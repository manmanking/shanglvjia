//
//  HotelListViewController.swift
//  shop
//
//  Created by manman on 2017/4/20.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import RxSwift
import MJRefresh

class HotelCompanyListViewController:CompanyBaseViewController,UITableViewDelegate,UITableViewDataSource{

    typealias HotelCompanySearcherAndListSearchConditionAccord = (HotelSearchForm)->Void

    //订单跳转 本页面标志
    public var travelNo:String = ""
    public var searchCondition = HotelSearchForm()
    public var hotelCompanySearcherAndListSearchConditionAccord:HotelCompanySearcherAndListSearchConditionAccord!
    public var userDetail:LoginResponse?
    private var regionDataSourcesSelectedIndex:[NSInteger] = Array()
    
    private let hotelCompanyListTableViewCellIdentify = "hotelCompanyListTableViewCellIdentify"
    private let hotelCompanyListTableViewHeaderViewIdentify = "hotelCompanyListTableViewHeaderViewIdentify"
    private var  searchResult:[HotelCompanyListItem]? = nil
    private let bag = DisposeBag()
    private var pageIndex:NSInteger = 1
    private var tableView = UITableView()
    private var screenView = TBISortCriteriaView()
    private var accordTravel:Float = 0
    private var topBackgroundView:UIView = UIView()
    private var topHeaderView:HotelListTableViewHeaderView = HotelListTableViewHeaderView(reuseIdentifier: "HotelListTableViewHeaderViewIdentify")
    private var cityRegionDataSource:[(title:String,code:String)] = Array()
    
    
    private var hotelFilterView:HotelFilterView = HotelFilterView()
    
    private var hotelList:HotelListNewModel = HotelListNewModel()
    
    ///  酒店当前城市的 差标价格
    private var currentPolicyPrice:String = ""
    
    //非丰田
    private let priceOrderRegularArr:[String] = ["不限","0-300","301-350","351-800","800以上",""]
    //丰田
    private let priceFTMSOrderRegularArr:[String] = ["不限","300-440","441-550","551-650","650以上",""]
    
    private let starOrderArr:[String] = ["不限","五星","四星","三星","二星","一星"]
    
    private let mapPatternView:HotelMapListView = HotelMapListView()
    
    private var mapRegionRadiusSearchView:MapRegionRadiusSearchView = MapRegionRadiusSearchView()
    
    private var localLatitude:Double = 0
    
    private var longLatitude:Double = 0
    
    /// 列表展示 样式。0 列表。1 地图展示
    private var hotelListViewShowPatternType:NSInteger = 0
   
    /// 违反差标是否可以购买
    var anOrder:Bool = true
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userDetail = DBManager.shareInstance.userDetailDraw()
        setNavigationBackButton(backImage: "left")
         UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        
        
        self.view.backgroundColor = TBIThemeBaseColor
        setNavigationBgColor(color: TBIThemeWhite)
        setUIViewAutolayout()
        currentPolicyPrice = HotelManager.shareInstance.searchConditionCityCategoryRegionDraw().travelpolicyLimit
        regionDataSourcesSelectedIndex.append(0)
        getHotelList(isRefresh: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = false
        setNavigationBgColor(color: TBIThemeWhite)
        let searchCondition = HotelManager.shareInstance.searchConditionUserDraw()
        var passengerId:[String] = Array()
        for element in PassengerManager.shareInStance.passengerSVDraw(){
            passengerId.append(element.passagerId)
        }
        searchCondition.parIds = passengerId
        HotelManager.shareInstance.searchConditionUserStore(searchCondition: searchCondition)
        topHeaderView.fillDataSources(searchCondition: searchCondition)
        resetLocalView()
        
        topBackgroundView.isHidden=false
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         topBackgroundView.isHidden=true
    }
    
    //MARK:- 定制视图
    
