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
import MJRefresh

class PSpecailOfferHotelViewController:  PersonalBaseViewController {
    
    ///导航头
    private var topView:PersonalNavbarTopView = PersonalNavbarTopView()
    
    let headerView = UIImageView()
    
    var  headerTable = UITableView()///上面的table
    var  listTableView = UITableView()///下面列表的table
    private let bag = DisposeBag()
    
    private let cityChinaMoreCityTipDefault:String = "更多"
    
    fileprivate var cityChinaArr:[HotelCityModel] = Array() //["北京","上海","天津","更多..."]
    fileprivate var cityInterArr:[HotelCityModel] = Array()//["日本","新加坡","迪拜","首尔","泰国","新加坡","迪拜"]
    
    fileprivate var cityIntenationalArr:[HotelCityModel] = Array()//["日本","新加坡","迪拜","首尔","泰国","新加坡","迪拜"]
    
    fileprivate var selectedChinaCity:HotelCityModel = HotelCityModel()
    
    fileprivate var selectedInteralCity:HotelCityModel = HotelCityModel()
    fileprivate var selectedStar:String = ""
    
    fileprivate var pageIndex:Int = 1
    
    
    /// 国内城市选择 idnex
    fileprivate var mainlandCitySelctedIndex:Int = 99
    
    /// 国际城市选择 idnex
    fileprivate var internationalCitySelctedIndex:Int = 99
    
    /// 国际 或者 国内。 国内 1 国际 2
    fileprivate var selectedChinaORInternationalIndex:String = "1"
    /// 城市列表
    private var cityGroupList:[HotelCityGroup] = Array()
    
    fileprivate var specialHotelListResponse:SpecialHotelListResponse = SpecialHotelListResponse()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
         initTopView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = TBIThemeBaseColor
        
