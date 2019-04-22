//
//  FlightSearchListViewController.swift
//  shop
//
//  Created by SLMF on 2017/4/22.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import RxSwift
import SwiftDate
import MJRefresh

class FlightBusinessSearchListViewController:FlightBaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    fileprivate let headerView = FlightSearchListHeaderView.init()
    fileprivate let tableView = UITableView()
    fileprivate let tableBusinessSearchViewCellIdentify = "tableBusinessSearchViewCellIdentify"
    fileprivate let tableBusinessSearchViewSelectedTripCellIdentify = "tableBusinessSearchViewSelectedTripCellIdentify"
    fileprivate let footerView = FlightFooterView()
    fileprivate var coFlightSearchResult:CoFlightSearchResult?
    
    fileprivate var flightTripCityTitleView:FlightTripCityTitleView = FlightTripCityTitleView()
    
    fileprivate var flightTripNoDataTipDefault:String = "您所选的航班没有检索到机票，请重新设定您的航班信息"
    
    private let flightDateHeaderHeight:CGFloat = 55
    
    fileprivate let flightListHeaderDateView:FlightListHeaderDateView = FlightListHeaderDateView()
    
    var flightList:[CoFlightSearchResult.FlightItem]?
    
    fileprivate let bag = DisposeBag()
    
    fileprivate var offsetY:CGFloat = 0
    
    var travelNo:String? = nil
    
    /// 违反差标是否可以购买
    var anOrder:Bool = true
    
    fileprivate var type:Int = 0
    
    //过滤后数据
    //fileprivate var fliterFlightList:[CoFlightSearchResult.FlightItem]?
    
    
    //MARK:-----------NEWOBT------------
    
    fileprivate var firstFlightSVSearchCondition:FlightSVSearchConditionModel = FlightSVSearchConditionModel()
    
    //fileprivate var tmpFlightSVSearchCondition:FlightSVSearchConditionModel = FlightSVSearchConditionModel()
    
    fileprivate var flightSVSearchResult:FlightSVSearchResultVOModel = FlightSVSearchResultVOModel()
    
    fileprivate var flightSVSearchList:[FlightSVSearchResultVOModel.AirfareVO] = Array()
    
    
    public var tableViewDataSources:[FlightSVSearchConditionModel] = Array()
    
    fileprivate var startCity:String = ""
    
    fileprivate var arriveCity:String = ""
    
    fileprivate var currentDateStr:String = Date().string(custom: "yyyy-MM-dd")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = TBIThemeBaseColor
        setBlackTitleAndNavigationColor(title: "")
        setNavigationBackButton(backImage: "left")
        firstFlightSVSearchCondition = FlightManager.shareInStance.flightConditionDraw().first!
        
        setHeaderViewAutolayout()
        setTableView()
        setFooterView()
