//
//  HomeViewController.swift
//  BA1
//
//  Created by Eva Jobst on 13.04.17.
//  Copyright © 2017 Eva Jobst. All rights reserved.
//

import Foundation
import UIKit

class NewHomeViewController : UITableViewController {
    let keys = KeyController()
    let controller = HomeController()
    @IBOutlet weak var homeName: UITextField!
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name(rawValue: keys.reload), object: nil)
    }
    
    @objc func reload(notification: NSNotification){
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 1 && indexPath.row == 0) {
            if(!(homeName.text?.isEmpty)!) {
                controller.addHome(name: homeName.text!)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        if(section == 1 && !controller.hasHome()) {
            return "New Home: Undefined"
        }
            
        else if(section == 1 && controller.hasHome()) {
            return "New Home: \((HomeStore.sharedStore.home?.name)!)"
        }
        
        return ""
    }
}
