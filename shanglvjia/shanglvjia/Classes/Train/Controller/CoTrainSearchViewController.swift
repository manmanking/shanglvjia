//
//  CoTrainSearchViewController.swift
//  shop
//
//  Created by TBI on 2017/12/26.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import RxSwift
import SwiftDate

enum CoCompanyBusinessType {
    case Hotel
    case Flight
    case Train
    case Car
    case Approval
    case NewTrip
}

//选择车型
protocol CoBusinessTypeListener
{
    func onClickListener(type:CoCompanyBusinessType) -> Void
}



/// 查询条件
//var coTrainSearchModel = CoTrainForm(fromStationName: "北京" ,toStationName: "上海", fromStation: "BJP", toStation: "SHH", departDate: "", returnDate: "", isGt: false , type: 0, fromSeat: SeatTrain.defaultSeat, toSeat: SeatTrain.defaultSeat, city: "上海")

class CoTrainSearchViewController: CompanyBaseViewController {
    
    //fileprivate let bgScrollView:UIScrollView =  UIScrollView(frame: UIScreen.main.bounds)
    
    
    fileprivate let baseBackgroundScrollView:UIScrollView = UIScrollView()
    
    fileprivate let subBaseBackgroundView:UIView = UIView()
    
    //广告头
    fileprivate let cycleScrollView:SDCycleScrollView = SDCycleScrollView()
    
    fileprivate let servicesPhoneView:TBIServicesPhoneView = TBIServicesPhoneView()
    
    
    fileprivate let  trainView = CoTrainSearchView()
    
    fileprivate let bag = DisposeBag()
    
    var travelNo:String? = nil
    
    var locationCity:String = ""
    
    var citys:[CoStationListItem] = []
    
    var citySVList:[StaticTrainStation] = []
    
    fileprivate var hotCities: [Dictionary<String,String>]  = []
    
    fileprivate var  jumpList:[(title:String,image:String,type:CoCompanyBusinessType,isClick:Bool)] = [(title:"机票",image:"ic_menu_air",type:.Flight,isClick:true),(title:"酒店",image:"ic_menu_hotle",type:.Hotel,isClick:true),(title:"专车",image:"ic_menu_car",type:.Car,isClick:true)]
    
    fileprivate var jumpCommonFooterView:CoJumpCommonFooterView = CoJumpCommonFooterView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = TBIThemeBaseColor
        self.view.addSubview(baseBackgroundScrollView)
        baseBackgroundScrollView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        baseBackgroundScrollView.bounces = false
        self.automaticallyAdjustsScrollViewInsets = false
        if #available(iOS 11.0, *) {
            self.baseBackgroundScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        } else {
            // Fallback on earlier versions
        }
        self.navigationController?.extendedLayoutIncludesOpaqueBars = false
        baseBackgroundScrollView.showsHorizontalScrollIndicator = false
        //baseBackgroundScrollView.contentSize = CGSize.init(width: ScreenWindowWidth, height:ScreentWindowHeight)
        var contentHeight:CGFloat = ScreentWindowHeight
        if ScreentWindowHeight < 667 {
            contentHeight = 667
        }
        subBaseBackgroundView.frame = CGRect.init(x: 0, y: 0, width: ScreenWindowWidth, height: contentHeight)
        baseBackgroundScrollView.addSubview(subBaseBackgroundView)
