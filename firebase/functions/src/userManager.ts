import { defineString } from "firebase-functions/params";
import * as admin from "firebase-admin";

const apiKeyParam = defineString("API_KEY");

export async function createUser(email: string, password: string, name: string): Promise<string> {
  // Create user in Firebase Auth
  const firebaseUser = await admin.auth().createUser({
    email: email,
    password: password,
  });

  // Save user info on the firestore
  await admin.firestore().collection("users").doc(firebaseUser.uid).set({
    email: email,
    name: name,
  });

  // Generate Custom Token
  return await admin.auth().createCustomToken(firebaseUser.uid);
}

export async function deleteUser(email: string): Promise<void> {
  const user = await admin.auth().getUserByEmail(email);
  await admin.auth().deleteUser(user.uid);

  //Deleting user document from firestore
  await admin.firestore().collection("users").doc(user.uid).delete();
}

export async function signIn(email: string, password: string): Promise<string> {
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