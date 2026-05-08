import * as admin from "firebase-admin";
import {onCall, HttpsError} from "firebase-functions/v2/https";
import {defineSecret} from "firebase-functions/params";
import {logger} from "firebase-functions";
import axios from "axios";

admin.initializeApp();

const fbAdsToken = defineSecret("FB_ADS_ACCESS_TOKEN");

// ---------------------------------------------------------------------------
// Graph API client
// ---------------------------------------------------------------------------

const GRAPH_BASE = "https://graph.facebook.com/v22.0";

function graphClient(accessToken: string) {
  return axios.create({
    baseURL: GRAPH_BASE,
    timeout: 30_000,
    params: {access_token: accessToken},
  });
}

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

interface SearchAdsRequest {
  searchTerms?: string;
  adType?: string;
}

interface SearchAdsResponse {
  termId: string;
}

interface GetPageInfoRequest {
  pageId: string;
}

const BASE_AD_FIELDS = [
  "id",
  "page_id",
  "page_name",
  "ad_creation_time",
  "ad_delivery_start_time",
  "ad_delivery_stop_time",
  "ad_creative_bodies",
  "ad_creative_link_titles",
  "ad_creative_link_captions",
  "ad_creative_link_descriptions",
  "ad_creative_link_urls",
  "ad_creative_link_call_to_action",
  "ad_snapshot_url",
  "ad_creative_link_images",
  "bylines",
  "languages",
  "publisher_platforms",
  "target_ages",
  "target_gender",
  "target_locations",
  "eu_total_reach",
  "br_total_reach",
  "total_reach_by_location",
  "age_country_gender_reach_breakdown",
  "beneficiary_payers",
  "estimated_audience_size",
];

const POLITICAL_FIELDS = [
  "currency",
  "impressions",
  "spend",
  "demographic_distribution",
  "delivery_by_region",
];

const PAGE_INFO_FIELDS = [
  "id",
  "name",
  "link",
  "category",
  "website",
  "about",
  "description",
  "emails",
  "phone",
  "location",
  "fan_count",
  "verification_status",
  "founded",
];

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/**
 * Converts a search term into a Firestore-safe document ID.
 * e.g. "Nike Shoes" → "nike_shoes"
 */
function slugify(term: string): string {
  return term
    .toLowerCase()
    .trim()
    .replace(/\s+/g, "_")
    .replace(/[^a-z0-9_]/g, "");
}

/**
 * Replaces the token-bearing ad_snapshot_url with the public Ads Library URL.
 */
function sanitizeAd(ad: Record<string, unknown>): Record<string, unknown> {
  const sanitized = {...ad};
  const adId = sanitized["id"];
  if (typeof adId === "string" && adId) {
    sanitized["ad_snapshot_url"] = `https://www.facebook.com/ads/library/?id=${adId}`;
  } else {
    delete sanitized["ad_snapshot_url"];
  }
  return sanitized;
}

function getNumber(value: unknown): number {
  if (typeof value === "number") return value;

  if (typeof value === "string") {
    const parsed = parseInt(value.replace(/[^\d]/g, ""), 10);
    return Number.isNaN(parsed) ? 0 : parsed;
  }

  return 0;
}

function getTimestamp(value: unknown): number {
  if (typeof value !== "string") return 0;

  const ts = Date.parse(value);
  return Number.isNaN(ts) ? 0 : ts;
}

/**
 * Creates a ranking score similar to "top impressions".
 */
function computeRankScore(ad: Record<string, unknown>): number {
  const euReach = getNumber(ad["eu_total_reach"]);
  const estimatedAudience = getNumber(ad["estimated_audience_size"]);
  const createdAt = getTimestamp(ad["ad_creation_time"]);

  // Recency boost (newer ads rank slightly higher)
  const ageDays = Math.max(
    1,
    (Date.now() - createdAt) / (1000 * 60 * 60 * 24)
  );

  const recencyBoost = 1 / ageDays;

  return (
    euReach * 10 +
    estimatedAudience * 2 +
    recencyBoost * 1000
  );
}

// ---------------------------------------------------------------------------
// Cloud Function: searchAds  (fire-and-forget scraper)
// Called from Flutter via FbFunctionController.callFunction("searchAds")
// ---------------------------------------------------------------------------

