//
//  PersonalFlightTableViewHeaderView.swift
//  shanglvjia
//
//  Created by manman on 2018/8/8.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PersonalFlightTableViewHeaderView: UITableViewCell {

    private let titleLabel:UILabel = UILabel()
    private let blueLine:UILabel = UILabel()
    private let bottomLine:UILabel = UILabel()
    let rightButton:UIButton = UIButton.init(title: "", titleColor: PersonalThemeNormalColor, titleSize: 13)

    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = TBIThemeWhite
        setUIViewAutolayout()
    }
  
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUIViewAutolayout() {
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = PersonalThemeMajorTextColor
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.bottom.equalToSuperview()
        }
        self.contentView.addSubview(rightButton)
        
        bottomLine.backgroundColor = TBIThemeGrayLineColor
        self.contentView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(0)
            make.height.equalTo(1)
        }
        
        blueLine.backgroundColor = PersonalThemeDarkColor
        self.contentView.addSubview(blueLine)
        blueLine.snp.makeConstraints { (make) in
            make.left.right.equalTo(titleLabel)
            make.height.equalTo(2)
            make.bottom.equalToSuperview()
        }
        rightButton.isHidden = true
        rightButton.contentHorizontalAlignment = .right
        rightButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(20)
            make.centerY.equalTo(titleLabel)
        }
        
    }
   
    public func fillDataSources(title:String) {
        titleLabel.text = title
        
    }
}
