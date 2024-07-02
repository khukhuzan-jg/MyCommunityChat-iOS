import UIKit

public extension UITextView {
    var numberOfLines: CGFloat {
        guard let lineHeight = font?.lineHeight else { return 0 }
        return contentSize.height / lineHeight
    }
}

