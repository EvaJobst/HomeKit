//
//  HomeStore.swift
//  BA1
//
//  Created by Eva Jobst on 24.04.17.
//  Copyright © 2017 Eva Jobst. All rights reserved.
//

import Foundation
import HomeKit

/// A static, singleton class which holds a home manager and the current home.
class HomeStore: NSObject {
    static let sharedStore = HomeStore()
    
    // MARK: Properties
    let manager = HMHomeManager()
    let browser = HMAccessoryBrowser()
    var home : HMHome? = nil
    var accessory : HMAccessory? = nil
    var trigger : HMTimerTrigger? = nil
    var actionSet : HMActionSet? = nil
    var actionPowerState : HMAction? = nil
    var actionBrightness : HMAction? = nil
}
