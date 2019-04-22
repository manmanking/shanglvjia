//
//  CoTrainDetailTableViewCell.swift
//  shop
//
//  Created by TBI on 2017/12/28.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class CoTrainDetailTableViewCell: UITableViewCell {
    
 
    let seatLabel: UILabel = UILabel(text: "二等座", color: TBIThemePrimaryTextColor, size: 13)
    
    let remainingVotesLabel:   UILabel = UILabel(text: "99张", color: TBIThemePrimaryTextColor, size: 13)
    
    let priceLabel: UILabel = UILabel(text: "¥54", color: TBIThemeOrangeColor, size: 13)
    
    let line = UILabel(color: TBIThemeGrayLineColor)
    
    let bookingButton:UIButton = UIButton(title: "预订",titleColor: TBIThemeWhite,titleSize: 13)
    
//    let policyLabel: UILabel = UILabel(text: "符合", color: TBIThemeWhite, size: 10)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView () {
       self.addSubview(seatLabel)
       seatLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(15)
        }
       self.addSubview(remainingVotesLabel)
       remainingVotesLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(110)
        }
       self.addSubview(priceLabel)
       priceLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(200)
        }
//       policyLabel.clipsToBounds = true
//       policyLabel.layer.cornerRadius = 2
//       policyLabel.backgroundColor = TBIThemeGreenColor
//       policyLabel.textAlignment = .center
//       self.addSubview(policyLabel)
//        policyLabel.snp.makeConstraints { (make) in
//            make.left.equalTo(priceLabel.snp.right).offset(5)
//            make.width.equalTo(25)
//            make.height.equalTo(14)
//            make.centerY.equalToSuperview()
//        }
       self.addSubview(line)
       line.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(0.5)
        }
       bookingButton.backgroundColor = TBIThemeOrangeColor
       bookingButton.layer.cornerRadius  = 4
       self.addSubview(bookingButton)
       bookingButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-15)
            make.width.equalTo(70)
            make.height.equalTo(32)
        }
    }
    
    func fillCell(model:(seat:SeatTrain,num:String,price:String,policy:Bool)?,anOrder:Bool,row:Int) {
        seatLabel.text = model?.seat.rawValue
        if row == 0 {
            line.isHidden  = true
        }else {
            line.isHidden  = false
        }
        remainingVotesLabel.text = "\(model?.num ?? "")张"
        let price = Double(model?.price ?? "0") ?? 0
        if  price.truncatingRemainder(dividingBy: 1) == 0 {
            priceLabel.text = "¥ \(Int(price))"
        }else {
            priceLabel.text = "¥ \(price)"
        }
        if model?.num == "0" || ((model?.policy ?? false) == false && anOrder == false){
            bookingButton.backgroundColor = TBIThemePlaceholderTextColor
        }else {
//            bookingButton.backgroundColor = TBIThemeOrangeColor
            if (model?.policy ?? false) == false {
                //            policyLabel.text = "违背"
                bookingButton.setTitle("违背预订", for: UIControlState.normal)
                bookingButton.backgroundColor = TBIThemeRedColor
            }else {
                //            policyLabel.text = "符合"
                bookingButton.setTitle("符合预订", for: UIControlState.normal)
                bookingButton.backgroundColor = TBIThemeGreenColor
            }
        }
    }
}



class CoTrainDetailHeaderTableView: UITableViewHeaderFooterView {
    
    let bgView = UIView()
    
    let startTime: UILabel = UILabel(text: "06:05", color: TBIThemePrimaryTextColor, size: 24)
    
    let endTime:   UILabel = UILabel(text: "06:40", color: TBIThemePrimaryTextColor, size: 24)
    
    let startCity: UILabel = UILabel(text: "北京", color: TBIThemePrimaryTextColor, size: 14)
    
    let endCity: UILabel = UILabel(text: "天津", color: TBIThemePrimaryTextColor, size: 14)
    
    let startImg:UIImageView = UIImageView(imageName:"ic_station_originating")
    
    let endImg:UIImageView = UIImageView(imageName:"ic_station_terminal")
    
    let line = UILabel(color: TBIThemePlaceholderTextColor)
    
    let runTime: UILabel = UILabel(text: "0小时30分", color: TBIThemePrimaryTextColor, size: 12)
    
    let isStop: UILabel = UILabel(text: "经停站", color: TBIThemePrimaryTextColor, size: 12)
    
    let message: UILabel = UILabel(text: "特别提示", color: TBIThemeBlueColor, size: 10)
    
    let messageImg:UIImageView = UIImageView.init(imageName: "warningBlue")
    
