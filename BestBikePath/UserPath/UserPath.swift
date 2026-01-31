import Foundation

struct UserPath: Identifiable, Hashable, Codable {

    let id: String

    let userId: String

    var date: Date

    var isPublic: Bool

    var path: Path

    var status: PathStatus

    struct Performance: Hashable, Codable {

        var distance: Measurement<UnitLength>

        var averageSpeed: Measurement<UnitSpeed>

        var peakSpeed: Measurement<UnitSpeed>
    }

    var performance: Performance?

    struct Weather: Hashable, Codable {

        var temperature: Measurement<UnitTemperature>

        var humidity: Measurement<UnitPercent>

        var windSpeed: Measurement<UnitSpeed>
    }

    var weather: Weather?
}

