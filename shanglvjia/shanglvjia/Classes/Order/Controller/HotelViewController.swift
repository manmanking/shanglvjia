//
//  HotelViewController.swift
//  shanglvjia
//
//  Created by tbi on 2018/5/14.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import MJExtension

class HotelViewController: CompanyBaseViewController {

    var orderNumber = String()
    var orderTy = String()
    var orderSts = String()
    
    fileprivate var flightPriceInfoView:PriceInfoTableView?
    
    var detailTable = UITableView()
    //基本信息
    var oneRow = [["title":"基本信息","content":"xxx"]]
    var orderModel = OrderDetailModel()
    
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
    
    var sectionArr = [String]()
    
    var priceArr = NSMutableArray()
    
    var approveNum : Int = 0
    var travelNum : Int = 0
    var requireNum : Int = 0
    var approveBool : Bool = false
    var travelBool : Bool = false
    var requireBool : Bool = false
    
    var carInfoArr = [["title":"xxx","content":"xxx"]]//专车信息
    var driverArr = [["title":"xxx","content":"xxx"]]//司机信息
    var hotelArr = [["title":"xxx","content":"xxx"]]//入住信息
    
    lazy var orderDetailFooterView:OrderDetailFooterView = OrderDetailFooterView()

    let bgView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor=TBIThemeWhite
        
        sectionArr = orderTy == "2" ? ["基本信息","入住信息","联系人","申请单","审批记录","修改记录"] : ["基本信息","专车信息","司机信息","联系人","申请单","审批记录","修改记录"]
        
        initTableView()
        setNavigationImage()
        setTitleView()
        
        initFooterView()
        
