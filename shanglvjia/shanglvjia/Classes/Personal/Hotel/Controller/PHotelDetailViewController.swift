//
//  PHotelDetailViewController.swift
//  shanglvjia
//
//  Created by tbi on 2018/7/31.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import RxSwift
import SwiftDate

class PHotelDetailViewController: PersonalBaseViewController {
    
    
    // 从哪个页面过来
    public var fromWhereView:AppModelCatoryENUM = AppModelCatoryENUM.Default
    
    public var hotelDetailCityName:String = ""
    
    public var hotelDetailCityId:String = ""
    
    public var hotelDetailType:AppModelCatoryENUM = AppModelCatoryENUM.Default
    
    /// 城市
    public var cityId:String = ""
    
    /// 1 预付 2 现付
    public var presaleType:String = ""
    
    public var cordGroup:String = ""
    
    //MARK:---个人 定投酒店 参数
    public var specialHotelItemInfo:SpecialHotelListResponse.SpecialHotelInfo = SpecialHotelListResponse.SpecialHotelInfo()
    
    /// 定投酒店 详细 信息 源数据
    fileprivate var specialHotelDetailInfo:SpecialHotelDetailResponse = SpecialHotelDetailResponse()
    
    fileprivate var specialRoomInfoList:[SpecialHotelDetailResponse.RoomInfo] = Array()
    
    /// 入店
    fileprivate var checkInDate:Date = Date().startOfDay
    
    /// 离店
    fileprivate var checkOutDate:Date = Date().startOfDay
    
    
    
    
    //MARK:-----个人  普通酒店
    
    public var hotelDetailInfo:SpecialHotelListResponse.SpecialHotelInfo = SpecialHotelListResponse.SpecialHotelInfo()
    
    /// 酒店信息 
    public var personalNormalHotel:HotelListNewItem = HotelListNewItem()
    
    fileprivate var hotelNormalDetailInfo:PersonalHotelDetailResult = PersonalHotelDetailResult()
    
    
    fileprivate var detailTableView = UITableView.init(frame:CGRect.zero, style: UITableViewStyle.plain)
    ///导航头
    private var topView:PersonalNavbarTopView = PersonalNavbarTopView()
    
    fileprivate let sepcialHotelDetailHeaderCellIdentify:String = "PSepcialHotelDetailHeaderCellIdentify"
    
    //PersonalHotelDetaiInfolHeaderView
    fileprivate let personalHotelDetailInfoHeaderIdentify:String = "personalHotelDetailInfoHeaderIdentify"
    
    fileprivate let personalHotelDetailTableViewDateHeaderIdentify:String = "personalHotelDetailTableViewDateHeaderIdentify"
    
    fileprivate let personalHotelDetailRoomRateSectionHeaderIdentify:String = "personalHotelDetailRoomRateSectionHeaderIdentify"
    
    fileprivate let personalHotelDetailTableCellIdentify:String = "personalHotelDetailTableCellIdentify"
    
    fileprivate let sepcialHotelDetailTableCellIdentify:String = "sepcialHotelDetailTableCellIdentify"
    
    fileprivate let personalHotelDetaiInfolHeaderView:PersonalHotelDetaiInfolHeaderView = PersonalHotelDetaiInfolHeaderView()
    
    fileprivate var localBookMaxNum:NSInteger = 0
    /// 国内酒店。true 国际酒店 false
    fileprivate var mainLandHotel:Bool = true
    
    private let bag = DisposeBag()
    
    private var localHotelName:String = ""
    
    private var localBackButton:UIButton = UIButton()
    
    
    private var navicationHeaderAlpha:CGFloat = 0
    
    //private var baseBackgroundScrollView:UIScrollView = UIScrollView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initTopView()
        
        setBackButtonAutolayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = TBIThemeWhite
        self.automaticallyAdjustsScrollViewInsets = false
        //self.automaticallyAdjustsScrollViewInsets = false
//        self.view.addSubview(baseBackgroundScrollView)
//        baseBackgroundScrollView.snp.makeConstraints { (make) in
//            make.top.left.bottom.right.equalToSuperview()
//        }
        
        fillLocalDatasouce()
        setUIViewAutolayout()
        
