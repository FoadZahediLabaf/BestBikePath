
import * as userPathManager from "../userPathManager";
import { HttpsError } from "firebase-functions/v2/https";
import * as pathManager from "../pathManager";


// Mock pathManager
jest.mock("../pathManager", () => ({
  getSimilarPath: jest.fn(),
  savePath: jest.fn(),
}));

// Mock firebase-admin
jest.mock("firebase-admin", () => {
  return {
    firestore: jest.fn(),
    initializeApp: jest.fn(),
  };
});

// Mock ESM modules to avoid syntax errors
jest.mock("@turf/turf", () => ({}));
jest.mock("geofire-common", () => ({}));

// Mock firebase-admin
// Mock Timestamp class inside factory to avoid hoisting issues
jest.mock("firebase-admin/firestore", () => {
  class MockTimestamp {
    seconds: number;
    nanoseconds: number;
    constructor(seconds: number, nanoseconds: number) {
      this.seconds = seconds;
      this.nanoseconds = nanoseconds;
    }
    toMillis() {
      return Date.now();
    }
    toDate() {
      return new Date();
    }
    static now() {
      return new MockTimestamp(0, 0);
    }
    static fromDate(d: Date) {
      return new MockTimestamp(0, 0);
    }
    static fromMillis(ms: number) {
      return new MockTimestamp(0, 0);
    }
  }
  return {
    FieldValue: { serverTimestamp: jest.fn() },
    Timestamp: MockTimestamp,
  };
});

describe("userPathManager", () => {
  let mockCollection: jest.Mock;
  let mockDoc: jest.Mock;
  let mockSet: jest.Mock;
  let mockGet: jest.Mock;
  let mockUpdate: jest.Mock;
  let mockDelete: jest.Mock;
  let mockWhere: jest.Mock;
  let mockLimit: jest.Mock;

  beforeEach(() => {
    jest.clearAllMocks();

    mockCollection = jest.fn();
    mockDoc = jest.fn();
    mockSet = jest.fn();
    mockGet = jest.fn();
    mockUpdate = jest.fn();
    mockDelete = jest.fn();
    mockWhere = jest.fn();
    mockLimit = jest.fn();

    const mockFirestoreFn = jest.fn(() => ({
      collection: mockCollection,
    }));
    (mockFirestoreFn as any).Timestamp = (require("firebase-admin/firestore").Timestamp);
    (require("firebase-admin").firestore as jest.Mock).mockImplementation(mockFirestoreFn);

    mockCollection.mockReturnValue({
      doc: mockDoc,
      where: mockWhere,
    });
    mockDoc.mockReturnValue({
      set: mockSet,
      get: mockGet,
      update: mockUpdate,
      delete: mockDelete,
    });
    mockWhere.mockReturnValue({
      get: mockGet,
      limit: mockLimit,
    });
    mockLimit.mockReturnValue({
      get: mockGet,
    });
  });

  describe("saveUserPath", () => {
    it("should save user path and link to existing path if found", async () => {
      (pathManager.getSimilarPath as jest.Mock).mockResolvedValue({ id: "existing-path-id" });

      const userPath: any = {
        id: "up1",
        userId: "user1",
        status: 5,
        path: { locations: [{}, {}] }, // 2 locations
        date: new Date(),
        isPublic: true,
      };

      await userPathManager.saveUserPath(userPath);

      expect(mockSet).toHaveBeenCalledWith(expect.objectContaining({
        pathId: "existing-path-id",
        userId: "user1",
      }));
      expect(pathManager.savePath).not.toHaveBeenCalled();
    });

    it("should create new path if no similar path found", async () => {
      (pathManager.getSimilarPath as jest.Mock).mockResolvedValue(null);

      const userPath: any = {
        id: "up1",
        userId: "user1",
        status: 5,
        path: { id: "new-p-id", locations: [{}, {}] },
        date: new Date(),
        isPublic: true,
      };

      await userPathManager.saveUserPath(userPath);

      expect(pathManager.savePath).toHaveBeenCalledWith(userPath.path);
      expect(mockSet).toHaveBeenCalledWith(expect.objectContaining({
        pathId: "new-p-id",
      }));
    });
  });

  describe("getUserPaths", () => {
    it("should return user paths", async () => {
      const now = new Date();
      const mockUserPathData = {
        userId: "user1",
        pathId: "p1",
        status: 5,
        isPublic: true,
        date: { toDate: () => now },
      };
      const mockPathData = {
        locations: [],
      };

      // Mock user paths query
      mockGet.mockResolvedValueOnce({
        docs: [{
          id: "up1",
          data: () => mockUserPathData,
        }],
      });

      // Mock path doc fetch inside loop
      // first call was where(), second call is doc(id).get()
      // Using logic based on call order is risky if impl changes order.
      // Better to mock implementation based on collection name.

      mockCollection.mockImplementation((name) => {
        if (name === "user_paths") {
          return {
            where: jest.fn().mockReturnValue({
              get: jest.fn().mockResolvedValue({
                docs: [{ id: "up1", data: () => mockUserPathData }],
              }),
            }),
          };
        }
        if (name === "paths") {
          return {
            doc: jest.fn().mockReturnValue({
              get: jest.fn().mockResolvedValue({
                exists: true,
                data: () => mockPathData,
              }),
            }),
          };
        }
        return {};
      });

      const result = await userPathManager.getUserPaths("user1", "user1");
      expect(result).toHaveLength(1);
      expect(result[0].id).toBe("up1");
    });
  });

  describe("updateUserPathStatus", () => {
    it("should update status if owner", async () => {
      mockGet.mockResolvedValue({
        exists: true,
        data: () => ({ userId: "user1" }),
      });

      await userPathManager.updateUserPathStatus("up1", "user1", 3);

      expect(mockUpdate).toHaveBeenCalledWith(expect.objectContaining({
        status: 3,
      }));
    });

    it("should throw error if not owner", async () => {
      mockGet.mockResolvedValue({
        exists: true,
        data: () => ({ userId: "other" }),
      });

      await expect(userPathManager.updateUserPathStatus("up1", "user1", 3))
        .rejects.toThrow(HttpsError);
    });
  });

  describe("deleteUserPath", () => {
    it("should delete user path and cleanup orphan path", async () => {
      mockGet.mockResolvedValueOnce({
        exists: true,
        data: () => ({ userId: "user1", pathId: "p1" }),
      });

      // Mock check for other references -> empty
      mockLimit.mockReturnValue({
        get: jest.fn().mockResolvedValue({ empty: true }),
      });

      // Mock delete path doc
      const mockPathDelete = jest.fn();
      mockCollection.mockImplementation((name) => {
        if (name === "paths") {
          return {
            doc: jest.fn().mockReturnValue({
              delete: mockPathDelete,
            }),
          };
        }
        return { // Fallback for other collections
          doc: mockDoc,
          where: mockWhere,
        };
      });

      await userPathManager.deleteUserPath("up1", "user1");

      expect(mockDelete).toHaveBeenCalled(); // user path delete
      expect(mockPathDelete).toHaveBeenCalled(); // path delete (orphan)
    });
  });
});
