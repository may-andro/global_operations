import {
  deleteCollectionRecursive,
  getExpiredSnowflakeCollections,
} from "../util/firebase_util";

const DAYS_TO_KEEP = 30;

/**
 * Deletes collections matching the `snowflake_record_YYYY-MM-Www` pattern
 * that are older than the configured threshold (`DAYS_TO_KEEP`).
 *
 * @return {Promise<number>} - Number of collections successfully processed.
 */
export async function deleteOldSnowflakeCollectionsTask(): Promise<number> {
  const now = new Date();
  const cutoff = new Date();
  cutoff.setDate(now.getDate() - DAYS_TO_KEEP);

  console.log("🧹 Starting Snowflake collection cleanup");
  console.log("📅 Cutoff date for deletion:", cutoff.toISOString());

  let expiredCollections: FirebaseFirestore.CollectionReference[];

  try {
    expiredCollections = await getExpiredSnowflakeCollections(cutoff);
  } catch (err) {
    console.error("❌ Failed to retrieve expired collections:", err);
    throw new Error("Cleanup aborted due to collection retrieval failure.");
  }

  if (expiredCollections.length === 0) {
    console.log("📭 No collections to delete. Cleanup finished.");
    return 0;
  }

  console.log(
    `📁 Found ${expiredCollections.length} collection(s)
     older than ${DAYS_TO_KEEP} day(s)`
  );

  let deletedCount = 0;

  for (const collection of expiredCollections) {
    try {
      console.log(`🗑️ Deleting collection: ${collection.id}`);
      await deleteCollectionRecursive(collection.path);
      deletedCount++;
    } catch (err) {
      console.warn(`⚠️ Failed to delete collection "${collection.id}":`, err);
    }
  }

  console.log(`✅ Cleanup complete. Deleted ${deletedCount} collection(s).`);
  return deletedCount;
}
