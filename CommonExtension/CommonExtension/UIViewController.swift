import UIKit
import SafariServices

public var hasTopNotch: Bool {
    if #available(iOS 11.0, tvOS 11.0, *) {
        return UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0 > 20
    }
    return false
}

public var topNotch: CGFloat {
    if #available(iOS 11.0, tvOS 11.0, *) {
        return UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
    }
    return 0
}

public var bottomNotch: CGFloat {
    if #available(iOS 11.0, tvOS 11.0, *) {
        return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
    }
    return 0
}

public extension UIViewController {
    @discardableResult
    func wrapInsideNav() -> UINavigationController {
        let nav = UINavigationController(rootViewController: self)
        nav.isNavigationBarHidden = true
        return nav
    }
}

public extension UIViewController {
    
    func showShare(for pdf: Data) {
        let vc = UIActivityViewController(
            activityItems: [pdf],
            applicationActivities: nil
        )
        present(vc, animated: true)
    }
    
    func showShare(for pdf: URL, completion: @escaping (URL) -> Void) {
        let vc = UIActivityViewController(
            activityItems: [pdf],
            applicationActivities: nil
        )
        vc.completionWithItemsHandler = { _, _, _, _ in
            completion(pdf)
        }
        present(vc, animated: true)
    }

    
    func showShare(forLink link: String, templateText: String? = nil) {
        if let url = URL(string: link) {
            var sharingItems: [Any] = []
            if let text = templateText {
                sharingItems.append(text)
            }
            sharingItems.append(url)
            let vc = UIActivityViewController(
                activityItems: sharingItems,
                applicationActivities: nil)
            present(vc, animated: true)
        }
    }
    
