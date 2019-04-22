//
//  PSpecailOfferHotelViewController.swift
//  shanglvjia
//
//  Created by manman on 2018/7/27.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import RxSwift
import SwiftDate

class PHotelSearchViewController:  PersonalBaseViewController {
    
    fileprivate let bag = DisposeBag()
    
    private let topImageView:UIImageView = UIImageView()
    
     private let searchView:PersonalHotelCommonSearchView = PersonalHotelCommonSearchView()
    
    private let baseBackgroundScrollView:UIScrollView = UIScrollView()
    
    private let subBaseBackgroundView:UIView = UIView()
    
    /// 城市列表
    private var cityGroupList:[HotelCityGroup] = Array()
    private let localTipDefaultCity:String = "天津"
    
    override func viewWillAppear(_ animated: Bool) {
        initNavigation(title:"",bgColor:PersonalThemeNormalColor,alpha:0,isTranslucent:true)
        searchView.fillSearchDataSources(hotelSearchItem: PersonalHotelManager.shareInstance.searchConditionUserDraw())
        setNavigationBackButton(backImage: "BackCircle")
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = TBIThemeBaseColor
        self.view.addSubview(baseBackgroundScrollView)
        baseBackgroundScrollView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        baseBackgroundScrollView.bounces = false
        self.automaticallyAdjustsScrollViewInsets = false
        baseBackgroundScrollView.showsHorizontalScrollIndicator = false
        baseBackgroundScrollView.showsVerticalScrollIndicator = false
        if #available(iOS 11.0, *) {
            self.baseBackgroundScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        } else {
            // Fallback on earlier versions
        }
        var contentHeight:CGFloat = ScreentWindowHeight
        if ScreentWindowHeight < 667 {
            contentHeight = 667
        }
        baseBackgroundScrollView.addSubview(subBaseBackgroundView)
        subBaseBackgroundView.frame = CGRect.init(x: 0, y: 0, width: ScreenWindowWidth, height: contentHeight)
        baseBackgroundScrollView.contentSize = CGSize.init(width: ScreenWindowWidth, height: contentHeight)
        