export const searchAds = onCall<SearchAdsRequest>(
  {
    region: "europe-west3",
    timeoutSeconds: 300,
    memory: "512MiB",
    secrets: ["FB_ADS_ACCESS_TOKEN"],
  },
  async (request): Promise<SearchAdsResponse> => {
    const {searchTerms = "", adType = "ALL"} = request.data ?? {};

    if (!searchTerms.trim()) {
      throw new HttpsError("invalid-argument", "searchTerms is required.");
    }

    const token = fbAdsToken.value();
    if (!token) {
      throw new HttpsError("failed-precondition", "FB_ADS_ACCESS_TOKEN secret is not set.");
    }

    const termId = slugify(searchTerms);
    if (!termId) {
      throw new HttpsError("invalid-argument", "searchTerms produced an empty termId after slugifying.");
    }

    const db = admin.firestore();
    const termRef = db.collection("search_terms").doc(termId);

    // Write "loading" status immediately so the Flutter stream reacts at once.
    await termRef.set(
      {
        term: searchTerms.trim(),
        adType,
        status: "loading",
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        lastFetchedAt: null,
        totalCount: 0,
        errorMessage: null,
      },
      {merge: true}
    );

    logger.info(`searchAds → termId="${termId}" adType=${adType}`);

    const fields = adType === "POLITICAL_AND_ISSUE_ADS"
      ? [...BASE_AD_FIELDS, ...POLITICAL_FIELDS]
      : BASE_AD_FIELDS;

    const PER_PAGE = 200;
    const MAX_PAGES = 5;

    let cursor: string | null = null;

    // Keyed by page_id (falls back to ad archive id) — last-write-wins per
    // advertiser, favouring the most recent ad_creation_time.
    const advertiserMap = new Map<
      string,
      {
        bestAd: Record<string, unknown>;
        score: number;
        adCount: number;
      }
    >();

    try {
      const client = graphClient(token);

      for (let page = 0; page < MAX_PAGES; page++) {
        const params: Record<string, unknown> = {
          ad_type: adType,
          ad_active_status: "ACTIVE",   // active ads only — skips stopped/inactive
          fields: fields.join(","),
          limit: PER_PAGE,
          "ad_reached_countries[0]": "NL",
          search_terms: `"${searchTerms.trim()}"`,
          ...(cursor ? {after: cursor} : {}),
        };

        const resp = await client.get<Record<string, unknown>>("/ads_archive", {params});
        const data = resp.data ?? {};
        const ads = (data["data"] as Record<string, unknown>[]) ?? [];
        const paging = (data["paging"] as Record<string, unknown>) ?? {};
        const cursors = (paging["cursors"] as Record<string, unknown>) ?? {};
        cursor = (cursors["after"] as string | undefined) ?? null;
        const hasNextPage = Boolean(paging["next"]);

        logger.info(`  page ${page + 1}: ${ads.length} ads, hasNextPage=${hasNextPage}`);

        const scrapedAt = new Date().toISOString();
        for (const ad of ads) {
          const sanitized = sanitizeAd(ad);
          // Use page_id as the dedup key; fall back to ad archive id.
          const pageId = (sanitized["page_id"] as string | undefined) ?? "";
          const adId = (sanitized["id"] as string | undefined) ?? "";
          const key = pageId || adId;
          if (!key) continue;

          sanitized["scraped_at"] = scrapedAt;

          const score = computeRankScore(sanitized);
          const existing = advertiserMap.get(key);
          if (!existing) {
            advertiserMap.set(key, {
              bestAd: sanitized,
              score,
              adCount: 1,
            });
          } else {
            existing.adCount += 1;
            // Keep higher-ranked ad
            if (score > existing.score) {
              existing.bestAd = sanitized;
              existing.score = score;
            }
            existing.score = Math.max(existing.score, score);
            advertiserMap.set(key, existing);
          }
        }

        if (!hasNextPage || !cursor) break;
      }

      // Write one document per unique advertiser (keyed by page_id).
      // Using page_id as the Firestore doc key is itself a dedup mechanism —
      // a plain set() would also deduplicate, but the Map approach lets us
      // control *which* ad wins (most recent), regardless of API return order.
      const uniqueAds = Array.from(advertiserMap.entries())
        .map(([key, value]) => {
          const bestAd = value.bestAd;

          return {
            key,
            data: {
              ...bestAd,
              advertiser_id: key,
              rank_score: value.score,
              total_ads_found: value.adCount,
              latest_ad_time:
                bestAd["ad_creation_time"] ?? null,
              scraped_at: new Date().toISOString(),
            },
          };
        })
        .sort((a, b) => {
          const scoreA = getNumber(a.data.rank_score);
          const scoreB = getNumber(b.data.rank_score);
          return scoreB - scoreA;
        });
      logger.info(`  unique advertisers: ${uniqueAds.length}`);

      // Delete ads from any previous scrape of this term so stale advertisers
      // that are no longer active don't remain in the collection.
      const existingSnap = await termRef.collection("ads").listDocuments();
      const newKeys = new Set(uniqueAds.map((item) => item.key));
      const staleRefs = existingSnap.filter((ref) => !newKeys.has(ref.id));
      if (staleRefs.length > 0) {
        logger.info(`  removing ${staleRefs.length} stale advertiser(s)`);
        const BATCH_SIZE = 500;
        for (let i = 0; i < staleRefs.length; i += BATCH_SIZE) {
          const deleteBatch = db.batch();
          for (const ref of staleRefs.slice(i, i + BATCH_SIZE)) {
            deleteBatch.delete(ref);
          }
          await deleteBatch.commit();
        }
      }

      const BATCH_SIZE = 500;
      for (let i = 0; i < uniqueAds.length; i += BATCH_SIZE) {
        const batch = db.batch();
        for (const item of uniqueAds.slice(i, i + BATCH_SIZE)) {
          const adRef = termRef.collection("ads").doc(item.key);
          batch.set(adRef, item.data, {merge: true});
        }
        await batch.commit();
      }

      const totalWritten = uniqueAds.length;

      // Mark done.
      await termRef.update({
        status: "done",
        totalCount: totalWritten,
        lastFetchedAt: admin.firestore.FieldValue.serverTimestamp(),
        errorMessage: null,
      });

      logger.info(`✅ searchAds done → termId="${termId}" uniqueAdvertisers=${totalWritten}`);
      return {termId};
    } catch (err) {
      logger.error(`❌ searchAds failed for termId="${termId}":`, err);
      await termRef.update({
        status: "error",
        errorMessage: err instanceof Error ? err.message : "Unknown error",
      }).catch(() => {/* best-effort */});
      throw new HttpsError(
        "internal",
        err instanceof Error ? err.message : "Scrape failed"
      );
    }
  }
);