        getOrderDetailRequest()
        
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
        detailTable.register(OrderRecordCell.self, forCellReuseIdentifier: "OrderRecordCell")
        //给TableView添加表头页尾
        let footerView:UIView = UIView(frame:
            CGRect(x:0, y:0, width:detailTable.frame.size.width, height:15))
        footerView.backgroundColor=TBIThemeWhite
        detailTable.tableFooterView = footerView
        self.view.addSubview(detailTable)
    }
    func getOrderDetailRequest(){
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
//                    weakSelf?.oneRow.append(["title":"差旅标准","content":(weakSelf?.orderModel.accordPolicy) == "1" ? "符合" : "违背  " + (weakSelf?.orderModel.disPolicyReason)!])
                    ///专车的差标写成符合
                    if  weakSelf?.orderTy == "4"{
                        weakSelf?.oneRow.append(["title":"差旅标准","content":"符合"])
                    }else{
                        weakSelf?.oneRow.append(["title":"差旅标准","content":(weakSelf?.orderModel.accordPolicy) == "1" ? "符合" : "违背  " + (weakSelf?.orderModel.disPolicyReason)!])
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
                    
                    if weakSelf?.orderTy == "4"
                    {
                         weakSelf?.orderDetailFooterView.priceCountLabel.text =  weakSelf?.orderModel.actPrice
                    }else{
                        weakSelf?.orderDetailFooterView.priceCountLabel.text =  weakSelf?.orderModel.money
                    }
                    
                    //car
                    weakSelf?.carInfoArr.removeAll()
                    weakSelf?.carInfoArr.append( ["title":"用车类型","content":(weakSelf?.orderModel.orderTypeCH)!])
                    weakSelf?.carInfoArr.append( ["title":"预约用车","content":(weakSelf?.orderModel.carTypeCH)!])
                    weakSelf?.carInfoArr.append( ["title":"用车时间","content":(weakSelf?.orderModel.startTime)!])
                    weakSelf?.carInfoArr.append( ["title":"上车地点","content":(weakSelf?.orderModel.startAddress)!])
                    weakSelf?.carInfoArr.append( ["title":"下车地点","content":(weakSelf?.orderModel.endAddress)!])
                    //hotel
                    weakSelf?.hotelArr.removeAll()
                    weakSelf?.hotelArr.append( ["title":"酒店名称","content":(weakSelf?.orderModel.hotelName)!])
                    weakSelf?.hotelArr.append( ["title":"预订房型","content":(weakSelf?.orderModel.roomType)!])
                    weakSelf?.hotelArr.append( ["title":"房间数量","content":(weakSelf?.orderModel.roomCount)! + "间"])
                    weakSelf?.hotelArr.append( ["title":"入离时间","content":(weakSelf?.orderModel.tripStart)! + "至" + (weakSelf?.orderModel.tripEnd)!])
                    weakSelf?.hotelArr.append( ["title":"入住人","content":(weakSelf?.orderModel.psgName)!])
                    weakSelf?.hotelArr.append( ["title":"最晚到店","content":(weakSelf?.orderModel.latestArrivalTime)!])
                    if weakSelf?.orderTy == "2"
                    {
                        var speArr = [String]()
                        //遍历passengers
                        for i in 0...(weakSelf?.orderModel.passengers.count)!-1
                        {
                            if (weakSelf?.orderModel.passengers[i].special)!.isNotEmpty
                            {
                                speArr.append((weakSelf?.orderModel.passengers[i].special)!)
                            }
                        }
                        
                        weakSelf?.hotelArr.append( ["title":"特殊要求","content":speArr.count == 0 ? "无":speArr[0]])
                        
                    }
                    
                    //driver
                    weakSelf?.driverArr.removeAll()
                    if(weakSelf?.orderModel.driverName.isNotEmpty)!
                    {
                        weakSelf?.driverArr.append( ["title":"司机姓名","content":(weakSelf?.orderModel.driverName)!])
                    }
                    if(weakSelf?.orderModel.driverPhone.isNotEmpty)!
                    {
                        weakSelf?.driverArr.append( ["title":"手机号码","content":(weakSelf?.orderModel.driverPhone)!])
                    }
                    if(weakSelf?.orderModel.carNumber.isNotEmpty)!
                    {
                        weakSelf?.driverArr.append( ["title":"车牌号码","content":(weakSelf?.orderModel.carNumber)!])
                    }
                    
                    
                    //出差单
                    weakSelf?.travelArr.removeAll()
                    if (weakSelf?.orderModel.psgName.isNotEmpty)!
                    {
                        weakSelf?.travelArr.append( ["title":"出差人","content":(weakSelf?.orderModel.psgName)!])
                    }
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

                     //酒店 价格明细
                    if(weakSelf?.orderTy == "2")
                    {
                        if (weakSelf?.priceArr.count == 0)
                        {
                            if (weakSelf?.orderModel.priceDetail.isNotEmpty)!
                            {
                                var tempArr = NSMutableArray()
                                //                        let str = "[{\"orderNo\":\"05-20\",\"orderPhone\":\"208\"}]"
                                tempArr = OrderDetailModel.mj_objectArray(withKeyValuesArray: weakSelf?.orderModel.priceDetail)
                                for i in 0...tempArr.count-1
                                {
                                    let model:OrderDetailModel = tempArr[i] as! OrderDetailModel
                                    weakSelf?.priceArr.add(model)
                                }
                            }
                        }
                        
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
extension HotelViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 + sectionArr.count;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }else if sectionArr[section-1] == "专车信息"
        {
            return 1+carInfoArr.count//专车信息
        }else if sectionArr[section-1] == "入住信息"
        {
            return 1+hotelArr.count//入住信息
        }
        else if sectionArr[section-1] == "基本信息"{
            return 1+oneRow.count//基本信息
        }else if sectionArr[section-1] == "司机信息"{
            return driverArr.count == 0 ? 0 : 1+driverArr.count//司机信息
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
        
            return UITableViewAutomaticDimension
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 || section == 1{
            return 0
        }else if sectionArr[section-1] == "审批记录"
        {
            return approveArr.count == 0 ? 0 : travelBool ? 22 : 10//审批记录
        }else if sectionArr[section-1] == "修改记录"
        {
            return requirArr.count == 0 ? 0 : approveArr.count == 0 ? ( travelBool  ? 22 : 10 ) :requireBool == false ? 10 : requirArr.count == 0 ? 0 : approveBool  ? 22 : 10//修改记录
        }else if sectionArr[section-1] == "司机信息"
        {
            return driverArr.count == 0 ? 0 : 22//司机信息
        }else if sectionArr[section-1] == "申请单"
        {
            return travelArr.count == 0 ? 0 : 22//修改记录
        }else if sectionArr[section-1] == "联系人"
        {
            return 22//联系人
        }else if sectionArr[section-1] == "入住信息"
        {
            return 22//入住信息
        }else if sectionArr[section-1] == "专车信息"
        {
            return 22//专车信息
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
        }else {
            // if indexPath.section == 1 || indexPath.section == 3 || indexPath.section == 4 || indexPath.section == 5 || indexPath.section == 6 || indexPath.section == 7 || indexPath.section == 2
            if indexPath.row == 0{
                let cell:OrderDetailTitleCell  = tableView.dequeueReusableCell(withIdentifier: "OrderDetailTitleCell") as! OrderDetailTitleCell
                cell.titleLabel.text = sectionArr[indexPath.section - 1]
                
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
                
                if sectionArr[indexPath.section-1] == "专车信息" || sectionArr[indexPath.section-1] == "入住信息" || sectionArr[indexPath.section-1] == "司机信息"{
                    let cell:OrderDetailLabelCell  = tableView.dequeueReusableCell(withIdentifier: "OrderDetailLabelCell") as! OrderDetailLabelCell
                    if sectionArr[indexPath.section-1] == "专车信息"
                    {
                         cell.setCell(leftStr: carInfoArr[indexPath.row-1]["title"]!, rightStr: carInfoArr[indexPath.row-1]["content"]!)
                    }else  if sectionArr[indexPath.section-1] == "司机信息"
                    {
                        cell.setCell(leftStr: driverArr[indexPath.row-1]["title"]!, rightStr: driverArr[indexPath.row-1]["content"]!)
                    }
                    else{
                       cell.setCell(leftStr: hotelArr[indexPath.row-1]["title"]!, rightStr: hotelArr[indexPath.row-1]["content"]!)
                    }
                   
                    return cell
                }else if sectionArr[indexPath.section-1] == "审批记录"||sectionArr[indexPath.section-1] == "修改记录"{
                    let cell:OrderRecordCell  = tableView.dequeueReusableCell(withIdentifier: "OrderRecordCell") as! OrderRecordCell
                    if sectionArr[indexPath.section-1] == "审批记录"
                    {
                        if approveArr.count != 0
                        {
                                cell.setCellWithModel(leftStr: CommonTool.stamp(to: approveArr[indexPath.row-1].approveTime, withFormat: "yyyy-MM-dd hh:mm") , middleStr: approveArr[indexPath.row-1].apverLevel + "/" + approveArr[indexPath.row-1].apverName, rightStr: approveArr[indexPath.row-1].statusCH)
                        }
                    
                    }
                    if sectionArr[indexPath.section-1] == "修改记录"
                    {
                        if requirArr.count != 0
                        {
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
                    if sectionArr[indexPath.section-1] == "基本信息"
                    {
                        cell.setCell(leftStr: oneRow[indexPath.row-1]["title"]!, rightStr: oneRow[indexPath.row-1]["content"]!)
                    }else if sectionArr[indexPath.section-1] == "联系人"
                    {
                        cell.setCell(leftStr: threeRow[indexPath.row-1]["title"]!, rightStr: threeRow[indexPath.row-1]["content"]!)
                    }else if sectionArr[indexPath.section-1] == "申请单"
                    {
                        cell.setCell(leftStr: travelArr[indexPath.row-1]["title"]!, rightStr: travelArr[indexPath.row-1]["content"]!)
                    }
                    return cell
                }
                
            }
        }
        
    }
}
extension HotelViewController
{
    func initFooterView()  {
        bgView.backgroundColor = TBIThemeBackgroundViewColor
        KeyWindow?.addSubview(bgView)//放到主视图上
        orderDetailFooterView.initViewWithStr(orderTy:orderTy)
        self.view.addSubview(orderDetailFooterView)
        bgView.isHidden = true
        //        orderDetailFooterView.priceCountLabel.text = sumPrice()
        
        bgView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(54)
        }
        
        orderDetailFooterView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(54)
        }
        
        bgView.addOnClickListener(target: self, action: #selector(removePriceInfo(tap:)))
        if(orderTy == "2")
        {
            orderDetailFooterView.priceButton.isHidden=false
            orderDetailFooterView.priceButton.addTarget(self, action: #selector(priceInfo(sender:)), for: .touchUpInside)
        }
    
        
        orderDetailFooterView.submitButton.addTarget(self, action: #selector(submitOrder(sender:)), for: .touchUpInside)
        orderDetailFooterView.leftButton.addTarget(self, action: #selector(footViewLeftBtnClick(sender:)), for: .touchUpInside)
        orderDetailFooterView.rightButton.addTarget(self, action: #selector(footViewRightBtnClick(sender:)), for: .touchUpInside)
    }
    func removePriceInfo(tap:UITapGestureRecognizer) {
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
        
            let height:Double = Double(54 + 35 * (priceArr.count > 10 ? 10 : priceArr.count) + 12)
            
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
            printDebugLog(message: "撤回送审")
            self.showAlertView(messageStr: "撤回送审？", okActionMethod: {
                (weakSelf?.cancelApproval(orderNoArr: [(weakSelf?.orderModel.id)!]))!
            })
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
            printDebugLog(message:"申请退订")
            self.showAlertView(messageStr:"申请退订？", okActionMethod: {
                weakSelf?.cancelRequireFunction(typeStr:"1")
            })
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
            if orderTy == "2"
            {
                ///酒店取消
                self.showAlertView(messageStr:"确定取消？", okActionMethod: {
                    weakSelf?.cancelHotelFunction(typeStr: "404")
                })
            }else{
                ///专车取消
                 self.showAlertView(messageStr:"确定取消？", okActionMethod: {
                     weakSelf?.cancelCarFunction(typeStr: "204")
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
        if orderSts == "1" || orderSts == "4"
        {
            ///是否OA对接 1是OA对接 0 未对接
            let oaStr = DBManager.shareInstance.userDetailDraw()?.busLoginInfo.userBaseInfo.oaCorp ?? ""
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
            }else{
                if orderModel.useStatus == "2"
                {
                    //已用车 显示明细
                    orderDetailFooterView.leftButton.isHidden=true
                    orderDetailFooterView.rightButton.isHidden=true
                    orderDetailFooterView.submitButton.isHidden=true
                    orderDetailFooterView.leftView.isHidden=false
                    orderDetailFooterView.leftView.snp.makeConstraints({ (make) in
                        make.right.equalTo(0)
                    })

                    orderDetailFooterView.priceButton.isHidden=true
//                    orderDetailFooterView.priceButton.setTitle("查看明细", for: UIControlState.normal)
                    let imageWith = orderDetailFooterView.priceButton.imageView?.bounds.size.width;
                    let labelWidth = orderDetailFooterView.priceButton.titleLabel?.bounds.size.width;
                    orderDetailFooterView.priceButton.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth!, 0, -labelWidth!);
                    orderDetailFooterView.priceButton.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWith!-5, 0, imageWith!+5);
                }else{
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
extension HotelViewController
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
                    printDebugLog(message: element.mj_keyValues())
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
    
    // 取消 机票订单
    func cancelHotelFunction(typeStr:String)
    {
        weak var weakSelf = self
        let request:QueryApproveVO = QueryApproveVO()
        request.orderNo=orderModel.orderNo
        request.id=orderModel.id
        request.status=typeStr
        _ = HomeService.sharedInstance
            .cancelHotel(request: request)
            .subscribe({ (event) in
                switch event {
                case .next(let element):
                    printDebugLog(message: element.mj_keyValues())
                    let alertController = UIAlertController(title: "提示", message: "申请取消成功", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "确认", style: .default){ action in
                        weakSelf?.refreshOrderStatus()
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
    func cancelCarFunction(typeStr:String)
    {
        weak var weakSelf = self
        let request:QueryApproveVO = QueryApproveVO()
        request.orderNo=orderModel.orderNo
        request.id=orderModel.id
        request.status=typeStr
        _ = HomeService.sharedInstance
            .cancelCar(request: request)
            .subscribe({ (event) in
                switch event {
                case .next(let element):
                    printDebugLog(message: element.mj_keyValues())
                    
                    let alertController = UIAlertController(title: "提示", message: "申请取消成功", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "确认", style: .default){ action in
                        weakSelf?.refreshOrderStatus()
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
    
    
    
    func refreshOrderStatus() {
        NotificationCenter.default.post(name: NSNotification.Name.init("orderRefreshListNotificationKey"), object: nil)
    }
    
    func intoNextNewExamineView(approvalGroup:QueryApproveResponseVO.ApproveGroupInfo,orderNoArr:[String]) {
        let examineView = CoNewExamineViewController()
        examineView.newExamineViewType = CoNewExamineViewController.NewExamineViewType.OrderPlanSubmit
        examineView.approveGroupInfos = approvalGroup
        examineView.orderNoArr = orderNoArr
        examineView.orderType = orderTy
        self.navigationController?.pushViewController(examineView, animated: true)
    }
    //取消申请 退票 改签
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
