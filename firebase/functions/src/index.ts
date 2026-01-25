import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp(); 

import { registerUser } from "./userManager";

export const signup = functions.https.onRequest(async (req, res) => {
 
    if (req.method !== "POST") {
    res.status(400).send("Method Not Allowed");
    return; 
  }

  const { email, username, password } = req.body;

  if (!email || !username || !password) {
    res.status(400).json({ error: "Missing the required fields" });
    return;
  }

  try {
    const uid = await registerUser({ email, username, password });
    res.status(201).json({ uid });
  } catch (error: any) {
    res.status(400).json({ error: error.message });
  }
});