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

export async function getUserPaths(userId: string) {
  const snapshot = await admin.firestore()
    .collection("paths")
    .where("userId", "==", userId)
    .orderBy("createdAt", "desc")
    .get();

  return snapshot.docs.map(doc => ({
    id: doc.id,
    ...doc.data()
  }));
}

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