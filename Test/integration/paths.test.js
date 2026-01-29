/**
 * Integration tests related to personal path management.
 *
 * These tests verify the interaction between authenticated users,
 * backend services, and Firebase Firestore when managing paths.
 */

import { initializeTestEnvironment } from "@firebase/rules-unit-testing";

describe("Path management integration tests", () => {

  /**
   * IT7 – Path creation and persistence
   * Verifies that an authenticated user can create a path
   * and that the path is stored in Firestore.
   */
  test("Authenticated user creates a path and it is stored", async () => {
    const testEnv = await initializeTestEnvironment({
      projectId: "bestbikepath-test"
    });

    const db = testEnv.authenticatedContext("user_1").firestore();

    const ref = await db.collection("paths").add({
      name: "Morning Ride",
      ownerId: "user_1",
      isPublic: false
    });

    const snapshot = await ref.get();
    expect(snapshot.exists).toBe(true);
  });

  /**
   * IT8 – Path retrieval for owner
   * Verifies that a user can retrieve only their own paths.
   */
  test("User retrieves only own paths", async () => {
    const testEnv = await initializeTestEnvironment({
      projectId: "bestbikepath-test"
    });

    const db = testEnv.authenticatedContext("user_1").firestore();

    const snapshot = await db
      .collection("paths")
      .where("ownerId", "==", "user_1")
      .get();

    snapshot.docs.forEach(doc => {
      expect(doc.data().ownerId).toBe("user_1");
    });
  });

  /**
   * IT9 – Path visibility update
   * Verifies that a user can change the visibility of a path
   * and that the update is persisted.
   */
  test("User updates path visibility", async () => {
    const testEnv = await initializeTestEnvironment({
      projectId: "bestbikepath-test"
    });

    const db = testEnv.authenticatedContext("user_1").firestore();

    const ref = await db.collection("paths").add({
      name: "Hidden Path",
      ownerId: "user_1",
      isPublic: false
    });

    await ref.update({ isPublic: true });

    const updated = await ref.get();
    expect(updated.data().isPublic).toBe(true);
  });

  /**
   * IT13 – Path deletion
   * Verifies that a user can delete one of their paths
   * and that the data is removed from Firestore.
   */
  test("User deletes own path", async () => {
    const testEnv = await initializeTestEnvironment({
      projectId: "bestbikepath-test"
    });

    const db = testEnv.authenticatedContext("user_1").firestore();

    const ref = await db.collection("paths").add({
      name: "To Be Deleted",
      ownerId: "user_1"
    });

    await ref.delete();

    const snapshot = await db.collection("paths").get();
    expect(snapshot.docs.length).toBe(0);
  });

});
