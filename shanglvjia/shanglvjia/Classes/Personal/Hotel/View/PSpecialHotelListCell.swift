//
//  PSpecialHotelListCell.swift
//  shanglvjia
//
//  Created by tbi on 2018/7/30.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PSpecialHotelListCell: UITableViewCell {

    let lineLabel = UILabel()
    var moneyLabel = UILabel.init(text: "", color: TBIThemePrimaryWarningColor, size: 20)
    var visaTitleLabel = UILabel.init(text: "", color: TBIThemePrimaryTextColor, size: 14)
    var visaImageView = UIImageView()
    var protocolLabel = UILabel.init(text: " 协议 ", color: PersonalThemeDarkColor, size: 10)
    var prepayLabel = UILabel.init(text: " 预付 ", color: PersonalThemeDarkColor, size: 10)
    fileprivate var sepcialLabel = UILabel.init(text: " 推荐 ", color: TBIThemeWhite, size: 8)
    
    private let peymentTypePrepayTipDefault:String = " 预付 "
    private let peymentTypePaynowTipDefault:String = " 现付 "
    
    private var addressLabel = UILabel.init(text: "", color: TBIThemePrimaryTextColor, size: 12)
    private var roomStyleLabel = UILabel.init(text: "", color: UIColor(red: 47.0 / 255.0, green: 160.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0), size: 12)
    
    fileprivate var hotelStarBackgroundView:UIView = UIView()
    fileprivate var hotelStarView = UIImageView()
    
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
        self.backgroundColor = TBIThemeWhite
        self.selectionStyle = .none
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initView(){
        self.addSubview(visaImageView)
        self.addSubview(visaTitleLabel)
        self.addSubview(lineLabel)
         self.addSubview(protocolLabel)
        self.addSubview(prepayLabel)
        self.addSubview(moneyLabel)
        self.addSubview(addressLabel)
        self.addSubview(roomStyleLabel)
        ///visaImageView.addSubview(sepcialLabel)
        
        visaImageView.layer.cornerRadius = 2
        visaImageView.clipsToBounds = true
        visaImageView.backgroundColor = TBIThemeBaseColor
        visaImageView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.bottom.equalToSuperview().inset(10)
            make.width.equalTo(112)
            make.height.equalTo(74)
        }
        
        visaTitleLabel.numberOfLines = 2
        visaTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(visaImageView.snp.right).offset(16)
            make.right.equalTo(-15)
            make.top.equalTo(visaImageView)
        }
        
        addressLabel.snp.makeConstraints { (make) in
            make.right.left.equalTo(visaTitleLabel)
            make.centerY.equalTo(visaImageView)
        }
        
        roomStyleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(visaTitleLabel)
            make.top.equalTo(addressLabel.snp.bottom).offset(5)
        }
        
        lineLabel.backgroundColor = TBIThemeGrayLineColor
        lineLabel.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        moneyLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalTo(visaImageView)
        }
        
        protocolLabel.layer.cornerRadius = 2.0
        protocolLabel.clipsToBounds = true
        protocolLabel.layer.borderColor = PersonalThemeDarkColor.cgColor
        protocolLabel.layer.borderWidth = 1.0
        protocolLabel.snp.makeConstraints { (make) in
            make.left.equalTo(visaTitleLabel)
            make.bottom.equalTo(visaImageView)
            make.height.equalTo(15)
        }
        prepayLabel.layer.cornerRadius = 2.0
        prepayLabel.clipsToBounds = true
        prepayLabel.layer.borderColor = PersonalThemeDarkColor.cgColor
        prepayLabel.layer.borderWidth = 1.0
        prepayLabel.snp.makeConstraints { (make) in
            make.left.equalTo(protocolLabel.snp.right).offset(5)
            make.bottom.equalTo(visaImageView)
            make.height.equalTo(15)
        }
        
