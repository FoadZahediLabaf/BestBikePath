import AsyncButton
import SwiftUI
import MapKit

struct UserPathInsertionView: View {

    @Environment(BestBikePathModel.self) private var appModel

    @State private var searchingCompletions: [MKLocalSearchCompletion] = []

    @State private var selectedItem: MKMapItem?

    @State private var searchText = ""

    @State private var isSearching = false

    @State private var rawStatus: Double = 1

    @State private var isPublic = true

    var statusSlider: some View {
        LabeledContent {
            ZStack(alignment: .trailing) {
                Text("Impassable")
                    .hidden()
                switch rawStatus {
                case ..<2:
                    Text("Impassable")
                case 2..<3:
                    Text("Poor")
                case 3..<4:
                    Text("Fair")
                case 4..<5:
                    Text("Good")
                case 5...:
                    Text("Excellent")
                default:
                    Text("Error")
                }
            }
            .fontWidth(.condensed)
        } label: {
            HStack {
                Text("Path Status")
                    .padding(.trailing)
                    .padding(.trailing)

                Slider(value: $rawStatus, in: 1...5) {
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

    var body: some View {
        List {
            if isSearching && !searchText.isEmpty {
                searchingCompletionsView
            } else {
                fieldsView
            }
        }
        .environment(\.editMode, .constant(.active))
        .animation(.default, value: appModel.mapCoordinator.mapItems)
        .animation(.default, value: isSearching)
        .scrollContentBackground(.hidden)
        .searchable(text: $searchText, isPresented: $isSearching, prompt: searchPrompt)
        .onSubmit(of: .search) {
            Task {
                try await addLocation(naturalLanguageQuery: searchText, region: appModel.mapCoordinator.coordinateRegion)
            }
        }
        .onChange(of: searchText) {
            suggestLocations()
        }
        .onChange(of: isSearching) {
            searchingCompletions = []
        }
        .onChange(of: appModel.mapCoordinator.mapItems) {
            Task {
                var mapCoordinator = appModel.mapCoordinator
                try await mapCoordinator.setHighlightedRoutesFromMapItems()
                appModel.mapCoordinator = mapCoordinator
            }
        }
        .toolbarTitleDisplayMode(.inline)
        .navigationTitle("Create a new Bike Path")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                saveButton
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
        .presentationBackground(.thinMaterial)
        .interactiveDismissDisabled()

    }

    var searchingCompletionsView: some View {
        ForEach(searchingCompletions, id: \.description) { completion in
            AsyncButton {
                try await addLocation(localSearchCompletion: completion)
            } label: {
                LocalSearchCompletionRow(completion: completion)
            }
        }
    }

    @ViewBuilder
    var fieldsView: some View {
        if !isSearching {
            Section {
                statusSlider

                Toggle("Share Pubblicly", isOn: $isPublic)
            }
        }


        Section {
            ForEach(appModel.mapCoordinator.mapItems, id: \.description) { item in
                MapItemRow(item: item)
            }
            .onDelete { offsets in
                appModel.mapCoordinator.mapItems.remove(atOffsets: offsets)
            }
            .onMove { fromOffsets, toOffset in
                appModel.mapCoordinator.mapItems.move(fromOffsets: fromOffsets, toOffset: toOffset)
            }
        }

        Section {
            placeholder
        }
        .foregroundStyle(.secondary)
        .frame(maxWidth: .infinity)
        .listRowBackground(Color.clear)
    }

    @ViewBuilder
    var placeholder: some View {
        if appModel.mapCoordinator.mapItems.isEmpty {
            ContentUnavailableView {
                Label("No Locations Provided", systemImage: "point.bottomleft.forward.to.point.topright.scurvepath")
            } description: {
                Text("Search a location.")
            }
            .imageScale(.small)
        } else if appModel.mapCoordinator.mapItems.count < 2 {
            ContentUnavailableView {
                Label("No Destination Provided", systemImage: "point.bottomleft.forward.to.point.topright.filled.scurvepath")
            } description: {
                Text("Search a location.")
            }
            .imageScale(.small)
        }
    }

    var searchPrompt: Text {
        if appModel.mapCoordinator.mapItems.isEmpty {
            return Text("Search Starting Point")
        } else {
            return Text("Search Destination")
        }
    }

    func addLocation(localSearchCompletion: MKLocalSearchCompletion) async throws {
        var mapCoordinator = self.appModel.mapCoordinator
        try await mapCoordinator.addMapItem(from: MKLocalSearch.Request(completion: localSearchCompletion))
        appModel.mapCoordinator = mapCoordinator
        isSearching = false
        searchText = ""
        appModel.mapCoordinator.mapCameraPosition = .automatic

    }

    func addLocation(naturalLanguageQuery: String, region: MKCoordinateRegion) async throws {
        var mapCoordinator = self.appModel.mapCoordinator
        try await mapCoordinator.addMapItem(from: MKLocalSearch.Request(naturalLanguageQuery: naturalLanguageQuery, region: region))
        appModel.mapCoordinator = mapCoordinator
        isSearching = false
        searchText = ""
        appModel.mapCoordinator.mapCameraPosition = .automatic
    }

    var saveButton: some View {
        AsyncButton(options: .automatic) {
            try await saveUserPath()
        } label: { operations in
            if operations.contains(where: \.isLoading) {
                ProgressView()
            } else {
                Label("Confirm", systemImage: "checkmark")
            }
        }
        .fontWeight(.semibold)
        .buttonStyle(.glassProminent)
        .disabled(appModel.mapCoordinator.mapItems.count < 2)
    }

    func saveUserPath() async throws {
        var mapCoordinator = self.appModel.mapCoordinator
        let path = mapCoordinator.makePathFromHighlightedRoutes()
        appModel.mapCoordinator = mapCoordinator
        guard let currentUserID = appModel.userSource.currentUser?.id else {
            throw UnauthenticatedCurrentUserError()
        }
        let userPath = UserPath(
            id: UUID().uuidString,
            userId: currentUserID,
            date: .now,
            isPublic: isPublic,
            path: path,
            status: PathStatus(sliderRawValue: rawStatus)
        )
        try await appModel.userPathSource.saveUserPath(userPath)
        await appModel.syncCurrentUserPaths()
        appModel.mapCoordinator.reset()
        appModel.presentedSheetItem = .communityPathSearch
    }

    @State private var completer = MKLocalSearchCompleter()
    @State private var completerDelegate: LocalSearchCompleterDelegate?

    func suggestLocations() {
        completerDelegate = LocalSearchCompleterDelegate {
            searchingCompletions = $0
        }
        completer.delegate = completerDelegate!
        completer.queryFragment = searchText
        completer.region = appModel.mapCoordinator.coordinateRegion
    }
}

#Preview {
    UserPathInsertionView()
}

private class LocalSearchCompleterDelegate: NSObject, MKLocalSearchCompleterDelegate {
    var onResult: ([MKLocalSearchCompletion]) -> Void
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        onResult(completer.results)
    }
    init(onResult: @escaping ([MKLocalSearchCompletion]) -> Void) {
        self.onResult = onResult
    }
}


extension MKLocalSearchCompletion {
    var attributedTitle: AttributedString {
        var s = AttributedString(title)
        for range in self.titleHighlightRanges {
            let start = s.index(s.startIndex, offsetByCharacters: range.rangeValue.lowerBound)
            let end = s.index(s.startIndex, offsetByCharacters: range.rangeValue.upperBound)

            s[start..<end].font = .body.bold()
        }
        return s
    }

    var attributedSubtitle: AttributedString {
        var s = AttributedString(subtitle)
        for range in self.subtitleHighlightRanges {
            let start = s.index(s.startIndex, offsetByCharacters: range.rangeValue.lowerBound)
            let end = s.index(s.startIndex, offsetByCharacters: range.rangeValue.upperBound)

            s[start..<end].font = .caption.bold()
        }
        return s
    }
}