//        setTitleView(start:startCity, arrive:arriveCity )
        initData()
        
        
        
    }
    
    override func backButtonAction(sender: UIButton) {
        let flightFirstSearchCondition = FlightManager.shareInStance.flightConditionDraw().first
        if (flightFirstSearchCondition?.type)! != 0 && (flightFirstSearchCondition?.currentTripSection)! > 1 {
            flightFirstSearchCondition?.currentTripSection -= 1
        }
        FlightManager.shareInStance.addSearchFlightCondition(searchCondition: flightFirstSearchCondition!, tripSection: 0)
        self.navigationController?.popViewController(animated: true)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationBgColor(color: TBIThemeWhite)
        //printDebugLog(message: FlightManager.shareInStance.flightConditionDraw().first?.mj_keyValues())
        var startCity:String =  ""
        var arriveCity:String = ""
        startCity = FlightManager.shareInStance.flightConditionDraw()[firstFlightSVSearchCondition.currentTripSection - 1].takeOffCity
        arriveCity = FlightManager.shareInStance.flightConditionDraw()[firstFlightSVSearchCondition.currentTripSection - 1].arriveCity
        if firstFlightSVSearchCondition.currentTripSection == 2 && firstFlightSVSearchCondition.type == 1  {
            startCity = firstFlightSVSearchCondition.arriveCity
            arriveCity = firstFlightSVSearchCondition.takeOffCity
        }
         setTitleView(start:startCity, arrive:arriveCity )
        tableView.reloadData()
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
////        let contentOffsetY = scrollView.contentOffset.y
////        if contentOffsetY > offsetY {
////            // 在最底部
////            footerView.isHidden = true
////        } else {
////            footerView.isHidden = false
////        }
//         footerView.isHidden = true
//    }
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
        searchConditionModel = FlightManager.shareInStance.flightConditionDraw()[firstFlightSVSearchCondition.currentTripSection - 1]
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
        if FlightManager.shareInStance.flightConditionDraw().first?.type == 1 &&
            FlightManager.shareInStance.flightConditionDraw().first?.currentTripSection == 2 {
            let searchCondition:FlightSVSearchConditionModel =  FlightManager.shareInStance.flightConditionDraw().first!
            searchCondition.returnDate = selectedDate * 1000
            searchCondition.returnDateFormat = formatter.string(from: departureDate)
             FlightManager.shareInStance.addSearchFlightCondition(searchCondition: searchCondition, tripSection:0)
        }else{ // 修改 出发时间
              let searchCondition:FlightSVSearchConditionModel =  FlightManager.shareInStance.flightConditionDraw()[firstFlightSVSearchCondition.currentTripSection - 1]
            searchCondition.departureDate = selectedDate * 1000
            searchCondition.departureDateFormat = formatter.string(from: departureDate)
             FlightManager.shareInStance.addSearchFlightCondition(searchCondition: searchCondition, tripSection:firstFlightSVSearchCondition.currentTripSection - 1)
        }
        
        
       
    }
    
}

extension FlightBusinessSearchListViewController {
    
