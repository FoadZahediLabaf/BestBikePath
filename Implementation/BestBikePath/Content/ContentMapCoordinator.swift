import MapKit
import SwiftUI

struct ContentMapCoordinator {
    
    var mapCameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    
    var coordinateRegion: MKCoordinateRegion = MKCoordinateRegion()
    
    var mapItems: [MKMapItem] = []
    
    var highlightedRoutes: [MKRoute] = []

    var subtleRoutes: [MKRoute] = []

    var cachedPathRoutes: [Path.ID :[MKRoute]] = [:]

    var monitoredLocations: [CLLocation] = []

    var isContentPresented: Bool {
        !(mapItems.isEmpty && highlightedRoutes.isEmpty && subtleRoutes.isEmpty)
    }

    mutating func reset() {
        self = ContentMapCoordinator()
    }
    
    mutating func resetCameraPosition() {
        mapCameraPosition = .userLocation(fallback: .automatic)
    }

    mutating func addMapItem(from localSearchRequest: MKLocalSearch.Request) async throws {
        let search = MKLocalSearch(request: localSearchRequest)
        let response = try await search.start()
        if let mapItem = response.mapItems.first {
            mapItems.append(mapItem)
        }
    }

    mutating func displayPath(from path: Path) async throws {
        guard
            let start = await path.locations.first?.mapItemGeocoded,
            let end = await path.locations.last?.mapItemGeocoded
        else {
            return
        }

        let routes = try await makeRoutes(from: path)
        highlightedRoutes = routes
        mapItems = [start, end]
    }

    mutating func makeCachedPathRoutes(from paths: [Path]) async throws {
        cachedPathRoutes.removeAll()
        for path in paths {
            let routes = try await makeRoutes(from: path)
            cachedPathRoutes[path.id] = routes
        }
        subtleRoutes = cachedPathRoutes.values.flatMap(\.self)
    }

    mutating func selectCachedPathRoutes(id: Path.ID?) {
        subtleRoutes = cachedPathRoutes.filter { $0.key != id }.values.flatMap(\.self)
        if let id {
            highlightedRoutes = cachedPathRoutes[id, default: []]
        } else {
            highlightedRoutes = []
        }
    }

    mutating func setHighlightedRoutesFromMapItems() async throws {
        highlightedRoutes = try await makeRoutes(from: mapItems)
    }

    mutating func setHighlightedRoutesFromMonitoredLocations() async throws {
        guard
            let startLocation = monitoredLocations.first,
            let endLocation = monitoredLocations.last
        else {
            return
        }
        let internalLocations = monitoredLocations.dropFirst().dropLast()

        let startMapItem = await PathLocation(from: startLocation.coordinate).mapItemGeocoded
        let endMapItem = await PathLocation(from: endLocation.coordinate).mapItemGeocoded
        let internalMapItems = internalLocations.map { MKMapItem(location: $0, address: nil) }

        let mapItems = [startMapItem] + internalMapItems + [endMapItem]

        highlightedRoutes = try await makeRoutes(from: mapItems)
        monitoredLocations = []
        self.mapItems = [startMapItem, endMapItem]
    }

    mutating func makePathFromHighlightedRoutes() -> Path {
        makePath(from: highlightedRoutes)
    }
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

private func makePath(from routes: [MKRoute]) -> Path {
    guard !routes.isEmpty else { return Path(id: UUID().uuidString, locations: []) }
    var initialRoutes = routes
    let lastRoute = initialRoutes.removeLast()
    var steps: [MKRoute.Step] = []
    for initialRoute in initialRoutes where initialRoute.steps.count > 1 {
        var stepsToAdd = initialRoute.steps
        stepsToAdd.removeLast()
        steps.append(contentsOf: stepsToAdd)
    }
    steps += lastRoute.steps
    let pathLocations = steps.map(\.polyline.coordinate).map { PathLocation(from: $0) }
    return Path(id: UUID().uuidString, locations: pathLocations)
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
