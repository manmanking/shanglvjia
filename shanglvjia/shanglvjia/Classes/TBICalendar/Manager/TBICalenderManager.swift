//
//  TBICalenderManager.swift
//  shop
//
//  Created by manman on 2017/7/13.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import SwiftDate

enum TBICalendarMonthPosition:NSInteger {
    case PreviousMonth
    case CurrentMonth
    case NextMonth
    case NotFound
}





class TBICalenderManager: NSObject {
    
    
    private var calendarType:TBICalendarAlertType = TBICalendarAlertType.Default

    public var selectedDates:[Date] = Array()
    public var showTitleArr:[String] = Array()
    public var scopeYearBool:Bool = false
    private var startDate:Date = Date()
    private var endDate:Date = Date()
    
    
    private var localDelayDay:NSInteger = 0
    
    // 个人酒店特价 可售日期
    
    private var personalSpecialHotelActivetyDay:[SpecialHotelDetailResponse.HotelUsableDateInfo] = Array()
    
    
    /// 保存 个人 酒店 定投的开始和结束日期
    private var personalSpecialHotelSelectedDate:[Date] = Array()
    
    private let gregorianCalendar:Calendar = Calendar.current
    
    override init() {
        super.init()
        initial()
        
    }
    
    
    /// 设置 日历 样式
    func mm_setCalendarType(type:TBICalendarAlertType) {
        calendarType = type
    }
    
    private func initial() {
        mm_showDateScope(scopeYear: true)
    }
    
    //获得开始时间
    public func mm_StartDate()->Date {
        return startDate
    }
    // 获得结束时间
    public func mm_EndDate()->Date {
        return endDate
    }
    
    
    /// 定投酒店 可以售卖的日期
    public func mm_PersonalSpecialHotelDateSaleActivetySet(dateSet:[SpecialHotelDetailResponse.HotelUsableDateInfo]) {
        personalSpecialHotelActivetyDay = dateSet
    }
    
    
    /// 延迟几天开始
    func mm_PersonalVisa(delayDay:NSInteger) {
        localDelayDay = delayDay + 4 //2018-09-10 签证 增加4⃣️天
    }
    
    
    
    // 设置 时间 范围
    public func mm_ShowDateRegion(start:String,end:String) {
        let oldStartDate = stringConversDate(content:start , format: "yyyy-MM-dd")
        startDate = self.gregorianCalendar.date(bySettingHour: 0, minute: 0, second: 0, of: oldStartDate)!
        let oldEndDate = stringConversDate(content: end, format: "yyyy-MM-dd")
        endDate = self.gregorianCalendar.date(bySettingHour: 0, minute: 0, second: 0, of: oldEndDate)!
    }
    
    
    public func mm_showDateScope(scopeYear:Bool) {
        guard scopeYear == true else {
            return
        }
        
        startDate = self.gregorianCalendar.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
        endDate = mm_currentDateNextYear(month: startDate)!
    }
    // 分组
    public func mm_Section() -> NSInteger {
        return mm_caculateMonthNum(fromDate: startDate, toDate: endDate)
    }
    // 每组 数据元素
    public func mm_ItemsForSection(section:NSInteger) -> NSInteger {
        
        let month = mm_MonthForSection(section: section)
        let rows = mm_weeksOfMonth(month: month)
        return rows * 7
    }
    
    //显示的日期
    public func mm_DateForIndexPath(indexPath:IndexPath) -> Date {
        //改进方法
        let month:Date = mm_MonthForSection(section: indexPath.section)
        let ordinalityOfFirstDay = self.gregorianCalendar.component(.weekday, from: mm_FirstDayOfMonth(month: month)!) - 1
        let sectionFirstDate:Date = self.gregorianCalendar.date(byAdding: Calendar.Component.day, value: -ordinalityOfFirstDay, to: month)!
        let returnDate:Date = self.gregorianCalendar.date(byAdding: Calendar.Component.day, value: indexPath.row, to: sectionFirstDate)!
        return returnDate
        
        
    }
    
    
    
    // 获得月
    public func mm_MonthForSection(section:NSInteger) -> Date {
        var month:Date = Date()
        month = self.gregorianCalendar.date(byAdding: Calendar.Component.month, value: section, to: self.mm_FirstDayOfMonth(month: self.startDate)!)!
        return month
        
    }
    
