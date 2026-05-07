import * as admin from "firebase-admin";
import {onCall, HttpsError} from "firebase-functions/v2/https";
import {logger} from "firebase-functions";
import axios from "axios";
import {wrapper} from "axios-cookiejar-support";
import {CookieJar} from "tough-cookie";

admin.initializeApp();

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

interface SearchAdsRequest {
  query: string;
  country?: string;
  adType?: string;
  offset?: number;
  count?: number;
}

interface FbAd {
  id: string;
  pageName?: string;
  pageId?: string;
  adCreativeBody?: string;
  adCreativeLinkTitle?: string;
  adCreativeLinkUrl?: string;
  adCreativeLinkCaption?: string;
  adSnapshotUrl?: string;
  adDeliveryStartTime?: string;
  adDeliveryStopTime?: string;
  publisherPlatforms?: string[];
  currency?: string;
  fundingEntity?: string;
}

interface SearchAdsResponse {
  ads: FbAd[];
  hasNextPage: boolean;
  totalCount: number;
  offset: number;
}

// ---------------------------------------------------------------------------
// Helper: build a cookie-aware axios client that looks like a browser
// ---------------------------------------------------------------------------

function buildClient() {
  const jar = new CookieJar();
  const client = wrapper(axios.create({
    jar,
    baseURL: "https://www.facebook.com",
    timeout: 20000,
    headers: {
      "User-Agent":
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) " +
        "AppleWebKit/537.36 (KHTML, like Gecko) " +
        "Chrome/124.0.0.0 Safari/537.36",
      "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
      "Accept-Language": "en-US,en;q=0.9",
      "Accept-Encoding": "gzip, deflate, br",
      "Connection": "keep-alive",
      "Upgrade-Insecure-Requests": "1",
    },
    maxRedirects: 5,
    withCredentials: true,
  }));
  return {client, jar};
}

// ---------------------------------------------------------------------------
// Helper: extract CSRF tokens from the Ads Library HTML page
// ---------------------------------------------------------------------------

async function fetchCsrfTokens(
  client: ReturnType<typeof buildClient>["client"]
): Promise<{dtsg: string; jazoest: string}> {
  const resp = await client.get<string>("/ads/library/", {
    headers: {
      "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
    },
  });
  const html: string = resp.data ?? "";

  // __dtsg token (CSRF)
  const dtsgMatch = html.match(/"DTSGInitData"[^}]*?"token":"([^"]+)"/);
  const dtsg = dtsgMatch?.[1] ?? "";

  // jazoest (another CSRF value)
  const jazoestMatch = html.match(/jazoest=(\d+)/);
  const jazoest = jazoestMatch?.[1] ?? "";

  // lsd (lightweight session data)
  const lsdMatch = html.match(/"LSD"[^}]*?"token":"([^"]+)"/);
  const lsd = lsdMatch?.[1] ?? "";

  logger.info(`Tokens → dtsg=${dtsg ? "✓" : "✗"} jazoest=${jazoest ? "✓" : "✗"} lsd=${lsd ? "✓" : "✗"}`);
  return {dtsg, jazoest};
}

// ---------------------------------------------------------------------------
// Helper: map raw FB response result to our FbAd shape
// ---------------------------------------------------------------------------

