import MapKit
import SwiftUI
import SwiftData
import CoreMotion

@Observable
final class BestBikePathModel {

    let locationManager: LocationManager = .shared

    let motionManager: MotionManager = .shared

    let modelSource: SwiftDataModelSource = .swiftData

    let userSource: UserSource = .firebase

    let userPathSource: UserPathSource = .firebase

    let communityPathSource: CommunityPathSource = .firebase

    var currentUserStreamTask: Task<Void, Never>?

    var presentedSheetItem: ContentSheetItem = .communityPathSearch

    var currentUser: User?

    var currentUserPaths: [UserPath]?

    var searchedCommunityPaths: [CommunityPath]?

    var contentMapStyle: ContentMapStyle = .standard

    var mapCoordinator = ContentMapCoordinator()

    var selectedCommunityPath: CommunityPath?

    var isSearchingCommunityPaths = false

    var isMapPresented: Bool {
        isSearchingCommunityPaths ||
        mapCoordinator.isContentPresented ||
        [
            .userPathRecording,
            .userPathInsertion,
            .userPathDetail,
            .communityPathDetail
        ].contains(presentedSheetItem.role)
    }

    var userPathRecordingPresentationDetent: PresentationDetent = .fraction(0.8)

    init() {
        currentUserStreamTask = Task {
            for await currentUser in userSource.currentUserStream {
                self.currentUser = currentUser
                await syncCurrentUserPaths(userID: currentUser?.id)
            }
        }
    }

    var syncCurrentUserPathsError: Error?
    func syncCurrentUserPaths(userID: User.ID? = nil) async {
        syncCurrentUserPathsError = nil
        if let userID = userID ?? userSource.currentUser?.id {
            do {
                currentUserPaths = try await userPathSource.getUserPaths(userID: userID)
            } catch {
                syncCurrentUserPathsError = error
                currentUserPaths = nil
            }
        } else {
            currentUserPaths = nil
        }
    }

    func searchCommunityPaths() async throws {
        guard
            let originMapItem = mapCoordinator.mapItems.first,
            let destinationMapItem = mapCoordinator.mapItems.last
        else {
            searchedCommunityPaths = nil
            return
        }

        let origin = PathLocation(from: originMapItem)
        let destination = PathLocation(from: destinationMapItem)

        let communityPaths = try await communityPathSource.getCommunityPaths(origin: origin, destination: destination)
        searchedCommunityPaths = communityPaths
        var mapCoordinator = self.mapCoordinator
        try await mapCoordinator.makeCachedPathRoutes(from: communityPaths.map(\.path))

        selectedCommunityPath = searchedCommunityPaths?.first
        mapCoordinator.selectCachedPathRoutes(id: searchedCommunityPaths?.first?.path.id)
        self.mapCoordinator = mapCoordinator
    }

    func presentUserPathDetail(_ userPath: UserPath) async throws {
        var mapCoordinator = mapCoordinator
        mapCoordinator.reset()
        mapCoordinator.mapCameraPosition = .automatic
        try await mapCoordinator.displayPath(from: userPath.path)
        withAnimation(isMapPresented ? .default : nil) {
            self.mapCoordinator = mapCoordinator
        }
        presentedSheetItem = .userPathDetail(userPath: userPath)
    }

    func presentCommunityPathDetail(_ communityPath: CommunityPath) async throws {
        var mapCoordinator = mapCoordinator
        mapCoordinator.reset()
        mapCoordinator.mapCameraPosition = .automatic
        try await mapCoordinator.displayPath(from: communityPath.path)
        withAnimation(isMapPresented ? .default : nil) {
            self.mapCoordinator = mapCoordinator
        }
        presentedSheetItem = .communityPathDetail(communityPath: communityPath)
    }


    static var locationManager: LocationManager = .shared

    var nextSuggestedRoutesForUserPathRecording: [MKRoute]?
    func presentUserPathRecording() {
        if ![.authorizedAlways, .authorizedWhenInUse].contains(locationManager.authorizationStatus) {
            presentedSheetItem = .locationAccess
        } else if ![.authorized].contains(motionManager.authorizationStatus) {
            presentedSheetItem = .motionAccess
        } else {
            presentedSheetItem = .userPathRecording
        }
    }
}
