//
//  TBICalendarViewController.swift
//  shop
//
//  Created by manman on 2017/4/27.
//  Copyright © 2017年 TBI. All rights reserved.
//


import UIKit
import SwiftDate

enum TBICalendarAlertType:NSInteger {
    case PersonalSpecialHotel
    case PersonalSpecialTravel
    case PersonalSpecialFlight
    case PersonalSpecialTrain
    case PersonalVisa
    case PersonalHotel
    case PersonalTravel
    case PersonalFlight
    case PersonalTrain
    
    
    case Hotel
    case Travel
    case Flight
    case Train
    case Default //  没有提示信息
}


enum TBICalendarAction:NSInteger {
    case Done
    case Back
}



class TBICalendarViewController: CompanyBaseViewController,UICollectionViewDelegate,UICollectionViewDataSource{
    typealias HotelSearchCalendarBlock = (Array<Any>)->Void
    typealias HotelSelectedDateAcomplishBlock = (Array<String>?,TBICalendarAction) ->Void
    
    public var hotelSelectedDateAcomplishBlock:HotelSelectedDateAcomplishBlock!
    //public var hotelSearchCalendarBlock:HotelSearchCalendarBlock!
    public var bacButtonImageName:String = ""
    public var calendarAlertType:TBICalendarAlertType = TBICalendarAlertType.Default
    public var calendarTypeAlert:[String] = Array()
    //这个字段 需和 selectedDates 一致
    public var isMultipleTap:Bool = true
    //这个字段 需和 isMultipleTap 一致 "yyyy-MM-dd HH:mm:ss"
    public var selectedDates:[String] = Array()
    //日子 描述
    public var showDateTitle:[String] = Array()
    
    public var personalSpecialHotelActivetyDay:[SpecialHotelDetailResponse.HotelUsableDateInfo] = Array()
    
    
    /// 延后天数 开始
    public var delayDay:NSInteger = 0
    
    public var titleColor:UIColor?
    private var collectionView:UICollectionView?
    private let identify:String = "identify"
    private let headerIdentify:String = "headerIdentify"
    private var calendarManager:TBICalenderManager = TBICalenderManager()
    private var alertCalendarView:AlertCalendarView = AlertCalendarView()
    private var topBackgroundView:UIView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setBlackTitleAndNavigationColor(title: "选择日期")
        setNavigationBgColor(color: TBIThemeWhite)
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.alpha = 1
        
        //calendarManager.mm_ShowDateRegion(start:"2017-07-10",end:"2018-12-31")
        calendarManager.mm_setCalendarType(type: calendarAlertType)
        calendarManager.mm_showDateScope(scopeYear: true)
        
        //personalSpecialHotelCustomConfig()
        
      
        personalCustomConfig()
        setDataSources()
        setUIAutolayout()
        
        
        
        var title:String = "请选择入住日期"
        if calendarTypeAlert.count > 0
        {
            title = calendarTypeAlert.first!
        }
        
