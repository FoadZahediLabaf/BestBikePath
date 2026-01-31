import SwiftUI

struct CommunityPathRow: View {

    @Environment(BestBikePathModel.self) private var appModel

    let path: CommunityPath

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
            "75%"
        case .fair:
            "50%"
        case .poor:
            "25%"
        case .impassable:
            "0%"
        }
    }

    var hasHighway: Bool {
        let routes = appModel.mapCoordinator.cachedPathRoutes[path.path.id] ?? []
        return routes.contains(where: \.hasHighways)
    }

    var body: some View {
        Label {
            VStack {
                Gauge(value: statusValue, in: 1...5) {
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
            VStack {
                if hasHighway {
                    HStack {
                        Text("Highway Detected")
                            .foregroundStyle(.black)
                        
                        Image(systemName: "exclamationmark.triangle")
                            .symbolRenderingMode(.multicolor)
                    }
                    .font(.caption.weight(.semibold))
                    .frame(maxWidth: .infinity)
                }

                PathMap(path.path, margin: 1.2)
                    .allowsHitTesting(false)
                    .cornerRadius(16)
            }
        }
    }
}
