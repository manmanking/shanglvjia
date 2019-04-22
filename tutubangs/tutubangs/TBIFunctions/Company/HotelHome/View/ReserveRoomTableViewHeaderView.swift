//
//  ReserveRoomTableViewHeaderView.swift
//  shop
//
//  Created by manman on 2017/4/22.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class ReserveRoomTableViewHeaderView:UITableViewHeaderFooterView{

    private let protocolFTMS = "FTMS"
    private let protocolTBI = "TBI"
    private let protocolElong = "elong"
    
    private var baseBackgroundView = UIView()
    private var hotelImageView = UIImageView()
    private var amountLabel = UILabel()
    private var roomStyleLabel = UILabel()
    private var checkInDateTitleLabel = UILabel()
    private var checkInDateLabel = UILabel()
    private var priodLabel = UILabel()
    private var checkOutDateTitleLabel = UILabel()
    private var checkOutDateLabel = UILabel()
    private var bedStyleLabel = UILabel()
    private var wifiLabel = UILabel()
    fileprivate var hotelProtocolFlagImageView = UIImageView()
    fileprivate var hotelTBIProtocolFlagLabel:UILabel = UILabel()
    fileprivate var hotelCompanyProtocolFlagLabel:UILabel = UILabel()
    fileprivate var hotelCompanyTravelAccordFlagLabel:UILabel = UILabel()
    fileprivate var hotelProtocolCompanyTipDefault:String = "企业协议"
    fileprivate var hotelProtocolTBITipDefault:String = "TBI协议"
    fileprivate var hotelCompanyProtocolTravelAccordTipDefault:String = "符合"
    
    fileprivate var guaranteeFlagLabel:UILabel = UILabel()
    //差旅政策
    fileprivate var hotelTravelProtocolFlagImageView = UIImageView()
    
    
    
