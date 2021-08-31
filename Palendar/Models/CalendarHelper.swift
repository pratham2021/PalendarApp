//
//  CalendarHelper.swift
//  Palendar
//
//  Created by Pratham  Hebbar on 8/11/21.
//

import Foundation
import UIKit

class CalendarHelper {
    
    // Getting a calendar object reference
    let calendar = Calendar.current
    
    // Input: Jan 15 2021, Result: Feb 15 2021
    func plusMonth(date:Date) -> Date {
        return calendar.date(byAdding: .month, value: 1, to: date)!
    }
    
    // Input: Jan 15 2021, Result: Dec 15 2020
    func minusMonth(date:Date) -> Date {
        return calendar.date(byAdding: .month, value: -1, to: date)!
    }
    
    func plusDay(date:Date) -> Date {
        return calendar.date(byAdding: .day, value: 1, to: date)!
    }
    
    func minusDay(date:Date) -> Date {
        return calendar.date(byAdding: .day, value: -1, to: date)!
    }

    func plusWeek(date:Date) -> Date {
        return calendar.date(byAdding: .day, value: 7, to: date)!
    }
    
    // Input: Jan 15 2021, Result: January
    func monthString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        return dateFormatter.string(from: date)
    }
    
    // Input: Jan 15 2021, Result: 2021
    func yearString(date:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: date)
    }
    
    // Input: Jan 15 2021, Result: 31
    func daysInMonth(date:Date) -> Int {
        // Returning the number of days in the month by giving the date (given the date)
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }
    
    // Input: Jan 15 2021, Result: 15
    func dayOfMonth(date:Date) -> Int {
        // Getting the day of month given the date
        let components = calendar.dateComponents([.day], from: date)
        return components.day!
    }
    
    // Input: Jan 15 2021, Result: Jan 1 2021
    func firstOfMonth(date:Date) -> Date {
        // Getting the first day of the month
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components)!
    }
    
    // Input: Jan 1 2021, Result: 5 (Friday)
    func weekDay(date:Date) -> Int {
        // Getting the number of weekday
        let components = calendar.dateComponents([.weekday], from: date)
        return components.weekday! - 1
    }
}
