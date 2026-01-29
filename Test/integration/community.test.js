/**
 * Integration tests related to community path browsing.
 *
 * These tests verify that public paths are correctly exposed
 * to other users and that path details can be retrieved.
 */

import { initializeTestEnvironment } from "@firebase/rules-unit-testing";

describe("Community path integration tests", () => {

  /**
   * IT10 – Community path browsing
   * Verifies that public paths are visible to other users.
   */
  test("Public paths are visible to other users", async () => {
    const testEnv = await initializeTestEnvironment({
      projectId: "bestbikepath-test"
    });

    const ownerDb = testEnv.authenticatedContext("owner").firestore();
    const viewerDb = testEnv.authenticatedContext("viewer").firestore();

    await ownerDb.collection("paths").add({
      name: "Community Path",
      ownerId: "owner",
      isPublic: true
    });

    const snapshot = await viewerDb
      .collection("paths")
      .where("isPublic", "==", true)
      .get();

    expect(snapshot.docs.length).toBeGreaterThan(0);
  });

  /**
   * IT11 – Private path exclusion
   * Verifies that private paths are not visible
   * during community browsing.
   */
  test("Private paths are not visible to other users", async () => {
    const testEnv = await initializeTestEnvironment({
      projectId: "bestbikepath-test"
    });

    const ownerDb = testEnv.authenticatedContext("owner").firestore();
    const viewerDb = testEnv.authenticatedContext("viewer").firestore();

    await ownerDb.collection("paths").add({
      name: "Private Path",
      ownerId: "owner",
      isPublic: false
    });

    const snapshot = await viewerDb.collection("paths").get();

    snapshot.docs.forEach(doc => {
      expect(doc.data().isPublic).toBe(true);
    });
  });

  /**
   * IT12 – Path detail retrieval
   * Verifies that all path attributes are correctly retrieved
   * when a specific path is selected.
   */
  test("Path details are correctly retrieved", async () => {
    const testEnv = await initializeTestEnvironment({
      projectId: "bestbikepath-test"
    });

    const db = testEnv.authenticatedContext("user_1").firestore();

    const ref = await db.collection("paths").add({
      name: "Detailed Path",
      ownerId: "user_1",
      isPublic: true,
      distance: 12.5
    });

    const snapshot = await ref.get();
    expect(snapshot.data().distance).toBe(12.5);
  });

});
