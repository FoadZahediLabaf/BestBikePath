//
//  ContentView.swift
//  BestBikePath
//
//  Created by Lorenzo Fiamingo on 05/11/25.
//

import AsyncButton
import SwiftUI
import SwiftData
import MapKit

struct UserAccountView: View {

    @Environment(BestBikePathModel.self) private var appModel

    let user: User

    @Environment(\.dismiss) private var dismiss

    @State private var isDeleteAccountConfirmationShown: Bool = false
    @State private var isSignOutConfirmationShown: Bool = false

    var body: some View {
        @Bindable var appModel = appModel
        List {
            Section {
                Label(user.displayName, systemImage: "person")
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)

                Label(user.email, systemImage: "envelope")
                    .foregroundStyle(.primary)
            }

            Section {
                Picker("Map Style", selection: $appModel.contentMapStyle) {
                    ForEach(ContentMapStyle.allCases, id: \.self) { mapStyle in
                        mapStyle.title
                    }
                }
            }

            Section {
                NavigationLink {
                    Text("Terms of Service")
                        .navigationTitle("Terms of Service")
                } label: {
                    Label("Terms of Service", systemImage: "doc.text")
                }

                NavigationLink {
                    Text("Conditions of Use")
                        .navigationTitle("Conditions of Use")
                } label: {
                    Label("Conditions of Use", systemImage: "doc.text")
                }

                NavigationLink {
                    Text("Community Guidelines")
                        .navigationTitle("Community Guidelines")
                } label: {
                    Label("Community Guidelines", systemImage: "person.3")
                }
            }

            Section {
                Button("Sign Out", systemImage: "rectangle.portrait.and.arrow.right", role: .destructive) {
                    isSignOutConfirmationShown = true
                }
                .confirmationDialog("Sign out", isPresented: $isSignOutConfirmationShown, titleVisibility: .visible) {
                    AsyncButton("Sign Out", role: .destructive) {
                        try await appModel.userSource.signOut()
                        appModel.presentedSheetItem = .communityPathSearch
                    }
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("You’ll need to sign in again to access your account.")
                }

                Button("Delete Account", systemImage: "xmark.rectangle.portrait.fill", role: .destructive) {
                    isDeleteAccountConfirmationShown = true
                }
            }
            .confirmationDialog("Delete account", isPresented: $isDeleteAccountConfirmationShown, titleVisibility: .visible) {
                AsyncButton("Delete Account", role: .destructive) {
                    try await appModel.userSource.deleteUser(email: user.email)
                    appModel.presentedSheetItem = .communityPathSearch
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This action is permanent and will remove your data.")
            }
        }
        .navigationTitle("Account")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(role: .cancel) {
                    appModel.mapCoordinator.reset()
                    appModel.presentedSheetItem = .communityPathSearch
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var appModel = BestBikePathModel()

    NavigationStack {
        UserAccountView(user: .test)
    }
    .modelContainer(for: UserModel.self, inMemory: true)
    .environment(appModel)
}