    func setUIViewAutolayout() {
        weak var weakSelf = self
        setTopView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = TBIThemeBaseColor
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.register(HotelListTableViewCell.classForCoder(), forCellReuseIdentifier: hotelCompanyListTableViewCellIdentify)
        tableView.register(UINib(nibName: "TableNoDateView", bundle: nil), forHeaderFooterViewReuseIdentifier: "TableNoDateView")
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            weakSelf?.refreshDataSources()
        })
        tableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: {
            weakSelf?.loadMoreDataSources()
        })
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            //make.top.equalTo(topBackgroundView.snp.bottom)
            make.top.equalToSuperview()
            make.left.bottom.right.equalToSuperview()
        }
        
        filterHotelView()
        mapPatternView.backgroundColor  = UIColor.green
        self.view.addSubview(mapPatternView)
        mapPatternView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        mapPatternView.hotelMapListViewSelectedBlock = { selectedIndex in
            weakSelf?.nextHotelDetailView(selectedHotelIndex: selectedIndex)
        }
        mapPatternView.hotelMapListViewUpdateHotelBlock = { (lon,lat) in
            weakSelf?.updateUserDragMapHotel(lon: lon, lat: lat)
        }
        
        self.view.sendSubview(toBack: mapPatternView)
    }
    
    
    
    func filterHotelView() {
        weak var weakSelf = self
        self.view.addSubview(hotelFilterView)
        hotelFilterView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(5)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().inset(5)
        }
        hotelFilterView.hotelFilterViewBlock = { index in
            weakSelf?.filterViewSelectedPattern(index: index)
        }
    }
    
    
    /// 老版 筛选视图
    func screenViewOld() {
        weak var weakSelf = self
        if userDetail?.busLoginInfo.userBaseInfo.corpCode != nil &&
            Toyota == userDetail?.busLoginInfo.userBaseInfo.corpCode  {
            screenView.priceDataSourcesArr = priceFTMSOrderRegularArr
        }else
        {
            screenView.priceDataSourcesArr = priceOrderRegularArr
        }
        
        screenView.starDataSourcesArr = starOrderArr
        self.view.addSubview(screenView)
        screenView.snp.makeConstraints { (make) in
            
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(50)
        }
        
        
        screenView.priceScreenBlock = { (parameter) in
            
           // weakSelf?.getHotelPriceScreenList(parameter: parameter)
            
        }
        screenView.starScreenBlock = { (parameter) in
            
          // weakSelf?.getHotelStarScreenList(parameter: parameter)
            
        }
        screenView.starOrderBlock = { (parameter) in
            
           // weakSelf?.getHotelStarOrderList(parameter: parameter)
        }
        
        screenView.priceOrderBlock = { (parameter ) in
            
           // weakSelf?.getHotelPriceOrderList(parameter: parameter)
            
        }
        
    }
    
    
    
    func setTopView() {
        
        topBackgroundView.frame = CGRect.init(x: 34, y: 5, width: ScreenWindowWidth-60, height: 30)
        self.navigationController?.navigationBar.addSubview(topBackgroundView)
        weak var weakSelf = self
        topBackgroundView.addSubview(topHeaderView)
        topHeaderView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        topHeaderView.hotelListSelctedDateBlock = {(parameter) in
            
            //weakSelf?.nextViewSpecialCalendar(paramater: parameter)
            weakSelf?.nextViewTBICalendar(paramater: parameter)
        }
        
        topHeaderView.hotelListHeaderSearchBlock = { (parameter) in
            
            //self.getHotelKeywordList(parameters: parameter)
            weakSelf?.getHotelCityRegionKeywordList(parameters:parameter)
            
        }
        topHeaderView.hotelListHeaderRegionBlock = { (selectedTitle) in
            
            //self.getRegionList(city: self.searchCondition.cityId)
            
        }
        topHeaderView.hotelListHeaderRegionRadiusBlock = { _ in
            weakSelf?.showMapRegionRadiusView()
        }
        topHeaderView.hotelListHeaderPassengerBlock = { _ in
            weakSelf?.showPassengerView()
        }
        
        topHeaderView.fillDataSources(searchCondition: HotelManager.shareInstance.searchConditionUserDraw())
        //topHeaderView.fillDataSources(searchCondition: searchCondition)
        
    }
    
    func resetLocalView() {
        pageIndex = 1
    }
    
    /// 地图模式搜索数据
    /// 将行政区 地标 商圈 去掉

    func updateUserDragMapHotel(lon:Double,lat:Double) {
        let searchCondition = HotelManager.shareInstance.searchConditionUserDraw()
        searchCondition.latitude = lat
        searchCondition.longitude = lon
        searchCondition.districtRegion = CityCategoryRegionModel.RegionModel()
        searchCondition.districtId = ""
        searchCondition.landmarkRegion = CityCategoryRegionModel.RegionModel()
        searchCondition.landmarkId = ""
        searchCondition.landmarkName = ""
        searchCondition.commericalRegion = CityCategoryRegionModel.RegionModel()
        searchCondition.commericalId = ""
        HotelManager.shareInstance.searchConditionUserStore(searchCondition: searchCondition)
        getHotelList(isRefresh: true,isMapSearch: true)
    }
    
    
    //MARK:- UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if searchResult != nil
