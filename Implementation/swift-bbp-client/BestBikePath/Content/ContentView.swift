import MapKit
import SwiftUI
import SwiftData
import AsyncButton

struct ContentView: View {

    @Environment(BestBikePathModel.self) private var appModel

    @State private var searchPathQuery: String = ""

    var userScrollView: some View {
        ScrollView {
            VStack {
                if let currentUserPaths = appModel.currentUserPaths, !currentUserPaths.isEmpty {
                    Section {
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(currentUserPaths) { userPath in
                                    AsyncButton {
                                        try await appModel.presentUserPathDetail(userPath)
                                    } label: {
                                        PathMap(userPath.path)
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
                } else if let currentUserPaths = appModel.currentUserPaths, currentUserPaths.isEmpty {
                    ContentUnavailableView {
                        Label("No Bike Paths Yet", systemImage: "figure.outdoor.cycle")
                    } description: {
                        Text("Insert a new path or start tracking your first ride.")
                    }
                } else if appModel.userSource.currentUser == nil {
                    ContentUnavailableView {
                        Label("Not Signed In", systemImage: "person.slash.fill")
                    } description: {
                        Text("You need to sign in to create new bike paths, but you can still search for community bike paths.")
                    } actions: {
                        Button("Sign In", systemImage: "person.fill") {
                            appModel.presentedSheetItem = .userAuthentication
                        }
                    }
                } else if appModel.syncCurrentUserPathsError != nil {
                    ContentUnavailableView {
                        Label("No Bike Paths Found", systemImage: "exclamationmark.circle")
                    } description: {
                        Text("An error occurred while syncing your bike paths.")
                    } actions: {
                        Button("Try Again", systemImage: "arrow.2.circlepath") {
                            Task {
                                await appModel.syncCurrentUserPaths()
                            }
                        }
                    }
                } else {
                    ProgressView {
                        Label("Loading your paths", systemImage: "figure.outdoor.cycle")
                    }
                    .controlSize(.extraLarge)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .containerRelativeFrame(.vertical)
        }
        .transition(.opacity)
        .animation(.default, value: appModel.currentUserPaths)
        .safeAreaInset(edge: .bottom) {
            if appModel.userSource.currentUser != nil {
                HStack {
                    Button("Record Path", systemImage: "record.circle") {
                        appModel.nextSuggestedRoutesForUserPathRecording = nil
                        appModel.presentUserPathRecording()
                    }
                    .tint(.red)

                    Button("Add Path", systemImage: "plus.circle") {
                        appModel.presentedSheetItem = .userPathInsertion
                        appModel.mapCoordinator.reset()
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
        .animation(.default, value: appModel.currentUserPaths)
        .animation(.default, value: appModel.userSource.currentUser)
    }

    var body: some View {
        @Bindable var appModel = appModel

        ZStack {
            userScrollView

            ContentMap()
                .blur(radius: appModel.isMapPresented ? 0 : 32)
                .opacity(appModel.isMapPresented ? 1 : 0)
                .animation(.default, value: appModel.isMapPresented)
                .onChange(of: appModel.presentedSheetItem) {
                    if ![.communityPathDetail, .userPathDetail].contains(appModel.presentedSheetItem.role) {
                        appModel.mapCoordinator.reset()
                    }
                    appModel.searchedCommunityPaths = nil
                    appModel.isSearchingCommunityPaths = false
                }
        }
        .navigationTitle("Best Bike Path")
        .toolbarTitleDisplayMode(.inlineLarge)
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Account", systemImage: "person.crop.circle") {
                    if let user = appModel.userSource.currentUser {
                        appModel.presentedSheetItem = .userAccount(user: user)
                    } else {
                        appModel.presentedSheetItem = .userAuthentication
                    }
                }
            }
        })
        .safeAreaInsetsSheet(item: Binding($appModel.presentedSheetItem, default: .communityPathSearch), isAppliedToMap: appModel.isMapPresented) { item in
            switch item.role {
            case .communityPathSearch:
                CommunityPathSearch()
                    .presentationBackgroundInteraction(.enabled(upThrough: .medium))
                    .interactiveDismissDisabled()
            case .communityPathDetail:
                if let communityPath = item.communityPath {
                    NavigationStack {
                        CommunityPathDetailView(communityPath: communityPath)
                            .toolbarTitleDisplayMode(.inlineLarge)
                    }
                    .presentationDetents([.medium, .large])
                    .presentationBackgroundInteraction(.enabled(upThrough: .medium))
                    .interactiveDismissDisabled()
                }
            case .userAuthentication:
                NavigationStack {
                    UserAuthenticationView()
                        .toolbarTitleDisplayMode(.large)
                }
                .presentationDetents([.large])
                .interactiveDismissDisabled()
                //.presentationBackgroundInteraction(.enabled(upThrough: .medium))
            case .userAccount:
                if let user = item.user {
                    NavigationStack {
                        UserAccountView(user: user)
                            .toolbarTitleDisplayMode(.large)
                    }
                    .presentationDetents([.large])
                    .interactiveDismissDisabled()
                    // .presentationBackgroundInteraction(.enabled(upThrough: .medium))
                }
            case .locationAccess:
                NavigationStack {
                    LocationAccessView(nextAction: appModel.presentUserPathRecording)
                        .toolbarTitleDisplayMode(.inlineLarge)
                }
                .presentationDetents([.large])
                .interactiveDismissDisabled()
            case .motionAccess:
                NavigationStack {
                    MotionAccessView(nextAction: appModel.presentUserPathRecording)
                        .toolbarTitleDisplayMode(.inlineLarge)
                }
                .presentationDetents([.large])
                .interactiveDismissDisabled()
            case .userPathInsertion:
                NavigationStack {
                    UserPathInsertionView()
                }
                .presentationDetents([.medium, .large])
                .presentationBackgroundInteraction(.enabled(upThrough: .medium))
                .interactiveDismissDisabled()
            case .userPathRecording:
                NavigationStack {
                    UserPathRecordingView()
                }
                .presentationDetents([.height(240), .fraction(0.8), .large], selection: $appModel.userPathRecordingPresentationDetent)
                .presentationBackgroundInteraction(.enabled(upThrough: .fraction(0.8)))
                .interactiveDismissDisabled()
            case .userPathDetail:
                if let userPath = item.userPath {
                    NavigationStack {
                        UserPathDetailView(userPath: userPath)
                            .toolbarTitleDisplayMode(.inlineLarge)
                    }
                    .presentationDetents([.medium, .large])
                    .presentationBackgroundInteraction(.enabled(upThrough: .medium))
                    .interactiveDismissDisabled()
                }
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .animation(.default, value: appModel.userSource.currentUser == nil)
    }


    var addPathButton: some View {
        Button {
            appModel.presentedSheetItem = .userPathRecording
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
    .modelContainer(for: UserModel.self, inMemory: true)
    .environment(appModel)
}
