import * as admin from "firebase-admin";
import { FieldValue, Timestamp } from "firebase-admin/firestore";
import { COLLECTIONS } from "./collections";
import { HttpsError } from "firebase-functions/v2/https";

export interface PathLocation {
  latitude: number;
  longitude: number;
}

export interface Path {
  locations: PathLocation[];
  startLatitude: number;
  startLongitude: number;
  endLatitude: number;
  endLongitude: number;
  createdAt: Timestamp;
}

export interface PathPerformance {
  distance: number;
  averageSpeed: number;
  peakSpeed: number;
}

export interface PathWeather {
  temperature: number;
  humidity: number;
  windSpeed: number;
}
const MAX_DISTANCE = 50; // meters

/**
 * Calculates the distance between two coordinates.
 * @param {PathLocation} c1 - The first coordinate.
 * @param {PathLocation} c2 - The second coordinate.
 * @return {number} The distance in meters.
 */
export function distance(c1: PathLocation, c2: PathLocation): number {
  const R = 6371e3; // metres
  const φ1 = c1.latitude * Math.PI / 180; // φ, λ in radians
  const φ2 = c2.latitude * Math.PI / 180;
  const Δφ = (c2.latitude - c1.latitude) * Math.PI / 180;
  const Δλ = (c2.longitude - c1.longitude) * Math.PI / 180;

  const a = Math.sin(Δφ / 2) * Math.sin(Δφ / 2) +
            Math.cos(φ1) * Math.cos(φ2) *
            Math.sin(Δλ / 2) * Math.sin(Δλ / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

  return R * c;
}

/**
 * Checks if two paths are similar.
 * @param {PathLocation[]} pathA - The first path.
 * @param {PathLocation[]} pathB - The second path.
 * @return {boolean} True if similar, false otherwise.
 */
export function areSimilar(pathA: PathLocation[], pathB: PathLocation[]): boolean {
  if (pathA.length === 0 || pathB.length === 0) return false;

  // Quick check on start and end points
  const startDist = distance(pathA[0], pathB[0]);
  const endDist = distance(pathA[pathA.length - 1], pathB[pathB.length - 1]);

  if (startDist > MAX_DISTANCE || endDist > MAX_DISTANCE) return false;

  // Simple sampling check for now to improve performance
  // over checking every point. Checks 10 points along the path
  const steps = 10;
  for (let i = 0; i <= steps; i++) {
    const idxA = Math.floor(i * (pathA.length - 1) / steps);
    const idxB = Math.floor(i * (pathB.length - 1) / steps);
    if (distance(pathA[idxA], pathB[idxB]) > MAX_DISTANCE * 2) {
      return false;
    }
  }

  return true;
}

/**
 * Finds a matching path in the database.
 * @param {PathLocation[]} locations - The path locations to check.
 * @return {Promise<string | null>} The ID of the matching path, or null.
 */
export async function findMatchingPath(
  locations: PathLocation[]
): Promise<string | null> {
  if (locations.length < 2) return null;

  const start = locations[0];
  const end = locations[locations.length - 1];
  const range = 0.002; // approx 200m

  // Query by start location proximity to narrow down candidates
  const snapshot = await admin.firestore().collection(COLLECTIONS.PATHS)
    .where("startLatitude", ">=", start.latitude - range)
    .where("startLatitude", "<=", start.latitude + range)
    .get();

  for (const doc of snapshot.docs) {
    const path = doc.data() as Path;

    // Filter by start/end longitude and end latitude strictly in memory
    if (Math.abs(path.startLongitude - start.longitude) > range) continue;
    if (Math.abs(path.endLatitude - end.latitude) > range) continue;
    if (Math.abs(path.endLongitude - end.longitude) > range) continue;

    if (areSimilar(locations, path.locations)) {
      return doc.id;
    }
  }

  return null;
}

/**
 * Creates a new path in the database.
 * @param {PathLocation[]} locations - The path locations.
 * @return {Promise<string>} The new path ID.
 */
export async function createPath(locations: PathLocation[]): Promise<string> {
  if (locations.length < 2) {
    throw new HttpsError("invalid-argument", "Cannot create a path with fewer than 2 coordinates");
  }

  const start = locations[0];
  const end = locations[locations.length - 1];

  const pathData: Omit<Path, "id"> = {
    locations,
    startLatitude: start.latitude,
    startLongitude: start.longitude,
    endLatitude: end.latitude,
    endLongitude: end.longitude,
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    createdAt: FieldValue.serverTimestamp() as any,
  };

  const docRef = await admin.firestore()
    .collection(COLLECTIONS.PATHS)
    .add(pathData);
  return docRef.id;
}