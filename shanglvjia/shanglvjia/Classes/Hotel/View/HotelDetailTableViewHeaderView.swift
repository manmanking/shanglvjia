//
//  HotelDetailTableViewHeaderView.swift
//  shop
//
//  Created by manman on 2017/4/22.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit



class HotelDetailTableViewHeaderView: UITableViewHeaderFooterView {
    
    typealias HotelDetailHeaderViewMoreBlock = ()->Void
    
    public var hotelDetailHeaderViewMoreBlock:HotelDetailHeaderViewMoreBlock!
    
    typealias HotelDetailHeaderViewAddressDetailBlock = ()->Void
    
    public var hotelDetailHeaderViewAddressDetailBlock:HotelDetailHeaderViewAddressDetailBlock!
    
    private var baseBackgroundView = UIView()
    //hotel 特点 图片
    private var hotelCharacteristicFlagImageView = UIImageView()
    private var cycleScrollView:SDCycleScrollView = SDCycleScrollView()
    private var cycleScrollImageView:UIScrollView = UIScrollView()
    
    private var hotelBuildingFlagImageView = UIImageView()
    private var hotelTitleLabel = UILabel()
    
    private var hotelAddressFlagImageView = UIImageView()
    private var hotelAddressLabel = UILabel()
    
    private var detailButton = UIButton()
    
    private var hotelServicePhoneFlagImageView = UIImageView()
    private var hotelServicePhoneLabel = UILabel()
    
    private var telButton = UIButton()
    
    private var hotelInfoFlagImageView = UIImageView()
    private var hotelInfoLabel = UILabel()
    
    private var moreButton = UIButton()
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = TBIThemeBaseColor
        baseBackgroundView.backgroundColor = UIColor.white
        self.contentView.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
            
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
            
        }
        
        setUIViewAutolayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setUIViewAutolayout()
    {
        
//        
//        SDCycleScrollView *cycleScrollView = [cycleScrollViewWithFrame:frame delegate:delegate placeholderImage:placeholderImage];
//        cycleScrollView.imageURLStringsGroup = imagesURLStrings;
//        
//        baseBackgroundView.addSubview(cycleScrollView)
//        cycleScrollView.snp.makeConstraints { (make) in
//            make.top.left.right.equalToSuperview()
//            make.height.equalTo(75)
//        }
        cycleScrollImageView.backgroundColor = UIColor.white
        cycleScrollImageView.showsHorizontalScrollIndicator = true
        baseBackgroundView.addSubview(cycleScrollImageView)
        cycleScrollImageView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(75)
            make.top.equalTo(10)
        }
        
        let bottomLine:UILabel = UILabel()
        bottomLine.backgroundColor = TBIThemeGrayLineColor
        baseBackgroundView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(15)
            make.right.equalToSuperview()
            make.bottom.equalTo(cycleScrollImageView.snp.bottom).offset(44)
            make.height.equalTo(0.5)
            
        }
        let bottomLineSecond:UILabel = UILabel()
        bottomLineSecond.backgroundColor = TBIThemeGrayLineColor
        baseBackgroundView.addSubview(bottomLineSecond)
        bottomLineSecond.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(15)
            make.right.equalToSuperview()
            make.bottom.equalTo(bottomLine.snp.bottom).offset(44)
            make.height.equalTo(0.5)
            
        }
        
        let bottomLineThired:UILabel = UILabel()
        bottomLineThired.backgroundColor = TBIThemeGrayLineColor
        baseBackgroundView.addSubview(bottomLineThired)
        bottomLineThired.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(15)
            make.right.equalToSuperview()
            make.bottom.equalTo(bottomLineSecond.snp.bottom).offset(44)
            make.height.equalTo(0.5)
            
        }
        
        
        
        
        
        hotelBuildingFlagImageView.image = UIImage.init(named: "HotelName")
        baseBackgroundView.addSubview(hotelBuildingFlagImageView)
        hotelBuildingFlagImageView.snp.makeConstraints { (make) in
            
            make.top.equalTo(cycleScrollImageView.snp.bottom).offset(12)
            make.left.equalTo(15)
            make.width.equalTo(20)
            make.height.equalTo(20)
            
        }
        hotelTitleLabel.text = ""
        hotelTitleLabel.textColor = TBIThemePrimaryTextColor
        hotelTitleLabel.font = UIFont.systemFont( ofSize: 14)
        baseBackgroundView.addSubview(hotelTitleLabel)
        hotelTitleLabel.snp.makeConstraints { (make) in
            
            make.left.equalTo(hotelBuildingFlagImageView.snp.right).offset(10)
            make.centerY.equalTo(hotelBuildingFlagImageView.snp.centerY)
            make.right.equalToSuperview()
            make.height.equalTo(20)
            
        }
       
        
      
        
        hotelAddressFlagImageView.image = UIImage.init(named: "HotelAddress")
        baseBackgroundView.addSubview(hotelAddressFlagImageView)
        hotelAddressFlagImageView.snp.makeConstraints { (make) in
            
            make.top.equalTo(bottomLine.snp.bottom).offset(12)
            make.left.equalTo(15)
            make.width.equalTo(20)
            make.height.equalTo(20)
            
        }
        
        
        detailButton.setTitle("地图", for: UIControlState.normal)
