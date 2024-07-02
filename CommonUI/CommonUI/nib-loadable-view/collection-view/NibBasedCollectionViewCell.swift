import UIKit

/// Base nib loading implementation for UICollectionViewCell descendants.
open class NibBasedCollectionViewCell: UICollectionViewCell, NibLoadableViewProtocol {
    
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

    // For UICollectionViewCell, it is reasonable to attach nib views
    // to its contentView rather than itself
    open var nibContainerView: UIView? { self.contentView }
}
