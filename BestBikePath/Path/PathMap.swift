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

    private let path: Path

    private let initialPosition: MapCameraPosition

    init(_ path: Path, margin: Double? = nil) {
        let locations = path.locations.map(\.location)
        self.path = path

        if let margin, let boundingRegion = boundingRegion(for: locations, margin: margin) {
            initialPosition = .region(boundingRegion)
        } else {
            initialPosition = .automatic
        }
    }

    var body: some View {
        Map(initialPosition: initialPosition, interactionModes: []) {
            ForEach(routes, id: \.description) { route in
                MapPolyline(route)
                    .stroke(Color.accent, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .bevel))
            }
        }
        .task {
            routes = (try? await makeRoutes(from: path)) ?? []
        }
    }
}


private func boundingRegion(for locations: [CLLocation], margin: Double) -> MKCoordinateRegion? {
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

private func makeRoutes(from path: Path) async throws -> [MKRoute] {
    let mapItems: [MKMapItem] = path.locations
        .map { CLLocation(latitude: $0.latitude, longitude: $0.longitude) }
        .map { MKMapItem(location: $0, address: nil) }

    return try await makeRoutes(from: mapItems)
}

// Here we also reduce the number of MKRoute as much as we can, in this way we can then use them to represent the path with the minimum number of coordinates
private func makeRoutes(from mapItems: [MKMapItem]) async throws -> [MKRoute] {
    guard mapItems.count > 1 else { return [] }
    var routes: [MKRoute] = []
    guard var comparedRoute = try await makeRoute(source: mapItems.first!, destination: mapItems.last!) else { return [] }
    var dividerMapItem: MKMapItem = mapItems.first!

    for mapItem in mapItems {
        if !mapItemIntersectsRoute(mapItem: mapItem, route: comparedRoute) {
            guard let previousRoute = try await makeRoute(source: dividerMapItem, destination: mapItem) else { return [] }
            guard let nextRoute = try await makeRoute(source: mapItem, destination: mapItems.last!) else { return [] }
            routes.append(previousRoute)
            comparedRoute = nextRoute
            dividerMapItem = mapItem
        }
    }
    routes.append(comparedRoute)
    return routes
}

private func makeRoute(source: MKMapItem, destination: MKMapItem) async throws -> MKRoute? {
    let request = MKDirections.Request()
    request.source = source
    request.destination = destination
    request.transportType = .cycling

    let directions = MKDirections(request: request)
    let response = try await directions.calculate()
    return response.routes.first
}

private func mapItemIntersectsRoute(mapItem: MKMapItem,
                          route: MKRoute,
                          tolerance: Measurement<UnitLength> = Measurement(value: 25, unit: .meters)) -> Bool {

    // 1. Convertiamo la tolleranza in metri (Double)
    let toleranceInMeters = tolerance.converted(to: .meters).value

    // 2. Convertiamo la coordinata dell'utente in un punto sulla mappa
    let userPoint = MKMapPoint(mapItem.location.coordinate)

    // 3. Otteniamo i punti della polilinea
    let routePoints = route.polyline.points()
    let pointCount = route.polyline.pointCount

    // 4. Trasformiamo la tolleranza in metri in "MapPoints"
    // Nota: la scala cambia in base alla latitudine
    let metersPerMapPoint = MKMetersPerMapPointAtLatitude(mapItem.location.coordinate.latitude)
    let toleranceInMapPoints = toleranceInMeters / metersPerMapPoint

    // 5. Iteriamo sui segmenti della rotta
    for i in 0..<pointCount - 1 {
        let p1 = routePoints[i]
        let p2 = routePoints[i+1]

        // Calcoliamo la distanza minima tra il punto utente e il segmento (p1, p2)
        let distance = distanceToSegment(p: userPoint, a: p1, b: p2)
        if distance <= toleranceInMapPoints {
            return true
        }
    }

    return false
}

// Funzione di supporto geometrico: Distanza tra un punto e un segmento
private func distanceToSegment(p: MKMapPoint, a: MKMapPoint, b: MKMapPoint) -> Double {
    let l2 = pow(a.x - b.x, 2) + pow(a.y - b.y, 2)
    if l2 == 0 { return sqrt(pow(p.x - a.x, 2) + pow(p.y - a.y, 2)) }

    // Proiezione del punto sulla retta
    var t = ((p.x - a.x) * (b.x - a.x) + (p.y - a.y) * (b.y - a.y)) / l2
    t = max(0, min(1, t)) // Vincoliamo t tra 0 e 1 per restare sul segmento

    let projection = MKMapPoint(x: a.x + t * (b.x - a.x),
                                y: a.y + t * (b.y - a.y))

    return sqrt(pow(p.x - projection.x, 2) + pow(p.y - projection.y, 2))
}
