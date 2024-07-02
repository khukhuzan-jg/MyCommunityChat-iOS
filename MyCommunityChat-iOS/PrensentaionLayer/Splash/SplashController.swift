//
//  SplashController.swift
//  MyCommunityChat-iOS
//
//  Created by kukuzan on 03/07/2024.
//

import UIKit
import Lottie
import Auth

class SplashController: UIViewController {

    @IBOutlet weak var animationView: LottieAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAnimation()
        
    }

    private func setupAnimation() {
        let animation = LottieAnimation.named("Animation")
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.play { (finished) in
            // Animation finished
            print("Animation Completed")
            let loginVC = LoginController()
            loginVC.modalPresentationStyle = .fullScreen
            self.present(loginVC, animated: true)
        }
    }
    

}
