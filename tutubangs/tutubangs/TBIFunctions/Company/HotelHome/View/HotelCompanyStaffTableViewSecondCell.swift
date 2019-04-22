//
//  HotelCompanyStaffTableViewSecondCell.swift
//  shop
//
//  Created by manman on 2017/5/10.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit


typealias HotelCompanyStaffSelected = (NSInteger,Bool) ->Void


class HotelCompanyStaffTableViewSecondCell: UITableViewCell {
    
    private let alertInfo = "差旅政策或者审批规则不同不能同时选择"
    
    
    
    public  var hotelCompanyStaffSelected:HotelCompanyStaffSelected!
    //记录选中 状态
    public var selectedButtonState:Bool = false
    
    
    private var baseBackgroundView:UIView = UIView()
    private var policyMatchFlagImageView:UIImageView = UIImageView()
    private var staffNameLabel:UILabel = UILabel()
    private var staffNumTitleLabel:UILabel = UILabel()
    private var staffNumLabel:UILabel = UILabel()
    private var staffTelTitleLabel:UILabel = UILabel()
    private var staffTelLabel:UILabel = UILabel()
    private var staffMailTitleLabel:UILabel = UILabel()
    private var staffMailLabel:UILabel = UILabel()
    private var selectedButton = UIButton()
    private var cellMatch:NSInteger = 0
    private var cellIndex:NSInteger!
    
    
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = TBIThemeBaseColor
        baseBackgroundView.backgroundColor = UIColor.white
        self.contentView.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(5)
        }
        
        setUIViewAutolayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUIViewAutolayout() {
    
        //政策标记
        baseBackgroundView.addSubview(policyMatchFlagImageView)
        policyMatchFlagImageView.backgroundColor = UIColor.red
        policyMatchFlagImageView.layer.cornerRadius = 2
        policyMatchFlagImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(20)
            make.left.equalToSuperview().inset(18)
            make.width.equalTo(4)
            make.height.equalTo(17)
        }
        
        staffNameLabel.text = "徐小明"
        staffNameLabel.font = UIFont.systemFont( ofSize: 18)
        staffNameLabel.textColor = TBIThemePrimaryTextColor
        baseBackgroundView.addSubview(staffNameLabel)
        staffNameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(20)
            make.left.equalToSuperview().inset(40)
            make.height.equalTo(18)
            make.right.equalToSuperview().inset(40)
        }
        staffNumTitleLabel.text = "工号:"
        staffNumTitleLabel.adjustsFontSizeToFitWidth = true
        staffNumTitleLabel.font = UIFont.systemFont( ofSize: 13)
        staffNumTitleLabel.textColor = TBIThemePlaceholderTextColor
        baseBackgroundView.addSubview(staffNumTitleLabel)
        staffNumTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(staffNameLabel.snp.bottom).offset(5)
            make.left.equalTo(staffNameLabel.snp.left)
            make.height.equalTo(13)
        }
        
        staffNumLabel.text = "8888888888"
        staffNumLabel.adjustsFontSizeToFitWidth = true
        staffNumLabel.font = UIFont.systemFont( ofSize: 13)
        staffNumLabel.textColor = TBIThemePlaceholderTextColor
        baseBackgroundView.addSubview(staffNumLabel)
        staffNumLabel.snp.makeConstraints { (make) in
            make.top.equalTo(staffNumTitleLabel.snp.top)
            make.left.equalTo(staffNumTitleLabel.snp.right)
            make.height.equalTo(13)
            make.width.equalTo(200)
        }
        
        
        staffTelTitleLabel.text = "手机:"
        staffTelTitleLabel.adjustsFontSizeToFitWidth = true
        staffTelTitleLabel.font = UIFont.systemFont( ofSize: 13)
        staffTelTitleLabel.textColor = TBIThemePlaceholderTextColor
        baseBackgroundView.addSubview(staffTelTitleLabel)
        staffTelTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(staffNumTitleLabel.snp.bottom).offset(5)
            make.left.equalTo(staffNumTitleLabel.snp.left)
            make.height.equalTo(13)
        }
        
        staffTelLabel.text = "88888888888"
        staffTelLabel.adjustsFontSizeToFitWidth = true
        staffTelLabel.font = UIFont.systemFont( ofSize: 13)
        staffTelLabel.textColor = TBIThemePlaceholderTextColor
        baseBackgroundView.addSubview(staffTelLabel)
        staffTelLabel.snp.makeConstraints { (make) in
            make.top.equalTo(staffTelTitleLabel.snp.top)
            make.left.equalTo(staffTelTitleLabel.snp.right)
            make.height.equalTo(13)
            make.width.equalTo(200)
        }
        
        staffMailTitleLabel.text = "邮箱:"
        staffMailTitleLabel.adjustsFontSizeToFitWidth = true
        staffMailTitleLabel.font = UIFont.systemFont( ofSize: 13)
        staffMailTitleLabel.textColor = TBIThemePlaceholderTextColor
        baseBackgroundView.addSubview(staffMailTitleLabel)
        staffMailTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(staffTelTitleLabel.snp.bottom).offset(5)
            make.left.equalTo(staffTelTitleLabel.snp.left)
            make.height.equalTo(13)
        }
        
        staffMailLabel.text = "xiaoqian@btravel.com"
        staffMailLabel.adjustsFontSizeToFitWidth = true
        staffMailLabel.font = UIFont.systemFont( ofSize: 13)
        staffMailLabel.textColor = TBIThemePlaceholderTextColor
        baseBackgroundView.addSubview(staffMailLabel)
        staffMailLabel.snp.makeConstraints { (make) in
            make.top.equalTo(staffMailTitleLabel.snp.top)
            make.left.equalTo(staffMailTitleLabel.snp.right)
            make.height.equalTo(15)
            make.width.equalTo(200)
        }
        
        selectedButton.isUserInteractionEnabled=false
        selectedButton.setImage(UIImage.init(named: "unselectedSquare"), for: UIControlState.normal)
        selectedButton.setImage(UIImage.init(named: "squareSelected"), for: UIControlState.selected)
        //selectedButton.addTarget(self, action: #selector(selectedButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        baseBackgroundView.addSubview(selectedButton)
        selectedButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(15)
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
        
        
        
        
    }
    
