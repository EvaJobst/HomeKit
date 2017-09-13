//
//  HomeManager.swift
//  BA1
//
//  Created by Eva Jobst on 23.03.17.
//  Copyright © 2017 Eva Jobst. All rights reserved.
//

import Foundation
import HomeKit

class HomeController : HomeObject{
    private let homeObject = HomeObject()
    private let accessoryObject = AccessoryObject()
    private let actionSetObject = ActionSetObject()
    private let triggerObject = TriggerObject()
    private let actionObject = ActionObject()
    private let characteristicObject = CharacteristicObject()
    
    func addAutomationTasks(counter: Int){
        switch counter {
        case 0: addActionSet()
        case 1: addAction(action: HomeStore.sharedStore.actionPowerState!)
        case 2: addAction(action: HomeStore.sharedStore.actionBrightness!)
        case 3: addTrigger(trigger: HomeStore.sharedStore.trigger!)
        case 4: addActionSetToTrigger(actionSet: HomeStore.sharedStore.actionSet!)
        case 5: enableAutomation(enabled: true)
        default: print("Wrong counter encountered!")
        }
    }
    
    func removeAutomationTasks(counter: Int) {
        switch counter {
        case 4: removeActionSetFromTrigger(actionSet: HomeStore.sharedStore.actionSet!)
        case 3: removeTrigger()
        case 2: removeAction()
        case 1: removeAction()
        case 0: removeActionSet()
        default: print("Wrong counter encountered!")
        }
    }
    
    func addHome(name: String) {
        homeObject.add(object: name)
    }
    
    func removeHome() {
        homeObject.remove()
    }
    
    func hasHome() -> Bool {
        return homeObject.isNotNil()
    }
    
    func addAccessory(accessory: HMAccessory) {
        accessoryObject.add(object: accessory)
    }
    
    func removeAccessory() {
        accessoryObject.remove()
    }
    
    func hasAccessory() -> Bool {
        return accessoryObject.isNotNil()
    }
    
    func addActionSet() {
        actionSetObject.add(object: "actionSetObject")
    }
    
    func removeActionSet() {
        actionSetObject.remove()
    }
    
    func hasActionSet() -> Bool {
        return actionSetObject.isNotNil()
    }
    
    func addTrigger(trigger: HMTimerTrigger) {
        triggerObject.add(object: trigger)
    }
    
    func removeTrigger() {
        triggerObject.remove()
    }
    
    func hasTrigger() -> Bool {
        return triggerObject.isNotNil()
    }
    
    func addAction(action: HMAction) {
        actionObject.add(object: action)
    }
    
    func removeAction() {
        actionObject.remove()
    }
    
    func hasAction() -> Bool {
        return actionObject.isNotNil()
    }
    
    func addActionSetToTrigger(actionSet: HMActionSet) {
        triggerObject.add(other: actionSet)
    }
    
    func removeActionSetFromTrigger(actionSet: HMActionSet) {
        triggerObject.remove(other: actionSet)
    }
    
    func addAutomation(name: String, timeString: String, powerState: Bool, brightness: Int) {
        let dateController = DateController()
        
        let newActionPowerState = HMCharacteristicWriteAction(characteristic: getCharacteristic(type: HMCharacteristicTypePowerState), targetValue: powerState as NSCopying)
        
        let newActionBrightness = HMCharacteristicWriteAction(characteristic: getCharacteristic(type: HMCharacteristicTypeBrightness), targetValue: brightness as NSCopying)
        
        let newTrigger = HMTimerTrigger(name: name, fireDate: dateController.getFireDate(timeString: timeString), timeZone: TimeZone.current, recurrence: dateController.getRecurrence(), recurrenceCalendar: Calendar.current)
        
        HomeStore.sharedStore.actionPowerState = newActionPowerState
        HomeStore.sharedStore.actionBrightness = newActionBrightness
        HomeStore.sharedStore.trigger = newTrigger
        addActionSet()
    }
    
    func removeAutomation() {
        removeActionSetFromTrigger(actionSet: HomeStore.sharedStore.actionSet!)
    }
    
    func hasAutomation() -> Bool {
        return hasTrigger() && hasActionSet() && hasAction()
    }
    
    func enableAutomation(enabled: Bool) {
        return triggerObject.enable(enabled: enabled)
    }

    func getCharacteristic(type: String) -> HMCharacteristic {
        return characteristicObject.get(type: type)
    }
    
    func readCharacteristics() {
        if(hasAccessory()) {
            readCharacteristic(type: "HMAccessoryName")
            readCharacteristic(type: HMCharacteristicTypeBrightness)
            readCharacteristic(type: HMCharacteristicTypePowerState)
            readCharacteristic(type: HMCharacteristicTypeModel)
            readCharacteristic(type: HMCharacteristicTypeManufacturer)
        }
    }
    
    func readCharacteristic(type : String) {
        characteristicObject.read(type: type)
    }

    func writeCharacteristic(value: Any?, type: String) {
        characteristicObject.write(value: value, type: type)
    }
    
    func assignStoreValues() {
        if(hasHome()) {
            if((HomeStore.sharedStore.home?.accessories.count)! > 0) {
                HomeStore.sharedStore.accessory = HomeStore.sharedStore.home?.accessories.last
                
                
                if((HomeStore.sharedStore.home?.triggers.count)! > 0) {
                    HomeStore.sharedStore.trigger = HomeStore.sharedStore.home?.triggers.last as! HMTimerTrigger?
                    
                    HomeStore.sharedStore.actionSet = HomeStore.sharedStore.trigger?.actionSets.first
                    
                    for action in (HomeStore.sharedStore.actionSet?.actions)! {
                        
                        let val = action as! HMCharacteristicWriteAction<NSCopying>
                        
                        if(val.characteristic == getCharacteristic(type: HMCharacteristicTypePowerState)) {
                            HomeStore.sharedStore.actionPowerState = action
                        }
                        
                        else {
                            HomeStore.sharedStore.actionBrightness = action
                        }
                    }
                }
            }
        }
    }
}
