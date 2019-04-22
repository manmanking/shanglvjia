//
//  FlightOrderDetailsItemCell.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/6/21.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import SwiftDate

//机票订单header
class FlightOrderDetailsItemCell: UITableViewCell {
    
    let bottomSegLine = UIView()
    let topRightCabinNameLabel = UILabel(text: "经济舱", color: TBIThemePrimaryTextColor, size: 13)
    
    
    
    //*************
    let bgView = UIView()
    //航空公司图标
    var airCompanyImage = UIImageView(imageName:"AI")
    
    var typeLabel = UILabel(text: "去", color: TBIThemeWhite, size: 11)
    //航空公司名字
    var flightNameLabel = UILabel(text: "厦航MF8460", color: TBIThemePrimaryTextColor, size: 13)
    //
    var flightDateLabel = UILabel(text: "4月6日", color: TBIThemePrimaryTextColor, size: 13)
    //
    var takeOffCityLabel = UILabel(text: "重庆", color: TBIThemePrimaryTextColor, size: 13)
    //
    var arriveCityLabel = UILabel(text: "天津", color: TBIThemePrimaryTextColor, size: 13)
    //
    var takeOffDateLabel = UILabel(text: "13:40", color: TBIThemePrimaryTextColor, size: 30)
    //
    let arrowImage = UIImageView(imageName: "ic_ari_timeto")
    //经停标签
    var stopOverLabel = UILabel(text: "经停", color: TBIThemeBlueColor, size: 11)
    //
    var arriveDateLabel = UILabel(text: "18:05", color: TBIThemePrimaryTextColor, size: 30)
    //
    var takeOffAirportLabel = UILabel(text: "江北国际机场✈️T2", color: TBIThemeMinorTextColor, size: 12)
    //
    var craftTypeLabel = UILabel(text: "波音738", color: TBIThemeMinorTextColor, size: 12)
    //
    var arriveAirportLabel = UILabel(text: "滨海国际机场T2", color: TBIThemeMinorTextColor, size: 12)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //self.backgroundColor = TBIThemeBaseColor
        self.backgroundColor = .white
        self.bgView.backgroundColor = TBIThemeWhite
        self.bgView.layer.cornerRadius = 2
        typeLabel.layer.masksToBounds = true
        typeLabel.layer.cornerRadius = 2
        typeLabel.backgroundColor = TBIThemeBlueColor
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
        bgView.addSubview(arriveCityLabel)
        bgView.addSubview(takeOffAirportLabel)
        bgView.addSubview(craftTypeLabel)
        bgView.addSubview(arriveAirportLabel)
        stopOverLabel.isHidden = true
        typeLabel.isHidden = true
        typeLabel.textAlignment = NSTextAlignment.center
        
        bgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalTo(-10)
            make.bottom.equalToSuperview()
            
