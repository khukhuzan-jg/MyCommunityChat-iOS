//
//  ChatRoomViewModel.swift
//  MyCommunityChat-iOS
//
//  Created by Phyo Kyaw Swar on 03/07/2024.
//

import Foundation
import RxRelay
import RxSwift
protocol ChatRoomViewModelProtocol {
    func tapCameraIcon() 
    func sendMessage(message : Message)
    func getMessage()
}
class ChatRoomViewModel : BaseViewModel {
    static let shared = ChatRoomViewModel()
    let chatManager = ChatManager.shared
    
    let messageListBehaviorRelay = BehaviorRelay<[Message]>(value: [])
    
    var currentUser =  BehaviorRelay<UserData?>(value: nil)
    var selectedUser = BehaviorRelay<UserData?>(value: nil)
    var successfullySendMessage = BehaviorRelay<Bool>(value: false)
    
    var senderId : String = ""
    var receiverId : String = ""
    
    override init() {
        super.init()
    }
    
    override func bindData() {
        Observable.combineLatest(currentUser, selectedUser).bind { (current , selected) in
            self.checkUserCreatedDate()
            self.chatManager.createDatabase(senderId:self.senderId , receiverId: self.receiverId)
            self.chatManager.changesMessage(senderId: self.senderId, receiverId: self.receiverId) {
                self.getMessage()
            }
        }
        .disposed(by: disposeBag)
    }
    
    private func checkUserCreatedDate()  {
        let currentUserCreatedDate = (currentUser.value?.createdAt ?? "").toDate(format: .type12) ?? Date()
        let selectedUserCreatedDate = (selectedUser.value?.createdAt ?? "").toDate(format: .type12) ?? Date()
        
        let currentUserId = currentUser.value?.id ?? ""
        let selectedUserId = selectedUser.value?.id ?? ""
        
        if currentUserCreatedDate < selectedUserCreatedDate {
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

extension ChatRoomViewModel : ChatRoomViewModelProtocol {
    func tapCameraIcon() {
        
    }
    
    func sendMessage(message: Message) {
        chatManager.sendMessage(senderId: self.senderId, receiverId: self.receiverId, message: message) { message in
            print("Message :::::: \(message.messageText ?? "")")
            successfullySendMessage.accept(true)
        }
        
    }
    
    func getMessage() {
        chatManager.getMessage(senderId: self.senderId, receiverId: self.receiverId) { messages in
            self.messageListBehaviorRelay.accept(messages)
            if (self.senderId == self.selectedUser.value?.id ?? "") || (self.receiverId == self.selectedUser.value?.id ?? "") {
                
                UserInfoManager.shared.setLastMessage(user: self.selectedUser.value ?? UserData(), message: messages.last ?? Message()) { data in
                    print("User Data ")
                }
            }
        }
        
    }
}
