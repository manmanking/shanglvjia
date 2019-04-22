//
//  TBIDateTimeView.swift
//  shop
//
//  Created by TBI on 2018/1/19.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import SwiftDate

class TBIDateTimeView: UIView,UIPickerViewDelegate,UIPickerViewDataSource{
    
    
    typealias TBIDateTimeViewDateBlock = (String)->Void
    
    public  var  dateTimeViewDateBlock:TBIDateTimeViewDateBlock!
    
    ///指定显示时间
    public var customSelectedDateStr:String = ""
    private var customSelectedDate:Date = Date()
    
    /// 业务允许时间 // 例如预约用车 只能预订一个小时之后
    public var afterHoursPermission:NSInteger = 2
    //开始时间
    public var currentDate:Date = Date()
    
    private var startDate:Date = Date()
    private var endDate:Date = Date()
    
    private var selectedDay:Date = Date()
    private var selectedHour:String = "0"
    private var selectedMin:String = "0"
    
    public var countDate:Int = 90
    
    private var minDataSourcesArr:[String] = Array()
    private var hourDataSourcesArr:[String] = Array()
    private var dayDataSourcesArr:[String] = Array()
    
    /// 背景 容器
    private let baseBackgroundView:UIView = UIView()
    
    /// 子背景  容器
    private let subView:UIView  = UIView()
    
    /// 表头 背景 容器
    private let headerBackgroundView:UIView  = UIView()
    
    private let titleLable:UILabel = UILabel()
    
    private let gregorianCalendar:Calendar = Calendar.current
    
    private let confirmButton:UIButton  = UIButton()
    
    private let cancelButton:UIButton   = UIButton()
    
    private let pickerView:UIPickerView = UIPickerView()
    
    
    var date:String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        customDateDataSources()
        baseBackgroundView.backgroundColor = TBIThemeBackgroundViewColor
        baseBackgroundView.addOnClickListener(target: self, action: #selector(cancelButtonAction))
        self.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        setUIViewAutolayout()
    }
    
