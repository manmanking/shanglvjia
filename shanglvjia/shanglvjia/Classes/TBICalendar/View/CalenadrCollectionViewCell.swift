//
//  CalenadrCollectionViewCell.swift
//  shop
//
//  Created by TBI on 2017/6/28.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class CalenadrCollectionViewCell: UICollectionViewCell {
    
    let dayLabel:UILabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 16)
    
    let inventoryLabel:UILabel = UILabel(text: "", color: TBIThemeRedColor, size: 11)
    
    let priceLabel:UILabel = UILabel(text: "", color: TBIThemeOrangeColor, size: 11)
    
    let line = UILabel(color: TBIThemeGrayLineColor)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        dayLabel.textAlignment = .center
        self.addSubview(dayLabel)
        dayLabel.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(-0.5)
        }
        self.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-4)
        }
        self.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(0.5)
        }
        self.addSubview(inventoryLabel)
        inventoryLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(2)
        }
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
