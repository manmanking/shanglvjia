//
//  CoTrainOrderTableViewCell.swift
//  shop
//
//  Created by TBI on 2017/12/29.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import SwiftDate

/// 车次详情信息
class CoTrainOrderTableViewCell: UITableViewCell {
    
    let bgView = UIView()
    
    let type: UILabel = UILabel(text: "去", color: TBIThemeWhite, size: 11)
    
    let startDate: UILabel = UILabel(text: "12月28日", color: TBIThemePrimaryTextColor, size: 12)
    
    let price: UILabel = UILabel(text: "¥175", color: TBIThemeOrangeColor, size: 12)
    
    let seat: UILabel = UILabel(text: "二等座", color: TBIThemePrimaryTextColor, size: 12)
    
    let startTime: UILabel = UILabel(text: "06:05", color: TBIThemePrimaryTextColor, size: 24)
    
    let endTime:   UILabel = UILabel(text: "06:40", color: TBIThemePrimaryTextColor, size: 24)
    
    let startCity: UILabel = UILabel(text: "北京", color: TBIThemePrimaryTextColor, size: 12)
    
    let endCity: UILabel = UILabel(text: "天津", color: TBIThemePrimaryTextColor, size: 12)
    
    let startImg:UIImageView = UIImageView(imageName:"ic_station_originating")
    
    let endImg:UIImageView = UIImageView(imageName:"ic_station_terminal")
    
    let line = UILabel(color: TBIThemePlaceholderTextColor)
    
    let runTime: UILabel = UILabel(text: "0小时30分", color: TBIThemePrimaryTextColor, size: 12)
    
