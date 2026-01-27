import CoreLocation

@Observable
class LocationManager {
    static var shared = LocationManager()

    class Coordinator: NSObject, CLLocationManagerDelegate {

        var onChangeAuthorizationStatus: ((CLAuthorizationStatus) -> Void)?

        var onLocationUpdate: ((CLLocation?) -> Void)?

        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            onChangeAuthorizationStatus?(manager.authorizationStatus)
        }

        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            onLocationUpdate?(locations.last)
        }

    }
    let coordinator: Coordinator

    let manager = CLLocationManager()

    var authorizationStatus: CLAuthorizationStatus

    var location: CLLocation?

    init() {
        self.authorizationStatus = manager.authorizationStatus
        self.coordinator = Coordinator()
        coordinator.onChangeAuthorizationStatus = { [weak self] status in
            self?.authorizationStatus = status
        }
        coordinator.onLocationUpdate = { [weak self] location in
            self?.location = location
        }
        manager.delegate = coordinator
    }

    func requestAlwaysAuthorization() {
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.requestAlwaysAuthorization()
    }

    func startUpdatingLocation() {
        manager.startUpdatingLocation()
    }
}
