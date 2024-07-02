import UIKit

open class AutoCollectionView: UICollectionView {
    open override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    open override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

public extension UICollectionView {
    
    func deque<cell: UICollectionViewCell>(_ cell: cell.Type, index: IndexPath) -> cell {
        return dequeueReusableCell(withReuseIdentifier: cell.className, for: index) as! cell
    }
    
    func dequeHeader<view: UICollectionReusableView>(_ view: view.Type, index: IndexPath) -> view {
        return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: view.className, for: index) as! view
    }
    
    func dequeFooter<view: UICollectionReusableView>(_ view: view.Type, index: IndexPath) -> view {
        return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: view.className, for: index) as! view
    }
    
    func register<cell: UICollectionViewCell>(cell: cell.Type) {
        register(.init(nibName: cell.className, bundle: nil), forCellWithReuseIdentifier: cell.className)
    }
    
    func register(nib nibName: String, bundle: Bundle? = nil) {
        let nib = UINib(nibName: nibName, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: nibName)
    }
    
    func register(nibs nibNames: [String], bundle: Bundle? = nil) {
        nibNames.forEach {
            register(UINib(nibName: $0, bundle: bundle), forCellWithReuseIdentifier: $0)
        }
    }
    
    func registerSectionHeader(nib nibName: String, bundle: Bundle? = nil) {
        let nib = UINib(nibName: nibName, bundle: bundle)
        register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: nibName)
    }
    
    func registerSectionFooter(nib nibName: String, bundle: Bundle? = nil) {
        let nib = UINib(nibName: nibName, bundle: bundle)
        register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: nibName)
    }
    /*
    func register(nib nibName: String, bundle: Bundle? = nil) {
        self.register(UINib(nibName: nibName , bundle: bundle), forCellReuseIdentifier: nibName)
        register
    }
    
    func registerHeaderFooter<T: UITableViewHeaderFooterView>(_ headerFooterView: T.Type) {
        register(headerFooterView.self, forHeaderFooterViewReuseIdentifier: headerFooterView.className)
    }
    
    func register(nibs nibNames: [String], bundle: Bundle? = nil) {
        nibNames.forEach {
            self.register(UINib(nibName: $0 , bundle: bundle), forCellReuseIdentifier: $0)
        }
    }
    
    func register(nibs nibNames: [UITableViewCell], bundle: Bundle? = nil) {
        nibNames.forEach {
            self.register(UINib(nibName: $0.className , bundle: bundle), forCellReuseIdentifier: $0.className)
        }
    }
    */
}

