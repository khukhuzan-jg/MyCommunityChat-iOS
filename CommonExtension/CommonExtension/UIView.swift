import UIKit

public extension UIView {
    
    ////////////////////////////////////////////////
    // MARK: - Utilities
    ////////////////////////////////////////////////
    
    @IBInspectable var viewCornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        } set {
            self.layer.cornerRadius = newValue
        }
    }
    
    // Load Nib with ease
    class func fromNib<T: UIView>(_ view: T.Type, bundle: Bundle = .main) -> T {
        return bundle.loadNibNamed(T.className, owner: nil, options: nil)![0] as! T
    }
    
    class func loadFromNib(bundle: Bundle = .main) -> Self {
        let nib = UINib(nibName: self.className, bundle: bundle)
        if let view = nib.instantiate(withOwner: self, options: nil).first as? Self {
            return view
        } else {
            fatalError("Unable to load Nib.")
        }
    }
    
    func loadViewFromNib(nib: String) -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nib, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func addSubViews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
    
    func showView() {
        isHidden = false
    }
    
    func hideView() {
        isHidden = true
    }
    
    func animateBorderColor(from oldColor: UIColor = .clear, to color: UIColor = .clear, withDuration duration: CFTimeInterval = 0.3, lay: CALayer? = nil) {
        let borderColor = CABasicAnimation(keyPath: "borderColor")
        borderColor.fromValue = oldColor.cgColor
        borderColor.toValue = color.cgColor
        borderColor.duration = duration
        if let lay = lay {
            lay.borderWidth = 1
            lay.borderColor = UIColor.red.cgColor
            lay.add(borderColor, forKey: "borderColor")
            lay.borderColor = color.cgColor
            return
        }
        layer.add(borderColor, forKey: "borderColor")
        layer.borderColor = color.cgColor
    }
    
    func mask(with image: String) {
        let imageView = UIImageView(image: UIImage(named: image))
        mask = imageView
    }
    //round specfic corner of view
    func maskByRoundingCorners(_ masks: UIRectCorner, withRadii radii: CGSize = CGSize(width: 10, height: 10)) {
        let rounded = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: masks, cornerRadii: radii)

        let shape = CAShapeLayer()
        shape.path = rounded.cgPath

        self.layer.mask = shape
    }

    func addBorder(toEdges edges: UIRectEdge, color: UIColor, thickness: CGFloat) {
        let yourViewBorder = CAShapeLayer()
        yourViewBorder.strokeColor = UIColor.black.cgColor
        yourViewBorder.lineDashPattern = [2, 2]
        yourViewBorder.frame = self.bounds
        yourViewBorder.fillColor = nil
        let rounded = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 10, height: 10))
        yourViewBorder.path = rounded.cgPath
        self.layer.addSublayer(yourViewBorder)
    }
    
    func addBorder(color: UIColor? = .black, thickness: CGFloat, radius: CGFloat) {
        self.clipsToBounds = true
        self.borderColor = color
        self.borderWidth = thickness
        self.cornerRadius = radius
    }
    
    ////////////////////////////////////////////////
    // MARK: Syntatic Sugar for NSlayoutConstraint
    ////////////////////////////////////////////////
    func fillToSuperview(withPadding padding: UIEdgeInsets) {
        anchor(top: superview?.topAnchor, leading: superview?.leadingAnchor, bottom: superview?.bottomAnchor, trailing: superview?.trailingAnchor, padding: padding)
    }
    
    func fillToSuperview() {
        fillToSuperview(withPadding: .zero)
    }
    
    func fillToSuperviewSafeArea() {
        anchor(top: superview?.safeAreaLayoutGuide.topAnchor, leading: superview?.safeAreaLayoutGuide.leadingAnchor, bottom: superview?.safeAreaLayoutGuide.bottomAnchor, trailing: superview?.safeAreaLayoutGuide.trailingAnchor, padding: .zero)
    }
    
    func aspectRatio(_ ratio: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: self, attribute: .width, multiplier: ratio, constant: 0).isActive = true
    }
    
    func centerInSuperview() {
        anchor(centerX: superview?.centerXAnchor, centerY: superview?.centerYAnchor)
    }
    
    func anchorSize(to view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func anchor(top: NSLayoutYAxisAnchor? = nil, leading: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, trailing: NSLayoutXAxisAnchor? = nil, padding: UIEdgeInsets = .zero, size: CGSize = .zero, centerX: NSLayoutXAxisAnchor? = nil, centerY: NSLayoutYAxisAnchor? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        
        if let centerX = centerX {
            centerXAnchor.constraint(equalTo: centerX).isActive = true
        }
        
        if let centerY = centerY {
            centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    func addShadow(with color: UIColor? = UIColor(white: 0, alpha: 0.1), opacity: Float = 1, radius: CGFloat = 3, offset: CGSize = CGSize(width: 0, height: 2)) {
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowColor = color?.cgColor
    }
    
    func addCornerAndShadow(corner: CGFloat, color: UIColor = UIColor(white: 0, alpha: 0.1), opacity: Float = 1, radius: CGFloat = 3, offset: CGSize = CGSize(width: 0, height: 2)) {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = corner
        self.layer.shadowColor = color.cgColor
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
    
    ////////////////////////////////////////////////
    // MARK: Inner Shadow for each specific side
    ////////////////////////////////////////////////
    // different inner shadow styles
    enum InnerShadowSide {
        case all, left, right, top, bottom, topAndLeft, topAndRight, bottomAndLeft, bottomAndRight, exceptLeft, exceptRight, exceptTop, exceptBottom
    }
    
    // define function to add inner shadow
    func addInnerShadow(onSide: InnerShadowSide, shadowColor: UIColor, shadowSize: CGFloat, cornerRadius: CGFloat = 0.0, shadowOpacity: Float) {
        // define and set a shaow layer
        let shadowLayer = CAShapeLayer()
        shadowLayer.frame = bounds
        shadowLayer.shadowColor = shadowColor.cgColor
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        shadowLayer.shadowOpacity = shadowOpacity
        shadowLayer.shadowRadius = shadowSize
        shadowLayer.fillRule = CAShapeLayerFillRule.evenOdd
        
        // define shadow path
        let shadowPath = CGMutablePath()
        
        // define outer rectangle to restrict drawing area
        let insetRect = bounds.insetBy(dx: -shadowSize * 2.0, dy: -shadowSize * 2.0)
        
        // define inner rectangle for mask
        let innerFrame: CGRect = { () -> CGRect in
            switch onSide {
            case .all:
                return CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: frame.size.height)
            case .left:
                return CGRect(x: 0.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 4.0)
            case .right:
                return CGRect(x: -shadowSize * 2.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 4.0)
            case .top:
                return CGRect(x: -shadowSize * 2.0, y: 0.0, width: frame.size.width + shadowSize * 4.0, height: frame.size.height + shadowSize * 2.0)
            case.bottom:
                return CGRect(x: -shadowSize * 2.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 4.0, height: frame.size.height + shadowSize * 2.0)
            case .topAndLeft:
                return CGRect(x: 0.0, y: 0.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 2.0)
            case .topAndRight:
                return CGRect(x: -shadowSize * 2.0, y: 0.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 2.0)
            case .bottomAndLeft:
                return CGRect(x: 0.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 2.0)
            case .bottomAndRight:
                return CGRect(x: -shadowSize * 2.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 2.0)
            case .exceptLeft:
                return CGRect(x: -shadowSize * 2.0, y: 0.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height)
            case .exceptRight:
                return CGRect(x: 0.0, y: 0.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height)
            case .exceptTop:
                return CGRect(x: 0.0, y: -shadowSize * 2.0, width: frame.size.width, height: frame.size.height + shadowSize * 2.0)
            case .exceptBottom:
                return CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: frame.size.height + shadowSize * 2.0)
            }
        }()
        
        // add outer and inner rectangle to shadow path
        shadowPath.addRect(insetRect)
        shadowPath.addRect(innerFrame)
        
        // set shadow path as show layer's
        shadowLayer.path = shadowPath
        
        // add shadow layer as a sublayer
        layer.addSublayer(shadowLayer)
        
        // hide outside drawing area
        clipsToBounds = true
    }
    
    /**
     change red border color
     */
    func error() {
        self.layer.borderColor = UIColor.red.cgColor
    }
    
    /**
     change green border color
     */
    func valid() {
        self.layer.borderColor = UIColor.green.cgColor
    }
    /**
     screenshot of a view
     */
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
    enum Corner {
        case TOP_LEFT
        case TOP_RIGHT
        case BOT_LEFT
        case BOT_RIGHT
    }
    
    func addCornerRadius(corners: [Corner], radius: CGFloat) {
        self.clipsToBounds = true
        if #available(iOS 11.0, *) {
            self.layer.cornerRadius = radius
            var toCorners: CACornerMask = []
            for c in corners {
                if c == .TOP_LEFT {
                    toCorners.update(with: .layerMinXMinYCorner)
                } else if c == .TOP_RIGHT {
                    toCorners.update(with: .layerMaxXMinYCorner)
                } else if c == .BOT_LEFT {
                    toCorners.update(with: .layerMinXMaxYCorner)
                } else if c == .BOT_RIGHT {
                    toCorners.update(with: .layerMaxXMaxYCorner)
                }
            }
            if toCorners.isEmpty { return }
            self.layer.maskedCorners = toCorners
            
        } else {
            var toCorners: UIRectCorner = []
            for c in corners {
                if c == .TOP_LEFT {
                    toCorners.update(with: .topLeft)
                } else if c == .TOP_RIGHT {
                    toCorners.update(with: .topRight)
                } else if c == .BOT_LEFT {
                    toCorners.update(with: .bottomLeft)
                } else if c == .BOT_RIGHT {
                    toCorners.update(with: .bottomRight)
                }
            }
            if toCorners.isEmpty {return}
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: toCorners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
    
    func fade(inward: Bool = false, duration: Double = 0.3) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = inward ? 1 : 0
        })
    }
    
    func shake(
        perDuration: TimeInterval = 0.06,
        repeatCount: Float = 4,
        autoreverses: Bool = true,
        xValue: CGFloat = 5,
        yValue: CGFloat = 0
    ) {
        let midX = center.x
        let midY = center.y
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = perDuration
        animation.repeatCount = repeatCount
        animation.autoreverses = autoreverses
        animation.fromValue = CGPoint(x: midX - xValue, y: midY - yValue)
        animation.toValue = CGPoint(x: midX + xValue, y: midY - yValue)
        layer.add(animation, forKey: "shake")
    }
}

