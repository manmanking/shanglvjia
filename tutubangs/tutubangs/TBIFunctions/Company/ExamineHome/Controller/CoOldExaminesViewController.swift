//
//  CoOldExaminesViewController.swift
//  shop
//
//  Created by akrio on 2017/6/9.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import MJRefresh
import RxSwift

class CoOldExaminesViewController: UITableViewController ,HttpValidate,LoginValidate {
    
    let bag = DisposeBag()
    let orderService = CoOldExanimeService.sharedInstance
    var orderState:CoExamineState? = nil
    var data:[CoOldExanimeListItem]?
    var index = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CoOrderTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.tableView.separatorStyle = .none //去掉item下方横线
        self.tableView.backgroundColor = TBIThemeMinorColor
        //监听下拉刷新 上啦加载
        tableView.mj_header = MJRefreshNormalHeader{
            self.index = 0
            let searchForm = CoOldExanimeForm.SearchList(offset: self.index, state: self.orderState)
            self.orderService.search(searchForm).subscribe{ event in
                self.tableView.mj_header.endRefreshing()
                switch event{
                case .next(let e):
                    self.data = e
                    if self.data!.count < searchForm.limit {
                        self.tableView.mj_footer.endRefreshingWithNoMoreData()
                    }else if self.data!.count == searchForm.limit {
                        self.tableView.mj_footer.endRefreshing()
                    }
                    self.tableView.reloadData()
                    //无数据时不显示加载更多
                    self.tableView.mj_footer.isHidden = self.data?.count == 0
                case .error(let e):
                    if !self.islogin(role: companyLogin) {
                        try? self.validateHttp(e)
                    }
                case .completed:
                    print("finish")
                }
                }.addDisposableTo(self.bag)
        }
        //初始化上拉加载
        tableView.mj_footer = MJRefreshAutoNormalFooter{
            self.index += 1
            let searchForm = CoOldExanimeForm.SearchList(offset: self.index, state: self.orderState)
            self.orderService.search(searchForm).subscribe{ event in
                switch event{
                case .next(let e):
                    if e.count == 0 {
                        self.tableView.mj_footer.endRefreshingWithNoMoreData()
                    }
                    self.data! += e
                    self.tableView.mj_footer.endRefreshing()
                    self.tableView.reloadData()
                case .error(let e):
                    self.tableView.mj_footer.endRefreshing()
                    if !self.islogin(role: companyLogin) {
                        try? self.validateHttp(e)
                    }
                case .completed:
                    print("finish")
                }
                }.addDisposableTo(self.bag)
        }

        //在开始隐藏上啦加载更多
        tableView.mj_footer.isHidden = true
        self.tableView.mj_header.beginRefreshing()
        tableView.register(UINib(nibName: "TableNoDateView", bundle: nil), forHeaderFooterViewReuseIdentifier: "TableNoDateView")
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let orders =  self.data {
            if orders.count == 0 {
                return tableView.frame.height
            }
            
        }
        return 0
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tableView.mj_footer.endRefreshing()
        self.tableView.mj_header.endRefreshing()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.data = nil
        self.tableView.reloadData()
        self.tableView.mj_header.beginRefreshing()
        self.tableView.mj_footer.isHidden = true
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableNoDateView") as? TableNoDateView {
            footer.setType(.noApproval)
            return footer
        }
        return nil
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        xxxxCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CoOrderTableViewCell
        guard let order = data?[indexPath.row] else {
            return cell
        }
        cell.flightIconImage.isHighlighted = order.hasFlight
        cell.hotelIconImage.isHighlighted = order.hasHotel
        cell.trainIconImage.isHighlighted = order.hasTrain
        cell.carIconImage.isHighlighted = order.hasCar
        cell.orderNoLabel.text = order.id
        cell.dateLabel.text = order.createTime.string(format: .custom("MM-dd HH:mm:ss"))
        cell.stateLabel.text = order.orderState.description
        cell.stateLabel.textColor = order.orderState.color
        cell.bookUserLabel.text = order.bookerName
        cell.passengersLabel.text = order.pagNames.joined(separator: "、")
        return cell
    }
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let order = data?[indexPath.row] else {
//            return
//        }
//        let approvalController = CoOldApprovalOrderController()
//        approvalController.mBigOrderNOParams = order.id
//        self.navigationController?.pushViewController(approvalController, animated: true)
//    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 144
    }
    /// 手动刷新数据
    func refresh() {
        self.tableView.mj_header.beginRefreshing()
    }
    
}
