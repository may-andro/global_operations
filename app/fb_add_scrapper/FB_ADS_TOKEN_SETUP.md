# Facebook Ads Scraper — API Access Setup

This document covers everything you need to get the app fully working, from the
basic `ads_read` token (for ad scraping) to the optional
`pages_read_engagement` permission (for advertiser contact details).

---

## Table of contents

1. [What you need](#1-what-you-need)
2. [Create a Facebook App](#2-create-a-facebook-app)
3. [Request Ads Library API Access](#3-request-ads-library-api-access)
4. [Generate an access token](#4-generate-an-access-token)
5. [Add the token to Firebase Remote Config](#5-add-the-token-to-firebase-remote-config)
6. [Unlock advertiser contact details (optional)](#6-unlock-advertiser-contact-details-optional)
7. [Token expiry & renewal](#7-token-expiry--renewal)
8. [Troubleshooting](#8-troubleshooting)

---

## 1. What you need

| Feature | Required permission / feature | Status |
|---|---|---|
| Search & scrape ads | `ads_read` | ✅ Basic — follow steps 2–5 |
| Advertiser contact details (phone, email, address, etc.) | `pages_read_engagement` **or** Page Public Metadata Access | 🔒 Requires app review — follow step 6 |

---

## 2. Create a Facebook App

1. Go to **[developers.facebook.com/apps](https://developers.facebook.com/apps)** and sign in.
2. Click **Create App**.
3. Choose **Other** → **Business** as the app type.
4. Fill in the app name (e.g. *Global Ops Ads Scraper*) and contact email.
5. Click **Create App**.

> **Business verification required** — If your app will go through app review
> (step 6), you must verify your business at
> [business.facebook.com/settings/security](https://business.facebook.com/settings/security)
> first.

---

## 3. Request Ads Library API Access

The Ads Library API requires a separate access request in addition to the
standard developer account.

1. Visit **[facebook.com/ads/library/api](https://www.facebook.com/ads/library/api/)**.
2. Click **Get Started** and sign in with the Facebook account that owns the
   developer app created in step 2.
3. Read and accept the Terms of Service.
4. Fill in the intended use form — describe that you are building an internal
   tool to monitor/research Facebook ad campaigns.
5. Submit and wait for approval *(usually a few hours to a few days)*.

You will receive an email confirmation when access is granted.

---

## 4. Generate an access token

### Option A — User access token (quickest, for testing)

1. Open the **[Graph API Explorer](https://developers.facebook.com/tools/explorer)**.
2. Select your app from the **Meta App** dropdown.
3. Click **Generate Access Token**.
4. In the permissions dialog check **`ads_read`** (and optionally
   `pages_read_engagement` if you have it).
5. Click **Generate Access Token** and copy the token.

> ⚠️ User tokens expire in **~60 days**. Use a System User token for
> production (see Option B).

### Option B — System User token (recommended for production)

1. Go to **[business.facebook.com](https://business.facebook.com)** → your
   Business Portfolio → **Settings** (gear icon) → **Users** → **System Users**.
2. Click **Add** → name it (e.g. *ads-scraper-bot*) → set role to **Employee**.
3. Click **Generate New Token** on the system user row.
4. Select your app from the dropdown.
5. Check **`ads_read`** (and `pages_read_engagement` if you have it).
6. Click **Generate Token** and copy the result.

> System User tokens **do not expire** unless manually revoked.

### Option C — Long-lived token (from a short-lived user token)

Exchange a short-lived token for a 60-day one via:

```
GET https://graph.facebook.com/v19.0/oauth/access_token
  ?grant_type=fb_exchange_token
  &client_id={app-id}
  &client_secret={app-secret}
  &fb_exchange_token={short-lived-token}
```

You can find `app-id` and `app-secret` in your app dashboard under
**App Settings → Basic**.

---

## 5. Add the token to Firebase Remote Config

The app reads the access token from Firebase Remote Config under the key
`fb_ads_access_token`. This avoids hardcoding secrets in source code.

1. Open the [Firebase console](https://console.firebase.google.com) → your
   project → **Remote Config**.
2. Click **Add parameter**.
3. Set:
   - **Parameter key**: `fb_ads_access_token`
   - **Default value**: *(paste your access token)*
4. Click **Save** → **Publish changes**.
5. Restart the app — it will pick up the token automatically.

> For different environments (dev/staging/prod), use Remote Config
> **Conditions** to serve different tokens per environment.

---

## 6. Unlock advertiser contact details (optional)

Fields like `about`, `emails`, `phone`, `location`, `fan_count`, `website`,
and `verification_status` on a Facebook Page require additional permissions
**beyond** `ads_read`.

### Option A — `pages_read_engagement` permission

Best when users log in with their own Facebook account.

1. In your app dashboard → **App Review → Permissions and Features**.
2. Search for **`pages_read_engagement`** → click **Request**.
3. Complete the required review items:
   - App icon, privacy policy URL, and terms of service URL.
   - A **screencast video** showing how advertiser info is displayed in the app.
   - A written description of why you need the permission.
4. Submit for review *(typically 5–10 business days)*.
5. Once approved, update the OAuth scope to include `pages_read_engagement`:
   ```
   https://www.facebook.com/dialog/oauth
     ?client_id={app-id}
     &redirect_uri={redirect-uri}
     &scope=ads_read,pages_read_engagement
   ```
   Or regenerate the System User token with the new permission checked.

### Option B — Page Public Metadata Access feature

Best for System User / server-side tokens — no per-user OAuth flow needed.

1. In your app dashboard → **App Review → Features**.
2. Request **Page Public Metadata Access**.
3. Provide a business verification and use-case description.
4. Once approved, your existing `ads_read` token will automatically gain
   access to public page metadata — **no token regeneration needed**.

### Re-enable the API call in the app

After either option is approved, the `getPageInfo` method in
`FbAdsApiDataSource` already has the full implementation ready — it will work
automatically as long as the token includes the required permission.

The `AdDetailBloc` and `GetPageInfoUseCase` are already registered in the DI
container and wired to the detail screen. No further code changes are needed.

---

## 7. Token expiry & renewal

| Token type | Expiry | Renewal |
|---|---|---|
| Short-lived user token | ~1–2 hours | Re-generate in Graph API Explorer |
| Long-lived user token | 60 days | Exchange via `/oauth/access_token` before expiry |
| System User token | Never (until revoked) | Re-generate in Business Manager |
| Page Access Token | Same as the user token used to generate it | Depends on source token |

When a token expires the app will return **401 Unauthorized** errors. Update
`fb_ads_access_token` in Firebase Remote Config with a fresh token.

---

## 8. Troubleshooting

| Error | Cause | Fix |
|---|---|---|
| `400 (#100) Missing permission` for `/ads_archive` | `ads_read` not on the token or Ads Library API access not approved | Complete steps 3 and 4 |
| `400 (#100) pages_read_engagement` error for `/{page_id}` | Advertiser details endpoint needs extra permission | Complete step 6 |
| `401 Invalid OAuth access token` | Token expired | Regenerate and update Remote Config |
| `400 (#4) Application request limit reached` | Too many calls per hour | Reduce polling frequency; use cursor-based pagination |
| Token works in Graph API Explorer but not in the app | Token not saved in Remote Config, or Remote Config not fetched yet | Publish changes in Remote Config and force-refresh |
