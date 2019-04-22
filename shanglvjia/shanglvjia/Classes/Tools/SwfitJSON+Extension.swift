//
//  SwfitJSON+Extension.swift
//  shop
//
//  Created by akrio on 2017/4/22.
//  Copyright © 2017年 TBI. All rights reserved.
//

import Foundation
import SwiftDate
import SwiftyJSON
extension JSON {
    /// 将json对象转化成日期类型
    ///
    /// - Parameter formamt: 格式化规则
    /// - Returns: 转化后的日期
    func dateFormat (_ formamt:DateFormat) -> DateInRegion {
        let str = self.stringValue
        switch formamt {
        case .custom(let formater):
            return DateInRegion(string: str, format: .custom(formater)) ?? (DateInRegion(string: "1970-01-01", format: .custom("YYYY-MM-dd"))!)
        case .strict(let formater):
            return DateInRegion(string: str, format: .strict(formater)) ?? (DateInRegion(string: "1970-01-01", format: .custom("YYYY-MM-dd"))!)
        case .iso8601(let options):
            return DateInRegion(string: str, format: .iso8601(options: options)) ?? (DateInRegion(string: "1970-01-01", format: .custom("YYYY-MM-dd"))!)
        case .iso8601Auto:
            return DateInRegion(string: str, format: .iso8601Auto) ?? (DateInRegion(string: "1970-01-01", format: .custom("YYYY-MM-dd"))!)
        case .extended:
            return DateInRegion(string: str, format: .extended) ?? (DateInRegion(string: "1970-01-01", format: .custom("YYYY-MM-dd"))!)
        case .rss(let alt):
            return DateInRegion(string: str, format: .rss(alt:alt) ) ?? (DateInRegion(string: "1970-01-01", format: .custom("YYYY-MM-dd"))!)
        case .dotNET:
            return DateInRegion(string: str, format: .dotNET) ?? (DateInRegion(string: "1970-01-01", format: .custom("YYYY-MM-dd"))!)
        case .unix:
            return unixFormat (str) ?? (DateInRegion(string: "1970-01-01", format: .custom("YYYY-MM-dd"))!)
        }
    }
    /// 将 unix 时间戳转化成DateInRegion类型
    ///
    /// - Parameter str: 待转化的时间字符串
    /// - Returns: 转化后的时间
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
}
/// Available date formats used to parse strings and format date into string
///
/// - custom:   custom format expressed in Unicode tr35-31 (see http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns and Apple's Date Formatting Guide). Formatter uses heuristics to guess the date if it's invalid.
///				This may end in a wrong parsed date. Use `strict` to disable heuristics parsing.
/// - strict:	strict format is like custom but does not apply heuristics to guess at the date which is intended by the string.
///				So, if you pass an invalid date (like 1999-02-31) formatter fails instead of returning guessing date (in our case
///				1999-03-03).
/// - iso8601:  ISO8601 date format (see https://en.wikipedia.org/wiki/ISO_8601).
/// - iso8601Auto:	ISO8601 date format. You should use it to parse a date (parsers evaluate automatically the format of
///					the ISO8601 string). Passed as options to transform a date to string it's equal to [.withInternetDateTime] options.
/// - extended: extended date format ("eee dd-MMM-yyyy GG HH:mm:ss.SSS zzz")
/// - rss:      RSS and AltRSS date format
/// - dotNET:   .NET date format
/// - unix:   unix时间戳格式化
enum DateFormat {
    case custom(String)
    case strict(String)
    case iso8601(options: ISO8601DateTimeFormatter.Options)
    case iso8601Auto
    case extended
    case rss(alt: Bool)
    case dotNET
    case unix
}
