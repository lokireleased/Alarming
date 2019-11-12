//
//  AlarmListTableViewController.swift
//  Alarm
//
//  Created by tyson ericksen on 11/11/19.
//  Copyright © 2019 tyson ericksen. All rights reserved.
//

import UIKit
import UserNotifications

class AlarmListTableViewController: UITableViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AlarmingController.sharedInstance.alarmsArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath) as? SwitchTableViewCell else { return UITableViewCell() }

        cell.alarm = AlarmingController.sharedInstance.alarmsArray[indexPath.row]
        cell.cellDelegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
           let alarm = AlarmingController.sharedInstance.alarmsArray[indexPath.row]
            AlarmingController.sharedInstance.deleteAlarms(alarm: alarm)
            cancelUserNotification(for: alarm)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailView" {
            if let indexPath = tableView.indexPathForSelectedRow {
                if let destinationVC = segue.destination as? AlarmDetailTableViewController {
                    let alarm = AlarmingController.sharedInstance.alarmsArray[indexPath.row]
                    destinationVC.alarm = alarm
                }
            }
        }
    }
}

extension AlarmListTableViewController: SwitchTableViewCellDelegate {
    func switchCellSwitchValueHasChanged(for cell: SwitchTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let alarm = AlarmingController.sharedInstance.alarmsArray[indexPath.row]
        AlarmingController.sharedInstance.toggleIsOn(for: alarm)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}


extension AlarmListTableViewController: AlarmSchedulerDelegate {
  
    
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
