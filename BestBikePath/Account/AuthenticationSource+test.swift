extension AuthenticationSource where Self == TestAuthenticationSource {

    static var test: TestAuthenticationSource {
        TestAuthenticationSource()
    }
}

struct TestAuthenticationSource: AuthenticationSource {

    @propertyWrapper
    class Box<V> {
        var wrappedValue: V

        init(wrappedValue: V) {
            self.wrappedValue = wrappedValue
        }
    }

    @Box var isAuthenticated: Bool = false

    func userExists(email: String) async throws -> Bool {
        try await Task.sleep(for: .seconds(0.5))
        return true
    }

    func createUser(email: String, password: String) async throws {
        try await Task.sleep(for: .seconds(0.5))
        isAuthenticated = true
    }

    func deleteUser(email: String) async throws {
        try await Task.sleep(for: .seconds(0.5))
        isAuthenticated = false
    }

    func signIn(email: String, password: String) async throws {
        try await Task.sleep(for: .seconds(0.5))
        isAuthenticated = false
    }

    func signOut() async throws {
        try await Task.sleep(for: .seconds(0.5))
        isAuthenticated = false
    }
}
