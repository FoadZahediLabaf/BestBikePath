import SwiftUI
import CoreLocation

// MARK: - View

struct LocationAccessView: View {
    var locationManager: LocationManager = BestBikePathModel.locationManager
    var nextAction: () -> Void
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL

    var body: some View {
        ScrollView {
            VStack {
                Text("Required Permissions")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                    .padding(.horizontal)

                Text("Location access is needed to automatically record your routes.")
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(.top)

                VStack {
                    PermissionRow(
                        icon: "location.fill",
                        title: "Location Access",
                        subtitle: "Track your position to record bike paths."
                    )

                    PermissionRow(
                        icon: "location.circle.fill",
                        title: "Background Location",
                        subtitle: "Keep recording while the app is in the background."
                    )
                }
                .padding(.top)
                .padding(.top)
            }
            .frame(maxWidth: .infinity)
            .scenePadding(.horizontal)
            .scenePadding()
        }
        .safeAreaInset(edge: .bottom) {
            VStack {
                if [.notDetermined].contains(locationManager.authorizationStatus) {
                    Button("Continue", action: locationManager.requestAlwaysAuthorization)
                        .buttonStyle(.borderedProminent)
                        .buttonSizing(.flexible)
                        .controlSize(.extraLarge)
                        .fontWeight(.semibold)
                        .scenePadding(.horizontal)
                }

                if [.restricted].contains(locationManager.authorizationStatus) {
                    Text("Location access is not available on this device.")
                        .foregroundStyle(.secondary)
                        .padding()
                        .background(.background.secondary)
                        .clipShape(.containerRelative)
                        .scenePadding()
                        .frame(maxWidth: .infinity)
                }

                if [.denied].contains(locationManager.authorizationStatus) {
                    Text("You previously denied location access. To use this feature, please enable location access in System Settings.")
                        .foregroundStyle(.secondary)
                        .padding()
                        .background(.background.secondary)
                        .clipShape(.containerRelative)
                        .scenePadding()

                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        Button("Open Settings") {
                            openURL(url)
                        }
                            .buttonStyle(.borderedProminent)
                            .buttonSizing(.flexible)
                            .controlSize(.extraLarge)
                            .fontWeight(.semibold)
                            .scenePadding(.horizontal)
                    }
                }

                if [.authorizedAlways, .authorizedWhenInUse].contains(locationManager.authorizationStatus) {
                    Text("You already authorized location access on this device.")
                        .foregroundStyle(.secondary)
                        .padding()
                        .background(.background.secondary)
                        .clipShape(.containerRelative)
                        .scenePadding()
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", systemImage: "xmark", role: .cancel, action: dismiss.callAsFunction)
                    .fontWeight(.semibold)
            }
        }
        .onChange(of: locationManager.authorizationStatus) {
            if [.authorizedAlways, .authorizedWhenInUse].contains(locationManager.authorizationStatus) {
                nextAction()
            }
        }
    }
}

// MARK: - Row

private struct PermissionRow: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(Color(.tertiarySystemFill))
                    .frame(width: 44, height: 44)

                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color.accentColor)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.leading)
        }
        .padding(.vertical, 4)
    }
}
