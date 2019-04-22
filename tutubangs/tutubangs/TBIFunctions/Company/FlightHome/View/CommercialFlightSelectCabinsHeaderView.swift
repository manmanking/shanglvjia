//
//  CommercialFlightSelectCabinsHeaderView.swift
//  shop
//
//  Created by SLMF on 2017/5/3.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import SwiftDate

fileprivate func setText(label: UILabel, text: String, bgView: UIView) {
    label.text = text
    bgView.addSubview(label)
}

class FLightSelectCabinsHeaderCellView: UITableViewHeaderFooterView {
    
    let bgView = UIView()
    //航空公司图标
    var airCompanyImage = UIImageView(imageName:"AI")
    //航空公司名字
    var flightNameLabel = UILabel.init(text: "鹰联航", color: PersonalThemeMajorTextColor, size: 13)
    ///实际承运
    var shareAirCompanyImage = UIImageView(imageName:"AI")
    var shareFlightNameLabel = UILabel.init(text: "", color: PersonalThemeMajorTextColor, size: 13)
    //
    var flightDateLabel = UILabel.init(text: "", color: PersonalThemeMajorTextColor, size: 13)
    //
    var takeOffCityLabel = UILabel.init(text: "", color: TBIThemePrimaryTextColor, size: 13)
    //
    var arriveCityLabel = UILabel.init(text: "", color: TBIThemePrimaryTextColor, size: 13)
    //
    var takeOffDateLabel = UILabel.init(text: "", color: PersonalThemeMajorTextColor, size: 25)
    
    var flightStatusLabel = UILabel.init(text: "", color: TBIThemeShallowBlueColor, size: 12)
    //
    let arrowImage = UIImageView.init(imageName: "ic_ari_timeto")
    //经停标签
    var stopOverLabel = UILabel.init(text: "经停", color: TBIThemeMinorTextColor, size: 11)
    
    //经停标签
    var stopOverCityLabel = UILabel.init(text: "", color: TBIThemeMinorTextColor, size: 11)
    
    //
    var arriveDateLabel = UILabel.init(text: "", color: TBIThemePrimaryTextColor, size: 25)
    //
    var takeOffAirportLabel = UILabel.init(text: "", color: TBIThemeMinorTextColor, size: 12)
    //
    var craftTypeLabel = UILabel.init(text: "", color: TBIThemeMinorTextColor, size: 12)
    //
    var arriveAirportLabel = UILabel.init(text: "", color: TBIThemeMinorTextColor, size: 12)
    
    let messageImage = UIImageView.init(imageName: "ico_attention")
    
    var messageLabel = UILabel.init(text: "什么是协议价?", color: TBIThemeBlueColor, size: 10)
    
    
    ///  航程是否隔天 +1天
    private var flyDaysLabel:UILabel = UILabel()
    
 
    
    private var mealCodeLabel:UILabel = UILabel()
    
    private let firstLine:UILabel = UILabel()
    /// 机型编号
    private var flightTypeLabel:UILabel = UILabel()
    
    private let secondLine:UILabel = UILabel()
    
    /// 中型机
    private var flightTypeBulkLabel:UILabel = UILabel()
    
    private let thirdLine:UILabel = UILabel()
    /// 飞行时间
    private var duringTimeLabel:UILabel = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.backgroundColor = TBIThemeBaseColor
        self.bgView.backgroundColor = TBIThemeWhite
        self.bgView.layer.cornerRadius = 2
        self.addSubview(bgView)
        bgView.addSubview(flightNameLabel)
        bgView.addSubview(airCompanyImage)
        bgView.addSubview(shareFlightNameLabel)
        bgView.addSubview(shareAirCompanyImage)
        bgView.addSubview(flightDateLabel)
        bgView.addSubview(takeOffDateLabel)
        bgView.addSubview(takeOffCityLabel)
        bgView.addSubview(arrowImage)
        bgView.addSubview(stopOverLabel)
        bgView.addSubview(arriveDateLabel)
        bgView.addSubview(arriveCityLabel)
        bgView.addSubview(takeOffAirportLabel)
        bgView.addSubview(craftTypeLabel)
        bgView.addSubview(arriveAirportLabel)
        bgView.addSubview(flightStatusLabel)
        stopOverLabel.isHidden = true
        
