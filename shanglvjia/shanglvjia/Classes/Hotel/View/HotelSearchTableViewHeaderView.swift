//
//  HotelSearchTableViewHeaderView.swift
//  shop
//
//  Created by manman on 2017/4/19.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit


let HotelSearchCityName = "cityName"
let HotelSearchCityId = "cityId"
let HotelSearchCheckinDate = "checkinDate"
let HotelSearchCheckoutDate = "checkoutDate"
let HotelSearchKeyword = "Keyword"
let HotelSearchName = "hotelName"



typealias HotelSearchCompleteBlock = (Dictionary<String,Any>)->Void
typealias HotelCheckInDateBlock = (Dictionary<String,Any>)->Void
typealias HotelSearchCityBlock = (String)->Void
//typealias HotelSearchBlock = (Dictionary<String,Any>)->Void
//typealias HotelSearchBlock = (Dictionary<String,Any>)->Void


class HotelSearchTableViewHeaderView: UITableViewHeaderFooterView,UITextFieldDelegate {
    
    public  var hotelSearchCompleteBlock:HotelSearchCompleteBlock!
    public  var hotelCheckinDateBlock:HotelCheckInDateBlock!
    public  var hotelSearchCityBlock:HotelSearchCityBlock!
    public  var priodInteger:NSInteger = 1
    public  var checkinDate:Date = Date()
    public  var checkoutDate:Date = Date()
    private var baseBackgroundView = UIView()
    private var subBackgroundView = UIView()
    private var cityFieldText = UITextField()
    private var cityId = String()
    private var checkinDateButton = UIButton()
    private var checkinWeekLabel = UILabel()
    private var priodLabel = UILabel()
    private var checkoutDateButton = UIButton()
    private var keywordFieldText = UITextField()
    private var checkoutWeekLabel = UILabel()
    private var searchButton = UIButton()
    
    
    
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setUIViewAutolayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setUIViewAutolayout()
    {
        subBackgroundView.backgroundColor = UIColor.white
        subBackgroundView.layer.cornerRadius = 5
        self.contentView.addSubview(subBackgroundView)
        subBackgroundView.snp.makeConstraints { (make) in
        
            make.top.bottom.equalToSuperview().inset(10)
            make.left.right.equalToSuperview().inset(15)
        }
        
        
        //城市
        //cityFieldText.placeholder = "输入城市"
        cityFieldText.placeholder = NSLocalizedString("hotel.search.home.cityPlaceHolder", comment:"输入城市")
        cityFieldText.delegate = self
        subBackgroundView.addSubview(cityFieldText)
        cityFieldText.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(8)
            make.height.equalTo(40)
            make.left.right.equalToSuperview().inset(15)
        }
        
        
        
