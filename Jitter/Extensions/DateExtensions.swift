//
//  Extensions.swift
//  Jitter
//
//  Created by Gonzalo Maldonado Martinez on 10/1/17.
//  Copyright © 2017 WanderTap. All rights reserved.
//

import Foundation

extension Date {
    func timeAgo() -> String {

        let interval = NSCalendar.current.dateComponents([.day], from: self, to: Date()).day!
        if interval > 0 {
            return "\(interval) d"
        }
        let hourInterval = NSCalendar.current.dateComponents([.hour], from: self, to: Date()).hour!
        if hourInterval > 0 {
            return "\(hourInterval) h"
        }

        let minuteInterval = NSCalendar.current.dateComponents([.minute], from: self, to: Date()).minute!
        if minuteInterval > 0 {
            return "\(minuteInterval) m"
        }

        let secondsInterval = NSCalendar.current.dateComponents([.second], from: self, to: Date()).second!
        if secondsInterval > 0 {
            return "\(secondsInterval) s"
        }

        return "0 s"
    }
}
