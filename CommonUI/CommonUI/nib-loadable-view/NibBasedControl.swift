import UIKit

/// Base nib loading implementation for custom control objects.
open class NibBasedControl: UIControl, NibLoadableViewProtocol {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        loadAndAttachNib()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadAndAttachNib()
    }
    
    // It's up to the subclasses to decide whether to
    // override this or not.
    open var nibOrNil: UINib? { nil }
    
    // For UIControl, it is reasonable to attach nib views
    // to itself
    open var nibContainerView: UIView? { self }
}
