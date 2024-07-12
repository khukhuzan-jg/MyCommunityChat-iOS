//
//  DataBaseManager.swift
//  MyCommunityChat-iOS
//
//  Created by Phyo Kyaw Swar on 12/07/2024.
//

import Foundation
import RealmSwift

protocol DataBaseManagerProtocol {
    func saveNotiSettingById(_ notiRealmObj : NotiDBRealmObject, completion : @escaping (_ isSuccess : Bool) -> Void)
    func getNotiSettingById(_ conversationID : String , completion : @escaping(_ notiDbObj : NotiDBRealmObject?) -> Void)
    func deleteNotiSettingById(_ conversationID : String , completion : @escaping (_ isSuccess : Bool) -> Void)
    func getAllNotiSetting( completion : @escaping(_ notiRealmObjs : [NotiDBRealmObject]?) -> Void)
}

class DataBaseManager {
    static let shared = DataBaseManager()
    
    var realm : Realm?
    
    init() {
        configuration()
    }
    
    private func configuration() {
        print("Realm Path :::: \(String(describing: Realm.Configuration.defaultConfiguration.fileURL))")
        Realm.Configuration.defaultConfiguration.schemaVersion = 1
        Realm.Configuration.defaultConfiguration.migrationBlock = { migration , oldVersion in
            
        }
    }
}

extension DataBaseManager : DataBaseManagerProtocol {
    func saveNotiSettingById(_ notiRealmObj : NotiDBRealmObject, completion: @escaping (Bool) -> Void) {
        realm = try! Realm()
        try! realm?.write({
            if let obj = realm?.objects(NotiDBRealmObject.self).first(where: {($0.conversationId ?? "") == (notiRealmObj.conversationId ?? "")}) {
                realm?.add(notiRealmObj, update: .modified)
            }
            else {
                
                realm?.add(notiRealmObj)
            }
            
            completion(true)
        })
    }
    
    func getNotiSettingById(_ conversationID: String, completion: @escaping (NotiDBRealmObject?) -> Void) {
        realm = try! Realm()
        try! realm?.write({
            if let obj = realm?.objects(NotiDBRealmObject.self).first(where: {($0.conversationId ?? "") == conversationID}) {
                completion(obj)
            }
            else {
                completion(nil)
            }
            
        })
    }
    
    func deleteNotiSettingById(_ conversationID: String, completion: @escaping (Bool) -> Void) {
        realm = try! Realm()
        try! realm?.write({
            if let obj = realm?.objects(NotiDBRealmObject.self).first(where: {($0.conversationId ?? "") == conversationID}) {
                realm?.delete(obj)
                completion(true)
            }
            else {
                completion(false)
            }
        })
    }
    
    func getAllNotiSetting(completion: @escaping ([NotiDBRealmObject]?) -> Void) {
        realm = try! Realm()
        try! realm?.write({
            if let objs = realm?.objects(NotiDBRealmObject.self) {
                var objects = [NotiDBRealmObject]()
                objs.forEach {
                    objects.append($0)
                }
                completion(objects)
            }
            else {
                completion(nil)
            }
        })
    }
    
    
}
