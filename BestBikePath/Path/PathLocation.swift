import MapKit

struct PathLocation: Hashable, Codable {

    let latitude: Double

    let longitude: Double
}

extension PathLocation {

    init(from coordinate: CLLocationCoordinate2D) {
        self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }

    init(from mapItem: MKMapItem) {
        self.init(from: mapItem.location.coordinate)
    }
}