    let isStop: UILabel = UILabel(text: "经停站", color: TBIThemePrimaryTextColor, size: 12)
    
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
        bgView.layer.cornerRadius = 5
//        bgView.layer.borderWidth = 1
//        bgView.layer.borderColor = TBIThemeGrayLineColor.cgColor
        bgView.backgroundColor = TBIThemeWhite
        bgView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(5)
            make.top.equalTo(10)
            make.height.equalTo(112)
        }
        
        type.backgroundColor = TBIThemeBlueColor
        type.layer.cornerRadius = 4
        type.clipsToBounds = true
        type.textAlignment = .center
        bgView.addSubview(type)
        type.snp.makeConstraints { (make) in
            make.width.height.equalTo(16)
            make.top.left.equalToSuperview().inset(15)
        }
        bgView.addSubview(startDate)
        startDate.snp.makeConstraints { (make) in
            make.top.equalTo(16)
            make.left.equalTo(type.snp.right).offset(15)
        }
        bgView.addSubview(price)
        price.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalTo(startDate.snp.centerY)
        }
        bgView.addSubview(seat)
        seat.snp.makeConstraints { (make) in
            make.right.equalTo(price.snp.left).offset(-2)
            make.centerY.equalTo(startDate.snp.centerY)
        }
        bgView.addSubview(startTime)
        startTime.snp.makeConstraints { (make) in
            make.top.equalTo(51)
            make.left.equalTo(15)
        }
        bgView.addSubview(endTime)
        endTime.snp.makeConstraints { (make) in
            make.top.equalTo(51)
            make.right.equalTo(-25)
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
            make.top.equalTo(startTime.snp.bottom).offset(6)
        }
        bgView.addSubview(endCity)
        endCity.snp.makeConstraints { (make) in
            make.right.equalTo(-25)
            make.top.equalTo(endTime.snp.bottom).offset(6)
        }
        
        bgView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.top.equalTo(76)
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
    }
    
    
    func fillDataSources(model:(price:Double,type:Int,seat:SeatTrain,model:QueryTrainResponse.TrainAvailInfo)) {
        seat.text = model.seat.rawValue
        startTime.text = model.model.startTime
        endTime.text = model.model.arriveTime
        startCity.text = model.model.fromStationName
        endCity.text = model.model.toStationName
        
        let time = model.model.runTime.components(separatedBy: ":")
        let hour = Int(time[0]) ?? 0
        let minutes = Int(time[1]) ?? 0
        runTime.text = hour == 0 ? "\(minutes)分" : "\(hour)时\(minutes)分"
        isStop.text = model.model.trainCode
        
        let tripDay:NSInteger =  NSInteger(model.model.arriveDay) ?? 0
        if  tripDay == 0 {
            tripDayLabel.isHidden = true
        }else
        {
            tripDayLabel.isHidden = false
            tripDayLabel.text = "+" + model.model.arriveDay + "天"
        }
        
        if  model.price.truncatingRemainder(dividingBy: 1) == 0 {
            price.text = "¥\(Int(model.price))"
        }else {
            price.text = "¥\(model.price)"
        }
        
        if model.model.isStart == "1" {
            startImg.image = UIImage.init(named: "ic_station_originating")
        }else {
            startImg.image = UIImage.init(named: "ic_station_intermediate")
        }
        if model.model.isEnd == "1" {
            endImg.image = UIImage.init(named: "ic_station_terminal")
        }else {
            endImg.image = UIImage.init(named: "ic_station_intermediate")
        }
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone?
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if model.type == 0 {
            type.isHidden = true
            startDate.snp.remakeConstraints { (make) in
                make.top.equalTo(16)
                make.left.equalTo(15)
                make.left.equalTo(type.snp.right).offset(15)
            }
            bgView.snp.updateConstraints { (make) in
                make.top.equalTo(10)
            }
            let date:Date = formatter.date(from: TrainManager.shareInstance.trainSearchConditionDraw().departureDateFormat)!
            startDate.text = date.string(custom: "MM月dd日")
        }
        
        
        if model.type == 1 {
            type.isHidden = false
            type.text = "去"
            startDate.snp.remakeConstraints { (make) in
                make.top.equalTo(16)
                make.left.equalTo(type.snp.right).offset(15)
            }
            bgView.snp.updateConstraints { (make) in
                make.top.equalTo(10)
            }
            let date:Date = formatter.date(from: TrainManager.shareInstance.trainSearchConditionDraw().departureDateFormat)!
            startDate.text = date.string(custom: "MM月dd日")
        }
        if model.type == 2 {
            type.isHidden = false
            type.text = "返"
            startDate.snp.remakeConstraints { (make) in
                make.top.equalTo(16)
                make.left.equalTo(type.snp.right).offset(15)
            }
            bgView.snp.updateConstraints { (make) in
                make.top.equalTo(5)
            }
            let date:Date = formatter.date(from: TrainManager.shareInstance.trainSearchConditionDraw().returnDateFormat)!
            startDate.text = date.string(custom: "MM月dd日")
        }
        
        
        
    }
    
}


/// 乘车人headerCell
class CoTrainOrderPassengerHeaderTableViewCell: UITableViewCell {
    
    let passengerLabel: UILabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 12)
    
    let line = UILabel(color: TBIThemeGrayLineColor)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initView() {
        self.addSubview(passengerLabel)
        passengerLabel.snp.makeConstraints { (make) in
            make.left.equalTo(23)
            make.centerY.equalToSuperview()
        }
        self.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    func fillCell(count:Int) {
        let passengerCount = NSMutableAttributedString()
        if count > 1
        {
            let textOne = NSAttributedString.init(string: "乘车人 (共", attributes: [NSForegroundColorAttributeName : TBIThemePrimaryTextColor, NSFontAttributeName : UIFont.systemFont(ofSize: 13)])
            passengerCount.append(textOne)
            let textTwo = NSAttributedString.init(string: "\(count)", attributes: [NSForegroundColorAttributeName : TBIThemeOrangeColor, NSFontAttributeName : UIFont.systemFont(ofSize: 13)])
            passengerCount.append(textTwo)
            let textThree = NSAttributedString.init(string: "人)", attributes: [NSForegroundColorAttributeName : TBIThemePrimaryTextColor, NSFontAttributeName : UIFont.systemFont(ofSize: 13)])
            passengerCount.append(textThree)
        }else{
            passengerCount.append(NSAttributedString.init(string:"乘车人"))
        }
        
        passengerLabel.attributedText = passengerCount
    }
    
}

