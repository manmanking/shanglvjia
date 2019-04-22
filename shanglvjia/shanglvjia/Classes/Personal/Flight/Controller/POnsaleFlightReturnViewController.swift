//
//  POnsaleFlightReturnViewController.swift
//  shanglvjia
//
//  Created by tbi on 2018/8/8.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import MJRefresh
import SwiftDate

class POnsaleFlightReturnViewController: PersonalBaseViewController {

    private let flightDateHeaderHeight:CGFloat = 55
    
    fileprivate let flightListHeaderDateView:FlightListHeaderDateView = FlightListHeaderDateView()
    fileprivate var firstFlightSVSearchCondition:FlightSVSearchConditionModel = FlightSVSearchConditionModel()
    
    fileprivate var flightTripCityTitleView:FlightTripCityTitleView = FlightTripCityTitleView()
    
    fileprivate let listTableView = UITableView()
    fileprivate let tablePersonalSepcailViewCellIdentify = "PersonalFlightListCell"
    fileprivate let tableBusinessSearchViewSelectedTripCellIdentify = "PersonalFlightSearchListSelectedTripCell"
    
    public var personalOnsaleFlightListViewType:AppModelCatoryENUM = AppModelCatoryENUM.PersonalOnsaleFlight
    
    /// 0 国内 1 国际
    public var nationString:String = "0"
    // A 定投 F 特惠
    public var specialString:String = "A"
    
    
    /// 起飞时间 YYYY-MM-dd
    fileprivate var departureDateStr:String = ""
    
    var startCity:String = ""
    var arriveCity:String = ""
    var productId:String = ""
    //var type:String = ""
    var interCacheid = ""
    
    /// 返程时间
    fileprivate var flightTime:String = ""
    ///数据源
    fileprivate var flightSVSearchList:[PCommonFlightSVSearchModel.AirfareVO] = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = TBIThemeBaseColor
        setBlackTitleAndNavigationColor(title: "")
        setNavigationBackButton(backImage: "left")
        
        setHeaderViewAutolayout()
        setTableView()
        
        firstFlightSVSearchCondition.type = 1
        firstFlightSVSearchCondition.currentTripSection = 2
        
        
        setTitleView(start:arriveCity, arrive:startCity )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 日期样式
    func setHeaderViewAutolayout() {
        
        weak var weakSelf = self
        self.view.addSubview(flightListHeaderDateView)
        flightListHeaderDateView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(flightDateHeaderHeight)
        }
        flightListHeaderDateView.headerDateShowType = .PersonalFlight
        var returnDateFromStr:String = PersonalOnsaleFlightManager.shareInStance
            .selectedFlightTripDraw().first?.flightInfos.first?.returnDateFrom ?? ""
        var returnDateToStr:String = PersonalOnsaleFlightManager.shareInStance
            .selectedFlightTripDraw().first?.flightInfos.first?.returnDateTo ?? ""

        let departureDateFromStr:String = PersonalOnsaleFlightManager.shareInStance
            .selectedFlightTripDraw().first?.flightInfos.first?.departureDateFrom ?? ""
        let departureDateFromToStr:String = PersonalOnsaleFlightManager.shareInStance
            .selectedFlightTripDraw().first?.flightInfos.first?.departureDateFromTo ?? ""
        let takeoffDateTimeInterval:NSInteger = (PersonalOnsaleFlightManager.shareInStance.selectedFlightTripDraw().first?.flightInfos.first?.takeOffDate)!
        let takeoffDate:Date = Date.init(timeIntervalSince1970: TimeInterval(takeoffDateTimeInterval/1000))
        flightListHeaderDateView.headerDateType = FlightListHeaderDateView.ListHeaderDateType.DateContinuance
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY-MM-dd"
        dateformatter.timeZone = NSTimeZone.local
        
        let returnDateFrom:NSInteger = NSInteger(returnDateFromStr)!
        let returnDateTo:NSInteger = NSInteger(returnDateToStr)!
        
//        let departureDateFrom:Date = departureDateFromStr.stringToDate(dateFormat: "YYYY-MM-dd")
//        let departureDateFromTo:Date = departureDateFromToStr.stringToDate(dateFormat: "YYYY-MM-dd")
//
        
