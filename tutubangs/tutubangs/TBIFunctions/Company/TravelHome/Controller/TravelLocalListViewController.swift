//
//  TravelLocalListViewController.swift
//  shop
//
//  Created by TBI on 2017/7/15.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import MJRefresh
import RxSwift
import SwiftDate

class TravelLocalListViewController: CompanyBaseViewController {

    fileprivate let bag = DisposeBag()
    
    let textField = UITextField(placeholder: "关键字/目的地",fontSize: 13)
    
    var citys:[LocalCitys.Citys] = []
    
    var city:LocalCitys.Citys?
    
    //途经地
    var throughCity:[LocalCitys]?
    
    // 1 国内 2国际
    var region:Int = 1
    
    lazy var searchBar: UIView = {
        let vi = UIView()
        let img = UIImageView.init(imageName: "searchBarFlag")
        vi.addSubview(img)
        vi.addSubview(self.textField)
        img.snp.makeConstraints{ (make) in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(12)
        }
        self.textField.snp.makeConstraints{ (make) in
            make.top.bottom.right.equalToSuperview()
            make.left.equalTo(img.snp.right).offset(5)
        }
        return vi
    }()
    
    let travelListTableViewCellIdentify = "travelListTableViewCellIdentify"
    
    let cityButton = UIButton()
    
    let startCityLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 12)
    
    
    let tableView: UITableView = UITableView()
    
    let footerView: TravelLocalFooterView = TravelLocalFooterView()
    
    fileprivate var offsetY:CGFloat = 0
    
    fileprivate var data:[TravelListItem]?
    
    fileprivate var rightBarView: UIView = {
        let vi = UIView(frame: CGRect(x: 0, y: ScreenWindowWidth - 64, width: 64, height: 44))
        let img = UIImageView(imageName: "ic_customization")
        let textLabel = UILabel(text: "定制", color: TBIThemeWhite, size: 13)
        vi.addSubview(img)
        vi.addSubview(textLabel)
        textLabel.snp.makeConstraints{ (make) in
            make.centerY.equalToSuperview()
            make.width.equalTo(30)
            make.right.equalTo(4)
        }
        img.snp.makeConstraints{ (make) in
            make.centerY.equalToSuperview()
            make.width.equalTo(12)
            make.right.equalTo(textLabel.snp.left).offset(-5)
        }
        return vi
    }()
    
    fileprivate lazy var searchBarView: UIView = {
        let vi = UIView()
        vi.backgroundColor = TBIThemeBlueColor
        return vi
    }()
    
    fileprivate lazy var searchBgView: UIView = {
        let vi = UIView()
        vi.backgroundColor = TBIThemeWhite
        vi.layer.cornerRadius = 4
        vi.layer.borderWidth = 1
        vi.layer.borderColor = TBIThemeGrayLineColor.cgColor
        return vi
    }()
    
    fileprivate var pageIndex:Int = 1
    
    fileprivate var pageSize:Int = 10
    
    var travelForm = TravelForm.Search(pageIndex: 1, pageSize: 20,searchKey: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation(title:"当地参团游")
        let rightBarButton = UIBarButtonItem(customView: rightBarView)
        self.navigationItem.rightBarButtonItem = rightBarButton
        //设置当地参加团游数据
        travelForm.startCity = city?.start_place
        travelForm.arriveCity = city?.start_place
        travelForm.destId = city?.start_place_id
        
        initView()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func backButtonAction(sender:UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        if contentOffsetY > offsetY {
            // 在最底部
            footerView.isHidden = true
        } else {
            footerView.isHidden = false
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        offsetY = scrollView.contentOffset.y
    }
}


extension TravelLocalListViewController {
    
    func initView(){
        let  line = UILabel(color: TBIThemeGrayLineColor)
        startCityLabel.text = city?.start_place
        startCityLabel.textAlignment = .center
        textField.returnKeyType = .search
        textField.delegate  = self
        //设置header
        cityButton.setImage(UIImage(named: "ic_down"), for: UIControlState.normal)
        
        self.view.addSubview(searchBarView)
        searchBarView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(38)
        }
        searchBarView.addSubview(searchBgView)
        searchBgView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalToSuperview()
            make.height.equalTo(32)
        }
        searchBgView.addSubview(cityButton)
        cityButton.snp.makeConstraints { (make) in
            make.left.equalTo(80)
            make.centerY.equalToSuperview()
            make.height.equalTo(6)
            make.width.equalTo(8)
        }
        searchBgView.addSubview(startCityLabel)
        startCityLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(cityButton.snp.left).offset(-5)
            make.left.equalTo(3)
            make.top.bottom.equalToSuperview()
            
        }
        searchBgView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.equalTo(cityButton.snp.right).offset(5)
            make.top.bottom.equalToSuperview().inset(5)
            make.width.equalTo(1)
        }
        searchBgView.addSubview(searchBar)
        searchBar.snp.makeConstraints { (make) in
            make.left.equalTo(line.snp.right).offset(5)
            make.top.bottom.right.equalToSuperview()
        }
        startCityLabel.addOnClickListener(target: self, action: #selector(cityClick))
        rightBarView.addOnClickListener(target: self, action: #selector(rightItemClick))
        initTableView()
        //searchBar.addOnClickListener(target: self, action: #selector(searchBarClick(tap:)))
    }
    
    
    //搜索点击事件
    func  searchBarClick(tap:UITapGestureRecognizer){
        self.navigationController?.pushViewController(TravelDestinationViewController(), animated: true)
    }
    
    
    //定制旅游
    func rightItemClick() {
        if self.islogin() {
            self.navigationController?.pushViewController(TravelDIYIntentOrderController(), animated: true)
        }
    }
    
    func cityClick() {
        self.textField.resignFirstResponder()
        let titleArr:[String] = citys.map{$0.start_place ?? ""}
        let roleView = TBIFinderView.init(frame: ScreenWindowFrame)
        roleView.finderViewSelectedResultBlock = { (cellIndex) in
            self.startCityLabel.text = titleArr[cellIndex]
            //切换城市 重置过滤条件
            self.travelForm.saleDateBegin = ""
            self.travelForm.saleDateEnd = ""
            self.travelForm.dayNumBegin = nil
            self.travelForm.dayNumEnd =   nil
            self.travelForm.saleDateBegin = ""
            self.travelForm.saleDateEnd = ""
            self.travelForm.orderBy = ""
            self.footerView.initButtonSelected()
            self.travelForm.startCity = titleArr[cellIndex]
            self.travelForm.arriveCity = titleArr[cellIndex]
            self.travelForm.destId = self.citys.filter{$0.start_place == titleArr[cellIndex]}.first?.start_place_id
            self.tableView.mj_header.beginRefreshing()
        }
        KeyWindow?.addSubview(roleView)
        roleView.reloadDataSources(titledataSources: titleArr, flageImage: nil)
        
    }
    
}

