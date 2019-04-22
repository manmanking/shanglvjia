//
//  JourneyTableViewCell.swift
//  shop
//
//  Created by TBI on 2017/6/15.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import SwiftDate

class JourneyTableViewCell: UITableViewCell {
    
    let typeLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 13)
    
    let dateLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 13)
    
    let typeLine = UILabel(color: TBIThemePrimaryTextColor)
    
    let daysLabel = UILabel(text: "", color: TBIThemeBlueColor, size: 13)
    
    let topLine = UILabel(color: TBIThemeGrayLineColor)
    
    let startDate  = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 20)
    
    let endDate    = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 20)
    
    let startLabel = UILabel(text: "", color: TBIThemeMinorTextColor, size: 13)
    
    let endLabel   = UILabel(text: "", color: TBIThemeMinorTextColor, size: 13)
    
    let  img = UIImageView(imageName: "Common_Right_Arrow_Circle_Gray")
    
    let buttomLine = UILabel(color: TBIThemeGrayLineColor)
    
    let buttomWithLine = UILabel(color: TBIThemeBaseColor)
    
    let nameLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 13)

    let detailButton = UIButton.init(title: "行程详情", titleColor: TBIThemeOrangeColor, titleSize: 12)
    
    //个人行程数据填充
    func fillCell(model:MyTripListResponse?) {
        typeLabel.text = model?.commodityName
        daysLabel.text = model?.head
        startDate.text = model?.orderTitle1
        endDate.text = model?.orderTitle2
        startLabel.text = model?.orderDescribe1
        endLabel.text = model?.orderDescribe2
        nameLabel.text = model?.foot
        
    }
    //企业行程数据填充
    func fillCell(model:CompanyJourneyResult?) {
        img.isHidden = false
        switch (model?.type ?? 0) {
        case 1:
            typeLabel.text = "机票"
            startDate.text = (model?.flight.departureDate.string(custom: "HH:mm") ?? "") + "起飞"
            endDate.text = (model?.flight.arriveDate.string(custom: "HH:mm") ?? "") + "到达"
            startLabel.text = model?.flight.departureAirport
            endLabel.text = model?.flight.arriveAirport
            nameLabel.text = (model?.flight.companyName ?? "") + (model?.flight.flightNo ?? "")
        case 2:
            typeLabel.text = "酒店"
            startDate.text = (model?.hotel.arriveDate.string(custom: "M月d日") ?? "")
            endDate.text = (model?.hotel.leaveDate.string(custom: "M月d日") ?? "")
            startLabel.text = "办理入住"
            endLabel.text = "办理离店"
            nameLabel.text = model?.hotel.hotelName
        case 3:
            typeLabel.text = "火车票"
            startDate.text = (model?.train.startTime.string(custom: "HH:mm") ?? "") + "出发"
            endDate.text = (model?.train.endTime.string(custom: "HH:mm") ?? "")  + "到达"
            startLabel.text = model?.train.fromStationNameCn
            endLabel.text =   model?.train.toStationNameCn
            nameLabel.text =  model?.train.checi
        case 4:
            img.isHidden = true
            typeLabel.text = "专车"
            startDate.text = (model?.car.startTime.string(custom: "HH:mm") ?? "") + "出发"
            endDate.text = model?.car.orderType.description
            startLabel.text = "出发地\n目的地"
            endLabel.text =   (model?.car.startAddress ?? "") + "\n" + (model?.car.endAddress ?? "")
            nameLabel.text =  model?.car.carType == "1" ? "五人座公务用车":"七人座商务用车"
        default:
            break
        }
        let travelData = model?.travelData ?? DateInRegion()
        let day = (travelData.timeIntervalSinceReferenceDate - DateInRegion().timeIntervalSinceReferenceDate ).in(.day)
        daysLabel.text = "距出行还有\(day ?? 0)天"
        dateLabel.text = model?.travelData.string(custom: "M月d日")
    }

    //企业行程数据填充
    func fillDataSources(model:PersonalJourneyListResponse.PersonalJourneyInfo) {
        
        
        
        img.isHidden = false
        switch model.type {
        case 1:
            
            let departureDate:Date = Date.init(timeIntervalSince1970: TimeInterval((model.airInfo?.departureDate)!))
            let arriveDate:Date = Date.init(timeIntervalSince1970: TimeInterval((model.airInfo?.arriveDate)!))
            
            typeLabel.text = "机票"
            startDate.text = departureDate.string(custom: "HH:mm") + "起飞"
            endDate.text = arriveDate.string(custom: "HH:mm") + "到达"
            startLabel.text = model.airInfo?.departureAirport
            endLabel.text = model.airInfo?.arriveAirport
            nameLabel.text = (model.airInfo?.companyName ?? "") + (model.airInfo?.flightNo ?? "")
        case 2:
            
            let arriveDate:Date = Date.init(timeIntervalSince1970: TimeInterval((model.hotelInfo?.arriveDate)!))
            let leaveDate:Date = Date.init(timeIntervalSince1970: TimeInterval((model.hotelInfo?.leaveDate)!))
            
            typeLabel.text = "酒店"
            startDate.text = arriveDate.string(custom: "M月d日")
            endDate.text = leaveDate.string(custom: "M月d日")
            startLabel.text = "办理入住"
            endLabel.text = "办理离店"
            nameLabel.text = model.hotelInfo?.hotelName
        case 3:
            let startTime:Date = Date.init(timeIntervalSince1970: TimeInterval((model.trainInfo?.startTime)!))
            let endTime:Date = Date.init(timeIntervalSince1970: TimeInterval((model.trainInfo?.endTime)!))
            typeLabel.text = "火车票"
            startDate.text = startTime.string(custom: "HH:mm") + "出发"
            endDate.text = endTime.string(custom: "HH:mm")  + "到达"
            startLabel.text = model.trainInfo?.fromStationNameCn
            endLabel.text =   model.trainInfo?.toStationNameCn
            nameLabel.text =  model.trainInfo?.checi
        case 4:
            img.isHidden = true
            let startTime:Date = Date.init(timeIntervalSince1970: TimeInterval((model.carInfo?.startTime)!))
            typeLabel.text = "专车"
            startDate.text = startTime.string(custom: "HH:mm") + "出发"
           
            var orderTypeStr:String = "" //用车类型：1.接机；2.送机；3.预约用车
            switch model.carInfo?.orderType {
            case 1?:
                orderTypeStr = "接机"
            case 2?:
                orderTypeStr = "送机"
            case 99?:
                orderTypeStr = "预约用车"
            default:
                break
            }
            //dataSource.append(("用车类型",))
             endDate.text = orderTypeStr//model.carInfo?.orderType.description
            startLabel.text = "出发地\n目的地"
            endLabel.text =   (model.carInfo?.startAddress ?? "") + "\n" + (model.carInfo?.endAddress ?? "")
            nameLabel.text =  model.carInfo?.carType == "1" ? "五人座公务用车":"七人座商务用车"
        default:
            break
        }
        
        let travelDate:Date = Date.init(timeIntervalSince1970:TimeInterval(model.travelData))
        let currentDate:Date = Date()
        //let day = (travelDate.timeIntervalSinceReferenceDate - DateInRegion().timeIntervalSinceReferenceDate ).in(.day)
        let dayTimeInterval = (travelDate.startOfDay - currentDate.startOfDay)
        let day:NSNumber = NSNumber.init(value:dayTimeInterval / (24 * 60 * 60))
        
        daysLabel.text = "距出行还有\(day.stringValue)天"
        dateLabel.text = travelDate.string(custom: "M月d日")
    }
    
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        detailButton.isUserInteractionEnabled = false
        addSubview(typeLabel)
        typeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(12.5)
        }
        addSubview(typeLine)
        typeLine.snp.makeConstraints { (make) in
            make.left.equalTo(typeLabel.snp.right).offset(10)
            make.height.equalTo(13)
            make.width.equalTo(0.5)
            make.top.equalTo(14)
        }
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(typeLine.snp.right).offset(10)
            make.top.equalTo(12.5)
        }
        addSubview(daysLabel)
        daysLabel.snp.makeConstraints { (make) in
            make.top.equalTo(12.5)
            make.right.equalTo(-15)
            
        }
        addSubview(topLine)
        topLine.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(0.5)
            make.top.equalTo(typeLine.snp.bottom).offset(12.5)
        }
        addSubview(startDate)
        startDate.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(topLine.snp.bottom).offset(25)
        }
        addSubview(endDate)
        endDate.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.top.equalTo(topLine.snp.bottom).offset(25)
        }
        startLabel.numberOfLines = 0
        addSubview(startLabel)
        startLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(startDate.snp.bottom).offset(5)
        }
        endLabel.numberOfLines = 0
        endLabel.textAlignment = .right
        addSubview(endLabel)
        endLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.top.equalTo(endDate.snp.bottom).offset(5)
        }
        addSubview(img)
        img.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        addSubview(buttomLine)
        buttomLine.snp.makeConstraints { (make) in
            make.top.equalTo(startLabel.snp.bottom).offset(25)
            make.height.equalTo(0.5)
            make.left.right.equalToSuperview().inset(15)
        }
        addSubview(detailButton)
        detailButton.snp.makeConstraints { (make) in
            make.top.equalTo(buttomLine.snp.bottom).offset(6.75)
            make.right.equalTo(buttomLine.snp.right)
            make.width.equalTo(78)
            make.height.equalTo(30)
        }
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalTo(detailButton.snp.centerY)
        }
        detailButton.layer.cornerRadius = 3
        detailButton.layer.borderColor = TBIThemeOrangeColor.cgColor
        detailButton.layer.borderWidth = 1

        addSubview(buttomWithLine)
        buttomWithLine.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.height.equalTo(5)
            make.left.right.equalToSuperview()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


