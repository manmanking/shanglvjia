//
//  TravelLocalCityCollectionViewCell.swift
//  shop
//
//  Created by TBI on 2017/7/16.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class TravelLocalCityCollectionReusableView: UICollectionReusableView {
    
    fileprivate var  title:UILabel = UILabel(text: "", color: TBIThemeWhite, size: 14)
    
    fileprivate let  leftLine =  UIImageView.init(imageName: "ic_pattern_left_white")
    
    fileprivate let  rightLine =  UIImageView.init(imageName: "ic_pattern_right_white")

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(title)
        title.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-19)
        }
        addSubview(leftLine)
        leftLine.snp.makeConstraints { (make) in
            make.centerY.equalTo(title.snp.centerY)
            make.right.equalTo(title.snp.left).offset(-5)
        }
        addSubview(rightLine)
        rightLine.snp.makeConstraints { (make) in
            make.centerY.equalTo(title.snp.centerY)
            make.left.equalTo(title.snp.right).offset(5)
        }
    }
    
    func fillCell(name:String) {
        self.title.font  = UIFont.boldSystemFont(ofSize: 14)
        if name == "国内" {
            title.text = "国内主推"
        }else if name == "国际" {
            title.text = "境外主推"
        }
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TravelLocalCityCollectionViewCell: UICollectionViewCell {
    
    var title:UILabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 13)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        title.textAlignment = .center
        title.backgroundColor = TBIThemeWhite
        title.layer.cornerRadius = 5
        title.layer.masksToBounds = true
        addSubview(title)
        title.snp.makeConstraints { (make) in
            make.size.equalToSuperview()
        }
    }
    
    func fillCell(name:String) {
        title.text = name
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
