protocol UserPathSource {

    func saveUserPath(_ path: UserPath) async throws

    func getUserPaths(userID: User.ID) async throws -> [UserPath]

    func updateUserPathPrivacy(id: UserPath.ID, isPublic: Bool) async throws

    func updateUserPathStatus(id: UserPath.ID, status: PathStatus) async throws

    func deleteUserPath(id: UserPath.ID) async throws
}
