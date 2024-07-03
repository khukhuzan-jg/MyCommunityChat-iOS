import UIKit

public func maskWithImageStyle(_ image: UIImageView) -> (UIView) -> Void {
    return {
        $0.mask = image
    }
}

public func cornerRadiusStyle(_ value: CGFloat) -> (UIView) -> Void {
    return {
        $0.layer.cornerRadius = value
        $0.clipsToBounds = true
    }
}

public func topCornerStyle(_ value: CGFloat) -> (UIView) -> Void {
    return {
        $0.layer.cornerRadius = value
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}

public func bottomCornerStyle(_ value: CGFloat) -> (UIView) -> Void {
    return {
        $0.layer.cornerRadius = value
        $0.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
}

public func leftBottomCornerStyle(_ value: CGFloat) -> (UIView) -> Void {
    return {
        $0.layer.cornerRadius = value
        $0.layer.maskedCorners = [.layerMinXMaxYCorner]
    }
}

public func roundedStyle() -> (UIView) -> Void {
    return {
        $0.layer.cornerRadius = $0.bounds.height / 2
        $0.clipsToBounds = true
    }
}

public func leftRoundedStyle() -> (UIView) -> Void {
    return {
        $0.layer.cornerRadius = $0.bounds.height / 2
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        $0.clipsToBounds = true
    }
}

public func rightRoundedStyle() -> (UIView) -> Void {
    return {
        $0.layer.cornerRadius = $0.bounds.height / 2
        $0.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        $0.clipsToBounds = true
    }
}

public func colorCodedStyle(baseColor: UIColor, codedColor: UIColor, _ query: String, baseFont: UIFont, codedFont: UIFont) -> (UILabel) -> Void {
    return {
        let text = $0.text ?? ""
        let attributedText = NSMutableAttributedString(string: text,
                                                       attributes: [NSAttributedString.Key.foregroundColor: baseColor, .font:baseFont])
        let queryRange = (attributedText.string as NSString).range(of: query)
        attributedText.addAttributes([NSAttributedString.Key.foregroundColor: codedColor, .font: codedFont], range: queryRange)
        $0.attributedText = attributedText
    }
}

public func borderStyle(_ color: UIColor?, _ width: CGFloat = 1, _ radius: CGFloat) -> (UIView) -> Void {
    return {
        $0.layer.borderWidth = width
        $0.layer.borderColor = color?.cgColor
        cornerRadiusStyle(radius)($0)
    }
}

public func clearBackgroundStyle(_ view: UIView) {
    view.backgroundColor = .clear
}

public func backgroundColorStyle(_ color: UIColor?) -> (UIView) -> Void {
    return { $0.backgroundColor = color }
}

public func noSeparatorStyle(_ view: UITableView) {
    view.separatorStyle = .none
}

public func setDataSource(_ source: UITableViewDataSource) -> (UITableView) -> Void {
    return { $0.dataSource = source }
}

public func setDelegate(_ delegate: UITableViewDelegate) -> (UITableView) -> Void {
    return { $0.delegate = delegate }
}

public func setDataSource(_ source: UICollectionViewDataSource) -> (UICollectionView) -> Void {
    return { $0.dataSource = source }
}

public func setDelegate(_ delegate: UICollectionViewDelegate) -> (UICollectionView) -> Void {
    return { $0.delegate = delegate }
}

public func setDataSourceAndDelegate(source: UITableViewDataSource, delegate: UITableViewDelegate) -> (UITableView) -> Void {
    return {
        $0.dataSource = source
        $0.delegate = delegate
    }
}

public func setDataSourceAndDelegate(source: UICollectionViewDataSource, delegate: UICollectionViewDelegate) -> (UICollectionView) -> Void {
    return {
        $0.dataSource = source
        $0.delegate = delegate
    }
}

public func applyWhiteBackground(_ view: UIView) -> Void {
    view.backgroundColor = .white
}

/*
public func tableViewConfiguration(dataSource: UITableViewDataSource, delegate: UITableViewDelegate, separatorStyle: UITableViewCell.SeparatorStyle, rowHeight: CGFloat, registerNib nib: String) -> (UITableView) -> Void {
    return tableViewConfiguration(dataSource: dataSource, delegate: delegate, separatorStyle: separatorStyle, rowHeight: rowHeight)
        <> register(nib: nib)
}

public func tableViewConfiguration(dataSource: UITableViewDataSource, delegate: UITableViewDelegate, separatorStyle: UITableViewCell.SeparatorStyle, rowHeight: CGFloat, register cell: UITableViewCell.Type) -> (UITableView) -> Void {
    return tableViewConfiguration(dataSource: dataSource, delegate: delegate, separatorStyle: separatorStyle, rowHeight: rowHeight)
        <> { (tbl: UITableView) in
            tbl.register(cell)
            return
    }
}

public func tableViewConfiguration(dataSource: UITableViewDataSource, delegate: UITableViewDelegate, separatorStyle: UITableViewCell.SeparatorStyle, rowHeight: CGFloat, registerNib nibs: [String]) -> (UITableView) -> Void {
    return tableViewConfiguration(dataSource: dataSource, delegate: delegate, separatorStyle: separatorStyle, rowHeight: rowHeight)
        <> { tbl in nibs.forEach { tbl.register(nib: $0) } }
}

public func tableViewConfiguration(dataSource: UITableViewDataSource, delegate: UITableViewDelegate, separatorStyle: UITableViewCell.SeparatorStyle, rowHeight: CGFloat, register cells: [UITableViewCell.Type]) -> (UITableView) -> Void {
    return tableViewConfiguration(dataSource: dataSource, delegate: delegate, separatorStyle: separatorStyle, rowHeight: rowHeight)
        <> { tbl in cells.forEach { tbl.register($0) } }
}

private func tableViewConfiguration(dataSource: UITableViewDataSource, delegate: UITableViewDelegate, separatorStyle: UITableViewCell.SeparatorStyle, rowHeight: CGFloat) -> (UITableView) -> Void {
    return setSeperatorStyle(separatorStyle)
        <> setRowHeightStyle(rowHeight)
        <> setDataSourceAndDelegate(source: dataSource, delegate: delegate)
}
*/
public func register(nib: String) -> (UITableView) -> Void {
    return { $0.register(nib: nib) }
}

public func register(nibs: String...) -> (UITableView) -> Void {
    return { tbl in nibs.forEach { tbl.register(nib: $0) } }
}

public func registerHeaderFooter(nib: String) -> (UITableView) -> Void {
    return { $0.registerHeaderFooter(nib: nib) }
}

public func register(_ classe: UITableViewCell.Type) -> (UITableView) -> Void {
    return { $0.register(classe) }
}

public func separatorStyle(_ style: UITableViewCell.SeparatorStyle) -> (UITableView) -> Void {
    return { $0.separatorStyle = style }
}

public func separatorColorStyle(_ color: UIColor?) -> (UITableView) -> Void {
    return { $0.separatorColor = color }
}

public func separatorInsetStyle(_ inset: UIEdgeInsets) -> (UITableView) -> Void {
    return { $0.separatorInset = inset }
}

public func emptyTableFooterStyle(_ tbl: UITableView) -> Void {
    tbl.tableFooterView = UIView()
}

public func setRowHeightStyle(_ height: CGFloat) -> (UITableView) -> Void {
    return { $0.rowHeight = height }
}

public func setEstimatedRowHeightStyle(_ height: CGFloat) -> (UITableView) -> Void {
    return { $0.estimatedRowHeight = height }
}

public func automaticTableCellHeightStyle(_ view: UITableView) {
    view.rowHeight = UITableView.automaticDimension
}

public func automaticTableCellHeightStyle(withEstimatedHeight height: CGFloat) -> (UITableView) -> Void {
    return {
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = height
    }
}

public func automaticTableSectionHeaderHeightStyle(withEstimatedHeight height: CGFloat) -> (UITableView) -> Void {
    return {
        $0.sectionHeaderHeight = UITableView.automaticDimension
        $0.estimatedSectionHeaderHeight = height
    }
}

public func automaticTableSectionHeaderHeightStyle(estimatedHeight: CGFloat) -> (UITableView) -> Void {
    return {
        $0.estimatedSectionHeaderHeight = estimatedHeight
        $0.sectionHeaderHeight = UITableView.automaticDimension
    }
}

public func gradientStyle(colors: [UIColor?], location: [NSNumber]) -> (UIView) -> Void {
    return {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.compactMap { $0?.cgColor }
        gradientLayer.locations = location
        gradientLayer.frame = $0.bounds
        $0.layer.insertSublayer(gradientLayer, at: 0)
    }
}

public func showView(_ view: UIView) {
    view.isHidden = false
}

public func hideView(_ view: UIView) {
    view.isHidden = true
}

public func hideViews(_ views: UIView...) {
    views.forEach(hideView)
}

public func showViews(_ views: UIView...) {
    views.forEach(showView)
}

public func setTintColorStyle(_ color: UIColor?) -> (UIView) -> Void {
    return {
        $0.tintColor = color
    }
}

public func setAlphaStyle(_ value: CGFloat) -> (UIView) -> Void {
    return {
        $0.alpha = value
    }
}

public func setContentInsetStyle(_ inset: UIEdgeInsets) -> (UITableView) -> Void {
    return {
        $0.contentInset = inset
    }
}

public func disableCellSelection(_ tbl: UITableView) -> Void {
    tbl.allowsSelection = false
}

public func setSeperatorStyle(_ style: UITableViewCell.SeparatorStyle) -> (UITableView) -> Void {
    return {
        $0.separatorStyle = style
    }
}

public func setSeperatorColorStyle(_ color: UIColor?) -> (UITableView) -> Void {
    return {
        $0.separatorColor = color
    }
}

public func contentModeStyle(_ mode: UIView.ContentMode) -> (UIView) -> Void {
    return { $0.contentMode = mode }
}

public func clipToBoundStyle(_ view: UIView) {
    view.clipsToBounds = true
}

public func unclipToBoundStyle(_ view: UIView) {
    view.clipsToBounds = false
}

// UILabel Styles

public func multilineLabelButtonStyle(_ btn: UIButton) {
    btn.titleLabel?.numberOfLines = 0
    btn.titleLabel?.textAlignment = .center
}

public func infiniteLabelLineStyle() -> (UILabel) -> Void {
    return { $0.numberOfLines = 0 }
}

public func setLabelFontColor(_ font: UIFont, _ color: UIColor) -> (UILabel) -> Void {
    return { $0.font = font; $0.textColor = color }
}

public func setLabelFontStyle(_ font: UIFont) -> (UILabel) -> Void {
    return { $0.font = font }
}

public func setLabelColorStyle(_ color: UIColor?) -> (UILabel) -> Void {
    return { $0.textColor = color }
}

public func setLabelTextStyle(_ text: String?) -> (UILabel) -> Void {
    return { $0.text = text }
}

public func setLabelRotationStyle() -> (UILabel) -> Void {
    return { $0.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2) }
}

// UIImage Styles
public func setImageStyle(_ image: UIImage?) -> (UIImageView) -> Void {
    return { $0.image = image }
}

// UIButton Styles

public func setButtonImageStyle(_ image: UIImage?) -> (UIButton) -> Void {
    return { $0.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal) }
}

