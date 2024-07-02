import Foundation

public extension Double {
    func rounded(descimalCount: Int) -> Double {
        let divisor = pow(10.0, Double(descimalCount))
        return (self * divisor).rounded() / divisor
    }
    
    func hasDecimalValue(descimalCount: Int? = nil) -> Bool {
        if let descimal = descimalCount {
            return self.rounded(descimalCount: descimal).truncatingRemainder(dividingBy: 1) != 0
        }
        return self.truncatingRemainder(dividingBy: 1) != 0
    }
    
    func toString(descimalCount: Int) -> String {
        if descimalCount == 0 {
            return String(format: "%.0f", self)
        }
        return String(format: "%.\(descimalCount)f", self)
    }
    
    mutating func toTwoDecimalFormat() -> Double {
        return ceil(self*1000)/1000
    }
    
    func toThreeDecimalFormatText() -> String {
        
        if self.isInfinite || self.isNaN {
            return "0"
        } else  if floor(self) == self {
            return "\(Int(self))"
        } else {
            return String(format: "%.3f", self)
        }
    }
    
    /// get Price Format
    func toFormattedPrice() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        let fromattedPrice = formatter.string(from: self as NSNumber)!
        return String("$\(fromattedPrice)")
    }
}
