//
//  ContentView.swift
//  BestBikePath
//
//  Created by Lorenzo Fiamingo on 05/11/25.
//

import SwiftUI
import SwiftData

struct AccountView: View {

    @Environment(BestBikePathModel.self) private var appModel

    @Environment(\.dismiss) private var dismiss

    @State private var isDeleteAccountConfirmationShown: Bool = false
    @State private var isSignOutConfirmationShown: Bool = false

    var body: some View {
        List {
            Section {
                Label("John Appleseed", systemImage: "person")
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)

                Label("john.appleseed@bbp.com" as String, systemImage: "envelope")
                    .foregroundStyle(.primary)
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
                    Button("Sign Out", role: .destructive) {
                        appModel.user = nil
                    }
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("You’ll need to sign in again to access your account.")
                }

                Button("Delete Account", systemImage: "xmark.rectangle.portrait.fill", role: .destructive) {
                    isDeleteAccountConfirmationShown = true
                    dismiss()
                }
            }
            .confirmationDialog("Delete account", isPresented: $isDeleteAccountConfirmationShown, titleVisibility: .visible) {
                Button("Delete Account", role: .destructive) {
                    appModel.user = nil
                    dismiss()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This action is permanent and will remove your data.")
            }
        }
        .navigationTitle("Account")
    }
}

#Preview {
    @Previewable @State var appModel = BestBikePathModel()

    NavigationStack {
        AccountView()
    }
    .modelContainer(for: User.self, inMemory: true)
    .environment(appModel)
}