    func initData() {
        footerView.setUIViewAutolayout()
        weak var weakSelf = self
        //监听下拉刷新 上啦加载
        tableView.mj_header = MJRefreshNormalHeader{
            weakSelf?.searchFlightNET()
       }
        tableView.mj_header.beginRefreshing()
         //flightListHeaderDateView.fillDataSources(date: (tableViewDataSources.first?.departureDates)!)
        
    }
    func searchFlightNET() {
        
        var requestModel:FlightSVSearchConditionModel = FlightSVSearchConditionModel()
        let  currentFlightSVSearchCondition = FlightManager.shareInStance.flightConditionDraw()[firstFlightSVSearchCondition.currentTripSection - 1]
        // 暂时 的
        // 查找自动化 拷贝
        requestModel = NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: currentFlightSVSearchCondition)) as! FlightSVSearchConditionModel
        //返程
        if firstFlightSVSearchCondition.type == 1 && firstFlightSVSearchCondition.currentTripSection == 2 {
            let firstTripTmpCondition:FlightSVSearchConditionModel = FlightManager.shareInStance.flightConditionDraw().first!
            let tmpModel:FlightSVSearchConditionModel = FlightSVSearchConditionModel()
            // 交换起始位置
            tmpModel.arriveAirportCode = firstTripTmpCondition.takeOffAirportCode
            tmpModel.takeOffAirportCode = firstTripTmpCondition.arriveAirportCode
            tmpModel.departureDate = firstTripTmpCondition.returnDate
            tmpModel.departureDateFormat = firstTripTmpCondition.returnDateFormat
            tmpModel.preArrTime = firstTripTmpCondition.departureDate.description
            tmpModel.type = 1
            requestModel = NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: tmpModel)) as! FlightSVSearchConditionModel
        }
        
        // 多程中 在查询第一段后的行程 需要传递上一段的到达时间
        var preArriveTime = ""
        if firstFlightSVSearchCondition.type == 2 && firstFlightSVSearchCondition.currentTripSection > 1 {
            let preFlightTrip = FlightManager.shareInStance.selectedFlightTripDraw().last
            if preFlightTrip?.hasRecommendFlightTrip == true {
               preArriveTime = preFlightTrip?.recommendFlightTrip?.flightInfos.last?.arriveDate.description ?? ""
            }else {
               preArriveTime = preFlightTrip?.flightInfos.last?.arriveDate.description ?? ""
            }
            requestModel.preArrTime = preArriveTime
        }
        
        
        let travellerList = PassengerManager.shareInStance.passengerSVDraw()//searchTravellerResult
        var uids:String = ""
        for element in travellerList {
            uids += element.passagerId + ","
        }
        requestModel.travelPolicyId = travellerList.first?.policyId ?? ""
        requestModel.needFilterPolicy = travellerList.first?.isSpecial == "1" ? "0":"1"
        //uids = String.init(uids.remove(at: uids.endIndex))
        let index = uids.index(before: uids.endIndex)
        let uidSet = uids.substring(to: index)
        requestModel.travellerUids = uidSet
        
        showLoadingView()
        weak var weakSelf = self
        FlightService.sharedInstance
            .searchFlightList(request:requestModel)
            .subscribe{ event in
                weakSelf?.hideLoadingView()
                weakSelf?.tableView.mj_header.endRefreshing()
                if case .next(let e) = event {
                    //printDebugLog(message: e.mj_keyValues())
                    if  e.airfares.count  == 0 {
                        weakSelf?.showSystemAlertView(titleStr:  "提示", message: weakSelf?.flightTripNoDataTipDefault ?? "")
                        return
                    }
                    weakSelf?.flightSVSearchResult = e
                    weakSelf?.flightSVSearchList.removeAll()
                    weakSelf?.flightSVSearchList = e.airfares
//                    weakSelf?.tmpFlightSVSearchCondition.arriveCity = weakSelf?.flightSVSearchList.first?.flightInfos.last?.arriveCity ?? ""
//                    weakSelf?.tmpFlightSVSearchCondition.takeOffCity = weakSelf?.flightSVSearchList.first?.flightInfos.first?.takeOffCity ?? ""
//                    FlightManager.shareInStance.addSearchFlightCondition(searchCondition: (weakSelf?.tmpFlightSVSearchCondition)!, tripSection: (weakSelf?.firstFlightSVSearchCondition.currentTripSection)! - 1)
//
//                    weakSelf?.setTitleView(start:(weakSelf?.tmpFlightSVSearchCondition.takeOffCity)! , arrive: (weakSelf?.tmpFlightSVSearchCondition.arriveCity)!)
                    weakSelf?.setTakeOffCityAndArriveCity(takeOffCity:weakSelf?.flightSVSearchList.first?.flightInfos.first?.takeOffCity ?? "" ,
                                                arriveCity: weakSelf?.flightSVSearchList.first?.flightInfos.last?.arriveCity ?? "")
                    weakSelf?.screenDataSources()
                    weakSelf?.tableView.reloadDataWithAnimate(.liftUpFromBottum, animationTime: 0.5, interval: 0.05)
                    }
                    if case .error(let e) = event {
                        try? self.validateHttp(e)
                    }
                }.disposed(by: self.bag)
                
        }
    
    
    func setTakeOffCityAndArriveCity(takeOffCity:String,arriveCity:String) {
        // 单程 或者 往返 第一程  多程 第一程
        if firstFlightSVSearchCondition.type == 0 || firstFlightSVSearchCondition.currentTripSection == 1  {
            firstFlightSVSearchCondition.arriveCity = arriveCity
            firstFlightSVSearchCondition.takeOffCity = takeOffCity
            FlightManager.shareInStance.addSearchFlightCondition(searchCondition: firstFlightSVSearchCondition, tripSection: 0)
        }
        
        // 往返 第二程
        if firstFlightSVSearchCondition.type == 1 && firstFlightSVSearchCondition.currentTripSection == 2 {
            firstFlightSVSearchCondition.arriveCity = takeOffCity
            firstFlightSVSearchCondition.takeOffCity = arriveCity
            FlightManager.shareInStance.addSearchFlightCondition(searchCondition: firstFlightSVSearchCondition, tripSection: 0)
        }
        // 多程。
        if firstFlightSVSearchCondition.type == 2 && firstFlightSVSearchCondition.currentTripSection > 1 {
            
            let currentSearchConditionTrip = FlightManager.shareInStance.flightConditionDraw()[firstFlightSVSearchCondition.currentTripSection - 1]
            currentSearchConditionTrip.takeOffCity = takeOffCity
            currentSearchConditionTrip.arriveCity = arriveCity
            FlightManager.shareInStance.addSearchFlightCondition(searchCondition: currentSearchConditionTrip, tripSection: firstFlightSVSearchCondition.currentTripSection - 1)
        }
        
        
        
        
        
        setTitleView(start:takeOffCity, arrive:arriveCity)
    }
    
    
    
    func screenDataSources() {
        self.footerView.flightFliterButton.isSelected = false
        self.footerView.flightPriceSortButton.isSelected = false
        self.footerView.flightTimeSortkButton.isSelected = false
        self.footerView.flightTimeSortTitleLabel.text="时间"
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
    
    
    //MARK:----------UIAlertViewDelegate----
    override func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if alertView.message == flightTripNoDataTipDefault {
//            backButtonAction(sender: UIButton())
            for vc in (self.navigationController?.viewControllers)!{
                if vc.isKind(of: FlightSVSearchViewController.self)
                {
                    var avc:FlightSVSearchViewController = vc as! FlightSVSearchViewController
                    self.navigationController?.popToViewController(avc, animated: true)
                }
            }
        }
    }
    
    
    
    
}

