//
//  POnsaleFlightListViewController.swift
//  shanglvjia
//
//  Created by tbi on 2018/8/8.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import MJRefresh
import RxSwift

class POnsaleFlightListViewController: PersonalBaseViewController {

    /// 0 国内 1 国际
    public var nationString:PSpecialOfferFlightViewController.PersonalFlightTripNationTypeEnum = PSpecialOfferFlightViewController.PersonalFlightTripNationTypeEnum.Mainland
    
    /// 产品ID
    public var productId:String = ""
    
    /// A 定投 F 特惠
    public var specialString:String = "A"
    
    public var flightTrip:String = ""
    
    public var personalOnsaleFlightListViewType:AppModelCatoryENUM = AppModelCatoryENUM.PersonalOnsaleFlight
    
    private let flightDateHeaderHeight:CGFloat = 55
    let bag = DisposeBag()
    fileprivate let flightListHeaderDateView:FlightListHeaderDateView = FlightListHeaderDateView()
    fileprivate var firstFlightSVSearchCondition:FlightSVSearchConditionModel = FlightSVSearchConditionModel()
    
    fileprivate var flightTripCityTitleView:FlightTripCityTitleView = FlightTripCityTitleView()
    
    
    
    fileprivate let listTableView = UITableView()
    fileprivate let tablePersonalSepcailViewCellIdentify = "PersonalFlightListCell"
    fileprivate let tableBusinessSearchViewSelectedTripCellIdentify = "tableBusinessSearchViewSelectedTripCellIdentify"
    
    
    
    
    
    ///国内国际
    var type:String = ""
    var startCity:String = ""
    var arriveCity:String = ""
    
    
    fileprivate var flightTime:String = ""
    
    ///数据源
    fileprivate var flightSVSearchList:[PCommonFlightSVSearchModel.AirfareVO] = Array()
    fileprivate var flightModel = PCommonFlightSVSearchModel()
   
    
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
        flightListHeaderDateView.headerDateType = FlightListHeaderDateView.ListHeaderDateType.DateContinuance
        flightListHeaderDateView.flightListHeaderDateViewSelectedDateBlock = { selectedDate in
            weakSelf?.flightListHeaderDateViewSelectedDateModifySearchCondition(selectedDate: selectedDate)
            weakSelf?.loadOnsaleFlightListNET()
            
        }
        
    }
    func flightListHeaderDateViewSelectedDateModifySearchCondition(selectedDate:NSInteger) {
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone.local
        //formatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone?
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let departureDate:Date = Date.init(timeIntervalSince1970: TimeInterval(selectedDate))
        flightTime = formatter.string(from: departureDate)
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
extension POnsaleFlightListViewController:UITableViewDataSource,UITableViewDelegate {
    
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
            weakSelf?.loadOnsaleFlightListNET()
        }
        listTableView.mj_header.beginRefreshing()
    }
    //MARK:- UITableViewDataSources
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return flightSVSearchList.count
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if flightSVSearchList.count == 0  {
            return tableView.frame.height
        }
        
        return 152
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if flightSVSearchList.count == 0  {
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.tablePersonalSepcailViewCellIdentify) as! PersonalFlightListCell
        cell.fillOnsaleDataSources(airfare:flightSVSearchList[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ///如果国际往返
        if nationString == .International && flightTrip == "1"{
            //重置已选航班信息
            PCommonFlightManager.shareInStance.resetAllFlightInfo()
            PersonalOnsaleFlightManager.shareInStance.resetAllFlightInfo()
            
            let returnVC: POnsaleFlightReturnViewController = POnsaleFlightReturnViewController()
            ///添加选择航班
            let selectedTmpFlightTrip:PCommonFlightSVSearchModel.AirfareVO = flightSVSearchList[indexPath.row]
            selectedTmpFlightTrip.productId = productId
            selectedTmpFlightTrip.flightNation = nationString.rawValue.description
            selectedTmpFlightTrip.flightTripType = flightTrip
            PersonalOnsaleFlightManager.shareInStance.addSelectedFlightTrip(searchCondition: selectedTmpFlightTrip, tripSection: 1)
            returnVC.nationString = nationString.rawValue.description
            returnVC.specialString = specialString
            returnVC.arriveCity = arriveCity
            returnVC.startCity = startCity
            returnVC.productId = productId
            //returnVC.type = nationString
            returnVC.interCacheid = flightModel.interCacheId
            self.navigationController?.pushViewController(returnVC, animated: true)

        }else{
        ///国内单程\往返\国际单程
            let selectedTmpFlightTrip:PCommonFlightSVSearchModel.AirfareVO = flightSVSearchList[indexPath.row]
            selectedTmpFlightTrip.productId = productId
            selectedTmpFlightTrip.flightNation = nationString.rawValue.description
            selectedTmpFlightTrip.flightTripType = flightTrip
            //重置已选航班信息
            PersonalOnsaleFlightManager.shareInStance.resetAllFlightInfo()
            PersonalOnsaleFlightManager.shareInStance.addSelectedFlightTrip(searchCondition: selectedTmpFlightTrip, tripSection:1)
            let selectVC:POnsaleFlightSelectCabinController = POnsaleFlightSelectCabinController()
            selectVC.startCity = startCity
            selectVC.arriveCity = arriveCity
            selectVC.tripType = NSInteger(flightTrip)!
            //selectVC.nationType = type
            selectVC.productId = productId
            selectVC.nationString = nationString.rawValue.description
            selectVC.specialString = specialString
            ///添加选择航班
            self.navigationController?.pushViewController(selectVC, animated: true)
        }
        
    }
  
    //MARK:-------NET-------
    
    func loadOnsaleFlightListNET(){
        
        showLoadingView()
        weak var weakSelf = self
        ///tripOption:=====国内传0(单程，去程)/1（　返程），国际传0(单程，去程)/2（返程）
        ///destinationDate:刚进来第一次传空，国内传空，国际往返传
        var tripOption : String = flightTrip == "0" ? "0" : "2"
        let request:[String:Any] = ["type":nationString.rawValue,"productId":productId,"departureDate":flightTime,"tripOption":tripOption,"destinationDate":""]
        PersonalFlightServices.sharedInstance
            .onsalePersonalFlightCabinList(request: request)
            .subscribe{ event in
                weakSelf?.hideLoadingView()
                 weakSelf?.listTableView.mj_header.endRefreshing()
               
                switch event {
                case .next(let element):
                    printDebugLog(message: element.mj_keyValues())
                    
                    weakSelf?.flightListHeaderDateView.fillDataSourcesContinuanceDate(fromDate: element.departureDateFrom, toDate: element.departureDateFromTo, selectedDate: element.departureDateFrom)
                    
                    weakSelf?.flightSVSearchList.removeAll()
                    weakSelf?.flightSVSearchList = element.airfares
                    weakSelf?.flightModel = element
                    weakSelf?.listTableView.reloadData()
                case .error(let error):
                    weakSelf?.hideLoadingView()
                    try? weakSelf?.validateHttp(error)
                case .completed:
                    break
                    
                }
        }.addDisposableTo(self.bag)
    }
    
   
}
