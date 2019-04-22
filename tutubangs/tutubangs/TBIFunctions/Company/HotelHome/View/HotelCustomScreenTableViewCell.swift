//
//  HotelCustomScreenTableViewCell.swift
//  shop
//
//  Created by manman on 2017/5/4.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit






enum TBICustomScreenType:NSInteger{
    case Flight = 1
    case Hotel = 2
    case Default = 0
}


class HotelCustomScreenTableViewCell: UITableViewCell {

    typealias HotelCustomScreenSelectedConditionBlock  = (NSInteger)->Void
    public var hotelCustomScreenSelectedConditionBlock:HotelCustomScreenSelectedConditionBlock!
    public var customScreenType:TBICustomScreenType = TBICustomScreenType.Default
    private let backgroundview = UIView()
    private let bottomLine = UILabel()
    private let titleLabel = UILabel()
    private let selectedButton = UIButton.init(type: UIButtonType.custom)
    private var cellIndex:NSInteger = 0
    
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundview.backgroundColor = UIColor.white
        self.contentView.addSubview(backgroundview)
        backgroundview.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        setUIViewAutolayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setUIViewAutolayout() {
       
        titleLabel.text = ""
        titleLabel.textColor = TBIThemePrimaryTextColor
        titleLabel.font = UIFont.systemFont( ofSize: 14)
        backgroundview.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
            make.left.equalToSuperview().inset(15)
            make.width.equalToSuperview().inset(30)
        }
        selectedButton.setImage(UIImage.init(named: "squareUnselected"), for: UIControlState.normal)
        selectedButton.setImage(UIImage.init(named: "squareSelected"), for: UIControlState.selected)
        selectedButton.imageView?.contentMode = UIViewContentMode.scaleAspectFill
        selectedButton.addTarget(self, action: #selector(selectedButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        backgroundview.addSubview(selectedButton)
        selectedButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
        bottomLine.backgroundColor = TBIThemeGrayLineColor
        backgroundview.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(15)
            make.bottom.right.equalToSuperview()
            make.height.equalTo(0.5)
            
        }
    }
    
    //,selectedImage:String?
    func cellConfig(title:String,selected:Bool,index:NSInteger,selectedImage:String?) {
        print("index",index,"selectedImage",selectedImage)
        titleLabel.text = title
        cellIndex = index
       
        switch customScreenType {
        case .Hotel:
            break
        case .Flight:
            
            if selected {
                selectedButton.setImage(UIImage.init(named: selectedImage!), for: UIControlState.selected)
            }else
            {
                selectedButton.setImage(UIImage.init(named: selectedImage!), for: UIControlState.normal)
            }
            
            
            break
        case .Default:
            break
        default:
            break
        }
        
        if selected {
            selectedButton.isSelected = selected
        }else
        {
            selectedButton.isSelected = selected
        }
        
        
    }
    
    
    
    
    
    
    
    //MARK:------- Action
    
    func selectedButtonAction(sender:UIButton) {
        self.hotelCustomScreenSelectedConditionBlock(cellIndex)
        
    }
    
    
    
    
    

}
