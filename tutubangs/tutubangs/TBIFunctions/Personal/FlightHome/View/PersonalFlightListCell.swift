//
//  PersonalFlightListCell.swift
//  shanglvjia
//
//  Created by tbi on 2018/8/3.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PersonalFlightListCell: UITableViewCell {

    private let bgView = UIView()
    //往返 标志
    var goLabel = UILabel.init(text: "", color: TBIThemeWhite, size: 10)
    //航空公司图标
    private var airCompanyImage = UIImageView(imageName:"BK")
    //航空公司名字
    private var flightNameLabel = UILabel.init(text: "", color: TBIThemeMinorTextColor, size: 13)
    //航班日期
    private var flightDateLabel = UILabel.init(text: "", color: TBIThemeMinorTextColor, size: 13)
    //起飞城市
    private var takeOffCityLabel = UILabel.init(text: "", color: TBIThemePrimaryTextColor, size: 13)
    //到达城市
    private var arriveCityLabel = UILabel.init(text: "", color: TBIThemePrimaryTextColor, size: 13)
    //起飞时间
    private var takeOffDateLabel = UILabel.init(text: "", color: TBIThemePrimaryTextColor, size: 25)
    //共享
    private var flightStatusLabel = UILabel.init(text: "", color: PersonalThemeNormalColor, size: 12)
    //
    private let arrowImage = UIImageView.init(imageName: "ic_ari_timeto")
    //经停标签
    private var stopOverLabel = UILabel.init(text: "经停", color: TBIThemeMinorTextColor, size: 11)
    
    //经停标签
    private var stopOverCityLabel = UILabel.init(text: "", color: TBIThemeMinorTextColor, size: 11)
    //到达时间
    private var arriveDateLabel = UILabel.init(text: "", color: TBIThemePrimaryTextColor, size: 25)
    //起飞机场
    private var takeOffAirportLabel = UILabel.init(text: "", color: TBIThemeMinorTextColor, size: 12)
    //
    private var craftTypeLabel = UILabel.init(text: "", color: TBIThemeMinorTextColor, size: 12)
    //到达机场
    private var arriveAirportLabel = UILabel.init(text: "", color: TBIThemeMinorTextColor, size: 12)
    ///  航程是否隔天 +1天
    private var flyDaysLabel:UILabel = UILabel()
    
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor=TBIThemeWhite
        self.selectionStyle=UITableViewCellSelectionStyle.none
        creatCellUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func creatCellUI() {
        self.backgroundColor = TBIThemeBaseColor
        self.bgView.backgroundColor = TBIThemeWhite
        self.bgView.layer.cornerRadius = 2
        self.addSubview(bgView)
        bgView.addSubview(flightNameLabel)
        bgView.addSubview(airCompanyImage)
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
        bgView.addSubview(goLabel)
        stopOverLabel.isHidden = true
        
        
        bgView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)//-17.5
        }
        
        goLabel.backgroundColor = PersonalThemeNormalColor
        goLabel.layer.cornerRadius = 2.0
        goLabel.clipsToBounds = true
        goLabel.snp.makeConstraints { (make) in
            make.left.equalTo(13)
            make.top.equalTo(13)
            make.height.equalTo(16)
        }
        
        airCompanyImage.snp.makeConstraints { (make) in
            make.left.equalTo(goLabel.snp.right).offset(5)
            make.width.height.equalTo(12)
            make.top.equalToSuperview().offset(15)
        }
        
        flightNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(airCompanyImage.snp.right).offset(3)
            make.centerY.equalTo(airCompanyImage.snp.centerY)
        }
        
        flightStatusLabel.snp.makeConstraints { (make) in
            make.left.equalTo(flightNameLabel.snp.right).offset(2)
            make.centerY.equalTo(flightNameLabel.snp.centerY)
            make.height.equalTo(12)
            
        }
        flightDateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(flightStatusLabel.snp.right).offset(5)
            make.centerY.equalTo(flightNameLabel.snp.centerY)
        }
        
        
        takeOffDateLabel.snp.makeConstraints { (make) in
            make.right.equalTo(arrowImage.snp.left).offset(-40)
            make.top.equalTo(flightNameLabel.snp.bottom).offset(20)
            make.height.equalTo(30)
        }
        arriveDateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(arrowImage.snp.right).offset(40)
            make.top.equalTo(takeOffDateLabel.snp.top)
            make.height.equalTo(30)
        }
        flyDaysLabel.text = "+1天"
        flyDaysLabel.font = UIFont.systemFont(ofSize: 11)
        flyDaysLabel.isHidden=true
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
            make.height.equalTo(5)
            make.centerX.equalTo(bgView.snp.centerX)
            make.centerY.equalTo(takeOffDateLabel.snp.centerY)
        }
        stopOverLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(arrowImage.snp.centerX)
            make.bottom.equalTo(arrowImage.snp.bottom).offset(-5)
        }
        takeOffAirportLabel.numberOfLines = 2
        takeOffAirportLabel.textAlignment = .right
        takeOffAirportLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(takeOffDateLabel.snp.right)
            make.top.equalTo(takeOffDateLabel.snp.bottom).offset(5)
        }
        craftTypeLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(arrowImage.snp.centerX)
            make.bottom.equalToSuperview().offset(-15)
        }
        arriveAirportLabel.numberOfLines = 2
        arriveAirportLabel.snp.makeConstraints { (make) in
            make.left.equalTo(arriveDateLabel.snp.left)
            make.top.equalTo(takeOffAirportLabel.snp.top)
            make.right.equalTo(-15)
        }
        
