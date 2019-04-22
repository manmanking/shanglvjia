//
//  TBIBirthdayDateView.swift
//  shop
//
//  Created by manman on 2017/8/1.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class TBIBirthdayDateView: UIView,UIPickerViewDelegate,UIPickerViewDataSource{

    
    typealias TBIBirthdayDateViewResult = (String)->Void
    
    public var birthdayDateViewResult:TBIBirthdayDateViewResult!
    private var startDate:Date = Date()
    private var endDate:Date = Date()
    
    private var localYear:String = "1900"
    private var localMonth:String = "01"
    private var localDay:String = "01"
    
    private let baseBackgroundView:UIView = UIView()
    
    private let subView:UIView  = UIView()
    
    private let headerBackgroundView:UIView  = UIView()
    
    private let gregorianCalendar:Calendar = Calendar.current
    
    private let confirmButton:UIButton  = UIButton(title: "确定",titleColor: TBIThemeWhite,titleSize: 16)
    
    private let cancelButton:UIButton   = UIButton(title: "取消",titleColor: TBIThemeWhite,titleSize: 16)
    
    private let pickerView:UIPickerView = UIPickerView()
    
    
    var date:String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        baseBackgroundView.backgroundColor = TBIThemeBackgroundViewColor
        baseBackgroundView.addOnClickListener(target: self, action: #selector(cancelButtonAction))
        self.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        subView.backgroundColor = TBIThemeWhite
        headerBackgroundView.backgroundColor = TBIThemeLinkColor
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
        
        headerBackgroundView.addSubview(confirmButton)
        headerBackgroundView.addSubview(cancelButton)
        cancelButton.addOnClickListener(target: self, action: #selector(cancelButtonAction))
        confirmButton.addOnClickListener(target: self, action: #selector(confirmButtonAction))
        cancelButton.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.bottom.equalToSuperview()
        }
        confirmButton.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.top.bottom.equalToSuperview()
        }
        
        subView.addSubview(pickerView)
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.bottom.right.equalToSuperview()
        }
        //mm_CaculateSartAndEnd(start: "1900-01-01", end: "2020-12-31")
        mm_CaculateSartAndEnd(start: "1970-01-01", end: "2090-12-31")
        reloadData(birthday: "1992-08-09")
    
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return  mm_caculateYearNum(fromDate: startDate, toDate: endDate)
        }
        if component == 1 {
            return 12
        }
        
        print(localYear + "-" + localMonth + "-" + localDay)
        let month:Date = stringConversDate(content: localYear + "-" + localMonth + "-" + localDay, format: "yyyy-MM-dd")
        return mm_caculateDaysInMonth(month:month)
        
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        pickerView.subviews[1].backgroundColor = TBIThemeGrayLineColor
        pickerView.subviews[2].backgroundColor = TBIThemeGrayLineColor
        if component == 0 {
            return (1900 + row).description + "年"
        }else if component == 1
        {
            return (1 + row).description + "月"
            
        }else if component == 2
        {
            return (1 + row).description + "日"
        }
        return row.description
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var contentLable:UILabel?
        
        if view == nil {
            
            contentLable = UILabel.init()
            contentLable?.backgroundColor = UIColor.clear
            contentLable?.textAlignment = NSTextAlignment.center
            contentLable?.font = UIFont.systemFont(ofSize: 18)
            
            
        }else
        {
            contentLable = view as! UILabel
        }
        
        contentLable?.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        return contentLable!
        
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("row",row,component)
        if component == 0
        {
            localYear = (1900 + row).description
            
        }else if component == 1
        {
            localMonth = (1 + row).description
            localDay = 1.description
            pickerView.reloadComponent(2)
            pickerView.selectRow(0, inComponent: 2, animated: true)
        }else if component == 2
        {
            localDay = (1 + row).description
        }
    }
    
    
    
    public func reloadData(birthday:String) {
        
        guard birthday != nil else {
            return
        }
        let  birthdayArr:[String] = birthday.components(separatedBy: "-")
        guard birthdayArr.count == 3 else {
            return
        }
        localYear = birthdayArr[0]
        let year = NSInteger(localYear)! - 1900
        pickerView.selectRow(year, inComponent: 0, animated: true)
        localMonth = birthdayArr[1]
        let month = NSInteger(localMonth)! - 1
        pickerView.selectRow(month, inComponent: 1, animated: true)
        localDay = birthdayArr[2]
        let day = NSInteger(localDay)! - 1
        pickerView.selectRow(day, inComponent: 2, animated: true)
    }
    
    
    private func mm_CaculateSartAndEnd(start:String,end:String) {
        let oldStartDate = stringConversDate(content:start , format: "yyyy-MM-dd")
        startDate = self.gregorianCalendar.date(bySettingHour: 0, minute: 0, second: 0, of: oldStartDate)!
        let oldEndDate = stringConversDate(content: end, format: "yyyy-MM-dd")
        endDate = self.gregorianCalendar.date(bySettingHour: 0, minute: 0, second: 0, of: oldEndDate)!
    }
    
    private func mm_caculateYearNum(fromDate:Date ,toDate:Date) -> NSInteger {
        
        var components =  self.gregorianCalendar.dateComponents([.year], from: fromDate, to: toDate)
        components.year = components.year! + 1
        return components.year!
        
    }
    
    
    
    
    private func mm_caculateDaysInMonth(month:Date) ->NSInteger
    {
        print(month,month.monthDays)
        return month.monthDays
        
    }
    
    
    
    //string  转 date
    private func stringConversDate(content:String, format:String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let date = formatter.date(from: content)
        print("转", date)
        return date!
    }
    
    @objc private func confirmButtonAction() {
    
        let result:String = String.init(format: "%04d-%02d-%02d",NSInteger(localYear)!,NSInteger(localMonth)!,NSInteger(localDay)!)
        
        if birthdayDateViewResult != nil {
            birthdayDateViewResult(result)
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
