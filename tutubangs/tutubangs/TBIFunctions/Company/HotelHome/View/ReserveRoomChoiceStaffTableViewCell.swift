//
//  ReserveRoomChoiceStaffTableViewCell.swift
//  shop
//
//  Created by manman on 2017/5/23.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class ReserveRoomChoiceStaffTableViewCell: UITableViewCell {

    typealias ReserveRoomChoiceStaffSelectedBlock = (NSInteger)->Void
    public var reserveRoomChoiceStaffSelectedBlock:ReserveRoomChoiceStaffSelectedBlock!
    private var baseBackgroundView:UIView = UIView()
    private var titleContentLabel:UILabel = UILabel()
    private var titlePhoneLabel:UILabel = UILabel()
    private var titlePhoneContentLabel:UILabel = UILabel()
    private var selectedButton:UIButton = UIButton()
    private var cellIndex:NSInteger = 0
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        baseBackgroundView.backgroundColor = UIColor.white
        self.contentView.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        
        setUIViewAutolayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func setUIViewAutolayout() {
        
        
        
        titleContentLabel.text = ""
        titleContentLabel.font = UIFont.systemFont( ofSize: 15)
        titleContentLabel.tintColor = TBIThemePrimaryTextColor
        baseBackgroundView.addSubview(titleContentLabel)
        titleContentLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(25)
            make.width.equalTo(200)
            make.height.equalTo(15)
        }
        
        
        
        titlePhoneLabel.text = "联系电话:"
        titlePhoneLabel.font = UIFont.systemFont( ofSize:12)
        titlePhoneLabel.tintColor = TBIThemeMinorColor
        titlePhoneLabel.adjustsFontSizeToFitWidth = true
        baseBackgroundView.addSubview(titlePhoneLabel)
        titlePhoneLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(titleContentLabel.snp.bottom).offset(5)
            make.height.equalTo(12)
        }
        
        
        
        titlePhoneContentLabel.text = ""
        titlePhoneContentLabel.font = UIFont.systemFont( ofSize: 12)
        titlePhoneContentLabel.tintColor = TBIThemeMinorColor
        titlePhoneContentLabel.adjustsFontSizeToFitWidth = true
        baseBackgroundView.addSubview(titlePhoneContentLabel)
        titlePhoneContentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titlePhoneLabel.snp.right).offset(5)
            make.top.equalTo(titlePhoneLabel.snp.top)
            make.width.equalTo(200)
            make.height.equalTo(12)
        }
        
        
        
        selectedButton.setImage(UIImage.init(named: "squareSelected"), for: UIControlState.selected)
        selectedButton.setImage(UIImage.init(named:"squareUnselected" ), for: UIControlState.normal)
        selectedButton.addTarget(self, action: #selector(selectedButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        baseBackgroundView.addSubview(selectedButton)
        selectedButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.equalTo(20)
            make.height.equalTo(20)
            make.right.equalToSuperview().inset(15)
        }
        
        
        
        
        
    }
    
    func fillDataSources(name:String,phone:String,selectedState:Bool,index:NSInteger) {
        
        titleContentLabel.text = name
        titlePhoneContentLabel.text = phone
        selectedButton.isSelected = selectedState
        cellIndex = index
    }
    
    
    
    func selectedButtonAction(sender:UIButton)  {
        if sender.isSelected == true {
            sender.isSelected = false
        }
        else
        {
            sender.isSelected = true
        }
        reserveRoomChoiceStaffSelectedBlock(cellIndex)
    }
    
    
    
    
    
}
