import UIKit

/// A protocol for supporting easy to use nib loadable views.
/// This protocol has default implementation for heavy lifting nib loading process.
public protocol NibLoadableViewProtocol: UIView {

    /// Target nib file to load. Return `nil` if you want the loader
    /// to automatically search Xib file matching the class name.
    var nibOrNil: UINib? { get }
    
    /// container view where the nib views are attached
    var nibContainerView: UIView? { get }

    /// Load contents from the nib, resolve outlets to current object
    /// and attach top level view objects to the provided container
    func loadAndAttachNib()
}

// MARK:- Default implementations
public extension NibLoadableViewProtocol {

    /// Get simple class name from class meta.
    /// i.e. `com.example.Project.ClassName` will become simply `ClassName`.
    ///
    /// - parameter anyClass: Meta class name.
    ///
    /// - returns: Simple class name
    ///
    private func simpleClassName(
        from anyClass: AnyClass
    ) -> String {
        return NSStringFromClass(anyClass)
            .split(separator: ".")
            .map(String.init).last ?? ""
    }
    
    /// Get nib file with class name.
    private func nibFileWithClassName() -> UINib {
        UINib(
            nibName: simpleClassName(
                from: self.classForCoder
            ),
            bundle: Bundle(for: self.classForCoder)
        )
    }
    
    private func givenOrAutoResolvedNibFile() -> UINib {
        // if the nibFile is not provided,
        // get the nib file with class name
        // otherwise, give user provided nib file
        nibOrNil ?? nibFileWithClassName()
    }
    
    // Default implementation of attaching nib
    func loadAndAttachNib() {
        let nib = givenOrAutoResolvedNibFile()

        // get all top level objects from the nib file
        // This also let the nib dynamically assign
        // outlets to the owner
        let objects = nib.instantiate(
            withOwner: self, options: nil
        )
        
        // if the nib container is not provided
        // no need to attach views on the container
        guard let container = nibContainerView else { return }

        // if the container is provided
        
        // Filter every uiview objects
        let views = objects.compactMap{$0 as? UIView}

        // Stick each view to the container
        for view in views {
            // Clear background
            view.backgroundColor = .clear
            
            // Opt into autolayout
            view.translatesAutoresizingMaskIntoConstraints = false
            
            // add to the container
            container.addSubview(view)
            
            // Stick the view to the margins
            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(
                    equalTo: container.leadingAnchor, constant: 0
                ),
                view.trailingAnchor.constraint(
                    equalTo: container.trailingAnchor, constant: 0
                ),
                view.topAnchor.constraint(
                    equalTo: container.topAnchor, constant: 0
                ),
                view.bottomAnchor.constraint(
                    equalTo: container.bottomAnchor, constant: 0
                ),
            ])
        }
        // Tell the conformer/realizer
        // that the nib has been successfully loaded
        awakeFromNib()
    }
}



