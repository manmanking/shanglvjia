//
//  PFlightSearchListViewController.swift
//  shanglvjia
//
//  Created by tbi on 2018/8/3.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import RxSwift
import SwiftDate
import MJRefresh

class PFlightSearchListViewController: PersonalBaseViewController {

    
    public var personalOnsaleFlightListViewType:AppModelCatoryENUM = AppModelCatoryENUM.PersonalFlight
    
    public var flightViewType:FlightCommonSearchViewENUM = FlightCommonSearchViewENUM.Default
    
    fileprivate let headerView = FlightSearchListHeaderView.init()
    fileprivate let tableView = UITableView()
    fileprivate let tablePersonalSearchViewCellIdentify = "PersonalCommonListCell"
    fileprivate let tableBusinessSearchViewSelectedTripCellIdentify = "PersonalFlightSearchListSelectedTripCell"
    fileprivate let footerView = FlightFooterView()
    fileprivate var coFlightSearchResult:CoFlightSearchResult?
    
    fileprivate var flightTripCityTitleView:FlightTripCityTitleView = FlightTripCityTitleView()
    
    fileprivate var flightTripNoDataTipDefault:String = "您所选的航班没有检索到机票，请重新设定您的航班信息"
    
    private let flightDateHeaderHeight:CGFloat = 55
    
    fileprivate let flightListHeaderDateView:FlightListHeaderDateView = FlightListHeaderDateView()
    
    var flightList:[CoFlightSearchResult.FlightItem]?
    
    fileprivate let bag = DisposeBag()
    
    fileprivate var offsetY:CGFloat = 0
    
    fileprivate var type:Int = 0
    
    fileprivate var firstFlightSVSearchCondition:FlightSVSearchConditionModel = FlightSVSearchConditionModel()
    
    //fileprivate var tmpFlightSVSearchCondition:FlightSVSearchConditionModel = FlightSVSearchConditionModel()
    
    fileprivate var flightSVSearchResult:PCommonFlightSVSearchModel = PCommonFlightSVSearchModel()
    
    fileprivate var flightSVSearchList:[PCommonFlightSVSearchModel.AirfareVO] = Array()
    
    
    public var tableViewDataSources:[FlightSVSearchConditionModel] = Array()
    
    fileprivate var startCity:String = ""
    fileprivate var arriveCity:String = ""
    fileprivate var currentDateStr:String = Date().string(custom: "yyyy-MM-dd")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = TBIThemeBaseColor
        setBlackTitleAndNavigationColor(title: "")
        setNavigationBackButton(backImage: "left")
        firstFlightSVSearchCondition = PCommonFlightManager.shareInStance.flightConditionDraw().first!
        
