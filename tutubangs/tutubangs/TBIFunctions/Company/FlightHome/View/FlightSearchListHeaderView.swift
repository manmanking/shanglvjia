//
//  FlightSearchListHeaderView.swift
//  shop
//
//  Created by SLMF on 2017/4/27.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class FlightSearchListHeaderView: UIView {
    
    let previousLabel: UILabel
    let nextLabel: UILabel
    let dateView = FlightSearchListDateView.init()
    let width: CGFloat = (ScreenWindowWidth - 135) / 2
    init() {
        previousLabel = UILabel.init(text: NSLocalizedString("flight.header.previous", comment: "前一天"), color: TBIThemeWhite, size: 12)
        nextLabel = UILabel.init(text: NSLocalizedString("flight.header.next", comment: "后一天"), color: TBIThemeWhite, size: 12)
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

class FlightSearchListDateView: UIView {
    
    let dateLabel = UILabel.init(text: "", color: TBIThemeBlueColor, size: 13)
    let dayLabel = UILabel.init(text: "", color: TBIThemeBlueColor, size: 13)
    let priceLabel = UILabel.init(text: "", color: TBIThemeOrangeColor, size: 13)
    
    init() {
        super.init(frame: CGRect.init(x: 0, y: 0, width: 270, height: 30))
        self.backgroundColor = TBIThemeWhite
        self.layer.cornerRadius = 2
        self.addSubview(dateLabel)
        self.addSubview(dayLabel)
        self.addSubview(priceLabel)
        dayLabel.snp.makeConstraints { (make) in
            make.center.equalTo(self.snp.center)
        }
        dateLabel.snp.makeConstraints{ (make) in
            make.left.equalToSuperview().offset(7)
            make.top.equalTo(dayLabel.snp.top)
        }
        priceLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-7)
            make.top.equalTo(dateLabel.snp.top)
        }
    }
    
    func setData(date: String, day: String, price: String) {
        self.dateLabel.text = date
        self.dayLabel.text = day
        self.priceLabel.text = "￥\(price)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