       // NotificationCenter.default.addObserver(self, selector: #selector(initTopView), name:NSNotification.Name(rawValue: GoForeground) , object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //self.navigationController?.navigationBar.alpha = 1
        //self.navigationController?.navigationBar.alpha = 1
    }
    
    func initTopView() {
        
        //initNavigation(title:"",bgColor:PersonalThemeNormalColor,alpha:0,isTranslucent:true)
        //setNavigationBackButton(backImage: "BackCircle")
        //setTitle(titleStr: localHotelName, titleColor: TBIThemePrimaryTextColor)
        setBlackTitleAndNavigationColor(title: localHotelName)
        //setBlackTitleAndNavigationColor(title: localHotelName)
        //self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.alpha = navicationHeaderAlpha
        self.navigationController?.navigationBar.isTranslucent = true
        
        
        printDebugLog(message: "initTopView")
        printDebugLog(message: self.view.frame)
        printDebugLog(message: localBackButton.isHidden == true ? "隐藏":"显示")
    }
    
    //MARK:- 定制视图
    func setUIViewAutolayout() {
        
        setTableViewHeaderViewAutolayout()
        setTableViewAutolayout()
        //initTopView()
        //setBackButtonAutolayout()
    }
    
    func setBackButtonAutolayout() {
        localBackButton.setImage(UIImage(named:"BackCircle"), for: UIControlState.normal)
        localBackButton.addTarget(self, action: #selector(backButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(localBackButton)
        localBackButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset( kNavigationHeight - 44)
            make.left.equalToSuperview().inset( isIPhoneX ? 8 : (ScreenWindowWidth == 375) ? 7 : 11)
            make.width.height.equalTo(44)
        }
        printDebugLog(message: ScreenWindowWidth)
    }
    
    
    func setTableViewHeaderViewAutolayout() {
        weak var weakSelf = self
        personalHotelDetaiInfolHeaderView.frame = CGRect.init(x: 0, y: 0, width: ScreenWindowWidth, height:520)
        
        personalHotelDetaiInfolHeaderView.sepcialHotelDetailHeaderMapNaviBlock = { _ in
            if (weakSelf?.mainLandHotel)!{
                weakSelf?.showMapView()
            }
        }
        personalHotelDetaiInfolHeaderView.sepcialHotelDetailHeaderSelectedDateBlock = { _ in
            weakSelf?.showCalendarView()
        }
        personalHotelDetaiInfolHeaderView.hotelDetailBlock = { _ in
            switch weakSelf?.hotelDetailType {
            case .PersonalHotel?:
                weakSelf?.showHotelDetailView()
            case .PersonalSpecialHotel?:
                if (weakSelf?.specialHotelDetailInfo.specialHotelBaseResponse.hotelDesc.isNotEmpty)! || (weakSelf?.specialHotelDetailInfo.specialHotelBaseResponse.facilitiesV2List.toString().isNotEmpty)! || (weakSelf?.specialHotelDetailInfo.specialHotelBaseResponse.trafficInfo.isNotEmpty)!
                {
                    weakSelf?.showHotelDetailView()
                }
                
            default:
                break
            }
            
        }
        //baseBackgroundScrollView.addSubview(personalHotelDetaiInfolHeaderView)
        fillHeaderViewDataSources()
        self.view.addSubview(personalHotelDetaiInfolHeaderView)
    }
    
    func fillHeaderViewDataSources() {
        switch hotelDetailType {
        case .PersonalHotel:
            personalHotelDetaiInfolHeaderView.fillPersonalNormalHotelDataSources(item:hotelNormalDetailInfo.hotelDetailInfo , checkInDate: checkInDate, checkOutDate: checkOutDate)
        case .PersonalSpecialHotel:
            personalHotelDetaiInfolHeaderView.fillPersonalSpecialHotelDataSources(item: specialHotelItemInfo, checkInDate: checkInDate, checkOutDate: checkOutDate)
        default: break
            
        }
    }
    
    
    func setTableViewAutolayout() {
        detailTableView.delegate = self
        detailTableView.dataSource = self
        detailTableView.bounces = false
        detailTableView.backgroundColor = TBIThemeBaseColor
        detailTableView.separatorStyle = .none
        //detailTableView.estimatedRowHeight = 50
        detailTableView.bounces = false
        detailTableView.register(PersonalHotelDetailDateInfoSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: personalHotelDetailTableViewDateHeaderIdentify)
        detailTableView.register(PersonalHotelDetailRoomRateSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: personalHotelDetailRoomRateSectionHeaderIdentify)
        detailTableView.register(PersonalHotelDetailRoomRateCell.self, forCellReuseIdentifier: personalHotelDetailTableCellIdentify)
        //baseBackgroundScrollView.addSubview( detailTableView)
        self.view.addSubview(detailTableView)
        detailTableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(personalHotelDetaiInfolHeaderView.snp.bottom)//.offset(-kNavigationHeight)
        }
        //detailTableView.tableHeaderView = personalHotelDetaiInfolHeaderView
    }
    
    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//        let touchView:UIView = touches.
