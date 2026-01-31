//
//  BestBikePathModel.swift
//  BestBikePath
//
//  Created by Lorenzo Fiamingo on 06/11/25.
//

import MapKit
import SwiftUI
import SwiftData

@Observable
final class BestBikePathModel {

    let modelSource: SwiftDataModelSource = .swiftData

    let userSource: UserSource = .firebase

    let userPathSource: UserPathSource = .firebase

    let communityPathSource: CommunityPathSource = .firebase

    var currentUserStreamTask: Task<Void, Never>?

    var presentedSheetItem: ContentSheetItem = .communityPathSearch

    var currentUser: User?

    var currentUserPaths: [UserPath]?

    var searchedCommunityPaths: [CommunityPath]?

    var mapCoordinator = ContentMapCoordinator()

    var selectedCommunityPath: CommunityPath?

    var isMapForcePresented = false

    var isMapPresented: Bool {
        isMapForcePresented ||
        mapCoordinator.isContentPresented ||
        [
            .userPathRecording,
            .userPathInsertion,
            .userPathDetail,
            .communityPathDetail
        ].contains(presentedSheetItem.role)
    }

    init() {
        currentUserStreamTask = Task {
            for await currentUser in userSource.currentUserStream {
                self.currentUser = currentUser
                await syncCurrentUserPaths(userID: currentUser?.id)
            }
        }
    }

