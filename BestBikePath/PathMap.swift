//
//  PathMap.swift
//  BestBikePath
//
//  Created by Lorenzo Fiamingo on 08/11/25.
//

import MapKit
import SwiftUI

struct PathMap: View {

    @State private var routes: [MKRoute] = []

    private var mapItems: [MKMapItem] = []

    private var initialPosition: MapCameraPosition?

    init(_ path: BikePathEntry, margin: Double? = nil) {
        let locations = path.path.streets.map { CLLocation(latitude: $0.latitude, longitude: $0.longitude) }
        self.mapItems = locations.map {
            MKMapItem(location: $0, address: nil)
        }

        if let margin {
            initialPosition = .region(boundingRegion(for: locations, margin: margin)!)
        }
    }

    var body: some View {
        Map(initialPosition: initialPosition ?? .automatic, interactionModes: []) {
            //            if let mapItem = mapItems.first {
            //                Marker(item: mapItem)
            //            }
            //
            //            if let mapItem = mapItems.last {
            //                Marker(item: mapItem)
            //            }

            ForEach(routes, id: \.description) { route in
                MapPolyline(route)
                    .stroke(.blue, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .bevel))
            }
        }
        .task {
            setTrip()
        }
    }

    func setTrip() {
        Task {
            var trip: [MKRoute] = []
            for (source, destination) in zip(mapItems, mapItems.dropFirst()) {
                if let route = await getDirections(source: source, destination: destination) {
                    trip.append(route)
                }
            }
            routes = trip
        }
    }

    func getDirections(source: MKMapItem, destination: MKMapItem) async -> MKRoute? {
        let request = MKDirections.Request()
        request.source = source
        request.destination = destination
        request.transportType = .cycling

        let directions = MKDirections(request: request)
        let response = try? await directions.calculate()
        return response?.routes.first
    }

    func boundingRegion(for locations: [CLLocation], margin: Double) -> MKCoordinateRegion? {
        guard !locations.isEmpty else { fatalError() }

        // Compute min/max lat/lon
        var minLat = locations.first!.coordinate.latitude
        var maxLat = locations.first!.coordinate.latitude
        var minLon = locations.first!.coordinate.longitude
        var maxLon = locations.first!.coordinate.longitude

        for location in locations.dropFirst() {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            minLat = min(minLat, lat)
            maxLat = max(maxLat, lat)
            minLon = min(minLon, lon)
            maxLon = max(maxLon, lon)
        }

        // Center
        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )

        // Span (+ a small padding)
        let span = MKCoordinateSpan(
            latitudeDelta: (maxLat - minLat) * margin,
            longitudeDelta: (maxLon - minLon) * margin
        )
        print(span)

        return MKCoordinateRegion(center: center, span: span)
    }

}
