//
//  HotelListTableViewCell.swift
//  shop
//
//  Created by manman on 2017/4/21.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

class HotelListTableViewCell: UITableViewCell {

    
    // 基础背景
    fileprivate var baseBackgroundView = UIView()
    // 子背景 边缘 灰色圈
    fileprivate var subBackgroundView = UIView()
    
    fileprivate var hotelImageView = UIImageView()
    
    fileprivate var hotelTitleLabel = UILabel()
    
    fileprivate var hotelStarTitleLabel = UILabel()
    fileprivate var hotelStarBackgroundView:UIView = UIView()
    fileprivate var hotelStarView = UIImageView()
    
    fileprivate var hotelDistanceLabel = UILabel()
    
    fileprivate let hotelDistanceTipDefault:String = "距您的位置"
    
    fileprivate var guaranteeFlagLabel = UILabel()
    
    fileprivate var hotelProtocolFlagImageView = UIImageView()
    fileprivate var hotelTBIProtocolFlagLabel:UILabel = UILabel()
    fileprivate var hotelCompanyProtocolFlagLabel:UILabel = UILabel()
    
    fileprivate var hotelProtocolCompanyTipDefault:String = "企业协议"
    fileprivate var hotelProtocolTBITipDefault:String = "TBI协议"
    
    fileprivate var hotelTravelProtocolFlagImageView = UIImageView()
    
    fileprivate var hotelPriceLabel = UILabel()
    
    fileprivate var startLabel = UILabel(text: "起", color: UIColor.gray, size: 10)
    
    fileprivate var hotelAddressLabel = UILabel()
    //星级
    fileprivate var hotelStarLabel = UILabel()
    
    
    private let sellOut:String = "当前日期无房"
    
    private let starOrderArr:[String] = ["","一星","二星","三星","四星","五星"]
    
    
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = TBIThemeBaseColor
        baseBackgroundView.backgroundColor = UIColor.white
        self.contentView.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        
        subBackgroundView.backgroundColor = UIColor.white
        subBackgroundView.clipsToBounds = true
        subBackgroundView.layer.cornerRadius = 2
        
//        subBackgroundView.layer.borderWidth = 0.5
//        subBackgroundView.layer.borderColor ƒ= TBIThemeGrayLineColor.cgColor
        baseBackgroundView.addSubview(subBackgroundView)
        subBackgroundView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()

        }
        
        setUIViewAutolayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUIViewAutolayout() {
        
        //图片
        hotelImageView.sd_setImage(with:URL.init(string: ""), placeholderImage:UIImage.init(named: "hotelPlaceholder"))
        hotelImageView.clipsToBounds = true
        hotelImageView.layer.cornerRadius = 2
        hotelImageView.contentMode = UIViewContentMode.scaleAspectFill//scaleAspectFit
        subBackgroundView.addSubview(hotelImageView)
        hotelImageView.snp.makeConstraints { (make) in
            
            make.top.left.bottom.equalToSuperview()
            make.width.equalTo(100)
            
        }

//        // 协议
//        hotelProtocolFlagImageView.image = UIImage.init(named: "") //sd_setImage(with: URL.init(string: ""), placeholderImage: UIImage.init(named: "HotelProtocol"))
//        hotelImageView.addSubview(hotelProtocolFlagImageView)
//        hotelProtocolFlagImageView.snp.makeConstraints { (make) in
//
//            make.top.left.equalToSuperview()
//            make.width.equalTo(34)
//            make.height.equalTo(14)
//
//        }
////
        
        
        // 差标标志
        hotelTravelProtocolFlagImageView.image = UIImage.init(named: "")
        hotelImageView.addSubview(hotelTravelProtocolFlagImageView)
        hotelTravelProtocolFlagImageView.snp.makeConstraints { (make) in
            
            make.top.left.equalToSuperview()
            make.width.equalTo(34)
            make.height.equalTo(14)
            
        }
        
        
        
        // 标题
        hotelTitleLabel.text = "北京民族智选假日酒店"
        hotelTitleLabel.numberOfLines = 2
        hotelTitleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        hotelTitleLabel.textColor = TBIThemePrimaryTextColor
        subBackgroundView.addSubview(hotelTitleLabel)
        hotelTitleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.left.equalTo(hotelImageView.snp.right).offset(15)
            make.right.equalToSuperview()
//            make.height.equalTo(16)
        }
        
        subBackgroundView.addSubview(hotelStarBackgroundView)
        hotelStarBackgroundView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(55)
            make.left.equalTo(hotelTitleLabel.snp.left)
            make.width.equalTo(70)
            make.height.equalTo(13)
        }
        
        
        // 推荐指数
        hotelStarTitleLabel.text = "推荐指数"
        hotelStarTitleLabel.font = UIFont.systemFont(ofSize: 12)
        hotelStarTitleLabel.textColor = TBIThemeMinorTextColor
        hotelStarBackgroundView.addSubview(hotelStarTitleLabel)
        hotelStarTitleLabel.snp.makeConstraints { (make) in
            
            make.top.left.equalToSuperview()
            ///make.width.equalTo(60)
            make.height.equalTo(13)
            
        }
