//
//  ForwardViewModel.swift
//  MyCommunityChat-iOS
//
//  Created by Phyo Kyaw Swar on 16/07/2024.
//

import Foundation
import RxRelay

protocol ForwardViewModelProtocol {
    func getAllUsers()
    func createForwardMessage(message : Message , completion : @escaping (_ sendMessage : Message) -> Void)
    func sendMessage(message : Message)
}
class ForwardViewModel : BaseViewModel {
    let model = ForwardModel.shared
    
    let chatManager = ChatManager.shared
    
    let userListBehaviorRelay = BehaviorRelay<[UserData]?>(value: nil)
    let successfullySendMessage = BehaviorRelay<Bool>(value: false)
    
    var currentUser =  BehaviorRelay<UserData?>(value: nil)
    var selectedUser = BehaviorRelay<UserData?>(value: nil)
    
    var senderId : String = ""
    var receiverId : String = ""
    
    private func checkUserCreatedDate()  {
//        let currentUserCreatedDate = (currentUser.value?.createdAt ?? "").toDate(format: .type12) ?? Date()
//        let selectedUserCreatedDate = (selectedUser.value?.createdAt ?? "").toDate(format: .type12) ?? Date()
//        
        let currentUserId = currentUser.value?.id ?? ""
        let selectedUserId = selectedUser.value?.id ?? ""
        
        if currentUserId < selectedUserId {
            self.senderId = currentUserId
            self.receiverId = selectedUserId
        }
        else {
//            conVersationId = selectedUserId + "__" + currentUserId
            self.receiverId = currentUserId
            self.senderId = selectedUserId
        }
        
    }
}
extension ForwardViewModel : ForwardViewModelProtocol {
    func createForwardMessage(message: Message, completion: @escaping (Message) -> Void) {
        self.checkUserCreatedDate()
        var forwardMessage = [String : String]()
        
        if let forward = message.forwardMessage {
            forwardMessage = forward
        }
        else {
            forwardMessage = [
                "text" : message.messageText ?? "",
                "image" : message.messageImage ?? "",
                "messageType" : message.messageType?.getValue() ?? "",
                "createdAt" : Date().toString(.type13, timeZone: "MM"),
                "updatedAt" : Date().toString(.type13, timeZone: "MM"),
                "senderId" : message.senderId ?? "",
                "reaction" : message.reaction ?? "",
                "sticker" : message.sticker ?? "",
                "gif" : message.gif ?? "",
            ]
        }
        
        
        let msg = Message(
            messageId: message.messageId,
            messageText: "",
            messageImage: "",
            messageType: .forward,
            createdAt: Date().toString(.type13, timeZone: "MM"),
            lastMessage: "",
            senderId: self.senderId,
            reaction: "",
            sticker: "",
            forwardMessage: forwardMessage
        )
        
        completion(msg)
    }
    
    func getAllUsers() {
        model.getAllUsers { users in
            self.userListBehaviorRelay.accept(users)
        }
    }
    
    func sendMessage(message: Message) {
        chatManager.sendMessage(senderId: self.senderId, receiverId: self.receiverId, message: message) { message in
            print("Message :::::: \(message.messageText ?? "")")
            successfullySendMessage.accept(true)
        }
        
    }
}
