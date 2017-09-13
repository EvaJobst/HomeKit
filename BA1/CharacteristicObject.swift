//
//  CharacteristicObject.swift
//  BA1
//
//  Created by Eva Jobst on 30.04.17.
//  Copyright © 2017 Eva Jobst. All rights reserved.
//

import Foundation
import HomeKit

class CharacteristicObject {
    let keys = KeyController()
    
    func get(type: String) -> HMCharacteristic {
        for service in (HomeStore.sharedStore.accessory?.services)! {
            for characteristic in service.characteristics {
                if(characteristic.characteristicType == type) {
                    return characteristic
                }
            }
        }
        
        return HMCharacteristic.init()
    }
    
    func write(value: Any?, type: String) {
        get(type: type).writeValue(value.self, completionHandler: { error in
            if let error = error {
                print(error)
            }
        })
    }
    
    func read(type : String) {
        if(type == "HMAccessoryName") {
            var values = [AnyHashable : Any?]()
            values["type"] = type
            values["value"] = HomeStore.sharedStore.accessory?.name
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: self.keys.read), object: nil, userInfo: values)
        }
            
        else {
            let characteristic = get(type: type)
            
            characteristic.readValue(completionHandler: { error in
                if let error = error {
                    print(error)
                }
                    
                else {
                    var values = [AnyHashable : Any?]()
                    values["type"] = type
                    values["value"] = characteristic.value
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: self.keys.read), object: nil, userInfo: values)
                }
            })
        }
    }
}
