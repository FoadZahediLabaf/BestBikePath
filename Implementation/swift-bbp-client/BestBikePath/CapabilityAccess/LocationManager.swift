import CoreLocation

@Observable
class LocationManager {
    static var shared = LocationManager()

    class Coordinator: NSObject, CLLocationManagerDelegate {

        var onChangeAuthorizationStatus: ((CLAuthorizationStatus) -> Void)?

        var onLocationsUpdateHandlers: [Int :(([CLLocation]) -> Void)] = [:]

        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            onChangeAuthorizationStatus?(manager.authorizationStatus)
        }

        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            for handler in onLocationsUpdateHandlers.values {
                handler(locations)
            }
        }
    }
    let coordinator: Coordinator

    let manager = CLLocationManager()

    var authorizationStatus: CLAuthorizationStatus

    init() {
        self.authorizationStatus = manager.authorizationStatus
        self.coordinator = Coordinator()
        coordinator.onChangeAuthorizationStatus = { [weak self] status in
            self?.authorizationStatus = status
        }
        manager.delegate = coordinator
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.pausesLocationUpdatesAutomatically = true
    }

    func requestAlwaysAuthorization() {
        manager.requestAlwaysAuthorization()
    }

    var locationsStream: AsyncStream<[CLLocation]> {
        AsyncStream { continuation in
            continuation.onTermination = { termination in
                Task { @MainActor in
                    self.coordinator.onLocationsUpdateHandlers[continuation.hashValue] = nil
                    if self.coordinator.onLocationsUpdateHandlers.isEmpty {
                        self.manager.stopUpdatingLocation()
                    }
                }
            }
            coordinator.onLocationsUpdateHandlers[continuation.hashValue] = { locations in
                continuation.yield(locations)
            }
            if coordinator.onLocationsUpdateHandlers.count < 2 {
                self.manager.startUpdatingLocation()
            }
        }
    }
}
