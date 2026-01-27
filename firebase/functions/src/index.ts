import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

if (!admin.apps.length) {
  admin.initializeApp();
}


import { registerUser, deleteUserAccount } from "./userManager";
import { savePath, getUserPaths, deleteUserPath, togglePrivacy } from "./pathManager";

export const signup = functions.https.onRequest(async (req, res) => {
 
    if (req.method !== "POST") {
    res.status(400).send("Method Not Allowed");
    return; 
  }

  const { email, username, password } = req.body;

  if (!email || !username || !password) {
    res.status(400).json({ error: "Missing the required fields" });
    return;
  }

  try {
    const uid = await registerUser({ email, username, password });
    res.status(201).json({ uid });
  } catch (error: any) {
    res.status(400).json({ error: error.message });
  }
});

const FIREBASE_API_KEY = "AIzaSyBX-HZ6X7F1eqtSpwMWA1mfLfDy6dUac10";

export const signin = functions.https.onRequest(async (req, res) => {

  const { username, password } = req.body;

  if (!username || !password) {
    res.status(400).json({ error: "Missing username or password" });
    return;
  }

  try {
    const snapshot = await admin.firestore()
      .collection("users")
      .where("username", "==", username)
      .limit(1)
      .get();

    if (snapshot.empty) {
      res.status(404).json({ error: "User not found" });
      return;
    }

    const userDoc = snapshot.docs[0];
    const email = userDoc.data().email;

    const response = await fetch(
      `https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${FIREBASE_API_KEY}`,
      {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          email,
          password,
          returnSecureToken: true,
        }),
      }
    );

    const data: any = await response.json();

    if (!response.ok) {
      res.status(400).json({ error: "Invalid password" });
      return;
    }

    res.status(200).json({
      uid: data.localId,
      idToken: data.idToken,
    });

  } catch (err: any) {
    console.error(err);
    res.status(500).json({ error: "Internal server error" });
  }
});

export const deleteAccount = functions.https.onRequest(async (req, res) => {
  if (req.method !== "POST") {
    res.status(405).send("Method Not Allowed");
    return;
  }

  const idToken = req.headers.authorization?.split("Bearer ")[1];

  if (!idToken) {
    res.status(401).json({ error: "Missing or invalid token" });
    return;
  }

  try {
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    const uid = decodedToken.uid;

    await deleteUserAccount(uid);

    res.status(200).json({ message: `User ${uid} deleted successfully` });
  } catch (error: any) {
    console.error("Delete user failed:", error);
    res.status(500).json({ error: error.message });
  }
});

export const addPath = functions.https.onRequest(async (req, res) => {

  const idToken = req.headers.authorization?.split("Bearer ")[1];

  if (!idToken) {
    res.status(400).json({ error: "Missing ID token" });
    return;
  }

  try {

    const decodedToken = await admin.auth().verifyIdToken(idToken);
    const userId = decodedToken.uid;

    const { isPublic, rating, locations } = req.body;
  
    if (!locations || !Array.isArray(locations)) {
      res.status(400).json({ error: "invalid data", body: req.body });
      return;
    }

    const pathId = await savePath({
      userId,
      isPublic,
      rating,
      locations,
    });

    res.status(201).json({ pathId });
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
});

export const getPaths = functions.https.onRequest(async (req, res) => {
  const idToken = req.headers.authorization?.split("Bearer ")[1];

  if (!idToken) {
    res.status(401).json({ error: "Missing ID token" });
    return;
  }

  try {
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    const userId = decodedToken.uid;

    const paths = await getUserPaths(userId);
    res.status(200).json(paths);
    return; 

  } catch (error: any) {
    res.status(500).json({ error: error.message });
    return; 
  }
});


export const deletePath = functions.https.onRequest(async (req, res) => {

  const idToken = req.headers.authorization?.split("Bearer ")[1];
  if (!idToken) {
    res.status(401).json({ error: "missing token" });
    return;
  }

  try {
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    const userId = decodedToken.uid;

    const { pathId } = req.body;
    if (!pathId) {
      res.status(400).json({ error: "missing pathId" });
      return;
    }

    await deleteUserPath(pathId, userId);

    res.status(200).json({ message: "path deleted sucessfully" });
    return;

  } catch (error: any) {
    res.status(500).json({ error: error.message });
    return;
  }
});

export const togglePathPrivacy = functions.https.onRequest(async (req, res) => {

  try {
    const idToken = req.headers.authorization?.split("Bearer ")[1];
    if (!idToken){
      res.status(400).json({ error: "Missing ID token" });
      return;
    }

    const decodedToken = await admin.auth().verifyIdToken(idToken);
    const userId = decodedToken.uid;

    const { pathId, isPublic } = req.body;
    if (!pathId || typeof isPublic !== "boolean") {
      res.status(400).json({ error: "missing or invalid data" });
      return;
    }
    
    togglePrivacy(pathId, userId, isPublic);
    res.status(200).json();
    return;

  } catch (error: any) {
    res.status(500).json({ error: error.message });
    return 
  }
});
