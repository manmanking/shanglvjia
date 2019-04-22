//
//  HotelSearchViewController.swift
//  shop
//
//  Created by manman on 2017/4/19.
//  Copyright © 2017年 zhangwangwang. All rights reserved.
//

import UIKit
import MJExtension
import RxSwift

class HotelCompanySearchViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource{
    public  var travelNo:String = ""
    private let hotelCompanySearchTableViewCellIdentify = "hotelCompanySearchTableViewCellIdentify"
    private let hotelCompanySearchTableViewHeaderIdentify = "hotelCompanySearchTableViewHeaderIdentify"
    private let hotelCompanySearchTableViewHeaderIdentifySecond = "hotelCompanySearchTableViewHeaderIdentifySecond"
    
    private var tableView = UITableView()
    
    private var searchCondtion = HotelSearchForm()
    
    private let userInfo = UserService.sharedInstance.userDetail()
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle(titleStr: "酒店查询")
        setNavigationBackButton(backImage: "")
        self.view.backgroundColor = TBIThemeBaseColor
        setUIViewAutolayout()
//        if UserDefaults.standard.object(forKey: companySearchCity) != nil {
//
//            let cityInfo:[String] = UserDefaults.standard.object(forKey: companySearchCity) as! [String]
//            searchCondtion.cityName = cityInfo[0]
//            searchCondtion.cityId = cityInfo[1]
//        }else
//        {
//            searchCondtion.cityName = ""
//            searchCondtion.cityId = ""
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- 定制视图
    
