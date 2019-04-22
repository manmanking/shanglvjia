//
//  PCommonHotelListCell.swift
//  shanglvjia
//
//  Created by tbi on 2018/8/1.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PCommonHotelListCell: UITableViewCell {

    let lineLabel = UILabel()
    var moneyLabel = UILabel.init(text: "", color: TBIThemePrimaryWarningColor, size: 20)
    var visaTitleLabel = UILabel.init(text: "", color: TBIThemePrimaryTextColor, size: 14)
    var visaImageView = UIImageView()
    var protocolLabel = UILabel.init(text: " 协议 ", color: PersonalThemeNormalColor, size: 10)
    var prepayLabel = UILabel.init(text: " 预付 ", color: PersonalThemeNormalColor, size: 10)
    fileprivate var sepcialLabel = UILabel.init(text: " 推荐 ", color: TBIThemeWhite, size: 8)
    
    private var addressLabel = UILabel.init(text: "", color: TBIThemePrimaryTextColor, size: 12)
    
    ///星星
    fileprivate var hotelStarTitleLabel = UILabel()
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
        //visaImageView.addSubview(sepcialLabel)
        
        visaImageView.layer.cornerRadius = 2
        visaImageView.clipsToBounds = true
        visaImageView.backgroundColor = TBIThemeBaseColor
        visaImageView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.bottom.equalToSuperview().inset(10)
            make.width.equalTo(112)
            make.height.equalTo(74)
        }
        
        visaTitleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        visaTitleLabel.numberOfLines = 2
        visaTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(visaImageView.snp.right).offset(16)
            make.right.equalTo(-15)
            make.top.equalTo(visaImageView).offset(5)
        }
        
        lineLabel.backgroundColor = TBIThemeGrayLineColor
        lineLabel.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        moneyLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalTo(visaImageView).offset(-2)
        }
        
        protocolLabel.layer.cornerRadius = 2.0
        protocolLabel.clipsToBounds = true
        protocolLabel.layer.borderColor = PersonalThemeNormalColor.cgColor
        protocolLabel.layer.borderWidth = 1.0
        protocolLabel.snp.makeConstraints { (make) in
            make.left.equalTo(visaTitleLabel)
            make.bottom.equalTo(visaImageView).offset(-5)
            make.height.equalTo(15)
        }
        prepayLabel.layer.cornerRadius = 2.0
        prepayLabel.clipsToBounds = true
        prepayLabel.layer.borderColor = PersonalThemeNormalColor.cgColor
        prepayLabel.layer.borderWidth = 1.0
        prepayLabel.snp.makeConstraints { (make) in
            make.left.equalTo(protocolLabel.snp.right).offset(5)
            make.bottom.equalTo(visaImageView).offset(-5)
            make.height.equalTo(15)
        }
        
