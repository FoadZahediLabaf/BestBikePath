import * as admin from "firebase-admin";

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