        let currentViewController = getCurrentViewController()
        printDebugLog(message:getCurrentViewController().description)
        setUIViewAutolayout()
        fillDataSources()
        
    }
    
    
    func fillDataSources() {
        LocalStoreInternationalCities()
        localChinaCiy()
        getHotelCityNET()
    }
    
    func localChinaCiy() {
        let firstCity = HotelCityModel()
        firstCity.cnName = "北京"  //,,,,,,"北京","上海","天津","更多..."
        firstCity.elongId = "0101"
        let secondCity = HotelCityModel()
        secondCity.cnName = "天津"
        secondCity.elongId = "0301"
        let thirdCity = HotelCityModel()
        thirdCity.cnName = "成都"
        thirdCity.elongId = "2301"
        let forthCity = HotelCityModel()
        forthCity.cnName = cityChinaMoreCityTipDefault
        cityChinaArr = [firstCity,secondCity,thirdCity,forthCity]
    }
    
    func LocalStoreInternationalCities() {
        // 东京   179897 大阪  180027 新加坡
        let firstCity = HotelCityModel()
        firstCity.cnName = "东京"
        firstCity.elongId = "179900"
        let secondCity = HotelCityModel()
        secondCity.cnName = "新加坡"
        secondCity.elongId = "180027"
        let thirdCity = HotelCityModel()
        thirdCity.cnName = "大阪"
        thirdCity.elongId = "179897"
        let forthCity = HotelCityModel()
        forthCity.cnName = cityChinaMoreCityTipDefault
        cityInterArr = [firstCity,secondCity,thirdCity,forthCity]
    }
    
    
    
    /// 广告头
    func initHeaderView() -> UIView {
        headerView.frame = CGRect(x: 0, y: 0, width: Int(ScreenWindowWidth), height: 140 + kNavigationHeight - 44)
        headerView.sd_setImage(with: URL.init(string:"\(Html_Base_Url)/static/banner/subpage/hotel/ios/banner_hotel@3x.png"))
        return headerView
    }
    //MARK:- 定制视图
    func setUIViewAutolayout() {
        
        headerTable.delegate = self
        headerTable.dataSource = self
        headerTable.bounces = false
        headerTable.backgroundColor = TBIThemeBaseColor
        headerTable.separatorStyle = .none
        //headerTable.tableHeaderView =  initHeaderView()
        headerTable.estimatedRowHeight = 50
        headerTable.register(PSepcialCountryCell.self, forCellReuseIdentifier: "PSepcialCountryCell")
        self.view.addSubview( headerTable)
        headerTable.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(44-kNavigationHeight)
            make.height.equalTo((isIPhoneX ? 237 : 212)  + kNavigationHeight + 40 * 1)
        }
        
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.backgroundColor = TBIThemeBaseColor
        listTableView.separatorStyle = .none
        //listTableView.estimatedRowHeight = 50
        listTableView.showsVerticalScrollIndicator = false
        listTableView.register(PSpecialHotelListCell.self, forCellReuseIdentifier: "PSpecialHotelListCell")
        listTableView.register(UINib(nibName: "TableNoDateView", bundle: nil), forHeaderFooterViewReuseIdentifier: "TableNoDateView")
        self.view.addSubview( listTableView)
        listTableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(headerTable.snp.bottom)
        }
        weak var weakSelf = self
        listTableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            weakSelf?.refreshDataSource()
        })
        
        listTableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: {
            weakSelf?.loadMoreDataSources()
        })
        
    }
    func initTopView() {
//        initNavigation(title:"",bgColor:PersonalThemeNormalColor,alpha:0,isTranslucent:true)
//        setNavigationBackButton(backImage: "BackCircle")
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
        topView.frame = CGRect(x:0,y:0,width:Int(ScreenWindowWidth),height:kNavigationHeight)
        topView.leftButton.setImage(UIImage(named:"ic_left_white"), for: UIControlState.normal)
        topView.leftButton.addTarget(self, action: #selector(leftButtonClick), for: UIControlEvents.touchUpInside)
        topView.creatSearchView()
        topView.searchTf.placeholder = "搜索酒店名称"
        weak var weakSelf = self
        topView.personalNavbarTopViewSearchBlock = { (searchKeyword) in
            weakSelf?.searchKeyword(searchKeyword: searchKeyword)
            
        }
        self.view.addSubview(topView)
    }
    /// 搜索关键字
    func searchKeyword(searchKeyword:String) {
        guard searchKeyword.isEmpty == false else {
            return
        }

      getHotelSpecialListFromNET(regionType:selectedChinaORInternationalIndex , cityCode: selectedChinaCity.elongId, starRate: selectedStar, isRefresh: true)
       
        
        
        
    }
    
    /// 展示城市 视图
    func showCityView(cityName:String,cityCode:String) {
        guard cityName == cityChinaMoreCityTipDefault else {
            if selectedChinaORInternationalIndex == "1" {
                for (index,element) in cityChinaArr.enumerated() {
                    if cityCode == element.elongId {
                        mainlandCitySelctedIndex = index
                    }
                }
                selectedChinaCity.cnName = cityName
                selectedChinaCity.elongId = cityCode
            }else{
                selectedInteralCity.cnName = cityName
                selectedInteralCity.elongId = cityCode
            }
            getHotelSpecialListFromNET(regionType: selectedChinaORInternationalIndex, cityCode: cityCode, starRate: selectedStar, isRefresh: true)
            return
        }
        if selectedChinaORInternationalIndex == "1" {
            showMainLandCityView()
        }else {
            showInternationalCityView()
        }
     
    }
    
    func showInternationalCityView() {
        weak var weakSelf = self
        let citySelectorViewController = PersonalSpecialHotelCityViewController()
        citySelectorViewController.cityInterArr = cityIntenationalArr
        citySelectorViewController.personalSpecialHotelCityViewSelectedBlcok = { (cityName,elongId) in
            print(cityName)
            weakSelf?.madifyInternationalCity(cityName: cityName, cityId: elongId)
        }
        self.navigationController?.pushViewController(citySelectorViewController, animated: true)
    }
    
    func madifyInternationalCity(cityName:String,cityId:String) {
        selectedInteralCity.elongId = cityId
        selectedInteralCity.cnName = cityName
        let tmpselectedCity = HotelCityModel()
        tmpselectedCity.elongId = cityId
        tmpselectedCity.cnName = cityName
        
        var isContain:Bool = false
        
        for (index, element) in cityInterArr.enumerated() {
            if element.elongId == cityId {
                internationalCitySelctedIndex = index
                isContain = true
                continue
            }
        }
        if isContain == false {
            cityInterArr[0] = tmpselectedCity
            internationalCitySelctedIndex = 0
        }
        
        
        headerTable.reloadData()
        
        getHotelSpecialListFromNET(regionType: selectedChinaORInternationalIndex, cityCode: selectedInteralCity.elongId, starRate:selectedStar , isRefresh: true)
        
        
        
    }
    
    
    
    
    
    func showMainLandCityView() {
        weak var weakSelf = self
        let citySelectorViewController = CitySelectorViewController()
        citySelectorViewController.cityShowType = CitySelectorViewController.CityType.CityType_Hotel
        citySelectorViewController.citySelectorBlock = { (cityName,elongId) in
            print(cityName)
            weakSelf?.modifyMainLandCity(cityName: cityName, cityId: elongId)
        }
        citySelectorViewController.setCityType(type: .hotelCity)
        citySelectorViewController.hotelCity = cityGroupList
        self.navigationController?.pushViewController(citySelectorViewController, animated: true)
    }
    
    
    
    func modifyMainLandCity(cityName:String,cityId:String) {
        selectedChinaCity.elongId = cityId
        selectedChinaCity.cnName = cityName
        let tmpselectedCity = HotelCityModel()
        tmpselectedCity.elongId = cityId
        tmpselectedCity.cnName = cityName
        
        var isContain:Bool = false
        
        for (index, element) in cityChinaArr.enumerated() {
            if element.elongId == cityId {
                mainlandCitySelctedIndex = index
                isContain = true
            }
        }
        if isContain == false {
            cityChinaArr[0] = tmpselectedCity
            mainlandCitySelctedIndex = 0
        }
        
        
        headerTable.reloadData()
        
        getHotelSpecialListFromNET(regionType: selectedChinaORInternationalIndex, cityCode: selectedChinaCity.elongId, starRate:selectedStar , isRefresh: true)
        
    }
    
    
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func leftButtonClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:-------NET-------
    
    /// 刷新数据
    func refreshDataSource() {
        pageIndex = 1
        getHotelSpecialListFromNET(regionType:selectedChinaORInternationalIndex , cityCode: selectedChinaCity.elongId, starRate: selectedStar, isRefresh: true)
    }
    
    func loadMoreDataSources() {
        getHotelSpecialListFromNET(regionType:selectedChinaORInternationalIndex , cityCode: selectedChinaCity.elongId, starRate: selectedStar, isRefresh: false)
        
    }
    
    
    func getHotelSpecialListFromNET(regionType:String,cityCode:String,starRate:String,isRefresh:Bool) {
//        guard (regionType == "1" && cityCode.isEmpty == false) || regionType == "2" else {
//            return
//        }
        if isRefresh == true {
            pageIndex = 1
        }
        let request = SpecialHotelListRequest()
        request.cityCode = cityCode
        request.regionType = regionType
        request.corpCode = [PersonalSpecialHotelCorpCode]
        request.dateStr = ""
        request.endCount = ""
        request.pageSize = "10"
        request.starRate = starRate
        request.pageNum = pageIndex.description
        request.arriveDate = ""//"1533000727"
        request.depDate = ""//"1533087127"
        request.hotelName = topView.searchTf.text!
        weak var weakSelf = self
        showLoadingView()
        PersonalHotelServices.sharedInstance
            .hotelSpecialList(request: request)
            .subscribe { (event) in
                weakSelf?.hideLoadingView()
                switch event {
                case .next(let result):
                    printDebugLog(message: event)
                    if isRefresh == true {
                        weakSelf?.pageIndex = 2
                        weakSelf?.specialHotelListResponse = result
                        weakSelf?.listTableView.mj_header.endRefreshing()
                        weakSelf?.listTableView.mj_footer.resetNoMoreData()
                    }else{
                        
                        if result.specialHotelList.count > 0 {
                            weakSelf?.pageIndex += 1
                            weakSelf?.specialHotelListResponse.specialHotelList
                                .append(contentsOf: result.specialHotelList)
                            
                            weakSelf?.listTableView.mj_footer.endRefreshing()
                        }else {
                            weakSelf?.listTableView.mj_footer.endRefreshingWithNoMoreData()
                        }
                       
                    }
                    weakSelf?.listTableView.reloadData()
                    
                case .error(let error):
                    weakSelf?.listTableView.mj_header.endRefreshing()
                    weakSelf?.listTableView.mj_footer.endRefreshing()
                    weakSelf?.specialHotelListResponse.specialHotelList.removeAll()
                    weakSelf?.listTableView.reloadData()
                    try? weakSelf?.validateHttp(error)
                case .completed:
                    break
                }
        }.addDisposableTo(self.bag)
        
    }

    ///  获得定投酒店城市
    func getHotelCityNET() {
        //showLoadingView()
        weak var weakSelf = self
        CityService.sharedInstance
            .getSpecialHotelCity(request: [PersonalSpecialHotelCorpCode])
            .subscribe{ event in
                //weakSelf?.hideLoadingView()
                switch event{
                case .next(let e):
                    printDebugLog(message: e)
                    // 需求 不取前三个城市
                    // 前三个城市 固定
//                    for element in e {
//                        weakSelf?.cityChinaArr.append(element)
//                        if (weakSelf?.cityChinaArr.count)! >= 3 {
//                            let firstCity = HotelCityModel()
//                            firstCity.cnName = (weakSelf?.cityChinaMoreCityTipDefault)!
//                            weakSelf?.cityChinaArr.append(firstCity)
//                            weakSelf?.selectedChinaCity.elongId = weakSelf?.cityChinaArr.first?.elongId ?? ""
//                            weakSelf?.headerTable.reloadData()
//                            weakSelf?.getHotelSpecialListFromNET(regionType: weakSelf?.selectedChinaORInternationalIndex ?? "1", cityCode: (weakSelf?.selectedChinaCity.elongId)!, starRate: "", isRefresh: true)
//                            break
//                        }
//                    }
                    //weakSelf?.selectedChinaCity.elongId = weakSelf?.cityChinaArr.first?.elongId ?? ""
                    weakSelf?.headerTable.reloadData()
                    weakSelf?.getHotelSpecialListFromNET(regionType: weakSelf?.selectedChinaORInternationalIndex ?? "1", cityCode:"", starRate: "", isRefresh: true)
                    weakSelf?.cityGroupList = (weakSelf?.hotelCitySort(cityArr: e))!
                    weakSelf?.cityIntenationalArr = (weakSelf?.hotelInternationalCity(cityArr: e))!
                case .error:
                    break
                case .completed:
                    break
                }
            }.addDisposableTo(self.bag)
    }
    
    
    func hotelInternationalCity(cityArr:[HotelCityModel])->[HotelCityModel] {
        
        var result:[HotelCityModel] = Array()
       result = cityArr.filter { (element) -> Bool in
            if element.regionType == "2" {
               return true
            }
            return false
        }
        return result
        
    }
    
    
    /// 城市排序
    public func hotelCitySort(cityArr:[HotelCityModel]) -> [HotelCityGroup] {
        var sortArr:[HotelCityGroup] = Array()
        
        for element in cityArr {
            if element.regionType == "2" {continue}
            let firstCharacter:String = element.enName.first?.description ?? "#"
            if let tmpAirportGroup = sortArr.first(where:{$0.firstCharacter.uppercased() == firstCharacter.uppercased()}){
                tmpAirportGroup.cities.append(element)
            }else{
                sortArr.append(HotelCityGroup(firstCharacter: firstCharacter, cities: [element]))
            }
        }
        
//        cityArr.map{ (element) in
//            
//        }
        return sortArr.sorted{ $0.firstCharacter < $1.firstCharacter }.map{ group in
            group.cities = group.cities.sorted{ $0.enName < $1.enName }
            return group
        }
    }
    
    
    

}
extension PSpecailOfferHotelViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == headerTable {
            return 1
        }else{
            return specialHotelListResponse.specialHotelList.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == headerTable{

            return CGFloat(140 + kNavigationHeight - 44 + 46 + 40 + 10 + 40 * ((selectedChinaORInternationalIndex == "1" ? returnCount(count:cityChinaArr.count) : returnCount(count:cityInterArr.count))))
        }else{
            return 130//UITableViewAutomaticDimension
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView == listTableView
        {
            if specialHotelListResponse.specialHotelList.count == 0{
                 return tableView.frame.height
            }
           
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if tableView == listTableView
        {
            if (specialHotelListResponse.specialHotelList.count ) == 0{
                if let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableNoDateView") as? TableNoDateView {
                    footer.setType(.noPersonal)                    
                    footer.messageLabel.text="暂无符合条件的酒店"
                    footer.image.image = UIImage(named: "hotel_default")
                    return footer
                }
            }
        }
        
        
        return nil
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == headerTable{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PSepcialCountryCell",for: indexPath) as! PSepcialCountryCell
            if cityChinaArr.count > 0 {
                cell.setCellWithData(contientArr: (selectedChinaORInternationalIndex == "1" ? cityChinaArr :cityInterArr), currentContinentIndex: (selectedChinaORInternationalIndex), currentCountryIndex: selectedChinaORInternationalIndex == "1" ? mainlandCitySelctedIndex : internationalCitySelctedIndex)
            }
            
            weak var weakSelf = self
            cell.tclickBlock = {(selectedIndex) in
                weakSelf?.selectedMainlandORInternationalCategory(selectedIndex: selectedIndex)
            }
            cell.hotelCityCellSelectedBlock = {(cityName,cityCode) in
                printDebugLog(message: cityName)
                weakSelf?.showCityView(cityName: cityName,cityCode: cityCode)
            }
            cell.hotelStarsCellSelectedBlock = {(hotelStarString) in
                weakSelf?.selectedStar = hotelStarString
                weakSelf?.getHotelSpecialListFromNET(regionType: (weakSelf?.selectedChinaORInternationalIndex)!, cityCode: (weakSelf?.selectedChinaCity.elongId)!,
                                                     starRate: (weakSelf?.selectedStar)!, isRefresh: true)
            }
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PSpecialHotelListCell",for: indexPath) as! PSpecialHotelListCell
            if specialHotelListResponse.specialHotelList.count > 0 {
                cell.fillDataSourcesCell(item: specialHotelListResponse.specialHotelList[indexPath.row])
            }
            return cell
        }
       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView != headerTable {
           intoHotelDetailView(selectedIndex: indexPath.row)
        }
    }
    func intoHotelDetailView(selectedIndex:NSInteger) {
        let corpCode:String = specialHotelListResponse.specialHotelList[selectedIndex].groupCode
        if corpCode.contains(PersonalSpecialHotelCorpCode) {
            intoNextPersonalSpecialHotelView(selectedIndex: selectedIndex)
        }else{
            intoNextPersonalNormalHotelView(selectedIndex: selectedIndex)
        }
    }
    
    func intoNextPersonalSpecialHotelView(selectedIndex:NSInteger) {
        let detailVC:PHotelDetailViewController = PHotelDetailViewController()
        detailVC.fromWhereView = .PersonalSpecialHotel
        // 国内 1 国际 2
        var selectedCityName:String = ""
        var selectedCityId:String = ""
        if selectedChinaORInternationalIndex == "1" {
            selectedCityName = selectedChinaCity.cnName
            selectedCityId = selectedChinaCity.elongId
        }else {
            selectedCityName = selectedInteralCity.cnName
            selectedCityId = selectedInteralCity.elongId
        }
        
        detailVC.hotelDetailCityName = selectedCityName
        detailVC.hotelDetailCityId = selectedCityId
        detailVC.cordGroup = specialHotelListResponse.specialHotelList[selectedIndex].groupCode
        detailVC.hotelDetailType = AppModelCatoryENUM.PersonalSpecialHotel
        detailVC.specialHotelItemInfo = specialHotelListResponse.specialHotelList[selectedIndex]
        detailVC.presaleType = specialHotelListResponse.specialHotelList[selectedIndex].payType
        detailVC.cityId  = specialHotelListResponse.specialHotelList[selectedIndex].cityId
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func intoNextPersonalNormalHotelView(selectedIndex:NSInteger) {
        let detailVC:PHotelDetailViewController = PHotelDetailViewController()
        detailVC.fromWhereView = .PersonalSpecialHotel
        // 国内 1 国际 2
        var selectedCityName:String = ""
        var selectedCityId:String = ""
        if selectedChinaORInternationalIndex == "1" {
            selectedCityName = selectedChinaCity.cnName
            selectedCityId = selectedChinaCity.elongId
        }else {
            selectedCityName = selectedInteralCity.cnName
            selectedCityId = selectedInteralCity.elongId
        }
        
        detailVC.hotelDetailCityName = selectedCityName
        detailVC.hotelDetailCityId = selectedCityId
        
        detailVC.presaleType = specialHotelListResponse.specialHotelList[selectedIndex].payType
        detailVC.hotelDetailType = AppModelCatoryENUM.PersonalHotel
        detailVC.hotelDetailInfo = specialHotelListResponse.specialHotelList[selectedIndex]
        detailVC.personalNormalHotel.corpCode = specialHotelListResponse.specialHotelList[selectedIndex].groupCode
        detailVC.personalNormalHotel.hotelId = specialHotelListResponse.specialHotelList[selectedIndex].elongId
        detailVC.personalNormalHotel.hotelOwnId = specialHotelListResponse.specialHotelList[selectedIndex].hotelId
        detailVC.personalNormalHotel.corpCode = specialHotelListResponse.specialHotelList[selectedIndex].groupCode
        detailVC.personalNormalHotel.cover = specialHotelListResponse.specialHotelList[selectedIndex].cover
        detailVC.personalNormalHotel.longitude = specialHotelListResponse.specialHotelList[selectedIndex].lon
        detailVC.personalNormalHotel.latitude = specialHotelListResponse.specialHotelList[selectedIndex].lat
        detailVC.personalNormalHotel.hotelName = specialHotelListResponse.specialHotelList[selectedIndex].hotelName
        detailVC.personalNormalHotel.hotelAddress = specialHotelListResponse.specialHotelList[selectedIndex].address
        detailVC.cityId = specialHotelListResponse.specialHotelList[selectedIndex].cityId
        let searchCondition = PersonalHotelManager.shareInstance.searchConditionUserDraw()
        
        if searchCondition.arrivalDate.isEmpty {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone?
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" //"yyyy-MM-dd HH:mm:ss"
            let currentDate:Date = (Date() + 1.day).startOfDay
            searchCondition.arrivalDateFormat = dateFormatter.string(from: currentDate)
            searchCondition.arrivalDate = (NSInteger(currentDate.timeIntervalSince1970) * 1000).description
            searchCondition.departureDate = ((NSInteger((currentDate + 1.day).timeIntervalSince1970)) * 1000).description
            searchCondition.departureDateFormat = dateFormatter.string(from: (currentDate + 1.day))
        }
        
        PersonalHotelManager.shareInstance.searchConditionUserStore(searchCondition: searchCondition)
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
    
    
    
}
extension PSpecailOfferHotelViewController{
    /// 选择 国际 国内
    func selectedMainlandORInternationalCategory(selectedIndex:String) {
        selectedChinaORInternationalIndex = selectedIndex
        //selectedCountryIndex = 0
        mainlandCitySelctedIndex = 99
        //切换国际国内 选中城市 需要清空 2018-09-04
        selectedInteralCity.elongId = ""//cityInterArr.first?.elongId ?? ""
        selectedChinaCity.elongId = ""//cityChinaArr[mainlandCitySelctedIndex].elongId
        headerTable.reloadData()
        headerTable.snp.remakeConstraints({ (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(44-kNavigationHeight)
            make.height.equalTo((isIPhoneX ? 237 : 212)  + kNavigationHeight + 40 * ((selectedChinaORInternationalIndex == "1" ? returnCount(count:cityChinaArr.count) : returnCount(count:cityInterArr.count))))
        })
        listTableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(headerTable.snp.bottom)
        }
        if selectedChinaORInternationalIndex == "2" {
            
            getHotelSpecialListFromNET(regionType: selectedChinaORInternationalIndex, cityCode: selectedInteralCity.elongId, starRate: "", isRefresh: true)
        }else{
            getHotelSpecialListFromNET(regionType: selectedChinaORInternationalIndex, cityCode: selectedChinaCity.elongId, starRate: "", isRefresh: true)
        }
        
    }
    func returnCount(count:Int) -> Int {
        return count%4 == 0 ? count/4: (1+(count/4))
    }
}
