import UIKit

public extension UIButton {
    
    func setImageSpacing(spacing: CGFloat) {
        let insetAmount = spacing / 2.0;
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
        self.titleEdgeInsets = UIEdgeInsets(top:0, left: insetAmount, bottom: 0, right: -insetAmount);
        self.contentEdgeInsets = UIEdgeInsets(top:0, left: insetAmount, bottom: 0, right: insetAmount);
    }
    
    func setTitleUnderLine(title: String) {
        let myNormalAttributedTitle = NSAttributedString(
            string: title,
            attributes: [
                NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue
            ]
        )
        
        self.setAttributedTitle(myNormalAttributedTitle, for: .normal)
    }
}
