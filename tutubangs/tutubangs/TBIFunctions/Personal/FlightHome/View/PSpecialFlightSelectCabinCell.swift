//
//  PSpecialFlightSelectCabinCell.swift
//  shanglvjia
//
//  Created by tbi on 2018/8/7.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PSpecialFlightSelectCabinCell: UITableViewCell {

    typealias FlightSelectCabinsContentSVCellSelectedBlock = (NSInteger) ->Void
    
    public var flightSelectCabinsContentSVCellSelectedBlock:FlightSelectCabinsContentSVCellSelectedBlock!
    
    private let priceTitlelabel:UILabel = UILabel()
    
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
            make.top.equalTo(selectedButton)
            make.height.equalTo(24)
            make.left.equalTo(14)
            
        }
        
        remainTicketLabel.textColor = PersonalThemeMajorTextColor
        remainTicketLabel.font = UIFont.systemFont(ofSize: 11)
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
            make.top.equalTo(priceTitlelabel.snp.bottom).offset(8)
            make.left.equalTo(priceTitlelabel)
            make.height.equalTo(15)
        }
        
        withdrawalPolicyLabel.textColor = TBIThemeMinorTextColor
        withdrawalPolicyLabel.addOnClickListener(target: self, action: #selector(showRule))
        withdrawalPolicyLabel.text = "|   退改政策"
        withdrawalPolicyLabel.font = UIFont.systemFont(ofSize: 12)
        withdrawalPolicyLabel.adjustsFontSizeToFitWidth = true
        self.contentView.addSubview(withdrawalPolicyLabel)
        withdrawalPolicyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(cabinTypeLabel)
            make.left.equalTo(cabinTypeLabel.snp.right).offset(13)
            make.height.equalTo(cabinTypeLabel)
        }
        
        self.contentView.addSubview(nextImage)
        nextImage.snp.makeConstraints { (make) in
            make.left.equalTo(withdrawalPolicyLabel.snp.right)
            make.centerY.equalTo(withdrawalPolicyLabel)
            make.width.height.equalTo(16)
        }
        
        
        
        bottomLine.backgroundColor = TBIThemeBaseColor
        self.contentView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(5)
        }
        
        
    }
    
    
    
    func fillDataSources(cabin:PSepcailFlightCabinModel.CabinInfosList,index:NSInteger) {
        
        let priceContent = "¥" + cabin.cabinPrice.TwoOfTheEffectiveFraction()
        let mutableAttribute = NSMutableAttributedString.init(string: priceContent)
        mutableAttribute.addAttributes([NSFontAttributeName:UIFont.systemFont( ofSize: 12)], range: NSRange(location: 0,length: 1))
        priceTitlelabel.attributedText = mutableAttribute
        
        cellIndex = index
        
//        if cabin.amount == -1 {
//            remainTicketLabel.isHidden = true
//        }else
//        {
//            remainTicketLabel.isHidden = false
//            remainTicketLabel.text =  "余" + cabin.amount.description + "张"
//        }
        
        
//        var discount:String = ""
//        if cabin.discount.intValue == 10 {
//            discount = "全价"
//        }else{
//            discount = cabin.discount.floatValue.OneOfTheEffectiveFraction() + "折"
//        }
//
        cabinTypeLabel.text = cabin.cabin
        
        retreatingEi = cabin.cabinEi
        
//        if cabin.stock == -1 || Int(cabin.stock)>8{
//            remainTicketLabel.isHidden = true
//        }else
//        {
            remainTicketLabel.isHidden = false
            let numContent = "余" + cabin.stock.description + "张"
            let numAttribute = NSMutableAttributedString.init(string: numContent)
            numAttribute.addAttributes([NSForegroundColorAttributeName:TBIThemeRedColor], range: NSRange(location: 1,length: cabin.stock.description.count))
           remainTicketLabel.attributedText = numAttribute
//        }
        
        if cabin.stock == 0{
            selectedButton.isEnabled = false
            selectedButton.setTitle("已售罄", for: .normal)
            selectedButton.setBackgroundImage(UIColor.creatImageWithColor(color: UIColor.lightGray), for: .normal)
        }
        
       
        
    }
    
    
    func showRule() {
        popPersonalNewAlertView(content:retreatingEi,titleStr:"温馨提示",btnTitle:"我知道了")
    }
    
    func fillDataSourcesOnsale(cabin:PCommonFlightSVSearchModel.CabinVO,index:NSInteger) {
        
        let priceContent = "¥" + cabin.price.floatValue.TwoOfTheEffectiveFraction()
        let mutableAttribute = NSMutableAttributedString.init(string: priceContent)
        mutableAttribute.addAttributes([NSFontAttributeName:UIFont.systemFont( ofSize: 12)], range: NSRange(location: 0,length: 1))
        priceTitlelabel.attributedText = mutableAttribute
        
        cellIndex = index
    
        cabinTypeLabel.text = cabin.shipping
        
        if cabin.amount == -1 || Int(cabin.amount)>8{
            remainTicketLabel.isHidden = true
        }else
        {
            remainTicketLabel.isHidden = false
            let numContent = "余" + cabin.amount.description + "张"
            let mutableAttribute = NSMutableAttributedString.init(string: numContent)
            mutableAttribute.addAttributes([NSForegroundColorAttributeName:TBIThemeRedColor], range: NSRange(location: 1,length: cabin.amount.description.count))
            remainTicketLabel.attributedText = mutableAttribute
            //remainTicketLabel.text =  "余" + cabin.amount.description + "张"
        }
        
        retreatingEi = cabin.ei
        
        if cabin.amount == 0{
            selectedButton.isEnabled = false
            selectedButton.setTitle("已售罄", for: .normal)
            selectedButton.setBackgroundImage(UIColor.creatImageWithColor(color: UIColor.lightGray), for: .normal)
        }
        
    }
    
    //MARK:------Action--------
    func selectedButtonAction(sender:UIButton) {
        
        if flightSelectCabinsContentSVCellSelectedBlock != nil  {
            flightSelectCabinsContentSVCellSelectedBlock(cellIndex)
        }
        
    }
    

}
