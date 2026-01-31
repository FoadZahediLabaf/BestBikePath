//
//  Item.swift
//  BestBikePath
//
//  Created by Lorenzo Fiamingo on 05/11/25.
//

import Foundation
import SwiftData

@Model
final class UserModel {

    var username: String

    @Attribute(.allowsCloudEncryption)
    var password: String

    var pathEntries: [UserPathModel]

    init(username: String, password: String, pathEntries: [UserPathModel]) {
        self.username = username
        self.password = password
        self.pathEntries = pathEntries
    }
}

@Model
final class UserPathModel {

    var user: UserModel

    var date: Date

    var isPublic: Bool

    var path: BikePath

    struct Performance: Codable {
        var distance: Double
        var averageSpeed: Double
        var peakSpeed: Double
    }

    var performance: Performance?

    struct Weather: Codable {
        var temperature: Double
        var humidity: Double
        var windSpeed: Double
    }

    var weather: Weather?

    var mode: BikePathEntryMode

    var obstaclesCount: Int?

    var manualStatus: BikePathStatus?

    var automaticStatus: BikePathStatus? {
        if let obstaclesCount, let distance = performance?.distance {
            let ratio = Double(obstaclesCount) / distance

            return switch ratio {
            case ..<0.01: .excellent
            case 0.01..<0.1: .good
            case 0.1..<1: .fair
            case 1..<2: .poor
            case 2...: .impassable
            default: fatalError("This should never be executed")
            }
        } else {
            return nil
        }
    }

    var status: BikePathStatus {
        return switch mode {
        case .manual: manualStatus!
        case .automatic: automaticStatus!
        }
    }

    init(user: UserModel, date: Date, isPublic: Bool, path: BikePath, performance: Performance?, weather: Weather? = nil, mode: BikePathEntryMode, obstaclesCount: Int? = nil, manualStatus: BikePathStatus? = nil) {
        self.user = user
        self.date = date
        self.isPublic = isPublic
        self.path = path
        self.performance = performance
        self.weather = weather
        self.mode = mode
        self.obstaclesCount = obstaclesCount
        self.manualStatus = manualStatus
    }
}

enum BikePathEntryMode: String, Codable {
    case manual
    case automatic
}


@Model
final class BikePath {

    var streets: [StreetLocation]

    var hasHighways: Bool

    var entries: [UserPathModel]

    var publicStatus: BikePathStatus? {
        let publicEntries = entries.filter { $0.isPublic }
        guard let lastEntryDate = publicEntries.map(\.date).sorted().last else {
            return nil // There are no public informations
        }

        // Keep only informations where path.date is within 1 month prior to lastDate (inclusive)
        let calendar = Calendar.current
        guard let cutoff = calendar.date(byAdding: .month, value: -1, to: lastEntryDate) else {
            return nil
        }

        let validEntries = publicEntries.filter { entry in
            entry.date >= cutoff
        }

        var statusCount: [BikePathStatus: Int] = [:]
        for info in validEntries {
            statusCount[info.status, default: 0] += 1
        }

        return statusCount.max(by: { $0.value < $1.value })?.key
    }

    init(streets: [StreetLocation], hasHighways: Bool, entries: [UserPathModel] = []) {
        self.streets = streets
        self.hasHighways = hasHighways
        self.entries = entries
    }
}

@Model
final class StreetLocation {

    //var name: String

    var latitude: Double

    var longitude: Double

    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

enum BikePathStatus: Int, Codable {
    case excellent = 5 // <0.01 obstacle every 1 meter
    case good = 4 // 0.01<0.1 obstacle every 1 meter
    case fair = 3 // 0.1<1 obstacle every 1 meter
    case poor = 2 // 1<2 obstacle every 1 meter
    case impassable = 1 // >2 obstacle every 1 meter
}


extension UserPathModel {
    static func makeLecCom() -> UserPathModel {
        UserPathModel(
            user: .init(username: "test", password: "test", pathEntries: []),
            date: .now,
            isPublic: true,
            path: BikePath(streets: [
                StreetLocation(latitude: 45.8566, longitude: 9.3977),
                StreetLocation(latitude: 45.8081, longitude: 9.0852)
            ], hasHighways: false),
            performance: nil,
            weather: nil,
            mode: .manual,
            obstaclesCount: nil,
            manualStatus: .excellent
        )
    }

