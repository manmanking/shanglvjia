//
//  TBIDatePickerView.swift
//  shop
//
//  Created by TBI on 2017/5/28.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class TBIDatePickerView: UIView {
    
    
    typealias DatePickerResultBlock = (String)->Void
    
    public  var datePickerResultBlock:DatePickerResultBlock?
    
    private let baseBackgroundView:UIView = UIView()
    
    private let subView:UIView  = UIView()
    
    private let headerBgView:UIView  = UIView()
    
    public let datePicker = UIDatePicker()
    
    private let confirmButton:UIButton  = UIButton(title: "确认",titleColor: TBIThemeWhite,titleSize: 16)
    
    private let cancelButton:UIButton   = UIButton(title: "取消",titleColor: TBIThemeWhite,titleSize: 16)
    
    
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
        headerBgView.backgroundColor = TBIThemeLinkColor
        self.addSubview(subView)
        subView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(175)
        }
        self.addSubview(headerBgView)
        headerBgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.height.equalTo(50)
            make.bottom.equalTo(subView.snp.top)
        }
        
        headerBgView.addSubview(confirmButton)
        headerBgView.addSubview(cancelButton)
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
       
        
        //创建日期选择器
        //将日期选择器区域设置为中文，则选择器日期显示为中文
        datePicker.locale = Locale(identifier: "zh_CN")
        datePicker.datePickerMode = .date
        //注意：action里面的方法名后面需要加个冒号“：”
        datePicker.addTarget(self, action:  #selector(dateChanged(datePicker:)),for: .valueChanged)
        datePicker.backgroundColor  = TBIThemeWhite
        subView.addSubview(datePicker)
        datePicker.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalToSuperview()
        }

    }
    
    func confirmButtonAction() {
        if date.isEmpty == true {
            date = datePicker.date.string(custom: "YYYY-MM-dd")
             if datePicker.datePickerMode == .dateAndTime{
                date = datePicker.date.string(custom: "YYYY-MM-dd HH:mm")
            }
        }
        datePickerResultBlock?(date)
        self.removeFromSuperview()
    }
    
    //日期选择器响应方法
    func dateChanged(datePicker : UIDatePicker){
        //更新提醒时间文本框
        let formatter = DateFormatter()
        //日期样式
        formatter.dateFormat = "yyyy-MM-dd"
        if datePicker.datePickerMode == .dateAndTime{
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
        }
        date = formatter.string(from: datePicker.date)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func cancelButtonAction() {
        self.removeFromSuperview()
    }
}