//    //match 0 默认灰色 1蓝色 匹配成功   2 红色。匹配 失败
//    func fillDataSources(traveller:Traveller)  {
//        selectedButton.isUserInteractionEnabled = false
//        policyMatchFlagImageView.isHidden = true
//        //policyMatchFlagImageView.backgroundColor = TBIThemeBlueColor
//        staffNameLabel.text = traveller.name
//        staffNumLabel.text = traveller.employeeNo
//        staffTelLabel.text = traveller.mobile
//        staffMailLabel.text = traveller.emails.first
//    }
    //match 0 默认灰色 1蓝色 匹配成功   2 红色。匹配 失败
    func fillDataSources(traveller:QueryPassagerResponse)  {
        selectedButton.isUserInteractionEnabled = false
        policyMatchFlagImageView.isHidden = true
        //policyMatchFlagImageView.backgroundColor = TBIThemeBlueColor
        staffNameLabel.text = traveller.name
        staffNumLabel.text = traveller.employeeNo
        staffTelLabel.text = traveller.mobiles.first
        staffMailLabel.text = traveller.emails.first
    }
    
    
    
    //match 0 默认灰色 1蓝色 匹配成功   2 红色。匹配 失败
    func fillDataSources(match:NSInteger,selectedState:Bool,index:NSInteger,traveller:Traveller)  {
        cellIndex = index
        cellMatch = match
        staffNameLabel.text = traveller.name
        staffNumLabel.text = traveller.employeeNo
        staffTelLabel.text = traveller.mobile
        staffMailLabel.text = traveller.emails.first
        
        selectedButton.isSelected = selectedState
        switch match {
        case 0:
            
            policyMatchFlagImageView.backgroundColor = TBIThemeGrayLineColor
        case 1:
            policyMatchFlagImageView.backgroundColor = TBIThemeBlueColor
        case 2:
            policyMatchFlagImageView.backgroundColor = TBIThemeGrayLineColor
            
        default: break

        }
    }
    
    func fillSVDataSources(match:NSInteger,selectedState:Bool,index:NSInteger,traveller:QueryPassagerResponse) {
        cellIndex = index
        cellMatch = match
        staffNameLabel.text = traveller.name
        staffNumLabel.text = traveller.employeeNo
        staffTelLabel.text = traveller.mobiles.first ?? ""
        staffMailLabel.text = traveller.emails.first ?? ""
        
        selectedButton.isSelected = selectedState
        switch match {
        case 0:
            
            policyMatchFlagImageView.backgroundColor = TBIThemeGrayLineColor
        case 1:
            policyMatchFlagImageView.backgroundColor = TBIThemeBlueColor
        case 2:
            policyMatchFlagImageView.backgroundColor = TBIThemeGrayLineColor
            
        default: break
            
        }
    }
    
    
    
    func selectedCell(selectedCell:HotelCompanyStaffTableViewSecondCell) {
        
        cellIndex = selectedCell.cellIndex
        selectedButtonAction(sender: selectedButton)
    }
    
    
    
    
    
    
    @objc private func selectedButtonAction(sender:UIButton) {
        
        
        if cellMatch  == 2  {
            
            showAlertViewNew(message: alertInfo)
            return
        }
        
        if sender.isSelected
        {
            sender.isSelected = false
            selectedButtonState = false
        }
        else
        {
            sender.isSelected = true
            selectedButtonState = true
        }
        self.hotelCompanyStaffSelected(cellIndex,sender.isSelected)
        
    }
    
    
    
    
    private func showAlertView(message:String) {
        let alertView = UIAlertView.init(title: "", message: alertInfo, delegate: self, cancelButtonTitle: "确定")
        alertView.show()
    }
    
    
    private func showAlertViewNew(message:String)
    {
        
        
        let alertController:UIAlertController = UIAlertController.init(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let messageAttri:NSMutableAttributedString = NSMutableAttributedString.init(string: message)
        messageAttri.addAttribute(NSFontAttributeName, value: UIFont.systemFont( ofSize: 19), range: NSMakeRange(0,message.characters.count))
        messageAttri.addAttribute(NSForegroundColorAttributeName, value: TBIThemePrimaryTextColor, range: NSMakeRange(0,message.characters.count))
        alertController.setValue(messageAttri, forKey:"attributedMessage")
        let alertAction:UIAlertAction = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.cancel, handler: nil)
        alertAction.setValue(TBIThemeBlueColor, forKey: "_titleTextColor")
        alertController.addAction(alertAction)
        let controller:UIViewController = getCurrentViewController()
        controller.present(alertController, animated: true, completion: nil)
        
    }
    
    
    
    
    

}