    private func setUIViewAutolayout() {
        subView.backgroundColor = TBIThemeMinorColor
        headerBackgroundView.backgroundColor = TBIThemeMinorColor
        self.addSubview(subView)
        subView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(175)
        }
        self.addSubview(headerBackgroundView)
        headerBackgroundView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.height.equalTo(50)
            make.bottom.equalTo(subView.snp.top)
        }
        
        cancelButton.setTitle("取消", for: UIControlState.normal)
        cancelButton.setTitleColor(TBIThemePrimaryTextColor, for: UIControlState.normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        cancelButton.addOnClickListener(target: self, action: #selector(cancelButtonAction))
        headerBackgroundView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.width.equalTo(50)
            make.top.bottom.equalToSuperview()
        }
        confirmButton.setTitle("确定", for: UIControlState.normal)
        confirmButton.setTitleColor(TBIThemeOrangeColor, for: UIControlState.normal)
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        confirmButton.addOnClickListener(target: self, action: #selector(confirmButtonAction))
        headerBackgroundView.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.width.equalTo(50)
            make.top.bottom.equalToSuperview()
        }
        
        titleLable.textColor = TBIThemePrimaryTextColor
        titleLable.text = "请选择上车时间"
        titleLable.textAlignment = NSTextAlignment.center
        headerBackgroundView.addSubview(titleLable)
        titleLable.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(cancelButton.snp.right)
            make.right.equalTo(confirmButton.snp.left)
        }
        let firstBottomLine:UILabel = UILabel()
        firstBottomLine.backgroundColor = TBIThemeGrayLineColor
        headerBackgroundView.addSubview(firstBottomLine)
        firstBottomLine.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(1)
            make.height.equalTo(1)
        }
        subView.addSubview(pickerView)
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.bottom.right.equalToSuperview()
        }
    }
    
    
    private func resetLocalDataSources()  {
        selectedMin = "0"
        selectedHour = "0"
        selectedDay = currentDate
    }
    
    
    public func customDateDataSources() {
        resetLocalDataSources()
//        if customSelectedDateStr.isEmpty == false {
//            customSelectedDate = customSelectedDateStr.stringConvertDate()
//        }else { customSelectedDate = currentDate }
        let start = DateInRegion(absoluteDate: currentDate)
        let end = start + countDate.day
        mm_CaculateSartAndEnd(start: start.string(custom: "yyyy-MM-dd"), end: end.string(custom: "yyyy-MM-dd"))
        
        // 时间延后之后 是否会导致 时间转移到第二天
        if currentDate.hour + afterHoursPermission >= 24 {
            currentDate = currentDate + 1.day
            startDate = startDate + 1.day
        }
        
        for index in 0..<countDate{
            let date = startDate + index.day
            dayDataSourcesArr.append(date.string(format: .custom("MM月dd日EEE")))
        }

//        let  todayDateStr:String = startDate.month.description + "月" + startDate.day.description + "日"
//        let tomarrowDateStr:String = startDate.month.description + "月" + (startDate + 1.day ).day.description + "日"
//        let TheDayAfterTomorrowDateStr:String = startDate.month.description + "月" + (startDate + 2.day ).day.description + "日"
        
//        dayDataSourcesArr = [todayDateStr,tomarrowDateStr,TheDayAfterTomorrowDateStr]
        hourDataSourcesArr = ["00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23"]
        minDataSourcesArr = ["00","10","20","30","40","50"]
        selectedDay = currentDate
        selectedHour = (currentDate.hour + afterHoursPermission).description
        if currentDate.hour + afterHoursPermission > 23 {
            selectedHour = (currentDate.hour + afterHoursPermission - 24).description
        }
        var minDecimalCeil:NSInteger = NSNumber.init(value:ceil(Double(currentDate.minute) / 10.0)).intValue
        //若分钟为整数时 需要在下一个10分钟展示 2018-01-25
        if NSInteger(currentDate.minute) % 10 == 0 { minDecimalCeil += 1 }
        if minDecimalCeil == 6 {
            selectedMin = minDataSourcesArr.first!
            selectedHour = (currentDate.hour + afterHoursPermission + 1).description
            if currentDate.hour + afterHoursPermission + 1 > 24 {
                selectedHour = (currentDate.hour + afterHoursPermission - 24).description
            }
        }else
        {
            
            selectedMin = minDataSourcesArr[minDecimalCeil]
        }
        pickerView.reloadAllComponents()
        if customSelectedDate.compare(currentDate + afterHoursPermission.hour) != ComparisonResult.orderedDescending {
            return
        }
        setSelectedDate(selectedDate: customSelectedDate)
        
    }
    
    
    /// 设置 指定时间
    private func setSelectedDate(selectedDate:Date) {
        if DEBUG { print(#function,#line,"selectedDate",selectedDate) }
        let tmpSelectedDayRow:NSInteger = selectedDate.day - currentDate.day
        var tmpSelectedHourRow:NSInteger = 0
        var tmpSelectedMinRow:NSInteger = 0
        tmpSelectedHourRow = selectedDate.hour
        tmpSelectedMinRow = selectedDate.minute / 10
        selectedDay = selectedDate
        selectedHour = hourDataSourcesArr[selectedDate.hour]
        
        //添加 分钟数容错
        var nearestHour:NSInteger = 0
        let nearestHourDecimalCeil:NSInteger = NSNumber.init(value:ceil(Double(currentDate.minute) / 10.0)).intValue
        if  nearestHourDecimalCeil == 6 {
            nearestHour = 1
        }
        // 计算 小时
        if selectedDate.isToday == true {
            selectedHour = selectedDate.hour.description
            if selectedDate.hour == currentDate.hour + afterHoursPermission + nearestHour{
                tmpSelectedHourRow = 0
            }else
            {
                tmpSelectedHourRow = tmpSelectedHourRow - currentDate.hour - afterHoursPermission - nearestHour
            }
        }
        
        // 计算分钟
        selectedMin = minDataSourcesArr[tmpSelectedMinRow]
        if selectedDate.isToday == true && selectedDate.hour == currentDate.hour + afterHoursPermission + nearestHour {
            //selectedMin = minDataSourcesArr[selectedDate.minute]
            let minDecimalCeil:NSInteger = NSNumber.init(value:ceil(Double(currentDate.minute) / 10.0)).intValue
            if minDecimalCeil == 6
            {
                //tmpSelectedMinRow = 0
            }else
            {
                //添加 分钟数容错
                var nearestDecimalMin:NSInteger = 0
                if  currentDate.minute % 10 == 0{ nearestDecimalMin = 1 }
                tmpSelectedMinRow = tmpSelectedMinRow - minDecimalCeil - nearestDecimalMin
            }
            
            
        }
        
        pickerView.reloadAllComponents()
        pickerView.selectRow(tmpSelectedDayRow, inComponent: 0, animated: true)
        pickerView.selectRow(tmpSelectedHourRow, inComponent: 1, animated: true)
        if tmpSelectedMinRow != 0 {
            pickerView.selectRow(tmpSelectedMinRow, inComponent: 2, animated: true)
        }
        if DEBUG {
            print("component 0  - >" , tmpSelectedDayRow )
            print("component 1  - >"  ,tmpSelectedHourRow )
            print("component 2  - >"  ,tmpSelectedMinRow )
        }
    }
    
    
    
    //MARK:-------------UIPickerViewDataSource---------
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //if DEBUG { print(#function,#line,"component",component) }
        switch component{
        case 0:
            return  countDate//mm_caculateDayNum(fromDate: startDate, toDate: endDate)
        case 1:
            return mm_caculateHoursNum()//mm_caculateHourNum(fromDate: selectedDay, toDate: selectedDay.endOfDay)
        case 2:
            return mm_caculateMinNum()
        default:
            break
        }
        return 0
        
    }
    
    
    //MARK:----------------UIPickerViewDelegate-----------------
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch component {
        case 0:
            return ScreenWindowWidth/3 + 60
        case 1:
            return ScreenWindowWidth/3 - 30
        case 2:
            return ScreenWindowWidth/3 - 30
        default:
            break
        }
        return ScreenWindowWidth/3
    }

    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var containerView:UIView?
        if view == nil {
            containerView = UIView()
        }
        let contentLable:UILabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWindowWidth/3, height: 44))
        contentLable.backgroundColor = UIColor.clear
        contentLable.textAlignment = NSTextAlignment.center
        contentLable.font = UIFont.systemFont(ofSize: 18)
        containerView?.addSubview(contentLable)
        switch component {
        case 0:
            contentLable.frame = CGRect.init(x: 0, y: 0, width: ScreenWindowWidth/3 + 60, height: 44)
            contentLable.text = mm_showMatchDateDay(index: row)
        case 1:
            contentLable.frame = CGRect.init(x: 0, y: 0, width: ScreenWindowWidth/3 - 30, height: 44)
            contentLable.text = mm_showMatchDateHour(index: row) + "点"
        case 2:
            contentLable.frame = CGRect.init(x: 0, y: 0, width: ScreenWindowWidth/3 - 60, height: 44)
            contentLable.text = mm_showMatchDateMin(index: row) + "分"
        default:
            break
        }
        
        return containerView!

    }
    
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //if DEBUG { print(#function,#line,"row",row,component) }
        switch component {
        case 0:
            selectedDateDay(index: row)
            break
        case 1:
            selectedDateHour(index: row)
            break
        case 2:
            selectedDateMin(index: row)
            break
        default:
            break
        }
    }
    
    /// 选中日期  单位 天
    private func selectedDateDay(index:Int) {
        switch index {
        case 0:
            selectedDay = currentDate
            selectedHour = hourDataSourcesArr[24 - mm_caculateHoursNum()]
            pickerView.reloadComponent(1)
            pickerView.selectRow(0, inComponent: 1, animated: true)
            let minDecimalCeil:NSInteger = NSNumber.init(value:ceil(Double(currentDate.minute) / 10.0)).intValue
            //            if NSInteger(selectedHour) == currentDate.hour + afterHoursPermission {
            //
            //            }
            if minDecimalCeil == 6 {
                selectedMin = minDataSourcesArr.first!
                pickerView.reloadComponent(2)
                pickerView.selectRow(0, inComponent: 2, animated: true)
            }else{
                selectedMin = minDataSourcesArr[minDecimalCeil]
                pickerView.reloadComponent(2)
                pickerView.selectRow(0, inComponent: 2, animated: true)
            }
        default:
            selectedDay = currentDate + index.day
            selectedHour = hourDataSourcesArr[8]
            selectedMin = minDataSourcesArr.first!
            pickerView.reloadComponent(1)
            pickerView.reloadComponent(2)
            pickerView.selectRow(8, inComponent: 1, animated: true)
            pickerView.selectRow(0, inComponent: 2, animated: true)
            break
        }
    }
    
    /// 选中日期  单位 小时
    private func selectedDateHour(index:Int) {
        
        if selectedDay.isToday == true
        {
            //添加 分钟数容错
            var nearestHour:NSInteger = 0
            let nearestHourDecimalCeil:NSInteger = NSNumber.init(value:ceil(Double(currentDate.minute) / 10.0)).intValue
            if  nearestHourDecimalCeil == 6 {
                nearestHour = 1
            }
            selectedHour = hourDataSourcesArr[currentDate.hour + afterHoursPermission + index + nearestHour]
            var minDecimalCeil:NSInteger = NSNumber.init(value:ceil(Double(currentDate.minute) / 10.0)).intValue
            //若分钟为整数时 需要在下一个10分钟展示 2018-01-25
            if NSInteger(currentDate.minute) % 10 == 0 { minDecimalCeil += 1 }
            if (selectedDay.isToday == true && NSInteger(selectedHour) == currentDate.hour + afterHoursPermission) {
                if minDecimalCeil == 6 {
                    selectedMin = minDataSourcesArr.first!
                    pickerView.selectRow(0, inComponent: 2, animated: true)
                }else{
                    selectedMin = minDataSourcesArr[minDecimalCeil]
                    let currentMinDecimalCeil:NSInteger = NSNumber.init(value:ceil(Double(currentDate.minute) / 10.0)).intValue
                    pickerView.selectRow(minDecimalCeil - currentMinDecimalCeil, inComponent: 2, animated: true)
                }
            }else
            {
                selectedMin = minDataSourcesArr.first!
                pickerView.selectRow(0, inComponent: 2, animated: true)
            }
            
        }else
        {
            selectedHour = hourDataSourcesArr[index]
            selectedMin = minDataSourcesArr.first!
            pickerView.selectRow(0, inComponent: 2, animated: true)
        }
        
        pickerView.reloadComponent(2)
    }
    
    /// 选中日期  单位 分钟
    private func selectedDateMin(index:Int) {
        //添加 分钟数容错
        var nearestHour:NSInteger = 0
        let nearestHourDecimalCeil:NSInteger = NSNumber.init(value:ceil(Double(currentDate.minute) / 10.0)).intValue
        if  nearestHourDecimalCeil == 6 {
            nearestHour = 1
        }
        if selectedDay.isToday == true && NSInteger(selectedHour) == currentDate.hour + afterHoursPermission + nearestHour {
            var minDecimalCeil:NSInteger = NSNumber.init(value:ceil(Double(currentDate.minute) / 10.0)).intValue
            //若分钟为整数时 需要在下一个10分钟展示 2018-01-25
            if NSInteger(currentDate.minute) % 10 == 0 { minDecimalCeil += 1 }
            if minDecimalCeil == 6 { selectedMin = minDataSourcesArr[index]}
            else { selectedMin = minDataSourcesArr[minDecimalCeil + index] }
            print(#function,#line,selectedMin)
        }else
        {
            selectedMin = minDataSourcesArr[index]
            print(#function,#line,selectedMin,selectedDay.isToday ,selectedHour,selectedDay.hour + afterHoursPermission)
        }
    }
    
    
    
    
    //MARK:--------------------Caculate Date-------------
    ///设置 时间区间
    private func mm_CaculateSartAndEnd(start:String,end:String) {
        let oldStartDate = stringConversDate(content:start , format: "yyyy-MM-dd")
        startDate = self.gregorianCalendar.date(bySettingHour: 0, minute: 0, second: 0, of: oldStartDate)!
        let oldEndDate = stringConversDate(content: end, format: "yyyy-MM-dd")
        endDate = self.gregorianCalendar.date(bySettingHour: 0, minute: 0, second: 0, of: oldEndDate)!
    }
    
    /// 年的计数
    private func mm_caculateYearNum(fromDate:Date ,toDate:Date) -> NSInteger {
        var components =  self.gregorianCalendar.dateComponents([.year], from: fromDate, to: toDate)
        components.year = components.year! + 1
        return components.year!
        
    }
    
    /// 计算月的个数
    private func mm_caculateMonthNum(fromDate:Date ,toDate:Date) -> NSInteger {
        var components =  self.gregorianCalendar.dateComponents([.month], from: fromDate, to: toDate)
        components.year = components.year! + 1
        return components.year!
    }
    /// 计算 一个月内 天的个数
    private func mm_caculateDaysInMonth(month:Date) ->NSInteger
    {
        print(month,month.monthDays)
        return month.monthDays
    }
    
    /// 计算开始时间到结束时间 天的个数
    private func mm_caculateDayNum(fromDate:Date ,toDate:Date) -> NSInteger {
        
        var components =  self.gregorianCalendar.dateComponents([.day], from: fromDate, to: toDate)
        components.day = components.day ?? 0
        return components.day!
    }
    
    
    /// 计算小时的个数
    private func mm_caculateHourNum(fromDate:Date ,toDate:Date) -> NSInteger {
        
        var components =  self.gregorianCalendar.dateComponents([.hour], from: fromDate, to: toDate)
        components.hour = (components.hour ?? 0) + 1
        return components.hour!
    }
    
    /// 计算需要显示小时的个数
    private func mm_caculateHoursNum() -> NSInteger {
        //今天
        if selectedDay.isToday == true  {
            let minDecimalCeil:NSInteger = NSNumber.init(value:ceil(Double(currentDate.minute) / 10.0)).intValue
            if minDecimalCeil == 6 {return  24 - currentDate.hour - afterHoursPermission - 1}
            return 24 - currentDate.hour - afterHoursPermission
        }
        if currentDate.hour + afterHoursPermission > 24 {
            let minDecimalCeil:NSInteger = NSNumber.init(value:ceil(Double(currentDate.minute) / 10.0)).intValue
            if minDecimalCeil == 6 {return  48 - currentDate.hour - afterHoursPermission - 1}
            return 48 - currentDate.hour - afterHoursPermission
        }
        return 24
    }
    
    /// 计算需要显示分钟的个数
    private func mm_caculateMinNum() -> NSInteger{
        if selectedDay.isToday == true  && NSInteger(selectedHour) == currentDate.hour + afterHoursPermission {
            var minDecimalCeil:NSInteger = NSNumber.init(value:ceil(Double(currentDate.minute) / 10.0)).intValue
            //优化 去除 整数
            if NSInteger(currentDate.minute) % 10 == 0 { minDecimalCeil += 1 }
            return minDataSourcesArr.count - minDecimalCeil
        }
        if currentDate.hour + afterHoursPermission >= 24 && NSInteger(selectedHour) == currentDate.hour + afterHoursPermission - 24 {
            var minDecimalCeil:NSInteger = NSNumber.init(value:ceil(Double(currentDate.minute) / 10.0)).intValue
            //优化 去除 整数
            if NSInteger(currentDate.minute) % 10 == 0 { minDecimalCeil += 1 }
            return minDataSourcesArr.count - minDecimalCeil
        }
        return 6
    }
    
    /// 需要显示 日期 day 的样式
    private func mm_showMatchDateDay(index:Int) -> String {
        return dayDataSourcesArr[index]
    }
    
    
    /// 需要显示 小时的 样式
    private func mm_showMatchDateHour(index:Int) -> String {
        if selectedDay.isToday == true {
            var minAbout:NSInteger = 0
            let minDecimalCeil:NSInteger = NSNumber.init(value:ceil(Double(currentDate.minute) / 10.0)).intValue
            if minDecimalCeil == 6 { minAbout = 1 }
            return hourDataSourcesArr[currentDate.hour + index + afterHoursPermission + minAbout]
        }
        if currentDate.hour + afterHoursPermission > 24 {
            var minAbout:NSInteger = 0
            let minDecimalCeil:NSInteger = NSNumber.init(value:ceil(Double(currentDate.minute) / 10.0)).intValue
            if minDecimalCeil == 6 { minAbout = 1 }
            return hourDataSourcesArr[index + currentDate.hour + afterHoursPermission - 24 + minAbout]
        }
        return hourDataSourcesArr[index]
    }
    
    /// 需要显示 分钟 的样式
    private func mm_showMatchDateMin(index:Int) -> String {
        if selectedDay.isToday == true && NSInteger(selectedHour) == currentDate.hour + afterHoursPermission {
            var minDecimalCeil:NSInteger = NSNumber.init(value:ceil(Double(currentDate.minute) / 10.0)).intValue
            //优化 去除 整数
            if NSInteger(currentDate.minute) % 10 == 0 { minDecimalCeil += 1 }
            return minDataSourcesArr[minDecimalCeil + index]
        }
        if currentDate.hour + afterHoursPermission >= 24 && NSInteger(selectedHour) == currentDate.hour + afterHoursPermission - 24 {
            var minDecimalCeil:NSInteger = NSNumber.init(value:ceil(Double(currentDate.minute) / 10.0)).intValue
            //优化 去除 整数
            if NSInteger(currentDate.minute) % 10 == 0 { minDecimalCeil += 1 }
            return minDataSourcesArr[minDecimalCeil + index]
        }
        return minDataSourcesArr[index]
    }
    
    //string  转 date
    private func stringConversDate(content:String, format:String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let date = formatter.date(from: content)
        return date!
    }
    
    //MARK:-----------setter-------------
    
    public func setDateTitle(title:String) {
        if title.isEmpty == false {
            titleLable.text = title
        }
    }
    
    
    
    //MARK:--------------Action--------------
    
    @objc private func confirmButtonAction() {
        
        let result:String = selectedDay.string(custom: "yyyy-MM-dd") + " " + selectedHour + ":" + selectedMin
        if DEBUG { print(#function,#line,"result",result) }
        if dateTimeViewDateBlock != nil {
            dateTimeViewDateBlock(result)
        }
        
        
        cancelButtonAction()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func cancelButtonAction() {
        self.removeFromSuperview()
    }
}

