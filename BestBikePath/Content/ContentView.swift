//
//  ContentView.swift
//  BestBikePath
//
//  Created by Lorenzo Fiamingo on 05/11/25.
//

import MapKit
import SwiftUI
import SwiftData

struct ContentView: View {

    @Environment(BestBikePathModel.self) private var appModel

    @State private var searchPathQuery: String = ""

    @ViewBuilder
    var map: some View {
        @Bindable var appModel = appModel

        Map(position: $appModel.mapCameraPosition) {
            UserAnnotation()

            ForEach(appModel.mapItems, id: \.description) { mapItem in
                Marker(item: mapItem)
            }

            let routes: [(route: MKRoute, isHighlighted: Bool)] = appModel.routes.map { route in
                let isHighlighted: Bool = route.path.map { $0 == appModel.selectedPath } ?? true
                return (route.route, isHighlighted)
            }.sorted { !$0.isHighlighted && $1.isHighlighted }

            ForEach(routes, id: \.route.description) { (route, isHighlighted) in
                MapPolyline(route)
                    .stroke(isHighlighted ? Color.blue : Color.blue.mix(with: .white, by: 0.5), style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .bevel))
            }
        }
        .animation(.default, value: appModel.selectedPath)
        .onMapCameraChange {
            appModel.mapRegion = $0.region
        }
        .mapControls {
            MapUserLocationButton()
            MapCompass()
            MapScaleView()
            MapPitchToggle()
        }
    }

    var userScrollView: some View {
        ScrollView {
            if appModel.user == nil {
                ContentUnavailableView {
                    Label("Not Signed In", systemImage: "person.slash.fill")
                } description: {
                    Text("You need to sign in to create new bike paths, but you can still search for community bike paths.")
                } actions: {
                    Button("Sign In ", systemImage: "person.fill") {
                        appModel.presentedSheetItem = .authentication
                    }
                }
            } else if appModel.userPaths.isEmpty {
                ContentUnavailableView {
                    Label("No Bike Paths Yet", systemImage: "bicycle.circle")
                } description: {
                    Text("You haven’t recorded or saved any bike paths yet. Start tracking your first ride or explore routes shared by the community.")
                }
            } else {
                Section {
                    ScrollView(.horizontal) {
                        HStack {
                            //                            addPathButton
                            //                                .aspectRatio(3/2, contentMode: .fill)
                            //                                .containerRelativeFrame(.horizontal) { (l, _) in l*2/5 }

                            ForEach(appModel.userPaths) { path in
                                Button {
                                    appModel.userSelectedPath = path
                                    appModel.displayUserPath(path)
                                    //appModel.presentedSheetItem = .pathDetail
                                } label: {
                                    PathMap(path)
                                        .allowsHitTesting(false)
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .aspectRatio(3/2, contentMode: .fill)
                                .containerRelativeFrame(.horizontal) { (l, _) in l*3/5 }
                                .background(.background.secondary)
                                .cornerRadius(24)
                            }
                        }
                        .scrollTargetLayout()
                        .scenePadding(.horizontal)
                    }
                    .scrollIndicators(.hidden)
                    .scrollTargetBehavior(.viewAligned)
                } header: {
                    Text("Your Bike Paths")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .scenePadding(.horizontal)
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            if appModel.user != nil {
                HStack {
                    Button("Record Path", systemImage: "record.circle") {
                        appModel.openRecordingView()
                    }
                    .tint(.red)

                    Button("Add Path", systemImage: "plus.circle") {
                        appModel.presentedSheetItem = .pathInsertion
                    }
                    .tint(.accentColor)
                }
                .buttonStyle(.bordered)
                .buttonSizing(.flexible)
                .controlSize(.extraLarge)
                .fontWeight(.medium)
                .scenePadding(.horizontal)
                .padding(.vertical)
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .defaultScrollAnchor(.center)
        .animation(.default, value: appModel.userPaths)
        .animation(.default, value: appModel.user)
    }

    var body: some View {
        @Bindable var appModel = appModel

        ZStack {
            userScrollView

            map
                .blur(radius: appModel.isRootMapPresented ? 0 : 32)
                .opacity(appModel.isRootMapPresented ? 1 : 0)
                .animation(.default, value: appModel.isRootMapPresented)
        }
        .navigationTitle("Best Bike Paths")
        .toolbarTitleDisplayMode(.inlineLarge)
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Account", systemImage: "person.crop.circle") {
                    if appModel.user == nil {
                        appModel.presentedSheetItem = .authentication
                    } else {
                        appModel.presentedSheetItem = .account
                    }
                }
            }
        })
        .safeAreaInsetsSheet(item: Binding($appModel.presentedSheetItem, default: .pathBrowsing), isAppliedToMap: appModel.isRootMapPresented) { item in
            switch item {
            case .pathBrowsing:
                CommunitySearch()
                    .presentationBackgroundInteraction(.enabled(upThrough: .medium))
            case .authentication:
                NavigationStack {
                    AuthenticationView()
                        .toolbarTitleDisplayMode(.inlineLarge)
                }
                .presentationDetents([.medium, .large])
                .presentationBackgroundInteraction(.enabled(upThrough: .medium))
            case .account:
                NavigationStack {
                    AccountView()
                        .toolbarTitleDisplayMode(.inlineLarge)
                }
                .presentationDetents([.medium, .large])
                .presentationBackgroundInteraction(.enabled(upThrough: .medium))
            case .locationAccess:
                NavigationStack {
                    LocationAccessView()
                        .toolbarTitleDisplayMode(.inlineLarge)
                }
                .presentationDetents([.large])
            case .pathInsertion:
                NavigationStack {
                    AddBikePathView()
                }
                .presentationDetents([.medium, .large])
                .presentationBackgroundInteraction(.enabled(upThrough: .medium))
                .interactiveDismissDisabled()
            case .pathRecording:
                NavigationStack {
                    RecordBikePathView()
                }
                .presentationDetents([.height(240), .fraction(0.8)])
                .presentationBackgroundInteraction(.enabled(upThrough: .fraction(0.8)))
                .interactiveDismissDisabled()
            default:
                EmptyView()
            }

        }
        .animation(.default, value: appModel.user == nil)
        //        .sheet(isPresented: appModel.isPresentingRootModal(.userPath)) {
        //            NavigationStack {
        //                UserPathView()
        //                    .toolbarTitleDisplayMode(.inlineLarge)
        //            }
        //            .presentationDetents([.medium, .large])
        //        }
    }


    var addPathButton: some View {
        Button {
            appModel.presentedSheetItem = .pathRecording
        } label: {
            VStack {
                Image(systemName: "plus.circle.fill")
                    .font(.title)

                Text("Add new path")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .buttonSizing(.flexible)
        .buttonBorderShape(.roundedRectangle(radius: 24))
        .controlSize(.extraLarge)
        .fontWeight(.medium)
    }
}

#Preview {
    @Previewable @State var appModel = BestBikePathModel()

    NavigationStack {
        ContentView()
    }
    .modelContainer(for: User.self, inMemory: true)
    .environment(appModel)
}
