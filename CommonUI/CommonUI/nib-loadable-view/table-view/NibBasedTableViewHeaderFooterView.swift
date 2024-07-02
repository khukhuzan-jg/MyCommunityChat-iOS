import UIKit

/// Base nib loading implementation for UITableViewHeaderFooterView descendants.
open class NibBasedTableViewHeaderFooterView: UITableViewHeaderFooterView, NibLoadableViewProtocol {
    
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        loadAndAttachNib()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadAndAttachNib()
    }
    
    // It's up to the subclasses to decide whether to
    // override this or not.
    open var nibOrNil: UINib? { nil }

    // For UITableViewCell, it is reasonable to attach nib views
    // to its contentView rather than itself
    open var nibContainerView: UIView? { self.contentView }
}
