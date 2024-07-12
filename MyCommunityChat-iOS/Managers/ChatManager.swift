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
                    message.messageText =  childSnapshot.childSnapshot(forPath:"text").value as? String
                    message.messageImage = childSnapshot.childSnapshot(forPath:"image").value as? String
                    message.messageType =  MessageType(rawValue: childSnapshot.childSnapshot(forPath:"messageType").value as? String ?? "" )
                    message.createdAt =  childSnapshot.childSnapshot(forPath:"createdAt").value as? String
                    message.lastMessage =  ""
                    message.senderId =  childSnapshot.childSnapshot(forPath:"senderId").value as? String
                    message.sticker = childSnapshot.childSnapshot(forPath: "sticker").value as? String
                    
                    //
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
            "sticker" : message.sticker ?? ""
        ]
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
}
