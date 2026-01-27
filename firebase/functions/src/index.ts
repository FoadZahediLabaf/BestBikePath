/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at
 * https://firebase.google.com/docs/functions
 */

import { setGlobalOptions } from "firebase-functions";
import { onCall, HttpsError } from "firebase-functions/https";
import * as admin from "firebase-admin";

import * as userManager from "./userManager";

admin.initializeApp();

setGlobalOptions({ maxInstances: 10 });

// MARK: - User Management

export const createUser = onCall(async (request) => {
  const { email, password, name } = request.data;
  return await userManager.createUser(email, password, name);
});

export const deleteUser = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "The user must be authenticated.");
  }
  const { email } = request.data;
  if (email !== request.auth.token.email) {
    throw new HttpsError("permission-denied",
      "The email does not match the authenticated user.");
  }

  return await userManager.deleteUser(email);
});

export const signIn = onCall(async (request) => {
  const { email, password } = request.data;
  return await userManager.signIn(email, password);
});

export const checkUserExists = onCall(async (request) => {
  const { email } = request.data;
  return await userManager.checkUserExists(email);
});

export const sendEmailVerificationCode = onCall(async (request) => {
  const { email } = request.data;
  await userManager.sendEmailVerificationCode(email);
});

export const checkEmailVerificationCode = onCall(async (request) => {
  const { email, code } = request.data;
  return await userManager.checkEmailVerificationCode(email, code);
});
