struct Path: Hashable, Identifiable, Codable {

    let id: String

    var locations: [PathLocation]
}
