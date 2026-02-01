import AsyncButton
import SwiftUI
import MapKit

struct CommunityPathSearch: View {

    @Environment(BestBikePathModel.self) private var appModel

    @State private var searchingCompletions: [MKLocalSearchCompletion] = []

    @State private var searchText: String = ""

    @State private var selectedDetent: PresentationDetent = .medium

    var searchBarIsHidden: Bool {
//        appModel.searchedCommunityPaths != nil

        if let searchedCommunityPaths = appModel.searchedCommunityPaths {
            !searchedCommunityPaths.isEmpty
        } else {
            false
        }
    }

    var body: some View {
        @Bindable var appModel = appModel
        NavigationStack {
            VStack {
                List(selection: $appModel.selectedCommunityPath) {
                    if let paths = appModel.searchedCommunityPaths {
                        ForEach(paths, id: \.self) { path in
                            Section {
                                CommunityPathRow(path: path)
                                    .labelReservedIconWidth(192)
                                    .frame(height: 96)
                            }
                        }
                        .listRowInsets(.leading, 8)
                        .listRowInsets(.vertical, 8)
                        .listSectionSpacing(12)

                        if paths.isEmpty {
                            searchedCommunityPathsEmptyView
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity)
                                .listRowBackground(Color.clear)
                        }
                    } else if appModel.isSearchingCommunityPaths && !searchText.isEmpty {
                        searchingCompletionsView
                    } else {
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
                    .animation(.default, value: appModel.isSearchingCommunityPaths)
                }
                .environment(\.editMode, .constant(.active))
                .animation(.default, value: appModel.mapCoordinator.mapItems)
                .animation(.default, value: appModel.searchedCommunityPaths)
                .scrollContentBackground(.hidden)
                .searchable(text: $searchText, isPresented: $appModel.isSearchingCommunityPaths, prompt: searchPrompt, isHidden: searchBarIsHidden)
                .onSubmit(of: .search) {
                    Task {
                        try await addLocation(naturalLanguageQuery: searchText, region: appModel.mapCoordinator.coordinateRegion)
                    }
                }

            }
            .onChange(of: searchText) {
                suggestLocations()
            }
            .onChange(of: appModel.isSearchingCommunityPaths) {
                searchingCompletions = []
                if appModel.searchedCommunityPaths?.isEmpty == true {
                    appModel.searchedCommunityPaths = nil
                    appModel.mapCoordinator.reset()
                }
                if !appModel.isSearchingCommunityPaths {
                    selectedDetent = .medium
                }
            }
            .toolbarTitleDisplayMode(.inline)
            .navigationTitle("Community Bike Paths")
            .toolbar {
                toolbarContent
            }
            .animation(.default, value: appModel.searchedCommunityPaths)
        }
        .presentationDetents([.medium, .large])
        .onChange(of: appModel.selectedCommunityPath) {
            appModel.mapCoordinator.selectCachedPathRoutes(id: appModel.selectedCommunityPath?.path.id)
            appModel.mapCoordinator.mapCameraPosition = .automatic
        }
        .presentationBackground(.thinMaterial)
        .interactiveDismissDisabled()
    }

    var searchedCommunityPathsEmptyView: some View {
        ContentUnavailableView {
            Label("No Paths Found", systemImage: "magnifyingglass")
        } description: {
            Text("We couldn’t find any bike paths between your selected locations. Try adjusting your start or destination point.")
        }
    }

    @ViewBuilder
    var placeholder: some View {
        if appModel.mapCoordinator.mapItems.isEmpty && !appModel.isSearchingCommunityPaths && searchText.isEmpty {
            Section {
                ContentUnavailableView {
                    Label("Community Bike Paths", systemImage: "person.3")
                } description: {
                    Text("Search a location to start.")
                }
            }
        } else if appModel.mapCoordinator.mapItems.isEmpty && searchText.isEmpty {
            ContentUnavailableView {
                Label("No Locations Provided", systemImage: "point.bottomleft.forward.to.point.topright.scurvepath")
            } description: {
                Text("Search a location.")
            }
            .imageScale(.small)
        } else if appModel.mapCoordinator.mapItems.count < 2 && searchText.isEmpty {
            ContentUnavailableView {
                Label("No Destination Provided", systemImage: "point.bottomleft.forward.to.point.topright.filled.scurvepath")
            } description: {
                Text("Search a location.")
            }
            .imageScale(.small)
        }
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

    var searchPrompt: Text {
        if appModel.searchedCommunityPaths?.isEmpty == true {
            Text("Search again")
        } else if appModel.mapCoordinator.mapItems.isEmpty {
            Text("Search Starting Point")
        } else {
            Text("Search Destination")
        }
    }

    @ToolbarContentBuilder
    var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            if appModel.searchedCommunityPaths == nil {
                AsyncButton(options: .automatic) {
                    try await appModel.searchCommunityPaths()
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
                .animation(.default, value: appModel.mapCoordinator.mapItems.count)
            } else if appModel.searchedCommunityPaths?.isEmpty == false {
                AsyncButton(options: .automatic) {
                    guard let selectedCommunityPath = appModel.selectedCommunityPath else { return }
                    try await appModel.presentCommunityPathDetail(selectedCommunityPath)
                } label: { operations in
                    if operations.contains(where: \.isLoading) {
                        ProgressView()
                    } else {
                        Label("Confirm", systemImage: "checkmark")
                    }
                }
                .fontWeight(.semibold)
                .buttonStyle(.glassProminent)
                .disabled(appModel.selectedCommunityPath == nil)
            }
        }

        if appModel.searchedCommunityPaths != nil || appModel.mapCoordinator.isContentPresented {
            ToolbarItem(placement: .cancellationAction) {
                Button(role: .cancel) {
                    appModel.mapCoordinator.reset()
                    appModel.searchedCommunityPaths = nil
                    selectedDetent = .medium
                }
            }
        }
    }

    func addLocation(localSearchCompletion: MKLocalSearchCompletion) async throws {
        var mapCoordinator = self.appModel.mapCoordinator
        if mapCoordinator.mapItems.count > 1 {
            mapCoordinator.mapItems.removeLast()
        }
        try await mapCoordinator.addMapItem(from: MKLocalSearch.Request(completion: localSearchCompletion))
        appModel.mapCoordinator = mapCoordinator
        appModel.isSearchingCommunityPaths = false
        searchText = ""
        appModel.mapCoordinator.mapCameraPosition = .automatic

    }

    func addLocation(naturalLanguageQuery: String, region: MKCoordinateRegion) async throws {
        var mapCoordinator = self.appModel.mapCoordinator
        if mapCoordinator.mapItems.count > 1 {
            mapCoordinator.mapItems.removeLast()
        }
        try await mapCoordinator.addMapItem(from: MKLocalSearch.Request(naturalLanguageQuery: naturalLanguageQuery, region: region))
        appModel.mapCoordinator = mapCoordinator
        appModel.isSearchingCommunityPaths = false
        searchText = ""
        appModel.mapCoordinator.mapCameraPosition = .automatic
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
