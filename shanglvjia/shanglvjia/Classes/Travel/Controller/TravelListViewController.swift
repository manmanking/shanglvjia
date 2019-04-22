//
//  TravelListViewController.swift
//  shop
//
//  Created by TBI on 2017/6/3.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import MJRefresh
import RxSwift
import SwiftDate

class TravelListViewController: CompanyBaseViewController {

    fileprivate let bag = DisposeBag()
    
    fileprivate let searchTextField = UITextField(placeholder: "关键字/目的地",fontSize: 13)
    
    lazy var searchBar: UIView = {
        let vi = UIView()
        let img = UIImageView.init(imageName: "searchBarFlag")
        //let label = UILabel(text: "关键字/目的地", color: TBIThemePlaceholderLabelColor, size: 13)
        vi.addSubview(img)
        vi.addSubview(self.searchTextField)
        img.snp.makeConstraints{ (make) in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(12)
        }
        self.searchTextField.snp.makeConstraints{ (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(img.snp.right).offset(5)
        }
        return vi
    }()
    
    let travelListTableViewCellIdentify = "travelListTableViewCellIdentify"
    
    let cityButton = UIButton()
    
    let startCityLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 13)
    
    
    let tableView: UITableView = UITableView()
    
    let footerView: TravelFooterView = TravelFooterView()
    
    fileprivate var offsetY:CGFloat = 0
    
    fileprivate var data:[TravelListItem]?
    
    fileprivate var citys:[CitsCitys]?
    
    fileprivate var rightBarView: UIView = {
        let vi = UIView()
        let img = UIImageView(imageName: "ic_customization")
        let textLabel = UILabel(text: "定制", color: TBIThemeWhite, size: 13)
        vi.addSubview(img)
        vi.addSubview(textLabel)
        textLabel.snp.makeConstraints{ (make) in
            make.centerY.equalToSuperview()
            make.width.equalTo(30)
            make.right.equalTo(-4)
        }
        img.snp.makeConstraints{ (make) in
            make.centerY.equalToSuperview()
            make.width.equalTo(12)
            make.right.equalTo(textLabel.snp.left).offset(-5)
        }
        return vi
    }()
    
    
    lazy var searchBarView: UIView = {
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
    
    var bakTravelForm = TravelForm.Search(pageIndex: 1, pageSize: 20,searchKey: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if cityName == "北京"{
            self.startCityLabel.text = "北京出发"
        }else {
            self.startCityLabel.text = "天津出发"
        }
        setNavigationBackButton(backImage: "")

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


extension TravelListViewController {
    
    func initView(){
        
        //设置搜索栏值
        self.searchTextField.text = travelForm.searchKey
        
        //设置header
        cityButton.setImage(UIImage(named: "ic_down"), for: UIControlState.normal)
        
        let line = UILabel(color: TBIThemeGrayLineColor)
        
        let vi = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWindowWidth - 36, height: 44))
        
        vi.addSubview(rightBarView)
        rightBarView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(0)
            make.height.equalTo(44)
            make.width.equalTo(63)
        }
        
        vi.addSubview(searchBarView)
        searchBarView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(4)
            make.centerY.equalToSuperview()
            make.height.equalTo(32)
            make.right.equalTo(rightBarView.snp.left)
        }
        
