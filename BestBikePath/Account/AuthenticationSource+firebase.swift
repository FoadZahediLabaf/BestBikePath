import FirebaseFunctions
import FirebaseAuth

extension AuthenticationSource where Self == FirebaseAuthenticationSource {

    static var firebase: FirebaseAuthenticationSource {
        FirebaseAuthenticationSource()
    }
}

struct FirebaseAuthenticationSource: AuthenticationSource {

    private let auth = FirebaseAuth.Auth.auth()

    private let functions = FirebaseFunctions.Functions.functions()

    var isAuthenticated: Bool {
        auth.currentUser != nil
    }

    func checkUserExists(email: String) async throws -> Bool {
        struct Data: Encodable {
            let email: String
        }
        let data = Data(email: email)
        return try await functions.httpsCallable("checkUserExists").call(data)
    }
    
    func sendEmailVerificationCode(email: String) async throws -> Bool {
        <#code#>
    }
    
    func checkEmailVerificationCode(email: String, code: String) async throws -> Bool {
        <#code#>
    }
    
    func createUser(email: String, password: String, displayName: String, emailVerificationCode: String) async throws {
        <#code#>
    }
    
    func deleteUser(email: String) async throws {
        <#code#>
    }
    
    func signIn(email: String, password: String) async throws {
        <#code#>
    }
    
    func signOut() async throws {
        <#code#>
    }
}
