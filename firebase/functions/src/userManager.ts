import { defineString } from "firebase-functions/params";
import * as admin from "firebase-admin";

const apiKeyParam = defineString("API_KEY");

if (!admin.apps.length) {
  admin.initializeApp();
}

export interface NewUser {
  email: string;
  username: string;
  password: string;
}

export async function registerUser(user: NewUser): Promise<string> {
  //User creation
  const firebaseUser = await admin.auth().createUser({
    email: user.email,
    password: user.password,
  });

  //Save user info on the firestore
  await admin.firestore().collection("users").doc(firebaseUser.uid).set({
    username: user.username,
    email: user.email,
  });

  return firebaseUser.uid;
}

export async function deleteUserAccount(uid: string): Promise<void> {
  // Deleting from firebse auth
  await admin.auth().deleteUser(uid);

  //Deleting user document from firestore
  await admin.firestore().collection("users").doc(uid).delete();
}

export async function signIn(username: string, password: string): Promise<string> {
  const usersSnapshot = await admin.firestore().collection("users").where("username", "==", username).get();

  if (usersSnapshot.empty) {
    throw new Error("User not found");
  }

  const userDoc = usersSnapshot.docs[0];
  const email = userDoc.data().email;

  // Verify password using Identity Toolkit API
  const apiKey = apiKeyParam.value();

  const response = await fetch(`https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${apiKey}`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      email: email,
      password: password,
      returnSecureToken: true,
    }),
  });

  const data = await response.json() as any;

  if (!response.ok) {
    throw new Error(data.error?.message || "Authentication failed");
  }

  // Generate Custom Token
  const uid = data.localId;
  const customToken = await admin.auth().createCustomToken(uid);

  return customToken;
}