        if returnDateFrom == 0 && returnDateTo == 0 {
            returnDateFromStr = departureDateFromStr
            returnDateToStr = departureDateFromToStr
        }else {
            returnDateFromStr = dateformatter.string(from:(takeoffDate + returnDateFrom.day))
            //.string(custom: "YYYY-MM-dd")
            returnDateToStr = dateformatter.string(from:(takeoffDate + returnDateTo.day))
            //.string(custom: "YYYY-MM-dd")
        }
        departureDateStr = returnDateFromStr
        flightListHeaderDateView.fillDataSourcesContinuanceDate(fromDate: returnDateFromStr, toDate: returnDateToStr, selectedDate:returnDateFromStr)
        
        
        
       
        flightListHeaderDateView.flightListHeaderDateViewSelectedDateBlock = { selectedDate in
            weakSelf?.flightListHeaderDateViewSelectedDateModifySearchCondition(selectedDate: selectedDate)
            weakSelf?.loadOnsaleCabinListNET()
            
        }
        
    }
    func flightListHeaderDateViewSelectedDateModifySearchCondition(selectedDate:NSInteger) {
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone.local
        formatter.dateFormat = "YYYY-MM-dd" // HH:mm:ss
        let startDate:Date = Date.init(timeIntervalSince1970: TimeInterval(selectedDate))
        departureDateStr = formatter.string(from: startDate)
        
//        let departureDateInter = PersonalOnsaleFlightManager.shareInStance.selectedFlightTripDraw().first?.flightInfos.first?.takeOffDate
//        let departureDate:Date = Date.init(timeIntervalSince1970: TimeInterval(departureDateInter! / 1000))
//        departureDateStr = departureDate.string(custom: "YYYY-MM-dd")
            //NSNumber.init(value: departureDate.timeIntervalSince1970 * 1000).intValue.description
        interCacheid = ""
        //type = "0"
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
    override func backButtonAction(sender: UIButton) {
        
       
        self.navigationController?.popViewController(animated: true)
        
    }

}
extension POnsaleFlightReturnViewController:UITableViewDataSource,UITableViewDelegate {
    func setTableView() {
        listTableView.frame = self.view.frame
        listTableView.dataSource = self
        listTableView.delegate = self
        listTableView.register(PersonalFlightListCell.classForCoder(), forCellReuseIdentifier: self.tablePersonalSepcailViewCellIdentify)
        listTableView.register(PersonalFlightSearchListSelectedTripCell.classForCoder(), forCellReuseIdentifier: tableBusinessSearchViewSelectedTripCellIdentify)
        listTableView.separatorStyle = .none
        listTableView.backgroundColor = TBIThemeBaseColor
        self.view.addSubview(listTableView)
        listTableView.snp.makeConstraints { (make) in
            make.top.equalTo(flightListHeaderDateView.snp.bottom)
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.width.equalToSuperview()
        }
        weak var weakSelf = self
        listTableView.mj_header = MJRefreshNormalHeader{
            weakSelf?.loadOnsaleCabinListNET()
        }
        listTableView.mj_header.beginRefreshing()
    }
    //MARK:- UITableViewDataSources
    func numberOfSections(in tableView: UITableView) -> Int {
        if PersonalOnsaleFlightManager.shareInStance.selectedFlightTripDraw().count > 0 {
            return 2
        }
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 && PersonalOnsaleFlightManager.shareInStance.selectedFlightTripDraw().count > 0  {
            return PersonalOnsaleFlightManager.shareInStance.selectedFlightTripDraw().count
        }
        return flightSVSearchList.count
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && PersonalOnsaleFlightManager.shareInStance.selectedFlightTripDraw().count  > 0 {
            return 41
        }
        return 152
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 && PersonalOnsaleFlightManager.shareInStance.selectedFlightTripDraw().count > 0 {
            
            let cell:PersonalFlightSearchListSelectedTripCell = tableView.dequeueReusableCell(withIdentifier: tableBusinessSearchViewSelectedTripCellIdentify) as! PersonalFlightSearchListSelectedTripCell
            cell.fillDataSourcesCommon(flight:PersonalOnsaleFlightManager.shareInStance.selectedFlightTripDraw()[indexPath.row] , type: firstFlightSVSearchCondition.type, currentTrip:indexPath.row + 1)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.tablePersonalSepcailViewCellIdentify) as! PersonalFlightListCell
        cell.fillOnsaleDataSources(airfare:flightSVSearchList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 0{
            let selectVC:POnsaleFlightSelectCabinController = POnsaleFlightSelectCabinController()
            selectVC.startCity = startCity
            selectVC.arriveCity = arriveCity
            selectVC.tripType = 1
            selectVC.productId = productId
            selectVC.nationString = nationString
            selectVC.specialString = specialString
            
            let selectedTmpFlightTrip:PCommonFlightSVSearchModel.AirfareVO = flightSVSearchList[indexPath.row]
            selectedTmpFlightTrip.productId = productId
            selectedTmpFlightTrip.flightNation = nationString
            selectedTmpFlightTrip.flightTripType = PersonalOnsaleFlightManager.shareInStance.selectedFlightTripDraw().first?.flightTripType ?? ""
            PersonalOnsaleFlightManager.shareInStance.addSelectedFlightTrip(searchCondition: selectedTmpFlightTrip, tripSection: 2)
            
            self.navigationController?.pushViewController(selectVC, animated: true)
        }
        
    }
    
    
    //MARK:--------NET--------
    
    func loadOnsaleCabinListNET(){
        
        showLoadingView()
        weak var weakSelf = self
        var tripOption = "1"
        //(type == "0" ? "1" : "2")
//        if nationString == "1" {
//            tripOption = "2"
//        }
        
        var request:[String:Any] = [String:Any]()
        
        
        // 国内
        if nationString == "0" {
            request = ["type":"0","productId":productId,"departureDate":departureDateStr,
                       "tripOption":"1"]
        }else { //国际
            ///航班号拼接
            var goFlightNos = [String]()
            for i in 0...(PersonalOnsaleFlightManager.shareInStance.selectedFlightTripDraw().first?.flightInfos.count)! - 1{
                goFlightNos.append(CommonTool
                    .replace((PersonalOnsaleFlightManager.shareInStance.selectedFlightTripDraw().first?.flightInfos[i].flightCode)! , withInstring: " ", withOut: "") + CommonTool.replace((PersonalOnsaleFlightManager.shareInStance.selectedFlightTripDraw().first?.flightInfos[i].flightNo)! , withInstring: " ", withOut: ""))
            }
            let takeoffDateTimeInterval:NSInteger = (PersonalOnsaleFlightManager.shareInStance.selectedFlightTripDraw().first?.flightInfos.first?.takeOffDate)!
            let takeoffDate:Date = Date.init(timeIntervalSince1970: TimeInterval(takeoffDateTimeInterval/1000))
            flightListHeaderDateView.headerDateType = FlightListHeaderDateView.ListHeaderDateType.DateContinuance
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "YYYY-MM-dd"
            dateformatter.timeZone = NSTimeZone.local
            let departureDate = dateformatter.string(from: takeoffDate)
            request = ["type":nationString,"productId":productId,"departureDate":departureDate,
                       "tripOption":"1","destinationDate":departureDateStr,
                       "interCacheId":interCacheid,"goFlightNos":goFlightNos.joined(separator: ",")]
        }
        PersonalFlightServices.sharedInstance.onsalePersonalFlightCabinList(request: request)
            .subscribe{ event in
                weakSelf?.hideLoadingView()
                 weakSelf?.listTableView.mj_header.endRefreshing()
                
                switch event {
                case .next(let element):
                    printDebugLog(message: element.mj_keyValues())
                    weakSelf?.flightSVSearchList.removeAll()
                    weakSelf?.flightSVSearchList = element.airfares
                    weakSelf?.listTableView.reloadData()
                case .error(let error):
                    weakSelf?.hideLoadingView()
                    try? weakSelf?.validateHttp(error)
                case .completed:
                    break
                    
                }
        }
    }
    
}

