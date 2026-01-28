
export interface Coordinate {
  lat: number;
  lng: number;
}

export interface Path {
  streets: string[];
  coordinates: Coordinate[];
  status: number;
  createdAt: number;
}

export interface CommunityPath {
  coordinates: Coordinate[];
  status: number;
}


const MAX_DISTANCE = 50; // meters

/**
 * Filters paths based on start and end coordinates.
 * @param {Path[]} paths - The list of paths to filter.
 * @param {Coordinate} start - The start coordinate.
 * @param {Coordinate} end - The end coordinate.
 * @return {Path[]} The filtered paths.
 */
export function filterPaths(
  paths: Path[],
  start: Coordinate,
  end: Coordinate
): Path[] {
  const maxDis = 0.001;
  return paths.filter((p) => {
    const startDiff = Math.hypot(
      p.coordinates[0].lat - start.lat,
      p.coordinates[0].lng - start.lng
    );
    const endDiff = Math.hypot(
      p.coordinates[p.coordinates.length - 1].lat - end.lat,
      p.coordinates[p.coordinates.length - 1].lng - end.lng
    );
    return startDiff < maxDis && endDiff < maxDis;
  });
}

/**
 * Calculates the rank weight based on index.
 * @param {number} index - The index.
 * @param {number} max - The maximum value.
 * @return {number} The calculated weight.
 */
export function rankWeight(index: number, max: number): number {
  const minWeight = 0.3; // how much the oldest still counts
  const t = index / (max - 1);
  return 1 - t * (1 - minWeight);
}

/**
 * Calculates the distance between two coordinates.
 * @param {Coordinate} c1 - The first coordinate.
 * @param {Coordinate} c2 - The second coordinate.
 * @return {number} The distance in meters.
 */
export function distance(c1: Coordinate, c2: Coordinate): number {
  const latDistance = 111000 * (c2.lat - c1.lat);
  const lngDistance = 111000 * Math.cos(c1.lat * Math.PI / 180) *
    (c2.lng - c1.lng);
  return Math.sqrt(latDistance ** 2 + lngDistance ** 2);
}

/**
 * Checks if two paths are similar.
 * @param {Coordinate[]} pathA - The first path.
 * @param {Coordinate[]} pathB - The second path.
 * @return {boolean} True if similar, false otherwise.
 */
export function areSimilar(pathA: Coordinate[], pathB: Coordinate[]): boolean {
  let i = 0; let j = 0; let diffCount = 0;
  const totalPoints = Math.max(pathA.length, pathB.length);

  while (i < pathA.length && j < pathB.length) {
    const d = distance(pathA[i], pathB[j]);
    if (d <= MAX_DISTANCE) {
      i++;
      j++;
    } else if (i + 1 < pathA.length && distance(pathA[i + 1], pathB[j]) < d) {
      i++;
    } else if (j + 1 < pathB.length && distance(pathA[i], pathB[j + 1]) < d) {
      j++;
    } else {
      diffCount++;
      i++;
      j++;
    }
  }

  // count remaining unmatched points
  diffCount += (pathA.length - i) + (pathB.length - j);

  // similar if the number of points that are different is less than 1%
  return diffCount / totalPoints <= 0.01;
}
