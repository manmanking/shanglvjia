//
//  CoTrainListHeaderView.swift
//  shop
//
//  Created by TBI on 2017/12/26.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class CoTrainListHeaderView: UIView {
    
    let previousLabel: UILabel = UILabel(text: NSLocalizedString("flight.header.previous", comment: "前一天"), color: TBIThemeWhite, size: 12)
    let nextLabel: UILabel = UILabel(text: NSLocalizedString("flight.header.next", comment: "后一天"), color: TBIThemeWhite, size: 12)
    let dateView = CoTrainSearchListDateView()
    let width: CGFloat = (ScreenWindowWidth - 135) / 2
    init() {
        previousLabel.textAlignment = .center
        nextLabel.textAlignment = .center
        super.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        self.backgroundColor = TBIThemeBlueColor
        self.layer.borderWidth = 0
        self.addSubview(previousLabel)
        self.addSubview(nextLabel)
        self.addSubview(dateView)
    
        dateView.snp.makeConstraints { (make) in
            make.center.equalTo(self.snp.center)
            make.width.equalTo(135)
            make.height.equalTo(30)
        }
        previousLabel.snp.makeConstraints { (make) in
            make.height.equalToSuperview()
            make.width.equalTo(self.width)
            make.left.equalToSuperview()
            make.top.equalToSuperview()
        }
        nextLabel.snp.makeConstraints { (make) in
            make.height.equalTo(previousLabel.snp.height)
            make.width.equalTo(previousLabel.snp.width)
            make.right.equalToSuperview()
            make.top.equalTo(previousLabel.snp.top)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class CoTrainSearchListDateView: UIView {
    
    ///ic_train_date
    let dateImage = UIImageView(imageName: "")
    let dayLabel = UILabel.init(text: "", color: TBIThemeBlueColor, size: 13)
    let downImage = UIImageView(imageName: "ic_train_down")
    
    init() {
        super.init(frame: CGRect.init(x: 0, y: 0, width: 270, height: 30))
        self.backgroundColor = TBIThemeWhite
        self.layer.cornerRadius = 2
        self.addSubview(dateImage)
        self.addSubview(dayLabel)
        self.addSubview(downImage)
        dayLabel.snp.makeConstraints { (make) in
            make.center.equalTo(self.snp.center)
        }
        dateImage.snp.makeConstraints{ (make) in
            make.left.equalToSuperview()
            make.top.equalTo(dayLabel.snp.top)
        }
        downImage.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-7)
            make.top.equalTo(dateImage.snp.top)
        }
    }
    
    func setData(date: String, day: String, price: String) {
        self.dayLabel.text = day
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
// 往返车次header 45px
class CoTrainListHeaderTrainsView: UIView {

    fileprivate let bgView = UIView()

    let titleLabel: UILabel = UILabel(text: "去程", color: TBIThemeWhite, size: 12)
    
    let dateLabel: UILabel = UILabel(text: "", color: TBIThemeWhite, size: 12)
    
    let cityLabel: UILabel = UILabel(text: "", color: TBIThemeWhite, size: 12)
    
    let timeLabel: UILabel = UILabel(text: "", color: TBIThemeWhite, size: 12)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    func initView () {
        self.backgroundColor = TBIThemeBlueColor
        bgView.layer.cornerRadius = 5
        bgView.backgroundColor = UIColor(r:255,g:255,b:255,alpha:0.25)
        self.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(10)
            make.height.equalTo(30)
        }
        bgView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
        bgView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right).offset(12)
            make.centerY.equalToSuperview()
        }
        bgView.addSubview(cityLabel)
        cityLabel.snp.makeConstraints { (make) in
            make.left.equalTo(dateLabel.snp.right).offset(17)
            make.centerY.equalToSuperview()
        }
        bgView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(cityLabel.snp.right).offset(15)
            make.centerY.equalToSuperview()
        }
    }
    
    func initData () {
        let index = TrainManager.shareInstance.trainSearchConditionDraw().departDate.index(TrainManager.shareInstance.trainSearchConditionDraw().returnDate.endIndex, offsetBy: -5)
        dateLabel.text = TrainManager.shareInstance.trainSearchConditionDraw().departDate.substring(from: index)
        cityLabel.text = "\(TrainManager.shareInstance.trainSearchConditionDraw().fromStationName) - \(TrainManager.shareInstance.trainSearchConditionDraw().toStationName)"
        timeLabel.text = "\(TrainManager.shareInstance.trainStartStationDraw().startTime) - \(TrainManager.shareInstance.trainStartStationDraw().arriveTime)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
