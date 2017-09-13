//
//  ActionSetObject.swift
//  BA1
//
//  Created by Eva Jobst on 29.04.17.
//  Copyright © 2017 Eva Jobst. All rights reserved.
//

import Foundation
import HomeKit

class ActionSetObject : ObjectProtocol {
    func add(object: String) {
        HomeStore.sharedStore.home?.addActionSet(withName: object, completionHandler: {value, error in
            if let error = error {
                print(error)
            }
                
            else {
                HomeStore.sharedStore.actionSet = value
                let controller = HomeController()
                controller.addAutomationTasks(counter: 1)
            }
        })
    }
    
    func remove() {
        HomeStore.sharedStore.home?.removeActionSet(HomeStore.sharedStore.actionSet!, completionHandler: {error in
            if let error = error {
                print(error)
            }
            
            else {
                HomeStore.sharedStore.actionSet = nil
                let keys = KeyController()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: keys.reload), object: nil)
            }
        })
    }
    
    func isNotNil() -> Bool {
        return HomeStore.sharedStore.actionSet != nil
    }
}
