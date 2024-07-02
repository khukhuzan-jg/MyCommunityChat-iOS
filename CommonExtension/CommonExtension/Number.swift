import Foundation

public extension FloatingPoint {
    var isInteger: Bool {
        return rounded() == self
    }
}