public func setButtonFontStyle(_ font: UIFont) -> (UIButton) -> Void {
    return { $0.titleLabel?.font = font }
}

public func setButtonTitleColorStyle(_ color: UIColor?) -> (UIButton) -> Void {
    return { $0.setTitleColor(color, for: .normal) }
}

public func setButtonTitleText(_ text: String) -> (UIButton) -> Void {
    return { $0.setTitle(text, for: .normal) }
}

public func setButtonTitleStyle(_ font: UIFont, _ color: UIColor?) -> (UIButton) -> Void {
    return { $0.titleLabel?.font = font; $0.setTitleColor(color, for: .normal) }
}

public func setButtonShadowBorderStyle(radius: CGFloat = 10, width: CGFloat, borderColor: UIColor?, opacity: Float, color: UIColor) -> (UIButton) -> Void {
    return {
        $0.layer.cornerRadius = radius
        $0.layer.borderWidth = width
        $0.layer.borderColor = borderColor?.cgColor
        $0.layer.shadowOpacity = opacity
        $0.layer.shadowOffset = CGSize(width: 1, height: 1)
        $0.layer.shadowRadius = radius
        $0.layer.shadowColor = color.cgColor
    }
}

public func setButtonTitleStyle(_ font: UIFont, _ color: UIColor?, underline: Bool) -> (UIButton) -> Void {
    return {
        guard let title = $0.title(for: .normal) else { return }
        var attributes: [NSAttributedString.Key: Any] = [
            .font: font
        ]
        if let color = color {
            attributes[.foregroundColor] = color
        }
        if underline {
            attributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
        }
        let attributedString = NSAttributedString(string: title, attributes: attributes)
        $0.setAttributedTitle(attributedString, for: .normal)
    }
}

