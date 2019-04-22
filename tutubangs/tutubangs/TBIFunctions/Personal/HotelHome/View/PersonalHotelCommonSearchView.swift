//
//  PersonalHotelCommonView.swift
//  shanglvjia
//
//  Created by tbi on 2018/8/1.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PersonalHotelCommonSearchView: UIView,UITextFieldDelegate{
    
    typealias HotelCommonSearchCompleteBlock = (Dictionary<String,Any>)->Void
    typealias HotelCommonCheckInDateBlock = (Dictionary<String,Any>)->Void
    typealias HotelCommonSearchCityBlock = (String)->Void
    typealias HotelCommonChoicesLandMark = ()->Void
    typealias HotelCommonCurrentLocationBlock = ()->Void
    typealias HotelCommonClearLandMarkBlock = ()->Void
    
    public  var hotelCommonSearchCompleteBlock:HotelCommonSearchCompleteBlock!
    public  var hotelCommonCheckinDateBlock:HotelCommonCheckInDateBlock!
    public  var hotelCommonSearchCityBlock:HotelCommonSearchCityBlock!
    public  var hotelCommonChoicesLandMark:HotelCommonChoicesLandMark!
    public  var hotelCommonCurrentLocationBlock:HotelCommonCurrentLocationBlock!
    public  var hotelCommonClearLandMarkBlock:HotelCommonClearLandMarkBlock!
    

