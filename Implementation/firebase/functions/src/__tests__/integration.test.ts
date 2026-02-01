
import * as admin from "firebase-admin";

// eslint-disable-next-line @typescript-eslint/no-var-requires
const test = require("firebase-functions-test")({
  projectId: "bestbikepath-test",
});

import * as myFunctions from "../index";
import { COLLECTIONS } from "../constants";

describe("Integration Tests", () => {
  // Cleanup after all tests
  afterAll(() => {
    test.cleanup();
  });

  describe("createUser", () => {
    const email = "integration-test@example.com";
    const password = "password123";
    const displayName = "Integration User";
    const verificationCode = "123456";

    beforeEach(async () => {
      // Clear Firestore and Auth specific to this user before test
      // Helper to clear would be nice, but simple delete for now
      try {
        await admin.auth().deleteUser((await admin.auth().getUserByEmail(email)).uid);
      } catch (e) {
        // Ignore if user doesn't exist
      }
      await admin.firestore().collection(COLLECTIONS.EMAIL_VERIFICATIONS).doc(email).delete();
    });

    it("should create a user successfully given valid verification code", async () => {
      // Setup Verification Code in Firestore
      await admin.firestore()
        .collection(COLLECTIONS.EMAIL_VERIFICATIONS)
        .doc(email)
        .set({
          code: verificationCode,
          expiresAt: admin.firestore.Timestamp.fromMillis(Date.now() + 100000),
        });

      // Call the function
      const request = {
        data: {
          email,
          password,
          displayName,
          emailVerificationCode: verificationCode,
        },
        auth: undefined as any // Unauthenticated
      };
      
      const token = await (myFunctions.createUser as any).run(request);

      // Verify Result
      expect(typeof token).toBe("string");

      // Verify User in Auth
      const user = await admin.auth().getUserByEmail(email);
      expect(user.displayName).toBe(displayName);
      expect(user.emailVerified).toBe(true); // create creates as verified

      // Verify Verification Code is deleted
      const doc = await admin.firestore()
        .collection(COLLECTIONS.EMAIL_VERIFICATIONS)
        .doc(email)
        .get();
      expect(doc.exists).toBe(false);
    });

    it("should fail if verification code is missing/invalid", async () => {
      const request = {
        data: {
          email,
          password,
          displayName,
          emailVerificationCode: "invalid-code",
        },
        auth: undefined
      };

      await expect((myFunctions.createUser as any).run(request)).rejects.toThrow();
    });
  });

  describe("Path Management Integration", () => {
    let uid: string;
    const userEmail = "path-tester@example.com";

    beforeAll(async () => {
       try {
        await admin.auth().deleteUser((await admin.auth().getUserByEmail(userEmail)).uid);
      } catch (e) {}
       const user = await admin.auth().createUser({
           email: userEmail,
           uid: "path-tester-uid"
       });
       uid = user.uid;
    });

    it("should save a new user path", async () => {
        const pathData = {
            id: "user-path-1",
            userId: uid,
            status: 4,
            isPublic: true,
            date: new Date().toISOString(),
            path: {
                id: "initial-path-id",
                locations: [{latitude: 10, longitude: 10}, {latitude: 10.001, longitude: 10.001}]
            }
        };

        const request = {
            data: {
                ...pathData,
                date: new Date() // Passing Date object directly
            },
            auth: {
                uid,
                token: {
                    uid,
                    email: userEmail,
                    email_verified: true,
                }
            }
        };

        await (myFunctions.saveUserPath as any).run(request);

        // Verify it exists in user_paths
        const doc = await admin.firestore().collection("user_paths").doc("user-path-1").get();
        expect(doc.exists).toBe(true);
        expect(doc.data()?.userId).toBe(uid);
        
        // It checks if it linked to a `paths` doc.
        const pathId = doc.data()?.pathId;
        expect(pathId).toBeDefined();
        
        // Check `paths` doc
        const pathDoc = await admin.firestore().collection("paths").doc(pathId).get();
        expect(pathDoc.exists).toBe(true);
    });

    it("should retrieve community paths", async () => {
        // We know "user-path-1" exists at 10,10 from previous test
        const request = {
            data: {
                origin: { latitude: 10, longitude: 10 },
                destination: { latitude: 10.001, longitude: 10.001 }
            },
            auth: undefined
        };
        
        const result = await (myFunctions.getCommunityPaths as any).run(request);
        
        expect(Array.isArray(result)).toBe(true);
        expect(result.length).toBeGreaterThan(0);
        const path = result.find((p: any) => p.id === "initial-path-id" || p.path.id === "initial-path-id");
        expect(path).toBeDefined();
    });

    it("should update user path privacy", async () => {
        const request = {
            data: {
                id: "user-path-1",
                isPublic: false
            },
            auth: {
                uid,
                token: { uid, email: userEmail, email_verified: true }
            }
        };

        await (myFunctions.updateUserPathPrivacy as any).run(request);

        const doc = await admin.firestore().collection("user_paths").doc("user-path-1").get();
        expect(doc.data()?.isPublic).toBe(false);
    });

    it("should delete user path and orphan path", async () => {
        // 1. Verify paths exist
        const upDocBefore = await admin.firestore().collection("user_paths").doc("user-path-1").get();
        expect(upDocBefore.exists).toBe(true);
        const pathId = upDocBefore.data()?.pathId;
        
        // 2. Delete User Path
        const request = {
            data: {
                id: "user-path-1"
            },
            auth: {
                uid,
                token: { uid, email: userEmail, email_verified: true }
            }
        };

        await (myFunctions.deleteUserPath as any).run(request);

        // Verify User Path is gone
        const upDocAfter = await admin.firestore().collection("user_paths").doc("user-path-1").get();
        expect(upDocAfter.exists).toBe(false);

        // Verify Linked Path is gone (Orphan cleanup)
        // Since "user-path-1" was the only one pointing to "initial-path-id"
        const pathDocAfter = await admin.firestore().collection("paths").doc(pathId).get();
        expect(pathDocAfter.exists).toBe(false);
    });
  });
});
