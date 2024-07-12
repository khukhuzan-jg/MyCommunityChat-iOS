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

enum ChatRoomMoreSetting : String {
    case notiUnMute = "Unmute"
    case notiMuteOneDay = "Mute for 1 day"
    case notiMuteOneWeek = "Mute for 1 week"
    case notiMuteOneMonth = "Mute for 1 month"
    case notiMutePermanently = "Mute permanently"
    case notiMuteCustom = "Mute custom"
    case leaveGroup = "Leave group"
    
    
    func getTitle() -> String {
        return self.rawValue
    }
    
}
