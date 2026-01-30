import * as admin from "firebase-admin";
import { COLLECTIONS } from "./collections";
import { FieldValue, Timestamp } from "firebase-admin/firestore";
import { HttpsError } from "firebase-functions/v2/https";
import {
  Path,
  PathPerformance,
  PathWeather,
  findMatchingPath,
  createPath,
} from "./pathManager";

export interface UserPath {
  id: string;
  userId: string;
  date?: Timestamp;
  isPublic: boolean;
  path: Path;
  status: number;
  performance?: PathPerformance;
  weather?: PathWeather;
}

/**
 * Saves (creates or updates) a user path.
 * Matches: func savePath(_ path: UserPath) async throws
 * @param {UserPath} userPath - The user path including geometry
 * @return {Promise<void>}
 */
export async function saveUserPath(userPath: UserPath): Promise<void> {
  // Validate Status
  if (!Number.isInteger(userPath.status) ||
    userPath.status < 1 ||
    userPath.status > 5) {
    throw new HttpsError("invalid-argument",
      "Status must be an integer between 1 and 5");
  }

  // Ensure ID is present
  if (!userPath.id) {
    throw new HttpsError("invalid-argument", "Path ID is required");
  }

  const locations = userPath.path.locations;
  if (!locations || locations.length < 2) {
    throw new HttpsError("invalid-argument",
      "Path must have at least 2 coordinates");
  }

  // Deduplication / Path Creation
  let pathId = await findMatchingPath(locations);
  if (!pathId) {
    pathId = await createPath(locations);
  }

  const docRef = admin.firestore()
    .collection(COLLECTIONS.USER_PATHS)
    .doc(userPath.id);

  await docRef.set({
    userId: userPath.userId,
    ...(userPath.date && { date: userPath.date }),
    isPublic: userPath.isPublic,
    pathId: pathId,
    status: userPath.status,
    ...(userPath.performance && { performance: userPath.performance }),
    ...(userPath.weather && { weather: userPath.weather }),
  });
}

/**
 * Retrieves all paths for a specific user ID.
 * Matches: func getUserPaths(userID: User.ID) async throws
 * @param {string} targetUserId - The ID of the user whose paths to fetch
 * @param {string} requestingUserId - The ID of the user making the request
 * @return {Promise<UserPath[]>} List of user paths
 */
export async function getUserPaths(
  targetUserId: string,
  requestingUserId: string,
): Promise<UserPath[]> {
  const snapshot = await admin.firestore()
    .collection(COLLECTIONS.USER_PATHS)
    .where("userId", "==", targetUserId)
    .get();

  const paths: UserPath[] = [];

  for (const doc of snapshot.docs) {
    const data = doc.data() as Omit<UserPath, "path"> & { pathId: string };

    // Privacy Check
    // If getting own paths, return all.
    // If getting other's paths, return only isPublic == true.
    if (targetUserId !== requestingUserId && !data.isPublic) {
      continue;
    }

    // Fetch the linked Path geometry
    const pathId = data.pathId;
    let path: Path | null = null;

    if (pathId) {
      const pathDoc = await admin.firestore()
        .collection(COLLECTIONS.PATHS)
        .doc(pathId)
        .get();
      if (pathDoc.exists) {
        path = pathDoc.data() as Path;
      }
    }
    if (!path) {
      continue;
    }

    const userPath: UserPath = {
      id: doc.id,
      userId: data.userId,
      date: data.date,
      isPublic: data.isPublic,
      path: path,
      status: data.status,
      performance: data.performance,
      weather: data.weather,
    };
    paths.push(userPath);
  }

  return paths;
}

/**
 * Updates path privacy.
 * Matches: func updatePathPrivacy(id: UserPath, isPrivate: Bool) async throws
 * @param {string} userPathId - ID of the user path
 * @param {string} userId - Requesting user ID (owner)
 * @param {boolean} isPublic - The new privacy state
 */
export async function updateUserPathPrivacy(
  userPathId: string,
  userId: string,
  isPublic: boolean
) {
  const docRef = admin.firestore()
    .collection(COLLECTIONS.USER_PATHS)
    .doc(userPathId);
  const doc = await docRef.get();

  if (!doc.exists) throw new HttpsError("not-found", "Path not found");
  if (doc.data()?.userId !== userId) {
    throw new HttpsError("permission-denied",
      "The user is not authorized to update this path");
  }

  await docRef.update({
    isPublic: isPublic,
    updatedAt: FieldValue.serverTimestamp(),
  });
}

/**
 * Updates path status.
 * Matches: func updatePathStatus(id: UserPath, status: UserPath.Status)
 * async throws
 * @param {string} userPathId - ID of the user path
 * @param {string} userId - Requesting user ID (owner)
 * @param {number} status - The new status (1-5)
 */
export async function updateUserPathStatus(
  userPathId: string,
  userId: string,
  status: number
) {
  if (!Number.isInteger(status) || status < 1 || status > 5) {
    throw new HttpsError("invalid-argument",
      "Status must be an integer between 1 and 5");
  }

  const docRef = admin.firestore()
    .collection(COLLECTIONS.USER_PATHS)
    .doc(userPathId);
  const doc = await docRef.get();

  if (!doc.exists) throw new HttpsError("not-found", "Path not found");
  if (doc.data()?.userId !== userId) {
    throw new HttpsError("permission-denied",
      "The user is not authorized to update this path");
  }

  await docRef.update({
    status: status,
    updatedAt: FieldValue.serverTimestamp(),
  });
}

/**
 * Deletes a path.
 * Matches: func deletePath(id: UserPath) async throws
 * @param {string} userPathId - The ID of the path to delete
 * @param {string} userId - The ID of the requesting user
 * @return {Promise<void>}
 */
export async function deleteUserPath(userPathId: string, userId: string) {
  const docRef = admin.firestore()
    .collection(COLLECTIONS.USER_PATHS)
    .doc(userPathId);
  const doc = await docRef.get();

  if (!doc.exists) {
    throw new HttpsError("not-found", "Path not found");
  }

  const data = doc.data();

  if (data?.userId !== userId) {
    throw new HttpsError("permission-denied",
      "The user is not authorized to delete this path");
  }

  const pathId = data.pathId;

  await docRef.delete();

  // Orphan Path Cleanup
  if (pathId) {
    const otherReferences = await admin.firestore()
      .collection(COLLECTIONS.USER_PATHS)
      .where("pathId", "==", pathId)
      .limit(1) // We only need to know if at least one exists
      .get();

    if (otherReferences.empty) {
      // No other user paths reference this geometry, delete it
      await admin.firestore()
        .collection(COLLECTIONS.PATHS)
        .doc(pathId)
        .delete();
    }
  }
}
