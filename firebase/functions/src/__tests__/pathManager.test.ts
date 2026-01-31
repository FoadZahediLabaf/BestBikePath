
import * as pathManager from '../pathManager';
import { COLLECTIONS } from '../collections';
import * as admin from 'firebase-admin';
import { HttpsError } from 'firebase-functions/v2/https';

// Mock ESM modules
jest.mock('@turf/turf', () => ({
    lineString: jest.fn(),
    booleanContains: jest.fn(),
    buffer: jest.fn().mockReturnValue({}),
    points: jest.fn(),
    point: jest.fn(),
    pointsWithinPolygon: jest.fn().mockReturnValue({ features: [] }),
    featureCollection: jest.fn(),
}));
jest.mock('geofire-common', () => ({
    distanceBetween: jest.fn(),
    geohashQueryBounds: jest.fn().mockReturnValue([['s','e','n','w']]), // return one bound
    geohashForLocation: jest.fn(),
}));

// Mock firebase-admin
jest.mock('firebase-admin', () => ({
  firestore: jest.fn(),
  initializeApp: jest.fn(),
}));

// Mock setup for pathManager
describe('pathManager', () => {
  let mockCollection: jest.Mock;
  let mockDoc: jest.Mock;
  let mockSet: jest.Mock;
  let mockGet: jest.Mock;
  let mockDelete: jest.Mock;

  beforeEach(() => {
    jest.clearAllMocks();
    
    mockCollection = jest.fn();
    mockDoc = jest.fn();
    mockSet = jest.fn();
    mockGet = jest.fn();
    mockDelete = jest.fn();

    (admin.firestore as unknown as jest.Mock).mockReturnValue({
        collection: mockCollection,
    });
    
    // Reset default mock implementations
    mockCollection.mockReturnValue({
      doc: mockDoc,
      orderBy: jest.fn().mockReturnThis(),
      startAt: jest.fn().mockReturnThis(),
      endAt: jest.fn().mockReturnThis(),
      get: mockGet,
      where: jest.fn().mockReturnThis(),
    });
    
    mockDoc.mockReturnValue({
      set: mockSet,
      get: mockGet,
      delete: mockDelete,
    });
  });

  describe('distance', () => {
    it('should calculate distance correctly', () => {
      (require('geofire-common').distanceBetween as jest.Mock).mockReturnValue(1111.95);
      const p1 = { latitude: 0, longitude: 0 };
      const p2 = { latitude: 0.01, longitude: 0 }; // approx 1.11km
      const d = pathManager.distance(p1, p2);
      expect(d).toBeCloseTo(1112, 0);
    });
  });

  describe('arePathsSimilar', () => {
    it('should return true for identical paths', () => {
      (require('@turf/turf').booleanContains as jest.Mock).mockReturnValue(true);
      (require('@turf/turf').pointsWithinPolygon as jest.Mock).mockReturnValue({ features: [1,2] }); // 100% features inside (2/2)
      const pathA = [{ latitude: 0, longitude: 0 }, { latitude: 1, longitude: 1 }];
      const pathB = [{ latitude: 0, longitude: 0 }, { latitude: 1, longitude: 1 }];
      expect(pathManager.arePathsSimilar(pathA, pathB)).toBe(true);
    });

    it('should return false for very different paths', () => {
       (require('@turf/turf').booleanContains as jest.Mock).mockReturnValue(false);
       (require('@turf/turf').pointsWithinPolygon as jest.Mock).mockReturnValue({ features: [] });
       const pathA = [{ latitude: 0, longitude: 0 }, { latitude: 1, longitude: 1 }];
       const pathB = [{ latitude: 10, longitude: 10 }, { latitude: 11, longitude: 11 }];
       expect(pathManager.arePathsSimilar(pathA, pathB)).toBe(false);
    });
  });

  describe('savePath', () => {
    it('should save path to firestore', async () => {
      const path = {
        id: 'path1',
        locations: [
          { latitude: 0, longitude: 0 },
          { latitude: 1, longitude: 1 },
        ],
      };

      await pathManager.savePath(path);

      expect(mockCollection).toHaveBeenCalledWith(COLLECTIONS.PATHS);
      expect(mockDoc).toHaveBeenCalledWith('path1');
      expect(mockSet).toHaveBeenCalledWith(expect.objectContaining({
        locations: path.locations,
        originLatitude: 0,
        destinationLatitude: 1,
      }));
    });

    it('should throw error for path with < 2 points', async () => {
      const path = {
        id: 'path1',
        locations: [{ latitude: 0, longitude: 0 }],
      };
      await expect(pathManager.savePath(path)).rejects.toThrow(HttpsError);
    });
  });
  
  describe('getSimilarPath', () => {
    it('should return null if no similar path found', async () => {
        // Mock empty result from getConnectingPaths logic (which calls firestore)
        mockGet.mockResolvedValue({ docs: [], empty: true });
        
        const path = [{ latitude: 0, longitude: 0 }, { latitude: 1, longitude: 1 }];
        const result = await pathManager.getSimilarPath(path);
        
        expect(result).toBeNull();
    });

    // More complex test with mocked data returning from firestore would be good
    it('should return path if similar path found', async () => {
      const existingPath = {
          id: 'existing',
          locations: [{ latitude: 0, longitude: 0 }, { latitude: 1, longitude: 1 }],
          originLatitude: 0, originLongitude: 0,
          destinationLatitude: 1, destinationLongitude: 1,
          originGeohash: 's000', destinationGeohash: 's001'
      };

      // Mock query returns
      mockGet.mockResolvedValue({
          docs: [
              {
                  id: 'existing',
                  data: () => existingPath
              }
          ]
      });

      const inputPath = [{ latitude: 0, longitude: 0 }, { latitude: 1, longitude: 1 }];
     
      // Since logic heavily depends on geofire querying boundaries, expecting a match might be tricky if I don't mock geofire exactly or ensure mocked data passes filters.
      // But given I mocked get() to return a doc, getConnectingPaths will filter it.
      // 0 distance means it passes filters.
      (require('@turf/turf').booleanContains as jest.Mock).mockReturnValue(true);
      (require('geofire-common').distanceBetween as jest.Mock).mockReturnValue(0);
      (require('@turf/turf').pointsWithinPolygon as jest.Mock).mockReturnValue({ features: [1, 2, 3] }); // length > 0.9 * 2 (path length)
      
      const result = await pathManager.getSimilarPath(inputPath);
      expect(result).not.toBeNull();
      expect(result?.id).toBe('existing');
    });
  });
});
