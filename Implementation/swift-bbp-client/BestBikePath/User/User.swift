struct User: Hashable, Codable, Identifiable {

    let id: String

    let displayName: String

    let email: String
}

extension User {
    static var test: User {
        User(id: "johnappleseed", displayName: "John Appleseed", email: "johnappleseed@example.com")
    }
}
