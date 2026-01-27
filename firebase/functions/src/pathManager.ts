import * as admin from "firebase-admin";
import { FieldValue } from "firebase-admin/firestore";

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
 * @return {Promise<string>} The ID of the created document
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
 * Retrieves all paths created by a specific user.
 * @param {string} userId - The ID of the user
 * @return {Promise<Array<Object>>} Array of path documents
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
 * Deletes a path if it belongs to the user.
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
 * Toggles the privacy status of a path.
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
