//
//  PersonalCommonHotelListHeaderView.swift
//  shanglvjia
//
//  Created by tbi on 2018/8/1.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PersonalCommonHotelListHeaderView: UITableViewHeaderFooterView,UITextFieldDelegate{
    
    
    typealias HotelListSelctedDateBlock = (Dictionary<String,Any>)->Void
    
    typealias HotelListHeaderSearchBlock = (Dictionary<String,Any>)->Void
    
    typealias HotelListHeaderRegionBlock = (String)->Void
    
    typealias HotelCommonClearLandMarkBlock = ()->Void
    
    public var hotelListSelctedDateBlock:HotelListSelctedDateBlock!
    public var hotelListHeaderSearchBlock:HotelListHeaderSearchBlock!
    public var hotelListHeaderRegionBlock:HotelListHeaderRegionBlock!
    public var hotelCommonClearLandMarkBlock:HotelCommonClearLandMarkBlock!
    
    
    private var baseBackgroundView = UIView()
    
    private var subBaseBackgroundView = UIView()
    private var subLeftBackgroundView = UIView()
    
    private var checkinDateTitleLabel = UILabel()
    private var checkinDateLabel = UILabel()
    private var checkinDate = String()
    
    private var checkoutDateTitleLabel = UILabel()
    private var checkoutDateLabel = UILabel()
    private var checkoutDate = String()
    private var choiceDateButton  = UIButton()
 
    private var searchRegionFlagImageView:UIImageView  = UIImageView()
    //搜索框 的灰色框
    private var subMidBackgroundView = UIView()
    
    private var keywordTextField = UITextField()
    
    private var searchDefaultImageName:String = "ic_search"
    
    private var clearDefaultImageName:String = "ic_clear"
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = TBIThemeBaseColor
        baseBackgroundView.backgroundColor = TBIThemeWhite
        self.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        subBaseBackgroundView.layer.cornerRadius = 4
        subBaseBackgroundView.backgroundColor = TBIThemeBaseColor
        baseBackgroundView.addSubview(subBaseBackgroundView)
        subBaseBackgroundView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        setUIViewAutolayut()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func setUIViewAutolayut() {
        
        //subLeftBackgroundView.backgroundColor = UIColor.green
        baseBackgroundView.addSubview(subLeftBackgroundView)
        subLeftBackgroundView.snp.makeConstraints { (make) in
            
            make.top.bottom.equalToSuperview().inset(2)
            //make.right.equalTo(subMidBackgroundView.snp.left).offset(-10)
            make.left.equalToSuperview().inset(3)
            make.width.equalTo(60)
            
        }
        choiceDateButton.setImage(UIImage.init(named: "HotelDownSolidTriangle"), for: UIControlState.normal)
        choiceDateButton.imageView?.contentMode  = UIViewContentMode.center
        //choiceDateButton.setEnlargeEdge(top: 0, left: 50, bottom: 0, right: 0)
        choiceDateButton.setEnlargeEdgeWithTop(0, left: 50, bottom: 0, right: 0)
        choiceDateButton.addTarget(self, action: #selector(choiceDateButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        subLeftBackgroundView.addSubview(choiceDateButton)
        choiceDateButton.snp.makeConstraints { (make) in
            
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalTo(7)
            make.height.equalTo(30)
            
        }
        
        
        
        
        checkinDateTitleLabel.text = "住"
        checkinDateTitleLabel.textColor = TBIThemePrimaryTextColor
        //checkinDateTitleLabel.adjustsFontSizeToFitWidth = true
        checkinDateTitleLabel.font = UIFont.systemFont( ofSize: 10)
        subLeftBackgroundView.addSubview(checkinDateTitleLabel)
        checkinDateTitleLabel.snp.makeConstraints { (make) in
            
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(3)
            make.width.equalTo(12)
            make.height.equalTo(12)
            
        }
        
        checkinDateLabel.text = "5-22"
        checkinDateLabel.textColor = TBIThemePrimaryTextColor
        //checkinDateLabel.adjustsFontSizeToFitWidth = true
        checkinDateLabel.font = UIFont.systemFont( ofSize: 10)
        subLeftBackgroundView.addSubview(checkinDateLabel)
        checkinDateLabel.snp.makeConstraints { (make) in
            
            make.top.equalTo(checkinDateTitleLabel)
            make.left.equalTo(checkinDateTitleLabel.snp.right).offset(3)
            make.height.equalTo(12)
            make.right.equalTo(choiceDateButton.snp.left)
        }
        
        
        checkoutDateTitleLabel.text = "离"
        checkoutDateTitleLabel.textColor = TBIThemePrimaryTextColor
        //checkoutDateTitleLabel.adjustsFontSizeToFitWidth = true
        checkoutDateTitleLabel.font = UIFont.systemFont( ofSize: 10)
        subLeftBackgroundView.addSubview(checkoutDateTitleLabel)
        checkoutDateTitleLabel.snp.makeConstraints { (make) in
            
            make.top.equalTo(checkinDateTitleLabel.snp.bottom)
            make.left.equalToSuperview().offset(3)
            make.height.width.equalTo(12)
        }
        
        checkoutDateLabel.text = "5-24"
        checkoutDateLabel.textColor = TBIThemePrimaryTextColor
        //checkoutDateLabel.adjustsFontSizeToFitWidth = true
        checkoutDateLabel.font = UIFont.systemFont( ofSize: 10)
        subLeftBackgroundView.addSubview(checkoutDateLabel)
        checkoutDateLabel.snp.makeConstraints { (make) in
            
            make.top.equalTo(checkoutDateTitleLabel.snp.top)
            make.left.equalTo(checkoutDateTitleLabel.snp.right).offset(3)
            make.height.equalTo(12)
            make.right.equalTo(choiceDateButton.snp.left)
            
        }
       
        baseBackgroundView.addSubview(subMidBackgroundView)
        subMidBackgroundView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(10)
            make.left.equalTo(subLeftBackgroundView.snp.right).offset(5)
            make.right.equalToSuperview().inset(10)
            
        }
        
        keywordTextField.placeholder = "行政区/地标/商圈"//"关键字／酒店名称／位置"
        keywordTextField.delegate = self
        keywordTextField.returnKeyType =  UIReturnKeyType.search
        keywordTextField.font = UIFont.systemFont( ofSize: 13)
        //keywordTextField.clearButtonMode = UITextFieldViewMode.always
        subMidBackgroundView.addSubview(keywordTextField)
        keywordTextField.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalToSuperview()
        }
        searchRegionFlagImageView.image = UIImage.init(named: "ic_search")
        searchRegionFlagImageView.contentMode = UIViewContentMode.scaleAspectFit
        searchRegionFlagImageView.addOnClickListener(target: self, action: #selector(searchBarAction))
        subBaseBackgroundView.addSubview(searchRegionFlagImageView)
        searchRegionFlagImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(16)
            make.right.equalToSuperview().offset(-8)
        }
    
    }
    
    
    private func adjustButtonImage(sender:UIButton) {
        sender.titleLabel?.sizeToFit()
        sender.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -12, bottom: 0, right: 12)
        sender.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: (sender.titleLabel?.bounds.size.width)!, bottom: 0, right: -(sender.titleLabel?.bounds.size.width)!)
    }
    
    
    
    
    public func fillDataSources(searchCondition:PersonalNormalHotelListRequest,isMapSearch:Bool = false) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone?
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" //"yyyy-MM-dd HH:mm:ss"
        let checkinDate:Date = dateFormatter.date(from: searchCondition.arrivalDateFormat)!
        let checkoutDate:Date = dateFormatter.date(from: searchCondition.departureDateFormat)!
        
        if searchCondition.arrivalDateFormat.isEmpty == false {
            
            checkinDateLabel.text = checkinDate.string(custom: "MM-dd")
            
        }
        if searchCondition.departureDateFormat.isEmpty == false {
            
            checkoutDateLabel.text = checkoutDate.string(custom: "MM-dd")
        }
        var searchRegion:String = ""
        if searchCondition.searchRegion.isEmpty == false {
            searchRegion = searchCondition.searchRegion
        }
        if searchRegion.isEmpty  == false && isMapSearch == false {
            keywordTextField.text = searchRegion
            searchRegionFlagImageView.image = UIImage.init(named: clearDefaultImageName)
        }else
        {
            keywordTextField.text = ""
            searchRegionFlagImageView.image = UIImage.init(named: searchDefaultImageName)
        }
        
    }
    
    
    func fillDataSources(searchCondition:HotelSearchForm) {
        
        
        
        if searchCondition.arrivalDate.isEmpty == false {
            if searchCondition.arrivalDate.characters.count == 10 {
                //时间example 2017-06-22
                checkinDate = searchCondition.arrivalDate
                checkinDateLabel.text = searchCondition.arrivalDate.substring(from: (searchCondition.arrivalDate.range(of: "-")?.upperBound)!)
            }else
            {
                //时间example 2017-06-22 16:00:00
                let tmpCheckinDate =  searchCondition.arrivalDate.substring(to: (searchCondition.arrivalDate.range(of: " ")?.upperBound)!)
                checkinDate = tmpCheckinDate
                checkinDateLabel.text = tmpCheckinDate.substring(from: (tmpCheckinDate.range(of: "-")?.upperBound)!)
            }
            
            
        }
        if searchCondition.departureDate.isEmpty == false {
            checkoutDate = searchCondition.departureDate
            checkoutDateLabel.text = searchCondition.departureDate.substring(from: (searchCondition.arrivalDate.range(of: "-")?.upperBound)!)
            
            if searchCondition.departureDate.characters.count == 10 {
                //时间example 2017-06-22
                checkoutDate = searchCondition.departureDate
                checkoutDateLabel.text = searchCondition.departureDate.substring(from: (searchCondition.departureDate.range(of: "-")?.upperBound)!)
            }else
            {
                //时间example 2017-06-22 16:00:00
                let tmpCheckoutDate =  searchCondition.departureDate.substring(to: (searchCondition.departureDate.range(of: " ")?.lowerBound)!)
                checkoutDate = tmpCheckoutDate
                checkoutDateLabel.text = tmpCheckoutDate.substring(from: (tmpCheckoutDate.range(of: "-")?.upperBound)!)
            }
            
            
            
        }
        if searchCondition.keyWord?.isEmpty  == false {
            keywordTextField.text = searchCondition.keyWord
        }else
        {
            keywordTextField.text = ""
        }
        if searchCondition.districtTitle?.isEmpty == false {
            var regionTitle:String = searchCondition.districtTitle!
            if (searchCondition.districtTitle?.characters.count)! > 3 {
                regionTitle = regionTitle.substring(to: regionTitle.index(regionTitle.startIndex, offsetBy: 4))
            }
        }
        
    }
    
    
    
    //MARK:-------------Action--------
    
    
    
    @objc private func regionButtonAction(sender:UIButton) {
        print("行政区域")
        hotelListHeaderRegionBlock("")
    }
    
    
    
    @objc private func choiceDateButtonAction(sender:UIButton) {
        printDebugLog(message:"choiceDateButtonAction ...")
        var tmp:Dictionary<String,Any> = Dictionary()
        self.hotelListSelctedDateBlock(tmp)
        
    }
    
    //MARK:----------------UITextFieldDelegate--------
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let conditionDic:Dictionary<String,Any> = Dictionary()
        if hotelListHeaderSearchBlock != nil {
            hotelListHeaderSearchBlock(conditionDic)
        }
        return false
    }
    
    func searchBarAction() {
        if keywordTextField.text?.isEmpty == true {
            let conditionDic:Dictionary<String,Any> = Dictionary()
            if hotelListHeaderSearchBlock != nil {
                hotelListHeaderSearchBlock(conditionDic)
            }
        }else {
            if hotelCommonClearLandMarkBlock != nil {
                hotelCommonClearLandMarkBlock()
            }
        }
        
        
    }
    
}
