//
//  PersonalHotelCommonListViewController.swift
//  shanglvjia
//
//  Created by tbi on 2018/8/1.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import RxSwift
import MJRefresh

class PersonalHotelCommonListViewController: PersonalBaseViewController,UIGestureRecognizerDelegate {

    
    /// 从哪过来
    public var fromWhere:String = ""
    
    private var topHeaderView:PersonalCommonHotelListHeaderView = PersonalCommonHotelListHeaderView(reuseIdentifier: "PersonalCommonHotelListHeaderView")
    private var topBackgroundView:UIView = UIView()
    
    private var listTable = UITableView()
    
    private var sortView:PCommonHotelListFilterView = PCommonHotelListFilterView()
    
    /// 酒店星级
    let starRankView:PHotelFilterTableView = PHotelFilterTableView()
    let starRankArray:[(title:String,content:String)] = [("不限",""),("五星／豪华","5"),("四星／高档","4"),("三星／舒适","3"),("快捷／经济","2,1")]
    var starRankSelectNum : NSInteger = 0
    
    ///推荐指数
    let recommendView:PHotelFilterTableView = PHotelFilterTableView()
    let recommendArray:[(title:String,content:String)] = [("不限",""),("五星","10"),("四星半","9"),("四星及以下","8,7")]//,6,5,4,3,2,1
    var recommendSelectNum : NSInteger = 0
    
    ///价格筛选
    let priceView:PHotelPriceView = PHotelPriceView()
    let priceFilterView:PHotelFilterTableView = PHotelFilterTableView()
    let priceArray:[(title:String,content:String)] = [("推荐排序",""),("价格最高","4"),("价格最低","2"),("","1")]
    var priceSelectNum : NSInteger = 0
    var lowPrice:String = "0"
    var highPrice:String = "2000"
    ///参数
    var indexString:String = ""
    var sortString:String = ""
    var hotelStarString:String = ""
    
