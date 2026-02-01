import * as admin from "firebase-admin";
import { COLLECTIONS } from "./constants";
import { Path, PathLocation, getConnectingPaths } from "./pathManager";
import { UserPath } from "./userPathManager";
import { Timestamp } from "firebase-admin/firestore";

export interface CommunityPath {
  id: string;
  path: Path; // The geometry/location data
  status: number; // Calculated from linked UserPaths
}

/**
 * Retrieves community paths based on origin and destination.
 * @param {PathLocation} origin - The origin coordinate.
 * @param {PathLocation} destination - The destination coordinate.
 * @return {Promise<CommunityPath[]>} The list of community paths.
 */
export async function getCommunityPaths(
  origin: PathLocation,
  destination: PathLocation
): Promise<CommunityPath[]> {
  const radiusInM = 5000; // 5km radius search

  const paths = await getConnectingPaths(origin, destination, radiusInM);

  const communityPaths: CommunityPath[] = [];

  for (const path of paths) {
    // Calculate status from UserPaths
    const userPathsSnapshot = await admin.firestore()
      .collection(COLLECTIONS.USER_PATHS)
      .where("pathId", "==", path.id)
      .where("isPublic", "==", true)
      .get();

    if (userPathsSnapshot.empty) {
      continue;
    }

    const userPaths = userPathsSnapshot.docs.map((userPathDoc) => ({
      ...userPathDoc.data(),
      id: userPathDoc.id,
    } as Omit<UserPath, "path" | "date"> & {
      pathId: string;
      date: Timestamp;
    }));

    const status = calculateCommunityPathStatus(userPaths);

    communityPaths.push({
      id: path.id,
      path: {
        id: path.id,
        locations: path.locations,
      },
      status: status,
    });
  }


  // Sort paths based on status (descending)
  communityPaths.sort((a, b) => b.status - a.status);

  return communityPaths;
}

/**
 * Calculates the aggregate status of a path based on user reports.
 * Uses a voting system weighted by freshness.
 * @param {any[]} userPaths - List of user paths/reviews
 * @return {number} The calculated status (1-5) or 0 if no data
 */
export function calculateCommunityPathStatus(
  userPaths: (Omit<UserPath, "path" | "date"> & {
    pathId: string;
    date: Timestamp;
  })[]
): number {
  // Filter valid statuses and timestamps
  const validReports = userPaths
    .filter((up) => up.status && up.date)
    .map((up) => ({
      status: up.status,
      date: up.date.toDate(),
    }));

  if (validReports.length === 0) return 0;

  // Find the most recent date
  const latestDate = validReports.reduce((max, current) =>
    current.date > max ? current.date : max, validReports[0].date);

  // Filter reports within the freshness window (1 year)
  const FRESHNESS_WINDOW_MS = 365 * 24 * 60 * 60 * 1000;
  const recentReports = validReports.filter((r) =>
    (latestDate.getTime() - r.date.getTime()) <= FRESHNESS_WINDOW_MS
  );

  // Count votes
  const voteCounts: Record<number, number> = { 1: 0, 2: 0, 3: 0, 4: 0, 5: 0 };
  let maxVotes = 0;

  for (const report of recentReports) {
    voteCounts[report.status] = (voteCounts[report.status] || 0) + 1;
    if (voteCounts[report.status] > maxVotes) {
      maxVotes = voteCounts[report.status];
    }
  }

  // Find winners (statuses with maxVotes)
  const winners: number[] = [];
  for (let s = 1; s <= 5; s++) {
    if (voteCounts[s] === maxVotes) {
      winners.push(s);
    }
  }

  // If single winner, return it. If tie, average them.
  if (winners.length === 1) {
    return winners[0];
  }

  const sum = winners.reduce((a, b) => a + b, 0);
  return Math.round(sum / winners.length);
}
