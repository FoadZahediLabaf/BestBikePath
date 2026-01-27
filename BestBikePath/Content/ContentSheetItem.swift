struct ContentSheetItem: Identifiable, Hashable {
    enum Role {
        case pathBrowsing
        case authentication
        case account
        case locationAccess
        case pathRecording
        case pathInsertion
    }
    let role: Role

    var id: Role {
        role
    }
}

extension ContentSheetItem {

    static var pathBrowsing: ContentSheetItem {
        ContentSheetItem(role: .pathBrowsing)
    }

    static var authentication: ContentSheetItem {
        ContentSheetItem(role: .authentication)
    }

    static var account: ContentSheetItem {
        ContentSheetItem(role: .account)
    }

    static var locationAccess: ContentSheetItem {
        ContentSheetItem(role: .locationAccess)
    }

    static var pathRecording: ContentSheetItem {
        ContentSheetItem(role: .pathRecording)
    }

    static var pathInsertion: ContentSheetItem {
        ContentSheetItem(role: .pathInsertion)
    }
}
