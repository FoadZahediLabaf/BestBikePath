import * as admin from "firebase-admin";
import { COLLECTIONS } from "./collections";
import { HttpsError } from "firebase-functions/v2/https";
import * as turf from "@turf/turf";
import * as geofire from "geofire-common";

export interface PathLocation {
  latitude: number;
  longitude: number;
}

export interface Path {
  id: string;
  locations: PathLocation[];
}

export interface PathMetadata {
  startGeohash: string;
  startLatitude: number;
  startLongitude: number;
  endLatitude: number;
  endLongitude: number;
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
export function arePathsSimilar(
  pathA: PathLocation[],
  pathB: PathLocation[]
): boolean {
  if (pathA.length < 2 || pathB.length < 2) return false;

  // 1. Convert to LineString
  const lineA = turf.lineString(
    pathA.map((p) => [p.longitude, p.latitude])
  );
  // const lineB = turf.lineString(
  //   pathB.map((p) => [p.longitude, p.latitude])
  // );

  // 2. Create a 'tube' of 20 meters around path A
  // 0.02 km = 20 meters
  const bufferA = turf.buffer(lineA, 0.02, { units: "kilometers" });

  // 3. Check if points of B fall within the tube of A
  const pointsB = turf.points(
    pathB.map((p) => [p.longitude, p.latitude])
  );

  // If buffer creation failed, return false (should guard against undefined result)
  if (!bufferA) {
    return false;
  }

  const pointsWithin = turf.pointsWithinPolygon(pointsB, bufferA);

  // If 90% of points are inside, it's the same path
  return pointsWithin.features.length / pathB.length > 0.90;
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
  const range = 200; // 200m

  // https://firebase.google.com/docs/firestore/solutions/geoqueries
  const center: [number, number] = [start.latitude, start.longitude];
  // Each item in 'bounds' represents a startAt/endAt pair. We have to issue
  // a separate query for each pair. There can be up to 9 pairs of bounds
  // depending on overlap, but in most cases there are 4.
  const bounds = geofire.geohashQueryBounds(center, range);

  const promises = [];
  for (const b of bounds) {
    const q = admin.firestore().collection(COLLECTIONS.PATHS)
      .orderBy("startGeohash")
      .startAt(b[0])
      .endAt(b[1]);
    promises.push(q.get());
  }

  // Collect all the query results together into a single list
  const snapshots = await Promise.all(promises);

  const docs = snapshots.flatMap(snap => snap.docs);

  for (const doc of docs) {
    const path = { ...doc.data(), id: doc.id } as Path & PathMetadata;

    // Filter by start location distance (to remove geohash false positives)
    const startDistanceInKm = geofire.distanceBetween(
      [path.startLatitude, path.startLongitude],
      center
    );
    const startDistanceInM = startDistanceInKm * 1000;
    if (startDistanceInM > range) continue;

    // Filter by end location proximity
    const endDistanceInKm = geofire.distanceBetween(
      [path.endLatitude, path.endLongitude],
      [end.latitude, end.longitude]
    );
    const endDistanceInM = endDistanceInKm * 1000;
    if (endDistanceInM > range) continue;

    // Finally, check path similarity
    if (arePathsSimilar(locations, path.locations)) {
      return path.id;
    }
  }

  return null;
}

/**
 * Creates a new path in the database.
 * @param {Path} path - The path object excluding ID for creation context.
 * @return {Promise<void>}
 */
export async function savePath(path: Path): Promise<void> {
  if (path.locations.length < 2) {
    throw new HttpsError("invalid-argument",
      "Cannot create a path with fewer than 2 coordinates");
  }

  const start = path.locations[0];
  const end = path.locations[path.locations.length - 1];

  const hash = geofire.geohashForLocation([start.latitude, start.longitude]);

  const pathData: Omit<Path, "id"> & PathMetadata = {
    locations: path.locations,
    startGeohash: hash,
    startLatitude: start.latitude,
    startLongitude: start.longitude,
    endLatitude: end.latitude,
    endLongitude: end.longitude,
  };

  await admin.firestore()
    .collection(COLLECTIONS.PATHS)
    .doc(path.id)
    .set(pathData);
}
