import SwiftUI
import CoreMotion

// MARK: - View

struct MotionAccessView: View {
    var motionManager: MotionManager = .shared
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

                Text("Motion access is required to automatically track your cycling sessions and identify road hazards.")
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(.top)

                VStack {
                    PermissionRow(
                        icon: "figure.outdoor.cycle",
                        title: "Motion Activity",
                        subtitle: "We use your motion data to detect cycling activity and automatically log your rides."
                    )

                    PermissionRow(
                        icon: "bicycle.sensor.tag.radiowaves.left.and.right",
                        title: "Impact Detection",
                        subtitle: "Access the accelerometer to detect potholes or road hazards while you are riding."
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
                if [.notDetermined].contains(motionManager.authorizationStatus) {
                    Button("Continue", action: motionManager.requestMotionAuthorization)
                        .buttonStyle(.borderedProminent)
                        .buttonSizing(.flexible)
                        .controlSize(.extraLarge)
                        .fontWeight(.semibold)
                        .scenePadding(.horizontal)
                }

                if [.restricted].contains(motionManager.authorizationStatus) {
                    Text("Motion access is not available on this device.")
                        .foregroundStyle(.secondary)
                        .padding()
                        .background(.background.secondary)
                        .clipShape(.containerRelative)
                        .scenePadding()
                        .frame(maxWidth: .infinity)
                }

                if [.denied].contains(motionManager.authorizationStatus) {
                    Text("You previously denied motion access. To use this feature, please enable location access in System Settings.")
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

                if [.authorized].contains(motionManager.authorizationStatus) {
                    Text("You already authorized motion access on this device.")
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
        .onChange(of: motionManager.authorizationStatus) {
            if [.authorized].contains(motionManager.authorizationStatus) {
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
