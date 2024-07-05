//
//  StringCosntants.swift
//  MyCommunityChat-iOS
//
//  Created by Phyo Kyaw Swar on 04/07/2024.
//

import Foundation

enum Conversation : String {
    case conversations = "Conversations"
    case conversationMessage = "Messages"
    
    
    func getValue() -> String {
        return self.rawValue
    }
}

enum UserDB : String {
    case users = "Users"
    
    func getValue() -> String {
        return self.rawValue
    }
}

//enum TestIds : String {
//    case senderId = "User-001"
//    case receiverId = "User-002"
//    
//    func getValue() -> String {
//        return self.rawValue
//    }
//}
