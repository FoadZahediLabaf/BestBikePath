protocol CommunityPathSource {

    func getCommunityPaths(origin: PathLocation, destination: PathLocation) async throws -> [CommunityPath]
}
