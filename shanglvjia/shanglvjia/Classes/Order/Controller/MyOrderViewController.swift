//
//  MyOrderViewController.swift
//  shanglvjia
//
//  Created by tbi on 2018/5/8.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import MJRefresh


class MyOrderViewController: CompanyBaseViewController {    
    
    var page : Int = 1
//    let bag = DisposeBag()
   
    var stateStr = String()
    var stateStrNum = String()
    var orderArr = [MyOrderModel.orderInfo]()
    var orderModel = MyOrderModel()

//    private var tableItems = NSMutableArray()
    
    var orderTable = UITableView()
    
 
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

         stateStrNum = stateStr == "计划中" ? "1" : stateStr == "审批中" ? "2" : stateStr == "待订妥" ? "3" : stateStr == "已订妥" ? "4" :"0"
        initTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(initData), name: NSNotification.Name.init("orderRefreshListNotificationKey"), object: nil)
        
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        printDebugLog(message: "into here ...")
        printDebugLog(message:stateStr )
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func initTableView() {
        orderTable.frame=CGRect(x:0,y:0,width:Int(ScreenWindowWidth),height:Int(ScreentWindowHeight)-kNavigationHeight-45)
        orderTable.dataSource=self
        orderTable.delegate=self
        orderTable.separatorStyle=UITableViewCellSeparatorStyle.none
        // 设置预估行高 --> 先让 tableView 能滚动，在滚动的时候再去计算显示的 cell 的真正的行高，并且调整 tabelView 的滚动范围
        orderTable.estimatedRowHeight = 210
        orderTable.rowHeight = UITableViewAutomaticDimension
        orderTable.register(MyOrderCell.self, forCellReuseIdentifier: "MyOrderCell")
        orderTable.register(UINib(nibName: "TableNoDateView", bundle: nil), forHeaderFooterViewReuseIdentifier: "TableNoDateView")
        self.view.addSubview(orderTable)
        
        orderTable.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(MyOrderViewController.initData))
        orderTable.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(MyOrderViewController.loadMoreData))
        orderTable.mj_header.beginRefreshing()

    
    }

    func initData()  {
       
        weak var weakSelf = self
        page = 1;
      weakSelf?.getOrderRequest(orderStatus: stateStrNum, pageNo: page)
//        weakSelf?.orderTable.mj_header.endRefreshing()
//        weakSelf?.perform(#selector(weakSelf?.hideLoadingView), with: weakSelf, afterDelay: 1.0)
    }
    func loadMoreData() {
        
        weak var weakSelf = self
        page  = page + 1
        weakSelf?.getOrderRequest(orderStatus: stateStrNum, pageNo: page)

    }
    //MARK:-----------NET-------------
    func getOrderRequest(orderStatus:String,pageNo:Int)  {
        weak var weakSelf = self
        weakSelf?.showLoadingView()
        _ = MyOrderListService.sharedInstance
            .getOrderList(pageNo: pageNo, orderStatus: orderStatus)
            .subscribe{(event) in
                weakSelf?.hideLoadingView()
                weakSelf?.orderTable.mj_header.endRefreshing()
            
            switch event {
            case .next(let element):
                printDebugLog(message: element.mj_keyValues())
//                printDebugLog(message: element.first?.mj_keyValues())
                if element.orderInfos.count == 0 {
                    weakSelf?.orderTable.mj_footer.endRefreshingWithNoMoreData()
                }else {
                    weakSelf?.orderTable.mj_footer.endRefreshing()
                }
                if pageNo == 1 {
                    weakSelf?.orderArr.removeAll()
                }
                weakSelf?.orderModel=element

                for orderInf in (weakSelf?.orderModel.orderInfos)!
                {
                     weakSelf?.orderArr.append(orderInf)
                }
                
                weakSelf?.orderTable.reloadData()
            case .error(let error):
                weakSelf?.hideLoadingView()
                try? weakSelf?.validateHttp(error)
            case .completed:
                break
            
            }
        }
    }

}
extension MyOrderViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return orderArr.count;
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MyOrderCell  = tableView.dequeueReusableCell(withIdentifier: "MyOrderCell") as! MyOrderCell
        cell.setCellWithModel(model: orderArr[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        let titleH = CommonTool.contentHeight(orderArr[indexPath.row].orderTitle, withWidth: Float(ScreenWindowWidth-125), withFont: 15)
        return 200 + (titleH > 20 ? 20 : 0)
//        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if orderArr.count == 0
        {
            return tableView.frame.height
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableNoDateView") as? TableNoDateView {
            footer.setType(.noNewOrder)
            
            footer.messageLabel.text="暂无" + stateStr + "订单"
            return footer
        }
        return nil
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if orderArr[indexPath.row].orderType == "1" || orderArr[indexPath.row].orderType == "3" {
            let orderDetail = FlightOrderDetaileViewController()
            orderDetail.orderNumber = orderArr[indexPath.row].orderNo
            orderDetail.orderTy = orderArr[indexPath.row].orderType
            orderDetail.orderSts = orderArr[indexPath.row].orderState
            self.navigationController?.pushViewController(orderDetail, animated: true)
        }else{
            let orderDetail = HotelViewController()
            orderDetail.orderNumber = orderArr[indexPath.row].orderNo
            orderDetail.orderTy = orderArr[indexPath.row].orderType
            orderDetail.orderSts = orderArr[indexPath.row].orderState
            self.navigationController?.pushViewController(orderDetail, animated: true)
        }
        
    }
}
