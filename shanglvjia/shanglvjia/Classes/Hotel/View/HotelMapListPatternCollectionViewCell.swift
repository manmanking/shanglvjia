//
//  HotelMapListPatternCollectionViewCell.swift
//  shanglvjia
//
//  Created by manman on 2018/4/26.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import SDWebImage

class HotelMapListPatternCollectionViewCell: UICollectionViewCell {
    
    
    // 基础背景
    fileprivate var baseBackgroundView = UIView()
    // 子背景 边缘 灰色圈
    fileprivate var subBackgroundView = UIView()
    
    fileprivate var hotelImageView = UIImageView()
    
    fileprivate var hotelTitleLabel = UILabel()
    
    fileprivate var hotelStarTitleLabel = UILabel()
    fileprivate var hotelStarBackgroundView:UIView = UIView()
    fileprivate var hotelStarView = UIImageView()
    
//    fileprivate var hotelProtocolFlagImageView = UIImageView()
//    fileprivate var hotelTBIProtocolFlagLabel:UILabel = UILabel()
    fileprivate var hotelCompanyProtocolFlagLabel:UILabel = UILabel()
    
    fileprivate var hotelProtocolCompanyTipDefault:String = "企业协议"
    fileprivate var hotelProtocolTBITipDefault:String = "TBI协议"
    
    fileprivate var hotelDistanceLabel = UILabel()
    
    fileprivate let hotelDistanceTipDefault:String = "据您的位置"
    
    fileprivate var guaranteeFlagLabel = UILabel()
    
    //fileprivate var hotelProtocolFlagImageView = UIImageView()
    
    fileprivate var hotelTravelProtocolFlagImageView = UIImageView()
    
    fileprivate var hotelPriceLabel = UILabel()
    
    fileprivate var startLabel = UILabel(text: "起", color: UIColor.gray, size: 10)
    
    fileprivate var hotelAddressLabel = UILabel()
    //星级
    fileprivate var hotelStarLabel = UILabel()
    
    
    private let sellOut:String = "当前日期无房"
    
    private let starOrderArr:[String] = ["","一星","二星","三星","四星","五星"]
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.contentView.backgroundColor = TBIThemeBaseColor
        self.contentView.layer.cornerRadius = 4
        baseBackgroundView.clipsToBounds = true
        baseBackgroundView.backgroundColor = UIColor.white
        self.contentView.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        
        subBackgroundView.backgroundColor = UIColor.white
        baseBackgroundView.addSubview(subBackgroundView)
        subBackgroundView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview().inset(10)
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
        hotelImageView.layer.cornerRadius = 4
        subBackgroundView.addSubview(hotelImageView)
        hotelImageView.snp.makeConstraints { (make) in
            
            make.top.left.bottom.equalToSuperview()
            //make.width.equalTo(115)
            make.width.equalTo(84)
            
        }
        
        
        // 协议
//        hotelProtocolFlagImageView.image = UIImage.init(named: "") //sd_setImage(with: URL.init(string: ""), placeholderImage: UIImage.init(named: "HotelProtocol"))
//        hotelImageView.addSubview(hotelProtocolFlagImageView)
//        hotelProtocolFlagImageView.snp.makeConstraints { (make) in
//
//            make.top.left.equalToSuperview()
//            make.width.equalTo(34)
//            make.height.equalTo(14)
//            
//        }
        
        // 差标标志
        hotelTravelProtocolFlagImageView.sd_setImage(with: URL.init(string: ""), placeholderImage: UIImage.init(named: ""))
        subBackgroundView.addSubview(hotelTravelProtocolFlagImageView)
        hotelTravelProtocolFlagImageView.snp.makeConstraints { (make) in
            
            make.top.left.equalToSuperview()
            make.width.equalTo(34)
            make.height.equalTo(14)
            
        }
        
        
        
        
        
        // 标题
        hotelTitleLabel.text = ""
        hotelTitleLabel.numberOfLines = 2
        hotelTitleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        hotelTitleLabel.textColor = TBIThemePrimaryTextColor
        subBackgroundView.addSubview(hotelTitleLabel)
        hotelTitleLabel.snp.makeConstraints { (make) in
            
            make.top.equalToSuperview().offset(10)
            make.left.equalTo(hotelImageView.snp.right).offset(15)
            make.right.equalToSuperview()
            make.height.equalTo(13)
            
        }
        
        
        subBackgroundView.addSubview(hotelStarBackgroundView)
        hotelStarBackgroundView.snp.makeConstraints { (make) in
            make.top.equalTo(hotelTitleLabel.snp.bottom).offset(27)
            make.left.equalTo(hotelTitleLabel.snp.left)
            make.width.equalTo(70)
            make.height.equalTo(13)
        }
        
