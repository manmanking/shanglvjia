//
//  SwiftDateTests.swift
//  shanglvjia
//
//  Created by akrio on 2017/4/23.
//  Copyright © 2017年 TBI. All rights reserved.
//

import XCTest
import SwiftDate
@testable import shanglvjia

class SwiftDateTests: XCTestCase {
    
    /// 时间戳日期格式化
    func testUnix() {
        let a = 1487865600000 / 1000
        print(Date(timeIntervalSince1970: TimeInterval(a)))
        print("time -> \(unixFormat("1495179092000")!)")
        print(1487865600000)
        print(Int(Date().timeIntervalSince1970)*1000)
    }
    private func unixFormat (_ str: String) -> DateInRegion?{
        //尝试将字符串转成数字，格式化失败返回nil
        guard let time = Double(str) else {
            return nil
        }
        //13位说明是精确到毫秒的时间戳，那么将转化成10位的秒级别时间戳，如果都不是说明格式错误
        if str.characters.count == 13 {
            return DateInRegion(absoluteDate: Date(timeIntervalSince1970: time/1000.0))
        }else if str.characters.count == 10 {
            return DateInRegion(absoluteDate: Date(timeIntervalSince1970: time))
            
        }else {
            return nil
        }
    }
    func testAllformat() {
        let current = DateInRegion()
        let sss = current.string(custom: "sss")
        print(sss)
    }
    func testYYYYMMdd() {
        let current = DateInRegion()
        let sss = current.string(custom: "YYYYMMdd")
        print(sss)
    }
    /// 日期格式化
    func testFormat() {
        let regionRome = Region(tz: TimeZoneName.current, cal: CalendarName.current, loc: LocaleName.chinese)
        let date = DateInRegion(string: "2016-09-08", format: .custom("yyyy-MM-dd"), fromRegion: regionRome)!
        print("2016-07-06 13:43:26.0".date(format: .custom("yyyy-MM-dd HH:mm:ss.0"),fromRegion:regionRome))
        print(date.string(custom: "yyyy-MM-dd HH:mm:ss"))
        print("日期格式化 -> \(date.string(custom: "M月d日"))")
        print("日期格式化 -> \(date.string(custom: "EEE"))")
    }
    /// 计算时间间隔
    func testBetween() {
        let arriveDate = DateInRegion()
        let depDate = DateInRegion() + 4.day
        let days = (depDate.timeIntervalSinceReferenceDate - arriveDate.timeIntervalSinceReferenceDate).in(.day)
        print(days!+2)
        print(depDate.string(custom: "yyyy-MM-dd"))
    }
    func testPrice() {
        let a:Double = 1
        print("\(a)")
        print("\(a)".contains(".0"))
    }
}