        setHeaderViewAutolayout()
        setTableView()
        setFooterView()
        initData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func backButtonAction(sender: UIButton) {
        let flightFirstSearchCondition = PCommonFlightManager.shareInStance.flightConditionDraw().first
        if (flightFirstSearchCondition?.type)! != 0 && (flightFirstSearchCondition?.currentTripSection)! > 1 {
            flightFirstSearchCondition?.currentTripSection -= 1
        }
        PCommonFlightManager.shareInStance.addSearchFlightCondition(searchCondition: flightFirstSearchCondition!, tripSection: 0)
        self.navigationController?.popViewController(animated: true)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        setNavigationBgColor(color: TBIThemeWhite)
        //printDebugLog(message: FlightManager.shareInStance.flightConditionDraw().first?.mj_keyValues())
        var startCity:String =  ""
        var arriveCity:String = ""
        startCity = PCommonFlightManager.shareInStance.flightConditionDraw()[firstFlightSVSearchCondition.currentTripSection - 1].takeOffCity
        arriveCity = PCommonFlightManager.shareInStance.flightConditionDraw()[firstFlightSVSearchCondition.currentTripSection - 1].arriveCity
        if firstFlightSVSearchCondition.currentTripSection == 2 && firstFlightSVSearchCondition.type == 1  {
            startCity = firstFlightSVSearchCondition.arriveCity
            arriveCity = firstFlightSVSearchCondition.takeOffCity
        }
        setTitleView(start:startCity, arrive:arriveCity )
        tableView.reloadData()
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        footerView.isHidden = false
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        footerView.isHidden = false
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        offsetY = scrollView.contentOffset.y
    }
    // add by manman on 2018-03-23
    // 更改headerView的视图样式
    // 日期样式
    func setHeaderViewAutolayout() {
        
        var searchConditionModel:FlightSVSearchConditionModel = FlightSVSearchConditionModel()
        searchConditionModel = PCommonFlightManager.shareInStance.flightConditionDraw()[firstFlightSVSearchCondition.currentTripSection - 1]
        if firstFlightSVSearchCondition.type == 1 && firstFlightSVSearchCondition.currentTripSection == 2 {
            let tmpModel:FlightSVSearchConditionModel = FlightSVSearchConditionModel()
            // 交换起始位置
            tmpModel.arriveAirportCode = firstFlightSVSearchCondition.takeOffAirportCode
            tmpModel.takeOffAirportCode = firstFlightSVSearchCondition.arriveAirportCode
            tmpModel.departureDate = firstFlightSVSearchCondition.returnDate
            tmpModel.type = 0
            searchConditionModel = tmpModel
        }
        let startDate:Date = Date.init(timeIntervalSince1970: TimeInterval(searchConditionModel.departureDate / 1000))
        
        weak var weakSelf = self
        self.view.addSubview(flightListHeaderDateView)
        flightListHeaderDateView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(flightDateHeaderHeight)
        }
        flightListHeaderDateView.headerDateShowType = .PersonalFlight
        flightListHeaderDateView.fillDataSources(date: startDate)
        flightListHeaderDateView.flightListHeaderDateViewSelectedDateBlock = { selectedDate in
            weakSelf?.flightListHeaderDateViewSelectedDateModifySearchCondition(selectedDate: selectedDate)
            weakSelf?.searchFlightNET()
            
        }
        
    }
    func flightListHeaderDateViewSelectedDateModifySearchCondition(selectedDate:NSInteger) {
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone?
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let departureDate:Date = Date.init(timeIntervalSince1970: TimeInterval(selectedDate))
        
        
        
        /// 修改返程时间
        if PCommonFlightManager.shareInStance.flightConditionDraw().first?.type == 1 &&
            PCommonFlightManager.shareInStance.flightConditionDraw().first?.currentTripSection == 2 {
            let searchCondition:FlightSVSearchConditionModel =  PCommonFlightManager.shareInStance.flightConditionDraw().first!
            searchCondition.returnDate = selectedDate * 1000
            searchCondition.returnDateFormat = formatter.string(from: departureDate)
            PCommonFlightManager.shareInStance.addSearchFlightCondition(searchCondition: searchCondition, tripSection:0)
        }else{ // 修改 出发时间
            let searchCondition:FlightSVSearchConditionModel =  PCommonFlightManager.shareInStance.flightConditionDraw()[firstFlightSVSearchCondition.currentTripSection - 1]
            searchCondition.departureDate = selectedDate * 1000
            searchCondition.departureDateFormat = formatter.string(from: departureDate)
            PCommonFlightManager.shareInStance.addSearchFlightCondition(searchCondition: searchCondition, tripSection:firstFlightSVSearchCondition.currentTripSection - 1)
        }
        
    }

}
extension PFlightSearchListViewController{
    
    func initData() {
        footerView.setUIViewAutolayout()
        weak var weakSelf = self
        //监听下拉刷新 上啦加载
        tableView.mj_header = MJRefreshNormalHeader{
            weakSelf?.searchFlightNET()
        }
        tableView.mj_header.beginRefreshing()
        
    }
    
