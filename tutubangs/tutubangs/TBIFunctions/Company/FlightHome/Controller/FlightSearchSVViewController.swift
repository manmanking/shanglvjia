//
//  FlightSVSearchViewController.swift
//  shop
//
//  Created by manman on 2018/2/1.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import RxSwift
import SwiftDate

// 下面 全局的 变量 是 以前的页面 copy 勿动  机票的 相关页面 需要使用
// 全局变量 现在已经 替换 2018-03-28

var searchModel: CommercialFlightSearchForm = CommercialFlightSearchForm(takeOffAirportCode: "TSN", arriveAirportCode: "SHA",takeOffAirportName: "天津滨海机场",arriveAirportName: "上海虹桥机场", type: 0, travellerUids: [""])
//选中去程航班信息信息
var takeOffModel:FlightListItem?
//选中回程航班信息
var arriveModel:FlightListItem?
//选中去程航班信息////???
var takeOffCabinRow:Int?
//选中回程航班信息
var arriveCabinRow:Int?
/// 个人信息end

/// 企业信息begin
//  去成航班信息
var takeOffCompanyModel:CoFlightSearchResult.FlightItem?
//  回程航班信息
var arriveCompanyModel:CoFlightSearchResult.FlightItem?
//选中去程航班信息
var takeOffCompanyCabinRow:Int?
//选中回程航班信息
var arriveCompanyCabinRow:Int?




class FlightSVSearchViewController: CompanyBaseViewController,CoBusinessTypeListener,UIScrollViewDelegate {
    

    
    private let topImageView:UIImageView = UIImageView()
    
   // private let service = CityService.sharedInstance
    private let fakeBackgroundScrollView:UIScrollView = UIScrollView()
    
    private let baseBackgroundScrollView:UIScrollView = UIScrollView()
    
    private let subBaseBackgroundView:UIView = UIView()
    
    
    private let searchView:FlightSVSearchView = FlightSVSearchView()
    
    private let pickerTimeView:TBIPickerView = TBIPickerView()
    
    /// 政策 背景  容器
    private let plicyTipBaseBackgroundView:UIView = UIView()
    
    private let plicyTipLabel:UILabel = UILabel()
    
    private let plicyTipFlagImageView:UIImageView = UIImageView()
    
    private var plicyTipDefault:String = "根据您的差旅政策，查询结果显示您期望时间上下2小时内的航班信息"
    
    private var servicesPhoneView:TBIServicesPhoneView = TBIServicesPhoneView()
    
    private var userInfo = UserService.sharedInstance.userDetail()
    
//    private var jumpCommonFooterView:CoJumpCommonFooterView = CoJumpCommonFooterView()
    
    
    /// 预订规划时间
    private var pickViewTimeDataSourcesArr:[String] = Array()
    
    public var travelNo:String? = nil
    
    private var flightServicesStartDate:Date = Date()
    
    private var flightServicesEndDate:Date = Date()
    
    private var flightViewServicesCategoryView:CoJumpCommonFooterView = CoJumpCommonFooterView()
    
    private var  jumpList:[(title:String,image:String,type:CoCompanyBusinessType,isClick:Bool)] = Array()
    
    private var flightServiceTakeOffStartHour:String = ""
    
    private var flightServiceLandingStartHour:String = ""
    
    //MARK:---------NEWOBT ----------
    
    private var flightSVSearchCondition:FlightSVSearchConditionModel = FlightSVSearchConditionModel()
    
    //private var tableViewDataSources:[FlightSVSearchConditionModel] = Array()
    
    private let endAirPortPlaceholderTipDefault:String = "到达机场"
    
    
    
    fileprivate var userPolicy:UserPolicy?
    
    override func viewDidLoad() {
        self.view.backgroundColor = TBIThemeBaseColor
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        //self.view.addSubview(fakeBackgroundScrollView)
        //baseBackgroundScrollView.frame = ScreenWindowFrame
        self.view.addSubview(baseBackgroundScrollView)
        baseBackgroundScrollView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        self.navigationController?.navigationBar.isTranslucent = true
        self.automaticallyAdjustsScrollViewInsets = false
        if #available(iOS 11.0, *) {
            self.baseBackgroundScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        } else {
            // Fallback on earlier versions
        }
        self.navigationController?.extendedLayoutIncludesOpaqueBars = false
        
