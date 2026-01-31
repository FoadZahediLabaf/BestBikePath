extension UserSource where Self == TestUserSource {

    static var test: TestUserSource {
        TestUserSource()
    }
}

struct TestUserSource: UserSource {

    @propertyWrapper
    class Box<V> {
        var wrappedValue: V

        init(wrappedValue: V) {
            self.wrappedValue = wrappedValue
        }
    }

    @Box var currentUser: User?

    var currentUserStream: AsyncStream<User?> {
        AsyncStream {
            try? await Task.sleep(for: .seconds(10*60))
            return self.currentUser
        }
    }

    func checkUserExists(email: String) async throws -> Bool {
        try await Task.sleep(for: .seconds(0.5))
        return true
    }

    func sendEmailVerificationCode(email: String) async throws {
        try await Task.sleep(for: .seconds(0.5))
    }

    func checkEmailVerificationCode(email: String, code: String) async throws -> Bool {
        try await Task.sleep(for: .seconds(0.5))
        return true
    }

    func createUser(email: String, password: String, displayName: String, emailVerificationCode: String) async throws {
        try await Task.sleep(for: .seconds(0.5))
        currentUser = .test
    }

    func deleteUser(email: String) async throws {
        try await Task.sleep(for: .seconds(0.5))
        currentUser = nil
    }

    func signIn(email: String, password: String) async throws {
        try await Task.sleep(for: .seconds(0.5))
        currentUser = .test
    }

    func signOut() async throws {
        try await Task.sleep(for: .seconds(0.5))
        currentUser = nil
    }
}
