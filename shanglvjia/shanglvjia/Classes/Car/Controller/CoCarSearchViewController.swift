//
//  CoCarSearchViewController.swift
//  shop
//
//  Created by TBI on 2018/1/15.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import RxSwift
import SwiftDate
import MJRefresh


//选择机场
protocol CoCarClickListener
{
    func onOrderTypeClickListener(orderType:OrderCarTypeEnum) -> Void
    
    ///  选择机场回调
    func onAirportClickListener(row:Int) -> Void
    
    ///  选择地址回调
    func onAddressClickListener(model:CoPointAddressModel,row:Int) -> Void
    
}


let navBarBottom = CompanyBaseViewController.navBarBottom()
private let IMAGE_HEIGHT:CGFloat = 64
private let NAVBAR_COLORCHANGE_POINT:CGFloat = IMAGE_HEIGHT - (navBarBottom * 2)


class CoCarSearchViewController: CompanyBaseViewController {

    fileprivate let bgScrollView:UIScrollView =  UIScrollView(frame: UIScreen.main.bounds)
    
    fileprivate let baseBackgroundScrollView:UIScrollView = UIScrollView()
    
    fileprivate let subBaseBackgroundView:UIView = UIView()
    
    fileprivate  let bag = DisposeBag()
    
    fileprivate let tableView = UITableView()
    
    private let servicesPhoneView:TBIServicesPhoneView = TBIServicesPhoneView()
    
    fileprivate let coCarSearchTableViewHeaderCellIdentify = "coCarSearchTableViewHeaderCellIdentify"
    
    fileprivate let coCarSearchTableViewScrollViewCellIdentify = "coCarSearchTableViewScrollViewCellIdentify"
    
    fileprivate let coCarSearchTableViewAddressViewCellIdentify = "coCarSearchTableViewAddressViewCellIdentify"
    
    fileprivate let coCarSearchTableViewTimeViewCellIdentify = "coCarSearchTableViewTimeViewCellIdentify"
    
    fileprivate let coCarSearchSubmitViewCellIdentify = "coCarSearchSubmitViewCellIdentify"
    
    fileprivate var flightScrollViewFlag:Int = 1
    
    fileprivate var flightIndex:Int = 0
    
    //广告头
    fileprivate let cycleScrollView:SDCycleScrollView = SDCycleScrollView()
    
    //fileprivate let footerView:CoBgFooterView = CoBgFooterView()
    
    fileprivate var orderCarType:OrderCarTypeEnum = .pick
    
    //接机数据
    fileprivate var pickData:[(image:String,placeholder:String,value:String,model:CoPointAddressModel?)] = [(image:"ic_car_qidian",placeholder:"请输入出发地",value:"",model:nil),(image:"ic_car_zhongdian",placeholder:"请输入目的地",value:"",model:nil),(image:"ic_car_time",placeholder:"请选择用车时间",value:"",model:nil)]
    
    //送机数据
    fileprivate var sendData:[(image:String,placeholder:String,value:String,model:CoPointAddressModel?)] = [(image:"ic_car_zhongdian",placeholder:"请输入目的地",value:"",model:nil),(image:"ic_car_qidian",placeholder:"请输入出发地",value:"",model:nil),(image:"ic_car_time",placeholder:"请选择用车时间",value:"",model:nil)]
    
    //预约用车
    fileprivate var aboutData:[(image:String,placeholder:String,value:String,model:CoPointAddressModel?)] = [(image:"ic_car_qidian",placeholder:"请输入出发地",value:"",model:nil),(image:"ic_car_zhongdian",placeholder:"请输入目的地",value:"",model:nil),(image:"ic_car_time",placeholder:"请选择用车时间",value:"",model:nil)]
    
    /// 机票行程
    fileprivate var journeyList:[CompanyJourneyResult] = []
    
    fileprivate var coCarForm:CoCarForm.CarVO = CoCarForm.CarVO()
    
    var travelNo:String? = nil
    
    fileprivate let amapSearch:AMapSearchAPI = AMapSearchAPI()
    