        showAlertViewAlpha(title: title)
        //createPthreadScrollItemToCenter()

        
    }
    
    
    func personalCustomConfig() {
        switch calendarAlertType {
        case .PersonalSpecialHotel:
            personalSpecialHotelCustomConfig()
        case .PersonalVisa:
            personalVisaCustomConfig()
        default:break
        }
    }
    
    
    /// 定投酒店 特殊配制
    func personalSpecialHotelCustomConfig() {
        guard calendarAlertType == TBICalendarAlertType.PersonalSpecialHotel && personalSpecialHotelActivetyDay.count > 0 else {
            return
        }
        
        calendarManager.mm_PersonalSpecialHotelDateSaleActivetySet(dateSet:personalSpecialHotelActivetyDay)
        
    }
    
    func personalVisaCustomConfig() {
        guard calendarAlertType == TBICalendarAlertType.PersonalVisa && delayDay != 0 else {
            return
        }
        
        calendarManager.mm_PersonalVisa(delayDay: delayDay)
    }
    
    
    
    
    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        scrollItemToCenter()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = false
        printDebugLog(message: "ceshi")
        scrollItemToCenter()
        
        
    }
    
    func showAlertViewAlpha(title:String) {
        
        switch calendarAlertType {
        case .Hotel,.Flight,.Travel,.Train:
            alertCalendarView.fillDataSource(title: title)
        case .Default:
            alertCalendarView.removeFromSuperview()
            break
        case .PersonalHotel,.PersonalVisa:
            alertCalendarView.fillDataSource(title: title)
        case .PersonalSpecialHotel:
            alertCalendarView.fillDataSource(title: title)
        default:break
        }
    }
    
    func setDataSources() {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone!
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var tmpCheckinDate:Date = Date()
        var tmpCheckoutDate:Date = Date()
        
        if showDateTitle.count > 0 {
            calendarManager.showTitleArr = showDateTitle
        }
        
        
        if isMultipleTap == true
        {
            if selectedDates.count != 2 {
                return
            }
            if selectedDates[0].characters.count > 0 &&  selectedDates[1].characters.count > 0
            {
                tmpCheckinDate  = dateFormatter.date(from:selectedDates[0])!
                tmpCheckoutDate = dateFormatter.date(from:selectedDates[1])!
                calendarManager.selectedDates.append(tmpCheckinDate)
                calendarManager.selectedDates.append(tmpCheckoutDate)
                calendarManager.mm_addDataSources(fromDate: tmpCheckinDate, toDate:tmpCheckoutDate )
            }
            
        }else
        {
            if selectedDates.count != 1 {
                return
            }
            if selectedDates[0].characters.count > 0
            {
                tmpCheckinDate  = dateFormatter.date(from:selectedDates[0])!
                calendarManager.selectedDates.append(tmpCheckinDate)
            }
        }
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setUIAutolayout() {
        
//        collectionView?.register(CalenadrCollectionReusableView.classForCoder(), forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: calenadrCollectionReusableViewIdentify)
        self.view.addSubview(topBackgroundView)
        topBackgroundView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(30)
        }
        let weekView = CalenadrCollectionReusableView()
        topBackgroundView.addSubview(weekView)
        weekView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(15)
        }
        
        
        
        //设置cell的大小
        let flowLayout =  UICollectionViewFlowLayout.init()
        collectionView = UICollectionView.init(frame:CGRect.zero, collectionViewLayout: flowLayout)
        flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.headerReferenceSize = CGSize.init(width: ScreenWindowWidth, height: 30)
        let itemSize = (ScreenWindowWidth - 30) / 7
        flowLayout.collectionView?.contentInset.left = 15
        flowLayout.collectionView?.contentInset.right = 15
        flowLayout.itemSize = CGSize(width: itemSize,height: itemSize)
        collectionView?.backgroundColor = UIColor.white
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        
        
        collectionView?.register(TBICalendarCell.classForCoder(), forCellWithReuseIdentifier:identify)
        collectionView?.register(TBICalenadrCollectionHeaderView.classForCoder(), forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: headerIdentify)
        self.view.addSubview(collectionView!)
        collectionView?.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(30)
            make.left.bottom.right.equalToSuperview()
        }
       
       
        self.view.addSubview(alertCalendarView)
        alertCalendarView.snp.makeConstraints { (make) in
            make.width.equalTo(150)
            make.height.equalTo(35)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(57)
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return calendarManager.mm_Section()
    
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return calendarManager.mm_ItemsForSection(section: section)
    
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:TBICalendarCell = collectionView.dequeueReusableCell(withReuseIdentifier: identify, for: indexPath) as! TBICalendarCell
        let indexDate:Date = calendarManager.mm_DateForIndexPath(indexPath: indexPath)
        let monthPosition = calendarManager.mm_monthPositionForIndexPath(indexPath: indexPath)
        let isToday:Bool = calendarManager.mm_isToday(indexPath: indexPath)
        let isActivity:Bool = calendarManager.mm_isActivity(indexPath: indexPath)
        
        var showBottomLine:Bool = true
        
        
        
        if indexPath.row >=  calendarManager.mm_ItemsForSection(section: indexPath.section) - 7
        {
            showBottomLine = false
        }
        
        
        
        var showFirstTitleStr:String = "去程";
        if (calendarManager.showTitleArr.count >= 1) {
            showFirstTitleStr = calendarManager.showTitleArr[0];
        }
        var showSecondTitleStr:String = "返程";
        if (calendarManager.showTitleArr.count >= 2) {
            showSecondTitleStr = calendarManager.showTitleArr[1];
        }
        
        
        
        
        switch monthPosition {
        case TBICalendarMonthPosition.PreviousMonth:
            cell.setCellTypeNone()
            return cell
        case TBICalendarMonthPosition.CurrentMonth:
            
            if calendarManager.selectedDates.count  == 1 {
                if calendarManager.selectedDates.contains(indexDate) {
                    cell.setCellTypeFirstSelected(title:indexDate.day.description , subTitle: showFirstTitleStr, today: isToday)
                    return cell
                }
                
            }
            if calendarManager.selectedDates.count >= 2 {
                if calendarManager.selectedDates[0] == indexDate {
                    
                    cell.setCellTypeFirstSelected(title: indexDate.day.description, subTitle: showFirstTitleStr, today: isToday)
                    return cell
                }
                
                if calendarManager.selectedDates[1] == indexDate {
                    
                    cell.setCellTypeFirstSelected(title: indexDate.day.description, subTitle: showSecondTitleStr, today: isToday)
                    return cell
                }
                
                // 选中 日期 展示
                if calendarManager.selectedDates.contains(indexDate) {
                    cell.fillDataSources(title: indexDate.day.description, subTitle: "", today: isToday, isSelected:true, alpha: 0.4, activity: isActivity, showLine: showBottomLine)
                    return cell
                }
                
            }
            
            
            
            cell.fillDataSources(title: indexDate.day.description, subTitle: "", today: isToday, isSelected: false, alpha: 1.0, activity: isActivity, showLine: showBottomLine)
            return cell
        case TBICalendarMonthPosition.NextMonth:
            cell.setCellTypeNone()
            return cell
        default:
            break
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        let headerView:TBICalenadrCollectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerIdentify, for: indexPath) as! TBICalenadrCollectionHeaderView
        let title:Date = calendarManager.mm_MonthForSection(section: indexPath.section)
        headerView.fillDataSources(title:title.string(format: .custom("yyyy年M月")))
        
        return headerView
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let cell:TBICalendarCell = collectionView.cellForItem(at: indexPath) as! TBICalendarCell
        let isActivity:Bool = cell.getActivity()
        let selectedDate:Date = calendarManager.mm_DateForIndexPath(indexPath: indexPath)
        if isActivity {
             print("selected")
            selectedItem(selectedDate: selectedDate)
        }

        
    }
    
    func selectedItem(selectedDate:Date) {
        
        if (calendarManager.selectedDates.count == 0 ) {
            
            if (self.isMultipleTap == false) {
                
                calendarManager.selectedDates.append(selectedDate)
                collectionView?.reloadData()
                selectedDateAction(parameters: calendarManager.selectedDates)
            }
            return;
            
        }
        // 第二次 选中 日期  返程
        if (calendarManager.selectedDates.count == 1) {
            
            
            if (self.isMultipleTap == false) {
                calendarManager.selectedDates.removeAll()
                //[calendarManager.selectedDates removeAllObjects];
                calendarManager.selectedDates.append(selectedDate)
                collectionView?.reloadData()
                selectedDateAction(parameters: calendarManager.selectedDates)
                return
                
            }
            // 判断 选中日期 和第二个日期 时间 顺序 是否为正
            if calendarManager.selectedDates[0].compare(selectedDate)  == ComparisonResult.orderedAscending{
                calendarManager.selectedDates.append(selectedDate)
                calendarManager.mm_addDataSources(fromDate: calendarManager.selectedDates[0], toDate: calendarManager.selectedDates[1])
                collectionView?.reloadData()
                selectedDateAction(parameters: calendarManager.selectedDates)
                return
                
            }else
            {
                calendarManager.selectedDates[0] = selectedDate
                collectionView?.reloadData()
                return
            }
        }
        // 第三次 选中 日期  去程
        if calendarManager.selectedDates.count >= 2 {
            calendarManager.selectedDates.removeAll()
            calendarManager.selectedDates.append(selectedDate)
            collectionView?.reloadData()
            var alert:String = "请选择离店日期"
            if calendarTypeAlert.count >= 1
            {
                alert = calendarTypeAlert[1]
                
            }
            showAlertViewAlpha(title: alert)
            
            
            return
        }
    }
    
    
    //返回的数据 只是想要的 其他的需要过滤  转化为String类型
    func selectedDateAction(parameters:[Date]) {
        var resultArr:[String] = Array()
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone?
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if isMultipleTap
        {
            if parameters.count >= 2 {
                resultArr.append(formatter.string(from: parameters[0]))
                resultArr.append(formatter.string(from: parameters[1]))
            }
        }
        else
        {
            if parameters.count > 0
            {
                resultArr.append(formatter.string(from: parameters[0]))
            }
        }
        if self.hotelSelectedDateAcomplishBlock != nil {
            self.hotelSelectedDateAcomplishBlock(resultArr,TBICalendarAction.Done)
        }
        
        self.perform(#selector(backButtonAction(sender:)), with: nil, afterDelay: 0.2)
    }
    
    
    func createPthreadScrollItemToCenter() {
        
        while (true) {
            if (collectionView?.window != nil) {
                break;
            }
        }
        
        weak var weakSelf = self
        DispatchQueue.main.async {
            weakSelf?.scrollItemToCenter()
        }
        
    }
    
    
    
    func scrollItemToCenter() {
        if calendarManager.selectedDates.count > 0 {
            let selectedDate:Date = calendarManager.selectedDates.first!
            let scrollSection:IndexPath = IndexPath.init(row: 0, section: self.calendarManager.mm_sectionForMonth(month: selectedDate))
            collectionView?.layoutIfNeeded()
            printDebugLog(message: scrollSection)
            collectionView?.scrollToItem(at:scrollSection, at: UICollectionViewScrollPosition.top, animated: true)

        }
    }
    
    
    
    
    
    
    
    override func backButtonAction(sender: UIButton) {
        
        print("TBICalendarViewController calendar back action ...  校验是否为返回action  校验 回调 第二个参数 TBICalendarAction.Back  ")
        self.hotelSelectedDateAcomplishBlock(nil,TBICalendarAction.Back)
        
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
//    func intoNextView() {
//        
//        self.hotelSearchCalendarBlock(self.calendar.selectedDates as! Array<Any>)
//        
//        _ = self.navigationController?.popViewController(animated: true)
//    }
    

}


class AlertCalendarView: UIView {
    
    private let alertTitleLabel:UILabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setalertCalendarView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setalertCalendarView() {
        let baseBackgroundView:UIView = UIView()
        baseBackgroundView.backgroundColor = UIColor.clear
        self.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
           make.top.left.bottom.right.equalToSuperview()
        }
        let subBaseBackgroundView:UIView = UIView()
        subBaseBackgroundView.backgroundColor = UIColor.black
        subBaseBackgroundView.alpha = 0.4
        subBaseBackgroundView.layer.cornerRadius = 2
        baseBackgroundView.addSubview(subBaseBackgroundView)
        subBaseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        alertTitleLabel.font = UIFont.systemFont( ofSize: 13)
        alertTitleLabel.text = ""
        alertTitleLabel.textColor = UIColor.white
        alertTitleLabel.textAlignment = NSTextAlignment.center
        alertTitleLabel.adjustsFontSizeToFitWidth = true
        baseBackgroundView.addSubview(alertTitleLabel)
        alertTitleLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        print("TBICalendarViewController 修改提示信息 请在 数组变量 calendarTypeAlert 和calendarAlertType   添加")
    }
    func fillDataSource(title:String) {
        alertTitleLabel.text = title
    }
    
    
    
    
}





