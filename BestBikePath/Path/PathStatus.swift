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
}
