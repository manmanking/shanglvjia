//
//  PSepcialFlightListViewController.swift
//  shanglvjia
//
//  Created by tbi on 2018/8/6.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import SwiftyJSON
import MJRefresh

class PSepcialFlightListViewController: PersonalBaseViewController {

    private let flightDateHeaderHeight:CGFloat = 55
    
    /// 0 国内 1 国际
    public var remainTicket:NSNumber = 0
    
    fileprivate let flightListHeaderDateView:FlightListHeaderDateView = FlightListHeaderDateView()
    fileprivate var firstFlightSVSearchCondition:FlightSVSearchConditionModel = FlightSVSearchConditionModel()
    
    fileprivate var flightTripCityTitleView:FlightTripCityTitleView = FlightTripCityTitleView()
    
    fileprivate let listTableView = UITableView()
    fileprivate let tablePersonalSepcailViewCellIdentify = "PersonalFlightListCell"
    fileprivate let tableBusinessSearchViewSelectedTripCellIdentify = "tableBusinessSearchViewSelectedTripCellIdentify"
    public var personalOnsaleFlightListViewType:AppModelCatoryENUM = AppModelCatoryENUM.PersonalSpecialHotel
    
    ///数据源 定投
    fileprivate var flightSVSearchList:[PSepcailFlightCabinModel.ResponsesListVo] = Array()
    fileprivate var flightModel = PSepcailFlightCabinModel()
    fileprivate var flightInfo = PersonalSpecialFlightInfoListResponse()
    ///可选日期数组
    fileprivate var deaprtureDatesArray:[String] = Array()
    
    /// 0 国内 1 国际
    public var nationString:PSpecialOfferFlightViewController.PersonalFlightTripNationTypeEnum = PSpecialOfferFlightViewController.PersonalFlightTripNationTypeEnum.Mainland
    // A 定投 F 特惠
    public var specialString:String = "A"
    var productId:String = ""
    var type:String = ""
    var startCity:String = ""
    var arriveCity:String = ""
    var flightTrip:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = TBIThemeBaseColor
        setBlackTitleAndNavigationColor(title: "")
        setNavigationBackButton(backImage: "left")
        
        firstFlightSVSearchCondition.type = Int(flightTrip)!
        
        setHeaderViewAutolayout()
        setTableView()
       
