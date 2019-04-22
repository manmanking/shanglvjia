//
//  CoExpenseController.swift
//  shop
//
//  Created by TBI on 2018/1/25.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON
import MJRefresh

class CoExpenseController: CompanyBaseViewController,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UISearchControllerDelegate {

    typealias  ExpenseSelectedResult = (QueryPassagerResponse) ->Void
    
    public var expenseSelectedResult:ExpenseSelectedResult!
    
    private let hotelCompanyStaffTableViewCellSecondIdentify = "hotelCompanyStaffTableViewCellSecondIdentify"
    private var searchBar:TBISearchBar = TBISearchBar()
    private var tableView:UITableView = UITableView()
    
    /// 乘车人
    private var tableViewDataSourcesArr:[QueryPassagerResponse] = Array()
    //是否收起 1是收起  记录选中的 个数
    private var selectedStaffShowNum:NSInteger = 0
    
    private var nextButton:UIButton = UIButton()
    
    private let bag = DisposeBag()
   
    fileprivate var pageIndex:Int = 1

    fileprivate var pageSize:Int = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBlackTitleAndNavigationColor(title:"选择报销人")
        //模拟数据
        // simulabteData()
        searchBar.placeholder = "请输入员工姓氏或全名"
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

        
        if #available(iOS 11.0, *) {
            searchBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
            if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
                if let backgroundview = textfield.subviews.first {

                    // Background color
                    backgroundview.backgroundColor = TBIThemeBaseColor

                    // Rounded corner
                    backgroundview.layer.cornerRadius = 5;
                    backgroundview.clipsToBounds = true;

                }
            }

        }
        
        //tableViewDataSourcesArr = PassengerManager.shareInStance.passengerSVDraw()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = TBIThemeBaseColor
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.register(HotelCompanyStaffTableViewSecondCell.classForCoder(), forCellReuseIdentifier: hotelCompanyStaffTableViewCellSecondIdentify)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
            
        }

        weak var weakSelf = self
        //监听上拉刷新
        tableView.mj_header = MJRefreshNormalHeader{
            weakSelf?.showLoadingView()
            weakSelf?.pageIndex = 1
            weakSelf?.getPassenger(keyword: "", pageIndex: (weakSelf?.pageIndex)!)
//            HotelCompanyService.sharedInstance
//                .getPageTravellerList(qname: weakSelf?.searchBar.text ?? "", pageSize: self.pageSize, pageIndex: self.pageIndex)
//                .subscribe { (result) in
//                    weakSelf?.tableView.mj_header.endRefreshing()
//                    weakSelf?.hideLoadingView()
//                    if case .next(let result) = result {
//                        weakSelf?.tableViewDataSourcesArr = result
//                        if result.count < self.pageSize {
//                            weakSelf?.tableView.mj_footer.endRefreshingWithNoMoreData()
//                            weakSelf?.tableView.mj_footer.isHidden = result.isEmpty ?? true
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
            weakSelf?.showLoadingView()
            weakSelf?.pageIndex += 1
            weakSelf?.getPassenger(keyword: "", pageIndex: (weakSelf?.pageIndex)!)
//            self.showLoadingView()
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
        
    }
    //MARK:-----------NET-------------
    
    func getPassenger(keyword:String,pageIndex:NSInteger) {
        var page:NSInteger = 1
        if pageIndex >= 1 {
            page = pageIndex
        }
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
                        self.tableView.mj_footer.endRefreshingWithNoMoreData()
                    }else {
                        self.tableView.mj_footer.endRefreshing()
                    }
                    if weakSelf?.pageIndex == 1 {
                        self.tableViewDataSourcesArr.removeAll()
                    }
                    self.tableViewDataSourcesArr += element
                    weakSelf?.tableView.reloadData()
                case .error(let error):
                    try? weakSelf?.validateHttp(error)
                case .completed:
                    break
                }
        }
        
        
    }
   
    //MARK:------UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewDataSourcesArr.count
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 115
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:HotelCompanyStaffTableViewSecondCell = tableView.dequeueReusableCell(withIdentifier: hotelCompanyStaffTableViewCellSecondIdentify) as! HotelCompanyStaffTableViewSecondCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.hotelCompanyStaffSelected = { _ in }
        //cell.fillDataSources( traveller: tableViewDataSourcesArr[indexPath.row])
        cell.fillDataSources(traveller: tableViewDataSourcesArr[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        expenseSelectedResult(tableViewDataSourcesArr[indexPath.row])
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:-------UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        let keyWord:String = searchBar.text ?? ""
        getPassenger(keyword:keyWord , pageIndex: 1)
        //tableView.mj_header.beginRefreshing()
//        showLoadingView()
//        weak var weakSelf = self
//        HotelCompanyService.sharedInstance
//            .getTravellerList(uid: searchBar.text!)
//            .subscribe { (result) in
//                weakSelf?.hideLoadingView()
//                if case .next(let result) = result {
//                    weakSelf?.tableViewDataSourcesArr = result
//                    weakSelf?.tableView.reloadData()
//                }
//                if case .error(let result) = result {
//                    try? weakSelf?.validateHttp(result)
//                }
//            }.disposed(by: bag)
        
    }
    
    
    override func backButtonAction(sender: UIButton) {
        searchBar.resignFirstResponder()
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
 

    
}