        searchBarView.addSubview(startCityLabel)
        startCityLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.centerY.equalToSuperview()
        }
        searchBarView.addSubview(cityButton)
        
        cityButton.snp.makeConstraints { (make) in
            make.height.equalTo(6)
            make.width.equalTo(8)
            make.centerY.equalToSuperview()
            make.left.equalTo(startCityLabel.snp.right).offset(5)
        }
        searchBarView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.height.equalTo(22)
            make.width.equalTo(1)
            make.centerY.equalToSuperview()
            make.left.equalTo(cityButton.snp.right).offset(5)
        }
        
        searchBarView.addSubview(searchBar)
        searchBar.snp.makeConstraints { (make) in
            make.left.equalTo(line.snp.right).offset(5)
            make.top.bottom.right.equalToSuperview()
        }
        
        self.navigationItem.titleView = vi
        startCityLabel.addOnClickListener(target: self, action: #selector(cityClick))
        rightBarView.addOnClickListener(target: self, action: #selector(rightItemClick))
        initTableView()
        
        searchBar.addOnClickListener(target: self, action: #selector(searchBarClick(tap:)))
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
        let titleArr:[String] = ["北京出发"]//["天津出发","北京出发"]
        let roleView = TBIFinderView.init(frame: ScreenWindowFrame)
        roleView.finderViewSelectedResultBlock = { (cellIndex) in
//            if cellIndex == 0 {
//                cityName = "天津"
//                self.startCityLabel.text = "天津出发"
//            }else {
//                cityName = "北京"
//                self.startCityLabel.text = "北京出发"
//            }
            cityName = "北京"
            self.startCityLabel.text = "北京出发"
            self.navigationController?.pushViewController(TravelDestinationViewController(), animated: true)
//            self.footerView.initButtonSelected()
//            self.travelForm = self.bakTravelForm
//            self.travelForm.startCity = cityName
//            self.tableView.mj_header.beginRefreshing()
        }
        KeyWindow?.addSubview(roleView)
        roleView.reloadDataSources(titledataSources: titleArr, flageImage: nil)
        
    }
    
}
extension TravelListViewController {
    
    /// 初始化数据
    func initThroughCityData () {
        let cityModel = DestinationsModel(type: travelForm.type ?? "6", departure: cityName, destId:"",keyWord: travelForm.searchKey ?? "")
        showLoadingView()
        CitsService.sharedInstance.getDestinations(form: cityModel).subscribe{ event in
            self.hideLoadingView()
            if case .next(let e) = event {
                if !e.isEmpty {
                    self.citys = e
                    var dataSourceArray:[(String,[String])] = [("全部",["全部"])]
                    //if self.travelForm.region == TravelForm.Search.Region.inland.rawValue{//国内
                        let city = e.first?.citys
                        for index in 0..<(city?.count ?? 0){
                            let citysList = city?[index].citys.reduce(["不限"]){$0 + [($1.name ?? "")]}
                            dataSourceArray.append((city?[index].name ?? "",citysList!))
                        }
//                    }else {
//                        for index in 0..<e.count{
//                            let city = e.first?.citys
//                            for index in 0..<(city?.count ?? 0){
//                                let citysList = city?[index].citys.reduce(["不限"]){$0 + [($1.name ?? "")]}
//                                dataSourceArray.append((city?[index].name ?? "",citysList!))
//                            }
//                            let citysList = e[index].citys.reduce(["不限"]){$0 + [($1.name ?? "")]}
//                            dataSourceArray.append((e[index].name ?? "",citysList))
//                        }
//                    }
                    self.alertThroughView(data:dataSourceArray)
                }
            }
            if case .error(let e) = event {
                try? self.validateHttp(e)
            }
            }.disposed(by: bag)
        
    }
    
    func  alertThroughView (data:[(String,[String])]){
        /**
         传递的参数:
         viewController:UIViewController   当前的ViewController
         dataSourceArray:[(String,[String])] -  [(左侧标题,[右侧内容item])]
         -----
         回调
         clickActionEnum -  按钮🔘点击的动作：取消和确定
         leftIndex       -  左侧的索引值
         rightIndex      -  右侧的索引值
         */
        let alertView = TravelPassPlaceFilterView.getInstance(viewController: self, dataSourceArray: data) { (clickActionEnum, leftIndex, rightIndex) in
            switch clickActionEnum {
                
            case .cancel:
                break
            case .ok:
                if leftIndex != 0 && rightIndex != 0 {
                    self.footerView.throughButton.isSelected =  true
//                    if self.travelForm.region == TravelForm.Search.Region.inland.rawValue{//国内
//                        let city = self.citys?.first?.citys[leftIndex-1].citys[rightIndex-1]
//                        self.travelForm.arriveCity = city?.name
//                        self.travelForm.destId = city?.code
//                        self.tableView.mj_header.beginRefreshing()
//                    }else {
//                        let city = self.citys?[leftIndex-1].citys[rightIndex-1]
//                        self.travelForm.arriveCity = city?.child_names
//                        self.travelForm.destId = city?.child_codes
//                        self.tableView.mj_header.beginRefreshing()
//                    }
                    let city = self.citys?.first?.citys[leftIndex-1].citys[rightIndex-1]
                    self.travelForm.arriveCity = city?.name
                    self.travelForm.destId = city?.code
                    self.tableView.mj_header.beginRefreshing()
                }else {
                    self.footerView.throughButton.isSelected =  false
                    self.travelForm.arriveCity = ""
                    self.travelForm.destId = ""
                    self.tableView.mj_header.beginRefreshing()
                }
            }

        }
        KeyWindow?.addSubview(alertView)

    }
    
}

// MARK: tableView 代理方法、数据源方法
extension TravelListViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func initTableView() {
        //设置tableview
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(TravelListTableViewCell.self, forCellReuseIdentifier: travelListTableViewCellIdentify)
        tableView.register(UINib(nibName: "TableNoDateView", bundle: nil), forHeaderFooterViewReuseIdentifier: "TableNoDateView")
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
        footerView.isLocalTravel = false
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
                //  没有过滤条件
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
                        self.travelForm.dayNumEnd = 5
                    case 2:
                        self.travelForm.dayNumBegin = 6
                        self.travelForm.dayNumEnd = 8
                    case 3:
                        self.travelForm.dayNumBegin = 9
                        self.travelForm.dayNumEnd = 10
                    case 3:
                        self.travelForm.dayNumBegin = 11
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
        
        //途经地
        footerView.throughBlock = { (data) in
            self.initThroughCityData()
            
        }
        //监听上拉刷新
        tableView.mj_header = MJRefreshNormalHeader{
            self.showLoadingView()
            self.pageIndex = 1
            self.travelForm.pageIndex = self.pageIndex
            self.travelForm.pageSize = self.pageSize
            TravelService.sharedInstance.search(self.travelForm).subscribe{ event in
                self.tableView.mj_header.endRefreshing()
                self.hideLoadingView()
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
       cell.selectionStyle = .none
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



