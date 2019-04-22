//
//  TravelProductCollectionViewCell.swift
//  shop
//
//  Created by TBI on 2017/6/29.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class TravelProductCollectionViewCell: UICollectionViewCell {
    
    var title:UILabel = UILabel(text: "", color: TBIThemeTipTextColor, size: 13)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        title.textAlignment = .center
        title.backgroundColor = TBIThemeBaseColor
        title.layer.cornerRadius = 2
        title.layer.masksToBounds = true
        addSubview(title)
        title.snp.makeConstraints { (make) in
            make.size.equalToSuperview()
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
