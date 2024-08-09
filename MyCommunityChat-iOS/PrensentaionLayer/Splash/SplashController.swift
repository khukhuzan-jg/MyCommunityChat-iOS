//
//  SplashController.swift
//  MyCommunityChat-iOS
//
//  Created by kukuzan on 03/07/2024.
//

import UIKit
import Lottie
import Auth

class SplashController: BaseViewController {

    @IBOutlet weak var animationView: LottieAnimationView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAnimation()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkLogin()
    }
    
    private func checkLogin() {
        userManager.completionSaved = { issaved -> Void in
            if issaved {
                self.navigateToHomeVC()
            }
            else {
                self.navigateToLoginVC()
            }
        }
    }

    private func setupAnimation() {
        let animation = LottieAnimation.named("Animation")
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.play { [weak self] (finished) in
            // Animation finished
            
//            self?.navigateToHomeVC()
            print("Animation Completed")
            if (self?.userManager.isAlreadyLogin ?? false) {
                self?.navigateToHomeVC()
            }
            else {
                self?.navigateToLoginVC()
            }
            
        }
    }
    
    private func navigateToHomeVC() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: HomeViewController.self)) as? HomeViewController
        let homeNav = UINavigationController(rootViewController: vc!)
//        let appearance = UINavigationBarAppearance()
//        appearance.backgroundColor = .primary
////        appearance.backgroundColor = .clear
//        
//        UINavigationBar.appearance().standardAppearance = appearance // for scrolling bg color
//        UINavigationBar.appearance().compactAppearance = appearance // not sure why it's here, but u can remove it and still works
//        UINavigationBar.appearance().scrollEdgeAppearance = appearance // for large title bg color
        let sceneDelegate = UIApplication.shared.connectedScenes
            .first!.delegate as! SceneDelegate
        sceneDelegate.window!.rootViewController = homeNav
        
    }
    
    private func navigateToLoginVC() {
        let loginVC = LoginController()
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    

}
