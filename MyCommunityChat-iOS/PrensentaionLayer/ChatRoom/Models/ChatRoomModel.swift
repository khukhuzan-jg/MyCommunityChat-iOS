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
    case forward
    
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
    public var forwardMessage : [String : String]?
    public var senderName : String?
    public var isPinned : Bool?
}

//public struct ForwardMessage {
//    public var messageId : String?
//    public var messageText : String?
//    public var messageImage : String?
//    public var messageType : MessageType?
//    public var createdAt : String?
//    public var lastMessage : String?
//    public var senderId : String?
//    public var reaction: String?
//    public var sticker : String?
//    
//    public func convertMessageToForwardMessage(message : Message) -> ForwardMessage {
//        return ForwardMessage(
//            messageId: message.messageId,
//            messageText: message.messageText,
//            messageImage: message.messageImage,
//            messageType: message.messageType,
//            createdAt: message.createdAt,
//            lastMessage: message.lastMessage,
//            senderId: message.senderId,
//            reaction: message.reaction,
//            sticker: message.sticker
//        )
//    }
//    
//}

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

