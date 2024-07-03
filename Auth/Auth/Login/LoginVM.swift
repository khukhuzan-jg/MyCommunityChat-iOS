//
//  LoginVM.swift
//  Auth
//
//  Created by kukuzan on 03/07/2024.
//

import Foundation
import Domain
import Combine

class LoginVM {
    
    private var cancellables = Set<AnyCancellable>()
    
    func transform(_ input: String, completion: @escaping(Bool) -> Void) {
        FirebaseAuthManager.shared.startAuth(phoneNumber: input)
            .receive(on: DispatchQueue.main)
            .sink { success in
                guard success else {
                    completion(false)
                    return
                }
                completion(true)
            }
            .store(in: &cancellables)
    }
}
