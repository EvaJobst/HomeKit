//
//  HomeObject.swift
//  BA1
//
//  Created by Eva Jobst on 29.04.17.
//  Copyright © 2017 Eva Jobst. All rights reserved.
//

import Foundation
import HomeKit

class HomeObject : ObjectProtocol {
    let keys = KeyController()
    
    func add(object : String) {
        let manager = HomeStore.sharedStore.manager
        
        manager.addHome(withName: object, completionHandler: {newHome, error in
            if let error = error {
                print(error)
            }
                
            else {
                manager.updatePrimaryHome(newHome!, completionHandler: {error in
                    if let error = error {
                        print(error)
                    }
                        
                    else {
                        HomeStore.sharedStore.home = newHome!
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: self.keys.reload), object: nil)
                    }
                })
            }
        })
    }
    
    func remove() {
        let manager = HomeStore.sharedStore.manager
        let controller = HomeController()
        
        if(controller.hasAccessory() && controller.hasAutomation()) {
            print("Please remove Automation and Accessory first!")
        }
        
        else if(controller.hasAccessory()) {
            print("Please remove Accessory first!")
        }
        
        else {
            manager.removeHome(HomeStore.sharedStore.home!, completionHandler: {error in
                if let error = error {
                    print(error)
                }
                    
                else {
                    HomeStore.sharedStore.home = nil
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: self.keys.reload), object: nil)
                }
            })
        }
    }
    
    func isNotNil() -> Bool {
        return HomeStore.sharedStore.home != nil
    }
}
