import UIKit

public extension NSAttributedString {
    
    convenience init(htmlString html: String, font: UIFont? = nil, color: UIColor = UIColor.black, linkFont: UIFont? = nil, linkColor: UIColor = .blue,  useDocumentFontSize: Bool = true, minimumFontSize: CGFloat = 16) throws {
        
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        let data = html.data(using: .utf8, allowLossyConversion: true)
        guard (data != nil), let fontDescriptor = font?.fontDescriptor, let attr = try? NSMutableAttributedString(data: data!, options: options, documentAttributes: nil) else {
            try self.init(data: data ?? Data(html.utf8), options: options, documentAttributes: nil)
            return
        }
        
        let range = NSRange(location: 0, length: attr.length)
        attr.enumerateAttribute(.font, in: range, options: .longestEffectiveRangeNotRequired) { attrib, range, _ in
            if let htmlFont = attrib as? UIFont {
                let traits = htmlFont.fontDescriptor.symbolicTraits
                var descrip = fontDescriptor
                
                if (traits.rawValue & UIFontDescriptor.SymbolicTraits.traitBold.rawValue) != 0 {
                    if let descripWithTraitBold = descrip.withSymbolicTraits(.traitBold) {
                        descrip = descripWithTraitBold
                    }
                }
                
                if (traits.rawValue & UIFontDescriptor.SymbolicTraits.traitItalic.rawValue) != 0 {
                    if let descripWithTraitItalic = descrip.withSymbolicTraits(.traitItalic) {
                        descrip = descripWithTraitItalic
                    }
                }
                
                if (attrib as? NSURL) == nil {
                    let size = htmlFont.pointSize < minimumFontSize ? minimumFontSize : htmlFont.pointSize
                    attr.addAttribute(.font, value: UIFont(descriptor: descrip, size: size), range: range)
                    attr.addAttribute(.foregroundColor, value: color, range: range)
                }
            }
        }
        attr.enumerateAttribute(.link, in: range, options: .longestEffectiveRangeNotRequired) {attrib, range, _ in
            if (attrib as? NSURL) != nil {
                if let font = linkFont {
                    attr.addAttribute(.font, value: font, range: range)
                }
                attr.addAttribute(.foregroundColor, value: linkColor, range: range)
                attr.addAttribute(.underlineColor, value: linkColor, range: range)
                attr.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
                
            }
        }
        
        self.init(attributedString: attr)
    }
    
    func attributedStringByTrimmingCharacterSet(charSet: CharacterSet) -> NSAttributedString {
        let modifiedString = NSMutableAttributedString(attributedString: self)
        modifiedString.trimCharactersInSet(charSet: charSet)
        return NSAttributedString(attributedString: modifiedString)
    }
}

extension NSMutableAttributedString {
    public func trimCharactersInSet(charSet: CharacterSet) {
        var range = (string as NSString).rangeOfCharacter(from: charSet as CharacterSet)
        
        // Trim leading characters from character set.
        while range.length != 0 && range.location == 0 {
            replaceCharacters(in: range, with: "")
            range = (string as NSString).rangeOfCharacter(from: charSet)
        }
        
        // Trim trailing characters from character set.
        range = (string as NSString).rangeOfCharacter(from: charSet, options: .backwards)
        while range.length != 0 && NSMaxRange(range) == length {
            replaceCharacters(in: range, with: "")
            range = (string as NSString).rangeOfCharacter(from: charSet, options: .backwards)
        }
    }
}
