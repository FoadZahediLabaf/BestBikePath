
export interface Coordinate {
  lat: number;
  lng: number;
}

 export interface Path {
  streets: string[];
  coordinates: any[];
  status: number;
  createdAt: number;
}

export interface CommunityPath {
  coordinates: any[];
  status: number;
}


const MAX_DISTANCE = 50; //meters

export function filterPaths(paths: Path[], start: Coordinate, end: Coordinate): Path[]{
    const maxDis = 0.001; 
    return paths.filter(p => {
    const startDiff = Math.hypot(p.coordinates[0].lat - start.lat, p.coordinates[0].lng - start.lng);
    const endDiff = Math.hypot(p.coordinates[p.coordinates.length - 1].lat - end.lat, p.coordinates[p.coordinates.length - 1].lng - end.lng);
    return startDiff < maxDis && endDiff < maxDis;
    });
}

export function rankWeight(index: number, max: number): number {
  const minWeight = 0.3;   //how much the oldest still counts
  const t = index / (max - 1);
  return 1 - t * (1 - minWeight);
}

export function distance(c1: Coordinate, c2: Coordinate): number {
  const latDistance = 111000 * (c2.lat - c1.lat);
  const lngDistance = 111000 * Math.cos(c1.lat * Math.PI / 180) * (c2.lng - c1.lng);
  return Math.sqrt(latDistance ** 2 + lngDistance ** 2);
}

export function areSimilar(pathA: Coordinate[], pathB: Coordinate[]): boolean {
  let i = 0, j = 0, diffCount = 0;
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

  //similar if the number of points that are different is less than 1%
  return diffCount / totalPoints <= 0.01; 

}