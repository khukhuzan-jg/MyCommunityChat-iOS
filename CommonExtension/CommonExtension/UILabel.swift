import Foundation
import UIKit

public extension UILabel {
    typealias MethodHandler = () -> Void
    func highlightPartOf(
        _ text: String,
        normalColor: UIColor,
        normalFont: UIFont,
        highlightText: [String],
        highlightColor: UIColor,
        highlightFont: UIFont,
        lineSpacing: CGFloat = 1,
        setUnderline: Bool = false
    ) {
        
        self.numberOfLines = 0
        
        let nsString = text as NSString
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = lineSpacing
        paragraphStyle.alignment = self.textAlignment
        
        let attributedString = NSMutableAttributedString(string: text, attributes: [
            .paragraphStyle: paragraphStyle,
            .font: normalFont,
            .foregroundColor: normalColor
        ])
        
        var highlightRanges: [NSRange] = []
        for highlight in highlightText {
            let range = nsString.range(of: highlight)
            attributedString.addAttributes([
                .foregroundColor: highlightColor,
                .font: highlightFont,
            ], range: range)
            if setUnderline {
                attributedString.addAttributes([
                    .underlineStyle: NSUnderlineStyle.single.rawValue,
                    .underlineColor: highlightColor
                ], range: range)
            }
            highlightRanges.append(range)
        }
        self.attributedText = attributedString;
    }
    
    // https://medium.com/@aroavi07/changing-line-spacing-in-a-uilabel-swift-5-538ad0591229
    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {
        guard let labelText = self.text else { return }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        // (Swift 4.2 and above) Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        // (Swift 4.1 and 4.0) Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        self.attributedText = attributedString
    }
    
    
    
      public  func addRangeGesture(stringRange: String, function: @escaping MethodHandler) {
            RangeGestureRecognizer.stringRange = stringRange
            RangeGestureRecognizer.function = function
            self.isUserInteractionEnabled = true
            let tapgesture: UITapGestureRecognizer = RangeGestureRecognizer(target: self, action: #selector(tappedOnLabel(_ :)))
            tapgesture.numberOfTapsRequired = 1
            self.addGestureRecognizer(tapgesture)
        }

    @objc func tappedOnLabel(_ gesture: RangeGestureRecognizer) {
        guard let text = self.text else { return }
        let stringRange = (text as NSString).range(of: RangeGestureRecognizer.stringRange ?? "")
        if gesture.didTapAttributedTextInLabel(label: self, inRange: stringRange) {
            guard let existedFunction = RangeGestureRecognizer.function else { return }
            existedFunction()
        }
    }
}
