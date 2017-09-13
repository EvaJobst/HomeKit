//
//  ActionObject.swift
//  BA1
//
//  Created by Eva Jobst on 29.04.17.
//  Copyright © 2017 Eva Jobst. All rights reserved.
//

import Foundation
import HomeKit

class ActionObject : ObjectProtocol {
    func add(object: HMAction) {
        HomeStore.sharedStore.actionSet?.addAction(object, completionHandler: {error in
            if let error = error {
                print(error)
            }
                
            else {
                let controller = HomeController()
                
                if(HomeStore.sharedStore.actionSet?.actions.count == 1) {
                    controller.addAutomationTasks(counter: 2)
                }
                
                else {
                    controller.addAutomationTasks(counter: 3)
                }
            }
        })
    }
    
    func remove() {
        HomeStore.sharedStore.actionSet?.removeAction((HomeStore.sharedStore.actionSet?.actions.first!)!, completionHandler: {error in
            if let error = error {
                print(error)
            }
            
            else {
                let controller = HomeController()
                controller.removeAutomationTasks(counter: (HomeStore.sharedStore.actionSet?.actions.count)!)
            }
        })
    }
    
    func isNotNil() -> Bool {
        return HomeStore.sharedStore.actionPowerState != nil
    }
}
