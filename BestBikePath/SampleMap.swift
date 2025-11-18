////
////  AddBikePathManuallyView.swift
////  BestBikePath
////
////  Created by Lorenzo Fiamingo on 06/11/25.
////
//
//import SwiftUI
//import MapKit
//
//struct AddBikePathManuallyView: View {
//
//    @Environment(BestBikePathModel.self) private var appModel
//
//    @State private var routes: [MKRoute] = []
//
//    @State private var mapItems: [MKMapItem] = []
//
//    @State private var searchingCompletions: [MKLocalSearchCompletion] = []
//
//    @State private var selectedItem: MKMapItem?
//
//    @State private var searchText = ""
//
//    @State private var isSearching = false
//
//    private static let smallDetent: PresentationDetent = .height(180)
//
//    @State private var selectedDetent: PresentationDetent = Self.smallDetent
//
//    @State private var mapCameraPosition: MapCameraPosition = .automatic
//
//    @State private var rate: Double = 1
//
//    @State private var sharePublicly = true
//
//    var rateSlider: some View {
//        LabeledContent {
//            ZStack(alignment: .trailing) {
//                Text("Impassable")
//                    .hidden()
//                switch rate {
//                case ..<2:
//                    Text("Impassable")
//                case 2..<3:
//                    Text("Poor")
//                case 3..<4:
//                    Text("Fair")
//                case 4..<5:
//                    Text("Good")
//                case 5...:
//                    Text("Excellent")
//                default:
//                    Text("Error")
//                }
//            }
//        } label: {
//            HStack {
//                Text("Path Status")
//                    .padding(.trailing)
//                    .padding(.trailing)
//
//                Slider(value: $rate, in: 1...5) {
//                    Text("Path Status")
//                } ticks: {
//                    SliderTickContentForEach(
//                        stride(from: 1.0, through: 5.0, by: 1).map { $0 },
//                        id: \.self
//                    ) { value in
//                        SliderTick(value)
//                    }
//                }
//            }
//        }
//    }
//
//    var body: some View {
//        NavigationStack {
//                Map(position: $mapCameraPosition) {
//                    UserAnnotation()
//
//                    ForEach(mapItems, id: \.description) { mapItem in
//                        Marker(item: mapItem)
//                    }
//
//                    ForEach(routes, id: \.description) { route in
//                        MapPolyline(route)
//                            .stroke(.blue, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .bevel))
//                    }
//                }
//                .mapControls {
//                    MapUserLocationButton()
//                    MapCompass()
//                    MapScaleView()
//                    MapPitchToggle()
//                }
//                .safeAreaInset(edge: .bottom) {
//                    Spacer()
//                        .frame(height: 472)
//                }
//                .sheet(isPresented: .constant(true), content: {
//                    NavigationStack {
//                        List {
//                            if isSearching && !searchText.isEmpty {
//                                ForEach(searchingCompletions, id: \.description) { completion in
//                                    Button {
//                                        searchLocation(query: completion.title + ", " + completion.subtitle)
//                                        isSearching = false
//                                        searchText = ""
//                                        mapCameraPosition = .automatic
//                                    } label: {
//                                        VStack(alignment: .leading) {
//                                            Text(completion.attributedTitle)
//                                                .foregroundStyle(.primary)
//                                                .tint(.primary)
//
//                                            Text(completion.attributedSubtitle)
//                                                .font(.caption)
//                                                .foregroundStyle(.secondary)
//                                                .tint(.secondary)
//                                        }
//                                    }
//                                }
//                            } else {
//                                Section {
//                                    rateSlider
//
//                                    Toggle("Share Pubblicly", isOn: $sharePublicly)
//                                }
//
//                                ForEach(mapItems, id: \.description) { item in
//                                    VStack(alignment: .leading) {
//                                        Text(item.name ?? "Undefined")
//
//                                        if let fullAddress = item.addressRepresentations?.fullAddress(includingRegion: false, singleLine: true) {
//                                            Text(fullAddress)
//                                                .font(.caption)
//                                                .foregroundStyle(.secondary)
//                                        }
//                                    }
//                                }
//                                .onDelete { offsets in
//                                    mapItems.remove(atOffsets: offsets)
//                                }
//                                .onMove { fromOffsets, toOffset in
//                                    mapItems.move(fromOffsets: fromOffsets, toOffset: toOffset)
//                                }
//
//                                Section {
//                                    if mapItems.isEmpty {
//                                        Label("Type your start location", systemImage: "bicycle")
//                                            .foregroundStyle(.secondary)
//                                            .frame(maxWidth: .infinity)
//                                            .listRowBackground(Color.clear)
//                                    } else if mapItems.count < 2 {
//                                        Label("Type your end location", systemImage: "bicycle")
//                                            .foregroundStyle(.secondary)
//                                            .frame(maxWidth: .infinity)
//                                            .listRowBackground(Color.clear)
//                                    }
//                                }
//                            }
//                        }
//                        .environment(\.editMode, .constant(.active))
//                        .animation(.default, value: mapItems)
//                        .scrollContentBackground(.hidden)
//                        .searchable(text: $searchText, isPresented: $isSearching)
//                        .onSubmit(of: .search) {
//                            searchLocation(query: searchText)
//                            isSearching = false
//                            searchText = ""
//                            mapCameraPosition = .automatic
//                        }
//                        .onChange(of: searchText) {
//                            suggestLocations()
//                        }
//                        .onChange(of: isSearching) {
//                            searchingCompletions = []
//                        }
//                        .onChange(of: mapItems) {
//                            setTrip()
//                        }
//                        .toolbarTitleDisplayMode(.inline)
//                        .navigationTitle("Create a new Bike Path")
//                        .toolbar {
//                            ToolbarItem(placement: .primaryAction) {
//                                Button("Confirm", systemImage: "checkmark") {
//                                    appModel.presentedRootModal = .searchCommunityPaths
//                                }
//                                    .fontWeight(.semibold)
//                                    .buttonStyle(.glassProminent)
//                                    .disabled(mapItems.count < 2)
//                            }
//                            ToolbarItem(placement: .cancellationAction) {
//                                Button(role: .cancel) {
//                                    appModel.presentedRootModal = .searchCommunityPaths
//                                }
//                            }
//                        }
//                    }
//                    .presentationDetents([.medium], selection: $selectedDetent)
//                    .presentationBackground(.thinMaterial)
//                    .presentationBackgroundInteraction(.enabled)
//                    .interactiveDismissDisabled()
//                })
//        }
//    }
//
//    func setTrip() {
//        Task {
//            var trip: [MKRoute] = []
//            for (source, destination) in zip(mapItems, mapItems.dropFirst()) {
//                if let route = await getDirections(source: source, destination: destination) {
//                    trip.append(route)
//                }
//            }
//            routes = trip
//        }
//    }
//
//    func getDirections(source: MKMapItem, destination: MKMapItem) async -> MKRoute? {
//        let request = MKDirections.Request()
//        request.source = source
//        request.destination = destination
//        request.transportType = .cycling
//
//        let directions = MKDirections(request: request)
//        let response = try? await directions.calculate()
//        return response?.routes.first
//    }
//
//    func searchLocation(query: String) {
//        let request = MKLocalSearch.Request()
//        request.naturalLanguageQuery = query
//
//        Task { @MainActor in
//            let search = MKLocalSearch(request: request)
//            let response = try? await search.start()
//            if let mapItem = response?.mapItems.first {
//                mapItems.append(mapItem)
//            }
//        }
//    }
//
//    @State private var completer = MKLocalSearchCompleter()
//    @State private var completerDelegate: LocalSearchCompleterDelegate?
//
//    func suggestLocations() {
//        completerDelegate = LocalSearchCompleterDelegate {
//            searchingCompletions = $0
//        }
//        completer.delegate = completerDelegate!
//        completer.queryFragment = searchText
//        if let region = mapCameraPosition.region {
//            completer.region = region
//        }
//    }
//}
//
//#Preview {
//    AddBikePathManuallyView()
//}
//
//
//    private class LocalSearchCompleterDelegate: NSObject, MKLocalSearchCompleterDelegate {
//        var onResult: ([MKLocalSearchCompletion]) -> Void
//        func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
//            onResult(completer.results)
//        }
//        init(onResult: @escaping ([MKLocalSearchCompletion]) -> Void) {
//            self.onResult = onResult
//        }
//    }
//
//
//extension MKLocalSearchCompletion {
//    var attributedTitle: AttributedString {
//        var s = AttributedString(title)
//        for range in self.titleHighlightRanges {
//            let start = s.index(s.startIndex, offsetByCharacters: range.rangeValue.lowerBound)
//            let end = s.index(s.startIndex, offsetByCharacters: range.rangeValue.upperBound)
//
//            s[start..<end].font = .body.bold()
//        }
//        return s
//    }
//
//    var attributedSubtitle: AttributedString {
//        var s = AttributedString(subtitle)
//        for range in self.subtitleHighlightRanges {
//            let start = s.index(s.startIndex, offsetByCharacters: range.rangeValue.lowerBound)
//            let end = s.index(s.startIndex, offsetByCharacters: range.rangeValue.upperBound)
//
//            s[start..<end].font = .caption.bold()
//        }
//        return s
//    }
//}