        bgView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(5)//-17.5
        }
        
        //
        //        self.addSubview(messageLabel)
        //        messageLabel.snp.makeConstraints { (make) in
        //            make.right.equalTo(-25)
        //            make.top.equalTo(bgView.snp.bottom).offset(4)
        //        }
        //
        //        self.addSubview(messageImage)
        //        messageImage.snp.makeConstraints { (make) in
        //            make.width.height.equalTo(10)
        //            make.centerY.equalTo(messageLabel.snp.centerY)
        //            make.right.equalTo(messageLabel.snp.left).offset(-5)
        //        }
        
        flightDateLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(15)
        }
        airCompanyImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(flightDateLabel.snp.centerY)
            make.width.height.equalTo(12)
            make.left.equalTo(flightDateLabel.snp.right).offset(5)
        }
        flightNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(airCompanyImage.snp.right).offset(5)
            make.centerY.equalTo(airCompanyImage)
        }
        flightStatusLabel.snp.makeConstraints { (make) in
            make.left.equalTo(flightDateLabel)
            make.top.equalTo(flightDateLabel.snp.bottom).offset(5)
            make.height.equalTo(12)
            
        }
        ///实际承运航班信息
        shareAirCompanyImage.isHidden = true
        shareAirCompanyImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(flightStatusLabel.snp.centerY)
            make.width.height.equalTo(12)
            make.left.equalTo(flightStatusLabel.snp.right).offset(5)
        }
        shareFlightNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(shareAirCompanyImage.snp.right).offset(5)
            make.centerY.equalTo(shareAirCompanyImage)
        }
        
        
        
        takeOffDateLabel.snp.makeConstraints { (make) in
            make.right.equalTo(arrowImage.snp.left).offset(-30)
            make.top.equalTo(arrowImage.snp.bottom).offset(15)
            make.height.equalTo(30)
        }
        arriveDateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(arrowImage.snp.right).offset(30)
            make.top.equalTo(takeOffDateLabel.snp.top)
            make.height.equalTo(30)
        }
        flyDaysLabel.text = "+1天"
        flyDaysLabel.font = UIFont.systemFont(ofSize: 11)
        flyDaysLabel.textColor = TBIThemePrimaryTextColor
        bgView.addSubview( flyDaysLabel)
        flyDaysLabel.snp.makeConstraints { (make) in
            make.left.equalTo(arriveDateLabel.snp.right).offset(2)
            make.top.equalTo(arriveDateLabel.snp.top).offset(-5)
            make.width.equalTo(40)
            make.height.equalTo(20)
        }
        takeOffCityLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(takeOffDateLabel.snp.top).offset(-2)
            make.centerX.equalTo(takeOffDateLabel.snp.centerX)
        }
        arriveCityLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(arriveDateLabel.snp.centerX)
            make.bottom.equalTo(arriveDateLabel.snp.top).offset(-2)
        }
        
        
        arrowImage.snp.makeConstraints { (make) in
            make.width.equalTo(50)
            make.height.equalTo(3)
            make.centerX.equalTo(bgView.snp.centerX)
            make.centerY.equalTo(takeOffDateLabel.snp.centerY)
        }
        stopOverLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(arrowImage.snp.centerX)
            make.bottom.equalTo(arrowImage.snp.bottom).offset(-4)
        }
        
        
        takeOffAirportLabel.snp.makeConstraints { (make) in
            make.right.equalTo(takeOffDateLabel.snp.right)
            make.top.equalTo(takeOffDateLabel.snp.bottom).offset(5)
        }
        craftTypeLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(arrowImage.snp.centerX)
            make.bottom.equalToSuperview().offset(-15)
        }
        arriveAirportLabel.snp.makeConstraints { (make) in
            make.left.equalTo(arriveDateLabel.snp.left)
            make.top.equalTo(takeOffAirportLabel.snp.top)
        }
        mealCodeLabel.font = UIFont.systemFont(ofSize: 11)
        mealCodeLabel.textColor = TBIThemeMinorTextColor
        mealCodeLabel.textAlignment = NSTextAlignment.center
        bgView.addSubview(mealCodeLabel)
        mealCodeLabel.snp.remakeConstraints { (make) in
            make.left.equalToSuperview().inset(15)
            make.height.equalTo(14)
            make.width.equalTo((ScreenWindowWidth - 40)/4)
            make.bottom.equalToSuperview().inset(15)
            make.top.equalTo(takeOffAirportLabel.snp.bottom).offset(20)
        }
        
        
        firstLine.backgroundColor = TBIThemeMinorTextColor
        bgView.addSubview(firstLine)
        firstLine.snp.makeConstraints { (make) in
            make.left.equalTo(mealCodeLabel.snp.right).offset(2)
            make.height.equalTo(12)
            make.centerY.equalTo(mealCodeLabel)
            make.width.equalTo(1)
        }
        
        flightTypeLabel.font = UIFont.systemFont(ofSize: 11)
        flightTypeLabel.textColor = TBIThemeMinorTextColor
        flightTypeLabel.textAlignment = NSTextAlignment.center
        bgView.addSubview(flightTypeLabel)
        flightTypeLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(firstLine.snp.right).offset(2)
            make.centerY.equalTo(mealCodeLabel)
            make.width.equalTo((ScreenWindowWidth - 40)/4)
            make.height.equalTo(14)
        }
        secondLine.backgroundColor = TBIThemeMinorTextColor
        bgView.addSubview(secondLine)
        secondLine.snp.makeConstraints { (make) in
            make.left.equalTo(flightTypeLabel.snp.right).offset(2)
            make.height.equalTo(12)
            make.centerY.equalTo(flightTypeLabel)
            make.width.equalTo(1)
        }
        
        flightTypeBulkLabel.font = UIFont.systemFont(ofSize: 11)
        flightTypeBulkLabel.textColor = TBIThemeMinorTextColor
        flightTypeBulkLabel.textAlignment = NSTextAlignment.center
        bgView.addSubview(flightTypeBulkLabel)
        flightTypeBulkLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(secondLine.snp.right).offset(2)
            make.centerY.equalTo(flightTypeLabel)
            make.width.equalTo((ScreenWindowWidth - 40)/4)
            make.height.equalTo(14)
        }
        
        thirdLine.backgroundColor = TBIThemeMinorTextColor
        bgView.addSubview(thirdLine)
        thirdLine.snp.makeConstraints { (make) in
            make.left.equalTo(flightTypeBulkLabel.snp.right).offset(2)
            make.height.equalTo(12)
            make.centerY.equalTo(mealCodeLabel)
            make.width.equalTo(1)
        }
        
        duringTimeLabel.font = UIFont.systemFont(ofSize: 11)
        duringTimeLabel.textColor = TBIThemeMinorTextColor
        duringTimeLabel.textAlignment = NSTextAlignment.center
        bgView.addSubview(duringTimeLabel)
        duringTimeLabel.snp.makeConstraints { (make) in
            make.width.equalTo((ScreenWindowWidth - 40)/4)
            make.centerY.equalTo(mealCodeLabel)
            make.height.equalTo(14)
            make.right.equalToSuperview().inset(15)
        }
        
        
        
        stopOverCityLabel.isHidden = true
        addSubview(stopOverCityLabel)
        stopOverCityLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(arrowImage.snp.centerX)
            make.top.equalTo(arrowImage.snp.bottom)
        }
    }
    
    
    func fillDataSources(airfare:FlightSVSearchResultVOModel.AirfareVO) {
        let takeOffDate:Date = Date.init(timeIntervalSince1970:TimeInterval(airfare.flightInfos.first!.takeOffDate/1000))
        var arriveDate:Date = Date.init(timeIntervalSince1970:TimeInterval(airfare.flightInfos.first!.arriveDate/1000))
        airCompanyImage.image = UIImage(named: (airfare.flightInfos.first?.flightCode)!)
        flightNameLabel.text = (airfare.flightInfos.first?.flightShortName ?? "") + (airfare.flightInfos.first?.flightCode ?? "") + (airfare.flightInfos.first?.flightNo ?? "")
        if airfare.flightInfos.first?.share ?? false {
            flightStatusLabel.text = "实际承运"
            shareAirCompanyImage.isHidden = false
            shareAirCompanyImage.image = UIImage(named:(airfare.flightInfos.first?.carriageCode)!)
            shareFlightNameLabel.text = (airfare.flightInfos.first?.carriageShortName)! + (airfare.flightInfos.first?.carriageCode)! + (airfare.flightInfos.first?.carriageNo)!
        }
        flightDateLabel.text = takeOffDate.string(custom: "M月dd日")
        takeOffDateLabel.text = takeOffDate.string(custom: "HH:mm")
        arriveDateLabel.text = arriveDate.string(custom: "HH:mm")
        takeOffAirportLabel.text =  (airfare.flightInfos.first?.takeOffAirportName ?? "") + (airfare.flightInfos.first?.takeOffTerminal ?? "")
        arriveAirportLabel.text  = (airfare.flightInfos.first?.arriveAirportName ?? "") + (airfare.flightInfos.first?.arriveTerminal ?? "")
        // 若存在中转的情况  到达的位置信息 需要变更
        if airfare.flightInfos.count > 1 {
            arriveDate = Date.init(timeIntervalSince1970:TimeInterval(airfare.flightInfos.first!.arriveDate/1000))
            takeOffDateLabel.text = arriveDate.hour.description + ":" + arriveDate.minute.description //takeOffDate.string(custom: "hh:mm")
            arriveAirportLabel.text  = (airfare.flightInfos[1].arriveAirportName ?? "") + (airfare.flightInfos[1].arriveTerminal ?? "")
        }
        
        var isFlyDay:Bool = false
        
        for element in airfare.flightInfos {
            if element.flyDays > 0 {
                isFlyDay = true
                break
            }
        }
        flyDaysLabel.isHidden = !isFlyDay
        if airfare.flightInfos.first?.mealCode.isEmpty == false {
            mealCodeLabel.text = airfare.flightInfos.first?.mealCode
        }else {
            mealCodeLabel.text = "--"
        }
        if  airfare.flightInfos.first?.craftTypeName.isEmpty == false {
            flightTypeLabel.text = airfare.flightInfos.first?.craftTypeName
        }else {
            flightTypeLabel.text = "--"
        }
        if airfare.flightInfos.first?.craftTypeClassShort.isEmpty == false {
           flightTypeBulkLabel.text = airfare.flightInfos.first?.craftTypeClassShort
        }else {
            flightTypeBulkLabel.text = "--"
        }
        let flightTime:String = airfare.flightInfos.first?.flightTime ?? ""
        let dateCompoment:[String] = flightTime.components(separatedBy: ":")
        if dateCompoment.count > 1 {
            duringTimeLabel.text = "约" + dateCompoment.first! + "小时" + dateCompoment[1] + "分"
        }else {
            duringTimeLabel.text = "--"//(airfare.flightInfos.first?.flightTime)!
        }
        
        
        
        
        
        
        //是否直达
        if airfare.direct {
            stopOverLabel.isHidden = true
            
            //是否经停
            if airfare.flightInfos.first?.stopOver == true {
                stopOverLabel.text = "经停"
                stopOverLabel.isHidden = false
                stopOverCityLabel.isHidden = false
                stopOverCityLabel.text = airfare.flightInfos.first?.stopOverCity
            }else {
                stopOverLabel.isHidden = true
            }
        }else {
            stopOverCityLabel.isHidden = false
            stopOverLabel.isHidden = false
            stopOverLabel.text = "转"
            stopOverCityLabel.text = airfare.transferCity//model.legList.first?.arriveCity
        }
 
    }
    
    func fillDataSourcesCommon(airfare:PCommonFlightSVSearchModel.AirfareVO) {
        let takeOffDate:Date = Date.init(timeIntervalSince1970:TimeInterval(airfare.flightInfos.first!.takeOffDate/1000))
        var arriveDate:Date = Date.init(timeIntervalSince1970:TimeInterval(airfare.flightInfos.first!.arriveDate/1000))
        airCompanyImage.image = UIImage(named: (airfare.flightInfos.first?.flightCode)!)
        flightNameLabel.text = (airfare.flightInfos.first?.flightShortName ?? "") + (airfare.flightInfos.first?.flightCode ?? "") + (airfare.flightInfos.first?.flightNo ?? "")
        if airfare.flightInfos.first?.share ?? false {
            flightStatusLabel.text = "实际承运"
            flightStatusLabel.textColor = PersonalThemeNormalColor
            shareAirCompanyImage.isHidden = false
            shareAirCompanyImage.image = UIImage(named:(airfare.flightInfos.first?.carriageCode)!)
            shareFlightNameLabel.text = (airfare.flightInfos.first?.carriageShortName)! + (airfare.flightInfos.first?.carriageCode)! + (airfare.flightInfos.first?.carriageNo)!
        }
        flightDateLabel.text = takeOffDate.string(custom: "M月dd日")
        takeOffDateLabel.text = takeOffDate.string(custom: "HH:mm")
        arriveDateLabel.text = arriveDate.string(custom: "HH:mm")
        takeOffAirportLabel.text =  (airfare.flightInfos.first?.takeOffAirportName ?? "") + (airfare.flightInfos.first?.takeOffTerminal ?? "")
        arriveAirportLabel.text  = (airfare.flightInfos.first?.arriveAirportName ?? "") + (airfare.flightInfos.first?.arriveTerminal ?? "")
        // 若存在中转的情况  到达的位置信息 需要变更
        if airfare.flightInfos.count > 1 {
            arriveDate = Date.init(timeIntervalSince1970:TimeInterval(airfare.flightInfos.first!.arriveDate/1000))
            takeOffDateLabel.text = arriveDate.hour.description + ":" + arriveDate.minute.description //takeOffDate.string(custom: "hh:mm")
            arriveAirportLabel.text  = (airfare.flightInfos[1].arriveAirportName ?? "") + (airfare.flightInfos[1].arriveTerminal ?? "")
        }
        
        var isFlyDay:Bool = false
        
        for element in airfare.flightInfos {
            if element.flyDays > 0 {
                isFlyDay = true
                break
            }
        }
        flyDaysLabel.isHidden = !isFlyDay
        if airfare.flightInfos.first?.mealCode.isEmpty == false {
            mealCodeLabel.text = airfare.flightInfos.first?.mealCode
        }else {
            mealCodeLabel.text = "--"
        }
        if  airfare.flightInfos.first?.craftTypeName.isEmpty == false {
            flightTypeLabel.text = airfare.flightInfos.first?.craftTypeName
        }else {
            flightTypeLabel.text = "--"
        }
        if airfare.flightInfos.first?.craftTypeClassShort.isEmpty == false {
            flightTypeBulkLabel.text = airfare.flightInfos.first?.craftTypeClassShort
        }else {
            flightTypeBulkLabel.text = "--"
        }
        let flightTime:String = airfare.flightInfos.first?.flightTime ?? ""
        let dateCompoment:[String] = flightTime.components(separatedBy: ":")
        if dateCompoment.count > 1 {
            duringTimeLabel.text = "约" + dateCompoment.first! + "小时" + dateCompoment[1] + "分"
        }else {
            duringTimeLabel.text = "--"//(airfare.flightInfos.first?.flightTime)!
        }
        
        
        
        
        
        
        //是否直达
        if airfare.direct {
            stopOverLabel.isHidden = true
            
            //是否经停
            if airfare.flightInfos.first?.stopOver == true {
                stopOverLabel.text = "经停"
                stopOverLabel.isHidden = false
                stopOverCityLabel.isHidden = false
                stopOverCityLabel.text = airfare.flightInfos.first?.stopOverCity
            }else {
                stopOverLabel.isHidden = true
            }
        }else {
            stopOverCityLabel.isHidden = false
            stopOverLabel.isHidden = false
            stopOverLabel.text = "转"
            stopOverCityLabel.text = airfare.transferCity//model.legList.first?.arriveCity
        }
        
    }
    
    
    func fillCell(model: FlightListItem) {
      
        let date = DateInRegion(string: (model.legList.first?.takeOffDate)!, format: .custom("YYYY-MM-dd"), fromRegion: regionRome)!
        airCompanyImage.image = UIImage(named: (model.legList.first?.marketAirlineCode)!)
        flightNameLabel.text = (model.legList.first?.marketAirlineShort)! + (model.legList.first?.marketAirlineCode)! + (model.legList.first?.marketFlightNo)!
        flightDateLabel.text = date.string(custom: "M月d日")
        if searchModel.type == 2 {
            takeOffCityLabel.text = searchModel.arriveAirportName
            arriveCityLabel.text  = searchModel.takeOffAirportName
        }else {
            takeOffCityLabel.text = searchModel.takeOffAirportName
            arriveCityLabel.text  = searchModel.arriveAirportName
        }
        
        takeOffDateLabel.text = model.legList.first?.takeOffTime
        arriveDateLabel.text = model.legList.first?.arriveTime
        takeOffAirportLabel.text = (model.legList.first?.takeOffStnTxt ?? "") + (model.legList.first?.takeOffTerminal ?? "")
        arriveAirportLabel.text  = (model.legList.last?.arriveStnTxt ?? "") + (model.legList.last?.arriveTerminal ?? "")
        craftTypeLabel.text = model.legList.first?.carriageFlightName
        
        //是否直达
        if model.direct {
            stopOverLabel.isHidden = true
            
            //是否经停
            if model.stopOver {
                stopOverLabel.text = "经停"
                stopOverLabel.isHidden = false
                stopOverCityLabel.isHidden = false
            }else {
                stopOverLabel.isHidden = true
            }
        }else {
            stopOverCityLabel.isHidden = false
            stopOverLabel.isHidden = false
            stopOverLabel.text = "转"
            stopOverCityLabel.text = model.legList.first?.arriveCity
        }
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
}

