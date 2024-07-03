//
//  FirebaseAuthManager.swift
//  Domain
//
//  Created by kukuzan on 03/07/2024.
//

import Foundation
import FirebaseAuth
import Combine

public class FirebaseAuthManager {
    public static let shared = FirebaseAuthManager()
    
    private let auth = Auth.auth()
    private var verificationId: String?
    private var verificationSubject = PassthroughSubject<Bool, Never>()
    private var verificationCancellable: AnyCancellable?

    private init() {}

    public func startAuth(phoneNumber: String) -> AnyPublisher<Bool, Never> {
        Future<Bool, Never> { [weak self] promise in
            PhoneAuthProvider.provider().verifyPhoneNumber(
                phoneNumber,
                uiDelegate: nil
            ) { verificationId, error in
                if let verificationId = verificationId, error == nil {
                    self?.verificationId = verificationId
                    promise(.success(true))
                } else {
                    promise(.success(false))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    public func verifyCode(smsCode: String) -> AnyPublisher<Bool, Never> {
        Future<Bool, Never> { [weak self] promise in
            guard let verificationId = self?.verificationId else {
                promise(.success(false))
                return
            }
            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: verificationId,
                verificationCode: smsCode
            )
            
            self?.auth.signIn(with: credential) { result, error in
                if result != nil, error == nil {
                    promise(.success(true))
                } else {
                    promise(.success(false))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

