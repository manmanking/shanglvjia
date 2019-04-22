//
//  TBIServicesPhoneView.swift
//  shop
//
//  Created by manman on 2018/3/5.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class TBIServicesPhoneView: UIView {
    
    typealias TBIServicesPhoneViewSelectedBlock  = ()->Void
    
    public var servicesPhoneViewSelectedBlock:TBIServicesPhoneViewSelectedBlock!
    
    private let baseBackgroundView:UIView = UIView()
    private let subBaseBackgroundView:UIView = UIView()
    
    private let servicesTipTitleLabel:UILabel = UILabel()
    
    private let servicesWorkPhoneLabel:UILabel = UILabel()
    private let servicesOvertimePhoneLabel:UILabel = UILabel()
    
    private let servicesWorkTimeLabel:UILabel = UILabel()
    
    private let servicesTipTitleDefault:String = "—————————  专属客服·为您护航  —————————"
    
    private let servicesTipTitleSmallDefault:String = "———————  专属客服·为您护航  ———————"
    private let servicesWorkPhoneTipDefault:String = "服务座机:"
    private let servicesOverTimePhoneTipDefault:String = "非工作时间紧急电话:"
    private let servicesWorkTimeTipDefault:String = "工作日: 8:30-19:30    休息日:  9:00-17:00"
    
    private var workPhone:String = ""
    private var overTimePhone:String = ""
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        self.addSubview(subBaseBackgroundView)
        subBaseBackgroundView.addOnClickListener(target: self, action: #selector(selectedServicesPhone))
        subBaseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        setUIViewAutolayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUIViewAutolayout() {
        servicesTipTitleLabel.text = servicesTipTitleDefault
        if ScreenWindowWidth < 375 {
            servicesTipTitleLabel.text = servicesTipTitleSmallDefault
        }
        servicesTipTitleLabel.textAlignment = NSTextAlignment.center
        servicesTipTitleLabel.textColor = TBIThemeFooterColor
        servicesTipTitleLabel.font = UIFont.systemFont(ofSize: 12)
        subBaseBackgroundView.addSubview(servicesTipTitleLabel)
        servicesTipTitleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(15)
        }
       
        if ScreenWindowWidth < 375 {
            devicesIphone5LaterViewAutolayout()
        }else
        {
            devicesIphone6LaterViewAutolayout()
        }
        
        servicesWorkTimeLabel.text = servicesWorkTimeTipDefault
        servicesWorkTimeLabel.textColor = TBIThemeFooterColor
        servicesWorkTimeLabel.textAlignment = NSTextAlignment.center
        servicesWorkTimeLabel.font = UIFont.systemFont(ofSize: 10)
        subBaseBackgroundView.addSubview(servicesWorkTimeLabel)
        servicesWorkTimeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(servicesWorkPhoneLabel.snp.bottom).offset(5)
            make.left.right.equalToSuperview()
            make.height.equalTo(15)
        }
    }
    
    
    /// iphone6 及 plus 设备
    func devicesIphone6LaterViewAutolayout() {
        servicesWorkPhoneLabel.text = servicesWorkPhoneTipDefault
        servicesWorkPhoneLabel.textColor = TBIThemeFooterColor
        servicesWorkPhoneLabel.textAlignment = NSTextAlignment.center
        servicesWorkPhoneLabel.font = UIFont.systemFont(ofSize: 11)
        subBaseBackgroundView.addSubview(servicesWorkPhoneLabel)
        servicesWorkPhoneLabel.snp.makeConstraints { (make) in
            make.top.equalTo(servicesTipTitleLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(10)
            make.height.equalTo(13)
        }
//        servicesOvertimePhoneLabel.text = servicesOverTimePhoneTipDefault
//        servicesOvertimePhoneLabel.textColor = TBIThemeFooterColor
//        servicesOvertimePhoneLabel.font = UIFont.systemFont(ofSize: 11)
//        servicesOvertimePhoneLabel.textAlignment = NSTextAlignment.left
//        subBaseBackgroundView.addSubview(servicesOvertimePhoneLabel)
//        servicesOvertimePhoneLabel.snp.makeConstraints { (make) in
//            make.top.equalTo(servicesWorkPhoneLabel.snp.top)
//            make.left.equalTo(servicesWorkPhoneLabel.snp.right).offset(10)
//            make.right.equalToSuperview().inset(20)
//            make.height.equalTo(13)
//        }
        
    }
    
    /// iphone 5 类似尺寸的设备
    func devicesIphone5LaterViewAutolayout() {
        servicesWorkPhoneLabel.text = servicesWorkPhoneTipDefault
        servicesWorkPhoneLabel.textColor = TBIThemeFooterColor
        servicesWorkPhoneLabel.textAlignment = NSTextAlignment.center
        servicesWorkPhoneLabel.font = UIFont.systemFont(ofSize: 11)
        subBaseBackgroundView.addSubview(servicesWorkPhoneLabel)
        servicesWorkPhoneLabel.snp.makeConstraints { (make) in
            make.top.equalTo(servicesTipTitleLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(10)
            make.height.equalTo(13)
        }
//        servicesOvertimePhoneLabel.text = servicesOverTimePhoneTipDefault
//        servicesOvertimePhoneLabel.textColor = TBIThemeFooterColor
//        servicesOvertimePhoneLabel.font = UIFont.systemFont(ofSize: 11)
//        servicesOvertimePhoneLabel.textAlignment = NSTextAlignment.center
//        subBaseBackgroundView.addSubview(servicesOvertimePhoneLabel)
//        servicesOvertimePhoneLabel.snp.makeConstraints { (make) in
//            make.top.equalTo(servicesWorkPhoneLabel.snp.bottom).offset(10)
//            make.left.right.equalToSuperview().inset(10)
//            make.height.equalTo(13)
//        }
        
    }
    
    
    
   public func fillDataSource(workPhone:String,overtimePhone:String) {
    if workPhone.isEmpty == false {
        servicesWorkPhoneLabel.text = servicesWorkPhoneTipDefault + workPhone
        self.workPhone = workPhone
    }
//    if overtimePhone.isEmpty == false {
//        servicesOvertimePhoneLabel.text = servicesOverTimePhoneTipDefault + overtimePhone
//        self.overTimePhone = overtimePhone
//    }
   
    }
    
    func showChoicesServicePhoneView() {
        let titleArr:[String] = [workPhone]
        let roleView = TBIFinderView.init(frame: ScreenWindowFrame)
        roleView.rowHeight = 80
        roleView.fontSize = UIFont.systemFont(ofSize: 18)
        weak var weakSelf = self
        roleView.finderViewSelectedResultBlock = { (cellIndex) in
            weakSelf?.callServicesPhone(phone: titleArr[cellIndex])
        }
        KeyWindow?.addSubview(roleView)
        roleView.reloadDataSources(titledataSources: titleArr, flageImage: nil)
    }
    
    //MARK:--------Action------------
    
    @objc private func selectedServicesPhone() {
        if  DEBUG { print(#line,#function) }
        if workPhone.isEmpty == true {
            return
        }
        showChoicesServicePhoneView()
        //        if servicesPhoneViewSelectedBlock != nil {
//            servicesPhoneViewSelectedBlock()
//        }
    }
    
    func callServicesPhone(phone:String) {
        guard phone.isEmpty == false else {
            return
        }
        UIApplication.shared.openURL(NSURL(string :"tel://" + phone)! as URL)
    }
    
    

}
