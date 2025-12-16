//
//  SampleMap.swift
//  BestBikePath
//
//  Created by Lorenzo Fiamingo on 06/11/25.
//

import SwiftUI
import MapKit

struct PathRow: View {

    let path: BikePathEntry

    var statusValue: Double {
        switch path.status {
        case .excellent:
            5
        case .good:
            4
        case .fair:
            3
        case .poor:
            2
        case .impassable:
            1
        }
    }

    var statusPercentage: String {
        switch path.status {
        case .excellent:
            "100%"
        case .good:
            "80%"
        case .fair:
            "60%"
        case .poor:
            "40%"
        case .impassable:
            "20%"
        }
    }

    var body: some View {
        Label {
            VStack {


                Gauge(value: statusValue, in: 0...5) {
                    Label("Status", systemImage: "road.lanes.curved.right")
                } currentValueLabel: {
                    Text(statusPercentage)
                }
                .gaugeStyle(.accessoryCircular)
                .tint(.red.mix(with: .green, by: statusValue/5))
                .frame(maxWidth: .infinity)

                Group {
                    switch path.status {
                    case .excellent:
                        Text("Excellent")
                    case .good:
                        Text("Good")
                    case .fair:
                        Text("Fair")
                    case .poor:
                        Text("Poor")
                    case .impassable:
                        Text("Impassable")
                    }
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
        } icon: {
            PathMap(path, margin: 1.2)
                .cornerRadius(16)
                .allowsHitTesting(false)
        }
        .onAppear(perform: makeTitle)
    }

    func makeTitle() {
        Task { @MainActor in

        }
    }
}

struct CommunitySearch: View {

    @Environment(BestBikePathModel.self) private var appModel

    @State private var searchingCompletions: [MKLocalSearchCompletion] = []

    @State private var searchText: String = ""

    @State private var isSearching: Bool = false

    @State private var selectedDetent: PresentationDetent = .medium

    var body: some View {
        @Bindable var appModel = appModel
        NavigationStack {
            VStack {
                List(selection: $appModel.selectedPath) {
                    if let paths = appModel.communityResultPaths {
                        if paths.isEmpty {
                            ContentUnavailableView {
                                Label("No Paths Found", systemImage: "magnifyingglass.circle")
                            } description: {
                                Text("We couldn’t find any bike paths between your selected locations. Try adjusting your start or destination point.")
                            }
                        } else {
                            ForEach(paths, id: \.self) { path in
                                Section {
                                    PathRow(path: path)
                                        .labelReservedIconWidth(192)
                                        .frame(height: 96)
                                }
                            }
                            .listRowInsets(.leading, 8)
                            .listRowInsets(.vertical, 8)
                            .listSectionSpacing(12)
                        }
                    } else if isSearching && !searchText.isEmpty {
                        ForEach(searchingCompletions, id: \.description) { completion in
                            Button {
                                searchLocation(request: .init(completion: completion))
                                isSearching = false
                                searchText = ""
                                appModel.mapCameraPosition = .automatic
                            } label: {
                                VStack(alignment: .leading) {
                                    Text(completion.attributedTitle)
                                        .foregroundStyle(.primary)
                                        .tint(.primary)

                                    Text(completion.attributedSubtitle)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                        .tint(.secondary)
                                }
                            }
                        }
                    } else {
                        ForEach(appModel.mapItems, id: \.description) { item in
                            VStack(alignment: .leading) {
                                Text(item.name ?? "Undefined")

                                if let fullAddress = item.addressRepresentations?.fullAddress(includingRegion: false, singleLine: true) {
                                    Text(fullAddress)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .onDelete { offsets in
                            appModel.mapItems.remove(atOffsets: offsets)
                        }
                        .onMove { fromOffsets, toOffset in
                            appModel.mapItems.move(fromOffsets: fromOffsets, toOffset: toOffset)
                        }

                        Section {
                            if appModel.mapItems.isEmpty {
                                Label("Type your start location", systemImage: "bicycle")
                                    .foregroundStyle(.secondary)
                                    .frame(maxWidth: .infinity)
                                    .listRowBackground(Color.clear)
                            } else {
                                Label("Type your end location", systemImage: "bicycle")
                                    .foregroundStyle(.secondary)
                                    .frame(maxWidth: .infinity)
                                    .listRowBackground(Color.clear)
                            }
                        }
                    }
                }
                .environment(\.editMode, .constant(.active))
                .animation(.default, value: appModel.mapItems)
                .scrollContentBackground(.hidden)
                .searchable(text: $searchText, isPresented: $isSearching, prompt: "Search Community Bike Paths")
                .onSubmit(of: .search) {
                    searchLocation(request: .init(naturalLanguageQuery: searchText, region: appModel.mapRegion))
                    isSearching = false
                    searchText = ""
                    appModel.mapCameraPosition = .automatic
                }

            }
            .onChange(of: searchText) {
                suggestLocations()
            }
            .onChange(of: isSearching) {
                searchingCompletions = []
                withAnimation {
                    appModel.isRootMapForcePresented = isSearching
                }
            }
            .toolbarTitleDisplayMode(.inline)
            .navigationTitle("Community Bike Paths")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    if appModel.communityResultPaths == nil {
                        Button("Confirm", systemImage: "checkmark") {
                            appModel.searchCommunityResultPaths()
                        }
                        .fontWeight(.semibold)
                        .buttonStyle(.glassProminent)
                        .disabled(appModel.mapItems.count < 2)
                        .animation(.default, value: appModel.mapItems.count)
                    } else {
                        Button("Confirm", systemImage: "checkmark") {
                            guard let selectedPath = appModel.selectedPath else { return }
                            appModel.userSelectedPath = selectedPath
                            appModel.displayUserPath(selectedPath)
                            appModel.presentedRootModal = .userPath
                        }
                        .fontWeight(.semibold)
                        .buttonStyle(.glassProminent)
                    }
                }

                if appModel.communityResultPaths != nil {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(role: .cancel) {
                            appModel.cleanMap()
                            selectedDetent = .medium
                        }
                    }
                }
            }
            .animation(.default, value: appModel.communityResultPaths)
        }
        .presentationDetents([.medium, .large], selection: $selectedDetent)
        .onChange(of: appModel.selectedPath) {
            selectedDetent = .medium
            appModel.routes = appModel.routes
        }
        .onChange(of: appModel.communityResultPaths) {
            appModel.selectedPath = appModel.communityResultPaths?.first
            setTrips()
        }
        .onChange(of: isSearching) {
            appModel.communityResultPaths = nil
            appModel.routes = []
        }
        .presentationBackground(.thinMaterial)
        .interactiveDismissDisabled()
    }

    func setTrips() {
        Task {
            guard let paths = appModel.communityResultPaths else { return }
            var trips: [[(MKRoute, BikePathEntry)]] = []
            for path in paths {
                let route = await makeTrip(path: path)
                trips.append(route.map { ($0, path) })
            }

            withAnimation {
                appModel.routes = trips.flatMap { $0 }
            }
        }
    }

    func makeTrip(path: BikePathEntry) async -> [MKRoute] {
        let locations = path.path.streets.map { CLLocation(latitude: $0.latitude, longitude: $0.longitude) }
        let mapItems = locations.map {
            MKMapItem(location: $0, address: nil)
        }

        var trip: [MKRoute] = []
        for (source, destination) in zip(mapItems, mapItems.dropFirst()) {
            if let route = await getDirections(source: source, destination: destination) {
                trip.append(route)
            }
        }

        return trip
    }

    func getDirections(source: MKMapItem, destination: MKMapItem) async -> MKRoute? {
        let request = MKDirections.Request()
        request.source = source
        request.destination = destination
        request.transportType = .cycling

        let directions = MKDirections(request: request)
        let response = try? await directions.calculate()
        return response?.routes.first
    }

    func searchLocation(request: MKLocalSearch.Request) {
        Task { @MainActor in
            let search = MKLocalSearch(request: request)
            let response = try? await search.start()
            if let mapItem = response?.mapItems.first {
                if appModel.mapItems.count > 1 {
                    appModel.mapItems[1] = mapItem
                } else {
                    appModel.mapItems.append(mapItem)
                }
            }
        }
    }

    @State private var completer = MKLocalSearchCompleter()
    @State private var completerDelegate: LocalSearchCompleterDelegate?

    func suggestLocations() {
        completerDelegate = LocalSearchCompleterDelegate {
            searchingCompletions = $0
        }
        completer.delegate = completerDelegate!
        completer.queryFragment = searchText
        completer.region = appModel.mapRegion
    }
}

#Preview {
    AddBikePathView()
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
