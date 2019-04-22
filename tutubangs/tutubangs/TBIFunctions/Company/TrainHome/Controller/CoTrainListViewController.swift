//
//  CoTrainListViewController.swift
//  shop
//
//  Created by TBI on 2017/12/26.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import RxSwift
import SwiftDate
import MJRefresh

class CoTrainListViewController: CompanyBaseViewController {
    
    fileprivate let coTrainListTableViewCellIdentify = "coTrainListTableViewCellIdentify"
    
    fileprivate let tableView = UITableView()
    
    fileprivate let headerView = CoTrainListHeaderView()
    
    fileprivate let fromTrainView = CoTrainListHeaderTrainsView()
    
    fileprivate let footerView = CoTrainListFooterView()
    
    fileprivate let countLabel: UILabel = UILabel(text: "", color: TBIThemeWhite, size: 10)
    
    fileprivate var offsetY:CGFloat = 0
    
    fileprivate var trainBookMax:NSInteger = 30
    
    fileprivate let bag = DisposeBag()
    
    fileprivate var data:CoTrainListItem?
    
    fileprivate var trainResponse:QueryTrainResponse = QueryTrainResponse()
    
    fileprivate var trainAvailDataSources:[QueryTrainResponse.TrainAvailInfo] = Array()
    
    fileprivate var trainAvailInfo:[CoTrainAvailInfo]?
    
    fileprivate var type:Int = 0
    
    var travelNo:String? = nil
    
    /// 过滤条件
    var filterData:[[(index:Int,selected:Bool,value:String)]] = []
    
    var sort:TrainSort = TrainSort.startTimeAsc
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trainBookMax = UserDefaults.standard.object(forKey: trainBookMaxDate) as! NSInteger
        type = TrainManager.shareInstance.trainSearchConditionDraw().type
        if TrainManager.shareInstance.trainSearchConditionDraw().type == 2 {
            setTitleView(start: TrainManager.shareInstance.trainSearchConditionDraw().toStationName,
                         arrive: TrainManager.shareInstance.trainSearchConditionDraw().fromStationName)
        }else {
            setTitleView(start: TrainManager.shareInstance.trainSearchConditionDraw().fromStationName,
                         arrive: TrainManager.shareInstance.trainSearchConditionDraw().toStationName)
        }
        
        initView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initDateLabel()
//        tableView.mj_header.beginRefreshing()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        setNavigationBackButton(backImage: "back")
        setNavigationBgColor(color: TBIThemeBlueColor)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func backButtonAction(sender:UIButton) {
        let searchCondition = TrainManager.shareInstance.trainSearchConditionDraw()
        if searchCondition.type == 2 {
            searchCondition.type = 1
        }
        TrainManager.shareInstance.trainSearchConditionStore(searchCondition: searchCondition)
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
////        let contentOffsetY = scrollView.contentOffset.y
////        if contentOffsetY > offsetY {
////            // 在最底部
////            footerView.isHidden = true
////        } else {
////            footerView.isHidden = false
////        }
//        footerView.isHidden = true
//    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        offsetY = scrollView.contentOffset.y
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        footerView.isHidden = false
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        footerView.isHidden = false
    }
    
}

