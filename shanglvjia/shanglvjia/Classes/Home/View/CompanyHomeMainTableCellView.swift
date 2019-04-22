//
//  CompanyHomeMainTableCellView.swift
//  shop
//
//  Created by SLMF on 2017/4/20.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class CompanyHomeMainTableCellView: UITableViewCell {
    
    let titleImage: UIImageView = UIImageView()
    let title: UILabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 20)
    let desc: UILabel = UILabel(text: "", color: TBIThemePlaceholderTextColor, size: 10)
    let focusImage: UIImageView = UIImageView()
    let line = UILabel(color: TBIThemeGrayLineColor)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(titleImage)
        self.contentView.addSubview(title)
        self.contentView.addSubview(desc)
        self.contentView.addSubview(focusImage)
        self.contentView.addSubview(line)
        self.titleImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(25)
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
        self.title.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(21)
            make.left.equalTo(titleImage.snp.right).offset(25)
        }
        self.desc.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(3)
            make.left.equalTo(title.snp.left)
        }
        self.focusImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(34.5)
            make.right.equalToSuperview().offset(-20)
            make.width.equalTo(9)
            make.height.equalTo(15)
        }
        line.snp.makeConstraints { (make) in
            make.top.right.equalToSuperview()
            make.left.equalTo(25)
            make.height.equalTo(0.5)
        }
    }
    
    func fillData(titleImageName: String, titleStr: String, descStr: String, focusImageStr: String,row: Int) {
        self.titleImage.image = UIImage.init(named: titleImageName)
        self.title.text = titleStr
        self.desc.text =  descStr
        self.focusImage.image = UIImage(named: focusImageStr)
        if row == 0 {
            line.isHidden = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
