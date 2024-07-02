import Foundation

public enum DateComponentType {
    case day, month, year
}

public extension Locale {
    static let sg = Locale(identifier: "en_SG")
    static let en = Locale(identifier: "EN")
}

public extension TimeZone {
    static let sg = TimeZone(abbreviation: "SGT")
    static let utc = TimeZone(abbreviation: "UTC")!
}

public extension Date {
    
    func toYear(_ year: Int) -> Date {
        let currentYear = Calendar.current.component(.year, from: Date())
        guard year < currentYear else { return self }
        let difference = currentYear - year
        return Date().adjust(component: .year, offset: -difference)
    }
    
    func adjust(component: DateComponentType, offset: Int) -> Date {
        switch component {
        case .day:
            break
        case .month:
            break
        case .year:
            return Calendar.current.date(byAdding: .year, value: offset, to: self, wrappingComponents: true) ?? self
        }
        
        return self
    }
    
    // Date Custom Formatting
    func toStringWith(_ format: DateFormat, _ locale: Locale = .en, _ calendarIdentifier: Calendar.Identifier = .gregorian, setGMT0: Bool = false) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = locale
        dateFormatter.calendar = Calendar(identifier: calendarIdentifier)
        dateFormatter.dateFormat = format.rawValue
        if setGMT0 { dateFormatter.timeZone = TimeZone(secondsFromGMT:0) }
        let strDate = dateFormatter.string(from: self)
        return strDate
    }
    
    func add(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
    
    func add(days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    
    func add(years: Int) -> Date {
        return Calendar.current.date(byAdding: .year, value: years, to: self)!
    }
    
    // https://stackoverflow.com/questions/44086555/swift-time-ago-from-parse-createdat-date
    func timeAgoDisplay(hourString: String = "hours") -> String {
        
        let calendar = Calendar.current
        let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date())!
        let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date())!
        let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date())!
        
        if minuteAgo < self {
            let diff = Calendar.current.dateComponents([.second], from: self, to: Date()).second ?? 0
            return "\(diff) seconds ago"
        } else if hourAgo < self {
            let diff = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0
            return "\(diff) mins ago"
        } else if dayAgo < self {
            let diff = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour ?? 0
            return "\(diff) \(hourString) ago"
        } else {
            let diff = Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
            if diff < 2 {
                return "\(diff) day ago"
            } else if diff < 6 {
                return "\(diff) days ago"
            } else {
                return self.toStringWith(.type3)
            }
        }
    }
    
    var nextDay: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self, wrappingComponents: true) ?? self
    }
    
    func toString(_ format: DateFormat = .type25, setLocalTimeZone: Bool = false) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        formatter.locale = .en
        formatter.timeZone = setLocalTimeZone ? .current : TimeZone(secondsFromGMT: 0)
        return formatter.string(from: self)
    }
    
    func toString(_ format: DateFormat = .type25, timeZone: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        formatter.locale = .en
        formatter.timeZone = TimeZone(identifier: timeZone)
        return formatter.string(from: self)
    }
    
    func setTime(hour: Int, min: Int, sec: Int, timeZoneAbbrev: String? = nil) -> Date? { //"UTC"
        let x: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let cal = Calendar.current
        var components = cal.dateComponents(x, from: self)
        
        if let tz = timeZoneAbbrev {
            components.timeZone = TimeZone(abbreviation: tz)
        }
        components.hour = hour
        components.minute = min
        components.second = sec
        
        return cal.date(from: components)
    }
    
    var isToday: Bool {
        let gregorian = Calendar(identifier: .gregorian)
        let thisDate = gregorian.dateComponents([.day, .month, .year], from: self)
        let currentDate = gregorian.dateComponents([.day, .month, .year], from: Date())
        return thisDate == currentDate
    }
    
    var day: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: self)
        return components.day ?? 1
    }
    
    var getDay: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        formatter.locale = .en
        let day = formatter.string(from: self)
        return day.uppercased()
    }
    
    var getMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        let month = formatter.string(from: self)
        return month
    }
}

public extension Date {
    static func currentUTCTime(_ format: DateFormat) -> String? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = format.rawValue
        return formatter.string(from: Date())
    }
}

extension Date {
    public func convertToTimeZone(initTimeZone: TimeZone, timeZone: TimeZone) -> Date {
         let delta = TimeInterval(timeZone.secondsFromGMT(for: self) - initTimeZone.secondsFromGMT(for: self))
         return addingTimeInterval(delta)
    }
}

extension Date {
    func dateFormatWithSuffix() -> String {
        return "d'\(self.daySuffix())' MMMM yyyy"
    }
    
    func daySuffix() -> String {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components(.day, from: self)
        let dayOfMonth = components.day
        switch dayOfMonth {
        case 1, 21, 31:
            return "st"
        case 2, 22:
            return "nd"
        case 3, 23:
            return "rd"
        default:
            return "th"
        }
    }
    
    public func billingDateString() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = date.dateFormatWithSuffix()
        return dateFormatter.string(from: Date())
    }
}