class BusinessFLightSelectCabinsContentCellView: UITableViewCell {
    
    let bgView = UIView()
    var cabinNameLabel = UILabel.init(text: "", color: TBIThemePrimaryTextColor, size: 16)
    var contraryPolicyLabel = UILabel.init(text: "符合", color: TBIThemeWhite, size: 11)
    var protocolLabel = UILabel.init(text: "协议", color: TBIThemeWhite, size: 11)
    var rmbLabel = UILabel.init(text: "￥", color: TBIThemeOrangeColor, size: 13)
    var priceLabel = UILabel.init(text: "", color: TBIThemeOrangeColor, size: 20)
    var amountLabel = UILabel.init(text: "", color: TBIThemeOrangeColor, size: 11)
    var discountLabel = UILabel.init(text: "", color: TBIThemePrimaryTextColor, size: 11)
    var orderButton =  UIButton(title: "预订",titleColor: TBIThemeWhite,titleSize: 16)
    
    var orderButtonView =  UIView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = TBIThemeBaseColor
        self.bgView.backgroundColor = TBIThemeWhite
        self.bgView.layer.cornerRadius = 2
        //orderButton.layer.cornerRadius = 2
        contraryPolicyLabel.layer.masksToBounds = true
        protocolLabel.layer.masksToBounds = true
        contraryPolicyLabel.layer.cornerRadius = 2
        protocolLabel.layer.cornerRadius = 2
        self.addSubview(bgView)
        