    func searchFlightNET() {
        
        var requestModel:FlightSVSearchConditionModel = FlightSVSearchConditionModel()
        let  currentFlightSVSearchCondition = PCommonFlightManager.shareInStance.flightConditionDraw()[firstFlightSVSearchCondition.currentTripSection - 1]
        // 暂时 的
        // 查找自动化 拷贝
        requestModel = NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: currentFlightSVSearchCondition)) as! FlightSVSearchConditionModel
        //返程
        if firstFlightSVSearchCondition.type == 1 && firstFlightSVSearchCondition.currentTripSection == 2 {
            let firstTripTmpCondition:FlightSVSearchConditionModel = PCommonFlightManager.shareInStance.flightConditionDraw().first!
            let preFlightTrip = PCommonFlightManager.shareInStance.selectedFlightTripDraw().last
            let tmpModel:FlightSVSearchConditionModel = FlightSVSearchConditionModel()
            // 交换起始位置
            tmpModel.arriveAirportCode = firstTripTmpCondition.takeOffAirportCode
            tmpModel.takeOffAirportCode = firstTripTmpCondition.arriveAirportCode
            tmpModel.departureDate = firstTripTmpCondition.returnDate
            tmpModel.departureDateFormat = firstTripTmpCondition.returnDateFormat
            tmpModel.preArrTime = preFlightTrip?.flightInfos.last?.arriveDate.description ?? ""
            tmpModel.type = 1
            requestModel = NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: tmpModel)) as! FlightSVSearchConditionModel
        }
        
        // 多程中 在查询第一段后的行程 需要传递上一段的到达时间
        var preArriveTime = ""
        if firstFlightSVSearchCondition.type == 2 && firstFlightSVSearchCondition.currentTripSection > 1 {
            let preFlightTrip = PCommonFlightManager.shareInStance.selectedFlightTripDraw().last
            if preFlightTrip?.hasRecommendFlightTrip == true {
                preArriveTime = preFlightTrip?.recommendFlightTrips?.flightInfos.last?.arriveDate.description ?? ""
            }else {
                preArriveTime = preFlightTrip?.flightInfos.last?.arriveDate.description ?? ""
            }
            requestModel.preArrTime = preArriveTime
        }
        
        
        let travellerList = PassengerManager.shareInStance.passengerSVDraw()//searchTravellerResult

        requestModel.travelPolicyId = travellerList.first?.policyId ?? ""
        requestModel.needFilterPolicy = travellerList.first?.isSpecial == "1" ? "0":"1"
       
        requestModel.travellerUids = ""
        
        showLoadingView()
        weak var weakSelf = self
        PersonalFlightServices.sharedInstance
            .searchPersonalFlightList(request:requestModel)
            .subscribe{ event in
                weakSelf?.hideLoadingView()
                weakSelf?.tableView.mj_header.endRefreshing()
                if case .next(let e) = event {
                    //printDebugLog(message: e.mj_keyValues())
                    if  e.airfares.count  == 0 {
                        weakSelf?.showSystemAlertView(titleStr:  "提示", message: weakSelf?.flightTripNoDataTipDefault ?? "")
                        weakSelf?.flightTripCityTitleView.isHidden = true
                        return
                    }
                    if weakSelf?.flightViewType != .Default {
                        weakSelf?.personalRebookCommonFlight(result: e)
                    }else{
                        weakSelf?.personalCommonFlight(result: e)
                    }
                    
                    weakSelf?.flightTripCityTitleView.isHidden = false
                  
                    weakSelf?.setTakeOffCityAndArriveCity(takeOffCity:weakSelf?.flightSVSearchList
                        .first?.flightInfos.first?.takeOffCity ?? "" ,
                                                          arriveCity: weakSelf?.flightSVSearchList
                                                            .first?.flightInfos.last?.arriveCity ?? "")
                    weakSelf?.screenDataSources()
                    weakSelf?.flightSVSearchList = (weakSelf?.flightSVSearchList.sorted(FlightSort.timeAsc))!
                    weakSelf?.tableView.reloadDataWithAnimate(.liftUpFromBottum, animationTime: 0.5, interval: 0.05)
                }
                if case .error(let e) = event {
                    try? self.validateHttp(e)
                }
            }.disposed(by: self.bag)
        
    }
    
    func personalRebookCommonFlight(result:PCommonFlightSVSearchModel){
        let flightCode:String = PCommonFlightManager.shareInStance.flightConditionDraw().first!.specialFlightCode
         flightSVSearchList = result.airfares.filterFlightCode([flightCode])
        let resultCopy:PCommonFlightSVSearchModel = result
        resultCopy.airfares = result.airfares.filterFlightCode([flightCode])
        resultCopy.companys = result.companys.filterCompanyCode([flightCode])
        flightSVSearchResult = resultCopy
        
        
    }
    
    func personalCommonFlight(result:PCommonFlightSVSearchModel){
        flightSVSearchResult = result
        flightSVSearchList.removeAll()
        flightSVSearchList = result.airfares
        
    }
    
    
    
    
    func screenDataSources() {
        self.footerView.flightFliterButton.isSelected = false
        self.footerView.flightPriceSortButton.isSelected = false
        self.footerView.flightTimeSortkButton.isSelected = true
        self.footerView.flightTimeSortTitleLabel.text="从早到晚"
        self.footerView.flightPriceSortTitleLabel.text="价格"
        self.footerView.selectedData = [[(index:0,content:"")],[(index:0,content:"")],[(index:0,content:"")],[(index:0,content:"")]]
        
        //最小价格
        self.headerView.dateView.priceLabel.text = "¥\(String(describing: self.coFlightSearchResult?.lowestPrice ?? 0))"
        //self.setTitleView(start: self.flightSVSearchCondition.?.takeOffCity ?? "", arrive: self.coFlightSearchResult?.arriveCity ?? "")
        self.footerView.allCabin = flightSVSearchResult.allCabin //(self.coFlightSearchResult?.allCabin)!
        self.footerView.allCabin.insert("不限", at: 0)
        var companyTitle:[String] = Array()
        for element in flightSVSearchResult.companys {
            companyTitle.append(element.name)
        }
        footerView.allCompany = companyTitle
        footerView.allCompany.insert("不限", at: 0)
    }
    func setTakeOffCityAndArriveCity(takeOffCity:String,arriveCity:String) {
        // 单程 或者 往返 第一程  多程 第一程
        if firstFlightSVSearchCondition.type == 0 || firstFlightSVSearchCondition.currentTripSection == 1  {
            firstFlightSVSearchCondition.arriveCity = arriveCity
            firstFlightSVSearchCondition.takeOffCity = takeOffCity
            PCommonFlightManager.shareInStance.addSearchFlightCondition(searchCondition: firstFlightSVSearchCondition, tripSection: 0)
        }
        
        // 往返 第二程
        if firstFlightSVSearchCondition.type == 1 && firstFlightSVSearchCondition.currentTripSection == 2 {
            firstFlightSVSearchCondition.arriveCity = takeOffCity
            firstFlightSVSearchCondition.takeOffCity = arriveCity
            PCommonFlightManager.shareInStance.addSearchFlightCondition(searchCondition: firstFlightSVSearchCondition, tripSection: 0)
        }
        
        
        setTitleView(start:takeOffCity, arrive:arriveCity)
    }
    ///导航标题
    func setTitleView(start: String, arrive: String) {
        guard start.isEmpty == false || arrive.isEmpty == false else {
            return
        }
        let startCityWidth:NSNumber = NSNumber.init(value:Float(start.getTextWidth(font: UIFont.systemFont(ofSize: 16), height: 44)))
        let arriveCityWidth:NSNumber = NSNumber.init(value:Float(arrive.getTextWidth(font: UIFont.systemFont(ofSize: 16), height: 44)))
        var titleWidth:NSInteger = 0
        if firstFlightSVSearchCondition.type != 0 {
            titleWidth = startCityWidth.intValue + arriveCityWidth.intValue + 50 + 20
        }else {
            titleWidth = startCityWidth.intValue + arriveCityWidth.intValue + 20
        }
        
        flightTripCityTitleView.frame = CGRect.init(x: Int((ScreenWindowWidth - 150)/2), y: 0, width: titleWidth, height: 44)
        let type:NSInteger = firstFlightSVSearchCondition.type
        flightTripCityTitleView.fillDataSources(type: type, startCity: start, arriveCity: arrive, tripIndex: firstFlightSVSearchCondition.currentTripSection)
    
        self.navigationItem.titleView?.addSubview(flightTripCityTitleView)
        flightTripCityTitleView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(titleWidth)
        }
    }
}
extension PFlightSearchListViewController{
    func setFooterView() {
        self.view.addSubview(footerView)
        footerView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalToSuperview()
        }
        
