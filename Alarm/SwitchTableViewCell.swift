//
//  AlarmCellTableViewCell.swift
//  Alarm
//
//  Created by tyson ericksen on 11/11/19.
//  Copyright © 2019 tyson ericksen. All rights reserved.
//

import UIKit

protocol SwitchTableViewCellDelegate: class {
    func switchCellSwitchValueHasChanged(for cell: SwitchTableViewCell)
}

class SwitchTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    
    var alarm: Alarming? {
        didSet {
            guard let alarm = alarm else { return }
            nameLabel.text = alarm.alarmName
            timeLabel.text = alarm.fireDateAsString
            alarmSwitch.isOn = alarm.alarmEnabled
        }
    }
    
    weak var cellDelegate: SwitchTableViewCellDelegate?
    
   
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        cellDelegate?.switchCellSwitchValueHasChanged(for: self)
    }
}