    func setUIViewAutolayout() {
        
        let backgroundImageView = UIImageView()
        backgroundImageView.backgroundColor = UIColor.red
        backgroundImageView.sd_setImage(with: nil, placeholderImage: UIImage.init(named: "HotelCompanySearchBackgroundVersion3"))
        backgroundImageView.contentMode = UIViewContentMode.scaleAspectFill//scaleAspectFit
        tableView.backgroundView = backgroundImageView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: hotelCompanySearchTableViewCellIdentify)
        // 两种 样式 HeaderView
        tableView.register(HotelCompanySearchTableViewHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: hotelCompanySearchTableViewHeaderIdentify)
        tableView.register(HotelSearchTableViewHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier:hotelCompanySearchTableViewHeaderIdentifySecond)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        
    }
    

    //MARK:- UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: hotelCompanySearchTableViewCellIdentify)
        cell?.textLabel?.text = "index" + indexPath.row.description
        return cell!
        
    }
    
   
    
    
    //MARK:- UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        if userInfo?.companyUser?.corpCode == Toyota  {
            return searchFTMSHeaderView()
        }else
        {
            return searchOrdinaryHeaderView()
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if userInfo?.companyUser?.corpCode == Toyota
        {
            return 283 + 30
        }else
        {
           return 225 + 30 
        }
    }
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if view.isMember(of:HotelCompanySearchTableViewHeaderView.classForCoder()) {
            (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.clear
        }
        if view.isMember(of:HotelSearchTableViewHeaderView.classForCoder()) {
            (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.clear
        }
    }
    
    
    private func searchFTMSHeaderView()->HotelCompanySearchTableViewHeaderView
    {
        let headerView:HotelCompanySearchTableViewHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: hotelCompanySearchTableViewHeaderIdentify) as! HotelCompanySearchTableViewHeaderView
        headerView.backgroundColor = UIColor.green
        weak var weakSelf = self
        headerView.hotelCompanyCheckinDateBlock = {(paramater )in
            weakSelf?.showCalendarView(paramater: paramater)
        }
        headerView.hotelCompanySearchCityBlock = {(parameter)in
            weakSelf?.showCityView(parameter: parameter)
        }
        headerView.hotelCompanySubsidiarySearchBlock = { (parameter ) in
            weakSelf?.choiceSubsidiaryAction(parameter: parameter)
        }
        headerView.hotelCompanySearchCompleteBlock =  {(parameters) in
            weakSelf?.searchHotelAction(parameters: parameters)
        }
        
        //headerView.fillSearchDataSources(hotelSearchItem: searchCondtion)
//        self.tableView.reloadData()
        return headerView
        
    }
    
    private func searchOrdinaryHeaderView()->HotelSearchTableViewHeaderView
    {
        let headerView:HotelSearchTableViewHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: hotelCompanySearchTableViewHeaderIdentifySecond) as! HotelSearchTableViewHeaderView
        headerView.backgroundColor = UIColor.green
        weak var weakSelf = self
        headerView.hotelCheckinDateBlock = {(paramater )in
            weakSelf?.showCalendarView(paramater: paramater)
        }
        headerView.hotelSearchCityBlock = {(parameter)in
            weakSelf?.showCityView(parameter: parameter)
        }
        headerView.hotelSearchCompleteBlock =  {(parameters) in
            weakSelf?.searchHotelAction(parameters: parameters)
        }
        headerView.fillSearchDataSources(hotelSearchItem: searchCondtion)
        return headerView
    }
    
    
    
    
    
    //MARK:- Action
    
    
    func logoutButtonAction(sender:UIButton) {
        
        printDebugLog(message: "logoutButtonAction ...")
        
        let loginView = LoginViewController()
        self.navigationController?.pushViewController(loginView, animated: true)
        
        
    }
    
    //MARK: -- 展示 calendar
    func showCalendarView(paramater:Dictionary<String,Any>) {
        //nextViewSpecialCalendar(paramater: paramater)
        nextViewTBICalendar(paramater: paramater)
       
    }
    
    
    
    func searchHotelAction(parameters:Dictionary<String, Any>)  {
        printDebugLog(message: "searchHotelAction ...  view controller")
        NSLog("search hotel condtion %@", parameters)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone!
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateFormatterString = DateFormatter()
        //dateFormatterString.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone!
        dateFormatterString.dateFormat = "yyyy-MM-dd"
        let hotelCompanyListView = HotelCompanyListViewController()
        
        if parameters[HotelSearchCityName] != nil {
        hotelCompanyListView.searchCondition.cityName = parameters[HotelSearchCityName] as! String
        }
        if parameters[HotelSearchCityId] != nil {
            hotelCompanyListView.searchCondition.cityId = parameters[HotelSearchCityId] as! String
        }
        if parameters[HotelSearchCheckinDate] != nil {
            let date =  dateFormatter.date(from: parameters[HotelSearchCheckinDate] as! String)
            hotelCompanyListView.searchCondition.arrivalDate = (date?.string(format: .custom("YYYY-MM-dd")))!// parameters[HotelSearchCheckinDate] as! String
        }
        if parameters[HotelSearchCheckoutDate] != nil {
            let date =  dateFormatter.date(from: parameters[HotelSearchCheckoutDate] as! String)
            hotelCompanyListView.searchCondition.departureDate = dateFormatterString.string(from: date!)//(date?.string(format: .custom("YYYY-MM-dd")))!//parameters[HotelSearchCheckoutDate] as! String
        }
        if parameters[HotelSearchKeyword] != nil {
            hotelCompanyListView.searchCondition.keyWord = parameters[HotelSearchKeyword] as? String
        }
        
        hotelCompanyListView.title = hotelCompanyListView.searchCondition.cityName
        
        if  (searchCondtion.subsidiary.branchName.isEmpty) {
            hotelCompanyListView.searchCondition.subsidiary = searchCondtion.subsidiary
        }
        
        
        
        
        weak var weakself = self
        hotelCompanyListView.travelNo = self.travelNo
        hotelCompanyListView.hotelCompanySearcherAndListSearchConditionAccord = {(parameters) in
            weakself?.searchCondtion = parameters
        }
        self.navigationController?.pushViewController(hotelCompanyListView, animated: true)
    }
    override func backButtonAction(sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    
    // MARK:-  TBINewCalendar 
    
    
    func nextViewSpecialCalendar (paramater:Dictionary<String, Any>) {
        let viewController = TBISpecailCalendarViewController()
        
        viewController.selectedDates = [paramater[HotelCompanySearchCheckinDate] as! String,paramater[HotelCompanySearchCheckoutDate] as! String]
        viewController.isMultipleTap = true
        viewController.showDateTitle = ["入住","离店"]
        weak var weakSelf = self
        viewController.hotelSelectedDateAcomplishBlock = { (parameters) in
            let formatter = DateFormatter()
            print("listView",parameters)
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            weakSelf?.searchCondtion.arrivalDate = parameters[0]
            weakSelf?.searchCondtion.departureDate = parameters[1]
            weakSelf?.tableView.reloadData()
        }
         _ = self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //MARK:- TBINEWCalendar Action
    
    
    
    func nextViewTBICalendar(paramater:Dictionary<String, Any>) {
        let calendarView = TBICalendarViewController()
        calendarView.calendarAlertType = TBICalendarAlertType.Hotel
        calendarView.calendarTypeAlert = ["请选择入住日期","请选择离店日期"]
        calendarView.selectedDates = [paramater[HotelCompanySearchCheckinDate] as! String,paramater[HotelCompanySearchCheckoutDate] as! String]
        calendarView.isMultipleTap = true
        calendarView.showDateTitle = ["入住","离店"]
        weak var weakSelf = self
        calendarView.hotelSelectedDateAcomplishBlock = { (parameters,action) in
            guard action == TBICalendarAction.Done else {
                return
            }
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            weakSelf?.searchCondtion.arrivalDate = (parameters?[0])!
            weakSelf?.searchCondtion.departureDate = (parameters?[1])!
            weakSelf?.tableView.reloadData()
        }
        
        
        self.navigationController?.pushViewController(calendarView, animated: true)
    }
    
    
    
    
    
    // MARK:-  FSCalendar
//    func nextViewCalendar(paramater:Dictionary<String,Any>)  {
//        let calendarView = TBICalendarViewController()
//        weak var weakSelf = self
//        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        let checkinDateString:String = paramater[HotelSearchCheckinDate] as! String
//        let checkoutDateString:String = paramater[HotelSearchCheckoutDate] as! String
//        if checkinDateString.isEmpty == false {
//            calendarView.selectedFirstIndex = dateFormatter.date(from: checkinDateString)!
//        }
//        
//        if checkoutDateString.isEmpty == false {
//            calendarView.selectedSecondIndex = dateFormatter.date(from: checkoutDateString)!
//        }
//        
//        
//        
//        
//        calendarView.hotelSearchCalendarBlock = {(paramater:Array<Any>) in
//            
//            weakSelf?.hotelSearchCalendarAction(parameters: paramater)
//            
//            
//        }
//        self.navigationController?.pushViewController(calendarView, animated: true)
//        
//    }
    
    
    //MARK:-- Calendar Action
    
    func hotelSearchCalendarAction(parameters:Array<Any>) -> Void {
        
        print("into hotel search ",parameters)
        let checkinDate:Date = parameters[0] as! Date
        let checkoutDate:Date = parameters[1] as! Date
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let checkinString = formatter.string(from: checkinDate)
        let checkoutString = formatter.string(from: checkoutDate)
        
        
        
        searchCondtion.arrivalDate = checkinString
        searchCondtion.departureDate = checkoutString
        self.tableView.reloadData()
        
    }
    
    //MARK: ----城市列表
    func showCityView(parameter:String) {
        weak var weakSelf = self
        let citySelectorViewController = CitySelectorViewController()
        citySelectorViewController.citySelectorBlock = { (cityName,cityCode) in
            print(cityName)
            weakSelf?.searchCondtion.cityId = cityCode
            weakSelf?.searchCondtion.cityName = cityName
            let tmpCityInfo:[String] = [cityName,cityCode]
            UserDefaults.standard.set(tmpCityInfo, forKey: companySearchCity)
            weakSelf?.tableView.reloadData()
            
        }
        citySelectorViewController.setCityType(type: .hotelCity)
        //citySelectorViewController.cityType = true//BusinessType == true ? true : false
        CityService.sharedInstance.getGroups(.hotelCity).subscribe{ event in
            if case .next(let e) = event {
                citySelectorViewController.city = e
                weakSelf?.navigationController?.pushViewController(citySelectorViewController, animated: true)
            }
            }.addDisposableTo(self.bag)
        
        
        /*
         
         weak var weakSelf = self
         let citySelectorViewController = CitySelectorViewController()
         citySelectorViewController.citySelectorBlock = { (cityName,cityCode) in
         print(cityName)
         weakSelf?.searchCondtion.cityId = cityCode
         weakSelf?.searchCondtion.cityName = cityName
         weakSelf?.tableView.reloadData()
         
         }
         citySelectorViewController.cityType = true
         CityService.sharedInstance
         .getGroups(.hotelCity)
         .subscribe{ event in
         if case .next(let e) = event {
         citySelectorViewController.city = e
         weakSelf?.navigationController?.pushViewController(citySelectorViewController, animated: true)
         }
         }.addDisposableTo(self.bag)
         */
        
        
    }
    
    
    
    
    
    //选择分公司
    func choiceSubsidiaryAction(parameter:Dictionary<String , Any>) {
        
        weak var weakSelf = self
        let subsidiaryView = HotelGroupSubsidiarySearchViewController()
        if searchCondtion.cityName.isEmpty == false {
            subsidiaryView.subsidiaryCity = searchCondtion.cityName
        }
        subsidiaryView.hotelGroupSubsidiarySearchBlock = { (parameter) in
            //weakSelf?.searchCondtion.subsidiary = parameter
            weakSelf?.tableView.reloadData()
        }
        
        
        self.navigationController?.pushViewController(subsidiaryView, animated: true)
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
