//
//  CompanyHomeTripListView.swift
//  shop
//
//  Created by SLMF on 2017/4/20.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class ComapnyHomeTripListView: UIView {
    
    var idList: [String] = []
    var contentViewList: [CompanyHomeTripView] = []
    
    init() {
        super.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
    }
    
    func setContentViews(list: [String]) {
        self.idList = list
        for index in 0..<idList.count {
            //根据id取model
            let model = setExampleModel(id: idList[index])
            let content: CompanyHomeTripView = CompanyHomeTripView.init(model: model)
            self.contentViewList.append(content)
            self.addSubview(content)
        }
        for index in 0..<self.contentViewList.count {
            self.contentViewList[index].snp.makeConstraints{ (make) in
                if index > 0 {
                    make.top.equalTo(contentViewList[index - 1].snp.bottom).offset(10)
                } else {
                    make.top.equalToSuperview()
                }
                make.left.equalToSuperview()
                make.height.equalTo(176.5)
                make.width.equalToSuperview()
            }
        }
    }
    
    func setExampleModel(id: String) -> CompanyHomeTripModel {
        return CompanyHomeTripModel.init(typeLabel: "乘机", dateLabel: "03月26日", startTimeLabel: "08:30", startAirportLabel: "北京首都机场T3", arriveTimeLabel: "09:56", arriveAirportLabel: "西安咸阳机场T2", airlineCompanyLabel: "奥凯航空BK8026", noticeLabel: "距出行还有6天")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CompanyHomeTripView: UIView {
    /// 业务类型
    let typeLabel: UILabel
    let sepLineVer: UILabel
    /// 行程日期，XX月XX日
    let dateLabel: UILabel
    /// noticeLabel
    let noticeLabel: UILabel
    let sepLineHor1: UILabel
    let sepLineHor2: UILabel
    /// 起飞时间，XX：XX
    let startTimeLabel: UILabel
    /// 起飞机场
    let startAirportLabel: UILabel
    let rightArrowImage: UIImageView
    /// 到达时间，XX：XX
    let arriveTimeLabel: UILabel
    /// 到达机场
    let arriveAirportLabel: UILabel
    /// 航空公司+航班号
    let airlineCompanyLabel: UILabel
    let detailButton: UIButton
    
    init(model: CompanyHomeTripModel) {
        self.typeLabel = UILabel.init(text: model.typeLabel, color: TBIThemePrimaryTextColor, size: 13)
        self.sepLineVer = UILabel.init(color: .black)
        self.dateLabel = UILabel.init(text: model.dateLabel, color: TBIThemePrimaryTextColor, size: 13)
        self.noticeLabel = UILabel.init(text: model.noticeLabel, color: TBIThemePrimaryWarningColor, size: 13)
        self.sepLineHor1 = UILabel.init(color: TBIThemeMinorTextColor)
        self.sepLineHor2 = UILabel.init(color: TBIThemeMinorTextColor)
        self.startTimeLabel = UILabel.init(text: "\(model.startTimeLabel)起飞", color: TBIThemePrimaryTextColor, size: 20)
        self.startAirportLabel = UILabel.init(text: model.startAirportLabel, color: TBIThemeMinorTextColor, size: 13)
        self.rightArrowImage = UIImageView.init(image: UIImage.init(named: "Common_Right_Arrow_Circle_Gray"))
        self.arriveTimeLabel = UILabel.init(text: "\(model.arriveTimeLabel)到达", color: TBIThemePrimaryTextColor, size: 20)
        self.arriveAirportLabel = UILabel.init(text: model.arriveAirportLabel, color: TBIThemeMinorTextColor, size: 13)
        self.airlineCompanyLabel = UILabel.init(text: model.airlineCompanyLabel, color: TBIThemePrimaryTextColor, size: 13)
        self.detailButton = UIButton.init(title: "查看详情", titleColor: TBIThemeBlueColor, titleSize: 12)
        super.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        self.backgroundColor = .white
        self.addSubview(typeLabel)
        self.addSubview(sepLineVer)
        self.addSubview(sepLineHor1)
        self.addSubview(sepLineHor2)
        self.addSubview(dateLabel)
        self.addSubview(noticeLabel)
        self.addSubview(startTimeLabel)
        self.addSubview(startAirportLabel)
        self.addSubview(rightArrowImage)
        self.addSubview(arriveTimeLabel)
        self.addSubview(arriveAirportLabel)
        self.addSubview(airlineCompanyLabel)
        self.addSubview(detailButton)
        detailButton.layer.cornerRadius = 6
        detailButton.layer.borderColor = TBIThemeBlueColor.cgColor
        detailButton.layer.borderWidth = 1
        typeLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(25)
            make.top.equalToSuperview().offset(12.5)
        }
        sepLineVer.snp.makeConstraints { (make) in
            make.left.equalTo(typeLabel.snp.right).offset(12.5)
            make.top.equalTo(typeLabel.snp.top)
            make.height.equalTo(15)
            make.width.equalTo(1)
        }
        dateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(sepLineVer.snp.right).offset(12.5)
            make.top.equalTo(sepLineVer.snp.top)
        }
        noticeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(dateLabel.snp.top)
            make.right.equalToSuperview().offset(-25)
        }
        sepLineHor1.snp.makeConstraints { (make) in
            make.width.equalTo(ScreenWindowWidth - 50)
            make.height.equalTo(0.5)
            make.left.equalToSuperview().offset(25)
            make.top.equalTo(typeLabel.snp.bottom).offset(12.5)
        }
        startTimeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(sepLineHor1.snp.bottom).offset(25)
            make.left.equalTo(sepLineHor1.snp.left)
        }
        startAirportLabel.snp.makeConstraints { (make) in
            make.top.equalTo(startTimeLabel.snp.bottom).offset(3)
            make.left.equalTo(startTimeLabel)
        }
        rightArrowImage.snp.makeConstraints { (make) in
            make.center.equalTo(self.snp.center)
        }
        arriveTimeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(startTimeLabel)
            make.right.equalTo(noticeLabel.snp.right)
        }
        arriveAirportLabel.snp.makeConstraints { (make) in
            make.top.equalTo(arriveTimeLabel.snp.bottom).offset(3)
            make.right.equalTo(arriveTimeLabel.snp.right)
        }
        sepLineHor2.snp.makeConstraints { (make) in
            make.top.equalTo(startAirportLabel.snp.bottom).offset(25)
            make.left.equalTo(sepLineHor1)
            make.width.equalTo(sepLineHor1)
            make.height.equalTo(sepLineHor1)
        }
        airlineCompanyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(sepLineHor2.snp.bottom).offset(15.25)
            make.left.equalTo(sepLineHor2)
        }
        detailButton.snp.makeConstraints { (make) in
            make.top.equalTo(sepLineHor2.snp.bottom).offset(6.75)
            make.right.equalTo(sepLineHor2.snp.right)
            make.width.equalTo(78)
            make.height.equalTo(30)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
