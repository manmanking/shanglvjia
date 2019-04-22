//
//  HotelSearchViewController.swift
//  shop
//
//  Created by manman on 2017/4/19.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import MJExtension
import RxSwift


class HotelSearchViewController: CompanyBaseViewController,UITableViewDelegate,UITableViewDataSource{
    
    private let hotelSearchTableViewCellIdentify = "hotelSearchTableViewCellIdentify"
    private let hotelSearchTableViewHeaderIdentify = "hotelSvarchTableViewHeaderIdentify"
    
    private var tableView = UITableView()
    //查询条件
    private var searchCondtion = HotelSearchForm()
    // 
    private let bag = DisposeBag()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setTitle(titleStr: "酒店查询")
        setTitle(titleStr: NSLocalizedString("hotel.search.home.title", comment: "酒店查询"))
        setNavigationBackButton(backImage: "")
        self.view.backgroundColor = TBIThemeBaseColor
        setUIViewAutolayout()
        
        if UserDefaults.standard.object(forKey: personalSearchCity) != nil {
            
            let cityInfo:[String] = UserDefaults.standard.object(forKey: personalSearchCity) as! [String]
            searchCondtion.cityName = cityInfo[0]
            searchCondtion.cityId = cityInfo[1]
        }else
        {
            searchCondtion.cityName = ""
            searchCondtion.cityId = ""
        }
        
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
        backgroundImageView.sd_setImage(with: nil, placeholderImage: UIImage.init(named: "HotelSearchBackground"))
        backgroundImageView.contentMode = UIViewContentMode.scaleAspectFill//scaleAspectFit
        tableView.backgroundView = backgroundImageView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: hotelSearchTableViewCellIdentify)
        tableView.register(HotelSearchTableViewHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: hotelSearchTableViewHeaderIdentify)
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: hotelSearchTableViewCellIdentify)
        cell?.textLabel?.text = "index" + indexPath.row.description
        
        
        return cell!
        
    }
    
   
    
    
    //MARK:- UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return configHeaderView(section: section)
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 225 + 30
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if view.isMember(of:HotelSearchTableViewHeaderView.classForCoder()) {
            (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.clear
        }
    }
    
    
    private func configHeaderView(section:Int) ->HotelSearchTableViewHeaderView
    {
        let headerView:HotelSearchTableViewHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: hotelSearchTableViewHeaderIdentify) as! HotelSearchTableViewHeaderView
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
        let companyAccountView = CompanyAccountViewController()
        companyAccountView.title = "企业账号登录"
        self.navigationController?.pushViewController(companyAccountView, animated: true)