    fileprivate var userPolicy:UserPolicy?
    
    
    ///-------NEWOBT--------
    fileprivate var flightOrderList:PersonalFlightListResponse = PersonalFlightListResponse()
    
    
    
    
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
        self.automaticallyAdjustsScrollViewInsets = false
        if #available(iOS 11.0, *) {
            self.baseBackgroundScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        } else {
            // Fallback on earlier versions
        }
        print(ScreentWindowHeight)
        baseBackgroundScrollView.contentSize = CGSize.init(width: ScreenWindowWidth, height:ScreentWindowHeight)
        var contentHeight:CGFloat = ScreentWindowHeight
        if ScreentWindowHeight < 667 {
            contentHeight = 667
        }
        baseBackgroundScrollView.addSubview(subBaseBackgroundView)
        subBaseBackgroundView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalTo(ScreenWindowWidth)
            make.height.equalTo(contentHeight)
        }
        baseBackgroundScrollView.contentSize = CGSize.init(width: ScreenWindowWidth, height: contentHeight)
        
        
        // 设置导航栏的leftButton
        amapSearch.delegate = self
        //initJourneyList()
        getPersonalFLightOrders(pageNo: 1)
        initTableView()
        policyView()
        setServicesPhoneView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func backButtonAction(sender:UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
        self.navigationController?.navigationBar.reset()
    }
    
    func setServicesPhoneView() {
        subBaseBackgroundView.addSubview(servicesPhoneView)
        servicesPhoneView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(100)
        }
        if (UserDefaults.standard.object(forKey: servicesPhoneCar) as! String).isEmpty == false {
            let workPhone:String = UserDefaults.standard.object(forKey: servicesPhoneCar) as! String
            if workPhone.isEmpty == false {
                servicesPhoneView.fillDataSource(workPhone: workPhone, overtimePhone:"")
            }
        }else
        {
            servicesPhoneView.isHidden = true
        }
    }
  
    
    ///MARK:--------NET-----
    // 获得当前用户的机票信息
    func getPersonalFLightOrders(pageNo:NSInteger) {
        weak var weakSelf = self
        showLoadingView()
        _ = CompanyJourneyService.sharedInstance
            .getPersonalFlightList(pageNo: pageNo)
            .subscribe{ event in
                weakSelf?.hideLoadingView()
                switch event{
                case .next(let e):
                    
                    if e.count == 0 {
                        weakSelf?.flightScrollViewFlag = 0
                        weakSelf?.tableView.reloadData()
                    }else
                    {
                        weakSelf?.flightOrderList = e
                        weakSelf?.flightScrollViewFlag = 1
                        weakSelf?.fillLocalSourcesData()
                    }
                    
                    
                case .error(let e):
                    try? self.validateHttp(e)
                case .completed:
                    break
                }
        }
    }
    
    
    
    
    
    
}


// MARK: - 滑动改变导航栏透明度、标题颜色、左右按钮颜色、状态栏颜色
extension CoCarSearchViewController
{
    /// 方法二：简单使用
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = navBarBottom
        self.navigationController?.navigationBar.homeChange(TBIThemeBlueColor, with: scrollView, andValue: height)
//        let offsetY = scrollView.contentOffset.y
//
//        if (offsetY > NAVBAR_COLORCHANGE_POINT) {
//            let alphas = (offsetY - NAVBAR_COLORCHANGE_POINT) / CGFloat(navBarBottom)
//
//            textLabel.textColor = TBIThemePrimaryTextColor
//            textLabel.alpha = alphas
//        }else {
//            textLabel.textColor = TBIThemeWhite
//            textLabel.alpha = 1
//        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initNavigation(title:"",bgColor:TBIThemeBlueColor,alpha:0,isTranslucent:true)
        self.navigationController?.navigationBar.star()
        setNavigationBackButton(backImage: "BackCircle")
        //scrollViewDidScroll(bgScrollView)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.reset()
    }

    
}


