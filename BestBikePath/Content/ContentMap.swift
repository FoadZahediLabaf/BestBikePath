import SwiftUI
import MapKit

struct ContentMap: View {

    @Environment(BestBikePathModel.self) private var appModel

    private var locationManager = BestBikePathModel.locationManager

    var body: some View {
        @Bindable var appModel = appModel

        Map(position: $appModel.mapCoordinator.mapCameraPosition) {
            UserAnnotation()

            ForEach(appModel.mapCoordinator.mapItems, id: \.description) { mapItem in
                Marker(item: mapItem)
            }

            ForEach(appModel.mapCoordinator.highlightedRoutes, id: \.description) { route in
                MapPolyline(route)
                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .bevel))
            }

            ForEach(appModel.mapCoordinator.subtleRoutes, id: \.description) { route in
                MapPolyline(route)
                    .stroke(Color.blue.mix(with: .white, by: 0.5), style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .bevel))
            }
        }
        .animation(.default, value: appModel.mapCoordinator.mapCameraPosition)
        .animation(.default, value: appModel.selectedCommunityPath)
        .onMapCameraChange {
            appModel.mapCoordinator.coordinateRegion = $0.region
        }
        .mapControls {
            if [.authorizedAlways, .authorizedWhenInUse].contains(locationManager.authorizationStatus) {
                MapUserLocationButton()
            }
            MapCompass()
            MapScaleView()
            MapPitchToggle()
        }
    }
}

#Preview {
    @Previewable @State var appModel = BestBikePathModel()
    @Previewable @State var isLocationAuthorizationViewPresented = false
    @Previewable @State var isTestSheetPresented = false
    @Previewable var locationManager = BestBikePathModel.locationManager

    NavigationStack {
        ContentMap()
            .onAppear {
                if ![.authorizedAlways, .authorizedWhenInUse].contains(locationManager.authorizationStatus) {
                    isLocationAuthorizationViewPresented = true
                }
            }
            .sheet(isPresented: $isLocationAuthorizationViewPresented) {
                NavigationStack {
                    LocationAccessView()
                }
            }
            .safeAreaInsetsSheet(isPresented: $isTestSheetPresented, isAppliedToMap: true) {
                Text("Test")
                    .presentationDetents([.height(100), .medium, .large])
                    .presentationBackgroundInteraction(.enabled(upThrough: .medium))
            }
            .navigationTitle("Content Map")
            .toolbarTitleDisplayMode(.inlineLarge)
            .toolbar {
                Button("Present Test Sheet", systemImage: "square.2.stack.3d.bottom.fill") {
                    isTestSheetPresented = true
                }
            }
    }
    .environment(appModel)
}

