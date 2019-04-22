//
//  RecommendedFlightTableViewCell.swift
//  shanglvjia
//
//  Created by manman on 2018/4/2.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class RecommendedFlightTableViewCell: UITableViewCell {

    typealias RecommendedFlightTableViewCellSelectedBlock = (Bool,NSInteger)->Void
    
    public var recommendedFlightTableViewCellSelectedBlock:RecommendedFlightTableViewCellSelectedBlock!
    
    private let flightPolicyTitleRecommendTipDefault:String = "推荐航班"
    private let flightPolicyTitleViolateTipDefault:String = "违背政策"
    private let flightPolicyTitleLabel:UILabel = UILabel()
    private let flightCompanyLogoImageView:UIImageView = UIImageView()
    private let flightCompanyShortNameAndAirTypeLabel:UILabel = UILabel()
    private let flightAirStatusLabel:UILabel = UILabel()
    private let flightTakeOffDateLabel:UILabel = UILabel()
    
    //经停中转标签
    var stopOverLabel = UILabel.init(text: "", color: TBIThemeMinorTextColor, size: 11)
    //经停中转城市标签
    var stopOverCityLabel = UILabel.init(text: "", color: TBIThemeMinorTextColor, size: 11)
    
    private let flightTakeOffHourLabel:UILabel = UILabel()
    private let flightArriveHourLabel:UILabel = UILabel()
    private let flightArrowImage:UIImageView = UIImageView() //.init(imageName: "Flight_Arrow_Right_Black")
    private let flightTakeOffAirPortLabel:UILabel = UILabel()
    private let flightArriveAirPortLabel:UILabel = UILabel()
    
    private let flightPriceLabel:UILabel = UILabel()
    private let flightRemainTicketLabel:UILabel = UILabel()
    
    private let flightCabinsLabel:UILabel = UILabel()
    private let flightPriceDiscountLabel:UILabel = UILabel()
    
    private let flightSelectedButton:UIButton = UIButton()
    private let bottomLine:UILabel = UILabel()
    
    
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
        
        flightPolicyTitleLabel.font = UIFont.systemFont(ofSize: 12)
        flightPolicyTitleLabel.text = flightPolicyTitleRecommendTipDefault
        flightPolicyTitleLabel.textColor = TBIThemeRedColor
        self.contentView.addSubview(flightPolicyTitleLabel)
        flightPolicyTitleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(25)
            make.left.equalToSuperview().inset(53)
            make.height.equalTo(14)
        }
        flightCompanyLogoImageView.image = UIImage.init(named: "")
        self.contentView.addSubview(flightCompanyLogoImageView)
        flightCompanyLogoImageView.snp.makeConstraints { (make) in
            make.left.equalTo(flightPolicyTitleLabel.snp.right).offset(5)
            make.centerY.equalTo(flightPolicyTitleLabel)
            make.width.equalTo(12)
            make.height.equalTo(12)
        }
        
        flightCompanyShortNameAndAirTypeLabel.font = UIFont.systemFont(ofSize: 12)
        flightCompanyShortNameAndAirTypeLabel.textColor = TBIThemePlaceholderColor
        flightCompanyShortNameAndAirTypeLabel.adjustsFontSizeToFitWidth = true
        self.contentView.addSubview(flightCompanyShortNameAndAirTypeLabel)
        flightCompanyShortNameAndAirTypeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(flightCompanyLogoImageView.snp.right).offset(5)
            make.centerY.equalTo(flightCompanyLogoImageView)
            make.height.equalTo(13)
            //make.width.equalTo(90)
        }
        flightAirStatusLabel.textColor = TBIThemeBlueColor
        flightAirStatusLabel.font = UIFont.systemFont(ofSize: 12)
        self.contentView.addSubview(flightAirStatusLabel)
        flightAirStatusLabel.snp.makeConstraints { (make) in
            make.left.equalTo(flightCompanyShortNameAndAirTypeLabel.snp.right).offset(2)
            make.centerY.equalTo(flightCompanyShortNameAndAirTypeLabel)
            make.height.equalTo(13)
            make.width.equalTo(30)
        }
        flightTakeOffDateLabel.textColor = TBIThemePlaceholderColor
        flightTakeOffDateLabel.font = UIFont.systemFont(ofSize: 12)
        self.contentView.addSubview(flightTakeOffDateLabel)
        flightTakeOffDateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(flightCompanyShortNameAndAirTypeLabel.snp.right).offset(30)
            make.centerY.equalTo(flightCompanyShortNameAndAirTypeLabel)
            make.height.equalTo(13)
            make.width.equalTo(75)
        }
        
        flightSelectedButton.setImage(UIImage.init(named: "ic_radio_not selected"), for: UIControlState.normal)
        flightSelectedButton.setImage(UIImage.init(named: "ic_radio_selected"), for: UIControlState.selected)
        flightSelectedButton.addTarget(self, action: #selector(selectedCabinsAction(sender:)), for: UIControlEvents.touchUpInside)
        self.contentView.addSubview(flightSelectedButton)
        flightSelectedButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(15)
            make.width.height.equalTo(23)
        }
        
        flightTakeOffHourLabel.font = UIFont.boldSystemFont(ofSize: 25)
        flightTakeOffHourLabel.textColor = TBIThemePrimaryTextColor
        self.contentView.addSubview(flightTakeOffHourLabel)
        flightTakeOffHourLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(69)
            make.top.equalToSuperview().inset(61)
            make.height.equalTo(27)
            make.width.equalTo(75)
        }
        
        flightArrowImage.image = UIImage.init(named:"ic_ari_timeto")
        self.contentView.addSubview(flightArrowImage)
        flightArrowImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(flightTakeOffHourLabel.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(4)
            make.width.equalTo(40)
        }
        stopOverLabel.isHidden = true
        stopOverLabel.textAlignment = NSTextAlignment.center
        self.contentView.addSubview(stopOverLabel)
        stopOverLabel.snp.makeConstraints{ (make) in
            make.left.equalTo(flightArrowImage.snp.left).offset(5)
            make.centerX.equalTo(flightArrowImage)
            make.bottom.equalTo(flightArrowImage.snp.bottom).offset(-4)
        }
        
        stopOverCityLabel.isHidden = true
        self.contentView.addSubview(stopOverCityLabel)
        stopOverCityLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(flightArrowImage.snp.centerX)
            make.top.equalTo(flightArrowImage.snp.bottom)
        }
        
        
        flightArriveHourLabel.font = UIFont.boldSystemFont(ofSize: 25)
        flightArriveHourLabel.textColor = TBIThemePrimaryTextColor
        self.contentView.addSubview(flightArriveHourLabel)
        flightArriveHourLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(46)
            make.top.equalToSuperview().inset(61)
            make.height.equalTo(27)
            make.width.equalTo(75)
        }
        flightTakeOffAirPortLabel.adjustsFontSizeToFitWidth = true
        flightTakeOffAirPortLabel.font = UIFont.systemFont(ofSize: 13)
        flightTakeOffAirPortLabel.textColor = TBIThemePrimaryTextColor
        self.contentView.addSubview(flightTakeOffAirPortLabel)
        flightTakeOffAirPortLabel.snp.makeConstraints { (make) in
            make.top.equalTo(flightTakeOffHourLabel.snp.bottom).offset(12)
            make.left.equalTo(flightTakeOffHourLabel.snp.left)
            make.height.equalTo(13)
        }
        
        flightArriveAirPortLabel.adjustsFontSizeToFitWidth = true
        flightArriveAirPortLabel.font = UIFont.systemFont(ofSize: 13)
        flightArriveAirPortLabel.textColor = TBIThemePrimaryTextColor
        self.contentView.addSubview(flightArriveAirPortLabel)
        flightArriveAirPortLabel.snp.makeConstraints { (make) in
            make.top.equalTo(flightArriveHourLabel.snp.bottom).offset(12)
            make.right.equalTo(flightArriveHourLabel.snp.right)
            make.height.equalTo(13)
        }
        
        flightPriceLabel.textColor = TBIThemeOrangeColor
        flightPriceLabel.font = UIFont.systemFont(ofSize: 12)
        flightPriceLabel.adjustsFontSizeToFitWidth = true
        self.contentView.addSubview(flightPriceLabel)
        flightPriceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(flightTakeOffAirPortLabel.snp.left).offset(-5)
            make.top.equalTo(flightTakeOffAirPortLabel.snp.bottom).offset(26)
            make.height.equalTo(15)
        }
        
        flightRemainTicketLabel.textColor = TBIThemeOrangeColor
        flightRemainTicketLabel.font = UIFont.systemFont(ofSize: 10)
        self.contentView.addSubview(flightRemainTicketLabel)
        flightRemainTicketLabel.snp.makeConstraints { (make) in
            make.left.equalTo(flightPriceLabel.snp.right).offset(5)
            make.bottom.equalTo(flightPriceLabel.snp.bottom)
            make.centerY.equalTo(flightPriceLabel)
            make.height.equalTo(11)
        }
        flightCabinsLabel.textColor = TBIThemePlaceholderColor
        flightCabinsLabel.font = UIFont.systemFont(ofSize: 12)
        self.contentView.addSubview(flightCabinsLabel)
        flightCabinsLabel.snp.makeConstraints { (make) in
            make.left.equalTo(flightRemainTicketLabel.snp.right).offset(5)
            make.bottom.equalTo(flightRemainTicketLabel.snp.bottom)
            make.centerY.equalTo(flightPriceLabel)
            make.height.equalTo(14)
        }
        
        flightPriceDiscountLabel.textColor = TBIThemePlaceholderColor
        flightPriceDiscountLabel.font = UIFont.systemFont(ofSize: 12)
        self.contentView.addSubview(flightPriceDiscountLabel)
        flightPriceDiscountLabel.snp.makeConstraints { (make) in
            make.left.equalTo(flightCabinsLabel.snp.right).offset(5)
            make.bottom.equalTo(flightCabinsLabel.snp.bottom)
            make.centerY.equalTo(flightPriceLabel)
            make.height.equalTo(14)
        }
        
        bottomLine.backgroundColor = TBIThemePlaceholderColor
        self.contentView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(38)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(1)
            make.height.equalTo(1)
        }
  
    }
    
    
    func fillDataSources(flight flightInfo:FlightSVSearchResultVOModel.AirfareVO,cabins cabinsInfo:FlightSVSearchResultVOModel.CabinVO,isAccordPolicy:Bool,index cellIndex:NSInteger,selected:Bool) {
        self.cellIndex = cellIndex
        if isAccordPolicy {
            flightPolicyTitleLabel.text = flightPolicyTitleViolateTipDefault
            flightPolicyTitleLabel.textColor = TBIThemeRedColor
        }else
        {
            flightPolicyTitleLabel.text = flightPolicyTitleRecommendTipDefault
            flightPolicyTitleLabel.textColor = TBIThemeGreenColor
        }
        
        flightSelectedButton.isSelected = selected
        
        flightCompanyLogoImageView.image = UIImage.init(named: flightInfo.flightInfos.first?.flightCode ?? "")
        flightCompanyShortNameAndAirTypeLabel.text = (flightInfo.flightInfos.first?.flightShortName ?? "" ) + (flightInfo.flightInfos.first?.flightCode ?? "") + (flightInfo.flightInfos.first?.flightNo ?? "")
        if flightInfo.flightInfos.first?.share ?? false {
            flightAirStatusLabel.isHidden = false
            flightAirStatusLabel.text =  "共享"
            flightAirStatusLabel.textColor = TBIThemeBlueColor
        }else
        {
            flightAirStatusLabel.isHidden = true
        }
        
        let takeOffDate:Date = Date.init(timeIntervalSince1970:(TimeInterval(flightInfo.flightInfos.first!.takeOffDate/1000)))
        let arriveDate:Date = Date.init(timeIntervalSince1970: TimeInterval(flightInfo.flightInfos.last!.arriveDate / 1000))
        flightTakeOffDateLabel.text = takeOffDate.string(custom: "MM月dd日")
        flightTakeOffHourLabel.text = takeOffDate.string(custom: "HH:mm")
        flightArriveHourLabel.text = arriveDate.string(custom: "HH:mm")
        flightTakeOffAirPortLabel.text = (flightInfo.flightInfos.first?.takeOffAirportName)! + (flightInfo.flightInfos.first?.takeOffTerminal)!
        flightArriveAirPortLabel.text = (flightInfo.flightInfos.last?.arriveAirportName)! + (flightInfo.flightInfos.last?.arriveTerminal)!
        flightPriceLabel.text = "¥" + cabinsInfo.price.stringValue
        if cabinsInfo.amount == -1 {
            flightRemainTicketLabel.isHidden = true
        }else
        {
            flightRemainTicketLabel.text = "仅" + cabinsInfo.amount.description + "张"
        }
        
        flightCabinsLabel.text = cabinsInfo.shipping
        
        
        var discount:String = ""
        if cabinsInfo.discount.intValue == 10 {
            discount = "全价"
        }else{
            discount = cabinsInfo.discount.stringValue + "折"
        }
        flightPriceDiscountLabel.text = discount
        if cellIndex == 0 {
            bottomLine.isHidden = false
        }else
        {
            bottomLine.isHidden = true
        }
        
        
        //是否直达
        if flightInfo.direct {
            stopOverLabel.isHidden = true
            
            //是否经停
            if flightInfo.flightInfos.first?.stopOver == true {
                stopOverLabel.text = "经停"
                stopOverLabel.isHidden = false
                stopOverCityLabel.isHidden = false
                stopOverCityLabel.text = flightInfo.flightInfos.first?.stopOverCity
            }else{
                stopOverLabel.isHidden = true
                stopOverCityLabel.isHidden = true
            }
        }else {
            stopOverCityLabel.isHidden = false
            stopOverLabel.isHidden = false
            stopOverLabel.text = "转"
            stopOverCityLabel.text = flightInfo.transferCity
        }
        
        
    }
    
    
    func selectedCabinsAction(sender:UIButton) {
        
        guard  verifyWetherContraryPolicyCanOrder(index: cellIndex) == true else {
            return
        }
        var status:Bool = false
        if sender.isSelected {
            sender.isSelected = false
            
        }else {
            sender.isSelected = true
            status = true
        }
        if recommendedFlightTableViewCellSelectedBlock != nil {
            recommendedFlightTableViewCellSelectedBlock(status,cellIndex)
        }
        
    }
    
    /// 验证是否可以预订
    /// 在 返回 true 可以预订 false 不可以
    func verifyWetherContraryPolicyCanOrder(index:NSInteger) -> Bool {
        let userInfo = DBManager.shareInstance.userDetailDraw()
        if userInfo?.busLoginInfo.userBaseInfo.canOrder == "0" && index == 0 {
            return false
        }
        return true
    }
    
    
    
    
}
