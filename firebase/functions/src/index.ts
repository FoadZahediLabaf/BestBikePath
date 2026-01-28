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
import * as pathManager from "./pathManager";

admin.initializeApp();

setGlobalOptions({ maxInstances: 10 });

// MARK: - User Management

export const createUser = onCall(async (request) => {
  const { email, password, displayName, emailVerificationCode } = request.data;
  return await userManager.createUser(
    email,
    password,
    displayName,
    emailVerificationCode
  );
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

// MARK: - Manual Path Insertion Management

export const createPath = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "The user must be authenticated.");
  }

  const { isPublic, status, locations, performance, weather } = request.data;

  return await pathManager.createPath({
    userId: request.auth.uid,
    isPublic,
    status,
    locations,
    performance,
    weather,
  });
});

export const getUserPaths = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "The user must be authenticated.");
  }

  return await pathManager.getUserPaths(request.auth.uid);
});

export const updatePath = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "The user must be authenticated.");
  }

  const { pathId, ...updates } = request.data;
  await pathManager.updatePath(pathId, request.auth.uid, updates);
});

export const deletePath = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "The user must be authenticated.");
  }

  const { pathId } = request.data;
  await pathManager.deletePath(pathId, request.auth.uid);
});

export const getPathDetails = onCall(async (request) => {
  const { pathId } = request.data;
  // request.auth?.uid might be undefined if not logged in,
  // which is allowed for public paths
  return await pathManager.getPathDetails(pathId, request.auth?.uid);
});
