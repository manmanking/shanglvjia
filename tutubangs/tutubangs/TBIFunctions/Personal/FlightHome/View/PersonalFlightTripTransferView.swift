//
//  PersonalFlightTripTransferView.swift
//  shanglvjia
//
//  Created by tbi on 2018/8/7.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PersonalFlightTripTransferView: UITableViewHeaderFooterView {

    private let baseBackgroundView:UIView = UIView()
    
    private let firstFlightTrip:UIImageView = UIImageView()
    
    private let conversFlagFlightTrip:UIImageView = UIImageView()
    
    private let secondFlightTrip:UIImageView = UIImageView()
    
    
    private let takeoffDateLabel:UILabel = UILabel()
    
    private let firstTripTakeoffHourLabel:UILabel = UILabel()
    
    ///中转
    private let firstTransferCityLabel:UILabel = UILabel.init(text: "", color: PersonalThemeMinorTextColor, size: 10)
    
    private let firstTripArriveHourLabel:UILabel = UILabel()
    
    private let firstTripTakeoffAirportLabel:UILabel = UILabel()
    
    private let firstTripArriveAirportLabel:UILabel = UILabel()
    
    private let middleRestHourLabel:UILabel = UILabel()
    
    private let transferCityLabel:UILabel = UILabel()
    
    private let firstTripFlightCompanyLogoImageView:UIImageView = UIImageView()
    
    private let firstTripFlightCompanySHortNameLabel:UILabel = UILabel()
    
    ///实际承运
    private var firstShareAirCompanyImage = UIImageView(imageName:"AI")
    private var firstShareFlightNameLabel = UILabel.init(text: "", color: PersonalThemeMinorTextColor, size: 11)
    
    private let firstTripFlightStatusLabel:UILabel = UILabel()
    
    private let firstTripMeaklCodeLabel:UILabel = UILabel()
//
//    private let firstTripFlightTypeLabel:UILabel = UILabel()
    
    private let firstTripFlightTimeLabel:UILabel = UILabel()
    
    ///中转消息。中转预定须知
    private let transferMessageLabel:UILabel = UILabel()
    
    
    
    private let secondTripTakeoffHourLabel:UILabel = UILabel()
    
    private let secondTripArriveHourLabel:UILabel = UILabel()
    ///中转
    private let secondTransferCityLabel:UILabel = UILabel.init(text: "", color: PersonalThemeMinorTextColor, size: 10)
    
    private let secondTripTakeoffAirportLabel:UILabel = UILabel()
    
    private let secondTripArriveAirportLabel:UILabel = UILabel()
    
    
    private let secondTripFlightCompanyLogoImageView:UIImageView = UIImageView()
    
    private let secondTripFlightCompanySHortNameLabel:UILabel = UILabel()
    
    ///实际承运
    private var secondShareAirCompanyImage = UIImageView(imageName:"AI")
    private var secondShareFlightNameLabel = UILabel.init(text: "", color: PersonalThemeMinorTextColor, size: 11)
    
    private let secondTripFlightStatusLabel:UILabel = UILabel()
    
    private let secondTripMeaklCodeLabel:UILabel = UILabel()

