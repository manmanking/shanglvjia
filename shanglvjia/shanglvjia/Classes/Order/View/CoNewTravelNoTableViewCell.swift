//
//  CoNewTravelNoTableViewCell.swift
//  shop
//
//  Created by TBI on 2017/6/8.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class CoNewTravelContactTableViewCell: UITableViewCell {

    let titleLabel = UILabel(text: "预定用户", color: TBIThemePrimaryTextColor, size: 13)
    
    let contentLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 13)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(23)
            make.centerY.equalToSuperview()
        }
        addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.centerY.equalToSuperview()
        }
    }
    func fillCell(name:String) {
      contentLabel.text = name
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


class CoNewCustomerTableViewCell: UITableViewCell {
    
    
    let titleLabel = UILabel(text: "出差员工", color: TBIThemePrimaryTextColor, size: 13)
    
    let contentLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 13)
    
    let line = UILabel(color: TBIThemeGrayLineColor)
    
    let rightImg = UIImageView(imageName: "HotelDeleteHollow")
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(titleLabel)
        addSubview(contentLabel)
        addSubview(line)
        addSubview(rightImg)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(23)
            make.centerY.equalToSuperview()
        }
        addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(100)
            make.centerY.equalToSuperview()
        }
        line.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        rightImg.snp.makeConstraints { (make) in
            make.right.equalTo(-23)
            make.height.width.equalTo(20)
            make.centerY.equalToSuperview()
        }
    }
    func fillCell(name:String,index: IndexPath,delFlag:Bool) {
        if index.row == 0 {
            rightImg.image = UIImage(named: "HotelAddHollow")
            line.isHidden = true
            contentLabel.isHidden = true
            titleLabel.isHidden = false
        }else{
           
            line.isHidden = false
            contentLabel.isHidden = false
            titleLabel.isHidden = true
            if delFlag == true {
                rightImg.image = UIImage(named: "HotelDeleteHollow")
            }else {
                let tintImage =  UIImage.init(named: "HotelDeleteHollow")
                let newImage = tintImage?.imageWithTintColor(color: TBIThemeGrayLineColor)
                rightImg.image = newImage
            }
        }
        contentLabel.text = name
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
