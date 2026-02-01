import SwiftUI
import MapKit

enum ContentMapStyle: CaseIterable {
    case standard
    case hybrid

    var mapStyle: MapStyle {
        switch self {
        case .standard:
                .standard
        case .hybrid:
                .hybrid(elevation: .realistic)
        }
    }

    var title: Text {
        switch self {
        case .standard:
            Text("Explore")
        case .hybrid:
            Text("Satellite")
        }
    }
}
