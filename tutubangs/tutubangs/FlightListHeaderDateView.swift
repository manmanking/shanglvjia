//
//  FlightListHeaderDateView.swift
//  shanglvjia
//
//  Created by manman on 2018/3/23.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import SwiftDate

class FlightListHeaderDateView: UIView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
   
    typealias FlightListHeaderDateViewSelectedDateBlock  = (NSInteger)->Void
    
    public var headerDateShowType:AppModelCatoryENUM = AppModelCatoryENUM.Default
    
    public var flightListHeaderDateViewSelectedDateBlock:FlightListHeaderDateViewSelectedDateBlock!

    public var headerDateType:ListHeaderDateType = ListHeaderDateType.Default
    
    private var startDate:Date = Date()
    
    private let currentDate:Date = Date()
    
    private var selectedDateLocal:Date = Date()
    
    private var selectedIndex:NSInteger = 0
    
    private let calendarWidth:CGFloat = 50
    
    private let bottomMargin:CGFloat = 2
    
    private var continuanceDateArr:[String] = Array()
    
    private var discontinuanceDateArr:[String] = Array()
    
    private let calanderCollectionCellIdentify:String = "CalanderCollectionCell"
    
    private let baseBackgroundView:UIView = UIView()
    
    private var dateCollectionView:UICollectionView?
    
    private let calendarButton:UIButton = UIButton()
    
    private let bottomLine:UILabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        baseBackgroundView.backgroundColor = TBIThemeWhite
        self.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        setUIViewAutolayout()
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUIViewAutolayout() {
        let flowLayout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        
        flowLayout.itemSize = CGSize.init(width: 47, height: 55)
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        dateCollectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWindowWidth, height: 55), collectionViewLayout: flowLayout)
        dateCollectionView?.collectionViewLayout = flowLayout
        dateCollectionView?.backgroundColor = TBIThemeWhite
        dateCollectionView?.bounces = false
        dateCollectionView?.delegate = self
        dateCollectionView?.dataSource = self
        dateCollectionView?.showsHorizontalScrollIndicator = false
        dateCollectionView?.register(CalanderCollectionCell.classForCoder(), forCellWithReuseIdentifier:calanderCollectionCellIdentify)
        baseBackgroundView.addSubview(dateCollectionView!)
        dateCollectionView?.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
//        calendarButton.setTitle("低价\n日历", for: UIControlState.normal)
//        calendarButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
//        calendarButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
//        calendarButton.setTitleColor(TBIThemeDarkBlueColor, for: UIControlState.normal)
//        calendarButton.addTarget(self, action: #selector(calendarAction), for: UIControlEvents.touchUpInside)
//        baseBackgroundView.addSubview(calendarButton)
//        calendarButton.snp.makeConstraints { (make) in
//            make.top.right.equalToSuperview()
//            make.bottom.equalToSuperview().inset(bottomMargin)
//            make.width.equalTo(calendarWidth)
//        }
        
       
        switch headerDateShowType {
        case .PersonalFlight:
            bottomLine.backgroundColor = PersonalThemeDarkColor
        default:
            bottomLine.backgroundColor = TBIThemeDarkBlueColor
        }
        
        baseBackgroundView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(bottomMargin)
            make.bottom.equalToSuperview()
        }
        
    }
    
    public func  fillDataSources(date:Date) {
        
        selectedDateLocal = date
        dateCollectionView?.reloadData()
        setbottomLineColor()
        caculateItemNum()
        let scrollToItemIndexPath:IndexPath = IndexPath.init(row: selectedIndex, section: 0)
        dateCollectionView?.scrollToItem(at:scrollToItemIndexPath, at: UICollectionViewScrollPosition.left, animated: true)
        
        
    }
    
    
    func caculateSelectedIndex() {
        
    }
    
    func fillDataSourcesContinuanceDate(fromDate:String,toDate:String,selectedDate:String) {
        continuanceDateArr = [fromDate,toDate]
        //selectedDateLocal = selectedDate
        dateCollectionView?.reloadData()
        caculateItemNum()
        setbottomLineColor()
        let scrollToItemIndexPath:IndexPath = IndexPath.init(row: selectedIndex, section: 0)
        dateCollectionView?.scrollToItem(at:scrollToItemIndexPath, at: UICollectionViewScrollPosition.left, animated: true)
    }
    
    func fillDataSourcesDiscontinuanceDate(showDate:[String],selectedDate:String) {
        var showDateCopy = showDate
        if showDate.count == 0 {
            showDateCopy = [Date().string(custom: "YYYY-MM-dd")]
        }
        discontinuanceDateArr = showDateCopy
        selectedDateLocal = selectedDate.stringToDate(dateFormat: "YYYY-MM-dd")
        dateCollectionView?.reloadData()
        setbottomLineColor()
//        for (index,element) in showDate.enumerated() {
//            if element == selectedDate {
//                selectedIndex = index
//                break
//            }
//        }
        
//        let scrollToItemIndexPath:IndexPath = IndexPath.init(row: selectedIndex, section: 0)
//        dateCollectionView?.scrollToItem(at:scrollToItemIndexPath, at: UICollectionViewScrollPosition.left, animated: true)
    }
    
    func setbottomLineColor() {
        switch headerDateShowType {
        case .PersonalFlight:
            bottomLine.backgroundColor = PersonalThemeDarkColor
        default:
            bottomLine.backgroundColor = TBIThemeDarkBlueColor
        }
    }
    
    
    
  
        //MARK:------------UICollectionViewDataSource------------
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            //caculateItemNum()
          return caculateItemNum()
            
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell:CalanderCollectionCell =  collectionView.dequeueReusableCell(withReuseIdentifier: calanderCollectionCellIdentify, for: indexPath) as! FlightListHeaderDateView.CalanderCollectionCell
            var selected:Bool = false
            let showDate:Date = configCellShowDate(index: indexPath)