    func mm_sectionForMonth(month:Date) -> NSInteger {
        
        var section:NSInteger = 0
        ///得到当前月第一天
        let calendar = NSCalendar.current
        let componentss = calendar.dateComponents(
            Set<Calendar.Component>([.year, .month]), from: startDate)
        let startOfMonth = calendar.date(from: componentss)!
        ///得到当前月的section
        section = startOfMonth.compare(to: month, granularity: Calendar.Component.month).rawValue
        let components:DateComponents = self.gregorianCalendar.dateComponents([.month], from: startOfMonth, to: month)
        return components.month!
    }
    
    
    
    
    public func mm_monthPositionForIndexPath(indexPath:IndexPath) -> TBICalendarMonthPosition {

        
        let date:Date = mm_DateForIndexPath(indexPath: indexPath)
        let page:Date = mm_MonthForSection(section: indexPath.section)
        let comparison:ComparisonResult = self.gregorianCalendar.compare(date, to: page, toGranularity: Calendar.Component.month)
        switch comparison {
    
        case ComparisonResult.orderedAscending:
            return TBICalendarMonthPosition.PreviousMonth
            
        case ComparisonResult.orderedSame:
            return TBICalendarMonthPosition.CurrentMonth
        case ComparisonResult.orderedDescending:
            return TBICalendarMonthPosition.NextMonth
            
        default: break
            
        }
        return TBICalendarMonthPosition.NotFound
    }
    
    public func mm_isToday(indexPath:IndexPath) -> Bool {
        
        let date:Date = mm_DateForIndexPath(indexPath: indexPath)
        
        let currentDate:Date = Date()
        
        let comparisonResult:ComparisonResult = currentDate.compare(to: date, granularity: Calendar.Component.day)
        
        switch comparisonResult {
        case ComparisonResult.orderedSame:
            //今天
            return true
        case ComparisonResult.orderedAscending:
            return false
        case ComparisonResult.orderedDescending:
            return false
        default:
            return false
        }
        
    }
    
    
    public func mm_isActivity(indexPath:IndexPath) -> Bool {
        
        
        let date:Date = mm_DateForIndexPath(indexPath: indexPath)
        let currentDate:Date = Date()
        
        var result:Bool = false
        
        
        
        let comparisonResult:ComparisonResult = currentDate.compare(to: date, granularity: Calendar.Component.day)
        let comparisonResultScope:ComparisonResult = date.compare(to: endDate, granularity: Calendar.Component.day)
        
        
        switch comparisonResult {
        case ComparisonResult.orderedSame:
            result =  true
        case ComparisonResult.orderedAscending:
            if comparisonResultScope == ComparisonResult.orderedDescending {
                result = false
            }else {
                result = true
            }
            
        case ComparisonResult.orderedDescending:
            result = false
        default:
            result = false
        }
        
        result = mm_CalendarTypeCustomActivetyScope(type: calendarType, attach: result, itemDate: date)
        
        return result
        
    }
    
    
    /// 日历 日期 有效性的检测
    func mm_CalendarTypeCustomActivetyScope(type:TBICalendarAlertType,attach:Bool,itemDate:Date) -> Bool {
        var result:Bool = attach
        switch type {
        case .Train:
            result = mm_CalendarCustomActivetyScopeTrain(itemDate: itemDate)
            
        case .Hotel:
            result = mm_CalendarCustomActivetyScopeHotel(itemDate: itemDate)
        case .Flight,.Travel:
            break
        case .PersonalSpecialHotel:
            if result == false { return result}
            else { result = mm_CalendarCustomActivetyScopePersonalSpecialHotel(itemDate: itemDate)}
        case .PersonalVisa:
            if result == false {return result }
            else {result = mm_CalendarCustomActivetyDelayPersonalVisa(itemDate: itemDate)}
        case .PersonalHotel:
             result = mm_CalendarCustomActivetyScopePersonalHotel(itemDate: itemDate)
        default:
            break
            
        }
        return result
    }
    
    
    /// 火车票最大售票范围
    private func mm_CalendarCustomActivetyScopeTrain(itemDate:Date) -> Bool {
    
        var result:Bool = false
        let currentDate:Date = Date()
        if calendarType == TBICalendarAlertType.Train {
            let trainMaxDate:NSInteger = UserDefaults.standard.object(forKey: trainBookMaxDate) as! NSInteger
            let bookDateResult:ComparisonResult = gregorianCalendar.compare(itemDate.startOfDay, to: (currentDate + trainMaxDate.day).endOfDay, toGranularity: Calendar.Component.day)
            let currentDateResult:ComparisonResult = gregorianCalendar.compare(itemDate.startOfDay, to: currentDate.endOfDay, toGranularity: Calendar.Component.day)
            if bookDateResult != ComparisonResult.orderedAscending {
                    result = false
            }else {
                    result = true
            }
            if  currentDateResult == ComparisonResult.orderedAscending {
                result = false
            }
        }
        return result
    }
    
