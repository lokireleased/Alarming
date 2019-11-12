//
//  Alarming.swift
//  Alarm
//
//  Created by tyson ericksen on 11/12/19.
//  Copyright © 2019 tyson ericksen. All rights reserved.
//

import Foundation

class Alarming: Codable {
    
    var alarmName: String
    var alarmEnabled: Bool
    var UUIDKey: String
    var fireDate: Date
    
    var fireDateAsString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: fireDate)
    }
    
    init(alarmName: String, alarmEnabled: Bool = false, UUIDKey: String = UUID().uuidString, fireDate: Date = Date()) {
        self.alarmName = alarmName
        self.alarmEnabled = alarmEnabled
        self.UUIDKey = UUIDKey
        self.fireDate = fireDate
    }
    
}


extension Alarming: Equatable {
    static func == (lhs: Alarming, rhs: Alarming) -> Bool {
       if lhs.alarmName == rhs.alarmName { return true }
        if lhs.alarmEnabled == rhs.alarmEnabled { return true }
        if lhs.fireDate == rhs.fireDate { return true }
        if lhs.UUIDKey == rhs.UUIDKey { return true }
        
        return false
    }
}
