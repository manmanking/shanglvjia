//
//  CityCategoryRegionCollectionReusableHeaderView.swift
//  shanglvjia
//
//  Created by manman on 2018/4/23.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class CityCategoryRegionCollectionReusableHeaderView: UICollectionReusableView {
    
    private var  baseBackgroundView:UIView = UIView()
    
    private let topLineLabel:UILabel = UILabel()
    
    private let titleLabel:UILabel = UILabel()
    
    
    private let titleFirstDefault:String = "行政区"
    
    private let titleSecondDefault:String = "地标"
    
    private let titleThirdDefault:String = "商圈"
    
    private let titleFlagImageView:UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(baseBackgroundView)
        baseBackgroundView.layer.cornerRadius = 4
        baseBackgroundView.backgroundColor = TBIThemeWhite
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        setUIViewAutolayout()
        
    }
    

    func setUIViewAutolayout() {
        
        topLineLabel.backgroundColor = TBIThemeBaseColor
        baseBackgroundView.addSubview(topLineLabel)
        topLineLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(5)
        }
        
        
        titleFlagImageView.image = UIImage.init(named: "")
        titleFlagImageView.contentMode = UIViewContentMode.scaleAspectFit
        baseBackgroundView.addSubview(titleFlagImageView)
        titleFlagImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        titleLabel.text = ""
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.textColor = TBIThemeDarkBlueColor
        baseBackgroundView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleFlagImageView)
            make.left.equalTo(titleFlagImageView.snp.right).offset(5)
//            make.width.equalTo(40)
            make.height.equalTo(30)
        }
    }
    
    
    func fillDataSources(title:String) {
        switch title {
        case titleFirstDefault:
            titleLabel.text = titleFirstDefault
            titleFlagImageView.image = UIImage.init(named: "ic_hotel_area")
        case titleSecondDefault:
            titleLabel.text = titleSecondDefault
            titleFlagImageView.image = UIImage.init(named: "ic_hotel_landscape")
        case titleThirdDefault:
            titleLabel.text = titleThirdDefault
            titleFlagImageView.image = UIImage.init(named: "ic_hotel_shop")
        default:
            break
        }
        
        
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
