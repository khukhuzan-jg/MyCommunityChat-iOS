//
//  UserInfoManager.swift
//  MyCommunityChat-iOS
//
//  Created by Phyo Kyaw Swar on 04/07/2024.
//

import Foundation
import Auth
import FirebaseDatabase
import RxRelay

public struct UserData {
    public var id : String? = UIDevice.current.identifierForVendor?.uuidString ?? ""
    public var name : String?
    public var image : String?
    public var phone : String?
    public var createdAt : String?
    public var lastMessage : String?
    public var time : String?
}
protocol UserInfoManagerProtocol {
    func savedUser(user : UserData) -> UserData
    func getUser(userId : String , completion : @escaping(_ userInfo : UserData?) -> Void)
    func getUserList(completion : @escaping(_ users : [UserData]) -> Void)
    func setLastMessage(user : UserData , message : Message , completion: @escaping(_ user : UserData) -> Void)
    func chagneUserNode(userId : String)
    func logoutUser(userId : String , completion : @escaping(_ isLogout : Bool) -> Void)
}
public class UserInfoManager {
    public static let shared = UserInfoManager()
    
    var ref: DatabaseReference!
    
    public var isAlreadyLogin = false
    public var currentUser : UserData?
    public var userList : [UserData]?
    
    public var updateLastMessage = BehaviorRelay<Bool>(value : false)
    
    public init() {
        ref = Database.database().reference()
        self.getUser(userId: UIDevice.current.identifierForVendor?.uuidString ?? "") { user in
            if let usr = user {
                self.isAlreadyLogin = true
                self.currentUser = usr
            }
            else {
                self.isAlreadyLogin = false
                self.currentUser = nil
            }
        }
        
        self.getUserList { users in
            self.userList = users
        }
        
        
    }
}

extension UserInfoManager : UserInfoManagerProtocol {
    func setLastMessage(user: UserData, message: Message, completion: @escaping (UserData) -> Void) {
        let userInfo = [
            "userId" : user.id,
            "userImage" : user.image,
            "userName" : user.name,
            "userPhone" : user.phone,
            "createdAt" : user.createdAt,
            "lastMessage" : message.messageText,
            "time" : message.createdAt
        ]
        
        self.ref.child("Users").child(user.id ?? "").setValue(userInfo)
        self.updateLastMessage.accept(true)
    }
    
    func savedUser(user: UserData) -> UserData {
        let userInfo = [
            "userId" : user.id,
            "userImage" : user.image,
            "userName" : user.name,
            "userPhone" : user.phone,
            "createdAt" : Date().toString(.type12, timeZone: "MM"),
            "lastMessage" : "",
            "time" : ""
        ]
        
        self.ref.child("Users").child(user.id ?? "").setValue(userInfo)
        return user
    }
    
    func getUser(userId: String , completion: @escaping(_ userInfo : UserData?) -> Void) {
        self.ref.child("Users")
//            .child(userId)
            .observeSingleEvent(of: .value) { snapshot in
                for childSnapshot in snapshot.children.allObjects as! [DataSnapshot] {
                    if let id = childSnapshot.childSnapshot(forPath:"userId").value as? String ,
                    id == userId {
                      
                        var user = UserData()
                        user.id = childSnapshot.childSnapshot(forPath:"userId").value as? String
                        user.name = childSnapshot.childSnapshot(forPath:"userName").value as? String
                        user.image = childSnapshot.childSnapshot(forPath:"userImage").value as? String
                        user.phone = childSnapshot.childSnapshot(forPath:"userPhone").value as? String
                        user.createdAt = childSnapshot.childSnapshot(forPath: "createdAt").value as? String
                        completion(user)
                    }
                    
                }
            }
    }
    
    func getUserList(completion : @escaping(_ users : [UserData]) -> Void) {
        var userList = [UserData]()
        self.ref.child("Users")
            .observeSingleEvent(of: .value) { snapshot in
                for childSnapshot in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    var user = UserData()
                    user.id = childSnapshot.childSnapshot(forPath:"userId").value as? String
                    user.name = childSnapshot.childSnapshot(forPath:"userName").value as? String
                    user.image = childSnapshot.childSnapshot(forPath:"userImage").value as? String
                    user.phone = childSnapshot.childSnapshot(forPath:"userPhone").value as? String
                    user.createdAt = childSnapshot.childSnapshot(forPath: "createdAt").value as? String
                    userList.append(user)
                }
                self.userList  = userList
                completion(userList)
            }
    }
    
    func chagneUserNode(userId: String) {
        self.ref.child("Users")
            .child(userId)
            .observeSingleEvent(of: .childChanged) { snapshot in
                self.updateLastMessage.accept(true)
            }
    }
    
    func logoutUser(userId: String, completion: @escaping (Bool) -> Void) {
        self.ref.child("Users")
            .child(userId)
            .removeValue { error, _ in
                if let err = error {
                    print("Error ::::: \(error?.localizedDescription)")
                    completion(false)
                }
                
                completion(true)
            }
    }
    
}
