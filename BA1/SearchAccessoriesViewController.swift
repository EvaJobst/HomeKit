//
//  SearchAccessoriesViewController.swift
//  BA1
//
//  Created by Eva Jobst on 23.03.17.
//  Copyright © 2017 Eva Jobst. All rights reserved.
//

import Foundation
import UIKit
import HomeKit
import ExternalAccessory

class SearchAccessoriesViewController : UITableViewController, HMAccessoryBrowserDelegate {
    let controller : HomeController = HomeController()
    let browser : HMAccessoryBrowser = HomeStore.sharedStore.browser
    let keys = KeyController()
    var items : [HMAccessory] = []
    
    override func viewDidLoad() {
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "searchAccessoriesCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name(rawValue: keys.reload), object: nil)

        browser.delegate = self
        browser.startSearchingForNewAccessories()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(browser.delegate != nil) {
            items = []
            items.append(contentsOf: browser.discoveredAccessories)
            tableView.reloadData()
        }
    }
    
    @objc func reload(notification: NSNotification){
        tableView.reloadData()
    }
    
    func accessoryBrowser(_ browser: HMAccessoryBrowser, didFindNewAccessory accessory: HMAccessory) {
        
        if(!items.contains(accessory)) {
            items.append(accessory)
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Found Accessories"
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        if(HomeStore.sharedStore.accessory == nil) {
            return "Selected Accessory: None"
        }
        
        else {
            return "Selected Accessory: \((HomeStore.sharedStore.accessory?.name)!)"
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item : UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "searchAccessoriesCell")! as UITableViewCell
        item.textLabel?.text = self.items[indexPath.row].name
        return item
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        controller.addAccessory(accessory: items[indexPath.row])
    }
}
