//
//  HotelDetailTableViewCell.swift
//  shop
//
//  Created by manman on 2017/4/24.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class HotelDetailTableViewCell: UITableViewCell {

    private let protocolFTMS = "FTMS"
    private let protocolTBI = "TBI"
    private let protocolElong = "elong"
    
    
    // 基础背景
    fileprivate var baseBackgroundView = UIView()
    // 子背景 边缘 灰色圈
    fileprivate var subBackgroundView = UIView()
    
    // 子背景 售罄
    fileprivate var subSelloutBackgroundView = UIView()
    
    fileprivate var hotelRoomImageView = UIImageView()
    
    fileprivate var hotelRoomTitleLabel = UILabel()
    
    fileprivate var hotelRoomPriceLabel = UILabel()
    
    fileprivate var hotelRoomBreakfastLabel = UILabel()
    
    fileprivate var hotelRoomSizeLabel = UILabel()
    
    fileprivate var hotelRoomWifiLabel = UILabel()
    
    fileprivate var guaranteeFlagLabel:UILabel = UILabel()
    
    /// 差标 协议
    fileprivate var hotelAccordPolicyFlagImageView = UIImageView()
    
    
    fileprivate var hotelProtocolFlagImageView = UIImageView()
    //差旅协议
    fileprivate var hotelTravelProtocolFlagImageView = UIImageView()
    fileprivate var hotelTBIProtocolFlagLabel:UILabel = UILabel()
    fileprivate var hotelCompanyProtocolFlagLabel:UILabel = UILabel()
    
    fileprivate var hotelProtocolCompanyTipDefault:String = "企业协议"
    fileprivate var hotelProtocolTBITipDefault:String = "TBI协议"
    
    /// 售罄标题
    fileprivate let titleLabel:UILabel = UILabel()
    
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
        subBackgroundView.layer.cornerRadius = 4
        subBackgroundView.layer.borderWidth = 0.5
        subBackgroundView.layer.borderColor = TBIThemeGrayLineColor.cgColor
        baseBackgroundView.addSubview(subBackgroundView)
        subBackgroundView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
            
        }
        
        setUIViewAutolayout()
        
        setSelloutUIView()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private  func setSelloutUIView()  {
        
        subSelloutBackgroundView.backgroundColor = UIColor.clear
        subBackgroundView.addSubview(subSelloutBackgroundView)
        subSelloutBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        let titleBackgroundView = UIView()
        titleBackgroundView.backgroundColor = UIColor.black
        titleBackgroundView.alpha = 0.4
        subSelloutBackgroundView.addSubview(titleBackgroundView)
        titleBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
       
        titleLabel.textColor = UIColor.white
        titleLabel.text = "已售罄"
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        subSelloutBackgroundView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalTo(hotelRoomImageView.snp.centerX)
            make.height.equalTo(30)
        }
    }
    
    
    func setUIViewAutolayout() {
        
        //图片
        hotelRoomImageView.sd_setImage(with:URL.init(string: ""), placeholderImage:UIImage.init(named: "hotelPlaceholder"))
        //hotelImageView.clipsToBounds = true
        subBackgroundView.addSubview(hotelRoomImageView)
        hotelRoomImageView.snp.makeConstraints { (make) in
            
            make.top.left.bottom.equalToSuperview()
            make.width.equalTo(115)
            
        }
        
        // 标题
        hotelRoomTitleLabel.text = "北京民族智选假日酒店"
        hotelRoomTitleLabel.font = UIFont.systemFont(ofSize: 13)
        hotelRoomTitleLabel.textColor = TBIThemePrimaryTextColor
        subBackgroundView.addSubview(hotelRoomTitleLabel)
        hotelRoomTitleLabel.snp.makeConstraints { (make) in
            
            make.top.equalToSuperview().offset(10)
            make.left.equalTo(hotelRoomImageView.snp.right).offset(10)
            make.right.equalToSuperview().offset(5)
            make.height.equalTo(13)
            
        }
        
        
        
        //价格
        
        // 这个需要 富文本 处理 暂时 显示 为这个
        hotelRoomPriceLabel.text = "¥266起"
        hotelRoomPriceLabel.textColor = TBIThemeOrangeColor
        hotelRoomPriceLabel.backgroundColor = TBIThemeWhite
        //hotelRoomPriceLabel.adjustsFontSizeToFitWidth = true
        hotelRoomPriceLabel.textAlignment = NSTextAlignment.right
        hotelRoomPriceLabel.font = UIFont.systemFont( ofSize: 16)
        subBackgroundView.addSubview(hotelRoomPriceLabel)
        hotelRoomPriceLabel.snp.makeConstraints { (make) in
            
            make.top.equalTo(hotelRoomTitleLabel.snp.bottom).offset(8)
            make.right.equalToSuperview().inset(10)
            make.width.equalTo(60)
            
        }
        
        hotelRoomBreakfastLabel.text = "不含早"
        hotelRoomBreakfastLabel.font = UIFont.systemFont(ofSize: 13)
        hotelRoomBreakfastLabel.adjustsFontSizeToFitWidth = true
        hotelRoomBreakfastLabel.textColor = TBIThemePlaceholderTextColor
        subBackgroundView.addSubview(hotelRoomBreakfastLabel)
        hotelRoomBreakfastLabel.snp.makeConstraints { (make) in
            
            make.top.equalTo(hotelRoomTitleLabel.snp.bottom).offset(8)
            make.left.equalTo(hotelRoomImageView.snp.right).offset(10)
            make.height.equalTo(13)
            
        }
        
        
        let hotelFirstLineLabel = UILabel()
        hotelFirstLineLabel.backgroundColor = TBIThemePlaceholderTextColor
        subBackgroundView.addSubview(hotelFirstLineLabel)
        hotelFirstLineLabel.snp.makeConstraints { (make) in
            
            make.top.equalTo(hotelRoomBreakfastLabel.snp.top)
            make.left.equalTo(hotelRoomBreakfastLabel.snp.right).offset(2)
            make.height.equalTo(hotelRoomBreakfastLabel.snp.height)
            make.width.equalTo(0.5)
            
        }
        
        
        hotelRoomSizeLabel.text = "双床1.3米"
//        hotelRoomSizeLabel.adjustsFontSizeToFitWidth = true
        hotelRoomSizeLabel.font = UIFont.systemFont(ofSize: 13)
        hotelRoomSizeLabel.textColor = TBIThemePlaceholderTextColor
        subBackgroundView.addSubview(hotelRoomSizeLabel)
        hotelRoomSizeLabel.snp.makeConstraints { (make) in
            
            make.top.equalTo(hotelRoomTitleLabel.snp.bottom).offset(8)
            make.left.equalTo(hotelRoomBreakfastLabel.snp.right).offset(8)
            make.right.equalTo(hotelRoomPriceLabel.snp.left).offset(3)
            make.height.equalTo(13)
            
        }
        
  
        //  是否符合差标
        hotelAccordPolicyFlagImageView.sd_setImage(with: URL.init(string: ""), placeholderImage: UIImage.init(named: ""))
        hotelRoomImageView.addSubview(hotelAccordPolicyFlagImageView)
        hotelAccordPolicyFlagImageView.snp.makeConstraints { (make) in
            
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalTo(34)
            make.height.equalTo(14)
            
        }
        
        //  担保标志
        hotelTravelProtocolFlagImageView.sd_setImage(with: URL.init(string: ""), placeholderImage: UIImage.init(named: ""))
        subBackgroundView.addSubview(hotelTravelProtocolFlagImageView)
        hotelTravelProtocolFlagImageView.snp.makeConstraints { (make) in
            
            make.top.equalTo(hotelRoomBreakfastLabel.snp.bottom).offset(8)
            make.left.equalTo(hotelRoomImageView.snp.right).offset(10)
            make.width.equalTo(18)
            make.height.equalTo(11)
            
        }
        
//        // 协议标志
//        hotelProtocolFlagImageView.sd_setImage(with: URL.init(string: ""), placeholderImage: UIImage.init(named: ""))
//        subBackgroundView.addSubview(hotelProtocolFlagImageView)
//        hotelProtocolFlagImageView.snp.makeConstraints { (make) in
//
//            make.top.equalTo(hotelRoomBreakfastLabel.snp.bottom).offset(8)
//            make.left.equalTo(hotelTravelProtocolFlagImageView.snp.right).offset(6)
//            make.width.equalTo(18)
//            make.height.equalTo(11)
//
//        }
        
        // 担保
        guaranteeFlagLabel.text = "担保"
        guaranteeFlagLabel.font = UIFont.systemFont(ofSize: 10)
        guaranteeFlagLabel.textColor = TBIThemeWhite
        guaranteeFlagLabel.backgroundColor = TBIThemeDarkBlueColor
        guaranteeFlagLabel.layer.cornerRadius = 2
        guaranteeFlagLabel.clipsToBounds = true
//        guaranteeFlagLabel.layer.borderColor = TBIThemeBlueColor.cgColor
//        guaranteeFlagLabel.layer.borderWidth = 1
        guaranteeFlagLabel.textAlignment = NSTextAlignment.center
        subBackgroundView.addSubview(guaranteeFlagLabel)
        guaranteeFlagLabel.snp.makeConstraints { (make) in
            
            make.top.equalTo(hotelRoomBreakfastLabel.snp.bottom).offset(8)
            make.left.equalTo(hotelRoomTitleLabel.snp.left)
            make.width.equalTo(32)
            make.height.equalTo(16)
            
        }
        
        
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
            
            make.top.equalTo(hotelRoomBreakfastLabel.snp.bottom).offset(8)
            make.left.equalTo(hotelRoomTitleLabel.snp.right).offset(5)
            make.width.equalTo(50)
            make.height.equalTo(16)
            
        }
        
      
        
        
        
    }
    
    

    //
    func fillNewDataSources(roomDetail:RoomModel ,accordTravel:Float,nowPay:Bool,anOrder:Bool) {
        
        if roomDetail.imgUrl.isEmpty == false {
            hotelRoomImageView.sd_setImage(with: URL.init(string: roomDetail.imgUrl), placeholderImage:UIImage.init(named: "hotelPlaceholder"))
        }else
        {
            hotelRoomImageView.sd_setImage(with: URL.init(string:""), placeholderImage:UIImage.init(named: "hotelPlaceholder"))
        }
        
        hotelRoomTitleLabel.text = roomDetail.roomName
        hotelRoomBreakfastLabel.text = roomDetail.ratePlanName
        let width = getTextWidth(textStr:roomDetail.ratePlanName , font:UIFont.systemFont(ofSize: 13) ,height:13)
        hotelRoomBreakfastLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(hotelRoomTitleLabel.snp.bottom).offset(8)
            make.left.equalTo(hotelRoomImageView.snp.right).offset(10)
            make.height.equalTo(13)
            make.width.equalTo(width)
        }
        hotelRoomSizeLabel.text = roomDetail.bedType
        
        //let priceStr:String = "¥" + String.init(format: "%.0f",(roomDetail.averageRate)!)
        // modify by manman  价格显示小数点 有效位数
        let priceStr:String = "¥" + (roomDetail.averageRate?.OneOfTheEffectiveFraction())!
        hotelRoomPriceLabel.text = priceStr
        
      
        
        //售罄
        if roomDetail.status == false {
            titleLabel.text = "已售罄"
            subSelloutBackgroundView.isHidden = false
        }else
        {
            /// 如果违背差标
            if (roomDetail.averageRate ?? 0) > accordTravel && anOrder == false{
                titleLabel.text = "不符合差标"
                subSelloutBackgroundView.isHidden = false
            }else {
                subSelloutBackgroundView.isHidden = true
            }
        }
        
        
        
       
        
        //是否存在协议  差旅符合标志
        var isResult:Bool = true
        
        
        // 差标 和协议标志 位置更改
        // modify by manman  on 2017-07-03 start of line
        
        if accordTravel != 0{
            print("into here ...差旅政策")
            
            if (roomDetail.averageRate)! <= accordTravel {
                
                //符合的标志
                hotelTravelProtocolFlagImageView.sd_setImage(with: nil, placeholderImage: UIImage.init(named: "HotelConform"))
            }else
            {
                
                //违背的标志
                hotelTravelProtocolFlagImageView.sd_setImage(with: nil, placeholderImage: UIImage.init(named: ""))
                isResult = false //差旅标 不存在
            }
        }else
        {
          isResult = false
        }
        if  roomDetail.oHotelNightlyRatesMap?.keys.count == 1{
            let protocolStr:String =  (roomDetail.oHotelNightlyRatesMap?.keys.first!)!
            if isResult == true {
                if protocolStr == protocolTBI {
                    hotelProtocolFlagImageView.sd_setImage(with: nil, placeholderImage: UIImage.init(named: "HotelTBI"))
                }
                if protocolStr == protocolFTMS {
                    hotelProtocolFlagImageView.sd_setImage(with: nil, placeholderImage: UIImage.init(named: "HotelProtocolBlue"))
                }
                if protocolStr == protocolElong {
                    
                    if  roomDetail.startTime != nil && (roomDetail.startTime?.characters.count)! > 0 && nowPay == true {
                        hotelProtocolFlagImageView.sd_setImage(with: nil, placeholderImage: UIImage.init(named: "HotelGuarantee"))
                    }
                    else
                    {
                        hotelProtocolFlagImageView.sd_setImage(with: nil, placeholderImage: UIImage.init(named: ""))
                    }
                }
            }
            else
            {
                if protocolStr == protocolTBI {
                    hotelTravelProtocolFlagImageView.sd_setImage(with: nil, placeholderImage: UIImage.init(named: "HotelTBI"))
                }
                if protocolStr == protocolFTMS {
                    hotelTravelProtocolFlagImageView.sd_setImage(with: nil, placeholderImage: UIImage.init(named: "HotelProtocolBlue"))
                }
                if protocolStr == protocolElong {
                    
                    if  roomDetail.startTime != nil && (roomDetail.startTime?.characters.count)! > 0 && nowPay == true {
                        hotelTravelProtocolFlagImageView.sd_setImage(with: nil, placeholderImage: UIImage.init(named: "HotelGuarantee"))
                        hotelProtocolFlagImageView.sd_setImage(with: nil, placeholderImage: UIImage.init(named: ""))
                    }
                    else
                    {
                        hotelTravelProtocolFlagImageView.sd_setImage(with: nil, placeholderImage: UIImage.init(named: ""))
                        hotelProtocolFlagImageView.sd_setImage(with: nil, placeholderImage: UIImage.init(named: ""))
                    }
                    
                    
                }
                
                
            }
            
            
        }
    }
    
    
    func fillDataSources(roomDetail:HotelDetailResult.HotelRoomPlan,accordTravel:Float) {
        if roomDetail.cover.isEmpty == false {
            hotelRoomImageView.sd_setImage(with: URL.init(string: roomDetail.cover), placeholderImage:UIImage.init(named: "hotel_default"))
        }else
        {
            hotelRoomImageView.sd_setImage(with: URL.init(string:""), placeholderImage:UIImage.init(named: "hotel_default"))
        }
        hotelRoomImageView.contentMode = UIViewContentMode.scaleAspectFill
        hotelRoomTitleLabel.text = roomDetail.roomTypeName
        hotelRoomBreakfastLabel.text = roomDetail.ratePlanInfo.valueAdd
        let width = getTextWidth(textStr:roomDetail.ratePlanInfo.valueAdd , font:UIFont.systemFont(ofSize: 13) ,height:13)
        hotelRoomBreakfastLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(hotelRoomTitleLabel.snp.bottom).offset(8)
            make.left.equalTo(hotelRoomImageView.snp.right).offset(10)
            make.height.equalTo(13)
            make.width.equalTo(width)
        }
        hotelRoomSizeLabel.text = roomDetail.bedType
        
        //let priceStr:String = "¥" + String.init(format: "%.0f",(roomDetail.averageRate)!)
        // modify by manman  价格显示小数点 有效位数
        let priceStr:String = "¥" + roomDetail.ratePlanInfo.rate.OneOfTheEffectiveFraction()
        hotelRoomPriceLabel.text = priceStr
        
        var isGuarantee:Bool = false
        // 担保
        if roomDetail.ratePlanInfo.isGuarantee == "1" {
            guaranteeFlagLabel.isHidden = false
            isGuarantee = true
        }else {
            guaranteeFlagLabel.isHidden = true
            isGuarantee = false
        }
        // 协议标
        var hotelProtocolArr:[String] = Array()
        if roomDetail.ratePlanInfo.corpCode.isEmpty == false {
            hotelProtocolArr = roomDetail.ratePlanInfo.corpCode.components(separatedBy: ",").map({ (element) -> String in
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
            if isGuarantee == false {
                hotelCompanyProtocolFlagLabel.snp.remakeConstraints { (update) in
                    update.top.equalTo(hotelRoomBreakfastLabel.snp.bottom).offset(8)
                    update.left.equalTo(hotelRoomTitleLabel.snp.left)
                    update.width.equalTo(50)
                    update.height.equalTo(16)
                }
            }else {
                hotelCompanyProtocolFlagLabel.snp.remakeConstraints { (make) in
                    make.top.equalTo(hotelRoomBreakfastLabel.snp.bottom).offset(8)
                    make.left.equalTo(guaranteeFlagLabel.snp.right).offset(5)
                    make.width.equalTo(50)
                    make.height.equalTo(16)
                }
            }
            
        }else{
            hotelCompanyProtocolFlagLabel.isHidden = true
        }
    
        /// 是否可以显示 违背的标
        var roomStatus:Bool = false
        //售罄
        if roomDetail.ratePlanInfo.status == false {
            roomStatus = true
            titleLabel.text = "已售罄"
            subSelloutBackgroundView.isHidden = false
        }else
        {
            /// 违背差标 是否可以预订
            if roomDetail.ratePlanInfo.rate > accordTravel && roomDetail.ratePlanInfo.canBook == "0" {
                titleLabel.text = "不符合差标"
                subSelloutBackgroundView.isHidden = false
                roomStatus = true
            }else {
                subSelloutBackgroundView.isHidden = true
                roomStatus = false
            }
        }
//        if roomStatus == false {
            if roomDetail.ratePlanInfo.rate <= accordTravel
            {
            // 符合差标
            hotelAccordPolicyFlagImageView.sd_setImage(with: nil, placeholderImage: UIImage.init(named: "ic_hotel_yes"))
            }else{
            //违背差标
            hotelAccordPolicyFlagImageView.sd_setImage(with: nil, placeholderImage: UIImage.init(named: "ic_hotel_no"))
            }
//        }else {
//            hotelAccordPolicyFlagImageView.sd_setImage(with: nil, placeholderImage: UIImage.init(named: ""))
//        }
    
        
        
    }
    
    
    
    
    
    
    func getTextWidth(textStr:String?,font:UIFont,height:CGFloat) -> CGFloat {
        
        if textStr?.characters.count == 0 || textStr == nil {
            return 0.0
        }
        let normalText: NSString = textStr as! NSString
        let size = CGSize(width:1000,height:height)
        let dic = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
        let stringSize = normalText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context:nil).size
        return stringSize.width
    }
    
    
    

}