    func syncCurrentUserPaths(userID: User.ID? = nil) async {
        if let userID = userID ?? userSource.currentUser?.id {
            do {
                currentUserPaths = try await userPathSource.getUserPaths(userID: userID)
            } catch {
                print(error)
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

    func presentUserPathDetail(_ userPath: UserPath) {
        Task {
            var mapCoordinator = mapCoordinator
            try await mapCoordinator.displayPath(from: userPath.path)
            withAnimation {
                self.mapCoordinator = mapCoordinator
            }
        }
        presentedSheetItem = .userPathDetail(userPath: userPath)
    }

    func presentCommunityPathDetail(_ communityPath: CommunityPath) {
        Task {
            var mapCoordinator = mapCoordinator
            try await mapCoordinator.displayPath(from: communityPath.path)
            withAnimation {
                self.mapCoordinator = mapCoordinator
            }
        }
        presentedSheetItem = .communityPathDetail(communityPath: communityPath)
    }









    func cleanMap() {
        routes.removeAll()
        mapItems.removeAll()
        communityResultPaths = nil
    }

    var routes: [(route: MKRoute, path: UserPathModel?)] = []

    var mapItems: [MKMapItem] = []


//    var user: User? = .some(.init(username: "", password: "", pathEntries: [])) {
//        didSet {
//            if let user {
//                var descriptor = FetchDescriptor<BikePathEntry>.init()
//                self.userPaths = (try? modelSource.mainContext.fetch(descriptor)) ?? []
//            } else {
//                self.userPaths.removeAll()
//            }
//        }
//    }


    var userPaths: [UserPathModel] = [.makeLecCanCom()]

    var userSelectedPath: UserPathModel?

    func displayUserPath(_ path: UserPathModel) {
        let locations = path.path.streets.map { CLLocation(latitude: $0.latitude, longitude: $0.longitude) }
        mapCoordinator.mapCameraPosition = .region(boundingRegion(for: locations, margin: 1.2)!)
        Task {
            var mapItems: [MKMapItem] = []
            for location in locations {
                if let mapItem = try? await MKReverseGeocodingRequest(location: location)?.mapItems.first {
                    mapItems.append(mapItem)
                }
            }
            var trip: [MKRoute] = []
            for (source, destination) in zip(mapItems, mapItems.dropFirst()) {
                if let route = await getDirections(source: source, destination: destination) {
                    trip.append(route)
                }
            }
            withAnimation {
                self.mapItems = mapItems
                routes = trip.map { ($0, nil) }
            }
        }
    }

    var communityResultPaths: [UserPathModel]?

    static var locationManager: LocationManager = .shared

    func openRecordingView() {
        if [.authorizedAlways, .authorizedWhenInUse].contains(Self.locationManager.authorizationStatus) {
            presentedSheetItem = .userPathRecording
        } else {
            presentedSheetItem = .locationAccess
        }
    }

    var recordLocations: [CLLocation] = []
    func addCurrentLocation() {
        guard let newLocation = Self.locationManager.location else { return }
        recordLocations.append(newLocation)
        Task {
            var mapItems: [MKMapItem] = []
            for location in recordLocations {
                if let mapItem = try? await MKReverseGeocodingRequest(location: location)?.mapItems.first {
                    mapItems.append(mapItem)
                }
            }
            var trip: [MKRoute] = []
            for (source, destination) in zip(mapItems, mapItems.dropFirst()) {
                if let route = await getDirections(source: source, destination: destination) {
                    trip.append(route)
                }
            }
            withAnimation {
                //self.mapItems = mapItems
                self.mapItems = [mapItems.first, mapItems.last].compactMap { $0 }
                routes = trip.map { ($0, nil) }
            }
        }
    }

    func searchCommunityResultPaths() {
        communityResultPaths = [.makeLecCom(), .makeLecCanCom(), .makeLecOggCom(), .makeLecCantCom()]
    }

    func addManualPath(isPublic: Bool) {
//        guard let user else { fatalError() }
//        let hasHighways = routes.contains { $0.route.hasHighways }
//        let streets = mapItems.map { item in
//            StreetLocation(latitude: item.location.coordinate.latitude, longitude: item.location.coordinate.longitude)
//        }
//        let bikePath = BikePath(
//            streets: streets,
//            hasHighways: hasHighways
//        )
//        let pathEntry = BikePathEntry(
//            user: user,
//            date: .now,
//            isPublic: isPublic,
//            path: bikePath,
//            performance: nil,
//            mode: .manual
//        )
//
//        modelSource.mainContext.insert(pathEntry)
//        userPaths.insert(pathEntry, at: 0)
    }

//    func checkUser(username: String) -> Bool {
//        // Build a fetch descriptor to find a User with a matching username
//        let predicate = #Predicate<User> { $0.username == username }
//        var descriptor = FetchDescriptor<User>(predicate: predicate)
//        descriptor.fetchLimit = 1
//        return try! modelContext.fetch(descriptor).count > 0
//    }

//    func loginUser(username: String, password: String) -> Bool {
//        let predicate = #Predicate<User> { $0.username == username && $0.password == password }
//        var descriptor = FetchDescriptor<User>(predicate: predicate)
//        descriptor.fetchLimit = 1
//        if let user = try! modelContext.fetch(descriptor).first {
//            self.user = user
//            presentedSheetItem = .communityPathSearch
//            return true
//        } else {
//            return false
//        }
//    }

//    func registerUser(username: String, password: String) {
//        let user = User(username: username, password: password, pathEntries: [])
//
//        modelContext.insert(user)
//        self.user = user
//        presentedSheetItem = .communityPathSearch
//    }
}

private extension BestBikePathModel {

    func getDirections(source: MKMapItem, destination: MKMapItem) async -> MKRoute? {
        let request = MKDirections.Request()
        request.source = source
        request.destination = destination
        request.transportType = .cycling

        let directions = MKDirections(request: request)
        let response = try? await directions.calculate()
        return response?.routes.first
    }

    func boundingRegion(for locations: [CLLocation], margin: Double) -> MKCoordinateRegion? {
        guard !locations.isEmpty else { fatalError() }

        // Compute min/max lat/lon
        var minLat = locations.first!.coordinate.latitude
        var maxLat = locations.first!.coordinate.latitude
        var minLon = locations.first!.coordinate.longitude
        var maxLon = locations.first!.coordinate.longitude

        for location in locations.dropFirst() {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            minLat = min(minLat, lat)
            maxLat = max(maxLat, lat)
            minLon = min(minLon, lon)
            maxLon = max(maxLon, lon)
        }

        // Center
        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )

        // Span (+ a small padding)
        let span = MKCoordinateSpan(
            latitudeDelta: (maxLat - minLat) * margin,
            longitudeDelta: (maxLon - minLon) * margin
        )
        print(span)

        return MKCoordinateRegion(center: center, span: span)
    }

}
