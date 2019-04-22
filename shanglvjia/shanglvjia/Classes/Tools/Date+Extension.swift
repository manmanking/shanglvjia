//
//  Date+Extension.swift
//  shop
//
//  Created by akrio on 2017/5/19.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import SwiftDate
extension Date {
    var unix:Int64 {
        return Int64(self.timeIntervalSince1970) * 1000
    }
}