//        sepcialLabel.backgroundColor = TBIThemeBackgroundViewColor
//        sepcialLabel.snp.makeConstraints { (make) in
//            make.left.top.equalToSuperview()
//            make.height.equalTo(15)
//        }
        self.addSubview(hotelStarBackgroundView)
        hotelStarBackgroundView.snp.makeConstraints { (make) in
            make.centerY.equalTo(roomStyleLabel)
            make.left.equalTo(roomStyleLabel.snp.right).offset(2)
            make.width.equalTo(70)
            make.height.equalTo(13)
        }
    }
    func fillDataSourcesCell(item:SpecialHotelListResponse.SpecialHotelInfo){
        visaTitleLabel.text = item.hotelName
        let moneyAttrs = NSMutableAttributedString(string:"¥ " + (Float(item.saleRate)?.TwoOfTheEffectiveFraction())!)
        moneyAttrs.addAttributes([ NSFontAttributeName : UIFont.systemFont(ofSize: 12)],range: NSMakeRange(0,1))
        moneyLabel.attributedText = moneyAttrs
        
        visaImageView.sd_setImage(with: URL.init(string: item.cover), placeholderImage: UIImage(named: "hotel_default"))
        
        addressLabel.text = item.businessZone
        
        var styleStr = item.starRate == "5" ? "豪华型" : item.starRate == "4" ? "高档型" : item.starRate == "3" ? "舒适型" : "经济型"
        roomStyleLabel.text = "\(styleStr)·推荐指数"
//        if item.groupCode.contains(PersonalSpecialHotelCorpCode){
//            sepcialLabel.isHidden = false
//        }else {
//            sepcialLabel.isHidden = true
//        }
        ///groupCode sftm：定投，tbi：tbi协议，else：丰田
        if item.groupCode.isEmpty == false{
            protocolLabel.isHidden = false
            prepayLabel.isHidden = true
            prepayLabel.snp.remakeConstraints({ (make) in
                make.left.equalTo(protocolLabel.snp.right).offset(5)
                make.bottom.equalTo(visaImageView)
                make.height.equalTo(15)
            })
            if item.groupCode.contains(PersonalSpecialHotelCorpCode) {
                protocolLabel.text = " 推荐 "
            }else if item.groupCode.contains(PersonaltbiCorpCode) {
                protocolLabel.text = " TBI协议 "
            }else{
                protocolLabel.text = " 丰田协议 "
            }
        }else{
            protocolLabel.isHidden = true
            prepayLabel.isHidden = false
                prepayLabel.snp.remakeConstraints({ (make) in
                    make.left.equalTo(visaTitleLabel)
                    make.bottom.equalTo(visaImageView)
                    make.height.equalTo(15)
                })
            
        }
        prepayLabel.isHidden = true
        if item.payType == "1" {
            prepayLabel.text = peymentTypePrepayTipDefault
        }else {
            prepayLabel.text = peymentTypePaynowTipDefault
            
        }
        
        if hotelStarBackgroundView.subviews.count > 0 {
            _ = hotelStarBackgroundView.subviews.map{
                if $0.isKind(of: UIImageView.self) == true {
                    $0.removeFromSuperview()
                }
            }
        }
        
        let numStar:NSInteger = (NSInteger(item.score) ?? 6) / 2
        let halfStar:Float = Float((NSInteger(item.score) ?? 6) % 2)
        for i in 0...(numStar - 1) {
            let tmpHotelStarImageView = UIImageView()
            tmpHotelStarImageView.image = UIImage.init(named: "ic_hotel_star")
            hotelStarBackgroundView.addSubview(tmpHotelStarImageView)
            tmpHotelStarImageView.snp.makeConstraints { (make) in
                
                make.centerY.equalTo(roomStyleLabel)
                make.left.equalTo( 12 * i)
                make.width.equalTo(12)
                make.height.equalTo(12)
            }
            if halfStar > 0 && i == (numStar - 1) {
                let tmpHalfHotelStarImageView = UIImageView()
                tmpHalfHotelStarImageView.image = UIImage.init(named: "ic_hotel_halfstar")
                hotelStarBackgroundView.addSubview(tmpHalfHotelStarImageView)
                
                tmpHalfHotelStarImageView.snp.makeConstraints { (make) in
                    
                    make.centerY.equalTo(roomStyleLabel)
                    make.left.equalTo(60 + 12 * i + 12)
                    make.width.equalTo(12)
                    make.height.equalTo(12)
                }
            }
        }
        

    }
}