extension FlightBusinessSearchListViewController {
    
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
            //self.flightList = self.flightList?.sorted(parameters)//(self.coFlightSearchResult?.flightList.sorted(parameters))!
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
        self.flightSVSearchList = NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self.flightSVSearchResult.airfares)) as! [FlightSVSearchResultVOModel.AirfareVO]
        
        //self.flightSVSearchList = self.flightSVSearchResult.airfares
        print("dataSources copy",self.flightSVSearchList.count)
        let dateFortter:DateFormatter = DateFormatter()
        dateFortter.dateFormat = "YYYY-MM-dd HH:mm"
        
        let startDateInt:NSInteger = FlightManager.shareInStance.flightConditionDraw()[firstFlightSVSearchCondition.currentTripSection - 1].departureDate
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

            var flightSVList:[FlightSVSearchResultVOModel.AirfareVO] = Array()
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
            var filterCabinList:[FlightSVSearchResultVOModel.AirfareVO] = Array()
            //filterCabinList = self.flightSVSearchList.filterCabin(parameters[2].reduce([]){$0 + [$1.content]})
            //var filterCabinsList2:[FlightSVSearchResultVOModel.AirfareVO] = Array.ini
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

extension FlightBusinessSearchListViewController {
    
    func setTableView() {
        tableView.frame = self.view.frame
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "TableNoDateView", bundle: nil), forHeaderFooterViewReuseIdentifier: "TableNoDateView")
        tableView.register(FlightSearchListTableCellView.classForCoder(), forCellReuseIdentifier: self.tableBusinessSearchViewCellIdentify)
        tableView.register(FlightSearchListSelectedTripTableViewCell.classForCoder(), forCellReuseIdentifier: tableBusinessSearchViewSelectedTripCellIdentify)
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
        if FlightManager.shareInStance.selectedFlightTripDraw().count > 0 {
            return 2
        }
        return 1
    }
    
    //MARK:- UITableViewDataSources
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 && FlightManager.shareInStance.selectedFlightTripDraw().count > 0  {
            return FlightManager.shareInStance.selectedFlightTripDraw().count
        }
        return flightSVSearchList.count
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if flightSVSearchList.count == 0 && FlightManager.shareInStance.selectedFlightTripDraw().count  == 0 {
            return tableView.frame.height
        }
        
        if indexPath.section == 0 && FlightManager.shareInStance.selectedFlightTripDraw().count  > 0 {
         return 41
        }
        return 108
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if flightSVSearchList.count == 0  && FlightManager.shareInStance.selectedFlightTripDraw().count  == 0 {
            return tableView.frame.height
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if flightSVSearchList.count == 0 {
            if let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableNoDateView") as? TableNoDateView {
                footer.setType(.noData)
                return footer
            }
        }
        return nil
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && FlightManager.shareInStance.selectedFlightTripDraw().count > 0 {
            
            let cell:FlightSearchListSelectedTripTableViewCell = tableView.dequeueReusableCell(withIdentifier: tableBusinessSearchViewSelectedTripCellIdentify) as! FlightSearchListSelectedTripTableViewCell
            cell.fillDataSources(flight:FlightManager.shareInStance.selectedFlightTripDraw()[indexPath.row] , type: firstFlightSVSearchCondition.type, currentTrip:indexPath.row + 1)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: self.tableBusinessSearchViewCellIdentify) as! FlightSearchListTableCellView
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.fillDataSources(airfare:flightSVSearchList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = BusinessFlightSelectCabinViewController()
        vc.travelNo = self.travelNo
        vc.anOrder = self.anOrder
        let selectedTmpFlightTrip:FlightSVSearchResultVOModel.AirfareVO = flightSVSearchList[indexPath.row]
        FlightManager.shareInStance.addSelectedFlightTrip(searchCondition: selectedTmpFlightTrip, tripSection: firstFlightSVSearchCondition.currentTripSection)
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
}

