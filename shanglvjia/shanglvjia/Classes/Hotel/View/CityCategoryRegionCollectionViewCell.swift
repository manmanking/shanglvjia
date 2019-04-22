//
//  CityCategoryRegionCollectionViewCell.swift
//  shanglvjia
//
//  Created by manman on 2018/4/23.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class CityCategoryRegionCollectionViewCell: UICollectionViewCell {
    
    private var titleLabel:UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = TBIThemeBaseColor
        self.contentView.layer.cornerRadius = 4
        setUIViewAutolayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUIViewAutolayout() {
        titleLabel.text = ""
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.numberOfLines = 0
        titleLabel.layer.cornerRadius = 2
        titleLabel.clipsToBounds = true
        titleLabel.textColor = TBIThemePrimaryTextColor
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
    }
    
    
    func fillDataSources(title:String) {
        titleLabel.text = title
    }
    
    func fillDataSources(title:String,isSelected:Bool) {
        titleLabel.text = title
        if isSelected == true {
            titleLabel.textColor = TBIThemeWhite
            titleLabel.backgroundColor = PersonalThemeNormalColor
        }else{
            titleLabel.backgroundColor = TBIThemeBaseColor
            titleLabel.textColor = TBIThemePrimaryTextColor
        }
        
    }
    
    
    
}
