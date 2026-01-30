import * as admin from "firebase-admin";
import { COLLECTIONS } from "./collections";
import { FieldValue, Timestamp } from "firebase-admin/firestore";
import { HttpsError } from "firebase-functions/v2/https";

if (!admin.apps.length) {
  admin.initializeApp();
}

export interface PathLocation {
  latitude: number;
  longitude: number;
}

export interface PathData {
  locations: PathLocation[];
}

export interface PathPerformance {
  distance: number;
  averageSpeed: number;
  peakSpeed: number;
}

export interface PathWeather {
  temperature: number;
  humidity: number;
  windSpeed: number;
}

export interface UserPath {
  id: string;
  userId: string;
  creationDate: string | Date | Timestamp;
  isPublic: boolean;
  path: PathData;
  status: number;
  performance?: PathPerformance;
  weather?: PathWeather;
}

/**
 * Saves (creates or updates) a user path.
 * Matches: func savePath(_ path: UserPath) async throws
 * @param {UserPath} userPath - The user path data
 * @return {Promise<void>}
 */
export async function savePath(userPath: UserPath): Promise<void> {
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

  const docRef = admin.firestore().collection(COLLECTIONS.USER_PATHS).doc(userPath.id);

  await docRef.set({
    userId: userPath.userId,
    creationDate: userPath.creationDate,
    isPublic: userPath.isPublic,
    path: userPath.path, // Contains locations
    status: userPath.status,
    ...(userPath.performance && { performance: userPath.performance }),
    ...(userPath.weather && { weather: userPath.weather }),
    updatedAt: FieldValue.serverTimestamp(),
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
  requestingUserId?: string
): Promise<UserPath[]> {
  const snapshot = await admin.firestore()
    .collection(COLLECTIONS.USER_PATHS)
    .where("userId", "==", targetUserId)
    .get();

  const paths: UserPath[] = [];

  for (const doc of snapshot.docs) {
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const data = doc.data() as any;

    // Privacy Check
    // If getting own paths, return all.
    // If getting other's paths, return only isPublic == true.
    if (targetUserId !== requestingUserId && !data.isPublic) {
      continue;
    }

    // Map back to UserPath interface
    const userPath: UserPath = {
      id: doc.id,
      userId: data.userId,
      creationDate: data.creationDate,
      isPublic: data.isPublic,
      path: data.path || { locations: data.locations || [] },
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
 * @param {string} pathId - ID of the path
 * @param {string} userId - Requesting user ID (owner)
 * @param {boolean} isPublic - The new privacy state
 */
export async function updatePathPrivacy(
  pathId: string,
  userId: string,
  isPublic: boolean
) {
  const docRef = admin.firestore().collection(COLLECTIONS.USER_PATHS).doc(pathId);
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
 * @param {string} pathId - ID of the path
 * @param {string} userId - Requesting user ID (owner)
 * @param {number} status - The new status (1-5)
 */
export async function updatePathStatus(
  pathId: string,
  userId: string,
  status: number
) {
  if (!Number.isInteger(status) || status < 1 || status > 5) {
    throw new HttpsError("invalid-argument",
      "Status must be an integer between 1 and 5");
  }

  const docRef = admin.firestore().collection(COLLECTIONS.USER_PATHS).doc(pathId);
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
 * @param {string} pathId - The ID of the path to delete
 * @param {string} userId - The ID of the requesting user
 * @return {Promise<void>}
 */
export async function deletePath(pathId: string, userId: string) {
  const docRef = admin.firestore().collection(COLLECTIONS.USER_PATHS).doc(pathId);
  const doc = await docRef.get();

  if (!doc.exists) {
    throw new HttpsError("not-found", "Path not found");
  }

  if (doc.data()?.userId !== userId) {
    throw new HttpsError("permission-denied",
      "The user is not authorized to delete this path");
  }

  await docRef.delete();
}
