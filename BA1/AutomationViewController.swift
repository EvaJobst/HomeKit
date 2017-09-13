//
//  AutomationViewController.swift
//  BA1
//
//  Created by Eva Jobst on 19.04.17.
//  Copyright © 2017 Eva Jobst. All rights reserved.
//

import Foundation
import UIKit
import HomeKit

class AutomationViewController : UITableViewController {
    let controller = HomeController()
    let keys = KeyController()
    
    @IBOutlet weak var enableSwitch: UISwitch!
    @IBOutlet weak var powerStateCell: UITableViewCell!
    @IBOutlet weak var brightnessCell: UITableViewCell!
    @IBOutlet weak var nameCell: UITableViewCell!
    @IBOutlet weak var timeCell: UITableViewCell!
    
    override func viewWillAppear(_ animated: Bool) {
        reloadValues()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name(rawValue: keys.reload), object: nil)
    }
    
    @IBAction func switchValueChanged(_ sender: Any) {
        controller.enableAutomation(enabled: enableSwitch.isOn)
    }
    
    func reloadValues() {
        if(controller.hasAutomation()) {
            print("has Automation")
            let hour = Calendar.current.component(.hour, from: (HomeStore.sharedStore.trigger?.fireDate)!)
            let minutes = Calendar.current.component(.minute, from: (HomeStore.sharedStore.trigger?.fireDate)!)
            
            var minutesString : String = "\(minutes)"
            var hourString : String = "\(hour)"
            
            if(minutes < 10) {
                minutesString = "0\(minutesString)"
            }
            
            if(hour < 10) {
                hourString = "0\(hourString)"
            }
            
            nameCell.detailTextLabel?.text = HomeStore.sharedStore.trigger?.name
            timeCell.detailTextLabel?.text = "\(hourString):\(minutesString)"
            enableSwitch.isOn = (HomeStore.sharedStore.trigger?.isEnabled)!
            
            let writeActionPowerState = HomeStore.sharedStore.actionPowerState as! HMCharacteristicWriteAction<NSCopying>
            
            if(writeActionPowerState.targetValue as! Bool) {
                powerStateCell.detailTextLabel?.text = "On"
            }
                
            else {
                powerStateCell.detailTextLabel?.text = "Off"
            }
            
            let writeActionBrightness = HomeStore.sharedStore.actionBrightness as! HMCharacteristicWriteAction<NSCopying>
            brightnessCell.detailTextLabel?.text = "\(writeActionBrightness.targetValue) %"
        }
        
        tableView.reloadData()
    }
    
    @objc func reload(notification: NSNotification){
        reloadValues()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 0 && indexPath.row == 6) {
            print("Remove")
            controller.removeAutomation()
        }
    }
    
    func getHeightForRow(isVisible: Bool) -> CGFloat {
        if(isVisible) {
            return tableView.rowHeight
        }
            
        else {
            return 0.0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0) {
            switch indexPath.row {
            case 0: return getHeightForRow(isVisible: controller.hasAutomation()) // Name
            case 1: return getHeightForRow(isVisible: controller.hasAutomation()) // Time
            case 2: return getHeightForRow(isVisible: controller.hasAutomation()) // Brightness
            case 3: return getHeightForRow(isVisible: controller.hasAutomation()) // Power State
            case 4: return getHeightForRow(isVisible: controller.hasAutomation()) // Enable
            case 5: return getHeightForRow(isVisible: !controller.hasAutomation()) // Add
            case 6: return getHeightForRow(isVisible: controller.hasAutomation()) // Delete
            default: return 0.0
            }
        }
        
        return 0.0
    }
}
