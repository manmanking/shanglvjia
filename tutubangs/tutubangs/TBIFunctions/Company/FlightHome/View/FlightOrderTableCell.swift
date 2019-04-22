//
//  FlightOrderTableCellViewTableViewCell.swift
//  shop
//
//  Created by TBI on 2017/5/15.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import SwiftDate
//机票订单header
class FlightSelectHeaderTableCell: UITableViewCell {

    let bgView = UIView()
    //航空公司图标
    var airCompanyImage = UIImageView(imageName:"AI")
    
    var typeLabel = UILabel(text: "", color: TBIThemeWhite, size: 11)
    //航空公司名字
    var flightNameLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 13)
    
    //共享标签
    var shareStatusLabel = UILabel.init(text: "", color: TBIThemeShallowBlueColor, size: 12)
    ///实际承运
    var shareAirCompanyImage = UIImageView(imageName:"AI")
    var shareFlightNameLabel = UILabel.init(text: "", color: PersonalThemeMajorTextColor, size: 13)
    //
    var flightDateLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 13)
    //
    var takeOffCityLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 13)
    //
    var arriveCityLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 13)
    //
    var takeOffDateLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 25)
    //
    let arrowImage = UIImageView(imageName: "ic_ari_timeto")
    
    //经停标签
    var stopOverLabel = UILabel(text: "停", color: TBIThemeMinorTextColor, size: 11)
    //经停标签
    private var stopOverCityLabel = UILabel.init(text: "", color: TBIThemeMinorTextColor, size: 11)
    //
    var arriveDateLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 25)
    //
    var takeOffAirportLabel = UILabel(text: "", color: TBIThemeMinorTextColor, size: 12)
    //
    var craftTypeLabel = UILabel(text: "", color: TBIThemeMinorTextColor, size: 12)
    //
    var arriveAirportLabel = UILabel(text: "", color: TBIThemeMinorTextColor, size: 12)
    
    var flyDays = UILabel.init(text: "+1", color: TBIThemePrimaryTextColor, size: 11)
    
    
    //准点率
    //private var mealCodeLabel:UILabel = UILabel.init(text: "--", color: TBIThemeMinorTextColor, size: 11)
    
    private let firstLine:UILabel = UILabel()
    /// 机型编号  有无餐饮
    private var flightTypeLabel:UILabel = UILabel.init(text: "--", color: TBIThemeMinorTextColor, size: 11)
    
    private let secondLine:UILabel = UILabel()
    
    /// 中型机
    private var flightTypeBulkLabel:UILabel = UILabel.init(text: "--", color: TBIThemeMinorTextColor, size: 11)
    
    private let thirdLine:UILabel = UILabel()
    /// 飞行时间
    private var duringTimeLabel:UILabel = UILabel.init(text: "--", color: TBIThemeMinorTextColor, size: 11)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = TBIThemeBaseColor
        self.bgView.backgroundColor = TBIThemeWhite
        self.bgView.layer.cornerRadius = 2
        typeLabel.layer.masksToBounds = true
        typeLabel.layer.cornerRadius = 2
        typeLabel.backgroundColor = TBIThemeShallowBlueColor
        self.addSubview(bgView)
        bgView.addSubview(typeLabel)
        bgView.addSubview(flightNameLabel)
        bgView.addSubview(airCompanyImage)
        bgView.addSubview(flightDateLabel)
        bgView.addSubview(takeOffDateLabel)
        bgView.addSubview(takeOffCityLabel)
        bgView.addSubview(arrowImage)
        bgView.addSubview(stopOverLabel)
        bgView.addSubview(arriveDateLabel)
        bgView.addSubview(flyDays)
        bgView.addSubview(arriveCityLabel)
        bgView.addSubview(takeOffAirportLabel)
        bgView.addSubview(shareFlightNameLabel)
        bgView.addSubview(shareAirCompanyImage)
//        bgView.addSubview(craftTypeLabel)
        bgView.addSubview(arriveAirportLabel)
        stopOverLabel.isHidden = true
        typeLabel.textAlignment = NSTextAlignment.center
        
        bgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalTo(-10)
            make.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(5)
        }
        typeLabel.adjustsFontSizeToFitWidth = true
        typeLabel.snp.makeConstraints{ make in
            make.height.equalTo(16)
            make.left.top.equalTo(13)
        }

        flightDateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(typeLabel.snp.right).offset(6)
            make.top.equalTo(13)
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
        
        bgView.addSubview(shareStatusLabel)
        shareStatusLabel.snp.makeConstraints{ (make) in
            make.left.equalTo(flightDateLabel)
            make.top.equalTo(flightDateLabel.snp.bottom).offset(5)
            make.height.equalTo(12)
        }
        
        ///实际承运航班信息
        shareAirCompanyImage.isHidden = true
        shareAirCompanyImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(shareStatusLabel.snp.centerY)
            make.width.height.equalTo(12)
            make.left.equalTo(shareStatusLabel.snp.right).offset(5)
        }
        shareFlightNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(shareAirCompanyImage.snp.right).offset(5)
            make.centerY.equalTo(shareAirCompanyImage)
        }
        
        arrowImage.snp.makeConstraints { (make) in
            make.width.equalTo(50)
            make.height.equalTo(5)
            make.centerX.equalTo(bgView.snp.centerX)
            make.centerY.equalTo(bgView.snp.bottom).offset(-60)
        }
        
        takeOffDateLabel.snp.makeConstraints { (make) in
            make.right.equalTo(arrowImage.snp.left).offset(-40)
            make.top.equalTo(arrowImage.snp.bottom).offset(-30)
            make.height.equalTo(30)
        }
        arriveDateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(arrowImage.snp.right).offset(40)
            make.top.equalTo(takeOffDateLabel.snp.top)
            make.height.equalTo(30)
        }
        
        flyDays.snp.makeConstraints { (make) in
            make.left.equalTo(arriveDateLabel.snp.right)
            make.bottom.equalTo(arriveDateLabel.snp.top).inset(5)
        }
        
        takeOffCityLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(takeOffDateLabel.snp.top).offset(-2)
            make.centerX.equalTo(takeOffDateLabel.snp.centerX)
        }
        arriveCityLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(arriveDateLabel.snp.centerX)
            make.bottom.equalTo(arriveDateLabel.snp.top).offset(-2)
        }
        
        stopOverLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(arrowImage.snp.centerX)
            make.bottom.equalTo(arrowImage.snp.bottom).offset(-4)
        }
        
        stopOverCityLabel.isHidden = true
        bgView.addSubview(stopOverCityLabel)
        stopOverCityLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(arrowImage.snp.centerX)
            make.top.equalTo(arrowImage.snp.bottom).offset(4)
        }
        takeOffAirportLabel.snp.makeConstraints { (make) in
            make.right.equalTo(takeOffDateLabel)
            make.top.equalTo(takeOffDateLabel.snp.bottom).offset(2)
            //make.bottom.equalToSuperview().offset(-15)
        }