extension  CoTrainListViewController: UITableViewDelegate,UITableViewDataSource {
    func initTableView() {
        //设置tableview
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(CoTrainListTableViewCell.self, forCellReuseIdentifier: coTrainListTableViewCellIdentify)
        tableView.register(UINib(nibName: "TableNoDateView", bundle: nil), forHeaderFooterViewReuseIdentifier: "TableNoDateView")
        let travel = PassengerManager.shareInStance.passengerSVDraw().first//passengerDraw().first
        if TrainManager.shareInstance.trainSearchConditionDraw().type == 2 {
            self.view.addSubview(tableView)
            tableView.snp.makeConstraints { (make) in
                make.top.equalTo(fromTrainView.snp.bottom)
                make.left.right.bottom.equalToSuperview()
            }
            //监听上拉刷新
            weak var weakSelf = self
            tableView.mj_header = MJRefreshNormalHeader{
                self.showLoadingView()
                CoTrainService.sharedInstance
                    .search(fromStation: TrainManager.shareInstance.trainSearchConditionDraw().toStation,
                            toStation: TrainManager.shareInstance.trainSearchConditionDraw().fromStation,
                            travelDate: TrainManager.shareInstance.trainSearchConditionDraw().returnDate ,
                            policy:travel?.policyId ?? "")
                    .subscribe{ event in
                    weakSelf?.tableView.mj_header.endRefreshing()
                    weakSelf?.hideLoadingView()
                    switch event{
                    case .next(let e):
                        //printDebugLog(message: e.mj_keyValues())
                        weakSelf?.trainResponse = e
                        if TrainManager.shareInstance.trainSearchConditionDraw().isGt {
                            weakSelf?.trainAvailDataSources = weakSelf?.trainAvailDataSources.filterTrainType(["G","D","C"]) ?? []
                        }else
                        {
                            weakSelf?.trainAvailDataSources = weakSelf?.trainResponse.trainAvailInfos.sorted(TrainSort.startTimeAsc) ?? []
                        }
                        weakSelf?.filterData = (weakSelf?.footerView.setCityData(cityData: weakSelf?.trainAvailDataSources.getAllRailwayStation() ?? [], flag:weakSelf?.filterData.isEmpty ?? true))!
                        weakSelf?.filterSort()
                        weakSelf?.countLabel.text = "共\(weakSelf?.trainAvailDataSources.count ?? 0)车次"
                        weakSelf?.tableView.reloadData()
                    case .error(let e):
                        try? self.validateHttp(e)
                        if  weakSelf?.trainAvailDataSources.count ?? 0 > 0 {
                            weakSelf?.trainAvailDataSources.removeAll()
                        }
                        
                        weakSelf?.countLabel.text = "共\(weakSelf?.trainAvailDataSources.count ?? 0)车次"
                        weakSelf?.tableView.reloadData()
                    case .completed:
                        break
                    }
                    }.addDisposableTo(self.bag)
            }
            tableView.mj_header.beginRefreshing()
        }else {
            self.view.addSubview(tableView)
            tableView.snp.makeConstraints { (make) in
                make.top.equalTo(headerView.snp.bottom)
                make.left.right.bottom.equalToSuperview()
            }
            //监听上拉刷新
            weak var weakSelf = self
            tableView.mj_header = MJRefreshNormalHeader{
                weakSelf?.showLoadingView()
                CoTrainService.sharedInstance.search(fromStation: TrainManager.shareInstance.trainSearchConditionDraw().fromStation,
                                                     toStation: TrainManager.shareInstance.trainSearchConditionDraw().toStation,
                                                     travelDate: TrainManager.shareInstance.trainSearchConditionDraw().departDate,policy:travel?.policyId ?? "")
                    .subscribe{ event in
                    self.tableView.mj_header.endRefreshing()
                    self.hideLoadingView()
                    switch event{
                    case .next(let e):
                        
                        //printDebugLog(message: e.mj_keyValues())
                        weakSelf?.trainResponse = e
                        if TrainManager.shareInstance.trainSearchConditionDraw().isGt {
                            weakSelf?.trainAvailDataSources = weakSelf?.trainAvailDataSources.filterTrainType(["G","D","C"]) ?? []
                        }else
                        {
                            weakSelf?.trainAvailDataSources = weakSelf?.trainResponse.trainAvailInfos.sorted(TrainSort.startTimeAsc) ?? []
                        }
                        weakSelf?.filterData = (weakSelf?.footerView.setCityData(cityData: weakSelf?.trainAvailDataSources.getAllRailwayStation() ?? [], flag:weakSelf?.filterData.isEmpty ?? true))!
                        weakSelf?.filterSort()
                        weakSelf?.countLabel.text = "共\(weakSelf?.trainAvailDataSources.count ?? 0)车次"
                        weakSelf?.tableView.reloadData()
                    case .error(let e):
                        try? self.validateHttp(e)
                        if  weakSelf?.trainAvailDataSources.count ?? 0 > 0 {
                            weakSelf?.trainAvailDataSources.removeAll()
                        }
                        
                        weakSelf?.countLabel.text = "共\(weakSelf?.trainAvailDataSources.count ?? 0)车次"
                        weakSelf?.tableView.reloadData()
                    case .completed:
                        break
                    }
                    }.addDisposableTo(self.bag)
            }
            tableView.mj_header.beginRefreshing()
        }
        //设置刷选条件view
        self.view.addSubview(footerView)
        footerView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalToSuperview()
        }
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  trainAvailDataSources.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if (trainAvailDataSources.count ) == 0 {
            return tableView.frame.height
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if (trainResponse.trainAvailInfos.count ) == 0 {
            if let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableNoDateView") as? TableNoDateView {
                footer.setType(.noNewOrder)
                footer.messageLabel.text="当前条件下暂未查询到车次"
                return footer
            }
        }
        return nil
    }
    
    // MARK: 创建cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: coTrainListTableViewCellIdentify, for: indexPath) as! CoTrainListTableViewCell
        cell.selectionStyle = .none
        //cell.fillCell(model: trainAvailInfo?[indexPath.row])
        cell.fillDataSources(model: trainAvailDataSources[indexPath.row])
        return cell
    }
    // MARK: 点击cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CoTrainDetailViewController()
        vc.travelNo = self.travelNo
        if TrainManager.shareInstance.trainSearchConditionDraw().type == 2 {
            //toCoTrainAvailInfo  = trainAvailDataSources[indexPath.row]
            TrainManager.shareInstance.trainEndStationStore(to:trainAvailDataSources[indexPath.row])
            //trainAvailInfo?[indexPath.row]
        }else {
            //formCoTrainAvailInfo = trainAvailInfo?[indexPath.row]
            TrainManager.shareInstance.trainStartStationStore(from: trainAvailDataSources[indexPath.row])
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: row高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 99
    }
}
extension  CoTrainListViewController {
    
    
    
