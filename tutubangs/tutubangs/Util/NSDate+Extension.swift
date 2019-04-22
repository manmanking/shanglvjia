//
//  NSDate+Extension.swift
//  Genius
//
//  Created by TBI on 2016/12/6.
//  Copyright © 2016年 TBI. All rights reserved.
//

import UIKit

/**
 刚刚(一分钟内)
 X分钟前(一小时内)
 X小时前(当天)
 
 昨天 HH:mm(昨天)
 
 MM-dd HH:mm(一年内)
 yyyy-MM-dd HH:mm(更早期)
 */
extension Date {
    
    //格式化日期
    static func formatDate(stringTime:String)->String {
        
        let dfmatter = DateFormatter()
        dfmatter.dateFormat="yyyy-MM-dd HH:mm:ss"
        let date = dfmatter.date(from: stringTime)
        dfmatter.dateFormat="MM月dd日 HH:mm"
        
        return dfmatter.string(from: date!)
        
    }
    
    /// 根据字符串创建时间戳
    static func dateWithString(string: String) -> NSDate? {
        
        // 创建时间格式化对象
        let formatter = DateFormatter()
        // 指定时间格式
        formatter.dateFormat = "EEE MM dd HH:mm:ss Z yyyy"
        // 指定时区
        formatter.locale = NSLocale(localeIdentifier: "en") as Locale!
        // 转换时间
        return formatter.date(from: string) as NSDate?
    }
    
    /// 获取当前时间的格式
    func getDateWithString() -> String {
        
        // 创建时间格式化对象
        let formatter = DateFormatter()
        // 指定时区
        formatter.locale = NSLocale(localeIdentifier: "en") as Locale!
        // 创建一个日历类
        let calendar = NSCalendar.current
        
        // 利用日历类从指定时间获取指定的组成成分
        // 判断是否是今天
        if calendar.isDateInToday(self as Date) {
            
            // 获取当前时间和指定时间之间的差值(单位秒)
            let rest = Int(NSDate().timeIntervalSince(self as Date))
            
            // 判断是否是一分钟内
            if rest < 60 {
                
                return "刚刚"
            }
            else if rest < 60 * 60 {
                
                return "\(rest / 60)分钟前"
            }
            else if rest < 60 * 60 * 24 {
                
                return "\(rest / (60 * 60))小时前"
            }
        }
        else if calendar.isDateInYesterday(self as Date) {
            
            formatter.dateFormat = "昨天 HH:mm"
            return formatter.string(from: self as Date)
        }
        
        // 取出微博时间和当前时间之间相差的年数
        let com = calendar.dateComponents([.year], from: self as Date, to: NSDate() as Date)
        if com.year! < 1 {
            
            formatter.dateFormat = "MM-dd HH:mm"
            return formatter.string(from: self as Date)
        }
        else {
            
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            return formatter.string(from: self as Date)
        }
    }
    
    
    //根据日期 计算 周期时间
    
    func weekdayStringFromDate() -> String {
        let weekdays = ["周天","周日","周一", "周二", "周三", "周四", "周五","周六"]
        var calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = NSTimeZone.system
        let component = calendar.component( Calendar.Component.weekday, from: self as Date)
        return weekdays[component]
    }
   
    
    
}
