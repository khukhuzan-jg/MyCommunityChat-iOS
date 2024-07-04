//
//  AlertDialog.swift
//  CommonUI
//
//  Created by kukuzan on 04/07/2024.
//

import UIKit
import CommonExtension

public protocol AlertCancellableProtocol: AnyObject {
    func dismiss()
}

public protocol AlertContentProtocol: AnyObject {
    var alertContent: UIView? { get }
    var alert: AlertCancellableProtocol? { get set }
}

public class AlertDialog: UIView {
    
    private var containerView: UIView!
    private var contentView: UIView!
    
    public init() {
        super.init(frame: .zero)
    }
    
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func removeAll() {
        contentView = nil
        subviews.forEach { $0.removeFromSuperview() }
    }
    
    public func configure(content: AlertContentProtocol) {
        removeAll()
        containerView = UIView()
        addSubview(containerView)
        
        contentView = content.alertContent
        content.alert = self
        addSubview(contentView)
        layoutContentView()
    }
    
    private func layoutContentView() {
        containerView.backgroundColor = .black.withAlphaComponent(0.3)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 8
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: centerYAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25)
        ])
    }
    
    public func present() {
        let window = UIApplication.shared.windows.filter ({ $0.isKeyWindow }).first
        frame = window?.bounds ?? .zero
        window?.addSubview(self)
    }

}

extension AlertDialog: AlertCancellableProtocol {
    public func dismiss() {
        let window = UIApplication.shared.windows.filter ({ $0.isKeyWindow }).first
        let alert = window?.subviews.filter { $0 is AlertDialog } ?? []
        alert.forEach { $0.removeFromSuperview() }
    }
}
