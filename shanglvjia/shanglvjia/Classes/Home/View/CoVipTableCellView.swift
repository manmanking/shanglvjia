//
//  CoVipTableCellView.swift
//  shop
//
//  Created by TBI on 2018/2/2.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class CoVipHeaderView: UITableViewHeaderFooterView {

    fileprivate let   cityTitleLabel:UILabel = UILabel(text: "城市", color: TBIThemeWhite, size: 11*adaptationRatio)
    
    fileprivate let   airportLabel:UILabel = UILabel(text: "机场/车站名称", color: TBIThemeWhite, size: 11*adaptationRatio)
    
    fileprivate let   serviceLabel:UILabel = UILabel(text: "提供服务", color: TBIThemeWhite, size: 11*adaptationRatio)
    
    fileprivate let   iconImage = UIImageView(imageName: "ic_vip_tishi")
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        initView()
//        self.contentView.backgroundColor = UIColor.init(r: 154, g: 204, b: 254)
        self.contentView.backgroundColor=TBIThemeDarkBlueColor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {

        self.contentView.addSubview(cityTitleLabel)
        cityTitleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(30)
        }
        self.contentView.addSubview(airportLabel)
        airportLabel.snp.makeConstraints { (make) in
            make.left.equalTo(105)
            make.centerY.equalToSuperview()
        }
        self.contentView.addSubview(iconImage)
        iconImage.snp.makeConstraints { (make) in
            make.right.equalTo(-41)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(12)
        }
        self.contentView.addSubview(serviceLabel)
        serviceLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(iconImage.snp.left).offset(-5)
        }
        
    }
    
}


class CoVipTableCellView: UITableViewCell {
    
    fileprivate let   cityLabel:UILabel = UILabel(text: "北京", color: TBIThemePrimaryTextColor, size: 13)
    
    fileprivate let   airportLabel:UILabel = UILabel(text: "北京首都机场", color: TBIThemePrimaryTextColor, size: 13)
   
    fileprivate let   loungeImage = UIImageView(imageName: "ic_vip_lounge")
    
    fileprivate let   cipImage = UIImageView(imageName: "ic_vip_cip")
    
    fileprivate let   remindImage = UIImageView(imageName: "ic_vip_remind")
    
    fileprivate let   checkinImage = UIImageView(imageName: "ic_vip_checkin")
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    func initView() {
        self.contentView.addSubview(cityLabel)
        cityLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(30)
        }
        self.contentView.addSubview(airportLabel)
        airportLabel.snp.makeConstraints { (make) in
            make.left.equalTo(105)
            make.centerY.equalToSuperview()
        }
        self.contentView.addSubview(loungeImage)
        loungeImage.snp.makeConstraints { (make) in
             make.centerY.equalToSuperview()
             make.right.equalTo(-30)
             make.width.height.equalTo(20)
        }
        self.contentView.addSubview(cipImage)
        cipImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(loungeImage.snp.left).offset(-10)
            make.width.height.equalTo(20)
        }
        self.contentView.addSubview(remindImage)
        remindImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(cipImage.snp.left).offset(-10)
            make.width.height.equalTo(20)
        }
        self.contentView.addSubview(checkinImage)
        checkinImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(remindImage.snp.left).offset(-10)
            make.width.height.equalTo(20)
        }
    }
    
    func fullCell(model:(city:String,airport:String,flag:Bool)) {
        cityLabel.text = model.city
        airportLabel.text = model.airport
        if model.flag {
            loungeImage.isHidden = false
            cipImage.isHidden = false
            remindImage.isHidden = false
            checkinImage.isHidden = false
        }else {
            loungeImage.isHidden = false
            cipImage.isHidden = true
            remindImage.isHidden = true
            checkinImage.isHidden = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class CoVipAlertView: UIView {
    
    let bgView = UIView()
    
    let contentView = UIView()
    
    fileprivate let   titleLabel:UILabel = UILabel(text: "提供服务", color: TBIThemePrimaryTextColor, size: 18)
    
    fileprivate let   loungeLabel:UILabel = UILabel(text: "协助值机", color: TBIThemeMinorTextColor, size: 11)
    fileprivate let   loungeImage = UIImageView(imageName: "ic_vip_checkin_68")
    
    fileprivate let   cipLabel:UILabel = UILabel(text: "登记提醒", color: TBIThemeMinorTextColor, size: 11)
    fileprivate let   cipImage = UIImageView(imageName: "ic_vip_remind_68")
    
    fileprivate let   remindLabel:UILabel = UILabel(text: "快速通道", color: TBIThemeMinorTextColor, size: 11)
    fileprivate let   remindImage = UIImageView(imageName: "ic_vip_cip_68")
    
    fileprivate let   checkinLabel:UILabel = UILabel(text: "休息室", color: TBIThemeMinorTextColor, size: 11)
    fileprivate let   checkinImage = UIImageView(imageName: "ic_vip_lounge_68")
    
    
    let  line = UILabel(color: TBIThemeGrayLineColor)
    
    let okBtn = UIButton(title: "了解", titleColor: TBIThemeBlueColor, titleSize: 16)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc fileprivate func okayButtonAction(sender:UIButton) {
        self.removeFromSuperview()
    }
    
    @objc fileprivate func cancelButtonAction() {
        self.removeFromSuperview()
    }
    
    func initView (){
        bgView.addOnClickListener(target: self, action: #selector(cancelButtonAction))
        okBtn.addTarget(self, action: #selector(okayButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        
        bgView.backgroundColor = TBIThemeBackgroundViewColor
        self.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = TBIThemeWhite
        self.bgView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(270)
            make.height.equalTo(280)
        }
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(25)
        }
        contentView.addSubview(loungeImage)
        loungeImage.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(25)
            make.left.equalTo(70)
            make.width.height.equalTo(34)
        }
        contentView.addSubview(loungeLabel)
        loungeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(loungeImage.snp.bottom).offset(10)
            make.centerX.equalTo(loungeImage.snp.centerX)
        }
        
        
        contentView.addSubview(cipImage)
        cipImage.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(25)
            make.right.equalTo(-70)
            make.width.height.equalTo(34)
        }
        contentView.addSubview(cipLabel)
        cipLabel.snp.makeConstraints { (make) in
            make.top.equalTo(cipImage.snp.bottom).offset(10)
            make.centerX.equalTo(cipImage.snp.centerX)
        }
        
        
        contentView.addSubview(remindImage)
        remindImage.snp.makeConstraints { (make) in
            make.top.equalTo(loungeLabel.snp.bottom).offset(25)
            make.left.equalTo(70)
            make.width.height.equalTo(34)
        }
        contentView.addSubview(remindLabel)
        remindLabel.snp.makeConstraints { (make) in
            make.top.equalTo(remindImage.snp.bottom).offset(10)
            make.centerX.equalTo(remindImage.snp.centerX)
        }
        
        
        contentView.addSubview(checkinImage)
        checkinImage.snp.makeConstraints { (make) in
            make.top.equalTo(cipLabel.snp.bottom).offset(25)
            make.right.equalTo(-70)
            make.width.height.equalTo(34)
        }
        contentView.addSubview(checkinLabel)
        checkinLabel.snp.makeConstraints { (make) in
            make.top.equalTo(checkinImage.snp.bottom).offset(10)
            make.centerX.equalTo(checkinImage.snp.centerX)
        }
        
        contentView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-50)
            make.height.equalTo(0.5)
        }
        contentView.addSubview(okBtn)
        okBtn.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
}