/// 乘车人cell
class CoTrainOrderPassengerTableViewCell: UITableViewCell {
    
    // 是否选中
    var flag:Bool = false
    
    let bgView = UIView()
    
    let deleteBgView = UIView()
    
    let deleteImg:UIImageView = UIImageView(imageName:"HotelDeleteHollow")
    
    let nameLabel: UILabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 13)
    
    let cardTypeLabel: UILabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 13)
    
    let cardNoLabel: UILabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 13)
    
    let line = UILabel(color: TBIThemeGrayLineColor)
    
    let rightImg:UIImageView = UIImageView(imageName:"ic_right_gray")
    
    let deleteButton:UIButton = UIButton(title: "删除",titleColor: TBIThemeWhite,titleSize: 20)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initView() {
        self.contentView.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(50)
            make.width.equalToSuperview()
        }
        
        bgView.addSubview(rightImg)
        rightImg.snp.makeConstraints { (make) in
            make.right.equalTo(-65)
            make.centerY.equalToSuperview()
        }
        bgView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        bgView.addSubview(cardTypeLabel)
        cardTypeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(50)
            make.centerY.equalToSuperview()
        }
        bgView.addSubview(cardNoLabel)
        cardNoLabel.snp.makeConstraints { (make) in
            make.left.equalTo(cardTypeLabel.snp.right).offset(10)
            make.centerY.equalToSuperview()
        }
        deleteButton.backgroundColor = UIColor.red
        bgView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { (make) in
            make.right.top.bottom.equalToSuperview()
            make.width.equalTo(50)
        }
        deleteBgView.backgroundColor = TBIThemeWhite
        self.contentView.addSubview(deleteBgView)
        deleteBgView.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
            make.width.equalTo(50)
        }
        deleteBgView.addSubview(deleteImg)
        deleteImg.snp.makeConstraints { (make) in
            make.left.equalTo(23)
            make.width.height.equalTo(16)
            make.centerY.equalToSuperview()
        }
        
        self.contentView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.equalTo(23)
            make.right.top.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    func  carFillCell(model:CoCarForm.CarPassenger,row:Int,count:Int,updateFlag:[String]) {
        flag = false
        if 1 == row {
            line.isHidden = true
        }else {
            line.isHidden = false
        }
        if count == 1 {
            deleteImg.image = UIImage.init(named: "ic_delete_grey")
        }else {
            deleteImg.image = UIImage.init(named: "HotelDeleteHollow")
        }
        nameLabel.text = model.name
        cardTypeLabel.text = model.phone.value
//        cardNoLabel.text = model.passportNo.value
        if updateFlag.contains(model.parId) {
            rightImg.isHidden = false
        }else {
            rightImg.isHidden = true
        }
    }
    
    func  fillCell (model:CoTrainCommitForm.SubmitTrainInfo.PassengerInfo,row:Int,count:Int,updateFlag:[String]) {
        flag = false
        if 1 == row {
            line.isHidden = true
        }else {
            line.isHidden = false
        }
        if count == 1 {
            deleteImg.image = UIImage.init(named: "ic_delete_grey")
        }else {
            deleteImg.image = UIImage.init(named: "HotelDeleteHollow")
        }
        nameLabel.text = model.passengerName
        cardTypeLabel.text = model.passportTypeseId == "1" ? "身份证":"护照"
        cardNoLabel.text = model.passportNo.value
        if updateFlag.contains(model.parId) {
            rightImg.isHidden = false
        }else {
            rightImg.isHidden = true
        }
    }
    
    func fillCells(model:Traveller,row:Int) {
        if 1 == row {
            line.isHidden = true
        }else {
            line.isHidden = false
        }
        nameLabel.text = model.name
        if !model.certificates.isEmpty {
            rightImg.isHidden = true
            let data = model.certificates.filter{$0.type == 1}
            if !data.isEmpty {
                cardTypeLabel.text = data.first?.name
                cardNoLabel.text = data.first?.number
            }else {
                cardTypeLabel.text = model.certificates.first?.name
                cardNoLabel.text = model.certificates.first?.number
            }
        }else {
            rightImg.isHidden = false
        }
        
    }
    
}


