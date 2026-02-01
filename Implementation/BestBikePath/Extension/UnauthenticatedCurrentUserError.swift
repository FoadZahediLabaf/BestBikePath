import Foundation

struct UnauthenticatedCurrentUserError: LocalizedError {
    var errorDescription: String? {
        "This feature is only available for authenticated users."
    }

    var failureReason: String? {
        "The current user is not authenticated"
    }
}
