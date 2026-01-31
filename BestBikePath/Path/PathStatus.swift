import Foundation

enum PathStatus: Int, Codable {
    case impassable = 1
    case poor = 2
    case fair = 3
    case good = 4
    case excellent = 5
}

extension PathStatus {

    init(sliderRawValue: Double) {
        self = switch sliderRawValue {
        case ..<2:
                .impassable
        case 2..<3:
                .poor
        case 3..<4:
                .fair
        case 4..<5:
                .good
        case 5...:
                .excellent
        default:
                .impassable
        }
    }

    init(obstaclesCount: Int, distance: Measurement<UnitLength>) {
        let obstacelPerKm = Double(obstaclesCount) / distance.converted(to: .kilometers).value

            self = switch obstacelPerKm {
            case ..<1:
                    .excellent
            case 1..<3:
                    .good
            case 3..<5:
                    .fair
            case 7..<9:
                    .poor
            case 9...:
                    .impassable
            default:
                    .impassable
            }
    }
}
