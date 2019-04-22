//
//  UnpayOrdersControllerViewController.swift
//  shop
//
//  Created by akrio on 2017/7/22.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import MJRefresh
import RxSwift

class UnpayOrdersControllerViewController : CompanyBaseViewController, UITableViewDelegate, UITableViewDataSource {
    let bag = DisposeBag()
    let orderService = OrderService.sharedInstance
    var data:[OrderListItem]?
    var index = 1
    let tableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.snp.makeConstraints{  make in
            make.bottom.top.leading.trailing.equalTo(self.view)
        }
        self.setNavigationBackButton(backImage: "back")
        self.setTitle(titleStr: "未支付订单")

        tableView.register(UINib(nibName: "CoOrderTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.tableView.separatorStyle = .none //去掉item下方横线
        self.tableView.backgroundColor = TBIThemeMinorColor
        //监听下拉刷新 上啦加载
        tableView.mj_header = MJRefreshNormalHeader{
            self.index = 1
            let searchForm = OrderSearchForm(pageIndex: self.index,orderStatus:.unpay)
            self.orderService.search(searchForm).subscribe{ event in
                self.tableView.mj_header.endRefreshing()
                switch event{
                case .next(let e):
                    self.data = e
                    if self.data!.count < searchForm.pageSize {
                        self.tableView.mj_footer.endRefreshingWithNoMoreData()
                    }
                    self.tableView.reloadData()
                    //无数据时不显示加载更多
                    self.tableView.mj_footer.isHidden = self.data?.count == 0
                case .error(let e):
                    try? self.validateHttp(e)
                case .completed:
                    print("finish")
                }
                }.addDisposableTo(self.bag)
        }
        //初始化上拉加载
        tableView.mj_footer = MJRefreshAutoNormalFooter{
            self.index += 1
            let searchForm = OrderSearchForm(pageIndex: self.index,orderStatus:.unpay)
            self.orderService.search(searchForm).subscribe{ event in
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
                    print("finish")
                }
                }.addDisposableTo(self.bag)
        }
        //在开始隐藏上啦加载更多
        tableView.mj_footer.isHidden = true
        self.tableView.mj_header.beginRefreshing()
        tableView.register(UINib(nibName: "TableNoDateView", bundle: nil), forHeaderFooterViewReuseIdentifier: "TableNoDateView")
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
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let orders =  self.data {
            if orders.count == 0 {
                return tableView.frame.height
            }
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableNoDateView") as? TableNoDateView {
            footer.setType(.noOrder)
            return footer
        }
        return nil
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = OrderListTableViewCell()
        // Configure the cell...
        if let cellData = data?[indexPath.row] {
            cell.typeLabel.text = cellData.commodityName
            cell.statusLabel.text = cellData.orderStatus.description
            cell.nameLabel.text = cellData.orderTitle
            cell.descriptionLabel.text = cellData.orderDescribe1
            cell.priceLabel.text = "￥\(cellData.totalAmount)"
            cell.clickCallback = {
                self.tableView(tableView, didSelectRowAt:indexPath)
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cellData = data?[indexPath.row] {
            if (cellData.commodity == 1) {
                let orderDetailController = PFlightOrderDetailsController()
                orderDetailController.flightOrderNO = cellData.orderNo
                self.navigationController?.pushViewController(orderDetailController, animated: true)
            } else if cellData.commodity == 2 {
                let orderDetailController = PHotelOrderDetailsController()
                orderDetailController.hotelOrderNO = cellData.orderNo
                self.navigationController?.pushViewController(orderDetailController, animated: true)
            }else if cellData.commodity == 3 || cellData.commodity == 4 || cellData.commodity == 5 {
                let orderDetailController = PTravelOrderDetailsController()
                orderDetailController.mTravelOrderNo = cellData.orderNo
                self.navigationController?.pushViewController(orderDetailController, animated: true)
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 187.5
    }
    override func backButtonAction(sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