        if coFlightSearchResult?.allCabin != nil {
            footerView.allCabin = (coFlightSearchResult?.allCabin)!
        }
        
        weak var weakSelf = self
        footerView.flightSortBlock = { (parameters ) in
            weakSelf?.flightSVSearchList = (weakSelf?.flightSVSearchList.sorted(parameters))!
            weakSelf?.tableView.reloadDataWithAnimate(.fromRightToLeft, animationTime: 0.5, interval: 0.05)
        }
        
        footerView.flightFliterBlock = {(parameters ) in
            weakSelf?.flightFliter(parameters: parameters)
        }
    }
    
    func flightFliter(parameters:[[(index:NSInteger,content:String)]]) {
        //self.flightList = self.coFlightSearchResult?.flightList
        print("dataSources",self.flightSVSearchResult.airfares.count)
        self.flightSVSearchList.removeAll()
        // 暂时 的
        // 查找自动化 拷贝
        self.flightSVSearchList = NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self.flightSVSearchResult.airfares)) as! [PCommonFlightSVSearchModel.AirfareVO]
        
        //self.flightSVSearchList = self.flightSVSearchResult.airfares
        print("dataSources copy",self.flightSVSearchList.count)
        let dateFortter:DateFormatter = DateFormatter()
        dateFortter.dateFormat = "YYYY-MM-dd HH:mm"
        
        let startDateInt:NSInteger = PCommonFlightManager.shareInStance.flightConditionDraw()[firstFlightSVSearchCondition.currentTripSection - 1].departureDate
        let startDate:Date = Date.init(timeIntervalSince1970: TimeInterval(startDateInt / 1000 ))
        currentDateStr = startDate.string(custom: "YYYY-MM-dd")
        if parameters[0][0].index == 0 && parameters[1][0].index == 0 && parameters[2][0].index == 0 && parameters[3][0].index == 0 {
            self.footerView.flightFliterButton.isSelected  = false
            self.flightSVSearchList = self.flightSVSearchResult.airfares
            self.tableView.reloadDataWithAnimate(.fromRightToLeft, animationTime: 0.5, interval: 0.05)
            return
        }
        //是否直达
        if parameters[0][0].index == 1 {
            //self.flightList = self.flightList?.filterDirect(true)
            self.flightSVSearchList = (self.flightSVSearchList.filterDirect(true))
        }else if parameters[0][0].index == 2 {
            //self.flightList = self.flightList?.filterDirect(false)
            self.flightSVSearchList = (self.flightSVSearchList.filterDirect(false))
        }
        //事件过滤
        if parameters[1][0].index != 0 {
            
            var flightSVList:[PCommonFlightSVSearchModel.AirfareVO] = Array()
            for index in 0..<parameters[1].count {
                // 起飞 时间段
                if parameters[1][index].index == 1 {
                    //                        flightLists += self.flightList?.maxTimeLimit("12:00".date(format: .custom("HH:mm"))!.absoluteDate).minTimeLimit("06:00".date(format: .custom("HH:mm"))!.absoluteDate) ?? []
                    
                    
                    
                    let maxDate:Date = dateFortter.date(from: currentDateStr + " 12:00" )!
                    //((currentDateStr + " 12:00").date(format: .custom("HH:mm"))?.absoluteDate)!
                    let minDate:Date = dateFortter.date(from: currentDateStr + " 06:00" )!
                    //((currentDateStr + " 06:00").date(format: .custom("HH:mm"))?.absoluteDate)!
                    flightSVList +=
                        self.flightSVSearchList.maxTimeLimit(maxDate).minTimeLimit(minDate)
                    
                }else if parameters[1][index].index == 2 {
                    //                        flightLists += self.flightList?.maxTimeLimit("18:00".date(format: .custom("HH:mm"))!.absoluteDate).minTimeLimit("12:00".date(format: .custom("HH:mm"))!.absoluteDate) ?? []
                    let maxDate:Date = dateFortter.date(from: currentDateStr + " 18:00" )!
                    //((currentDateStr + " 18:00").date(format: .custom("HH:mm"))?.absoluteDate)!
                    let minDate:Date = dateFortter.date(from: currentDateStr + " 12:00" )!
                    //((currentDateStr + " 12:00").date(format: .custom("HH:mm"))?.absoluteDate)!
                    flightSVList += self.flightSVSearchList.maxTimeLimit(maxDate).minTimeLimit(minDate)
                    
                }else if parameters[1][index].index == 3 {
                    //                        flightLists += self.flightList?.maxTimeLimit("24:00".date(format: .custom("HH:mm"))!.absoluteDate).minTimeLimit("18:00".date(format: .custom("HH:mm"))!.absoluteDate) ?? []
                    let maxDate:Date = dateFortter.date(from: currentDateStr + " 23:59" ) ?? Date().endOfDay
                    //formatter.date(from:currentDateStr + " 24:00") ?? Date()
                    let minDate:Date = dateFortter.date(from: currentDateStr + " 18:00" )!
                    //formatter.date(from:currentDateStr + " 18:00")!
                    flightSVList += self.flightSVSearchList.maxTimeLimit(maxDate).minTimeLimit(minDate)
                }
            }
            //self.flightList = flightLists
            self.flightSVSearchList = flightSVList
        }
        //仓位
        if parameters[2][0].index != 0 {
            //self.flightList = self.flightList?.filterCabin(parameters[2].reduce([]){$0 + [$1.content]})
            var filterCabinList:[PCommonFlightSVSearchModel.AirfareVO] = Array()
            //filterCabinList = self.flightSVSearchList.filterCabin(parameters[2].reduce([]){$0 + [$1.content]})
            //var filterCabinsList2:[PCommonFlightSVSearchModel.AirfareVO] = Array.ini
            filterCabinList = self.flightSVSearchList.newFilterCabin((parameters[2].first?.content) ?? "")
            self.flightSVSearchList = filterCabinList
        }
        
        // 航空公司
        if parameters[3][0].index != 0 {
            //self.flightList = self.flightList?.filterCompany(parameters[3].reduce([]){$0 + [$1.content]})
            self.flightSVSearchList = self.flightSVSearchList.filterCompany(parameters[3].reduce([]){$0 + [$1.content]})
            
        }
        
        self.footerView.flightFliterButton.isSelected  = true
        //self.flightList = self.flightList
        self.tableView.reloadDataWithAnimate(.fromRightToLeft, animationTime: 0.5, interval: 0.05)
        
    }
}
extension PFlightSearchListViewController:UITableViewDataSource,UITableViewDelegate {
    
