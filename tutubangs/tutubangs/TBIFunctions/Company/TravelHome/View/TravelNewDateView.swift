//
//  TravelNewDateView.swift
//  shop
//
//  Created by TBI on 2017/7/3.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class TravelNewDateView: UIView {
    
    typealias  TravelNewDateViewBlock = (String)->Void
    
    
    public var travelNewDateViewBlock:TravelNewDateViewBlock!
    fileprivate var img =  UIImageView(imageName:"ic_site")
    
    var startCityLabel = UILabel(text: "\(cityName)出发", color: TBIThemePrimaryTextColor, size: 13)
    
    var newDayLabel = UIButton(title:"[发起新日期]",titleColor: TBIThemeBlueColor,titleSize: 11)//UILabel(text: "[发起新日期]", color: TBIThemeBlueColor, size: 11)
    
    fileprivate let line = UILabel(color: TBIThemeGrayLineColor)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(img)
        img.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
            make.height.equalTo(16)
            make.width.equalTo(12)
        }
        addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        addSubview(startCityLabel)
        startCityLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(img.snp.right).offset(3)
        }
        addSubview(newDayLabel)
        newDayLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
        }
        
        newDayLabel.setEnlargeEdgeWithTop(20 ,left: 40, bottom: 20, right: 40)

        newDayLabel.isUserInteractionEnabled = true
        newDayLabel.addOnClickListener(target: self, action: #selector(newDayLabelAction))
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func newDayLabelAction() {
        travelNewDateViewBlock("selected")
    }
    
    
    
    
}