extension CoCarSearchViewController: UITableViewDelegate,UITableViewDataSource {
    

    
    func fillLocalSourcesData() {
        let dateIn = DateInRegion() + 2.hour
        let date = dateIn.string(custom: "yyyy-MM-dd HH:mm")
        var pickDate:String = ""
        var sendDate:String = ""
        if self.flightOrderList.personalFlightInfos.count > 0 {
            pickDate = self.flightOrderList.personalFlightInfos.first!.depDate + " " + (self.flightOrderList.personalFlightInfos.first?.depTime ?? "08:00")!
            sendDate = self.flightOrderList.personalFlightInfos.first!.arrDate + " " + (self.flightOrderList.personalFlightInfos.first?.arrTime  ?? "08:00")!
        }else {
            pickDate = date
            sendDate = date
        }
        pickData  =  [(image:"ic_car_qidian",placeholder:"请输入出发地",value:flightOrderList.personalFlightInfos.first?.arrAirport ?? "",model:nil)
            ,(image:"ic_car_zhongdian",placeholder:"请输入目的地",value:"",model:nil),
             (image:"ic_car_time",placeholder:"请选择用车时间",value:pickDate,model:nil)]
        sendData  =  [(image:"ic_car_zhongdian",placeholder:"请输入目的地",value:flightOrderList.personalFlightInfos.first?.depAirport ?? "",model:nil),(image:"ic_car_qidian",placeholder:"请输入出发地",value:"",model:nil),
                      (image:"ic_car_time",placeholder:"请选择用车时间",value:sendDate,model:nil)]
        aboutData =  [(image:"ic_car_qidian",placeholder:"请输入出发地",value:"",model:nil),
                      (image:"ic_car_zhongdian",placeholder:"请输入目的地",value:"",model:nil),
                      (image:"ic_car_time",placeholder:"请选择用车时间",value:date,model:nil)]
        if flightOrderList.count > 0 {
            requestMapPoi(keyword: flightOrderList.personalFlightInfos.first?.arrAirport ?? "")
        }
        self.tableView.reloadData()
    }
    
    
    
    
    
