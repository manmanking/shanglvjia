//
//  HotelListTableViewHeaderView.swift
//  shop
//
//  Created by manman on 2017/4/21.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

let HotelListSelectedCheckinDate = "HotelListSelectedCheckinDate"
let HotelListSelectedCheckoutDate = "HotelListSelectedCheckoutDate"
let HotelListHeaderSearchConditionKeyword = "HotelListHeaderSearchConditionKeyword"

class HotelListTableViewHeaderView: UITableViewHeaderFooterView,UITextFieldDelegate{

    
    typealias HotelListSelctedDateBlock = (Dictionary<String,Any>)->Void
    
    typealias HotelListHeaderSearchBlock = (Dictionary<String,Any>)->Void
    
    typealias HotelListHeaderRegionBlock = (String)->Void
    
    typealias HotelListHeaderRegionRadiusBlock = ()->Void
    
    typealias HotelListHeaderPassengerBlock = (String)->Void
    
    public var hotelListSelctedDateBlock:HotelListSelctedDateBlock!
    public var hotelListHeaderSearchBlock:HotelListHeaderSearchBlock!
    public var hotelListHeaderRegionBlock:HotelListHeaderRegionBlock!
    public var hotelListHeaderRegionRadiusBlock:HotelListHeaderRegionRadiusBlock!
    public var hotelListHeaderPassengerBlock:HotelListHeaderPassengerBlock!
    
    
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
    
    //搜索框  行政区域
    private var subRightBackgroundView = UIView()
    private var regionButton  = UIButton()
    private var regionLabel:UILabel  = UILabel()
    private var regionButtonFlag:UIButton = UIButton()
    //搜索框 的灰色框
    private var subMidBackgroundView = UIView()
    
    private var keywordTextField = UITextField()
    
    private var searchRegionRadiusButton:UIButton = UIButton()
    
    private var searchRegionRadiusButtonTipDefault:String = "搜索范围"
    
    
    
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
            make.right.equalToSuperview().inset(40)
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
            
            make.top.equalToSuperview().offset(2)
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
        
       //
        //subRightBackgroundView.backgroundColor = UIColor.orange
        baseBackgroundView.addSubview(subRightBackgroundView)
        subRightBackgroundView.snp.makeConstraints { (make) in
            
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(10)
            //make.width.equalTo(70)
            make.left.equalTo(subBaseBackgroundView.snp.right).offset(10)
        }
//        regionButton.setTitle("行政区", for: UIControlState.normal)
//        regionButton.titleLabel?.textAlignment = NSTextAlignment.right
//        //regionButton.setImage(UIImage.init(named: "HotelDownSolidTriangle"), for: UIControlState.normal)
//        regionButton.titleLabel?.font = UIFont.systemFont( size: 12)
//        regionButton.setEnlargeEdgeWithTop(0, left: 0, bottom: 0, right: 20)
//        regionButton.setTitleColor(TBIThemePrimaryTextColor, for: UIControlState.normal)
//        regionButton.addTarget(self, action: #selector(regionButtonAction(sender:)), for: UIControlEvents.touchUpInside)
//        subRightBackgroundView.addSubview(regionButton)
//        regionButton.snp.makeConstraints { (make) in
//            make.top.left.bottom.equalToSuperview()
//            make.right.equalToSuperview().inset(18)
//            
//        }
//        let regionButtonFlag:UIImageView = UIImageView()
//        regionButtonFlag.image = UIImage.init(named: "HotelDownSolidTriangle")
//        regionButtonFlag.contentMode = UIViewContentMode.scaleAspectFit
//        subRightBackgroundView.addSubview(regionButtonFlag)
//        regionButtonFlag.snp.makeConstraints { (make) in
//            make.top.bottom.right.equalToSuperview()
//            make.width.equalTo(8)
//        }
//        
        
        
        // second Method
        regionLabel.text = "2人"
        regionLabel.textAlignment = NSTextAlignment.right
        regionLabel.font = UIFont.systemFont( ofSize: 12)
        regionLabel.textColor = TBIThemePrimaryTextColor
        subRightBackgroundView.addSubview(regionLabel)
        regionLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalTo(20)
        }
     
        //选择旅客信息
        regionButtonFlag.setImage(UIImage.init(named: "ic_hotel_customer"), for: UIControlState.normal)
        regionButtonFlag.setEnlargeEdgeWithTop(0, left:0, bottom: 0, right: 50)
        //regionButtonFlag.setTitleColor(TBIThemePrimaryTextColor, for: UIControlState.normal)
        regionButtonFlag.addTarget(self, action: #selector(selectedPassenger(sender:)), for: UIControlEvents.touchUpInside)
        subRightBackgroundView.addSubview(regionButtonFlag)
        regionButtonFlag.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.right.equalTo(regionLabel.snp.left)
//            make.width.equalTo(18)
        }
    
        
        
        searchRegionRadiusButton.setTitle(searchRegionRadiusButtonTipDefault, for: UIControlState.normal)
        searchRegionRadiusButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        searchRegionRadiusButton.setImage(UIImage.init(named: "ic_downTriangle"), for: UIControlState.normal)
        searchRegionRadiusButton.setTitleColor(TBIThemeBlueColor, for: UIControlState.normal)
        searchRegionRadiusButton.addTarget(self, action: #selector(searchRegionRedicAction(sender:)), for: UIControlEvents.touchUpInside)
        subRightBackgroundView.addSubview(searchRegionRadiusButton)
        searchRegionRadiusButton.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        searchRegionRadiusButton.isHidden = true
        adjustButtonImage(sender: searchRegionRadiusButton)
    
        
        //subMidBackgroundView.layer.borderColor = TBIThemeGrayLineColor.cgColor
        //subMidBackgroundView.backgroundColor = UIColor.black
        //subMidBackgroundView.layer.borderWidth = 0.5
        //subMidBackgroundView.layer.cornerRadius = 2
        baseBackgroundView.addSubview(subMidBackgroundView)
        subMidBackgroundView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(10)
            make.left.equalTo(subLeftBackgroundView.snp.right).offset(5)
            make.right.equalTo(subRightBackgroundView.snp.left).inset(-10)
            
        }
        
        keywordTextField.placeholder = "行政区/地标/商圈"//"关键字／酒店名称／位置"
        keywordTextField.delegate = self
        keywordTextField.returnKeyType =  UIReturnKeyType.search
        keywordTextField.font = UIFont.systemFont( ofSize: 13)
        subMidBackgroundView.addSubview(keywordTextField)
        keywordTextField.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalToSuperview()
        }
    
        searchRegionFlagImageView.image = UIImage.init(named: "ic_search")
        searchRegionFlagImageView.contentMode = UIViewContentMode.scaleAspectFit
        subBaseBackgroundView.addSubview(searchRegionFlagImageView)
        searchRegionFlagImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(16)
            make.right.equalToSuperview().offset(-8)
        }
        layoutIfNeeded()