//    private let secondTripFlightTypeLabel:UILabel = UILabel()
    
    private let secondTripFlightTimeLabel:UILabel = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        baseBackgroundView.backgroundColor = TBIThemeWhite
        self.contentView.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        setUIAutoLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUIAutoLayout() {
        
        
        
        takeoffDateLabel.textColor = TBIThemePlaceholderColor
        takeoffDateLabel.font = UIFont.systemFont(ofSize: 12)
        baseBackgroundView.addSubview(takeoffDateLabel)
        takeoffDateLabel.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().inset(15)
            make.width.equalTo(60)
            make.height.equalTo(14)
        }
        
        firstTripTakeoffHourLabel.textColor = TBIThemePrimaryTextColor
        firstTripTakeoffHourLabel.font = UIFont.systemFont(ofSize: 20)
        baseBackgroundView.addSubview(firstTripTakeoffHourLabel)
        firstTripTakeoffHourLabel.snp.makeConstraints { (make) in
            make.top.equalTo(takeoffDateLabel.snp.bottom).offset(19)
            make.left.equalToSuperview().inset(36)
            make.width.equalTo(80)
            make.height.equalTo(20)
        }
        baseBackgroundView.addSubview(firstTransferCityLabel)
        firstTransferCityLabel.snp.makeConstraints { (make) in
            make.top.equalTo(firstTripTakeoffHourLabel.snp.bottom).offset(5)
            make.left.equalToSuperview().inset(36)
        }
        
        firstTripTakeoffAirportLabel.textColor = TBIThemePrimaryTextColor
        //firstTripTakeoffAirportLabel.adjustsFontSizeToFitWidth = true
        firstTripTakeoffAirportLabel.font = UIFont.systemFont(ofSize: 16)
        baseBackgroundView.addSubview(firstTripTakeoffAirportLabel)
        firstTripTakeoffAirportLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(firstTripTakeoffHourLabel)
            make.left.equalTo(firstTripTakeoffHourLabel.snp.right).offset(10)
            make.height.equalTo(16)
            make.width.equalTo(180)
        }
        
        firstTripArriveHourLabel.textColor = TBIThemePrimaryTextColor
        firstTripArriveHourLabel.font = UIFont.systemFont(ofSize: 14)
        baseBackgroundView.addSubview(firstTripArriveHourLabel)
        firstTripArriveHourLabel.snp.makeConstraints { (make) in
            make.top.equalTo(firstTransferCityLabel.snp.bottom).offset(5)
            make.left.equalTo(firstTripTakeoffHourLabel.snp.left)
            make.height.equalTo(13)
            make.width.equalTo(50)
        }
        firstTripArriveAirportLabel.textColor = TBIThemePrimaryTextColor
        //firstTripArriveAirportLabel.adjustsFontSizeToFitWidth = true
        firstTripArriveAirportLabel.font = UIFont.systemFont(ofSize: 12)
        baseBackgroundView.addSubview(firstTripArriveAirportLabel)
        firstTripArriveAirportLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(firstTripArriveHourLabel)
            make.left.equalTo(firstTripTakeoffAirportLabel.snp.left)
            make.height.equalTo(15)
            make.width.equalTo(180)
        }
        
        ///实际承运航班信息
        baseBackgroundView.addSubview(firstShareFlightNameLabel)
        firstShareFlightNameLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(15)
            make.top.equalTo(firstTripTakeoffAirportLabel.snp.top)
        }
        baseBackgroundView.addSubview(firstShareAirCompanyImage)
        firstShareAirCompanyImage.isHidden = true
        firstShareAirCompanyImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(firstShareFlightNameLabel)
            make.width.height.equalTo(12)
            make.right.equalTo(firstShareFlightNameLabel.snp.left).offset(-5)
        }
        
        //第一段 航班状态
        firstTripFlightStatusLabel.textColor = PersonalThemeNormalColor
        firstTripFlightStatusLabel.font = UIFont.systemFont(ofSize: 11)
        baseBackgroundView.addSubview(firstTripFlightStatusLabel)
        firstTripFlightStatusLabel.snp.makeConstraints { (make) in
            make.top.equalTo(firstShareFlightNameLabel.snp.bottom)
            make.right.equalToSuperview().inset(15)
        }
        // 第一段 公司信息
        firstTripFlightCompanySHortNameLabel.textColor = TBIThemeMinorTextColor
        firstTripFlightCompanySHortNameLabel.adjustsFontSizeToFitWidth = true
        firstTripFlightCompanySHortNameLabel.font = UIFont.systemFont(ofSize: 11)
        baseBackgroundView.addSubview(firstTripFlightCompanySHortNameLabel)
        firstTripFlightCompanySHortNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(firstTripFlightStatusLabel.snp.bottom)
            make.right.equalTo(firstTripFlightStatusLabel)
            make.height.equalTo(15)
        }
        
        //第一段 公司logo
        baseBackgroundView.addSubview(firstTripFlightCompanyLogoImageView)
        firstTripFlightCompanyLogoImageView.snp.makeConstraints { (make) in
            make.top.equalTo(firstTripFlightCompanySHortNameLabel.snp.top)
            make.right.equalTo(firstTripFlightCompanySHortNameLabel.snp.left)
            make.height.width.equalTo(14)
        }
        
