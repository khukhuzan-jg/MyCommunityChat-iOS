//
//  HomeViewModle.swift
//  MyCommunityChat-iOS
//
//  Created by Phyo Kyaw Swar on 03/07/2024.
//

import Foundation
import Auth
import RxRelay

protocol HomeViewModelProtocol {
    func getCurrentUser()
    func getUserList()
    func logoutUser(userId: String)
}
class HomeViewModel : BaseViewModel{
    let userInfoManager = UserInfoManager.shared
    var currentUser = BehaviorRelay<UserData?>(value: nil)
    var userList = BehaviorRelay<[UserData]?>(value: nil)
    var isSuccessfullyLogout = BehaviorRelay<Bool>(value: false)
    override init() {
        super.init()
        getCurrentUser()
        getUserList()
        userInfoManager.chagneUserNode(userId: self.currentUser.value?.id ?? (UIDevice.current.identifierForVendor?.uuidString) ?? "")
    }
    
    override func bindData() {
        super.bindData()
        
        userInfoManager.updateLastMessage.bind { isUpdate in
            self.getUserList()
        }
        .disposed(by: disposeBag)
    }
}

extension HomeViewModel : HomeViewModelProtocol {
    func logoutUser(userId: String) {
        userInfoManager.logoutUser(userId: userId) { isSuccess in
            self.isSuccessfullyLogout.accept(isSuccess)
        }
    }
    
    func getCurrentUser() {
        userInfoManager.getUser(userId: UIDevice.current.identifierForVendor?.uuidString ?? "") { userInfo in
            self.currentUser.accept(userInfo)
        }
    }
    
    func getUserList() {
        userInfoManager.getUserList { users in
            let userList = users.sorted(by: {
                $0.time?.toDate(dateFormat: "dd MMM yyyy hh:mm:ss a") ?? Date() > $1.time?.toDate(dateFormat: "dd MMM yyyy hh:mm:ss a") ?? Date()
            })
            self.userList.accept(userList)
        }
    }
    
}

