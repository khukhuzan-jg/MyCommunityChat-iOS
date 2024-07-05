//
//  BaseViewController.swift
//  MyCommunityChat-iOS
//
//  Created by Phyo Kyaw Swar on 04/07/2024.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Auth

class BaseViewController : UIViewController {
    let disposeBag = DisposeBag()
    let userManager = UserManager.shared
    override func viewDidLoad() {
        self.bindData()
        self.bindObserver()
    }
    
    func bindData() {
        
    }
    
    func bindObserver() {
        
    }
}
