import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { onCall, HttpsError} from "firebase-functions/v2/https";

if (!admin.apps.length) {
  admin.initializeApp();
}

import { registerUser, deleteUserAccount } from "./userManager";
import { savePath, getUserPaths, deleteUserPath, togglePrivacy } from "./pathManager";
import { Coordinate, Path, CommunityPath, filterPaths, areSimilar, rankWeight} from "./communityPathManager";

const FIREBASE_API_KEY = "AIzaSyBX-HZ6X7F1eqtSpwMWA1mfLfDy6dUac10";


export const deleteAccount = functions.https.onRequest(async (req, res) => {

  const idToken = req.headers.authorization?.split("Bearer ")[1];

  if (!idToken) {
    res.status(401).json({ error: "Missing or invalid token" });
    return;
  }

  try {
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    const uid = decodedToken.uid;

    await deleteUserAccount(uid);

    res.status(200).json({ message: `User ${uid} deleted successfully` });
  } catch (error: any) {
    console.error("Delete user failed:", error);
    res.status(500).json({ error: error.message });
  }
});

export const addPath = functions.https.onRequest(async (req, res) => {

  const idToken = req.headers.authorization?.split("Bearer ")[1];

  if (!idToken) {
    res.status(400).json({ error: "Missing ID token" });
    return;
  }

  try {

    const decodedToken = await admin.auth().verifyIdToken(idToken);
    const userId = decodedToken.uid;

    const { isPublic, rating, locations } = req.body;
  
    if (!locations || !Array.isArray(locations)) {
      res.status(400).json({ error: "invalid data", body: req.body });
      return;
    }

    const pathId = await savePath({
      userId,
      isPublic,
      rating,
      locations,
    });

    res.status(201).json({ pathId });
  } catch (error: any) {
    res.status(500).json({ error: error.message });
  }
});

export const getPaths = functions.https.onRequest(async (req, res) => {
  const idToken = req.headers.authorization?.split("Bearer ")[1];

  if (!idToken) {
    res.status(401).json({ error: "Missing ID token" });
    return;
  }

  try {
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    const userId = decodedToken.uid;

    const paths = await getUserPaths(userId);
    res.status(200).json(paths);
    return; 

  } catch (error: any) {
    res.status(500).json({ error: error.message });
    return; 
  }
});


export const deletePath = functions.https.onRequest(async (req, res) => {

  const idToken = req.headers.authorization?.split("Bearer ")[1];
  if (!idToken) {
    res.status(401).json({ error: "missing token" });
    return;
  }

  try {
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    const userId = decodedToken.uid;

    const { pathId } = req.body;
    if (!pathId) {
      res.status(400).json({ error: "missing pathId" });
      return;
    }

    await deleteUserPath(pathId, userId);

    res.status(200).json({ message: "path deleted sucessfully" });
    return;

  } catch (error: any) {
    res.status(500).json({ error: error.message });
    return;
  }
});

export const togglePathPrivacy = functions.https.onRequest(async (req, res) => {

  try {
    const idToken = req.headers.authorization?.split("Bearer ")[1];
    if (!idToken){
      res.status(400).json({ error: "Missing ID token" });
      return;
    }

    const decodedToken = await admin.auth().verifyIdToken(idToken);
    const userId = decodedToken.uid;

    const { pathId, isPublic } = req.body;
    if (!pathId || typeof isPublic !== "boolean") {
      res.status(400).json({ error: "missing or invalid data" });
      return;
    }

    togglePrivacy(pathId, userId, isPublic);
    res.status(200).json();
    return;

  } catch (error: any) {
    res.status(500).json({ error: error.message });
    return 
  }
});

const MAX_PATHS = 30;

export const getCommunityPaths = onCall(async (data, context) => {

const { start, end } = (data as unknown) as { start: Coordinate; end: Coordinate };

  if (!start || !end) {
    throw new HttpsError('invalid-argument', 'Missing start or end coordinates');
  }

  try {
    // fetch all public paths
    const pathsSnap = await admin.firestore()
      .collection("paths")
      .where("isPublic", "==", true)
      .get();

    const allPaths: Path[] = pathsSnap.docs.map(doc => {
      const data = doc.data();
      return {
        streets: data.streets as string[],
        coordinates: data.locations as Coordinate[],
        status: data.status as number,
        createdAt: data.createdAt as number
      };
    });

    //filter paths based on start and end
    const filtered = filterPaths(allPaths, start, end); 
    

    //group similar paths in clusters
    const clusters: Path[][] = [];

    for (const path of filtered) {
      let placed = false;

      for (const cluster of clusters) {
        if (areSimilar(cluster[0].coordinates, path.coordinates)) {
          cluster.push(path);
          placed = true;
          break;
        }
      }

      if (!placed) {
        clusters.push([path]);
      }
    }

    //compute the community paths
    const communityPaths: CommunityPath[] = [];

    for (const cluster of clusters) {
      // Sort by recency 
      cluster.sort((a, b) => b.createdAt - a.createdAt);

      //top 30 paths per cluster
      const top = cluster.slice(0, MAX_PATHS);

      let wSum = 0;
      let wTot = 0;

      //compute weighted average of status
      top.forEach((p, index) => {
        const w = rankWeight(index, MAX_PATHS); 
  
        wSum += p.status * w;
        wTot += w;
      });

      const avgStatus = wSum/ wTot;

      communityPaths.push({
        coordinates: top[0].coordinates,
        status: avgStatus,
      });
    }

    // sort by status descending
    communityPaths.sort((a, b) => b.status - a.status);

    return { communityPaths };
  } catch (error: any) {
    throw new HttpsError('internal', error.message);
  }
});