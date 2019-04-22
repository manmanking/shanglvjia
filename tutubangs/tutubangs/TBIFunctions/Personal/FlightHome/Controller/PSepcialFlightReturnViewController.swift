//
//  PSepcialFlightReturnViewController.swift
//  shanglvjia
//
//  Created by tbi on 2018/8/7.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PSepcialFlightReturnViewController: PersonalBaseViewController {

    private let flightDateHeaderHeight:CGFloat = 55
    
    fileprivate let flightListHeaderDateView:FlightListHeaderDateView = FlightListHeaderDateView()
    fileprivate var firstFlightSVSearchCondition:FlightSVSearchConditionModel = FlightSVSearchConditionModel()
    
    fileprivate var flightTripCityTitleView:FlightTripCityTitleView = FlightTripCityTitleView()
    
    public var personalOnsaleFlightListViewType:AppModelCatoryENUM = AppModelCatoryENUM.PersonalSpecialHotel
    
    fileprivate let listTableView = UITableView()
    fileprivate let tablePersonalSepcailViewCellIdentify = "PersonalFlightListCell"
    fileprivate let tableBusinessSearchViewSelectedTripCellIdentify = "tableBusinessSearchViewSelectedTripCellIdentify"
    fileprivate var flightInfo = PersonalSpecialFlightInfoListResponse()
    fileprivate var deaprtureDatesArray:[String] = Array()
    private var showDate:String = ""
    
    var startCity:String = ""
    var arriveCity:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = TBIThemeBaseColor
        setBlackTitleAndNavigationColor(title: "")
        setNavigationBackButton(backImage: "left")
        
        setHeaderViewAutolayout()
        setTableView()
        
        firstFlightSVSearchCondition.type = 1
        firstFlightSVSearchCondition.currentTripSection = 2
        setTitleView(start:arriveCity, arrive:startCity)
        getPersonalSpecialReturnFlightInfo(takeOffDate: showDate)
        
    }
    // 日期样式
    func setHeaderViewAutolayout() {
        
        weak var weakSelf = self
        self.view.addSubview(flightListHeaderDateView)
        flightListHeaderDateView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(flightDateHeaderHeight)
        }
        
        deaprtureDatesArray = PersonalSpecialFlightManager.shareInStance.selectedFlightTripInfoDraw().first?.returnDateList ?? Array()
        
        flightListHeaderDateView.headerDateShowType = .PersonalFlight
        flightListHeaderDateView.headerDateType = FlightListHeaderDateView.ListHeaderDateType.DateDiscontinuous
        showDate = deaprtureDatesArray.first ?? ""//PersonalSpecialFlightManager.shareInStance.selectedFlightTripInfoDraw().first?.returnDateList.first ?? "2018-08-08"
        
        flightListHeaderDateView.fillDataSourcesDiscontinuanceDate(showDate: deaprtureDatesArray, selectedDate:showDate )
        flightListHeaderDateView.headerDateType = FlightListHeaderDateView.ListHeaderDateType.DateDiscontinuous
        flightListHeaderDateView.flightListHeaderDateViewSelectedDateBlock = { selectedDate in
            weakSelf?.filterDateFlight(date: selectedDate)
        }
        
    }
    
    func filterDateFlight(date:NSInteger) {
        let selectedDate:Date = Date.init(timeIntervalSince1970: TimeInterval(date))
        let dateStr:String = selectedDate.string(custom: "yyyy-MM-dd")
        getPersonalSpecialReturnFlightInfo(takeOffDate: dateStr)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    //MARK:---------NET------
    func getPersonalSpecialReturnFlightInfo(takeOffDate:String = "") {
        let takeOffDate:String = takeOffDate
        let flightCacheId:String = PersonalSpecialFlightManager.shareInStance.selectedFlightTripInfoDraw().first?.flightCacheId ?? ""
        let productId:String = PersonalSpecialFlightManager.shareInStance.selectedFlightTripInfoDraw().first?.id ?? ""
        showLoadingView()
        weak var weakSelf = self
        let request:[String:Any] = ["flightCacheId":flightCacheId,"productId":productId,"takeOffDate":takeOffDate]
        PersonalFlightServices.sharedInstance
            .personalSpecialReturnFlightInfoList(request: request)
            .subscribe{ event in
                weakSelf?.hideLoadingView()
                switch event {
                case .next(let element):
                    printDebugLog(message: element.mj_keyValues())
                    //weakSelf?.deaprtureDatesArray = element.deaprtureDates
                    weakSelf?.flightInfo = element
                    //                        if weakSelf?.deaprtureDatesArray.count != 0{
                    //                            ///默认显示第一个日期的航班
                    //                            weakSelf?.returnFlightList(key:(weakSelf?.deaprtureDatesArray[0])!)
                    //                        }
//                    if element.deaprtureDates.isEmpty == false {
//                        weakSelf?.flightListHeaderDateView.fillDataSourcesDiscontinuanceDate(showDate: element.deaprtureDates, selectedDate: element.deaprtureDates.first!)
//                    }
                    
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
extension PSepcialFlightReturnViewController:UITableViewDataSource,UITableViewDelegate {
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
    }
    //MARK:- UITableViewDataSources
    func numberOfSections(in tableView: UITableView) -> Int {
        if PersonalSpecialFlightManager.shareInStance.selectedFlightTripInfoDraw().count > 0 {
            return 2
        }
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 && PersonalSpecialFlightManager.shareInStance.selectedFlightTripInfoDraw().count > 0  {
            return PersonalSpecialFlightManager.shareInStance.selectedFlightTripInfoDraw().count
        }
        return 1
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && PersonalSpecialFlightManager.shareInStance.selectedFlightTripInfoDraw().count  > 0 {
            return 41
        }
        return 152
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 && PersonalSpecialFlightManager.shareInStance.selectedFlightTripInfoDraw().count > 0 {
            
            let cell:PersonalFlightSearchListSelectedTripCell = tableView.dequeueReusableCell(withIdentifier: tableBusinessSearchViewSelectedTripCellIdentify) as! PersonalFlightSearchListSelectedTripCell
            cell.fillDataSources(flightInfo:PersonalSpecialFlightManager.shareInStance.selectedFlightTripInfoDraw()[indexPath.row] , type: firstFlightSVSearchCondition.type, currentTrip:indexPath.row + 1)
            cell.currentSectionTripAirportLabel.text = startCity + "-" + arriveCity

            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.tablePersonalSepcailViewCellIdentify) as! PersonalFlightListCell
        //cell.fillDataSourcesReturnTrip(airfare:PersonalSpecialFlightManager.shareInStance.selectedFlightTripDraw().first!)
        if flightInfo.responses.isEmpty == false {
            cell.fillDataSourcesSpecialReturnFlightInfo(airfare: flightInfo.responses[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectVC:PSpecailFlightSelectCabinsViewController = PSpecailFlightSelectCabinsViewController()
        selectVC.startCity = startCity
        selectVC.arriveCity = arriveCity
        selectVC.tripType = 1
        let selectedFirstFlightTrip:PersonalSpecialFlightInfoListResponse.BaseFlightAndReturnInfoVo = PersonalSpecialFlightManager.shareInStance.selectedFlightTripInfoDraw().first!
        let selectedSecondFlightTrip = flightInfo.responses[indexPath.row]
        PersonalSpecialFlightManager.shareInStance.selectedFlightTripInfoStore(flightTripArr: [selectedFirstFlightTrip,selectedSecondFlightTrip])
        
        self.navigationController?.pushViewController(selectVC, animated: true)
    }
    
    
    
    
    
}
