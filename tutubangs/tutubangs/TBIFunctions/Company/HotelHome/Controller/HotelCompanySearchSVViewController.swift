//
//  HotelSVCompanySearchViewController.swift
//  shop
//
//  Created by manman on 2018/1/30.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import RxSwift

class HotelSVCompanySearchViewController: CompanyBaseViewController,CoBusinessTypeListener{
    
    typealias HotelSVCompanySearchViewBackFromHotelListBlock = ()->Void
    
    public var hotelSVCompanySearchViewBackFromHotelListBlock:HotelSVCompanySearchViewBackFromHotelListBlock!
    
    
    private let hotelCompanySearchTableViewCellIdentify = "hotelCompanySearchTableViewCellIdentify"
    private let hotelCompanySearchTableViewHeaderIdentify = "hotelCompanySearchTableViewHeaderIdentify"
    private let hotelCompanySearchTableViewHeaderIdentifySecond = "hotelCompanySearchTableViewHeaderIdentifySecond"
    
    
    
    //private var searchCondtion = HotelSearchForm()
    
    fileprivate let bag = DisposeBag()

    public var travelNo:String = ""
    
    private let topImageView:UIImageView = UIImageView()
    
    private let baseBackgroundScrollView:UIScrollView = UIScrollView()
    
    private let subBaseBackgroundView:UIView = UIView()
    
    private let searchView:HotelSVSearchView = HotelSVSearchView()
    
    private let servicesPhoneView:TBIServicesPhoneView = TBIServicesPhoneView()
    
    private var userInfo:LoginResponse?
    
    private var jumpCommonFooterView:CoJumpCommonFooterView = CoJumpCommonFooterView()
    
    private var  jumpList:[(title:String,image:String,type:CoCompanyBusinessType,isClick:Bool)] = Array()
    
    /// 城市列表
    private var cityGroupList:[HotelCityGroup] = Array()
    
    private let localTipDefaultCity:String = "天津"
    
    //private var cityCategoryRegionModel:CityCategoryRegionModel = CityCategoryRegionModel()
    