    func initTableView () {
        //bgScrollView.delegate = self
//        bgScrollView.backgroundColor = TBIThemeBaseColor
//        bgScrollView.showsVerticalScrollIndicator = false
//        bgScrollView.contentSize =  CGSize(width: 0, height: ScreentWindowHeight)
//        self.view.addSubview(bgScrollView)
//        bgScrollView.snp.makeConstraints { (make) in
//            make.left.top.bottom.right.equalToSuperview()
//        }
//
        cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight
        cycleScrollView.pageControlBottomOffset = 10
        cycleScrollView.imageURLStringsGroup = ["banner_car"]
        subBaseBackgroundView.addSubview(cycleScrollView)
        cycleScrollView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()//.inset(-navBarBottom)
            make.width.equalTo(ScreenWindowWidth)
            make.height.equalTo(180)
        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        tableView.layer.cornerRadius = 3
        tableView.isScrollEnabled = false
        subBaseBackgroundView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(5)
            make.width.equalTo(ScreenWindowWidth-10)
            make.top.equalTo(cycleScrollView.snp.bottom).offset(-45)
            make.height.equalTo(356)
        }
        tableView.register(CoCarSearchTableViewHeaderCell.self, forCellReuseIdentifier: coCarSearchTableViewHeaderCellIdentify)
        tableView.register(CoCarSearchTableViewScrollViewCell.self, forCellReuseIdentifier: coCarSearchTableViewScrollViewCellIdentify)
        tableView.register(CoCarSearchTableViewAddressViewCell.self, forCellReuseIdentifier: coCarSearchTableViewAddressViewCellIdentify)
        tableView.register(CoCarSearchTableViewTimeViewCell.self, forCellReuseIdentifier: coCarSearchTableViewTimeViewCellIdentify)
        tableView.register(CoCarSearchSubmitViewCell.self, forCellReuseIdentifier: coCarSearchSubmitViewCellIdentify)
        
//        self.bgScrollView.addSubview(footerView)
//        footerView.snp.makeConstraints { (make) in
//            make.left.right.equalToSuperview()
//            make.top.equalTo(tableView.snp.bottom).offset(85)
//            make.width.equalTo(ScreenWindowWidth)
//            make.height.equalTo(90)
//            make.bottom.equalToSuperview()
//
//        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return  0
    }
    
    
    //MARK:- UITableViewDataSources
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else {
            return  4 + flightScrollViewFlag
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 45
        }
         if indexPath.row == 0 && flightScrollViewFlag == 1{
            return 59.5
        }else if indexPath.row == flightScrollViewFlag + 0{
            return 55
        }else if indexPath.row == flightScrollViewFlag + 1{
            return 55
        }else if indexPath.row == flightScrollViewFlag + 2{
            return 55
        }
        return 92

    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: coCarSearchTableViewHeaderCellIdentify, for: indexPath) as! CoCarSearchTableViewHeaderCell
            cell.coCarClickListener = self
            cell.selectionStyle = .none
            return cell
        }
        if indexPath.row == 0 && flightScrollViewFlag == 1{ //历史订单 展示
            let cell = tableView.dequeueReusableCell(withIdentifier: coCarSearchTableViewScrollViewCellIdentify, for: indexPath) as! CoCarSearchTableViewScrollViewCell
            //cell.fullCell(data: journeyList, orderType: orderCarType,flightIndex: flightIndex)
            cell.fillDataSources(flightList: flightOrderList.personalFlightInfos, orderType: orderCarType, flightIndex: flightIndex)
            cell.coCarClickListener = self
            cell.selectionStyle = .none
            return cell
        }else if indexPath.row == flightScrollViewFlag + 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: coCarSearchTableViewAddressViewCellIdentify, for: indexPath) as! CoCarSearchTableViewAddressViewCell
            self.fullCellData(cell: cell, row: 0)
            cell.selectionStyle = .none
            return cell
        }else if indexPath.row == flightScrollViewFlag + 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: coCarSearchTableViewAddressViewCellIdentify, for: indexPath) as! CoCarSearchTableViewAddressViewCell
            self.fullCellData(cell: cell, row: 1)
            cell.selectionStyle = .none
            return cell
        }else if indexPath.row == flightScrollViewFlag + 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: coCarSearchTableViewTimeViewCellIdentify, for: indexPath) as! CoCarSearchTableViewTimeViewCell
            self.fullCellData(cell: cell, row: 2)
            cell.selectionStyle = .none
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: coCarSearchSubmitViewCellIdentify, for: indexPath) as! CoCarSearchSubmitViewCell
        cell.selectionStyle = .none
        cell.submitButton.addTarget(self, action: #selector(searchButton(sender:)), for: UIControlEvents.touchUpInside)
        return cell

    }
    
    func fullCellData (cell:UITableViewCell,row:Int){
        if row == 0 {
            let cel = cell as! CoCarSearchTableViewAddressViewCell
            if orderCarType == .pick {
                cel.fullCell(data: pickData[0])
            }else if orderCarType == .send {
                cel.fullCell(data: sendData[0])
            }else if orderCarType == .about {
                cel.fullCell(data: aboutData[0])
            }
        }else if row == 1{
            let cel = cell as! CoCarSearchTableViewAddressViewCell
            if orderCarType == .pick {
                cel.fullCell(data: pickData[1])
            }else if orderCarType == .send {
                cel.fullCell(data: sendData[1])
            }else if orderCarType == .about {
                cel.fullCell(data: aboutData[1])
            }
        }else if row == 2 {
            let cel = cell as! CoCarSearchTableViewTimeViewCell
            if orderCarType == .pick {
                cel.fullCell(data: pickData[2])
            }else if orderCarType == .send {
                cel.fullCell(data: sendData[2])
            }else if orderCarType == .about {
                cel.fullCell(data: aboutData[2])
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == flightScrollViewFlag + 0 {
            if orderCarType == .about {
                let vc = CoCarAddressViewController()
                vc.coCarClickListener = self
                vc.row = 0
                self.navigationController?.pushViewController(vc, animated: true)
            }else {
                intoNextAirportView()
            }
            
        }else if indexPath.row == flightScrollViewFlag + 1 {
            let vc = CoCarAddressViewController()
            vc.coCarClickListener = self
            vc.row  = 1
            if orderCarType == .pick {
                vc.city = coCarForm.startCityName
            }else if orderCarType == .send {
                vc.city = coCarForm.endCityName
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == flightScrollViewFlag + 2  {
            weak var weakSelf = self
            let bookDateView =  TBIDateTimeView.init(frame: ScreenWindowFrame)
            bookDateView.afterHoursPermission = 2
            bookDateView.countDate = 90
            bookDateView.currentDate = Date()
            bookDateView.customDateDataSources()
            bookDateView.dateTimeViewDateBlock = { (result) in
                if weakSelf?.orderCarType == .pick {
                    weakSelf?.pickData[2].value = result
                }else if weakSelf?.orderCarType == .send {
                    weakSelf?.sendData[2].value = result
                }else if weakSelf?.orderCarType == .about {
                    weakSelf?.aboutData[2].value = result
                }
                weakSelf?.tableView.reloadData()
            }
            KeyWindow?.addSubview(bookDateView)
        }
        
        
    }
    
    /// 显示 机场信息
    func intoNextAirportView() {
        weak var weakSelf = self
        let airportView = CityAndAirportSVViewController()
        airportView.cityAndAirportSVViewSelectedResultBlock = { airport in
            
            if weakSelf?.orderCarType == .pick {
                weakSelf?.pickData[0].value = airport.airportName//cityName
            }else if weakSelf?.orderCarType == .send {
                weakSelf?.sendData[0].value  = airport.airportName//cityName
            }
            self.requestMapPoi(keyword: airport.airportName)
            weakSelf?.flightIndex = -1
            weakSelf?.tableView.reloadData()
        }
        self.navigationController?.pushViewController(airportView, animated: true)
        /*
         citySelectorViewController.citySelectorBlock = { (cityName,cityCode) in
         if weakSelf?.orderCarType == .pick {
         weakSelf?.pickData[0].value = cityName
         }else if weakSelf?.orderCarType == .send {
         weakSelf?.sendData[0].value  = cityName
         }
         self.requestMapPoi(keyword: cityName)
         weakSelf?.flightIndex = -1
         weakSelf?.tableView.reloadData()
         }
         
         */
    }
    

    func intoNextAirportViewOld() {
        let citySelectorViewController = CitySelectorViewController()
        weak var weakSelf = self
        citySelectorViewController.citySelectorBlock = { (cityName,cityCode) in
            if weakSelf?.orderCarType == .pick {
                weakSelf?.pickData[0].value = cityName
            }else if weakSelf?.orderCarType == .send {
                weakSelf?.sendData[0].value  = cityName
            }
            self.requestMapPoi(keyword: cityName)
            weakSelf?.flightIndex = -1
            weakSelf?.tableView.reloadData()
        }
        citySelectorViewController.setCityType(type: .carAirport)
        CityService.sharedInstance.getGroups(.carAirport).subscribe{ event in
            if case .next(let e) = event {
                citySelectorViewController.city = e
                self.navigationController?.pushViewController(citySelectorViewController, animated: true)
            }
            }.addDisposableTo(self.bag)
    }
    
    
    
    
}

extension CoCarSearchViewController: CoCarClickListener,AMapSearchDelegate{
    
    func onOrderTypeClickListener(orderType:OrderCarTypeEnum) -> Void{
        self.orderCarType = orderType
        if orderType == .send {
            self.requestMapPoi(keyword: self.flightOrderList.personalFlightInfos.first?.depAirport ??  "")
        }
        if orderType == .about {
            self.flightScrollViewFlag = 0
            self.tableView.reloadSections([1], with: .right)
        }else {
            self.flightScrollViewFlag = flightOrderList.personalFlightInfos.isEmpty ? 0:1
            self.tableView.reloadSections([1], with: .none)
        }
        //self.tableView.reloadData()
    }
    
    func onAirportClickListener(row:Int) -> Void{
        self.flightIndex = row
        if row == -1 {
            self.sendData[0].value  = ""
            
            self.pickData[0].value = ""
            
        }else if flightOrderList.count > row {
            self.sendData[0].value  = self.flightOrderList.personalFlightInfos[row].depAirport
            self.sendData[2].value = self.flightOrderList.personalFlightInfos[row].depDate + " " + self.flightOrderList.personalFlightInfos[row].depTime
            
            
            self.pickData[0].value = self.flightOrderList.personalFlightInfos[row].arrAirport
            self.pickData[2].value = self.flightOrderList.personalFlightInfos[row].arrDate + " " + self.flightOrderList.personalFlightInfos[row].arrTime
        }
        if row != -1 && flightOrderList.count > row {
            if orderCarType == .pick {
                self.requestMapPoi(keyword: self.flightOrderList.personalFlightInfos[row].arrAirport)
            }else if orderCarType == .send  && flightOrderList.count > row {
                self.requestMapPoi(keyword: self.flightOrderList.personalFlightInfos[row].depAirport)
            }
        }
        
        
        
        self.tableView.reloadData()
    }
    
    func DateConvertFromString(date:String) -> String {
        return ""
    }
    
    
    
    
    func onAddressClickListener(model:CoPointAddressModel,row:Int) -> Void{
        if orderCarType == .pick {
            self.pickData[row].value  = model.name
            self.pickData[row].model = model

        }else if orderCarType == .send {
            self.sendData[row].value  = model.name
            self.sendData[row].model = model

        }else if orderCarType == .about {
            self.aboutData[row].value = model.name
            self.aboutData[row].model = model

        }
        self.tableView.reloadData()
    }
    
    
    /// 搜索城市
    func requestMapPoi(keyword:String) {
        let request:AMapPOIKeywordsSearchRequest = AMapPOIKeywordsSearchRequest()
        request.requireExtension = true
        request.keywords = keyword
        amapSearch.aMapPOIKeywordsSearch(request)
    }
    
    /// 搜索接送机城市给 选目的地用
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        let model = response.pois.first
        if orderCarType == .pick {
            coCarForm.startLatitude = "\(model?.location.latitude ?? 0)"
            coCarForm.stratLongitude = "\(model?.location.longitude ?? 0)"
            coCarForm.startCityName = model?.city ?? ""
        }else if orderCarType == .send {
            coCarForm.endLatitude = "\(model?.location.latitude ?? 0)"
            coCarForm.endLongitude = "\(model?.location.longitude ?? 0)"
            coCarForm.endCityName = model?.city ?? ""
        }
        
    }
    
    func searchButton(sender:UIButton){
        coCarForm.carType = orderCarType.rawValue
        if orderCarType == .pick {
            coCarForm.startTime = pickData[2].value
            coCarForm.startAddress = pickData[0].value
            coCarForm.endAddress = self.pickData[1].value
            coCarForm.endCityName = self.pickData[1].model?.city ?? ""
            coCarForm.endLatitude = "\(self.pickData[1].model?.latitude ?? 0)"
            coCarForm.endLongitude = "\(self.pickData[1].model?.longitude ?? 0)"
        }else if orderCarType == .send {
            coCarForm.startTime = sendData[2].value
            coCarForm.endAddress = sendData[0].value
            
            coCarForm.startAddress = self.sendData[1].value
            coCarForm.startCityName = self.sendData[1].model?.city ?? ""
            coCarForm.startLatitude = "\(self.sendData[1].model?.latitude ?? 0)"
            coCarForm.stratLongitude = "\(self.sendData[1].model?.longitude ?? 0)"
        }else if orderCarType == .about {
            coCarForm.startAddress = self.aboutData[0].value
            coCarForm.startCityName = self.aboutData[0].model?.city ?? ""
            coCarForm.startLatitude = "\(self.aboutData[0].model?.latitude ?? 0)"
            coCarForm.stratLongitude = "\(self.aboutData[0].model?.longitude ?? 0)"
            
            coCarForm.endAddress = self.aboutData[1].value
            coCarForm.endCityName = self.aboutData[1].model?.city ?? ""
            coCarForm.endLatitude = "\(self.aboutData[1].model?.latitude ?? 0)"
            coCarForm.endLongitude = "\(self.aboutData[1].model?.longitude ?? 0)"
            coCarForm.startTime = aboutData[2].value
        }
        if coCarForm.startAddress.isEmpty {
            alertView(title: "提示",message: "请输入出发地")
            return
        }
        if coCarForm.endAddress.isEmpty {
            alertView(title: "提示",message: "请输入目的地")
            return
        }
        if coCarForm.startTime.isEmpty {
            alertView(title: "提示",message: "请选择用车时间")
            return
        }
        let vc = CoCarTypeViewController()
        vc.coCarForm = self.coCarForm
        vc.travelNo = self.travelNo
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

///  右侧差旅政策按钮
extension CoCarSearchViewController{
    
//    func initRightButtonData () {
//        let traveller = PassengerManager.shareInStance.passengerDraw().first
//        NewUserService.sharedInstance.getPolicy(id: traveller?.uid ?? "").subscribe{ event in
//            switch event{
//            case .next(let e):
//                self.userPolicy = e
//                if e.carDesc.isNotEmpty {
//                    self.initRightButton ()
//                }
//            case .error(let e):
//                try? self.validateHttp(e)
//            case .completed:
//                break
//            }
//            }.addDisposableTo(self.bag)
//    }
    
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
        let policy:String = PassengerManager.shareInStance.passengerSVDraw().first?.carPolicyShow ?? ""
        var modifyPolicy:[String] = Array()
        var resultPolicy:String = ""
        if policy.isEmpty == false {
            modifyPolicy = policy.components(separatedBy: "。")
            for element in modifyPolicy {
                resultPolicy += element + "\n"
            }
        }
        vi.fullData(title: "专车预订差旅标准",subTitle:"符合差旅标准价位:", content:resultPolicy)
        KeyWindow?.addSubview(vi)
    }
}
