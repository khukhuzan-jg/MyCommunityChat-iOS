//
//  Colors.swift
//  CommonUI
//
//  Created by kukuzan on 03/07/2024.
//

import UIKit
import CommonExtension

public extension UIColor {
    static var primaryGreen: UIColor { UIColor(hex: "#174C5B") }
    static var secondaryYellow: UIColor { UIColor(hex: "#FEC267") }
    static var secondaryYellow50: UIColor {
        return secondaryYellow.blended(withFraction: 0.5, of: .white)
    }
    static var quickSliver: UIColor {
        return black.blended(withFraction: 0.5, of: .white)
    }
}

extension UIColor {
    convenience init(hex: String) {
        let hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if hexString.hasPrefix("#") {
            scanner.currentIndex = hexString.index(after: hexString.startIndex)
        }

        var color: UInt64 = 0
        scanner.scanHexInt64(&color)

        let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(color & 0x0000FF) / 255.0

        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }

    func blended(withFraction fraction: CGFloat, of color: UIColor) -> UIColor {
        var r1: CGFloat = 0
        var g1: CGFloat = 0
        var b1: CGFloat = 0
        var a1: CGFloat = 0

        var r2: CGFloat = 0
        var g2: CGFloat = 0
        var b2: CGFloat = 0
        var a2: CGFloat = 0

        self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)

        let r = r1 + (r2 - r1) * fraction
        let g = g1 + (g2 - g1) * fraction
        let b = b1 + (b2 - b1) * fraction
        let a = a1 + (a2 - a1) * fraction

        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}
