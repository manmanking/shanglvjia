//
//  CoTrainListTableViewCell.swift
//  shop
//
//  Created by TBI on 2017/12/27.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import SwiftDate

class CoTrainListTableViewCell: UITableViewCell {

    let bgView = UIView()
    // 开始时间
    let startTime: UILabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 20)
    // 结束日期
    let endTime:   UILabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 20)
    // 开始城市
    let startCity: UILabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 12)
    // 结束城市
    let endCity: UILabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 12)
    //开始标志
    let startImg:UIImageView = UIImageView(imageName:"ic_station_originating")
    // 结束标志
    let endImg:UIImageView = UIImageView(imageName:"ic_station_terminal")
    
    let line = UILabel(color: TBIThemePlaceholderTextColor)
    //车次
    let trainNo: UILabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 10)
    //行程时间
    let consumingTime: UILabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 10)
    // 价格
    let price: UILabel = UILabel(text: "", color: TBIThemeOrangeColor, size: 20)
    
    ///
    let remainingVotesOne = UILabel(text: "", color: TBIThemeMinorTextColor, size: 11)
    
    let remainingVotesTwo = UILabel(text: "", color: TBIThemeMinorTextColor, size: 11)
    
    let remainingVotesThree = UILabel(text: "", color: TBIThemeMinorTextColor, size: 11)
    
    let remainingVotesFour = UILabel(text: "", color: TBIThemeMinorTextColor, size: 11)
    
    let tripDayLabel:UILabel = UILabel(text: "", color: TBIThemeMinorTextColor, size: 11)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initView () {
        let cell = (ScreenWindowWidth-247)/3
        self.backgroundColor = TBIThemeMinorColor
        self.addSubview(bgView)
        bgView.backgroundColor = TBIThemeWhite
        bgView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(-5)
        }
        bgView.addSubview(startTime)
        startTime.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(10)
        }
        
        bgView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.top.equalTo(25)
            make.height.equalTo(1)
            make.width.equalTo(43)
            //make.centerX.equalToSuperview().offset(-((ScreenWindowWidth-247)/3))
            make.left.equalTo(startTime.snp.right).offset(cell+14)
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
        bgView.addSubview(trainNo)
        trainNo.snp.makeConstraints { (make) in
            make.bottom.equalTo(line.snp.top).offset(-4)
            make.centerX.equalTo(line.snp.centerX)
        }
        bgView.addSubview(consumingTime)
        consumingTime.snp.makeConstraints { (make) in
            make.top.equalTo(line.snp.bottom).offset(4)
            make.centerX.equalTo(line.snp.centerX)
        }
        
        bgView.addSubview(endTime)
        endTime.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            //make.centerX.equalToSuperview().offset((ScreenWindowWidth-247)/3)
            make.left.equalTo(endImg.snp.right).offset(cell)
            
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
            make.left.equalTo(15)
            make.top.equalTo(startTime.snp.bottom).offset(10)
        }
        bgView.addSubview(endCity)
        endCity.snp.makeConstraints { (make) in
            make.right.equalTo(endTime.snp.right)
            make.centerY.equalTo(startCity.snp.centerY)
        }
        
        bgView.addSubview(price)
        price.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.right.equalTo(-15)
        }
        bgView.addSubview(remainingVotesOne)
        remainingVotesOne.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.bottom.equalTo(-15)
        }
        bgView.addSubview(remainingVotesTwo)
        remainingVotesTwo.snp.makeConstraints { (make) in
            make.bottom.equalTo(-15)
            make.centerX.equalTo(line.snp.centerX)
        }
        bgView.addSubview(remainingVotesThree)
        remainingVotesThree.snp.makeConstraints { (make) in
            make.bottom.equalTo(-15)
            make.right.equalTo(endTime.snp.right)
        }
        bgView.addSubview(remainingVotesFour)
        remainingVotesFour.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.bottom.equalTo(-15)
        }
    }
    
    func fillDataSources(model:QueryTrainResponse.TrainAvailInfo) {
        remainingVotesOne.text = ""
        remainingVotesTwo.text = ""
        remainingVotesThree.text = ""
        remainingVotesFour.text = ""
        startTime.text = model.startTime
        endTime.text = model.arriveTime
        startCity.text = model.fromStationName
        endCity.text = model.toStationName
        trainNo.text = model.trainCode
        let tripDay:NSInteger =  NSInteger(model.arriveDay) ?? 0
        if  tripDay == 0 {
            tripDayLabel.isHidden = true
        }else
        {
            tripDayLabel.isHidden = false
            tripDayLabel.text = "+" + model.arriveDay + "天"
        }
        
        
        
        let runTime = model.runTime
        if runTime.isEmpty == false  {
            let time = runTime.components(separatedBy: ":")
            let hour = Int(time[0]) ?? 0
            let minutes = Int(time[1]) ?? 0
            consumingTime.text = hour == 0 ? "\(minutes)分" : "\(hour)时\(minutes)分"
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
        //二等、一等、商务、特等、硬座、硬卧、软卧、无座、软座、高级软卧
        //大于张现实有   6 - 20显示大灰  1-5显示橙色   0张浅灰
        var priceText:[Double] = []
        var i = 1
        let edzNum:String = model.edzNum
        if edzNum.isEmpty == false {
            if edzNum != "--"{
                i = setRemainingVotesText(title: "二等座",num: Int(edzNum) ?? 0,i:i)
                if model.edzPrice.isNotEmpty {
                    priceText.append(Double(model.edzPrice )!)
                }
            }
            
        }
        let ydzNum = model.ydzNum
        if ydzNum.isEmpty == false {
            if ydzNum != "--"{
                i = setRemainingVotesText(title: "一等座",num: Int(ydzNum) ?? 0,i:i)
                if model.ydzPrice.isNotEmpty {
                    priceText.append(Double(model.ydzPrice )!)
                }
            }
        }
        
        let swzNum = model.swzNum
        if swzNum.isEmpty == false {
            if swzNum != "--"{
                i = setRemainingVotesText(title: "商务座",num: Int(swzNum) ?? 0,i:i)
                if model.swzPrice.isNotEmpty {
                    priceText.append(Double(model.swzPrice )!)
                }
            }
            
            
        }
        let tdzNum = model.tdzNum
        if tdzNum.isEmpty == false {
            if tdzNum != "--" {
                i = setRemainingVotesText(title: "特等座",num: Int(tdzNum) ?? 0,i:i)
                if model.tdzPrice.isNotEmpty {
                    priceText.append(Double(model.tdzPrice )!)
                }
            }
        }
        let yzNum = model.yzNum
        if yzNum.isEmpty == false {
            if yzNum != "--"{
                i = setRemainingVotesText(title: "硬座",num: Int(yzNum) ?? 0,i:i)
                if model.yzPrice.isNotEmpty {
                    priceText.append(Double(model.yzPrice )!)
                }
            }
            
            
        }
        let ywNum = model.ywNum
        
        if ywNum.isEmpty == false {
            if ywNum != "--"{
                i = setRemainingVotesText(title: "硬卧",num: Int(ywNum) ?? 0,i:i)
                if model.ywPrice.isNotEmpty {
                    priceText.append(Double(model.ywPrice )!)
                }
            }
            
            
        }
        let rwNum = model.rwNum
        
        if rwNum.isEmpty == false {
            if rwNum != "--"{
                i = setRemainingVotesText(title: "软卧",num: Int(rwNum) ?? 0,i:i)
                if model.rwPrice.isNotEmpty {
                    priceText.append(Double(model.rwPrice )!)
                }
            }
            
        }
         let wzNum = model.wzNum
        if wzNum.isEmpty == false {
            if wzNum != "--"{
                i = setRemainingVotesText(title: "无座",num: Int(wzNum) ?? 0,i:i)
                if model.wzPrice.isNotEmpty {
                    priceText.append(Double(model.wzPrice )!)
                }
            }
            
        }
        //
        let rzNum = model.rzNum
        if rzNum.isEmpty == false {
            if rzNum != "--"{
                i = setRemainingVotesText(title: "软座",num: Int(rzNum) ?? 0,i:i)
                if model.rzPrice.isNotEmpty {
                    priceText.append(Double(model.rzPrice )!)
                }
            }
            
        }
        let gjrwNum = model.gjrwNum
        if  gjrwNum.isEmpty == false {
            if gjrwNum != "--"{
                i = setRemainingVotesText(title: "高级软卧",num: Int(gjrwNum) ?? 0,i:i)
                if model.gjrwPrice.isNotEmpty {
                    priceText.append(Double(model.gjrwPrice )!)
                }
            }
            
        }
        let priceData = NSMutableAttributedString()
        priceText.sort{$0 < $1}
        let pric = priceText.first ?? 0
        if  pric.truncatingRemainder(dividingBy: 1) == 0 {
            let textOne = NSAttributedString.init(string: "¥\(Int(pric))", attributes: [NSForegroundColorAttributeName : TBIThemeOrangeColor, NSFontAttributeName : UIFont.systemFont(ofSize: 16)])
            priceData.append(textOne)
        }else {
            let textOne = NSAttributedString.init(string: "¥\(pric)", attributes: [NSForegroundColorAttributeName : TBIThemeOrangeColor, NSFontAttributeName : UIFont.systemFont(ofSize: 16)])
            priceData.append(textOne)
        }
        
        
        
        let textTwo = NSAttributedString.init(string: "起", attributes: [NSForegroundColorAttributeName : TBIThemeMinorTextColor, NSFontAttributeName : UIFont.systemFont(ofSize: 11)])
        priceData.append(textTwo)
        price.attributedText = priceData
    }
    
    
    
    func fillCell(model: CoTrainAvailInfo?) {
        remainingVotesOne.text = ""
        remainingVotesTwo.text = ""
        remainingVotesThree.text = ""
        remainingVotesFour.text = ""
        startTime.text = model?.startTime
        endTime.text = model?.arriveTime
        startCity.text = model?.fromStationName
        endCity.text = model?.toStationName
        trainNo.text = model?.trainCode
        if let runTime =  model?.runTime {
            let time = runTime.components(separatedBy: ":")
            let hour = Int(time[0]) ?? 0
            let minutes = Int(time[1]) ?? 0
            consumingTime.text = hour == 0 ? "\(minutes)分" : "\(hour)时\(minutes)分"
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
        //二等、一等、商务、特等、硬座、硬卧、软卧、无座、软座、高级软卧
        //大于张现实有   6 - 20显示大灰  1-5显示橙色   0张浅灰
        var priceText:[Double] = []
        var i = 1
        if let edzNum = model?.edzNum {
            if edzNum != "--"{
                i = setRemainingVotesText(title: "二等座",num: Int(edzNum) ?? 0,i:i)
                if model?.edzPrice.isNotEmpty ?? false{
                    priceText.append(Double(model?.edzPrice ?? "0.0")!)
                }
            }
           
        }
        
        if let ydzNum = model?.ydzNum {
            if ydzNum != "--"{
                i = setRemainingVotesText(title: "一等座",num: Int(ydzNum) ?? 0,i:i)
                if model?.ydzPrice.isNotEmpty ?? false{
                    priceText.append(Double(model?.ydzPrice ?? "0")!)
                }
            }
        }
        
        if let swzNum = model?.swzNum {
            if swzNum != "--"{
                i = setRemainingVotesText(title: "商务座",num: Int(swzNum) ?? 0,i:i)
                if model?.swzPrice.isNotEmpty ?? false{
                    priceText.append(Double(model?.swzPrice ?? "0")!)
                }
            }
            
            
        }
        
        if let tdzNum = model?.tdzNum {
            if tdzNum != "--"{
                i = setRemainingVotesText(title: "特等座",num: Int(tdzNum) ?? 0,i:i)
                if model?.tdzPrice.isNotEmpty ?? false {
                    priceText.append(Double(model?.tdzPrice ?? "0")!)
                }
            }
            
           
        }
        
        if let yzNum = model?.yzNum {
            if yzNum != "--"{
                i = setRemainingVotesText(title: "硬座",num: Int(yzNum) ?? 0,i:i)
                if model?.yzPrice.isNotEmpty ?? false {
                    priceText.append(Double(model?.yzPrice ?? "0")!)
                }
            }
            
            
        }
        
        if let ywNum = model?.ywNum {
            if ywNum != "--"{
                i = setRemainingVotesText(title: "硬卧",num: Int(ywNum) ?? 0,i:i)
                if model?.ywPrice.isNotEmpty ?? false {
                    priceText.append(Double(model?.ywPrice ?? "0")!)
                }
            }
            
            
        }
        
        if let rwNum = model?.rwNum {
            if rwNum != "--"{
                i = setRemainingVotesText(title: "软卧",num: Int(rwNum) ?? 0,i:i)
                if model?.rwPrice.isNotEmpty ?? false {
                    priceText.append(Double(model?.rwPrice ?? "0")!)
                }
            }
            
        }
        
        if let wzNum = model?.wzNum {
            if wzNum != "--"{
                i = setRemainingVotesText(title: "无座",num: Int(wzNum) ?? 0,i:i)
                if model?.wzPrice.isNotEmpty ?? false {
                    priceText.append(Double(model?.wzPrice ?? "0")!)
                }
            }
            
        }
        
        if let rzNum = model?.rzNum {
            if rzNum != "--"{
                i = setRemainingVotesText(title: "软座",num: Int(rzNum) ?? 0,i:i)
                if model?.rzPrice.isNotEmpty ?? false {
                    priceText.append(Double(model?.rzPrice ?? "0")!)
                }
            }
            
        }
        
        if let gjrwNum = model?.gjrwNum {
            if gjrwNum != "--"{
                i = setRemainingVotesText(title: "高级软卧",num: Int(gjrwNum) ?? 0,i:i)
                if model?.gjrwPrice.isNotEmpty ?? false {
                    priceText.append(Double(model?.gjrwPrice ?? "0")!)
                }
            }
            
        }
        let priceData = NSMutableAttributedString()
        priceText.sort{$0 < $1}
        let pric = priceText.first ?? 0
        if  pric.truncatingRemainder(dividingBy: 1) == 0 {
            let textOne = NSAttributedString.init(string: "¥\(Int(pric))", attributes: [NSForegroundColorAttributeName : TBIThemeOrangeColor, NSFontAttributeName : UIFont.systemFont(ofSize: 16)])
            priceData.append(textOne)
        }else {
            let textOne = NSAttributedString.init(string: "¥\(pric)", attributes: [NSForegroundColorAttributeName : TBIThemeOrangeColor, NSFontAttributeName : UIFont.systemFont(ofSize: 16)])
            priceData.append(textOne)
        }
        
       
       
        let textTwo = NSAttributedString.init(string: "起", attributes: [NSForegroundColorAttributeName : TBIThemeMinorTextColor, NSFontAttributeName : UIFont.systemFont(ofSize: 11)])
        priceData.append(textTwo)
        price.attributedText = priceData
    }
    
    func setRemainingVotesText (title:String,num:Int,i:Int) -> Int{
        
        switch i {
            case 1:
                remainingVotesOne.textColor = TBIThemePrimaryTextColor
                if num > 20 {
                    remainingVotesOne.text = "\(title):有"
                }
                if num <= 20 && num > 5 {
                    remainingVotesOne.text = "\(title):\(num)张"
                }
                if num <= 5 && num > 0{
                    let attrText = NSMutableAttributedString()
                    let textOne = NSAttributedString.init(string: "\(title):", attributes: [NSForegroundColorAttributeName : TBIThemePrimaryTextColor, NSFontAttributeName : UIFont.systemFont(ofSize: 11)])
                    let textTwo = NSAttributedString.init(string: "\(num)张", attributes: [NSForegroundColorAttributeName : TBIThemeOrangeColor, NSFontAttributeName : UIFont.systemFont(ofSize: 11)])
                    attrText.append(textOne)
                    attrText.append(textTwo)
                    remainingVotesOne.attributedText = attrText
                    
                }
                if num == 0 {
                    remainingVotesOne.text = "\(title):\(num)张"
                    remainingVotesOne.textColor = TBIThemePlaceholderTextColor
                }
                break
            case 2:
                remainingVotesTwo.textColor = TBIThemePrimaryTextColor
                if num > 20 {
                    remainingVotesTwo.text = "\(title):有"
                }
                if num <= 20 && num > 5 {
                     remainingVotesTwo.text = "\(title):\(num)张"
                }
                if num <= 5 && num > 0{
                    let attrText = NSMutableAttributedString()
                    let textOne = NSAttributedString.init(string: "\(title):", attributes: [NSForegroundColorAttributeName : TBIThemePrimaryTextColor, NSFontAttributeName : UIFont.systemFont(ofSize: 11)])
                    let textTwo = NSAttributedString.init(string: "\(num)张", attributes: [NSForegroundColorAttributeName : TBIThemeOrangeColor, NSFontAttributeName : UIFont.systemFont(ofSize: 11)])
                    attrText.append(textOne)
                    attrText.append(textTwo)
                    remainingVotesTwo.attributedText = attrText
                    
                }
                if num == 0 {
                    remainingVotesTwo.text = "\(title):\(num)张"
                    remainingVotesTwo.textColor = TBIThemePlaceholderTextColor
                }
                break
            case 3:
                remainingVotesThree.textColor = TBIThemePrimaryTextColor
                if num > 20 {
                    remainingVotesThree.text = "\(title):有"
                }
                if num <= 20 && num > 5 {
                     remainingVotesThree.text = "\(title):\(num)张"
                }
                if num <= 5 && num > 0{
                    let attrText = NSMutableAttributedString()
                    let textOne = NSAttributedString.init(string: "\(title):", attributes: [NSForegroundColorAttributeName : TBIThemePrimaryTextColor, NSFontAttributeName : UIFont.systemFont(ofSize: 11)])
                    let textTwo = NSAttributedString.init(string: "\(num)张", attributes: [NSForegroundColorAttributeName : TBIThemeOrangeColor, NSFontAttributeName : UIFont.systemFont(ofSize: 11)])
                    attrText.append(textOne)
                    attrText.append(textTwo)
                    remainingVotesThree.attributedText = attrText
                    
                }
                if num == 0 {
                    remainingVotesThree.text = "\(title):\(num)张"
                    remainingVotesThree.textColor = TBIThemePlaceholderTextColor
                }
                break
            case 4:
                remainingVotesFour.textColor = TBIThemePrimaryTextColor
                if num > 20 {
                    remainingVotesFour.text = "\(title):有"
                }
                if num <= 20 && num > 5 {
                     remainingVotesFour.text = "\(title):\(num)张"
                }
                if num <= 5 && num > 0{
                    let attrText = NSMutableAttributedString()
                    let textOne = NSAttributedString.init(string: "\(title):", attributes: [NSForegroundColorAttributeName : TBIThemePrimaryTextColor, NSFontAttributeName : UIFont.systemFont(ofSize: 11)])
                    let textTwo = NSAttributedString.init(string: "\(num)张", attributes: [NSForegroundColorAttributeName : TBIThemeOrangeColor, NSFontAttributeName : UIFont.systemFont(ofSize: 11)])
                    attrText.append(textOne)
                    attrText.append(textTwo)
                    remainingVotesFour.attributedText = attrText
                    
                }
                if num == 0 {
                    remainingVotesFour.text = "\(title):\(num)张"
                    remainingVotesFour.textColor = TBIThemePlaceholderTextColor
                }
                break
            default: break
        }
        
        return i + 1
    }
    
   
}
