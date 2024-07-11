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
    
    func getValue() -> String {
        return self.rawValue
    }
}
public struct Message {
    public var messageText : String?
    public var messageImage : String?
    public var messageType : MessageType?
    public var createdAt : String?
    public var lastMessage : String?
    public var senderId : String?
    public var reaction: String?
    
}
class ChatRoomModel {
    
}
