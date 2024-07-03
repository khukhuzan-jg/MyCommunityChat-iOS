//
//  LogoAndTitleView.swift
//  Auth
//
//  Created by kukuzan on 03/07/2024.
//

import UIKit
import CommonUI
import CommonExtension

class LogoAndTitleView: NibBasedView {
    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        welcomeLabel |> setLabelFontStyle(.RoboB24)
        titleLabel |> setLabelFontStyle(.RoboB24)
    }

}
