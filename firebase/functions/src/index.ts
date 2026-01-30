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
import * as pathManager from "./userPathManager";

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
    throw new HttpsError("unauthenticated", "The user must be authenticated");
  }
  const { email } = request.data;
  if (email !== request.auth.token.email) {
    throw new HttpsError("permission-denied",
      "The email does not match the authenticated user");
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

// MARK: - UserPath Management

export const saveUserPath = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "The user must be authenticated");
  }

  const userPath = request.data;

  if (userPath.userId !== request.auth.uid) {
    throw new HttpsError("permission-denied",
      "User ID does not match authenticated user");
  }

  return await pathManager.savePath(userPath);
});

export const getUserPaths = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "The user must be authenticated");
  }

  const { userID } = request.data;

  if (!userID) {
    throw new HttpsError("invalid-argument", "userID is required");
  }

  return await pathManager.getUserPaths(userID, request.auth.uid);
});

export const updateUserPathPrivacy = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "The user must be authenticated");
  }

  const { id: pathId, isPublic } = request.data;

  if (!pathId) {
    throw new HttpsError("invalid-argument", "Path ID is required");
  }

  await pathManager.updatePathPrivacy(pathId, request.auth.uid, isPublic);
});

export const updateUserPathStatus = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "The user must be authenticated");
  }

  const { id: pathId, status } = request.data;

  if (!pathId) {
    throw new HttpsError("invalid-argument", "Path ID is required");
  }

  await pathManager.updatePathStatus(pathId, request.auth.uid, status);
});

import * as communityPathManager from "./communityPathManager";

export const deleteUserPath = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "The user must be authenticated");
  }

  const { id: pathId } = request.data;

  if (!pathId) {
    throw new HttpsError("invalid-argument", "Path ID is required");
  }

  await pathManager.deletePath(pathId, request.auth.uid);
});

// MARK: - Community Paths

export const getCommunityPaths = onCall(async (request) => {
  const { origin, destination } = request.data;

  if (!origin || !destination) {
    throw new HttpsError("invalid-argument",
      "Origin and destination are required");
  }

  return await communityPathManager.getCommunityPaths(origin, destination);
});

// MARK: - CommunityPath Management
