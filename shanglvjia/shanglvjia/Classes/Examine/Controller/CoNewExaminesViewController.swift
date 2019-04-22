//
//  CoNewExaminesViewController.swift
//  shop
//
//  Created by akrio on 2017/6/9.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import MJRefresh
import RxSwift

class CoNewExaminesViewController: UITableViewController,HttpValidate,LoginValidate {
    
    
    private var approvalResponseList:ApproveListResponseVO = ApproveListResponseVO()
    private var tableViewCellIdentify:String = "tableViewCellIdentify"
    
    let bag = DisposeBag()
    let orderService = CoNewExanimeService.sharedInstance
    var orderState:CoExamineState = CoExamineState.waitApproval
    var data:[CoNewExanimeListItem]?
    
    private var isTableViewEditing: Bool = false
    
    private var isMoreData:Bool = true
    
    private var pageNo:NSInteger = 1
    var index = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CoOrderTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.register(ApproveTableViewCell.self, forCellReuseIdentifier: tableViewCellIdentify)
        self.tableView.separatorStyle = .none //去掉item下方横线
        self.tableView.backgroundColor = TBIThemeMinorColor

        weak var weakSelf = self
        //监听下拉刷新 上啦加载
        tableView.mj_header = MJRefreshNormalHeader{
            weakSelf?.getApproval(isRefesh: true, pageNo: 1)
        }
        //初始化上拉加载
        tableView.mj_footer = MJRefreshAutoNormalFooter{
            weakSelf?.getApproval(isRefesh: false, pageNo: (weakSelf?.pageNo)!)
        }
        //在开始隐藏上啦加载更多
        tableView.mj_footer.isHidden = true
        self.tableView.mj_header.beginRefreshing()
        tableView.register(UINib(nibName: "TableNoDateView", bundle: nil), forHeaderFooterViewReuseIdentifier: "TableNoDateView")
    }
    
    
    func getApproval(isRefesh:Bool,pageNo:NSInteger) {
        
        guard isRefesh == true || approvalResponseList.count  > approvalResponseList.approveListInfoList.count else {
            tableView.mj_footer.endRefreshingWithNoMoreData()
            return
        }
        
        weak var weakSelf = self
       CoNewExanimeService.sharedInstance
        .getApprovalList(pageNo:pageNo,status: (weakSelf?.orderState.rawValue ?? ""))
        .subscribe{ event in
            if isRefesh == true {
                weakSelf?.tableView.mj_header.endRefreshing()
            }else{
                weakSelf?.tableView.mj_footer.endRefreshingWithNoMoreData()
            }
            switch event{
                
                
            case .next(let e):
               printDebugLog(message: e.mj_keyValues())
               weakSelf?.pageNo += 1
               if isRefesh == false {
                weakSelf?.approvalResponseList.approveListInfoList.append(contentsOf: e.approveListInfoList)
               }else {
                weakSelf?.approvalResponseList = e
               }
                weakSelf?.tableView.reloadData()
                //无数据时不显示加载更多
                weakSelf?.tableView.mj_footer.isHidden = self.data?.count == 0
            case .error(let e):
                if !self.islogin(role: companyLogin) {
                    try? self.validateHttp(e)
                }
            case .completed:
                print("finish")
            }
            }.addDisposableTo(self.bag)
    }
    
    
    func adjustTableViewEditModel(isEdit:Bool) {
        isTableViewEditing = isEdit
        tableView.reloadData()
    }
    
    
    
    
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if approvalResponseList.approveListInfoList.count == 0 {
            return tableView.frame.height
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
            var tipMessage:String = ""
            switch orderState {
            case CoExamineState.waitApproval:
                tipMessage = "暂无待审批订单"
            case CoExamineState.agree:
                tipMessage = "暂无通过审批订单"
            case CoExamineState.reject:
                tipMessage = "暂无拒绝审批订单"
            case CoExamineState.unknow:
                tipMessage = "暂无审批订单"
            }
            
            footer.messageLabel.text = tipMessage
            return footer
        }
        return nil
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return approvalResponseList.approveListInfoList.count
        //return data?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ApproveTableViewCell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentify) as! ApproveTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        if isTableViewEditing == true {
            
        }
        
        cell.fillDataSources(dataSources: approvalResponseList.approveListInfoList[indexPath.row], index: indexPath.row, isEdit: false)
        cell.approveTableViewCellSelectedBlock = { isSelected  in
            
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return caculateRowHeight(row: indexPath.row)
    }
    
    
    func caculateRowHeight(row:NSInteger)->CGFloat {
        let rowHeight:NSInteger = 44 + 175 * approvalResponseList.approveListInfoList[row].approveListOrderInfos.count
        return CGFloat(rowHeight)
    }
    
    
    /// 手动刷新数据
    func refresh() {
        self.tableView.mj_header.beginRefreshing()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard approvalResponseList.approveListInfoList.count > indexPath.row else {
            return
        }
        intoNextApprovalDetailView(index:indexPath.row)

    }
    
    func intoNextApprovalDetailView(index:NSInteger) {
        let approvalDetailView = ApprovalOrderDetailViewController()
        approvalDetailView.approvalId = approvalResponseList.approveListInfoList[index].approveNo
        approvalDetailView.orderState =  CoExamineState.init(type:approvalResponseList.approveListInfoList[index].status)
        self.navigationController?.pushViewController(approvalDetailView, animated: true)
        return
    }
    
    
    
    
    //MARK:--------Action-------
    
    
    func backButtonAction(sender:UIButton) {
        
    }
    
    
    func rightButtonAction(sender:UIButton) {
        
    }
    
    
}
