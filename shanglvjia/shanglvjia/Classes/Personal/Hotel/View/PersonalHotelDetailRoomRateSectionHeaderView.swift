//
//  PersonalHotelDetailRoomRateSectionHeaderView.swift
//  shanglvjia
//
//  Created by manman on 2018/9/18.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PersonalHotelDetailRoomRateSectionHeaderView: UITableViewHeaderFooterView {
    
    ///展开收起
    typealias MoreReturnBlock = (NSInteger)->Void
    var moreReturnBlock:MoreReturnBlock!
    ///点击预订的回调
    typealias BookButtonBlock = (NSInteger,NSInteger) ->Void
    var bookButtonBlock:BookButtonBlock!
    
    let lineLabel = UILabel()
    var moneyLabel = UILabel.init(text: "", color: TBIThemePrimaryWarningColor, size: 20)
    var visaTitleLabel = UILabel.init(text: "", color: PersonalThemeMajorTextColor, size: 15)
    var visaImageView = UIImageView()
    //var protocolLabel = UILabel.init(text: " 协议 ", color: PersonalThemeDarkColor, size: 10)
    //var prepayLabel = UILabel.init(text: " 预付 ", color: PersonalThemeDarkColor, size: 10)
    var moreButton = UIButton()
    
    var sepcialLabel = UILabel.init(text: " 推荐 ", color: TBIThemeWhite, size: 8)
    
    var hotelRatePlaneViewArray:[PersonalHotelDetailRoomPlanMoreView] = Array()
    ///每个房间下边的含早种类
    var moreView = UIView()
    ///每个房间下边的含早种类 定投酒店
    var specialHotelRatePlaneArray:[SpecialHotelDetailResponse.RatePlanInfo] = Array()
    
    var specialHotelRoomPlanInfo:SpecialHotelDetailResponse.RoomInfo = SpecialHotelDetailResponse.RoomInfo()
    
    /// 每个 房间下面的 不同产品 普通酒店
    var normalHotelRatePlaneArray:[HotelDetailResult.RatePlanInfo] = Array()
    
    var normalHotelRoomPlanInfo:HotelDetailResult.HotelRoomInfo = HotelDetailResult.HotelRoomInfo()
    
    var cellIndex:NSInteger = 0
    

