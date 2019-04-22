//
//  DateHeaderView.swift
//  shop
//
//  Created by TBI on 2017/6/29.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class DateHeaderView: UIView {
    
    let dayLabel:UILabel = UILabel(text: "", color: TBIThemeBlueColor, size: 14)

    let lastMonth:UIButton = UIButton()
    
    let nextMonth:UIButton = UIButton()
    
    let line = UILabel(color: TBIThemeBlueColor)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(dayLabel)
        
        lastMonth.setImage(UIImage(named: "ic_left_grey"), for: UIControlState.normal)
        lastMonth.setImage(UIImage(named: "ic_left_blue"), for: UIControlState.selected)
        
        nextMonth.setImage(UIImage(named: "ic_right_blue"), for: UIControlState.normal)
        lastMonth.setEnlargeEdgeWithTop(10 ,left: 30, bottom: 10, right: 30)
        nextMonth.setEnlargeEdgeWithTop(10, left: 30, bottom: 10, right: 30)
        dayLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        addSubview(lastMonth)
        lastMonth.snp.makeConstraints { (make) in
            make.left.equalTo(35)
            make.centerY.equalToSuperview()
            make.width.equalTo(8)
            make.height.equalTo(14)
        }
        addSubview(nextMonth)
        nextMonth.snp.makeConstraints { (make) in
            make.right.equalTo(-35)
            make.centerY.equalToSuperview()
            make.width.equalTo(8)
            make.height.equalTo(14)
        }
        addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
