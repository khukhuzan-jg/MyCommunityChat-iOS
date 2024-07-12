//
//  ChatRoomModel.swift
//  MyCommunityChat-iOS
//
//  Created by Phyo Kyaw Swar on 03/07/2024.
//

import Foundation

public enum MessageType : String{
    case text
    case image
    case sticker
    
    func getValue() -> String {
        return self.rawValue
    }
}
public struct Message {
    public var messageId : String?
    public var messageText : String?
    public var messageImage : String?
    public var messageType : MessageType?
    public var createdAt : String?
    public var lastMessage : String?
    public var senderId : String?
    public var reaction: String?
    public var sticker : String?
    
}

protocol ChatroomModelProtocol {
    func savedNotiSetting(converstaionId : String , settingType : ChatRoomMoreSetting)
    func getNotiSetting(converstaionId : String)
}
class ChatRoomModel {
    let dbManager = DataBaseManager.shared
}

extension ChatRoomModel : ChatroomModelProtocol {
    func savedNotiSetting(converstaionId: String, settingType: ChatRoomMoreSetting) {
        
    }
    
    func getNotiSetting(converstaionId: String) {
        
    }
    
    
}

