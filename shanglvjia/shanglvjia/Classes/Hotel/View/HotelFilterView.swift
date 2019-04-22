//
//  HotelFilterView.swift
//  shanglvjia
//
//  Created by manman on 2018/4/24.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class HotelFilterView: UIView {

    typealias HotelFilterViewBlock = (NSInteger)->Void
    
    /// 选择回调 0 列表模式 1 地图模式 2 条件筛选
    public var hotelFilterViewBlock:HotelFilterViewBlock!
    
    private let baseBackgroundView:UIView = UIView()
    private let mapFlagImageView:UIImageView = UIImageView()
    private let mapTitleLabel:UILabel = UILabel()
    
    private let searchFlagImageView:UIImageView = UIImageView()
    private let searchTitleLabel:UILabel = UILabel()
    
    private var currentSearchIndex:NSInteger = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(baseBackgroundView)
        baseBackgroundView.backgroundColor = UIColor.black
        baseBackgroundView.alpha = 0.6
        baseBackgroundView.layer.cornerRadius = 4
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        setUIViewAutolayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUIViewAutolayout() {
        mapFlagImageView.image = UIImage.init(named: "ic_hotel_map")
        mapFlagImageView.contentMode = UIViewContentMode.scaleAspectFit
        self.addSubview(mapFlagImageView)
        mapFlagImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(ScreenWindowWidth / 5)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(20)
        }
        
        mapTitleLabel.text = "地图模式"
        mapTitleLabel.font = UIFont.systemFont(ofSize: 12)
        mapTitleLabel.addOnClickListener(target: self, action: #selector(selectedPattern(tag:)))
        mapTitleLabel.textColor = TBIThemeWhite
        self.addSubview(mapTitleLabel)
        mapTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(mapFlagImageView.snp.right).offset(2)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(50)
        }
        
        searchFlagImageView.image = UIImage.init(named: "ic_hotel_filter")
        searchFlagImageView.contentMode = UIViewContentMode.scaleAspectFit
        self.addSubview(searchFlagImageView)
        searchFlagImageView.snp.makeConstraints { (make) in
            make.left.equalTo(mapTitleLabel.snp.right).offset(ScreenWindowWidth / 5)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(20)
        }
        
        searchTitleLabel.text = "条件筛选"
        searchTitleLabel.font = UIFont.systemFont(ofSize: 12)
        searchTitleLabel.addOnClickListener(target: self, action: #selector(selectedPattern(tag:)))
        searchTitleLabel.textColor = TBIThemeWhite
        self.addSubview(searchTitleLabel)
        searchTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(searchFlagImageView.snp.right).offset(2)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(50)
        }
        
        
        
    }
    
    
    func selectedPattern(tag:UITapGestureRecognizer) {
        let tmpLabel:UILabel =  tag.view as! UILabel
        var selectedIndex:NSInteger = 0
        switch tmpLabel {
        case mapTitleLabel:
            if currentSearchIndex == 0 {
                selectedIndex = 1
                currentSearchIndex = 1
                mapTitleLabel.text = "列表模式"
            }else{
                selectedIndex = 0
                currentSearchIndex = 0
                mapTitleLabel.text = "地图模式"
            }
            
        case searchTitleLabel:
            selectedIndex = 2
        default:
            break
        }
        if hotelFilterViewBlock != nil {
            hotelFilterViewBlock(selectedIndex)
        }
        
    }
    

}
