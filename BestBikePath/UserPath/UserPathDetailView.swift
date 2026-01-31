import AsyncButton
import SwiftUI
import MapKit

struct UserPathDetailView: View {

    @Environment(BestBikePathModel.self) private var appModel

    var isUserPath: Bool = true

    private let initialUserPath: UserPath

    @State private var userPath: UserPath

    @State private var mapItems: [MKMapItem] = []

    @State private var routeSteps: [MKRoute.Step] = []

    var rawStatusBinding: Binding<Double> {
        Binding {
            Double(userPath.status.rawValue)
        } set: { rawStatus in
            userPath.status = PathStatus(sliderRawValue: rawStatus)
        }

    }

    var hasChanged: Bool {
        initialUserPath != userPath
    }


    init(userPath: UserPath) {
        initialUserPath = userPath
        _userPath = State(wrappedValue: userPath)
    }

    var rateSlider: some View {
        LabeledContent {
            ZStack(alignment: .trailing) {
                Text("Impassable")
                    .hidden()
                switch userPath.status {
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
            }
            .fontWidth(.condensed)
        } label: {
            HStack {
                Text("Path Status")
                    .padding(.trailing)
                    .padding(.trailing)

                Slider(value: rawStatusBinding, in: 1...5) {
                    Text("Path Status")
                } ticks: {
                    SliderTickContentForEach(
                        stride(from: 1.0, through: 5.0, by: 1).map { $0 },
                        id: \.self
                    ) { value in
                        SliderTick(value)
                    }
                }
            }
        }
    }

    var hasHighways: Bool {
        appModel.mapCoordinator.highlightedRoutes.contains { $0.hasHighways }
    }

    var body: some View {
        List {
            if hasHighways {
                Section {
                    ContentUnavailableView {
                        Label("Highway Detected", systemImage: "exclamationmark.triangle")
                            .symbolRenderingMode(.multicolor)
                    } description: {
                        Text("This route includes a highway, which may be unsafe for cyclists.")
                    }
                    .imageScale(.small)
                }
            }

            if isUserPath {
                Section {
                    rateSlider

                    Toggle("Share Publicly", isOn: $userPath.isPublic)
                }
            } else {
                Section {
                    LabeledContent {
                        Text("Excellent")
                    } label: {
                        Text("Status")
                    }

                }
            }

            if isUserPath {
                if let performance = userPath.performance {
                    Section("Performance") {
                        let duration: Duration = .seconds(performance.time.converted(to: .seconds).value)
                        let needsHours: Bool = duration.components.seconds >= 3600
                        LabeledContent("Total time", value: duration, format: .time(pattern: needsHours ? .hourMinuteSecond : .minuteSecond))
                        LabeledContent("Covered Distance", value: performance.distance.formatted())
                        LabeledContent("Average Speed", value: performance.averageSpeed.formatted())
                        LabeledContent("Peak Speed", value: performance.peakSpeed.formatted())
                    }
                }

                if let weather = userPath.weather {
                    Section("Weather") {
                        LabeledContent("Temperature", value: weather.temperature.formatted())
                        LabeledContent("Humidity", value: weather.humidity.formatted())
                        LabeledContent("Wind Speed", value: weather.windSpeed.formatted())
                    }
                }
            }

            Section {
//                DisclosureGroup("Locations") {
//                    mapItemsView
//                }
//                .onChange(of: appModel.mapCoordinator.highlightedRoutes, initial: true) {
//                    Task {
//                        guard
//                            let startMapItem = appModel.mapCoordinator.mapItems.first,
//                            let endMapItem = appModel.mapCoordinator.mapItems.last
//                        else {
//                            return
//                        }
//                        let locations = userPath.path.locations.dropFirst().dropLast()
//                        var mapItems: [MKMapItem] = []
//                        mapItems.append(startMapItem)
//                        for location in locations {
//                            let mapItem = await location.mapItemGeocoded
//                            mapItems.append(mapItem)
//                        }
//                        mapItems.append(endMapItem)
//                        self.mapItems = mapItems
//                    }
//                }

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

            Section {
                Button {
                    appModel.nextSuggestedRoutesForUserPathRecording = appModel.mapCoordinator.highlightedRoutes
                    appModel.presentUserPathRecording()
                } label: {
                    Label {
                        Text("Record New Path")
                    } icon: {
                        Image(systemName: "record.circle")
                            .foregroundStyle(.red)
                    }
                }
            }

            if isUserPath {
                AsyncButton(role: .destructive) {
                    try await deletePath()
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                .tint(.red)
                .foregroundStyle(.red)
            }
        }
        .animation(.default, value: appModel.mapCoordinator.mapItems)
        .scrollContentBackground(.hidden)
        .toolbarTitleDisplayMode(.inline)
        .navigationTitle("Bike Path")
        .toolbar {
            toolbarContent
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

    @ToolbarContentBuilder
    var toolbarContent: some ToolbarContent {
        if isUserPath {
            ToolbarItem(placement: .primaryAction) {
                AsyncButton(options: .automatic) {
                    if userPath.status != initialUserPath.status {
                        try await appModel.userPathSource.updateUserPathStatus(id: userPath.id, status: userPath.status)
                    }

                    if userPath.isPublic != initialUserPath.isPublic {
                        try await appModel.userPathSource.updateUserPathPrivacy(id: userPath.id, isPublic: userPath.isPublic)
                    }

                    if userPath != initialUserPath {
                        await appModel.syncCurrentUserPaths()
                    }

                    appModel.mapCoordinator.reset()
                    appModel.presentedSheetItem = .communityPathSearch
                } label: { operations in
                    if operations.contains(where: \.isLoading) {
                        ProgressView()
                    } else {
                        Label("Confirm", systemImage: "checkmark")
                    }
                }
                .fontWeight(.semibold)
                .buttonStyle(.glassProminent)
                .disabled(!hasChanged)
                .animation(.default, value: hasChanged)
            }
        }

        ToolbarItem(placement: .cancellationAction) {
            Button(role: .cancel) {
                Task { @MainActor in
                    appModel.mapCoordinator.reset()
                    appModel.presentedSheetItem = .communityPathSearch
                }
            }
        }
    }

    func deletePath() async throws {
        try await appModel.userPathSource.deleteUserPath(id: userPath.id)
        await appModel.syncCurrentUserPaths()
        appModel.presentedSheetItem = .communityPathSearch
    }
}