//        // 星级
//        hotelStarView.image = UIImage.init(named: "")
//        subBackgroundView.addSubview(hotelStarView)
//        hotelStarView.snp.makeConstraints { (make) in
//
//            make.centerY.equalTo(hotelStarTitleLabel)
//            make.left.equalTo(hotelStarTitleLabel.snp.right)
//            make.width.equalTo(18)
//            make.height.equalTo(12)
//        }
//
        
        
        // 距离
        hotelDistanceLabel.text =  hotelDistanceTipDefault + " 03.km"
        hotelDistanceLabel.font = UIFont.systemFont(ofSize: 13)
        hotelDistanceLabel.textColor = TBIThemeMinorTextColor
        subBackgroundView.addSubview(hotelDistanceLabel)
        hotelDistanceLabel.snp.makeConstraints { (make) in
            
            make.top.equalTo(hotelStarBackgroundView.snp.bottom).offset(5)
            make.left.equalTo(hotelStarTitleLabel.snp.left)
            make.right.equalToSuperview()
            make.height.equalTo(13)
            
        }
        
        // 担保
//        guaranteeFlagLabel.text = "担保"
//        guaranteeFlagLabel.font = UIFont.systemFont(ofSize: 10)
//        guaranteeFlagLabel.textColor = TBIThemeBlueColor
//        guaranteeFlagLabel.layer.cornerRadius = 4
//        guaranteeFlagLabel.clipsToBounds = true
//        guaranteeFlagLabel.layer.borderColor = TBIThemeBlueColor.cgColor
//        guaranteeFlagLabel.layer.borderWidth = 1
//        guaranteeFlagLabel.textAlignment = NSTextAlignment.center
//        guaranteeFlagLabel.backgroundColor = TBIThemeWhite
//        subBackgroundView.addSubview(guaranteeFlagLabel)
//        guaranteeFlagLabel.snp.makeConstraints { (make) in
//
//            make.top.equalTo(hotelDistanceLabel.snp.bottom).offset(8)
//            make.left.equalTo(hotelTitleLabel.snp.left)
//            make.width.equalTo(32)
//            make.height.equalTo(16)
//
//        }
        // TBI协议
        hotelCompanyProtocolFlagLabel.text = hotelProtocolCompanyTipDefault
        hotelCompanyProtocolFlagLabel.font = UIFont.systemFont(ofSize: 10)
        hotelCompanyProtocolFlagLabel.textColor = TBIThemeWhite
        hotelCompanyProtocolFlagLabel.backgroundColor = TBIThemeOrangeColor
        hotelCompanyProtocolFlagLabel.layer.cornerRadius = 2
        hotelCompanyProtocolFlagLabel.clipsToBounds = true
