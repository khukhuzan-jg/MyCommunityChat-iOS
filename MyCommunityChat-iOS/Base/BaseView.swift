//
//  BaseView.swift
//  CommonUI
//
//  Created by Phyo Kyaw Swar on 11/07/2024.
//

import Foundation
import UIKit
import RxRelay
import RxSwift

public class BaseView : UIView {
    
    var view: UIView!
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        bindObserver()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        bindObserver()
    }
    
    
    func setupUI() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    func bindObserver() {
        
    }
    
    func loadViewFromNib() -> UIView! {
        return UINib(nibName: String(describing: type(of: self)), bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView ?? UIView(frame: CGRect.zero)
    }
    

}
