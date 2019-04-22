//
//  HotelCompanyStaffViewController.swift
//  shop
//
//  Created by manman on 2017/5/10.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON
import MJRefresh

enum HotelCompanyStaffViewType {
    case Hotel
    case Flight
    case NewOrder
    case Train
    case Car
}

class HotelCompanyStaffViewController: CompanyBaseViewController,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UISearchControllerDelegate{

    typealias  CompanyStaffViewNewOrderSelectedResult = (Bool) ->Void
    
    // 类型 决定 下一步 跳转页面
    public  var hotelCompanyStaffViewType = HotelCompanyStaffViewType.Hotel

    public var companyStaffViewNewOrderSelectedResult:CompanyStaffViewNewOrderSelectedResult!
    
    
    
    private let hotelCompanyStaffTableViewCellFirstIdentify = "hotelCompanyStaffTableViewCellFirstIdentify"
    private let hotelCompanyStaffTableViewCellSecondIdentify = "hotelCompanyStaffTableViewCellSecondIdentify"
    private var searchBar:TBISearchBar = TBISearchBar()
    private var tableView:UITableView = UITableView()
    private var headerSectionTableView : UITableView = UITableView()
    private var headerSectionTableViewBackgroundView : UIView = UIView()
    
    //网络接收 数据
    private var tableViewDataSourcesArr:[QueryPassagerResponse] = Array<QueryPassagerResponse>()
    //是否收起 1是收起  记录选中的 个数
    private var selectedStaffShowNum:NSInteger = 0
    
    private var nextButton:UIButton = UIButton()
    
    private let bag = DisposeBag()
    
    fileprivate var pageIndex:NSInteger = 1
    
    fileprivate var pageSize:Int = 10
    
    private var tableViewSelectedDataSourcesArr:[QueryPassagerResponse] = Array<QueryPassagerResponse>(){
        
        willSet{
            print("设置之前",tableViewSelectedDataSourcesArr.count)
        }
        
        didSet{
            print("设置之后",tableViewSelectedDataSourcesArr.count)
            if tableViewSelectedDataSourcesArr.count > 0 {
                
                
                setNextButtonState(state: hotelCompanyStaffViewType)

                //  是否可以触发事件
                nextButton.backgroundColor = TBIThemeBlueColor
                nextButton.isEnabled = true
                
                
                // 是否存在按钮
//                if nextButton.isHidden == true {
//                    nextButton.isHidden = false
//                }else
//                {
//                    nextButton.isHidden = true
//                }
                
                
            }else
            {
                nextButton.backgroundColor = TBIThemeGrayLineColor
                nextButton.isEnabled = false
            }
            
        }
        
        
    }

    

    override func viewDidLoad() {
        super.viewDidLoad()
        //模拟数据
       // simulabteData()
        searchBar.placeholder = "请输入员工姓氏或全名"
        searchBar.layer.cornerRadius = 2
        searchBar.frame = CGRect(x:200,y:0,width:ScreenWindowWidth - 40,height:32)
        if #available(iOS 11.0, *) {
            searchBar.contentInset = UIEdgeInsets.init(top: 6, left:40, bottom: 6, right:20)
        }else
        {
            searchBar.contentInset = UIEdgeInsets.init(top: 6, left:0, bottom: 6, right:20)
        }
        searchBar.delegate = self
        //searchBar.becomeFirstResponder()
        searchBar.tintColor = UIColor.blue
        //searchBar.keyboardType = UIKeyboardType.webSearch
        self.navigationItem.titleView = searchBar
        
        
//        if #available(iOS 11.0, *) {
//            //navigationItem.searchController = searchBar
//            self.navigationItem.searchController = searchBar
//        } else {
//            // Fallback on earlier versions
//            navigationItem.titleView = searchBar
//        }

