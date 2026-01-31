import CoreMotion
import CoreLocation

@Observable
class MotionManager {
    static var shared = MotionManager()

    let activityManager = CMMotionActivityManager()

    var authorizationStatus: CMAuthorizationStatus

    let motionManager = CMMotionManager()

    init() {
        self.authorizationStatus = CMMotionActivityManager.authorizationStatus()
    }

    func requestMotionAuthorization() {
        let activityManager = CMMotionActivityManager()
        let today = Date()

        // Eseguiamo una query per un brevissimo intervallo di tempo
        // per forzare il sistema a mostrare il prompt di autorizzazione
        activityManager.queryActivityStarting(from: today, to: today, to: .main) { (activities, error) in

            self.authorizationStatus = CMMotionActivityManager.authorizationStatus()

            activityManager.stopActivityUpdates()
        }
    }

    var motionActivityStream: AsyncStream<CMMotionActivity?> {
        AsyncStream { continuation in
            continuation.onTermination = { termination in
                Task { @MainActor in
                    self.activityManager.stopActivityUpdates()
                }
            }

            if CMMotionActivityManager.isActivityAvailable() {
                activityManager.startActivityUpdates(to: .main) { (activity) in
                    print("Attività rilevata: \(activity)")
                    continuation.yield(activity)
                }
            }
        }
    }

    class ObstacleDetectionCoordinator {
        var lastDetection: Date = .now
    }
    let obstacleDetectionCoordinator = ObstacleDetectionCoordinator()

    var obstacleDetectionStream: AsyncStream<UUID> {
        AsyncStream { continuation in
            continuation.onTermination = { termination in
                Task { @MainActor in
                    self.motionManager.stopDeviceMotionUpdates()
                }
            }

            if motionManager.isDeviceMotionAvailable {
                // Frequenza di campionamento alta per non perdere il picco
                motionManager.deviceMotionUpdateInterval = 1 / 50

                motionManager.startDeviceMotionUpdates(to: .main) { (data, error) in
                    guard let data = data else { return }

                    let accelX = data.userAcceleration.x
                    let accelY = data.userAcceleration.y
                    let accelZ = data.userAcceleration.z

                    let threshold: Double = 3 // Da testare
                    let totalAcceleration = sqrt(pow(accelX, 2) + pow(accelY, 2) + pow(accelZ, 2))

                    if totalAcceleration > threshold && self.obstacleDetectionCoordinator.lastDetection.timeIntervalSinceNow <= -5 {
                        self.obstacleDetectionCoordinator.lastDetection = .now
                        print("Buca rilevata! Intensità: \(totalAcceleration) G")
                        continuation.yield(UUID())
                    }
                }
            }
        }
    }
}