//        subBaseBackgroundView.snp.makeConstraints { (make) in
//            make.top.equalToSuperview()
//            make.left.right.equalToSuperview()
//            make.height.equalTo(contentHeight)
//        }
        baseBackgroundScrollView.contentSize = CGSize.init(width: ScreenWindowWidth, height: contentHeight)
        //subBaseBackgroundView.frame = CGRect.init(x: 0, y: 0, width: ScreenWindowWidth, height: contentHeight)
        TrainManager.shareInstance.resetTrainInfo()
        
        
        
        policyView()
        initView()
        initData()
        initJumpCommonFooterView()
        setServicesPhoneView()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func backButtonAction(sender:UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
extension CoTrainSearchViewController {
    
    func initData () {
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone?
        formatter.dateFormat = "yyyy-MM-dd"
        
        
        let startDate = Date()
        let trainSearchCondition = TrainManager.shareInstance.trainSearchConditionDraw()
        //fromStationName: "北京" ,toStationName: "上海", fromStation: "BJP", toStation: "SHH",
        trainSearchCondition.fromStation = "TJP"
        trainSearchCondition.fromStationName = "天津"
        trainSearchCondition.toStation = "BJP"
        trainSearchCondition.toStationName = "北京"
       
        
        trainSearchCondition.departDate = formatter.string(from: startDate + 0.day)
        trainSearchCondition.returnDate = formatter.string(from: startDate + 1.day)
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        trainSearchCondition.departureDateFormat = formatter.string(from:startDate + 0.day)
        //(startDate + 1.day).string(custom: "yyyy-MM-dd HH:mm:ss")
        trainSearchCondition.returnDateFormat = formatter.string(from: startDate + 1.day)
            //(startDate + 2.day).string(custom: "yyyy-MM-dd HH:mm:ss")
        TrainManager.shareInstance.trainSearchConditionStore(searchCondition: trainSearchCondition)
        trainView.fillDataSources(searchCondition: trainSearchCondition)
        getTrainStation()
        
    }
    
    func getTrainStation() {
        showLoadingView()
        weak var weakSelf = self
        CoTrainService.sharedInstance
            .trainStation()
            .subscribe { (event) in
                weakSelf?.hideLoadingView()
                switch event {
                case .next(let element):
                    weakSelf?.citySVList = element
                    weakSelf?.initCity()
                    element.filter{$0.hotStation == "1"}.map{weakSelf?.hotCities.append(["name":$0.stationName,"code":$0.stationCode])}
                    //printDebugLog(message: element)
                case .error(let error):
                    try? self.validateHttp(error)
                case .completed:
                    break
                    
                }
        }
        
    }
    
    
    
    
    //查询
    func searchButton(sender:UIButton){
        let vc = CoTrainListViewController()
        vc.travelNo = self.travelNo
        let searchCondition = TrainManager.shareInstance.trainSearchConditionDraw()
        searchCondition.type = trainView.type
        searchCondition.isGt = trainView.gtSwitch.isOn
        TrainManager.shareInstance.trainSearchConditionStore(searchCondition: searchCondition)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func initCity () {
        weak var weakSelf = self
        MapManager.sharedInstance.startLocation()
        MapManager.sharedInstance.locationCityBlock = { (cityName,_) in
            if cityName.isNotEmpty{
                weakSelf?.locationCity = cityName
                let data = self.citys.filter{$0.city + "市" == cityName}.first
                if data != nil {
                    let searchCondition = TrainManager.shareInstance.trainSearchConditionDraw()
                    searchCondition.fromStationName = data?.city ?? "天津"
                    searchCondition.fromStation = data?.code ?? "TJP"
                    TrainManager.shareInstance.trainSearchConditionStore(searchCondition: searchCondition)
                    weakSelf?.trainView.fillDataSources(searchCondition: searchCondition)
                }
            }
        }
    }
    
    
    
    
    
    func initView () {
//        bgScrollView.backgroundColor = TBIThemeBaseColor
//        bgScrollView.showsVerticalScrollIndicator = false
//        bgScrollView.contentSize =  CGSize(width: 0, height: ScreentWindowHeight)
//        subBaseBackgroundView.addSubview(bgScrollView)
//        bgScrollView.snp.makeConstraints { (make) in
//            make.left.top.bottom.right.equalToSuperview()
//        }
//
        cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight
        cycleScrollView.pageControlBottomOffset = 10
        cycleScrollView.imageURLStringsGroup = ["banner_train"]
        subBaseBackgroundView.addSubview(cycleScrollView)
        cycleScrollView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()//.inset(-navBarBottom)
            make.width.equalTo(ScreenWindowWidth)
            make.height.equalTo(180)
        }
        self.subBaseBackgroundView.addSubview(trainView)
        trainView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(5)
            make.width.equalTo(ScreenWindowWidth-10)
            make.top.equalTo(cycleScrollView.snp.bottom).offset(-45)
            make.height.equalTo(302)
        }
        
        trainView.searchButton.addTarget(self, action: #selector(searchButton(sender:)), for: UIControlEvents.touchUpInside)
        weak var weakSelf = self
        //去程回程切换
        trainView.searchTypeBlock = { (parameter) in
          weakSelf?.exchangeStartStationAndArriveStation()
        }
        
        trainView.parametersTypeBlock = { (parameter) in
            switch parameter {
            case FlightSearchView.ParametersType.startCity:
                let citySelectorViewController = TrainCityViewController()
                citySelectorViewController.trainHotCities =  (weakSelf?.hotCities)!
                
                citySelectorViewController.citySelectorBlock = { (cityName,cityCode) in
                   weakSelf?.adjustTrainStation(trainType: FlightSearchView.ParametersType.startCity, cityName: cityName, cityCode: cityCode)
                    
                }
                citySelectorViewController.setCityType(type: .trainCity)
                
                citySelectorViewController.city = weakSelf?.citiesToGroups(weakSelf?.citySVList ?? [])
                weakSelf?.navigationController?.pushViewController(citySelectorViewController, animated: true)
            case FlightSearchView.ParametersType.arriveCity:
                let citySelectorViewController = TrainCityViewController()
                citySelectorViewController.trainHotCities =  (weakSelf?.hotCities)!
                citySelectorViewController.citySelectorBlock = { (cityName,cityCode) in
                   weakSelf?.adjustTrainStation(trainType: FlightSearchView.ParametersType.arriveCity, cityName: cityName, cityCode: cityCode)
                }
                citySelectorViewController.setCityType(type: .trainCity)
                citySelectorViewController.city = weakSelf?.citiesToGroups(weakSelf?.citySVList ?? [])
                weakSelf?.navigationController?.pushViewController(citySelectorViewController, animated: true)
            case FlightSearchView.ParametersType.startDate:

                weakSelf?.nextViewTBICalendar()
                return
            case FlightSearchView.ParametersType.arriveDate:

                weakSelf?.nextViewTBICalendar()
                return
            default: break
                
            }
        }
    }
    
    /// 调整 出发终点 站
    func adjustTrainStation(trainType:FlightSearchView.ParametersType,cityName:String,cityCode:String) {
        let searchCondition = TrainManager.shareInstance.trainSearchConditionDraw()
        if FlightSearchView.ParametersType.arriveCity == trainType {
            
            searchCondition.toStation = cityCode
            searchCondition.toStationName = cityName
        }else{
            searchCondition.fromStation = cityCode
            searchCondition.fromStationName = cityName
        }
        TrainManager.shareInstance.trainSearchConditionStore(searchCondition: searchCondition)
        trainView.fillDataSources(searchCondition: searchCondition)
        
    }
    
    func exchangeStartStationAndArriveStation() {
        let searchCondition = TrainManager.shareInstance.trainSearchConditionDraw()
        let startStation = searchCondition.fromStation
        let startStationName = searchCondition.fromStationName
        searchCondition.fromStationName = searchCondition.toStationName
        searchCondition.fromStation = searchCondition.toStation
        searchCondition.toStationName = startStationName
        searchCondition.toStation = startStation
        TrainManager.shareInstance.trainSearchConditionStore(searchCondition: searchCondition)
        printDebugLog(message: TrainManager.shareInstance.trainSearchConditionDraw().mj_keyValues())
    }
    
    /// 城市转首字母排序格式格式
    ///
    /// - Parameter cities: 待排序城市
    /// - Returns: 排序后的城市组
    func citiesToGroups(_ cities:[StaticTrainStation]) -> [CityGroup]{
        var groups:[CityGroup] = []
        cities.forEach{ cityItem in
            //获取首字母
            let firstCode:String = cityItem.stationCode.first?.description ?? "没有首字母" //spell.characters.first?.description
            if let currentGroup = groups.first(where: {$0.code.uppercased() == firstCode.uppercased()}) {
                
                currentGroup.cities.append(cityItem.staticTrainStationConvertCityModel())
            } else {
                //如果不存在该字母的项则创建
                groups.append(CityGroup(code: firstCode, cities: [cityItem.staticTrainStationConvertCityModel()]))
            }
        }
        //排序
        return  groups.sorted{ $0.code < $1.code}.map{ group in
            group.cities = group.cities.sorted{ $0.spell < $1.spell }
            return group
        }
    }
    
    
    func setServicesPhoneView() {
        subBaseBackgroundView.addSubview(servicesPhoneView)
        servicesPhoneView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(100)
        }
        if  (UserDefaults.standard.object(forKey: servicesPhoneTrain) as! String).isEmpty == false {
            let workPhone:String = UserDefaults.standard.object(forKey: servicesPhoneTrain) as! String
            if workPhone.isEmpty == false {
                servicesPhoneView.fillDataSource(workPhone: workPhone, overtimePhone: "")
            }
        }
        else
        {
            servicesPhoneView.isHidden = true
        }
    }
    
    //选择日期
    func nextViewTBICalendar () {
        weak var weakSelf = self
        let vc:TBICalendarViewController = TBICalendarViewController()
        if trainView.type == 0 {
            vc.isMultipleTap = false
            vc.calendarAlertType = TBICalendarAlertType.Train
            vc.showDateTitle = ["去程"]
            vc.calendarTypeAlert = ["请选择去程日期"]
            vc.selectedDates = [TrainManager.shareInstance.trainSearchConditionDraw().departureDateFormat]
            vc.titleColor = TBIThemePrimaryTextColor
            vc.bacButtonImageName = "back"
            vc.hotelSelectedDateAcomplishBlock = { (parameters,action) in
                weakSelf?.adjustSearchConditionDate(parameters: parameters, action: action)
                weakSelf?.trainView.fillDataSources(searchCondition: TrainManager.shareInstance.trainSearchConditionDraw())
                
            }
        }else if trainView.type ==  1 {
            vc.selectedDates = [TrainManager.shareInstance.trainSearchConditionDraw().departureDateFormat,
                                TrainManager.shareInstance.trainSearchConditionDraw().returnDateFormat]
            vc.isMultipleTap = true
            vc.calendarAlertType = TBICalendarAlertType.Train
            vc.calendarTypeAlert = ["请选择去程日期","请选择返程日期"]
            vc.showDateTitle = ["去程","返程"]
            vc.titleColor = TBIThemePrimaryTextColor
            vc.bacButtonImageName = "back"
            vc.hotelSelectedDateAcomplishBlock = { (parameters,action) in

                weakSelf?.adjustSearchConditionDate(parameters: parameters, action: action)
                weakSelf?.trainView.fillDataSources(searchCondition: TrainManager.shareInstance.trainSearchConditionDraw())
                
            }
        }
        _ = self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func adjustSearchConditionDate(parameters:[String]?,action:TBICalendarAction) {
        
        guard  action != TBICalendarAction.Back else {
            return
        }
        
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone?
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        
        let trainSearchCondition = TrainManager.shareInstance.trainSearchConditionDraw()
        if (parameters?.count)! == 1 {
            let startDate = formatter.date(from:parameters![0])
            trainSearchCondition.departureDateFormat =  parameters![0]
            trainSearchCondition.returnDateFormat = formatter.string(from: startDate! + 1.day)
            formatter.dateFormat = "YYYY-MM-dd"
            formatter.timeZone = NSTimeZone.local
            trainSearchCondition.departDate = formatter.string(from: startDate!)
            trainSearchCondition.returnDate = formatter.string(from: startDate! + 1.day)
            
            
            
        }else if (parameters?.count)! ==  2 {
            let startDate = formatter.date(from:parameters![0])
            let endDate = formatter.date(from: parameters![1])
            trainSearchCondition.departureDateFormat =  parameters![0]
            trainSearchCondition.returnDateFormat = parameters![1]//formatter.string(from: startDate! + 2.day)
            formatter.dateFormat = "YYYY-MM-dd"
            formatter.timeZone = NSTimeZone.local
            trainSearchCondition.departDate = formatter.string(from: startDate!)
            trainSearchCondition.returnDate = formatter.string(from: endDate!)
        }
        TrainManager.shareInstance.trainSearchConditionStore(searchCondition: trainSearchCondition)
    }
    
}
extension CoTrainSearchViewController {
    
    func  initJumpCommonFooterView () {
        
        jumpList = [(title:"机票",image:"ic_menu_air",type:.Flight,isClick:true),
                    (title:"酒店",image:"ic_menu_hotle",type:.Hotel,isClick:true),
                    (title:"专车",image:"ic_menu_car",type:.Car,isClick:true)]
        guard let userInfo =  DBManager.shareInstance.userDetailDraw()  else {
            return
        }
        
        if userInfo.busLoginInfo.resourceList.contains(where: { (element) -> Bool in
            if element.resourceRegex == FrontFlight { return true }
            else { return false }
            
        })  == false {
            jumpList[0] = (title:"火车票",image:"ic_menu_train_gray",type:.Train,isClick:false) 
        }
        if userInfo.busLoginInfo.resourceList.contains(where: { (element) -> Bool in
            if element.resourceRegex == FrontHotel { return true }
            else { return false }
            
        }) ==  false  {
            jumpList[1] = (title:"酒店",image:"ic_menu_hotle_gray",type:.Hotel,isClick:false)
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
            make.top.equalTo(trainView.snp.bottom).offset(10)
        }
        
    }
}


// MARK: - 滑动改变导航栏透明度、标题颜色、左右按钮颜色、状态栏颜色
extension CoTrainSearchViewController: CoBusinessTypeListener
{
    /// 方法二：简单使用
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = navBarBottom
        self.navigationController?.navigationBar.change(TBIThemeBlueColor, with: scrollView, andValue: height)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initNavigation(title:"",bgColor:TBIThemeBlueColor,alpha:0,isTranslucent:true)
        trainView.fillDataSources(searchCondition: TrainManager.shareInstance.trainSearchConditionDraw())
        self.navigationController?.navigationBar.star()
        setNavigationBackButton(backImage: "BackCircle")
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        //scrollViewDidScroll(bgScrollView)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.reset()
    }
    
    
    
    ///  监听跳转
    func onClickListener(type:CoCompanyBusinessType) -> Void {
        switch type {
        case .Flight:
            let vc = FlightSVSearchViewController()
            vc.travelNo = self.travelNo
            self.navigationController?.pushViewController(vc, animated: true)
        case .Hotel:
            let vc = HotelSVCompanySearchViewController()
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
    
    
}
///  右侧差旅政策按钮
extension CoTrainSearchViewController{
    
    func policyView () {
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
        let policy:String = PassengerManager.shareInStance.passengerSVDraw().first?.trainPolicyShow ?? ""
        var modifyPolicy:[String] = Array()
        var resultPolicy:String = ""
        if policy.isEmpty == false {
            modifyPolicy = policy.components(separatedBy: "。")
            for element in modifyPolicy {
                resultPolicy += element + "\n"
            }
        }
        vi.fullData(title: "火车票预订差旅标准",subTitle:"符合差旅标准席别:", content: resultPolicy)
        KeyWindow?.addSubview(vi)
    }
}
