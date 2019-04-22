//
//  ApprovalDetailTrainInfoTableViewCell.swift
//  shanglvjia
//
//  Created by manman on 2018/5/22.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class ApprovalDetailTrainInfoTableViewCell: UITableViewCell {
    
    let bgView = UIView()
    
    
    let startDate: UILabel = UILabel(text: "12月28日", color: TBIThemeMinorTextColor, size: 13)
    
    //    let price: UILabel = UILabel(text: "¥175", color: TBIThemeOrangeColor, size: 12)
    //
    //    let seat: UILabel = UILabel(text: "二等座", color: TBIThemePrimaryTextColor, size: 12)
    
    let startTime: UILabel = UILabel(text: "06:05", color: TBIThemePrimaryTextColor, size: 25)
    
    let endTime:   UILabel = UILabel(text: "06:40", color: TBIThemePrimaryTextColor, size: 25)
    
    let startCity: UILabel = UILabel(text: "北京", color: TBIThemeMinorTextColor, size: 12)
    
    let endCity: UILabel = UILabel(text: "天津", color: TBIThemeMinorTextColor, size: 12)
    
    //    let startImg:UIImageView = UIImageView(imageName:"ic_station_originating")
    //
    //    let endImg:UIImageView = UIImageView(imageName:"ic_station_terminal")
    let arrowImage = UIImageView.init(imageName: "ic_ari_timeto")
    
    let line = UILabel(color: TBIThemePlaceholderTextColor)
    
    let runTime: UILabel = UILabel(text: "0小时30分", color: TBIThemeMinorTextColor, size: 11)
    
    let isStop: UILabel = UILabel(text: "经停站", color: TBIThemeMinorTextColor, size: 11)
    
    let tripDayLabel: UILabel = UILabel(text: "", color: TBIThemeMinorTextColor, size: 10)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView () {
        self.backgroundColor  = TBIThemeMinorColor
        self.addSubview(bgView)
        bgView.backgroundColor = TBIThemeWhite
        bgView.addSubview(arrowImage)
        
        bgView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
        }
        
        bgView.addSubview(startDate)
        startDate.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.left.equalTo(13)
        }
        
        
        bgView.addSubview(startTime)
        startTime.snp.makeConstraints { (make) in
            make.right.equalTo(arrowImage.snp.left).offset(-30)
            make.top.equalTo(startDate.snp.bottom).offset(25)
            make.height.equalTo(30)
        }
        bgView.addSubview(endTime)
        endTime.snp.makeConstraints { (make) in
            make.left.equalTo(arrowImage.snp.right).offset(30)
            make.top.equalTo(startTime.snp.top)
            make.height.equalTo(30)
        }
        
        // add by manman  on 2018-04-18
        // start of line 行程 天数
        bgView.addSubview(tripDayLabel)
        tripDayLabel.snp.makeConstraints { (make) in
            make.left.equalTo(endTime.snp.right).offset(2)
            make.top.equalTo(endTime.snp.top).offset(-5)
            make.width.equalTo(40)
            make.height.equalTo(20)
        }
        
        // end of line
        bgView.addSubview(startCity)
        startCity.snp.makeConstraints { (make) in
            make.right.equalTo(startTime.snp.right)
            make.top.equalTo(startTime.snp.bottom).offset(5)
        }
        bgView.addSubview(endCity)
        endCity.snp.makeConstraints { (make) in
            make.left.equalTo(endTime.snp.left)
            make.top.equalTo(startCity.snp.top)
        }
        
        arrowImage.snp.makeConstraints { (make) in
            make.width.equalTo(50)
            make.height.equalTo(5)
            make.centerX.equalTo(bgView.snp.centerX)
            make.centerY.equalTo(startTime.snp.centerY)
        }
        
        bgView.addSubview(runTime)
        runTime.snp.makeConstraints { (make) in
            make.top.equalTo(arrowImage.snp.bottom).offset(4)
            make.centerX.equalTo(arrowImage.snp.centerX)
        }
        bgView.addSubview(isStop)
        isStop.snp.makeConstraints { (make) in
            make.bottom.equalTo(arrowImage.snp.top).offset(-4)
            make.centerX.equalTo(arrowImage.snp.centerX)
        }
    }
    
    
    func fillDataSources(trainDetail:ApproveDetailResponseVO.ApprovalOrderDetail) {
        
        
        //开始日期
        
        
        
        let startDateArr:[String] = trainDetail.startTime.components(separatedBy: " ")
        let startDateDayUnitArr:[String] = startDateArr.first?.components(separatedBy: "-") ?? []
        if startDateDayUnitArr.count > 0 {
            startDate.text = startDateDayUnitArr[1] + "月" + (startDateDayUnitArr.last ?? "")! + "日"
        }
        
        
        if startDateArr.count > 0 {
            startTime.text = startDateArr.last
        }else{
            startTime.text = ""
        }
        
        let arriveDateArr:[String] = trainDetail.arriveTime.components(separatedBy: " ")
        if arriveDateArr.count > 0 {
            endTime.text = arriveDateArr.last
        }else{
            endTime.text = ""
        }
        
        let allTime =  CommonTool.returnRuntime(trainDetail.runTime)
        
        startCity.text = trainDetail.startStationName
        endCity.text = trainDetail.endStationName
        runTime.text = allTime
        isStop.text = trainDetail.trainCode
        
        let tripDay:NSInteger =  NSInteger(trainDetail.trainDay) ?? 0
        if  tripDay == 0 {
            tripDayLabel.isHidden = true
        }else
        {
            tripDayLabel.isHidden = false
            tripDayLabel.text = "+" + trainDetail.trainDay + "天"
        }
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone?
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//
//        if model.type == 0 {
//            startDate.snp.remakeConstraints { (make) in
//                make.top.equalTo(15)
//                make.left.equalTo(13)
//            }
//            bgView.snp.updateConstraints { (make) in
//                make.top.equalTo(10)
//            }
//            let date:Date = formatter.date(from: TrainManager.shareInstance.trainSearchConditionDraw().departureDateFormat)!
//            startDate.text = date.string(custom: "MM月dd日")
//        }
//
//
//        if model.type == 1 {
//
//            startDate.snp.remakeConstraints { (make) in
//                make.top.equalTo(15)
//                make.left.equalTo(13)
//            }
//            bgView.snp.updateConstraints { (make) in
//                make.top.equalTo(10)
//            }
//            let date:Date = formatter.date(from: TrainManager.shareInstance.trainSearchConditionDraw().departureDateFormat)!
//            startDate.text = date.string(custom: "MM月dd日")
//        }
//        if model.type == 2 {
//
//            startDate.snp.remakeConstraints { (make) in
//                make.top.equalTo(15)
//                make.left.equalTo(13)
//            }
//            bgView.snp.updateConstraints { (make) in
//                make.top.equalTo(5)
//            }
//            let date:Date = formatter.date(from: TrainManager.shareInstance.trainSearchConditionDraw().returnDateFormat)!
//            startDate.text = date.string(custom: "MM月dd日")
        //}
        
        
        
    }
    
    
}