    func setTableView() {
        tableView.frame = self.view.frame
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "TableNoDateView", bundle: nil), forHeaderFooterViewReuseIdentifier: "TableNoDateView")
        tableView.register(PersonalCommonListCell.classForCoder(), forCellReuseIdentifier: self.tablePersonalSearchViewCellIdentify)
        tableView.register(PersonalFlightSearchListSelectedTripCell.classForCoder(), forCellReuseIdentifier: tableBusinessSearchViewSelectedTripCellIdentify)
        tableView.separatorStyle = .none
        tableView.backgroundColor = TBIThemeBaseColor
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(flightListHeaderDateView.snp.bottom)
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if PCommonFlightManager.shareInStance.selectedFlightTripDraw().count > 0 {
            return 2
        }
        return 1
    }
    
    //MARK:- UITableViewDataSources
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 && PCommonFlightManager.shareInStance.selectedFlightTripDraw().count > 0  {
            return PCommonFlightManager.shareInStance.selectedFlightTripDraw().count
        }
        return flightSVSearchList.count
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if flightSVSearchList.count == 0 && PCommonFlightManager.shareInStance.selectedFlightTripDraw().count  == 0 {
            return tableView.frame.height
        }
        
        if indexPath.section == 0 && PCommonFlightManager.shareInStance.selectedFlightTripDraw().count  > 0 {
            return 41
        }
        return 108
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if flightSVSearchList.count == 0  && PCommonFlightManager.shareInStance.selectedFlightTripDraw().count  == 0 {
            return tableView.frame.height
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if flightSVSearchList.count == 0 {
            if let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableNoDateView") as? TableNoDateView {
                footer.setType(.noPersonal)
                footer.messageLabel.text="当前条件下暂未查询到机票"
                return footer
            }
        }
        return nil
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && PCommonFlightManager.shareInStance.selectedFlightTripDraw().count > 0 {
            
            let cell:PersonalFlightSearchListSelectedTripCell = tableView.dequeueReusableCell(withIdentifier: tableBusinessSearchViewSelectedTripCellIdentify) as! PersonalFlightSearchListSelectedTripCell
            cell.fillDataSourcesCommon(flight:PCommonFlightManager.shareInStance.selectedFlightTripDraw()[indexPath.row] , type: firstFlightSVSearchCondition.type, currentTrip:indexPath.row + 1)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: self.tablePersonalSearchViewCellIdentify) as! PersonalCommonListCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.fillDataSources(airfare:flightSVSearchList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = PersonalCommonFlightSelectCabinController()
        let selectedTmpFlightTrip:PCommonFlightSVSearchModel.AirfareVO = flightSVSearchList[indexPath.row]
        PCommonFlightManager.shareInStance.addSelectedFlightTrip(searchCondition: selectedTmpFlightTrip, tripSection: firstFlightSVSearchCondition.currentTripSection)
        vc.flightViewType = flightViewType
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