// UITextField Styles

public func setTextFieldPlaceholder(_ text: String, _ font: UIFont, _ color: UIColor) -> (UITextField) -> Void {
    return { $0.attributedPlaceholder = NSAttributedString(string: text, attributes: [.font: font, .foregroundColor: color]) }
}

public func setTextFieldStyle(_ font: UIFont, _ color: UIColor, _ tint: UIColor) -> (UITextField) -> Void {
    return { $0.font = font; $0.textColor = color; $0.tintColor = tint }
}

public func setTextFieldTextFont(_ font: UIFont) -> (UITextField) -> Void {
    return { $0.font = font }
}

public func setTextViewFontColor(_ font: UIFont, _ color: UIColor) -> (UITextView) -> Void {
    return { $0.font = font; $0.textColor = color }
}

public func translateAutoResizeFalse(_ view: UIView) {
    view.translatesAutoresizingMaskIntoConstraints = false
}

public func shadowStyle(color: UIColor?, opacity: Float, radius: CGFloat = 10) -> (UIView) -> Void {
    return {
        $0.layer.cornerRadius = radius
        $0.layer.shadowOpacity = opacity
        $0.layer.shadowOffset = CGSize(width: 1, height: 1)
        $0.layer.shadowRadius = radius
        $0.layer.shadowColor = color?.cgColor
    }
}