    fileprivate var userPolicy:UserPolicy?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
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
        print(ScreentWindowHeight)
        //baseBackgroundScrollView.contentSize = CGSize.init(width: ScreenWindowWidth, height:ScreentWindowHeight)
        userInfo = DBManager.shareInstance.userDetailDraw()
        var contentHeight:CGFloat = ScreentWindowHeight
        if ScreentWindowHeight < 667 {
            contentHeight = 667
        }
        if userInfo?.busLoginInfo.userBaseInfo.corpCode.uppercased() == Toyota
        {
            contentHeight = 736
        }
        baseBackgroundScrollView.addSubview(subBaseBackgroundView)
        subBaseBackgroundView.frame = CGRect.init(x: 0, y: 0, width: ScreenWindowWidth, height: contentHeight)
//        subBaseBackgroundView.snp.makeConstraints { (make) in
//            make.top.equalToSuperview()
//            make.width.equalTo(ScreenWindowWidth)
//            make.height.equalTo(contentHeight)
//        }
        baseBackgroundScrollView.contentSize = CGSize.init(width: ScreenWindowWidth, height: contentHeight)
        fillLocalDataSources()
        setUIViewAutolayout()
        initRightButtonView()
    }
    
    func setUIViewAutolayout() {
        
        
        
        
        topImageView.image = UIImage.init(named: "banner_hotle")
        subBaseBackgroundView.addSubview(topImageView)
        topImageView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(180)
        }
        var searcheViewHeight:CGFloat = 260 + 55
        if userInfo?.busLoginInfo.userBaseInfo.corpCode.uppercased() == Toyota
        {
            searcheViewHeight = 310 + 55
            searchView.hotelSVSearchViewType = HotelSVSearchView.HotelSVSearchViewType.FTMS
            searchView.hotelNameFieldText.placeholder = "酒店名称"
        }
        subBaseBackgroundView.addSubview(searchView)
        searchView.snp.remakeConstraints { (make) in
            make.top.equalTo(topImageView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(searcheViewHeight)
        }
        weak var weakSelf = self
        searchView.hotelCompanyCheckinDateBlock = {(paramater )in
            weakSelf?.showCalendarView(paramater: paramater)
        }
        searchView.hotelCompanySearchCityBlock = {(parameter)in
            weakSelf?.showCityView(parameter: parameter)
        }
        searchView.hotelCompanySubsidiarySearchBlock = { (parameter ) in
            weakSelf?.choiceSubsidiaryAction(parameter: parameter)
        }
        searchView.hotelCompanySearchCompleteBlock =  {(parameters) in
            weakSelf?.searchHotelAction(parameters: parameters)
        }
        searchView.hotelCompanyCurrentLocationBlock = { _ in
            
            weakSelf?.getCurrentLocation()
        }
        searchView.hotelCompanyChoicesLandMark = { _ in
            weakSelf?.nextViewLandMark()
        }
        //searchView.fillSearchDataSources(hotelSearchItem: searchCondtion)
        initJumpCommonFooterView()
        
        subBaseBackgroundView.addSubview(servicesPhoneView)
        servicesPhoneView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(100)
            make.bottom.equalToSuperview().offset(10)
        }
        if (UserDefaults.standard.object(forKey: servicesPhoneHotel) as! String).isEmpty == false {
            let workPhone:String = UserDefaults.standard.object(forKey: servicesPhoneHotel) as! String
            if workPhone.isEmpty == false  {
                servicesPhoneView.fillDataSource(workPhone: workPhone, overtimePhone: "123456")
            }
        }else
        {
            servicesPhoneView.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initNavigation(title:"",bgColor:TBIThemeBlueColor,alpha:0,isTranslucent:true)
        //HotelManager.shareInstance.resetPartSearchCondition()
        searchView.fillSearchDataSources(hotelSearchItem: HotelManager.shareInstance.searchConditionUserDraw())
        setNavigationBackButton(backImage: "BackCircle")
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
        self.navigationController?.navigationBar.reset()
    }
    //MARK: ------------ Into next view
    /// 展示 日历
    func showCalendarView(paramater:Dictionary<String,Any>) {
        nextViewTBICalendar(paramater: paramater)
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
        
        
        
        let searchCondition:HotelListRequest = HotelManager.shareInstance.searchConditionUserDraw()
//        if cityId != searchCondition.cityId {
//            getLandmark(cityId: cityId)
//        }
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
        HotelManager.shareInstance.searchConditionUserStore(searchCondition: searchCondition)
        searchView.fillSearchDataSources(hotelSearchItem:searchCondition)
        
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
    
    func nextViewTBICalendar(paramater:Dictionary<String, Any>) {
        
        
        let calendarView = TBICalendarViewController()
        calendarView.calendarAlertType = TBICalendarAlertType.Hotel
        calendarView.calendarTypeAlert = ["请选择入住日期","请选择离店日期"]
        calendarView.selectedDates = [HotelManager.shareInstance.searchConditionUserDraw().arrivalDateFormat,
                                      HotelManager.shareInstance.searchConditionUserDraw().departureDateFormat]
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
        let searchCondition:HotelListRequest = HotelManager.shareInstance.searchConditionUserDraw()
        searchCondition.arrivalDateFormat = (parameters?[0])!
        searchCondition.departureDateFormat = (parameters?[1])!
        searchCondition.arrivalDate = (NSInteger(formatter.date(from:(parameters?[0])!)?.timeIntervalSince1970 ?? 0) * 1000).description
        searchCondition.departureDate = (NSInteger(formatter.date(from:(parameters?[1])!)?.timeIntervalSince1970 ?? 0) * 1000).description
        
        HotelManager.shareInstance.searchConditionUserStore(searchCondition: searchCondition)
        searchView.fillSearchDataSources(hotelSearchItem: searchCondition)
    }
    
    
    
    /// 进入行政区 视图
    func nextViewLandMark() {
        let searchCondition = HotelManager.shareInstance.searchConditionUserDraw()
        guard searchCondition.cityId.isEmpty == false else {
            showSystemAlertView(titleStr: "提示", message: "请选择城市")
            return
        }
        weak var weakSelf = self
        let landmarkView = LandMarkViewController()
        landmarkView.elongId = searchCondition.cityId
        landmarkView.landMarkViewSelectedRegionBlock = { (region,index) in
            weakSelf?.searchRegion(region: region, index: index)
        }
        self.navigationController?.pushViewController(landmarkView, animated: true)
    }
    
   private func searchRegion(region:CityCategoryRegionModel.RegionModel,index:NSInteger) {
        let searchCondition:HotelListRequest = HotelManager.shareInstance.searchConditionUserDraw()
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
        HotelManager.shareInstance.searchConditionUserStore(searchCondition: searchCondition)
        searchView.fillSearchDataSources(hotelSearchItem: searchCondition)
    }
    
    
    
    
    
    ///选择分公司
    func choiceSubsidiaryAction(parameter:Dictionary<String , Any>) {
        weak var weakSelf = self
        let searchCondition = HotelManager.shareInstance.searchConditionUserDraw()
        let subsidiaryView = HotelGroupSubsidiarySearchViewController()
        if searchCondition.cityName.isEmpty == false {
            subsidiaryView.subsidiaryCity = searchCondition.cityName
        }
        subsidiaryView.hotelGroupSubsidiarySearchBlock = { (parameter) in
            
            weakSelf?.modifyFiliale(filiale: parameter)
//            weakSelf?.searchCondtion.subsidiary = parameter
//            weakSelf?.searchView.fillSearchDataSources(hotelSearchItem: (weakSelf?.searchCondtion)!)
        }
        self.navigationController?.pushViewController(subsidiaryView, animated: true)
    }
    
    func modifyFiliale(filiale:FilialeItemModel) {
        let tmpSearchCondition:HotelListRequest = HotelManager.shareInstance.searchConditionUserDraw()
        tmpSearchCondition.filialeItem = filiale
        let corpCode:String = DBManager.shareInstance.userDetailDraw()?.busLoginInfo.userBaseInfo.corpCode ?? ""
        tmpSearchCondition.groupCodes = [corpCode]
        tmpSearchCondition.longitude = Double(filiale.lon) ?? 0
        tmpSearchCondition.latitude = Double(filiale.lat) ?? 0
        if tmpSearchCondition.latitude == 0 {
            tmpSearchCondition.radius = 0
        }else{
            tmpSearchCondition.radius = 5000
        }
        HotelManager.shareInstance.searchConditionUserStore(searchCondition: tmpSearchCondition)
        searchView.fillSearchDataSources(hotelSearchItem: tmpSearchCondition)
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
                let searchCondition:HotelListRequest = HotelManager.shareInstance.searchConditionUserDraw()
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
                HotelManager.shareInstance.searchConditionUserStore(searchCondition: searchCondition)
                weakSelf?.searchView.fillSearchDataSources(hotelSearchItem:searchCondition)
            }
            let elongId = HotelManager.shareInstance.searchConditionUserDraw().cityId
            weakSelf?.getLandmark(cityId: elongId)
            
            
            
        }
        
    }
    
    
    /// 进入酒店列表
    func intoNextHotelListView() {
        
        let hotelCompanyListView = HotelCompanyListViewController()
        weak var weakSelf = self
        hotelCompanyListView.travelNo = self.travelNo
        hotelCompanyListView.hotelCompanySearcherAndListSearchConditionAccord = {(parameters) in
            HotelManager.shareInstance.resetPartSearchCondition()
            weakSelf?.searchView.fillSearchDataSources(hotelSearchItem: HotelManager.shareInstance.searchConditionUserDraw())
        }
        self.navigationController?.pushViewController(hotelCompanyListView, animated: true)
    }
    
    
    /// 获得商圈 地标 行政区
    func getLandmark(cityId:String) {
        weak var weakSelf = self
        showLoadingView()
        let policyId:String = PassengerManager.shareInStance.passengerSVDraw().first?.policyId ?? ""
        _ = CityService.sharedInstance
            .getHotelLandMark(elongId: cityId, policyId: policyId) //
            .subscribe { (event) in
                weakSelf?.hideLoadingView()
                switch event {
                case .next(let element):
                    //printDebugLog(message: element.mj_keyValues())
                    HotelManager.shareInstance.searchConditionCityCategoryRegionStore(cityCategoryRegionModel: element)
                case .error(let error):
                    try?weakSelf?.validateHttp(error)
                case .completed:
                    break
                }
        }
    }
    
    
    /// 搜索
    func searchHotelAction(parameters:Dictionary<String, Any>)  {
        if HotelManager.shareInstance.searchConditionCityCategoryRegionDraw().travelpolicyLimit.isEmpty == false {
            intoNextHotelListView()
        }else {
            getHotelTravelPolicy()
        }
        
    }
    
    /// 获得城市差标
    func getHotelTravelPolicy() {
        guard HotelManager.shareInstance.searchConditionUserDraw().cityId.isEmpty == false else {
            showSystemAlertView(titleStr: "提示", message: "请选择城市")
            return
        }
        weak var weakSelf = self
        showLoadingView()
        let policyId:String = PassengerManager.shareInStance.passengerSVDraw().first?.policyId ?? ""
        let cityId:String = HotelManager.shareInstance.searchConditionUserDraw().cityId
        _ = CityService.sharedInstance
            .getHotelTravelPolicy(elongId: cityId, policyId: policyId) //
            .subscribe { (event) in
                weakSelf?.hideLoadingView()
                switch event {
                case .next(let element):
                    //printDebugLog(message: element.mj_keyValues())
                    
                    let travelPolicyPrice:CityCategoryRegionModel = CityCategoryRegionModel()
                    travelPolicyPrice.travelpolicyLimit = element
                    HotelManager.shareInstance.searchConditionCityCategoryRegionStore(cityCategoryRegionModel: travelPolicyPrice)
                    weakSelf?.intoNextHotelListView()
                    
                case .error(let error):
                    try?weakSelf?.validateHttp(error)
                case .completed:
                    break
                }
        }
    }
    
    
    func fillLocalDataSources() {
        
        jumpList = [(title:"机票",image:"ic_menu_air",type:.Flight,isClick:true),(title:"火车票",image:"ic_menu_train",type:.Train,isClick:true),(title:"专车",image:"ic_menu_car",type:.Car,isClick:true)]
        let searchCondition:HotelListRequest = HotelManager.shareInstance.searchConditionUserDraw()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone?
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" //"yyyy-MM-dd HH:mm:ss"
        let currentDateDay:Date = Date().startOfDay
        searchCondition.arrivalDateFormat =  dateFormatter.string(from: currentDateDay)
        searchCondition.departureDateFormat = dateFormatter.string(from: (currentDateDay.addingTimeInterval(24 * 60 * 60)))
        searchCondition.arrivalDate = (NSInteger(currentDateDay.timeIntervalSince1970) * 1000).description
        searchCondition.departureDate = ((NSInteger(currentDateDay.addingTimeInterval(24 * 60 * 60).timeIntervalSince1970)) * 1000).description
        HotelManager.shareInstance.searchConditionUserStore(searchCondition: searchCondition)
        
        getHotelCity()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func  initJumpCommonFooterView () {
        jumpList = [(title:"机票",image:"ic_menu_air",type:.Flight,isClick:true),(title:"火车票",image:"ic_menu_train",type:.Train,isClick:true),(title:"专车",image:"ic_menu_car",type:.Car,isClick:true)]
        guard let userInfo =  DBManager.shareInstance.userDetailDraw()  else {
            return
        }
        
        if userInfo.busLoginInfo.resourceList.contains(where: { (element) -> Bool in
            if element.resourceRegex == FrontFlight { return true }
            else { return false }
            
        })  == false {
            jumpList[0] = (title:"机票",image:"ic_menu_air_gray",type:.Flight,isClick:false)
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
        
        jumpCommonFooterView.fullCell(data:jumpList)
        jumpCommonFooterView.coBusinessTypeListener = self
        subBaseBackgroundView.addSubview(jumpCommonFooterView)
        jumpCommonFooterView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(77)
            make.top.equalTo(searchView.snp.bottom).offset(10)
        }
        
    }
    
    ///  监听跳转
    func onClickListener(type:CoCompanyBusinessType) -> Void {
        switch type {
        case .Flight:
            let vc = FlightSVSearchViewController()
            vc.travelNo = self.travelNo
            self.navigationController?.pushViewController(vc, animated: true)
        case .Train:
            let vc = CoTrainSearchViewController()
            vc.travelNo = self.travelNo
            self.navigationController?.pushViewController(vc, animated: true)
        case .Car:
            let vc = CoCarSearchViewController()
            vc.travelNo = self.travelNo
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
//    func initRightButtonData () {
//        let traveller = PassengerManager.shareInStance.passengerDraw().first
//        NewUserService.sharedInstance.getPolicy(id: traveller?.uid ?? "").subscribe{ event in
//            switch event{
//            case .next(let e):
//                self.userPolicy = e
//                if e.hotelDesc.isNotEmpty {
//                    self.initRightButton ()
//                }
//            case .error(let e):
//                try? self.validateHttp(e)
//            case .completed:
//                break
//            }
//            }.addDisposableTo(self.bag)
//    }
    
    func initRightButtonView () {
        let backButton = UIButton(frame:CGRect(x:0,y:0,width:62,height:30))
        backButton.setTitle("差旅标准", for: .normal)
        backButton.titleLabel?.textColor = TBIThemeWhite
        backButton.titleLabel?.font  = UIFont.systemFont(ofSize: 12)
        backButton.layer.cornerRadius = 15
        backButton.backgroundColor = TBIThemeBackgroundViewColor
        let backBarButton = UIBarButtonItem.init(customView: backButton)
        backButton.addTarget(self, action: #selector(rightItemClick(sender:)), for: UIControlEvents.touchUpInside)
        navigationItem.rightBarButtonItem = backBarButton
    }
    func rightItemClick(sender:UIButton){
        let vi = CoPolicyView(frame: ScreenWindowFrame)
        let policy:String = PassengerManager.shareInStance.passengerSVDraw().first?.hotelPolicyShow ?? ""
        var modifyPolicy:[String] = Array()
        var resultPolicy:String = ""
        if policy.isEmpty == false {
            let policyCopy = policy.replacingOccurrences(of: ",", with:"。" )
            modifyPolicy = policyCopy.components(separatedBy: "。")
            for element in modifyPolicy {
                if element.isEmpty == false {
                    resultPolicy += element + "。" + "\n"
                }
                
            }
        }
        vi.fullData(title: "酒店预订差旅标准",subTitle:"符合差旅标准房间:", content: resultPolicy)
        KeyWindow?.addSubview(vi)
    }
    //MARK:------------NET---------
    ///  获得酒店城市
    func getHotelCity() {
        showLoadingView()
        weak var weakSelf = self
        CityService.sharedInstance
            .getHotelCity()
            .subscribe{ event in
                weakSelf?.hideLoadingView()
                switch event{
                case .next(let e):
                    weakSelf?.cityGroupList = (weakSelf?.hotelCitySort(cityArr: e))!
                    let searchCondition:HotelListRequest = HotelManager.shareInstance.searchConditionUserDraw()
                    var tmpLocalCity:HotelCityModel = HotelCityModel()
                    for element in e {
                        if element.cnName == weakSelf?.localTipDefaultCity {
                            tmpLocalCity = element
                            break
                        }
                    }
                    searchCondition.cityId = tmpLocalCity.elongId
                    searchCondition.cityName = tmpLocalCity.cnName
                    HotelManager.shareInstance.searchConditionUserStore(searchCondition: searchCondition)
                    weakSelf?.searchView.fillSearchDataSources(hotelSearchItem:searchCondition)
                    
                    weakSelf?.getCurrentLocation()
                case .error:
                    break
                case .completed:
                    break
                }
            }.addDisposableTo(self.bag)
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
    
    func setSearchViewLandMark(distId:String,name:String,cityId:String) {
        let searchCondition:HotelListRequest = HotelManager.shareInstance.searchConditionUserDraw()
        searchCondition.districtRegion = CityCategoryRegionModel.RegionModel()
        let prefecturelevelCity:String = searchCondition.cityName
        searchCondition.cityName = name
        searchCondition.districtId = distId
        searchCondition.searchRegion = prefecturelevelCity
        searchCondition.cityId = cityId
        HotelManager.shareInstance.searchConditionUserStore(searchCondition: searchCondition)
        searchView.fillSearchDataSources(hotelSearchItem: searchCondition)
    }
    
    
    
    //MARK:------------Action---------
    override func backButtonAction(sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }

}