//    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        self.contentView.backgroundColor = TBIThemeBaseColor
//        baseBackgroundView.backgroundColor = UIColor.white
//        self.contentView.addSubview(baseBackgroundView)
//        baseBackgroundView.snp.makeConstraints { (make) in
//
//            make.top.left.right.equalToSuperview()
//            make.bottom.equalToSuperview()//.inset(10)
//
//        }
//        setUIViewAutolayout()
//        
//        
//        
//    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = TBIThemeBaseColor
        baseBackgroundView.backgroundColor = UIColor.white
        self.contentView.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
            
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            
        }
        setUIViewAutolayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUIViewAutolayout()
    {

        hotelImageView.sd_setImage(with: URL.init(string: ""), placeholderImage: UIImage.init(named: "ReserveHotelPlaceHolder"))
        hotelImageView.contentMode = UIViewContentMode.scaleAspectFill
        hotelImageView.clipsToBounds = true
        baseBackgroundView.addSubview(hotelImageView)
        hotelImageView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(130 + 70)
        }
        
        roomStyleLabel.text = "高级大床房"
        roomStyleLabel.adjustsFontSizeToFitWidth = true
        roomStyleLabel.font = UIFont.systemFont( ofSize: 13)
        baseBackgroundView.addSubview(roomStyleLabel)
        roomStyleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(hotelImageView.snp.bottom).offset(15)
            make.left.equalToSuperview().inset(15)
            make.height.equalTo(12)
            
        }
       
        // 担保
        guaranteeFlagLabel.text = "担保"
        guaranteeFlagLabel.font = UIFont.systemFont(ofSize: 10)
        guaranteeFlagLabel.textColor = TBIThemeWhite
        guaranteeFlagLabel.layer.cornerRadius = 2
        guaranteeFlagLabel.clipsToBounds = true
        guaranteeFlagLabel.textAlignment = NSTextAlignment.center
        guaranteeFlagLabel.backgroundColor = TBIThemeDarkBlueColor
        baseBackgroundView.addSubview(guaranteeFlagLabel)
        guaranteeFlagLabel.snp.makeConstraints { (make) in
            
            make.left.equalTo(roomStyleLabel.snp.right).offset(10)
            make.centerY.equalTo(roomStyleLabel.snp.centerY)
            make.width.equalTo(32)
            make.height.equalTo(16)
            
        }
        
        // TBI协议
        hotelCompanyProtocolFlagLabel.text = "企业协议"
        hotelCompanyProtocolFlagLabel.font = UIFont.systemFont(ofSize: 10)
        hotelCompanyProtocolFlagLabel.textColor = TBIThemeWhite
        hotelCompanyProtocolFlagLabel.backgroundColor = TBIThemeOrangeColor
        hotelCompanyProtocolFlagLabel.layer.cornerRadius = 2
        hotelCompanyProtocolFlagLabel.clipsToBounds = true
        hotelCompanyProtocolFlagLabel.textAlignment = NSTextAlignment.center
        baseBackgroundView.addSubview(hotelCompanyProtocolFlagLabel)
        hotelCompanyProtocolFlagLabel.snp.makeConstraints { (make) in
            
            make.centerY.equalTo(guaranteeFlagLabel)
            make.left.equalTo(guaranteeFlagLabel.snp.right).offset(5)
            make.width.equalTo(50)
            make.height.equalTo(16)
            
        }
        
        // 是否符合差标
        hotelCompanyTravelAccordFlagLabel.text = hotelCompanyProtocolTravelAccordTipDefault
        hotelCompanyTravelAccordFlagLabel.font = UIFont.systemFont(ofSize: 10)
        hotelCompanyTravelAccordFlagLabel.textColor = TBIThemeWhite
        hotelCompanyTravelAccordFlagLabel.layer.cornerRadius = 2
        hotelCompanyTravelAccordFlagLabel.clipsToBounds = true
        hotelCompanyTravelAccordFlagLabel.textAlignment = NSTextAlignment.center
        hotelCompanyTravelAccordFlagLabel.backgroundColor = TBIThemeGreenColor
        baseBackgroundView.addSubview(hotelCompanyTravelAccordFlagLabel)
        hotelCompanyTravelAccordFlagLabel.snp.makeConstraints { (make) in
            
            make.centerY.equalTo(hotelCompanyProtocolFlagLabel)
            make.left.equalTo(hotelCompanyProtocolFlagLabel.snp.right).offset(5)
            make.width.equalTo(32)
            make.height.equalTo(16)
            
        }
   
        
        
        
        
        