    let tripDayLabel: UILabel = UILabel(text: "", color: TBIThemeMinorTextColor, size: 10)
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView () {
        self.backgroundColor = TBIThemeMinorColor
        self.addSubview(bgView)
        bgView.backgroundColor = TBIThemeWhite
        bgView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(-10)
        }
        bgView.addSubview(startTime)
        startTime.snp.makeConstraints { (make) in
            make.left.top.equalTo(30)
        }
        bgView.addSubview(endTime)
        endTime.snp.makeConstraints { (make) in
           make.right.top.equalToSuperview().inset(30)
        }
        
        // add by manman  on 2018-04-18
        // start of line 行程 天数
        bgView.addSubview(tripDayLabel)
        tripDayLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(endTime.snp.top)
            make.left.equalTo(endTime.snp.right)
            make.height.equalTo(13)
            make.width.equalTo(30)
        }
        
        // end of line
        
        bgView.addSubview(startCity)
        startCity.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.top.equalTo(startTime.snp.bottom).offset(10)
        }
        bgView.addSubview(endCity)
        endCity.snp.makeConstraints { (make) in
            make.right.equalTo(endTime.snp.right)
            make.centerY.equalTo(startCity.snp.centerY)
        }
        bgView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.top.equalTo(52)
            make.height.equalTo(1)
            make.width.equalTo(52)
            make.centerX.equalToSuperview()
        }
        bgView.addSubview(startImg)
        startImg.snp.makeConstraints { (make) in
            make.centerY.equalTo(line.snp.centerY)
            make.right.equalTo(line.snp.left).offset(-2)
            make.height.width.equalTo(12)
        }
        bgView.addSubview(endImg)
        endImg.snp.makeConstraints { (make) in
            make.centerY.equalTo(line.snp.centerY)
            make.left.equalTo(line.snp.right).offset(2)
            make.height.width.equalTo(12)
        }
        bgView.addSubview(runTime)
        runTime.snp.makeConstraints { (make) in
            make.top.equalTo(line.snp.bottom).offset(4)
            make.centerX.equalTo(line.snp.centerX)
        }
        bgView.addSubview(isStop)
        isStop.snp.makeConstraints { (make) in
            make.bottom.equalTo(line.snp.top).offset(-4)
            make.centerX.equalTo(line.snp.centerX)
        }
        bgView.addSubview(message)
        message.snp.makeConstraints { (make) in
            make.right.equalTo(-30)
            make.bottom.equalTo(-15)
        }
        bgView.addSubview(messageImg)
        messageImg.snp.makeConstraints { (make) in
            make.width.height.equalTo(12)
            make.centerY.equalTo(message.snp.centerY)
            make.right.equalTo(message.snp.left).offset(-4)
        }
        message.isHidden = true
        messageImg.isHidden = true
        
    }
    
    func fillCell(model: CoTrainAvailInfo?) {
        startTime.text = model?.startTime
        endTime.text = model?.arriveTime
        startCity.text = model?.fromStationName
        endCity.text = model?.toStationName
        
        
        
        
        if let runTimes =  model?.runTime {
            let time = runTimes.components(separatedBy: ":")
            let hour = Int(time[0]) ?? 0
            let minutes = Int(time[1]) ?? 0
            runTime.text = hour == 0 ? "\(minutes)分" : "\(hour)时\(minutes)分"
        }
        if model?.isStart ?? true{
            startImg.image = UIImage.init(named: "ic_station_originating")
        }else {
            startImg.image = UIImage.init(named: "ic_station_intermediate")
        }
        if model?.isEnd ?? true {
            endImg.image = UIImage.init(named: "ic_station_terminal")
        }else {
            endImg.image = UIImage.init(named: "ic_station_intermediate")
        }
        isStop.text = model?.trainCode
    }
    func fillDataSources(model:QueryTrainResponse.TrainAvailInfo) {
        startTime.text = model.startTime
        endTime.text = model.arriveTime
        startCity.text = model.fromStationName
        endCity.text = model.toStationName
        
        let tripDay:NSInteger =  NSInteger(model.arriveDay) ?? 0
        if  tripDay == 0 {
            tripDayLabel.isHidden = true
        }else
        {
            tripDayLabel.isHidden = false
            tripDayLabel.text = "+" + model.arriveDay + "天"
        }
        
        if model.runTime.isEmpty == false {
            let time = model.runTime.components(separatedBy: ":")
            let hour = Int(time[0]) ?? 0
            let minutes = Int(time[1]) ?? 0
            runTime.text = hour == 0 ? "\(minutes)分" : "\(hour)时\(minutes)分"
        }
        if model.isStart == "1"{
            startImg.image = UIImage.init(named: "ic_station_originating")
        }else {
            startImg.image = UIImage.init(named: "ic_station_intermediate")
        }
        if model.isEnd == "1" {
            endImg.image = UIImage.init(named: "ic_station_terminal")
        }else {
            endImg.image = UIImage.init(named: "ic_station_intermediate")
        }
        isStop.text = model.trainCode
    }
    
}
