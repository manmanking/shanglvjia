//
//  Date+TBIExtension.swift
//  shanglvjia
//
//  Created by manman on 2018/8/31.
//  Copyright © 2018年 TBI. All rights reserved.
//

import Foundation

extension Date{
    
    func dateToStringGMTTimezone(format:String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone?
        formatter.dateFormat = format//"yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: self)
    }
    
    
    
    
}