//        // 差标标志
//        hotelTravelProtocolFlagImageView.sd_setImage(with: URL.init(string: ""), placeholderImage: UIImage.init(named: ""))
//        baseBackgroundView.addSubview(hotelTravelProtocolFlagImageView)
//        hotelTravelProtocolFlagImageView.snp.makeConstraints { (make) in
//
////            make.top.equalTo(hotelImageView.snp.bottom).offset(15)
//            make.left.equalTo(roomStyleLabel.snp.right).offset(10)
//            make.centerY.equalTo(roomStyleLabel.snp.centerY)
//            make.width.equalTo(18)
//            make.height.equalTo(11)
//
//        }
//
//        // 协议标志
//        hotelProtocolFlagImageView.sd_setImage(with: URL.init(string: ""), placeholderImage: UIImage.init(named: ""))
//
//        baseBackgroundView.addSubview(hotelProtocolFlagImageView)
//        hotelProtocolFlagImageView.snp.makeConstraints { (make) in
//
//            //make.top.equalTo(hotelImageView.snp.bottom).offset(15)
//            make.left.equalTo(hotelTravelProtocolFlagImageView.snp.right).offset(6)
//            make.centerY.equalTo(hotelTravelProtocolFlagImageView.snp.centerY)
//            make.width.equalTo(18)
//            make.height.equalTo(11)
//
//        }
       
        
        checkInDateTitleLabel.text = "入住:"
        checkInDateTitleLabel.adjustsFontSizeToFitWidth = true
        checkInDateTitleLabel.font = UIFont.systemFont( ofSize: 13)
        baseBackgroundView.addSubview(checkInDateTitleLabel)
        checkInDateTitleLabel.snp.makeConstraints { (make) in
            
            make.top.equalTo(roomStyleLabel.snp.bottom).offset(15)
            make.left.equalTo(roomStyleLabel.snp.left)
            //make.width.equalTo(60)
            make.height.equalTo(roomStyleLabel.snp.height)
            
        }
        
        checkInDateLabel.text = "04-07"
        checkInDateLabel.adjustsFontSizeToFitWidth = true
        checkInDateLabel.font = UIFont.systemFont( ofSize: 13)
        baseBackgroundView.addSubview(checkInDateLabel)
        checkInDateLabel.snp.makeConstraints { (make) in
            
            make.top.equalTo(checkInDateTitleLabel.snp.top)
            make.left.equalTo(checkInDateTitleLabel.snp.right).offset(3)
            //make.width.equalTo(80)
            make.height.equalTo(roomStyleLabel.snp.height)
            
        }
        checkOutDateTitleLabel.text = "离店:"
        checkOutDateTitleLabel.font = UIFont.systemFont( ofSize: 13)
        baseBackgroundView.addSubview(checkOutDateTitleLabel)
        checkOutDateTitleLabel.snp.makeConstraints { (make) in
            
            make.top.equalTo(checkInDateLabel.snp.top)
            make.left.equalTo(checkInDateLabel.snp.right).offset(3)
            //make.width.equalTo(80)
            make.height.equalTo(roomStyleLabel.snp.height)
            
        }
        checkOutDateLabel.text = "04-09"
        checkOutDateLabel.adjustsFontSizeToFitWidth = true
        checkOutDateLabel.font = UIFont.systemFont( ofSize: 13)
        baseBackgroundView.addSubview(checkOutDateLabel)
        checkOutDateLabel.snp.makeConstraints { (make) in
            
            make.top.equalTo(checkInDateLabel.snp.top)
            make.left.equalTo(checkOutDateTitleLabel.snp.right).offset(3)
            //make.width.equalTo(80)
            make.height.equalTo(roomStyleLabel.snp.height)
            
        }
        
        
        
        priodLabel.text = "2晚"
        priodLabel.adjustsFontSizeToFitWidth = true
        priodLabel.font = UIFont.systemFont( ofSize: 13)
        baseBackgroundView.addSubview(priodLabel)
        priodLabel.snp.makeConstraints { (make) in
            
            make.top.equalTo(checkInDateTitleLabel.snp.top)
            make.left.equalTo(checkOutDateLabel.snp.right).offset(3)
            make.width.equalTo(80)
            make.height.equalTo(roomStyleLabel.snp.height)
            
        }
        
        amountLabel.text = "均价¥345"
        amountLabel.textColor = TBIThemeOrangeColor
        amountLabel.adjustsFontSizeToFitWidth = true
        amountLabel.font = UIFont.systemFont( ofSize: 13)
        baseBackgroundView.addSubview(amountLabel)
        amountLabel.snp.makeConstraints { (make) in
            
            make.top.equalTo(checkInDateTitleLabel.snp.top)
            make.right.equalToSuperview().inset(15)
            make.height.equalTo(checkInDateTitleLabel.snp.height)
            
        }
        
        //Wi-Fi 改为是否含早
        wifiLabel.text = "含早"
        wifiLabel.adjustsFontSizeToFitWidth = true
        wifiLabel.font = UIFont.systemFont( ofSize: 13)
        baseBackgroundView.addSubview(wifiLabel)
        wifiLabel.snp.makeConstraints { (make) in
    
            make.left.equalToSuperview().inset(15)
            make.height.equalTo(roomStyleLabel.snp.height)
            make.bottom.equalToSuperview().inset(15)
            
        }
        
        let lineLabel = UILabel()
        lineLabel.backgroundColor = UIColor.black
        baseBackgroundView.addSubview(lineLabel)
        lineLabel.snp.makeConstraints { (make) in
            
            make.top.equalTo(wifiLabel.snp.top)
            make.left.equalTo(wifiLabel.snp.right).offset(3)
            make.height.equalTo(wifiLabel.snp.height)
            make.width.equalTo(0.5)
        }
        
        
        bedStyleLabel.text = "单床1.8米"
        bedStyleLabel.adjustsFontSizeToFitWidth = true
        bedStyleLabel.font = UIFont.systemFont( ofSize: 13)
        baseBackgroundView.addSubview(bedStyleLabel)
        bedStyleLabel.snp.makeConstraints { (make) in
            
            make.left.equalTo(lineLabel.snp.right).offset(3)
            //make.left.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(15)
            //make.width.equalTo(80)
            make.height.equalTo(roomStyleLabel.snp.height)
            
        }
        