//        {
//
//            return (searchResult?.count)!
//        }
        return hotelList.result.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
        return configCell(indexCell: indexPath)
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if hotelList.result.count == 0 {
            return tableView.frame.height
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableNoDateView") as? TableNoDateView {
            footer.setType(.noNewOrder)
            footer.messageLabel.text="当前条件下暂未查询到酒店"
            return footer
        }
        return nil
    }
    
    
    
    //MARK:- UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 129
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        printDebugLog(message: "didSelectRow ")
        nextHotelDetailView(selectedHotelIndex: indexPath.row)
        
        
    }
    
    
    private func configCell(indexCell:IndexPath)->HotelListTableViewCell
    {
        let cell:HotelListTableViewCell = tableView.dequeueReusableCell(withIdentifier: hotelCompanyListTableViewCellIdentify) as!HotelListTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        //let hotelListItem:HotelCompanyListItem = (searchResult?[indexCell.row])!
        let hotelListItem:HotelListNewItem = (hotelList.result[indexCell.row])
        cell.fillDataSources(hotelItem: hotelListItem, policyPrice: currentPolicyPrice)
        return cell
    }
    
    func dispatchRequest() {
        let requestGroup = DispatchGroup()//创建group
        
        showLoadingView()
        searchCondition.pageIndex = 1
        searchCondition.pageSize = 10
        pageIndex = 1
        requestGroup.enter()
        weak var weakSelf = self
        HotelCompanyService.sharedInstance
            .getHotelsList(searchCondition:searchCondition)
            .subscribe { (event) in
                if case .next(let result) = event {
                    weakSelf?.searchResult = result
                    weakSelf?.tableView.reloadData()
                }
                if case .error(let result) = event {
                    print(result)
                    try? weakSelf?.validateHttp(result)
                    //weakSelf?.showSystemAlertView(titleStr: "提示", message: String(describing: result))
                }
                requestGroup.leave()
            }.disposed(by: bag)
        
        requestGroup.enter()
        CitysService.sharedInstance
            .getDistrict(cityId:self.searchCondition.cityId)
            .subscribe { (event) in
                
                if case .next(let result) = event {
                    print(result)
                }
                if case .error(let result) = event {
                    try? weakSelf?.validateHttp(result)
                    //weakSelf?.showSystemAlertView(titleStr: "提示", message: String(describing: result))
                }
                requestGroup.leave()
            }.disposed(by: bag)
        
        
        
        requestGroup.notify(queue:DispatchQueue.main) {
            print("Group tasks are done")
            self.hideLoadingView()
        }
    }
    
    //MARK:----刷新数据
    
    func refreshDataSources() {
        pageIndex = 1
        let searchUserCondition =  HotelManager.shareInstance.searchConditionUserDraw()
        searchUserCondition.pageNum = pageIndex
        HotelManager.shareInstance.searchConditionUserStore(searchCondition: searchUserCondition)
        getHotelList(isRefresh: true)
        tableView.mj_header.endRefreshing()
        
    }
    
    func loadMoreDataSources() {
        let searchUserCondition =  HotelManager.shareInstance.searchConditionUserDraw()
        searchUserCondition.pageNum = pageIndex
        HotelManager.shareInstance.searchConditionUserStore(searchCondition: searchUserCondition)
        getHotelList(isRefresh: false)
        tableView.mj_footer.endRefreshing()
    }
    
    
    
    // MARK:-------- NET----
    ///获得网络数据-  搜索列表
    
    func getHotelList(isRefresh:Bool,isMapSearch:Bool = false) {
        let hotelListRequest:HotelListRequest = HotelManager.shareInstance.searchConditionUserDraw() //HotelListRequest.hotelSearchFormConvertToHotelListRequest(searchCondition: searchCondition)
        hotelListRequest.corpCode = DBManager.shareInstance.userDetailDraw()?.busLoginInfo.userBaseInfo.corpCode ?? ""
        ///如果是当前城市传入经纬度
        if hotelListRequest.cityName == hotelListRequest.currentCityName{
            hotelListRequest.latitude = hotelListRequest.userLatitude
            hotelListRequest.longitude = hotelListRequest.userLongitude
        }else{
            hotelListRequest.latitude = 0
            hotelListRequest.longitude = 0
        }
        
        if isRefresh == true {
            hotelListRequest.sId = ""
        }else {
            hotelListRequest.sId = hotelList.sId
        }
        weak var weakSelf = self
        showLoadingView()
        HotelService.sharedInstance
            .getHotelList(hotelListRequest)
            .subscribe { (event) in
                weakSelf?.hideLoadingView()
                switch event {
                case .next(let element):
                    printDebugLog(message: element)
                    
                    if isRefresh == true {
                        weakSelf?.pageIndex = 2
                        weakSelf?.hotelList = element
                    }else {
                        weakSelf?.hotelList.result.append(contentsOf: element.result)
                        weakSelf?.pageIndex += 1
                    }
                    if weakSelf?.hotelListViewShowPatternType == 0 {
                        weakSelf?.tableView.reloadData()
                    }else {
                        weakSelf?.mapPatternView.fillDataSources(hotelDataSources:element,isMapSearch: isMapSearch)
                        weakSelf?.topHeaderView.fillDataSources(searchCondition: hotelListRequest,isMapSearch:isMapSearch)
                    }
                case .error(let error):
                    try? weakSelf?.validateHttp(error)
                case .completed:
                    break
                }
        }.disposed(by: bag)

    }
    
    
    func  getHotelListOld() {
        searchCondition.pageIndex = 1
        searchCondition.pageSize = 10
        pageIndex = 1
        
        weak var weakSelf = self
        showLoadingView()
        HotelCompanyService.sharedInstance
            .getHotelsList(searchCondition:searchCondition)
            .subscribe { (event) in
                weakSelf?.hideLoadingView()
                if case .next(let result) = event {
                    weakSelf?.searchResult = result
                    weakSelf?.tableView.reloadData()
                    //满足某人的需求，说真的挺傻逼的
                    if result.count <= 5 && self.pageIndex <= 5{
                        self.loadMoreDataSources()
                    }else{
                        weakSelf?.hideLoadingView()
                    }
                }
                
                if case .error(let result) = event {
                    print(result)
                    try? weakSelf?.validateHttp(result)
                    //weakSelf?.showSystemAlertView(titleStr: "提示", message: String(describing: result))
                }
            }.disposed(by: bag)
    }
    
    // MARK:- 获得网络数据- 价格筛选列表
