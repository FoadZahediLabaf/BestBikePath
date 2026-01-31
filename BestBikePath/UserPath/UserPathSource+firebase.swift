import FirebaseFunctions
import FirebaseSharedSwift
import Foundation

extension UserPathSource where Self == FirebaseUserPathSource {

    static var firebase: FirebaseUserPathSource {
        FirebaseUserPathSource()
    }
}

struct FirebaseUserPathSource: UserPathSource {

    private var functions: Functions {
        Functions.functions()
    }

    func saveUserPath(_ path: UserPath) async throws {
        do {
            typealias Request = UserPath
            struct Response: Decodable {}

            try await call("saveUserPath", path)
        } catch {
            print("JFK", error)
        }
    }

    func getUserPaths(userID: User.ID) async throws -> [UserPath] {
        struct Request: Encodable {
            let userID: UserPath.ID
        }
        typealias Response = [UserPath]

        let request = Request(userID: userID)
        return try await call("getUserPaths", request)
    }

    func updateUserPathPrivacy(id: UserPath.ID, isPublic: Bool) async throws {
        struct Request: Encodable {
            let id: UserPath.ID
            let isPublic: Bool
        }
        struct Response: Decodable {}

        let request = Request(id: id, isPublic: isPublic)
        try await call("updateUserPathPrivacy", request)
    }

    func updateUserPathStatus(id: UserPath.ID, status: PathStatus) async throws {
        struct Request: Encodable {
            let id: UserPath.ID
            let status: Int
        }
        struct Response: Decodable {}

        let request = Request(id: id, status: status.rawValue)
        try await call("updateUserPathStatus", request)
    }

    func deleteUserPath(id: UserPath.ID) async throws {
        struct Request: Encodable {
            let id: UserPath.ID
        }
        struct Response: Decodable {}

        let request = Request(id: id)
        try await call("deleteUserPath", request)
    }
}

extension FirebaseUserPathSource {

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
        }
    }
}
