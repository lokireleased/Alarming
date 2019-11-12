//
//  AlarmingController.swift
//  Alarm
//
//  Created by tyson ericksen on 11/12/19.
//  Copyright © 2019 tyson ericksen. All rights reserved.
//

import Foundation
import UserNotifications

protocol AlarmSchedulerDelegate: class {
    func scheduleUserNotification(for alarm: Alarming)
    func cancelUserNotification(for alarm: Alarming)
}


class AlarmingController {
    
    static let sharedInstance = AlarmingController()
    
    var alarmsArray: [Alarming] = []
    
    weak var delegate: AlarmSchedulerDelegate?
    
    init() {
        loadInformationFromStorage()
    }
    
    
    func addAlarms(alarmName: String, fireDate: Date, alarmEnabled: Bool) {
        let newAlarm = Alarming(alarmName: alarmName, alarmEnabled: alarmEnabled, fireDate: fireDate)
        alarmsArray.append(newAlarm)
        saveInformationToStorage()
    }
    
    func deleteAlarms(alarm: Alarming) {
        guard let indexPath = alarmsArray.firstIndex(of: alarm) else { return }
        alarmsArray.remove(at: indexPath)
        saveInformationToStorage()
    }
    
    func updateAlarms(alarm: Alarming, alarmName: String, fireDate: Date, alarmEnabled: Bool) {
        alarm.alarmName = alarmName
        alarm.alarmEnabled = alarmEnabled
        alarm.fireDate = fireDate
        saveInformationToStorage()
    }
    
    func toggleIsOn(for alarm: Alarming) {
        alarm.alarmEnabled = !alarm.alarmEnabled
        saveInformationToStorage()
    }
    
    func findURL() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileUrl = urls[0].appendingPathComponent("Alarming.json")
        return fileUrl
    }
    
    func saveInformationToStorage() {
        
        let jsEncoder = JSONEncoder()
        
        do {
           let data = try jsEncoder.encode(alarmsArray)
            try data.write(to: findURL())
        } catch {
            print("Error in saving information: \(error)")
        }
    }
    
    func loadInformationFromStorage() {
        
        let jsDecoder = JSONDecoder()
        
        do {
            let data = try Data(contentsOf: findURL())
            let alarm = try jsDecoder.decode([Alarming].self, from: data)
            self.alarmsArray = alarm
        } catch {
            print("Error in retrieving information: \(error)")
        }
    }
}

extension AlarmSchedulerDelegate {
    func scheduleUserNotification(for alarm: Alarming) {
        
        let contents = UNMutableNotificationContent()
        contents.title = "Alarm"
        contents.body = "Here's your alarm"
        contents.badge = 1
        contents.sound = .default
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: alarm.fireDate)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(identifier: "Alarming", content: contents, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (_) in
            print("user asked to get a local notification")
        }
    }
    
    func cancelUserNotification(for alarm: Alarming) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.UUIDKey])
    }
}
