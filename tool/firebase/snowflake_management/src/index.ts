import * as admin from "firebase-admin";
import {onRequest} from "firebase-functions/v2/https";
import {onSchedule} from "firebase-functions/v2/scheduler";
import {logger} from "firebase-functions";

admin.initializeApp();

import {importSnowflakeToFirestoreTask} from "./task/create_collection_task";
import {deleteOldSnowflakeCollectionsTask} from "./task/delete_collection_task";

/**
 * HTTP-triggered function
 * - Manually trigger via HTTP request or from app
 */
export const importSnowflakeDataToFirestore = onRequest(
  {
    region: "europe-west3",
    secrets: [
      "SF_ACCOUNT",
      "SF_USERNAME",
      "SF_PASSWORD",
      "SF_WAREHOUSE",
      "SF_DATABASE",
      "SF_SCHEMA",
    ],
    timeoutSeconds: 540,
  },
  async (_request, response) => {
    try {
      const count = await importSnowflakeToFirestoreTask();
      logger.info(`ℹ️ Found ${count} record.`);
      if (count === 0) {
        response.status(200).send({
          success: true,
          message: "No records to sync",
        });
      } else {
        response.status(200).send({
          success: true,
          count,
        });
      }
    } catch (error) {
      logger.error("❌ Import failed:", error);
      response.status(500).send({
        success: false,
        error: error instanceof Error ? error.message : "Unknown error",
      });
    }
  }
);

/**
 * Scheduled function
 * - Automatically runs every Monday at 2:00 AM Europe/Amsterdam
 */
export const scheduledImportSnowflakeDataToFirestore = onSchedule(
  {
    schedule: "0 2 * * 1", // At 02:00 every Monday
    secrets: [
      "SF_ACCOUNT",
      "SF_USERNAME",
      "SF_PASSWORD",
      "SF_WAREHOUSE",
      "SF_DATABASE",
      "SF_SCHEMA",
    ],
    timeZone: "Europe/Amsterdam",
    region: "europe-west3",
    timeoutSeconds: 540,
    memory: "512MiB",
  },
  async () => {
    logger.info("ℹ️Scheduled import started");
    try {
      const count = await importSnowflakeToFirestoreTask();
      logger.info(`✅ Scheduled import completed. ${count} records synced.`);
    } catch (error) {
      logger.error("❌ Scheduled import failed:", error);
    }
  }
);

/**
 * Scheduled function:
 * - Runs daily at 00:00 Europe/Amsterdam
 * - Calls the task function to delete old collections
 */
export const scheduledDeleteOldSnowflakeCollections = onSchedule(
  {
    schedule: "0 0 * * 0", // runs every sunday at midnight
    timeZone: "Europe/Amsterdam",
    region: "europe-west3",
    timeoutSeconds: 540,
    memory: "512MiB",
  },
  async () => {
    logger.info("Scheduled cleanup collections");
    try {
      const deletedCount = await deleteOldSnowflakeCollectionsTask();
      logger.info(`✅ Scheduled cleanup deleted ${deletedCount} collections.`);
    } catch (err) {
      logger.error("❌ Scheduled cleanup failed:", err);
    }
  }
);

/**
 * HTTP function:
 * - Can be triggered manually from an app, CLI, or browser
 * - Optional: add authentication for secure access
 */
export const deleteOldSnowflakeCollections = onRequest(
  {region: "europe-west3", timeoutSeconds: 540},
  async (_request, response) => {
    try {
      const deleted = await deleteOldSnowflakeCollectionsTask();
      response.status(200).send({
        success: true,
        deleted,
        message: `✅ Deleted ${deleted} old collections.`,
      });
    } catch (err) {
      logger.error("❌ Cleanup failed:", err);
      response.status(500).send({
        success: false,
        error: err instanceof Error ? err.message : "Unknown error",
      });
    }
  }
);
