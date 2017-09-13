//
//  ViewController.swift
//  BA1
//
//  Created by Eva Jobst on 22.03.17.
//  Copyright © 2017 Eva Jobst. All rights reserved.
//

import UIKit
import HomeKit

class DetailsViewController: UITableViewController {
    let controller = HomeController()
    let keys = KeyController()

    @IBOutlet weak var modelCell: UITableViewCell!
    @IBOutlet weak var networkCell: UITableViewCell!
    @IBOutlet weak var manufacturerCell: UITableViewCell!
    @IBOutlet weak var nameCell: UITableViewCell!
    @IBOutlet weak var stateCell: UITableViewCell!
    @IBOutlet weak var brightnessCell: UITableViewCell!
    
    override func viewWillAppear(_ animated: Bool) {
        //HomeStore.sharedStore.accessory?.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(setValues), name: NSNotification.Name(rawValue: keys.read), object: nil)
        
        controller.readCharacteristics()
        setReachability()
    }
    
    func setReachability() {
        if(HomeStore.sharedStore.accessory?.isReachable)! {
            networkCell.detailTextLabel?.text = "Yes"
        }
        
        else {
            networkCell.detailTextLabel?.text = "No"
        }
    }
    
    @objc func setValues(notification: NSNotification){
        let value = notification.userInfo?["value"]
        let type = notification.userInfo?["type"] as! String
        
        switch type {
        case "HMAccessoryName":
            nameCell.detailTextLabel?.text = value as? String
        case HMCharacteristicTypeBrightness:
            let brightness = value as! Int
            brightnessCell.detailTextLabel?.text = "\(brightness) %"
            
        case HMCharacteristicTypePowerState:
            let state = value as! Bool
            if(state) {
                stateCell.detailTextLabel?.text = "On"
            }
            else {
                stateCell.detailTextLabel?.text = "Off"
            }
        case HMCharacteristicTypeManufacturer:
            manufacturerCell.detailTextLabel?.text = value as? String
            
        case HMCharacteristicTypeModel:
            modelCell.detailTextLabel?.text = value as? String
            
        default:
            print("Error: Unknown Characteristic Type")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