        // 推荐指数
        hotelStarTitleLabel.text = "推荐指数"
        hotelStarTitleLabel.font = UIFont.systemFont(ofSize: 12)
        hotelStarTitleLabel.textColor = TBIThemeMinorTextColor
        subBackgroundView.addSubview(hotelStarTitleLabel)
        hotelStarTitleLabel.snp.makeConstraints { (make) in
            
            make.top.equalTo(hotelTitleLabel.snp.bottom).offset(27)
            make.left.equalTo(hotelTitleLabel.snp.left)
            make.width.equalTo(70)
            make.height.equalTo(13)
            
        }
        // 星级
        hotelStarView.image = UIImage.init(named: "")
        subBackgroundView.addSubview(hotelStarView)
        hotelStarView.snp.makeConstraints { (make) in
            
            make.centerY.equalTo(hotelStarTitleLabel)
            make.left.equalTo(hotelStarTitleLabel.snp.right)
            make.width.equalTo(18)
            make.height.equalTo(12)
            
        }
        
        
        
        // 距离
        hotelDistanceLabel.text = "据您的位置 03.km"
        hotelDistanceLabel.font = UIFont.systemFont(ofSize: 13)
        hotelDistanceLabel.textColor = TBIThemePrimaryTextColor
        subBackgroundView.addSubview(hotelDistanceLabel)
        hotelDistanceLabel.snp.makeConstraints { (make) in
            
            make.top.equalTo(hotelStarTitleLabel.snp.bottom).offset(5)
            make.left.equalTo(hotelStarTitleLabel.snp.left)
            make.right.equalToSuperview()
            make.height.equalTo(13)
            
        }
        
        // TBI协议
        hotelCompanyProtocolFlagLabel.text = "企业协议"
        hotelCompanyProtocolFlagLabel.font = UIFont.systemFont(ofSize: 10)
        hotelCompanyProtocolFlagLabel.textColor = TBIThemeWhite
        hotelCompanyProtocolFlagLabel.layer.cornerRadius = 2
        hotelCompanyProtocolFlagLabel.clipsToBounds = true
        hotelCompanyProtocolFlagLabel.backgroundColor = TBIThemeOrangeColor
        hotelCompanyProtocolFlagLabel.textAlignment = NSTextAlignment.center
        subBackgroundView.addSubview(hotelCompanyProtocolFlagLabel)
        hotelCompanyProtocolFlagLabel.snp.makeConstraints { (make) in
            
            make.top.equalTo(hotelDistanceLabel.snp.bottom).offset(8)
            make.left.equalTo(hotelTitleLabel.snp.left)
            make.width.equalTo(50)
            make.height.equalTo(16)
            
        }
        