//        hotelCompanyProtocolFlagLabel.layer.borderColor = TBIThemeOrangeColor.cgColor
//        hotelCompanyProtocolFlagLabel.layer.borderWidth = 1
        hotelCompanyProtocolFlagLabel.textAlignment = NSTextAlignment.center
        subBackgroundView.addSubview(hotelCompanyProtocolFlagLabel)
        hotelCompanyProtocolFlagLabel.snp.makeConstraints { (make) in
            
            make.top.equalTo(hotelDistanceLabel.snp.bottom).offset(8)
            make.left.equalTo(hotelTitleLabel.snp.left)
            make.width.equalTo(50)
            make.height.equalTo(16)
            
        }
        
//        // TBI协议
//        hotelTBIProtocolFlagLabel.text = "TBI协议"
//        hotelTBIProtocolFlagLabel.font = UIFont.systemFont(ofSize: 10)
//        hotelTBIProtocolFlagLabel.textColor = TBIThemeOrangeColor
//        hotelTBIProtocolFlagLabel.layer.cornerRadius = 4
//        hotelTBIProtocolFlagLabel.clipsToBounds = true
//        hotelTBIProtocolFlagLabel.layer.borderColor = TBIThemeOrangeColor.cgColor
//        hotelTBIProtocolFlagLabel.layer.borderWidth = 1
//        hotelTBIProtocolFlagLabel.textAlignment = NSTextAlignment.center
//        hotelTBIProtocolFlagLabel.backgroundColor = TBIThemeWhite
//        subBackgroundView.addSubview(hotelTBIProtocolFlagLabel)
//        hotelTBIProtocolFlagLabel.snp.makeConstraints { (make) in
//
//            make.top.equalTo(hotelDistanceLabel.snp.bottom).offset(8)
//            make.left.equalTo(hotelCompanyProtocolFlagLabel.snp.right).offset(2)
//            make.width.equalTo(50)
//            make.height.equalTo(16)
//
//        }
        
        subBackgroundView.addSubview(startLabel)
        startLabel.textAlignment = .right
        startLabel.lineBreakMode = NSLineBreakMode.byClipping
        startLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
        }
        //价格
        // 这个需要 富文本 处理 暂时 显示 为这个
        hotelPriceLabel.text = "¥266"
        hotelPriceLabel.textColor = TBIThemeRedColor
        hotelPriceLabel.textAlignment = NSTextAlignment.right
        //hotelPriceLabel.font = UIFont.systemFont(ofSize: 16)
        hotelPriceLabel.font = UIFont.systemFont( ofSize: 20)
        subBackgroundView.addSubview(hotelPriceLabel)
        hotelPriceLabel.snp.makeConstraints { (make) in
            make.right.equalTo(startLabel.snp.left).offset(-5)
            make.bottom.equalTo(startLabel).offset(3)
        }
        
        
