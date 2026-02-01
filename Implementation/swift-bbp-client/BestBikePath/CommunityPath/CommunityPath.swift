struct CommunityPath: Identifiable, Hashable, Codable {
    
    let id: String
    
    var path: Path
    
    var status: PathStatus
}