        // 担保
        guaranteeFlagLabel.text = "担保"
        guaranteeFlagLabel.font = UIFont.systemFont(ofSize: 10)
        guaranteeFlagLabel.textColor = TBIThemeWhite
        guaranteeFlagLabel.layer.cornerRadius = 4
        guaranteeFlagLabel.clipsToBounds = true
        guaranteeFlagLabel.textAlignment = NSTextAlignment.center
        guaranteeFlagLabel.backgroundColor = TBIThemeBlueColor
        subBackgroundView.addSubview(guaranteeFlagLabel)
        guaranteeFlagLabel.snp.makeConstraints { (make) in
            
            make.top.equalTo(hotelDistanceLabel.snp.bottom).offset(8)
            make.left.equalTo(hotelTitleLabel.snp.left)
            make.width.equalTo(32)
            make.height.equalTo(16)
            
        }
        guaranteeFlagLabel.isHidden = true
        subBackgroundView.addSubview(startLabel)
        startLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
        }
        
        //价格
        // 这个需要 富文本 处理 暂时 显示 为这个
        hotelPriceLabel.text = "¥266起"
        hotelPriceLabel.textColor = TBIThemeOrangeColor
        hotelPriceLabel.textAlignment = NSTextAlignment.right
        //hotelPriceLabel.font = UIFont.systemFont(ofSize: 16)
        hotelPriceLabel.font = UIFont.systemFont( ofSize: 20)
        subBackgroundView.addSubview(hotelPriceLabel)
        hotelPriceLabel.snp.makeConstraints { (make) in
            make.right.equalTo(startLabel.snp.left).offset(-5)
            make.bottom.equalTo(startLabel).offset(3)
        }
        
    }
    
    func fillDataSources(hotelItem:HotelListNewItem,policyPrice:String) {
        
        hotelImageView.sd_setImage(with: URL.init(string: hotelItem.cover), placeholderImage: UIImage.init(named: ""), options: SDWebImageOptions.highPriority)
        hotelTitleLabel.text = hotelItem.hotelName
//        if hotelItem.corpCode == HotelTBIProtocol {
//            hotelTitleLabel.attributedText =  adjustHotelNameAndLogo(title: hotelItem.hotelName, image: "ic_hotel_landscape")
//        }
        // 协议标
        var hotelProtocolArr:[String] = Array()
        if hotelItem.corpCode.isEmpty == false {
            hotelProtocolArr = hotelItem.corpCode.components(separatedBy: ",").map({ (element) -> String in
                return element.uppercased()
            })
        }
        let selfCompanyProtocol:String = DBManager.shareInstance.userDetailDraw()?.busLoginInfo.userBaseInfo.corpCode.uppercased() ?? ""
        if hotelProtocolArr.count > 0 {
            hotelCompanyProtocolFlagLabel.isHidden = false
            if hotelProtocolArr.contains(HotelTBIProtocol) {
                hotelCompanyProtocolFlagLabel.text = hotelProtocolTBITipDefault
            }
            if selfCompanyProtocol != HotelTBIProtocol && hotelProtocolArr.contains(selfCompanyProtocol) {
                hotelCompanyProtocolFlagLabel.text = hotelProtocolCompanyTipDefault
            }
        }else{
            hotelCompanyProtocolFlagLabel.isHidden = true
        }

        
        
        let numStar:NSInteger = (NSInteger(hotelItem.score) ?? 6) / 2
        let halfStar:Float = Float((NSInteger(hotelItem.score) ?? 6) % 2)
        if hotelStarBackgroundView.subviews.count > 0 {
            _ = hotelStarBackgroundView.subviews.map{
                if $0.isKind(of: UIImageView.self) == true {
                    $0.removeFromSuperview()
                }
            }
        }
        
        for i in 0...(numStar - 1) {
            let tmpHotelStarImageView = UIImageView()
            tmpHotelStarImageView.image = UIImage.init(named: "ic_hotel_star")
            hotelStarBackgroundView.addSubview(tmpHotelStarImageView)
            tmpHotelStarImageView.snp.makeConstraints { (make) in
                
                make.centerY.equalTo(hotelStarTitleLabel)
                make.left.equalTo(60 + 12 * i)
                make.width.equalTo(12)
                make.height.equalTo(12)
            }
            if halfStar > 0 && i == (numStar - 1) {
                let tmpHalfHotelStarImageView = UIImageView()
                tmpHalfHotelStarImageView.image = UIImage.init(named: "ic_hotel_halfstar")
                hotelStarBackgroundView.addSubview(tmpHalfHotelStarImageView)
                
                tmpHalfHotelStarImageView.snp.makeConstraints { (make) in
                    
                    make.centerY.equalTo(hotelStarTitleLabel)
                    make.left.equalTo(60 + 12 * i + 12)
                    make.width.equalTo(12)
                    make.height.equalTo(12)
                }
            }
        }
        
//        if hotelItem.distance != "0" {
//            hotelDistanceLabel.isHidden = false
//
//            let distance:Float = Float(hotelItem.distance )! / 1000
//            hotelDistanceLabel.text = hotelDistanceTipDefault + distance.OneOfTheEffectiveFraction() + "km"
//        }else {
//            hotelDistanceLabel.isHidden = true
//        }
        /// 自己计算距离
        var distanceHotel:String = ""
        if hotelItem.longitude.isEmpty == false && hotelItem.latitude.isEmpty == false {
            distanceHotel =  acculateHotelDistance(latitude: hotelItem.latitude, lontitude: hotelItem.longitude)
        }
        if distanceHotel.isEmpty == false {
            hotelDistanceLabel.text = "据您的位置 " + distanceHotel + "km"
            hotelDistanceLabel.isHidden = false
        }else {
            hotelDistanceLabel.isHidden = true
        }
        
        adjustPriceLabel(price: hotelItem.lowRate)
        var isAccord:Double = 0
        if policyPrice.isEmpty == false {
            isAccord = Double(policyPrice )! - Double(hotelItem.lowRate)!
        }
        if isAccord > 0 {
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
        printDebugLog(message:userLocalLatitude)
        printDebugLog(message:userLocalLontitude)
        printDebugLog(message:" here here")
        guard userLocalLatitude > 0 && userLocalLontitude > 0 else {
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
        
        let userRadLat = rad(d: userLocalLatitude)
        let userRadLon = rad(d: userLocalLontitude)
        let hotelRadLat = rad(d: hotelLatitude)
        let hotelRadLon = rad(d: hotelLontitude)
        
        let diffenceLat:Double = userRadLat - hotelRadLat
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
        return d * M_PI / 180.0
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
    
    
    
}
