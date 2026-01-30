import * as admin from "firebase-admin";
import { COLLECTIONS } from "./collections";
import { Path, PathLocation } from "./pathManager";
import { distance } from "./pathManager";

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
  const range = 0.05; // ~5km radius search? Or smaller?
  // Let's use a reasonably large area for "nearby" paths

  const snapshot = await admin.firestore().collection(COLLECTIONS.PATHS)
    .where("startLatitude", ">=", origin.latitude - range)
    .where("startLatitude", "<=", origin.latitude + range)
    .get();

  const results: CommunityPath[] = [];

  for (const doc of snapshot.docs) {
    const path = doc.data() as Path;

    // Filter by similarity to requested origin/dest loosely?
    // Or just return all paths that start near origin and end near destination?
    // Requirement says: "Query the Path collection for paths matching the
    // origin and destination."

    const startDist = distance(origin,
      { latitude: path.startLatitude, longitude: path.startLongitude });
    const endDist = distance(destination,
      { latitude: path.endLatitude, longitude: path.endLongitude });

    const PROXIMITY_THRESHOLD = 500; // meters

    if (startDist < PROXIMITY_THRESHOLD && endDist < PROXIMITY_THRESHOLD) {
      // Calculate status from UserPaths
      const userPathsSnapshot = await admin.firestore()
        .collection(COLLECTIONS.USER_PATHS)
        .where("pathId", "==", doc.id)
        .get();

      let totalStatus = 0;
      let count = 0;

      userPathsSnapshot.forEach((userPathDoc) => {
        const up = userPathDoc.data();
        if (up.status) {
          totalStatus += up.status;
          count++;
        }
      });

      // Simple average for now
      const avgStatus = count > 0 ?
        Math.round(totalStatus / count) : 0;

      results.push({
        id: doc.id,
        path: path,
        status: avgStatus,
      });
    }
  }

  return results;
}
