//
//  NotiDBRealmObject.swift
//  MyCommunityChat-iOS
//
//  Created by Phyo Kyaw Swar on 12/07/2024.
//

import Foundation
import RealmSwift

class NotiDBRealmObject: Object {
    /*
     var id : Int?
     var conversationId : String?
     var startTime : String?
     var endTime : String?
     var settingType : String?
     */
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var conversationId : String?
    @Persisted var startTime : String?
    @Persisted var endTime : String?
    @Persisted var settingType : String?
}
