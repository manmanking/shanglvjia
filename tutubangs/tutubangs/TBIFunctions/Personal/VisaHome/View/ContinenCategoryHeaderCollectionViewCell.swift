//
//  ContinenCategoryHeaderCollectionViewCell.swift
//  shanglvjia
//
//  Created by manman on 2018/8/24.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class ContinenCategoryHeaderCollectionViewCell: UICollectionViewCell {
    
    private var titleLabel:UILabel = UILabel()
    
    private var blueLineLabel:UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = TBIThemeWhite
        self.contentView.layer.cornerRadius = 4
        setUIViewAutolayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUIViewAutolayout() {
        titleLabel.text = ""
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.numberOfLines = 0
        titleLabel.textColor = TBIThemePrimaryTextColor
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        blueLineLabel.backgroundColor = PersonalThemeDarkColor
        self.contentView.addSubview(blueLineLabel)
        blueLineLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(4)
            make.height.equalTo(2)
        }
        
        
        
    }
    
    
    public func fillDataSources(title:String,isSelected:Bool) {
        titleLabel.text = title
        blueLineLabel.isHidden = !isSelected
    }
    
    
    
    
    
}