//        let loginView = LoginViewController()
//        self.navigationController?.pushViewController(loginView, animated: true)
    }
    
    //MARK: -- 展示 calendar
    func showCalendarView(paramater:Dictionary<String,Any>) {
        //nextViewSpecialCalendar(paramater: paramater)
        nextViewTBICalendar(paramater: paramater)
       
    }
    
    
    //MARK:--- 跳转页面
    func searchHotelAction(parameters:Dictionary<String, Any>)  {
        printDebugLog(message: "searchHotelAction ...  view controller")
        intoNextListView(parameters: parameters)
        
    }
    
    
    func intoNextListView(parameters:Dictionary<String,Any>) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone!
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let hotelListView = HotelListViewController()
        
        if parameters[HotelSearchCityName] != nil {
            hotelListView.searchCondition.cityName = parameters[HotelSearchCityName] as! String
        }
        if parameters[HotelSearchCityId] != nil {
            hotelListView.searchCondition.cityId = parameters[HotelSearchCityId] as! String
        }
        if parameters[HotelSearchCheckinDate] != nil {
            let date =  dateFormatter.date(from: parameters[HotelSearchCheckinDate] as! String)
            hotelListView.searchCondition.arrivalDate = (date?.string(format: .custom("YYYY-MM-dd")))!// parameters[HotelSearchCheckinDate] as! String
        }
        if parameters[HotelSearchCheckoutDate] != nil {
            let date =  dateFormatter.date(from: parameters[HotelSearchCheckoutDate] as! String)
            hotelListView.searchCondition.departureDate = (date?.string(format: .custom("YYYY-MM-dd")))!//parameters[HotelSearchCheckoutDate] as! String
        }
        if parameters[HotelSearchKeyword] != nil {
            hotelListView.searchCondition.keyWord = parameters[HotelSearchKeyword] as? String
        }
        hotelListView.title = hotelListView.searchCondition.cityName
        
        weak var weakself = self
        hotelListView.hotelSearcherAndListSearchConditionAccord = {(parameters) in
            
            weakself?.searchCondtion = parameters
        }
        self.navigationController?.pushViewController(
            hotelListView, animated: true)
    }
    
    func intoNextCompanyView(parameters:Dictionary<String,Any>) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone!
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
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
            hotelCompanyListView.searchCondition.departureDate = (date?.string(format: .custom("YYYY-MM-dd")))!//parameters[HotelSearchCheckoutDate] as! String
        }
        if parameters[HotelSearchKeyword] != nil {
            hotelCompanyListView.searchCondition.keyWord = parameters[HotelSearchKeyword] as? String
        }
        hotelCompanyListView.title = hotelCompanyListView.searchCondition.cityName
        
        weak var weakself = self
        hotelCompanyListView.hotelCompanySearcherAndListSearchConditionAccord = {(parameters) in
            
            weakself?.searchCondtion = parameters
        }
        
        
        self.navigationController?.pushViewController(
            hotelCompanyListView, animated: true)
        
        
        
    }
    
    
    
    
    
    
    override func backButtonAction(sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    
    // MARK:-  TBINewCalendar 
    
    
    func nextViewSpecialCalendar (paramater:Dictionary<String, Any>) {
        let viewController = TBISpecailCalendarViewController()
        viewController.selectedDates = [paramater[HotelSearchCheckinDate] as! String,paramater[HotelSearchCheckoutDate] as! String]
        viewController.isMultipleTap = true 
        viewController.showDateTitle = ["入住","离店"]
        

        weak var weakSelf = self
        viewController.hotelSelectedDateAcomplishBlock = { (parameters) in
            weakSelf?.searchCondtion.arrivalDate = parameters[0]
            weakSelf?.searchCondtion.departureDate = parameters[1]
            weakSelf?.tableView.reloadData()
        }
         _ = self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func nextViewTBICalendar(paramater:Dictionary<String, Any>)  {
        let calendarView = TBICalendarViewController()
        calendarView.calendarAlertType = TBICalendarAlertType.Hotel
        calendarView.calendarTypeAlert = ["请选择入住日期","请选择离店日期"]
        calendarView.selectedDates = [paramater[HotelSearchCheckinDate] as! String,paramater[HotelSearchCheckoutDate] as! String]
        calendarView.isMultipleTap = true
        calendarView.showDateTitle = ["入住","离店"]
        weak var weakSelf = self
        calendarView.hotelSelectedDateAcomplishBlock = { (parameters,action) in
            if action == TBICalendarAction.Back {
                return
            }
            weakSelf?.searchCondtion.arrivalDate = (parameters?[0])!
            weakSelf?.searchCondtion.departureDate = (parameters?[1])!
            weakSelf?.tableView.reloadData()
        }
        
        
        self.navigationController?.pushViewController(calendarView, animated: true)
    }
    //MARK:--- 测试
    func testMethod() {
        let calendarView = TBICalendarViewController()
        calendarView.selectedDates = ["2017-07-14 16:00:00","2017-07-15 16:00:00"]
        self.navigationController?.pushViewController(calendarView, animated: true)
    }
    
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
            UserDefaults.standard.set(tmpCityInfo, forKey: personalSearchCity)
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