//        hotelStarLabel.text = "四星"
//        hotelStarLabel.textColor = TBIThemeTipTextColor
//        //hotelStarLabel.adjustsFontSizeToFitWidth = true
//        hotelStarLabel.font = UIFont.systemFont( ofSize: 11)
//        subBackgroundView.addSubview(hotelStarLabel)
//        hotelStarLabel.snp.makeConstraints { (make) in
//
//            make.left.equalTo(hotelTitleLabel.snp.left)
//            make.width.equalTo(25)
//            make.bottom.equalToSuperview().offset(-10)
//            make.height.equalTo(11)
//        }
//
//        hotelAddressLabel.text = "朝阳区 民族园路2号3幢"
//        hotelAddressLabel.textColor = TBIThemeTipTextColor
//        hotelAddressLabel.font = UIFont.systemFont( ofSize: 11)
//        subBackgroundView.addSubview(hotelAddressLabel)
//        hotelAddressLabel.snp.makeConstraints { (make) in
//
//            make.left.equalTo(hotelStarLabel.snp.right).offset(10)
//            make.right.equalToSuperview().inset(15)
//            make.bottom.equalToSuperview().offset(-10)
//            make.height.equalTo(11)
//
//        }
        
    }
    
    func fillDataSources(hotelItem:HotelListNewItem,policyPrice:String) {
        
        if hotelItem.cover.isEmpty == false {
            hotelImageView.sd_setImage(with: URL.init(string: hotelItem.cover), placeholderImage: UIImage.init(named: "hotel_default"), options: SDWebImageOptions.highPriority)
        }else{
            hotelImageView.sd_setImage(with: URL.init(string: hotelItem.coverBig), placeholderImage: UIImage.init(named: "hotel_default"), options: SDWebImageOptions.highPriority)
        }
        
        
        hotelTitleLabel.text = hotelItem.hotelName
        
        // 协议标
        var hotelProtocolArr:[String] = Array()
        if hotelItem.corpCode.isEmpty == false {
            hotelProtocolArr = hotelItem.corpCode.components(separatedBy: ",").map({ (element) -> String in
                return element.uppercased()
            })
        }
//        let selfCompanyProtocol:String = DBManager.shareInstance.userDetailDraw()?.userBaseInfo.corpCode.uppercased() ?? ""
        if hotelProtocolArr.count > 0 {
            hotelCompanyProtocolFlagLabel.isHidden = false
            if hotelProtocolArr.contains(HotelTBIProtocol) {
                hotelCompanyProtocolFlagLabel.text = hotelProtocolTBITipDefault
                startLabel.text = "起"
               
            }else{
                 hotelCompanyProtocolFlagLabel.text = hotelProtocolCompanyTipDefault
                startLabel.text = hotelItem.mealDesc
                
            }
//            if selfCompanyProtocol != HotelTBIProtocol && hotelProtocolArr.contains(selfCompanyProtocol) {
//                hotelCompanyProtocolFlagLabel.text = hotelProtocolCompanyTipDefault
//            }else{
//                 hotelCompanyProtocolFlagLabel.text = hotelProtocolTBITipDefault
//            }
        }else{
            hotelCompanyProtocolFlagLabel.isHidden = true
        }
        if hotelItem.mealDesc.count > 3{
            startLabel.snp.remakeConstraints { (make) in
                make.right.equalToSuperview()
                make.bottom.equalToSuperview().inset(16)
                make.width.equalTo("含单早".getTextWidth(font: UIFont.systemFont(ofSize: 10), height: 30))
            }
        }else{
            startLabel.snp.remakeConstraints { (make) in
                make.right.equalToSuperview()
                make.bottom.equalToSuperview().inset(16)
            }
        }
        printDebugLog(message:hotelItem.score)
        if hotelStarBackgroundView.subviews.count > 0 {
            _ = hotelStarBackgroundView.subviews.map{
                if $0.isKind(of: UIImageView.self) == true {
                    $0.removeFromSuperview()
                }
            }
        }
        let styleStr = hotelItem.starRate == "5" ? "豪华型" : hotelItem.starRate == "4" ? "高档型" : hotelItem.starRate == "3" ? "舒适型" : "经济型"
        hotelStarTitleLabel.text = "\(styleStr)/推荐指数 "
        
        let numStar:NSInteger = (NSInteger(hotelItem.score) ?? 6) / 2
        let halfStar:Float = Float((NSInteger(hotelItem.score) ?? 6) % 2)
        for i in 0...(numStar - 1) {
            let tmpHotelStarImageView = UIImageView()
            tmpHotelStarImageView.image = UIImage.init(named: "ic_hotel_star")
            hotelStarBackgroundView.addSubview(tmpHotelStarImageView)
            tmpHotelStarImageView.snp.makeConstraints { (make) in
    
                make.centerY.equalTo(hotelStarTitleLabel)
                make.left.equalTo(hotelStarTitleLabel.snp.right).offset(12*i)
                make.width.equalTo(12)
                make.height.equalTo(12)
            }
            if halfStar > 0 && i == (numStar - 1) {
                let tmpHalfHotelStarImageView = UIImageView()
                tmpHalfHotelStarImageView.image = UIImage.init(named: "ic_hotel_halfstar")
                hotelStarBackgroundView.addSubview(tmpHalfHotelStarImageView)
                
                tmpHalfHotelStarImageView.snp.makeConstraints { (make) in
                    
                    make.centerY.equalTo(hotelStarTitleLabel)
                    make.left.equalTo(hotelStarTitleLabel.snp.right).offset(12 * i + 12)
                    make.width.equalTo(12)
                    make.height.equalTo(12)
                }
            }
        }
        
        
        /// 自己计算距离
        var distanceHotel:String = ""
        if hotelItem.longitude.isEmpty == false && hotelItem.latitude.isEmpty == false {
           distanceHotel = acculateHotelDistance(latitude:hotelItem.latitude , lontitude: hotelItem.longitude)
            //accurateHotelDistance(latitude: hotelItem.latitude, lontitude: hotelItem.longitude)
        }
        if distanceHotel.isEmpty == false {
            hotelDistanceLabel.text = "据您的位置 " + distanceHotel + "km"
            hotelDistanceLabel.isHidden = false
        }else {
            hotelDistanceLabel.isHidden = true
        }
        
//        if hotelItem.distance != "0" && hotelItem.distance.isEmpty == false {
//
//            let distance:Float = Float(hotelItem.distance )! / 1000
//            hotelDistanceLabel.text = hotelDistanceTipDefault + distance.OneOfTheEffectiveFraction() + "km"
//        }else {
//            hotelDistanceLabel.isHidden = true
//        }
        //hotelPriceLabel.text =  + "起"
        adjustPriceLabel(price: hotelItem.lowRate)
        
        var isAccord:Double = 0
        if policyPrice.isEmpty == false {
            isAccord = Double(policyPrice )! - Double(hotelItem.lowRate)!
        }
        
        printDebugLog(message: isAccord)
        printDebugLog(message: policyPrice)
        printDebugLog(message: hotelItem.lowRate)
        if isAccord >= 0 {
            hotelTravelProtocolFlagImageView.image = UIImage.init(named: "ic_hotel_yes")
        }else {
            hotelTravelProtocolFlagImageView.image = UIImage.init(named: "ic_hotel_no")
        }
      
    }
    
    
    
    func acculateHotelDistance(latitude:String,lontitude:String) -> String {
        guard latitude.isEmpty == false && lontitude.isEmpty == false else {
            return ""
        }
        
        let userLocalLatitude:Double = HotelManager.shareInstance.searchConditionUserDraw().userLatitude
        let userLocalLontitude:Double = HotelManager.shareInstance.searchConditionUserDraw().userLongitude
        guard userLocalLatitude != 0 && userLocalLontitude != 0 else {
            return ""
        }
        var hotelLatitude:Double = 0
        var hotelLontitude:Double = 0
        
        if latitude.isEmpty == false {
            hotelLatitude = Double(latitude) ?? 0
        }
        if lontitude.isEmpty == false {
            hotelLontitude = Double(lontitude) ?? 0
        }
        
        let origUser:CLLocation = CLLocation.init(latitude: userLocalLatitude, longitude: userLocalLontitude)
        let origHotel:CLLocation = CLLocation.init(latitude: hotelLatitude, longitude: hotelLontitude)
        let distance:CLLocationDistance = origUser.distance(from: origHotel) / 1000
        let result:NSNumber = NSNumber.init(value: distance)
        printDebugLog(message: "计算距离")
        printDebugLog(message: result)
        if result.intValue > 50 {
            return ""
        }else {
            return (result.floatValue).OneOfTheEffectiveFraction()
        }
        
    }
    
    func accurateHotelDistance(latitude:String,lontitude:String) -> String {
        guard latitude.isEmpty == false && lontitude.isEmpty == false else {
            return ""
        }
        
        let userLocalLatitude:Double = HotelManager.shareInstance.searchConditionUserDraw().userLatitude
        let userLocalLontitude:Double = HotelManager.shareInstance.searchConditionUserDraw().userLongitude
        guard userLocalLatitude != 0 && userLocalLontitude != 0 else {
            return ""
        }
        
        
        var hotelLatitude:Double = 0
        var hotelLontitude:Double = 0
        
        if latitude.isEmpty == false {
            hotelLatitude = Double(latitude) ?? 0
        }
        if lontitude.isEmpty == false {
            hotelLontitude = Double(lontitude) ?? 0
        }
        
        let userRadLat = rad(d: userLocalLatitude)
        let userRadLon = rad(d: userLocalLontitude)
        let hotelRadLat = rad(d: hotelLatitude)
        let hotelRadLon = rad(d: hotelLontitude)
        
        let diffenceLat:Double =  userRadLat - hotelRadLat
        let diffenceLon:Double = userRadLon - hotelRadLon
        var distance:Double = 2 * asin(sqrt(pow(sin(diffenceLat / 2), 2))) + cos(userRadLat) * cos(hotelRadLat) * pow(sin(diffenceLon / 2), 2)
        distance = distance * EARTH_RADIUS
        distance = round(distance * 10000) / 10000
        let result:NSNumber = NSNumber.init(value: distance)
        if result.intValue > 50000 {
            return ""
        }else {
            return (result.floatValue / 1000 ).OneOfTheEffectiveFraction()
        }
    }
    
    
    func rad(d:Double) -> Double {
        return d * Double.pi / 180.0
    }
    
    
    func caculateHotelDistance(latitude:String,lontitude:String) -> String {
        guard latitude.isEmpty == false && lontitude.isEmpty == false else {
            return ""
        }
        
        let userLocalLatitude:Double = HotelManager.shareInstance.searchConditionUserDraw().latitude
        let userLocalLontitude:Double = HotelManager.shareInstance.searchConditionUserDraw().longitude
        guard userLocalLatitude != 0 && userLocalLontitude != 0 else {
            return ""
        }
        
        
        var hotelLatitude:Double = 0
        var hotelLontitude:Double = 0
        
        if latitude.isEmpty == false {
            hotelLatitude = Double(latitude) ?? 0
        }
        if lontitude.isEmpty == false {
            hotelLontitude = Double(lontitude) ?? 0
        }
        
        let differenceLatitude = hotelLatitude - userLocalLatitude
        let differenceLontitude = hotelLontitude - userLocalLontitude
        
        let distance = sqrt(pow(differenceLatitude, 2) + pow(differenceLontitude, 2))
        
        
        
       
        
        
        return ""
        
    }
    
    
    
    
    
    func adjustPriceLabel(price:String){
        
        if price == "0" {
            
            hotelPriceLabel.text = sellOut
            return
            
        }
        
        let priceContent = "¥" + price
        let mutableAttribute = NSMutableAttributedString.init(string: priceContent)
        mutableAttribute.addAttributes([NSFontAttributeName:UIFont.systemFont( ofSize: 12)], range: NSRange(location: 0,length: 1))
        hotelPriceLabel.attributedText = mutableAttribute

    }
    
    func adjustHotelNameAndLogo(title:String,image:String)->NSMutableAttributedString {
        
        let attributeStr:NSMutableAttributedString = NSMutableAttributedString.init(string: title)
        let attach:NSTextAttachment = NSTextAttachment.init()
        attach.image = UIImage.init(named:image)
        let imageAttribute:NSAttributedString = NSAttributedString.init(attachment:attach)
        attributeStr.append(imageAttribute)
        return attributeStr
    }
    
    
    
    
    
    
    //
    func fillDatasource(hotelImage:String,
                        hotelTitle:String,
                        hotelProtocol:String,
                        hotelprice:String,
                        hotelStar:Int,
                        hotelAddress:String,
                        accordTravel:Float)
    {
        hotelImageView.sd_setImage(with: URL.init(string: hotelImage), placeholderImage: UIImage.init(named: ""), options: SDWebImageOptions.highPriority)
       
        
        var isFirst:Bool = true
        
        hotelTitleLabel.text = hotelTitle
        if hotelProtocol == "AGREEMENT" {
            hotelProtocolFlagImageView.image = UIImage.init(named: "HotelProtocolBlue")
        }else if hotelProtocol == "TBI" {
                hotelProtocolFlagImageView.image = UIImage.init(named: "HotelTBI")
        }
        else if hotelProtocol == "NONE" {
            isFirst = false
            hotelProtocolFlagImageView.image = UIImage.init(named: "")
        }
        
        
        adjustPriceLabel(price: hotelprice)
        
//        let priceContent = "¥" + hotelprice + "起"
//        let mutableAttribute = NSMutableAttributedString.init(string: priceContent)
//        mutableAttribute.addAttributes([NSFontAttributeName:UIFont.systemFont( ofSize: 11)], range: NSRange(location: priceContent.characters.count - 1,length: 1))
//        hotelPriceLabel.attributedText = mutableAttribute
        hotelAddressLabel.text = hotelAddress
        hotelStarLabel.text = starOrderArr[hotelStar]
        if hotelStar == 0 {
            hotelAddressLabel.snp.remakeConstraints({ (make) in
                make.left.equalTo(hotelTitleLabel.snp.left)
                make.right.equalToSuperview().inset(15)
                make.bottom.equalToSuperview().offset(-10)
                make.height.equalTo(11)
            })
        }else
        {
            hotelAddressLabel.snp.remakeConstraints({ (make) in
                make.left.equalTo(hotelStarLabel.snp.right).offset(10)
                make.right.equalToSuperview().inset(15)
                make.bottom.equalToSuperview().offset(-10)
                make.height.equalTo(11)
            })
        }
        
        let styleStr = hotelStar == 5 ? "豪华型" : hotelStar == 4 ? "高档型" : hotelStar == 3 ? "舒适型" : "经济型"
        hotelStarTitleLabel.text = "\(styleStr)·推荐指数"
       
        // 校验是否符合差旅政策。
        // 个人版 不需要 这个标签
        if accordTravel != 0{
            if Float(hotelprice)! <= accordTravel {
                if isFirst == false {
                    //符合的标志  右侧位置
                    hotelProtocolFlagImageView.sd_setImage(with: nil, placeholderImage: UIImage.init(named: "HotelConform"))
                    //符合 标志 第二个位置 
                    hotelTravelProtocolFlagImageView.sd_setImage(with: nil, placeholderImage: UIImage.init(named: ""))
                }else
                {
                    //符合的标志
                    hotelTravelProtocolFlagImageView.sd_setImage(with: nil, placeholderImage: UIImage.init(named: "HotelConform"))
                }
                
            }else
            {
                //违背的标志
                hotelTravelProtocolFlagImageView.sd_setImage(with: nil, placeholderImage: UIImage.init(named: ""))
            }
            
        }else
        {
            //违背的标志
            hotelTravelProtocolFlagImageView.sd_setImage(with: nil, placeholderImage: UIImage.init(named: ""))
        }
        
    }
    
    
//    func adjustPriceLabel(price:String){
//
//        if price == "0" {
//
//            hotelPriceLabel.text = sellOut
//            return
//
//        }
//
//        let priceContent = "¥" + price + "起"
//        let mutableAttribute = NSMutableAttributedString.init(string: priceContent)
//        mutableAttribute.addAttributes([NSFontAttributeName:UIFont.systemFont( ofSize: 11)], range: NSRange(location: priceContent.characters.count - 1,length: 1))
//        hotelPriceLabel.attributedText = mutableAttribute
//
//
//
//    }
    
    
    
    
    
    
}