//extension TravelLocalListViewController {
//    
//    /// 初始化数据
//    func initThroughCityData () {
//        let cityModel = DestinationsModel(type: "10", departure: cityName, destId: travelForm.destId ?? "",keyWord: travelForm.searchKey ?? "")
//        CitsService.sharedInstance.getLocalDestinations(form: cityModel).subscribe{ event in
//            self.hideLoadingView()
//            if case .next(let e) = event {
//                if !e.isEmpty {
//                    self.throughCity = e
//                    var dataSourceArray:[(String,[String])] = [("全部",["全部"])]
//                    for index in 0..<e.count{
//                        let citysList = e[index].citys.reduce(["不限"]){$0 + [($1.start_place ?? "")]}
//                        dataSourceArray.append((e[index].name ?? "",citysList))
//                    }
//
//                    self.alertThroughView(data:dataSourceArray)
//                }
//            }
//            if case .error(let e) = event {
//                try? self.validateHttp(e)
//            }
//            }.disposed(by: bag)
//        
//    }
//    
//    func  alertThroughView (data:[(String,[String])]){
//        /**
//         传递的参数:
//         viewController:UIViewController   当前的ViewController
//         dataSourceArray:[(String,[String])] -  [(左侧标题,[右侧内容item])]
//         -----
//         回调
//         clickActionEnum -  按钮🔘点击的动作：取消和确定
//         leftIndex       -  左侧的索引值
//         rightIndex      -  右侧的索引值
//         */
//        let alertView = TravelPassPlaceFilterView.getInstance(viewController: self, dataSourceArray: data) { (clickActionEnum, leftIndex, rightIndex) in
//            switch clickActionEnum {
//            case .cancel:
//               break
//            case .ok:
//                if leftIndex != 0 && rightIndex != 0 {
//                    self.footerView.throughButton.isSelected =  true
//                    self.citys = self.throughCity?[leftIndex-1].citys ?? []
//                    let citys = self.throughCity?[leftIndex-1]
//                    if citys?.name == "国内" {
//                        self.region = 1
//                    }else {
//                        self.region = 2
//                    }
//                    
//                    self.city = self.throughCity?[leftIndex-1].citys[rightIndex-1]
//                    self.startCityLabel.text = self.city?.start_place
//                    self.travelForm.arriveCity = self.city?.start_place
//                    self.travelForm.destId = self.city?.start_place_id
//                    self.tableView.mj_header.beginRefreshing()
//                }else {
//                    self.footerView.throughButton.isSelected =  false
//                    self.travelForm.arriveCity = ""
//                    self.travelForm.destId = ""
//                    self.tableView.mj_header.beginRefreshing()
//                }
//            }
//        }
//        KeyWindow?.addSubview(alertView)
//        
//    }
//    
//}



