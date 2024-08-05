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
    func updateMessage(message : Message)
    
    /// Note: db methods for noti mute / unmute
    func savedNotiSetting(settingType : ChatRoomMoreSetting)
    func getNotiSetting()
    func deleteNotiSetting()
}
class ChatRoomViewModel : BaseViewModel {
    static let shared = ChatRoomViewModel()
    let chatManager = ChatManager.shared
    
    let messageListBehaviorRelay = BehaviorRelay<[Message]>(value: [])
    
    var currentUser =  BehaviorRelay<UserData?>(value: nil)
    var selectedUser = BehaviorRelay<UserData?>(value: nil)
    var successfullySendMessage = BehaviorRelay<Bool>(value: false)
    var selectedMoreSetting = BehaviorRelay<ChatRoomMoreSetting>(value: .notiUnMute)
    var selectedSticker = BehaviorRelay<UIImage>(value: UIImage())
    var selectedGif = BehaviorRelay<String>(value: String())
    
    var selectedMessagesBehaviorRelay = BehaviorRelay<[Message]>(value: [])
    
    var senderId : String = ""
    var receiverId : String = ""
    
    var startDateBehaviorRelay = BehaviorRelay<String>(value : "")
    var endDateBehaviorRelay = BehaviorRelay<String>(value : "")
    
    var dbManager = DataBaseManager.shared
    
    var isSuccessfullySavedBehaviorRelay = BehaviorRelay(value: false)
    var isActiveSaveButtonBehaviorRelay = BehaviorRelay(value: false)
    
    var isUpdateBehaviorRelay = BehaviorRelay(value: false)
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
        
        Observable.combineLatest(startDateBehaviorRelay, endDateBehaviorRelay).bind { (startDate , endDate) in
            let start = startDate.toDate(format: .type12) ?? Date()
            let end = endDate.toDate(format: .type12) ?? Date()
            
            let isActve = start < end && !startDate.isEmpty && !endDate.isEmpty
            self.isActiveSaveButtonBehaviorRelay.accept(isActve)
        }
        .disposed(by: disposeBag)
    }
    
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
    
    func getCurrentDate() -> String {
        return Date().toString(.type12)
    }
    
    func getStartDate(settingType : ChatRoomMoreSetting) -> String {
        switch settingType {
        case .notiUnMute:
            return ""
        case .notiMuteOneDay:
            return getCurrentDate()
        case .notiMuteOneWeek:
            return getCurrentDate()
        case .notiMuteOneMonth:
            return getCurrentDate()
        case .notiMutePermanently:
            return getCurrentDate()
        case .notiMuteCustom:
            return startDateBehaviorRelay.value
        case .leaveGroup:
            return ""
        }
    }
    
    func getEndDate(settingType : ChatRoomMoreSetting) -> String {
        switch settingType {
        case .notiUnMute:
            return ""
        case .notiMuteOneDay:
            let today = Date()
            let modifiedDate = Calendar.current.date(byAdding: .day, value: 1, to: today)!
            return modifiedDate.toString(.type12)
        case .notiMuteOneWeek:
            let today = Date()
            let modifiedDate = Calendar.current.date(byAdding: .day, value: 7, to: today)!
            return modifiedDate.toString(.type12)
        case .notiMuteOneMonth:
            let today = Date()
            let modifiedDate = Calendar.current.date(byAdding: .day, value: 30, to: today)!
            return modifiedDate.toString(.type12)
        case .notiMutePermanently:
            let today = Date()
            let modifiedDate = Calendar.current.date(byAdding: .year, value: 1, to: today)!
            return modifiedDate.toString(.type12)
        case .notiMuteCustom:
            return endDateBehaviorRelay.value
        case .leaveGroup:
            return ""
        }
    }
}

extension ChatRoomViewModel : ChatRoomViewModelProtocol {
    func savedNotiSetting(settingType: ChatRoomMoreSetting) {
        self.checkUserCreatedDate()
        let conversationId = self.senderId + "__" + self.receiverId
        let dbObj = NotiDBRealmObject()
        dbObj.conversationId = conversationId
        dbObj.startTime = getStartDate(settingType: self.selectedMoreSetting.value)
        dbObj.endTime = getEndDate(settingType: self.selectedMoreSetting.value)
        dbObj.settingType = selectedMoreSetting.value.rawValue
        
        dbManager.saveNotiSettingById(dbObj) { isSuccess in
            self.isSuccessfullySavedBehaviorRelay.accept(isSuccess)
        }
        
        
    }
    
    func getNotiSetting() {
        
    }
    
    func deleteNotiSetting() {
        
    }
    
    func tapCameraIcon() {
        
    }
    
    func sendMessage(message: Message) {
        chatManager.sendMessage(senderId: self.senderId, receiverId: self.receiverId, message: message) { message in
            print("Message :::::: \(message.messageText ?? "")")
            isUpdateBehaviorRelay.accept(false)
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
    func updateMessage(message: Message) {
        chatManager.updateMessage(senderId: self.senderId, receiverId: self.receiverId, message: message, messageId: message.messageId ?? "") {
            print("Update Done")
            self.isUpdateBehaviorRelay.accept(true)
            self.getMessage()
        }
    }
}
