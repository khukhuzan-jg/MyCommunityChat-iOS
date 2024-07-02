import UIKit

public extension UINavigationController {
    func pushFromBottom(_ viewControllerToPush: UIViewController) {
        let transition: CATransition = CATransition()
        transition.duration = 0.25
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromTop
        DispatchQueue.main.async {
            self.view.window!.layer.add(transition, forKey: kCATransition)
            self.pushViewController(viewControllerToPush, animated: false)
        }
    }
    
    func popToBottom() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        DispatchQueue.main.async {
            self.view.window!.layer.add(transition, forKey: kCATransition)
            self.popViewController(animated: false)
        }
    }
    
    func popTo<VC: UIViewController>(_ vc: VC.Type) {
        let vcs = viewControllers
        let index = vcs.firstIndex { $0 is VC }
        index.map { viewControllers[$0] }.then {
            popToViewController($0, animated: true)
        }
    }
    
    func replaceNPopTo<VC: UIViewController>(_ vc: VC.Type, with resetVC: UIViewController) {
        let vcs = viewControllers
        let index = vcs.firstIndex { $0 is VC }
        index.then {
            viewControllers[$0] = resetVC
        }
        popToViewController(resetVC, animated: true)
    }
    
    func contain<VC: UIViewController>(_ vc: VC.Type) -> Bool {
        viewControllers.contains { $0 is VC }
    }
    
    func replaceRoot(view: UIViewController) {
        setViewControllers([view], animated: false)
    }

}
