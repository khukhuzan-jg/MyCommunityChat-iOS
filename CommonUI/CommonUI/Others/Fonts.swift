//
//  Fonts.swift
//  CommonUI
//
//  Created by kukuzan on 03/07/2024.
//

import UIKit

public enum FontFamily: String, CaseIterable {
    case regular = "RobotoSlab-Regular"
    case bold = "RobotoSlab-Bold"
    case medium = "RobotoSlab-Medium"
    case semiBold = "RobotoSlab-ExtraBold"
    
    func of(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: self.rawValue, size: size) else {
            // fatalError("Unable to load font.")
            return .systemFont(ofSize: size)
        }
        return font
    }
}

public extension UIFont {
    
    static var RoboR8: UIFont { FontFamily.regular.of(size: 8) }
    static var RoboR10: UIFont { FontFamily.regular.of(size: 10) }
    static var RoboR12: UIFont { FontFamily.regular.of(size: 12) }
    static var RoboR14: UIFont { FontFamily.regular.of(size: 14) }
    static var RoboR15: UIFont { FontFamily.regular.of(size: 15) }
    static var RoboR16: UIFont { FontFamily.regular.of(size: 16) }
    static var RoboR18: UIFont { FontFamily.regular.of(size: 18) }
    
    static var RoboB8: UIFont { FontFamily.bold.of(size: 8) }
    static var RoboB10: UIFont { FontFamily.bold.of(size: 10) }
    static var RoboB12: UIFont { FontFamily.bold.of(size: 12) }
    static var RoboB14: UIFont { FontFamily.bold.of(size: 14) }
    static var RoboB15: UIFont { FontFamily.bold.of(size: 15) }
    static var RoboB16: UIFont { FontFamily.bold.of(size: 16) }
    static var RoboB18: UIFont { FontFamily.bold.of(size: 18) }
    static var RoboB20: UIFont { FontFamily.bold.of(size: 20) }
    static var RoboB24: UIFont { FontFamily.bold.of(size: 24) }
    static var RoboB28: UIFont { FontFamily.bold.of(size: 28) }
    static var RoboB32: UIFont { FontFamily.bold.of(size: 32) }
    
    static var RoboSemiB15: UIFont { FontFamily.semiBold.of(size: 15) }
    
    static var RoboM10: UIFont { FontFamily.medium.of(size: 10) }
    static var RoboM13: UIFont { FontFamily.medium.of(size: 13) }
    static var RoboM14: UIFont { FontFamily.medium.of(size: 14) }
    static var RoboM18: UIFont { FontFamily.medium.of(size: 18) }
}