    static func makeLecCanCom() -> UserPathModel {
        UserPathModel(
            user: .init(username: "test", password: "test", pathEntries: []),
            date: .now,
            isPublic: true,
            path: BikePath(streets: [
                StreetLocation(latitude: 45.8566, longitude: 9.3977),
                StreetLocation(latitude: 45.8466, longitude: 9.2725),
                StreetLocation(latitude: 45.8081, longitude: 9.0852)
            ], hasHighways: false),
            performance: nil,
            weather: nil,
            mode: .manual,
            obstaclesCount: nil,
            manualStatus: .good
        )
    }

    static func makeLecOggCom() -> UserPathModel {
        UserPathModel(
            user: .init(username: "test", password: "test", pathEntries: []),
            date: .now,
            isPublic: true,
            path: BikePath(streets: [
                StreetLocation(latitude: 45.8566, longitude: 9.3977),
                StreetLocation(latitude: 45.7964, longitude: 9.3473),
                StreetLocation(latitude: 45.8081, longitude: 9.0852)
            ], hasHighways: false),
            performance: nil,
            weather: nil,
            mode: .manual,
            obstaclesCount: nil,
            manualStatus: .poor
        )
    }

    static func makeLecCantCom() -> UserPathModel {
        UserPathModel(
            user: .init(username: "test", password: "test", pathEntries: []),
            date: .now,
            isPublic: true,
            path: BikePath(streets: [
                StreetLocation(latitude: 45.8566, longitude: 9.3977),
                StreetLocation(latitude: 45.7360, longitude: 9.1270),
                StreetLocation(latitude: 45.7696, longitude: 9.2721),
                StreetLocation(latitude: 45.8081, longitude: 9.0852)
            ], hasHighways: false),
            performance: nil,
            weather: nil,
            mode: .manual,
            obstaclesCount: nil,
            manualStatus: .impassable
        )
    }

    static func makeMilBre() -> UserPathModel {
        UserPathModel(
            user: .init(username: "test", password: "test", pathEntries: []),
            date: .now,
            isPublic: true,
            path: BikePath(streets: [
                StreetLocation(latitude: 45.4642, longitude: 9.1900),
                StreetLocation(latitude: 45.5416, longitude: 10.2118)
            ], hasHighways: false),
            performance: nil,
            weather: nil,
            mode: .manual,
            obstaclesCount: nil,
            manualStatus: .fair
        )
    }

    static func makeMilCreBre() -> UserPathModel {
        UserPathModel(
            user: .init(username: "test", password: "test", pathEntries: []),
            date: .now,
            isPublic: true,
            path: BikePath(streets: [
                StreetLocation(latitude: 45.4642, longitude: 9.1900),
                StreetLocation(latitude: 45.3625, longitude: 9.6844),
                StreetLocation(latitude: 45.5416, longitude: 10.2118)
            ], hasHighways: false),
            performance: nil,
            weather: nil,
            mode: .manual,
            obstaclesCount: nil,
            manualStatus: .fair
        )
    }

    static func makeMilBerBre() -> UserPathModel {
        UserPathModel(
            user: .init(username: "test", password: "test", pathEntries: []),
            date: .now,
            isPublic: true,
            path: BikePath(streets: [
                StreetLocation(latitude: 45.4642, longitude: 9.1900),
                StreetLocation(latitude: 45.6983, longitude: 9.6773),
                StreetLocation(latitude: 45.5416, longitude: 10.2118)
            ], hasHighways: false),
            performance: nil,
            weather: nil,
            mode: .manual,
            obstaclesCount: nil,
            manualStatus: .fair
        )
    }
}
