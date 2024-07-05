import UIKit
import CommonExtension
import CommonUI

public class ToastView: UIView {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var imgIndicator: UIImageView!
    
    var title: String? {
        didSet {
            lblTitle.isHidden = title == nil
            lblTitle.text = title
        }
    }
    
    var message: String? {
        didSet { lblDesc.text = message }
    }

    var containerViewColor: UIColor? {
        didSet { containerView.backgroundColor = containerViewColor }
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        containerView |> backgroundColorStyle(.black)
        backgroundColor = .clear
        lblTitle |> setLabelFontColor(.RoboR12, .white)
        lblDesc |> setLabelFontColor(.RoboR12, .white)
        guard let window = UIApplication.shared.keyWindow else { return }
        window.addSubview(self)
        anchor(top: window.topAnchor, leading: window.leadingAnchor, trailing: window.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        window.layoutIfNeeded()
        transform = .init(translationX: 0, y: -100)
    }
        
    public func present(_ show: Bool) {
        let duration = show ? 0.8 : 0.7
        let damping: CGFloat = show ? 0.8 : 0.9
        let velocity: CGFloat = show ? 3 : 1
        let animationOption = show ? UIView.AnimationOptions.curveEaseIn : .curveEaseOut
        let transform = show ? CGAffineTransform.identity : CGAffineTransform.init(translationX: 0, y: -200)
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: animationOption, animations: {
            self.transform = transform
        }, completion: { [weak self] _ in
            guard let self = self, !show else { return }
            self.removeFromSuperview()
        })
    }
}

public extension ToastView {
    static func success(title: String? = nil, message: String) {
        let toast = UIView.fromNib(ToastView.self, bundle: .authBundle)
        toast.title = title
        toast.message = message
        toast.lblDesc.textAlignment = .center
        toast.imgIndicator.hideView()
        toast.present(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            toast.present(false)
        }
    }
    
    static func error(title: String? = nil, message: String) {
        let toast = UIView.fromNib(ToastView.self, bundle: .authBundle)
        toast.title = title
        toast.message = message
        toast.lblDesc.textAlignment = .center
        toast.imgIndicator.hideView()
        toast.present(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            toast.present(false)
        }
    }
  
    static func announcement(title: String? = nil, message: String) {
        let toast = UIView.fromNib(ToastView.self, bundle: .authBundle)
        toast.title = title
        toast.message = message
        toast.imgIndicator.hideView()
        toast.present(true)
    }
    
    static func offline() {
        let toast = UIView.fromNib(ToastView.self, bundle: .authBundle)
        toast.title = nil
        toast.message = "You’re currently offline. Certain functions may not be available."
        toast.lblDesc.textAlignment = .center
        toast.imgIndicator.hideView()
        toast.present(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            toast.present(false)
        }
    }
    
}
