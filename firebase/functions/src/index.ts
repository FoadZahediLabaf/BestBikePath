/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import { setGlobalOptions } from "firebase-functions";
import { onCall } from "firebase-functions/https";

import { signIn as signInManager } from "./userManager";

setGlobalOptions({ maxInstances: 10 });

export const signIn = onCall(async (request) => {
    const { username, password } = request.data;
    return await signInManager(username, password);
});
