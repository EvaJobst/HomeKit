//
//  ObjectInterface.swift
//  BA1
//
//  Created by Eva Jobst on 29.04.17.
//  Copyright © 2017 Eva Jobst. All rights reserved.
//

import Foundation
import HomeKit

protocol ObjectProtocol {
    associatedtype T
    
    func add(object: T)
    func remove()
    func isNotNil() -> Bool
}
