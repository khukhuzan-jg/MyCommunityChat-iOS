//
//  ForwardModel.swift
//  MyCommunityChat-iOS
//
//  Created by Phyo Kyaw Swar on 16/07/2024.
//

import Foundation
protocol ForwardModelProtocol {
    func getAllUsers(completion : @escaping (_ users : [UserData]) -> Void)
    
}
class ForwardModel {
    static let shared = ForwardModel()
    var userManager = UserInfoManager.shared
}

extension ForwardModel : ForwardModelProtocol {
    func getAllUsers(completion: @escaping ([UserData]) -> Void) {
        userManager.getUserList { users in
            completion(users)
        }
    }
}