//
//
//
//    }
    
    
    
    
    func fillLocalDatasouce(){
        
        switch hotelDetailType {
        case .PersonalSpecialHotel:
            fillPersonalSpecialHotelDataSources()
            localHotelName = specialHotelItemInfo.hotelName
        case .PersonalHotel:
            fillPersonalNormalHotelDataSources()
            localHotelName = hotelNormalDetailInfo.hotelDetailInfo.hotelName
        default:
            break
        }
    }
    
    /// 定投酒店 数据
    func fillPersonalSpecialHotelDataSources() {
        checkInDate = Date().startOfDay
        checkOutDate = checkInDate + 1.day
        personalSpecialHotelDetailInfoNET()
    }
    /// 普通酒店 数据
    func fillPersonalNormalHotelDataSources() {
        let searchCondition = PersonalHotelManager.shareInstance.searchConditionUserDraw()
        
        checkInDate = Date.init(timeIntervalSince1970: TimeInterval(searchCondition.arrivalDate)!/1000)
        checkOutDate = Date.init(timeIntervalSince1970: TimeInterval(searchCondition.departureDate)!/1000)
        personalNormalHotelDetailInfoNET()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:------Show View -----
    
    
    func showCalendarView() {
        switch hotelDetailType {
        case .PersonalHotel:
            showPersonalNormalHotelCalendarView()
        case .PersonalSpecialHotel:
            showPersonalSpecialHotelCalendarView()
        default: break
            
        }
    }
    
    
    
    ///  定投酒店 日历视图
    func showPersonalSpecialHotelCalendarView() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone?
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" //"yyyy-MM-dd HH:mm:ss"
        let arrivalDateFormat = dateFormatter.string(from: checkInDate)
//        searchCondition.arrivalDate = (NSInteger(currentDate.timeIntervalSince1970) * 1000).description
        //searchCondition.departureDate = ((NSInteger((currentDate + 1.day).timeIntervalSince1970)) * 1000).description
        let departureDateFormat = dateFormatter.string(from: checkOutDate)
        let calendarView = TBICalendarViewController()
        calendarView.calendarAlertType = TBICalendarAlertType.PersonalSpecialHotel
        calendarView.calendarTypeAlert = ["请选择入住日期","请选择离店日期"]
        calendarView.selectedDates = [arrivalDateFormat,departureDateFormat] //测试数据
        calendarView.isMultipleTap = true
        calendarView.showDateTitle = ["入住","离店"]
        calendarView.personalSpecialHotelActivetyDay = specialHotelDetailInfo.hotelUsableDateInfos
        weak var weakSelf = self
        calendarView.hotelSelectedDateAcomplishBlock = { (parameters,action) in
            printDebugLog(message: parameters)
            weakSelf?.searchDate(parameters: parameters, action: action)
        }
        self.navigationController?.pushViewController(calendarView, animated: true)
    }
    
    
    
    ///  个人普通酒店 日历 视图
    func showPersonalNormalHotelCalendarView() {
        
        let calendarView = TBICalendarViewController()
        calendarView.calendarAlertType = TBICalendarAlertType.PersonalHotel
        calendarView.calendarTypeAlert = ["请选择入住日期","请选择离店日期"]
        calendarView.selectedDates = [PersonalHotelManager.shareInstance.searchConditionUserDraw().arrivalDateFormat,PersonalHotelManager.shareInstance.searchConditionUserDraw().departureDateFormat] //测试数据
        calendarView.isMultipleTap = true
        calendarView.showDateTitle = ["入住","离店"]
        weak var weakSelf = self
        calendarView.hotelSelectedDateAcomplishBlock = { (parameters,action) in
            printDebugLog(message: parameters)
            weakSelf?.searchDate(parameters: parameters, action: action)
        }
        self.navigationController?.pushViewController(calendarView, animated: true)
    }
    
    
    
    private func searchDate(parameters:Array<String>?,action:TBICalendarAction) {
        guard action == TBICalendarAction.Done else {
            return
        }
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone?
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        checkInDate =  formatter.date(from:(parameters?[0])!)!
        checkOutDate =  formatter.date(from:(parameters?[1])!)!
        switch hotelDetailType {
        case .PersonalHotel:
            normalHotelFilter(checkInDate: checkInDate, checkOutDate: checkOutDate)
        case .PersonalSpecialHotel:
            specialHotelFilter(checkInDate: checkInDate, checkOutDate: checkOutDate)
        default: break
        }
        fillHeaderViewDataSources()
        
    }
    
    
    func specialHotelFilter(checkInDate:Date,checkOutDate:Date) {
        specialRoomInfoList = filterMatchDate(checkInDate: checkInDate, checkOutDate: checkOutDate)
        detailTableView.reloadData()
    }
    
    func normalHotelFilter(checkInDate:Date,checkOutDate:Date) {
        let searchCondition:PersonalNormalHotelListRequest = PersonalHotelManager.shareInstance.searchConditionUserDraw()
        searchCondition.arrivalDateFormat = checkInDate.dateToStringGMTTimezone()//string(custom: "yyyy-MM-dd HH:mm:ss")
        searchCondition.departureDateFormat = checkOutDate.dateToStringGMTTimezone()//.string(custom: "yyyy-MM-dd HH:mm:ss")
        searchCondition.arrivalDate = (NSInteger(checkInDate.timeIntervalSince1970 ) * 1000).description
        searchCondition.departureDate = (NSInteger(checkOutDate.timeIntervalSince1970 ) * 1000).description
        PersonalHotelManager.shareInstance.searchConditionUserStore(searchCondition: searchCondition)
        
        personalNormalHotelDetailInfoNET()

        
    }
    
    
    /// 获得最大可预订房间
    func specialHotelFilterBookMaxNum(checkInDate:Date,checkOutDate:Date,selectedRoom:NSInteger,selectedRoomPlan:NSInteger)->NSInteger {
        guard specialRoomInfoList.isEmpty == false else {
            return 0
        }
        var bookMaxNum:NSInteger = 0
        let checkInDateSecond:NSNumber = NSNumber.init(value: checkInDate.timeIntervalSince1970)
        let checkOutDateSecond:NSNumber = NSNumber.init(value: checkOutDate.timeIntervalSince1970)

        for element in specialRoomInfoList[selectedRoom]
            .ratePlanInfoList[selectedRoomPlan]
            .priceDetailInfoList {
            let presaleStartDateSecond:NSInteger = element.saleDate / 1000
            if checkInDateSecond.intValue == presaleStartDateSecond {
                bookMaxNum = element.inventory
            }
            if checkInDateSecond.intValue <= presaleStartDateSecond &&
                checkOutDateSecond.intValue >= presaleStartDateSecond && bookMaxNum > element.inventory {
                bookMaxNum = element.inventory
            }
        }
        
        return bookMaxNum
    }
    
    /// 进入生单页面
    func showBookInfoView(selectedRoom:NSInteger,selectedRoomPlan:NSInteger) {
 
        switch hotelDetailType {
        case .PersonalHotel:
            localBookMaxNum = 99
            normalHotelIntoBookInfoView(selectedRoom: selectedRoom, selectedRoomPlan: selectedRoomPlan)
        case .PersonalSpecialHotel:
            localBookMaxNum = specialHotelFilterBookMaxNum(checkInDate: checkInDate, checkOutDate: checkOutDate, selectedRoom: selectedRoom, selectedRoomPlan: selectedRoomPlan)
            specialHotelIntoBookInfoView(selectedRoom: selectedRoom, selectedRoomPlan: selectedRoomPlan)
        default:
            break
        }
    }
    
    
    func specialHotelIntoBookInfoView(selectedRoom:NSInteger,selectedRoomPlan:NSInteger) {
        let nextVC:PHotelBookInfoViewController = PHotelBookInfoViewController()
        nextVC.presaleType = specialRoomInfoList[selectedRoom].payType //presaleType
        nextVC.bookMaxRoomNum = localBookMaxNum
        nextVC.specialHotelRoomInfo = specialRoomInfoList[selectedRoom]
        nextVC.specialHotelRoomInfo.selectedPlanInfoIndex = selectedRoomPlan
        nextVC.bookInfoType = AppModelCatoryENUM.PersonalSpecialHotel
        nextVC.checkInDate = checkInDate
        nextVC.checkOutDate = checkOutDate
        nextVC.hotelFax = specialHotelItemInfo.hotelFax
        nextVC.hotelItemInfo = specialHotelItemInfo
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    func normalHotelIntoBookInfoView(selectedRoom:NSInteger,selectedRoomPlan:NSInteger) {
        let nextVC:PHotelBookInfoViewController = PHotelBookInfoViewController()
        nextVC.presaleType = hotelNormalDetailInfo.hotelRoomInfoList[selectedRoom].ratePlanInfoList[selectedRoomPlan].payType//presaleType
        nextVC.bookMaxRoomNum = localBookMaxNum
        nextVC.hotelNormalDetailInfo = hotelNormalDetailInfo
        nextVC.hotelNormalDetailInfo.hotelDetailInfo.cityId = hotelNormalDetailInfo.hotelDetailInfo.cityId
        nextVC.hotelNormalDetailInfo.hotelDetailInfo.cityName = hotelNormalDetailInfo.hotelDetailInfo.cityName
        nextVC.personalNormalHotelRoom = hotelNormalDetailInfo.hotelRoomInfoList[selectedRoom]
        nextVC.personalNormalHotelRoom.selectedPlanInfoIndex = selectedRoomPlan
        nextVC.bookInfoType = AppModelCatoryENUM.PersonalHotel
        nextVC.personalNormalHotelRoom.hotelAddress = hotelNormalDetailInfo.hotelDetailInfo.hotelAddress
        nextVC.checkInDate = checkInDate
        nextVC.checkOutDate = checkOutDate
        self.navigationController?.pushViewController(nextVC, animated: true)
    }

    /// 地图视图
    func showMapView() {
        
        var latitude:String = ""
        var longitude:String = ""
        var distionName:String = ""
        switch  hotelDetailType{
        case .PersonalHotel:
            latitude = hotelNormalDetailInfo.hotelDetailInfo.latitude
            longitude = hotelNormalDetailInfo.hotelDetailInfo.longitude
            distionName = hotelNormalDetailInfo.hotelDetailInfo.hotelName
        case .PersonalSpecialHotel:
            latitude = specialHotelDetailInfo.specialHotelBaseResponse.lat
            longitude = specialHotelDetailInfo.specialHotelBaseResponse.lon
            distionName = specialHotelDetailInfo.specialHotelBaseResponse.hotelName
        default:
            break
        }
        
        mapNavigation(latitude:latitude , longitude: longitude, distionName: distionName)
    }
    /// 地图视图
    func showHotelDetailView() {
        let summaryView = HotelSummaryViewController()
        
       
        ///summaryView.hotelTraffic =  hotelSVDetail.hotelDetailInfo.trafficInfo
        ///summaryView.generalAmenities = hotelSVDetail.hotelDetailInfo.facilitiesV2List.toString()//(hotelDetail.oHotel?.detail?.generalAmenities)!
        
        switch hotelDetailType {
        case .PersonalHotel:
            summaryView.hotelName =  hotelNormalDetailInfo.hotelDetailInfo.hotelName //(hotelDetail.oHotel?.detail?.name)!
            summaryView.hotelDescription = hotelNormalDetailInfo.hotelDetailInfo.hotelDesc//hotelDetail.oHotel?.detail?.description
            summaryView.hotelTraffic =  hotelNormalDetailInfo.hotelDetailInfo.trafficInfo
            summaryView.generalAmenities =  hotelNormalDetailInfo.hotelDetailInfo.facilitiesV2List.toString()//(hotelDetail.oHotel?.detail?.generalAmenities)!
        case .PersonalSpecialHotel:
            summaryView.hotelName =  specialHotelDetailInfo.specialHotelBaseResponse.hotelName //(hotelDetail.oHotel?.detail?.name)!
            summaryView.hotelDescription = specialHotelDetailInfo.specialHotelBaseResponse.hotelDesc//hotelDetail.oHotel?.detail?.description
            summaryView.generalAmenities =  specialHotelDetailInfo.specialHotelBaseResponse.facilitiesV2List.toString()
            summaryView.hotelTraffic = specialHotelDetailInfo.specialHotelBaseResponse.trafficInfo
        default:
            break
        }
        
        
        self.navigationController?.pushViewController(summaryView, animated: true)
    
    }
    
    
    /// 进入 普通酒店 的列表页面
    func showPersonalNormalHotelListView() {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone?
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" //"yyyy-MM-dd HH:mm:ss"
       // let currentDate:Date = (Date() + 1.day).startOfDay
        
        let personalNormalHotelListView = PersonalHotelCommonListViewController()
        personalNormalHotelListView.fromWhere = "detailView"
        PersonalHotelManager.shareInstance.resetAllSearchCondition()
        let personalHotelRequestCondition = PersonalNormalHotelListRequest()
        personalHotelRequestCondition.arrivalDate = NSInteger(checkInDate.timeIntervalSince1970 * 1000).description
        personalHotelRequestCondition.arrivalDateFormat = dateFormatter.string(from: checkInDate)
        //checkInDate.string(custom: "yyyy-MM-dd HH:mm:ss")
        personalHotelRequestCondition.departureDate = NSInteger(checkOutDate.timeIntervalSince1970 * 1000).description
        personalHotelRequestCondition.departureDateFormat = dateFormatter.string(from: checkOutDate)
        //checkOutDate.string(custom: "yyyy-MM-dd HH:mm:ss")
        personalHotelRequestCondition.cityId = cityId //hotelDetailCityId
        personalHotelRequestCondition.cityName = hotelDetailCityName
        PersonalHotelManager.shareInstance.searchConditionUserStore(searchCondition: personalHotelRequestCondition)
        self.navigationController?.pushViewController(personalNormalHotelListView, animated: true)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //let contentOffset = scrollView.contentOffset
        let offsetY = scrollView.contentOffset.y
        let alpha =  offsetY / 136
        navicationHeaderAlpha = alpha
        if alpha >= 1 {
            localBackButton.isHidden = true
        }else {
            localBackButton.isHidden = false
            localBackButton.alpha = 1 - alpha
        }
        
        self.navigationController?.navigationBar.alpha = alpha
        printDebugLog(message: offsetY)
        if offsetY > 0  && offsetY < 450 - 40  - 30 {
            personalHotelDetaiInfolHeaderView.frame = CGRect.init(x: 0, y: -offsetY , width: ScreenWindowWidth, height: 520)
            printDebugLog(message:detailTableView.contentInset)
        }
    }
    
    
    
    //MARK:-------Action ------
    
    override func backButtonAction(sender: UIButton) {
        switch fromWhereView {
        case .PersonalSpecialHotel:
            specialBackView()
        case .PersonalHotel:
            self.navigationController?.popViewController(animated: true)
        default: break
            
        }
        
  
        //self.navigationController?.popViewController(animated: true)
    }
    
    func specialBackView() {
        if mainLandHotel {
            showPersonalNormalHotelListView()
            return
        }
        self.navigationController?.popViewController(animated: true)
        return
    }
    
    
    
    
    //MARK:-------NET------
    
    func personalSpecialHotelDetailInfoNET() {
        let request = SpecialHotelDetailRequest()
        request.corpCode = [PersonalSpecialHotelCorpCode]
        request.endDate = (NSNumber.init(value:(checkInDate.startOfDay + 180.day).timeIntervalSince1970).intValue * 1000).description
        request.hotelId = specialHotelItemInfo.hotelId
        request.startDate = (NSNumber.init(value:checkInDate.startOfDay.timeIntervalSince1970).intValue * 1000).description
        
        weak var weakSelf = self
        PersonalHotelServices.sharedInstance
            .hotelSpecialProductDetail(request: request)
            .subscribe { (event) in
                
                switch event {
                case .next(let result):
                    weakSelf?.specialHotelFillDataSources(response: result)
                case .error(let error):
                    try? weakSelf?.validateHttp(error)
                case .completed:
                    break
                }
            }.addDisposableTo(self.bag)
    }
    
    func personalNormalHotelDetailInfoNET()  {
        let userRequest = PersonalHotelManager.shareInstance.searchConditionUserDraw()
        let detailRequest = PersonalHotelRoomDetailRequest()
        detailRequest.arrivalDate = userRequest.arrivalDate
        detailRequest.departureDate = userRequest.departureDate
        detailRequest.hotelElongId = personalNormalHotel.hotelId
        detailRequest.ownHotelId = personalNormalHotel.hotelOwnId
        detailRequest.corpCode = personalNormalHotel.corpCode
        weak var weakSelf = self
        PersonalHotelServices.sharedInstance
            .personalHotelDetail(request: detailRequest)
            .subscribe { (event) in
                
                switch event {
                case .next(let result):
                    printDebugLog(message: result)
                    weakSelf?.hotelNormalDetailInfo = result
//                    for element in (weakSelf?.hotelNormalDetailInfo.hotelRoomInfoList)! {
//                        element.payType = (weakSelf?.presaleType)!
//                    }
                    if result.hotelRoomInfoList.isEmpty == false && weakSelf?.fromWhereView == .PersonalSpecialHotel {
                        weakSelf?.mainLandHotel = true
                    }
                    
                    weakSelf?.personalHotelDetaiInfolHeaderView.fillPersonalNormalHotelDataSources(item: result.hotelDetailInfo, checkInDate: (weakSelf?.checkInDate)!, checkOutDate: (weakSelf?.checkOutDate)!)
//                    weakSelf?.personalNormalHotel.hotelName = result.hotelDetailInfo.hotelName
//                    weakSelf?.personalNormalHotel.hotelDesc = result.hotelDetailInfo.hotelDesc
//                    weakSelf?.personalNormalHotel.trafficInfo = result.hotelDetailInfo.trafficInfo
                    weakSelf?.personalHotelDetaiInfolHeaderView.lookMapButton.isHidden = false
                    
                    weakSelf?.localHotelName = result.hotelDetailInfo.hotelName
                    weakSelf?.setBlackTitleAndNavigationColor(title: weakSelf?.localHotelName ?? "")
                    weakSelf?.showLookMoreButton()
                    weakSelf?.detailTableView.reloadData()
                case .error(let error):
                    try? weakSelf?.validateHttp(error)
                case .completed:
                    break
                }
            }.addDisposableTo(self.bag)
        
        
        
        
    }
    
    
    func specialHotelFillDataSources(response:SpecialHotelDetailResponse) {
        //printDebugLog(message: result)
        specialHotelDetailInfo = response
        
        if response.roomInfoList.isEmpty == false {
            mainLandHotel = response.roomInfoList.first?.regionType == "1" ? true : false
        }
        if response.hotelUsableDateInfos.isEmpty == false {
            checkInDate = Date.init(timeIntervalSince1970: TimeInterval((response.hotelUsableDateInfos.first?.saleDate)!)/1000)
            checkOutDate = (checkInDate) + 1.day
        }
        
        specialRoomInfoList = filterMatchDate(checkInDate: (checkInDate), checkOutDate: (checkOutDate))
//        personalHotelDetaiInfolHeaderView.fillPersonalSpecialHotelDataSources(item: specialHotelItemInfo, checkInDate: checkInDate,checkOutDate: checkOutDate)
        personalHotelDetaiInfolHeaderView.fillPersonalSpecialHotelDataSources(item: specialHotelDetailInfo.specialHotelBaseResponse, checkInDate: checkInDate, checkOutDate: checkOutDate)
        if mainLandHotel == false{
            personalHotelDetaiInfolHeaderView.lookMapButton.isHidden = true
        }else{
            personalHotelDetaiInfolHeaderView.lookMapButton.isHidden = false
        }
        showLookMoreButton()
        detailTableView.reloadData()
    }
    
    func showLookMoreButton(){
        switch hotelDetailType {
        case .PersonalSpecialHotel:
            if specialHotelDetailInfo.specialHotelBaseResponse.hotelDesc.isEmpty && specialHotelDetailInfo.specialHotelBaseResponse.facilitiesV2List.toString().isEmpty && specialHotelDetailInfo.specialHotelBaseResponse.trafficInfo.isEmpty
            {
               personalHotelDetaiInfolHeaderView.moreButton.isHidden = true
            }
            
        default:
            break
        }
    }
    
    
    
    /// 查找日期合适的房间 产品
    func filterMatchDate(checkInDate:Date,checkOutDate:Date) -> [SpecialHotelDetailResponse.RoomInfo] {
        var roomInfoListCopy = NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self.specialHotelDetailInfo.roomInfoList )) as! [SpecialHotelDetailResponse.RoomInfo]
        let checkInDateSecond:NSNumber = NSNumber.init(value: checkInDate.timeIntervalSince1970)
        let checkOutDateSecond:NSNumber = NSNumber.init(value: checkOutDate.timeIntervalSince1970)
        let duringDays:NSInteger = caculateIntervalDay(fromDate: checkInDate, toDate: checkOutDate)
        //let duringDays:NSInteger = NSInteger(NSNumber.init(value: checkOutDate.timeIntervalSince1970))
        
        roomInfoListCopy = roomInfoListCopy.filter({ (roomElement) -> Bool in
            
            let ratePlanInfoFilterList = roomElement.ratePlanInfoList.filter { (ratePlan) -> Bool in
                var isSuccess:Bool = false
                
                if ratePlan.priceDetailInfoList.count == 0 {
                    return isSuccess
                }
//                let presaleStartDateSecond:NSInteger = (ratePlan.priceDetailInfoList.first?.saleDate ?? 0)! / 1000
//                let presaleEndDateSecond:NSInteger = (ratePlan.priceDetailInfoList.last?.saleDate ?? 0)! / 1000
                var startDateIndex:NSInteger = -1
                for (index,element) in ratePlan.priceDetailInfoList.enumerated(){
                    let tmpPresaleStartDateSecond:NSInteger = (element.saleDate) / 1000
                    if tmpPresaleStartDateSecond == checkInDateSecond.intValue {
                        startDateIndex = index
                        break
                    }
                }
                if startDateIndex == -1 {
                    return isSuccess
                }
                startDateIndex += duringDays
                var tmpCheckoutDate:NSNumber = 0
                // 第一个条件
                if ratePlan.priceDetailInfoList.count >= startDateIndex {
                    tmpCheckoutDate = NSNumber.init(value: ratePlan.priceDetailInfoList[startDateIndex].saleDate / 1000)
                    if tmpCheckoutDate.intValue == checkOutDateSecond.intValue {
                        isSuccess = true
                    }//else {return false}
                }
                // 第二个条件
                let preCheckOutDateSecond:NSNumber = NSNumber.init(value: (checkOutDate - 1.day).timeIntervalSince1970)
                if isSuccess == false &&  checkInDateSecond.intValue <= preCheckOutDateSecond.intValue {
                    for element in ratePlan.priceDetailInfoList {
                        let tmpPresaleStartDateSecond:NSInteger = (element.saleDate) / 1000
                        if tmpPresaleStartDateSecond == preCheckOutDateSecond.intValue {
                            isSuccess = true
                        }
                    }
                }
                
//                }else{return false}
//                if presaleStartDateSecond <= checkOutDateSecond.intValue &&
//                    presaleEndDateSecond >= checkOutDateSecond.intValue
//                {
//                    return true
//                }
                return isSuccess
            }
            roomElement.ratePlanInfoList = ratePlanInfoFilterList
            if roomElement.ratePlanInfoList.count == 0 {
                return false
            }
            return true
        })
        
        return roomInfoListCopy
    }
    
    func caculateIntervalDay(fromDate:Date,toDate:Date) -> NSInteger {
        
        let calendar = NSCalendar.init(identifier: NSCalendar.Identifier.gregorian)
        let result = calendar?.components(NSCalendar.Unit.day, from: fromDate, to: toDate, options: NSCalendar.Options.matchFirst)
        
        return (result?.day)!
    }
    
    

}
extension PHotelDetailViewController:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return caculaterSection()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return caculateRow(section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(caculateSectionHeight(section: section))
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return caculateRowHeight(index: indexPath)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell:PersonalHotelDetailRoomRateCell = tableView.dequeueReusableCell(withIdentifier:personalHotelDetailTableCellIdentify) as! PersonalHotelDetailRoomRateCell
            configCell(cell: cell, indexPath: indexPath)
            weak var weakSelf = self
            cell.personalHotelDetailRoomPlanSelectedBlock = { indexPath in
                weakSelf?.showBookInfoView(selectedRoom: indexPath.section, selectedRoomPlan: indexPath.row)
                
            }
            return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        weak var weakSelf = self
        let sectionRoomView:PersonalHotelDetailRoomRateSectionHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: personalHotelDetailRoomRateSectionHeaderIdentify) as! PersonalHotelDetailRoomRateSectionHeaderView
        configSectionHeaderView(headerView: sectionRoomView, section: section)
        sectionRoomView.moreReturnBlock = { index in
             weakSelf?.updateHotelDataSources(section: index)
        }
        //printDebugLog(message: section)
        return sectionRoomView
       
    }
    
    //MARK:------ConfigCell---------
    func updateHotelDataSources(section:NSInteger) {
        switch hotelDetailType {
        case .PersonalHotel:
            updateNormalHotelDataSources(section:section)//noramlHotelCaculateRow(section: section)
        case .PersonalSpecialHotel:
            updateSpecialHotelDataSources(section:section)//specialHotelCaculateRow(section: section)
        default: break
        }
    }
    
    func updateSpecialHotelDataSources(section:NSInteger) {
        let isOpenFolder =  specialRoomInfoList[section].isFolderOpen
        specialRoomInfoList[section].isFolderOpen = !isOpenFolder
        detailTableView.reloadSections([section], with: UITableViewRowAnimation.none)
    }
    
    func updateNormalHotelDataSources(section:NSInteger) {
        let isOpenFolder =  hotelNormalDetailInfo.hotelRoomInfoList[section].isFolderOpen
        hotelNormalDetailInfo.hotelRoomInfoList[section].isFolderOpen = !isOpenFolder
        detailTableView.reloadSections([section], with: UITableViewRowAnimation.none)
    }
    
    
    func configSectionHeaderView(headerView:PersonalHotelDetailRoomRateSectionHeaderView,section:NSInteger) {
        switch hotelDetailType {
        case .PersonalHotel:
            configNormalHotelSectionHeaderView(headerView:headerView,section: section)//noramlHotelCaculateRow(section: section)
        case .PersonalSpecialHotel:
            configSpecialHotelSectionHeaderView(headerView:headerView,section: section)//specialHotelCaculateRow(section: section)
        default: break
        }
    }
    
    
    func configSpecialHotelSectionHeaderView(headerView:PersonalHotelDetailRoomRateSectionHeaderView,section:NSInteger) {
        //let item = specialRoomInfoList[section]
        headerView.fillSpecialHotelDataSources(model: specialRoomInfoList[section], checkInDate: checkInDate,checkOutDate: checkOutDate, index: section,payType:"1",isShowProtocol:cordGroup)
        
        
    }
    
    func configNormalHotelSectionHeaderView(headerView:PersonalHotelDetailRoomRateSectionHeaderView,section:NSInteger) {
        headerView.fillNormalHotelDataSources(model: hotelNormalDetailInfo.hotelRoomInfoList[section],index: section)
    }
    
    
    
    
    
    /// 计算 row
    
    func caculaterSection() ->NSInteger {
        var row:NSInteger = 0
        switch hotelDetailType {
        case .PersonalHotel:
            row = normalHotelCaculate()//noramlHotelCaculateRow(section: section)
        case .PersonalSpecialHotel:
            row = specialHotelCaculate()//specialHotelCaculateRow(section: section)
        default: break
        }
        return row
    }
    
    func specialHotelCaculate() -> NSInteger {
        return specialRoomInfoList.count
    }
    
    func normalHotelCaculate() -> NSInteger {
        return hotelNormalDetailInfo.hotelRoomInfoList.count
    }
    
    func caculateSectionHeight(section:NSInteger) -> NSInteger {
        var height:NSInteger = 0
        switch hotelDetailType {
        case .PersonalHotel:
            height = normalHotelCaculateSectionHeight(section:section)
        case .PersonalSpecialHotel:
            height = specialHotelCaculateSectionHeight(section:section)
        default: break
        }
        return height
    }
    
    
    func specialHotelCaculateSectionHeight(section:NSInteger) ->NSInteger {
//        if section == 0 {
//            return 55
//        }
        return 90
    }
    
    func normalHotelCaculateSectionHeight(section:NSInteger) ->NSInteger {
       
        return 90
    }
    
    
    func caculateRow(section:NSInteger)->NSInteger {
        var row:NSInteger = 0
        switch hotelDetailType {
        case .PersonalHotel:
            row = noramlHotelCaculateRow(section: section)
        case .PersonalSpecialHotel:
          row = specialHotelCaculateRow(section: section)
        default: break
            
        }
        return row
    }
    
    /// 定投产品
    func specialHotelCaculateRow(section:NSInteger) -> NSInteger {
        
        guard specialRoomInfoList.count > section else {
            return 0
        }
        if specialRoomInfoList[section].isFolderOpen  {
            return specialRoomInfoList[section].ratePlanInfoList.count
        }
        return 0
        
    }
    
    /// 普通产品
    func noramlHotelCaculateRow(section:NSInteger) -> NSInteger {
        guard hotelNormalDetailInfo.hotelRoomInfoList.count > section else {
            return 0
        }
        
        
        if hotelNormalDetailInfo.hotelRoomInfoList[section].isFolderOpen {
            return hotelNormalDetailInfo.hotelRoomInfoList[section].ratePlanInfoList.count
        }
        
        return 0
        
        
    }
    
    /// 计算 高度
    func caculateRowHeight(index:IndexPath) -> CGFloat {
        var rowHeight:CGFloat = 0
        switch hotelDetailType {
        case .PersonalHotel:
            rowHeight = noramlHotelCaculateRowHeight(indexPath: index)
        case .PersonalSpecialHotel:
            rowHeight = specialHotelCaculateRowHeight(indexPath: index)
        default: break
        
        }
        return rowHeight
    }
    /// 定投产品 计算 高度
    func specialHotelCaculateRowHeight(indexPath:IndexPath) -> CGFloat {
         return 45

    }
    
    /// 普通产品 计算 高度
    func noramlHotelCaculateRowHeight(indexPath:IndexPath) -> CGFloat {
        return 45
    }
    
    
    /// header 配置信息
    func configHotelDetailInfoHeaderView(header:PersonalHotelDetaiInfolHeaderView) {
        switch hotelDetailType {
        case .PersonalHotel:
            configNormalHotelHeaderView(header: header)
        case .PersonalSpecialHotel:
            configSpecialHotelHeaderView(header:header)
        default:
            break
        }
    }
    /// header 配置信息 定投酒店
    func configSpecialHotelHeaderView(header:PersonalHotelDetaiInfolHeaderView) {
        personalHotelDetaiInfolHeaderView.fillPersonalSpecialHotelDataSources(item: specialHotelItemInfo, checkInDate: checkInDate,checkOutDate: checkOutDate)
        //header.fillPersonalNormalHotelDataSources(item: specialHotelItemInfo)
        //cell.fillPersonalSpecialHotelDataSources(item: specialHotelItemInfo,checkInDate:checkInDate ,checkOutDate:checkOutDate)
    }
    
    ///  header 配置信息  个人酒店
    func configNormalHotelHeaderView(header:PersonalHotelDetaiInfolHeaderView) {
//        let checkInDateSecond:NSNumber = NSNumber.init(value: checkInDate.timeIntervalSince1970)
//        let checkInDate:Date = Date.init(timeIntervalSince1970: TimeInterval(checkInDateSecond.intValue / 1000))
//        let checkOutDateSecond:NSNumber = NSNumber.init(value: NSInteger(PersonalHotelManager.shareInstance.searchConditionUserDraw().arrivalDate)!)
//        let checkOutDate:Date = Date.init(timeIntervalSince1970: TimeInterval(checkOutDateSecond.intValue / 1000))
        personalHotelDetaiInfolHeaderView.fillPersonalNormalHotelDataSources(item: hotelNormalDetailInfo.hotelDetailInfo, checkInDate: checkInDate,checkOutDate: checkOutDate)
        //cell.fillPersonalNormalHotelDataSources(item: personalNormalHotel, checkInDate:checkInDate , checkOutDate: checkOutDate)
    }
    
    
    func configHotelDetailDateHeaderView(headerView:PersonalHotelDetailDateInfoSectionHeaderView ,checkinDate firstDate:Date,checkoutDate secondDate:Date) {
        switch hotelDetailType {
        case .PersonalHotel:
            normalHotelDetailDate(headerView: headerView, checkinDate: firstDate, checkoutDate: secondDate)
        case .PersonalSpecialHotel:
            specialHotelDetailDate(headerView: headerView, checkinDate: firstDate, checkoutDate: secondDate)
        default:
            break
        }
        
    }
    
    
    func specialHotelDetailDate(headerView:PersonalHotelDetailDateInfoSectionHeaderView, checkinDate firstDate:Date,checkoutDate secondDate:Date) {
        headerView.fillDataSources(checkInDate: firstDate, checkOutDate: secondDate)
    }
    func normalHotelDetailDate(headerView:PersonalHotelDetailDateInfoSectionHeaderView, checkinDate firstDate:Date,checkoutDate secondDate:Date) {
        headerView.fillDataSources(checkInDate: firstDate, checkOutDate: secondDate)
    }
    func configCell(cell:PersonalHotelDetailRoomRateCell,indexPath:IndexPath) {
        switch hotelDetailType {
        case .PersonalHotel:
            configNormalHotelCell(cell: cell, indexPath: indexPath)
        case .PersonalSpecialHotel:
            configSpecialHotelCell(cell: cell, indexPath: indexPath)
        default:
            break
        }
    }
    
    func configSpecialHotelCell(cell:PersonalHotelDetailRoomRateCell,indexPath:IndexPath) {
        ///传model
        if specialRoomInfoList.count > indexPath.section {
            let item = specialRoomInfoList[indexPath.section].ratePlanInfoList[indexPath.row]
            let averageRate:String = caculateRoomPlanAverageRate(roomSaleInfo: item, checkInDate: checkInDate, checkOutDate: checkOutDate)
            cell.fillDataSources(title: item.ratePlanName, prices: averageRate, index: indexPath, productRemark:item.productRemark, isShowProtocol: cordGroup, payType: "1")
//            weak var weakSelf = self
//
//            cell.personalHotelDetailRoomPlanSelectedBlock = { section in
//                weakSelf?.updateHotelDataSources(section: section)
//
//            }
        }
        
    }
    
    func configNormalHotelCell(cell:PersonalHotelDetailRoomRateCell,indexPath:IndexPath) {
        if hotelNormalDetailInfo.hotelRoomInfoList.count > 0 {
            let item = hotelNormalDetailInfo.hotelRoomInfoList[indexPath.section].ratePlanInfoList[indexPath.row]
            cell.fillDataSources(title: item.ratePlanName, prices: item.rate.TwoOfTheEffectiveFraction(), index: indexPath, productRemark:item.refundDesc, isShowProtocol: item.corpCode, payType: item.payType)
                //weak var weakSelf = self
           
        }
    }
    
    
    /// 计算 产品 的平均价
    func caculateRoomPlanAverageRate(roomSaleInfo:SpecialHotelDetailResponse.RatePlanInfo,checkInDate:Date,checkOutDate:Date) -> String{
        let checkInDateSecond:NSNumber = NSNumber.init(value: checkInDate.timeIntervalSince1970)
        let checkOutDateSecond:NSNumber = NSNumber.init(value: checkOutDate.timeIntervalSince1970)
        
        var roomAmount:Float = 0
        var tmpRoomAmount:Float = 0
        for priceElement in roomSaleInfo.priceDetailInfoList {
            
            if priceElement.saleDate / 1000 >= checkInDateSecond.intValue && priceElement.saleDate / 1000 < checkOutDateSecond.intValue {
                tmpRoomAmount += priceElement.saleRate
            }
        }
        if roomAmount == 0 {
            roomAmount = tmpRoomAmount
        }
        if roomAmount != 0 && roomAmount > tmpRoomAmount && tmpRoomAmount != 0 {
            roomAmount = tmpRoomAmount
        }
        //let bookRoomDays:NSNumber = NSNumber.init(value: checkOutDate.timeIntervalSince1970)
        let bookRoomDays:NSNumber = NSNumber.init(value:caculateIntervalDay(fromDate: checkInDate, toDate: checkOutDate))
        return ceil(roomAmount / bookRoomDays.floatValue).OneOfTheEffectiveFraction()
    }
