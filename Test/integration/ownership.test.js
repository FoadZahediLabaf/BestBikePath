/**
 * Integration tests related to data isolation and ownership.
 *
 * These tests verify that users cannot modify or delete
 * paths owned by other users.
 */

import { initializeTestEnvironment } from "@firebase/rules-unit-testing";

describe("Ownership and isolation integration tests", () => {

  /**
   * IT14 – Data isolation between users
   * Verifies that a user cannot modify a path
   * belonging to another user.
   */
  test("User cannot modify another user's path", async () => {
    const testEnv = await initializeTestEnvironment({
      projectId: "bestbikepath-test"
    });

    const ownerDb = testEnv.authenticatedContext("owner").firestore();
    const otherDb = testEnv.authenticatedContext("other").firestore();

    const ref = await ownerDb.collection("paths").add({
      name: "Owner Path",
      ownerId: "owner"
    });

    await expect(
      otherDb.collection("paths").doc(ref.id).update({ name: "Hack" })
    ).rejects.toThrow();
  });

});