        orderButtonView.layer.cornerRadius = 2
        orderButtonView.layer.masksToBounds = true
        
        orderButtonView.layer.borderWidth = 1
        orderButtonView.layer.borderColor = TBIThemeOrangeColor.cgColor
        
        amountLabel.textAlignment = .center
        protocolLabel.textAlignment = .center
        contraryPolicyLabel.textAlignment = .center
        protocolLabel.backgroundColor = TBIThemeBlueColor
        contraryPolicyLabel.backgroundColor = TBIThemeGreenColor
        orderButton.backgroundColor = TBIThemeOrangeColor
        orderButton.setEnlargeEdgeWithTop(15 ,left: 15, bottom: 20, right: 20)
        
        bgView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalToSuperview().offset(-2.5)
            make.top.equalToSuperview().offset(2.5)
        }
        bgView.addSubview(cabinNameLabel)
        bgView.addSubview(contraryPolicyLabel)
        bgView.addSubview(protocolLabel)
        bgView.addSubview(rmbLabel)
        bgView.addSubview(priceLabel)
        //bgView.addSubview(amountLabel)
        bgView.addSubview(discountLabel)
        bgView.addSubview(orderButtonView)
        orderButtonView.addSubview(orderButton)
        orderButtonView.addSubview(amountLabel)
        
        contraryPolicyLabel.snp.makeConstraints { (make) in
            make.left.equalTo(19)
            make.bottom.equalTo(-12)
            make.height.equalTo(20)
            make.width.equalTo(44)
        }
        protocolLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(-12)
            make.left.equalTo(contraryPolicyLabel.snp.right).offset(6)
            make.height.equalTo(20)
            make.width.equalTo(44)
        }
        cabinNameLabel.snp.makeConstraints { (make) in
           make.left.equalTo(19)
           make.top.equalTo(12)
        }
        orderButtonView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-19)
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
            make.height.width.equalTo(42)
        }
        amountLabel.snp.makeConstraints { (make) in
           make.bottom.left.right.equalToSuperview()
            make.height.equalTo(14)
        }
        
        
        orderButton.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(-14)
        }
        priceLabel.snp.makeConstraints { (make) in
            make.right.equalTo(orderButtonView.snp.left).offset(-12)
            make.top.equalTo(orderButtonView.snp.top).offset(6)
            make.height.equalTo(20)
        }
        rmbLabel.snp.makeConstraints { (make) in
            make.right.equalTo(priceLabel.snp.left).offset(-1)
            make.bottom.equalTo(priceLabel.snp.bottom)
        }
        discountLabel.snp.makeConstraints { (make) in
            make.right.equalTo(orderButtonView.snp.left).offset(-12)
            make.bottom.equalTo(orderButtonView.snp.bottom).offset(-6)
            make.height.equalTo(11)
        }
        

    }
    
    func fillCell(model: CoFlightSearchResult.FlightItem.CabinItem?,anOrder:Bool) {
        cabinNameLabel.text =  (model?.cabinTypeText ?? "") + "(\(model?.type ?? ""))"
        priceLabel.text = String(describing: model?.price ?? 0)
        if model?.num == -1 {
            orderButton.snp.updateConstraints { (make) in
                make.bottom.equalToSuperview()
            }
        }else {
            orderButton.snp.updateConstraints { (make) in
                make.bottom.equalTo(-14)
            }
            amountLabel.text =  "余\(model?.num ?? 0)张"
        }
        
        discountLabel.text =  (model?.discount ?? 0) < 10.0 ? String(describing: model?.discount ?? 0) + "折" : "全价"
        
        if model?.contraryPolicy ?? false {
            contraryPolicyLabel.text = "违背"
            contraryPolicyLabel.backgroundColor = TBIThemeRedColor
        }else {
            contraryPolicyLabel.text = "符合"
            contraryPolicyLabel.backgroundColor = TBIThemeGreenColor
        }
        if model?.isProtocol ??  false {
            protocolLabel.isHidden = false
        }else {
            protocolLabel.isHidden = true
        }
        if (model?.contraryPolicy ?? false) && anOrder == false{
            orderButtonView.layer.borderColor = TBIThemePlaceholderTextColor.cgColor
            orderButton.backgroundColor = TBIThemePlaceholderTextColor
        }else {
            orderButtonView.layer.borderColor = TBIThemeOrangeColor.cgColor
            orderButton.backgroundColor = TBIThemeOrangeColor
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func fillDataSources(cabins:FlightSVSearchResultVOModel.CabinVO ,anOrder:Bool) {
        cabinNameLabel.text = cabins.shipping + "\(cabins.code)"  //(model?.cabinTypeText ?? "") + "(\(model?.type ?? ""))"
        priceLabel.text = cabins.price.stringValue
        if cabins.amount == -1 {
            orderButton.snp.updateConstraints { (make) in
                make.bottom.equalToSuperview()
            }
        }else {
            orderButton.snp.updateConstraints { (make) in
                make.bottom.equalTo(-14)
            }
            amountLabel.text =  "余\(cabins.amount )张"
        }
        
        discountLabel.text = cabins.discount.doubleValue < 10.0 ?  cabins.discount.doubleValue.description + "折" : "全价"
        
        if cabins.contraryPolicy ?? false {
            contraryPolicyLabel.text = "违背"
            contraryPolicyLabel.backgroundColor = TBIThemeRedColor
        }else {
            contraryPolicyLabel.text = "符合"
            contraryPolicyLabel.backgroundColor = TBIThemeGreenColor
        }
        if cabins.protocolPrice ??  false {
            protocolLabel.isHidden = false
        }else {
            protocolLabel.isHidden = true
        }
        if (cabins.contraryPolicy ?? false) && anOrder == false{
            orderButtonView.layer.borderColor = TBIThemePlaceholderTextColor.cgColor
            orderButton.backgroundColor = TBIThemePlaceholderTextColor
        }else {
            orderButtonView.layer.borderColor = TBIThemeOrangeColor.cgColor
            orderButton.backgroundColor = TBIThemeOrangeColor
        }
    }
    
   
    
    
}

class PersonalFlightSelectCabinsContentCellView: UITableViewCell {
    
    let bgView = UIView()
    var cabinNameLabel = UILabel.init(text: "", color: TBIThemePrimaryTextColor, size: 16)
    var rmbLabel = UILabel.init(text: "￥", color: TBIThemeOrangeColor, size: 13)
    var priceLabel = UILabel.init(text: "", color: TBIThemeOrangeColor, size: 20)
    var amountLabel = UILabel.init(text: "", color: TBIThemeOrangeColor, size: 11)
    var discountLabel = UILabel.init(text: "", color: TBIThemePrimaryTextColor, size: 11)
    var orderButton =  UIButton(title: "预订",titleColor: TBIThemeWhite,titleSize: 16)
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = TBIThemeBaseColor
        self.bgView.backgroundColor = TBIThemeWhite
        self.bgView.layer.cornerRadius = 2
        orderButton.layer.cornerRadius = 2
        self.addSubview(bgView)
        orderButton.backgroundColor = TBIThemeOrangeColor
        
        bgView.addSubview(cabinNameLabel)
        bgView.addSubview(rmbLabel)
        bgView.addSubview(priceLabel)
        bgView.addSubview(amountLabel)
        bgView.addSubview(discountLabel)
        bgView.addSubview(orderButton)
        
        bgView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().offset(-2.5)
            make.top.equalToSuperview().offset(2.5)
        }
        
        cabinNameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(19)
            make.centerY.equalToSuperview()
        }
        orderButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-19)
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
            make.height.width.equalTo(42)
        }
        priceLabel.snp.makeConstraints { (make) in
            make.right.equalTo(orderButton.snp.left).offset(-12)
            make.top.equalTo(orderButton.snp.top).offset(6)
            make.height.equalTo(20)
        }
        rmbLabel.snp.makeConstraints { (make) in
            make.right.equalTo(priceLabel.snp.left).offset(-1)
            make.bottom.equalTo(priceLabel.snp.bottom)
        }
        discountLabel.snp.makeConstraints { (make) in
            make.right.equalTo(orderButton.snp.left).offset(-12)
            make.bottom.equalTo(orderButton.snp.bottom).offset(-6)
            make.height.equalTo(11)
        }
        amountLabel.snp.makeConstraints { (make) in
            make.right.equalTo(discountLabel.snp.left).offset(-4)
            make.bottom.equalTo(discountLabel.snp.bottom)
            make.height.equalTo(11)
        }
        
        
    }
    
    func fillCell(model: CabinListItem?) {
        cabinNameLabel.text =  model?.cabinTypeText
        priceLabel.text = String(describing: model?.price ?? 0)
        amountLabel.text = model?.num == "A" ? ">9张" : "\(model?.num ?? "0")张"
        discountLabel.text =  String(describing: model?.discount ?? 0) + "折"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