    private let bag = DisposeBag()
    var pageIndex:NSInteger = 1
    fileprivate var hotelList:PersonalNormalHotelListResponse = PersonalNormalHotelListResponse()
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = false
        setNavigationBgColor(color: TBIThemeWhite)
        self.navigationController?.navigationBar.alpha = 1
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        let searchCondition = PersonalHotelManager.shareInstance.searchConditionUserDraw()
        PersonalHotelManager.shareInstance.searchConditionUserStore(searchCondition: searchCondition)
        topHeaderView.fillDataSources(searchCondition: searchCondition)
        topBackgroundView.isHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        topBackgroundView.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBackButton(backImage: "left")
        self.view.backgroundColor = TBIThemeBaseColor
        setNavigationBgColor(color: TBIThemeWhite)
        setTopView()
        setUIViewAutolayout()
        getHotelListNET(isRefresh: true)
    }
    //MARK:- 定制视图
    func setUIViewAutolayout() {
        
        ///筛选条件
        sortView = PCommonHotelListFilterView.init(frame: CGRect(x:0,y:0,width:ScreenWindowWidth,height:40))
        self.view.addSubview(sortView)
        sortView.recommendIndexButton.addTarget(self, action: #selector(recommendIndexButtonClick(sender:)), for: UIControlEvents.touchUpInside)
        sortView.hotelStarButton.addTarget(self, action: #selector(hotelStarButtonClick(sender:)), for: UIControlEvents.touchUpInside)
        sortView.recommendSortButton.addTarget(self, action: #selector(pricesSortButtonClick(sender:)), for: UIControlEvents.touchUpInside)
        
        
       self.view.addSubview(listTable)
        listTable.snp.makeConstraints { (make) in
            make.top.equalTo(40)
            make.left.right.bottom.equalToSuperview()
        }
        weak var weakSelf = self
        listTable.dataSource=self
        listTable.delegate=self
        listTable.separatorStyle=UITableViewCellSeparatorStyle.none
        listTable.register(PCommonHotelListCell.self, forCellReuseIdentifier: "PCommonHotelListCell")
        listTable.register(UINib(nibName: "TableNoDateView", bundle: nil), forHeaderFooterViewReuseIdentifier: "TableNoDateView")
        listTable.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            weakSelf?.refreshDataSource()
        })
        listTable.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: {
            weakSelf?.loadMoreDataSources()
        })
        
        // 推荐指数
        creatRecommendView()
        //酒店星级
        creatStarRankView()
        // 价格筛选
        creatPriceView()

        
    }
    func setTopView() {
        
        topBackgroundView.frame = CGRect.init(x: 34, y: 5, width: ScreenWindowWidth-60, height: 40)
        self.navigationController?.navigationBar.addSubview(topBackgroundView)
        weak var weakSelf = self
        topBackgroundView.addSubview(topHeaderView)
        topHeaderView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        topHeaderView.hotelListSelctedDateBlock = {(parameter) in
            weakSelf?.nextViewTBICalendar(paramater: parameter)
        }
        
        topHeaderView.hotelListHeaderSearchBlock = { (parameter) in
            weakSelf?.getHotelCityRegionKeywordList(parameters:parameter)
            
        }
        topHeaderView.hotelListHeaderRegionBlock = { (selectedTitle) in
            
            //self.getRegionList(city: self.searchCondition.cityId)
            
        }
        
        topHeaderView.hotelCommonClearLandMarkBlock = {
                weakSelf?.clearLandMarkAction()
        }
        
        
        topHeaderView.fillDataSources(searchCondition: PersonalHotelManager.shareInstance.searchConditionUserDraw())
        
    }
    ///酒店星级
    func creatStarRankView() {
        self.view.addSubview(starRankView)
        starRankView.snp.makeConstraints { (make) in
            make.top.equalTo(sortView.snp.bottom)
            make.right.left.bottom.equalToSuperview()
        }
        weak var weakSelf = self
        starRankView.photelFilterTableViewSelectedBlock = { selectedIndex in
            printDebugLog(message: selectedIndex)
            weakSelf?.starRankSelectNum = selectedIndex
            weakSelf?.customSearchCondition(starRank:weakSelf?.starRankArray[selectedIndex].content ?? ""
                , recommendIndex: "", lowPrices: "", highPrices: "", storType:"")
            
        }
        starRankView.isHidden = true
        addViewClickListener(target: self, action: #selector(removeFillterView),view:starRankView)
    }
    ///推荐指数
    func creatRecommendView() {
        self.view.addSubview(recommendView)
        recommendView.snp.makeConstraints { (make) in
            make.top.equalTo(sortView.snp.bottom)
            make.right.left.bottom.equalToSuperview()
        }
        recommendView.isHidden = true
        weak var weakSelf = self
        recommendView.photelFilterTableViewSelectedBlock = { selectedIndex in
            printDebugLog(message: "推荐指数")
            printDebugLog(message: selectedIndex)
            weakSelf?.recommendSelectNum = selectedIndex
            weakSelf?.customSearchCondition(starRank:"" , recommendIndex: weakSelf?
                .recommendArray[selectedIndex].content ?? "", lowPrices: "", highPrices: "", storType:"")
        }
        addViewClickListener(target: self, action: #selector(removeFillterView),view:recommendView)
        
    }
    /// 推荐排序
    ///价格 筛选
    func creatPriceView(){
        self.view.addSubview(priceView)
        creatPriceTableView()
        priceView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(117)
            make.top.equalTo(sortView.snp.bottom)
        }
        weak var weakSelf = self
        priceView.returnSearchPirceBlock = { (lowStr,highStr) in
           weakSelf?.lowPrice = lowStr
            weakSelf?.highPrice = highStr
            ///weakSelf?.pricesSortButtonClick(sender: (weakSelf?.sortView.recommendSortButton)!)
            ///weakSelf?.customSearchCondition(starRank: "", recommendIndex: "", lowPrices: lowStr, highPrices: highStr, storType: "")
            
        }
        priceView.isHidden = true
        addViewClickListener(target: self, action: #selector(removeFillterView),view:priceFilterView)
    }
    func addViewClickListener(target: AnyObject, action: Selector , view:UIView) {
        let gr = UITapGestureRecognizer(target: target, action: action)
        gr.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        gr.delegate = self
        view.addGestureRecognizer(gr)
    }
    
    func removeFillterView(){
        sortView.hotelStarButton.isSelected = false
        sortView.recommendSortButton.isSelected = false
        sortView.recommendIndexButton.isSelected = false
        starRankView.isHidden = true
        priceFilterView.isHidden = true
        recommendView.isHidden = true
        priceView.isHidden = true
    }
    ///消除手势与TableView的冲突
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if NSStringFromClass((touch.view?.classForCoder)!) == "UITableViewCellContentView" {
            return false
        }
        return true
    }
    ///推荐排序
    func creatPriceTableView(){
        self.view.addSubview(priceFilterView)
        priceFilterView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(priceView.snp.bottom)
        }
        priceFilterView.isHidden = true
        weak var weakSelf = self
        priceFilterView.photelFilterTableViewSelectedBlock = { selectedIndex in
            printDebugLog(message: "推荐排序")
            weakSelf?.priceFilterView.fillDataSources(dataArray: (weakSelf?.priceArray)!, selectIndex: selectedIndex)
            printDebugLog(message: selectedIndex)
            weakSelf?.priceSelectNum = selectedIndex
            
        }
        ///确定or重置
        priceFilterView.resetOrSureButtonBlock = { buttonTitle in
            printDebugLog(message: buttonTitle)
            if buttonTitle == "重置"{
               ///清空筛选条件
                weakSelf?.priceFilterView.fillDataSources(dataArray: (weakSelf?.priceArray)!, selectIndex: 0)
                weakSelf?.priceSelectNum = 0
                weakSelf?.lowPrice = "0"
                weakSelf?.highPrice = hotelSearchMaxPrice.description
                weakSelf?.priceView.setRangeSliderValue(lower:Float(0) , high: Float(hotelSearchMaxPrice))
            }
            ///根据条件筛选
            weakSelf?.customSearchCondition(starRank:"" , recommendIndex:"", lowPrices: (weakSelf?.lowPrice)!, highPrices: (weakSelf?.highPrice)!, storType:weakSelf?.priceArray[(weakSelf?.priceSelectNum)!].content ?? "")
        }
        priceFilterView.photelFilterTableViewDismissBlock = {
            weakSelf?.priceView.isHidden = true
        }
        
        
    }
    
    
    func customSearchCondition(starRank:String,recommendIndex:String,
                               lowPrices:String,highPrices:String,storType:String) {
        let searchCondition:PersonalNormalHotelListRequest = PersonalHotelManager.shareInstance.searchConditionUserDraw()
        if starRank.isEmpty == true {
            searchCondition.hotelStarRate = starRank
        }
        if recommendIndex.isEmpty == true {
            searchCondition.score = recommendIndex
        }
        if storType.isEmpty == true {
            searchCondition.sortType = storType
        }
        if lowPrices.isEmpty == false {
            searchCondition.lowRate = NSInteger(lowPrices) ?? 0
        }
        if highPrices.isEmpty == false {
            searchCondition.highRate = NSInteger(highPrices) ?? hotelSearchMaxPrice
        }
        
        PersonalHotelManager.shareInstance.searchConditionUserStore(searchCondition: searchCondition)
        refreshDataSource()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK:--------Action-------
    func clearLandMarkAction() {
        let searchCondition:PersonalNormalHotelListRequest = PersonalHotelManager.shareInstance.searchConditionUserDraw()
        guard searchCondition.searchRegion.isEmpty == false else {
            return
        }
        
        searchCondition.districtRegion = CityCategoryRegionModel.RegionModel()
        searchCondition.districtId = ""
        searchCondition.landmarkRegion = CityCategoryRegionModel.RegionModel()
        searchCondition.landmarkId = ""
        searchCondition.landmarkName = ""
        searchCondition.commericalRegion = CityCategoryRegionModel.RegionModel()
        searchCondition.commericalId = ""
        searchCondition.searchRegion = ""
        PersonalHotelManager.shareInstance.searchConditionUserStore(searchCondition: searchCondition)
        topHeaderView.fillDataSources(searchCondition: PersonalHotelManager.shareInstance.searchConditionUserDraw())
    }
    
    override func backButtonAction(sender: UIButton) {
        
        if fromWhere == "detailView" {
            for element in (self.navigationController?.childViewControllers)! {
                if element.isMember(of: PHoteiDetailNewViewController.self) {
                    self.navigationController?.popToViewController(element, animated: true)
                }
            }
        }
        
          self.navigationController?.popViewController(animated: true)
    }
    
    ///选择日期
    func nextViewTBICalendar(paramater:Dictionary<String, Any>) {
        let calendarView = TBICalendarViewController()
        calendarView.calendarAlertType = TBICalendarAlertType.PersonalHotel
        calendarView.calendarTypeAlert = ["请选择入住日期","请选择离店日期"]
        calendarView.selectedDates = [PersonalHotelManager.shareInstance.searchConditionUserDraw().arrivalDateFormat,
                                      PersonalHotelManager.shareInstance.searchConditionUserDraw().departureDateFormat]
        //[paramater[HotelListSelectedCheckinDate] as! String,paramater[HotelListSelectedCheckoutDate] as! String]
        calendarView.isMultipleTap = true
        calendarView.showDateTitle = ["入住","离店"]
        weak var weakSelf = self
        calendarView.hotelSelectedDateAcomplishBlock = { (parameters,action) in
            
            weakSelf?.modifyDate(parameters: parameters, action: action)
            // 日期选择之后要搜索
            weakSelf?.getHotelListNET(isRefresh: true)
        }
        
        
        self.navigationController?.pushViewController(calendarView, animated: true)
    }
    func modifyDate(parameters:Array<String>?,action:TBICalendarAction) {
        guard action == TBICalendarAction.Done else {
            return
        }
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone?
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let searchCondition:PersonalNormalHotelListRequest = PersonalHotelManager.shareInstance.searchConditionUserDraw()
        searchCondition.arrivalDateFormat = (parameters?[0])!
        searchCondition.departureDateFormat = (parameters?[1])!
        searchCondition.arrivalDate = (NSInteger(formatter.date(from:(parameters?[0])!)?.timeIntervalSince1970 ?? 0) * 1000).description
        searchCondition.departureDate = (NSInteger(formatter.date(from:(parameters?[1])!)?.timeIntervalSince1970 ?? 0) * 1000).description
        
        PersonalHotelManager.shareInstance.searchConditionUserStore(searchCondition: searchCondition)
        topHeaderView.fillDataSources(searchCondition: searchCondition)
    }
    ///行政区
    func getHotelCityRegionKeywordList(parameters:Dictionary<String,Any>)  {
        nextViewLandMark()
    }
    /// 进入行政区 视图
    func nextViewLandMark() {
        let searchCondition = PersonalHotelManager.shareInstance.searchConditionUserDraw()
        weak var weakSelf = self
        let landmarkView = LandMarkViewController()
        landmarkView.landMarkViewType = AppModelCatoryENUM.PersonalHotel
        landmarkView.elongId = searchCondition.cityId
        landmarkView.landMarkViewSelectedRegionBlock = { (region,index) in
            weakSelf?.searchRegion(region: region, index: index)
            /// weakSelf?.getHotelList(isRefresh: true)
            ///请求刷新
            weakSelf?.getHotelListNET(isRefresh: true)
        }
        self.navigationController?.pushViewController(landmarkView, animated: true)
    }
    private func searchRegion(region:CityCategoryRegionModel.RegionModel,index:NSInteger) {
        let searchCondition:PersonalNormalHotelListRequest = PersonalHotelManager.shareInstance.searchConditionUserDraw()
        searchCondition.districtRegion = CityCategoryRegionModel.RegionModel()
        searchCondition.districtId = ""
        searchCondition.landmarkRegion = CityCategoryRegionModel.RegionModel()
        searchCondition.landmarkId = ""
        searchCondition.commericalRegion = CityCategoryRegionModel.RegionModel()
        searchCondition.commericalId = ""
        switch index {
        case 0:
            searchCondition.districtRegion = region
            searchCondition.districtId = region.id
        case 1:
            searchCondition.landmarkRegion = region
            searchCondition.landmarkId = region.id
        case 2:
            searchCondition.commericalRegion = region
            searchCondition.commericalId = region.id
            
        default:
            break
        }
        searchCondition.searchRegion = region.name
        PersonalHotelManager.shareInstance.searchConditionUserStore(searchCondition: searchCondition)
        topHeaderView.fillDataSources(searchCondition: PersonalHotelManager.shareInstance.searchConditionUserDraw())
    }
    
    ///推荐指数
    func recommendIndexButtonClick(sender:UIButton){
        sender.isSelected = !sender.isSelected
        starRankView.isHidden = true
        priceFilterView.isHidden = true
        priceView.isHidden = true
        ///其他两个筛选按钮的箭头还原
        sortView.hotelStarButton.isSelected = false
        sortView.recommendSortButton.isSelected = false
        
        recommendView.isHidden = !recommendView.isHidden

        recommendView.fillDataSources(dataArray: recommendArray, selectIndex: recommendSelectNum)

    }
    ///酒店星级
    func hotelStarButtonClick(sender:UIButton){
        sender.isSelected = !sender.isSelected
        priceFilterView.isHidden = true
        priceView.isHidden = true
        recommendView.isHidden = true
        starRankView.isHidden = !starRankView.isHidden
        
        ///其他两个筛选按钮的箭头还原
        sortView.recommendIndexButton.isSelected = false
        sortView.recommendSortButton.isSelected = false
        
        weak var weakSelf = self
        starRankView.fillDataSources(dataArray:starRankArray , selectIndex:starRankSelectNum)

    }
    ///价格排序
    func pricesSortButtonClick(sender:UIButton) {
        sender.isSelected = !sender.isSelected
        starRankView.isHidden = true
        recommendView.isHidden = true
        recommendView.isHidden = true
        
        ///其他两个筛选按钮的箭头还原
        sortView.recommendIndexButton.isSelected = false
        sortView.hotelStarButton.isSelected = false
        
        var isShow:Bool = false
        if sender.isSelected == true {
            isShow = true
        }
        priceView.isHidden = !isShow
        priceFilterView.isHidden = !isShow
        
        priceFilterView.fillDataSources(dataArray: priceArray, selectIndex: priceSelectNum)

    }
    
    
    //MARK:-------NET-----
    
    /// 刷新数据
    func refreshDataSource() {
        pageIndex = 1
        getHotelListNET(isRefresh: true)
        
    }
    
    func loadMoreDataSources() {
        getHotelListNET(isRefresh: false)
        
    }
    
    
    
    func getHotelListNET(isRefresh:Bool) {
        if isRefresh == true {
            pageIndex = 1
        }
        let hotelListRequest:PersonalNormalHotelListRequest = PersonalHotelManager.shareInstance.searchConditionUserDraw() //HotelListRequest.hotelSearchFormConvertToHotelListRequest(searchCondition: searchCondition)
        hotelListRequest.hotelStarRate = starRankArray[starRankSelectNum].content
        hotelListRequest.score = recommendArray[recommendSelectNum].content
        hotelListRequest.corpCode = PersonalftmsCorpCode
        hotelListRequest.pageNum = pageIndex
        hotelListRequest.sortType = priceArray[priceSelectNum].content
        if isRefresh == true {
            hotelListRequest.sId = ""
        }else {
            hotelListRequest.sId = hotelList.sId
        }
        weak var weakSelf = self
        showLoadingView()
        PersonalHotelServices.sharedInstance
            .psersonalHotelList(request: hotelListRequest)
            .subscribe { (event) in
                weakSelf?.hideLoadingView()
                switch event {
                case .next(let result):
                    
                    if isRefresh == true {
                        weakSelf?.pageIndex = 2
                        weakSelf?.hotelList = result
                        weakSelf?.listTable.mj_header.endRefreshing()
                    }else {
                        if result.result.count > 0 {
                            weakSelf?.hotelList.result.append(contentsOf: result.result)
                            weakSelf?.pageIndex += 1
                            weakSelf?.listTable.mj_footer.endRefreshing()
                        }else{
                            weakSelf?.listTable.mj_footer.endRefreshingWithNoMoreData()
                        }
                       
                    }
                    weakSelf?.listTable.reloadData()
                    weakSelf?.removeFillterView()
                    
                case .error(let error):
                    weakSelf?.listTable.mj_header.endRefreshing()
                    weakSelf?.listTable.mj_footer.endRefreshing()
                    try? weakSelf?.validateHttp(error)
                case .completed:
                    break
                }
            }.addDisposableTo(self.bag)
    }
    
    
    
    
    
    
}
extension PersonalHotelCommonListViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hotelList.result.count
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if (hotelList.result.count ) == 0 {
            return tableView.frame.height
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if (hotelList.result.count ) == 0 {
            if let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableNoDateView") as? TableNoDateView {
                footer.setType(.noPersonal)
                footer.messageLabel.text="当前条件下暂未查询到酒店"
                footer.image.image = UIImage(named: "hotel_default")
                return footer
            }
        }
        return nil
    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        return hotelList.count