//            //选中的当月 则向后延30天
//            if startDate.month == currentDate.month {
//                showDate = showDate + indexPath.row.day
//            }else if startDate.month > Date().month
//            {
//                let formatter = DateFormatter()
//                formatter.dateFormat = "YYYY-MM-dd hh:mm:ss"
//
//                showDate =  formatter.date(from:startDate.year.description + startDate.month.description + indexPath.row.description + "00:00:00")!
//
//            }
            if selectedIndex == indexPath.row {
                selected = true
            }
            
            cell.fillDataSources(date: showDate, price: indexPath.row.description, selected: selected, type: headerDateShowType)
            
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
            selectedIndex = indexPath.row
            didSelectedDate(index: indexPath)
        }
    
    
    //MARK:-------Cell -------
    
    /// 计算日期个数
    func caculateItemNum() -> NSInteger {
        switch headerDateType {
        case .DateContinuance:
            return caculateDateContinuanceNum()
        case .DateDiscontinuous:
            return caculateDateDiscontinuanceNum()
        case .Default:
            return caculateDateDefaultNum()
        default:break
            
        }
    }
    
    
    
    func caculateDateDefaultNum() -> NSInteger {
        
        let intervalDay:NSInteger =  caculateDateInterval(fromDate: currentDate, toDate:selectedDateLocal)
        if intervalDay == 0 {
            selectedIndex = 0
            return 30
        }
        if intervalDay >= 30 {
            startDate = selectedDateLocal - 30.day
            selectedIndex = 30
            return 60
        }else {
            startDate = currentDate
            selectedIndex = intervalDay
            return intervalDay + 30
        }
    }
    
    func caculateDateContinuanceNum() -> NSInteger {
        guard continuanceDateArr.count > 0 else {
            return 0
        }
        let startContinuaceDate:Date = (continuanceDateArr.first?.stringToDate(dateFormat: "YYYY-MM-dd"))!
        let endContinuaceDate:Date = (continuanceDateArr.last?.stringToDate(dateFormat: "YYYY-MM-dd"))!
        
        return caculateNumRow(fromDate: startContinuaceDate, toDate: endContinuaceDate)

    }
    
    func caculateNumRow(fromDate:Date,toDate:Date) -> NSInteger {
        
        var currentCalendar = Calendar.current
        currentCalendar.timeZone = NSTimeZone.local
        let component:DateComponents = currentCalendar.dateComponents([Calendar.Component.day], from: fromDate, to: toDate)
//            currentCalendar.component(Calendar.Component.day, from: fromDate)
//        let numDays:NSInteger = currentCalendar.date(byAdding: component, to: toDate)
        return component.day! + 1
//
//        NSDateComponents *comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute
//            11                                           fromDate:latterDate];
//        12
//        13     [comps setYear:years];
//            [comps setMonth:months];
//            [comps setDay:days];
//
//     return [calendar dateByAddingComponents:comps toDate:latterDate options:0];
        
        
        
    }
    
    
    
    func caculateDateDiscontinuanceNum() -> NSInteger {
        return discontinuanceDateArr.count
    }
    
    
    /// 计算 show Date
    func configCellShowDate(index:IndexPath)->Date {
        switch headerDateType {
        case .DateContinuance:
            return configCellShowDateContinuance(index: index)
        case .DateDiscontinuous:
            return configCellShowDateDiscontinuous(index: index)
        case .Default:
            return configCellShowDateDefault(index: index)
        default: break
            
        }
    }
    
    func configCellShowDateDefault(index:IndexPath) -> Date {
        
        let showDate:Date = startDate + index.row.day
        return showDate
    }
    
    func configCellShowDateContinuance(index:IndexPath) -> Date {
        let startContinuaceDate:Date = (continuanceDateArr.first?.stringToDate(dateFormat: "YYYY-MM-dd"))!
        //let endContinuaceDate:Date = (continuanceDateArr.last?.stringToDate(dateFormat: "YYYY-MM-dd"))!
        
        return startContinuaceDate + index.row.day
        //caculateNumRow(fromDate: startContinuaceDate, toDate: endContinuaceDate)
    }
    
    func configCellShowDateDiscontinuous(index:IndexPath) -> Date {
        guard discontinuanceDateArr.count > index.row else {
            return Date()
        }
        return discontinuanceDateArr[index.row].stringToDate(dateFormat: "YYYY-MM-dd")
    }
    
    
    func didSelectedDate(index:IndexPath) {
        switch headerDateType {
        case .DateContinuance:
            return didSelectedDateContinuance(index: index)
        case .DateDiscontinuous:
            return didSelectedDateDiscontinuous(index: index)
        case .Default:
            return didSelectedDateDefault(index: index)
        default: break
            
        }
    }
    func didSelectedDateDefault(index:IndexPath) {
        dateCollectionView?.reloadData()
        let selectedDateTimeInterval:NSInteger = NSInteger((startDate + index.row.day).timeIntervalSince1970)
        selectedDateLocal = startDate + index.row.day
        if flightListHeaderDateViewSelectedDateBlock != nil {
            flightListHeaderDateViewSelectedDateBlock(selectedDateTimeInterval)
        }
    }
    func didSelectedDateContinuance(index:IndexPath) {
        dateCollectionView?.reloadData()
        let startContinuaceDate:Date = (continuanceDateArr.first?.stringToDate(dateFormat: "YYYY-MM-dd"))!
        let selectedDateTimeInterval:NSInteger = NSNumber.init(value:(startContinuaceDate + index.row.day).timeIntervalSince1970).intValue
        selectedDateLocal = startContinuaceDate + index.row.day
        if flightListHeaderDateViewSelectedDateBlock != nil {
            flightListHeaderDateViewSelectedDateBlock(selectedDateTimeInterval)
        }
        
    }
    func didSelectedDateDiscontinuous(index:IndexPath) {
        dateCollectionView?.reloadData()
        let selectedDateTimeInterval:NSInteger = NSInteger(discontinuanceDateArr[index.row]
            .stringToDate(dateFormat: "YYYY-MM-dd").timeIntervalSince1970)
        selectedDateLocal = startDate + index.row.day
        if flightListHeaderDateViewSelectedDateBlock != nil {
            flightListHeaderDateViewSelectedDateBlock(selectedDateTimeInterval)
        }
        
    }
    
    
    
    
    
    
    
    

    /// 计算相隔多少天
    func caculateDateInterval(fromDate:Date ,toDate:Date) -> NSInteger  {
        let gregorian = Calendar.current
        let componentDay =  gregorian.dateComponents([.day], from: fromDate.startOfDay, to:toDate.endOfDay)
        return componentDay.day ?? 0
    }
    
    
    
    
    
    
    
    class CalanderCollectionCell: UICollectionViewCell {
        
        private let baseBackgroundView:UIView = UIView()
        
        private let weekTitleLabel:UILabel = UILabel()
        
        private let dateTitleLabel:UILabel = UILabel()
        
        private let priceTitleLabel:UILabel = UILabel()
        
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.contentView.backgroundColor = TBIThemeWhite
            self.contentView.addSubview(baseBackgroundView)
            baseBackgroundView.snp.makeConstraints { (make) in
                make.top.left.bottom.right.equalToSuperview()
            }
            setUIViewAutolayout()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        
        private func setUIViewAutolayout()  {
            weekTitleLabel.textAlignment = NSTextAlignment.center
            weekTitleLabel.font = UIFont.systemFont(ofSize: 10)
            baseBackgroundView.addSubview(weekTitleLabel)
            weekTitleLabel.snp.makeConstraints { (make) in
                make.top.equalToSuperview().inset(10)
                make.centerX.equalToSuperview()
                make.width.equalToSuperview()
                make.height.equalTo(10)
            }
            dateTitleLabel.textAlignment = NSTextAlignment.center
            dateTitleLabel.font = UIFont.boldSystemFont(ofSize: 12)
            baseBackgroundView.addSubview(dateTitleLabel)
            dateTitleLabel.snp.makeConstraints { (make) in
                make.top.equalTo(weekTitleLabel.snp.bottom).offset(3)
                make.centerX.equalToSuperview()
                make.width.equalToSuperview()
                make.height.equalTo(25)
            }
            priceTitleLabel.textAlignment = NSTextAlignment.center
            priceTitleLabel.font = UIFont.systemFont(ofSize: 9)
            baseBackgroundView.addSubview(priceTitleLabel)
            priceTitleLabel.snp.makeConstraints { (make) in
                make.top.equalTo(dateTitleLabel.snp.bottom)
                make.left.right.equalToSuperview()
                
            }
            setNormalStatus(type: .Default)
        }
       
        
        
        
       private func setNormalStatus(type:AppModelCatoryENUM) {
        
            baseBackgroundView.backgroundColor = TBIThemeWhite
            weekTitleLabel.textColor = TBIThemePrimaryTextColor
            dateTitleLabel.textColor = TBIThemePrimaryTextColor
            priceTitleLabel.textColor = TBIThemePrimaryTextColor
            
        }
        
        private func setSelectedStatus(type:AppModelCatoryENUM) {
            weekTitleLabel.textColor = TBIThemeWhite
            dateTitleLabel.textColor = TBIThemeWhite
            priceTitleLabel.textColor = TBIThemeWhite
            switch type {
            case .PersonalFlight:
                baseBackgroundView.backgroundColor = PersonalThemeDarkColor
            default:
                baseBackgroundView.backgroundColor = TBIThemeDarkBlueColor
            }
            
            baseBackgroundView.layer.cornerRadius = 3.0
            baseBackgroundView.clipsToBounds=true
        }
        
        
        //MARK:-----------dataSources----------
        public func fillDataSources(date:Date,price:String,selected:Bool,type:AppModelCatoryENUM) {
            
            let weekName:String = date.weekdayName
            let index = weekName.index(weekName.startIndex, offsetBy: 2)
            weekTitleLabel.text = weekName.substring(from: index)
            dateTitleLabel.text = date.month.description + "/" + date.day.description
//            priceTitleLabel.text = price
            if selected {
                setSelectedStatus(type: type)
            }else {
                setNormalStatus(type: type)
            }
            
        }
    }
    
    //MARK:-----------Action----------
    
    func calendarAction() {
        
        printDebugLog(message: "Calendar")
        
        
    }
    
    
    enum ListHeaderDateType:NSInteger {
        case DateContinuance = 1
        case DateDiscontinuous = 2
        case Default = 0
    }
    
    
    
    
    

}