        //第一条分割线
        let firstLine = UILabel()
        firstLine.backgroundColor = TBIThemeGrayLineColor
        subBackgroundView.addSubview(firstLine)
        firstLine.snp.makeConstraints { (make) in
            
            make.top.equalTo(cityFieldText.snp.bottom)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(0.5)
            
        }
        
        
        let checkinDateLabel = UILabel()
        //checkinDateLabel.text = "入住时间"
        checkinDateLabel.text = NSLocalizedString("hotel.search.home.checkInDate", comment: "入住时间")
        checkinDateLabel.font = UIFont.systemFont(ofSize: 10)
        checkinDateLabel.textColor = TBIThemePlaceholderTextColor
        subBackgroundView.addSubview(checkinDateLabel)
        checkinDateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(firstLine.snp.bottom).offset(7)
            make.left.equalTo(cityFieldText.snp.left)
            make.height.equalTo(10)
            make.width.equalToSuperview().dividedBy(3)
        }
        
        let checkinTmpDate = dateStringFormat(format: "MM月dd日", date: Date())
        self.checkinDate = Date().startOfDay
        self.checkoutDate = checkinDate.addingTimeInterval(24*60*60)
        
        //self.checkoutDate = self.checkinDate.next
        
        //入住时间Button
        checkinDateButton.setTitle(checkinTmpDate, for: UIControlState.normal)
        checkinDateButton.titleLabel?.adjustsFontSizeToFitWidth = true
        checkinDateButton.titleEdgeInsets = UIEdgeInsetsMake((checkinDateButton.titleLabel?.frame.origin.y)!, -2.6, 0,0)
        checkinDateButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        checkinDateButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        
        
        checkinDateButton.setEnlargeEdgeWithTop(0, left: 0, bottom: 0, right: 50)
        //checkinDateButton.setEnlargeEdge(Top:20, left:20, bottom:20, right:20)
        checkinDateButton.addTarget(self, action: #selector(checkinDateButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        subBackgroundView.addSubview(checkinDateButton)
        checkinDateButton.snp.makeConstraints { (make) in
            make.top.equalTo(checkinDateLabel.snp.bottom).offset(6)
            make.left.equalTo(checkinDateLabel.snp.left)
            make.height.equalTo(16)
            make.width.equalTo(60)
        }
        
        checkinWeekLabel.text = Date().weekdayStringFromDate()
        checkinWeekLabel.font = UIFont.systemFont(ofSize: 10)
        checkinWeekLabel.textColor = TBIThemePlaceholderTextColor
        subBackgroundView.addSubview(checkinWeekLabel)
        checkinWeekLabel.snp.makeConstraints { (make) in
            
            make.height.equalTo(10)
            make.width.equalTo(60)
            make.left.equalTo(checkinDateButton.snp.right).offset(8)
            make.bottom.equalTo(checkinDateButton.snp.bottom).offset(-2)
        }
        
        //预定时长
        priodLabel.text = "  1晚  "
        //priodLabel.text = "1" + NSLocalizedString("hotel.search.home.priod", comment: "晚")
        priodLabel.font = UIFont.systemFont(ofSize: 10)
        priodLabel.textAlignment = NSTextAlignment.center
        priodLabel.textColor = TBIThemePlaceholderTextColor
        subBackgroundView.addSubview(priodLabel)
        priodLabel.snp.makeConstraints { (make) in
            
            make.centerX.equalToSuperview()
            make.width.equalTo(30)
            make.height.equalTo(10)
            make.bottom.equalTo(checkinWeekLabel.snp.bottom)
            
        }
        
        let checkinFlage = UIImageView.init()
        checkinFlage.image = UIImage.init(named: "HotelRightGray")
        subBackgroundView.addSubview(checkinFlage)
        checkinFlage.snp.makeConstraints { (make) in
            
            make.width.equalTo(6)
            make.height.equalTo(8)
//            make.right.equalTo(checkinWeekLabel.snp.right).offset(1)
            make.right.equalTo(priodLabel.snp.left).offset(-4)
            make.bottom.equalTo(checkinWeekLabel.snp.bottom)
            
        }
        
        //MARK:- 第二条分割线 left
        let secondLeftLine = UILabel()
        secondLeftLine.backgroundColor = TBIThemeGrayLineColor
        subBackgroundView.addSubview(secondLeftLine)
        secondLeftLine.snp.makeConstraints { (make) in
            
            make.top.equalTo(checkinDateButton.snp.bottom).offset(7)
            make.left.equalToSuperview().inset(15)
            make.right.equalTo(priodLabel.snp.left).offset(-4)
            make.height.equalTo(0.5)
            
        }
        
        let checkoutDateLabel = UILabel()
        //checkoutDateLabel.text = "离店时间"
        checkoutDateLabel.text = NSLocalizedString("hotel.search.home.checkOutDate", comment: "离店时间")
        checkoutDateLabel.textColor = TBIThemePlaceholderTextColor
        checkoutDateLabel.font = UIFont.systemFont(ofSize: 10)
        subBackgroundView.addSubview(checkoutDateLabel)
        checkoutDateLabel.snp.makeConstraints { (make) in
            
            make.top.equalTo(firstLine.snp.bottom).offset(7)
            make.left.equalTo(priodLabel.snp.right)
            make.height.equalTo(10)
            make.width.equalToSuperview().dividedBy(3)
            
        }
        
        
        let checkoutTmpDate = dateStringFormat(format: "MM月dd日", date: Date().addingTimeInterval(24*60*60))
        
        //离店时间Button
        checkoutDateButton.setTitle(checkoutTmpDate, for: UIControlState.normal)
        checkoutDateButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        checkoutDateButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        checkoutDateButton.titleLabel?.adjustsFontSizeToFitWidth = true
        checkoutDateButton.titleEdgeInsets = UIEdgeInsetsMake((checkinDateButton.titleLabel?.frame.origin.y)!, -2.6, 0,0)
        //checkoutDateButton.setEnlargeEdge(top: 0, left: 0, bottom: 0, right: 50)
        checkoutDateButton.setEnlargeEdgeWithTop(0, left: 0, bottom: 0, right: 50)
        checkoutDateButton.addTarget(self, action: #selector(checkinDateButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        subBackgroundView.addSubview(checkoutDateButton)
        checkoutDateButton.snp.makeConstraints { (make) in
            
            make.top.equalTo(checkoutDateLabel.snp.bottom).offset(6)
            make.left.equalTo(checkoutDateLabel.snp.left)
            make.height.equalTo(16)
            make.width.equalTo(60)
            
        }
        checkoutWeekLabel.text = Date().addingTimeInterval(24*60*60).weekdayStringFromDate()
        checkoutWeekLabel.font = UIFont.systemFont(ofSize: 10)
        checkoutWeekLabel.textColor = TBIThemePlaceholderTextColor
        subBackgroundView.addSubview(checkoutWeekLabel)
        checkoutWeekLabel.snp.makeConstraints { (make) in
            
            make.height.equalTo(10)
            make.width.equalTo(60)
            make.left.equalTo(checkoutDateButton.snp.right).offset(8)
            make.bottom.equalTo(checkoutDateButton.snp.bottom).offset(-2)
            
        }
        
        let checkoutFlage = UIImageView.init()
        checkoutFlage.image = UIImage.init(named: "HotelRightGray")
        subBackgroundView.addSubview(checkoutFlage)
        checkoutFlage.snp.makeConstraints { (make) in
            
            make.width.equalTo(6)
            make.height.equalTo(8)
//            make.left.equalTo(checkoutWeekLabel.snp.right).offset(1)
            make.right.equalToSuperview().inset(15)
            make.bottom.equalTo(checkoutWeekLabel.snp.bottom)
            
        }

        //MARK:- 第二条分割线  right
        let secondLine = UILabel()
        secondLine.backgroundColor = TBIThemeGrayLineColor
        subBackgroundView.addSubview(secondLine)
        secondLine.snp.makeConstraints { (make) in
            
            make.top.equalTo(checkinDateButton.snp.bottom).offset(7)
            make.left.equalTo(checkoutDateLabel.snp.left)
            make.right.equalToSuperview().inset(15)
            make.height.equalTo(0.5)
            
        }
        
        
        //城市
        //keywordFieldText.placeholder = "输入关键字/酒店名/位置"
         keywordFieldText.placeholder = NSLocalizedString("hotel.search.home.keyword", comment:"输入关键字/酒店名/位置")
        keywordFieldText.font = UIFont.systemFont(ofSize: 16)
        subBackgroundView.addSubview(keywordFieldText)
        keywordFieldText.snp.makeConstraints { (make) in
            
            make.top.equalTo(secondLine.snp.bottom).offset(12)
            make.height.equalTo(20)
            make.left.right.equalToSuperview().inset(15)
        }

        //MARK:- 第三条分割线
        let thirdLine = UILabel()
        thirdLine.backgroundColor = TBIThemeGrayLineColor
        subBackgroundView.addSubview(thirdLine)
        thirdLine.snp.makeConstraints { (make) in
            
            make.top.equalTo(keywordFieldText.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(0.5)
            
        }
        
        
        //searchButton.setTitle("查询", for: UIControlState.normal)
        searchButton.setTitle(NSLocalizedString("hotel.search.home.commit", comment:"查询"), for: UIControlState.normal)
        searchButton.layer.cornerRadius = 5
        searchButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        searchButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        searchButton.addTarget(self, action: #selector(searchButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        searchButton.backgroundColor = TBIThemeOrangeColor
        subBackgroundView.addSubview(searchButton)
        searchButton.snp.makeConstraints { (make) in
            
            make.top.equalTo(thirdLine.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(47)
            
        }
        
        
        //layoutIfNeeded()
        //checkinDateButton.setEnlargeEdge(top: 0, left: 0, bottom: 0, right: 50)
    
    
    
    
    
    }
    
    func fillSearchDataSources(hotelSearchItem:HotelSearchForm) {
        print(hotelSearchItem)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateFormatterString = DateFormatter()
        dateFormatterString.dateFormat = "MM月dd日"
        
        //搜索 城市
        if hotelSearchItem.cityName.isEmpty == false {
            cityFieldText.text = hotelSearchItem.cityName
            cityId = hotelSearchItem.cityId
        }
        
        
        //住店时间
        if hotelSearchItem.arrivalDate.isEmpty == false {
            checkinDate = dateFormatter.date(from: hotelSearchItem.arrivalDate)!
            // 转换格式。赋值在button
            //checkinDateButton.titleLabel?.text = dateFormatterString.string(from: checkinDate)
            checkinDateButton.setTitle(dateFormatterString.string(from: checkinDate), for: UIControlState.normal)
            checkinWeekLabel.text = checkinDate.weekdayStringFromDate()
            
        }
        //离店时间
        if hotelSearchItem.departureDate.isEmpty == false {
            checkoutDate = dateFormatter.date(from: hotelSearchItem.departureDate)!
            // 转换格式。赋值在button
            //checkoutDateButton.titleLabel?.text = dateFormatterString.string(from: checkoutDate)
            checkoutDateButton.setTitle(dateFormatterString.string(from: checkoutDate), for: UIControlState.normal)
            checkoutWeekLabel.text = checkoutDate.weekdayStringFromDate()
        }
        
        if hotelSearchItem.keyWord?.isEmpty == false
        {
            keywordFieldText.text = hotelSearchItem.keyWord
        }
        
        
        
       let intervalDay =  self.caculateIntervalDay(fromDate: checkinDate, toDate: checkoutDate)
     
        priodLabel.text = "  " + String(intervalDay) + "晚  "
        
        
        
    }
    
    
    
    
    //MARK:- Action
    
   @objc private func checkinDateButtonAction(sender:UIButton) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone!
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//            let calendarView = TBICalendarViewController()
        var tmpDic:Dictionary<String,Any> = Dictionary()
        tmpDic[HotelSearchCheckinDate] = dateFormatter.string(from: checkinDate.startOfDay)
        tmpDic[HotelSearchCheckoutDate] = dateFormatter.string(from: checkoutDate.startOfDay)
        
        
        
        self.hotelCheckinDateBlock(tmpDic)
    
    }
    
    
    
    @objc private func searchButtonAction(sender:UIButton) {
        
        printDebugLog(message: "searchButtonAction  header view")
        
        if (cityFieldText.text?.isEmpty)! {
            //alertView(title:"提示", info: "请输入将要预定的城市")
             alertView(title:NSLocalizedString("hotel.search.home.alertTitle", comment:"提示"), info: NSLocalizedString("hotel.search.home.alertMessage", comment: "请输入将要预定的城市"))
            return
        }
        
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone!
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        
        var tmpDic:Dictionary<String,Any> = Dictionary()
        if cityFieldText.text?.isEmpty == false {
            tmpDic[HotelSearchCityName] = cityFieldText.text?.description
            tmpDic[HotelSearchCityId] =  cityId
        }
        if checkinDateButton.titleLabel?.text?.isEmpty == false
        {
            tmpDic[HotelSearchCheckinDate] = dateFormatter.string(from:checkinDate)//checkinDateButton.titleLabel?.text?.description
        }
        if checkoutDateButton.titleLabel?.text?.isEmpty == false
        {
            tmpDic[HotelSearchCheckoutDate] = dateFormatter.string(from:checkoutDate)//checkoutDateButton.titleLabel?.text?.description
        }
        if keywordFieldText.text?.isEmpty == false
        {
            tmpDic[HotelSearchKeyword] = keywordFieldText.text?.description
        }
        
        self.hotelSearchCompleteBlock(tmpDic)
    }
    
    
    private func caculateIntervalDay(fromDate:Date,toDate:Date) -> NSInteger {
        
        let calendar = NSCalendar.init(identifier: NSCalendar.Identifier.gregorian)
        let result = calendar?.components(NSCalendar.Unit.day, from: fromDate, to: toDate, options: NSCalendar.Options.matchFirst)
        
        return (result?.day)!
    }
    
    
    
    
    private func dateStringFormat(format:String,date:Date) -> String {
        let dateFormatterString = DateFormatter()
        dateFormatterString.dateFormat = format
        return dateFormatterString.string(from: date)
    }
    
    //MARK:- UITextFieldDelegate 
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        NSLog("输入城市 ...");
        textField.resignFirstResponder()
        
        self.hotelSearchCityBlock("")
        
    }
    
    func alertView(title:String,info:String) {
        //let alertView = UIAlertView.init(title: title, message: info, delegate: nil, cancelButtonTitle: "确定")
         let alertView = UIAlertView.init(title: title, message: info, delegate: nil, cancelButtonTitle:NSLocalizedString("hotel.search.home.alertAction", comment: "确定"))
        alertView.show()
    }
    
    
    
    
    

}
