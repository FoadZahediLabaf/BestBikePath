import SwiftData

protocol ModelSource {

    var container: ModelContainer { get }

    var mainContext: ModelContext { get }
}

extension ModelSource where Self == SwiftDataModelSource {

    static var swiftData: SwiftDataModelSource {
        SwiftDataModelSource()
    }
}

struct SwiftDataModelSource: ModelSource {

    private static let sharedModelContainer: ModelContainer = {
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

    var container: ModelContainer {
        Self.sharedModelContainer
    }

    var mainContext: ModelContext {
        container.mainContext
    }
}
