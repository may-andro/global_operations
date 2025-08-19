import * as admin from "firebase-admin";
import {GeoPoint} from "firebase-admin/firestore";
import * as geofire from "geofire-common";

const firestore = admin.firestore();
export const BATCH_SIZE = 500;

/**
 * Delete all documents in a Firestore collection in batches.
 * Firestore doesn't support direct collection deletion, so we do it manually.
 *
 * @param {string} collectionName - Firestore collection name.
 * @return {void}
 */
export async function deleteCollectionRecursive(
  collectionName: string
): Promise<void> {
  const collectionRef = firestore.collection(collectionName);
  const query = collectionRef.limit(BATCH_SIZE);

  let snapshot;
  do {
    snapshot = await query.get();
    if (snapshot.empty) break;

    const batch = firestore.batch();
    snapshot.docs.forEach((doc) => batch.delete(doc.ref));
    await batch.commit();

    console.log(`🧹 Deleted ${snapshot.size} documents from ${collectionName}`);
  } while (!snapshot.empty);

  console.log(`🧼 Fully deleted collection: ${collectionName}`);
}

/**
 * Inserts documents into a Firestore collection in batches of 500.
 * Each document uses the value of a specified field as its document ID.
 *
 * @param {string} collectionName - Firestore collection name.
 * @param {string} documentIdField - Document ID.
 * @param {Record<string, unknown>} rows - The array of records to insert.
 */
export async function createCollection(
  collectionName: string,
  documentIdField: string,
  rows: Record<string, unknown>[],
): Promise<void> {
  const collectionRef = firestore.collection(collectionName);

  console.log(
    `📦 Retrieved ${rows.length} records. 
      Writing to collection: ${collectionName}`
  );

  for (let i = 0; i < rows.length; i += BATCH_SIZE) {
    const batch = firestore.batch();
    const slice = rows.slice(i, i + BATCH_SIZE);

    slice.forEach((row, idx) => {
      const docId = row[documentIdField];
      if (!docId) {
        console.warn(
          `⚠️ Row at index ${i + idx} missing ${documentIdField}. Skipping.`
        );
        return;
      }

      // ✅ Add GeoPoint if latitude and longitude exist
      const latitude = Number(row["LATITUDE"]);
      const longitude = Number(row["LONGITUDE"]);
      if (!isNaN(latitude) && !isNaN(longitude)) {
        // row["location"] = new GeoPoint(latitude, longitude);
        const geohash = geofire.geohashForLocation([latitude, longitude]);

        row["geo"] = {
          geohash,
          geopoint: new GeoPoint(latitude, longitude),
        };
      } else {
        console.warn(`⚠️ Row at index ${i + idx}
         missing valid LATITUDE/LONGITUDE. Skipping location field.`
        );
        return;
      }

      const docRef = collectionRef.doc(
        String(docId)
      );
      batch.set(docRef, {...row});
    });

    await batch.commit();
    console.log(
      `✅ Committed batch 
        ${Math.floor(i / BATCH_SIZE) + 1} (${slice.length} records)`
    );
  }
}

/**
 * Returns collections matching the `snowflake_record_YYYY-MM-Www` pattern
 * that are older than the provided cutoff date.
 *
 * @param {Date} cutoffDate - Collections older than this date will be returned
 * @return {Promise<FirebaseFirestore.CollectionReference[]>} - List of
 * expired collection references
 */
export async function getExpiredSnowflakeCollections(
  cutoffDate: Date
): Promise<FirebaseFirestore.CollectionReference[]> {
  try {
    const collections = await firestore.listCollections();
    const expiredCollections: FirebaseFirestore.CollectionReference[] = [];

    for (const collection of collections) {
      const match =
        /^snowflake_record_(\d{4})-(\d{2})-W(\d{2})$/.exec(collection.id);
      if (!match) continue;

      const [, yearStr, , weekStr] = match;

      const year = Number(yearStr);
      const week = Number(weekStr);

      if (isNaN(year) || isNaN(week)) {
        console.warn(`⚠️ Skipping malformed collection ID: ${collection.id}`);
        continue;
      }

      // Approximate ISO week start date
      const janFirst = new Date(Date.UTC(year, 0, 1));
      const weekStart = new Date(janFirst);
      weekStart.setUTCDate(janFirst.getUTCDate() + (week - 1) * 7);

      if (weekStart < cutoffDate) {
        expiredCollections.push(collection);
      }
    }

    console.log(`📁 Found ${expiredCollections.length} expired collections.`);
    return expiredCollections;
  } catch (err) {
    console.error("❌ Failed to list Firestore collections:", err);
    throw new Error("Failed to retrieve expired Firestore collections");
  }
}
