//
//  CityCategoryRegionCollectionReusableFooterView.swift
//  shanglvjia
//
//  Created by manman on 2018/4/23.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class CityCategoryRegionCollectionReusableFooterView: UICollectionReusableView {
    
    typealias CityCategoryRegionCollectionReusableFooterViewMoreDataBlock = (NSInteger,Bool)->Void
    
    public var cityCategoryRegionCollectionReusableFooterViewMoreDataBlock:CityCategoryRegionCollectionReusableFooterViewMoreDataBlock!
    
    private var  baseBackgroundView:UIView = UIView()
    
    private var moreButton:UIButton = UIButton()
    
    private var section:NSInteger = 0
    
    private var moreDataFlagButton:UIButton = UIButton()
    
    
    private let moreDataFlagButtonNormalTipDefault:String = "查看更多"
    
    private let moreDataFlagButtonSelectedTipDefault:String = "收起"
    
    /// false 关闭。true 全部打开
    private var fold:Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(baseBackgroundView)
        baseBackgroundView.backgroundColor = TBIThemeWhite
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        setUIViewAutolayout()
    }
    
    func setUIViewAutolayout() {
        moreButton.addTarget(self, action: #selector(moreButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        moreButton.setTitle(moreDataFlagButtonNormalTipDefault, for: UIControlState.normal)
        moreButton.setTitle(moreDataFlagButtonSelectedTipDefault, for: UIControlState.selected)
        moreButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        moreButton.setTitleColor(TBIThemeMinorTextColor, for: UIControlState.normal)
        baseBackgroundView.addSubview(moreButton)
        moreButton.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(60)
            make.centerX.equalToSuperview()
        }
        moreDataFlagButton.setImage(UIImage.init(named: "ic_dropdownarrow"), for: UIControlState.normal)
        moreDataFlagButton.setImage(UIImage.init(named: "ic_dropuparrow"), for: UIControlState.selected)
        baseBackgroundView.addSubview(moreDataFlagButton)
        moreDataFlagButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.equalTo(10)
            make.height.equalTo(10)
            make.left.equalTo(moreButton.snp.right).offset(5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func fillDataSources(section:NSInteger,isFold:Bool) {
        self.section = section
        moreDataFlagButton.isSelected = isFold
        moreButton.isSelected = isFold
    }
    
    func moreButtonAction(sender:UIButton) {
        if moreDataFlagButton.isSelected == false {
            //fold = true
            moreDataFlagButton.isSelected = true
            printDebugLog(message:"ic_dropuparrow")
        }else {
            //fold = false
            moreDataFlagButton.isSelected = false
            printDebugLog(message:"ic_dropdownarrow")
        }
        
        printDebugLog(message: fold == true ? "open":"fold")
        if cityCategoryRegionCollectionReusableFooterViewMoreDataBlock != nil{
            cityCategoryRegionCollectionReusableFooterViewMoreDataBlock(section,moreDataFlagButton.isSelected)
        }
    }
    
    
}