/// 乘车人headerCell
class CoTrainOrderContactPersonTableViewCell: UITableViewCell {
    
    let titleLabel: UILabel = UILabel(text: "联系人", color: TBIThemePrimaryTextColor, size: 13)
    
    let nameLabel: UILabel = UILabel(text: "刘博博", color: TBIThemePrimaryTextColor, size: 13)
    
    let rightImg:UIImageView = UIImageView(imageName:"ic_right_gray")
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initView() {
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(23)
            make.centerY.equalToSuperview()
        }
        self.contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.centerY.equalToSuperview()
        }
        self.contentView.addSubview(rightImg)
        rightImg.snp.makeConstraints { (make) in
            make.right.equalTo(-23)
            make.centerY.equalToSuperview()
        }
    }
    
    func fillCell(name:String?) {
       titleLabel.text =  "联系人"
       nameLabel.text = name
    }
    
    func carFillCell(name:String?) {
        titleLabel.text =  "报销人"
        nameLabel.text =  name
    }
    
}


class CoTrainOrderFooterView: UIView {
    
    let priceCountLabel = UILabel(text: "", color: TBIThemePrimaryWarningColor, size: 20)
    
    let priceButton = UIButton()
    
    lazy var leftView:UIView = {
        let vi = UIView()
        vi.backgroundColor = TBIThemeWhite
        let line = UILabel(color: TBIThemeGrayLineColor)
        let titleLabel = UILabel(text: "总价", color: TBIThemePrimaryTextColor, size: 13)
        let yLabel = UILabel(text: "¥", color: TBIThemePrimaryWarningColor, size: 13)
        vi.addSubview(line)
        vi.addSubview(titleLabel)
        vi.addSubview(self.priceCountLabel)
        vi.addSubview(yLabel)
        line.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalTo(0)
            make.height.equalTo(0.5)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
        self.priceCountLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-44)
            make.centerY.equalToSuperview()
        }
        yLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.priceCountLabel.snp.bottom).offset(-3)
            make.right.equalTo(self.priceCountLabel.snp.left)
        }
        return vi
    }()
    
    let submitButton:UIButton = UIButton(title: "立即预订",titleColor: TBIThemeWhite,titleSize: 20)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView(){
        priceCountLabel.font = UIFont.boldSystemFont(ofSize: 20)
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        addSubview(leftView)
        addSubview(submitButton)
        addSubview(priceButton)
        priceButton.setImage(UIImage(named: "ic_up_gray"), for: UIControlState.normal)
        priceButton.setImage(UIImage(named: "ic_down_gray"), for: UIControlState.selected)
        submitButton.backgroundColor = TBIThemeDarkBlueColor
        priceButton.setEnlargeEdgeWithTop(20 ,left: 400, bottom: 20, right: 0)
        leftView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.height.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
        }
        submitButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.height.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
        }
        priceButton.snp.makeConstraints { (make) in
            make.right.equalTo(submitButton.snp.left).offset(-15)
            make.centerY.equalToSuperview()
        }
    }
    
}



class CoTrainPriceInfoView: UIView {
    
    let priceTitleLabel = UILabel(text: "费用明细", color: TBIThemePrimaryTextColor, size: 16)
    
    let priceLine = UILabel(color: TBIThemeGrayLineColor)
    
