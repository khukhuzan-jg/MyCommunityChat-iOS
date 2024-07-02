//
//  LoginController.swift
//  Auth
//
//  Created by kukuzan on 03/07/2024.
//

import UIKit
import CommonExtension
import CommonUI

public class LoginController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    public init() {
        super.init(nibName: "LoginController", bundle: .authBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        welcomeLabel |> setLabelFontStyle(.RoboB24)
        titleLabel |> setLabelFontStyle(.RoboB24)
    }

}
