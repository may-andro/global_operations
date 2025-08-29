# Purpose

CLI tool for importing and exporting data in the [Cloud Firestore](https://firebase.google.com/docs/firestore/).

# Usage

`dart run bin/firestore_export_import.dart import --collection snowflake_record_2025-08-W35 --secrets .data/service_account.json --output .data/import.json`

`dart run bin/firestore_export_import.dart export --collection snowflake_record_demo --secrets .data/service_account.json --path .data/export.json`

