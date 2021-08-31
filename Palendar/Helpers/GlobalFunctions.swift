//  GlobalFunctions.swift
//  Palendar
//  Created by Pratham  Hebbar on 8/15/2021.

import Foundation

class GlobalFunctions {
    
    func fileNameFrom(fileUrl:String) -> String {
        return (fileUrl.components(separatedBy: "_").last)!.components(separatedBy: "?").first!.components(separatedBy: ".").first!
    }
    
    func timeElapsed(_ date:Date) -> String {
        let seconds = Date().timeIntervalSince(date)
        var elapsed = ""
        // Less than a minute ago
        if seconds < 60 {
            elapsed = "Just now"
        }
        else if seconds < 60 * 60 {
            let minutes = Int(seconds/60)
            let minText = minutes > 1 ? "mins":"min"
            elapsed = "\(minutes) \(minText)"
        }
        else if seconds < 24 * 60 * 60 {
            let hours = Int(seconds/(60 * 60))
            let hourText = hours > 1 ? "hours":"hour"
            elapsed = "\(hours) \(hourText)"
        }
        else {
            elapsed = date.longDate()
        }
        
        return elapsed
    }
}
