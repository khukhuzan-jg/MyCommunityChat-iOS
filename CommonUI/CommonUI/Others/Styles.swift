//
//  Styles.swift
//  CommonUI
//
//  Created by kukuzan on 03/07/2024.
//

import UIKit
import CommonExtension

public func setMainButtonStyle(isEnabled: Bool = true, font: UIFont = .RoboM18) -> (UIButton) -> Void {
    return {
        $0.isEnabled = isEnabled
        $0.titleLabel?.font = font
        $0.setTitleColor(.black, for: .normal)
        $0.setTitleColor(.quickSliver, for: .disabled)
        $0.backgroundColor = isEnabled ? .secondaryYellow : .secondaryYellow50
        cornerRadiusStyle(8)($0)
    }
}

