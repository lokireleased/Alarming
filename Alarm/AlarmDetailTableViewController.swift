//
//  AlarmDetailTableViewController.swift
//  Alarm
//
//  Created by tyson ericksen on 11/11/19.
//  Copyright © 2019 tyson ericksen. All rights reserved.
//

import UIKit
import UserNotifications

class AlarmDetailTableViewController: UITableViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var button: UIButton!
    
    
    
    var alarm: Alarming? {
        didSet {
            if isViewLoaded {
                updateView()
            } else {
                loadView()
                updateView()
            }
        }
    }
    
    var isEnabled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
       updateView()
    }
  
    
    @IBAction func enabledButtonTapped(_ sender: UIButton) {
        isEnabled.toggle()
    }
    
    @IBAction func savedButtonTapped(_ sender: UIBarButtonItem) {
        guard let title = textField.text else { return }
        let date = datePicker.date
        if let alarm = alarm {
            AlarmingController.sharedInstance.updateAlarms(alarm: alarm, alarmName: title, fireDate: date, alarmEnabled: isEnabled)
            cancelUserNotification(for: alarm)
            scheduleUserNotification(for: alarm)
        } else {
            let alarm = AlarmingController.sharedInstance.addAlarms(alarmName: title, fireDate: date, alarmEnabled: isEnabled)
//            scheduleUserNotification(for: alarm)
        }
        navigationController?.popViewController(animated: true)
        
    }

    func updateView() {
        guard let alarm = alarm else { return }
        
        textField.text = alarm.alarmName
        datePicker.setDate(alarm.fireDate, animated: false)
    
        button.isHidden = false
        if alarm.alarmEnabled {
            button.setTitle("Disable", for: UIControl.State())
            button.setTitleColor(.white, for: UIControl.State())
            button.backgroundColor = .red
        } else {
            button.setTitle("Enable", for: UIControl.State())
            button.setTitleColor(.blue, for: UIControl.State())
            button.backgroundColor = .gray
        }
    }
}

extension AlarmDetailTableViewController: AlarmSchedulerDelegate {

    
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