//        let titleFrame = regionButton.titleLabel?.frame
//        let imageFrame = regionButton.imageView?.frame
//        regionButton.imageEdgeInsets = UIEdgeInsetsMake(0,50, 0,-50)
//        regionButton.titleEdgeInsets = UIEdgeInsetsMake(0,-5, 0,5)
    }
    
    public func setViewType(type:HotelListHeaderViewType) {
        
        switch type {
        case .HotelListHeaderView_FormList:
            setUIViewFormListType()
        case .HotelListHeaderView_MapList:
            setUIViewMapListType()
        default:
            setUIViewFormListType()
        }
    }
    
    private func setUIViewMapListType() {
        subBaseBackgroundView.snp.remakeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.right.equalToSuperview().inset(80)
        }
        searchRegionRadiusButton.isHidden = false
        regionButtonFlag.isHidden = true
        regionLabel.isHidden = true
        
        
    }
    
   private func setUIViewFormListType() {
        subBaseBackgroundView.snp.remakeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.right.equalToSuperview().inset(60)
        }
        searchRegionRadiusButton.isHidden = true
        regionButtonFlag.isHidden = false
        regionLabel.isHidden = false
    }
    
    
    private func adjustButtonImage(sender:UIButton) {
        sender.titleLabel?.sizeToFit()
        sender.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -12, bottom: 0, right: 12)
        sender.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: (sender.titleLabel?.bounds.size.width)!, bottom: 0, right: -(sender.titleLabel?.bounds.size.width)!)
    }
    
    
    
    
    public func fillDataSources(searchCondition:HotelListRequest,isMapSearch:Bool = false) {
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
        }else
        {
            keywordTextField.text = ""
        }
        
        regionLabel.text =  searchCondition.parIds.count.description + "人"
        var radiusTitle:String  = searchRegionRadiusButtonTipDefault
        if searchCondition.radiusTitle.isEmpty == false {
            radiusTitle = searchCondition.radiusTitle
        }
            searchRegionRadiusButton.setTitle(radiusTitle, for: UIControlState.normal)
           searchRegionRadiusButton.setImage(UIImage.init(named: "ic_downTriangle"), for: UIControlState.normal)
            adjustButtonImage(sender: searchRegionRadiusButton)
    
            //
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
            
            regionLabel.text = regionTitle
            //regionButton.setTitle(regionTitle, for: UIControlState.normal)
        }else
        {
            regionLabel.text = "2人"
            //regionButton.setTitle("行政区", for: UIControlState.normal)
        }
        
    }
    
    

    //MARK:-------------Action--------
    
    /// 搜索范围
    @objc private func searchRegionRedicAction(sender:UIButton) {
        searchRegionRadiusButton.setImage(UIImage.init(named: "ic_upTriangle"), for: UIControlState.normal)
        if hotelListHeaderRegionRadiusBlock != nil {
            hotelListHeaderRegionRadiusBlock()
        }
    }
    
    
    
    @objc private func regionButtonAction(sender:UIButton) {
        print("行政区域")
        hotelListHeaderRegionBlock("")
    }
    
    
   @objc private func selectedPassenger(sender:UIButton) {
        if hotelListHeaderPassengerBlock != nil {
            hotelListHeaderPassengerBlock("")
        }
    
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
    
    
    enum HotelListHeaderViewType:NSInteger {
        case HotelListHeaderView_FormList = 1
        case HotelListHeaderView_MapList = 2
        case HotelListHeaderView_Default  = 0
    }
    
    
}




