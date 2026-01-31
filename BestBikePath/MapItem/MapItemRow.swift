import SwiftUI
import MapKit

struct MapItemRow: View {

    let item: MKMapItem

    var body: some View {
        VStack(alignment: .leading) {
            Text(item.name ?? "Undefined")

            if let fullAddress = item.addressRepresentations?.fullAddress(includingRegion: false, singleLine: true) {
                Text(fullAddress)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
