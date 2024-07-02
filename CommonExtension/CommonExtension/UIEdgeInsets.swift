import UIKit

public extension UIEdgeInsets {
    init(all: CGFloat) {
        self.init(top: all, left: all, bottom: -all, right: -all)
    }
    
    init(leftRight: CGFloat) {
        self.init(top: 0, left: leftRight, bottom: 0, right: -leftRight)
    }
    
    init(left: CGFloat) {
        self.init(top: 0, left: left, bottom: 0, right: 0)
    }
    
    init(right: CGFloat) {
        self.init(top: 0, left: 0, bottom: 0, right: -right)
    }
}