    /// 酒店最大售票范围 90天
    private func mm_CalendarCustomActivetyScopeHotel(itemDate:Date) -> Bool {
        
        var result:Bool = false
        let currentDate:Date = Date()
        if calendarType == TBICalendarAlertType.Hotel {
            let hotelMaxDate:NSInteger = UserDefaults.standard.object(forKey: hotelBookMaxDate) as! NSInteger
            let bookDateResult:ComparisonResult = gregorianCalendar.compare(itemDate.startOfDay, to: (currentDate + hotelMaxDate.day).endOfDay, toGranularity: Calendar.Component.day)
            let currentDateResult:ComparisonResult = gregorianCalendar.compare(itemDate.startOfDay, to: currentDate.endOfDay, toGranularity: Calendar.Component.day)
            if bookDateResult != ComparisonResult.orderedAscending {
                result = false
            }else {
                result = true
            }
            if  currentDateResult == ComparisonResult.orderedAscending {
                result = false
            }
        }
        return result
    }
    
    ///个人 酒店最大售票范围 90天
    private func mm_CalendarCustomActivetyScopePersonalHotel(itemDate:Date) -> Bool {
        
        var result:Bool = false
        let currentDate:Date = Date()
        if calendarType == TBICalendarAlertType.PersonalHotel {
            var hotelMaxDate:NSInteger =  90 * 2
            if let hotelDate = UserDefaults.standard.object(forKey: personalHotelBookMaxDate) {
                hotelMaxDate = hotelDate as! NSInteger
            }
            let bookDateResult:ComparisonResult = gregorianCalendar.compare(itemDate.startOfDay, to: (currentDate + hotelMaxDate.day).endOfDay, toGranularity: Calendar.Component.day)
            let currentDateResult:ComparisonResult = gregorianCalendar.compare(itemDate.startOfDay, to: currentDate.endOfDay, toGranularity: Calendar.Component.day)
            if bookDateResult != ComparisonResult.orderedAscending {
                result = false
            }else {
                result = true
            }
            if  currentDateResult == ComparisonResult.orderedAscending {
                result = false
            }
        }
        return result
    }
    
    
    
    
    /// 定投酒店 可售日期 检测
    func mm_CalendarCustomActivetyScopePersonalSpecialHotel(itemDate:Date) -> Bool {
        var result:Bool = false
       // let checkDateSecond:NSNumber =  NSNumber.init(value:itemDate.timeIntervalSince1970)
        printDebugLog(message: "elected Date")
        printDebugLog(message: selectedDates)
        
        
        let itemDateNumber:NSNumber = NSNumber.init(value:(itemDate.timeIntervalSince1970))
        //let itemNextDayDateNumber:NSNumber = NSNumber.init(value: ((itemDate + 1.day).timeIntervalSince1970))
        for element in personalSpecialHotelActivetyDay {
            
            if selectedDates.isEmpty || selectedDates.count >= 2 {
                // 第一个条件
                if (element.saleDate / 1000) ==  itemDateNumber.intValue {
                    result = true
                    break
                }
            }else if selectedDates.count == 1 {
                // 第一个条件
                let selectedDateNum:NSNumber = NSNumber.init(value: (selectedDates.first?.timeIntervalSince1970)!)
                
                if selectedDateNum.intValue >= itemDateNumber.intValue {
                    if (element.saleDate / 1000) ==  itemDateNumber.intValue && selectedDateNum.intValue >= itemDateNumber.intValue {
                        result = true
                        break
                    }
                }else {
                    // 第二个条件
                    //let selectedDateNum:NSNumber = NSNumber.init(value: (selectedDates.first?.timeIntervalSince1970)!)
                    //                let preDayDate:Date = (itemDate - 1.day)
                    //                let preDayDateNum:NSNumber = NSNumber.init(value: preDayDate.timeIntervalSince1970)
                    if selectedDateNum.intValue == (element.saleDate / 1000) && (element.saleEndDate / 1000) >= itemDateNumber.intValue {
                        result = true
                        break
                    }
                }
                
               
               
            }
            
            
          
        }
        
        //return result
        
        
        
    
        /// 展示 日期 激活可以使用日期
//        if selectedDates.count == 2 {
//            personalSpecialHotelSelectedDate.removeAll()
//            for element in personalSpecialHotelActivetyDay {
//                if (element.saleDate / 1000) == checkDateSecond.intValue{
//                    result = true
//
//                    break
//                }
//            }
//        }
       /// 选择第一个日期  过滤产品 是否 支持 这个 日期
//        if selectedDates.count  == 1 && personalSpecialHotelSelectedDate.count == 0  {
//            
//            let checkInDate:NSNumber = NSNumber.init(value:(selectedDates.first?.timeIntervalSince1970)!)
//            for element in personalSpecialHotelActivetyDay {
//                if (element.saleDate / 1000) ==  checkInDate.intValue {
//                    let presaleStartDate:Date = Date.init(timeIntervalSince1970: TimeInterval(element.saleDate / 1000))
//                    let presaleEndDate:Date = Date.init(timeIntervalSince1970: TimeInterval(element.saleEndDate / 1000))
//                    personalSpecialHotelSelectedDate.removeAll()
//                    personalSpecialHotelSelectedDate = [presaleStartDate,presaleEndDate]
//                    break
//                }
//            }
//
//        }
//
//        if selectedDates.count == 1 && personalSpecialHotelSelectedDate.count == 2 {
////            let bookStartDateResult:ComparisonResult = gregorianCalendar.compare(personalSpecialHotelSelectedDate.first!.startOfDay, to: itemDate.endOfDay, toGranularity: Calendar.Component.day)
////            let bookEndDateResult:ComparisonResult = gregorianCalendar.compare(itemDate.startOfDay, to: personalSpecialHotelSelectedDate.last!.endOfDay, toGranularity: Calendar.Component.day)
////            if bookStartDateResult != ComparisonResult.orderedAscending {
////                result = false
////            }else {
////                result = true
////            }
////            if  bookEndDateResult == ComparisonResult.orderedAscending {
////                result = false
////            }
//            let bookStartDateSecond = NSNumber.init(value:(personalSpecialHotelSelectedDate.first?.timeIntervalSince1970)!)
//            let bookEndDateSecond = NSNumber.init(value:(personalSpecialHotelSelectedDate.last?.timeIntervalSince1970)!)
//            let currentSecond:NSNumber = NSNumber.init(value: itemDate.timeIntervalSince1970)
//            if bookStartDateSecond.intValue <= currentSecond.intValue && bookEndDateSecond.intValue >= currentSecond.intValue {
//                result = true
//            }else {
//                result = false
//            }
//        }
//
        return result
    }
    
    
    func  mm_CalendarCustomActivetyDelayPersonalVisa(itemDate:Date) ->Bool {
        
        let currentDay:Date = Date().startOfDay
        //var weekend:NSInteger = 0
        var tmpResultDate:Date = currentDay
        for _ in 1...localDelayDay {
            var indexCopy = 1
            let isWeekend = (tmpResultDate + indexCopy.day).isInWeekend
            if isWeekend {
                while (tmpResultDate + indexCopy.day).isInWeekend {
                    indexCopy += 1
                }
            }
            tmpResultDate = (tmpResultDate + indexCopy.day)
//            printDebugLog(message:tmpResultDate.string(custom: "yyyy-MM-dd"))
//            printDebugLog(message: isWeekend == true ? "是周末":"要上班")
        }
        while (tmpResultDate + 1.day).isInWeekend {
            tmpResultDate = (tmpResultDate + 1.day)
        }
//        printDebugLog(message:tmpResultDate.string(custom: "yyyy-MM-dd"))
//        printDebugLog(message:tmpResultDate.weekdayName)
        let delayDayDate:Date = tmpResultDate//(currentDay + localDelayDay.day + weekend.day)
        if delayDayDate.compare(itemDate) == .orderedAscending {
            return true
        }
        return false
    }
    
    
    
    
    