//    func getHotelPriceScreenList(parameter:Dictionary<String, Any>) {
//
//        print("价格筛选列表 ")
//        let selectConditionArr:Array<String> = parameter[HotelCustomScreenDetermineConditionDetail] as! Array
//
//        guard selectConditionArr.count >= 1 else
//        {
//            getHotelList()
//            return
//        }
//        let priceCondition:String = selectConditionArr[0]
//        if priceCondition.characters.count > 2 {
//            let priceArr = priceCondition.components(separatedBy: "-")
//            searchCondition.lowRate = Int(priceArr[0])
//            searchCondition.highRate = Int(priceArr[1])
//            //可以筛选300 -300 的价格
////            if  Int(priceArr[0]) == Int(priceArr[1]){
////               searchCondition.highRate = 10000
////            }
//           screenView.priceScreenButton.isSelected = true
//        }else
//        {
//            searchCondition.lowRate = 0
//            searchCondition.highRate = 0
//            screenView.priceScreenButton.isSelected = false
//        }
//        getHotelList()
//    }
//
    
    // MARK:- 获得网络数据- 星级筛选列表
//    func getHotelStarScreenList(parameter:Dictionary<String, Any>) {
//
//        print("星级排序列表")
//        let selectConditionArr:Array<String> = parameter[HotelCustomScreenDetermineConditionDetail] as! Array
//        if selectConditionArr.count < 1 {
//            getHotelList()
//            return
//        }
//
//        //不限 参数 用 0 代替
//        var selectedIndexArr:[String] = Array()
//        for index in 0..<selectConditionArr.count
//        {
//            for subIndex in 0..<starOrderArr.count
//            {
//                if selectConditionArr[index] == starOrderArr[subIndex]
//                {
//                    if subIndex == 0 {
//                        selectedIndexArr.append("0")
//                        continue
//                    }
//                    selectedIndexArr.append( String(6 - subIndex) )
//                }
//            }
//        }
//
//
////        let selectedConditinStr = ",".join(selectedIndexArr)
//        let selectedConditionStr = selectedIndexArr.joined(separator: ",")
//
//        if selectedConditionStr != "0"{
//            screenView.starScreenButton.isSelected = true
//        }else{
//            screenView.starScreenButton.isSelected = false
//        }
//
//        searchCondition.starRate = selectedConditionStr
//        getHotelList()
//    }
    
