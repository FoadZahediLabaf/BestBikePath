protocol AuthenticationSource {

    var isAuthenticated: Bool { get }

    func userExists(email: String) async  throws -> Bool

    func createUser(email: String, password: String) async throws

    func deleteUser(email: String) async throws

    func signIn(email: String, password: String) async throws

    func signOut() async throws
}