// ---------------------------------------------------------------------------
// Cloud Function: getPageInfo
// Called from Flutter via FbFunctionController.callFunction("getPageInfo")
// ---------------------------------------------------------------------------

export const getPageInfo = onCall<GetPageInfoRequest>(
  {
    region: "europe-west3",
    timeoutSeconds: 30,
    memory: "256MiB",
    secrets: ["FB_ADS_ACCESS_TOKEN"],
  },
  async (request): Promise<Record<string, unknown> | null> => {
    const {pageId} = request.data ?? {};

    if (!pageId) {
      throw new HttpsError("invalid-argument", "pageId is required.");
    }

    const token = fbAdsToken.value();
    if (!token) {
      throw new HttpsError("failed-precondition", "FB_ADS_ACCESS_TOKEN secret is not set.");
    }

    logger.info(`getPageInfo → pageId=${pageId}`);

    try {
      const client = graphClient(token);
      const resp = await client.get<Record<string, unknown>>(`/${pageId}`, {
        params: {fields: PAGE_INFO_FIELDS.join(",")},
      });
      return resp.data ?? null;
    } catch (err) {
      logger.warn(`getPageInfo → no data for pageId=${pageId}:`, err instanceof Error ? err.message : err);
      // Safely log response data if available
      if (err && typeof err === "object" && "response" in err && err.response && typeof err.response === "object" && "data" in err.response) {
        logger.error("Meta Graph error", JSON.stringify((err as any).response.data, null, 2));
      } else {
        logger.error("Meta Graph error", err);
      }
      return null;
    }
  }
);
