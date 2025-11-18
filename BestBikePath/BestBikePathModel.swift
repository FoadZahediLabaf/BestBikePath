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
        presentedRootModal == .addBikePath
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

    var user: User? {
        didSet {
            if let user {
                var descriptor = FetchDescriptor<BikePathEntry>.init()
                self.userPaths = (try? modelContext.fetch(descriptor)) ?? []
            } else {
                self.userPaths.removeAll()
            }
        }
    }

    var userPaths: [BikePathEntry] = []

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
