struct ContentSheetItem: Identifiable, Hashable {

    enum Role {
        case communityPathSearch
        case communityPathDetail
        case userAuthentication
        case userAccount
        case locationAccess
        case motionAccess
        case userPathRecording
        case userPathInsertion
        case userPathDetail
    }

    let role: Role

    let user: User?

    let userPath: UserPath?

    let communityPath: CommunityPath?

    var id: Self {
        self
    }

    fileprivate init(role: Role, user: User? = nil, userPath: UserPath? = nil, communityPath: CommunityPath? = nil) {
        self.role = role
        self.user = user
        self.userPath = userPath
        self.communityPath = communityPath
    }
}

extension ContentSheetItem {

    static var communityPathSearch: ContentSheetItem {
        ContentSheetItem(role: .communityPathSearch)
    }

    static func communityPathDetail(communityPath: CommunityPath) -> ContentSheetItem {
        ContentSheetItem(role: .communityPathDetail, communityPath: communityPath)
    }

    static var userAuthentication: ContentSheetItem {
        ContentSheetItem(role: .userAuthentication)
    }

    static func userAccount(user: User) -> ContentSheetItem {
        ContentSheetItem(role: .userAccount, user: user)
    }

    static var locationAccess: ContentSheetItem {
        ContentSheetItem(role: .locationAccess)
    }

    static var motionAccess: ContentSheetItem {
        ContentSheetItem(role: .motionAccess)
    }

    static var userPathRecording: ContentSheetItem {
        ContentSheetItem(role: .userPathRecording)
    }

    static var userPathInsertion: ContentSheetItem {
        ContentSheetItem(role: .userPathInsertion)
    }

    static func userPathDetail(userPath: UserPath) -> ContentSheetItem {
        ContentSheetItem(role: .userPathDetail, userPath: userPath)
    }
}