    func setFooterView() {
        self.view.addSubview(footerView)
        footerView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalToSuperview()
        }
        weak var weakSelf = self
        footerView.trainSortBlock = { (parameters ) in
            weakSelf?.sort = parameters
            weakSelf?.filterSort()
//            weakSelf?.trainAvailInfo = weakSelf?.trainAvailInfo?.sorted(parameters)
//            weakSelf?.tableView.reloadData()
        }
  
        footerView.trainFliterBlock  = { (parameters) in
            weakSelf?.filterData = parameters
            weakSelf?.filterSort()
//            var dataList = weakSelf?.data?.trainAvailInfo
//            dataList = weakSelf?.filterTrainType(list: dataList, model: parameters[0])
//            dataList = weakSelf?.filterTime(list: dataList, model: parameters[1])
//            dataList = weakSelf?.filterStation(list: dataList, model: parameters[2])
//            dataList = weakSelf?.filterIsStart(list: dataList, model: parameters[3])
//            weakSelf?.trainAvailInfo = dataList
//            weakSelf?.countLabel.text = "共\(self.trainAvailInfo?.count ?? 0)车次"
//            weakSelf?.tableView.reloadData()
        }
    }
    
    /// 过滤帅选条件
    func filterSort (){
        
        var dataList = self.trainResponse.trainAvailInfos
        if !filterData.isEmpty {
            dataList = self.filterTrainType(list: dataList, model: filterData[0]) ?? []
            dataList = self.filterTime(list: dataList, model: filterData[1]) ?? []
            dataList = self.filterStation(list: dataList, model: filterData[2]) ?? []
            dataList = self.filterIsStart(list: dataList, model: filterData[3]) ?? []
        }
        self.trainAvailDataSources = dataList
        self.countLabel.text = "共\(self.trainAvailDataSources.count ?? 0)车次"
        self.trainAvailDataSources = self.trainAvailDataSources.sorted(sort)
        self.tableView.reloadData()
        
        
        
//        var dataList = self.data?.trainAvailInfo
//        if !filterData.isEmpty {
//            dataList = self.filterTrainType(list: dataList, model: filterData[0])
//            dataList = self.filterTime(list: dataList, model: filterData[1])
//            dataList = self.filterStation(list: dataList, model: filterData[2])
//            dataList = self.filterIsStart(list: dataList, model: filterData[3])
//        }
//        self.trainAvailInfo = dataList
//        self.countLabel.text = "共\(self.trainAvailInfo?.count ?? 0)车次"
//        self.trainAvailInfo = self.trainAvailInfo?.sorted(sort)
//        self.tableView.reloadData()
    }
    
    // 过滤车站
    func filterTime (list:[QueryTrainResponse.TrainAvailInfo]?,model:[(index:Int,selected:Bool,value:String)]) -> [QueryTrainResponse.TrainAvailInfo]? {
    
        let mo = model.filter{$0.selected == true}
        if  mo.isEmpty {
            return list
        }
        var listData:[QueryTrainResponse.TrainAvailInfo] = []
        if  model[0].selected {
            listData += list?.minTimeLimit("00:00").maxTimeLimit("06:00") ?? []
        }
        if  model[1].selected {
            listData += list?.minTimeLimit("06:00").maxTimeLimit("12:00") ?? []
        }
        if  model[2].selected {
            listData += list?.minTimeLimit("12:00").maxTimeLimit("18:00") ?? []
        }
        if  model[3].selected {
            listData += list?.minTimeLimit("18:00").maxTimeLimit("24:00") ?? []
        }
        return listData
    }
    
    // 过滤车站
    func filterStation (list:[QueryTrainResponse.TrainAvailInfo]?,model:[(index:Int,selected:Bool,value:String)]) -> [QueryTrainResponse.TrainAvailInfo]? {
        var stations:[String] = []
        for data in model {
            if data.selected {
                stations.append(data.value)
            }
        }
        if stations.isEmpty {
            return list
        }else {
            return list?.filterStation(stations)
        }
    }
    // 过滤车次类型
    func filterIsStart(list:[QueryTrainResponse.TrainAvailInfo]?,model:[(index:Int,selected:Bool,value:String)]) -> [QueryTrainResponse.TrainAvailInfo]? {
        if model[0].selected == false && model[1].selected == false{
            return list
        }
        var listData:[QueryTrainResponse.TrainAvailInfo] = []
        if model[0].selected {
            listData += list?.filterIsStart(isStart: true) ?? []
        }
        if model[1].selected {
            listData += list?.filterIsStart(isStart: false) ?? []
        }
        return listData
    }
    // 过滤车次类型
    func filterTrainType (list:[QueryTrainResponse.TrainAvailInfo]?,model:[(index:Int,selected:Bool,value:String)]) -> [QueryTrainResponse.TrainAvailInfo]? {
        var trainTypes:[String] = []
        if model[0].selected == true {
            trainTypes.append("G")
            trainTypes.append("C")
        }
        if model[1].selected == true {
            trainTypes.append("D")
        }
        if model[2].selected == true {
            trainTypes.append("Z")
        }
        if model[3].selected == true {
            trainTypes.append("T")
        }
        if model[4].selected == true {
            trainTypes.append("K")
        }
        if model[5].selected == true {
            trainTypes.append("L")
            trainTypes.append("A")
            trainTypes.append("Y")
            trainTypes.append("0")
            trainTypes.append("1")
            trainTypes.append("2")
            trainTypes.append("3")
            trainTypes.append("4")
            trainTypes.append("5")
            trainTypes.append("6")
            trainTypes.append("7")
            trainTypes.append("8")
            trainTypes.append("9")
        }
        if trainTypes.isEmpty {
            return list
        }else {
            return list?.filterTrainType(trainTypes)
        }
        
    }
}
extension  CoTrainListViewController {
    
