//
//  ProfileController.swift
//  Auth
//
//  Created by kukuzan on 03/07/2024.
//

import UIKit
import CommonUI
import CommonExtension

class ProfileController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    public init() {
        super.init(nibName: "ProfileController", bundle: .authBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }


    private func setupUI() {
        titleLabel |> setLabelFontStyle(.RoboB32)
    }
}
