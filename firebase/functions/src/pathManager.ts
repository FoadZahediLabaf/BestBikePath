import * as admin from "firebase-admin";
import { FieldValue } from "firebase-admin/firestore";
if (!admin.apps.length) {
  admin.initializeApp();
}


export interface PathLocation {
  latitude: number;
  longitude: number;
}

export interface PathPerformance {
  averageSpeed: number;
  peakSpeed: number;
}

export interface PathWeather {
  temperature: number;
  humidity: number;
  windSpeed: number;
}

export interface Path {
  userId: string;
  isPublic: boolean;
  status: number;
  locations: PathLocation[];
  performance?: PathPerformance;
  weather?: PathWeather;
}

/**
 * Saves a new path to Firestore.
 * @param {Path} path - The path data to save
 * @return {Promise<string>} The new document ID
 */
export async function createPath(path: Path) {
  if (!Number.isInteger(path.status) || path.status < 1 || path.status > 5) {
    throw new Error("Status must be an integer between 1 and 5");
  }

  const docRef = await admin.firestore().collection("paths").add({
    userId: path.userId,
    isPublic: path.isPublic,
    status: path.status,
    locations: path.locations,
    createdAt: FieldValue.serverTimestamp(),
    ...(path.performance && { performance: path.performance }),
    ...(path.weather && { weather: path.weather }),
  });

  return docRef.id;
}

/**
 * Retrieves all paths for a specific user.
 * @param {string} userId - The user ID
 * @return {Promise<any[]>} List of user paths
 */
export async function getUserPaths(userId: string) {
  const snapshot = await admin.firestore()
    .collection("paths")
    .where("userId", "==", userId)
    .orderBy("createdAt", "desc")
    .get();

  return snapshot.docs.map((doc) => ({
    id: doc.id,
    ...doc.data(),
  }));
}

/**
 * Deletes a path if the user is authorized.
 * @param {string} pathId - The ID of the path to delete
 * @param {string} userId - The ID of the requesting user
 * @return {Promise<void>}
 */
export async function deletePath(pathId: string, userId: string) {
  const docRef = admin.firestore().collection("paths").doc(pathId);
  const doc = await docRef.get();

  if (!doc.exists) {
    throw new Error("Path not found");
  }

  if (doc.data()?.userId !== userId) {
    throw new Error("unauthorized");
  }

  await docRef.delete();
}

/**
 * Updates a path with the provided data.
 * @param {string} pathId - The ID of the path to update
 * @param {string} userId - The ID of the requesting user
 * @param {Partial<Path>} updates - The fields to update
 * @return {Promise<void>}
 */
export async function updatePath(
  pathId: string,
  userId: string,
  updates: Partial<Path>
) {
  const pathRef = admin.firestore().collection("paths").doc(pathId);
  const pathSnap = await pathRef.get();

  if (!pathSnap.exists) {
    throw new Error("Path not found");
  }

  const pathData = pathSnap.data();
  if (pathData?.userId !== userId) {
    throw new Error("Can't update path");
  }

  if (
    updates.status !== undefined &&
    (!Number.isInteger(updates.status) ||
      updates.status < 1 ||
      updates.status > 5)
  ) {
    throw new Error("Status must be an integer between 1 and 5");
  }

  // Remove userId from updates to prevent ownership transfer via this function
  // references cannot be deleted, so we just destructure and omit userId
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  const { userId: _, ...safeUpdates } = updates;

  await pathRef.update({
    ...safeUpdates,
    updatedAt: FieldValue.serverTimestamp(),
  });
}

/**
 * Retrieves details of a single path with privacy enforcement.
 * Public paths are accessible by anyone.
 * Private paths are accessible only by the owner.
 * @param {string} pathId - The ID of the path
 * @param {string | undefined} userId - Requesting user ID (if authenticated)
 * @return {Promise<any>} Path data
 */
export async function getPathDetails(
  pathId: string,
  userId?: string
) {
  const docRef = admin.firestore().collection("paths").doc(pathId);
  const docSnap = await docRef.get();

  if (!docSnap.exists) {
    throw new Error("Path not found");
  }

  const pathData = docSnap.data();

  if (pathData?.isPublic === true) {
    return {
      id: docSnap.id,
      ...pathData,
    };
  }

  if (userId && pathData?.userId === userId) {
    return {
      id: docSnap.id,
      ...pathData,
    };
  }

  throw new Error("unauthorized");
}


