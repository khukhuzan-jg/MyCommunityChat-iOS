//
//  FontFamily.swift
//  CommonUI
//
//  Created by kukuzan on 21/08/2024.
//

import UIKit

public enum FontFamily: String, CaseIterable {
    case regular = "MuktaMahee-Regular"
    case light = "MuktaMahee-Light"
    case medium = "MuktaMahee-Medium"
    case bold = "MuktaMahee-Bold"
    case semiBold = "MuktaMahee-SemiBold"
    case extraBold = "MuktaMahee-ExtraBold"
    case extraLight = "MuktaMahee-ExtraLight"
    
    func of(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: self.rawValue, size: size) else {
            return .systemFont(ofSize: size) // fatalError("Unable to load font.")
        }
        return font
    }
}

public extension UIFont {
    
    static var mukHR8: UIFont { FontFamily.regular.of(size: 8) }
    static var mukHR10: UIFont { FontFamily.regular.of(size: 10) }
    static var mukHR12: UIFont { FontFamily.regular.of(size: 12) }
    static var mukHR14: UIFont { FontFamily.regular.of(size: 14) }
    static var mukHR16: UIFont { FontFamily.regular.of(size: 16) }

    static var mukHB8: UIFont { FontFamily.bold.of(size: 8) }
    static var mukHB10: UIFont { FontFamily.bold.of(size: 10) }
    static var mukHB12: UIFont { FontFamily.bold.of(size: 12) }
    static var mukHB14: UIFont { FontFamily.bold.of(size: 14) }
    static var mukHB16: UIFont { FontFamily.bold.of(size: 16) }
    static var mukHB20: UIFont { FontFamily.bold.of(size: 20) }
    static var mukHB24: UIFont { FontFamily.bold.of(size: 24) }
    static var mukHB28: UIFont { FontFamily.bold.of(size: 28) }
    static var mukHB32: UIFont { FontFamily.bold.of(size: 32) }

    static var mukHM10: UIFont { FontFamily.medium.of(size: 10) }
    static var mukHM12: UIFont { FontFamily.medium.of(size: 12) }
    static var mukHM14: UIFont { FontFamily.medium.of(size: 14) }
    
}