        if #available(iOS 11.0, *) {
            searchBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
            if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
                if let backgroundview = textfield.subviews.first {
                    
                    // Background color
                    backgroundview.backgroundColor = UIColor.white
                    
                    // Rounded corner
                    backgroundview.layer.cornerRadius = 5;
                    backgroundview.clipsToBounds = true;
                    
                }
            }
            
        }
        
        
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = TBIThemeBaseColor
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        //tableView.register(HotelCompanyStaffTableViewFirstCell.classForCoder(), forCellReuseIdentifier: hotelCompanyStaffTableViewCellFirstIdentify)
        tableView.register(HotelCompanyStaffTableViewSecondCell.classForCoder(), forCellReuseIdentifier: hotelCompanyStaffTableViewCellSecondIdentify)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(50)
            make.top.equalTo(1)
            
        }
        headerSectionTableView.delegate = self
        headerSectionTableView.dataSource = self
        headerSectionTableView.backgroundColor = TBIThemeBaseColor
        headerSectionTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        headerSectionTableView.register(HotelCompanyStaffTableViewFirstCell.classForCoder(), forCellReuseIdentifier: hotelCompanyStaffTableViewCellFirstIdentify)
        headerSectionTableViewBackgroundView.addSubview(headerSectionTableView)
        headerSectionTableView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        nextButton.setTitle("下一步", for: .normal)
        nextButton.backgroundColor = TBIThemeGrayLineColor
        nextButton.titleLabel?.font = UIFont.systemFont( ofSize: 18)
        nextButton.addTarget(self, action: #selector(nextButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        nextButton.isEnabled = false
        self.view.addSubview(nextButton)
        nextButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(50)
        }
        

        //heardSectionTableView.register(HotelCompanyStaffTableViewSecondCell.classForCoder(), forCellReuseIdentifier: hotelCompanyStaffTableViewCellSecondIdentify)

        //nextButton.isHidden = true
       
        
        weak var weakSelf = self
        //监听上拉刷新
        tableView.mj_header = MJRefreshNormalHeader{
            weakSelf?.pageIndex = 1
            let keyword:String = weakSelf?.searchBar.text  ?? ""
            weakSelf?.getPassenger(keyword: keyword, pageNO: weakSelf?.pageIndex ?? 1)
//            HotelCompanyService.sharedInstance
//                .getPageTravellerList(qname: weakSelf?.searchBar.text ?? "", pageSize: self.pageSize, pageIndex: self.pageIndex)
//                .subscribe { (result) in
//                    weakSelf?.tableView.mj_header.endRefreshing()
//                    weakSelf?.hideLoadingView()
//                    if case .next(let result) = result {
//                        weakSelf?.tableViewDataSourcesArr = result
//                        if result.count < self.pageSize {
//                            weakSelf?.tableView.mj_footer.endRefreshingWithNoMoreData()
//                            weakSelf?.tableView.mj_footer.isHidden = result.isEmpty
//                        }else {
//                            weakSelf?.tableView.mj_footer.endRefreshing()
//                        }
//                        weakSelf?.tableView.reloadData()
//                    }
//                    if case .error(let result) = result {
//                        try? weakSelf?.validateHttp(result)
//                    }
//                }.disposed(by: self.bag)
            
        }
        //初始化下拉加载
        tableView.mj_footer = MJRefreshAutoNormalFooter{
            
            weakSelf?.pageIndex += 1
             let keyword:String = weakSelf?.searchBar.text  ?? ""
            weakSelf?.getPassenger(keyword: keyword, pageNO: weakSelf?.pageIndex ?? 1)
            
//            HotelCompanyService.sharedInstance
//                .getPageTravellerList(qname: weakSelf?.searchBar.text ?? "", pageSize: self.pageSize, pageIndex: self.pageIndex)
//                .subscribe { (result) in
//                    weakSelf?.tableView.mj_header.endRefreshing()
//                    weakSelf?.hideLoadingView()
//                    if case .next(let e) = result {
//                        if e.count == 0 {
//                            self.tableView.mj_footer.endRefreshingWithNoMoreData()
//                        }else {
//                            self.tableView.mj_footer.endRefreshing()
//                        }
//                        self.tableViewDataSourcesArr += e
//                        weakSelf?.tableView.reloadData()
//                    }
//                    if case .error(let result) = result {
//                        try? weakSelf?.validateHttp(result)
//                    }
//                }.disposed(by: self.bag)
            
        }
        //在开始隐藏上啦加载更多
        tableView.mj_header.beginRefreshing()
        //getPassenger()
    }
    
    private func simulabteData()
    {
        //模拟数据
       do
       {
        try jsonLocalDataParse()
       }
       catch
       {
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        setNavigationBackButton(backImage: "left")
        setNavigationBgColor(color: TBIThemeWhite)
        
        //add by manman  on start of line
        // 由于选择完旅客之后 进入到下一个页面 在返回选择旅客信息页面
        // so 页面将要出现时，检测是否有本地数据
        fillLocalDataSource()
        // end of line
        setNextButtonState(state: hotelCompanyStaffViewType)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        //clearLocalDataSource()
        //self.tableView.reloadData()
    }
    
    //清空本地数据
    private func clearLocalDataSource()
    {
        
         if tableViewSelectedDataSourcesArr.count > 0
         {
            selectedStaffShowNum = 0
            tableViewSelectedDataSourcesArr.removeAll()
        }
        
    }
    
    func fillLocalDataSource() {
        if PassengerManager.shareInStance.passengerSVDraw().count > 0
        {
            tableViewSelectedDataSourcesArr = PassengerManager.shareInStance.passengerSVDraw()
            selectedStaffShowNum = tableViewSelectedDataSourcesArr.count
            tableView.reloadData()
        }
        
        
    }
    
    
    private func setNextButtonState(state:HotelCompanyStaffViewType)
    {
        
        switch state {
        case .Flight,.Hotel,.Train,.Car:
            print("机票酒店")
            
            nextButton.removeTarget(nil, action: nil, for: UIControlEvents.touchUpInside)
            nextButton.setTitle("下一步", for: UIControlState.normal)
            nextButton.addTarget(self, action: #selector(nextButtonAction(sender:)), for: UIControlEvents.touchUpInside)
            
            
        case .NewOrder:
            print("新建出差单")

            nextButton.removeTarget(nil, action: nil, for: UIControlEvents.touchUpInside)
            nextButton.setTitle("确定", for: UIControlState.normal)
            nextButton.addTarget(self, action: #selector(okayButtonAction(sender:)), for: UIControlEvents.touchUpInside)
            
        }

    }
    
    func configHeaderTableView() {
        guard selectedStaffShowNum > 0 else {
            return
        }
        headerSectionTableViewBackgroundView.frame = CGRect.init(x: 0, y: 0, width: Int(ScreenWindowWidth), height: selectedStaffShowNum * 44)
        headerSectionTableViewBackgroundView.backgroundColor = UIColor.red
        headerSectionTableViewBackgroundView.addSubview(headerSectionTableView)
        headerSectionTableView.snp.remakeConstraints { (update) in
            update.top.left.bottom.right.equalToSuperview()
        }
        headerSectionTableView.reloadData()
    }
    
    
    //MARK:------UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard headerSectionTableView != tableView else {
            return 0
        }
        if selectedStaffShowNum > 0 {
            return (CGFloat(44 * selectedStaffShowNum))
        }else {
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard headerSectionTableView != tableView else {
            return UIView()
        }
       
        configHeaderTableView()
        return headerSectionTableViewBackgroundView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//            return tableViewDataSourcesArr.count + selectedStaffShowNum
        if headerSectionTableView != tableView {
            return tableViewDataSourcesArr.count
        }else{
            return selectedStaffShowNum
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if headerSectionTableView != tableView {
            return 115
        }
        return 44
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        weak var weakSelf = self
//        if tableViewSelectedDataSourcesArr.count > 0 &&
//            tableViewSelectedDataSourcesArr.count > indexPath.row &&
//            selectedStaffShowNum > indexPath.row
            if headerSectionTableView == tableView && selectedStaffShowNum > 0
        {
            let cell:HotelCompanyStaffTableViewFirstCell = tableView.dequeueReusableCell(withIdentifier: hotelCompanyStaffTableViewCellFirstIdentify) as! HotelCompanyStaffTableViewFirstCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            var isShow:Bool = false
            
            if indexPath.row == 0 {
                isShow = true
            }
            //cell.fillDataSources(traveller: tableViewSelectedDataSourcesArr[indexPath.row], index: indexPath.row, isShow: isShow)
            cell.fillSVDataSource(passgenger: tableViewSelectedDataSourcesArr[indexPath.row], index: indexPath.row, isShow: isShow)
            cell.hotelCompanyStaffUnfoldBlock = { (isFold) in
                weakSelf?.selectedStaffIsFold(fold: isFold)
            }
            cell.hotelCompanyStaffDeleteBlock = { (deleteIndex) in
                weakSelf?.deleteSelectedStaffFirstCell(deleteIndex: deleteIndex)
            }
            return cell
        }else{
        
                let cell:HotelCompanyStaffTableViewSecondCell = tableView.dequeueReusableCell(withIdentifier: hotelCompanyStaffTableViewCellSecondIdentify) as! HotelCompanyStaffTableViewSecondCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        if tableViewDataSourcesArr.count + 0 > indexPath.row {
            var isMatch = 0
            var isSelected:Bool = false
            
            
            if tableViewSelectedDataSourcesArr.count > 0
            {
                //判断   差旅政策     是否匹配  添加 审批 政策
//                if  (tableViewSelectedDataSourcesArr.first?.policyId == tableViewDataSourcesArr[indexPath.row - selectedStaffShowNum].policyId
//                    && tableViewSelectedDataSourcesArr.first?.approveId == tableViewDataSourcesArr[indexPath.row - selectedStaffShowNum].approveId)
                if  (tableViewSelectedDataSourcesArr.first?.policyId == tableViewDataSourcesArr[indexPath.row ].policyId
                    && tableViewSelectedDataSourcesArr.first?.approveId == tableViewDataSourcesArr[indexPath.row ].approveId)
                {
                    isMatch = 1
                }else
                {
                    isMatch = 2
                }
                /// 新添加需求 专车 不需要判断 差旅 审批 政策
                if hotelCompanyStaffViewType == HotelCompanyStaffViewType.Car {
                    isMatch = 1
                }
                
                
//              isSelected =  tableViewSelectedDataSourcesArr.contains{ (element) -> Bool in
//                    element.passagerId == tableViewDataSourcesArr[indexPath.row - selectedStaffShowNum].passagerId
                isSelected =  tableViewSelectedDataSourcesArr.contains{ (element) -> Bool in
                    element.passagerId == tableViewDataSourcesArr[indexPath.row ].passagerId
                
                }
            }
//            cell.fillSVDataSources(match: isMatch,selectedState:isSelected,index:indexPath.row - selectedStaffShowNum, traveller: tableViewDataSourcesArr[indexPath.row - selectedStaffShowNum])
            cell.fillSVDataSources(match: isMatch,selectedState:isSelected,index:indexPath.row, traveller: tableViewDataSourcesArr[indexPath.row ])
        }
        cell.hotelCompanyStaffSelected = {(selectedIndex,isSelected) in
            weakSelf?.selectedStaffIsSelectedSecondCell(deleteIndex: selectedIndex,isSelected:isSelected)
        }
        
        if selectedStaffShowNum == 0 {
            //nextButton.isHidden = true
            nextButton.backgroundColor = TBIThemeGrayLineColor
            nextButton.isEnabled = false
        }else
        {
            //nextButton.isHidden = false
            nextButton.backgroundColor = TBIThemeBlueColor
            nextButton.isEnabled = true
        }
        return cell
      }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard tableView != headerSectionTableView else {
            return
        }
        searchBar.resignFirstResponder()
        //add by manman on 2018-04-18
        //为他人预定 最多5个人
        if indexPath.row < tableViewDataSourcesArr.count {
            let tmpTraveller  = tableViewDataSourcesArr[indexPath.row - 0]
            let isContain =  tableViewSelectedDataSourcesArr.contains(where: { (element) -> Bool in
                if element.uid == tmpTraveller.uid
                {
                    return true
                }
                else{
                    return false
                }
            })
            
            if tableViewSelectedDataSourcesArr.count >= 5 && isContain == false {
                showSystemAlertView(titleStr: "提示", message: "最多选择五人")
                return
            }
        }
        // end of line
        
        let cell = tableView.cellForRow(at: indexPath)
        if (cell?.isMember(of: HotelCompanyStaffTableViewSecondCell.classForCoder()))! {

            let cell:HotelCompanyStaffTableViewSecondCell = tableView.cellForRow(at: indexPath) as! HotelCompanyStaffTableViewSecondCell
            cell.selectedCell(selectedCell:cell)
        }
        
    }
    
    
    
    //MARK:-------UISearchBarDelegate 
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        print("searchBar click ...")
        searchBar.resignFirstResponder()
        let keyWord:String = searchBar.text ?? ""
        self.pageIndex = 1
        getPassenger(keyword:keyWord , pageNO: 1)
        
        //tableView.mj_header.beginRefreshing()
        
        
//        showLoadingView()
//        weak var weakSelf = self
//        HotelCompanyService.sharedInstance
//            .getTravellerList(uid: searchBar.text!)
//            .subscribe { (result) in
//
//                weakSelf?.hideLoadingView()
//                if case .next(let result) = result {
//
//                    print(result)
//                    weakSelf?.tableViewDataSourcesArr = result
//                    weakSelf?.tableView.reloadData()
//
//                }
//                if case .error(let result) = result {
//                    print(result)
//                    try? weakSelf?.validateHttp(result)
//                    //weakSelf?.showSystemAlertView(titleStr: "提示", message: String(describing: result))
//                }
//            }.disposed(by: bag)
        
        
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.bounds.size.height//size.height
        let contentOffsetY = scrollView.contentOffset.y
        let bottomOffset = scrollView.contentSize.height - contentOffsetY
        if bottomOffset <= height {
            // 在最底部
            //print("在最底部... ")
        } else {
            //print("在最底部... ")
        }
    }
    
    func reloadDataSources(dataSources:[Traveller]) {
        
//        tableViewSelectedDataSourcesArr = dataSources
//        selectedStaffShowNum = tableViewSelectedDataSourcesArr.count
//        tableView.reloadData()
        
    }
    func reloadSVDataSources(dataSources:[QueryPassagerResponse]) {
        
        tableViewSelectedDataSourcesArr = dataSources
        selectedStaffShowNum = tableViewSelectedDataSourcesArr.count
        tableView.reloadData()
        
    }
    
    
    //MARK:-----------NET-------------
    
    func getPassenger(keyword:String,pageNO:NSInteger) {
        var page:NSInteger = 1
        if pageNO >= 1 {
            page = pageNO
        }
        searchBar.resignFirstResponder()
        weak var weakSelf = self
        self.showLoadingView()
        _ = PassengerServices.sharedInstance
            .getPassengerList(name: keyword, page: page)
            .subscribe { (event) in
                weakSelf?.hideLoadingView()
                weakSelf?.tableView.mj_header.endRefreshing()
                switch event {
                case .next(let element):
                    printDebugLog(message: element)
                    printDebugLog(message: element.first?.mj_keyValues())
                    if element.count == 0 {
                        weakSelf?.tableView.mj_footer.endRefreshingWithNoMoreData()
                    }else {
                        weakSelf?.tableView.mj_footer.endRefreshing()
                    }
                    if weakSelf?.pageIndex == 1  {
                        weakSelf?.tableViewDataSourcesArr.removeAll()
                    }
                    weakSelf?.tableViewDataSourcesArr += element
                    weakSelf?.tableView.reloadData()
                case .error(let error):
                    try? weakSelf?.validateHttp(error)
                case .completed:
                    break
                    
                    
                    
                }
                
                /*
weakSelf?.tableView.mj_header.endRefreshing()
         weakSelf?.hideLoadingView()
         if case .next(let e) = result {
             if e.count == 0 {
                 self.tableView.mj_footer.endRefreshingWithNoMoreData()
             }else {
                 self.tableView.mj_footer.endRefreshing()
             }
             self.tableViewDataSourcesArr += e
             weakSelf?.tableView.reloadData()
         }
         if case .error(let result) = result {
             try? weakSelf?.validateHttp(result)
         }
                 
                 
                 */
                
                
                
            }
        
        
    }
    
    
    
// MARK:---- cell Action
    
    
    // true 是收起。false 展开状态
    private func selectedStaffIsFold(fold:Bool) {
     
        if fold {
            selectedStaffShowNum = 1
        }else
        {
            selectedStaffShowNum = tableViewSelectedDataSourcesArr.count
        }
        
        
        self.tableView.reloadData()
    }
    
    
    //删除 选中的数据
    private func deleteSelectedStaffFirstCell(deleteIndex:NSInteger)  {
        print("第一个信息 删除数据")
        // add by manman start of line
        //替换为 旅客管理类 管理 旅客信息
        if tableViewSelectedDataSourcesArr.count == 0 &&
            PassengerManager.shareInStance.passengerDraw().count > 0{
            tableViewSelectedDataSourcesArr = PassengerManager.shareInStance.passengerSVDraw()
        }
        
        
        
        
        //end of line
        
        
        
        tableViewSelectedDataSourcesArr.remove(at: deleteIndex)
        selectedStaffShowNum = tableViewSelectedDataSourcesArr.count
        self.tableView.reloadData()
    }
    
    
    //选中的数据 是否在选中的人员中
    private func selectedStaffIsSelectedSecondCell(deleteIndex:NSInteger,isSelected:Bool)  {
        print("第二个信息 删除数据或者添加 选中数据")
        
       
        
        if isSelected {
            
            print("选中 ...")
            let tmpTraveller  = tableViewDataSourcesArr[deleteIndex]
            let isContain =  tableViewSelectedDataSourcesArr.contains(where: { (element) -> Bool in
                if element.uid == tmpTraveller.uid
                {
                    return true
                }
                else{
                    return false
                }
                
                
            })
            
            if !isContain
            {
                tableViewSelectedDataSourcesArr.append(tmpTraveller)
            }
            
            
        }else
        {
            print("取消 选中 ...")
            let tmpTraveller  = tableViewDataSourcesArr[deleteIndex]
            for index in 0..<tableViewSelectedDataSourcesArr.count {
                if tmpTraveller.passagerId == tableViewSelectedDataSourcesArr[index].passagerId {
                    tableViewSelectedDataSourcesArr.remove(at: index)
                    break
                }
            }
        }
        selectedStaffShowNum = tableViewSelectedDataSourcesArr.count
        tableView.reloadData()
    }
    
    //MARK:--- 机票酒店搜索页面
    @objc private func nextButtonAction(sender:UIButton) {
        PassengerManager.shareInStance
            .passengerSVStore(passengers:tableViewSelectedDataSourcesArr)
        
        switch hotelCompanyStaffViewType {
        case .Hotel:
            nextHotelCompanySearchView()
        case .Flight:
            nextFlightCompanySearchView()
        case .Train:
            nextTrainCompanySearchView()
        case .Car:
            nextCarCompanySearchView()
            
        default: break
        }
    }
    
    //MARK: --- 修改出差单 回调 方法
    @objc private func okayButtonAction(sender:UIButton) {
        PassengerManager.shareInStance
            .passengerSVStore(passengers: tableViewSelectedDataSourcesArr)
        backButtonAction(sender: UIButton.init())
        companyStaffViewNewOrderSelectedResult(true)
        
    }
    
    
    
    private func nextHotelCompanySearchView() {
        PassengerManager.shareInStance.passengerSVStore(passengers:tableViewSelectedDataSourcesArr)
        
        // 进入 酒店搜索页面。
        //从酒店列表页进入 选择乘客信息的 需要回到 列表页
//        if self.navigationController?.viewControllers {
//            
//        }
        
        for element in (self.navigationController?.viewControllers)!{
            if element.isKind(of:HotelCompanyListViewController.classForCoder()){
                self.navigationController?.popViewController(animated: true)
                return
            }
        }
        
        
        intoNextSearchView()
    }
    
    private func intoNextSearchView()
    {
        //let searchCompanyView = HotelCompanySearchViewController()
        let searchCompanyView = HotelSVCompanySearchViewController()
        //searchCompanyView.travelNo = "订单号"
        self.navigationController?.pushViewController(searchCompanyView, animated: true)
    }
    
    
    private func nextFlightCompanySearchView()
    {
        
        //let fightCompanySearchView = FlightSearchViewController()
        let fightCompanySearchView = FlightSVSearchViewController()
        self.navigationController?.navigationBar.shadowImage = UIImage.init(named: "border")
        self.navigationController?.pushViewController(fightCompanySearchView, animated: true)
        
    }
    
    private func nextTrainCompanySearchView()
    {
        let trainSearchViewController = CoTrainSearchViewController()
        self.navigationController?.pushViewController(trainSearchViewController, animated: true)
        
    }
    
    private func nextCarCompanySearchView()
    {
        let carSearchViewController = CoCarSearchViewController()
        self.navigationController?.pushViewController(carSearchViewController, animated: true)
        
    }

    override func backButtonAction(sender: UIButton) {
        searchBar.resignFirstResponder()
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:------解析 JSON本地数据
    
    func jsonLocalDataParse()throws  {

//        let filePath:String = Bundle.main.path(forResource: "TravellerList", ofType: "json")!
//        let url = URL.init(fileURLWithPath: filePath)
//        let data = try Data.init(contentsOf: url)
//        let json:Any = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
//        tableViewDataSourcesArr = JSON(data)["content"].arrayValue.map{Traveller(jsonData:$0)}

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
