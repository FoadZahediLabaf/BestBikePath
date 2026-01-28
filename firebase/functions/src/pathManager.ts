import * as admin from "firebase-admin";
import { FieldValue } from "firebase-admin/firestore";
if (!admin.apps.length) {
  admin.initializeApp();
}


export interface PathLocation {
  latitude: number;
  longitude: number;
}

export interface NewPath {
  userId: string;
  isPublic: boolean;
  rating: number;
  locations: PathLocation[];
}

/**
 * Saves a new path to Firestore.
 * @param {NewPath} path - The path data to save
 * @return {Promise<string>} The new document ID
 */
export async function savePath(path: NewPath) {
  const docRef = await admin.firestore().collection("paths").add({
    userId: path.userId,
    isPublic: path.isPublic,
    rating: path.rating,
    locations: path.locations,
    createdAt: FieldValue.serverTimestamp(),
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
export async function deleteUserPath(pathId: string, userId: string) {
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
 * Toggles the public status of a path.
 * @param {string} pathId - The ID of the path to update
 * @param {string} userId - The ID of the requesting user
 * @param {boolean} isPublic - The new public status
 * @return {Promise<void>}
 */
export async function togglePrivacy(
  pathId: string,
  userId: string,
  isPublic: boolean
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

  await pathRef.update({
    isPublic,
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


