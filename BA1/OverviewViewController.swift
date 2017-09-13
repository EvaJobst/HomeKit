//
//  ActionViewController.swift
//  BA1
//
//  Created by Eva Jobst on 23.03.17.
//  Copyright © 2017 Eva Jobst. All rights reserved.
//

import Foundation
import UIKit
import HomeKit

class OverviewViewController : UITableViewController, HMHomeManagerDelegate, HMAccessoryDelegate {
    let keys = KeyController()
    let controller : HomeController = HomeController()
    @IBOutlet weak var accessoryName: UITableViewCell!
    @IBOutlet weak var homeName: UITableViewCell!
    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var stateSwitch: UISwitch!
    
    override func viewWillAppear(_ animated: Bool) {
        HomeStore.sharedStore.manager.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(setValues), name: NSNotification.Name(rawValue: keys.read), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name(rawValue: keys.reload), object: nil)
    }

    @IBAction func changeSwitchValue(_ sender: Any) {
        controller.writeCharacteristic(value: stateSwitch.isOn, type: HMCharacteristicTypePowerState)
    }
    
    @objc func reload(notification: NSNotification){
        if(controller.hasHome()) {
            homeName.detailTextLabel?.text = HomeStore.sharedStore.home?.name
        }
        tableView.reloadData()
    }
    
    @objc func setValues(notification: NSNotification){
        let value = notification.userInfo?["value"]
        let type = notification.userInfo?["type"] as! String

        switch type {
        case "HMAccessoryName":
            accessoryName.detailTextLabel?.text = value as? String
        case HMCharacteristicTypeBrightness:
            brightnessSlider.value = value as! Float
        case HMCharacteristicTypePowerState:
            stateSwitch.isOn = value as! Bool
        default:
            print(type)
        }
        
        tableView.reloadData()
    }
    
    @IBAction func changeSliderValue(_ sender: UISlider) {
        controller.writeCharacteristic(value: brightnessSlider.value.rounded(), type: HMCharacteristicTypeBrightness)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 1 && indexPath.row == 6) {
            controller.removeAccessory()
        }
        
        if(indexPath.section == 0 && indexPath.row == 2) {
            controller.removeHome()
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0) {
            return "Home"
        }
        
        else {
            if(controller.hasHome()) {
                return "Accessory"
            }
            
            else {
                return nil
            }
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
            case 0: return getHeightForRow(isVisible: controller.hasHome()) // Name
            case 1: return getHeightForRow(isVisible: !controller.hasHome()) // Add
            case 2: return getHeightForRow(isVisible: controller.hasHome()) // Delete
            default: return 0.0
            }
        }
        
        else {
            switch indexPath.row {
            case 0, 2, 3, 4, 5, 6, 7: return getHeightForRow(isVisible: controller.hasAccessory())
            case 1: return getHeightForRow(isVisible: (controller.hasHome() && !controller.hasAccessory())) // Add
            default: return 0.0
            }
        }
    }
    
    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        HomeStore.sharedStore.home = HomeStore.sharedStore.manager.primaryHome

        controller.assignStoreValues()
        
        if(controller.hasHome()) {
            homeName.detailTextLabel?.text = HomeStore.sharedStore.home?.name
            
            if(controller.hasAccessory()) {
                HomeStore.sharedStore.accessory?.delegate = self
                controller.readCharacteristics()
            }
        }
        
        tableView.reloadData()
    }
}