//        craftTypeLabel.snp.makeConstraints { (make) in
//            make.centerX.equalTo(arrowImage.snp.centerX)
//            make.centerY.equalTo(takeOffAirportLabel.snp.centerY)
//            //make.bottom.equalToSuperview().offset(-15)
//        }
        arriveAirportLabel.snp.makeConstraints { (make) in
            make.left.equalTo(arriveDateLabel)
            make.top.equalTo(arriveDateLabel.snp.bottom).offset(2)
            //make.bottom.equalTo(-15)
        }
        
        
//        mealCodeLabel.isHidden = true
//        mealCodeLabel.textAlignment = NSTextAlignment.center
//        bgView.addSubview(mealCodeLabel)
//        mealCodeLabel.snp.remakeConstraints { (make) in
//            make.left.equalToSuperview().inset(15)
//            make.height.equalTo(14)
//            make.width.equalTo((ScreenWindowWidth - 40)/4)
//            make.bottom.equalToSuperview().inset(10)
//        }
        
//        firstLine.isHidden = true
//        firstLine.backgroundColor = TBIThemePlaceholderColor
//        bgView.addSubview(firstLine)
//        firstLine.snp.makeConstraints { (make) in
//            make.left.equalTo(mealCodeLabel.snp.right).offset(2)
//            make.height.equalTo(12)
//            make.centerY.equalTo(mealCodeLabel)
//            make.width.equalTo(1)
//        }
        
        flightTypeLabel.isHidden = true
        flightTypeLabel.textAlignment = NSTextAlignment.center
        bgView.addSubview(flightTypeLabel)
        flightTypeLabel.snp.remakeConstraints { (make) in
            make.left.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(10)
            make.width.equalTo((ScreenWindowWidth - 40)/3)
            make.height.equalTo(14)
        }
        secondLine.isHidden = true
        secondLine.backgroundColor = TBIThemePlaceholderColor
        bgView.addSubview(secondLine)
        secondLine.snp.makeConstraints { (make) in
            make.left.equalTo(flightTypeLabel.snp.right).offset(2)
            make.height.equalTo(12)
            make.centerY.equalTo(flightTypeLabel)
            make.width.equalTo(1)
        }
        
        thirdLine.isHidden = true
        thirdLine.backgroundColor = TBIThemePlaceholderColor
        bgView.addSubview(thirdLine)
        thirdLine.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(12)
            make.bottom.equalToSuperview().inset(10)
            make.width.equalTo(1)
        }
        
        flightTypeBulkLabel.isHidden = true
        flightTypeBulkLabel.textAlignment = NSTextAlignment.center
        bgView.addSubview(flightTypeBulkLabel)
        flightTypeBulkLabel.snp.makeConstraints { (make) in
            make.right.equalTo(thirdLine.snp.left).offset(-2)
            make.bottom.equalToSuperview().inset(10)
            make.width.equalTo((ScreenWindowWidth - 40)/3)
            make.height.equalTo(14)
        }
        
        
         duringTimeLabel.isHidden = true
        duringTimeLabel.textAlignment = NSTextAlignment.center
        bgView.addSubview(duringTimeLabel)
        duringTimeLabel.snp.makeConstraints { (make) in
            make.width.equalTo((ScreenWindowWidth - 40)/3)
            make.bottom.equalToSuperview().inset(10)
            make.height.equalTo(14)
            make.left.equalTo(thirdLine.snp.right).offset(2)
        }
        
    }
    
    func companyFillCell(model: [String:Any],row: Int) {
        let flightInfo = model["flightModel"] as! CoFlightSearchResult.FlightItem.LegItem
        let direct = model["direct"] as! Bool
        let type = model["type"] as! String
        let stopOver = model["stopOver"] as! Bool
        
        let date = DateInRegion(string: flightInfo.takeOffDate, format: .custom("YYYY-MM-dd"), fromRegion: regionRome)!
        
        airCompanyImage.image = UIImage(named: flightInfo.marketAirlineCode)
        flightNameLabel.text = flightInfo.marketAirlineShort + flightInfo.marketAirlineCode + flightInfo.marketFlightNo //flightInfo.marketAirlineShort + flightInfo.marketAirlineCode + flightInfo.marketFlightNo
        flightDateLabel.text = date.string(custom: "M月d日")
        
        takeOffCityLabel.text = flightInfo.takeOffCity //searchModel.takeOffAirportName
        arriveCityLabel.text  = flightInfo.arriveCity //searchModel.arriveAirportName
        takeOffDateLabel.text = flightInfo.takeOffTime
        arriveDateLabel.text =  flightInfo.arriveTime
        takeOffAirportLabel.text = flightInfo.arriveStnTxt + flightInfo.takeOffTerminal
        arriveAirportLabel.text  = flightInfo.arriveStnTxt + flightInfo.arriveTerminal
        craftTypeLabel.text = flightInfo.craftType
        
        //是否直达
        if direct {
            stopOverLabel.isHidden = true
            //是否经停
            if stopOver == false {
                stopOverLabel.text = "经停"
                stopOverLabel.isHidden = false
            }else {
                stopOverLabel.isHidden = true
            }
        }else {
            stopOverLabel.isHidden = false
            stopOverLabel.text = "转"
            
        }

        if type == "返"{
            takeOffCityLabel.text = searchModel.arriveAirportName
            arriveCityLabel.text  = searchModel.takeOffAirportName
        }
        if type != "单"{
            typeLabel.text = type
            typeLabel.isHidden = false
//            airCompanyImage.snp.remakeConstraints { (make) in
//                make.left.equalTo(typeLabel.snp.right).offset(6)
//                make.top.equalTo(15)
//                make.width.height.equalTo(12)
//            }
        }else {
            typeLabel.isHidden = true
//            airCompanyImage.snp.remakeConstraints { (make) in
//                make.left.equalTo(13)
//                make.top.equalTo(15)
//                make.width.height.equalTo(12)
//            }
        }
        if row == 0 {
            bgView.snp.remakeConstraints { (make) in
                make.left.equalToSuperview().offset(10)
                make.right.equalTo(-10)
                make.bottom.equalToSuperview()
                make.top.equalToSuperview().offset(10)
            }
            
        }

    }
    
    // add by manman on 2018-03-27
    //  更换数据结构 start of line
    
    func fillDataSources(flightTrip:FlightSVSearchResultVOModel.AirfareVO,row: NSInteger,tripType:NSInteger) {

        arrowImage.snp.remakeConstraints { (make) in
            make.width.equalTo(50)
            make.height.equalTo(5)
            make.centerX.equalTo(bgView.snp.centerX)
            make.centerY.equalTo(bgView.snp.bottom).offset(-40)
        }
        
        airCompanyImage.image = UIImage(named: (flightTrip.flightInfos.first?.flightCode)!) //.marketAirlineCode
        flightNameLabel.text = (flightTrip.flightInfos.first?.flightShortName)! + (flightTrip.flightInfos.first?.flightCode)! + (flightTrip.flightInfos.first?.flightNo ?? "")!
        let takeOffDate:Date = Date.init(timeIntervalSince1970: TimeInterval((flightTrip.flightInfos.first?.takeOffDate)! / 1000))
        let arriveDate:Date = Date.init(timeIntervalSince1970: TimeInterval((flightTrip.flightInfos.last?.arriveDate)! / 1000))
        flightDateLabel.text = takeOffDate.string(custom: "M月dd日") //date.string(custom: "M月d日")
        takeOffDateLabel.text =  takeOffDate.string(custom: "HH:mm")//flightInfo.takeOffTime
        arriveDateLabel.text =  arriveDate.string(custom:  "HH:mm")
        takeOffAirportLabel.text = flightTrip.flightInfos.first?.takeOffAirportName ?? "" + (flightTrip.flightInfos.first?.takeOffTerminal)!
        //flightInfo.takeOffStnTxt + flightInfo.takeOffTerminal
        arriveAirportLabel.text  = flightTrip.flightInfos.last?.arriveAirportName ?? "" + (flightTrip.flightInfos.last?.arriveTerminal)!
        //flightInfo.arriveStnTxt + flightInfo.arriveTerminal
        craftTypeLabel.text = flightTrip.flightInfos.first?.craftType //flightInfo.craftType
        
        //是否直达
        if flightTrip.direct {
            stopOverLabel.isHidden = true
            //是否经停
            if flightTrip.flightInfos.first?.stopOver == true {
                stopOverLabel.text = "经停"
                stopOverLabel.isHidden = false
            }else {
                stopOverLabel.isHidden = true
            }
        }else {
            stopOverLabel.isHidden = false
            stopOverLabel.text = "转"
            
        }
        
        if flightTrip.flightInfos.first?.flyDays != 0 {
            self.flyDays.isHidden = false
            self.flyDays.text = (flightTrip.flightInfos.first?.flyDays != 0 ?  "+1" : "") + "天"
        }else {
            self.flyDays.isHidden = true
        }

        if row == 0 {
            bgView.snp.remakeConstraints { (make) in
                make.left.equalToSuperview().offset(10)
                make.right.equalTo(-10)
                make.bottom.equalToSuperview()
                make.top.equalToSuperview().offset(10)
            }
            
        }
        
        var titleStr:String = ""
        if tripType == 1 {
            if row == 0 { titleStr = " 去程 " }
            else { titleStr = " 返程 " }
        }
        if tripType == 2 {
            switch row + 1 {
            case 1 :
                titleStr = " 第一程 "
            case 2:
                titleStr = " 第二程 "
            case 3:
                titleStr = " 第三程 "
            case 4:
                titleStr = " 第四程 "
            default:
                break
            }
        }
        if flightTrip.flightInfos.first?.share ?? false == true {
            shareStatusLabel.text = "实际承运"
            shareAirCompanyImage.isHidden = false
            shareAirCompanyImage.image = UIImage(named:(flightTrip.flightInfos.first?.carriageCode)!)
            shareFlightNameLabel.text = (flightTrip.flightInfos.first?.carriageShortName)! + (flightTrip.flightInfos.first?.carriageCode)! + (flightTrip.flightInfos.first?.carriageNo)!
        }
        
        typeLabel.text = titleStr
        if titleStr.isEmpty == false {
            typeLabel.isHidden = false
        }else{
            typeLabel.isHidden = true
//            airCompanyImage.snp.remakeConstraints { (make) in
//                make.centerY.equalTo(flightDateLabel.snp.centerY)
//                make.width.height.equalTo(12)
//                make.left.equalTo(flightDateLabel.snp.right).offset(5)
//            }
        }
    }
    
    
    // end of line
    
    
    
    
    
    
    
    /// 个人 普通 机票
    func personalFlightFillDataSources(flightTripItem:[PCommonFlightSVSearchModel.FlightVO],row: Int) {
        //let flightInfo = FlightLegListItem() //model["flightModel"] as! FlightLegListItem
        let direct = flightTripItem.count>1 ? true : false
       // let type = flightTripItem.first?.craftType //"测试"//model["type"] as! String
        let stopOver = flightTripItem.first?.stopOver
        
        let  takeOffDate:Date = Date.init(timeIntervalSince1970: TimeInterval((flightTripItem.first?.takeOffDate ?? 1)! / 1000))
        let  arriveDate:Date = Date.init(timeIntervalSince1970: TimeInterval(flightTripItem.last?.arriveDate ?? 1) / 1000)
        airCompanyImage.image = UIImage(named: flightTripItem.first?.flightCode ?? "")//flightInfo.marketAirlineCode)
        flightNameLabel.text = (flightTripItem.first?.flightName ?? "") + (flightTripItem.first?.flightCode ?? "") + (flightTripItem.first?.flightNo ?? "")
        flightDateLabel.text = takeOffDate.string(custom: "M月dd日")
        
        takeOffDateLabel.text = takeOffDate.string(custom: "HH:mm")
        arriveDateLabel.text =  arriveDate.string(custom: "HH:mm")
        takeOffAirportLabel.text = "\(flightTripItem.first?.takeOffAirportName ?? "")\(flightTripItem.first?.takeOffTerminal ?? "")"
        arriveAirportLabel.text  = "\(flightTripItem.last?.arriveAirportName ?? "")\(flightTripItem.last?.arriveTerminal ?? "")"
     
        craftTypeLabel.text = flightTripItem.first?.craftType //"东航"//flightInfo.carriageFlightName
        
        if flightTripItem.first?.flyDays != 0 {
            flyDays.isHidden = false
            flyDays.text = (flightTripItem.first?.flyDays != 0 ?  "+1" : "") + "天"
        }else {
            flyDays.isHidden = true
        }
        
        
        if flightTripItem.first?.share ?? false == true {
            shareStatusLabel.text = "实际承运"
            shareAirCompanyImage.isHidden = false
            shareAirCompanyImage.image = UIImage(named:(flightTripItem.first?.carriageCode)!)
            shareFlightNameLabel.text = (flightTripItem.first?.carriageShortName)! + (flightTripItem.first?.carriageCode)! + (flightTripItem.first?.carriageNo)!
        }
        
        displayMealCodeUI()
       // mealCodeLabel.isHidden = false
        //firstLine.isHidden = false
        secondLine.isHidden = false
        thirdLine.isHidden = false
        flightTypeLabel.isHidden = false
        //self.mealCodeLabel.text = "--"
        self.flightTypeLabel.text = (flightTripItem.first?.mealCode.isEmpty)! ? "--":flightTripItem.first?.mealCode
        flightTypeBulkLabel.isHidden = false
        self.flightTypeBulkLabel.text = (flightTripItem.first?.craftTypeClassShort.isEmpty)! ? "--" : flightTripItem.first?.craftTypeClassShort
        duringTimeLabel.isHidden = false
        ///飞行时间
//        let secondFlightTime:String = flightTripItem.last?.flightTime ?? ""
//        let secondDateCompoment:[String] = secondFlightTime.components(separatedBy: ":")
//        if secondDateCompoment.count > 1 {
//            duringTimeLabel.text = "约" + secondDateCompoment.first! + "小时" + secondDateCompoment[1] + "分"
//        }else {
//            duringTimeLabel.text = "--"
//        }
        
        let firstTime = flightTripItem.first?.flightTime ?? ""
        var secondTime = ""//flightTripItem.first?.flightTime
        var thirdTime = flightTripItem.first?.transferTime ?? "" 
        if flightTripItem.count > 0 {
            if flightTripItem.count > 1 {
                secondTime = flightTripItem.last?.flightTime ?? ""
            }
        }
        
        var flightTime = String.caculateFlightTime(first: firstTime, second: secondTime, third: thirdTime)
        if flightTime.isEmpty == false {
            duringTimeLabel.text = flightTime //"约" + secondDateCompoment.first! + "小时" + secondDateCompoment[1] + "分"
        }else {
            duringTimeLabel.text = "--"
        }
        
        
        //是否中转
        if direct {
            stopOverCityLabel.isHidden = false
            stopOverLabel.isHidden = false
            stopOverLabel.text = "转"
            stopOverCityLabel.text = flightTripItem.first?.arriveAirportName
            
            
        }else {
            //是否经停
            if stopOver! {
                stopOverLabel.text = "经停"
                stopOverLabel.isHidden = false
                stopOverCityLabel.isHidden = false
                stopOverCityLabel.text = flightTripItem.first?.stopOverCity
            }else {
                stopOverLabel.isHidden = true
                stopOverCityLabel.isHidden = true
            }
           
        }
        shareStatusLabel.textColor = PersonalThemeNormalColor
        typeLabel.backgroundColor = PersonalThemeNormalColor
        
//        if type == "返"{
//            takeOffCityLabel.text = searchModel.arriveAirportName
//            arriveCityLabel.text  = searchModel.takeOffAirportName
//        }
//        if type != "单"{
//            typeLabel.text = type
//            typeLabel.isHidden = false
//
//        }else {
//            typeLabel.isHidden = true
//            
//        }
        
        if row == 0 {
            bgView.snp.remakeConstraints { (make) in
                make.left.equalToSuperview().offset(10)
                make.right.equalTo(-10)
                make.bottom.equalToSuperview()
                make.top.equalToSuperview().offset(10)
            }

        }
    }
    
    /// 个人 定投 机票
    func personalSpecialFlightFillDataSources(flightTripItem:[PSepcailFlightCabinModel.ResponsesListVo],row: Int) {
        
        var flightInfoArr:[PSepcailFlightCabinModel.Segments] = Array()
        if row == 0 {
            flightInfoArr = flightTripItem.first!.segmentD
        }else{
            flightInfoArr = flightTripItem.first!.segmentR
        }
        
        let direct = flightTripItem.first!.segmentD.count > 1 ? true:false
//        let type = flightTripItem.first?.tripType //"测试"//model["type"] as! String
        let stopOver = (flightTripItem.first!.segmentD.first?.stopAirport.isNotEmpty)! ? true:false
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        
        //let date = Date()//DateInRegion(string: Date(), format: .custom("YYYY-MM-dd"), fromRegion: regionRome)!
        let  takeOffDate:Date = dateFormatter.date(from: flightInfoArr.first?.takeOffTime ?? "2018-08-08 08:08:08")!
            //Date.init(timeIntervalSince1970: TimeInterval(flightInfoArr.first?.takeOffTime ?? 1 / 1000))
        let  arriveDate:Date = dateFormatter.date(from: flightInfoArr.last?.arriveTime ?? "2018-08-08 08:08:08")!
            //Date.init(timeIntervalSince1970: TimeInterval(flightInfoArr.last?.arriveTime ?? 1 / 1000))
        airCompanyImage.image = UIImage(named: flightInfoArr.first?.companyCode ?? "")//flightInfo.marketAirlineCode)
        flightNameLabel.text = (flightInfoArr.first?.company ?? "")  + (flightInfoArr.first?.flightno ?? "")
        flightDateLabel.text = takeOffDate.string(custom: "M月dd日")

        takeOffDateLabel.text = takeOffDate.string(custom: "HH:mm")//"8:00"//flightInfo.takeOffTime
        arriveDateLabel.text =  arriveDate.string(custom: "HH:mm") //"12:00"//flightInfo.arriveTime
        
        takeOffAirportLabel.text = flightInfoArr.first?.departure
        arriveAirportLabel.text  = flightInfoArr.last?.destination
        craftTypeLabel.text = flightInfoArr.first?.crafttypeCH //"东航"//flightInfo.carriageFlightName
        flyDays.isHidden = true


        //是否中转
        if direct {
            stopOverLabel.text = "转"
            stopOverLabel.isHidden = false
            stopOverCityLabel.isHidden = false
            stopOverCityLabel.text = flightTripItem.first!.segmentR.first?.stopAirport
            
        }else {
            //是否经停
            if stopOver {
                stopOverLabel.text = "经停"
                stopOverLabel.isHidden = false
                stopOverCityLabel.isHidden = false
                stopOverCityLabel.text = flightTripItem.first!.segmentR.first?.stopAirport
            }else {
                stopOverLabel.isHidden = true
                stopOverCityLabel.isHidden = true
            }
            
        }

        if row == 0 {
            bgView.snp.remakeConstraints { (make) in
                make.left.equalToSuperview().offset(10)
                make.right.equalTo(-10)
                make.bottom.equalToSuperview()
                make.top.equalToSuperview().offset(10)
            }
            
        }
    
        thirdLine.isHidden = false
        flightTypeBulkLabel.isHidden = false
        flightTypeBulkLabel.text = (flightInfoArr.first?.crafttypeCH.isEmpty)! ? "--" : flightInfoArr.first?.crafttypeCH
        ///飞行时间
        duringTimeLabel.isHidden = false
        duringTimeLabel.text = CommonTool.returnRuntime(flightInfoArr.first?.flightTime)
        
        shareStatusLabel.textColor = PersonalThemeNormalColor
        typeLabel.backgroundColor = PersonalThemeNormalColor
    }
    
    /// 个人 定投 机票 new
    func personalSpecialFlightInfoFillDataSources(flightTripItem:[PersonalSpecialFlightInfoListResponse.BaseFlightAndReturnInfoVo],row: Int) {
        
        var flightInfoArr:[PSepcailFlightCabinModel.Segments] = Array()
        if row == 0 {
            flightInfoArr = flightTripItem.first!.segment
        }else{
            flightInfoArr = flightTripItem.last!.segment
        }
        
        let direct = flightTripItem.first!.segment.count > 1 ? true:false
        //        let type = flightTripItem.first?.tripType //"测试"//model["type"] as! String
        let stopOver = (flightTripItem.first!.segment.first?.stopAirport.isNotEmpty)! ? true:false
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        
        //let date = Date()//DateInRegion(string: Date(), format: .custom("YYYY-MM-dd"), fromRegion: regionRome)!
        let  takeOffDate:Date = dateFormatter.date(from: flightInfoArr.first?.takeOffTime ?? "2018-08-08 08:08:08")!
        //Date.init(timeIntervalSince1970: TimeInterval(flightInfoArr.first?.takeOffTime ?? 1 / 1000))
        let  arriveDate:Date = dateFormatter.date(from: flightInfoArr.last?.arriveTime ?? "2018-08-08 08:08:08")!
        //Date.init(timeIntervalSince1970: TimeInterval(flightInfoArr.last?.arriveTime ?? 1 / 1000))
        airCompanyImage.image = UIImage(named: flightInfoArr.first?.companyCode ?? "")//flightInfo.marketAirlineCode)
        flightNameLabel.text = (flightInfoArr.first?.company ?? "") + (flightInfoArr.first?.flightno ?? "")
        flightDateLabel.text = takeOffDate.string(custom: "M月dd日")
        
        takeOffDateLabel.text = takeOffDate.string(custom: "HH:mm")//"8:00"//flightInfo.takeOffTime
        arriveDateLabel.text =  arriveDate.string(custom: "HH:mm") //"12:00"//flightInfo.arriveTime
        
        takeOffAirportLabel.text = flightInfoArr.first?.departure
        arriveAirportLabel.text  = flightInfoArr.last?.destination
        craftTypeLabel.text = flightInfoArr.first?.crafttypeCH //"东航"//flightInfo.carriageFlightName
        flyDays.isHidden = true
        
        
        //是否中转
        if direct {
            stopOverLabel.text = "转"
            stopOverLabel.isHidden = false
            stopOverCityLabel.isHidden = false
            stopOverCityLabel.text = flightTripItem.last!.segment.first?.stopAirport
            
        }else {
            //是否经停
            if stopOver {
                stopOverLabel.text = "经停"
                stopOverLabel.isHidden = false
                stopOverCityLabel.isHidden = false
                stopOverCityLabel.text = flightTripItem.last!.segment.first?.stopAirport
            }else {
                stopOverLabel.isHidden = true
                stopOverCityLabel.isHidden = true
            }
            
        }
        
        if row == 0 {
            bgView.snp.remakeConstraints { (make) in
                make.left.equalToSuperview().offset(10)
                make.right.equalTo(-10)
                make.bottom.equalToSuperview()
                make.top.equalToSuperview().offset(10)
            }
            
        }
        
        thirdLine.isHidden = false
        flightTypeBulkLabel.isHidden = false
        flightTypeBulkLabel.text = (flightInfoArr.first?.crafttypeCH.isEmpty)! ? "--" : flightInfoArr.first?.crafttypeCH
        ///飞行时间
        duringTimeLabel.isHidden = false
        duringTimeLabel.text = CommonTool.returnRuntime(flightInfoArr.first?.flightTime)
        
        shareStatusLabel.textColor = PersonalThemeNormalColor
        typeLabel.backgroundColor = PersonalThemeNormalColor
    }
    
    
    func displayMealCodeUI(){
       // mealCodeLabel.isHidden = false
        //firstLine.isHidden = false
        flightTypeLabel.isHidden = false
        secondLine.isHidden = false
        flightTypeBulkLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(secondLine.snp.left).offset(2)
            make.bottom.equalToSuperview().inset(10)
            make.width.equalTo((ScreenWindowWidth - 40)/4)
            make.height.equalTo(14)
        }
        thirdLine.snp.remakeConstraints { (make) in
            make.left.equalTo(flightTypeBulkLabel.snp.right).offset(2)
            make.height.equalTo(12)
            make.bottom.equalToSuperview().inset(10)
            make.width.equalTo(1)
        }
        duringTimeLabel.snp.remakeConstraints { (make) in
            make.width.equalTo((ScreenWindowWidth - 40)/4)
            make.bottom.equalToSuperview().inset(10)
            make.height.equalTo(14)
            make.left.equalTo(thirdLine.snp.right).offset(2)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
//选中舱位cell
class FlightSelectCabinTableCell: UITableViewCell {
    
    let typeLabel = UILabel(text: "", color: TBIThemeBlueColor, size: 13)
    
    //舱位
    let cabinNameLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 13)
    
    let priceTitleLabel = UILabel(text: "票价", color: TBIThemePrimaryTextColor, size: 13)
    //票价
    let priceLabel = UILabel(text: "", color: TBIThemeRedColor, size: 13)
    
    let taxTitleLabel = UILabel(text: "机建", color: TBIThemePrimaryTextColor, size: 13)
    //机场建设费
    let taxLabel = UILabel.init(text: "", color: TBIThemeRedColor, size: 13)
    
    let lineLabel = UILabel(color: TBIThemeGrayLineColor)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = TBIThemeWhite
        addSubview(typeLabel)
        addSubview(cabinNameLabel)
        addSubview(priceTitleLabel)
        addSubview(priceLabel)
        addSubview(taxTitleLabel)
        addSubview(taxLabel)
        addSubview(lineLabel)
        typeLabel.snp.makeConstraints{ make in
            make.left.equalTo(23)
            make.centerY.equalToSuperview()
        }
        cabinNameLabel.snp.makeConstraints{ make in
            make.left.equalTo(typeLabel.snp.right)
            make.centerY.equalToSuperview()
        }
        priceTitleLabel.snp.makeConstraints{ make in
            make.centerX.equalToSuperview().offset(-26)
            make.centerY.equalToSuperview()
        }
        priceLabel.snp.makeConstraints{ make in
            make.centerY.equalToSuperview()
            make.left.equalTo(priceTitleLabel.snp.right)
        }
        taxLabel.snp.makeConstraints{ make in
            make.right.equalTo(-23)
            make.centerY.equalToSuperview()
        }
        taxTitleLabel.snp.makeConstraints{ make in
            make.centerY.equalToSuperview()
            make.right.equalTo(taxLabel.snp.left)
        }
        lineLabel.snp.makeConstraints{ make in
            make.left.right.equalTo(0)
            make.height.equalTo(0.5)
            make.bottom.equalToSuperview()
        }
        
    }
    
    func companyFillCell(model: [String:Any]) {
        let type = model["type"] as! String
        let cabin = model["cabinModel"] as! CoFlightSearchResult.FlightItem.CabinItem
        if type != "单程"{
            typeLabel.text = type
            cabinNameLabel.text = "-" + cabin.cabinTypeText
        }else {
            cabinNameLabel.text = cabin.cabinTypeText
        }
        priceLabel.text = "¥" + String(cabin.price)
        taxLabel.text = "¥" + String(cabin.tax)
    }
    
    
    
    func fillDataSources(cabin:FlightSVSearchResultVOModel.CabinVO,tripType:NSInteger,row:NSInteger) {

        typeLabel.text = ""
        cabinNameLabel.text = "-" + cabin.shipping
        priceLabel.text = "¥" + cabin.price.stringValue //String(cabin.price)
        taxLabel.text = "¥" + cabin.tax.stringValue //String(cabin.tax)
        var titleStr:String = ""
        if tripType == 1 {
            if row == 0 { titleStr = " 去程 " }
            else { titleStr = " 返程 " }
        }
        if tripType == 2 {
            switch row + 1 {
            case 1 :
                titleStr = " 第一程 "
            case 2:
                titleStr = " 第二程 "
            case 3:
                titleStr = " 第三程 "
            case 4:
                titleStr = " 第四程 "
            default:
                break
            }
        }
        
        typeLabel.text = titleStr
        if titleStr.isEmpty == false {
            typeLabel.isHidden = false
        }else{
            typeLabel.isHidden = true
            cabinNameLabel.text = cabin.shipping
            cabinNameLabel.snp.remakeConstraints { (make) in
                make.left.equalTo(23)
                make.centerY.equalToSuperview()
            }
        }
        
        
        
        
    }
    
    
    
    
    func fillCell(model: [String:Any]) {
        let type = model["type"] as! String
        let cabin = model["cabinModel"] as! CabinListItem
        if type != "单程"{
            typeLabel.text = type
            cabinNameLabel.text = "-" + cabin.cabinTypeText
        }else {
            cabinNameLabel.text = cabin.cabinTypeText
        }
        priceLabel.text = "¥" + String(cabin.price)
        taxLabel.text = "¥" + String(cabin.tax)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//可点击cell
class FlightClickTableCell: UITableViewCell {
    
    let titleLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 13)
    let rightImg = UIImageView(imageName: "ic_right_gray")
    let rightSwitch = UISwitch()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = TBIThemeWhite
        addSubview(titleLabel)
        addSubview(rightImg)
        addSubview(rightSwitch)
        titleLabel.snp.makeConstraints{ make in
            make.left.equalTo(23)
            make.centerY.equalToSuperview()
        }
        rightImg.snp.makeConstraints{ make in
            make.right.equalTo(-23)
            make.centerY.equalToSuperview()
            make.height.equalTo(14)
            make.width.equalTo(8)
        }
        rightSwitch.snp.makeConstraints{ make in
            make.right.equalTo(-23)
            make.width.equalTo(48)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
        }
        
    }
    //初始化数据
    func fillCell(title: String) {
        titleLabel.text = title
        if title == "报销凭证"{
            rightSwitch.isHidden = false
            rightImg.isHidden = true
        }else {
            rightSwitch.isHidden = true
            rightImg.isHidden = false
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class FlightTextTableCell: UITableViewCell {
    
    let titleLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 13)
    
    //可以编辑label
    let textField = UITextField(placeholder: "",fontSize: 13)

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(titleLabel)
        self.addSubview(textField)
    
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(23)
            make.centerY.equalToSuperview()
        }
        textField.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalTo(-23)
            make.centerY.equalToSuperview()
        }
        
    }
    
    func fillCell(model:[String:String],index: IndexPath) {
        let title = model["title"]
        let text = model["text"]
        let placeholder = model["placeholder"]
        titleLabel.text = title
        textField.placeholder = placeholder
        textField.text = text
        textField.isUserInteractionEnabled = false
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

// text
class FlightContactTableCell: UITableViewCell {
    
    let nameLabel = UILabel(text: "联系人", color: TBIThemePrimaryTextColor, size: 13)
    
    let nameField = UITextField(placeholder: "输入联系人姓名",fontSize: 13)
    
    let phoneLabel = UILabel(text: "手机号码", color: TBIThemePrimaryTextColor, size: 13)
    
    let phoneField = UITextField(placeholder: "输入手机号码",fontSize: 13)
    
    let line = UILabel(color: TBIThemeGrayLineColor)

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(nameLabel)
        addSubview(nameField)
        addSubview(phoneLabel)
        addSubview(phoneField)
        addSubview(line)
        phoneField.keyboardType = UIKeyboardType.numberPad
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(23)
            make.centerY.equalTo(22)
        }
        nameField.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalTo(-23)
            make.centerY.equalTo(22)
        }
        line.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(0.5)
            make.top.equalTo(44)
        }
        phoneLabel.snp.makeConstraints { (make) in
            make.left.equalTo(23)
            make.centerY.equalTo(66)
        }
        phoneField.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalTo(-23)
            make.centerY.equalTo(66)
        }
        
    }
    func fillCell(model:FlightCommitForm.Contact) {
        nameField.text = model.contactName.value
        phoneField.text = model.contactPhone.value
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class FlightInvoiceTableCell: UITableViewCell {
    
    let topLine = UILabel(color: TBIThemeGrayLineColor)
    
    let typeLabel = UILabel(text: "凭证类型", color: TBIThemePrimaryTextColor, size: 13)
    
    let typeTextLabel = UILabel(text: "行程单", color: TBIThemePrimaryTextColor, size: 13)
    
     let typeLine = UILabel(color: TBIThemeGrayLineColor)
    
    let courierLabel = UILabel(text: "配送方式", color: TBIThemePrimaryTextColor, size: 13)
    
    let courierTextLabel = UILabel(text: "快递 ¥10", color: TBIThemePrimaryTextColor, size: 13)
    
     let courierLine = UILabel(color: TBIThemeGrayLineColor)
    
    let nameLabel = UILabel(text: "收件人", color: TBIThemePrimaryTextColor, size: 13)
    
    let nameField = UITextField(placeholder: "输入收件人姓名",fontSize: 13)
    
     let nameLine = UILabel(color: TBIThemeGrayLineColor)
    
    let phoneLabel = UILabel(text: "手机号码", color: TBIThemePrimaryTextColor, size: 13)
    
    let phoneField = UITextField(placeholder: "输入手机号码",fontSize: 13)
    
    let phoneLine = UILabel(color: TBIThemeGrayLineColor)
    
//    let cityLabel = UILabel(text: "所在地区", color: TBIThemePrimaryTextColor, size: 13)
//    
//    let cityField = UITextField(placeholder: "输入所在地区",fontSize: 13)
    
//     let cityLine = UILabel(color: TBIThemeGrayLineColor)
    
    let addressLabel = UILabel(text: "详细地址", color: TBIThemePrimaryTextColor, size: 13)
    
    //let addressField = UITextField(placeholder: "输入详细地址",fontSize: 13)
    
    let addressField = UITextView()
    
    var addressPlaceHolderLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(topLine)
        addSubview(typeLabel)
        addSubview(typeTextLabel)
        addSubview(courierLabel)
        addSubview(courierTextLabel)
        addSubview(nameLabel)
        addSubview(nameField)
        addSubview(phoneLabel)
        addSubview(phoneField)
//        addSubview(cityLabel)
//        addSubview(cityField)
        addSubview(addressLabel)
        addSubview(addressField)
        addSubview(typeLine)
        addSubview(courierLine)
        addSubview(nameLine)
        addSubview(phoneLine)
//        addSubview(cityLine)
        phoneField.keyboardType = UIKeyboardType.numberPad
        topLine.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        typeLine.snp.makeConstraints { (make) in
            make.left.equalTo(23)
            make.right.equalTo(-23)
            make.height.equalTo(0.5)
            make.top.equalTo(44)
        }
        courierLine.snp.makeConstraints { (make) in
            make.left.equalTo(23)
            make.right.equalTo(-23)
            make.height.equalTo(0.5)
            make.top.equalTo(typeLine.snp.bottom).offset(44)
        }
        nameLine.snp.makeConstraints { (make) in
            make.left.equalTo(23)
            make.right.equalTo(-23)
            make.height.equalTo(0.5)
            make.top.equalTo(courierLine.snp.bottom).offset(44)
        }
        phoneLine.snp.makeConstraints { (make) in
            make.left.equalTo(23)
            make.right.equalTo(-23)
            make.height.equalTo(0.5)
            make.top.equalTo(nameLine.snp.bottom).offset(44)
        }
//        cityLine.snp.makeConstraints { (make) in
//            make.left.equalTo(23)
//            make.right.equalTo(-23)
//            make.height.equalTo(1)
//             make.top.equalTo(phoneLine.snp.bottom).offset(44)
//        }
        typeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(23)
            make.centerY.equalTo(22)
        }
        typeTextLabel.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalTo(-23)
            make.centerY.equalTo(22)
        }
        courierLabel.snp.makeConstraints { (make) in
            make.left.equalTo(23)
            make.centerY.equalTo(typeLabel.snp.centerY).offset(44)
        }
        courierTextLabel.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalTo(-23)
            make.centerY.equalTo(typeTextLabel.snp.centerY).offset(44)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(23)
            make.centerY.equalTo(courierLabel.snp.centerY).offset(44)
        }
        nameField.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalTo(-23)
            make.centerY.equalTo(courierTextLabel.snp.centerY).offset(44)
        }
        phoneLabel.snp.makeConstraints { (make) in
            make.left.equalTo(23)
            make.centerY.equalTo(nameLabel.snp.centerY).offset(44)
        }
        phoneField.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.right.equalTo(-23)
            make.centerY.equalTo(nameField.snp.centerY).offset(44)
        }
        