//    func getHotelStarOrderList(parameter:Dictionary<String, Any>) {
//
//        print("星级排序列表")
//
//        let selectedConditionStr:String = parameter[hotelListStarOrderState] as! String
//
//        if selectedConditionStr == "down"
//        {
//            searchCondition.sort = HotelSearchForm.Sort.starRankDesc.rawValue
//        }
//        else
//        {
//            searchCondition.sort = nil
//        }
//
//        getHotelList()
//    }
//
    // MARK:- 获得网络数据- 价格排序列表
//    func getHotelPriceOrderList(parameter:Dictionary<String, Any>) {
//
//        print("价格排序")
//        let rankWard:String = parameter[hotelListPriceOrderState] as! String
//        //升序
//        if rankWard == "up" {
//            print("价格升排序")
//            searchCondition.sort  = HotelSearchForm.Sort.rateAsc.rawValue
//        }else  if rankWard == "down"// 降序
//        {
//            print("价格降排序")
//            searchCondition.sort  = HotelSearchForm.Sort.rateDesc.rawValue
//        }
//        else
//        {
//            searchCondition.sort = nil
//        }
//
//        getHotelList()
//    }
    
//
//    // 关键字 搜索
//    func getHotelKeywordList(parameters:Dictionary<String,Any>)  {
//        let checkinDate:String = parameters["HotelListSelectedCheckinDate"] as! String
//        let checkoutDate:String = parameters["HotelListSelectedCheckoutDate"] as! String
//        let keyword:String = parameters["HotelListHeaderSearchConditionKeyword"] as! String
//
//        searchCondition.arrivalDate = checkinDate
//        searchCondition.departureDate = checkoutDate
//        searchCondition.keyWord = keyword
//        getHotelList()
//
//    }
    
    
    func nextHotelDetailView(selectedHotelIndex:NSInteger) {
        let hotelDetailView = HotelDetailViewController()
        let searchCondition = HotelManager.shareInstance.searchConditionUserDraw()
        hotelDetailView.roomDetailRequest.arrivalDate = searchCondition.arrivalDate
        hotelDetailView.roomDetailRequest.departureDate = searchCondition.departureDate
        hotelDetailView.roomDetailRequest.corpCode = searchCondition.corpCode
        hotelDetailView.roomDetailRequest.hotelElongId = hotelList.result[selectedHotelIndex].hotelId
        hotelDetailView.title = hotelList.result[selectedHotelIndex].hotelName
        hotelDetailView.roomDetailRequest.ownHotelId = hotelList.result[selectedHotelIndex].hotelOwnId
        hotelDetailView.accordTravel = Float(currentPolicyPrice ) ?? 0
        var parIds:[String] = Array()
        for element in PassengerManager.shareInStance.passengerSVDraw() {
            parIds.append(element.passagerId)
        }
        //let parId = parIds.remove(at: parIds.index(before: parIds.endIndex))
        hotelDetailView.roomDetailRequest.parIds = parIds
        self.navigationController?.pushViewController(hotelDetailView, animated: true)
    }
    
    
    func getHotelCityRegionKeywordList(parameters:Dictionary<String,Any>)  {
        guard hotelListViewShowPatternType == 0 else {
            return
        }
        nextViewLandMark()
        
    }
    
    /// 进入行政区 视图
    func nextViewLandMark() {
        let searchCondition = HotelManager.shareInstance.searchConditionUserDraw()
        weak var weakSelf = self
        let landmarkView = LandMarkViewController()
        landmarkView.elongId = searchCondition.cityId
        landmarkView.landMarkViewSelectedRegionBlock = { (region,index) in
                weakSelf?.searchRegion(region: region, index: index)
                weakSelf?.getHotelList(isRefresh: true)
        }
        self.navigationController?.pushViewController(landmarkView, animated: true)
    }
    
    private func searchRegion(region:CityCategoryRegionModel.RegionModel,index:NSInteger) {
        let searchCondition:HotelListRequest = HotelManager.shareInstance.searchConditionUserDraw()
        searchCondition.districtRegion = CityCategoryRegionModel.RegionModel()
        searchCondition.districtId = ""
        searchCondition.landmarkRegion = CityCategoryRegionModel.RegionModel()
        searchCondition.landmarkId = ""
        searchCondition.commericalRegion = CityCategoryRegionModel.RegionModel()
        searchCondition.commericalId = ""
        switch index {
        case 0:
            searchCondition.districtRegion = region
            searchCondition.districtId = region.id
        case 1:
            searchCondition.landmarkRegion = region
            searchCondition.landmarkId = region.id
        case 2:
            searchCondition.commericalRegion = region
            searchCondition.commericalId = region.id
            
        default:
            break
        }
        searchCondition.searchRegion = region.name
        HotelManager.shareInstance.searchConditionUserStore(searchCondition: searchCondition)
        topHeaderView.fillDataSources(searchCondition: HotelManager.shareInstance.searchConditionUserDraw())
    }
    
    /// 展示 行政区域
    func showMapRegionRadiusView() {
        mapRegionRadiusSearchView.alpha = 0.6
        self.view.addSubview(mapRegionRadiusSearchView)
        mapRegionRadiusSearchView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview().inset(5)
            make.width.equalTo(95)
            make.height.equalTo(5 * 44)
        }
        weak var weakSelf = self
        mapRegionRadiusSearchView.mapRegionRadiusSearchSelectedBlock = { radiusTitle,regionRadius in
            weakSelf?.modifyRegionRadius(radiusTitle: radiusTitle, radius: regionRadius)
        }
        
        
        let dataSources:[(String,String)] = [("不限","20000"),("<500M","500"),("<1000M","1000"),("<3000M","3000"),("5000M","5000")]
        mapRegionRadiusSearchView.fillDataSources(dataSources: dataSources)
        self.view.bringSubview(toFront: mapRegionRadiusSearchView)
    }
    
    func modifyRegionRadius(radiusTitle:String,radius:String) {
        
        let searchUserCondition = HotelManager.shareInstance.searchConditionUserDraw()
        searchUserCondition.radius = NSInteger(radius)!
        searchUserCondition.radiusTitle = radiusTitle
        HotelManager.shareInstance.searchConditionUserStore(searchCondition: searchUserCondition)
        getHotelList(isRefresh: true)
        
        
    }
    
    func showPassengerView() {
        if (userDetail?.busLoginInfo.userBaseInfo.isSecretary == "1" || userDetail?.busLoginInfo.userBaseInfo.isSecretary == "3") {
            let staffView = HotelCompanyStaffViewController()
            staffView.hotelCompanyStaffViewType = HotelCompanyStaffViewType.Hotel
            self.navigationController?.pushViewController(staffView, animated: true)
        }
        
    }
    
    
    
    //MARK:- Action
    
    
    func logoutButtonAction(sender:UIButton) {
        
        printDebugLog(message: "logoutButtonAction ...")
        let companyAccountView = CompanyAccountViewController()
        companyAccountView.title = "企业账号登录"
        self.navigationController?.pushViewController(companyAccountView, animated: true)
//        let loginView = LoginViewController()
//        self.navigationController?.pushViewController(loginView, animated: true)
        
        
    }

    
    func nextViewTBICalendar(paramater:Dictionary<String, Any>) {
        let calendarView = TBICalendarViewController()
        calendarView.calendarAlertType = TBICalendarAlertType.Hotel
        calendarView.calendarTypeAlert = ["请选择入住日期","请选择离店日期"]
        calendarView.selectedDates = [HotelManager.shareInstance.searchConditionUserDraw().arrivalDateFormat,
                                      HotelManager.shareInstance.searchConditionUserDraw().departureDateFormat]
            //[paramater[HotelListSelectedCheckinDate] as! String,paramater[HotelListSelectedCheckoutDate] as! String]
        calendarView.isMultipleTap = true
        calendarView.showDateTitle = ["入住","离店"]
        weak var weakSelf = self
        calendarView.hotelSelectedDateAcomplishBlock = { (parameters,action) in
            
            weakSelf?.modifyDate(parameters: parameters, action: action)
            // 日期选择之后要搜索
            if action != TBICalendarAction.Back {
                weakSelf?.getHotelList(isRefresh: true)
            }
            
        }
        
        
        self.navigationController?.pushViewController(calendarView, animated: true)
    }
    
    
    func modifyDate(parameters:Array<String>?,action:TBICalendarAction) {
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
        topHeaderView.fillDataSources(searchCondition: searchCondition)
    }
    
    
    /// 进入地图模式
    func showMapPatternView() {
        self.view.bringSubview(toFront: mapPatternView)
        self.view.bringSubview(toFront: hotelFilterView)
        mapPatternView.fillDataSources(hotelDataSources:hotelList)
        topHeaderView.setViewType(type: HotelListTableViewHeaderView
            .HotelListHeaderViewType.HotelListHeaderView_MapList)
    }
    
    /// 进入列表模式
    func showListPatternView() {
        
        if HotelManager.shareInstance.searchConditionUserDraw().latitude == 0 {
            tableView.reloadData()
            
        }else{
            HotelManager.shareInstance.resetPartSearchConditionForMap2Lsit()
            getHotelList(isRefresh: true)
        }
        self.view.bringSubview(toFront: hotelFilterView)
        self.view.sendSubview(toBack: mapPatternView)
        topHeaderView.setViewType(type: HotelListTableViewHeaderView
            .HotelListHeaderViewType.HotelListHeaderView_FormList)
        
    }
    
    
    /// 进入 筛选条件页面
    func showSearchConditionView() {
        weak var weakSelf = self
        let searchConditionView = HotelSearchConditionViewController()
        searchConditionView.hotelSearchConditionViewSearchBlock = { _ in
            weakSelf?.getHotelList(isRefresh: true)
        }
        
        self.navigationController?.pushViewController(searchConditionView , animated:true)
    }
    
    
    /// 选择 筛选 方式
    ///
    /// - Parameter index:
    func filterViewSelectedPattern(index:NSInteger) {
        
        switch index {
        case 0:
            hotelListViewShowPatternType = 0
            showListPatternView()
        case 1:
            hotelListViewShowPatternType = 1
            showMapPatternView()
        case 2:
            showSearchConditionView()
        default:
            break
        }
        
        
    }
    
    
    
    
    
    
    
    override func backButtonAction(sender: UIButton) {
        
//        var isContainReservePage = false
//
//        let viewControllers = self.navigationController?.viewControllers
//        if (viewControllers?.count ?? 0) <= 4
//        {
//            for vc in viewControllers!
//            {
//                if vc is HotelSearchViewController
//                {
//                    isContainReservePage = true
//                    break
//                }
//            }
//        }
//        else
//        {
//            let index = self.navigationController?.viewControllers.index(of: self)
//            for i in 0..<3
//            {
//                let vc = viewControllers?[index! - i - 1]
//                if vc is HotelSearchViewController
//                {
//                    isContainReservePage = true
//                    break
//                }
//            }
//        }
//        if isContainReservePage {
//            if searchCondition.arrivalDate.characters.count < 11 {
//                searchCondition.arrivalDate = searchCondition.arrivalDate+" 00:00:00"
//                searchCondition.departureDate = searchCondition.departureDate+" 00:00:00"
//            }
//
//
//            self.hotelCompanySearcherAndListSearchConditionAccord(searchCondition)
//            _ = self.navigationController?.popViewController(animated: true)
//        }else {
//            self.navigationController?.popViewController(animated: true)
//            return
//        }
//        if searchCondition.arrivalDate.characters.count < 11 {
//            searchCondition.arrivalDate = searchCondition.arrivalDate+" 00:00:00"
//            searchCondition.departureDate = searchCondition.departureDate+" 00:00:00"
//        }
        if hotelCompanySearcherAndListSearchConditionAccord != nil {
            self.hotelCompanySearcherAndListSearchConditionAccord(searchCondition)
        }
        _ = self.navigationController?.popViewController(animated: true)
        
        
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