function mapResult(r: Record<string, unknown>): FbAd {
  const snapshot = (r["snapshot"] as Record<string, unknown>) ?? {};
  const cards = (snapshot["cards"] as unknown[]) ?? [];
  const firstCard = (cards[0] as Record<string, unknown>) ?? {};

  const body =
    (snapshot["body"] as Record<string, unknown>)?.["text"] as string |undefined ??
    firstCard["body"] as string | undefined;

  const title =
    snapshot["title"] as string | undefined ??
    firstCard["title"] as string | undefined;

  const linkUrl =
    snapshot["link_url"] as string | undefined ??
    firstCard["link_url"] as string | undefined;

  const linkCaption =
    snapshot["link_description"] as string | undefined ??
    firstCard["link_description"] as string | undefined;

  const rawPlatforms = r["publisherPlatform"] as unknown[] | undefined;
  const platforms = rawPlatforms?.map((p) => String(p));

  return {
    id: String(r["adArchiveID"] ?? r["ad_archive_id"] ?? r["id"] ?? ""),
    pageName: r["pageName"] as string | undefined ?? r["page_name"] as string | undefined,
    pageId: r["pageID"] != null ? String(r["pageID"]) : r["page_id"] as string | undefined,
    adCreativeBody: body,
    adCreativeLinkTitle: title,
    adCreativeLinkUrl: linkUrl,
    adCreativeLinkCaption: linkCaption,
    adSnapshotUrl: r["snapshot_url"] as string | undefined,
    adDeliveryStartTime: r["startDate"] != null ? String(r["startDate"]) : r["ad_delivery_start_time"] as string | undefined,
    adDeliveryStopTime: r["endDate"] != null ? String(r["endDate"]) : r["ad_delivery_stop_time"] as string | undefined,
    publisherPlatforms: platforms,
    currency: r["currency"] as string | undefined,
    fundingEntity: snapshot["page_name"] as string | undefined,
  };
}

// ---------------------------------------------------------------------------
// Cloud Function: searchFbAds
// Called from Flutter via FbFunctionController.callFunction("searchFbAds")
// ---------------------------------------------------------------------------

export const searchFbAds = onCall<SearchAdsRequest>(
  {
    region: "europe-west3",
    timeoutSeconds: 60,
    memory: "512MiB",
  },
  async (request): Promise<SearchAdsResponse> => {
    const {query = "", country = "US", adType = "all", offset = 0, count = 30} =
      request.data ?? {};

    logger.info(`🔍 searchFbAds → query="${query}" country=${country} offset=${offset}`);

    const {client} = buildClient();

    try {
      // 1. Warm up: hit the public library page to get cookies + CSRF tokens
      const {dtsg, jazoest} = await fetchCsrfTokens(client);

      // 2. Call the async search endpoint
      const params = new URLSearchParams({
        active_status: "all",
        ad_type: adType,
        "country[0]": country,
        q: query,
        search_type: "keyword_unordered",
        session_id: `${Date.now()}_search`,
        "start_date[min]": "",
        "start_date[max]": "",
        view_all_page_id: "",
        count: String(count),
        __a: "1",
        ...(dtsg ? {__dtsg: dtsg} : {}),
        ...(jazoest ? {jazoest} : {}),
        ...(offset > 0 ? {offset: String(offset)} : {}),
      });

      const searchResp = await client.get<string>(
        `/ads/library/async/search_ads/?${params.toString()}`,
        {
          headers: {
            "Referer": "https://www.facebook.com/ads/library/",
            "Accept": "*/*",
            "Sec-Fetch-Site": "same-origin",
            "Sec-Fetch-Mode": "cors",
            "X-Requested-With": "XMLHttpRequest",
          },
        }
      );

      let raw: string = searchResp.data ?? "";

      // FB prepends "for (;;);" to prevent JSON hijacking
      if (raw.startsWith("for (;;);")) {
        raw = raw.slice("for (;;);".length);
      }

      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      const decoded: Record<string, any> = JSON.parse(raw);

      const payload: Record<string, unknown> =
        decoded["payload"] ?? decoded["data"] ?? {};

      const results: unknown[] =
        (payload["results"] as unknown[]) ??
        (decoded["results"] as unknown[]) ??
        [];

      const totalCount: number =
        (payload["total_count"] as number) ?? results.length;

      const ads = results.map((r) => mapResult(r as Record<string, unknown>));

      logger.info(`✅ Found ${ads.length} ads (total: ${totalCount})`);

      return {
        ads,
        hasNextPage: offset + ads.length < totalCount,
        totalCount,
        offset,
      };
    } catch (err) {
      logger.error("❌ searchFbAds failed:", err);
      throw new HttpsError(
        "internal",
        err instanceof Error ? err.message : "Scraping failed"
      );
    }
  }
);