    let line =  UILabel(color: TBIThemeGrayLineColor)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView(personCount:Int,formPrice:Double,toPrice:Double){
        self.backgroundColor = TBIThemeWhite
        addSubview(priceTitleLabel)
        addSubview(priceLine)
        priceTitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(22)
        }
        priceLine.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(0.5)
            make.top.equalTo(44)
        }
        
        if TrainManager.shareInstance.trainSearchConditionDraw().type == 2 { //往返
            let takeOffTitleLabel = UILabel(text: "去程票价", color: TBIThemePrimaryTextColor, size: 13)
            
            let takeOffPersonLabel = UILabel(text: "X\(personCount)人", color: TBIThemeMinorTextColor, size: 13)
            let formPrice = formPrice * Double(personCount)
            var takeOffPriceLabel:UILabel
            if formPrice.truncatingRemainder(dividingBy: 1) == 0 {
                 takeOffPriceLabel = UILabel(text: "¥\(Int(formPrice))", color: TBIThemeOrangeColor, size: 13)
            }else {
                takeOffPriceLabel = UILabel(text: "¥\(formPrice)", color: TBIThemeOrangeColor, size: 13)
            }
            
            
            let arriveTitleLabel = UILabel(text: "返程票价", color: TBIThemePrimaryTextColor, size: 13)
            
            let toPrice = toPrice * Double(personCount)
            var arrivePriceLabel:UILabel
            let arrivePersonLabel = UILabel(text: "X\(personCount)人", color: TBIThemeMinorTextColor, size: 13)
            if toPrice.truncatingRemainder(dividingBy: 1) == 0 {
                arrivePriceLabel = UILabel(text: "¥\(Int(toPrice))", color: TBIThemeOrangeColor, size: 13)
            }else {
                arrivePriceLabel = UILabel(text: "¥\(toPrice)", color: TBIThemeOrangeColor, size: 13)
            }
            
            addSubview(takeOffTitleLabel)
            takeOffTitleLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(15)
                make.top.equalTo(priceLine.snp.bottom).offset(15)
            })
            addSubview(takeOffPersonLabel)
            takeOffPersonLabel.snp.makeConstraints({ (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(takeOffTitleLabel.snp.top)
            })
            addSubview(takeOffPriceLabel)
            takeOffPriceLabel.snp.makeConstraints({ (make) in
                make.right.equalTo(-15)
                make.top.equalTo(takeOffTitleLabel.snp.top)
            })
            
            addSubview(arriveTitleLabel)
            arriveTitleLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(15)
                make.top.equalTo(takeOffTitleLabel.snp.bottom).offset(10)
            })
            addSubview(arrivePersonLabel)
            arrivePersonLabel.snp.makeConstraints({ (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(arriveTitleLabel.snp.top)
            })
            addSubview(arrivePriceLabel)
            arrivePriceLabel.snp.makeConstraints({ (make) in
                make.right.equalTo(-15)
                make.top.equalTo(arriveTitleLabel.snp.top)
            })
            
        }else { //单程
            let takeOffTitleLabel = UILabel(text: "票价", color: TBIThemePrimaryTextColor, size: 13)
            
            let takeOffPersonLabel = UILabel(text: "X\(personCount)人", color: TBIThemeMinorTextColor, size: 13)
//            let takeOffPriceLabel = UILabel(text: "¥\(formPrice * Double(personCount))", color: TBIThemeOrangeColor, size: 13)
            let formPrice = formPrice * Double(personCount)
            var takeOffPriceLabel:UILabel
            if formPrice.truncatingRemainder(dividingBy: 1) == 0 {
                takeOffPriceLabel = UILabel(text: "¥\(Int(formPrice))", color: TBIThemeOrangeColor, size: 13)
            }else {
                takeOffPriceLabel = UILabel(text: "¥\(formPrice)", color: TBIThemeOrangeColor, size: 13)
            }
            
            addSubview(takeOffTitleLabel)
            takeOffTitleLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(15)
                make.top.equalTo(priceLine.snp.bottom).offset(15)
                make.height.equalTo(13)
            })
            addSubview(takeOffPersonLabel)
            takeOffPersonLabel.snp.makeConstraints({ (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(takeOffTitleLabel.snp.top)
                make.height.equalTo(13)
            })
            addSubview(takeOffPriceLabel)
            takeOffPriceLabel.snp.makeConstraints({ (make) in
                make.right.equalTo(-15)
                make.top.equalTo(takeOffTitleLabel.snp.top)
                make.height.equalTo(13)
            })
            
            
        }
        
        
    }
    
}


