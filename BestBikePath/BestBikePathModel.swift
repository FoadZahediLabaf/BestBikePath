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

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            User.self, BikePathEntry.self, BikePath.self, StreetLocation.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    private var modelContext: ModelContext {
        sharedModelContainer.mainContext
    }

    enum RootModal {
        case signIn
        case recordBikePath
        case addBikePath
        case searchCommunityPaths
        case userPath
    }
    var presentedRootModal: RootModal = .searchCommunityPaths

    func isPresentingRootModal(_ modal: RootModal) -> Binding<Bool> {
        Binding {
            self.presentedRootModal == modal
        } set: { isPresented in
            if isPresented {
                self.presentedRootModal = modal
            } else {
                self.presentedRootModal = .searchCommunityPaths
            }
        }
    }

    var isRootMapForcePresented = false

    var isRootMapPresented: Bool {
        isRootMapForcePresented ||
        !routes.isEmpty ||
        !mapItems.isEmpty ||
        presentedRootModal == .recordBikePath ||
        presentedRootModal == .addBikePath ||
        presentedRootModal == .userPath
    }

    func cleanMap() {
        routes.removeAll()
        mapItems.removeAll()
        communityResultPaths = nil
    }

    var routes: [(route: MKRoute, path: BikePathEntry?)] = []

    var mapItems: [MKMapItem] = []

    var mapCameraPosition: MapCameraPosition = .automatic

    var mapRegion = MKCoordinateRegion()

    var user: User? = .some(.init(username: "", password: "", pathEntries: [])) {
        didSet {
            if let user {
                var descriptor = FetchDescriptor<BikePathEntry>.init()
                self.userPaths = (try? modelContext.fetch(descriptor)) ?? []
            } else {
                self.userPaths.removeAll()
            }
        }
    }

    var userPaths: [BikePathEntry] = [.makeLecCanCom()]

    var userSelectedPath: BikePathEntry?

    func displayUserPath(_ path: BikePathEntry) {
        let locations = path.path.streets.map { CLLocation(latitude: $0.latitude, longitude: $0.longitude) }
        mapCameraPosition = .region(boundingRegion(for: locations, margin: 1.2)!)
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

    var communityResultPaths: [BikePathEntry]?

    var selectedPath: BikePathEntry?

    func searchCommunityResultPaths() {
        communityResultPaths = [.makeLecCom(), .makeLecCanCom(), .makeLecOggCom(), .makeLecCantCom()]
    }

    func addManualPath(isPublic: Bool) {
        guard let user else { fatalError() }
        let hasHighways = routes.contains { $0.route.hasHighways }
        let streets = mapItems.map { item in
            StreetLocation(latitude: item.location.coordinate.latitude, longitude: item.location.coordinate.longitude)
        }
        let bikePath = BikePath(
            streets: streets,
            hasHighways: hasHighways
        )
        let pathEntry = BikePathEntry(
            user: user,
            date: .now,
            isPublic: isPublic,
            path: bikePath,
            performance: nil,
            mode: .manual
        )

        modelContext.insert(pathEntry)
        userPaths.insert(pathEntry, at: 0)
    }

    func checkUser(username: String) -> Bool {
        // Build a fetch descriptor to find a User with a matching username
        let predicate = #Predicate<User> { $0.username == username }
        var descriptor = FetchDescriptor<User>(predicate: predicate)
        descriptor.fetchLimit = 1
        return try! modelContext.fetch(descriptor).count > 0
    }

    func loginUser(username: String, password: String) -> Bool {
        let predicate = #Predicate<User> { $0.username == username && $0.password == password }
        var descriptor = FetchDescriptor<User>(predicate: predicate)
        descriptor.fetchLimit = 1
        if let user = try! modelContext.fetch(descriptor).first {
            self.user = user
            presentedRootModal = .searchCommunityPaths
            return true
        } else {
            return false
        }
    }

    func registerUser(username: String, password: String) {
        let user = User(username: username, password: password, pathEntries: [])

        modelContext.insert(user)
        self.user = user
        presentedRootModal = .searchCommunityPaths
    }
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
