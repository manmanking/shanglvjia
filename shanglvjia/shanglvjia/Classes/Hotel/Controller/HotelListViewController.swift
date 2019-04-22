//
//  HotelListViewController.swift
//  shop
//
//  Created by manman on 2017/4/20.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import RxSwift
import MJRefresh




// 测试提交
class HotelListViewController:CompanyBaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    
   
    typealias HotelSearcherAndListSearchConditionAccord = (HotelSearchForm)->Void
    
    public var hotelSearcherAndListSearchConditionAccord:HotelSearcherAndListSearchConditionAccord!
    
    public var searchCondition = HotelSearchForm()
    
    private let hotelListTableViewHeaderViewIdentify = "hotelListTableViewHeaderViewIdentify"
    private let hotelListTableViewCellIdentify = "hotelListTableViewCellIdentify"
    private var offsetY:CGFloat = 0
    private var accordTravel:Float = 0
    private var tableView = UITableView()
    private var pageIndex:NSInteger = 1
    private var screenView = TBISortCriteriaView()
    private let priceOrderArr:[String] = ["不限","0-300","301-350","351-800","800以上",""]
    private let starOrderArr:[String] = ["不限","五星","四星","三星","二星","一星"]
    private var  searchResult:[HotelListItem]? = nil
    private var cityRegionDataSource:[(title:String,code:String)] = Array()
    private var regionDataSourcesSelectedIndex:[NSInteger] = Array()
    private var topBackgroundView:UIView = UIView()
    private var topHeaderView:HotelListTableViewHeaderView = HotelListTableViewHeaderView(reuseIdentifier: "HotelListTableViewHeaderViewIdentify")
    private let bag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setTitle(titleStr: self.title!)
        setNavigationBackButton(backImage: "")
        self.view.backgroundColor = TBIThemeBaseColor
        self.navigationController?.navigationBar.isTranslucent = false
        //self.extendedLayoutIncludesOpaqueBars = false
        setUIViewAutolayout()
        getHotelList()
        regionDataSourcesSelectedIndex.append(0)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:- 定制视图
    
    func setUIViewAutolayout() {
        setTopView()
        weak var weakSelf = self
        tableView.frame = self.view.frame
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = TBIThemeBaseColor
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.register(HotelListTableViewCell.classForCoder(), forCellReuseIdentifier: hotelListTableViewCellIdentify)
        tableView.register(HotelListTableViewHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: hotelListTableViewHeaderViewIdentify)
        tableView.register(UINib(nibName: "TableNoDateView", bundle: nil), forHeaderFooterViewReuseIdentifier: "TableNoDateView")
        
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: { 
            weakSelf?.refreshDataSources()
        })
        tableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: { 
            weakSelf?.loadMoreDataSources()
        })
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(topBackgroundView.snp.bottom)
            make.left.bottom.right.equalToSuperview()
            
        }
        configScreenView()
        
    }
    
    
    func setTopView() {
        self.view.addSubview(topBackgroundView)
        topBackgroundView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(64)
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        weak var weakSelf = self
        
        topBackgroundView.addSubview(topHeaderView)
        topHeaderView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        topHeaderView.hotelListSelctedDateBlock = {(parameter) in
            
            //weakSelf?.nextViewSpecialCalendar(paramater: parameter)
            weakSelf?.nextViewTBICalendar(paramater: parameter)
        }
        
        topHeaderView.hotelListHeaderSearchBlock = { (parameter) in
            
            weakSelf?.getHotelKeywordList(parameters: parameter)
        }
        topHeaderView.hotelListHeaderRegionBlock = { (selectedTitle) in
            
            weakSelf?.getRegionList(city: self.searchCondition.cityId)
            
        }
        topHeaderView.fillDataSources(searchCondition: searchCondition)
    }
    
    //MARK: -- 筛选视图  
    private func configScreenView()
    {
        weak var weakSelf = self
        screenView.priceDataSourcesArr = priceOrderArr
        screenView.starDataSourcesArr = starOrderArr
        self.view.addSubview(screenView)
        screenView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(50)
        }
        screenView.priceScreenBlock = { (parameter) in
            
            weakSelf?.getHotelPriceScreenList(parameter: parameter)
            
        }
        screenView.starScreenBlock = { (parameter) in
            
            weakSelf?.getHotelStarScreenList(parameter: parameter)
            
        }
        screenView.starOrderBlock = { (parameter) in
            
            weakSelf?.getHotelStarOrderList(parameter: parameter)
        }
        
        screenView.priceOrderBlock = { (parameter ) in
            
            weakSelf?.getHotelPriceOrderList(parameter: parameter)
            
        }
    }
    
    
    //MARK:- UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard searchResult != nil else {
            return 0
        }
        return (searchResult?.count)!
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return configCell(cellIndex: indexPath)
    }
    
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 60
//    }
//    
//    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
//    {
//        
//        return configHeaderView(section: section)
//        
//    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let orders =  self.searchResult {
            if orders.count == 0 {
                return tableView.frame.height
            }
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableNoDateView") as? TableNoDateView {
            footer.setType(.noData)
            return footer
        }
        return nil
    }
    
    
    
    //MARK:- UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 95
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.view.endEditing(true)
        printDebugLog(message: "didSelectRow ")
        let hotelDetailView = HotelDetailViewController()
        hotelDetailView.fromWhere = ""
        hotelDetailView.title = searchResult?[indexPath.row].name
        hotelDetailView.hotelDetailForm.arrivalDate = searchCondition.arrivalDate
        hotelDetailView.hotelDetailForm.departureDate = searchCondition.departureDate
        hotelDetailView.searchCondition = searchCondition
        hotelDetailView.accordTravel = 0
        hotelDetailView.hotelDetailForm.hotelId = (searchResult?[indexPath.row].id)!
        self.navigationController?.pushViewController(hotelDetailView, animated: true)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //let height = scrollView.bounds.size.height//size.height
        let contentOffsetY = scrollView.contentOffset.y
        //let bottomOffset = scrollView.contentSize.height - contentOffsetY
        if contentOffsetY > offsetY {
            screenView.isHidden = true
        } else {
            screenView.isHidden = false
        }
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
       offsetY = scrollView.contentOffset.y
    }
    
    
    func configCell(cellIndex:IndexPath) -> HotelListTableViewCell {
        let cell:HotelListTableViewCell = tableView.dequeueReusableCell(withIdentifier: hotelListTableViewCellIdentify) as!HotelListTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        let hotelListItem:HotelListItem = (searchResult?[cellIndex.row])!
        var starRate:NSInteger = 3
        if hotelListItem.starRate != 0 {
            starRate = hotelListItem.starRate
        }else
        {
            starRate = hotelListItem.category
        }
        cell.fillDatasource(hotelImage:hotelListItem.imgUrl , hotelTitle: hotelListItem.name, hotelProtocol: hotelListItem.hotelType, hotelprice: hotelListItem.lowRate.description, hotelStar: starRate, hotelAddress: hotelListItem.address, accordTravel:hotelListItem.accordTravel)
        return cell
    }
    
    func configHeaderView(section:NSInteger)->HotelListTableViewHeaderView {
        let headerView:HotelListTableViewHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: hotelListTableViewHeaderViewIdentify) as! HotelListTableViewHeaderView
        weak var weakSelf = self
        headerView.hotelListSelctedDateBlock = {(parameter) in
            
            //weakSelf?.nextViewSpecialCalendar(paramater: parameter)
            //self.view.endEditing(true)
            //[[UIApplication sharedApplication].keyWindow endEditing:YES];
            UIApplication.shared.keyWindow?.endEditing(true)
            weakSelf?.nextViewTBICalendar(paramater: parameter)
        }
        headerView.hotelListHeaderSearchBlock = { (parameter) in
            weakSelf?.getHotelKeywordList(parameters: parameter)
            
        }
        headerView.hotelListHeaderRegionBlock = { (parameter) in
            weakSelf?.view.endEditing(true)
            weakSelf?.getRegionList(city: self.searchCondition.cityId)
            
        }
        headerView.fillDataSources(searchCondition: searchCondition)
        return headerView
    }
    
    
    
    
    func getRegionList(city:String) {
        
        weak var weakSelf = self
        self.showLoadingView()
        CitysService.sharedInstance
            .getDistrict(cityId:city)
            .subscribe { (event) in
                
                weakSelf?.hideLoadingView()
                weakSelf?.tableView.mj_header.endRefreshing()
                if case .next(let result) = event {
                    print(result)
                    if self.cityRegionDataSource.count > 0
                    {
                        self.cityRegionDataSource.removeAll()
                    }
                    let keysArr = result.keys
                    for (index ,value) in keysArr.enumerated()
                    {
                        self.cityRegionDataSource.append((title:value, code: result[value]!))
                        
                    }
                    print(self.cityRegionDataSource)
                    
                    self.regionScreen()
                }
                if case .error(let result) = event {
                    
                    try? weakSelf?.validateHttp(result)
                    //weakSelf?.showSystemAlertView(titleStr: "提示", message: String(describing: result))
                }
            }.disposed(by: bag)
        
    }
    
    
    
    //MARK:- 行政区域
    func regionScreen() {
        printDebugLog(message: "priceScreenButtonAction  view ...")
        weak var weakSelf = self
        let priceView = HotelCustomScreenView.init(frame: ScreenWindowFrame)
        priceView.hotelCustomScreenType = HotelCustomScreenType.Region
        
        var dataSource:[String] = Array()
        dataSource.append("不限")
        for (index,value) in self.cityRegionDataSource.enumerated() {
            let tmp:String = self.cityRegionDataSource[index].title
            dataSource.append(tmp)
        }
        priceView.datasource = dataSource
        
        if  regionDataSourcesSelectedIndex.count > 0
        {
            priceView.selectedIndexArr = regionDataSourcesSelectedIndex
        }
        
        priceView.hotelCustomScreenDetermineConditionBlock = { (parameter) in
            
            print("选好了",parameter,"accord ")
            
            let index:NSInteger = (parameter["HotelCustomScreenDetermineConditionDetailIndex"]  as! [NSInteger]).first!
            var title:String = ""
            var code:String = ""
            if index != 0 {
                title = (parameter["HotelCustomScreenDetermineConditionDetail"]  as! [String]).first!//
                code = (weakSelf?.cityRegionDataSource[index - 1].code)!
            }
            
            weakSelf?.regionDataSourcesSelectedIndex[0] = index
            
            weakSelf?.searchCondition.districtTitle = title
            
            weakSelf?.searchCondition.districtId = code
            weakSelf?.topHeaderView.fillDataSources(searchCondition: (weakSelf?.searchCondition)!)
            weakSelf?.getHotelList()
            
        }
        
        KeyWindow?.addSubview(priceView)
        
    }
    
    
    
    //MARK:----刷新数据
    
    private func refreshDataSources() {
        
        searchCondition.pageIndex = 1
        
        searchCondition.pageSize = 10
        pageIndex = 1
        showLoadingView()
        weak var weakSelf = self
        HotelService.sharedInstance
            .getList(searchCondition)
            .subscribe { (event) in
                weakSelf?.tableView.mj_header.endRefreshing()
                weakSelf?.hideLoadingView()
                if case .next(let result) = event {
                    
                    if weakSelf?.searchResult != nil && (weakSelf?.searchResult?.count)! > 0
                    {
                        weakSelf?.searchResult?.removeAll()
                    }
                    weakSelf?.searchResult = result
                    weakSelf?.pageIndex += 1
                    weakSelf?.tableView.reloadData()
                }
                if case .error(let result) = event {
                    try? weakSelf?.validateHttp(result)
                   //weakSelf?.showSystemAlertView(titleStr: "提示", message: String(describing: result))
                }
                
            }.disposed(by: bag)
        
        
    }
    
    func loadMoreDataSources() {
        pageIndex += 1
        searchCondition.pageIndex = pageIndex
        showLoadingView()
        weak var weakSelf = self
        HotelService.sharedInstance
            .getList(searchCondition)
            .subscribe { (event) in
                weakSelf?.tableView.mj_footer.endRefreshing()
                
                if case .next(let result) = event {
                    weakSelf?.searchResult = (weakSelf?.searchResult!)! + result
                    weakSelf?.tableView.reloadData()
                    //满足某人的需求，说真的挺傻逼的
                    if result.count <= 5 && self.pageIndex <= 5{
                        self.loadMoreDataSources()
                    }else{
                        weakSelf?.hideLoadingView()
                    }
                }
                if case .error(let result) = event {
                    weakSelf?.hideLoadingView()
                    try? weakSelf?.validateHttp(result)
                    //weakSelf?.showSystemAlertView(titleStr: "提示", message: String(describing: result))
                }
            }.disposed(by: bag)
    }
    
    
    // MARK:--  获得网络数据-  搜索列表
    func getHotelList() {
        print(searchCondition)
        showLoadingView()
        weak var weakSelf = self
        HotelService.sharedInstance
            .getList(searchCondition)
            .subscribe { (event) in
                //weakSelf?.hideLoadingView()
                if case .next(let result) = event {
                    if weakSelf?.searchResult != nil && (weakSelf?.searchResult?.count)! > 0
                    {
                        weakSelf?.searchResult?.removeAll()
                    }
                    weakSelf?.searchResult = result
                    weakSelf?.tableView.reloadData()
                    //满足某人的需求，说真的挺傻逼的
                    if result.count <= 5 && self.pageIndex <= 5{
                        self.loadMoreDataSources()
                    }else{
                        weakSelf?.hideLoadingView()
                    }
                }
                if case .error(let result) = event {
                    weakSelf?.hideLoadingView()
                    try? weakSelf?.validateHttp(result)
                    //weakSelf?.showSystemAlertView(titleStr: "提示", message: String(describing: result))
                }
                
             
            }.disposed(by: bag)
    }
    
    // MARK:- 获得网络数据- 价格筛选列表
    func getHotelPriceScreenList(parameter:Dictionary<String, Any>) {
        
        print("价格筛选列表 ")
        let selectConditionArr:Array<String> = parameter[HotelCustomScreenDetermineConditionDetail] as! Array
        if selectConditionArr.count < 1 {
            getHotelList()
            return
        }
        let priceCondition:String = selectConditionArr[0]
        if priceCondition.characters.count > 2 {
            let priceArr = priceCondition.components(separatedBy: "-")
            searchCondition.lowRate = Int(priceArr[0])
            searchCondition.highRate = Int(priceArr[1])
            searchCondition.pageIndex = 1
            pageIndex = 1
            
            //可以筛选300 -300 的价格 
//            if Int(priceArr[0]) == Int(priceArr[1]) {
//                searchCondition.highRate = 10000
//            }
            screenView.priceScreenButton.isSelected = true
        }else
        {
            searchCondition.lowRate = 0
            searchCondition.highRate = 0
            screenView.priceScreenButton.isSelected = false
        }
        getHotelList()
    }
    
    // MARK:- 获得网络数据- 星级筛选列表
    func getHotelStarScreenList(parameter:Dictionary<String, Any>) {
        
        print("星级排序列表")
        let selectConditionArr:Array<String> = parameter[HotelCustomScreenDetermineConditionDetail] as! Array
        if selectConditionArr.count < 1 {
            getHotelList()
            return
        }
        
        //不限 参数 用 0 代替
        var selectedIndexArr:[String] = Array()
        for index in 0..<selectConditionArr.count
        {
            for subIndex in 0..<starOrderArr.count
            {
                if selectConditionArr[index] == starOrderArr[subIndex]
                {
                    if subIndex == 0 {
                        selectedIndexArr.append("0")
                        continue
                    }
                    selectedIndexArr.append( String(6 - subIndex) )
                }
            }
        }
        let selectedConditionStr = selectedIndexArr.joined(separator: ",")
        if selectedConditionStr != "0"{
            screenView.starScreenButton.isSelected = true
        }else{
            screenView.starScreenButton.isSelected = false
        }
        searchCondition.starRate = selectedConditionStr
        searchCondition.pageIndex = 1
        pageIndex = 1
        getHotelList()
    }
    
    func getHotelStarOrderList(parameter:Dictionary<String,Any>) {
        print("星级排序列表")
        let selectedConditionStr:String = parameter[hotelListStarOrderState] as! String
        
        if selectedConditionStr == "down"
        {
            searchCondition.sort = HotelSearchForm.Sort.starRankDesc.rawValue
        }
        else
        {
            searchCondition.sort = nil
        }
        searchCondition.pageIndex = 1
        pageIndex = 1
        getHotelList()
    }
    
    // MARK:- 获得网络数据- 价格排序列表
    func getHotelPriceOrderList(parameter:Dictionary<String, Any>) {
        
        print("价格排序")
        let rankWard:String = parameter[hotelListPriceOrderState] as! String
        //升序
        if rankWard == "up" {
            print("价格升排序")
            searchCondition.sort  = HotelSearchForm.Sort.rateAsc.rawValue
        }else  if rankWard == "down"// 降序
        {
            print("价格降排序")
            searchCondition.sort  = HotelSearchForm.Sort.rateDesc.rawValue
        }
        else
        {
            searchCondition.sort = nil
        }
        searchCondition.pageIndex = 1
        pageIndex = 1
        getHotelList()
    }
    
    
    // 关键字 搜索
    func getHotelKeywordList(parameters:Dictionary<String,Any>)  {
        let checkinDate:String = parameters["HotelListSelectedCheckinDate"] as! String
        let checkoutDate:String = parameters["HotelListSelectedCheckoutDate"] as! String
        let keyword:String = parameters["HotelListHeaderSearchConditionKeyword"] as! String
        
        searchCondition.arrivalDate = checkinDate
        searchCondition.departureDate = checkoutDate
        searchCondition.keyWord = keyword
        searchCondition.pageIndex = 1
        pageIndex = 1
        getHotelList()
        
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
    
    func nextViewSpecialCalendar (paramater:Dictionary<String, Any>) {
        let viewController = TBISpecailCalendarViewController()
        
        viewController.selectedDates = [paramater[HotelListSelectedCheckinDate] as! String,paramater[HotelListSelectedCheckoutDate] as! String]
        viewController.isMultipleTap = true
        viewController.showDateTitle = ["入住","离店"]
        
        weak var weakSelf = self
        viewController.hotelSelectedDateAcomplishBlock = { (parameters) in
            
            print("listView",parameters)
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone!
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let checkinDate =  dateFormatter.date(from: parameters[0])
            weakSelf?.searchCondition.arrivalDate = (checkinDate?.string(format: .custom("YYYY-MM-dd")))!
            let checkoutDate =  dateFormatter.date(from: parameters[1])
            weakSelf?.searchCondition.departureDate = (checkoutDate?.string(format: .custom("YYYY-MM-dd")))!
            weakSelf?.tableView.reloadData()
            // 日期选择之后要搜索
            weakSelf?.getHotelList()
        }
        _ = self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func nextViewTBICalendar(paramater:Dictionary<String, Any>) {
        let calendarView = TBICalendarViewController()
        calendarView.calendarAlertType = TBICalendarAlertType.Hotel
        calendarView.calendarTypeAlert = ["请选择入住日期","请选择离店日期"]
        calendarView.selectedDates = [paramater[HotelListSelectedCheckinDate] as! String,paramater[HotelListSelectedCheckoutDate] as! String]
        calendarView.isMultipleTap = true
        calendarView.showDateTitle = ["入住","离店"]
        weak var weakSelf = self
        calendarView.hotelSelectedDateAcomplishBlock = { (parameters,action) in
            guard action == TBICalendarAction.Done else {
                return
            }
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone!
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let checkinDate =  dateFormatter.date(from: (parameters?[0])!)
            weakSelf?.searchCondition.arrivalDate = (checkinDate?.string(format: .custom("YYYY-MM-dd")))!
            let checkoutDate =  dateFormatter.date(from: (parameters?[1])!)
            weakSelf?.searchCondition.departureDate = (checkoutDate?.string(format: .custom("YYYY-MM-dd")))!
            weakSelf?.topHeaderView.fillDataSources(searchCondition:(weakSelf?.searchCondition)!)
            // 日期选择之后要搜索
            weakSelf?.getHotelList()
        }
        
        
        self.navigationController?.pushViewController(calendarView, animated: true)
    }
    
    
    
    
    
    
    override func backButtonAction(sender: UIButton) {
//        if (self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 2].isKind(of: HomeViewController.classForCoder()))! {
//            _ = self.navigationController?.popViewController(animated: true)
//            return
//        }
        if self.hotelSearcherAndListSearchConditionAccord == nil {
            _ = self.navigationController?.popViewController(animated: true)
            return
        }
        
        if searchCondition.arrivalDate.characters.count < 11 {
            searchCondition.arrivalDate = searchCondition.arrivalDate+" 00:00:00"
            searchCondition.departureDate = searchCondition.departureDate+" 00:00:00"
        }
        self.hotelSearcherAndListSearchConditionAccord(searchCondition)
        _ = self.navigationController?.popViewController(animated: true)
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
