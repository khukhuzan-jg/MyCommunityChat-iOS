import UIKit

public extension UIWindow {
    
    func replaceRootVC(with vc: UIViewController, duration: TimeInterval = 0.4, options: UIView.AnimationOptions = .transitionCrossDissolve, completion: (() -> Void)? = nil) {
        guard let view = rootViewController?.view else { return }
        rootViewController = vc
        //        UIView.transition(with: window, duration: duration, options: options, animations: {}, completion: nil)
        
        UIView.transition(
            from: view,
            to: vc.view,
            duration: duration,
            options: options) { [weak self] finished in
            if let completion = completion {
                completion()
            }
            self?.rootViewController = vc
        }
    }
    
    var safeArea: (top: CGFloat, bottom: CGFloat) {
        if #available(iOS 11.0, *) {
            let windo = UIApplication.shared.delegate?.window
            return (top: windo??.safeAreaInsets.top ?? 20, bottom: windo??.safeAreaInsets.bottom ?? 0)
        }
        return (top: 20, bottom: 0)
    }
    
    func tapBarController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let tabController = controller as? UITabBarController {
            return tabController
        }
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    
    func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }

}

public extension UIWindow {
    
    static func switchRootView(_ root: UIViewController) {
        guard let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first else { return }
        window.rootViewController = root
        let options: UIView.AnimationOptions = .transitionCrossDissolve
        let duration: TimeInterval = 0.3
        UIView.transition(with: window, duration: duration, options: options, animations: nil, completion: nil)
    }
    
    static var size: CGSize {
        return UIScreen.main.bounds.size
    }
    
    static var width: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    static var height: CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
}
