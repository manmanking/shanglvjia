//
//  TBICalendarCell.swift
//  shop
//
//  Created by manman on 2017/7/13.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit


/*
 
 typedef NS_ENUM(NSUInteger, SelectionType) {
 SelectionTypeNone,
 SelectionTypeSelected,
 SelectionTypeLeftBorder,
 SelectionTypeMiddle,
 SelectionTypeRightBorder
 };
 
 
 */

class TBICalendarCell: UICollectionViewCell {
    private var baseBackgroundView:UIView = UIView()
    private var subBaseBackgroundImageView:UIImageView = UIImageView()
    private var titleLabel:UILabel = UILabel()
    private var subTitleLabel:UILabel = UILabel()
    private var todayFlagImageView:UIImageView = UIImageView()
    private var isActivity:Bool = true
    private var isToday:Bool = false
    private var cellSelected:Bool = false
    private var bottomLine:UILabel = UILabel()
    //internal var selected:Bool
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = UIColor.clear
        baseBackgroundView.backgroundColor = UIColor.white
        self.contentView.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        baseBackgroundView.addSubview(subBaseBackgroundImageView)
        subBaseBackgroundImageView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(0.5)
        }
        
        
        setUIViewAutolayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUIViewAutolayout() {
        
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.textColor = TBIThemePrimaryTextColor
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        baseBackgroundView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalToSuperview().dividedBy(3)
            make.centerY.equalToSuperview()
        }
        
        baseBackgroundView.addSubview(subTitleLabel)
        subTitleLabel.textAlignment = NSTextAlignment.center
        subTitleLabel.textColor = UIColor.white
        subTitleLabel.font = UIFont.systemFont( ofSize: 11)
        subTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            
        }
        baseBackgroundView.addSubview(todayFlagImageView)
        todayFlagImageView.snp.makeConstraints { (make) in
            make.top.right.equalToSuperview().inset(6)
            make.height.width.equalTo(12)
        }
        if !isToday {
            todayFlagImageView.image = UIImage.init(named: "today")
        }else{
            todayFlagImageView.image = UIImage.init(named: "red_today")
        }
  
        bottomLine.backgroundColor = TBIThemeGrayLineColor
        baseBackgroundView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(0.3)
            make.height.equalTo(0.5)
        }
    }

    func setCellTypeNone() {
        titleLabel.text = ""
        subTitleLabel.text = ""
        subBaseBackgroundImageView.backgroundColor = UIColor.white
        subBaseBackgroundImageView.alpha = 1.0
        todayFlagImageView.isHidden = true
        cellSelected = false
        isActivity = false
        isToday = false
        bottomLine.isHidden = true
    }
    func setCellTypePlaceHolder(title:String){
        titleLabel.text = title
        subTitleLabel.text = ""
        subBaseBackgroundImageView.backgroundColor = UIColor.white
        subBaseBackgroundImageView.alpha = 1.0
        todayFlagImageView.isHidden = true
        cellSelected = false
        isActivity = false
        isToday = false
        bottomLine.isHidden = false
    }
    
    func setCellTypeFirstSelected(title:String,subTitle:String,today:Bool) {
        titleLabel.text = title
        titleLabel.textColor = UIColor.white
        subTitleLabel.text = subTitle
        subTitleLabel.textColor = UIColor.white
        subBaseBackgroundImageView.backgroundColor = TBIThemeBlueColor
        subBaseBackgroundImageView.alpha = 1.0
        todayFlagImageView.isHidden = !today
        cellSelected = true
        isActivity = true
        isToday = today
        bottomLine.isHidden = false
       
    }
    func fillDataSources(title:String,subTitle:String,today:Bool,isSelected:Bool,alpha:CGFloat,activity:Bool,showLine:Bool) {
        titleLabel.text = title
        subTitleLabel.text = subTitle
        
        if isSelected == true {
            subBaseBackgroundImageView.backgroundColor = TBIThemeBlueColor
           
        }else
        {
            subBaseBackgroundImageView.backgroundColor = UIColor.white
            
        }
        subBaseBackgroundImageView.alpha = alpha
        
        isToday = today
        todayFlagImageView.isHidden = !today
        cellSelected = isSelected
        isActivity = activity
        if isActivity {
            titleLabel.textColor = TBIThemePrimaryTextColor
        }else
        {
            titleLabel.textColor = TBIThemePlaceholderTextColor
        }
        
        bottomLine.isHidden = !showLine
        
        if !today {
            todayFlagImageView.image = UIImage.init(named: "today")
        }else{
            todayFlagImageView.image = UIImage.init(named: "red_today")
        }
        
    }
    
    
    func getActivity() -> Bool {
        return isActivity
    }
    
}
