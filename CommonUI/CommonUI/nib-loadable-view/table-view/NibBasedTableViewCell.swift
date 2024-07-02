import UIKit

/// Base nib loading implementation for UITableViewCell descendants.
///
open class NibBasedTableViewCell: UITableViewCell, NibLoadableViewProtocol {
     
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