//   public var hotelSVSearchViewType:HotelSVSearchViewType = HotelSVSearchViewType.Default
    /// 基础背景  容器
    private let baseBackgroundView:UIView = UIView()
    
    /// 子基础 背景  容器
    private let subBaseBackgroundView:UIView = UIView()
    
    private var cityId:String = String()
    
    /// 城市 背景 容器
    private let cityBaseBackgroundView:UIView = UIView()
    
    /// 城市
    private var cityFieldText:UITextField = UITextField()
    private var cityLabel:UILabel = UILabel()
    
    /// 当前城市
    private var currentCityView:UIView = UIView()
    private var currentCityLabel:UILabel = UILabel()
    private var currentCityImageView:UIImageView = UIImageView()
    
    private let cityTipDefault:String = "输入城市"
  
    /// 地标商圈
    private let choiceLankMarkTipDefault:String = "行政区/地标/商圈"
    
    
    /// 酒店 背景 容器
    private let hotelNameBaseBackgroundView:UIView = UIView()
    
    /// 酒店名称
    var hotelNameFieldText:UITextField = UITextField()
    
    private let hotelNameTipDefault:String = "酒店名字"
    
    /// 日期 背景 容器
    private let dateBaseBackgroundView:UIView = UIView()
    
    /// 入住时间
    public  var checkinDate:Date = Date()
    
    /// 离店时间
    public  var checkoutDate:Date = Date()
    
    /// 入住时间 label
    private var checkinDateTitleLabel:UILabel = UILabel()
    
    /// 入住时间 label
    private var checkinDateLabel:UILabel = UILabel()
    
    /// 入住时间 周值
    private var checkinWeekLabel:UILabel = UILabel()
    
    /// 入住时长
    private var priodLabel:UILabel = UILabel()
    
    /// 离店时间 label
    private var checkoutDateLabel:UILabel = UILabel()
    
    /// 离店时间 label
    private var checkoutDateTitleLabel:UILabel = UILabel()
    
    /// 离店时间 周值
    private var checkoutWeekLabel:UILabel = UILabel()
    
    /// 关键字 背景 容器
    private let searchKeywordBaseBackgroundView:UIView = UIView()
    
    /// 搜索关键字
    public var keywordFieldText:UITextField = UITextField()
    public var landMarkLabel:UILabel = UILabel()
    
    private var clearLandMarkButton:UIButton = UIButton()
    
    
    /// 搜索 按钮
    private var searchButton:UIButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        setUIViewAutolayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setUIViewAutolayout()
    {
        subBaseBackgroundView.backgroundColor = UIColor.white
        baseBackgroundView.addSubview(subBaseBackgroundView)
        subBaseBackgroundView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        // 城市布局
        subBaseBackgroundView.addSubview(cityBaseBackgroundView)
        cityBaseBackgroundView.snp.remakeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(55)
        }
        setCityBackgroundViewAutolayout()
        // 日期布局
        subBaseBackgroundView.addSubview(dateBaseBackgroundView)
        dateBaseBackgroundView.snp.remakeConstraints { (make) in
            make.top.equalTo(cityBaseBackgroundView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(55)
        }
        setDateBackgroundViewAutolayout()
        // 酒店名称 布局
        subBaseBackgroundView.addSubview(hotelNameBaseBackgroundView)
        hotelNameBaseBackgroundView.snp.makeConstraints { (make) in
            make.top.equalTo(dateBaseBackgroundView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(55)
        }
        setHotelNameViewAutolayout()
        // 行政区 商圈 地标
        subBaseBackgroundView.addSubview(searchKeywordBaseBackgroundView)
        searchKeywordBaseBackgroundView.snp.remakeConstraints { (make) in
            make.top.equalTo(hotelNameBaseBackgroundView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(55)
        }
        setSearchKeywordViewAutolayout()
        ///查询
        searchButton.setTitle("查询", for: UIControlState.normal)
        searchButton.layer.cornerRadius = 5
        searchButton.clipsToBounds=true
        searchButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        searchButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        searchButton.addTarget(self, action: #selector(searchButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        searchButton.setBackgroundImage(UIImage (named: "yellow_btn_gradient"), for: UIControlState.normal)
        subBaseBackgroundView.addSubview(searchButton)
        searchButton.snp.makeConstraints { (make) in
            make.top.equalTo(searchKeywordBaseBackgroundView.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(47)
        }
    }
    
    /// 城市布局
    private func setCityBackgroundViewAutolayout() {
        //城市
        cityBaseBackgroundView.backgroundColor = TBIThemeWhite
        
        cityLabel.text = cityTipDefault
        cityLabel.addOnClickListener(target: self, action: #selector(cityAction))
        cityLabel.textColor = TBIThemePlaceholderColor
        cityLabel.font = UIFont.systemFont( ofSize: 16)
        cityBaseBackgroundView.addSubview(cityLabel)
        cityLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(15)
            make.right.equalToSuperview().inset(100)
        }
        // start of line
        
        currentCityView.backgroundColor = TBIThemeWhite
        currentCityView.addOnClickListener(target: self, action: #selector(getCurrentLocaltion))
        cityBaseBackgroundView.addSubview(currentCityView)
        currentCityView.snp.makeConstraints { (make) in
            make.centerY.equalTo(cityLabel)
            make.right.equalToSuperview().inset(15)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        
        currentCityLabel.text = "当前城市"
        currentCityLabel.font = UIFont.systemFont(ofSize: 9)
        currentCityLabel.textAlignment = NSTextAlignment.center
        currentCityLabel.textColor = PersonalThemeDarkColor
        currentCityView.addSubview(currentCityLabel)
        currentCityLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-2)
            make.height.equalTo(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }
        currentCityImageView.image = UIImage.init(named: "personal_ic_hotel_locate")
        currentCityView.addSubview(currentCityImageView)
        currentCityImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(2)
            make.width.height.equalTo(20)
            make.centerX.equalToSuperview()
        }
        //end of line
        
        
        //第一条分割线  临时添加
        let firstTmpLine = UILabel()
        firstTmpLine.backgroundColor = TBIThemeGrayLineColor
        cityBaseBackgroundView.addSubview(firstTmpLine)
        firstTmpLine.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(1)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(0.5)
        }
    }
    /// 时间布局
    private func setDateBackgroundViewAutolayout() {
        dateBaseBackgroundView.backgroundColor = TBIThemeWhite
        checkinDateTitleLabel.text = "入住"
        checkinDateTitleLabel.font = UIFont.systemFont(ofSize: 10)
        checkinDateTitleLabel.textColor = TBIThemePlaceholderTextColor
        dateBaseBackgroundView.addSubview(checkinDateTitleLabel)
        checkinDateTitleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview().inset(15)
            make.height.equalTo(10)
            make.width.equalTo(60)
        }
        let checkinTmpDate = dateStringFormat(format: "MM-dd", date: Date())
        self.checkinDate = Date().startOfDay
        self.checkoutDate = checkinDate.addingTimeInterval(24*60*60)
        //入住时间Button
        checkinDateLabel.text = checkinTmpDate
        checkinDateLabel.font = UIFont.systemFont(ofSize: 16)
        checkinDateLabel.textColor = PersonalThemeMajorTextColor
        checkinDateLabel.addOnClickListener(target: self, action: #selector(checkinDateButtonAction))
        dateBaseBackgroundView.addSubview(checkinDateLabel)
        checkinDateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(checkinDateTitleLabel.snp.bottom).offset(4)
            make.left.equalTo(checkinDateTitleLabel.snp.left)
            make.height.equalTo(16)
        }
        
        checkinWeekLabel.text = Date().weekdayStringFromDate()
        checkinWeekLabel.font = UIFont.systemFont(ofSize: 10)
        checkinWeekLabel.textColor = PersonalThemeMajorTextColor
        dateBaseBackgroundView.addSubview(checkinWeekLabel)
        checkinWeekLabel.snp.makeConstraints { (make) in
            make.left.equalTo(checkinDateLabel.snp.right).offset(8)
            make.bottom.equalTo(checkinDateLabel.snp.bottom).offset(-2)
            make.height.equalTo(10)
        }
        
        //预定时长
        priodLabel.text = " 1晚 "
        priodLabel.textAlignment = NSTextAlignment.center
        priodLabel.font = UIFont.systemFont(ofSize: 12)
        priodLabel.textColor = TBIThemeWhite
        priodLabel.backgroundColor = PersonalThemeNormalColor
        priodLabel.layer.cornerRadius = 9
        priodLabel.clipsToBounds = true
        dateBaseBackgroundView.addSubview(priodLabel)
        priodLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(18)
        }
        
        //分割线 left
        let firstLine = UILabel()
        firstLine.backgroundColor = TBIThemeGrayLineColor
        dateBaseBackgroundView.addSubview(firstLine)
        firstLine.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(1)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(0.5)
        }
        
        checkoutDateTitleLabel.text = "退房"
        checkoutDateTitleLabel.textColor = TBIThemePlaceholderTextColor
        checkoutDateTitleLabel.font = UIFont.systemFont(ofSize: 10)
        checkoutDateTitleLabel.textAlignment = NSTextAlignment.right
        dateBaseBackgroundView.addSubview(checkoutDateTitleLabel)
        checkoutDateTitleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(12)
            make.right.equalToSuperview().inset(15)
            make.height.equalTo(10)
            make.width.equalTo(60)
        }
        
        let checkoutTmpDate = dateStringFormat(format: "MM-dd", date: Date().addingTimeInterval(24*60*60))
        //离店时间Button
        checkoutDateLabel.text = checkoutTmpDate
        checkoutDateLabel.font = UIFont.systemFont(ofSize: 16)
        checkoutDateLabel.textColor = PersonalThemeMajorTextColor
        checkoutDateLabel.addOnClickListener(target: self, action: #selector(checkinDateButtonAction))
        dateBaseBackgroundView.addSubview(checkoutDateLabel)
        checkoutDateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(checkoutDateTitleLabel.snp.bottom).offset(4)
            make.right.equalToSuperview().inset(15)
            make.height.equalTo(16)
        }
        
        checkoutWeekLabel.text = Date().addingTimeInterval(24*60*60).weekdayStringFromDate()
        checkoutWeekLabel.font = UIFont.systemFont(ofSize: 10)
        checkoutWeekLabel.textColor = PersonalThemeMajorTextColor
        checkoutWeekLabel.adjustsFontSizeToFitWidth = true
        dateBaseBackgroundView.addSubview(checkoutWeekLabel)
        checkoutWeekLabel.snp.makeConstraints { (make) in
            make.top.equalTo(checkoutDateTitleLabel.snp.bottom).offset(9)
            make.right.equalTo(checkoutDateLabel.snp.left).offset(-8)
            make.height.equalTo(10)
        }
    }
    
    func setHotelNameViewAutolayout(){
        
        // 酒店名称 试图
        hotelNameBaseBackgroundView.backgroundColor = TBIThemeWhite
        
        hotelNameFieldText.placeholder = hotelNameTipDefault
        hotelNameFieldText.delegate = self
        hotelNameFieldText.font = UIFont.systemFont(ofSize: 16)
        hotelNameBaseBackgroundView.addSubview(hotelNameFieldText)
        hotelNameFieldText.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(15)
            
        }
        //第一条分割线
        let firstLine = UILabel()
        firstLine.backgroundColor = TBIThemeGrayLineColor
        hotelNameBaseBackgroundView.addSubview(firstLine)
        firstLine.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(1)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(0.5)
        }
        
    }
    /// 行政区/地标/商圈 布局
    private func setSearchKeywordViewAutolayout() {
        searchKeywordBaseBackgroundView.backgroundColor = TBIThemeWhite
    
        landMarkLabel.text = choiceLankMarkTipDefault
        landMarkLabel.textColor = TBIThemePlaceholderTextColor
        landMarkLabel.addOnClickListener(target: self, action: #selector(getLandMark))
        landMarkLabel.font = UIFont.systemFont(ofSize: 16)
        searchKeywordBaseBackgroundView.addSubview(landMarkLabel)
        landMarkLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(15)
            make.right.equalToSuperview().inset(100)
        }
        
        clearLandMarkButton.addTarget(self, action: #selector(clearLandMarkDataButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        clearLandMarkButton.setImage(UIImage.init(named: "ic_clear"), for: UIControlState.normal)
        searchKeywordBaseBackgroundView.addSubview(clearLandMarkButton)
        clearLandMarkButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(landMarkLabel)
            make.width.height.equalTo(12)
            make.right.equalToSuperview().inset(15)
        }
        
        
        let firstLine:UILabel = UILabel()
        firstLine.backgroundColor = TBIThemeGrayLineColor
        searchKeywordBaseBackgroundView.addSubview(firstLine)
        firstLine.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(1)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(0.5)
        }
    }
    private func dateStringFormat(format:String,date:Date) -> String {
        let dateFormatterString = DateFormatter()
        dateFormatterString.dateFormat = format
        return dateFormatterString.string(from: date)
    }
    //MARK:---------------- fillDataSources
    
    public func fillSearchDataSources(hotelSearchItem:PersonalNormalHotelListRequest) {
        if DEBUG { print(hotelSearchItem) }
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone?
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateFormatterString = DateFormatter()
        dateFormatterString.dateFormat = "MM月dd日"
        if hotelSearchItem.cityName.isEmpty == false {
            //cityFieldText.text = hotelSearchItem.cityName
            cityLabel.text = hotelSearchItem.cityName
            cityLabel.textColor = TBIThemePrimaryTextColor
            cityId = hotelSearchItem.cityId
        }else
        {
            cityLabel.text = cityTipDefault
            cityLabel.textColor = TBIThemePlaceholderColor
            
        }
        if hotelSearchItem.searchRegion.isEmpty == false {
            landMarkLabel.text = hotelSearchItem.searchRegion
            landMarkLabel.textColor = TBIThemePrimaryTextColor
            //keywordFieldText.text = hotelSearchItem.searchRegion
        }else
        {
            landMarkLabel.text = choiceLankMarkTipDefault
            landMarkLabel.textColor = TBIThemePlaceholderTextColor
        }
       
        
        if hotelSearchItem.arrivalDate.isEmpty == false {
            checkinDate = dateFormatter.date(from: hotelSearchItem.arrivalDateFormat)!
            checkinDateLabel.text = dateFormatterString.string(from: checkinDate)
            checkinWeekLabel.text = checkinDate.weekdayStringFromDate()
        }
        
        if hotelSearchItem.departureDate.isEmpty == false {
            checkoutDate = dateFormatter.date(from: hotelSearchItem.departureDateFormat)!
            // 转换格式。赋值在button //这种写法在ios8中会不赋值
            checkoutDateLabel.text = dateFormatterString.string(from: checkoutDate)
            checkoutWeekLabel.text = checkoutDate.weekdayStringFromDate()
        }
        if hotelSearchItem.keyword.isEmpty == false {
            hotelNameFieldText.text = hotelSearchItem.keyword
        }else{
            hotelNameFieldText.text = ""
        }
        
        let intervalDay =  self.caculateIntervalDay(fromDate: checkinDate, toDate: checkoutDate)
        priodLabel.text =  "" + String(intervalDay) + "晚    "
    }
    
    private func caculateIntervalDay(fromDate:Date,toDate:Date) -> NSInteger {
        
        let calendar = NSCalendar.init(identifier: NSCalendar.Identifier.gregorian)
        let result = calendar?.components(NSCalendar.Unit.day, from: fromDate, to: toDate, options: NSCalendar.Options.matchFirst)
        
        return (result?.day)!
    }
    
    
    
    //MARK:-------Alert------
    private  func alertView(title:String,info:String) {
        let alertView = UIAlertView.init(title: title, message: info, delegate: nil, cancelButtonTitle: "确定")
        alertView.show()
    }
    
    //MARK:------------------------------ UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == keywordFieldText {
            textField.resignFirstResponder()
            if hotelCommonChoicesLandMark != nil {
                hotelCommonChoicesLandMark()
            }
            return
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == hotelNameFieldText {
            textField.resignFirstResponder()
            let searchCondition = PersonalHotelManager.shareInstance.searchConditionUserDraw()
            searchCondition.keyword = textField.text ?? ""
            PersonalHotelManager.shareInstance.searchConditionUserStore(searchCondition: searchCondition)
            return
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == hotelNameFieldText {
            textField.resignFirstResponder()
            let searchCondition = PersonalHotelManager.shareInstance.searchConditionUserDraw()
            searchCondition.keyword = textField.text ?? ""
            PersonalHotelManager.shareInstance.searchConditionUserStore(searchCondition: searchCondition)
            return true
        }
        if textField == keywordFieldText {
            textField.resignFirstResponder()
            if hotelCommonChoicesLandMark != nil {
                hotelCommonChoicesLandMark()
            }
            return true
        }
        return true
    }
   
    
    //MARK:------------------- Action 日期选择---------------
    func cityAction() {
        if hotelCommonSearchCityBlock != nil {
            self.hotelCommonSearchCityBlock("")
        }
    }
    
    
    func getCurrentLocaltion() {
        printDebugLog(message: "当前城市")
        if hotelCommonCurrentLocationBlock != nil {
            hotelCommonCurrentLocationBlock()
        }
    }
    
    func getLandMark() {
        printDebugLog(message: "当前城市")
        if hotelCommonChoicesLandMark != nil {
            hotelCommonChoicesLandMark()
        }
    }
    
    func clearLandMarkDataButtonAction(sender:UIButton) {
        
        if hotelCommonClearLandMarkBlock != nil {
            
            hotelCommonClearLandMarkBlock()
        }
        
    }
    
    
    
    
    @objc public func checkinDateButtonAction() {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone!
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //            let calendarView = TBICalendarViewController()
        var tmpDic:Dictionary<String,Any> = Dictionary()
        tmpDic[HotelSearchCheckinDate] = dateFormatter.string(from: checkinDate.startOfDay)
        tmpDic[HotelSearchCheckoutDate] = dateFormatter.string(from: checkoutDate.startOfDay)
        if  hotelCommonCheckinDateBlock != nil{
            self.hotelCommonCheckinDateBlock(tmpDic)
        }
        
    }
    // ---搜索
    func searchButtonAction(sender:UIButton) {
        printDebugLog(message: "searchButtonAction  header view")
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone!
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if cityLabel.text == cityTipDefault || cityLabel.text?.contains("定位") == true {
            
            self.alertView(title:"提示", info: "请输入将要预订的城市")
            return
        }
        var tmpDic:Dictionary<String,Any> = Dictionary()
        if cityLabel.text?.isEmpty == false {
            tmpDic[HotelSearchCityName] = cityLabel.text
            tmpDic[HotelSearchCityId] =  cityId
        }
        if checkinDateLabel.text?.isEmpty == false
        {
            tmpDic[HotelSearchCheckinDate] = dateFormatter.string(from:checkinDate)//checkinDateButton.titleLabel?.text?.description
        }
        if checkoutDateLabel.text?.isEmpty == false
        {
            tmpDic[HotelSearchCheckoutDate] = dateFormatter.string(from:checkoutDate)//checkoutDateButton.titleLabel?.text?.description
        }
        if keywordFieldText.text?.isEmpty == false
        {
            tmpDic[HotelSearchKeyword] = keywordFieldText.text?.description
        }
        if hotelCommonSearchCompleteBlock != nil {
            self.hotelCommonSearchCompleteBlock(tmpDic)
        }
        
    }
    
}