// MARK: - Properties
public extension UIView {
    
    /// Border color of view; also inspectable from Storyboard.
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            guard let color = newValue else {
                layer.borderColor = nil
                return
            }
            // Fix React-Native conflict issue
            guard String(describing: type(of: color)) != "__NSCFType" else { return }
            layer.borderColor = color.cgColor
        }
    }
    
    /// Border width of view; also inspectable from Storyboard.
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    /// Corner radius of view; also inspectable from Storyboard.
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.masksToBounds = true
            layer.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
        }
    }
    
    /// Height of view.
    var height: CGFloat {
        get {
            return frame.size.height
        }
        set {
            frame.size.height = newValue
        }
    }
    
    /// Check if view is in RTL format.
    var isRightToLeft: Bool {
        if #available(iOS 10.0, *, tvOS 10.0, *) {
            return effectiveUserInterfaceLayoutDirection == .rightToLeft
        } else {
            return false
        }
    }
    
    /// Take screenshot of view (if applicable).
    var screenshot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /// Shadow color of view; also inspectable from Storyboard.
    @IBInspectable var shadowColor: UIColor? {
        get {
            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    /// Shadow offset of view; also inspectable from Storyboard.
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    /// Shadow opacity of view; also inspectable from Storyboard.
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    /// Shadow radius of view; also inspectable from Storyboard.
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    /// Size of view.
    var size: CGSize {
        get {
            return frame.size
        }
        set {
            width = newValue.width
            height = newValue.height
        }
    }
    
    /// Get view's parent view controller
    var parentViewController: UIViewController? {
        weak var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    /// Width of view.
    var width: CGFloat {
        get {
            return frame.size.width
        }
        set {
            frame.size.width = newValue
        }
    }
    
    /// x origin of view.
    // swiftlint:disable:next identifier_name
    var x: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            frame.origin.x = newValue
        }
    }
    
    /// y origin of view.
    // swiftlint:disable:next identifier_name
    var y: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            frame.origin.y = newValue
        }
    }
    
}