    func initView () {
        setHeaderView()
        setFooterView()
        initTableView()
    }
    
    
    func setHeaderView() {
        self.view.addSubview(headerView)
        
        initDateLabel()
        
        headerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(40)
        }
        
        if TrainManager.shareInstance.trainSearchConditionDraw().type == 2{
            self.view.addSubview(fromTrainView)
            fromTrainView.initData()
            fromTrainView.snp.makeConstraints{ (make) in
                make.left.right.equalToSuperview()
                make.top.equalTo(headerView.snp.bottom)
                make.height.equalTo(45)
            }
            
        }
        headerView.previousLabel.addOnClickListener(target: self, action: #selector(beforeDateClick(tap:)))
        headerView.nextLabel.addOnClickListener(target: self, action: #selector(nextDateClick(tap:)))
        headerView.dateView.addOnClickListener(target: self, action: #selector(dateClick(tap:)))
    }
    
    
    func dateClick (tap:UITapGestureRecognizer) {
        weak var weakSelf = self
        let vc:TBICalendarViewController = TBICalendarViewController()
            vc.isMultipleTap = false
            vc.calendarAlertType = TBICalendarAlertType.Train
            vc.showDateTitle = [""]
            vc.titleColor = TBIThemePrimaryTextColor
            vc.bacButtonImageName = "back"
            vc.hotelSelectedDateAcomplishBlock = { (parameters,action) in
                if action == TBICalendarAction.Back {
                    return
                }
                
                let formatter = DateFormatter()
                formatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone?
                formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
                //let dateString = parameters?[0]
                let date:Date = formatter.date(from:(parameters?[0])!)!
                let searchCondition = TrainManager.shareInstance.trainSearchConditionDraw()
                if TrainManager.shareInstance.trainSearchConditionDraw().type == 2 {
                    searchCondition.returnDateFormat = (parameters?[0])!
                    searchCondition.returnDate = date.string(custom: "YYYY-MM-dd")
                }else {
                    searchCondition.departureDateFormat = (parameters?[0])!
                    searchCondition.departDate = date.string(custom: "YYYY-MM-dd")
                    
                }
                TrainManager.shareInstance.trainSearchConditionStore(searchCondition: searchCondition)
                weakSelf?.initDateLabel()
                weakSelf?.tableView.mj_header.beginRefreshing()
            }
        _ = self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    /// 初始化中间日期星期
    func initDateLabel(){
        if TrainManager.shareInstance.trainSearchConditionDraw().type == 2 {
            let date = DateInRegion(string: TrainManager.shareInstance.trainSearchConditionDraw().returnDate,
                                    format: .custom("YYYY-MM-dd"), fromRegion: regionRome)!
            headerView.dateView.dayLabel.text = date.string(custom: "EEE")
            let index = TrainManager.shareInstance.trainSearchConditionDraw().returnDate.index(TrainManager.shareInstance.trainSearchConditionDraw().returnDate.endIndex, offsetBy: -5)
            headerView.dateView.dayLabel.text = TrainManager.shareInstance.trainSearchConditionDraw().returnDate.substring(from: index) + " \(date.string(custom: "EEE"))"
        }else {
           
            let date = DateInRegion(string: TrainManager.shareInstance.trainSearchConditionDraw().departDate, format: .custom("YYYY-MM-dd"), fromRegion: regionRome)!
            headerView.dateView.dayLabel.text = date.string(custom: "EEE")
            let index = TrainManager.shareInstance.trainSearchConditionDraw().departDate.index(TrainManager.shareInstance.trainSearchConditionDraw().departDate.endIndex, offsetBy: -5)
            
            headerView.dateView.dayLabel.text = TrainManager.shareInstance.trainSearchConditionDraw().departDate.substring(from: index) + " \(date.string(custom: "EEE"))"
        }
        
        
        
    }
    //下一天
    func nextDateClick(tap:UITapGestureRecognizer){
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone?
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let searchCondition = TrainManager.shareInstance.trainSearchConditionDraw()
        if TrainManager.shareInstance.trainSearchConditionDraw().type == 2{
            let date = formatter.date(from: searchCondition.returnDateFormat)!
            let returnDate = date + 1.day
            
            let compareComponent = returnDate.compare(to: (Date() + trainBookMax.day).startOfDay, granularity: Calendar.Component.day)
            if compareComponent != ComparisonResult.orderedAscending {
                showSystemAlertView(titleStr: "提示", message: "超出可预定日期,请重新选择!")
                return
            }
            
            searchCondition.returnDateFormat = formatter.string(from: returnDate)
            formatter.dateFormat = "YYYY-MM-dd"
            formatter.timeZone = NSTimeZone.local
            searchCondition.returnDate =  formatter.string(from: returnDate)

        }else {
            let date = formatter.date(from: searchCondition.departureDateFormat)!
            let departDate =  date + 1.day
            let compareComponent = departDate.compare(to: (Date() + trainBookMax.day).startOfDay, granularity: Calendar.Component.day)
            if compareComponent != ComparisonResult.orderedAscending {
                showSystemAlertView(titleStr: "提示", message: "超出可预定日期,请重新选择!")
                return
            }
            searchCondition.departureDateFormat = formatter.string(from: departDate)
            formatter.dateFormat = "YYYY-MM-dd"
            formatter.timeZone = NSTimeZone.local
            
            searchCondition.departDate = formatter.string(from: departDate)
        }
        TrainManager.shareInstance.trainSearchConditionStore(searchCondition: searchCondition)
        initDateLabel()
        tableView.mj_header.beginRefreshing()
    }
    //上一天
    func beforeDateClick(tap:UITapGestureRecognizer){
        
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone?
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let searchCondition = TrainManager.shareInstance.trainSearchConditionDraw()
        let today = Date()
        if searchCondition.type == 2{
            let date = formatter.date(from: searchCondition.returnDateFormat)!
            //DateInRegion(string: searchCondition.returnDate, format: .custom("YYYY-MM-dd"), fromRegion: regionRome)!
            let returnDate = date - 1.day
            if today > date {
                self.alertView(title: "提示", message: "该日期此车不运行")
                return
            }
            searchCondition.returnDateFormat =  formatter.string(from: returnDate)
            formatter.dateFormat = "YYYY-MM-dd"
            formatter.timeZone = NSTimeZone.local
            
            searchCondition.returnDate = formatter.string(from: returnDate)
            //returnDate.string(custom: "YYYY-MM-dd")
            
        }else {
            let date:Date = formatter.date(from: searchCondition.departureDateFormat)!
            let departureDate =  date - 1.day
            if today > date {
                self.alertView(title: "提示", message: "该日期此车不运行")
                return
            }
            searchCondition.departureDateFormat = formatter.string(from:departureDate)
            formatter.dateFormat = "YYYY-MM-dd"
            formatter.timeZone = NSTimeZone.local
            searchCondition.departDate =  formatter.string(from: departureDate)
        }
        TrainManager.shareInstance.trainSearchConditionStore(searchCondition: searchCondition)
        initDateLabel()
        tableView.mj_header.beginRefreshing()
    }
    
    func setTitleView(start: String, arrive: String) {
        let titleView: UIView = {
            let vi = UIView()
            let labelStart = UILabel.init(text: start, color: TBIThemeWhite, size: 16)
            let  line = UILabel(color: TBIThemeWhite)
            let labelArrive = UILabel.init(text: arrive, color: TBIThemeWhite, size: 16)
            
            vi.addSubview(labelStart)
            vi.addSubview(line)
            vi.addSubview(labelArrive)
            vi.addSubview(countLabel)
            line.snp.makeConstraints{ (make) in
                make.height.equalTo(2)
                make.width.equalTo(8)
                if TrainManager.shareInstance.trainSearchConditionDraw().type == 0 {
                    make.centerX.equalToSuperview()
                }else {
                    make.centerX.equalToSuperview().inset(33)
                }
                make.centerY.equalToSuperview().offset(-3)
            }
            labelStart.snp.makeConstraints{ (make) in
                make.top.equalTo(line.snp.top).offset(-7)
                make.right.equalTo(line.snp.left).offset(-6)
            }
            labelArrive.snp.makeConstraints{ (make) in
                make.top.equalTo(labelStart.snp.top)
                make.left.equalTo(line.snp.right).offset(6)
            }
            countLabel.snp.makeConstraints({ (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(line.snp.bottom).offset(12)
            })
            let typeLabel = UILabel(text: "", color: TBIThemeWhite, size: 16)
            typeLabel.isHidden = true
            if TrainManager.shareInstance.trainSearchConditionDraw().type == 1 {
                typeLabel.text = "选去程: "
                typeLabel.isHidden = false
            }else if TrainManager.shareInstance.trainSearchConditionDraw().type == 2{
                typeLabel.text = "选返程: "
                typeLabel.isHidden = false
            }
            vi.addSubview(typeLabel)
            typeLabel.snp.makeConstraints{ make in
                make.right.equalTo(labelStart.snp.left).offset(-4)
                make.centerY.equalTo(labelStart.snp.centerY)
            }
            return vi
        }()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.titleView = titleView
    }
}

