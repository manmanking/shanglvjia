//
//  FlightOrderDetaileViewController.swift
//  shanglvjia
//
//  Created by tbi on 2018/5/9.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class FlightOrderDetaileViewController: CompanyBaseViewController {

    //101计划中102待订妥103已订妥104已取消110审批中
    
    var orderNumber = String()
    var orderTy = String()
    var orderSts = String()
    
    fileprivate var flightPriceInfoView:PriceInfoTableView?
    
    var detailTable = UITableView()
    //基本信息
    var oneRow = [["title":"基本信息","content":"xxx"]]
    var orderModel = OrderDetailModel()
    //乘机人
    var towRow = [OrderDetailModel.passenger]()
    //联系人
    var threeRow = [["title":"xxx","content":"xxx"]]
    //保险
    var suransArr = [OrderDetailModel.passenger.surance]()
    //申请单
    var travelArr = [["title":"xxx","content":"xxx"]]
    //审批记录
    var approveArr = [OrderDetailModel.approve]()
    //修改记录
    var requirArr = [OrderDetailModel.require]()
    //区头信息
    var sectionArr = [String]()
    //价格明细
    var priceArr = NSMutableArray()
    var tuigaiArr = [OrderDetailModel.passenger]()
    
    var tuiNum : Int = 0
    var approveNum : Int = 0
    var travelNum : Int = 0
    var requireNum : Int = 0
    var approveBool : Bool = false
    var travelBool : Bool = false
    var requireBool : Bool = false
    
    lazy var orderDetailFooterView:OrderDetailFooterView = OrderDetailFooterView()
   
    let bgView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor=TBIThemeWhite
        // Do any additional setup after loading the view.
        sectionArr = orderTy == "1" ? ["基本信息","","乘机人","联系人","申请单","审批记录","修改记录"] : ["基本信息","","乘车人","联系人","申请单","审批记录","修改记录"]
        
        initTableView()
        setNavigationImage()
        setTitleView()
        
        getOrderDetailRequest()
        
        initFooterView()
       
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setNavigationImage() {
        self.navigationController?.navigationBar.isTranslucent = false
     
        
    }
    func setTitleView() {
        let str = orderTy == "1" ? "机票详情" : orderTy == "2" ? "酒店详情" : orderTy == "3" ? "火车票详情" : "专车详情"
        setBlackTitleAndNavigationColor(title:str)
        /// 新版订单更新
        setNavigationBackButton(backImage: "left")
        
    }
    
    override func backButtonAction(sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
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
        detailTable.frame=CGRect(x:0,y:0,width:Int(ScreenWindowWidth),height:Int(ScreentWindowHeight)-kNavigationHeight-54)
        detailTable.dataSource=self
        detailTable.delegate=self
        detailTable.separatorStyle=UITableViewCellSeparatorStyle.none
        // 设置预估行高 --> 先让 tableView 能滚动，在滚动的时候再去计算显示的 cell 的真正的行高，并且调整 tabelView 的滚动范围
        detailTable.estimatedRowHeight = 200
        detailTable.rowHeight = UITableViewAutomaticDimension
        detailTable.register(OrderDetailTitleCell.self, forCellReuseIdentifier: "OrderDetailTitleCell")
        detailTable.register(OrderDetailLabelCell.self, forCellReuseIdentifier: "OrderDetailLabelCell")
        detailTable.register(OrderStatusCell.self, forCellReuseIdentifier: "OrderStatusCell")
        detailTable.register(OrderPsgerCell.self, forCellReuseIdentifier: "OrderPsgerCell")
        detailTable.register(OrderRecordCell.self, forCellReuseIdentifier: "OrderRecordCell")
        detailTable.register(OrderFlightTuiCell.self, forCellReuseIdentifier: "OrderFlightTuiCell")
        detailTable.register(OrderFlightCell.self, forCellReuseIdentifier: "OrderFlightCell")
        detailTable.register(OrderTrainCell.self, forCellReuseIdentifier: "OrderTrainCell")
        //给TableView添加表头页尾
        let footerView:UIView = UIView(frame:
            CGRect(x:0, y:0, width:detailTable.frame.size.width, height:15))
        footerView.backgroundColor=TBIThemeWhite
        detailTable.tableFooterView = footerView
        
        self.view.addSubview(detailTable)
    }
    func getOrderDetailRequest() {
        weak var weakSelf = self
        weakSelf?.showLoadingView()
        _ = MyOrderDetailService.sharedInstance
            .getFlightDetailBy(orderNo: orderNumber,orderType: orderTy)
            .subscribe{(event) in
                weakSelf?.hideLoadingView()
              
                switch event {
                case .next(let element):
//                    printDebugLog(message: element.mj_keyValues())
                    weakSelf?.orderModel=element
                     weakSelf?.orderSts = (weakSelf?.orderModel.statusCH == "计划中" ? "1" : weakSelf?.orderModel.statusCH == "审批中" ? "2" : weakSelf?.orderModel.statusCH == "待订妥" ? "3" : weakSelf?.orderModel.statusCH == "已订妥" ? "4" : "5")
                    
                    weakSelf?.oneRow.removeAll()
                    weakSelf?.oneRow.append( ["title":"订单单号","content":(weakSelf?.orderModel.orderNo)!])
                    if (weakSelf?.orderModel.createTime)!.isNotEmpty
                    {
                        weakSelf?.oneRow.append(["title":"创建时间","content":(weakSelf?.orderModel.createTime)!.components(separatedBy: " ")[0]])
                    }
                    if (weakSelf?.orderModel.costCenter)!.isNotEmpty
                    {
                       weakSelf?.oneRow.append(["title":"成本中心","content":(weakSelf?.orderModel.costCenter)!])
                    }
                    weakSelf?.oneRow.append(["title":"预订人","content":(weakSelf?.orderModel.orderName)!])
                    if weakSelf?.orderTy == "1"
                    {
                        weakSelf?.oneRow.append(["title":"差旅标准","content":(weakSelf?.orderModel.accordPolicy) == "0" ? "符合" : "违背  " + (weakSelf?.orderModel.disPolicyReason)!])
                    }else{
                        weakSelf?.oneRow.append(["title":"差旅标准","content":(weakSelf?.orderModel.accordPolicy) == "1" ? "符合" : "违背  " + (weakSelf?.orderModel.disPolicyReason)!])
                    }
                    

                    weakSelf?.towRow.removeAll()
                    for passger in (weakSelf?.orderModel.passengers)!
                    {
                        weakSelf?.towRow.append(passger)
                       
                        for surance in (passger.surances)
                        {
                            weakSelf?.suransArr.append(surance)
                        }
                    }
                    
                    weakSelf?.threeRow.removeAll()
                    if (weakSelf?.orderModel.contactName.isNotEmpty)!
                    {
                        weakSelf?.threeRow.append( ["title":"姓名","content":(weakSelf?.orderModel.contactName)!])
                    }
                    if (weakSelf?.orderModel.contactPhone .isNotEmpty)!
                    {
                        weakSelf?.threeRow.append( ["title":"手机号码","content":(weakSelf?.orderModel.contactPhone)!])
                    }
                    if (weakSelf?.orderModel.contactEmail.isNotEmpty)!
                    {
                        weakSelf?.threeRow.append( ["title":"邮箱","content":(weakSelf?.orderModel.contactEmail)!])
                    }
                    var nameArr = [String]()
                    for i in 0...(weakSelf?.towRow.count)!-1{
                        nameArr.append((weakSelf?.towRow[i].psgName)!)
                    }
                    //出差单
                    weakSelf?.travelArr.removeAll()
                    
                    weakSelf?.travelArr.append( ["title":"出差人","content":nameArr.joined(separator: ",")])
                   
                    if (weakSelf?.orderModel.travel?.startTime.isNotEmpty)!
                    {
                         weakSelf?.travelArr.append( ["title":"出差时间","content":(weakSelf?.orderModel.travel?.startTime)!+"至"+(weakSelf?.orderModel.travel?.endTime)!])
                    }
                    if (weakSelf?.orderModel.travel?.address.isNotEmpty)!
                    {
                        weakSelf?.travelArr.append( ["title":"出差地点","content":(weakSelf?.orderModel.travel?.address)!])
                    }
                    if (weakSelf?.orderModel.travel?.target.isNotEmpty)!
                    {
                         weakSelf?.travelArr.append( ["title":"出差目的","content":(weakSelf?.orderModel.travel?.target)!])
                    }
                    if (weakSelf?.orderModel.travel?.reason.isNotEmpty)!
                    {
                        weakSelf?.travelArr.append( ["title":"出差事由","content":(weakSelf?.orderModel.travel?.reason)!])
                    }
                    weakSelf?.travelNum = (weakSelf?.travelArr.count)!
                    
                    //审批
                    for approve in (weakSelf?.orderModel.approves)!{
                        weakSelf?.approveArr.append(approve)
                    }
                    weakSelf?.approveNum = (weakSelf?.approveArr.count)!
                    //修改记录
                    for requirItem in (weakSelf?.orderModel.requires)!
                    {
                        weakSelf?.requirArr.append(requirItem)
                    }
                    weakSelf?.requireNum = (weakSelf?.requirArr.count)!
                    
                    //总价钱
                    weakSelf?.orderDetailFooterView.priceCountLabel.text =  weakSelf?.orderModel.money
                   
                    
                    //价格明细 火车
                    if(weakSelf?.orderTy == "3")
                    {
                        if (weakSelf?.priceArr.count == 0)
                        {
                            
                            //火车 如果是退票 显示退票费 否则显示买票的钱
                            for i in 0...(weakSelf?.orderModel.passengers.count)!-1
                            {
                                let model = OrderDetailModel()
                                if(weakSelf?.orderSts == "5")
                                {
                                    model.date = "退票费" + "(\(weakSelf!.orderModel.passengers[i].psgName))"
                                    model.memberRate=(weakSelf?.orderModel.passengers[i].refundAmount)!
                                }else{
                                    if((weakSelf?.orderModel.passengers[i].refundStatus)! == "0")
                                    {
                                        //未退票
                                        model.date = (weakSelf?.orderModel.passengers[i].siteCodeCH)! + "(\(weakSelf!.orderModel.passengers[i].psgName))"
                                        model.memberRate=(weakSelf?.orderModel.passengers[i].money)!
                                    }else{
                                        weakSelf?.tuiNum += 1
                                        //已退票
                                        model.date = "退票费" + "(\(weakSelf!.orderModel.passengers[i].psgName))"
                                        model.memberRate=(weakSelf?.orderModel.passengers[i].refundAmount)!
                                    }
                                    
                                }
                                weakSelf?.priceArr.add(model)
                            }
                            for i in 0...(weakSelf?.orderModel.passengers.count)!-1
                            {
                                //手续费
                                if (weakSelf?.orderModel.passengers[i].poundage)! != "0"
                                {
                                    let model = OrderDetailModel()
                                    model.date = "手续费" + "(\(weakSelf!.orderModel.passengers[i].psgName))"
                                    model.memberRate=(weakSelf?.orderModel.passengers[i].poundage)!
                                    weakSelf?.priceArr.add(model)
                                }
                            }
                            
                        }
                       
                    }
                    //价格明细 飞机
                    if(weakSelf?.orderTy == "1")
                    {
                        if (weakSelf?.priceArr.count == 0)
                        {
                            for i in 0...(weakSelf?.orderModel.passengers.count)!-1
                            {
                                ////如果type==0 即正常状态下 0普通1退票单2改签单3改签退票单4取消单
                                if(weakSelf?.orderModel.passengers[i].type != "0")
                                {
                                    weakSelf?.tuigaiArr.append((weakSelf?.orderModel.passengers[i])!)
                                }
                                
                            }
                            //weakSelf?.tuigaiArr.count==0 说明没有退改的航班
                            if(weakSelf?.tuigaiArr.count==0)
                            {
                                //                            var nameArr = ["机票","机建","保险"]
                                //                            var moneyArr = [weakSelf?.towRow[0].unitFare,weakSelf?.towRow[0].ocTax,"20"]
                                //                            var peopleArr  = [" x \(String(weakSelf!.towRow.count))人"," x \(String(weakSelf!.towRow.count))人"," x \(String(weakSelf!.suransArr.count))份"]
                                //                            //判断有无保险
                                //                            if (weakSelf?.suransArr.count == 0)
                                //                            {
                                //                                nameArr=["机票","机建"]
                                //                                moneyArr = [weakSelf?.towRow[0].unitFare,weakSelf?.towRow[0].ocTax]
                                //                                peopleArr = [" x \(String( weakSelf!.towRow.count))人"," x \(String(weakSelf!.towRow.count))人"]
                                //                            }
                                //
                                //                            for i in 0...nameArr.count-1
                                //                            {
                                //                                let model = OrderDetailModel()
                                //                                model.date = nameArr[i]
                                //                                model.memberRate = moneyArr[i]!
                                //                                weakSelf?.priceArr.add(model)
                                //                            }
                                for i in 0...(weakSelf?.towRow.count)!-1
                                {
                                    var nameArr = ["机票(\(String(describing: weakSelf!.towRow[i].psgName)))","机建(\(String(describing: weakSelf!.towRow[i].psgName)))"]
                                    var moneyArr = [weakSelf?.towRow[i].unitFare,weakSelf?.towRow[i].ocTax]
                                    //判断有无燃油
                                    if weakSelf?.towRow[i].tcTax != "0"
                                    {
                                        nameArr.append("燃油费(\(String(describing: weakSelf!.towRow[i].psgName)))")
                                        moneyArr.append(weakSelf?.towRow[i].tcTax)
                                    }
                                    //判断有无保险
                                    if (weakSelf?.towRow[i].surances.count == 0 || weakSelf?.towRow[i].surances[0].first == false)
                                    {
                                        
                                    }else{
                                        nameArr.append("保险(\(String(describing: weakSelf!.towRow[i].psgName)))")
                                        moneyArr.append(weakSelf!.towRow[i].surances.first?.price)
                                    }
                                    
                                    for i in 0...nameArr.count-1
                                    {
                                        let model = OrderDetailModel()
                                        model.date = nameArr[i]
                                        model.memberRate = moneyArr[i]!
                                        weakSelf?.priceArr.add(model)
                                    }
                                }
                            }else{
                                //有发生退改
                                //遍历tuigaiArr
                                for i in 0...(weakSelf?.towRow.count)!-1{
                                    //改签单
                                    if weakSelf?.towRow[i].type == "2"
                                    {
                                        //                                    计算改签费总和====现在不用算了，取alert[0]里extraTotal
                                        var gaiMoney : Double = 0
                                        for index in 0...(weakSelf?.towRow[i].alters.count)!-1{
                                                gaiMoney += Double((weakSelf?.towRow[i].alters[index].extraTotal)!)!
                                        }
                                        var nameArr = ["机票(\(String(describing: weakSelf!.towRow[i].psgName)))","机建(\(String(describing: weakSelf!.towRow[i].psgName)))"]
                                        var moneyArr = [weakSelf?.towRow[i].unitFare,weakSelf?.towRow[i].ocTax]
                                        //判断有无燃油
                                        if weakSelf?.towRow[i].tcTax != "0"
                                        {
                                            nameArr.append("燃油费(\(String(describing: weakSelf!.towRow[i].psgName)))")
                                            moneyArr.append(weakSelf?.towRow[i].tcTax)
                                        }
                                        //判断有无保险
                                        if (weakSelf?.towRow[i].surances.count == 0 || weakSelf?.towRow[i].surances[0].first == false)
                                        {
                                            
                                        }else{
                                            nameArr.append("保险(\(String(describing: weakSelf!.towRow[i].psgName)))")
                                            moneyArr.append(weakSelf!.towRow[i].surances.first?.price)
                                        }
                                        nameArr.append("改签费(\(String(describing: weakSelf!.towRow[i].psgName)))")
                                        moneyArr.append(gaiMoney.description)

                                        for j in 0...nameArr.count-1
                                        {
                                            let model = OrderDetailModel()
                                            model.date = nameArr[j]
                                            model.memberRate = moneyArr[j]!
                                            weakSelf?.priceArr.add(model)
                                        }
                                    }
                                    //退票单
                                    if weakSelf?.towRow[i].type == "1"
                                    {
                                        var nameArr = ["退票费(\(String(describing: weakSelf!.towRow[i].psgName)))"]
                                        var moneyArr = [weakSelf!.towRow[i].refund?.extraPrice]
                                        //判断有无保险
                                        if (weakSelf?.towRow[i].surances.count != 0 )
                                        {
                                            if (weakSelf?.towRow[i].surances[0].first == true )
                                            {
                                                nameArr = ["保险(\(String(describing: weakSelf!.towRow[i].psgName)))","退票费(\(String(describing: weakSelf!.towRow[i].psgName)))"]
                                                moneyArr = [weakSelf!.towRow[i].surances.first?.price,weakSelf!.towRow[i].refund?.extraPrice]
                                            }
                                            
                                        }
                                        for j in 0...nameArr.count-1
                                        {
                                            let model = OrderDetailModel()
                                            model.date = nameArr[j]
                                            model.memberRate = moneyArr[j]!
                                            weakSelf?.priceArr.add(model)
                                        }
                                        weakSelf?.tuiNum += 1
                                    }
                                    //改签后退票
                                    if weakSelf?.towRow[i].type == "3"
                                    {
                                        var gaiMoney : Double = 0
                                        for index in 0...(weakSelf?.towRow[i].alters.count)!-1{
                                            gaiMoney += Double((weakSelf?.towRow[i].alters[index].extraTotal)!)!
                                        }
                                        ////改签完退票
                                        var nameArr = ["改签费(\(String(describing: weakSelf!.towRow[i].psgName)))","退票费(\(String(describing: weakSelf!.towRow[i].psgName)))"]
                                        var moneyArr = [gaiMoney.description,weakSelf!.towRow[i].refund?.extraPrice]
                                        ////现在改签完退票只取退票费就好了
//                                        var nameArr = ["退票费(\(String(describing: weakSelf!.tuigaiArr[i].psgName)))"]
//                                        var moneyArr = [weakSelf!.tuigaiArr[i].refund?.extraPrice]
                                        
                                        //判断有无保险
                                        if (weakSelf?.towRow[i].surances.count != 0 )
                                        {
                                            if (weakSelf?.towRow[i].surances[0].first == true )
                                            {
                                                nameArr = ["保险(\(String(describing: weakSelf!.towRow[i].psgName)))","改签费(\(String(describing: weakSelf!.towRow[i].psgName)))","退票费(\(String(describing: weakSelf!.towRow[i].psgName)))"]
                                                moneyArr = [weakSelf!.towRow[i].surances.first?.price,gaiMoney.description,weakSelf!.towRow[i].refund?.extraPrice]
                                            }
                                            
                                        }
                                        
                                        for j in 0...nameArr.count-1
                                        {
                                            let model = OrderDetailModel()
                                            model.date = nameArr[j]
                                            model.memberRate = moneyArr[j]!
                                            weakSelf?.priceArr.add(model)
                                        }
                                        weakSelf?.tuiNum += 1
                                    }
                                    if weakSelf?.towRow[i].type == "0"
                                    {
                                        var nameArr = ["机票(\(String(describing: weakSelf!.towRow[i].psgName)))","机建(\(String(describing: weakSelf!.towRow[i].psgName)))"]
                                        var moneyArr = [weakSelf?.towRow[i].unitFare,weakSelf!.towRow[i].ocTax]
                                        //                                    var peopleArr = [" x \(String((weakSelf?.towRow.count)! - (weakSelf?.tuigaiArr.count)!))人"," x \(String((weakSelf?.towRow.count)! - (weakSelf?.tuigaiArr.count)!))人"]
                                        //判断有无燃油
                                        if weakSelf?.towRow[i].tcTax != "0"
                                        {
                                            nameArr.append("燃油费(\(String(describing: weakSelf!.towRow[i].psgName)))")
                                            moneyArr.append(weakSelf?.towRow[i].tcTax)
                                        }
                                        //判断有无保险
                                        if (weakSelf?.towRow[i].surances.count == 0 || weakSelf?.towRow[i].surances[0].first == false)
                                        {
                                            
                                        }else{
                                            nameArr.append("保险(\(String(describing: weakSelf!.towRow[i].psgName)))")
                                            moneyArr.append(weakSelf!.towRow[i].surances.first?.price)
                                        }
                                        for j in 0...nameArr.count-1
                                        {
                                            let model = OrderDetailModel()
                                            model.date = nameArr[j]
                                            model.memberRate = moneyArr[j]!
                                            weakSelf?.priceArr.add(model)
                                        }
                                        
                                    }
                                    
                                }
                                //                            if weakSelf?.suransArr.count != 0
                                //                            {
                                //                                var nameArr = ["保险"]
                                //                                var moneyArr = ["20"]
                                //                                var peopleArr = [" x \(String((weakSelf?.suransArr.count)!))份"]
                                //                                for j in 0...nameArr.count-1
                                //                                {
                                //                                    let model = OrderDetailModel()
                                //                                    model.date = nameArr[j]
                                //                                    model.memberRate = moneyArr[j]
                                //                                    model.pnr = peopleArr[j]
                                //                                    weakSelf?.priceArr.add(model)
                                //                                }
                                //                            }
                            }
                            
                        }
                    }
                    printDebugLog(message: weakSelf?.tuiNum)
                    if weakSelf?.tuiNum == weakSelf?.towRow.count
                    {
                        weakSelf?.orderSts = "5"
                    }
                    weakSelf?.footerViewUI()
                    weakSelf?.detailTable.reloadData()
                case .error(let error):
                    weakSelf?.hideLoadingView()
                    try? weakSelf?.validateHttp(error)
                case .completed:
                    break
                    
                }
        }
        
    }
}
extension FlightOrderDetaileViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 + sectionArr.count;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            if section == 0
            {
                return 1
            }else if section == 2 {
                if orderTy == "1"
                {
                    //机票 发生退改(tuigaiArr.count == towRow.count 不显示最初航班信息)
                    return  tuigaiArr.count == towRow.count ? tuigaiArr.count : 1 + tuigaiArr.count
                }
                return 1
            }else if sectionArr[section-1] == "基本信息"{
                return 1+oneRow.count//基本信息
            }else if sectionArr[section-1] == "乘机人" || sectionArr[section-1] == "乘车人"{
                return 1+towRow.count//乘机人
            }else if sectionArr[section-1] == "联系人"{
                return 1+threeRow.count//联系人
            }else if sectionArr[section-1] == "申请单"{
                return travelArr.count == 0 ? 0 : travelBool ? 1+travelNum : 1//申请单
            }else if sectionArr[section-1] == "审批记录"{
                return approveArr.count == 0 ? 0 : approveBool ? 1+approveNum : 1//审批记录
            }else{
                return requirArr.count == 0 ? 0: requireBool ? 1+requireNum : 1//修改记录
            }
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section==2 {
            //没变的航班样式不变
            if tuigaiArr.count == towRow.count{
                return 170
            }else{
                if indexPath.row == tuigaiArr.count
                {
                    return 130
                }else{
                    return 170
                }
            }
        }else{
            return UITableViewAutomaticDimension
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 || section == 1{
            return 0
        }else if sectionArr[section-1] == "乘机人"
        {
            return 0
        }else if sectionArr[section-1] == "审批记录"
        {
            return approveArr.count == 0 ? 0 : travelBool ? 22 : 10//审批记录
        }else if sectionArr[section-1] == "修改记录"
        {
//            return requirArr.count == 0 ? 0 : approveArr.count == 0 ? ( travelNum == 0 ? 10 : 22 ) :requireNum == 0 ? 10 : requirArr.count == 0 ? 0 : approveNum == 0 ? 10 : 22//修改记录
            return requirArr.count == 0 ? 0 : approveArr.count == 0 ? ( travelBool  ? 22 : 10 ) :requireBool == false ? 10 : requirArr.count == 0 ? 0 : approveBool  ? 22 : 10//修改记录
        }
        else if sectionArr[section-1] == "申请单"
        {
            return travelArr.count == 0 ? 0 : 22//申请单
        }
        else if section == 2
        {
           return 22//修改记录
        }
        return 10
    }
   
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let baseView = UIView()
        view.addSubview(baseView)
        view.backgroundColor=TBIThemeWhite
        baseView.backgroundColor=TBIThemeBaseColor
        baseView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.height.equalTo(10)
            make.left.right.equalTo(0)
        }
        return view
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
     if indexPath.section == 0 {
         let cell:OrderStatusCell  = tableView.dequeueReusableCell(withIdentifier: "OrderStatusCell") as! OrderStatusCell
        cell.setCellWithStatus(status:orderSts)
         return cell
     }else if indexPath.section == 1 || indexPath.section == 3 || indexPath.section == 4 || indexPath.section == 5 || indexPath.section == 6 || indexPath.section == 7 {
        
         if indexPath.row == 0{
            let cell:OrderDetailTitleCell  = tableView.dequeueReusableCell(withIdentifier: "OrderDetailTitleCell") as! OrderDetailTitleCell
            cell.titleLabel.text = sectionArr[indexPath.section - 1]
            if(sectionArr[indexPath.section - 1] == "乘机人")
            {
                if towRow.count>1
                {
                    cell.titleLabel.text = "乘机人" + "（共\(towRow.count)人）"
                }else{
                    cell.titleLabel.text = "乘机人" 
                }
            }
            if(sectionArr[indexPath.section - 1] == "乘车人")
            {
                if towRow.count>1
                {
                    cell.titleLabel.text = "乘车人" + "（共\(towRow.count)人）"
                }else{
                    cell.titleLabel.text = "乘车人"
                }
            }
            if(sectionArr[indexPath.section - 1] == "申请单" || sectionArr[indexPath.section - 1] == "审批记录" || sectionArr[indexPath.section - 1] == "修改记录")
            {
                cell.upButton.isHidden=false
                cell.upButton.tag=indexPath.section-1
                cell.upButton.isSelected = cell.upButton.isSelected
                cell.upButton.addTarget(self, action: #selector(upButtonClick(sender:)), for: UIControlEvents.touchUpInside)
            }else{
                cell.upButton.isHidden=true
            }
            cell.lineLabel.isHidden = false
            cell.rightLabel.isHidden = true
            return cell
            
         }else{
            //乘机人 乘车人
            if sectionArr[indexPath.section-1] == "乘机人" || sectionArr[indexPath.section-1] == "乘车人"{
                let cell:OrderPsgerCell  = tableView.dequeueReusableCell(withIdentifier: "OrderPsgerCell") as! OrderPsgerCell
               
                cell.setCellWithOrderDetailModel(model: towRow[indexPath.row-1])
                if indexPath.row == towRow.count
                {
                    cell.bottomLineLabel.isHidden = true
                }else{
                    cell.bottomLineLabel.isHidden = false
                }
                return cell
            }else if sectionArr[indexPath.section-1] == "审批记录"||sectionArr[indexPath.section-1] == "修改记录"{
                let cell:OrderRecordCell  = tableView.dequeueReusableCell(withIdentifier: "OrderRecordCell") as! OrderRecordCell
                if sectionArr[indexPath.section-1] == "审批记录"
                {
                    if approveArr.count != 0
                    {
                        cell.setCellWithModel(leftStr:CommonTool.stamp(to: approveArr[indexPath.row-1].approveTime, withFormat: "yyyy-MM-dd hh:mm") , middleStr: approveArr[indexPath.row-1].apverLevel + "/" + approveArr[indexPath.row-1].apverName, rightStr: approveArr[indexPath.row-1].statusCH)
                    }
                }
                if sectionArr[indexPath.section-1] == "修改记录"
                {
                    if requirArr.count != 0
                    {
                        //status == 0 ? typeCH : type :
                        var rightS : String = ""
                        if(requirArr[indexPath.row-1].status == "0"){
                            rightS="申请";
                        }else if(requirArr[indexPath.row-1].status == "1"){
                            rightS="已";
                        }else {
                            rightS="驳回";
                        }
                        //未处理
                        if(requirArr[indexPath.row-1].type == "0"){
                            rightS = rightS + "取消"
                        }else if(requirArr[indexPath.row-1].type == "1"){
                            rightS = rightS + "退票"
                        }else {
                            rightS = rightS + "改签"
                        }
                        cell.setCellWithModel(leftStr: requirArr[indexPath.row-1].handleTime, middleStr: "", rightStr: rightS)
                    }
                }
              return cell
            }else{
                let cell:OrderDetailLabelCell  = tableView.dequeueReusableCell(withIdentifier: "OrderDetailLabelCell") as! OrderDetailLabelCell
                //基本信息
                if sectionArr[indexPath.section-1] == "基本信息"
                {
                    cell.setCell(leftStr: oneRow[indexPath.row-1]["title"]!, rightStr: oneRow[indexPath.row-1]["content"]!)
                }else if sectionArr[indexPath.section-1] == "联系人"
                {
                    //联系人
                    cell.setCell(leftStr: threeRow[indexPath.row-1]["title"]!, rightStr: threeRow[indexPath.row-1]["content"]!)
                }else if sectionArr[indexPath.section-1] == "申请单"
                {
                    //申请单
                    cell.setCell(leftStr: travelArr[indexPath.row-1]["title"]!, rightStr: travelArr[indexPath.row-1]["content"]!)
                }
                return cell
            }
            
         }
     }else{
       
            if orderTy == "1"
            {
                //没变的航班样式不变
                if tuigaiArr.count == towRow.count{
                    //航班信息
                    let cell:OrderFlightTuiCell  = tableView.dequeueReusableCell(withIdentifier: "OrderFlightTuiCell") as! OrderFlightTuiCell
                    
                    //type (integer, optional): 0普通1退票单2改签单3改签退票单4取消单 ,
                    
                    if(towRow[indexPath.row].type == "1" )
                    {
                        cell.setCellWithModel(model:orderModel)
                        cell.tuigaiButton.isUserInteractionEnabled=false
                        cell.tuigaiButton.setTitleColor(UIColor.gray, for: UIControlState.normal)
                        cell.tuigaiButton.setTitle("已退票", for: UIControlState.normal)
                        
                        cell.takeOffDateLabel.textColor=TBIThemeMinorTextColor
                        cell.arriveDateLabel.textColor=TBIThemeMinorTextColor
                        cell.flyDaysLabel.textColor=TBIThemeMinorTextColor
                        
                    }else if towRow[indexPath.row].type == "0"
                    {
                        cell.setCellWithModel(model:orderModel)
                    }else if(towRow[indexPath.row].type == "3")
                    {
                        cell.setCellWithPsg(model: towRow[indexPath.row])
                        cell.tuigaiButton.isUserInteractionEnabled=false
                        cell.tuigaiButton.setTitleColor(UIColor.gray, for: UIControlState.normal)
                        cell.tuigaiButton.setTitle("已退票", for: UIControlState.normal)
                        
                        cell.takeOffDateLabel.textColor=TBIThemeMinorTextColor
                        cell.arriveDateLabel.textColor=TBIThemeMinorTextColor
                        cell.flyDaysLabel.textColor=TBIThemeMinorTextColor
                        
                    }else if(towRow[indexPath.row].type == "2"){
                        //改签
                        cell.setCellWithPsg(model: towRow[indexPath.row])
                    }else if(towRow[indexPath.row].type == "4"){
                        //订单已取消
                        cell.setCellWithModel(model:orderModel)
                        cell.tuigaiButton.isUserInteractionEnabled=false
                        cell.tuigaiButton.setTitle(" ", for: UIControlState.normal)
                        
                        cell.takeOffDateLabel.textColor=TBIThemeMinorTextColor
                        cell.arriveDateLabel.textColor=TBIThemeMinorTextColor
                        cell.flyDaysLabel.textColor=TBIThemeMinorTextColor
                    }
                    cell.titleLabel.text="航班信息（\(towRow[indexPath.row].psgName)）"
                    
                    return cell
                }else{
                    if indexPath.row == tuigaiArr.count
                    {
                        //航班信息
                        let cell:OrderFlightCell  = tableView.dequeueReusableCell(withIdentifier: "OrderFlightCell") as! OrderFlightCell
                        cell.setCellWithModel(model:orderModel)
                        return cell
                    }else{
                        //航班信息
                        let cell:OrderFlightTuiCell  = tableView.dequeueReusableCell(withIdentifier: "OrderFlightTuiCell") as! OrderFlightTuiCell
                        
                        //type (integer, optional): 0普通1退票单2改签单3改签退票单4取消单 ,
                        
                        if(towRow[indexPath.row].type == "1" )
                        {
                            cell.setCellWithModel(model:orderModel)
                            cell.tuigaiButton.isUserInteractionEnabled=false
                            cell.tuigaiButton.setTitleColor(UIColor.gray, for: UIControlState.normal)
                            cell.tuigaiButton.setTitle("已退票", for: UIControlState.normal)
                            
                            cell.takeOffDateLabel.textColor=TBIThemeMinorTextColor
                            cell.arriveDateLabel.textColor=TBIThemeMinorTextColor
                            cell.flyDaysLabel.textColor=TBIThemeMinorTextColor
                            
                        }else if towRow[indexPath.row].type == "0"
                        {
                            cell.setCellWithModel(model:orderModel)
                        }else if(towRow[indexPath.row].type == "3")
                        {
                            cell.setCellWithPsg(model: towRow[indexPath.row])
                            cell.tuigaiButton.isUserInteractionEnabled=false
                            cell.tuigaiButton.setTitleColor(UIColor.gray, for: UIControlState.normal)
                            cell.tuigaiButton.setTitle("已退票", for: UIControlState.normal)
                            
                            cell.takeOffDateLabel.textColor=TBIThemeMinorTextColor
                            cell.arriveDateLabel.textColor=TBIThemeMinorTextColor
                            cell.flyDaysLabel.textColor=TBIThemeMinorTextColor
                            
                        }else if(towRow[indexPath.row].type == "2"){
                            //改签
                            cell.setCellWithPsg(model: towRow[indexPath.row])
                        }else if(towRow[indexPath.row].type == "4"){
                            //订单已取消
                            cell.setCellWithModel(model:orderModel)
                            cell.tuigaiButton.isUserInteractionEnabled=false
                            cell.tuigaiButton.setTitle(" ", for: UIControlState.normal)
                            
                            cell.takeOffDateLabel.textColor=TBIThemeMinorTextColor
                            cell.arriveDateLabel.textColor=TBIThemeMinorTextColor
                            cell.flyDaysLabel.textColor=TBIThemeMinorTextColor
                        }
                        cell.titleLabel.text="航班信息（\(towRow[indexPath.row].psgName)）"
                        
                        return cell
                    }
                }
//                if tuigaiArr.count>0
//                {
//                    //航班信息
//                    let cell:OrderFlightTuiCell  = tableView.dequeueReusableCell(withIdentifier: "OrderFlightTuiCell") as! OrderFlightTuiCell
//
//                    //type (integer, optional): 0普通1退票单2改签单3改签退票单4取消单 ,
//
//                        if(towRow[indexPath.row].type == "1" )
//                        {
//                            cell.setCellWithModel(model:orderModel)
//                            cell.tuigaiButton.isUserInteractionEnabled=false
//                            cell.tuigaiButton.setTitleColor(UIColor.gray, for: UIControlState.normal)
//                            cell.tuigaiButton.setTitle("已退票", for: UIControlState.normal)
//
//                             cell.takeOffDateLabel.textColor=TBIThemeMinorTextColor
//                             cell.arriveDateLabel.textColor=TBIThemeMinorTextColor
//
//                        }else if towRow[indexPath.row].type == "0"
//                        {
//                            cell.setCellWithModel(model:orderModel)
//                        }else if(towRow[indexPath.row].type == "3")
//                        {
//                            cell.setCellWithPsg(model: towRow[indexPath.row])
//                            cell.tuigaiButton.isUserInteractionEnabled=false
//                            cell.tuigaiButton.setTitleColor(UIColor.gray, for: UIControlState.normal)
//                            cell.tuigaiButton.setTitle("已退票", for: UIControlState.normal)
//
//                            cell.takeOffDateLabel.textColor=TBIThemeMinorTextColor
//                            cell.arriveDateLabel.textColor=TBIThemeMinorTextColor
//
//                        }else if(towRow[indexPath.row].type == "2"){
//                            //改签
//                            cell.setCellWithPsg(model: towRow[indexPath.row])
//                        }else if(towRow[indexPath.row].type == "4"){
//                            //订单已取消
//                            cell.setCellWithModel(model:orderModel)
//                            cell.tuigaiButton.isUserInteractionEnabled=false
//                            cell.tuigaiButton.setTitle(" ", for: UIControlState.normal)
//
//                            cell.takeOffDateLabel.textColor=TBIThemeMinorTextColor
//                            cell.arriveDateLabel.textColor=TBIThemeMinorTextColor
//                        }
//                        cell.titleLabel.text="航班信息（\(towRow[indexPath.row].psgName)）"
//
//                    return cell
//                }else{
//                    //航班信息
//                    let cell:OrderFlightCell  = tableView.dequeueReusableCell(withIdentifier: "OrderFlightCell") as! OrderFlightCell
//                    cell.setCellWithModel(model:orderModel)
//                    return cell
//                }
                
            }else{
                //火车信息
                let cell:OrderTrainCell  = tableView.dequeueReusableCell(withIdentifier: "OrderTrainCell") as! OrderTrainCell
                cell.setCellWithModel(model:orderModel)
                return cell
            }

        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if orderTy == "1" {
            if indexPath.section != 0{
                
                if sectionArr[indexPath.section-1] == "乘机人"
                {
                    if indexPath.row != 0
                    {
                        if towRow[indexPath.row-1].surances.count != 0
                        {
                            //保险详情
                            let insureVC = OrderInsureViewController()
                            insureVC.suransModel=towRow[indexPath.row-1].surances[0]
                            self.navigationController?.pushViewController(insureVC, animated: true)
                        }
                        
                    }
                }
            }
        }
    }
    
}
extension FlightOrderDetaileViewController
{
    func initFooterView()  {
        bgView.backgroundColor = TBIThemeBackgroundViewColor
        KeyWindow?.addSubview(bgView)//放到主视图上
        orderDetailFooterView.initViewWithStr(orderTy:orderTy)
        self.view.addSubview(orderDetailFooterView)
        bgView.isHidden = true
    
        bgView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(54)
        }
        orderDetailFooterView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(54)
        }

        
        bgView.addOnClickListener(target: self, action: #selector(removePriceInfo(tap:)))
        orderDetailFooterView.priceButton.addTarget(self, action: #selector(priceInfo(sender:)), for: .touchUpInside)
        orderDetailFooterView.submitButton.addTarget(self, action: #selector(submitOrder(sender:)), for: .touchUpInside)
        orderDetailFooterView.leftButton.addTarget(self, action: #selector(footViewLeftBtnClick(sender:)), for: .touchUpInside)
        orderDetailFooterView.rightButton.addTarget(self, action: #selector(footViewRightBtnClick(sender:)), for: .touchUpInside)
    }
    // MARK: - footView.button click
    func removePriceInfo(tap:UITapGestureRecognizer) {
        print("removePriceInfo")
        priceInfoViewDisappear()
    }
    func priceInfo(sender:UIButton)  {
        if sender.isSelected == true{
            sender.isSelected = false
             bgView.isHidden = true
            flightPriceInfoView?.removeFromSuperview()
        }else{
            sender.isSelected = true
            
            flightPriceInfoView = PriceInfoTableView()
            
            
            
            let height:Double = Double(54 + 35 * (priceArr.count > 10 ? 10 : priceArr.count)+12)
                      
            flightPriceInfoView?.initViewWithArray(model: orderModel,orderType:orderTy,dataArray:priceArr)
            
            self.view.addSubview(flightPriceInfoView!)
            flightPriceInfoView?.snp.makeConstraints({ (make) in
                make.left.right.equalTo(0)
                make.bottom.equalTo(orderDetailFooterView.snp.top).offset(0)
                make.height.equalTo(height-54)
            })
            bgView.snp.updateConstraints({ (make) in
                make.bottom.equalToSuperview().inset(height)
            })
             bgView.isHidden = false
            
        }
    }
    func submitOrder(sender:UIButton)  {
        priceInfoViewDisappear()
        weak var weakSelf = self
        if orderSts == "2"
        {
            self.showAlertView(messageStr: "撤回送审？", okActionMethod: {
                (weakSelf?.cancelApproval(orderNoArr: [(weakSelf?.orderModel.id)!]))!
                })
            printDebugLog(message:"撤回送审")
            
        }
        if orderSts == "3"
        {
           printDebugLog(message:"取消申请")
            self.showAlertView(messageStr: "取消申请？", okActionMethod: {
                weakSelf?.cancelRequireFunction(typeStr:"0")
            })
            
        }
        if orderSts == "4"
        {
            if orderTy == "3"
            {
                printDebugLog(message:"申请退订")
                self.showAlertView(messageStr:"申请退订？", okActionMethod: {
                    weakSelf?.cancelRequireFunction(typeStr:"1")
                })
            }
        }
        
    }
    func footViewLeftBtnClick(sender:UIButton)  {
        priceInfoViewDisappear()
        if orderSts == "1"
        {
            printDebugLog(message:"送审")
            self.getApproval(orderNoArr: [orderModel.id])

        }
        if orderSts == "4"
        {
            weak var weakSelf = self
            printDebugLog(message:"改签")
            self.showAlertView(messageStr:"确定改签？", okActionMethod: {
                weakSelf?.cancelRequireFunction(typeStr:"2")
            })
        }
        
    }
    func footViewRightBtnClick(sender:UIButton)  {
        priceInfoViewDisappear()
        weak var weakSelf = self
        if orderSts == "1"
        {
            printDebugLog(message:"取消")
            if orderTy == "1"
            {
                self.showAlertView(messageStr:"确定取消？", okActionMethod: {
                    //机票取消 104
                    weakSelf?.cancelFlightFunction(typeStr:"104")
                })
            }else{
                self.showAlertView(messageStr:"确定取消？", okActionMethod: {
                    //火车票取消 304
                    weakSelf?.cancelTrainFunction(typeStr:"304")
                })
            }
            
        }
        if orderSts == "4"
        {
            printDebugLog(message:"退票")
            self.showAlertView(messageStr:"确定退票？", okActionMethod: {
                weakSelf?.cancelRequireFunction(typeStr:"1")
            })
        }
        
    }
    
    func footerViewUI() {
        print("orderSts==\(orderSts)")
        ///是否OA对接 1是OA对接 0 未对接
        let oaStr = DBManager.shareInstance.userDetailDraw()?.busLoginInfo.userBaseInfo.oaCorp ?? ""
        if orderSts == "1" || orderSts == "4"
        {
            ///如果是oa对接
            if orderSts == "1" && oaStr == "1"
            {
                orderDetailFooterView.submitButton.isHidden=true
                orderDetailFooterView.leftButton.isHidden=true
                orderDetailFooterView.rightButton.isHidden=false
                orderDetailFooterView.rightButton.snp.remakeConstraints({ (make) in
                    make.right.equalToSuperview()
                    make.height.equalToSuperview()
                    make.bottom.equalToSuperview()
                    make.width.equalToSuperview().dividedBy(orderTy == "4" ? 1:2)
                })
            }else{
                orderDetailFooterView.submitButton.isHidden=true
                orderDetailFooterView.leftButton.isHidden=false
                orderDetailFooterView.rightButton.isHidden=false
            }
            
            if orderSts == "1"
            {
                orderDetailFooterView.leftButton.backgroundColor=TBIThemeGreenColor
                orderDetailFooterView.leftButton.setTitle("送审", for: UIControlState.normal)
                orderDetailFooterView.rightButton.backgroundColor=TBIThemeRedColor
                orderDetailFooterView.rightButton.setTitle("取消", for: UIControlState.normal)
            }
            if orderSts == "4"
            {
                if orderTy == "3"
                {
                    orderDetailFooterView.submitButton.isHidden=false
                    orderDetailFooterView.leftButton.isHidden=true
                    orderDetailFooterView.rightButton.isHidden=true
                    orderDetailFooterView.submitButton.backgroundColor=TBIThemeDarkBlueColor
                    orderDetailFooterView.submitButton.setTitle("申请退订", for: UIControlState.normal)
                }
            }
            
        }else{
            orderDetailFooterView.leftButton.isHidden=true
            orderDetailFooterView.rightButton.isHidden=true
            orderDetailFooterView.submitButton.isHidden=false
            if orderSts == "2"
            {
                orderDetailFooterView.submitButton.backgroundColor=TBIThemeRedColor
                orderDetailFooterView.submitButton.setTitle("撤回送审", for: UIControlState.normal)
            }
            if orderSts == "3"
            {
                orderDetailFooterView.submitButton.backgroundColor=TBIThemeDarkBlueColor
                orderDetailFooterView.submitButton.setTitle("取消申请", for: UIControlState.normal)
            }
            
            if orderSts == "5"
            {
                orderDetailFooterView.submitButton.backgroundColor=TBIThemeButtonGrayColor
                orderDetailFooterView.submitButton.setTitle("已退订", for: UIControlState.normal)
            }
        }
    }
}
extension FlightOrderDetaileViewController
{
    //送审
    func getApproval(orderNoArr:[String]) {
        weak var weakSelf = self
        let request:QueryApproveVO = QueryApproveVO()
        for element in orderNoArr {
            let orderInfo:QueryApproveVO.ApproveOrderInfo = QueryApproveVO.ApproveOrderInfo()
            orderInfo.orderId = element
            orderInfo.orderType = orderTy
            request.approveOrderInfos.append(orderInfo)
        }
        
        showLoadingView()
        _ = HomeService.sharedInstance
            .getApproval(request:request )
            .subscribe { (event) in
                weakSelf?.hideLoadingView()
                switch event {
                case .next(let element):
//                    printDebugLog(message: element.mj_keyValues())
                    if element.approveGroupInfos.count > 0 {
                        weakSelf?.intoNextNewExamineView(approvalGroup: element.approveGroupInfos.first!, orderNoArr: orderNoArr)
                    }else {
                        weakSelf?.navigationController?.popViewController(animated: true)
                    }
                case .error(let error):
                    try? weakSelf?.validateHttp(error)
                case .completed:
                    break
                }
                
        }
    }
    
    //取消送审
    func cancelApproval(orderNoArr:[String])  {
        weak var weakSelf = self
        let request:QueryApproveVO = QueryApproveVO()
        for element in orderNoArr {
            let orderInfo:QueryApproveVO.orderApproveInfo = QueryApproveVO.orderApproveInfo()
            orderInfo.orderId = element
            orderInfo.orderType = orderTy
            request.orderApproveInfos.append(orderInfo)
        }
        showLoadingView()
        
        _ = HomeService.sharedInstance
            .revokeApproval(request:request )
            .subscribe { (event) in
                weakSelf?.hideLoadingView()
                switch event {
                case .next(_):
//                    weakSelf?.navigationController?.popViewController(animated: true)
                    let alertController = UIAlertController(title: "提示", message: "成功", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "确定", style: .default){ action in
                        alertController.removeFromParentViewController()
                        weakSelf?.getOrderDetailRequest()
                    }
                    alertController.addAction(okAction)
                    weakSelf?.present(alertController, animated: true)
                    
                case .error(let error):
                    try? weakSelf?.validateHttp(error)
                case .completed:
                    break
                }
                
        }
    }
    //取消申请 退票 改签  0取消1退票2改签 ,
    func cancelRequireFunction(typeStr:String)
    {
        weak var weakSelf = self
        let request:QueryApproveVO = QueryApproveVO()
        request.orderType=orderTy
        request.orderId=orderModel.id
        request.type=typeStr
        _ = HomeService.sharedInstance
            .cancelRequire(request: request)
            .subscribe({ (event) in
                switch event {
                case .next(let element):
                    printDebugLog(message: element.mj_keyValues())
                    //弹出提示框
                    popNewAlertView(content:"",titleStr:"",btnTitle:"我知道了",imageName:"img_call",nullStr:"修改订单请联系您的差旅顾问")
                case .error(let error):
                    weakSelf?.hideLoadingView()
                    try? weakSelf?.validateHttp(error)
                case .completed:
                    break
                    
                }
            })
    }
    // 取消 机票订单
    func cancelFlightFunction(typeStr:String)
    {
        weak var weakSelf = self
        let request:QueryApproveVO = QueryApproveVO()
        request.orderNo=orderModel.orderNo
        request.id=orderModel.id
        request.status=typeStr
        _ = HomeService.sharedInstance
            .cancelFlight(request: request)
            .subscribe({ (event) in
                switch event {
                case .next(let element):
                    printDebugLog(message: element.mj_keyValues())
                    let alertController = UIAlertController(title: "提示", message: "申请取消成功", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "确认", style: .default){ action in
                        weakSelf?.navigationController?.popViewController(animated: true)
                    }
                    alertController.addAction(okAction)
                    weakSelf?.present(alertController, animated: true)
                case .error(let error):
                    weakSelf?.hideLoadingView()
                    try? weakSelf?.validateHttp(error)
                case .completed:
                    break
                    
                }
            })
    }
    func cancelTrainFunction(typeStr:String)
    {
        weak var weakSelf = self
        let request:QueryApproveVO = QueryApproveVO()
        request.orderNo=orderModel.orderNo
        request.id=orderModel.id
        request.status=typeStr
        _ = HomeService.sharedInstance
            .cancelTrain(request: request)
            .subscribe({ (event) in
                switch event {
                case .next(let element):
                    printDebugLog(message: element.mj_keyValues())
                    let alertController = UIAlertController(title: "提示", message: "申请取消成功", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "确认", style: .default){ action in
                        weakSelf?.navigationController?.popViewController(animated: true)
                    }
                    alertController.addAction(okAction)
                    weakSelf?.present(alertController, animated: true)
                    
                case .error(let error):
                    weakSelf?.hideLoadingView()
                    try? weakSelf?.validateHttp(error)
                case .completed:
                    break
                    
                }
            })
    }
    
    func intoNextNewExamineView(approvalGroup:QueryApproveResponseVO.ApproveGroupInfo,orderNoArr:[String]) {
        let examineView = CoNewExamineViewController()
        examineView.newExamineViewType = CoNewExamineViewController.NewExamineViewType.OrderPlanSubmit
        examineView.approveGroupInfos = approvalGroup
        examineView.orderNoArr = orderNoArr
        examineView.orderType = orderTy
        self.navigationController?.pushViewController(examineView, animated: true)
    }
    func upButtonClick(sender:UIButton)
    {
        if sender.isSelected == true{
            sender.isSelected = false
        }else{
            sender.isSelected = true
        }
        printDebugLog(message: sectionArr[sender.tag])
        if sectionArr[sender.tag] == "申请单"
        {
            if sender.isSelected
            {
               travelNum = travelArr.count
                travelBool = true
            }else{
                travelBool = false
                 travelNum = 0
            }
        }
        if sectionArr[sender.tag] == "修改记录"
        {
            if sender.isSelected
            {
                requireNum = requirArr.count
                requireBool = true
            }else{
               requireNum = 0
               requireBool = false
            }
        }
        if sectionArr[sender.tag] == "审批记录"
        {
            if sender.isSelected
            {
                approveNum = approveArr.count
                approveBool = true
            }else{
               approveNum = 0
                approveBool = false
            }
        }
        detailTable.reloadData()
    }
    
    func priceInfoViewDisappear()  {
        orderDetailFooterView.priceButton.isSelected = false
        bgView.isHidden = true
        flightPriceInfoView?.removeFromSuperview()
    }
    //显示AlertView
    func showAlertView(titleStr:String = "",messageStr:String,isHasCancel:Bool = false,okActionMethod:(()->Void)!) -> Void
    {
        let alertController = UIAlertController(title: titleStr, message: messageStr,preferredStyle: .alert)
        
//        if isHasCancel
//        {
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
//        }
        
        let okAction = UIAlertAction(title: "确定", style: .default, handler:
        {action in
            if okActionMethod != nil
            {
                okActionMethod()
            }
        })
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