//        firstTripFlightTypeLabel.textColor = TBIThemeMinorTextColor
//        firstTripFlightTypeLabel.font = UIFont.systemFont(ofSize: 11)
//        firstTripFlightTypeLabel.textAlignment = NSTextAlignment.center
//        baseBackgroundView.addSubview(firstTripFlightTypeLabel)
//        firstTripFlightTypeLabel.snp.makeConstraints { (make) in
//            make.top.equalTo(firstTripFlightCompanySHortNameLabel.snp.bottom).offset(2)
//            make.right.equalToSuperview().inset(15)
//            make.width.equalTo(60)
//            make.height.equalTo(15)
//        }

//        let firstTripFirstLine:UILabel = UILabel()
//        firstTripFirstLine.backgroundColor = TBIThemePlaceholderColor
//        baseBackgroundView.addSubview(firstTripFirstLine)
//        firstTripFirstLine.snp.makeConstraints { (make) in
//            make.right.equalTo(firstTripFlightTypeLabel.snp.left)
//            make.height.equalTo(12)
//            make.centerY.equalTo(firstTripFlightTypeLabel)
//            make.width.equalTo(1)
//        }

        
        firstTripFlightTimeLabel.textColor = TBIThemeMinorTextColor
        firstTripFlightTimeLabel.font = UIFont.systemFont(ofSize: 11)
        firstTripFlightTimeLabel.textAlignment = NSTextAlignment.right
        baseBackgroundView.addSubview(firstTripFlightTimeLabel)
        firstTripFlightTimeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(firstTripFlightCompanySHortNameLabel.snp.bottom).offset(2)
            make.right.equalToSuperview().inset(15)
            make.height.equalTo(15)
            make.width.equalTo(100)
        }
        
        firstTripMeaklCodeLabel.textColor = TBIThemeMinorTextColor
        firstTripMeaklCodeLabel.font = UIFont.systemFont(ofSize: 11)
        firstTripMeaklCodeLabel.textAlignment = NSTextAlignment.right
        baseBackgroundView.addSubview(firstTripMeaklCodeLabel)
        firstTripMeaklCodeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(firstTripFlightTimeLabel.snp.bottom).offset(2)
            make.right.equalToSuperview().inset(15)
            make.width.equalTo(60)
            make.height.equalTo(15)
        }
        
        middleRestHourLabel.textColor = TBIThemeMinorTextColor
        middleRestHourLabel.font = UIFont.systemFont(ofSize: 11)
        middleRestHourLabel.adjustsFontSizeToFitWidth = true
        baseBackgroundView.addSubview(middleRestHourLabel)
        middleRestHourLabel.snp.makeConstraints { (make) in
            make.left.equalTo(firstTripTakeoffHourLabel.snp.left)
            make.top.equalTo(firstTripArriveHourLabel.snp.bottom).offset(18)
            make.height.equalTo(12)
        }
        
        
        firstFlightTrip.image = UIImage.init(named: "ic_air_transfer_first")
        baseBackgroundView.addSubview(firstFlightTrip)
        firstFlightTrip.snp.makeConstraints { (make) in
            make.top.equalTo(firstTripTakeoffHourLabel.snp.centerY)
            make.left.equalToSuperview().inset(15)
            make.width.equalTo(7)
            make.bottom.equalTo(firstTripArriveHourLabel.snp.centerY)
        }
        
        
        conversFlagFlightTrip.image = UIImage.init(named: "ic_air_transfer")
        baseBackgroundView.addSubview(conversFlagFlightTrip)
        conversFlagFlightTrip.snp.makeConstraints { (make) in
            make.centerX.equalTo(firstFlightTrip.snp.centerX)
            make.centerY.equalTo(middleRestHourLabel.snp.centerY)
            make.width.height.equalTo(15)
        }
        
        transferCityLabel.textColor = TBIThemeMinorTextColor
        transferCityLabel.font = UIFont.systemFont(ofSize: 11)
        transferCityLabel.adjustsFontSizeToFitWidth = true
        baseBackgroundView.addSubview(transferCityLabel)
        transferCityLabel.snp.makeConstraints { (make) in
            make.top.equalTo(firstTripArriveAirportLabel.snp.bottom).offset(18)
            make.left.equalTo(firstTripArriveAirportLabel.snp.left)
            make.height.equalTo(11)
        }
        transferMessageLabel.textColor = PersonalThemeNormalColor
        transferMessageLabel.font = UIFont.systemFont(ofSize: 11)
        baseBackgroundView.addSubview(transferMessageLabel)
        transferMessageLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(conversFlagFlightTrip)
            make.right.equalToSuperview().inset(30)
            make.height.equalTo(14)
            
        }
        
        secondTripTakeoffHourLabel.textColor = TBIThemePrimaryTextColor
        secondTripTakeoffHourLabel.font = UIFont.systemFont(ofSize:14)
        baseBackgroundView.addSubview(secondTripTakeoffHourLabel)
        secondTripTakeoffHourLabel.snp.makeConstraints { (make) in
            make.top.equalTo(middleRestHourLabel.snp.bottom).offset(19)
            make.left.equalToSuperview().inset(36)
            make.width.equalTo(80)
            make.height.equalTo(20)
        }
        baseBackgroundView.addSubview(secondTransferCityLabel)
        secondTransferCityLabel.snp.makeConstraints { (make) in
            make.top.equalTo(secondTripTakeoffHourLabel.snp.bottom).offset(5)
            make.left.equalToSuperview().inset(36)
        }
        secondTripTakeoffAirportLabel.textColor = TBIThemePrimaryTextColor
        //secondTripTakeoffAirportLabel.adjustsFontSizeToFitWidth = true
        secondTripTakeoffAirportLabel.font = UIFont.systemFont(ofSize: 12)
        baseBackgroundView.addSubview(secondTripTakeoffAirportLabel)
        secondTripTakeoffAirportLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(secondTripTakeoffHourLabel)
            make.left.equalTo(secondTripTakeoffHourLabel.snp.right).offset(10)
            make.height.equalTo(16)
            make.width.equalTo(180)
        }
        
        secondTripArriveHourLabel.textColor = TBIThemePrimaryTextColor
        secondTripArriveHourLabel.font = UIFont.systemFont(ofSize: 20)
        baseBackgroundView.addSubview(secondTripArriveHourLabel)
        secondTripArriveHourLabel.snp.makeConstraints { (make) in
            make.top.equalTo(secondTransferCityLabel.snp.bottom).offset(8)
            make.left.equalTo(secondTripTakeoffHourLabel.snp.left)
            make.height.equalTo(15)
            make.width.equalTo(80)
        }
        
        secondTripArriveAirportLabel.textColor = TBIThemePrimaryTextColor
        //secondTripArriveAirportLabel.adjustsFontSizeToFitWidth = true
        secondTripArriveAirportLabel.font = UIFont.systemFont(ofSize: 16)
        baseBackgroundView.addSubview(secondTripArriveAirportLabel)
        secondTripArriveAirportLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(secondTripArriveHourLabel)
            make.left.equalTo(secondTripTakeoffAirportLabel.snp.left)
            make.height.equalTo(15)
            make.width.equalTo(180)
            
        }
        ///实际承运航班信息
        baseBackgroundView.addSubview(secondShareFlightNameLabel)
        secondShareFlightNameLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(15)
            make.top.equalTo(secondTripTakeoffAirportLabel.snp.top)
        }
        baseBackgroundView.addSubview(secondShareAirCompanyImage)
        secondShareAirCompanyImage.isHidden = true
        secondShareAirCompanyImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(secondShareFlightNameLabel)
            make.width.height.equalTo(12)
            make.right.equalTo(secondShareFlightNameLabel.snp.left).offset(-5)
        }
        
        // 第二段。航班状态
        secondTripFlightStatusLabel.textColor = PersonalThemeNormalColor
        secondTripFlightStatusLabel.font = UIFont.systemFont(ofSize: 11)
        baseBackgroundView.addSubview(secondTripFlightStatusLabel)
        secondTripFlightStatusLabel.snp.makeConstraints { (make) in
            make.top.equalTo(secondShareFlightNameLabel.snp.bottom)
            make.right.equalToSuperview().inset(15)
        }
        // 第二段 公司信息
        secondTripFlightCompanySHortNameLabel.textColor = TBIThemeMinorTextColor
        secondTripFlightCompanySHortNameLabel.font = UIFont.systemFont(ofSize: 11)
        baseBackgroundView.addSubview(secondTripFlightCompanySHortNameLabel)
        secondTripFlightCompanySHortNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(secondTripFlightStatusLabel.snp.bottom)
            make.right.equalTo(secondTripFlightStatusLabel)
            make.height.equalTo(15)
        }
        
        //第二段 公司logo
        baseBackgroundView.addSubview(secondTripFlightCompanyLogoImageView)
        secondTripFlightCompanyLogoImageView.snp.makeConstraints { (make) in
            make.top.equalTo(secondTripFlightCompanySHortNameLabel.snp.top)
            make.right.equalTo(secondTripFlightCompanySHortNameLabel.snp.left)
            make.height.width.equalTo(14)
        }
        
