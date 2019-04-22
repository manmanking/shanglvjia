//
//  SweepBookingViewCell.swift
//  shop
//
//  Created by TBI on 2017/7/29.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class SweepBookingViewCell: UITableViewCell {

    let titleLabel = UILabel(text:"", color: TBIThemeMinorTextColor, size: 16)
    
    let messageLabel = UILabel(text:"", color: TBIThemeMinorTextColor, size: 13)
    
    let img:UIImageView = UIImageView(imageName:"")
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView () {
        self.backgroundColor = TBIThemeWhite
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(40)
            make.top.equalTo(72)
            
        }
        addSubview(messageLabel)
        messageLabel.snp.makeConstraints { (make) in
            make.left.equalTo(40)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
        addSubview(img)
        img.snp.makeConstraints { (make) in
            make.right.equalTo(-50)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(100)
        }
    }
    
    func fillCell(title:String,message:String,imgUrl:String) {
        titleLabel.text = title
        messageLabel.text = message
        img.image = UIImage.init(named: imgUrl)
    }

}