// MARK: searchBar 代理方法
extension TravelLocalListViewController: UITextFieldDelegate {
    
    public func textFieldDidEndEditing(_ textField: UITextField){
        travelForm.searchKey = textField.text
    }
    
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        travelForm = TravelForm.Search(pageIndex: 1, pageSize: 10,searchKey: "")
        travelForm.startCity = startCityLabel.text
        travelForm.arriveCity = startCityLabel.text
        travelForm.destId = self.citys.filter{$0.start_place == startCityLabel.text}.first?.start_place_id
        travelForm.type = "10"
        travelForm.region = self.region
        travelForm.searchKey = textField.text
        tableView.mj_header.beginRefreshing()
        return true
    }
    
    
    
}
// MARK: tableView 代理方法、数据源方法
extension TravelLocalListViewController: UITableViewDataSource, UITableViewDelegate  {
    
    
    func initTableView() {
        //设置tableview
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(TravelListTableViewCell.self, forCellReuseIdentifier: travelListTableViewCellIdentify)
        tableView.register(UINib(nibName: "TableNoDateView", bundle: nil), forHeaderFooterViewReuseIdentifier: "TableNoDateView")
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(38)
        }
        footerView.isLocalTravel = true
        //设置刷选条件view
        self.view.addSubview(footerView)
        footerView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalToSuperview()
        }
        footerView.filterBlock  = { (clickActionEnum,startDate0, startDate1, journeyDayIndex, priceAreaIndex) in
            switch clickActionEnum {
            case .ok:
                self.travelForm.saleDateBegin = ""
                self.travelForm.saleDateEnd = ""
                self.travelForm.dayNumBegin = nil
                self.travelForm.dayNumEnd =   nil
                self.travelForm.saleDateBegin = ""
                self.travelForm.saleDateEnd = ""

                if  startDate0 == nil && startDate1 == nil && journeyDayIndex == 0 && priceAreaIndex == 0 {
                    self.footerView.filterButton.isSelected = false
                    self.tableView.mj_header.beginRefreshing()
                    return
                }
                if startDate0 != nil && startDate1 != nil{
                    let dateBegin = DateInRegion(absoluteDate: startDate0 ?? Date()).string(custom: "yyyy-MM-dd")
                    let dateEnd = DateInRegion(absoluteDate: startDate1 ?? Date()).string(custom: "yyyy-MM-dd")
                    self.travelForm.saleDateBegin = dateBegin
                    self.travelForm.saleDateEnd = dateEnd
                }
                if  journeyDayIndex != 0{
                    switch journeyDayIndex {
                    case 1:
                        self.travelForm.dayNumBegin = 1
                        self.travelForm.dayNumEnd = 1
                    case 2:
                        self.travelForm.dayNumBegin = 2
                        self.travelForm.dayNumEnd = 2
                    case 3:
                        self.travelForm.dayNumBegin = 3
                        self.travelForm.dayNumEnd = nil
                    default:
                        break
                    }
                }
                if  priceAreaIndex != 0{
                    switch priceAreaIndex {
                    case 1:
                        self.travelForm.priceAreaBegin = "0"
                        self.travelForm.priceAreaEnd = "2000"
                    case 2:
                        self.travelForm.priceAreaBegin = "2001"
                        self.travelForm.priceAreaEnd = "5000"
                    case 3:
                        self.travelForm.priceAreaBegin = "5001"
                        self.travelForm.priceAreaEnd = "9999"
                    case 4:
                        self.travelForm.priceAreaBegin = "10000"
                        self.travelForm.priceAreaEnd = "20000"
                    case 5:
                        self.travelForm.priceAreaBegin = "20001"
                        self.travelForm.priceAreaEnd = nil
                    default:
                        break
                    }
                }
                self.footerView.filterButton.isSelected = true
                self.tableView.mj_header.beginRefreshing()
            case .cancel:
               break
            }
            
        }
        
        footerView.priceSortSortBlock = { (sort) in
            switch sort {
            case .priceAsc: //升序
                self.travelForm.orderBy = "5"
                self.tableView.mj_header.beginRefreshing()
            case .priceDesc: //降序
                self.travelForm.orderBy = "6"
                self.tableView.mj_header.beginRefreshing()
            case .priceSort: //
                self.travelForm.orderBy = ""
                self.tableView.mj_header.beginRefreshing()
            }
        }
        
        
        //监听上拉刷新
        tableView.mj_header = MJRefreshNormalHeader{
            self.showLoadingView()
            self.pageIndex += 1
            self.travelForm.pageSize = self.pageSize
            self.travelForm.region = self.region
            self.travelForm.type = "10"
            self.travelForm.pageSize = self.pageSize
            TravelService.sharedInstance.search(self.travelForm).subscribe{ event in
                self.hideLoadingView()
                self.tableView.mj_header.endRefreshing()
                switch event{
                case .next(let e):
                    self.data = e
                    if e.count < self.pageSize {
                        self.tableView.mj_footer.endRefreshingWithNoMoreData()
                        self.tableView.mj_footer.isHidden = self.data?.isEmpty ?? true
                    }else {
                        self.tableView.mj_footer.endRefreshing()
                    }
                    self.tableView.reloadData()
                    
                case .error(let e):
                    try? self.validateHttp(e)
                case .completed:
                    break
                }
                }.addDisposableTo(self.bag)
        }
        //初始化下拉加载
        tableView.mj_footer = MJRefreshAutoNormalFooter{
            self.showLoadingView()
            self.pageIndex += 1
            self.travelForm.pageSize = self.pageSize
            self.travelForm.pageIndex = self.pageIndex
            TravelService.sharedInstance.search(self.travelForm).subscribe{ event in
                self.hideLoadingView()
                switch event{
                case .next(let e):
                    if e.count == 0 {
                        self.tableView.mj_footer.endRefreshingWithNoMoreData()
                    }else {
                        self.tableView.mj_footer.endRefreshing()
                    }
                    self.data! += e
                    self.tableView.reloadData()
                case .error(let e):
                    self.tableView.mj_footer.endRefreshing()
                    try? self.validateHttp(e)
                case .completed:
                    break
                }
                }.addDisposableTo(self.bag)        }
        //在开始隐藏上啦加载更多
        //tableView.mj_footer.isHidden = true
        tableView.mj_header.beginRefreshing()
    }
    

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if (data?.count ?? 0) == 0 {
            return tableView.frame.height
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if (data?.count ?? 0) == 0 {
            if let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableNoDateView") as? TableNoDateView {
                footer.setType(.noData)
                return footer
            }
        }
        return nil
    }
    
    // MARK: 创建cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: travelListTableViewCellIdentify, for: indexPath) as! TravelListTableViewCell
        cell.fillCell(model: data?[indexPath.row])
        return cell
    }
    // MARK: 点击cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = TravelDetailViewController()
        vc.productId = data?[indexPath.row].productId
        vc.travelItem = data?[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: row高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92.5
    }
}
