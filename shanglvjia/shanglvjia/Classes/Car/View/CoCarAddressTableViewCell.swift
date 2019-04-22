//
//  CoCarAddressTableViewCell.swift
//  shop
//
//  Created by TBI on 2018/1/24.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class CoCarAddressTableViewCell: UITableViewCell {

    fileprivate let tiltleLabel:UILabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 14)
    
    fileprivate let messageLabel:UILabel = UILabel(text: "", color: TBIThemePlaceholderTextColor, size: 12)
    
    fileprivate  let  buttomLine = UILabel(color: TBIThemeGrayLineColor)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView () {
        self.contentView.addSubview(tiltleLabel)
        tiltleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview().offset(-7.5)
        }
        self.contentView.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview().offset(7.5)
        }
        self.contentView.addSubview(buttomLine)
        buttomLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    func fullCell (title:String,message:String){
        tiltleLabel.text = title
        messageLabel.text = message
    }
}
