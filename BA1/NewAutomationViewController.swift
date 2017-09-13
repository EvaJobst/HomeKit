//
//  NewAutomationViewController.swift
//  BA1
//
//  Created by Eva Jobst on 19.04.17.
//  Copyright © 2017 Eva Jobst. All rights reserved.
//

import Foundation
import UIKit

class NewAutomationViewController : UITableViewController {
    let keys = KeyController()
    let controller = HomeController()
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var brightness: UISlider!
    @IBOutlet weak var powerState: UISwitch!
    @IBOutlet weak var time: UITextField!
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name(rawValue: keys.reload), object: nil)
    }
    
    @objc func reload(notification: NSNotification){
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 2 && indexPath.row == 0) {
            let brightnessInt : Int = Int(brightness.value)
            controller.addAutomation(name: name.text!, timeString: time.text!, powerState: powerState.isOn, brightness: brightnessInt)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        if(section == 2 && !controller.hasAutomation()) {
            return "New Automation: Undefined"
        }
            
        else if(section == 2 && controller.hasAutomation()) {
            return "New Automation: \((HomeStore.sharedStore.trigger?.name)!)"
        }
        
        return ""
    }
}
