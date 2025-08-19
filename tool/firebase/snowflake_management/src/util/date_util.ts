/**
 * Returns a string in the format YYYY-MM-WW (e.g. "2025-07-W30")
 * for the given date, where MM is the original month
 * and WW is the ISO week number.
 *
 * @param {Date} date - The date to format.
 * @return {string} The formatted string.
 */
export function getYearMonthWeek(date: Date): string {
  const d = new Date(
    Date.UTC(
      date.getFullYear(),
      date.getMonth(),
      date.getDate(),
    ),
  );
  const dayNum = d.getUTCDay() || 7;
  d.setUTCDate(d.getUTCDate() + 4 - dayNum); // ISO week starts on Monday
  const yearStart = new Date(Date.UTC(d.getUTCFullYear(), 0, 1));
  const weekNo = Math.ceil((((+d - +yearStart) / 86400000) + 1) / 7);
  const month = String(
    date.getMonth() + 1).padStart(2, "0",
  ); // Original date’s month
  return `${d.getUTCFullYear()}-${month}-W${String(weekNo).padStart(2, "0")}`;
}
