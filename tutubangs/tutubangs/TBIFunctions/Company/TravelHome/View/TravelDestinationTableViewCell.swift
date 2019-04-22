//
//  TravelDestinationTableViewCell.swift
//  shop
//
//  Created by TBI on 2017/7/11.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class TravelDestinationTableViewCell: UITableViewCell {

    let  titleLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 14)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = TBIThemeBaseColor
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    func fillCell(title:String,selectFlag:Bool){
        titleLabel.text = title
        if selectFlag {
            titleLabel.textColor = TBIThemeBlueColor
            self.backgroundColor = TBIThemeWhite
        }else {
            self.backgroundColor = TBIThemeBaseColor
            titleLabel.textColor = TBIThemePrimaryTextColor
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