extension FlightBusinessSearchListViewController {
    
    func setHeaderView() {
        self.view.addSubview(headerView)
        
        initDateLabel()
        
        headerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(40)
        }
        headerView.previousLabel.addOnClickListener(target: self, action: #selector(beforeDateClick(tap:)))
        headerView.nextLabel.addOnClickListener(target: self, action: #selector(nextDateClick(tap:)))
    }
    
    /// 初始化中间日期星期
    func initDateLabel(){
        let formatter = DateFormatter.init()
        formatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone?
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let flightSearchConditionArr = FlightManager.shareInStance.flightConditionDraw()
        
        // 返程航段
        if FlightManager.shareInStance.flightConditionDraw().first?.type == 1 &&
            FlightManager.shareInStance.flightConditionDraw().first?.currentTripSection == 2 {
            let returnDate:Date = formatter.date(from:(flightSearchConditionArr.first?.returnDateFormat)!)!
            headerView.dateView.dayLabel.text = returnDate.string(custom: "EEE")
            headerView.dateView.dateLabel.text = returnDate.string(custom: "MM-dd")
        }else {
            var departureDate:Date = Date()
            // 单程 和 往返 第一程
            if  FlightManager.shareInStance.flightConditionDraw().first?.type != 2 {
                departureDate = formatter.date(from: (flightSearchConditionArr.first?.departureDateFormat)!)!
            }else {
                let dateStr:String = flightSearchConditionArr[(flightSearchConditionArr.first?
                    .currentTripSection)!].departureDateFormat
                departureDate = formatter.date(from: dateStr)!
            }
            headerView.dateView.dayLabel.text = departureDate.string(custom: "EEE")
            headerView.dateView.dateLabel.text = departureDate.string(custom: "MM-dd")
        }
    }
    //下一天
    func nextDateClick(tap:UITapGestureRecognizer){
        
        let formatter = DateFormatter.init()
        formatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone?
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        var flightSearchConditionArr = FlightManager.shareInStance.flightConditionDraw()
        
        // 返程航段
        if FlightManager.shareInStance.flightConditionDraw().first?.type == 1 &&
            FlightManager.shareInStance.flightConditionDraw().first?.currentTripSection == 2 {
            let flightFirstSearchCondition = flightSearchConditionArr.first
            let date = formatter.date(from: (flightFirstSearchCondition!.returnDateFormat))!
            flightFirstSearchCondition?.returnDateFormat = formatter.string(from:date + 1.day)
            flightFirstSearchCondition?.returnDate = NSNumber.init(value: (date + 1.day).timeIntervalSince1970 * 1000).intValue
            flightSearchConditionArr[0] = flightFirstSearchCondition!
        }else {
            var departureDate:Date = Date()
            // 单程 和 往返 多程  去程
            if  FlightManager.shareInStance.flightConditionDraw().first?.type != 2 {
                
                let flightFirstSearchCondition = flightSearchConditionArr.first
                departureDate = formatter.date(from: (flightFirstSearchCondition!.departureDateFormat))!
                flightFirstSearchCondition?.departureDateFormat = formatter.string(from:departureDate + 1.day)
                flightFirstSearchCondition?.departureDate = NSNumber.init(value: (departureDate + 1.day).timeIntervalSince1970 * 1000).intValue
                flightSearchConditionArr[0] = flightFirstSearchCondition!
            }else {
                let departureDateStr:String = flightSearchConditionArr[(flightSearchConditionArr.first?
                    .currentTripSection)!].departureDateFormat
                departureDate = formatter.date(from: departureDateStr)!
                let flightIndexSearchCondition = flightSearchConditionArr[(flightSearchConditionArr.first?
                    .currentTripSection)!]
                flightIndexSearchCondition.returnDateFormat = formatter.string(from:departureDate + 1.day)
                flightIndexSearchCondition.returnDate = NSNumber.init(value: (departureDate + 1.day).timeIntervalSince1970 * 1000).intValue
                flightSearchConditionArr[(flightSearchConditionArr.first?.currentTripSection)!] = flightIndexSearchCondition
                
            }
        }
        
        FlightManager.shareInStance.flightConditionStore(searchConditionArr: flightSearchConditionArr)
        initDateLabel()
        initData()
        
    }
    //上一天
    func beforeDateClick(tap:UITapGestureRecognizer){
        let today = Date()
        let formatter = DateFormatter.init()
        formatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone?
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        var flightSearchConditionArr = FlightManager.shareInStance.flightConditionDraw()
        
        // 返程航段
        if FlightManager.shareInStance.flightConditionDraw().first?.type == 1 &&
            FlightManager.shareInStance.flightConditionDraw().first?.currentTripSection == 2 {
            let flightFirstSearchCondition = flightSearchConditionArr.first
            let returnDate = formatter.date(from: (flightFirstSearchCondition!.returnDateFormat))!
            if today > (returnDate - 1.day) {
                self.alertView(title: "提示", message: "已经是最早的可选择日期了")
                return
            }
            flightFirstSearchCondition?.returnDateFormat = formatter.string(from:returnDate - 1.day)
            flightFirstSearchCondition?.returnDate = NSNumber.init(value: (returnDate - 1.day).timeIntervalSince1970 * 1000).intValue
            flightSearchConditionArr[0] = flightFirstSearchCondition!
        }else {
            
            var departureDate:Date = Date()
            // 单程 和 往返 多程  去程
            if  FlightManager.shareInStance.flightConditionDraw().first?.type != 2 {
                
                let flightFirstSearchCondition = flightSearchConditionArr.first
                departureDate = formatter.date(from: (flightFirstSearchCondition!.departureDateFormat))!
                if today > (departureDate - 1.day) {
                    self.alertView(title: "提示", message: "已经是最早的可选择日期了")
                    return
                }
                flightFirstSearchCondition?.departureDateFormat = formatter.string(from:departureDate - 1.day)
                flightFirstSearchCondition?.departureDate = NSNumber.init(value: (departureDate - 1.day).timeIntervalSince1970 * 1000).intValue
                flightSearchConditionArr[0] = flightFirstSearchCondition!
            }else {
                let departureDateStr:String = flightSearchConditionArr[(flightSearchConditionArr.first?
                    .currentTripSection)!].departureDateFormat
                departureDate = formatter.date(from: departureDateStr)!
                if today > (departureDate - 1.day) {
                    self.alertView(title: "提示", message: "已经是最早的可选择日期了")
                    return
                }
                let flightIndexSearchCondition = flightSearchConditionArr[(flightSearchConditionArr.first?
                    .currentTripSection)!]
                flightIndexSearchCondition.returnDateFormat = formatter.string(from:departureDate - 1.day)
                flightIndexSearchCondition.returnDate = NSNumber.init(value: (departureDate - 1.day).timeIntervalSince1970 * 1000).intValue
                flightSearchConditionArr[(flightSearchConditionArr.first?.currentTripSection)!] = flightIndexSearchCondition
                
            }
        }
        FlightManager.shareInStance.flightConditionStore(searchConditionArr: flightSearchConditionArr)
        initDateLabel()
        initData()
    }
    
}

extension FlightBusinessSearchListViewController {
    
