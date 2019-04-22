//
//  PCommonSelectCabinsContentCell.swift
//  shanglvjia
//
//  Created by tbi on 2018/8/6.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PCommonSelectCabinsContentCell: UITableViewCell {

    typealias FlightSelectCabinsContentSVCellSelectedBlock = (NSInteger) ->Void
    
    public var flightSelectCabinsContentSVCellSelectedBlock:FlightSelectCabinsContentSVCellSelectedBlock!
    
    private let priceTitlelabel:UILabel = UILabel()
    
    private let originPricelabel = UILabel.init(text: "", color: PersonalThemeMinorTextColor, size: 14)
    
    private let remainTicketLabel:UILabel = UILabel()
    
    private let cabinTypeLabel:UILabel = UILabel()
    
    private let withdrawalPolicyLabel:UILabel = UILabel()
    
    private let bottomLine:UILabel = UILabel()
    
    
    private let selectedButtonComformIsSpecailTipDefault = "预订"//"符合预定"
    
    private let selectedButton:UIButton = UIButton()
   
    private var cellIndex:NSInteger = 0
    
    private var retreatingEi:String = ""
    
    private let nextImage = UIImageView.init(image: UIImage(named:"ic_next"))
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = TBIThemeWhite
        self.selectionStyle = .none
        setUIViewAutoLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUIViewAutoLayout() {
        
        selectedButton.setTitle(selectedButtonComformIsSpecailTipDefault, for: UIControlState.normal)
        selectedButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        selectedButton.setTitleColor(TBIThemeWhite, for: UIControlState.normal)
        selectedButton.addTarget(self, action: #selector(selectedButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        selectedButton.setBackgroundImage(UIImage (named: "yellow_btn_gradient"), for: UIControlState.normal)
        selectedButton.layer.cornerRadius = 4
        selectedButton.clipsToBounds = true
        self.contentView.addSubview(selectedButton)
        selectedButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(-2)
            make.right.equalToSuperview().inset(10)
            make.width.equalTo(80)
            make.height.equalTo(40)
            
        }
        
        priceTitlelabel.textColor = TBIThemeRedColor
        priceTitlelabel.textAlignment = NSTextAlignment.center
        priceTitlelabel.font = UIFont.systemFont(ofSize: 20)
        priceTitlelabel.adjustsFontSizeToFitWidth = true
        self.contentView.addSubview(priceTitlelabel)
        priceTitlelabel.snp.makeConstraints { (make) in
            make.top.equalTo(selectedButton).offset(-2)
            make.height.equalTo(24)
            make.right.equalTo(selectedButton.snp.left).offset(-30)
            
        }

        cabinTypeLabel.textColor = PersonalThemeMajorTextColor
        cabinTypeLabel.font = UIFont.systemFont(ofSize: 15)
        cabinTypeLabel.adjustsFontSizeToFitWidth = true
        self.contentView.addSubview(cabinTypeLabel)
        cabinTypeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(selectedButton).offset(3)
            make.left.equalToSuperview().inset(15)
            make.height.equalTo(15)
        }
        
        remainTicketLabel.textColor = PersonalThemeMajorTextColor
        remainTicketLabel.font = UIFont.systemFont(ofSize: 11)
        remainTicketLabel.adjustsFontSizeToFitWidth = true
        self.contentView.addSubview(remainTicketLabel)
        remainTicketLabel.snp.makeConstraints { (make) in
            make.left.equalTo(cabinTypeLabel.snp.right).offset(5)
            make.bottom.equalTo(cabinTypeLabel.snp.bottom).offset(1)
        }
        
        
        
        withdrawalPolicyLabel.textColor = TBIThemeMinorTextColor
        withdrawalPolicyLabel.addOnClickListener(target: self, action: #selector(showRule))
        withdrawalPolicyLabel.text = "退改政策"
        withdrawalPolicyLabel.font = UIFont.systemFont(ofSize: 12)
        withdrawalPolicyLabel.adjustsFontSizeToFitWidth = true
        self.contentView.addSubview(withdrawalPolicyLabel)
        withdrawalPolicyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(cabinTypeLabel.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(15)
            make.height.equalTo(22)
        }
        
         self.contentView.addSubview(nextImage)
        nextImage.snp.makeConstraints { (make) in
            make.left.equalTo(withdrawalPolicyLabel.snp.right)
            make.centerY.equalTo(withdrawalPolicyLabel)
            make.width.height.equalTo(16)
        }
        
        self.contentView.addSubview(originPricelabel)
        originPricelabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(withdrawalPolicyLabel)
            make.right.equalTo(priceTitlelabel)
        }
        
        
        
        bottomLine.backgroundColor = TBIThemeBaseColor
        self.contentView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(5)
        }
        
        
    }
    
    
    
    func fillDataSources(cabin:PCommonFlightSVSearchModel.CabinVO,index:NSInteger) {
        
        ///如果有协议价
        if cabin.ifAccountCodePrice == true{
            let priceContent = "协议价 ¥" + cabin.price.intValue.description
            let mutableAttribute = NSMutableAttributedString.init(string: priceContent)
            mutableAttribute.addAttributes([NSFontAttributeName:UIFont.systemFont( ofSize: 10)], range: NSRange(location: 0,length: 5))
            priceTitlelabel.attributedText = mutableAttribute
            
            let priceString = "原价 ¥" + cabin.orginPrice.floatValue.TwoOfTheEffectiveFraction()
            let priceAttribute = NSMutableAttributedString.init(string: priceString)
            priceAttribute.addAttributes([NSFontAttributeName:UIFont.systemFont( ofSize: 10)], range: NSRange(location: 0,length: 4))
            originPricelabel.attributedText = priceAttribute
        
        }else {
            let priceContent = "¥" + cabin.price.intValue.description
            let mutableAttribute = NSMutableAttributedString.init(string: priceContent)
            mutableAttribute.addAttributes([NSFontAttributeName:UIFont.systemFont( ofSize: 10)], range: NSRange(location: 0,length: 1))
            priceTitlelabel.attributedText = mutableAttribute
        }
        retreatingEi = cabin.ei
        
        cellIndex = index
        
        if cabin.amount == -1 {
            remainTicketLabel.isHidden = true
        }else
        {
            remainTicketLabel.isHidden = false
            let numContent = "余" + cabin.amount.description + "张"
            let mutableAttribute = NSMutableAttributedString.init(string: numContent)
            mutableAttribute.addAttributes([NSForegroundColorAttributeName:TBIThemeRedColor], range: NSRange(location: 1,length: cabin.amount.description.count))
           remainTicketLabel.attributedText = mutableAttribute
            /// remainTicketLabel.text =  "余" + cabin.amount.description + "张"
        }
        
        
        var discount:String = ""
        if cabin.discount.intValue == 10 {
            discount = "全价"
        }else{
            discount = cabin.discount.floatValue.OneOfTheEffectiveFraction() + "折"
        }
 
        cabinTypeLabel.text = cabin.shipping + discount

        
    }
    
   func showRule() {
        popPersonalNewAlertView(content:retreatingEi,titleStr:"温馨提示",btnTitle:"确定")
    }
    
    
    //MARK:------Action--------
    func selectedButtonAction(sender:UIButton) {
        
        if flightSelectCabinsContentSVCellSelectedBlock != nil  {
            flightSelectCabinsContentSVCellSelectedBlock(cellIndex)
        }
        
    }
    
    
    
}

