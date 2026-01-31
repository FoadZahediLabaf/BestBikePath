import FirebaseFunctions
import FirebaseSharedSwift
import FirebaseAuth

extension UserSource where Self == FirebaseUserSource {

    static var firebase: FirebaseUserSource {
        FirebaseUserSource()
    }
}

struct FirebaseUserSource: UserSource {

    private var auth: Auth {
        Auth.auth()
    }

    private var functions: Functions {
        Functions.functions()
    }

    var currentUser: User? {
        if
            let id = auth.currentUser?.uid,
            let email = auth.currentUser?.email,
            let displayName = auth.currentUser?.displayName
        {
            User(
                id: id,
                displayName: displayName,
                email: email
            )
        } else {
            nil
        }
    }

    var currentUserStream: AsyncStream<User?> {
        let auth = auth

        return AsyncStream { continuation in
            let listenerHandle = auth.addStateDidChangeListener { auth, user in
                if
                    let id = user?.uid,
                    let email = user?.email,
                    let displayName = user?.displayName
                {

                    let user = User(
                        id: id,
                        displayName: displayName,
                        email: email
                    )
                    continuation.yield(user)

                } else {
                    continuation.yield(nil)
                }
            }
            continuation.onTermination = { termination in
                auth.removeStateDidChangeListener(listenerHandle)
            }
        }
    }

    func checkUserExists(email: String) async throws -> Bool {
        struct Request: Encodable {
            let email: String
        }
        typealias Response = Bool

        let request = Request(email: email)
        return try await call("checkUserExists", request)
    }

    func sendEmailVerificationCode(email: String) async throws {
        struct Request: Encodable {
            let email: String
        }
        struct Response: Decodable {}

        let request = Request(email: email)
        try await call("sendEmailVerificationCode", request)
    }

    func checkEmailVerificationCode(email: String, code: String) async throws -> Bool {
        struct Request: Encodable {
            let email: String
            let code: String
        }
        typealias Response = Bool

        let request = Request(email: email, code: code)
        return try await call("checkEmailVerificationCode", request)
    }

    func createUser(email: String, password: String, displayName: String, emailVerificationCode: String) async throws {
        struct Request: Encodable {
            let email: String
            let password: String
            let displayName: String
            let emailVerificationCode: String
        }
        typealias Response = String

        let request = Request(email: email, password: password, displayName: displayName, emailVerificationCode: emailVerificationCode)
        let customToken: Response = try await call("createUser", request)
        try await auth.signIn(withCustomToken: customToken)
    }

    func deleteUser(email: String) async throws {
        struct Request: Encodable {
            let email: String
        }
        struct Response: Decodable {}

        let request = Request(email: email)
        try await call("deleteUser", request)
        try auth.signOut()
    }

    func signIn(email: String, password: String) async throws {
        try await auth.signIn(withEmail: email, password: password)
    }

    func signOut() async throws {
        try auth.signOut()
    }
}

extension FirebaseUserSource {
    struct InvalidEmail: LocalizedError {
        var errorDescription: String? {
            "Please enter a valid email address."
        }

        var failureReason: String? {
            "The email address doesn’t match the required format."
        }
    }
    private static let encoder = {
        let encoder = FirebaseDataEncoder()
        encoder.dateEncodingStrategy = .millisecondsSince1970
        return encoder
    }()

    private static let decoder = {
        let decoder = FirebaseDataDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970
        return decoder
    }()

    private func call<Request: Encodable, Response: Decodable>(_ name: String, _ request: Request) async throws -> Response {
        let requestData = try Self.encoder.encode(request)
        let function = functions.httpsCallable(name)
        let responseData = try await mapErrors { try await function.call(requestData).data }
        return try Self.decoder.decode(Response.self, from: responseData)
    }

    struct VoidResponse: Decodable {}
    private func call<Request: Encodable>(_ name: String, _ request: Request) async throws {
        _ = try await call(name, request) as VoidResponse
    }

    func mapErrors<O>(_ handler: () async throws -> O) async throws -> O {
        do {
            return try await handler()
        } catch let error as CustomNSError {
            if
                let details = error.errorUserInfo["details"] as? NSDictionary,
                let code = details["code"] as? String,
                code == "auth/invalid-email"
            {
                throw InvalidEmail()
            }
            throw error
        }
    }
}
