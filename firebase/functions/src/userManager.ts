import { defineString } from "firebase-functions/params";
import { HttpsError } from "firebase-functions/https";
import * as admin from "firebase-admin";
import { COLLECTIONS } from "./collections";

import * as nodemailer from "nodemailer";

const apiKeyParam = defineString("API_KEY");
const emailUserParam = defineString("EMAIL_USER");
const emailPassParam = defineString("EMAIL_PASS");
const emailServiceParam = defineString("EMAIL_SERVICE");
const emailFromParam = defineString("EMAIL_FROM");

/**
 * Creates a new user in Firebase Auth and Firestore.
 * @param {string} email - User email
 * @param {string} password - User password
 * @param {string} displayName - User display name
 * @param {string} emailVerificationCode - The code to verify email
 * @return {Promise<string>} Custom auth token
 */
export async function createUser(
  email: string,
  password: string,
  displayName: string,
  emailVerificationCode: string
): Promise<string> {
  const emailVerified = await checkEmailVerificationCode(
    email,
    emailVerificationCode
  );
  if (!emailVerified) {
    const code = "invalid-email";
    const message = "Email is not verified";
    throw new HttpsError("invalid-argument", message, { code, message });
  }

  // Create user in Firebase Auth
  const firebaseUser = await admin.auth().createUser({
    displayName: displayName,
    email: email,
    emailVerified: true,
    password: password,
  });

  // Delete verification document after successful creation
  await admin.firestore().collection(COLLECTIONS.EMAIL_VERIFICATIONS).doc(email).delete();

  // Generate Custom Token
  return await admin.auth().createCustomToken(firebaseUser.uid);
}

/**
 * Sends a verification code to the provided email.
 * @param {string} email - User email
 * @return {Promise<void>}
 */
export async function sendEmailVerificationCode(email: string): Promise<void> {
  // Create transporter using params
  const transporter = nodemailer.createTransport({
    service: emailServiceParam.value(),
    auth: {
      user: emailUserParam.value(),
      pass: emailPassParam.value(),
    },
  });

  const code = Math.floor(100000 + Math.random() * 900000).toString();
  // 10 minutes
  const expiresAt = admin.firestore.Timestamp.fromMillis(
    Date.now() + 10 * 60 * 1000
  );

  await admin.firestore()
    .collection(COLLECTIONS.EMAIL_VERIFICATIONS)
    .doc(email)
    .set({
      code: code,
      expiresAt: expiresAt,
    });

  const mailOptions = {
    from: emailFromParam.value(),
    to: email,
    subject: "Your Verification Code",
    text: `Your verification code is: ${code}`,
  };

  try {
    await transporter.sendMail(mailOptions);
    console.log(`Verification code sent to ${email}`);
  } catch (error) {
    console.error("Error sending email:", error);
    throw new HttpsError("unavailable", "Failed to send verification email.");
  }
}

/**
 * Checks the verification code for the provided email.
 * @param {string} email - User email
 * @param {string} code - Verification code
 * @return {Promise<boolean>} True if verified, false otherwise
 */
export async function checkEmailVerificationCode(
  email: string,
  code: string
): Promise<boolean> {
  const doc = await admin.firestore()
    .collection(COLLECTIONS.EMAIL_VERIFICATIONS)
    .doc(email)
    .get();

  if (!doc.exists) {
    return false;
  }

  const data = doc.data();
  if (!data || data.code !== code) {
    return false;
  }

  if (data.expiresAt.toMillis() < Date.now()) {
    return false;
  }

  return true;
}

/**
 * Deletes a user from Firebase Auth and Firestore.
 * @param {string} email - User email to lookup
 * @return {Promise<void>}
 */
export async function deleteUser(email: string): Promise<void> {
  const user = await admin.auth().getUserByEmail(email);
  await admin.auth().deleteUser(user.uid);
}

/**
 * Signs in a user using the Identity Toolkit API.
 * @param {string} email - User email
 * @param {string} password - User password
 * @return {Promise<string>} Custom auth token
 */
export async function signIn(email: string, password: string): Promise<string> {
  // Verify password using Identity Toolkit API
  const apiKey = apiKeyParam.value();

  const response = await fetch(
    "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword" +
    `?key=${apiKey}`,
    {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        email: email,
        password: password,
        returnSecureToken: true,
      }),
    }
  );

  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const data = await response.json() as any;

  if (!response.ok) {
    throw new HttpsError("unauthenticated", data.error?.message || "Authentication failed");
  }

  // Generate Custom Token
  const uid = data.localId;
  const customToken = await admin.auth().createCustomToken(uid);

  return customToken;
}

/**
 * Checks if a user exists in Firebase Auth.
 * @param {string} email - User email
 * @return {Promise<boolean>} True if user exists, false otherwise
 */
export async function checkUserExists(email: string): Promise<boolean> {
  try {
    const result = await admin.auth().getUsers([{ email }]);
    return result.users.length > 0;
  } catch (error: unknown) {
    const firebaseError = error as { code?: string; message?: string };
    const code = firebaseError.code || "unknown";
    const message = firebaseError.message || "Unknown error";

    if (code === "auth/invalid-email") {
      throw new HttpsError("invalid-argument", message, { code, message });
    }

    throw new HttpsError("unknown", message, { code, message });
  }
}