//    private func caculateIntervalDay(fromDate:Date,toDate:Date) -> NSInteger {
//
//        let calendar = NSCalendar.init(identifier: NSCalendar.Identifier.gregorian)
//        let result = calendar?.components(NSCalendar.Unit.day, from: fromDate, to: toDate, options: NSCalendar.Options.matchFirst)
//
//        return (result?.day)!
//    }
    
    
//    func configSpecialHotelCell(cell:PSepcialHotelDetailListCell,indexPath:IndexPath) {
//        ///传model
//        if specialRoomInfoList.count > 0 {
//            cell.fillSpecialHotelDataSources(model: specialRoomInfoList[indexPath.row], checkInDate: checkInDate,checkOutDate: checkOutDate, index: indexPath.row,payType:"1",isShowProtocol:cordGroup)
//        }
//
//    }
//
//    func configNormalHotelCell(cell:PSepcialHotelDetailListCell,indexPath:IndexPath) {
//        if hotelNormalDetailInfo.hotelRoomInfoList.count > 0 {
//            cell.fillNormalHotelDataSources(model: hotelNormalDetailInfo.hotelRoomInfoList[indexPath.row],index: indexPath.row)
//        }
//    }
//
    
    /// 是否展开
    func showMoreRoomPlanView(index:NSInteger) {
        
        switch hotelDetailType {
        case .PersonalHotel:
            normalHotelMoreViewIsOpenFloder(index: index)
        case .PersonalSpecialHotel:
            specialHotelMoreViewIsOpenFloder(index: index)
            
        default:
            break
        }
    }
    
    func specialHotelMoreViewIsOpenFloder(index:NSInteger) {
        guard specialRoomInfoList.count > index else {
            return
        }
        specialRoomInfoList[index].isFolderOpen = !specialRoomInfoList[index].isFolderOpen
        detailTableView.reloadData()
        
        
    }
    func normalHotelMoreViewIsOpenFloder(index:NSInteger) {
        guard hotelNormalDetailInfo.hotelRoomInfoList.count > index else {
            return
        }
        hotelNormalDetailInfo.hotelRoomInfoList[index].isFolderOpen = !hotelNormalDetailInfo.hotelRoomInfoList[index].isFolderOpen
        detailTableView.reloadData()
    }
    
    
    
    
    
    func calculateCellHeight(roomItemSum:NSInteger) ->CGFloat{
        return CGFloat( 90 + 61*(roomItemSum))
    }
    
    
    func mapNavigation(latitude:String , longitude: String, distionName: String) {
        checkInstallMapType(latitude: latitude, longitude: longitude, distionName: distionName)
    }
    
    
   
}
