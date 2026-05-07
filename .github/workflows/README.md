# CI/CD Workflows Guide

This folder contains reusable and app-specific GitHub Actions workflows for `global_ops` and `fb_add_scrapper`.

## Workflow Layout

### Reusable building blocks

- `_app_static_analyze_with_test.yaml` - reusable app analysis/test pipeline.
- `_build_and_distribute_web.yaml` - reusable Flutter web build + Firebase Hosting deploy.
- `_build_and_distribute_android.yaml` - reusable Android build + Firebase/App Distribution/Play Store upload.
- `_build_release_notes.yaml` - reusable release notes generator.
- `_layer_static_analyze_with_test.yaml` - reusable static analyze + test for layer packages.
- `_layer_static_analyze_with_golden_test.yaml` - reusable static analyze + golden test for layer packages.

### App entry workflows

- `global_ops_code_quality_validation.yaml`
- `global_ops_review_release.yaml`
- `global_ops_prod_release.yaml`
- `fb_add_scrapper_code_quality_validation.yaml`
- `fb_add_scrapper_review_release.yaml`
- `fb_add_scrapper_prod_release.yaml`

### Layer entry workflows

- `layer_cache_code_quality_validation.yaml`
- `layer_core_code_quality_validation.yaml`
- `layer_design_system_code_quality_validation.yaml`
- `layer_error_reporter_code_quality_validation.yaml`
- `layer_firebase_code_quality_validation.yaml`
- `layer_log_reporter_code_quality_validation.yaml`
- `layer_module_injector_code_quality_validation.yaml`
- `layer_remote_code_quality_validation.yaml`
- `layer_tracking_code_quality_validation.yaml`
- `layer_use_case_code_quality_validation.yaml`

These layer workflows call the reusable layer workflows above and run package-specific checks for shared workspace layers.

## Triggers

### Pull request validation

- `global_ops_code_quality_validation.yaml` runs on PRs that change `app/global_ops/**`.
- `fb_add_scrapper_code_quality_validation.yaml` runs on PRs that change `app/fb_add_scrapper/**`.

### Tag-based releases

- `global_ops` review release tag: `*-review`
- `global_ops` prod release tag: `*-prod`
- `fb_add_scrapper` review release tag: `*-fb_add_scrapper-review`
- `fb_add_scrapper` prod release tag: `*-fb_add_scrapper-prod`

## Required Secrets

### Shared secrets (used by both apps)

- `APP_CHECK_TOKEN_BASE64`

### global_ops secrets

- `FIREBASE_OPTIONS_BASE64`
- `FIREBASE_SERVICE_ACCOUNT`
- `FIREBASE_PROJECT_ID`
- `FIREBASE_JSON_BASE64`
- `FIREBASE_CONFIG_BASE64`
- `FIREBASE_ANDROID_APP_ID`
- `SIGNING_KEYSTORE_BASE64`
- `SIGNING_KEY_ALIAS`
- `SIGNING_KEY_PASSWORD`
- `SIGNING_STORE_PASSWORD`
- `PLAYSTORE_SERVICE_ACCOUNT`
- `GOOGLE_SERVICES_BASE64`
- `ANDROID_GOOGLE_MAP_KEY`

### fb_add_scrapper secrets

- `FB_ADD_SCRAPPER_FIREBASE_OPTIONS_BASE64`
- `FB_ADD_SCRAPPER_FIREBASE_SERVICE_ACCOUNT`
- `FB_ADD_SCRAPPER_FIREBASE_PROJECT_ID`
- `FB_ADD_SCRAPPER_FIREBASE_JSON_BASE64`
- `FB_ADD_SCRAPPER_FIREBASE_CONFIG_BASE64`
- `FB_ADD_SCRAPPER_FIREBASE_ANDROID_APP_ID`
- `FB_ADD_SCRAPPER_SIGNING_KEYSTORE_BASE64`
- `FB_ADD_SCRAPPER_SIGNING_KEY_ALIAS`
- `FB_ADD_SCRAPPER_SIGNING_KEY_PASSWORD`
- `FB_ADD_SCRAPPER_SIGNING_STORE_PASSWORD`
- `FB_ADD_SCRAPPER_PLAYSTORE_SERVICE_ACCOUNT`
- `FB_ADD_SCRAPPER_GOOGLE_SERVICES_BASE64`
- `FB_ADD_SCRAPPER_ANDROID_GOOGLE_MAP_KEY`

## Release Tag Examples

```bash
git tag v1.2.3+45-review
git push origin v1.2.3+45-review

git tag v1.2.3+45-prod
git push origin v1.2.3+45-prod

git tag v0.9.0+12-fb_add_scrapper-review
git push origin v0.9.0+12-fb_add_scrapper-review

git tag v0.9.0+12-fb_add_scrapper-prod
git push origin v0.9.0+12-fb_add_scrapper-prod
```

## Notes

- Reusable workflows are parameterized by `app_path` and app-specific secrets.
- Keep app Firebase files and base64 secrets aligned when app IDs/config change.

