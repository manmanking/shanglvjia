//
//  PersonalCommonListCell.swift
//  shanglvjia
//
//  Created by tbi on 2018/8/6.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PersonalCommonListCell: UITableViewCell {
    
    let bgView = UIView()
    var takeOffDateLabel = UILabel.init(text: "", color: TBIThemePrimaryTextColor, size: 20)
    var takeOffAirportLabel = UILabel.init(text: "", color: TBIThemeMinorTextColor, size: 12)
    var arrivalDateLabel = UILabel.init(text: "", color: TBIThemePrimaryTextColor, size: 20)
    var arrivalAirportLabel = UILabel.init(text: "", color: TBIThemeMinorTextColor, size: 12)
    fileprivate let remainTicketLabel:UILabel = UILabel()
    var priceLabel = UILabel.init(text: "", color: TBIThemeRedColor, size: 20)
    var protocalLabel = UILabel.init(text: "有协议价", color: TBIThemeRedColor, size: 13)
    //是否违背差旅政策
    var contrayPolicyLabel = UILabel.init(text: "符合", color: TBIThemeWhite, size: 11)
    //经停中转标签
    var stopOverLabel = UILabel.init(text: "", color: TBIThemeMinorTextColor, size: 11)
    
    //经停中转城市标签
    var stopOverCityLabel = UILabel.init(text: "", color: TBIThemeMinorTextColor, size: 11)
    
    //共享标签
    var shareStatusLabel = UILabel.init(text: "共享", color: PersonalThemeNormalColor, size: 11)
    //航空公司图标
    var airCompanyImage = UIImageView(imageName:"AI")
    //航空公司名字
    var flightNameLabel = UILabel.init(text: "", color: TBIThemeMinorTextColor, size: 11)
    //颜色
    var flagLabel = UILabel()
    var craftType = UILabel.init(text: "", color: TBIThemeMinorTextColor, size: 11)
    var flyDays = UILabel.init(text: "+1", color: TBIThemePrimaryTextColor, size: 11)
    let sepLine = UILabel.init(color: TBIThemeGrayLineColor)
    let arrowImage = UIImageView.init(imageName: "ic_ari_timeto")
    
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
        self.backgroundColor = TBIThemeBaseColor
        self.selectionStyle = .none
        self.addSubview(bgView)
        bgView.backgroundColor = TBIThemeWhite
        bgView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
        }
        creatView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func creatView(){
        bgView.addSubview(arrowImage)
        bgView.addSubview(takeOffDateLabel)
        bgView.addSubview(takeOffAirportLabel)
        bgView.addSubview(arrivalDateLabel)
        bgView.addSubview(arrivalAirportLabel)
        bgView.addSubview(priceLabel)
        bgView.addSubview(protocalLabel)
        //bgView.addSubview(priceFlagLabel)
        bgView.addSubview(airCompanyImage)
        bgView.addSubview(flightNameLabel)
        bgView.addSubview(craftType)
        bgView.addSubview(flyDays)
        bgView.addSubview(sepLine)
        bgView.addSubview(stopOverLabel)
        bgView.addSubview(shareStatusLabel)
        stopOverLabel.isHidden = true
        shareStatusLabel.isHidden = true
        takeOffDateLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(15)
        }
        arrowImage.snp.makeConstraints { (make) in
            make.left.equalTo(takeOffDateLabel.snp.right).offset(38)
            //make.top.equalToSuperview().offset(26)
            make.centerY.equalTo(takeOffDateLabel.snp.bottom).offset(-2)
            make.width.equalTo(50)
            make.height.equalTo(3)
        }
        stopOverLabel.textAlignment = NSTextAlignment.center
        stopOverLabel.snp.makeConstraints{ (make) in
            make.left.equalTo(arrowImage.snp.left).offset(5)
            make.centerX.equalTo(arrowImage)
            make.bottom.equalTo(arrowImage.snp.bottom).offset(-1)
        }
        
        arrivalDateLabel.snp.makeConstraints { (make) in
            //make.left.equalTo(arrowImage.snp.right).offset(25)
            make.left.equalTo(arrowImage.snp.right).offset(39)
            make.top.equalTo(takeOffDateLabel.snp.top)
        }
        flyDays.snp.makeConstraints { (make) in
            make.left.equalTo(arrivalDateLabel.snp.right)
            make.bottom.equalTo(arrivalDateLabel.snp.top).inset(5)
        }
        priceLabel.adjustsFontSizeToFitWidth = true
        priceLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(16)
            make.bottom.equalTo(arrivalDateLabel).offset(-5)
            make.height.equalTo(15)
        }
        
        remainTicketLabel.font = UIFont.systemFont(ofSize: 12)
        remainTicketLabel.textColor = TBIThemeOrangeColor
        bgView.addSubview(remainTicketLabel)
        remainTicketLabel.snp.makeConstraints { (make) in
            make.top.equalTo(priceLabel.snp.bottom).offset(9)
            make.right.equalTo(priceLabel.snp.right)
            make.height.equalTo(13)
        }
        
        
        //        priceFlagLabel.snp.makeConstraints { (make) in
        //            make.bottom.equalTo(priceLabel.snp.bottom).offset(-1)
        //            make.right.equalTo(priceLabel.snp.left)
        //        }
        takeOffAirportLabel.adjustsFontSizeToFitWidth = true
        takeOffAirportLabel.snp.makeConstraints { (make) in
            make.top.equalTo(takeOffDateLabel.snp.bottom).offset(8)
            make.left.equalTo(takeOffDateLabel.snp.left)
        }
        arrivalAirportLabel.snp.makeConstraints { (make) in
            make.top.equalTo(takeOffAirportLabel.snp.top)
            //make.right.equalTo(arrivalDateLabel.snp.right)
            make.right.equalTo(arrivalDateLabel)
        }
        
        airCompanyImage.snp.makeConstraints { (make) in
            make.top.equalTo(takeOffAirportLabel.snp.bottom).offset(20)
            make.left.equalTo(takeOffAirportLabel.snp.left)
            make.width.height.equalTo(12)
            make.bottom.equalToSuperview().offset(-10)
        }
        protocalLabel.isHidden = true
        protocalLabel.snp.makeConstraints { (make) in
            make.right.equalTo(priceLabel)
            make.bottom.equalTo(arrivalAirportLabel)
        }
        
        flightNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(airCompanyImage.snp.right).offset(2)
            //make.top.equalTo(airCompanyImage.snp.top)
            make.centerY.equalTo(airCompanyImage.snp.centerY)
        }
        shareStatusLabel.snp.makeConstraints{ (make) in
            make.left.equalTo(flightNameLabel.snp.right).offset(6)
            make.top.equalTo(flightNameLabel.snp.top)
        }
        sepLine.snp.makeConstraints{ (make) in
            make.left.equalTo(shareStatusLabel.snp.right).offset(6)
            make.centerY.equalTo(flightNameLabel.snp.centerY)
            //make.top.equalTo(shareStatusLabel.snp.top).offset(1)
            make.width.equalTo(1)
            make.height.equalTo(9)
        }
        craftType.snp.makeConstraints { (make) in
            make.left.equalTo(sepLine.snp.right).offset(6)
            make.centerY.equalTo(flightNameLabel.snp.centerY)
        }
        
        
        flagLabel.backgroundColor = TBIThemeGreenColor
        contrayPolicyLabel.backgroundColor = TBIThemeGreenColor
        contrayPolicyLabel.text = "符合"
        contrayPolicyLabel.textAlignment = .center
        flagLabel.isHidden = true
        contrayPolicyLabel.isHidden = true
        
        contrayPolicyLabel.layer.cornerRadius = 2
        contrayPolicyLabel.layer.masksToBounds =  true
        bgView.addSubview(flagLabel)
        bgView.addSubview(contrayPolicyLabel)
        flagLabel.snp.makeConstraints{ (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalTo(6)
        }
        contrayPolicyLabel.snp.makeConstraints{ (make) in
            make.right.equalToSuperview().offset(-25)
            make.top.equalTo(arrivalAirportLabel.snp.top).offset(-3.5)
            make.width.equalTo(44)
            make.height.equalTo(20)
        }
        stopOverCityLabel.isHidden = true
        addSubview(stopOverCityLabel)
        stopOverCityLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(arrowImage.snp.centerX)
            make.top.equalTo(arrowImage.snp.bottom)
        }
        
    }
    
    /// 航班展示
    func fillDataSources(airfare:PCommonFlightSVSearchModel.AirfareVO) {
        
        let takeOffDate:Date = Date.init(timeIntervalSince1970:TimeInterval(airfare.flightInfos.first!.takeOffDate/1000))
        var arriveDate:Date = Date.init(timeIntervalSince1970:TimeInterval(airfare.flightInfos.first!.arriveDate/1000))
        if airfare.flightInfos.count > 1 {
            arriveDate = Date.init(timeIntervalSince1970:TimeInterval(airfare.flightInfos[1].arriveDate/1000))
        }
        
        if airfare.protocolPrice{
            protocalLabel.isHidden = false
        }else{
            protocalLabel.isHidden = true
        }
        self.takeOffDateLabel.text = takeOffDate.string(custom: "HH:mm")
        self.takeOffAirportLabel.text = (airfare.flightInfos.first?.takeOffAirportName ?? "" ) + (airfare.flightInfos.first?.takeOffTerminal ?? "")
        self.arrivalDateLabel.text = arriveDate.string(custom: "HH:mm")
        self.arrivalAirportLabel.text = (airfare.flightInfos.first?.arriveAirportName ?? "") + (airfare.flightInfos.first?.arriveTerminal ?? "")
        if airfare.flightInfos.count > 1 {
            self.arrivalAirportLabel.text = (airfare.flightInfos[1].arriveAirportName ) + (airfare.flightInfos[1].arriveTerminal ?? "")
        }
        //        self.priceLabel.text =  "¥" + airfare.price.stringValue
        let priceContent = "¥" + airfare.price.stringValue
        let mutableAttribute = NSMutableAttributedString.init(string: priceContent)
        mutableAttribute.addAttributes([NSFontAttributeName:UIFont.systemFont( ofSize: 12)], range: NSRange(location: 0,length: 1))
        priceLabel.attributedText = mutableAttribute
        
        
        self.airCompanyImage.image = UIImage(named: airfare.flightInfos.first?.flightCode ?? "")
        self.flightNameLabel.text =  (airfare.flightInfos.first?.flightName ?? "") + (airfare.flightInfos.first?.flightCode)! + (airfare.flightInfos.first?.flightNo ?? "")
        
        if airfare.flightInfos.first?.craftTypeName.isNotEmpty ?? false{
            self.craftType.text = "\(airfare.flightInfos.first?.craftTypeName ?? "")(\(airfare.flightInfos.first?.craftTypeClassShort ?? ""))"
        }else{
            self.craftType.text = ""
        }
        
        if airfare.flightInfos.first?.flyDays != 0 {
            self.flyDays.isHidden = false
            self.flyDays.text = (airfare.flightInfos.first?.flyDays != 0 ?  "+1" : "") + "天"
        }else {
            self.flyDays.isHidden = true
        }
        
        
        
        //是否直达
        if airfare.direct {
            stopOverLabel.isHidden = true
            
            //是否经停
            if airfare.flightInfos.first?.stopOver == true {
                stopOverLabel.text = "经停"
                stopOverLabel.isHidden = false
                stopOverCityLabel.isHidden = false
                stopOverCityLabel.text = airfare.flightInfos.first?.stopOverCity
            }else{
                stopOverLabel.isHidden = true
                stopOverCityLabel.isHidden = true
            }
        }else {
            stopOverCityLabel.isHidden = false
            stopOverLabel.isHidden = false
            stopOverLabel.text = "转"
            stopOverCityLabel.text = airfare.transferCity
        }
        
        if airfare.flightInfos.first?.share ?? false {
            shareStatusLabel.isHidden = false
            sepLine.snp.remakeConstraints{ (make) in
                make.left.equalTo(shareStatusLabel.snp.right).offset(6)
                make.centerY.equalTo(flightNameLabel.snp.centerY)
                make.width.equalTo(1)
                make.height.equalTo(9)
            }
        }else {
            shareStatusLabel.isHidden = true
            sepLine.snp.makeConstraints{ (make) in
                make.left.equalTo(flightNameLabel.snp.right).offset(6)
                make.centerY.equalTo(flightNameLabel.snp.centerY)
                make.width.equalTo(1)
                make.height.equalTo(9)
            }
            
        }
        flagLabel.isHidden = true
        contrayPolicyLabel.isHidden = true
        
    }
    
}