        setTitleView(start:startCity, arrive:arriveCity )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func backButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    // 更改headerView的视图样式
    // 日期样式
    func setHeaderViewAutolayout() {
        
        weak var weakSelf = self
        self.view.addSubview(flightListHeaderDateView)
        flightListHeaderDateView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(flightDateHeaderHeight)
        }
        flightListHeaderDateView.headerDateShowType = .PersonalFlight
        flightListHeaderDateView.headerDateType = FlightListHeaderDateView.ListHeaderDateType.DateDiscontinuous
//        flightListHeaderDateView.fillDataSources(date: startDate)
        flightListHeaderDateView.flightListHeaderDateViewSelectedDateBlock = { selectedDate in
           // weakSelf?.flightListHeaderDateViewSelectedDateModifySearchCondition(selectedDate: selectedDate)
            //weakSelf?.loadCabinsNET()
            weakSelf?.filterDateFlight(date: selectedDate)
            
        }
        
    }
    func filterDateFlight(date:NSInteger) {
        let selectedDate:Date = Date.init(timeIntervalSince1970: TimeInterval(date))
        let dateStr:String = selectedDate.string(custom: "yyyy-MM-dd")
//        returnFlightList(key: dateStr)
//        listTableView.reloadData()
        getPersonalSpecialFlightInfo(takeOffDate: dateStr)
        
        
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
extension PSepcialFlightListViewController:UITableViewDataSource,UITableViewDelegate {
    
    func setTableView() {
        listTableView.frame = self.view.frame
        listTableView.dataSource = self
        listTableView.delegate = self
        listTableView.register(UINib(nibName: "TableNoDateView", bundle: nil), forHeaderFooterViewReuseIdentifier: "TableNoDateView")
        listTableView.register(PersonalFlightListCell.classForCoder(), forCellReuseIdentifier: self.tablePersonalSepcailViewCellIdentify)
        listTableView.register(FlightSearchListSelectedTripTableViewCell.classForCoder(), forCellReuseIdentifier: tableBusinessSearchViewSelectedTripCellIdentify)
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
            //weakSelf?.loadCabinsNET()
            weakSelf?.getPersonalSpecialFlightInfo()
        }
        listTableView.mj_header.beginRefreshing()
    }
    
 
    
    
    //MARK:- UITableViewDataSources
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return flightInfo.responses.count//flightSVSearchList.count
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if flightInfo.responses.count == 0  {
            return tableView.frame.height
        }
        
        return 152
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if flightInfo.responses.count == 0  {
            return tableView.frame.height
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if flightInfo.responses.count == 0 {
            if let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableNoDateView") as? TableNoDateView {
                footer.setType(.noPersonal)
                return footer
            }
        }
        return nil
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.tablePersonalSepcailViewCellIdentify) as! PersonalFlightListCell
        cell.fillDataSources(flightInfo: flightInfo.responses[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        PersonalSpecialFlightManager.shareInStance.resetAllFlightInfo()
        let selectedTmpFlightTrip:PersonalSpecialFlightInfoListResponse.BaseFlightAndReturnInfoVo = flightInfo.responses[indexPath.row]
        selectedTmpFlightTrip.flightNation = nationString.rawValue.description
        //selectedTmpFlightTrip.tripType = selectedTmpFlightTrip.flightTripType
        if flightTrip != "0"{
            let returnVC: PSepcialFlightReturnViewController = PSepcialFlightReturnViewController()
            PersonalSpecialFlightManager.shareInStance.selectedFlightTripInfoStore(flightTripArr: [selectedTmpFlightTrip])
            returnVC.arriveCity = arriveCity
            returnVC.startCity = startCity
            self.navigationController?.pushViewController(returnVC, animated: true)
        }else{
             PersonalSpecialFlightManager.shareInStance.selectedFlightTripInfoStore(flightTripArr: [selectedTmpFlightTrip])
            let selectVC:PSpecailFlightSelectCabinsViewController = PSpecailFlightSelectCabinsViewController()
            selectVC.startCity = startCity
            selectVC.arriveCity = arriveCity
            selectVC.tripType = 0
            
            self.navigationController?.pushViewController(selectVC, animated: true)
        }
        
        
    }
    
    //MARk:---------NET---------
    func getPersonalSpecialFlightInfo(takeOffDate:String = "") {
        let takeOffDate:String = takeOffDate
        showLoadingView()
        weak var weakSelf = self
        let request:[String:Any] = ["productId":productId,"takeOffDate":takeOffDate]
        PersonalFlightServices.sharedInstance
            .personalSpecialFlightInfoList(request: request)
            .subscribe{ event in
                    weakSelf?.hideLoadingView()
                    weakSelf?.listTableView.mj_header.endRefreshing()
                    switch event {
                    case .next(let element):
                        printDebugLog(message: element.mj_keyValues())
                        weakSelf?.deaprtureDatesArray = element.deaprtureDates
                        weakSelf?.flightInfo = element
//                        if weakSelf?.deaprtureDatesArray.count != 0{
//                            ///默认显示第一个日期的航班
//                            weakSelf?.returnFlightList(key:(weakSelf?.deaprtureDatesArray[0])!)
//                        }
                        if element.deaprtureDates.isEmpty == false {
                            weakSelf?.flightListHeaderDateView.fillDataSourcesDiscontinuanceDate(showDate: element.deaprtureDates, selectedDate: element.deaprtureDates.first!)
                        }
                        
                        weakSelf?.listTableView.reloadData()
                    case .error(let error):
                        weakSelf?.hideLoadingView()
                        try? weakSelf?.validateHttp(error)
                    case .completed:
                        break
                        
                    }
        }
    }
    
    func returnFlightList(key:String)
    {
        printDebugLog(message: flightModel.responsesList[key])
        
        flightSVSearchList = (flightModel.responsesList[key]?.arrayValue.map{PSepcailFlightCabinModel.ResponsesListVo.init(jsonData: $0)!})!
        printDebugLog(message: flightSVSearchList)
       
    }
}
