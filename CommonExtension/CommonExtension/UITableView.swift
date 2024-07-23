import UIKit

open class AutoTableView: UITableView {
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

public extension UITableView {
    
    func deque<cell: UITableViewCell>(_ cell: cell.Type) -> cell {
        return dequeueReusableCell(withIdentifier: cell.className) as! cell
    }
    
    func dequeHeaderFooter<T: UITableViewHeaderFooterView>(_ cell: T.Type) -> T {
        return self.dequeueReusableHeaderFooterView(withIdentifier: T.className) as! T
    }
    
    func register<cell: UITableViewCell>(_ cell: cell.Type) {
        self.register(.init(nibName: cell.identifier, bundle: nil), forCellReuseIdentifier: cell.identifier)
    }
    
    func registerHeaderFooter(nib nibName: String, bundle: Bundle? = nil) {
        register(UINib(nibName: nibName , bundle: bundle), forHeaderFooterViewReuseIdentifier: nibName)
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
    
    func layoutHeaderView() {
        
        guard let headerView = self.tableHeaderView else { return }
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        let headerWidth = headerView.bounds.size.width;
        let temporaryWidthConstraints = NSLayoutConstraint.constraints(withVisualFormat: "[headerView(width)]", options: NSLayoutConstraint.FormatOptions(rawValue: UInt(0)), metrics: ["width": headerWidth], views: ["headerView": headerView])
        
        headerView.addConstraints(temporaryWidthConstraints)
        
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        
        let headerSize = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        let height = headerSize.height
        var frame = headerView.frame
        
        frame.size.height = height
        headerView.frame = frame
        
        self.tableHeaderView = headerView
        
        headerView.removeConstraints(temporaryWidthConstraints)
        headerView.translatesAutoresizingMaskIntoConstraints = true
        
    }
    
}

public extension UITableViewCell {
    func addSeparator(color: UIColor, padding: CGFloat, height: CGFloat) {
        let frame = self.contentView.frame.size
        let separator = CALayer()
        separator.frame = CGRect(x: padding, y: frame.height - height, width: frame.width - (2 * padding), height: height)
        separator.backgroundColor = color.cgColor
        self.contentView.layer.addSublayer(separator)
    }
    
    class var identifier: String {
        return String(describing: self)
    }
}

public extension UITableView {
    func scrollToBottom(isAnimated:Bool = true){

           DispatchQueue.main.async {
               let indexPath = IndexPath(
                   row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
                   section: self.numberOfSections - 1)
               if self.hasRowAtIndexPath(indexPath: indexPath) {
                   self.scrollToRow(at: indexPath, at: .bottom, animated: isAnimated)
               }
           }
       }

       func scrollToTop(isAnimated:Bool = true) {

           DispatchQueue.main.async {
               let indexPath = IndexPath(row: 0, section: 0)
               if self.hasRowAtIndexPath(indexPath: indexPath) {
                   self.scrollToRow(at: indexPath, at: .top, animated: isAnimated)
              }
           }
       }

       func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
           return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
       }
}