//        sepcialLabel.backgroundColor = TBIThemeBackgroundViewColor
//        sepcialLabel.snp.makeConstraints { (make) in
//            make.left.top.equalToSuperview()
//            make.height.equalTo(15)
//        }
        
        
        // 推荐指数
        hotelStarTitleLabel.font = UIFont.systemFont(ofSize: 12)
        hotelStarTitleLabel.textColor = UIColor(red: 47.0 / 255.0, green: 160.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
        self.addSubview(hotelStarTitleLabel)
        hotelStarTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(visaTitleLabel)
            make.bottom.equalTo(visaImageView.snp.bottom).offset(-28)
            
        }
        
        self.addSubview(hotelStarBackgroundView)
        hotelStarBackgroundView.snp.makeConstraints { (make) in
            make.top.equalTo(visaImageView.snp.centerY)
            make.left.equalTo(hotelStarTitleLabel.snp.right)
            make.width.equalTo(70)
            make.height.equalTo(13)
        }
        
        self.addSubview(addressLabel)
        addressLabel.snp.makeConstraints { (make) in
            make.right.left.equalTo(visaTitleLabel)
            make.bottom.equalTo(hotelStarTitleLabel.snp.top).offset(-6)
        }
    }
    func fillDataSourcesCell(itemModel:HotelListNewItem){
        visaTitleLabel.text = itemModel.hotelName//"item.hotelName"
        let moneyAttrs = NSMutableAttributedString(string:"¥ " + itemModel.lowRate)
        moneyAttrs.addAttributes([ NSFontAttributeName : UIFont.systemFont(ofSize: 12)],range: NSMakeRange(0,1))
        moneyLabel.attributedText = moneyAttrs
        
        visaImageView.sd_setImage(with: URL.init(string: itemModel.cover), placeholderImage: UIImage(named: "hotel_default"))
        
        addressLabel.text = itemModel.businessZone
        
        let styleStr = itemModel.starRate == "5" ? "豪华型" : itemModel.starRate == "4" ? "高档型" : itemModel.starRate == "3" ? "舒适型" : "经济型"
        hotelStarTitleLabel.text = "\(styleStr)·推荐指数"
        
//        if itemModel.corpCode.contains(PersonalSpecialHotelCorpCode){
//            sepcialLabel.isHidden = false
//        }else {
//            sepcialLabel.isHidden = true
//        }
        ///sftm:定投 tbi，有值：协议，无值：不显示
        if itemModel.corpCode.isEmpty == false{
        
            protocolLabel.isHidden = false
            prepayLabel.isHidden = true
            prepayLabel.snp.remakeConstraints({ (make) in
                make.left.equalTo(protocolLabel.snp.right).offset(5)
                make.bottom.equalTo(visaImageView).offset(-5)
                make.height.equalTo(15)
            })
            if itemModel.corpCode.contains(PersonalSpecialHotelCorpCode) {
                protocolLabel.text = " 推荐 "
            }else if itemModel.corpCode.contains(PersonaltbiCorpCode) {
                protocolLabel.text = " TBI协议 "
            }else{
                protocolLabel.text = " 丰田协议 "
            }
        }else{
            protocolLabel.isHidden = true
            prepayLabel.isHidden = false
            prepayLabel.snp.remakeConstraints({ (make) in
                make.left.equalTo(visaTitleLabel)
                make.bottom.equalTo(visaImageView).offset(-5)
                make.height.equalTo(15)
            })
        }
        
        if itemModel.payType == "1" {
            prepayLabel.text = " 预付 "
        }else{
            prepayLabel.text = " 现付 "
        }
        
        if hotelStarBackgroundView.subviews.count > 0 {
            _ = hotelStarBackgroundView.subviews.map{
                if $0.isKind(of: UIImageView.self) == true {
                    $0.removeFromSuperview()
                }
            }
        }
        let numStar:NSInteger = (NSInteger(itemModel.score) ?? 6) / 2
        let halfStar:Float = Float((NSInteger(itemModel.score) ?? 6) % 2)
        for i in 0...(numStar - 1) {
            let tmpHotelStarImageView = UIImageView()
            tmpHotelStarImageView.image = UIImage.init(named: "ic_hotel_star")
            hotelStarBackgroundView.addSubview(tmpHotelStarImageView)
            tmpHotelStarImageView.snp.makeConstraints { (make) in
                
                make.centerY.equalTo(hotelStarTitleLabel)
                make.left.equalTo( 12 * i)
                make.width.equalTo(12)
                make.height.equalTo(12)
            }
            if halfStar > 0 && i == (numStar - 1) {
                let tmpHalfHotelStarImageView = UIImageView()
                tmpHalfHotelStarImageView.image = UIImage.init(named: "ic_hotel_halfstar")
                hotelStarBackgroundView.addSubview(tmpHalfHotelStarImageView)
                
                tmpHalfHotelStarImageView.snp.makeConstraints { (make) in
                    
                    make.centerY.equalTo(hotelStarTitleLabel)
                    make.left.equalTo(12 * i + 12)
                    make.width.equalTo(12)
                    make.height.equalTo(12)
                }
            }
        }
        
    }
    
}
