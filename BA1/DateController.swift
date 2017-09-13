//
//  DateController.swift
//  BA1
//
//  Created by Eva Jobst on 30.04.17.
//  Copyright © 2017 Eva Jobst. All rights reserved.
//

import Foundation

class DateController {
    func getRecurrence() -> DateComponents {
        var recurrence = DateComponents()
        recurrence.day = 1
        return recurrence
    }
    
    func getFireDate(timeString: String) -> Date {
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let toTime = timeFormatter.date(from: timeString)
        let fromTime = timeFormatter.date(from: timeFormatter.string(from: date))
        let interval = toTime?.timeIntervalSince(fromTime!)
        
        var fireDate: Date {
            let flags : NSCalendar.Unit = [.year, .weekday, .month, .day, .hour, .minute]
            let dateComponents = (Calendar.current as NSCalendar).components(flags, from: date)
            var probableDate = Calendar.current.date(from: dateComponents)
            probableDate?.addTimeInterval(TimeInterval(interval!))
            return probableDate!
        }
        
        return fireDate
    }
}
