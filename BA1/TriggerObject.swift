//
//  TriggerObject.swift
//  BA1
//
//  Created by Eva Jobst on 29.04.17.
//  Copyright © 2017 Eva Jobst. All rights reserved.
//

import Foundation
import HomeKit

class TriggerObject : ObjectProtocol {
    func add(object: HMTimerTrigger) {
        HomeStore.sharedStore.home?.addTrigger(object, completionHandler: {error in
            if let error = error {
                print(error)
            }
                
            else {
                let controller = HomeController()
                controller.addAutomationTasks(counter: 4)
            }
        })
    }
    
    func add(other: HMActionSet) {
        HomeStore.sharedStore.trigger?.addActionSet(other, completionHandler: {error in
            if let error = error {
                print(error)
            }
            
            else {
                let controller = HomeController()
                controller.addAutomationTasks(counter: 5)
            }
        })
    }
    
    func remove() {
        HomeStore.sharedStore.home?.removeTrigger(HomeStore.sharedStore.trigger!, completionHandler: {error in
            if let error = error {
                print(error)
            }
            
            else {
                HomeStore.sharedStore.trigger = nil
                let controller = HomeController()
                controller.removeAutomationTasks(counter: 2)
            }
        })
    }
    
    func remove(other: HMActionSet) {
        HomeStore.sharedStore.trigger?.removeActionSet(other, completionHandler: {error in
            if let error = error {
                print(error)
            }
            
            else {
                let controller = HomeController()
                controller.removeAutomationTasks(counter: 3)
            }
        })
    }
    
    func isNotNil() -> Bool {
        return HomeStore.sharedStore.trigger != nil
    }
    
    func enable(enabled : Bool) {
        HomeStore.sharedStore.trigger?.enable(enabled, completionHandler: {error in
            if let error = error {
                print(error)
            }
                
            else {
                let keys = KeyController()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: keys.reload), object: nil)
            }
        })
    }
}