    func mm_addDataSources(fromDate:Date ,toDate:Date) {
        var nextDate:Date = fromDate + 1.day
        while nextDate.compare(toDate) == ComparisonResult.orderedAscending {
            selectedDates.append(nextDate)
            nextDate = nextDate + 1.day
        }
        
        
        
        
    }
    
    
    
    // 本月中几周
    private func mm_weeksOfMonth(month:Date) -> NSInteger {
        
        let rangeOfWeeks = (self.gregorianCalendar as NSCalendar).range(of: .weekOfMonth,in: .month,for: month).length
        return rangeOfWeeks
    }
    
    // 获取 本月 第一天
    private func mm_FirstDayOfMonth(month:Date) -> Date? {
        if month == nil {
            return nil
        }
        var components = self.gregorianCalendar.dateComponents([.year,.month,.day,.hour], from: month)
        components.day = 1
        
        return self.gregorianCalendar.date(from: components)
    }
    
    
    // 获取 本月 第一天
    private func mm_currentDateNextYear(month:Date) -> Date? {
        if month == nil {
            return nil
        }
        var components = self.gregorianCalendar.dateComponents([.year,.month,.day,.hour], from: month)
        components.year = components.year! + 1
        components.day = components.day! - 1
        
        
        return self.gregorianCalendar.date(from: components)
    }
    
    private func mm_caculateMonthNum(fromDate:Date ,toDate:Date) -> NSInteger {
        
        var components =  self.gregorianCalendar.dateComponents([.month], from: fromDate, to: toDate)
        components.month = components.month! + 2
        return components.month!
        
    }
    //string  转 date
    private func stringConversDate(content:String, format:String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let date = formatter.date(from: content)
        return date!
    }
    
    
    
    
}
