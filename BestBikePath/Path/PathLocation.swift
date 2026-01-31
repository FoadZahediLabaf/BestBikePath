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

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var location: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }

    var mapItem: MKMapItem {
        MKMapItem(location: location, address: nil)
    }

    var mapItemGeocoded: MKMapItem {
        get async {
            if let mapItem = try? await MKReverseGeocodingRequest(location: location)?.mapItems.first {
                mapItem
            } else {
                mapItem
            }
        }
    }
}
