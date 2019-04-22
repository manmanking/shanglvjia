//
//  TravelProductCollectionReusableView.swift
//  shop
//
//  Created by TBI on 2017/6/29.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class TravelProductCollectionReusableView: UICollectionReusableView {
    var title:UILabel = UILabel(text: "产品类型", color: TBIThemeTipTextColor, size: 13)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(title)
        title.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(10)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