class JourneyTravelTableViewCell: UITableViewCell {
    
    let typeLabel = UILabel(text: "机票行程", color: TBIThemePrimaryTextColor, size: 13)
    
    let dateLabel = UILabel(text: "2017年10月11日", color: TBIThemePrimaryTextColor, size: 13)
    
    let typeLine = UILabel(color: TBIThemePrimaryTextColor)
    
    let daysLabel = UILabel(text: "距出行还有6天", color: TBIThemeBlueColor, size: 13)
    
    let topLine = UILabel(color: TBIThemeGrayLineColor)
    
    let titleLabel  = UILabel(text: "06月20日天津出发,厦门跟团游", color: TBIThemePrimaryTextColor, size: 20)
    
    let describeLabel   = UILabel(text: "厦门-鼓浪屿-云水土楼双飞5日游 0购物0自费", color: TBIThemeMinorTextColor, size: 13)
    
    let buttomLine = UILabel(color: TBIThemeGrayLineColor)
    
    let buttomWithLine = UILabel(color: TBIThemeGrayLineColor)
    
    let nameLabel = UILabel(text: "北京城市快捷酒店", color: TBIThemePrimaryTextColor, size: 13)
    
    let detailButton = UIButton.init(title: "行程详情", titleColor: TBIThemeOrangeColor, titleSize: 12)
    
    
    