//        let lineLabel = UILabel()
//        lineLabel.backgroundColor = UIColor.black
//        baseBackgroundView.addSubview(lineLabel)
//        lineLabel.snp.makeConstraints { (make) in
//            
//            make.top.equalTo(bedStyleLabel.snp.top)
//            make.left.equalTo(wifiLabel.snp.right).offset(3)
//            make.height.equalTo(bedStyleLabel.snp.height)
//            make.width.equalTo(0.5)
//        }
//        
        //Wi-Fi 改为是否含早
//        wifiLabel.text = "宽带免费"
//        wifiLabel.font = UIFont.systemFont( size: 13)
//        baseBackgroundView.addSubview(wifiLabel)
//        wifiLabel.snp.makeConstraints { (make) in
//            
//            make.top.equalTo(bedStyleLabel.snp.top)
//            make.left.equalTo(lineLabel.snp.right).offset(3)
//            make.width.equalTo(100)
//            make.height.equalTo(bedStyleLabel.snp.height)
//            
//        }
        
        
        
        
    }
    
    func fillDataSources(hotelRoomDetail:HotelDetailResult.HotelRoomPlan,checkinDateStr:String,checkoutDateStr:String,accordTravel:Float) {


        if hotelRoomDetail.coverBig.isEmpty == false {
            hotelImageView.sd_setImage(with: URL.init(string: hotelRoomDetail.coverBig), placeholderImage:UIImage.init(named: "hotel_default"))
        }
        roomStyleLabel.text = hotelRoomDetail.roomTypeName
        let checkinDateTimeInterval:TimeInterval = TimeInterval(checkinDateStr)! / 1000
        let checkoutDateTimeInterval:TimeInterval = TimeInterval(checkoutDateStr)! / 1000
        
        checkInDateLabel.text =  Date.init(timeIntervalSince1970: checkinDateTimeInterval).string(custom: "MM-dd")//checkinDateStr.substring(from: (checkinDateStr.range(of: "-")?.upperBound)!)
        checkOutDateLabel.text = Date.init(timeIntervalSince1970: checkoutDateTimeInterval).string(custom: "MM-dd")
            //checkoutDateStr.substring(from: (checkoutDateStr.range(of: "-")?.upperBound)!)
        wifiLabel.text = hotelRoomDetail.ratePlanInfo.valueAdd//hotelRoomDetail.oHotelRatePlans?.first?.ratePlanName
        bedStyleLabel.text = hotelRoomDetail.bedType

        if hotelRoomDetail.ratePlanInfo.rate != nil  {
            amountLabel.text = "均价¥" + hotelRoomDetail.ratePlanInfo.rate.OneOfTheEffectiveFraction()
            //String.init(format: "%.0f", (hotelRoomDetail.oHotelRatePlans?.first?.averageRate)!)

        }
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        let checkinDateStrFull = checkinDateStr + " 18:00:00"
//        let checkoutDateStrFull = checkoutDateStr + " 18:00:00"
//        let checkinDateFull = dateFormatter.date(from: checkinDateStrFull)
//        let checkoutDateFull = dateFormatter.date(from: checkoutDateStrFull)
        let intervalDay = caculateIntervalDay(fromDate: Date.init(timeIntervalSince1970: checkinDateTimeInterval),
                                              toDate: Date.init(timeIntervalSince1970: checkoutDateTimeInterval))
        priodLabel.text = " " + String(intervalDay) + "晚 "
        var isResultFlag:Bool = true
        // 校验是否符合差旅政策。
        // 个人版 不需要 这个标签
//        if accordTravel != 0{
//            print("into here ...差旅政策")
//
//            if hotelRoomDetail.ratePlanInfo.rate <= accordTravel {
//
//                //符合的标志
//                hotelTravelProtocolFlagImageView.sd_setImage(with: nil, placeholderImage: UIImage.init(named: "HotelConform"))
//                hotelTravelProtocolFlagImageView.backgroundColor = UIColor.red
//            }else
//            {
//                //违背的标志
//                hotelTravelProtocolFlagImageView.sd_setImage(with: nil, placeholderImage: UIImage.init(named: ""))
//                isResultFlag = false
//            }
//        }else
//        {
//            //符合的标志
//            hotelTravelProtocolFlagImageView.sd_setImage(with: nil, placeholderImage: UIImage.init(named: ""))
//        }
//
//        if isResultFlag == true {
//            if hotelRoomDetail.ratePlanInfo.corpCode.uppercased().contains(protocolTBI) == true {
//                hotelProtocolFlagImageView.sd_setImage(with: nil, placeholderImage: UIImage.init(named: "HotelTBI"))
//            }else if hotelRoomDetail.ratePlanInfo.corpCode.count > 0 {
//                hotelProtocolFlagImageView.sd_setImage(with: nil, placeholderImage: UIImage.init(named: "HotelProtocolBlue"))
//            }
//        }
//
//        if hotelRoomDetail.ratePlanInfo.isGuarantee == "1" {
//            hotelProtocolFlagImageView.isHidden = false
//            hotelProtocolFlagImageView.sd_setImage(with: nil, placeholderImage: UIImage.init(named: "HotelGuarantee"))
//        }else{
//            hotelProtocolFlagImageView.isHidden = true
//        }

        // 是否存在 符合差标
        var isTravelAccord:Bool = false
        
        if accordTravel != 0 && hotelRoomDetail.ratePlanInfo.rate <= accordTravel  {
                //符合的标志
//                hotelCompanyTravelAccordFlagLabel.isHidden = false
            hotelCompanyTravelAccordFlagLabel.backgroundColor = TBIThemeGreenColor
            hotelCompanyTravelAccordFlagLabel.text = "符合"
                isTravelAccord = true
        } else {
            //违背的标志
//            hotelCompanyTravelAccordFlagLabel.isHidden = true
            hotelCompanyTravelAccordFlagLabel.backgroundColor = TBIThemeOrangeColor
            hotelCompanyTravelAccordFlagLabel.text = "违背"
            isTravelAccord = false
        }
    
        // 担保
        var isGuarantee:Bool = false
        if isTravelAccord == true && hotelRoomDetail.ratePlanInfo.isGuarantee == "1"   {
            guaranteeFlagLabel.isHidden = false
            isGuarantee = true
            guaranteeFlagLabel.snp.remakeConstraints { (make) in
                make.centerY.equalTo(roomStyleLabel)
                make.left.equalTo(roomStyleLabel.snp.right).offset(5)
                make.width.equalTo(32)
                make.height.equalTo(16)
            }
        }else {
            
            if  isTravelAccord == false && hotelRoomDetail.ratePlanInfo.isGuarantee == "1"   {
                guaranteeFlagLabel.isHidden = false
                isGuarantee = true
                guaranteeFlagLabel.snp.remakeConstraints { (make) in
                    make.left.equalTo(roomStyleLabel.snp.right).offset(10)
                    make.centerY.equalTo(roomStyleLabel.snp.centerY)
                    make.width.equalTo(32)
                    make.height.equalTo(16)
                }
            }else {
                guaranteeFlagLabel.isHidden = true
                isGuarantee = false
            }
            
           
        }
      
        // 协议标
        var isProtocol : Bool = false
        var hotelProtocolArr:[String] = Array()
        if hotelRoomDetail.ratePlanInfo.corpCode.isEmpty == false {
            hotelProtocolArr = hotelRoomDetail.ratePlanInfo.corpCode.components(separatedBy: ",").map({ (element) -> String in
                return element.uppercased()
            })
        }
        let selfCompanyProtocol:String = DBManager.shareInstance.userDetailDraw()?.busLoginInfo.userBaseInfo.corpCode.uppercased() ?? ""
        if hotelProtocolArr.count > 0 {
            hotelCompanyProtocolFlagLabel.isHidden = false
            isProtocol = true
            if hotelProtocolArr.contains(HotelTBIProtocol) {
                hotelCompanyProtocolFlagLabel.text = hotelProtocolTBITipDefault
            }
            if selfCompanyProtocol != HotelTBIProtocol && hotelProtocolArr.contains(selfCompanyProtocol) {
                hotelCompanyProtocolFlagLabel.text = hotelProtocolCompanyTipDefault
            }
            if isGuarantee == false { //担保不存在
//                if isTravelAccord == true { //符合的标存在
//                    hotelCompanyProtocolFlagLabel.snp.remakeConstraints { (update) in
//                        update.centerY.equalTo(hotelCompanyTravelAccordFlagLabel)
//                        update.left.equalTo(guaranteeFlagLabel.snp.right).offset(5)
//                        update.width.equalTo(50)
//                        update.height.equalTo(16)
//                    }
//                }else { // 符合的标不存在
                    hotelCompanyProtocolFlagLabel.snp.remakeConstraints { (update) in
                        update.left.equalTo(roomStyleLabel.snp.right).offset(10)
                        update.centerY.equalTo(roomStyleLabel.snp.centerY)
                        update.width.equalTo(50)
                        update.height.equalTo(16)
                    }
//                }
               
            }else {
                hotelCompanyProtocolFlagLabel.snp.remakeConstraints { (make) in
                    make.centerY.equalTo(guaranteeFlagLabel)
                    make.left.equalTo(guaranteeFlagLabel.snp.right).offset(5)
                    make.width.equalTo(50)
                    make.height.equalTo(16)
                }
            }
            
        }else{
            hotelCompanyProtocolFlagLabel.isHidden = true
            isProtocol = false
        }
        
        if isProtocol == false{
            //无协议
            if isGuarantee{
                //有担保
                hotelCompanyTravelAccordFlagLabel.snp.remakeConstraints({ (make) in
                    make.centerY.equalTo(guaranteeFlagLabel.snp.centerY)
                    make.left.equalTo(guaranteeFlagLabel.snp.right).offset(5)
                    make.width.equalTo(32)
                    make.height.equalTo(16)
                })
            }else{
                //无担保
                hotelCompanyTravelAccordFlagLabel.snp.remakeConstraints({ (make) in
                    make.centerY.equalTo(roomStyleLabel.snp.centerY)
                    make.left.equalTo(roomStyleLabel.snp.right).offset(5)
                    make.width.equalTo(32)
                    make.height.equalTo(16)
                })
            }
        }else{
            hotelCompanyTravelAccordFlagLabel.snp.remakeConstraints({ (make) in
                make.centerY.equalTo(hotelCompanyProtocolFlagLabel.snp.centerY)
                make.left.equalTo(hotelCompanyProtocolFlagLabel.snp.right).offset(5)
                make.width.equalTo(32)
                make.height.equalTo(16)
            })
        }
    }

    func fillDataSourcesNew(hotelRoomDetail:RoomModel,checkinDateStr:String,checkoutDateStr:String,accordTravel:Float) {
        
        if hotelRoomDetail.imgBigUrl.isEmpty == false {
            hotelImageView.sd_setImage(with: URL.init(string: hotelRoomDetail.imgBigUrl), placeholderImage:UIImage.init(named: "hotelPlaceholder"))
        }
        roomStyleLabel.text = hotelRoomDetail.roomName
        checkInDateLabel.text = checkinDateStr.substring(from: (checkinDateStr.range(of: "-")?.upperBound)!)
        checkOutDateLabel.text = checkoutDateStr.substring(from: (checkoutDateStr.range(of: "-")?.upperBound)!)
        wifiLabel.text = hotelRoomDetail.ratePlanName
        bedStyleLabel.text = hotelRoomDetail.bedType
        
        if hotelRoomDetail.averageRate != nil  {
            amountLabel.text = "均价¥" + (hotelRoomDetail.averageRate?.OneOfTheEffectiveFraction())!//String.init(format: "%.0f", (hotelRoomDetail.averageRate)!)
            
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let checkinDateStrFull = checkinDateStr + " 12:00:00"
        let checkoutDateStrFull = checkoutDateStr + " 12:00:00"
        let checkinDateFull = dateFormatter.date(from: checkinDateStrFull)
        let checkoutDateFull = dateFormatter.date(from: checkoutDateStrFull)
        let intervalDay = caculateIntervalDay(fromDate: checkinDateFull!, toDate: checkoutDateFull!)
        priodLabel.text = " " + String(intervalDay) + "晚 "

        var isResultFlag:Bool = true
        // 校验是否符合差旅政策。
        // 个人版 不需要 这个标签
        if accordTravel != 0{
            print("into here ...差旅政策")
            
            if (hotelRoomDetail.averageRate)! <= accordTravel {
                
                //符合的标志
                hotelTravelProtocolFlagImageView.sd_setImage(with: nil, placeholderImage: UIImage.init(named: "HotelConform"))
                hotelTravelProtocolFlagImageView.backgroundColor = UIColor.red
            }else
            {
                //违背的标志
                hotelTravelProtocolFlagImageView.sd_setImage(with: nil, placeholderImage: UIImage.init(named: ""))
                isResultFlag = false
            }
        }else
        {
            //符合的标志
            hotelTravelProtocolFlagImageView.sd_setImage(with: nil, placeholderImage: UIImage.init(named: ""))
            isResultFlag = false
        }
        
        if  hotelRoomDetail.oHotelNightlyRatesMap?.keys.count == 1{
            let protocolStr:String =  (hotelRoomDetail.oHotelNightlyRatesMap?.keys.first!)!
            if isResultFlag == true {
                if protocolStr == protocolTBI {
                    hotelProtocolFlagImageView.sd_setImage(with: nil, placeholderImage: UIImage.init(named: "HotelTBI"))
                }
                if protocolStr == protocolFTMS {
                    hotelProtocolFlagImageView.sd_setImage(with: nil, placeholderImage: UIImage.init(named: "HotelProtocolBlue"))
                }
                if protocolStr == protocolElong {
                    
                    if  hotelRoomDetail.startTime != nil && (hotelRoomDetail.startTime?.characters.count)! > 0{
                        hotelProtocolFlagImageView.sd_setImage(with: nil, placeholderImage: UIImage.init(named: "HotelGuarantee"))
                    }
                    else
                    {
                        hotelProtocolFlagImageView.sd_setImage(with: nil, placeholderImage: UIImage.init(named: ""))
                    }
                    
                    
                }
            }else
            {
                if protocolStr == protocolTBI {
                    hotelTravelProtocolFlagImageView.sd_setImage(with: nil, placeholderImage: UIImage.init(named: "HotelTBI"))
                }
                if protocolStr == protocolFTMS {
                    hotelTravelProtocolFlagImageView.sd_setImage(with: nil, placeholderImage: UIImage.init(named: "HotelProtocolBlue"))
                }
                if protocolStr == protocolElong {
                    
                    if  hotelRoomDetail.startTime != nil && (hotelRoomDetail.startTime?.characters.count)! > 0  {
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
    
    private func caculateIntervalDay(fromDate:Date,toDate:Date) -> NSInteger {
        
        let calendar = NSCalendar.init(identifier: NSCalendar.Identifier.gregorian)
        let result = calendar?.components(NSCalendar.Unit.day, from: fromDate, to: toDate, options: NSCalendar.Options.matchFirst)
        
        return (result?.day)!
    }
}