    func setNavigationController() {
//        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        setNavigationBgColor(color:TBIThemeWhite)
        setNavigationBackButton(backImage: "back")
    }
    
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
        //let flightTripTitleView: UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 150, height: 44))
        //flightTripTitleView.backgroundColor = UIColor.green
//        let labelStart = UILabel.init(text: start, color: TBIThemePrimaryTextColor, size: 16)
//        let imageView = UIImageView(imageName: "ic_air_to")
//        let labelArrive = UILabel.init(text: arrive, color: TBIThemePrimaryTextColor, size: 16)
//
//        titleView.addSubview(labelStart)
//        titleView.addSubview(imageView)
//        titleView.addSubview(labelArrive)
//        labelArrive.snp.makeConstraints{ (make) in
//            make.right.equalToSuperview()
//            make.centerY.equalToSuperview()
//        }
//        imageView.snp.makeConstraints{ (make) in
//            make.height.equalTo(15)
//            make.width.equalTo(20)
//            make.centerY.equalToSuperview()
//            make.right.equalTo(labelArrive.snp.left).inset(5)
//        }
//        labelStart.snp.makeConstraints{ (make) in
//            //make.top.equalTo(imageView.snp.top).offset(-7)
//            make.right.equalTo(imageView.snp.left).offset(-6)
//            make.centerY.equalToSuperview()
//        }
//
//
//        let typeLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 16)
//        typeLabel.layer.masksToBounds = true
//        typeLabel.layer.cornerRadius = 2
//        typeLabel.textAlignment = NSTextAlignment.center
//        typeLabel.backgroundColor = TBIThemeWhite
//        typeLabel.adjustsFontSizeToFitWidth = true
//        titleView.addSubview(typeLabel)
//        typeLabel.snp.remakeConstraints{ make in
//            make.height.equalTo(18)
//            make.right.equalTo(labelStart.snp.left).offset(-4)
//            make.centerY.equalTo(labelStart.snp.centerY)
//        }
//        typeLabel.isHidden = true
//        if firstFlightSVSearchCondition.type == 1  {
//            if firstFlightSVSearchCondition.currentTripSection == 1 {
//                typeLabel.text = "选去程:"
//                typeLabel.isHidden = false
//            }else
//            {
//                typeLabel.text = "选返程:"
//                typeLabel.isHidden = false
//            }
//
//        }else if firstFlightSVSearchCondition.type == 2 {
//            typeLabel.isHidden = false
//            //                typeLabel.snp.remakeConstraints{ make in
//            //                    make.height.equalTo(16)
//            //                    make.width.equalTo(65)
//            //                    make.right.equalTo(labelStart.snp.left).offset(-4)
//            //                    make.centerY.equalTo(labelStart.snp.centerY)
//            //                }
//            switch firstFlightSVSearchCondition.currentTripSection {
//            case 1 :
//                typeLabel.text = "第一程"
//            case 2:
//                typeLabel.text = "第二程"
//            case 3:
//                typeLabel.text = "第三程"
//            case 4:
//                typeLabel.text = "第四程"
//            default:
//                break
//            }
//
//        }
        
        
//        let baseBackgroundTitleView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWindowWidth - 150, height: 44))
//        baseBackgroundTitleView.backgroundColor = UIColor.red
//        baseBackgroundTitleView.addSubview(flightTripTitleView)
//        flightTripTitleView.snp.makeConstraints { (make) in
//            make.top.bottom.equalToSuperview()
//            make.center.equalToSuperview()
//        }
        
        self.navigationItem.titleView?.addSubview(flightTripCityTitleView)
        flightTripCityTitleView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(titleWidth)
        }
        //self.navigationItem.titleView = flightTripCityTitleView
    }
    
}
