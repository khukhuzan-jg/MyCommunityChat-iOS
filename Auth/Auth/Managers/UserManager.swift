//
//  UserManager.swift
//  MyCommunityChat-iOS
//
//  Created by Phyo Kyaw Swar on 04/07/2024.
//

import Foundation
import FirebaseDatabase

public struct UserInfo {
    public var id : String? = UIDevice.current.identifierForVendor?.uuidString ?? ""
    public var name : String?
    public var image : String?
    public var phone : String?
    public var createdAt : String?
}

protocol UserManagerProtocol {
    func savedUser(user : UserInfo) -> UserInfo
    func getUser(userId : String , completion : @escaping(_ userInfo : UserInfo?) -> Void)
    func getUserList(completion : @escaping(_ users : [UserInfo]) -> Void)
}
public class UserManager {
    public static let shared = UserManager()
    
    var ref: DatabaseReference!
    
    public var isAlreadyLogin = false
    public var currentUser : UserInfo?
    public var userList : [UserInfo]?
    
    public var completionSaved : ((_ isCompletion : Bool) -> Void)!
    
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

extension UserManager : UserManagerProtocol {
    func savedUser(user: UserInfo) -> UserInfo {
        let userInfo = [
            "userId" : user.id,
            "userImage" : user.image,
            "userName" : user.name,
            "userPhone" : user.phone,
            "createdAt" : Date().toString(.type12, timeZone: "MM")
        ]
        
        self.ref.child("Users").child(user.id ?? "").setValue(userInfo)
        
        return user
    }
    
    func getUser(userId: String , completion: @escaping(_ userInfo : UserInfo?) -> Void) {
        self.ref.child("Users")
            .child(userId)
            .observeSingleEvent(of: .value) { snapshot in
                for childSnapshot in snapshot.children.allObjects as! [DataSnapshot] {
                    var user = UserInfo()
                    user.id = childSnapshot.childSnapshot(forPath:"userId").value as? String
                    user.name = childSnapshot.childSnapshot(forPath:"userName").value as? String
                    user.image = childSnapshot.childSnapshot(forPath:"userImage").value as? String
                    user.phone = childSnapshot.childSnapshot(forPath:"userPhone").value as? String
                    user.createdAt = childSnapshot.childSnapshot(forPath:"createdAt").value as? String
                    self.currentUser = user
                    completion(user)
                    
                }
            }
    }
    
    func getUserList(completion : @escaping(_ users : [UserInfo]) -> Void) {
        var userList = [UserInfo]()
        self.ref.child("Users")
            .observeSingleEvent(of: .value) { snapshot in
                for childSnapshot in snapshot.children.allObjects as! [DataSnapshot] {

                    var user = UserInfo()
                    user.id = childSnapshot.childSnapshot(forPath:"userId").value as? String
                    user.name = childSnapshot.childSnapshot(forPath:"userName").value as? String
                    user.image = childSnapshot.childSnapshot(forPath:"userImage").value as? String
                    user.phone = childSnapshot.childSnapshot(forPath:"userPhone").value as? String
                    user.createdAt = childSnapshot.childSnapshot(forPath:"createdAt").value as? String
                    userList.append(user)
                }
                self.userList  = userList
                completion(userList)
            }
    }
    
}
