import SwiftUI
import MapKit

struct CommunityPathDetailView: View {

    @Environment(BestBikePathModel.self) private var appModel

    let communityPath: CommunityPath

    @State private var mapItems: [MKMapItem] = []

    @State private var routeSteps: [MKRoute.Step] = []


    var body: some View {
        List {
            Section {
                LabeledContent {
                    switch communityPath.status {
                    case .impassable:
                        Text("Impassable")
                    case .poor:
                        Text("Poor")
                    case .fair:
                        Text("Fair")
                    case .good:
                        Text("Good")
                    case .excellent:
                        Text("Excellent")
                    }
                } label: {
                    Text("Status")
                }
            }

            Section {
                DisclosureGroup("Locations") {
                    mapItemsView
                }
                .onChange(of: appModel.mapCoordinator.highlightedRoutes, initial: true) {
                    Task {
                        guard
                            let startMapItem = appModel.mapCoordinator.mapItems.first,
                            let endMapItem = appModel.mapCoordinator.mapItems.last
                        else {
                            return
                        }
                        let locations = communityPath.path.locations.dropFirst().dropLast()
                        var mapItems: [MKMapItem] = []
                        mapItems.append(startMapItem)
                        for location in locations {
                            let mapItem = await location.mapItemGeocoded
                            mapItems.append(mapItem)
                        }
                        mapItems.append(endMapItem)
                        self.mapItems = mapItems
                    }
                }

                DisclosureGroup("Directions") {
                    ForEach(routeSteps, id: \.description) { step in
                        VStack(alignment: .leading) {
                            Text(step.instructions)

                            if let notice = step.notice {
                                Label(notice, systemImage: "exclamationmark.triangle")
                                    .font(.caption)
                                    .foregroundStyle(.red.secondary)
                            }
                        }
                    }
                }
                .onChange(of: appModel.mapCoordinator.highlightedRoutes, initial: true) {
                    Task {
                        let steps = appModel.mapCoordinator.highlightedRoutes.map(\.steps)
                        let initialSteps = steps.dropLast().map { $0.dropLast() }
                        routeSteps = Array(initialSteps.joined()) + (steps.last ?? [])
                    }
                }
            }

            if appModel.currentUser != nil {
                Section {
                    Button("Record New Path", systemImage: "record.circle") {
                        appModel.openRecordingView()
                    }
                    .tint(.red)
                }
            }
        }
        .animation(.default, value: appModel.mapItems)
        .scrollContentBackground(.hidden)
        .toolbarTitleDisplayMode(.inline)
        .navigationTitle("Bike Path")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(role: .cancel) {
                    Task { @MainActor in
                        appModel.cleanMap()
                        appModel.presentedSheetItem = .communityPathSearch
                    }
                }
            }
        }
        .presentationBackground(.thinMaterial)
        .interactiveDismissDisabled()

    }

    var mapItemsView: some View {
        ForEach(mapItems, id: \.description) { item in
            let isOn = Binding {
                appModel.mapCoordinator.mapItems.contains { $0 === item }
            } set: { isOn in
                if isOn && !appModel.mapCoordinator.mapItems.contains(where: { $0 === item }) {
                    appModel.mapCoordinator.mapItems.append(item)
                } else {
                    appModel.mapCoordinator.mapItems.removeAll { $0 === item }
                }
            }

            Toggle(isOn: isOn) {
                MapItemRow(item: item)
            }
            .controlSize(.mini)
        }
    }
}
