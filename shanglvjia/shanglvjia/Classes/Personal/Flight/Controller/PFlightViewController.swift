//
//  PSpecialOfferFlightViewController.swift
//  shanglvjia
//
//  Created by manman on 2018/7/27.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import SwiftDate

class PFlightViewController: PersonalBaseViewController {

    
    public var flightViewType:FlightCommonSearchViewENUM = FlightCommonSearchViewENUM.Default
    
    private let topImageView:UIImageView = UIImageView()
    private let baseBackgroundScrollView:UIScrollView = UIScrollView()
    private let subBaseBackgroundView:UIView = UIView()
    
    private var servicesPhoneView:TBIServicesPhoneView = TBIServicesPhoneView()
    private let searchView:PersonalFlightSVSearchView = PersonalFlightSVSearchView()
    
    public var personalOnsaleFlightListViewType:AppModelCatoryENUM = AppModelCatoryENUM.PersonalFlight
    
      /// 预订规划时间
    private var flightServicesStartDate:Date = Date()
    
    private var flightServicesEndDate:Date = Date()
    
    override func viewWillAppear(_ animated: Bool) {
        initNavigation(title:"",bgColor:TBIThemeBlueColor,alpha:0,isTranslucent:true)
        setNavigationBackButton(backImage: "BackCircle")
        searchView.fillMoreTripDataSources(dataSoureces: PCommonFlightManager.shareInStance.flightConditionDraw())
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = TBIThemeBaseColor
        self.view.addSubview(baseBackgroundScrollView)
        baseBackgroundScrollView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        self.automaticallyAdjustsScrollViewInsets = false
        if #available(iOS 11.0, *) {
            self.baseBackgroundScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        } else {
            // Fallback on earlier versions
        }
        self.navigationController?.extendedLayoutIncludesOpaqueBars = false
        
        baseBackgroundScrollView.bounces = false
        
        baseBackgroundScrollView.showsHorizontalScrollIndicator = false
        var contentHeight:CGFloat = ScreentWindowHeight
        if ScreentWindowHeight < 667 {
            contentHeight = 667
        }
        subBaseBackgroundView.frame = CGRect.init(x: 0, y: 0, width: ScreenWindowWidth, height: contentHeight)
        baseBackgroundScrollView.addSubview(subBaseBackgroundView)
        baseBackgroundScrollView.contentSize = CGSize.init(width: ScreenWindowWidth, height: contentHeight)
        setUIviewAutolayout()
        if flightViewType == .Default {fillLocalDataSources()}
        searchView.fillMoreTripDataSources(dataSoureces: PCommonFlightManager.shareInStance.flightConditionDraw())
        //         policyView()
    }
    
    func setUIviewAutolayout() {
        topImageView.image = UIImage.init(named: "banner_air")
        topImageView.contentMode = UIViewContentMode.scaleToFill
         subBaseBackgroundView.addSubview(topImageView)
        topImageView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(180)
        }
        
        let flightServicesViewType:PersonalFlightSVSearchView.FlightServicesViewType = PersonalFlightSVSearchView.FlightServicesViewType.DefTakeOffTime
        searchView.flightSearchViewType = flightViewType
        subBaseBackgroundView.addSubview(searchView)
        searchView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(135)
            make.left.right.equalToSuperview()
            make.height.equalTo(325)
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
        
        searchView.childDescriptionBlock = { _ in
            popPersonalNewAlertView(content: "儿童婴儿说明", titleStr: "儿童婴儿说明", btnTitle: "确定")
        }
        
        
        subBaseBackgroundView.addSubview(servicesPhoneView)
        servicesPhoneView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(100)
            make.bottom.equalToSuperview()
        }