//    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        self.backgroundColor = TBIThemeWhite
//        self.selectionStyle = .none
//        creatView()
//    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = TBIThemeWhite//UIColor.blue
        creatView()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func creatView(){
        self.addSubview(visaImageView)
        self.addSubview(visaTitleLabel)
        self.addSubview(lineLabel)
        self.addSubview(moneyLabel)
        self.addSubview(moreButton)
        self.addSubview(moreView)
        visaImageView.layer.cornerRadius = 2
        visaImageView.clipsToBounds = true
        visaImageView.backgroundColor = UIColor.red
        visaImageView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalToSuperview().inset(10)
            make.width.equalTo(112)
            make.height.equalTo(74)
        }
        
        visaTitleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        visaTitleLabel.numberOfLines = 2
        visaTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(visaImageView.snp.right).offset(16)
            make.right.equalTo(-15)
            make.centerY.equalTo(visaImageView)
        }
        
        lineLabel.backgroundColor = TBIThemeGrayLineColor
        lineLabel.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        moreButton.setImage(UIImage(named:"ic_hotel_open"), for: .normal)
        moreButton.setImage(UIImage(named:"ic_hotel_close"), for: .selected)
        moreButton.contentHorizontalAlignment = .right
        moreButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(15)
            make.centerY.equalTo(visaImageView)
            make.height.equalTo(50)
            
        }
        moreButton.addTarget(self, action: #selector(moreButtonClcik(sender:)), for: UIControlEvents.touchUpInside)
        moneyLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-44)
            make.centerY.equalTo(moreButton)
        }
        
        //        protocolLabel.layer.cornerRadius = 2.0
        //        protocolLabel.clipsToBounds = true
        //        protocolLabel.layer.borderColor = PersonalThemeDarkColor.cgColor
        //        protocolLabel.layer.borderWidth = 1.0
        //        protocolLabel.snp.makeConstraints { (make) in
        //            make.left.equalTo(visaTitleLabel)
        //            make.bottom.equalTo(visaImageView)
        //            make.height.equalTo(15)
        //        }
        //        prepayLabel.layer.cornerRadius = 2.0
        //        prepayLabel.clipsToBounds = true
        //        prepayLabel.layer.borderColor = PersonalThemeDarkColor.cgColor
        //        prepayLabel.layer.borderWidth = 1.0
        //        prepayLabel.snp.makeConstraints { (make) in
        //            make.left.equalTo(protocolLabel.snp.right).offset(5)
        //            make.bottom.equalTo(visaImageView)
        //            make.height.equalTo(15)
        //        }
        moreView.isHidden = true
        moreView.backgroundColor = TBIThemeWhite
        moreView.snp.makeConstraints { (make) in
            make.top.equalTo(visaImageView.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        //        sepcialLabel.backgroundColor = TBIThemeBackgroundViewColor
        //        sepcialLabel.snp.makeConstraints { (make) in
        //            make.left.top.equalToSuperview()
        //            make.height.equalTo(15)
        //        }
        
    }
    func fillSpecialHotelDataSources(model:SpecialHotelDetailResponse.RoomInfo,checkInDate:Date,checkOutDate:Date,index:NSInteger,payType:String,isShowProtocol:String){
        visaTitleLabel.text = model.roomName
        cellIndex = index
        let averageRate:String = caculateRoomAverageRate(roomSaleInfo: model, checkInDate: checkInDate, checkOutDate: checkOutDate)
        let moneyAttrs = NSMutableAttributedString(string:"¥ " + averageRate)
        moneyAttrs.addAttributes([ NSFontAttributeName : UIFont.systemFont(ofSize: 12)],range: NSMakeRange(0,1))
        moneyLabel.attributedText = moneyAttrs
        
        visaImageView.sd_setImage(with: URL.init(string: model.imageUrl), placeholderImage: UIImage(named: "bg_default_travel"))
        
        specialHotelRatePlaneArray = model.ratePlanInfoList
        if hotelRatePlaneViewArray.count > 0 {
            for element in hotelRatePlaneViewArray{
                element.removeFromSuperview()
            }
            hotelRatePlaneViewArray.removeAll()
            
        }
//        weak var weakSelf = self
//        for (index,item )in model.ratePlanInfoList.enumerated() {
//            ///传model 创建view
//            if item.ratePlanName.count > 13{
//
//            }
//
//            let roomView:PersonalHotelDetailRoomPlanMoreView = specialHotelCreateMoreView(itemPlan:item, index:index ,originY:CGFloat(60*index), checkInDate: checkInDate,checkOutDate: checkOutDate,payType: payType,isShowProtocol: isShowProtocol)
//            roomView.personalHotelDetailRoomPlanSelectedBlock = { selectedIndex in
//                weakSelf?.bookButtonClick(selectedIndex: selectedIndex)
//            }
//            hotelRatePlaneViewArray.append(roomView)
//        }
        //        protocolLabel.isHidden = true
        //        prepayLabel.snp.remakeConstraints({ (make) in
        //            make.left.equalTo(visaTitleLabel)
        //            make.bottom.equalTo(visaImageView)
        //            make.height.equalTo(15)
        //        })
        //specialHotelRoomPlanInfo = model
        
        //        if model.ratePlanInfoList.first. {
        //        }
        
        
        if model.isFolderOpen{
            moreButton.isSelected = true
            moreView.isHidden = false
        }else{
            moreButton.isSelected = false
            moreView.isHidden = true
        }
        
    }
    
    func fillNormalHotelDataSources(model:HotelDetailResult.HotelRoomInfo,index:NSInteger){
        visaTitleLabel.text = model.roomTypeName
        cellIndex = index
        //let averageRate:String = caculateRoomAverageRate(roomSaleInfo: model, checkInDate: checkInDate, checkOutDate: checkOutDate)
        var lowRate:Float = model.ratePlanInfoList.first?.rate ?? 0
        for element in model.ratePlanInfoList {
            if element.rate < lowRate {
                lowRate = element.rate
            }
        }
        
        //        if model.ratePlanInfoList.first?.corpCode.isEmpty == false && model.ratePlanInfoList.first?.corpCode.contains(PersonalSpecialHotelCorpCode) == false {
        //            protocolLabel.isHidden = false
        //            prepayLabel.snp.remakeConstraints({ (make) in
        //                make.left.equalTo(protocolLabel.snp.right).offset(5)
        //                make.bottom.equalTo(visaImageView)
        //                make.height.equalTo(15)
        //            })
        //        }else{
        //            protocolLabel.isHidden = true
        //            prepayLabel.snp.remakeConstraints({ (make) in
        //                make.left.equalTo(visaTitleLabel)
        //                make.bottom.equalTo(visaImageView)
        //                make.height.equalTo(15)
        //            })
        //        }
        
        
        let moneyAttrs = NSMutableAttributedString(string:"¥ " + lowRate.TwoOfTheEffectiveFraction())
        moneyAttrs.addAttributes([ NSFontAttributeName : UIFont.systemFont(ofSize: 12)],range: NSMakeRange(0,1))
        moneyLabel.attributedText = moneyAttrs
        
        visaImageView.sd_setImage(with: URL.init(string: model.cover), placeholderImage: UIImage(named: "bg_default_travel"))
        
        normalHotelRatePlaneArray = model.ratePlanInfoList
        if hotelRatePlaneViewArray.count > 0 {
            for element in hotelRatePlaneViewArray{
                element.removeFromSuperview()
            }
            hotelRatePlaneViewArray.removeAll()
        }
//        weak var weakSelf = self
//        for (index,item )in model.ratePlanInfoList.enumerated() {
//            ///传model 创建view
//            let roomPlaneView:PersonalHotelDetailRoomPlanMoreView = normalHotelCreateMoreView(itemPlan:item, index:index ,originY:CGFloat(60*index),payType:item.payType)
//            roomPlaneView.personalHotelDetailRoomPlanSelectedBlock = { selectedIndex in
//                weakSelf?.bookButtonClick(selectedIndex: selectedIndex)
//            }
//            hotelRatePlaneViewArray.append(roomPlaneView)
//        }
        
        //        protocolLabel.isHidden = false
        //        prepayLabel.snp.remakeConstraints({ (make) in
        //            make.left.equalTo(protocolLabel.snp.right).offset(5)
        //            make.bottom.equalTo(visaImageView)
        //            make.height.equalTo(15)
        //        })
        //        if model.payType == "1"  {
        //            prepayLabel.text = " 预付 "
        //        }else {
        //            prepayLabel.text = " 现付 "
        //        }
        
        
        //normalHotelRoomPlanInfo = model
        
        if model.isFolderOpen {
            moreButton.isSelected = true
            moreView.isHidden = false
        }else{
            moreButton.isSelected = false
            moreView.isHidden = true
        }
        
    }
    
    
    
    /// 定投酒店 创建
    /// 后期 可以合并
    func specialHotelCreateMoreView(itemPlan:SpecialHotelDetailResponse.RatePlanInfo,index:NSInteger,originY:CGFloat,checkInDate:Date,checkOutDate:Date,payType:String,isShowProtocol:String)->PersonalHotelDetailRoomPlanMoreView  {
        ///房间 含早类型
        
        let averageRate:String = caculateRoomPlanAverageRate(roomSaleInfo: itemPlan, checkInDate: checkInDate, checkOutDate: checkOutDate)
        
        let roomPlaneView = hotelCreateRoomPlaneView(title: itemPlan.ratePlanName, prices: averageRate, productRemark: itemPlan.productRemark, index: index, originY: originY, isShowProtocol: isShowProtocol,payType:payType)
        return roomPlaneView
        
        
        
        let titleButton = UIButton.init(title: itemPlan.ratePlanName, titleColor: PersonalThemeMajorTextColor, titleSize: 14)
        let topLine = UILabel()
        let bookButton = UIButton.init(title: "预订", titleColor: TBIThemeWhite, titleSize: 14)
        let priceLabel = UILabel.init(text: "¥ " + averageRate, color: TBIThemePrimaryWarningColor, size: 20)
        
        moreView.addSubview(titleButton)
        moreView.addSubview(topLine)
        moreView.addSubview(bookButton)
        moreView.addSubview(priceLabel)
        
        topLine.backgroundColor = TBIThemeGrayLineColor
        topLine.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(originY)
            make.height.equalTo(1)
        }
        titleButton.setImage(UIImage(named:"ic_car_zhongdian"), for: .normal)
        titleButton.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(topLine.snp.bottom)
            make.height.equalTo(45)
        }
        let imageWith = titleButton.imageView?.bounds.size.width;
        let labelWidth = titleButton.titleLabel?.bounds.size.width;
        titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth!, 0, -labelWidth!);
        titleButton.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWith!-5, 0, imageWith!+5);
        //titleButton.addTarget(self, action: #selector(roomAlertInfo(sender:)), for: UIControlEvents.touchUpInside)
        
        bookButton.setBackgroundImage(UIImage (named: "yellow_btn_gradient"), for: UIControlState.normal)
        bookButton.layer.cornerRadius = 4
        bookButton.tag = 1000 + index // 暂时 使用tag 标志 后期修改
        bookButton.clipsToBounds = true
        bookButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(15)
            make.centerY.equalTo(titleButton)
            make.height.equalTo(30)
            make.width.equalTo(70)
        }
        //bookButton.addTarget(self, action: #selector(bookButtonClick(sender:)), for: UIControlEvents.touchUpInside)
        
        priceLabel.snp.makeConstraints { (make) in
            make.right.equalTo(bookButton.snp.left).offset(-45)
            make.centerY.equalTo(titleButton)
        }
        let moneyAttrs = NSMutableAttributedString(string:"¥ " + itemPlan.averageRate.OneOfTheEffectiveFraction())
        moneyAttrs.addAttributes([ NSFontAttributeName : UIFont.systemFont(ofSize: 12)],range: NSMakeRange(0,1))
        priceLabel.attributedText = moneyAttrs
    }
    
    func normalHotelCreateMoreView(itemPlan:HotelDetailResult.RatePlanInfo,index:NSInteger,originY:CGFloat,payType:String) ->PersonalHotelDetailRoomPlanMoreView {
        return hotelCreateRoomPlaneView(title: itemPlan.ratePlanName, prices: itemPlan.rate.TwoOfTheEffectiveFraction(), productRemark: itemPlan.refundDesc, index: index, originY: originY, isShowProtocol: itemPlan.corpCode,payType:payType)
    }
    
    func hotelCreateRoomPlaneView(title:String, prices:String,productRemark:String, index: NSInteger,originY:CGFloat,isShowProtocol:String,payType:String)->PersonalHotelDetailRoomPlanMoreView {
        let roomPlaneView:PersonalHotelDetailRoomPlanMoreView = PersonalHotelDetailRoomPlanMoreView()
        moreView.addSubview(roomPlaneView)
        roomPlaneView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(originY)
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        roomPlaneView.fillDataSources(title: title, prices:prices, index: index, productRemark: productRemark,isShowProtocol: isShowProtocol,payType:payType)
        return roomPlaneView
    }
    
    
    
    
    
    /// 计算房间平均价
    func caculateRoomAverageRate(roomSaleInfo:SpecialHotelDetailResponse.RoomInfo,checkInDate:Date,checkOutDate:Date) -> String {
        
        let checkInDateSecond:NSNumber = NSNumber.init(value: checkInDate.timeIntervalSince1970)
        let checkOutDateSecond:NSNumber = NSNumber.init(value: checkOutDate.timeIntervalSince1970)
        let bookRoomDays:NSNumber = NSNumber.init(value:caculateIntervalDay(fromDate: checkInDate, toDate: checkOutDate))
        
        var roomAmount:Float = 0
        
        for element in roomSaleInfo.ratePlanInfoList {
            var tmpRoomAmount:Float = 0
            //            var startPresaleIndex:NSInteger = element.priceDetailInfoList.count
            //            for (index,startPresalElement) in element.priceDetailInfoList.enumerated(){
            //                if startPresalElement.saleDate / 1000 == checkInDateSecond.intValue {
            //                    startPresaleIndex = index
            //                }
            //            }
            //for i in startPresaleIndex...element.priceDetailInfoList.count - 1 {
            for priceElement in element.priceDetailInfoList {
                
                //let priceElement = element.priceDetailInfoList[i]
                
                if priceElement.saleDate / 1000 >= checkInDateSecond.intValue && priceElement.saleDate / 1000 < checkOutDateSecond.intValue {
                    tmpRoomAmount += priceElement.saleRate
                }
            }
            if roomAmount == 0 {
                roomAmount = tmpRoomAmount
            }
            if roomAmount != 0 && roomAmount > tmpRoomAmount && tmpRoomAmount != 0{
                roomAmount = tmpRoomAmount
            }
            
        }
        
        return ceil(roomAmount / bookRoomDays.floatValue).OneOfTheEffectiveFraction()
    }
    
    
    /// 计算 产品 的平均价
    func caculateRoomPlanAverageRate(roomSaleInfo:SpecialHotelDetailResponse.RatePlanInfo,checkInDate:Date,checkOutDate:Date) -> String{
        let checkInDateSecond:NSNumber = NSNumber.init(value: checkInDate.timeIntervalSince1970)
        let checkOutDateSecond:NSNumber = NSNumber.init(value: checkOutDate.timeIntervalSince1970)
        
        var roomAmount:Float = 0
        var tmpRoomAmount:Float = 0
        for priceElement in roomSaleInfo.priceDetailInfoList {
            
            if priceElement.saleDate / 1000 >= checkInDateSecond.intValue && priceElement.saleDate / 1000 < checkOutDateSecond.intValue {
                tmpRoomAmount += priceElement.saleRate
            }
        }
        if roomAmount == 0 {
            roomAmount = tmpRoomAmount
        }
        if roomAmount != 0 && roomAmount > tmpRoomAmount && tmpRoomAmount != 0 {
            roomAmount = tmpRoomAmount
        }
        let bookRoomDays:NSNumber = NSNumber.init(value:caculateIntervalDay(fromDate: checkInDate, toDate: checkOutDate))
        return ceil(roomAmount / bookRoomDays.floatValue).OneOfTheEffectiveFraction()
        
        
        
        
    }
    
    
    
    
    private func caculateIntervalDay(fromDate:Date,toDate:Date) -> NSInteger {
        
        let calendar = NSCalendar.init(identifier: NSCalendar.Identifier.gregorian)
        let result = calendar?.components(NSCalendar.Unit.day, from: fromDate, to: toDate, options: NSCalendar.Options.matchFirst)
        
        return (result?.day)!
    }
    
    
    ///展开收起
    func moreButtonClcik(sender:UIButton){
        if moreReturnBlock != nil{
            moreReturnBlock(cellIndex)
        }
        
    }
    ///预订 跳转下一页
    func bookButtonClick(selectedIndex:NSInteger){
        
        if bookButtonBlock != nil{
            bookButtonBlock(cellIndex,selectedIndex)
        }
    }
    
    

    
}