    @objc func popVC(_ animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
    
    @objc func popVCToBottom() {
        navigationController?.popToBottom()
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    @objc func dismissNavigation() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func popOrDismiss() {
        guard let nav = navigationController else {
            dismissVC()
            return
        }
        if nav.viewControllers.count > 1 {
            popVC()
        } else {
            dismissVC()
        }
    }
    
    @objc func popOrDismissVC() {
        guard let nav = navigationController else {
            dismiss(animated: false)
            return
        }
        if nav.viewControllers.count > 1 {
            navigationController?.popViewController(animated: false)
        } else {
            dismiss(animated: false)
        }
    }
    
    func prepareForSlideupAnimation() {
        //hero.isEnabled = true
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
    }
    
    func prepareForFadeInAnimation() {
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
    }
    
//    func slideup(_ view: UIView) {
//        view.hero.modifiers = [.duration(0.4), .translate(y: view.frame.height), .useGlobalCoordinateSpace]
//    }
    
    var isPresentedModally: Bool {
        
        let presentingIsModal = presentingViewController != nil
        let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController
        let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController
        
        return presentingIsModal || presentingIsNavigation || presentingIsTabBar || false
    }
    
    func showAlert(title: String? = "", message: String?, actionTitle: String = "OK", actionCallback: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (_) in
            actionCallback?()
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    func showAlert(title: String? = "", message: String?, positiveTitle: String = "Yes", positiveAction: (() -> Void)? = nil, negativeTitle: String = "No", negativeAction:  (() -> Void)? = nil) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: negativeTitle, style: .default, handler: { (_) in
            if negativeAction == nil { alertController.dismiss(animated: true, completion: nil) }
            negativeAction?()
        }))
        
        alertController.addAction(UIAlertAction(title: positiveTitle, style: .default, handler: { (_) in
            if positiveAction == nil { alertController.dismiss(animated: true, completion: nil) }
            positiveAction?()
        }))
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func showInputAlert(title: String? = "", message: String? = "", submitAction: ((String) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.placeholder = message
            textField.clearButtonMode = .whileEditing
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default) { _ in
            alert.dismiss(animated: true, completion: nil)
        })

        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak alert] (_) in
            let inputText = alert?.textFields![0].text ?? "" // Force unwrapping because we know it exists.
            submitAction?(inputText)
            alert?.dismiss(animated: true, completion: nil)
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    func showForceInputAlert(title: String? = "", message: String? = "", submitAction: ((String) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.placeholder = message
            textField.clearButtonMode = .whileEditing
        }
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak alert] (action) in
            guard let inputText = alert?.textFields![0].text else { return }
            if !inputText.isEmpty {
                submitAction?(inputText)
                alert?.dismiss(animated: true, completion: nil)
            }
        }
        
        submitAction.isEnabled = false
        
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: alert.textFields![0], queue: OperationQueue.main) { (notification) in
            let inputText = alert.textFields![0].text ?? ""
            submitAction.isEnabled = !inputText.isEmpty
        }
        
        alert.addAction(submitAction)

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    func openURL(_ url: String) {
        if let url = URL(string: url) {
            if #available(iOS 11.0, *) {
                let vc = SFSafariViewController(url: url)
                present(vc, animated: true)
            } else {
                UIApplication.shared.open(url, options: [:])
            }
            
        }
    }
    
    func openURLInSafari(_ url: String) {
        if let url = URL(string: url) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    func replaceRootVC(with vc: UIViewController, duration: TimeInterval = 0.4, options: UIView.AnimationOptions = .transitionCrossDissolve) {
        guard let window = UIApplication.shared.keyWindow else { return }
        window.rootViewController = vc
        UIView.transition(with: window, duration: duration, options: options, animations: {}, completion: nil)
    }
    
    @objc
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        guard parent != nil else {
            return
        }
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
    
    func call(phone no: String) {
        guard let url = URL(string: "tel://\(no)") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    static func canOpenGoogleMap() -> Bool {
        return UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!)
    }
    
    static func canOpenAppleMap() -> Bool {
        return UIApplication.shared.canOpenURL(URL(string: "http://maps.apple.com/maps")!)
    }
    
    func openGoogleMap(with coordinate: (lat: String, long: String)) {
         guard let url = URL(string: "comgooglemaps://?q=\(coordinate.lat),\(coordinate.long)") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func openAppleMap(with coordinate: (lat: String, long: String)) {
        guard let url = URL(string: "http://maps.apple.com/maps?saddr=\(coordinate.lat),\(coordinate.long)") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func loadViewFromNib(nib: String) -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nib, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func openAppStore(using url: String) {
        
        guard let url = URL(string: url) else {
            print("invalid app store url")
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("can't open app store url")
        }
    }
    
    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("can't open app store url")
        }
    }
    
    func openAppSetting() {
        if let appSettings = URL(string: UIApplication.openSettingsURLString + (Bundle.main.bundleIdentifier ?? "")) {
            if UIApplication.shared.canOpenURL(appSettings) {
                UIApplication.shared.open(appSettings)
            } else {
                print("can't open app setting")
            }
        } else {
            print("can't open app setting")
        }
    }
    
    func showSettingsAlert(title: String, message: String) {
        if let appSettingURL = URL(string: UIApplication.openSettingsURLString) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Settings", style: .cancel, handler: { (_) -> Void in
                UIApplication.shared.open(appSettingURL, options: [:], completionHandler: nil)
            }))
            present(alert, animated: true)
        }
    }
    
    
}

public extension UIViewController {
    func present(_ vc: UIViewController) {
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        nav.isNavigationBarHidden = true
        present(nav, animated: true)
    }
}

//MARK: Animation
public extension UIViewController {
    
    func animateDropCenter(
        with image: UIImageView,
        completion: @escaping () -> ()
    ) {
        // Calculate the center of the screen
        let centerX = view.frame.width / 2
        let centerY = view.frame.height / 2
        
        // Initial position of the icon (above the screen)
        image.center = CGPoint(x: centerX, y: -image.frame.height)
        
        // Animate icon drop
        UIView.animate(
            withDuration: 1.0,
            delay: 0.0,
            options: .curveEaseIn, animations: {
            image.center = CGPoint(x: centerX, y: centerY)
        }, completion: { _ in
            completion()
        })
    }
    
    func animateTransition(
        with image: UIImageView,
        completion: @escaping () -> ()
    ) {
        UIView.transition(
            with: image,
            duration: 1.0,
            options: .curveEaseInOut, animations: { 
            image.alpha = 1
        }, completion: { _ in
            completion()
        })
    }
}
