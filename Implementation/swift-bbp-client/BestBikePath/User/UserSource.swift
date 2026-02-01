protocol UserSource {

    var currentUser: User? { get }

    var currentUserStream: AsyncStream<User?> { get }

    func checkUserExists(email: String) async  throws -> Bool

    func sendEmailVerificationCode(email: String) async  throws

    func checkEmailVerificationCode(email: String, code: String) async  throws -> Bool

    func createUser(email: String, password: String, displayName: String, emailVerificationCode: String) async throws

    func deleteUser(email: String) async throws

    func signIn(email: String, password: String) async throws

    func signOut() async throws
}
