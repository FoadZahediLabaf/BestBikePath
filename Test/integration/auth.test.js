/**
 * Integration tests related to the authentication flow.
 *
 * These tests verify the interaction between the mobile client
 * and Firebase Authentication. The authentication flow is based
 * on a single access page where the user first enters an email,
 * and the system dynamically decides how to proceed.
 */

import {
  getAuth,
  fetchSignInMethodsForEmail,
  signInWithEmailAndPassword,
  createUserWithEmailAndPassword
} from "firebase/auth";

describe("Authentication integration tests", () => {

  /**
   * IT1 – Email handling for existing account
   * Verifies that Firebase Authentication correctly recognizes
   * an email that is already associated with an existing account.
   */
  test("Existing email is recognized by the authentication system", async () => {
    const auth = getAuth();

    const methods = await fetchSignInMethodsForEmail(
      auth,
      "existinguser@test.com"
    );

    // If at least one sign-in method exists,
    // the email is already registered.
    expect(methods.length).toBeGreaterThan(0);
  });

  /**
   * IT2 – Email handling for new account
   * Verifies that Firebase Authentication does not return
   * sign-in methods for a new email address.
   */
  test("New email is not found in the authentication system", async () => {
    const auth = getAuth();

    const methods = await fetchSignInMethodsForEmail(
      auth,
      "newuser@test.com"
    );

    // No methods means the email is not yet registered.
    expect(methods.length).toBe(0);
  });

  /**
   * IT3 – Password verification for existing account
   * Verifies that an existing user can authenticate
   * by providing the correct password.
   */
  test("Existing user can authenticate with correct password", async () => {
    const auth = getAuth();

    const result = await signInWithEmailAndPassword(
      auth,
      "existinguser@test.com",
      "correctPassword123"
    );

    // Successful authentication returns a valid user object.
    expect(result.user.uid).toBeDefined();
  });

  /**
   * IT4 – Account creation inside the access flow
   * Verifies that a new user account can be created
   * and authenticated when the email is not registered.
   */
  test("New account is created during access flow", async () => {
    const auth = getAuth();

    const result = await createUserWithEmailAndPassword(
      auth,
      "newuser@test.com",
      "newPassword123"
    );

    // Account creation immediately authenticates the user.
    expect(result.user.uid).toBeDefined();
  });

});
