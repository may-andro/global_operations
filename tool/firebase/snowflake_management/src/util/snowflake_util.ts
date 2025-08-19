import * as snowflake from "snowflake-sdk";

// Define secrets
import {defineSecret} from "firebase-functions/params";
const SF_ACCOUNT = defineSecret("SF_ACCOUNT");
const SF_USERNAME = defineSecret("SF_USERNAME");
const SF_PASSWORD = defineSecret("SF_PASSWORD");
const SF_WAREHOUSE = defineSecret("SF_WAREHOUSE");
const SF_DATABASE = defineSecret("SF_DATABASE");
const SF_SCHEMA = defineSecret("SF_SCHEMA");

/**
 * Establishes a connection to Snowflake.
 *
 * @param {snowflake.Connection} connection - The Snowflake connection object
 * @return {Promise<void>} - Resolves when the connection is established.
 * @throws {Error} - If the connection fails.
 *
 * @example
 * const conn = createSnowflakeConnection();
 * await connectToSnowflake(conn);
 */
const connectToSnowflake =
  (connection: snowflake.Connection): Promise<void> => {
    return new Promise((resolve, reject) => {
      connection.connect((err) => {
        if (err) {
          reject(err);
        } else {
          resolve();
        }
      });
    });
  };

/**
 * Executes a SQL query against an established Snowflake connection.
 *
 * @param {string} sqlQuery - The SQL query to execute.
 * @return {Promise<Record<string, unknown>[]>} - Array of row objects,
 * @throws {Error} - If the query execution fails.
 *
 * @example
 * const rows = await executeSnowflakeQuery(connection, "SELECT * FROM users");
 */
export async function executeSnowflakeQuery(
  sqlQuery: string
): Promise<Record<string, unknown>[]> {
  const connection = snowflake.createConnection({
    account: SF_ACCOUNT.value(),
    username: SF_USERNAME.value(),
    password: SF_PASSWORD.value(),
    warehouse: SF_WAREHOUSE.value(),
    database: SF_DATABASE.value(),
    schema: SF_SCHEMA.value(),
  });

  let connected = false;

  try {
    console.log("🔌 Connecting to Snowflake...");
    await Promise.race([
      connectToSnowflake(connection),
      new Promise<void>((_, reject) =>
        setTimeout(() => reject(new Error("⏱️ Connection timeout.")), 10000)
      ),
    ]);
    connected = true;
    console.log("✅ Connected to Snowflake");

    if (!sqlQuery) {
      throw new Error("❗ Invalid SQL query provided");
    }

    return await new Promise((resolve, reject) => {
      connection.execute({
        sqlText: sqlQuery,
        complete: (err, _stmt, rows) => {
          if (err) {
            console.error("❌ Snowflake query failed:", err);
            reject(new Error("Snowflake query execution failed"));
          } else {
            const result = rows ?? [];
            console.log(`📥 Query succeeded: ${result.length} rows fetched`);
            resolve(result);
          }
        },
      });
    });
  } catch (err) {
    console.error("❌ Error executing Snowflake query:", err);
    throw err instanceof Error ? err : new Error("Unknown error occurred");
  } finally {
    if (connected) {
      connection.destroy((err) => {
        if (err) {
          console.warn("⚠️ Failed to close Snowflake connection:", err);
        } else {
          console.log("🔌 Disconnected from Snowflake");
        }
      });
    }
  }
}