//        if (UserDefaults.standard.object(forKey: servicesPhoneAir) as! String).isEmpty == false {
//            let workPhone:String = UserDefaults.standard.object(forKey: servicesPhoneAir) as! String
//            if workPhone.isEmpty == false {
//                servicesPhoneView.fillDataSource(workPhone: workPhone, overtimePhone: "")
//            }
//        }else
//        {
//            servicesPhoneView.isHidden = true
//        }
        servicesPhoneView.isHidden = true
    }
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
        PCommonFlightManager.shareInStance.flightConditionStore(searchConditionArr:[firstSVSearchModel,secondSVSearchModel])
    }
     //MARK:-----------Action---------
    /// 交换 起始地点
    func flightSVSearchViewExchangeAddressPointAction(cellIndex:NSInteger) {
        guard PCommonFlightManager.shareInStance.flightConditionDraw().count > cellIndex  else {
            return
        }
        var searchConditionArr = PCommonFlightManager.shareInStance.flightConditionDraw()
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
        PCommonFlightManager.shareInStance.flightConditionStore(searchConditionArr:searchConditionArr)
        searchView.fillMoreTripDataSources(dataSoureces: PCommonFlightManager.shareInStance.flightConditionDraw())
    }
    /// 航班 行程  例如 单程  往返 多程
    func flightSVSearchViewServicesTypeAction(servicesType:PersonalFlightSVSearchView.FlightServicesRouteType,sumRow:NSInteger) {
        //如果时间是0不显示time
        if servicesType == PersonalFlightSVSearchView.FlightServicesRouteType.RoundTrip {
            searchView.snp.remakeConstraints({ (make) in
                make.top.equalToSuperview().inset(135)
                make.left.right.equalToSuperview()
                make.height.equalTo(325)
            })
        }else if servicesType == PersonalFlightSVSearchView.FlightServicesRouteType.OneWay {
            searchView.snp.remakeConstraints({ (make) in
                make.top.equalToSuperview().inset(135)
                make.left.right.equalToSuperview()
                make.height.equalTo(325)
            })
        }else if servicesType == PersonalFlightSVSearchView.FlightServicesRouteType.MoreTrip{
            searchView.snp.remakeConstraints({ (make) in
                make.top.equalToSuperview().inset(135)
                make.left.right.equalToSuperview()
                make.height.equalTo(345 + 44 + (sumRow - 2)  * 110)
            })
            
        }
        var contentHeight:CGFloat = 0
        if PersonalFlightSVSearchView.FlightServicesRouteType.MoreTrip == servicesType && sumRow > 2 {
            contentHeight = ScreentWindowHeight + 50 + CGFloat((sumRow - 2) * 110)
            
        }else
        {
            if ScreentWindowHeight < 667 {
                contentHeight = 667
            }else {
                contentHeight = ScreentWindowHeight
            }
            
        }
        
        if PersonalFlightSVSearchView.FlightServicesRouteType.MoreTrip == servicesType && sumRow == 2  {
            contentHeight = 736
        }
        baseBackgroundScrollView.contentSize = CGSize.init(width: ScreenWindowWidth, height:contentHeight)

        
        subBaseBackgroundView.frame = CGRect.init(x: 0, y: 0, width: ScreenWindowWidth, height: contentHeight)
        
        printDebugLog(message: "debug info")
        printDebugLog(message: searchView.frame)
        printDebugLog(message: servicesType)
        printDebugLog(message: contentHeight)
        printDebugLog(message: subBaseBackgroundView.frame)
        printDebugLog(message: baseBackgroundScrollView.contentSize)
    }
    
    func changesearchModelValue(servicesType:PersonalFlightSVSearchView.FlightSVSearchViewServicesType,cellIndex:NSInteger) {
        switch servicesType {
        case PersonalFlightSVSearchView.FlightSVSearchViewServicesType.startCity:
            intoNextAirportView(airPortType:.startCity ,index: cellIndex)
        case PersonalFlightSVSearchView.FlightSVSearchViewServicesType.arriveCity:
            intoNextAirportView(airPortType:.arriveCity ,index: cellIndex)
        case PersonalFlightSVSearchView.FlightSVSearchViewServicesType.startDate:
            self.nextViewTBICalendar(cellIndex: cellIndex)
        case PersonalFlightSVSearchView.FlightSVSearchViewServicesType.arriveDate:
            self.nextViewTBICalendar(cellIndex: cellIndex)
        case .startTime,.arriveTime:
            break
        }
    }
    func intoNextAirportView(airPortType:PersonalFlightSVSearchView.FlightSVSearchViewServicesType,index:NSInteger) {
        weak var weakSelf = self
        let airportView = CityAndAirportSVViewController()
        airportView.cityAndAirportSVViewSelectedResultBlock = { airport in
            weakSelf?.flightModifyAirport(airport: airport, airPortType: airPortType, cellIndex: index)
        }
        self.navigationController?.pushViewController(airportView, animated: true)
    }
    /// 添加行程
    func searchViewMoreTripAddTrip() {
        let formatter:DateFormatter = DateFormatter()
        formatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone?
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        var searchConditionArr = PCommonFlightManager.shareInStance.flightConditionDraw()
        let departureDate:Date = formatter.date(from: (searchConditionArr.last?.departureDateFormat)!)!
        
        let secondSVModel:FlightSVSearchConditionModel = FlightSVSearchConditionModel()
        secondSVModel.takeOffAirportCode = (searchConditionArr.last?.arriveAirportCode ?? "")
        secondSVModel.takeOffAirportName = (searchConditionArr.last?.arriveAirportName ?? "")
        secondSVModel.departureDate = NSNumber.init(value: (departureDate + 3.day).timeIntervalSince1970 * 1000 ).intValue
        secondSVModel.departureDateFormat = formatter.string(from: (departureDate + 3.day))
        searchConditionArr.append(secondSVModel)
        PCommonFlightManager.shareInStance.flightConditionStore(searchConditionArr: searchConditionArr)
        searchView.fillMoreTripDataSources(dataSoureces: PCommonFlightManager.shareInStance.flightConditionDraw())
        if baseBackgroundScrollView.contentOffset.y != 0 {
            baseBackgroundScrollView.contentOffset = CGPoint.zero
        }
    }
    func searchViewMoreTripDeleteTrip(deleteCell:NSInteger) {
        var searchConditionArr = PCommonFlightManager.shareInStance.flightConditionDraw()
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
        
        PCommonFlightManager.shareInStance.flightConditionStore(searchConditionArr: searchConditionArr)
        searchView.fillMoreTripDataSources(dataSoureces: PCommonFlightManager.shareInStance.flightConditionDraw())
        flightSVSearchViewServicesTypeAction(servicesType: PersonalFlightSVSearchView.FlightServicesRouteType.MoreTrip ,sumRow: searchConditionArr.count)
    }
    //MARK:-----------IntonextView---------
    //选择日期
    func nextViewTBICalendar (cellIndex:NSInteger) {
        weak var weakSelf = self
        let vc:TBICalendarViewController = TBICalendarViewController()
        if searchView.getFlightServicesRouteType() == PersonalFlightSVSearchView.FlightServicesRouteType.OneWay ||
            searchView.getFlightServicesRouteType() == PersonalFlightSVSearchView.FlightServicesRouteType.MoreTrip {
            let searchConditionArr = PCommonFlightManager.shareInStance.flightConditionDraw()
            vc.selectedDates =  [searchConditionArr[cellIndex].departureDateFormat]
            vc.isMultipleTap = false
            vc.showDateTitle = [""]
            vc.titleColor = TBIThemePrimaryTextColor
            vc.bacButtonImageName = "back"
            vc.hotelSelectedDateAcomplishBlock = { (parameters,action) in
                weakSelf?.adjustFlightDate(parameters: parameters, action: action, cellIndex: cellIndex)
                weakSelf?.searchView.fillMoreTripDataSources(dataSoureces:PCommonFlightManager.shareInStance.flightConditionDraw())
                
            }
        }else if searchView.getFlightServicesRouteType() == PersonalFlightSVSearchView.FlightServicesRouteType.RoundTrip {
            vc.selectedDates = [PCommonFlightManager.shareInStance.flightConditionDraw().first?.departureDateFormat,
                                PCommonFlightManager.shareInStance.flightConditionDraw().first?.returnDateFormat] as! [String]
            vc.isMultipleTap = true
            vc.calendarAlertType = TBICalendarAlertType.Flight
            vc.calendarTypeAlert = ["请选择去程日期","请选择返程日期"]
            vc.showDateTitle = ["去程","返程"]
            vc.titleColor = TBIThemePrimaryTextColor
            vc.bacButtonImageName = "back"
            vc.hotelSelectedDateAcomplishBlock = { (parameters,action) in
                weakSelf?.adjustFlightDate(parameters: parameters, action: action, cellIndex: cellIndex)
                weakSelf?.searchView.fillMoreTripDataSources(dataSoureces:PCommonFlightManager.shareInStance.flightConditionDraw())
            }
        }
        _ = self.navigationController?.pushViewController(vc, animated: true)
    }
    /// 修改机场信息
    ///
    /// - Parameters:
    ///   - airport: 机场信息
    ///   - airPortType: 机场类型
    ///   - index: 第几段
    func flightModifyAirport(airport:AirportInfoResponseSVModel,
                             airPortType:PersonalFlightSVSearchView.FlightSVSearchViewServicesType,
                             cellIndex:NSInteger) {
        
        var searchConditionArr = PCommonFlightManager.shareInStance.flightConditionDraw()
        let searchCondition = searchConditionArr[cellIndex]
        if  PersonalFlightSVSearchView.FlightSVSearchViewServicesType.startCity == airPortType{
            searchCondition.takeOffAirportCode = airport.airportCode
            searchCondition.takeOffAirportName = airport.airportName
        }else if PersonalFlightSVSearchView.FlightSVSearchViewServicesType.arriveCity == airPortType{
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
        PCommonFlightManager.shareInStance.flightConditionStore(searchConditionArr:searchConditionArr)
        searchView.fillMoreTripDataSources(dataSoureces: PCommonFlightManager.shareInStance.flightConditionDraw())
    }
    /// 调整机票时间
    func adjustFlightDate(parameters:Array<String>?,action:TBICalendarAction,cellIndex:NSInteger) {
        guard action != TBICalendarAction.Back else {
            return
        }
        let formatter:DateFormatter = DateFormatter()
        formatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone?
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        var searchConditionArr = PCommonFlightManager.shareInStance.flightConditionDraw()
        
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
        
        PCommonFlightManager.shareInStance.flightConditionStore(searchConditionArr: searchConditionArr)
    }
    func searchAction() {
        let searchListView = PFlightSearchListViewController()
        // 更改 航班 行程的 服务类型 操作 已经 实时同步
        var searchConditionArr = PCommonFlightManager.shareInStance.flightConditionDraw()
        let firstSearchCondition = searchConditionArr.first
        firstSearchCondition?.type = self.searchView.getFlightServicesRouteType().rawValue
        firstSearchCondition?.maxTripInt = searchConditionArr.count
        firstSearchCondition?.currentTripSection = 1
        searchListView.flightViewType = flightViewType
        searchConditionArr[0] = firstSearchCondition!
        PCommonFlightManager.shareInStance.flightConditionStore(searchConditionArr: searchConditionArr)
        self.navigationController?.pushViewController(searchListView, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func backButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
//    func policyView() {
//        let backButton1 = UIButton(frame:CGRect(x:0,y:0,width:62,height:30))
//        backButton1.setTitle("差旅标准", for: .normal)
//        backButton1.titleLabel?.textColor = TBIThemeWhite
//        backButton1.titleLabel?.font  = UIFont.systemFont(ofSize: 12)
//        backButton1.layer.cornerRadius = 15
//        backButton1.backgroundColor = TBIThemeBackgroundViewColor
//        let backBarButton1 = UIBarButtonItem.init(customView: backButton1)
//        backButton1.addTarget(self, action: #selector(rightItemClick(sender:)), for: UIControlEvents.touchUpInside)
//        navigationItem.rightBarButtonItem = backBarButton1
//    }
//    
//    func rightItemClick(sender:UIButton){
//        let vi = CoPolicyView(frame: ScreenWindowFrame)
//        let policy:String = PassengerManager.shareInStance.passengerSVDraw().first?.airPolicyShow ?? ""
//        var modifyPolicy:[String] = Array()
//        var resultPolicy:String = ""
//        if policy.isEmpty == false {
//            modifyPolicy = policy.components(separatedBy: "。")
//            for element in modifyPolicy {
//                resultPolicy += element + "\n"
//            }
//        }
//        vi.fullData(title: "机票预订差旅标准",subTitle:"符合差旅标准席别:", content:resultPolicy)
//        KeyWindow?.addSubview(vi)
//    }
    


}
