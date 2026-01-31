import * as admin from "firebase-admin";
import { COLLECTIONS } from "./collections";
import { Path, PathLocation, getConnectingPaths } from "./pathManager";
import { UserPath } from "./userPathManager";

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
      .get();

    let totalStatus = 0;
    let count = 0;

    userPathsSnapshot.forEach((userPathDoc) => {
      const userPath = {
        ...userPathDoc.data(),
        id: userPathDoc.id,
      } as Omit<UserPath, "path"> & { pathId: string };

      if (userPath.status) {
        totalStatus += userPath.status;
        count++;
      }
    });

    // Simple average for now
    const avgStatus = count > 0 ?
      Math.round(totalStatus / count) : 0;

    communityPaths.push({
      id: path.id,
      path: {
        id: path.id,
        locations: path.locations,
      },
      status: avgStatus,
    });
  }

  return communityPaths;
}