        fillLocalDataSources()
        setUIViewAutolayout()
    }
    func setUIViewAutolayout()
    {
        topImageView.sd_setImage(with:URL.init(string:"\(Html_Base_Url)/static/banner/subpage/hotel/ios/banner_hotel@3x.png"))
        subBaseBackgroundView.addSubview(topImageView)
        topImageView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(140)
        }
        
        subBaseBackgroundView.addSubview(searchView)
        searchView.snp.remakeConstraints { (make) in
            make.top.equalTo(topImageView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(260 + 55)
        }
        
        weak var weakSelf = self
        searchView.hotelCommonCheckinDateBlock = {(paramater )in
            weakSelf?.showCalendarView(paramater: paramater)
        }
        searchView.hotelCommonSearchCityBlock = {(parameter)in
            weakSelf?.showCityView(parameter: parameter)
        }
        searchView.hotelCommonSearchCompleteBlock =  {(parameters) in
            weakSelf?.searchHotelAction(parameters: parameters)
        }
        searchView.hotelCommonCurrentLocationBlock = { _ in
            
            weakSelf?.getCurrentLocation()
        }
        searchView.hotelCommonChoicesLandMark = { _ in
            weakSelf?.nextViewLandMark()
        }
        searchView.hotelCommonClearLandMarkBlock = {
            weakSelf?.clearLandMarkAction()
        }
        

    }
    func fillLocalDataSources(){
        let searchCondition = PersonalHotelManager.shareInstance.searchConditionUserDraw()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone?
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" //"yyyy-MM-dd HH:mm:ss"
        let currentDate:Date = Date().startOfDay
        searchCondition.arrivalDateFormat = dateFormatter.string(from: currentDate)
        searchCondition.arrivalDate = (NSInteger(currentDate.timeIntervalSince1970) * 1000).description
        searchCondition.departureDate = ((NSInteger(currentDate.addingTimeInterval(24 * 60 * 60).timeIntervalSince1970)) * 1000).description
        searchCondition.departureDateFormat = dateFormatter.string(from: (currentDate.addingTimeInterval(24 * 60 * 60)))
        PersonalHotelManager.shareInstance.searchConditionUserStore(searchCondition: searchCondition)
        getHotelCity()
        //cityModeldataSourcesNETGroup()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func testFirst() {
//
//        let path = UIBezierPath()
//        let circleCenter = self.view.center
//        path.move(to: CGPoint.init(x: circleCenter.x + 50, y: circleCenter.y))
//        path.addArc(withCenter: circleCenter, radius: 50, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
//        path.
//
//        -(void)checkFillRule{
//            UIBezierPath *path = [[UIBezierPath alloc] init];
//            CGPoint circleCenter = self.view.center;
//            [path moveToPoint:CGPointMake(circleCenter.x + 50, circleCenter.y)];
//            [path addArcWithCenter:circleCenter radius:50 startAngle:0 endAngle:2*M_PI clockwise:YES];
//            [path moveToPoint:CGPointMake(circleCenter.x + 100, circleCenter.y)];
//            [path addArcWithCenter:circleCenter radius:100 startAngle:0 endAngle:2*M_PI clockwise:YES];
//            [path moveToPoint:CGPointMake(circleCenter.x + 150, circleCenter.y)];
//            [path addArcWithCenter:circleCenter radius:150 startAngle:0 endAngle:2*M_PI clockwise:YES];
//
//            //create shape layer
//            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//            shapeLayer.strokeColor = [UIColor redColor].CGColor;
//            shapeLayer.fillColor = [UIColor greenColor].CGColor;
//            shapeLayer.fillRule = kCAFillRuleNonZero;
//            //shapeLayer.fillRule = kCAFillRuleEvenOdd;
//
//            shapeLayer.lineWidth = 5;
//            shapeLayer.lineJoin = kCALineJoinBevel;
//            shapeLayer.lineCap = kCALineCapRound;
//            shapeLayer.path = path.CGPath;
//
//            //add it to our view
//            [self.view.layer addSublayer:shapeLayer];
//        }
//
//    }
//
    
    
    
    override func backButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    //MARK: ------------ Into next view
    /// 展示 日历
    func showCalendarView(paramater:Dictionary<String,Any>) {
        nextViewTBICalendar(paramater: paramater)
    }
    func nextViewTBICalendar(paramater:Dictionary<String, Any>) {
        
        
        let calendarView = TBICalendarViewController()
        calendarView.calendarAlertType = TBICalendarAlertType.PersonalHotel
        calendarView.calendarTypeAlert = ["请选择入住日期","请选择离店日期"]
        calendarView.selectedDates = [PersonalHotelManager.shareInstance.searchConditionUserDraw().arrivalDateFormat,
                                      PersonalHotelManager.shareInstance.searchConditionUserDraw().departureDateFormat]
        calendarView.isMultipleTap = true
        calendarView.showDateTitle = ["入住","离店"]
        weak var weakSelf = self
        calendarView.hotelSelectedDateAcomplishBlock = { (parameters,action) in
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
        let searchCondition:PersonalNormalHotelListRequest = PersonalHotelManager.shareInstance.searchConditionUserDraw()
        searchCondition.arrivalDateFormat = (parameters?[0])!
        searchCondition.departureDateFormat = (parameters?[1])!
        searchCondition.arrivalDate = (NSInteger(formatter.date(from:(parameters?[0])!)?.timeIntervalSince1970 ?? 0) * 1000).description
        searchCondition.departureDate = (NSInteger(formatter.date(from:(parameters?[1])!)?.timeIntervalSince1970 ?? 0) * 1000).description
        
        PersonalHotelManager.shareInstance.searchConditionUserStore(searchCondition: searchCondition)
        searchView.fillSearchDataSources(hotelSearchItem: searchCondition)
    }
    
    /// 展示  城市
    func showCityView(parameter:String) {
        weak var weakSelf = self
        let citySelectorViewController = CitySelectorViewController()
        citySelectorViewController.cityShowType = CitySelectorViewController.CityType.CityType_Hotel
        citySelectorViewController.citySelectorBlock = { (cityName,elongId) in
            print(cityName)
            weakSelf?.modifyCity(cityName: cityName, cityId: elongId)
        }
        citySelectorViewController.setCityType(type: .hotelCity)
        citySelectorViewController.hotelCity = cityGroupList
        weakSelf?.navigationController?.pushViewController(citySelectorViewController, animated: true)
    }
    func modifyCity(cityName:String,cityId:String) {
        if cityId.contains("_") == true {
            
            getPrefecturelevelCity(cityId: cityId)
        }else {
            getLandmark(cityId: cityId)
        }
      
        let searchCondition:PersonalNormalHotelListRequest = PersonalHotelManager.shareInstance.searchConditionUserDraw()

        searchCondition.cityId = cityId
        searchCondition.cityName = cityName
        searchCondition.longitude = 0
        searchCondition.latitude = 0
        searchCondition.searchRegion = ""
        searchCondition.districtId = ""
        searchCondition.districtRegion = CityCategoryRegionModel.RegionModel()
        searchCondition.landmarkId  = ""
        searchCondition.landmarkRegion = CityCategoryRegionModel.RegionModel()
        searchCondition.commericalId = ""
        searchCondition.commericalRegion = CityCategoryRegionModel.RegionModel()
        PersonalHotelManager.shareInstance.searchConditionUserStore(searchCondition: searchCondition)
        searchView.fillSearchDataSources(hotelSearchItem:searchCondition)
        
    }
    
    // MARK:--------Action-------
    func clearLandMarkAction() {
        let searchCondition:PersonalNormalHotelListRequest = PersonalHotelManager.shareInstance.searchConditionUserDraw()
        guard searchCondition.searchRegion.isEmpty == false else {
            return
        }
        
        searchCondition.districtRegion = CityCategoryRegionModel.RegionModel()
        searchCondition.districtId = ""
        searchCondition.landmarkRegion = CityCategoryRegionModel.RegionModel()
        searchCondition.landmarkId = ""
        searchCondition.landmarkName = ""
        searchCondition.commericalRegion = CityCategoryRegionModel.RegionModel()
        searchCondition.commericalId = ""
        searchCondition.searchRegion = ""
        PersonalHotelManager.shareInstance.searchConditionUserStore(searchCondition: searchCondition)
        searchView.fillSearchDataSources(hotelSearchItem: PersonalHotelManager.shareInstance.searchConditionUserDraw())
    }
    
    
    
    //MARK:------------NET---------
    
    
    func cityModeldataSourcesNETGroup() {
//        let dispacthGroup = DispatchGroup()
//        let dispatchQueen = DispatchQueue.init(label: "cityModeldataSourcesNETGroup")
//        self.showLoadingView()
//        dispatchQueen.sync {
//            printDebugLog(message: "1")
//            self.getHotelCity()
//        }
//        dispatchQueen.sync {
//            printDebugLog(message: "2")
//            self.getCurrentLocation()
//        }
//        dispatchQueen.sync {
//            printDebugLog(message: "3")
//            let elongId = PersonalHotelManager.shareInstance.searchConditionUserDraw().cityId
//            getLandmark(cityId: elongId)
//        }
//        dispatchQueen.sync {
//            printDebugLog(message: "4")
//            DispatchQueue.main.async {
//                self.hideLoadingView()
//            }
//        }
        
//        dispatchQueen.async(group: dispacthGroup, qos: DispatchQoS.default, flags: []) {
//            printDebugLog(message: "1")
//            self.getHotelCity()
//        }
//        dispatchQueen.async(group: dispacthGroup, qos: DispatchQoS.default, flags: []) {
//            printDebugLog(message: "1")
//            self.getCurrentLocation()
//        }
//        dispatchQueen.async(group: dispacthGroup, qos: DispatchQoS.default, flags: []) {
//            let elongId = PersonalHotelManager.shareInstance.searchConditionUserDraw().cityId
//            self.getLandmark(cityId: elongId)
//            printDebugLog(message: "1")
//        }
//        dispacthGroup.notify(queue: DispatchQueue.main) {
//            self.hideLoadingView()
//        }
        
        
        
    }
    
    
    
    ///  获得酒店城市
    func getHotelCity() {
        if let cityModelData = UserDefaults.standard.object(forKey: PersonalNormalHotelCityKey) {
            let userModel:[HotelCityModel] = NSKeyedUnarchiver.unarchiveObject(with: cityModelData as! Data) as! [HotelCityModel]
            fillLocalHotelCity(cityModels: userModel)
            getCurrentLocation()
            return
        }
        ///showLoadingView()
        weak var weakSelf = self
        CityService.sharedInstance
            .getHotelCity()
            .subscribe{ event in
                weakSelf?.hideLoadingView()
                switch event{
                case .next(let e):
                    weakSelf?.fillLocalHotelCity(cityModels: e)
//                    weakSelf?.cityGroupList = (weakSelf?.hotelCitySort(cityArr: e))!
//                    let searchCondition:PersonalNormalHotelListRequest = PersonalHotelManager.shareInstance.searchConditionUserDraw()
//                    var tmpLocalCity:HotelCityModel = HotelCityModel()
//                    for element in e {
//                        if element.cnName == weakSelf?.localTipDefaultCity {
//                            tmpLocalCity = element
//                            break
//                        }
//                    }
//                    searchCondition.cityId = tmpLocalCity.elongId
//                    searchCondition.cityName = tmpLocalCity.cnName
//                    PersonalHotelManager.shareInstance.searchConditionUserStore(searchCondition: searchCondition)
//                    weakSelf?.searchView.fillSearchDataSources(hotelSearchItem:searchCondition)
//
                    weakSelf?.getCurrentLocation()
                case .error:
                    break
                case .completed:
                    break
                }
            }.addDisposableTo(self.bag)
    }
    
    func fillLocalHotelCity(cityModels:[HotelCityModel]) {
        cityGroupList = hotelCitySort(cityArr: cityModels)
        let searchCondition:PersonalNormalHotelListRequest = PersonalHotelManager.shareInstance.searchConditionUserDraw()
        var tmpLocalCity:HotelCityModel = HotelCityModel()
        for element in cityModels {
            if element.cnName == localTipDefaultCity {
                tmpLocalCity = element
                break
            }
        }
        searchCondition.cityId = tmpLocalCity.elongId
        searchCondition.cityName = tmpLocalCity.cnName
        PersonalHotelManager.shareInstance.searchConditionUserStore(searchCondition: searchCondition)
        searchView.fillSearchDataSources(hotelSearchItem:searchCondition)
    }
    
    
    
    
    /// 获得当前位置
    func getCurrentLocation()  {
        weak var weakSelf = self
        MapManager.sharedInstance.startLocation()
        MapManager.sharedInstance.locationCityBlock = { (cityName,location) in
            
            //            guard location != nil else {
            //                return
            //            }
            if cityName.isEmpty == false && cityName != "定位了" && cityName != "定位" {
                var elongId:String = ""
                var cityNameCopy = cityName
                cityNameCopy.remove(at: cityName.index(before: cityName.endIndex))
                weakSelf?.cityGroupList.forEach({ (group) in
                    for element in group.cities{
                        if element.cnName == cityNameCopy{
                            elongId = element.elongId
                            break
                        }
                    }
                })
                let searchCondition:PersonalNormalHotelListRequest = PersonalHotelManager.shareInstance.searchConditionUserDraw()
                searchCondition.userLatitude = location?.coordinate.latitude ?? 0
                searchCondition.userLongitude = location?.coordinate.longitude ?? 0
                searchCondition.cityId = elongId
                searchCondition.cityName = cityNameCopy
                searchCondition.currentCityId = elongId
                searchCondition.currentCityName = cityNameCopy
                searchCondition.districtRegion = CityCategoryRegionModel.RegionModel()
                searchCondition.districtId = ""
                searchCondition.landmarkRegion = CityCategoryRegionModel.RegionModel()
                searchCondition.landmarkId = ""
                searchCondition.landmarkName = ""
                searchCondition.commericalRegion = CityCategoryRegionModel.RegionModel()
                searchCondition.commericalId = ""
                PersonalHotelManager.shareInstance.searchConditionUserStore(searchCondition: searchCondition)
                weakSelf?.searchView.fillSearchDataSources(hotelSearchItem:searchCondition)
            }
            let elongId = PersonalHotelManager.shareInstance.searchConditionUserDraw().cityId
            weakSelf?.getLandmark(cityId: elongId)
            
            
            
        }
        
    }
    func getPrefecturelevelCity(cityId:String) {
        
        weak var weakSelf = self
        CityService.sharedInstance
            .getPrefecturelevelCity(cityId:cityId)
            .subscribe{ event in
                switch event{
                case .next(let e):
                    printDebugLog(message: e)
                    weakSelf?.setSearchViewLandMark(distId: e.distId, name: e.distName,cityId: e.cityId)
                    weakSelf?.getLandmark(cityId: e.cityId)
                case .error:
                    break
                case .completed:
                    break
                }
            }.addDisposableTo(self.bag)
    }
    /// 获得商圈 地标 行政区
    func getLandmark(cityId:String) {
        weak var weakSelf = self
        ///showLoadingView()
        let policyId:String = PassengerManager.shareInStance.passengerSVDraw().first?.policyId ?? ""
        _ = CityService.sharedInstance
            .getHotelLandMark(elongId: cityId, policyId: policyId) //
            .subscribe { (event) in
                weakSelf?.hideLoadingView()
                switch event {
                case .next(let element):
                    //printDebugLog(message: element.mj_keyValues())
                    PersonalHotelManager.shareInstance.searchConditionCityCategoryRegionStore(cityCategoryRegionModel: element)
                case .error(let error):
                    try?weakSelf?.validateHttp(error)
                case .completed:
                    break
                }
        }
    }
    func setSearchViewLandMark(distId:String,name:String,cityId:String) {
        let searchCondition:PersonalNormalHotelListRequest = PersonalHotelManager.shareInstance.searchConditionUserDraw()
        searchCondition.districtRegion = CityCategoryRegionModel.RegionModel()
        let prefecturelevelCity:String = searchCondition.cityName
        searchCondition.cityName = name
        searchCondition.districtId = distId
        searchCondition.searchRegion = prefecturelevelCity
        searchCondition.cityId = cityId
        PersonalHotelManager.shareInstance.searchConditionUserStore(searchCondition: searchCondition)
        searchView.fillSearchDataSources(hotelSearchItem: searchCondition)
    }
    /// 城市排序
    public func hotelCitySort(cityArr:[HotelCityModel]) -> [HotelCityGroup] {
        var sortArr:[HotelCityGroup] = Array()
        cityArr.forEach { (element) in
            let firstCharacter:String = element.enName.first?.description ?? "#"
            if let tmpAirportGroup = sortArr.first(where:{$0.firstCharacter.uppercased() == firstCharacter.uppercased()}){
                tmpAirportGroup.cities.append(element)
            }else{
                sortArr.append(HotelCityGroup(firstCharacter: firstCharacter, cities: [element]))
            }
        }
        return sortArr.sorted{ $0.firstCharacter < $1.firstCharacter }.map{ group in
            group.cities = group.cities.sorted{ $0.enName < $1.enName }
            return group
        }
    }
    
    /// 搜索
    func searchHotelAction(parameters:Dictionary<String, Any>)  {
        if PersonalHotelManager.shareInstance.searchConditionCityCategoryRegionDraw().travelpolicyLimit.isEmpty == false {
            intoNextHotelListView()
        }else {
            getHotelTravelPolicy()
        }
        
    }
    /// 进入酒店列表
    func intoNextHotelListView() {
        
        let personalHotelListView = PersonalHotelCommonListViewController()
//        weak var weakSelf = self
//        hotelCompanyListView.travelNo = ""
//        hotelCompanyListView.hotelCompanySearcherAndListSearchConditionAccord = {(parameters) in
//            HotelManager.shareInstance.resetPartSearchCondition()
//            weakSelf?.searchView.fillSearchDataSources(hotelSearchItem: HotelManager.shareInstance.searchConditionUserDraw())
//        }
        self.navigationController?.pushViewController(personalHotelListView, animated: true)
    }
    /// 获得城市差标
    func getHotelTravelPolicy() {
        guard PersonalHotelManager.shareInstance.searchConditionUserDraw().cityId.isEmpty == false else {
            showSystemAlertView(titleStr: "提示", message: "请选择城市")
            return
        }
        weak var weakSelf = self
        ///showLoadingView()
        let policyId:String = PassengerManager.shareInStance.passengerSVDraw().first?.policyId ?? ""
        let cityId:String = PersonalHotelManager.shareInstance.searchConditionUserDraw().cityId
        _ = CityService.sharedInstance
            .getHotelTravelPolicy(elongId: cityId, policyId: policyId) //
            .subscribe { (event) in
                weakSelf?.hideLoadingView()
                switch event {
                case .next(let element):
                    //printDebugLog(message: element.mj_keyValues())
                    
                    let travelPolicyPrice:CityCategoryRegionModel = CityCategoryRegionModel()
                    travelPolicyPrice.travelpolicyLimit = element
                    PersonalHotelManager.shareInstance.searchConditionCityCategoryRegionStore(cityCategoryRegionModel: travelPolicyPrice)
                    weakSelf?.intoNextHotelListView()
                    
                case .error(let error):
                    try?weakSelf?.validateHttp(error)
                case .completed:
                    break
                }
        }
    }
    
    
    /// 进入行政区 视图
    func nextViewLandMark() {
        let searchCondition = PersonalHotelManager.shareInstance.searchConditionUserDraw()
        guard searchCondition.cityId.isEmpty == false else {
            showSystemAlertView(titleStr: "提示", message: "请选择城市")
            return
        }
        weak var weakSelf = self
        let landmarkView = LandMarkViewController()
        landmarkView.landMarkViewType = AppModelCatoryENUM.PersonalHotel
        landmarkView.elongId = searchCondition.cityId
        landmarkView.landMarkViewSelectedRegionBlock = { (region,index) in
            weakSelf?.searchRegion(region: region, index: index)
        }
        self.navigationController?.pushViewController(landmarkView, animated: true)
    }
    private func searchRegion(region:CityCategoryRegionModel.RegionModel,index:NSInteger) {
        let searchCondition:PersonalNormalHotelListRequest = PersonalHotelManager.shareInstance.searchConditionUserDraw()
        searchCondition.districtRegion = CityCategoryRegionModel.RegionModel()
        searchCondition.districtId = ""
        searchCondition.landmarkRegion = CityCategoryRegionModel.RegionModel()
        searchCondition.landmarkId = ""
        searchCondition.landmarkName = ""
        searchCondition.commericalRegion = CityCategoryRegionModel.RegionModel()
        searchCondition.commericalId = ""
        searchCondition.latitude = 0
        searchCondition.longitude = 0
        switch index {
        case 0:
            searchCondition.districtRegion = region
            searchCondition.districtId = region.id
        case 1:
            searchCondition.landmarkRegion = region
            searchCondition.landmarkId = region.id
            searchCondition.landmarkName = region.name
        case 2:
            searchCondition.commericalRegion = region
            searchCondition.commericalId = region.id
            
        default:
            break
        }
        searchCondition.searchRegion = region.name
        PersonalHotelManager.shareInstance.searchConditionUserStore(searchCondition: searchCondition)
        searchView.fillSearchDataSources(hotelSearchItem: searchCondition)
    }

}
