import * as admin from 'firebase-admin';

import { HttpsError } from 'firebase-functions/https';
import * as userManager from '../userManager';


// Mock firebase-functions/params
jest.mock('firebase-functions/params', () => ({
  defineString: jest.fn().mockReturnValue({ value: jest.fn().mockReturnValue('test-value') }),
}));

// Mock nodemailer
jest.mock('nodemailer', () => ({
  createTransport: jest.fn().mockReturnValue({
    sendMail: jest.fn(),
  }),
}));

// Mock global fetch
global.fetch = jest.fn();

// Mock firebase-admin
jest.mock('firebase-admin', () => ({
  auth: jest.fn(),
  firestore: jest.fn(),
  initializeApp: jest.fn(),
}));

describe('userManager', () => {
  let mockAuth: any;
  let mockFirestore: any;
  let mockSendMail: any;

  beforeEach(() => {
    jest.clearAllMocks();

    mockAuth = {
      createUser: jest.fn(),
      createCustomToken: jest.fn(),
      getUserByEmail: jest.fn(),
      deleteUser: jest.fn(),
      getUsers: jest.fn(),
    };
    (admin.auth as unknown as jest.Mock).mockReturnValue(mockAuth);

    const mockCollection = jest.fn();
    mockFirestore = jest.fn(() => ({
      collection: mockCollection,
    }));
    // Assign statics
    mockFirestore.Timestamp = {
      fromMillis: jest.fn((ms) => ({ toMillis: () => ms })),
      now: jest.fn(() => ({ toMillis: () => Date.now() })),
    } as any;
    
    (admin.firestore as unknown as jest.Mock).mockImplementation(mockFirestore);
    // Also attach statics to the mock itself for direct access if needed
    (admin.firestore as any).Timestamp = mockFirestore.Timestamp;

    mockSendMail = jest.fn();
    (require('nodemailer').createTransport as jest.Mock).mockReturnValue({
        sendMail: mockSendMail,
    });
  });



describe('userManager', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  describe('createUser', () => {
    it('should create a user and return a custom token when email is verified', async () => {
      // Mock verify email check
      const mockDocGet = jest.fn().mockResolvedValue({
        exists: true,
        data: () => ({ code: '123456', expiresAt: { toMillis: () => Date.now() + 10000 } }),
      });
      const mockDocDelete = jest.fn();
      const mockCollectionFn = jest.fn().mockReturnValue({
        doc: jest.fn().mockReturnValue({
          get: mockDocGet,
          delete: mockDocDelete,
        }),
      });
      (admin.firestore as any).mockReturnValue({ collection: mockCollectionFn });

      mockAuth.createUser.mockResolvedValue({ uid: 'test-uid' });
      mockAuth.createCustomToken.mockResolvedValue('custom-token');

      const result = await userManager.createUser('test@example.com', 'password', 'Test User', '123456');

      expect(result).toBe('custom-token');
      expect(mockAuth.createUser).toHaveBeenCalledWith({
        displayName: 'Test User',
        email: 'test@example.com',
        emailVerified: true,
        password: 'password',
      });
      expect(mockDocDelete).toHaveBeenCalled();
    });

    it('should throw error if email is not verified', async () => {
      // Mock verify email check failure
       const mockDocGet = jest.fn().mockResolvedValue({
        exists: false,
      });
      const mockCollectionFn = jest.fn().mockReturnValue({
        doc: jest.fn().mockReturnValue({
          get: mockDocGet,
        }),
      });
      (admin.firestore as any).mockReturnValue({ collection: mockCollectionFn });

      await expect(userManager.createUser('test@example.com', 'password', 'Test User', '123456'))
        .rejects.toThrow(HttpsError);
    });
  });

  describe('checkUserExists', () => {
    it('should return true if user exists', async () => {
      mockAuth.getUsers.mockResolvedValue({ users: [{ uid: 'some-uid' }] });
      const exists = await userManager.checkUserExists('test@example.com');
      expect(exists).toBe(true);
    });

    it('should return false if user does not exist', async () => {
      mockAuth.getUsers.mockResolvedValue({ users: [] });
      const exists = await userManager.checkUserExists('test@example.com');
      expect(exists).toBe(false);
    });
  });

  describe('sendEmailVerificationCode', () => {
    it('should send an email and save code to firestore', async () => {
      const mockSet = jest.fn();
      const mockCollectionFn = jest.fn().mockReturnValue({
        doc: jest.fn().mockReturnValue({
          set: mockSet,
        }),
      });
      (admin.firestore as any).mockReturnValue({ collection: mockCollectionFn });
      mockSendMail.mockResolvedValue({});

      await userManager.sendEmailVerificationCode('test@example.com');

      expect(mockSet).toHaveBeenCalled();
      expect(mockSendMail).toHaveBeenCalled();
    });
  });

  describe('signIn', () => {
    it('should return custom token on successful sign in', async () => {
      (global.fetch as jest.Mock).mockResolvedValue({
        ok: true,
        json: async () => ({ localId: 'test-uid' }),
      });
      mockAuth.createCustomToken.mockResolvedValue('custom-token');

      const token = await userManager.signIn('test@example.com', 'password');
      expect(token).toBe('custom-token');
    });

    it('should throw HttpsError on failed sign in', async () => {
       (global.fetch as jest.Mock).mockResolvedValue({
        ok: false,
        json: async () => ({ error: { message: 'Auth failed' } }),
      });

       await expect(userManager.signIn('test@example.com', 'password'))
        .rejects.toThrow(HttpsError);
    });
  });

   describe('deleteUser', () => {
    it('should delete user given an email', async () => {
      mockAuth.getUserByEmail.mockResolvedValue({ uid: 'test-uid' });
      mockAuth.deleteUser.mockResolvedValue(undefined);

      await userManager.deleteUser('test@example.com');

      expect(mockAuth.getUserByEmail).toHaveBeenCalledWith('test@example.com');
      expect(mockAuth.deleteUser).toHaveBeenCalledWith('test-uid');
    });
  });
});
});