public func cardViewStyle(color:UIColor?, offset: CGSize = .init(width: 1, height: 1),
                          shadowOpacity: Float, shadowPath: CGPath,
                          shadowSize:CGSize) -> (UIView) -> Void {
    return {
        $0.layer.masksToBounds = false
        $0.layer.shadowColor = color?.cgColor
        $0.layer.shadowOffset = shadowSize
        $0.layer.shadowOpacity = shadowOpacity
        $0.layer.shadowPath = shadowPath
    }
}

public func wrapStyle(padding: UIEdgeInsets, background: UIColor = .white) -> (UIView) -> UIView {
    return {
        let wrapper = UIView()
        wrapper.backgroundColor = background
        wrapper.translatesAutoresizingMaskIntoConstraints = false
        $0.translatesAutoresizingMaskIntoConstraints = false
        wrapper.addSubview($0)
        NSLayoutConstraint.activate([
            $0.leftAnchor.constraint(equalTo: wrapper.leftAnchor, constant: padding.left),
            $0.rightAnchor.constraint(equalTo: wrapper.rightAnchor, constant: padding.right),
            $0.topAnchor.constraint(equalTo: wrapper.topAnchor, constant: padding.top),
            $0.bottomAnchor.constraint(equalTo: wrapper.bottomAnchor, constant: padding.bottom)
        ])
        return wrapper
    }
}

public func wrapStyle(size: CGSize) -> (UIView) -> UIView {
    return {
        let wrapper = UIView()
//        wrapper.backgroundColor = .green
        wrapper.translatesAutoresizingMaskIntoConstraints = false
        $0.translatesAutoresizingMaskIntoConstraints = false
        wrapper.addSubview($0)
        NSLayoutConstraint.activate([
            wrapper.widthAnchor.constraint(equalToConstant: size.width),
            wrapper.heightAnchor.constraint(equalToConstant: size.height),
            $0.centerXAnchor.constraint(equalTo: wrapper.centerXAnchor),
            $0.centerYAnchor.constraint(equalTo: wrapper.centerYAnchor)
        ])
        return wrapper
    }
}