//                mealCodeLabel.isHidden = true
//                mealCodeLabel.textAlignment = NSTextAlignment.center
//                bgView.addSubview(mealCodeLabel)
//                mealCodeLabel.snp.remakeConstraints { (make) in
//                    make.left.equalToSuperview().inset(15)
//                    make.height.equalTo(14)
//                    make.width.equalTo((ScreenWindowWidth - 40)/4)
//                    make.bottom.equalToSuperview().inset(10)
//                }
        
//                firstLine.isHidden = true
//                firstLine.backgroundColor = TBIThemePlaceholderColor
//                bgView.addSubview(firstLine)
//                firstLine.snp.makeConstraints { (make) in
//                    make.left.equalTo(mealCodeLabel.snp.right).offset(2)
//                    make.height.equalTo(12)
//                    make.centerY.equalTo(mealCodeLabel)
//                    make.width.equalTo(1)
//                }
        
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
        
            thirdLine.backgroundColor = TBIThemePlaceholderColor
            bgView.addSubview(thirdLine)
            thirdLine.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.height.equalTo(12)
                make.bottom.equalToSuperview().inset(10)
                make.width.equalTo(1)
            }
        
        
                flightTypeBulkLabel.textAlignment = NSTextAlignment.center
                bgView.addSubview(flightTypeBulkLabel)
                flightTypeBulkLabel.snp.makeConstraints { (make) in
                    make.right.equalTo(thirdLine.snp.left).offset(-2)
                    make.bottom.equalToSuperview().inset(10)
                    make.width.equalTo((ScreenWindowWidth - 40)/3)
                    make.height.equalTo(14)
                }
        
        
        
                duringTimeLabel.textAlignment = NSTextAlignment.center
                bgView.addSubview(duringTimeLabel)
                duringTimeLabel.snp.makeConstraints { (make) in
                    make.width.equalTo((ScreenWindowWidth - 40)/3)
                     make.bottom.equalToSuperview().inset(10)
                    make.height.equalTo(14)
                    make.left.equalTo(thirdLine.snp.right).offset(2)
                }
        
        
        
        stopOverCityLabel.isHidden = true
        bgView.addSubview(stopOverCityLabel)
        stopOverCityLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(arrowImage.snp.centerX)
            make.top.equalTo(arrowImage.snp.bottom).offset(4)
        }
    }
    /// 定投 航班展示
    func fillDataSources(airfare:PSepcailFlightCabinModel.ResponsesListVo) {
        
        ///有中转
        if airfare.segmentD.count > 1{
            if (airfare.segmentD.first?.takeOffTime.isNotEmpty)!{
                self.takeOffDateLabel.text = CommonTool.returnSubString(airfare.segmentD.first?.takeOffTime, withStart: 11, withLenght: 5)
            }
            if (airfare.segmentD.last?.arriveTime.isNotEmpty)!{
                self.arriveDateLabel.text = CommonTool.returnSubString(airfare.segmentD.last?.arriveTime, withStart: 11, withLenght: 5)
            }
            self.takeOffAirportLabel.text = airfare.segmentD.first?.departure
            self.arriveAirportLabel.text = airfare.segmentD.last?.destination
            
            stopOverLabel.text = "转"
            stopOverLabel.isHidden = false
            stopOverCityLabel.isHidden = false
            stopOverCityLabel.text = airfare.segmentD.first?.stopAirport
            
            self.airCompanyImage.image = UIImage(named: (airfare.segmentD.first?.companyCode)! )
            self.flightNameLabel.text =  (airfare.segmentD.first?.company ?? "") + (airfare.segmentD.first?.companyCode ?? "") + (airfare.segmentD.first?.flightno)!
            
            flightTypeBulkLabel.text = (airfare.segmentD.first?.crafttypeCH.isEmpty)! ? "--" : airfare.segmentD.first?.crafttypeCH
       
        
            
        }else{
            if (airfare.segmentD.first?.takeOffTime.isNotEmpty) ?? false {
                self.takeOffDateLabel.text = CommonTool.returnSubString(airfare.segmentD.first?.takeOffTime, withStart: 11, withLenght: 5)
            }
            if (airfare.segmentD.first?.arriveTime.isNotEmpty) ?? false {
                self.arriveDateLabel.text = CommonTool.returnSubString(airfare.segmentD.first?.arriveTime, withStart: 11, withLenght: 5)
            }
            self.takeOffAirportLabel.text = airfare.segmentD.first?.departure
            self.arriveAirportLabel.text = airfare.segmentD.first?.destination
            
            ///是否经停
            if (airfare.segmentD.first?.stopAirport.isNotEmpty) ?? false{
                stopOverLabel.text = "经停"
                stopOverLabel.isHidden = false
                stopOverCityLabel.isHidden = false
                stopOverCityLabel.text = airfare.segmentD.first?.stopAirport
            }else{
                stopOverLabel.isHidden = true
                stopOverCityLabel.isHidden = true
            }
            
            self.airCompanyImage.image = UIImage(named: (airfare.segmentD.first?.companyCode ?? "" ) )
            self.flightNameLabel.text = (airfare.segmentD.first?.company ?? "") + (airfare.segmentD.first?.companyCode ?? "") + (airfare.segmentD.first?.flightno ?? "")!
            
             flightTypeBulkLabel.text = (airfare.segmentD.first?.crafttypeCH.isEmpty ?? false)! ? "--" : airfare.segmentD.first?.crafttypeCH
        }
        
        flightDateLabel.text = airfare.deaprtureDate
        ///飞行时间
        duringTimeLabel.text = CommonTool.returnRuntime(airfare.segmentD.first?.flightTime)
    }
    
    
    // 定投机票 信息
    public func  fillDataSources(flightInfo:PersonalSpecialFlightInfoListResponse.BaseFlightAndReturnInfoVo){
        ///有中转
        if flightInfo.segment.count > 1{
            if (flightInfo.segment.first?.takeOffTime.isNotEmpty)!{
                self.takeOffDateLabel.text = CommonTool.returnSubString(flightInfo.segment.first?.takeOffTime, withStart: 11, withLenght: 5)
                flightDateLabel.text = CommonTool.returnSubString(flightInfo.segment.first?.takeOffTime, withStart: 0, withLenght: 10)
            }
            if (flightInfo.segment.last?.arriveTime.isNotEmpty)!{
                self.arriveDateLabel.text = CommonTool.returnSubString(flightInfo.segment.last?.arriveTime, withStart: 11, withLenght: 5)
            }
            self.takeOffAirportLabel.text = flightInfo.segment.first?.departure
            self.arriveAirportLabel.text = flightInfo.segment.last?.destination
            
            stopOverLabel.text = "转"
            stopOverLabel.isHidden = false
            stopOverCityLabel.isHidden = false
            stopOverCityLabel.text = flightInfo.segment.first?.stopAirport
            
            self.airCompanyImage.image = UIImage(named: (flightInfo.segment.first?.companyCode)! )
            self.flightNameLabel.text =  (flightInfo.segment.first?.company ?? "") +  (flightInfo.segment.first?.companyCode ?? "") + (flightInfo.segment.first?.flightno)!
            
            flightTypeBulkLabel.text = (flightInfo.segment.first?.crafttypeCH.isEmpty)! ? "--" : flightInfo.segment.first?.crafttypeCH
            
            
            
        }else{
            if (flightInfo.segment.first?.takeOffTime.isNotEmpty) ?? false {
                self.takeOffDateLabel.text = CommonTool.returnSubString(flightInfo.segment.first?.takeOffTime, withStart: 11, withLenght: 5)
                flightDateLabel.text = CommonTool.returnSubString(flightInfo.segment.first?.takeOffTime, withStart: 0, withLenght: 10)
            }
            if (flightInfo.segment.first?.arriveTime.isNotEmpty) ?? false {
                self.arriveDateLabel.text = CommonTool.returnSubString(flightInfo.segment.first?.arriveTime, withStart: 11, withLenght: 5)
            }
            self.takeOffAirportLabel.text = flightInfo.segment.first?.departure
            self.arriveAirportLabel.text = flightInfo.segment.first?.destination
            
            ///是否经停
            if (flightInfo.segment.first?.stopAirport.isNotEmpty) ?? false{
                stopOverLabel.text = "经停"
                stopOverLabel.isHidden = false
                stopOverCityLabel.isHidden = false
                stopOverCityLabel.text = flightInfo.segment.first?.stopAirport
            }else{
                stopOverLabel.isHidden = true
                stopOverCityLabel.isHidden = true
            }
            
            self.airCompanyImage.image = UIImage(named: (flightInfo.segment.first?.companyCode ?? "" ) )
            self.flightNameLabel.text = (flightInfo.segment.first?.company ?? "") + (flightInfo.segment.first?.companyCode ?? "") +  (flightInfo.segment.first?.flightno ?? "")!
            
            flightTypeBulkLabel.text = (flightInfo.segment.first?.crafttypeCH.isEmpty ?? false)! ? "--" : flightInfo.segment.first?.crafttypeCH
        }
        
        var flightTimeSum:NSInteger = 0 //flightInfo.segment.reduce(0){NSInteger($0.flightTime) + NSInteger($1.flightTime)}
        for element in flightInfo.segment {
            flightTimeSum += NSInteger(element.flightTime ?? "0")!
        }
    
        ///飞行时间
        duringTimeLabel.text = CommonTool.returnRuntime(flightTimeSum.description)
    }
    
    
    
    
    
    /// 定投返程 航班展示
    func fillDataSourcesReturnTrip(airfare:PSepcailFlightCabinModel.ResponsesListVo) {
        
        ///有中转
        if airfare.segmentR.count > 1{
            if (airfare.segmentR.first?.takeOffTime.isNotEmpty)!{
                self.takeOffDateLabel.text = CommonTool.returnSubString(airfare.segmentR.first?.takeOffTime, withStart: 11, withLenght: 5)
            }
            if (airfare.segmentR.last?.arriveTime.isNotEmpty)!{
                self.arriveDateLabel.text = CommonTool.returnSubString(airfare.segmentR.last?.arriveTime, withStart: 11, withLenght: 5)
            }
            self.takeOffAirportLabel.text = airfare.segmentR.first?.departure
            self.arriveAirportLabel.text = airfare.segmentR.last?.destination
            
            stopOverLabel.text = "转"
            stopOverLabel.isHidden = false
            stopOverCityLabel.isHidden = false
            stopOverCityLabel.text = airfare.segmentR.first?.stopAirport
            
            self.airCompanyImage.image = UIImage(named: (airfare.segmentR.first?.companyCode)! )
            self.flightNameLabel.text = (airfare.segmentD.first?.company ?? "")  + (airfare.segmentD.first?.companyCode ?? "") + (airfare.segmentR.first?.flightno)!
            
            flightTypeBulkLabel.text = (airfare.segmentR.first?.crafttypeCH.isEmpty)! ? "--" : airfare.segmentR.first?.crafttypeCH
            
        }else{
            if (airfare.segmentR.first?.takeOffTime.isNotEmpty)!{
                self.takeOffDateLabel.text = CommonTool.returnSubString(airfare.segmentR.first?.takeOffTime, withStart: 11, withLenght: 5)
            }
            if (airfare.segmentR.first?.arriveTime.isNotEmpty)!{
                self.arriveDateLabel.text = CommonTool.returnSubString(airfare.segmentR.first?.arriveTime, withStart: 11, withLenght: 5)
            }
            self.takeOffAirportLabel.text = airfare.segmentR.first?.departure
            self.arriveAirportLabel.text = airfare.segmentR.first?.destination
            
            ///是否经停
            if (airfare.segmentR.first?.stopAirport.isNotEmpty)! {
                stopOverLabel.text = "经停"
                stopOverLabel.isHidden = false
                stopOverCityLabel.isHidden = false
                stopOverCityLabel.text = airfare.segmentR.first?.stopAirport
            }else{
                stopOverLabel.isHidden = true
                stopOverCityLabel.isHidden = true
            }
            
            self.airCompanyImage.image = UIImage(named: (airfare.segmentR.first?.companyCode)! )
            self.flightNameLabel.text =  (airfare.segmentR.first?.company ?? "") + (airfare.segmentR.first?.companyCode)! + (airfare.segmentR.first?.flightno)!
            
            flightTypeBulkLabel.text = (airfare.segmentR.first?.crafttypeCH.isEmpty)! ? "--" : airfare.segmentR.first?.crafttypeCH
        }
        flightDateLabel.text = airfare.returnDate
        ///飞行时间
        duringTimeLabel.text = CommonTool.returnRuntime(airfare.segmentR.first?.flightTime)
        
    }
    
    func fillDataSourcesSpecialReturnFlightInfo(airfare:PersonalSpecialFlightInfoListResponse.BaseFlightAndReturnInfoVo) {
        ///有中转
        if airfare.segment.count > 1{
            if (airfare.segment.first?.takeOffTime.isNotEmpty)!{
                self.takeOffDateLabel.text = CommonTool.returnSubString(airfare.segment.first?.takeOffTime, withStart: 11, withLenght: 5)
                flightDateLabel.text = CommonTool.returnSubString(airfare.segment.first?.takeOffTime, withStart: 0, withLenght: 10)
            }
            if (airfare.segment.last?.arriveTime.isNotEmpty)!{
                self.arriveDateLabel.text = CommonTool.returnSubString(airfare.segment.last?.arriveTime, withStart: 11, withLenght: 5)
            }
            self.takeOffAirportLabel.text = airfare.segment.first?.departure
            self.arriveAirportLabel.text = airfare.segment.last?.destination
            
            stopOverLabel.text = "转"
            stopOverLabel.isHidden = false
            stopOverCityLabel.isHidden = false
            stopOverCityLabel.text = airfare.segment.first?.stopAirport
            
            self.airCompanyImage.image = UIImage(named: (airfare.segment.first?.companyCode)! )
            self.flightNameLabel.text = (airfare.segment.first?.company ?? "")  + (airfare.segment.first?.companyCode ?? "") + (airfare.segment.first?.flightno)!
            
            flightTypeBulkLabel.text = (airfare.segment.first?.crafttypeCH.isEmpty)! ? "--" : airfare.segment.first?.crafttypeCH
            
        }else{
            if (airfare.segment.first?.takeOffTime.isNotEmpty)!{
                self.takeOffDateLabel.text = CommonTool.returnSubString(airfare.segment.first?.takeOffTime, withStart: 11, withLenght: 5)
                flightDateLabel.text = CommonTool.returnSubString(airfare.segment.first?.takeOffTime, withStart: 0, withLenght: 10)
            }
            if (airfare.segment.first?.arriveTime.isNotEmpty)!{
                self.arriveDateLabel.text = CommonTool.returnSubString(airfare.segment.first?.arriveTime, withStart: 11, withLenght: 5)
            }
            self.takeOffAirportLabel.text = airfare.segment.first?.departure
            self.arriveAirportLabel.text = airfare.segment.first?.destination
            
            ///是否经停
            if (airfare.segment.first?.stopAirport.isNotEmpty)! {
                stopOverLabel.text = "经停"
                stopOverLabel.isHidden = false
                stopOverCityLabel.isHidden = false
                stopOverCityLabel.text = airfare.segment.first?.stopAirport
            }else{
                stopOverLabel.isHidden = true
                stopOverCityLabel.isHidden = true
            }
            
            self.airCompanyImage.image = UIImage(named: (airfare.segment.first?.companyCode)! )
            self.flightNameLabel.text =  (airfare.segment.first?.company ?? "")  + (airfare.segment.first?.companyCode ?? "") + (airfare.segment.first?.flightno)!
            
            flightTypeBulkLabel.text = (airfare.segment.first?.crafttypeCH.isEmpty)! ? "--" : airfare.segment.first?.crafttypeCH
        }
        var flightTimeSum:NSInteger = 0 //flightInfo.segment.reduce(0){NSInteger($0.flightTime) + NSInteger($1.flightTime)}
        for element in airfare.segment {
            flightTimeSum += NSInteger(element.flightTime ?? "0")!
        }
        
        ///飞行时间
        duringTimeLabel.text = CommonTool.returnRuntime(flightTimeSum.description)
        
        
    }
    
    
    
    
    
    
    
    /// 特价 航班展示
    func fillOnsaleDataSources(airfare:PCommonFlightSVSearchModel.AirfareVO) {
        displayMealCodeUI()
        guard airfare.flightInfos.count > 0 else {
            return
        }
        let takeOffDate:Date = Date.init(timeIntervalSince1970:TimeInterval(airfare.flightInfos.first!.takeOffDate/1000))
        var arriveDate:Date = Date.init(timeIntervalSince1970:TimeInterval(airfare.flightInfos.first!.arriveDate/1000))
        if airfare.flightInfos.count > 1 {
            arriveDate = Date.init(timeIntervalSince1970:TimeInterval(airfare.flightInfos[1].arriveDate/1000))
        }
        
        self.takeOffDateLabel.text = takeOffDate.string(custom: "HH:mm")
        self.takeOffAirportLabel.text = (airfare.flightInfos.first?.takeOffAirportName ?? "" ) + (airfare.flightInfos.first?.takeOffTerminal ?? "")
        self.arriveDateLabel.text = arriveDate.string(custom: "HH:mm")
        self.arriveAirportLabel.text = (airfare.flightInfos.first?.arriveAirportName ?? "") + (airfare.flightInfos.first?.arriveTerminal ?? "")
        if airfare.flightInfos.count > 1 {
            self.arriveAirportLabel.text = (airfare.flightInfos[1].arriveAirportName ) + (airfare.flightInfos[1].arriveTerminal )
        }
        
        
        self.airCompanyImage.image = UIImage(named: airfare.flightInfos.first?.flightCode ?? "")
        self.flightNameLabel.text =  (airfare.flightInfos.first?.flightName ?? "") + (airfare.flightInfos.first?.flightCode)! + (airfare.flightInfos.first?.flightNo ?? "")
        
        self.flightTypeBulkLabel.text = (airfare.flightInfos.first?.craftTypeClassShort.isEmpty)! ? "--" : airfare.flightInfos.first?.craftTypeClassShort
        //self.mealCodeLabel.text = "准点率 100%"
        self.flightTypeLabel.text = (airfare.flightInfos.first?.mealCode.isEmpty)! ? "--":airfare.flightInfos.first?.mealCode
        
        if airfare.flightInfos.first?.flyDays != 0 {
            self.flyDaysLabel.isHidden = false
            self.flyDaysLabel.text = (airfare.flightInfos.first?.flyDays != 0 ?  "+1" : "") + "天"
        }else {
            self.flyDaysLabel.isHidden = true
        }
        
        ///飞行时间
//        let secondFlightTime:String = airfare.flightInfos.last?.flightTime ?? ""
//        let secondDateCompoment:[String] = secondFlightTime.components(separatedBy: ":")
//        if secondDateCompoment.count > 1 {
//            duringTimeLabel.text = "约" + secondDateCompoment.first! + "小时" + secondDateCompoment[1] + "分"
//        }else {
//            duringTimeLabel.text = "--"
//        }
//
        let firstTime = airfare.flightInfos.first?.flightTime ?? ""
        var secondTime = ""//flightTripItem.first?.flightTime
        var thirdTime = airfare.flightInfos.first?.transferTime ?? ""
        if airfare.flightInfos.count > 0 {
            if airfare.flightInfos.count > 1 {
                secondTime = airfare.flightInfos.last?.flightTime ?? ""
            }
        }
        var flightTime = String.caculateFlightTime(first: firstTime, second: secondTime, third: thirdTime)
        if flightTime.isEmpty == false {
            duringTimeLabel.text = flightTime//"约" + secondDateCompoment.first! + "小时" + secondDateCompoment[1] + "分"
        }else {
            duringTimeLabel.text = "--"
        }
        flightDateLabel.text = takeOffDate.string(custom: "yyyy-MM-dd")
        if airfare.flightInfos.count > 1 {
            stopOverCityLabel.isHidden = false
            stopOverLabel.isHidden = false
            stopOverLabel.text = "转"
            stopOverCityLabel.text = airfare.flightInfos.first?.arriveAirportName
        }else {
            
            //是否经停
            if airfare.flightInfos.first?.stopOver == true {
                stopOverLabel.text = "经停"
                stopOverLabel.isHidden = false
                stopOverCityLabel.isHidden = false
                stopOverCityLabel.text = airfare.flightInfos.first?.stopOverCity
            }else{
                stopOverLabel.isHidden = true
                stopOverCityLabel.isHidden = true
            }
            
            
            
        }
        if airfare.flightInfos.first?.share ?? false {
            flightStatusLabel.text = "共享"
            
        }else {
            flightStatusLabel.text = ""
        }
   
       
        
    }
    
    func displayMealCodeUI(){
        //mealCodeLabel.isHidden = false
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

}