//        cityLabel.snp.makeConstraints { (make) in
//            make.left.equalTo(23)
//            make.centerY.equalTo(phoneLabel.snp.centerY).offset(44)
//        }
//        cityField.snp.makeConstraints { (make) in
//            make.left.equalTo(100)
//            make.right.equalTo(-23)
//            make.centerY.equalTo(phoneField.snp.centerY).offset(44)
//        }
        addressLabel.snp.makeConstraints { (make) in
            make.left.equalTo(23)
            make.centerY.equalTo(phoneLabel.snp.centerY).offset(44)
        }
        addressField.snp.makeConstraints { (make) in
            make.left.equalTo(95)
            make.right.equalTo(-23)
            make.centerY.equalTo(phoneField.snp.centerY).offset(56)
            make.height.greaterThanOrEqualTo(56)
        }
        
        addressField.textColor = TBIThemePrimaryTextColor
        addressField.font = UIFont.systemFont(ofSize: 13)
        addressField.delegate = self
        //设置diyDemandContentTextView的placeHolderText
        addressPlaceHolderLabel = UILabel(text: "输入详细地址", color: TBIThemePlaceholderColor, size: 13)
        addressField.addSubview(addressPlaceHolderLabel)
        addressPlaceHolderLabel.snp.makeConstraints{(make)->Void in
            make.left.equalTo(5)
            make.top.equalTo(8)
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension FlightInvoiceTableCell:UITextViewDelegate
{
    public func textViewDidChange(_ textView: UITextView)
    {
        if (textView.text == nil) || (textView.text == "")
        {
            self.addressPlaceHolderLabel.text = "输入详细地址"
        }
        else
        {
            self.addressPlaceHolderLabel.text = ""
        }
    }
}


// 乘机人信息
class FlightPersonTableCell: UITableViewCell {
    
    let titleLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 13)
    
    let rightImg = UIImageView(imageName: "ic_right_gray")
    
    let nameText = UITextField(placeholder: "选择乘机人",fontSize: 13)
    
    let line = UILabel(color: TBIThemeGrayLineColor)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(titleLabel)
        nameText.isUserInteractionEnabled = false
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(23)
            make.centerY.equalToSuperview()
        }
        addSubview(nameText)
        nameText.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.centerY.equalToSuperview()
        }
        addSubview(rightImg)
        rightImg.snp.makeConstraints { (make) in
            make.right.equalTo(-23)
            make.centerY.equalToSuperview()
        }
        addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    func fillCell(model:TravellerListItem?,index:Int) {
        nameText.text = model?.nameChi
        titleLabel.text = "乘机人\(index)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
