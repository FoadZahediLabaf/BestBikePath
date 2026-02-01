import * as admin from "firebase-admin";
import { Timestamp } from "firebase-admin/firestore";

import * as communityPathManager from "../communityPathManager";


// Mock pathManager
jest.mock("../pathManager", () => ({
  getConnectingPaths: jest.fn(),
}));

// Mock firebase-admin
jest.mock("firebase-admin", () => ({
  firestore: jest.fn(),
}));

describe("communityPathManager", () => {
  let mockCollection: jest.Mock;
  let mockWhere: jest.Mock;
  let mockGet: jest.Mock;
  let mockQuery: any;

  beforeEach(() => {
    jest.clearAllMocks();

    mockCollection = jest.fn();
    mockWhere = jest.fn();
    mockGet = jest.fn();
    mockQuery = {
      where: mockWhere,
      get: mockGet,
    };

    const mockFirestore = jest.fn(() => ({
      collection: mockCollection,
    }));
    (mockFirestore as any).Timestamp = {
      now: jest.fn(() => ({ toMillis: () => Date.now(), toDate: () => new Date() })),
      fromDate: jest.fn((date) => ({ toMillis: () => date.getTime(), toDate: () => date })),
    };

    (admin.firestore as unknown as jest.Mock).mockImplementation(mockFirestore);
    (admin.firestore as any).Timestamp = (mockFirestore as any).Timestamp;

    mockCollection.mockReturnValue(mockQuery);
    mockWhere.mockReturnValue(mockQuery);
  });

  describe("getCommunityPaths", () => {
    it("should return community paths with calculated status", async () => {
      // Mock connecting paths
      (require("../pathManager").getConnectingPaths as jest.Mock).mockResolvedValue([
        { id: "path1", locations: [], originGeohash: "abc", destinationGeohash: "def" },
      ]);

      // Mock user paths reviews
      const now = new Date();
      const validUserPath = {
        id: "up1", userId: "u1", isPublic: true, pathId: "path1",
        status: 5,
        date: { toDate: () => now, toMillis: () => now.getTime() } as Timestamp,
      };

      mockGet.mockResolvedValue({
        docs: [
          { data: () => validUserPath, id: "up1" },
        ],
      });

      const origin = { latitude: 0, longitude: 0 };
      const dest = { latitude: 1, longitude: 1 };

      const result = await communityPathManager.getCommunityPaths(origin, dest);

      expect(result).toHaveLength(1);
      expect(result[0].id).toBe("path1");
      expect(result[0].status).toBe(5);
    });

    it("should sort paths by status descending", async () => {
      (require("../pathManager").getConnectingPaths as jest.Mock).mockResolvedValue([
        { id: "path1" }, { id: "path2" },
      ]);

      // path1 -> status 3
      // path2 -> status 5

      // We need to mock different returns for different paths.
      // But collection().where().get() is called in a loop.
      // mockWhere is called with 'pathId' == 'path1' then 'path2'

      mockWhere.mockImplementation((field, op, value) => {
        const common = { id: "x", userId: "u", isPublic: true, pathId: value, date: { toDate: () => new Date() } };

        if (field === "pathId") {
          const currentPathId = value;
          // Return an object that has a .where() for the next link in the chain
          return {
            where: jest.fn((field2, op2, value2) => {
              if (field2 === "isPublic" && value2 === true) {
                if (currentPathId === "path1") {
                  return {
                    get: jest.fn().mockResolvedValue({
                      docs: [{ data: () => ({ ...common, status: 3 }), id: "up1" }],
                    }),
                  };
                }
                if (currentPathId === "path2") {
                  return {
                    get: jest.fn().mockResolvedValue({
                      docs: [{ data: () => ({ ...common, status: 5 }), id: "up2" }],
                    }),
                  };
                }
              }
              return { get: jest.fn().mockResolvedValue({ docs: [] }) };
            }),
          };
        }
        return {
          get: jest.fn().mockResolvedValue({ docs: [] }),
          where: jest.fn().mockReturnThis(),
        };
      });

      const result = await communityPathManager.getCommunityPaths(
        { latitude: 0, longitude: 0 },
        { latitude: 1, longitude: 1 }
      );

      expect(result).toHaveLength(2);
      expect(result[0].id).toBe("path2"); // 5
      expect(result[1].id).toBe("path1"); // 3
    });

    it("should exclude paths with no public reports", async () => {
      (require("../pathManager").getConnectingPaths as jest.Mock).mockResolvedValue([
        { id: "path1" }, { id: "path2" },
      ]);

      mockWhere.mockImplementation((field, op, value) => {
        const common = { id: "x", userId: "u", isPublic: true, pathId: value, date: { toDate: () => new Date() } };

        if (field === "pathId") {
          const currentPathId = value;
          return {
            where: jest.fn((field2, op2, value2) => {
              if (field2 === "isPublic" && value2 === true) {
                // path1 has reports
                if (currentPathId === "path1") {
                  return {
                    get: jest.fn().mockResolvedValue({
                      empty: false,
                      docs: [{ data: () => ({ ...common, status: 5 }), id: "up1" }],
                    }),
                  };
                }
                // path2 has NO reports (empty)
                if (currentPathId === "path2") {
                  return {
                    get: jest.fn().mockResolvedValue({
                      empty: true,
                      docs: [],
                    }),
                  };
                }
              }
              return { get: jest.fn().mockResolvedValue({ empty: true, docs: [] }) };
            }),
          };
        }
        return {
          get: jest.fn().mockResolvedValue({ empty: true, docs: [] }),
          where: jest.fn().mockReturnThis(),
        };
      });

      const result = await communityPathManager.getCommunityPaths(
        { latitude: 0, longitude: 0 },
        { latitude: 1, longitude: 1 }
      );

      expect(result).toHaveLength(1);
      expect(result[0].id).toBe("path1");
    });
  });

  // ITD: T1
  describe("calculateCommunityPathStatus", () => {
    it("should return 0 if no valid reports", () => {
      const result = communityPathManager.calculateCommunityPathStatus([]);
      expect(result).toBe(0);
    });

    it("should aggregate votes correctly", () => {
      const now = new Date();
      const reports = [
        { status: 5, date: { toDate: () => now } as Timestamp, pathId: "p1", id: "1", userId: "u1", isPublic: true },
        { status: 5, date: { toDate: () => now } as Timestamp, pathId: "p2", id: "2", userId: "u2", isPublic: true },
        { status: 1, date: { toDate: () => now } as Timestamp, pathId: "p3", id: "3", userId: "u3", isPublic: true },
      ];
      const result = communityPathManager.calculateCommunityPathStatus(reports);
      expect(result).toBe(5);
    });

    it("should ignore old reports", () => {
      const now = new Date();
      const oldDate = new Date(now.getTime() - (400 * 24 * 60 * 60 * 1000)); // 400 days ago
      const reports = [
        { status: 5, date: { toDate: () => now } as Timestamp, pathId: "p1", id: "1", userId: "u1", isPublic: true },
        { status: 1, date: { toDate: () => oldDate } as Timestamp, pathId: "p2", id: "2", userId: "u2", isPublic: true },
        { status: 1, date: { toDate: () => oldDate } as Timestamp, pathId: "p3", id: "3", userId: "u3", isPublic: true },
      ];

      // Only the fresh 5 counts
      const result = communityPathManager.calculateCommunityPathStatus(reports);
      expect(result).toBe(5);
    });

    it("should average winners in case of a tie", () => {
      const now = new Date();
      const reports = [
        { status: 5, date: { toDate: () => now } as Timestamp, pathId: "p1", id: "1", userId: "u1", isPublic: true },
        { status: 5, date: { toDate: () => now } as Timestamp, pathId: "p1", id: "2", userId: "u2", isPublic: true },
        { status: 1, date: { toDate: () => now } as Timestamp, pathId: "p1", id: "3", userId: "u3", isPublic: true },
        { status: 1, date: { toDate: () => now } as Timestamp, pathId: "p1", id: "4", userId: "u4", isPublic: true },
      ];
        // 2 votes for 5, 2 votes for 1. Max votes = 2. Winners = [1, 5].
        // Average = (1+5)/2 = 3.
      const result = communityPathManager.calculateCommunityPathStatus(reports);
      expect(result).toBe(3);
    });
  });
});
