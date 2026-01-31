const functionsTest = require('firebase-functions-test');

// Mock ESM modules
jest.mock('@turf/turf', () => ({}));
jest.mock('geofire-common', () => ({}));

// Initialize test environment
const testEnv = functionsTest();

// Mock dependencies
jest.mock('firebase-admin', () => ({
  initializeApp: jest.fn(),
  firestore: jest.fn(),
  auth: jest.fn(),
}));
jest.mock('../userManager');
jest.mock('../userPathManager');
jest.mock('../communityPathManager');

import * as triggers from '../index';
import * as userManager from '../userManager';
import * as userPathManager from '../userPathManager';
import * as communityPathManager from '../communityPathManager';

describe('functions triggers', () => {
    afterAll(() => {
        testEnv.cleanup();
    });

    describe('createUser', () => {
        it('should call userManager.createUser', async () => {
            const wrapped = testEnv.wrap(triggers.createUser);
            const data = { email: 'e', password: 'p', displayName: 'n', emailVerificationCode: 'c' };
            
            (userManager.createUser as jest.Mock).mockResolvedValue('token');
            
            const result = await wrapped({ data });
            
            expect(userManager.createUser).toHaveBeenCalledWith('e', 'p', 'n', 'c');
            expect(result).toBe('token');
        });
    });

    describe('getCommunityPaths', () => {
        it('should call communityPathManager.getCommunityPaths', async () => {
             const wrapped = testEnv.wrap(triggers.getCommunityPaths);
             const data = { origin: 'o', destination: 'd' };
             
             (communityPathManager.getCommunityPaths as jest.Mock).mockResolvedValue([]);
             
             await wrapped({ data });
             
             expect(communityPathManager.getCommunityPaths).toHaveBeenCalledWith('o', 'd');
        });
    });

    describe('saveUserPath', () => {
        it('should call userPathManager.saveUserPath', async () => {
            const wrapped = testEnv.wrap(triggers.saveUserPath);
            const data = { userId: 'u1' };
            const auth = { uid: 'u1' };
            
            await wrapped({ data, auth });
            
            expect(userPathManager.saveUserPath).toHaveBeenCalled();
        });

        it('should throw if unauthenticated', async () => {
             const wrapped = testEnv.wrap(triggers.saveUserPath);
             const data = {};
             // no auth context
             
             await expect(wrapped({ data })).rejects.toThrow('The user must be authenticated');
        });
    });
});
