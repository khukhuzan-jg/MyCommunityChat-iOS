//
//  ChatManager.swift
//  MyCommunityChat-iOS
//
//  Created by Phyo Kyaw Swar on 04/07/2024.
//

import Foundation
import FirebaseDatabase

protocol ChatManagerProtocol {
    func createDatabase(senderId : String , receiverId : String)
    func checkConversationByConversationId(senderId : String , receiverId : String) -> Bool
    func getMessage(senderId : String , receiverId : String , completion : @escaping(_ messages : [Message]) -> Void)
    func sendMessage(senderId : String , receiverId : String,  message : Message , completion : (_ message : Message) -> Void)
    func changesMessage(senderId : String , receiverId : String, completion : @escaping() -> Void)
    
    func updateMessage(senderId : String , receiverId : String, message : Message , messageId : String,  completion : @escaping() -> Void)
}

class ChatManager {
    static let shared = ChatManager()
    
    var messageList = [Message]()
    var ref: DatabaseReference!
    
    
    init() {
        ref = Database.database().reference()
    }
    
    

}

extension ChatManager : ChatManagerProtocol {
    func createDatabase(senderId : String , receiverId : String) {
        let conversations = self.ref.child(Conversation.conversations.getValue())

        self.ref.child(Conversation.conversations.getValue()).child(senderId + "__" + receiverId).child(Conversation.conversationMessage.getValue())
    }
    func getMessage(senderId : String , receiverId : String , completion : @escaping(_ messages : [Message] ) -> Void){
        
        self.ref.child(Conversation.conversations.getValue())
            .child(senderId + "__" + receiverId)
            .child(Conversation.conversationMessage.getValue())
            .observeSingleEvent(of: .value) { snapshot in
                self.messageList.removeAll()
                for childSnapshot in snapshot.children.allObjects as! [DataSnapshot] {
                  
                var message = Message()
                    message.messageId = childSnapshot.key
                    message.messageText =  childSnapshot.childSnapshot(forPath:"text").value as? String
                    message.messageImage = childSnapshot.childSnapshot(forPath:"image").value as? String
                    message.messageType =  MessageType(rawValue: childSnapshot.childSnapshot(forPath:"messageType").value as? String ?? "" )
                    message.createdAt =  childSnapshot.childSnapshot(forPath:"createdAt").value as? String
                    message.lastMessage =  ""
                    message.senderId =  childSnapshot.childSnapshot(forPath:"senderId").value as? String
                    message.reaction = childSnapshot.childSnapshot(forPath: "reaction").value as? String
                    message.sticker = childSnapshot.childSnapshot(forPath: "sticker").value as? String
                    message.senderName = childSnapshot.childSnapshot(forPath: "senderName").value as? String
                    message.isPinned = childSnapshot.childSnapshot(forPath: "isPinned").value as? Bool
                    message.forwardMessage = childSnapshot.childSnapshot(forPath: "forwardMessage").value as? [String : String]
                    
                    self.messageList.append(message)
                }
                completion(self.messageList)
            }
    }
    
    func sendMessage(senderId : String , receiverId : String,  message : Message , completion : (_ message : Message) -> Void) {
        
        let sendMessage = [
            "text" : message.messageText ?? "",
            "image" : message.messageImage ?? "",
            "messageType" : message.messageType?.getValue() ?? "",
            "createdAt" : Date().toString(.type13, timeZone: "MM"),
            "updatedAt" : Date().toString(.type13, timeZone: "MM"),
            "senderId" : message.senderId ?? "",
            "reaction" : message.reaction ?? "",
            "sticker" : message.sticker ?? "",
            "forwardMessage" : message.forwardMessage,
            "senderName" : message.senderName ?? "",
            "isPinned" : message.isPinned ?? false
        ] as [String : Any]
        
        self.ref.child(Conversation.conversations.getValue()).child(senderId + "__" + receiverId).child(Conversation.conversationMessage.getValue()).childByAutoId()
            .setValue(sendMessage)
        
        completion(message)
    }
    
    func checkConversationByConversationId(senderId: String, receiverId: String) -> Bool {
        return true
    }
    
    func changesMessage(senderId: String, receiverId: String, completion: @escaping() -> Void) {
        self.ref.child(Conversation.conversations.getValue())
            .child(senderId + "__" + receiverId)
            .child(Conversation.conversationMessage.getValue())
            .observe(.childAdded) { _ in
                completion()
            }
    }
    
    func updateMessage(senderId: String, receiverId: String, message : Message, messageId: String, completion: @escaping () -> Void) {
        guard let sendMessage = [
            "text" : message.messageText ?? "",
            "image" : message.messageImage ?? "",
            "messageType" : message.messageType?.getValue() ?? "",
            "createdAt" : Date().toString(.type13, timeZone: "MM"),
            "updatedAt" : Date().toString(.type13, timeZone: "MM"),
            "senderId" : message.senderId ?? "",
            "reaction" : message.reaction ?? "",
            "sticker" : message.sticker ?? "",
            "senderName" : message.senderName ?? "",
            "isPinned" : message.isPinned ?? false
//            "forwardMessage" : message.forwardMessage ?? ForwardMessage()
        ] as? [String : Any] else { return  }
        
        self.ref.child(Conversation.conversations.getValue())
            .child(senderId + "__" + receiverId)
            .child(Conversation.conversationMessage.getValue())
            .child(messageId)
            .updateChildValues(sendMessage) { error, db in
                if let err = error {
                    print("Error :::::: \(err.localizedDescription)")
                }
                else {
                    completion()
                }
            }
    }
}