        baseBackgroundScrollView.bounces = false
        baseBackgroundScrollView.delegate = self
//        if #available(iOS 11.0, *) {
//            baseBackgroundScrollView.insetsLayoutMarginsFromSafeArea = false
//        } else {
//            // Fallback on earlier versions
//        }
        baseBackgroundScrollView.showsHorizontalScrollIndicator = false
        //baseBackgroundScrollView.contentSize = CGSize.init(width: ScreenWindowWidth, height:ScreentWindowHeight)
        var contentHeight:CGFloat = ScreentWindowHeight
        if ScreentWindowHeight < 667 {
            contentHeight = 667
        }
        subBaseBackgroundView.frame = CGRect.init(x: 0, y: 0, width: ScreenWindowWidth, height: contentHeight)
        baseBackgroundScrollView.addSubview(subBaseBackgroundView)
//        subBaseBackgroundView.snp.makeConstraints { (make) in
//            make.top.left.right.equalToSuperview()
//            make.width.equalTo(ScreenWindowWidth)
//            make.height.equalTo(contentHeight)
//        }
        baseBackgroundScrollView.contentSize = CGSize.init(width: ScreenWindowWidth, height: contentHeight)
        //baseBackgroundScrollView.contentInset = UIEdgeInsets.zero
        setUIviewAutolayout()
        fillLocalDataSources()
        policyView()
    }
    
    func setUIviewAutolayout() {
        topImageView.image = UIImage.init(named: "banner_air")
        topImageView.contentMode = UIViewContentMode.scaleToFill
        subBaseBackgroundView.addSubview(topImageView)
        topImageView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(180)
        }
        let flightServicesViewType:FlightSVSearchView.FlightServicesViewType = FlightSVSearchView.FlightServicesViewType.DefTakeOffTime
        subBaseBackgroundView.addSubview(searchView)
        searchView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(135)
            make.left.right.equalToSuperview()
            make.height.equalTo(255)
        }
        searchView.adjustFlightSVSearchView(type:flightServicesViewType)
        weak var weakSelf = self
        searchView.flightSVSearchViewExchangeAddressPointBlock = { cellIndex in
            weakSelf?.flightSVSearchViewExchangeAddressPointAction(cellIndex: cellIndex)
        }
        searchView.flightSVSearchViewServicesRouterTypeBlock = { (servicesType,sumRow) in
            weakSelf?.flightSVSearchViewServicesTypeAction(servicesType: servicesType ,sumRow: sumRow)
        }
        searchView.flightSVSearchViewServicesParametersTypeBlock = { (servicesType,cellIndex) in
            weakSelf?.changesearchModelValue(servicesType: servicesType, cellIndex: cellIndex)
        }
        
        searchView.flightSVSearchViewMoreTripAddTripBlock = { _ in
            
            weakSelf?.searchViewMoreTripAddTrip()
        }
        searchView.flightSVSearchViewMoreTripDeleteTripBlock = { cellIndex in
            weakSelf?.searchViewMoreTripDeleteTrip(deleteCell: cellIndex)
        }
        
        
        searchView.flightSVSearchViewSearchBlock = { _ in
            weakSelf?.searchAction()
        }
        initJumpCommonFooterView()
       
        
        subBaseBackgroundView.addSubview(servicesPhoneView)
        servicesPhoneView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(100)
            make.bottom.equalToSuperview()
            //make.top.equalTo(flightViewServicesCategoryView.snp.bottom)
        }
        if (UserDefaults.standard.object(forKey: servicesPhoneAir) as! String).isEmpty == false {
            let workPhone:String = UserDefaults.standard.object(forKey: servicesPhoneAir) as! String
            if workPhone.isEmpty == false {
                servicesPhoneView.fillDataSource(workPhone: workPhone, overtimePhone: "")
            }
        }else
        {
            servicesPhoneView.isHidden = true
        }
        
    }
    
    
    // MARK:---------------UIScrollViewDelegate------------
    
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        printDebugLog(message: scrollView.contentInset)
//        printDebugLog(message: scrollView.contentOffset)
//        if #available(iOS 11.0, *) {
//            printDebugLog(message: scrollView.adjustedContentInset)
//            scrollView.contentInset = UIEdgeInsets.zero
//            scrollView.setContentOffset(CGPoint.zero, animated: true)
//        } else {
//            // Fallback on earlier versions
//        }
//    }
//
//    func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
//        scrollView.setContentOffset(CGPoint.zero, animated: true)
//    }
//
    
    
    
    
    // MARK:---------------fillDataSources------------
    
    func fillLocalDataSources() {
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone?
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let firstSVSearchModel:FlightSVSearchConditionModel = FlightSVSearchConditionModel()
        let secondSVSearchModel:FlightSVSearchConditionModel = FlightSVSearchConditionModel()
        firstSVSearchModel.takeOffAirportCode = "TSN"
        firstSVSearchModel.takeOffAirportName = "天津滨海机场"
        firstSVSearchModel.arriveAirportCode = "SHA"
        firstSVSearchModel.arriveAirportName = "上海虹桥机场"
        firstSVSearchModel.departureDateFormat = formatter.string(from: flightServicesStartDate)
        firstSVSearchModel.returnDateFormat = formatter.string(from: flightServicesStartDate + 3.day)
        firstSVSearchModel.departureDate = NSInteger(flightServicesStartDate.timeIntervalSince1970) * 1000
        firstSVSearchModel.returnDate = NSInteger((flightServicesStartDate + 3.day).timeIntervalSince1970) * 1000
        
        secondSVSearchModel.takeOffAirportCode = "SHA"
        secondSVSearchModel.takeOffAirportName = "上海虹桥机场"
        secondSVSearchModel.departureDateFormat = formatter.string(from:flightServicesStartDate + 3.day)
        secondSVSearchModel.departureDate = NSInteger((flightServicesStartDate + 3.day).timeIntervalSince1970) * 1000
        FlightManager.shareInStance.flightConditionStore(searchConditionArr:[firstSVSearchModel,secondSVSearchModel])
        
        searchView.fillMoreTripDataSources(dataSoureces: FlightManager.shareInStance.flightConditionDraw())
    }
    
    //MARK:-----------IntonextView---------
    //选择日期
    func nextViewTBICalendar (cellIndex:NSInteger) {
        weak var weakSelf = self
        let vc:TBICalendarViewController = TBICalendarViewController()
        if searchView.getFlightServicesRouteType() == FlightSVSearchView.FlightServicesRouteType.OneWay ||
            searchView.getFlightServicesRouteType() == FlightSVSearchView.FlightServicesRouteType.MoreTrip {
            let searchConditionArr = FlightManager.shareInStance.flightConditionDraw()
            vc.selectedDates =  [searchConditionArr[cellIndex].departureDateFormat]
            vc.isMultipleTap = false
            vc.showDateTitle = [""]
            vc.titleColor = TBIThemePrimaryTextColor
            vc.bacButtonImageName = "back"
            vc.hotelSelectedDateAcomplishBlock = { (parameters,action) in
                weakSelf?.adjustFlightDate(parameters: parameters, action: action, cellIndex: cellIndex)
                weakSelf?.searchView.fillMoreTripDataSources(dataSoureces:FlightManager.shareInStance.flightConditionDraw())
                
            }
        }else if searchView.getFlightServicesRouteType() == FlightSVSearchView.FlightServicesRouteType.RoundTrip {
            vc.selectedDates = [FlightManager.shareInStance.flightConditionDraw().first?.departureDateFormat,
                                FlightManager.shareInStance.flightConditionDraw().first?.returnDateFormat] as! [String]
            vc.isMultipleTap = true
            vc.calendarAlertType = TBICalendarAlertType.Flight
            vc.calendarTypeAlert = ["请选择去程日期","请选择返程日期"]
            vc.showDateTitle = ["去程","返程"]
            vc.titleColor = TBIThemePrimaryTextColor
            vc.bacButtonImageName = "back"
            vc.hotelSelectedDateAcomplishBlock = { (parameters,action) in
                weakSelf?.adjustFlightDate(parameters: parameters, action: action, cellIndex: cellIndex)
                weakSelf?.searchView.fillMoreTripDataSources(dataSoureces:FlightManager.shareInStance.flightConditionDraw())
            }
        }
        _ = self.navigationController?.pushViewController(vc, animated: true)
    }
 
    
    /// 调整机票时间
    func adjustFlightDate(parameters:Array<String>?,action:TBICalendarAction,cellIndex:NSInteger) {
        guard action != TBICalendarAction.Back else {
            return
        }
        let formatter:DateFormatter = DateFormatter()
        formatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone?
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        var searchConditionArr = FlightManager.shareInStance.flightConditionDraw()
        
        // 单程 和 多程 只需要修改 起飞时间
        if parameters?.count == 1 {
            let departureDate:Date = formatter.date(from:(parameters?.first)!)!
            // 修改当前行程的日期
            if cellIndex  == 0 {
                let firstSearchCondition = searchConditionArr.first
                firstSearchCondition?.departureDateFormat = (parameters?.first)!
                firstSearchCondition?.departureDate = NSNumber.init(value:departureDate.timeIntervalSince1970 * 1000).intValue
                firstSearchCondition?.returnDateFormat = formatter.string(from: (departureDate + 3.day))
                firstSearchCondition?.returnDate = NSNumber.init(value: (departureDate + 3.day).timeIntervalSince1970 * 1000).intValue
                searchConditionArr[0] = firstSearchCondition!
            }else {
                let cellIndexSearchCondition = searchConditionArr[cellIndex]
                cellIndexSearchCondition.departureDateFormat = (parameters?.first)!
                cellIndexSearchCondition.departureDate = NSNumber.init(value:departureDate.timeIntervalSince1970 * 1000).intValue
                cellIndexSearchCondition.returnDateFormat = formatter.string(from: (departureDate + 3.day))
                cellIndexSearchCondition.returnDate = NSNumber.init(value: (departureDate + 3.day).timeIntervalSince1970 * 1000).intValue
                searchConditionArr[cellIndex] = cellIndexSearchCondition
            }

        }else{ // 往返
            let departureDate:Date = formatter.date(from:(parameters![0]))!
            let returnDate:Date = formatter.date(from:(parameters![1]))!
            
            let firstSearchCondition = searchConditionArr.first
            firstSearchCondition?.departureDateFormat = (parameters![0])
            firstSearchCondition?.returnDateFormat = (parameters![1])
            firstSearchCondition?.departureDate = NSNumber.init(value:departureDate.timeIntervalSince1970 * 1000).intValue
            firstSearchCondition?.returnDate = NSNumber.init(value: (returnDate).timeIntervalSince1970 * 1000).intValue
            searchConditionArr[0] = firstSearchCondition!
        }
        
        // 后面的排期都跟随变动  多程的行程变动
        for (index,_) in (searchConditionArr.enumerated()) {
            if index + 1 >= (searchConditionArr.count) {break}
            if cellIndex > index { continue }
            let tmpSearchCondition = searchConditionArr[index]
            let tmpAfterSearchCondition = searchConditionArr[index + 1]
            let departureDate:Date = formatter.date(from: tmpSearchCondition.departureDateFormat)!
            tmpAfterSearchCondition.departureDateFormat = formatter.string(from: (departureDate + 3.day))
            tmpAfterSearchCondition.departureDate = NSNumber.init(value: (departureDate + 3.day).timeIntervalSince1970 * 1000).intValue
            searchConditionArr[index + 1] = tmpAfterSearchCondition
        }
        
        FlightManager.shareInStance.flightConditionStore(searchConditionArr: searchConditionArr)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        //self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.star()
        self.extendedLayoutIncludesOpaqueBars = true
        initNavigation(title:"",bgColor:TBIThemeBlueColor,alpha:0,isTranslucent:true)
        FlightManager.shareInStance.resetPartFlightInfo()
        searchView.fillMoreTripDataSources(dataSoureces: FlightManager.shareInStance.flightConditionDraw())
        setNavigationBackButton(backImage: "BackCircle")
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        //self.view.endEditing(true)
        self.navigationController?.navigationBar.reset()
    }
    
    //MARK:-----------Action---------
    
    /// 交换 起始地点
    func flightSVSearchViewExchangeAddressPointAction(cellIndex:NSInteger) {
        guard FlightManager.shareInStance.flightConditionDraw().count > cellIndex  else {
            return
        }
        var searchConditionArr = FlightManager.shareInStance.flightConditionDraw()
        let tmpSearchCondition = searchConditionArr[cellIndex]
        let takeOffAirportCode = tmpSearchCondition.takeOffAirportCode
        let takeOffAirportName = tmpSearchCondition.takeOffAirportName
        tmpSearchCondition.takeOffAirportCode =  tmpSearchCondition.arriveAirportCode
        tmpSearchCondition.takeOffAirportName =  tmpSearchCondition.arriveAirportName
        tmpSearchCondition.arriveAirportCode =  takeOffAirportCode
        tmpSearchCondition.arriveAirportName =  takeOffAirportName
        searchConditionArr[cellIndex] = tmpSearchCondition
        // 后面的排期都跟随变动  多程的行程变动
        for (index,_) in (searchConditionArr.enumerated()) {
            if index + 1 >= (searchConditionArr.count) {break}
            if cellIndex > index { continue }
            let tmpSearchCondition = searchConditionArr[index]
            let tmpAfterSearchCondition = searchConditionArr[index + 1]
            if tmpSearchCondition.arriveAirportCode != tmpAfterSearchCondition.takeOffAirportCode {
                tmpAfterSearchCondition.takeOffAirportCode = tmpSearchCondition.arriveAirportCode
                tmpAfterSearchCondition.takeOffAirportName = tmpSearchCondition.arriveAirportName
            }
            searchConditionArr[index + 1] = tmpAfterSearchCondition
        }
        FlightManager.shareInStance.flightConditionStore(searchConditionArr:searchConditionArr)
        searchView.fillMoreTripDataSources(dataSoureces: FlightManager.shareInStance.flightConditionDraw())
    }
    
    
    /// 修改机场信息
    ///
    /// - Parameters:
    ///   - airport: 机场信息
    ///   - airPortType: 机场类型
    ///   - index: 第几段
    func flightModifyAirport(airport:AirportInfoResponseSVModel,
                             airPortType:FlightSVSearchView.FlightSVSearchViewServicesType,
                             cellIndex:NSInteger) {

        var searchConditionArr = FlightManager.shareInStance.flightConditionDraw()
        let searchCondition = searchConditionArr[cellIndex]
        if  FlightSVSearchView.FlightSVSearchViewServicesType.startCity == airPortType{
            searchCondition.takeOffAirportCode = airport.airportCode
            searchCondition.takeOffAirportName = airport.airportName
        }else if FlightSVSearchView.FlightSVSearchViewServicesType.arriveCity == airPortType{
            searchCondition.arriveAirportName  = airport.airportName
            searchCondition.arriveAirportCode =  airport.airportCode
        }
        searchConditionArr[cellIndex] = searchCondition
        // 后面的排期都跟随变动  多程的行程变动
        for (index,_) in (searchConditionArr.enumerated()) {
            if index + 1 >= (searchConditionArr.count) {break}
            if cellIndex > index { continue }
            let tmpSearchCondition = searchConditionArr[index]
            let tmpAfterSearchCondition = searchConditionArr[index + 1]
            if tmpSearchCondition.arriveAirportCode != tmpAfterSearchCondition.takeOffAirportCode {
                tmpAfterSearchCondition.takeOffAirportCode = tmpSearchCondition.arriveAirportCode
                tmpAfterSearchCondition.takeOffAirportName = tmpSearchCondition.arriveAirportName
            }
            searchConditionArr[index + 1] = tmpAfterSearchCondition
        }
        FlightManager.shareInStance.flightConditionStore(searchConditionArr:searchConditionArr)
        searchView.fillMoreTripDataSources(dataSoureces: FlightManager.shareInStance.flightConditionDraw())
    }
    
    /// 航班 行程  例如 单程  往返 多程
    func flightSVSearchViewServicesTypeAction(servicesType:FlightSVSearchView.FlightServicesRouteType,sumRow:NSInteger) {
        //如果时间是0不显示time
        if userInfo?.companyUser?.lowestPriceInterval != 0 &&
            servicesType == FlightSVSearchView.FlightServicesRouteType.RoundTrip {
            searchView.snp.remakeConstraints({ (make) in
                make.top.equalToSuperview().inset(135)
                make.left.right.equalToSuperview()
                make.height.equalTo(255)
            })
        }else if servicesType == FlightSVSearchView.FlightServicesRouteType.OneWay {
            searchView.snp.remakeConstraints({ (make) in
                make.top.equalToSuperview().inset(135)
                make.left.right.equalToSuperview()
                make.height.equalTo(255)
            })
        }else if servicesType == FlightSVSearchView.FlightServicesRouteType.MoreTrip{
            searchView.snp.remakeConstraints({ (make) in
                make.top.equalToSuperview().inset(135)
                make.left.right.equalToSuperview()
                make.height.equalTo(345 + 44 + (sumRow - 2)  * 110)
            })
            
        }
        var contentHeight:CGFloat = 0
        if FlightSVSearchView.FlightServicesRouteType.MoreTrip == servicesType && sumRow > 2 {
            
            //baseBackgroundScrollView.contentSize = CGSize.init(width: ScreenWindowWidth, height:ScreentWindowHeight + 50 + CGFloat((sumRow - 2) * 110))
            contentHeight = ScreentWindowHeight + 50 + CGFloat((sumRow - 2) * 110)
            
        }else
        {
            if ScreentWindowHeight < 667 {
                contentHeight = 667
            }else {
                 contentHeight = ScreentWindowHeight
            }
            //baseBackgroundScrollView.contentSize = CGSize.init(width: ScreenWindowWidth, height:contentHeight)
            
        }
        
        if FlightSVSearchView.FlightServicesRouteType.MoreTrip == servicesType && sumRow == 2  {
            contentHeight = 736
            //baseBackgroundScrollView.contentSize = CGSize.init(width: ScreenWindowWidth, height:contentHeight)
        }
        baseBackgroundScrollView.contentSize = CGSize.init(width: ScreenWindowWidth, height:contentHeight)
        
//        subBaseBackgroundView.snp.remakeConstraints { (make) in
//            make.top.left.right.equalToSuperview()
//            make.width.equalTo(ScreenWindowWidth)
//            make.height.equalTo(contentHeight)
//        }

        subBaseBackgroundView.frame = CGRect.init(x: 0, y: 0, width: ScreenWindowWidth, height: contentHeight)
        
        printDebugLog(message: "debug info")
        printDebugLog(message: searchView.frame)
        printDebugLog(message: servicesType)
        printDebugLog(message: contentHeight)
        printDebugLog(message: subBaseBackgroundView.frame)
        printDebugLog(message: baseBackgroundScrollView.contentSize)
    }
    
    func changesearchModelValue(servicesType:FlightSVSearchView.FlightSVSearchViewServicesType,cellIndex:NSInteger) {
        switch servicesType {
        case FlightSVSearchView.FlightSVSearchViewServicesType.startCity:
            intoNextAirportView(airPortType:.startCity ,index: cellIndex)
        case FlightSVSearchView.FlightSVSearchViewServicesType.arriveCity:
            intoNextAirportView(airPortType:.arriveCity ,index: cellIndex)
        case FlightSVSearchView.FlightSVSearchViewServicesType.startDate:
            self.nextViewTBICalendar(cellIndex: cellIndex)
        case FlightSVSearchView.FlightSVSearchViewServicesType.arriveDate:
            self.nextViewTBICalendar(cellIndex: cellIndex)
        case .startTime,.arriveTime:
            break
        }
    }
    
    /// 添加行程
    func searchViewMoreTripAddTrip() {
        let formatter:DateFormatter = DateFormatter()
        formatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone?
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        var searchConditionArr = FlightManager.shareInStance.flightConditionDraw()
        let departureDate:Date = formatter.date(from: (searchConditionArr.last?.departureDateFormat)!)!
        
        let secondSVModel:FlightSVSearchConditionModel = FlightSVSearchConditionModel()
        secondSVModel.takeOffAirportCode = (searchConditionArr.last?.arriveAirportCode ?? "")
        secondSVModel.takeOffAirportName = (searchConditionArr.last?.arriveAirportName ?? "")
        secondSVModel.departureDate = NSNumber.init(value: (departureDate + 3.day).timeIntervalSince1970 * 1000 ).intValue
        secondSVModel.departureDateFormat = formatter.string(from: (departureDate + 3.day))
        searchConditionArr.append(secondSVModel)
        FlightManager.shareInStance.flightConditionStore(searchConditionArr: searchConditionArr)
        searchView.fillMoreTripDataSources(dataSoureces: FlightManager.shareInStance.flightConditionDraw())
        if baseBackgroundScrollView.contentOffset.y != 0 {
          baseBackgroundScrollView.contentOffset = CGPoint.zero
        }
    }
    
    func searchViewMoreTripDeleteTrip(deleteCell:NSInteger) {
        var searchConditionArr = FlightManager.shareInStance.flightConditionDraw()
        guard searchConditionArr.count > deleteCell else {
            return
        }
        let deleteTrip = searchConditionArr[deleteCell]
        var afterTrip = FlightSVSearchConditionModel()//searchConditionArr[deleteCell]
        if deleteCell == 0  {
            afterTrip = searchConditionArr[1]
            afterTrip.returnDate = deleteTrip.returnDate
            afterTrip.returnDateFormat = deleteTrip.returnDateFormat
            searchConditionArr.remove(at: deleteCell)
            searchConditionArr[0] = afterTrip
        }else{
            searchConditionArr.remove(at: deleteCell)
        }
        
        FlightManager.shareInStance.flightConditionStore(searchConditionArr: searchConditionArr)
        searchView.fillMoreTripDataSources(dataSoureces: FlightManager.shareInStance.flightConditionDraw())
        flightSVSearchViewServicesTypeAction(servicesType: FlightSVSearchView.FlightServicesRouteType.MoreTrip ,sumRow: searchConditionArr.count)
    }
    
    
    
    
    func intoNextAirportView(airPortType:FlightSVSearchView.FlightSVSearchViewServicesType,index:NSInteger) {
        weak var weakSelf = self
        let airportView = CityAndAirportSVViewController()
        airportView.cityAndAirportSVViewSelectedResultBlock = { airport in
           weakSelf?.flightModifyAirport(airport: airport, airPortType: airPortType, cellIndex: index)
        }
        self.navigationController?.pushViewController(airportView, animated: true)
    }

    func  initJumpCommonFooterView () {
        
        jumpList = [(title:"酒店",image:"ic_menu_hotle",type:.Hotel,isClick:true)
            ,(title:"火车票",image:"ic_menu_train",type:.Train,isClick:true)
            ,(title:"专车",image:"ic_menu_car",type:.Car,isClick:true)]
        guard let userInfo =  DBManager.shareInstance.userDetailDraw()  else {
            return
        }
        
        if userInfo.busLoginInfo.resourceList.contains(where: { (element) -> Bool in
            if element.resourceRegex == FrontHotel { return true }
            else { return false }
            
        })  == false {
            jumpList[0] = (title:"酒店",image:"ic_menu_hotle_gray",type:.Hotel,isClick:false)
           
        }
        if userInfo.busLoginInfo.resourceList.contains(where: { (element) -> Bool in
            if element.resourceRegex == FrontTrain { return true }
            else { return false }
            
        }) ==  false  {
            jumpList[1] = (title:"火车票",image:"ic_menu_train_gray",type:.Train,isClick:false)
        }
        if userInfo.busLoginInfo.resourceList.contains(where: { (element) -> Bool in
            if element.resourceRegex == FrontCar { return true }
            else { return false }
            
        }) ==  false {
            jumpList[2] = (title:"专车",image:"ic_menu_car_gray",type:.Car,isClick:false)
        }
        
        flightViewServicesCategoryView.fullCell(data:jumpList)
        flightViewServicesCategoryView.coBusinessTypeListener = self
        subBaseBackgroundView.addSubview(flightViewServicesCategoryView)
        flightViewServicesCategoryView.snp.makeConstraints { (make) in
           make.top.equalTo(searchView.snp.bottom).offset(5)
            make.left.right.equalToSuperview()
            make.height.equalTo(77)
            
        }
//        flightViewServicesCategoryView.snp.remakeConstraints({ (make) in
//            make.top.equalTo(searchView.snp.bottom).offset(10)
//            make.left.right.equalToSuperview()
//            make.height.equalTo(77)
//        })
    }
    
    ///  监听跳转
    func onClickListener(type:CoCompanyBusinessType) -> Void {
        switch type {
        case .Hotel:
            let vc = HotelSVCompanySearchViewController()
            vc.travelNo = self.travelNo ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        case .Train:
            let vc = CoTrainSearchViewController()
            vc.travelNo = self.travelNo ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        case .Car:
            let vc = CoCarSearchViewController()
            vc.travelNo = self.travelNo
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    
    
    func searchAction() {
        let searchListView = FlightBusinessSearchListViewController()
        // 更改 航班 行程的 服务类型 操作 已经 实时同步
        var searchConditionArr = FlightManager.shareInStance.flightConditionDraw()
        let firstSearchCondition = searchConditionArr.first
        firstSearchCondition?.type = self.searchView.getFlightServicesRouteType().rawValue
        firstSearchCondition?.maxTripInt = searchConditionArr.count
        firstSearchCondition?.currentTripSection = 1
        searchConditionArr[0] = firstSearchCondition!
        FlightManager.shareInStance.flightConditionStore(searchConditionArr: searchConditionArr)
        searchListView.travelNo = self.travelNo
        self.navigationController?.pushViewController(searchListView, animated: true)
    }
    
    
    override func backButtonAction(sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    func policyView() {
        let backButton1 = UIButton(frame:CGRect(x:0,y:0,width:62,height:30))
        backButton1.setTitle("差旅标准", for: .normal)
        backButton1.titleLabel?.textColor = TBIThemeWhite
        backButton1.titleLabel?.font  = UIFont.systemFont(ofSize: 12)
        backButton1.layer.cornerRadius = 15
        backButton1.backgroundColor = TBIThemeBackgroundViewColor
        let backBarButton1 = UIBarButtonItem.init(customView: backButton1)
        backButton1.addTarget(self, action: #selector(rightItemClick(sender:)), for: UIControlEvents.touchUpInside)
        navigationItem.rightBarButtonItem = backBarButton1
    }
    
    func rightItemClick(sender:UIButton){
        let vi = CoPolicyView(frame: ScreenWindowFrame)
        let policy:String = PassengerManager.shareInStance.passengerSVDraw().first?.airPolicyShow ?? ""
        var modifyPolicy:[String] = Array()
        var resultPolicy:String = ""
        if policy.isEmpty == false {
            modifyPolicy = policy.components(separatedBy: "。")
            for element in modifyPolicy {
                resultPolicy += element + "\n"
            }
        }
        vi.fullData(title: "机票预订差旅标准",subTitle:"符合差旅标准席别:", content:resultPolicy)
        KeyWindow?.addSubview(vi)
    }

}

