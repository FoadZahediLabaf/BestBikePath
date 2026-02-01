import SwiftUI
import MapKit

struct LocalSearchCompletionRow: View {

    let completion: MKLocalSearchCompletion

    var body: some View {
            VStack(alignment: .leading) {
                Text(completion.attributedTitle)
                    .foregroundStyle(.primary)
                    .tint(.primary)

                Text(completion.attributedSubtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .tint(.secondary)
            }
    }
}
