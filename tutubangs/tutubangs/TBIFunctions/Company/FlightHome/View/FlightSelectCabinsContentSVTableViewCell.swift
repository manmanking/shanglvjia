//
//  FlightSelectCabinsContentSVTableViewCell.swift
//  shanglvjia
//
//  Created by manman on 2018/3/30.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class FlightSelectCabinsContentSVTableViewCell: UITableViewCell {
    
    
    typealias FlightSelectCabinsContentSVCellSelectedBlock = (Bool,NSInteger) ->Void
    
    public var flightSelectCabinsContentSVCellSelectedBlock:FlightSelectCabinsContentSVCellSelectedBlock!

    private let priceTitlelabel:UILabel = UILabel()
    
    private let remainTicketLabel:UILabel = UILabel()
    
    private let cabinTypeLabel:UILabel = UILabel()
    
    private let withdrawalPolicyLabel:UILabel = UILabel()
    
    private let bottomLine:UILabel = UILabel()
    
    //竖线
    private let verLine:UILabel = UILabel()
    
    private let selectedButtonComformTipDefault = "符合预订"//"符合预定"
    
    private let selectedButtonComformIsSpecailTipDefault = "预订"//"符合预定"
    
    
    private let selectedButtonViolateTipDefault = "违背预订"
    
    private let selectedButton:UIButton = UIButton()
    
    private var contraryPolicy:Bool = false
    
    private var cellIndex:NSInteger = 0

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = TBIThemeWhite
        setUIViewAutoLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUIViewAutoLayout() {
        priceTitlelabel.textColor = TBIThemeRedColor
        priceTitlelabel.textAlignment = NSTextAlignment.center
        priceTitlelabel.font = UIFont.systemFont(ofSize: 20)
        priceTitlelabel.adjustsFontSizeToFitWidth = true
        self.contentView.addSubview(priceTitlelabel)
        priceTitlelabel.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().inset(10)
            make.height.equalTo(24)
            make.left.equalToSuperview().inset(15)
            
        }
        
        remainTicketLabel.textColor = TBIThemeRedColor
        remainTicketLabel.font = UIFont.systemFont(ofSize: 10)
        remainTicketLabel.adjustsFontSizeToFitWidth = true
        self.contentView.addSubview(remainTicketLabel)
        remainTicketLabel.snp.makeConstraints { (make) in
            make.left.equalTo(priceTitlelabel.snp.right).offset(5)
            make.height.equalTo(12)
            make.bottom.equalTo(priceTitlelabel.snp.bottom).offset(-3)
        }
        
        
        
        cabinTypeLabel.textColor = TBIThemeMinorTextColor
        cabinTypeLabel.font = UIFont.systemFont(ofSize: 12)
        cabinTypeLabel.adjustsFontSizeToFitWidth = true
        self.contentView.addSubview(cabinTypeLabel)
        cabinTypeLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(16)
            make.left.equalToSuperview().inset(10)
            make.height.equalTo(15)
        }
        //竖线
        verLine.backgroundColor=TBIThemeMinorTextColor
        self.contentView.addSubview(verLine)
        verLine.snp.makeConstraints { (make) in
            make.left.equalTo(cabinTypeLabel.snp.right).offset(25)
            make.width.equalTo(1)
            make.height.equalTo(14)
            make.centerY.equalTo(cabinTypeLabel)
        }
        
        withdrawalPolicyLabel.textColor = TBIThemeMinorTextColor
        withdrawalPolicyLabel.text = "退改政策"
        withdrawalPolicyLabel.font = UIFont.systemFont(ofSize: 12)
        withdrawalPolicyLabel.adjustsFontSizeToFitWidth = true
        self.contentView.addSubview(withdrawalPolicyLabel)
        withdrawalPolicyLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(cabinTypeLabel)
            make.left.equalTo(verLine.snp.right).offset(25)
            make.height.equalTo(22)
        }
       
        selectedButton.setTitle(selectedButtonComformTipDefault, for: UIControlState.normal)
        selectedButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        selectedButton.setTitleColor(TBIThemeWhite, for: UIControlState.normal)
        selectedButton.addTarget(self, action: #selector(selectedButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        selectedButton.backgroundColor = UIColor.green
        selectedButton.layer.cornerRadius = 4
        self.contentView.addSubview(selectedButton)
        selectedButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(10)
            make.width.equalTo((ScreenWindowWidth - 20) / 5)
            make.height.equalTo(40)
            
        }
        
        bottomLine.backgroundColor = TBIThemeBaseColor
        self.contentView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(5)
        }
        
        
    }
    
    
    
    func fillDataSources(cabin:FlightSVSearchResultVOModel.CabinVO,index:NSInteger) {

        let priceContent = "¥" + cabin.price.intValue.description
        let mutableAttribute = NSMutableAttributedString.init(string: priceContent)
        mutableAttribute.addAttributes([NSFontAttributeName:UIFont.systemFont( ofSize: 12)], range: NSRange(location: 0,length: 1))
        priceTitlelabel.attributedText = mutableAttribute
        
        cellIndex = index
        
        if cabin.amount == -1 {
            remainTicketLabel.isHidden = true
        }else
        {
            remainTicketLabel.isHidden = false
            remainTicketLabel.text =  "仅" + cabin.amount.description + "张"
        }
        
        
        var discount:String = ""
        if cabin.discount.intValue == 10 {
            discount = "全价"
        }else{
            discount = cabin.discount.floatValue.OneOfTheEffectiveFraction() + "折"
        }
        
        let userInfo = DBManager.shareInstance.userDetailDraw()
        cabinTypeLabel.text = cabin.shipping + discount
        contraryPolicy = cabin.contraryPolicy
        if cabin.contraryPolicy {
            selectedButton.setTitle(selectedButtonViolateTipDefault, for: UIControlState.normal)
            
            if userInfo?.busLoginInfo.userBaseInfo.canOrder == "1" {
                selectedButton.backgroundColor = TBIThemeRedColor
            }else {
                selectedButton.backgroundColor = TBIThemePlaceholderColor
            }
            
        }else
        {
            selectedButton.setTitle(selectedButtonComformTipDefault, for: UIControlState.normal)
            selectedButton.backgroundColor = TBIThemeGreenColor
        }
        //特殊差标
        if PassengerManager.shareInStance.passengerSVDraw().first?.isSpecial == "1" {
            
            selectedButton.setTitle(selectedButtonComformIsSpecailTipDefault, for: UIControlState.normal)
            selectedButton.backgroundColor = TBIThemeGreenColor
        }
        
    }
    
    
    
    //MARK:------Action--------
    func selectedButtonAction(sender:UIButton) {
        
        if flightSelectCabinsContentSVCellSelectedBlock != nil  {
            flightSelectCabinsContentSVCellSelectedBlock(contraryPolicy,cellIndex)
        }
        
    }
    
    

}
