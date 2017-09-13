//
//  AccessoryObject.swift
//  BA1
//
//  Created by Eva Jobst on 29.04.17.
//  Copyright © 2017 Eva Jobst. All rights reserved.
//

import Foundation
import HomeKit

class AccessoryObject : ObjectProtocol {
    let keys = KeyController()
    
    func add(object : HMAccessory) {
        let home = HomeStore.sharedStore.home
            
        home?.addAccessory(object) {error in
            if let error = error {
                print(error)
            }
            else {
                HomeStore.sharedStore.accessory = home?.accessories.first
                HomeStore.sharedStore.browser.stopSearchingForNewAccessories()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: self.keys.reload), object: nil)
            }
        }
    }
    
    func remove() {
        let home = HomeStore.sharedStore.home
        let accessory = home?.accessories.first
        
        if(HomeStore.sharedStore.trigger != nil) {
            print("Please remove Automation first!")
        }
        
        else {
            home?.removeAccessory((accessory!)) {error in
                if let error = error {
                    print(error)
                }
                    
                else {
                    HomeStore.sharedStore.accessory = nil
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: self.keys.reload), object: nil)
                }
            }
        }
    }
    

    func isNotNil() -> Bool {
        return HomeStore.sharedStore.accessory != nil
    }
}
