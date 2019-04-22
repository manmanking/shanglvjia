//
//  CoCarOrderTableViewCell.swift
//  shop
//
//  Created by TBI on 2018/1/22.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import SwiftDate

class CoCarOrderTableViewCell: UITableViewCell {

    let dateLabel:UILabel = UILabel(text: "12月28日 16:40", color: TBIThemePrimaryTextColor, size: 15)
    
    let orderType:UILabel = UILabel(text: "预约用车", color: TBIThemePrimaryTextColor, size: 15)
        
    let messageLabel:UILabel = UILabel(text: "预计时长50分钟,行驶30公里", color: TBIThemeMinorTextColor, size: 12)
    
    let startLabel:UILabel = UILabel(text: "湖南省长沙市开福区东风路50号", color: TBIThemePrimaryTextColor, size: 14)
    
    let endLabel:UILabel = UILabel(text: "长沙喜来登大酒店", color: TBIThemePrimaryTextColor, size: 14)
    
    let startImg:UIImageView = UIImageView.init(imageName: "ic_car_start")
    
    let endImg:UIImageView = UIImageView.init(imageName: "ic_car_end")
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView () {
        self.backgroundColor  = TBIThemeMinorColor
        self.contentView.layer.cornerRadius = 5
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = TBIThemeGrayLineColor.cgColor
        self.contentView.backgroundColor = TBIThemeWhite
        self.contentView.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.right.equalToSuperview().inset(5)
            make.bottom.equalToSuperview()
        }
        self.contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(15)
        }
        self.contentView.addSubview(orderType)
        orderType.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.top.equalTo(15)
        }
        self.contentView.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(dateLabel.snp.bottom).offset(20)
        }
        self.contentView.addSubview(startImg)
        startImg.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(messageLabel.snp.bottom).offset(15)
            make.width.height.equalTo(16)
        }
        self.contentView.addSubview(endImg)
        endImg.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(startImg.snp.bottom).offset(15)
            make.width.height.equalTo(16)
        }
        self.contentView.addSubview(startLabel)
        startLabel.snp.makeConstraints { (make) in
            make.left.equalTo(startImg.snp.right).offset(15)
            make.centerY.equalTo(startImg.snp.centerY)
        }
        self.contentView.addSubview(endLabel)
        endLabel.snp.makeConstraints { (make) in
            make.left.equalTo(endImg.snp.right).offset(15)
            make.centerY.equalTo(endImg.snp.centerY)
        }
       
    }
    
    func fullCell(model:CoCarForm.CarVO,time:String,mileage:String) {
        
        let date = DateInRegion(string: model.startTime, format: .custom("YYYY-MM-dd HH:mm"), fromRegion: regionRome)!
        let str = date.string(custom: "MM月dd日 HH:mm")
        dateLabel.text = str
        if       model.carType  ==  "1" {
            orderType.text = "接机"
        }else if  model.carType ==  "2" {
            orderType.text = "送机"
        }else if model.carType  ==  "3" {
            orderType.text = "预约用车"
        }
        let ti = Int(time) ?? 0
        let hour = ti / 60 < 1 ? 0:Int(ti/60)
        let minutes = ti - hour * 60
        let  times = hour == 0 ? "\(minutes)分":"\(hour)时\(minutes)分"
        
        messageLabel.text = "预计时长\(times),行驶\(mileage)公里"
        startLabel.text = model.startAddress
        endLabel.text = model.endAddress
    }

}