public extension UIView {

    class func getAllSubviews<T: UIView>(from parenView: UIView) -> [T] {
        return parenView.subviews.flatMap { subView -> [T] in
            var result = getAllSubviews(from: subView) as [T]
            if let view = subView as? T { result.append(view) }
            return result
        }
    }

    class func getAllSubviews(from parenView: UIView, types: [UIView.Type]) -> [UIView] {
        return parenView.subviews.flatMap { subView -> [UIView] in
            var result = getAllSubviews(from: subView) as [UIView]
            for type in types {
                if subView.classForCoder == type {
                    result.append(subView)
                    return result
                }
            }
            return result
        }
    }

    func getAllSubviews<T: UIView>() -> [T] {
        return UIView.getAllSubviews(from: self) as [T]
    }
    
    func get<T: UIView>(all type: T.Type) -> [T] {
        return UIView.getAllSubviews(from: self) as [T]
    }
    
    func get(all types: [UIView.Type]) -> [UIView] {
        return UIView.getAllSubviews(from: self, types: types)
    }
}

public extension UIView {
    func initFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = bundle.loadNibNamed(self.className, owner: self, options: nil)
        let view = nib?.first as! UIView
        view.frame = bounds
        addSubview(view)
    }
    
    static func reloadViewFrame<T: UIView>(view: T) -> T {
        let height = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        var frame = view.frame
        //Comparison necessary to avoid infinite loop
        if height != frame.size.height {
            frame.size.height = height
            view.frame = frame
        }
        return view
    }
}


public extension UIView {

    func roundCorners(
        _ corners: UIRectCorner,
        radius: CGFloat) {
         let path = UIBezierPath(
            roundedRect: self.bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
         )
         let mask = CAShapeLayer()
         mask.path = path.cgPath
         self.layer.mask = mask
    }

}


public extension UIView {
    func makeCircular() {
        self.layer.cornerRadius = min(self.frame.size.height, self.frame.size.width) / 2.0
        self.clipsToBounds = true
    }
}


public extension UIView {
    func dropShadow(scale: Bool = true, shadowOpacity: Float = 0.2) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = .zero
        layer.shadowRadius = 8
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func addShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        backgroundColor = UIColor.white
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.shadowOpacity = 0.5
    }
    
    func removeShadow() {
        layer.masksToBounds = true
        layer.shadowColor = UIColor.white.cgColor
        backgroundColor = UIColor.white
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowOpacity = 0.0
    }
}
