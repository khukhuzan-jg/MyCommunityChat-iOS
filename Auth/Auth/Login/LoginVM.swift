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
    private let maxSmsPerDay = 10

    // Method to get the current count of SMS requests
    private func getSmsCount() -> Int {
        let defaults = UserDefaults.standard
        let today = Date()
        let lastResetDate = defaults.object(forKey: "lastResetDate") as? Date ?? Date.distantPast

        if !Calendar.current.isDateInToday(lastResetDate) {
            // Reset the counter if it's a new day
            defaults.set(0, forKey: "smsCount")
            defaults.set(today, forKey: "lastResetDate")
        }
        
        return defaults.integer(forKey: "smsCount")
    }
    
    // Method to increment the SMS count
    private func incrementSmsCount() {
        let defaults = UserDefaults.standard
        let newCount = getSmsCount() + 1
        defaults.set(newCount, forKey: "smsCount")
    }
    
    func transform(_ input: String, completion: @escaping (Bool) -> Void) {
        let smsCount = getSmsCount()
        print("SMS Count:", smsCount)

        guard smsCount < maxSmsPerDay else {
            print("Exceeded Limit")
            completion(false)
            return
        }
        
        FirebaseAuthManager.shared.startAuth(phoneNumber: input)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] success in
                if success {
                    self?.incrementSmsCount()
                    print("Success:", success)
                    completion(true)
                } else {
                    print("Failure:", success)
                    completion(false)
                }
            }
            .store(in: &cancellables)
    }
}


