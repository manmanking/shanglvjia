//
//  PersonalHotelDetailRoomRateCell.swift
//  shanglvjia
//
//  Created by manman on 2018/9/18.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PersonalHotelDetailRoomRateCell: UITableViewCell {

    typealias PersonalHotelDetailRoomPlanSelectedBlock = (IndexPath)->Void
    
    public var personalHotelDetailRoomPlanSelectedBlock:PersonalHotelDetailRoomPlanSelectedBlock!
    
    typealias PersonalHotelDetailRoomPlanAlertInfoBlock = ()->Void
    
    public var personalHotelDetailRoomPlanAlertInfoBlock:PersonalHotelDetailRoomPlanAlertInfoBlock!
    
    ///房间 含早类型
    private let titleButton = UIButton()
    private let topLine = UILabel()
    private let bookButton = UIButton()
    private let priceLabel = UILabel()
    //.init(text: "¥ " + itemPlan.rate.TwoOfTheEffectiveFraction(), color: , size: 20)
    private var cellIndex:IndexPath?
    
    private var productRemarkLocal:String = ""
    
    private var protocolLabel = UILabel.init(text: " 协议 ", color: PersonalThemeDarkColor, size: 10)
    private var prepayLabel = UILabel.init(text: " 预付 ", color: PersonalThemeDarkColor, size: 10)
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setUIViewAutolayout()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUIViewAutolayout() {
        
        self.contentView.addSubview(titleButton)
        self.contentView.addSubview(topLine)
        self.contentView.addSubview(bookButton)
        self.contentView.addSubview(priceLabel)
        self.contentView.addSubview(protocolLabel)
        self.contentView.addSubview(prepayLabel)
        
        topLine.backgroundColor = TBIThemeGrayLineColor
        topLine.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        titleButton.setTitleColor(PersonalThemeMajorTextColor, for: UIControlState.normal)
        titleButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        titleButton.addTarget(self, action: #selector(titleButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        titleButton.contentHorizontalAlignment = .left
        titleButton.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.centerY.equalToSuperview().offset(-12)
            //make.height.equalTo(25)
            make.width.equalTo(180)
        }
        titleButton.setImage(UIImage(named:"ic_hotel_remark"), for: .normal)
        
        //titleButton.addTarget(self, action: #selector(roomAlertInfo(sender:)), for: UIControlEvents.touchUpInside)
        
        protocolLabel.layer.cornerRadius = 2.0
        protocolLabel.clipsToBounds = true
        protocolLabel.layer.borderColor = PersonalThemeDarkColor.cgColor
        protocolLabel.layer.borderWidth = 1.0
        protocolLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleButton)
            make.bottom.equalToSuperview().inset(6)
            make.height.equalTo(15)
        }
        prepayLabel.layer.cornerRadius = 2.0
        prepayLabel.clipsToBounds = true
        prepayLabel.layer.borderColor = PersonalThemeDarkColor.cgColor
        prepayLabel.layer.borderWidth = 1.0
        prepayLabel.snp.makeConstraints { (make) in
            make.left.equalTo(protocolLabel.snp.right).offset(5)
            make.bottom.equalTo(protocolLabel)
            make.height.equalTo(15)
        }
        
        bookButton.setTitle("预订", for: UIControlState.normal)
        bookButton.setTitleColor(TBIThemeWhite, for: UIControlState.normal)
        bookButton.setBackgroundImage(UIImage (named: "yellow_btn_gradient"), for: UIControlState.normal)
        bookButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        bookButton.setTitleColor(TBIThemeWhite, for: UIControlState.normal)
        bookButton.layer.cornerRadius = 4
        bookButton.addTarget(self, action: #selector(bookButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        bookButton.clipsToBounds = true
        bookButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(70)
        }
        
        priceLabel.textColor = TBIThemePrimaryWarningColor
        priceLabel.font = UIFont.systemFont(ofSize: 20)
        priceLabel.snp.makeConstraints { (make) in
            make.right.equalTo(bookButton.snp.left).offset(-30)
            make.centerY.equalToSuperview()
        }
        
        
    }
    
    public func fillDataSources(title:String,prices:String,index:IndexPath,productRemark:String,isShowProtocol:String,payType:String,status:Bool) {
        let titleStr = title
//        if titleStr.count > 13{
//            ///字符串插入
//            titleStr.insert("\n", at:  titleStr.index(titleStr.startIndex, offsetBy: 13))
//        }
        titleButton.setTitle(titleStr , for: UIControlState.normal)
        let moneyAttrs = NSMutableAttributedString(string:"¥ " + prices)
        moneyAttrs.addAttributes([ NSFontAttributeName : UIFont.systemFont(ofSize: 12)],range: NSMakeRange(0,1))
        priceLabel.attributedText = moneyAttrs
        cellIndex = index
        productRemarkLocal = productRemark
        
        titleButton.titleLabel?.lineBreakMode = NSLineBreakMode(rawValue: 0)!
        
        let imageWith = titleButton.imageView?.bounds.size.width;
        let labelWidth = titleButton.titleLabel?.bounds.size.width
        titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth!, 0, -labelWidth!);
        titleButton.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWith!, 0, imageWith!);
        
        if isShowProtocol.isEmpty == false{
            protocolLabel.isHidden = false
            protocolLabel.snp.remakeConstraints { (update) in
                update.left.equalTo(titleButton)
                update.bottom.equalToSuperview().inset(6)
                update.height.equalTo(15)
            }
            prepayLabel.snp.remakeConstraints { (update) in
                update.left.equalTo(protocolLabel.snp.right).offset(5)
                update.bottom.equalTo(protocolLabel)
                update.height.equalTo(15)
            }
            if isShowProtocol.contains(PersonalSpecialHotelCorpCode) {
                protocolLabel.text = " 推荐 "
            }else if isShowProtocol.contains(PersonaltbiCorpCode) {
                protocolLabel.text = " TBI协议 "
            }else{
                protocolLabel.text = " 丰田协议 "
            }
        }else{
            protocolLabel.isHidden = true
            prepayLabel.snp.remakeConstraints { (update) in
                update.left.equalTo(titleButton)
                update.bottom.equalToSuperview().inset(6)
                update.height.equalTo(15)
            }
//            prepayLabel.snp.remakeConstraints { (update) in
//                update.left.equalTo(protocolLabel.snp.right).offset(5)
//                update.bottom.equalTo(protocolLabel)
//                update.height.equalTo(15)
//            }
        }
        
        if payType == "1"{
            prepayLabel.text = " 预付 "
        }else{
            prepayLabel.text = " 现付 "
        }
        
        if status{
            bookButton.isUserInteractionEnabled = true
            bookButton.setTitle("预订", for: .normal)
            bookButton.setBackgroundImage(UIImage (named: "yellow_btn_gradient"), for: UIControlState.normal)
        }else{
             bookButton.isUserInteractionEnabled = false
            bookButton.setTitle("售罄", for: .normal)
            bookButton.setBackgroundImage(UIColor.creatImageWithColor(color: PersonalThemeMinorTextColor), for: UIControlState.normal)
        }
        
        
    }
    
    @objc private func bookButtonAction(sender:UIButton) {
        if personalHotelDetailRoomPlanSelectedBlock != nil {
            personalHotelDetailRoomPlanSelectedBlock(cellIndex!)
        }
    }
    
    func titleButtonAction(sender:UIButton) {
        
        printDebugLog(message: "每个房间 含早类型 的提示信息")
        ///弹出提示信息
        guard productRemarkLocal.isEmpty == false else {
            return
        }
        popPersonalNewAlertView(content:productRemarkLocal , titleStr: "提示", btnTitle: "确定")
        
        
        //        func roomAlertInfo(sender:UIButton) {
        //            ///每个房间 含早类型 的提示信息
        //            popPersonalNewAlertView(content:"行程中显示的是您个人或者公司秘书为您订妥的近期行程。如有问题请您及时与客服人员联系，我们将竭诚为您服务。行程中显示的是您个人或者公司秘书为您订妥的近期行程。如有问题请您及时与客服人员联系，我们将竭诚为您服务。",titleStr:"提示",btnTitle:"确定")
        //        }
    }
    
}