//    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PCommonHotelListCell  = tableView.dequeueReusableCell(withIdentifier: "PCommonHotelListCell") as! PCommonHotelListCell
       cell.fillDataSourcesCell(itemModel: hotelList.result[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailView = PHoteiDetailNewViewController()
        detailView.fromWhereView = .PersonalHotel
        detailView.presaleType = hotelList.result[indexPath.row].payType
        detailView.fromWhereString = "normal"
        let corpCode:String = hotelList.result[indexPath.row].corpCode
        detailView.cordGroup = corpCode
        if corpCode.contains(PersonalSpecialHotelCorpCode) {
            detailView.fromWhereView = .PersonalSpecialHotel
            detailView.specialHotelItemInfo.facilitiesV2List = hotelList.result[indexPath.row].facilitiesV2List
            detailView.specialHotelItemInfo.hotelId = hotelList.result[indexPath.row].hotelOwnId
            detailView.presaleType = "1"
            detailView.specialHotelItemInfo.address = hotelList.result[indexPath.row].hotelAddress
            detailView.specialHotelItemInfo.hotelDesc = hotelList.result[indexPath.row].hotelDesc
            detailView.specialHotelItemInfo.hotelName = hotelList.result[indexPath.row].hotelName
            detailView.specialHotelItemInfo.cover = hotelList.result[indexPath.row].cover
            detailView.hotelDetailType = AppModelCatoryENUM.PersonalSpecialHotel
            detailView.cityId = PersonalHotelManager.shareInstance.searchConditionUserDraw().cityId
        }else {
            detailView.hotelDetailType = AppModelCatoryENUM.PersonalHotel
            detailView.personalNormalHotel = hotelList.result[indexPath.row]
            detailView.presaleType = hotelList.result[indexPath.row].payType
        }
        self.navigationController?.pushViewController(detailView, animated: true)
        
    }
    
    
}
