import UIKit

extension UIDevice {
    
    public var hasTopNotch: Bool {
        if #available(iOS 11.0, tvOS 11.0, *) {
            return UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0 > 20
        }
        return false
    }
    
    public var topNotch: CGFloat {
        if #available(iOS 11.0, tvOS 11.0, *) {
            return UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
        }
        return 0
    }
}