    //个人行程数据填充
    func fillCell(model:MyTripListResponse?) {
        typeLabel.text = model?.commodityName
        daysLabel.text = model?.head
        titleLabel.text = model?.orderTitle1
        describeLabel.text = model?.orderDescribe1
        nameLabel.text = model?.foot
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(typeLabel)
        detailButton.isUserInteractionEnabled = false
        describeLabel.numberOfLines = 3
        typeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(12.5)
        }
        addSubview(typeLine)
        typeLine.snp.makeConstraints { (make) in
            make.left.equalTo(typeLabel.snp.right).offset(10)
            make.height.equalTo(13)
            make.width.equalTo(1)
            make.top.equalTo(14)
        }
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(typeLine.snp.right).offset(10)
            make.top.equalTo(12.5)
        }
        addSubview(daysLabel)
        daysLabel.snp.makeConstraints { (make) in
            make.top.equalTo(12.5)
            make.right.equalTo(-15)
            
        }
        addSubview(topLine)
        topLine.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(0.5)
            make.top.equalTo(typeLine.snp.bottom).offset(12.5)
        }
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(topLine.snp.bottom).offset(25)
        }
        addSubview(describeLabel)
        describeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.right.equalTo(-15)
        }
        addSubview(buttomLine)
        buttomLine.snp.makeConstraints { (make) in
            make.top.equalTo(describeLabel.snp.bottom).offset(25)
            make.height.equalTo(0.5)
            make.left.right.equalToSuperview().inset(15)
        }
        addSubview(detailButton)
        detailButton.snp.makeConstraints { (make) in
            make.top.equalTo(buttomLine.snp.bottom).offset(6.75)
            make.right.equalTo(buttomLine.snp.right)
            make.width.equalTo(78)
            make.height.equalTo(30)
        }
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalTo(detailButton.snp.centerY)
        }
        detailButton.layer.cornerRadius = 6
        detailButton.layer.borderColor = TBIThemeOrangeColor.cgColor
        detailButton.layer.borderWidth = 1
        
        buttomWithLine.backgroundColor = UIColor.red
        addSubview(buttomWithLine)
        buttomWithLine.snp.makeConstraints { (make) in
            make.top.equalTo(detailButton.snp.bottom).offset(5)
            make.height.equalTo(2)
            make.left.right.equalToSuperview().inset(15)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