//        secondTripFlightTypeLabel.textColor = TBIThemeMinorTextColor
//        secondTripFlightTypeLabel.font = UIFont.systemFont(ofSize: 11)
//        secondTripFlightTypeLabel.textAlignment = NSTextAlignment.center
//        baseBackgroundView.addSubview(secondTripFlightTypeLabel)
//        secondTripFlightTypeLabel.snp.makeConstraints { (make) in
//            make.top.equalTo(secondTripFlightCompanySHortNameLabel.snp.bottom).offset(2)
//            make.right.equalToSuperview().inset(15)
//            make.width.equalTo(60)
//            make.height.equalTo(15)
//        }


//        let secondTripFirstLine:UILabel = UILabel()
//        secondTripFirstLine.backgroundColor = TBIThemePlaceholderColor
//        baseBackgroundView.addSubview(secondTripFirstLine)
//        secondTripFirstLine.snp.makeConstraints { (make) in
//            make.right.equalTo(secondTripFlightTypeLabel.snp.left)
//            make.height.equalTo(12)
//            make.centerY.equalTo(secondTripFlightTypeLabel)
//            make.width.equalTo(1)
//        }
        
        
        secondTripFlightTimeLabel.textColor = TBIThemeMinorTextColor
        secondTripFlightTimeLabel.font = UIFont.systemFont(ofSize: 11)
        secondTripFlightTimeLabel.textAlignment = NSTextAlignment.right
        baseBackgroundView.addSubview(secondTripFlightTimeLabel)
        secondTripFlightTimeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(secondTripFlightCompanySHortNameLabel.snp.bottom).offset(2)
            make.right.equalToSuperview().inset(15)
            make.height.equalTo(15)
            make.width.equalTo(100)
        }
        
        secondTripMeaklCodeLabel.textColor = TBIThemeMinorTextColor
        secondTripMeaklCodeLabel.font = UIFont.systemFont(ofSize: 11)
        secondTripMeaklCodeLabel.textAlignment = NSTextAlignment.right
        baseBackgroundView.addSubview(secondTripMeaklCodeLabel)
        secondTripMeaklCodeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(secondTripFlightTimeLabel.snp.bottom).offset(2)
            make.right.equalToSuperview().inset(15)
            make.width.equalTo(60)
            make.height.equalTo(15)
        }
        
        secondFlightTrip.image = UIImage.init(named: "ic_air_transfer_second")
        baseBackgroundView.addSubview(secondFlightTrip)
        secondFlightTrip.snp.makeConstraints { (make) in
            make.top.equalTo(secondTripTakeoffHourLabel.snp.centerY)
            make.left.equalToSuperview().inset(15)
            make.width.equalTo(7)
            make.bottom.equalTo(secondTripArriveHourLabel.snp.centerY)
            
        }
        
        let bottomLine:UILabel  = UILabel()
        bottomLine.backgroundColor = TBIThemeBaseColor
        baseBackgroundView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(5)
        }
    }
    
    func fillDataSources(airfare:PCommonFlightSVSearchModel.AirfareVO) {
        
        let firstTripTakeoffDate:Date = Date.init(timeIntervalSince1970: TimeInterval((airfare.flightInfos.first?.takeOffDate)! / 1000))
        let secondTripTakeoffDate:Date = Date.init(timeIntervalSince1970: TimeInterval((airfare.flightInfos.last?.takeOffDate)! / 1000))
        let firstTripArriveDate:Date = Date.init(timeIntervalSince1970: TimeInterval((airfare.flightInfos.first?.arriveDate)! / 1000))
        let secondTripArriveDate:Date = Date.init(timeIntervalSince1970: TimeInterval((airfare.flightInfos.last?.arriveDate)! / 1000))
        
        
        takeoffDateLabel.text = firstTripTakeoffDate.string(custom: "MM月dd日")
        
        firstTripTakeoffHourLabel.text = firstTripTakeoffDate.string(custom: "HH:mm")
        
        firstTripArriveHourLabel.text = firstTripArriveDate.string(custom: "HH:mm")
        
        firstTripTakeoffAirportLabel.text = (airfare.flightInfos.first?.takeOffAirportName ?? "")
        // + (airfare.flightInfos.first?.takeOffTerminal)!
        
        firstTripArriveAirportLabel.text = (airfare.flightInfos.first?.arriveAirportName ?? "")
        // + (airfare.flightInfos.first?.arriveTerminal ?? "")
        
        
        
        let flightTime:String = airfare.flightInfos.first?.flightTime ?? ""
        let firstDateCompoment:[String] = flightTime.components(separatedBy: ":")
        if firstDateCompoment.count > 1 {
            firstTripFlightTimeLabel.text = "约" + firstDateCompoment.first! + "小时" + firstDateCompoment[1] + "分"
        }else {
            firstTripFlightTimeLabel.text = "--"//(airfare.flightInfos.first?.flightTime)!
        }
        
        let timeInterval:NSInteger =  NSInteger(airfare.transferTime ?? "0")!
        let hour:NSInteger = NSInteger(floor(Double(timeInterval / 60)))
        let min:NSInteger = NSInteger(floor(Double(timeInterval % 60)))
        var restHours:String = ""
        
        if hour > 0 {
            restHours = "停" + hour.description + "小时"
        }
        if hour > 0 && min > 0{
            restHours += min.description + "分"
        }else if hour == 0 && min > 0 {
            restHours = "停" + min.description + "分"
        }
        if restHours.isEmpty == true {
            restHours = ""
        }
        middleRestHourLabel.text = restHours
        
        
        transferCityLabel.text = airfare.transferCity
        
        firstTripFlightCompanyLogoImageView.image = UIImage.init(named: (airfare.flightInfos.first?.flightCode)!)
        
        firstTripFlightCompanySHortNameLabel.text = (airfare.flightInfos.first?.flightShortName ?? "") + (airfare.flightInfos.first?.flightCode ?? "") + (airfare.flightInfos.first?.flightNo ?? "")
        
        if airfare.flightInfos.first?.share ?? false {
            firstTripFlightStatusLabel.isHidden = false
            firstTripFlightStatusLabel.text = "实际承运"
            ///中转消息。中转预定须知
            //transferMessageLabel.text = "中转预订须知"
            firstShareAirCompanyImage.isHidden = false
            firstShareAirCompanyImage.image = UIImage(named:(airfare.flightInfos.first?.carriageCode)!)
            firstShareFlightNameLabel.text = (airfare.flightInfos.first?.carriageShortName)! + (airfare.flightInfos.first?.carriageCode)! + (airfare.flightInfos.first?.carriageNo)!
        }else
        {
            firstTripFlightStatusLabel.isHidden = true
        }
        
        if  airfare.flightInfos.first?.mealCode.isEmpty == false {
            firstTripMeaklCodeLabel.text = airfare.flightInfos.first?.mealCode
        } else {
            firstTripMeaklCodeLabel.text = "--"
        }
//
//        if  airfare.flightInfos.first?.craftTypeClassShort.isEmpty == false {
//            firstTripFlightTypeLabel.text =  airfare.flightInfos.first?.craftTypeClassShort
//        } else {
//            firstTripFlightTypeLabel.text = "--"
//        }
        
       
        takeoffDateLabel.text = firstTripTakeoffDate.string(custom: "MM月dd日")
        
        secondTripTakeoffHourLabel.text = secondTripTakeoffDate.string(custom: "HH:mm")
        
        secondTripArriveHourLabel.text = secondTripArriveDate.string(custom: "HH:mm")
        
        secondTripTakeoffAirportLabel.text = (airfare.flightInfos.last?.takeOffAirportName ?? "")
        //+ (airfare.flightInfos.last?.takeOffTerminal  ?? "")!
        
        secondTripArriveAirportLabel.text = (airfare.flightInfos.last?.arriveAirportName ?? "")
        //+ (airfare.flightInfos.last?.arriveTerminal ?? "")
        
        secondTripFlightCompanyLogoImageView.image = UIImage.init(named: (airfare.flightInfos.last?.flightCode)!)
        
        secondTripFlightCompanySHortNameLabel.text = (airfare.flightInfos.last?.flightShortName ?? "") + (airfare.flightInfos.last?.flightCode ?? "") + (airfare.flightInfos.last?.flightNo ?? "")
        
        let secondFlightTime:String = airfare.flightInfos.last?.flightTime ?? ""
        let secondDateCompoment:[String] = secondFlightTime.components(separatedBy: ":")
        if secondDateCompoment.count > 1 {
            secondTripFlightTimeLabel.text = "约" + secondDateCompoment.first! + "小时" + secondDateCompoment[1] + "分"
        }else {
            secondTripFlightTimeLabel.text = "--"//(airfare.flightInfos.first?.flightTime)!
        }
        
        if airfare.flightInfos.last?.share ?? false {
            secondTripFlightStatusLabel.isHidden = false
            secondTripFlightStatusLabel.text = "实际承运"
            ///中转消息。中转预定须知
            //transferMessageLabel.text = "中转预订须知"
            secondShareAirCompanyImage.isHidden = false
            secondShareAirCompanyImage.image = UIImage(named:(airfare.flightInfos.last?.carriageCode)!)
            secondShareFlightNameLabel.text = (airfare.flightInfos.last?.carriageShortName)! + (airfare.flightInfos.last?.carriageCode)! + (airfare.flightInfos.last?.carriageNo)!
        }else
        {
            secondTripFlightStatusLabel.isHidden = true
        }
        
        if airfare.flightInfos.last?.mealCode.isEmpty == false {
            secondTripMeaklCodeLabel.text = airfare.flightInfos.last?.mealCode
        } else {
            secondTripMeaklCodeLabel.text = "--"
        }

//        if  airfare.flightInfos.last?.craftTypeClassShort.isEmpty == false {
//            secondTripFlightTypeLabel.text = airfare.flightInfos.last?.craftTypeClassShort
//        } else {
//            secondTripFlightTypeLabel.text = "--"
//        }
        if airfare.flightInfos.first?.stopOver == true{
            firstTransferCityLabel.text = "经停" + (airfare.flightInfos.first?.stopOverCity)!
        }
        if airfare.flightInfos.last?.stopOver == true{
            secondTransferCityLabel.text = "经停" + (airfare.flightInfos.last?.stopOverCity)!
        }
    }

}