//        detailButton.setImage(UIImage.init(named: "HotelRightBlue"), for: UIControlState.normal)
        detailButton.setTitleColor(TBIThemeBlueColor, for: UIControlState.normal)
        detailButton.titleLabel?.font = UIFont.systemFont( ofSize: 11)
        detailButton.titleLabel?.adjustsFontSizeToFitWidth = true
        detailButton.addTarget(self, action: #selector(detailButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        baseBackgroundView.addSubview(detailButton)
        detailButton.snp.makeConstraints { (make) in
            
            make.top.equalTo(hotelBuildingFlagImageView.snp.bottom).offset(15)
            make.right.equalToSuperview().inset(15)
            make.centerY.equalTo(hotelAddressFlagImageView.snp.centerY)
            make.height.equalTo(20)
            
        }
        let detailButtonImageFrame = detailButton.imageView?.bounds
        let detailButtonTitleFrame = detailButton.titleLabel?.bounds
        
        detailButton.imageEdgeInsets = UIEdgeInsetsMake(0,(detailButtonTitleFrame?.size.width)!, 0,-(detailButtonTitleFrame?.size.width)!)
        detailButton.titleEdgeInsets = UIEdgeInsetsMake(0,-(detailButtonImageFrame?.size.width)!, 0,(detailButtonImageFrame?.size.width)!)
        
        
        
        
        
        hotelAddressLabel.text = ""
        hotelAddressLabel.textColor = TBIThemePrimaryTextColor
        hotelAddressLabel.font = UIFont.systemFont( ofSize: 14)
        baseBackgroundView.addSubview(hotelAddressLabel)
        hotelAddressLabel.snp.makeConstraints { (make) in
            
            make.left.equalTo(hotelAddressFlagImageView.snp.right).offset(10)
            make.centerY.equalTo(hotelAddressFlagImageView.snp.centerY)
            make.right.equalTo(detailButton.snp.left).offset(-5)
            make.height.equalTo(20)
            
        }
        
       
        
        
        
        hotelServicePhoneFlagImageView.image = UIImage.init(named: "ic_hotel_tel")
        baseBackgroundView.addSubview(hotelServicePhoneFlagImageView)
        hotelServicePhoneFlagImageView.snp.makeConstraints { (make) in
            
            make.top.equalTo(bottomLineSecond.snp.bottom).offset(12)
            make.left.equalTo(15)
            make.width.equalTo(20)
            make.height.equalTo(20)
            
        }
        
        hotelServicePhoneLabel.text = ""
        hotelServicePhoneLabel.textColor = TBIThemePrimaryTextColor
        hotelServicePhoneLabel.font = UIFont.systemFont( ofSize: 14)
        baseBackgroundView.addSubview(hotelServicePhoneLabel)
        hotelServicePhoneLabel.snp.makeConstraints { (make) in
            
            make.left.equalTo(hotelServicePhoneFlagImageView.snp.right).offset(10)
            make.centerY.equalTo(hotelServicePhoneFlagImageView.snp.centerY)
            make.right.equalToSuperview()
            make.height.equalTo(20)
            
        }
        
        
        
        
        telButton.setTitle("拨打", for: UIControlState.normal)
//        telButton.setImage(UIImage.init(named: "HotelRightBlue"), for: UIControlState.normal)
        telButton.setTitleColor(TBIThemeBlueColor, for: UIControlState.normal)
        telButton.titleLabel?.font = UIFont.systemFont( ofSize: 11)
        telButton.titleLabel?.adjustsFontSizeToFitWidth = true
        telButton.addTarget(self, action: #selector(callPhone), for: UIControlEvents.touchUpInside)
        baseBackgroundView.addSubview(telButton)
        telButton.snp.makeConstraints { (make) in
            
            make.top.equalTo(hotelServicePhoneLabel.snp.top)
            make.right.equalToSuperview().inset(15)
            make.height.equalTo(hotelServicePhoneLabel.snp.height)
            
        }
        
        let telButtonImageFrame = telButton.imageView?.bounds
        let telButtonTitleFrame = telButton.titleLabel?.bounds
        
        telButton.imageEdgeInsets = UIEdgeInsetsMake(0,(telButtonTitleFrame?.size.width)!, 0,-(telButtonTitleFrame?.size.width)!)
        telButton.titleEdgeInsets = UIEdgeInsetsMake(0,-(telButtonImageFrame?.size.width)!, 0,(telButtonImageFrame?.size.width)!)
        
        
        
        
        hotelInfoFlagImageView.image = UIImage.init(named: "HotelDetails")
        baseBackgroundView.addSubview(hotelInfoFlagImageView)
        hotelInfoFlagImageView.snp.makeConstraints { (make) in
            
            make.top.equalTo(bottomLineThired.snp.bottom).offset(12)
            make.left.equalTo(15)
            make.width.equalTo(20)
            make.height.equalTo(20)
            
        }
        hotelInfoLabel.text = "酒店信息"
        hotelInfoLabel.textColor = TBIThemePrimaryTextColor
        hotelInfoLabel.font = UIFont.systemFont( ofSize: 14)
        baseBackgroundView.addSubview(hotelInfoLabel)
        hotelInfoLabel.snp.makeConstraints { (make) in
            
            make.left.equalTo(hotelInfoFlagImageView.snp.right).offset(10)
            make.centerY.equalTo(hotelInfoFlagImageView.snp.centerY)
            make.right.equalToSuperview()
            make.height.equalTo(20)
            
        }
        
        moreButton.setTitle("更多", for: UIControlState.normal)
//        moreButton.setImage(UIImage.init(named: "HotelRightBlue"), for: UIControlState.normal)
        moreButton.setTitleColor(TBIThemeBlueColor, for: UIControlState.normal)
        moreButton.addTarget(self, action: #selector(moreButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        moreButton.titleLabel?.font = UIFont.systemFont( ofSize: 11)
        moreButton.titleLabel?.adjustsFontSizeToFitWidth = true
        baseBackgroundView.addSubview(moreButton)
        moreButton.snp.makeConstraints { (make) in
            
            make.top.equalTo(hotelInfoLabel.snp.top)
            make.right.equalToSuperview().inset(15)
            make.height.equalTo(hotelInfoLabel.snp.height)
            
        }
        
        let moreButtonImageFrame = moreButton.imageView?.bounds
        let moreButtonTitleFrame = moreButton.titleLabel?.bounds
        
        moreButton.imageEdgeInsets = UIEdgeInsetsMake(0,(moreButtonTitleFrame?.size.width)!, 0,-(moreButtonTitleFrame?.size.width)!)
        moreButton.titleEdgeInsets = UIEdgeInsetsMake(0,-(moreButtonImageFrame?.size.width)!, 0,(moreButtonImageFrame?.size.width)!)
        
    }
    
    func fillDataSources(hotelDetail:HotelDetailResult.HotelDetailInfo) {
        var frameX = 0
        for element in hotelDetail.images {
            
            let imageView = UIImageView.init(frame: CGRect(x: frameX, y: 0, width: 106, height: 75))
            //            imageView.frame = CGRect(x: frameX, y: 0, width: 106, height: 75)
            imageView.sd_setImage(with:URL.init(string: element), placeholderImage: UIImage.init(named: "hotel_default"))
            cycleScrollImageView.addSubview(imageView)
            frameX += 10 + 106
        }
        cycleScrollImageView.contentSize = CGSize.init(width: frameX - 10, height: 75)
        hotelTitleLabel.text = hotelDetail.hotelName
        hotelAddressLabel.text = hotelDetail.hotelAddress
        hotelServicePhoneLabel.text = hotelDetail.hotelPhone
        
        
        
    }
    
    
    func fillDataSources(hotelDetail:HotelDetail) {
        //cycleScrollView.imageURLStringsGroup = hotelDetail.detail?.hotelImage
        var frameX = 0
        for element in (hotelDetail.detail?.hotelImage)! {
            
            let imageView = UIImageView.init(frame: CGRect(x: frameX, y: 0, width: 106, height: 75))
//            imageView.frame = CGRect(x: frameX, y: 0, width: 106, height: 75)
            imageView.sd_setImage(with:URL.init(string: element), placeholderImage: UIImage.init(named: ""))
            cycleScrollImageView.addSubview(imageView)
            frameX += 10 + 106
        }
        cycleScrollImageView.contentSize = CGSize.init(width: frameX - 10, height: 75)
        hotelTitleLabel.text = hotelDetail.detail?.name
        hotelAddressLabel.text = hotelDetail.detail?.address
        hotelServicePhoneLabel.text = hotelDetail.detail?.phone
    }
    
    
    
    
    //MARK:- Action
    
    //暂时 这样 后面修改 为最新的系统控件
    func detailButtonAction(sender:UIButton) {
//        let alert = UIAlertView.init(title: "", message: hotelAddressLabel.text, delegate: nil, cancelButtonTitle: "关闭")
//        alert.show()
        if hotelDetailHeaderViewAddressDetailBlock != nil {
            hotelDetailHeaderViewAddressDetailBlock()
        }
    }
    
    func callPhone() {
        let callWebView = UIWebView()
        let phoneNum = "tel:" + (hotelServicePhoneLabel.text?.description)!
        let callURL = NSURL.init(string:phoneNum)
        callWebView.loadRequest(URLRequest.init(url: callURL as! URL))
        self.addSubview(callWebView)
    }
    
    
    func moreButtonAction(sender:UIButton) {
        
        self.hotelDetailHeaderViewMoreBlock()
        
    }
    
    
    
    
    
    

}
