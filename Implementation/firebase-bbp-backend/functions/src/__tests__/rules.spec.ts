
import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
  RulesTestEnvironment,
} from "@firebase/rules-unit-testing";
import * as fs from "fs";

let testEnv: RulesTestEnvironment;

beforeAll(async () => {
  testEnv = await initializeTestEnvironment({
    projectId: "bestbikepath-test",
    firestore: {
      rules: fs.readFileSync("../firestore.rules", "utf8"),
    },
  });
});

afterAll(async () => {
  await testEnv.cleanup();
});

beforeEach(async () => {
  await testEnv.clearFirestore();
});

describe("Firestore Security Rules", () => {
  // Helpers
  const getContext = (userId?: string) => {
    return userId ? testEnv.authenticatedContext(userId) : testEnv.unauthenticatedContext();
  };

  const db = (userId?: string) => getContext(userId).firestore();

  describe("Users Collection", () => {
    it("should allow user to write their own profile", async () => {
      const aliceDb = db("alice");
      await assertSucceeds(aliceDb.collection("users").doc("alice").set({ name: "Alice" }));
    });

    it("should allow user to read their own profile", async () => {
      const aliceDb = db("alice");
      await aliceDb.collection("users").doc("alice").set({ name: "Alice" });
      await assertSucceeds(aliceDb.collection("users").doc("alice").get());
    });

    it("should not allow user to write others' profile", async () => {
      const aliceDb = db("alice");
      await assertFails(aliceDb.collection("users").doc("bob").set({ name: "Hacked" }));
    });

    it("should not allow user to read others' profile", async () => {
      const bobDb = db("bob");
      await bobDb.collection("users").doc("bob").set({ name: "Bob" }); // Setup

      const aliceDb = db("alice");
      await assertFails(aliceDb.collection("users").doc("bob").get());
    });
  });

  describe("User Paths Collection", () => {
    it("should allow owner to create path with matching userId", async () => {
      const aliceDb = db("alice");
      await assertSucceeds(
        aliceDb.collection("user_paths").add({ userId: "alice", someData: "..." })
      );
    });

    it("should not allow owner to create path with mismatching userId", async () => {
      const aliceDb = db("alice");
      await assertFails(
        aliceDb.collection("user_paths").add({ userId: "bob", someData: "..." })
      );
    });

    it("should allow owner to read their path", async () => {
      // const adminDb = testEnv.authenticatedContext('admin').firestore();
      // Let's use `withSecurityRulesDisabled` to setup data or just write correctly.
      // But we can't write as admin easily without rule support.
      // We'll write as 'alice' first.
      const aliceDb = db("alice");
      const docRef = await aliceDb.collection("user_paths").add({ userId: "alice" });

      await assertSucceeds(docRef.get());
    });

    it("should allow others to read public paths", async () => {
      // Using withSecurityRulesDisabled to setup data for specific test scenario
      await testEnv.withSecurityRulesDisabled(async (context) => {
        await context.firestore().collection("user_paths").doc("public_path").set({
          userId: "alice",
          isPublic: true,
        });
      });

      const bobDb = db("bob");
      await assertSucceeds(bobDb.collection("user_paths").doc("public_path").get());

      const unauthDb = db();
      // Unauthenticated read?
      // My rules say: allow read: if isAuthenticated() && ...
      // So unauth should fail.
      await assertFails(unauthDb.collection("user_paths").doc("public_path").get());
    });

    it("should not allow others to read private paths", async () => {
      await testEnv.withSecurityRulesDisabled(async (context) => {
        await context.firestore().collection("user_paths").doc("private_path").set({
          userId: "alice",
          isPublic: false,
        });
      });

      const bobDb = db("bob");
      await assertFails(bobDb.collection("user_paths").doc("private_path").get());
    });
  });

  describe("Paths (Community) Collection", () => {
    it("should allow read for authenticated users", async () => {
      const aliceDb = db("alice");
      await assertSucceeds(aliceDb.collection("paths").doc("any").get());
    });

    it("should deny write for users", async () => {
      const aliceDb = db("alice");
      await assertFails(aliceDb.collection("paths").doc("any").set({ foo: "bar" }));
    });
  });
});
