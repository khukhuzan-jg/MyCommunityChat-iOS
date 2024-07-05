//
//  OTPVM.swift
//  Auth
//
//  Created by kukuzan on 03/07/2024.
//

import Foundation
import Domain
import Combine

class OTPVM {
    private var cancellables = Set<AnyCancellable>()
    
    func transform(_ input: String, completion: @escaping(Bool) -> Void) {
        FirebaseAuthManager.shared.verifyCode(smsCode: input)
            .receive(on: DispatchQueue.main)
            .sink { success in
//                guard success else {
//                    completion(false)
//                    return
//                }
                if success {
                    completion(true)
                } else {
                    completion(false)
                }
            }
            .store(in: &cancellables)
    }
    
}