            make.top.equalToSuperview().offset(2)
        }
        typeLabel.snp.makeConstraints{ make in
            make.height.width.equalTo(16)
            make.left.top.equalTo(13)
        }
        airCompanyImage.snp.makeConstraints { (make) in
            make.top.equalTo(13)
            make.width.height.equalTo(12)
            
            make.left.equalTo(typeLabel.snp.right).offset(6)
        }
        
        
        flightNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(airCompanyImage.snp.right).offset(3)
            make.top.equalToSuperview().offset(13)
        }
        
        flightDateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(flightNameLabel.snp.right).offset(12)
            make.centerY.equalTo(flightNameLabel.snp.centerY)
        }
        
        takeOffDateLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(35)
            make.top.equalTo(flightNameLabel.snp.bottom).offset(32)
            make.height.equalTo(30)
        }
        arriveDateLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-35)
            make.top.equalTo(flightNameLabel.snp.bottom).offset(32)
            make.height.equalTo(30)
        }
        
        takeOffCityLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(takeOffDateLabel.snp.top).offset(-7)
            make.centerX.equalTo(takeOffDateLabel.snp.centerX)
        }
        arriveCityLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(arriveDateLabel.snp.centerX)
            make.bottom.equalTo(arriveDateLabel.snp.top).offset(-7)
        }
        
        
        arrowImage.snp.makeConstraints { (make) in
            make.width.equalTo(34)
            make.height.equalTo(6)
            make.centerX.equalTo(bgView.snp.centerX)
            make.centerY.equalTo(takeOffDateLabel.snp.centerY)
        }
        stopOverLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(arrowImage.snp.centerX)
            make.bottom.equalTo(arrowImage.snp.bottom).offset(-4)
        }
        
        
        takeOffAirportLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(35)
            make.bottom.equalToSuperview().offset(-15)
        }
        craftTypeLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(arrowImage.snp.centerX)
            make.bottom.equalToSuperview().offset(-15)
        }
        arriveAirportLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-35)
            make.bottom.equalTo(-15)
        }
        
        //******************
        //在底部添加分割线
        bottomSegLine.backgroundColor = TBIThemeGrayLineColor
        bgView.addSubview(bottomSegLine)
        bottomSegLine.snp.makeConstraints{(make)->Void in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalToSuperview()
            
            make.height.equalTo(1)
        }
        
        //头部右侧的仓位名称
        bgView.addSubview(topRightCabinNameLabel)
        topRightCabinNameLabel.snp.makeConstraints{(make)->Void in
            make.left.equalTo(flightDateLabel.snp.right).offset(12)
            make.top.equalTo(flightDateLabel.snp.top)
        }
    }
    
    func companyFillCell(model: [String:Any],row: Int) {
        let flightInfo = model["flightModel"] as! CoFlightSearchResult.FlightItem.LegItem
        let direct = model["direct"] as! Bool
        let type = model["type"] as! String
        
        let date = DateInRegion(string: flightInfo.takeOffDate, format: .custom("YYYY-MM-dd"), fromRegion: regionRome)!
        
        airCompanyImage.image = UIImage(named: flightInfo.marketAirlineCode)
        flightNameLabel.text = flightInfo.marketAirlineCode + flightInfo.marketFlightNo //flightInfo.marketAirlineShort + flightInfo.marketAirlineCode + flightInfo.marketFlightNo
        flightDateLabel.text = date.string(custom: "M月d日")
        
        takeOffCityLabel.text = searchModel.takeOffAirportName
        arriveCityLabel.text  = searchModel.arriveAirportName
        takeOffDateLabel.text = flightInfo.takeOffTime
        arriveDateLabel.text =  flightInfo.arriveTime
        takeOffAirportLabel.text = flightInfo.takeOffStnTxt + flightInfo.takeOffTerminal
        arriveAirportLabel.text  = flightInfo.arriveStnTxt + flightInfo.arriveTerminal
        craftTypeLabel.text = flightInfo.carriageFlightName
        
        if direct {
            stopOverLabel.isHidden = true
        }else {
            stopOverLabel.isHidden = false
        }
        if type != "单"{
            typeLabel.text = type
            typeLabel.isHidden = false
            airCompanyImage.snp.remakeConstraints { (make) in
                make.left.equalTo(typeLabel.snp.right).offset(6)
                make.top.equalTo(15)
                make.width.height.equalTo(12)
            }
        }else {
            typeLabel.isHidden = true
            airCompanyImage.snp.remakeConstraints { (make) in
                make.left.equalTo(13)
                make.top.equalTo(15)
                make.width.height.equalTo(12)
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
        
    }
    
    
    func fillCell(model: [String:Any],row: Int) {
        let flightInfo = model["flightModel"] as! FlightLegListItem
        let direct = model["direct"] as! Bool
        let type = model["type"] as! String
        
        let date = DateInRegion(string: flightInfo.takeOffDate, format: .custom("YYYY-MM-dd"), fromRegion: regionRome)!
        
        airCompanyImage.image = UIImage(named: flightInfo.marketAirlineCode)
        flightNameLabel.text = flightInfo.marketAirlineShort + flightInfo.marketAirlineCode + flightInfo.marketFlightNo
        flightDateLabel.text = date.string(custom: "M月d日")
        
        takeOffCityLabel.text = searchModel.takeOffAirportName
        arriveCityLabel.text  = searchModel.arriveAirportName
        takeOffDateLabel.text = flightInfo.takeOffTime
        arriveDateLabel.text =  flightInfo.arriveTime
        takeOffAirportLabel.text = flightInfo.takeOffStnTxt + flightInfo.takeOffTerminal
        arriveAirportLabel.text  = flightInfo.arriveStnTxt + flightInfo.arriveTerminal
        craftTypeLabel.text = flightInfo.carriageFlightName
        
        if direct {
            stopOverLabel.isHidden = true
        }else {
            stopOverLabel.isHidden = false
        }
        if type != "单"{
            typeLabel.text = type
            typeLabel.isHidden = false
            airCompanyImage.snp.remakeConstraints { (make) in
                make.left.equalTo(typeLabel.snp.right).offset(6)
                make.top.equalTo(15)
                make.width.height.equalTo(12)
            }
        }else {
            typeLabel.isHidden = true
            airCompanyImage.snp.remakeConstraints { (make) in
                make.left.equalTo(13)
                make.top.equalTo(15)
                make.width.height.equalTo(12)
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
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
