import {executeSnowflakeQuery} from "../util/snowflake_util";
import {getYearMonthWeek} from "../util/date_util";
import {createCollection} from "../util/firebase_util";

export const COLLECTION_PREFIX = "snowflake_record_";

/**
 * Core task function:
 * - Connects to Snowflake
 * - Runs the SELECT query
 * - Saves data in batches to Firestore under "snowflake_record_YYYY-MM-Www"
 * - Returns count of records saved
 */
export async function importSnowflakeToFirestoreTask(): Promise<number> {
  try {
    const query = "SELECT * FROM app.vw_actual_object_campaigns";
    const rows = await executeSnowflakeQuery(query);
    console.log(`📁 Found ${rows.length} rows in snowflake`);

    if (!Array.isArray(rows)) {
      throw new Error("Snowflake returned non-array data");
    }

    if (rows.length === 0) {
      console.warn("⚠️ No records returned from Snowflake");
      return 0;
    }

    const collectionId = getYearMonthWeek(new Date());
    const collectionName = `${COLLECTION_PREFIX}${collectionId}`;
    const documentIdField = "KEY";

    console.log(
      `📁 Preparing to write ${rows.length} rows to 
      Firestore collection: ${collectionName}`
    );

    await createCollection(collectionName, documentIdField, rows);

    console.log(
      `🎉 Import successful: ${rows.length} records 
      written to ${collectionName}`
    );

    return rows.length;
  } catch (error) {
    console.error(
      "❌ Failed to import data from Snowflake to Firestore:",
      error,
    );
    throw error instanceof Error ?
      error :
      new Error("Unknown error during import");
  }
}
