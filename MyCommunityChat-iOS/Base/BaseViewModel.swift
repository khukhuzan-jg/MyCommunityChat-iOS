//
//  BaseViewModel.swift
//  MyCommunityChat-iOS
//
//  Created by Phyo Kyaw Swar on 04/07/2024.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

class BaseViewModel {
    var disposeBag = DisposeBag()
    
    init() {
        self.bindData()
    }
    
    func bindData() {
        
    }
}
