import Foundation

enum SubscriptionRefreshInterval {
    static func seconds(from rawValue: String?) -> TimeInterval? {
        guard let rawValue else {
            return nil
        }

        let value = rawValue.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let unit = value.last else {
            return nil
        }

        let numberPart = value
            .dropLast()
            .trimmingCharacters(in: .whitespacesAndNewlines)
        guard let number = Double(numberPart), number.isFinite, number > 0 else {
            return nil
        }

        let multiplier: TimeInterval
        switch String(unit).lowercased() {
        case "s":
            multiplier = 1
        case "m":
            multiplier = 60
        case "h":
            multiplier = 60 * 60
        case "d":
            multiplier = 24 * 60 * 60
        default:
            return nil
        }

        let seconds = number * multiplier
        return seconds.isFinite ? seconds : nil
    }

    static func nanoseconds(from seconds: TimeInterval) -> UInt64? {
        let nanoseconds = seconds * 1_000_000_000
        guard nanoseconds.isFinite,
              nanoseconds > 0,
              nanoseconds <= TimeInterval(UInt64.max) else {
            return nil
        }
        return UInt64(nanoseconds.rounded(.up))
    }
}
