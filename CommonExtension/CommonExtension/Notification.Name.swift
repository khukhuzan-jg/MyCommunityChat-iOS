//
//  Notification.Name.swift
//  CommonExtension
//
//  Created by Aung Bo Bo on 16/05/2023.
//

import Foundation

extension Notification.Name {
    public static var goToTimetable: Notification.Name {
        return .init(rawValue: "goToTimetable")
    }
    public static var refetchAppearedSchedules: Notification.Name {
        return .init("refetchAppearedSchedules")
    }
    public static var fetchNewInboxData: Notification.Name {
        return .init("fetchNewInboxData")
    }
}
