
import FirebaseSharedSwift
import FirebaseFunctions
import Foundation

extension CommunityPathSource where Self == FirebaseCommunityPathSource {

    static var firebase: FirebaseCommunityPathSource {
        FirebaseCommunityPathSource()
    }
}

struct FirebaseCommunityPathSource: CommunityPathSource {

    private var functions: Functions {
        Functions.functions()
    }

    func getCommunityPaths(origin: PathLocation, destination: PathLocation) async throws -> [CommunityPath] {
        struct Request: Encodable {
            let origin: PathLocation
            let destination: PathLocation
        }
        typealias Response = [CommunityPath]

        let request = Request(origin: origin, destination: destination)
        return try await call("getCommunityPaths", request)
    }
}

extension FirebaseCommunityPathSource {

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
