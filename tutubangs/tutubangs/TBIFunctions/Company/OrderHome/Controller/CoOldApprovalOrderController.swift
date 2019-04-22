//
//  CoOldApprovalController.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/6/6.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import RxSwift

class CoOldApprovalOrderController: BaseViewController 
{
    
    //外部调用时传递过来的大订单号 参数
    var mBigOrderNOParams = "200053461"
    
    var selectedCellIndexPath:IndexPath!
    
    let bag = DisposeBag()
    
    var myContentView:CoApprovalOrderView!
    
    var cellIsShowArray:[Bool]! = []
    
    
    var orderDetails:CoOldOrderDetail!
    /// 机票小订单
    var flightItems:[CoOldOrderDetail.FlightVo]! =  []
    /// 酒店小订单
    var hotelItems:[CoOldOrderDetail.HotelVo]! = []
    /// 保险小订单
    var suranceItems:[CoOldOrderDetail.SuranceVo]! = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        initView()
        
    }

    func initView() -> Void
    {
        CoApprovalOrderView.isNewVersionOrder = false
        
        self.title = NSLocalizedString("order.approval.title", comment: "待审批出差单")   //"待审批出差单"
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont.systemFont(ofSize: 16),NSForegroundColorAttributeName:UIColor.white]
        setNavigationBackButton(backImage: "back")
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIColor.creatImageWithColor(color: TBIThemeBlueColor), for: .any, barMetrics: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        
        
        self.myContentView = CoApprovalOrderView(frame: CGRect(x: 0, y: 0, width: ScreenWindowWidth, height: ScreentWindowHeight-20-44))
        self.view.addSubview(myContentView)
        
        
        myContentView.myContentFooterView.isHidden = true
        
        myContentView.myTableView.delegate = self
        myContentView.myTableView.dataSource = self
        myContentView.onTableFooterListener = self
        
        //setUp0()
        getCoOldOrderDetailsFromServer(orderParams: self.mBigOrderNOParams)
    }
    
    //重写  头部左侧的🔙Btn
    override func backButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.navigationBar.shadowImage = UIImage.init(named: "border")
    }
    
    
    //获取企业版老版订单详情。   从服务器
    func getCoOldOrderDetailsFromServer(orderParams:String) {
        
        self.showLoadingView()
        
        let orderService = CoOldOrderService.sharedInstance
        orderService.getDetailBy(orderParams).subscribe{ event in
            self.hideLoadingView()
            if case .next(let e) = event
            {
                print("=^_^====成功======")
                
                self.orderDetails = e
                print(self.orderDetails)
                
                self.flightItems = self.orderDetails.flightItems
                self.hotelItems = self.orderDetails.hotelItems
                self.suranceItems = self.orderDetails.suranceItems
                
                var totalCount = 0
                if self.flightItems != nil {
                    totalCount += self.flightItems.count
                }
                if self.hotelItems != nil {
                    totalCount += self.hotelItems.count
                }
                if self.suranceItems != nil {
                    totalCount += self.suranceItems.count
                }
                for _ in 0..<totalCount
                {
                    self.cellIsShowArray.append(false)
                }
                
                //设置TableView的头部的布局
                self.setMyTableHeadView()
                //设置TableFooterView的布局 - Footer
                self.setMyTableFooterView()
                //设置整个View的尾部的视图
                self.setContentBottomView()
                
                self.myContentView.myContentFooterView.isHidden = false
                self.myContentView.myTableView.reloadData()
            }
            if case .error(let e) = event
            {
                
//                print("=====失败======")
//                print(e)
//                
//                if ((e as? HttpError) != nil)
//                {
//                    self.tipNetWorkError(httpError: e as! HttpError)
//                }
                
                print("=====失败======\n \(e)")
                //处理异常
                try? self.validateHttp(e)
                
            }
            }.disposed(by: bag)
    }
    
    func setUp0() {
        
        let form  = CompanyLoginUserForm(userName: "lionel", passWord: "TBI1234hehe", companyCode: "cits")
//        let form  = CompanyLoginUserForm(userName: "test001", passWord: "Aa111111", companyCode: "cits")
        UserService.sharedInstance
            .companyLogin(form)
            .subscribe{ event in
                if case .next(let e) = event {
                    UserDefaults.standard.set(e, forKey: TOKEN_KEY)
                    
                    print("=^_^==login==成功======")
                    
                    //self.getCoOldOrderDetailsFromServer()
                }
                if case .error(let e) = event {
                    print("=====失败======\n \(e)")
                    //处理异常
                    try? self.validateHttp(e)
                }
                self.getCoOldOrderDetailsFromServer(orderParams: self.mBigOrderNOParams)
            }.disposed(by: bag)
        
        
    }
    
    
    //TODO:设置TableView的头部布局
    func setMyTableHeadView() -> Void
    {
        
//        //TODO:测试结束后取消注释
//        if orderDetails == nil
//        {
//            return
//        }
        
        var orderStatus:(currentIndex:Int,states:[CoOrderState])!
        do {
            try orderStatus = orderDetails.getStates()
        }
        catch let discription
        {
            print(discription)
        }
        
        //订单的当前状态
        let orderCurIndex = orderStatus.currentIndex
        let orderStateArray:[CoOrderState] = orderStatus.states
        let curStatusStr:String = CoOldOrderDetailsController.getOrderStateStr(orderState: orderStateArray[orderCurIndex])
        
        //创建时间
        let orderCreateTimeStr = "\(orderDetails.createTime.year)-\(self.numChangeTwoDigital(num: orderDetails.createTime.month))-\(self.numChangeTwoDigital(num: orderDetails.createTime.day))  \(self.numChangeTwoDigital(num: orderDetails.createTime.hour)):\(self.numChangeTwoDigital(num: orderDetails.createTime.minute))"
        
        //出差旅客
        var passageNames = ""
        for i in 0..<orderDetails.orderPsgNames.count
        {
            let passage = orderDetails.orderPsgNames[i]
            
            
            if i != orderDetails.orderPsgNames.count-1
            {
                passageNames += (passage+"、")
            }
            else
            {
                passageNames += passage
            }
        }
        
        
        //对数组进行设置
        var headFixedDataSource:[(String,String)] = []
        headFixedDataSource.append((NSLocalizedString("order.details.orderno", comment:"出差单号"),orderDetails.orderNo))
        headFixedDataSource.append((NSLocalizedString("order.approval.order.status", comment:"订单状态"),curStatusStr))
        headFixedDataSource.append((NSLocalizedString("order.details.create.user", comment:"创建用户"),orderDetails.bookerName))
        headFixedDataSource.append((NSLocalizedString("order.details.create.time", comment:"创建时间"),orderCreateTimeStr))
        
        headFixedDataSource.append((NSLocalizedString("order.details.business.traveller", comment:"出差旅客"),passageNames))
        headFixedDataSource.append((NSLocalizedString("order.details.business.purpose", comment:"出差目的"),orderDetails.travelPurpose))
        headFixedDataSource.append((NSLocalizedString("order.details.business.resaon", comment:"出差事由"),orderDetails.travelDesc))
        
        //对数组进行设置
        myContentView.myHeadFixedDataSource = headFixedDataSource
        myContentView.setTableHeaderView()
        
    }
    
    //设置TableView的底部的布局
    func setMyTableFooterView() -> Void
    {
        //设置审批记录的内容
        var reviewRecordArray:[(String,String,Bool)] = []
        let historyApprovaCount:Int = orderDetails.historyApprovalInfos.count
        
        for i in 0..<historyApprovaCount
        {
            let historyApprovaItem = orderDetails.historyApprovalInfos[i]
            
            var approvaDate_Month_Str = "\(historyApprovaItem.datetime.month)"
            if historyApprovaItem.datetime.month < 10
            {
                approvaDate_Month_Str = "0\(historyApprovaItem.datetime.month)"
            }
            var approvaDate_Day_Str = "\(historyApprovaItem.datetime.day)"
            if historyApprovaItem.datetime.day < 10
            {
                approvaDate_Day_Str = "0\(historyApprovaItem.datetime.day)"
            }
            
            reviewRecordArray.append((historyApprovaItem.apverName,"\(historyApprovaItem.datetime.year)-\(approvaDate_Month_Str)-\(approvaDate_Day_Str)",historyApprovaItem.apvResult))
        }
//        reviewRecordArray.append(("str0","str2",true))
//        reviewRecordArray.append(("str1","str2",true))
//        reviewRecordArray.append(("str2","str2",true))
//        reviewRecordArray.append(("str3","str2",true))
//        reviewRecordArray.append(("str4","str2",true))
        //设置审批记录 的 列表视图
        myContentView.footerReviewRecordArray = reviewRecordArray
        myContentView.setTableFooterView()
    }
    
    //设置底部的同意和拒绝❌按钮的。容器视图
    func setContentBottomView() -> Void
    {
        if (orderDetails.state == .approving) && (!orderDetails.hideApproval)  //底部视图 显示
        {
            myContentView.myContentFooterView.isHidden = false
        }
        else  //对底部视图隐藏
        {
            myContentView.myContentFooterView.isHidden = true
            myContentView.myTableView.frame.size.height = (myContentView.myTableView.frame.size.height + 54)
        }
    }
    
    
    //**********************************
    
    //将<10的数转换为01的形式
    func numChangeTwoDigital(num:Int) -> String
    {
        if num<10
        {
            return "0\(num)"
        }
        
        return "\(num)"
    }
    
    //UIVIew旋转的动画
    func viewRoateAnimation(view:UIView,fromDegree:Double,toDegree:Double,duration:Double) -> Void
    {
        var fromDegreeVar:Double = 0.0
        var toDegreeVar:Double = 0.0
        
        if fromDegree == 0
        {
            fromDegreeVar = 0
            toDegreeVar = Double.pi
        }
        if fromDegree == 180
        {
            fromDegreeVar = Double.pi
            toDegreeVar = Double.pi*2
        }
        
        let momAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        momAnimation.fromValue = NSNumber(value: fromDegreeVar) //左幅度
        momAnimation.toValue = NSNumber(value: toDegreeVar) //右幅度
        momAnimation.duration = duration
        
        //以下两行同时设置才能保持旋转后的位置状态不变
        momAnimation.fillMode = kCAFillModeForwards
        momAnimation.isRemovedOnCompletion = false
        
        //momAnimation.repeatCount = 0 //无限重复
        view.layer.add(momAnimation, forKey: "centerLayer")
    }
    
    
    //提示网络连接异常
    func tipNetWorkError(httpError:HttpError?) -> Void
    {
        if let error = httpError
        {
            switch error
            {
            case .timeout:
                
                self.showSystemAlertView(titleStr: NSLocalizedString("common.validate.hint", comment:"提示"), message: NSLocalizedString("common.validate.fail", comment:"失败"))
                
            case .serverException(let code,let message):
                print(message+"\(code)")
                self.showSystemAlertView(titleStr: NSLocalizedString("common.validate.hint", comment:"提示"), message: message)
                
            default :
                printDebugLog(message: "into here ...")
            }
        }
    }
    
}



extension CoOldApprovalOrderController:UITableViewDelegate,UITableViewDataSource,OnTableCellShowHideListener,OnMyTableViewFooterListener
{
    //订单详情底部的点击事件  和 顶部的点击事件
    func onClickListener(tableViewFooter:UIView,flagStr:String) -> Void
    {
        print("\(flagStr)")
        
        //TODO:底部的点击事件
        if  flagStr == CoApprovalOrderView.REJECT_APPROVAL  //审批拒绝
        {
            //self.present(CoApprovalOpinionController(), animated: true, completion: nil)
            
            let approvalOpinionController = CoApprovalOpinionController()
            
            approvalOpinionController.isAgreeOrderParams = false
            approvalOpinionController.isNewVersionParams = CoApprovalOrderView.isNewVersionOrder
            approvalOpinionController.orderNoParams = orderDetails.orderNo
            approvalOpinionController.currentApverIdParams = orderDetails.currentApvId
            approvalOpinionController.currentApvLevelParams = orderDetails.currentApvLevel
            
            self.navigationController?.pushViewController(approvalOpinionController, animated: true)
        }
        
        if  flagStr == CoApprovalOrderView.AGREE_APPROVAL  //审批同意   老版
        {
            let alertController = UIAlertController(title: "", message: NSLocalizedString("order.approval.order.ispass", comment:"通过审批?"),preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: NSLocalizedString("common.validate.cancel", comment:"取消"), style: .cancel, handler: nil)
            cancelAction.setValue(TBIThemePrimaryTextColor, forKey: "_titleTextColor")
            let okAction = UIAlertAction(title: NSLocalizedString("common.validate.ok", comment:"确定"), style: .default, handler:
            {action in
                print("^_^ 点击了确定  通过审批")
                
                let agreeBean = CoOldExanimeForm.Agree(currentApverId: self.orderDetails.currentApvId, currentApverLevel: self.orderDetails.currentApvLevel)
                
                self.showLoadingView()
                let coOldExanimeService = CoOldExanimeService.sharedInstance
                coOldExanimeService.agree(self.orderDetails.orderNo, form: agreeBean).subscribe{ event in
                    self.hideLoadingView()
                    if case .next(let e) = event
                    {
                        print("=^_^==agree==成功======")
                        
                        //已审批成功
                        //let alertSuccessApproval = UIAlertController(title: "", message: NSLocalizedString("order.approval.order.passed", comment:"已成功通过审批"),preferredStyle: .alert)
                        //let okApprovalAction = UIAlertAction(title: NSLocalizedString("common.validate.ok", comment:"确定"), style: .cancel, handler: nil)
                        //alertSuccessApproval.addAction(okApprovalAction)
                        //self.present(alertSuccessApproval, animated: true, completion: nil)
                        
                        let vc = CoApprovalSuccessController()
                        vc.type = .approval
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    if case .error(let e) = event
                    {
                        print("===agree==失败======")
                        print(e)
                        
                        if ((e as? HttpError) != nil)
                        {
                            self.tipNetWorkError(httpError: e as? HttpError)
                        }
                        
                    }
                    }.disposed(by: self.bag)
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    func onShowHide(tableCell:UITableViewCell,flagStr:String, indexPath:IndexPath) -> Void
    {
        var flightCount = 0
        if flightItems != nil {
            flightCount = flightItems.count
        }
        var hotelCount = 0
        if hotelItems != nil {
            hotelCount = hotelItems.count
        }
        var suranceCount = 0
        if suranceItems != nil {
            suranceCount = suranceItems.count
        }
        
        //展开订单的详情
        if flagStr == CoOrderDetailsCellViewFlight.FLIGHT_SHOWHIDE_DETAILS ||
            flagStr == CoOrderDetailsCellViewHotel.HOTEL_SHOWHIDE_DETAILS  ||
            flagStr == CoOrderDetailsCellViewInsurance.INSURANCE_SHOWHIDE_DETAILS
        {
            selectedCellIndexPath = indexPath
            
            var isShow = cellIsShowArray[indexPath.row]
            isShow = !isShow
            cellIsShowArray[indexPath.row] = isShow
            
            //myContentView.myTableView.reloadData()
            myContentView.myTableView.reloadRows(at: [indexPath], with: .fade)
        }
        else
        {
            print("^_^  flagStr = \(flagStr)")
            
            //机票费用 <---> 费用明细   的弹出框
            if flagStr == CoOrderDetailsCellViewFlight.FLIGHT_LOOK_CHARGE
            {
                
                let itemPos = indexPath.row
                let flightVo:CoOldOrderDetail.FlightVo = flightItems[itemPos]
                
                var showTextArray:[(String,String,String)] = []
                showTextArray.append((NSLocalizedString("order.details.adultflightticket", comment:"成人机票"),"x\(flightVo.passengers.count)"+NSLocalizedString("order.details.people", comment: "人"),"¥\((flightVo.price-flightVo.tax).description0)"))
                showTextArray.append((NSLocalizedString("order.details.airportbuildcharge", comment:"机场建设"),"x\(flightVo.passengers.count)"+NSLocalizedString("order.details.people", comment: "人"),"¥\(flightVo.tax.description0)"))
                showTextArray.append((NSLocalizedString("order.details.totalprice", comment:"订单总价"),"","¥\(flightVo.price.description0)"))
                
                let alertView = CoFlightChargeDetailsAlertView(frame: ScreenWindowFrame)
                alertView.showTextArray = showTextArray
                alertView.setSubUIViewlayout()
                KeyWindow?.addSubview(alertView)
                
            }
            
            
            //退改政策  <->   退改签说明   （不会出现往返程,往返程会拆成两个订单）
            if flagStr == CoOrderDetailsCellViewFlight.FLIGHT_CHANGE_POLICY
            {
                let itemPos = indexPath.row
                let flightVo = flightItems[itemPos]
                
                let title:[(title:String,content:String)] = [(NSLocalizedString("order.details.changeinduction", comment:"退改签说明"),"")]
                let subFirstTitle:[(title:String,content:String)] = [("",flightVo.ei.replacingOccurrences(of: "<br>", with: "\n"))]
                let tbiALertView = TBIAlertView.init(frame: ScreenWindowFrame)
                tbiALertView.setDataSources(dataSource: [title,subFirstTitle])
                KeyWindow?.addSubview(tbiALertView)
                
                
            }
            
            //理赔详情     <---->      理赔说明
            if flagStr == CoOrderDetailsCellViewInsurance.INSURANCE_GIVE_MONEY
            {
                let itemPos = indexPath.row-flightCount-hotelCount
                let insuranceVo = suranceItems[itemPos]
                
                let title:[(title:String,content:String)] = [(NSLocalizedString("order.details.payinduction", comment:"理赔说明"),"")]
                let subFirstTitle:[(title:String,content:String)] = [("",insuranceVo.suranceDescribe )]
                let tbiALertView = TBIAlertView.init(frame: ScreenWindowFrame)
                tbiALertView.setDataSources(dataSource: [title,subFirstTitle])
                KeyWindow?.addSubview(tbiALertView)
            }
            
            
            //删除订单。      老版暂时没有删除小订单功能
            //删除机票订单
            if flagStr == CoOrderDetailsCellViewFlight.FLIGHT_DEL_ORDER
            {
                
            }
            //删除酒店订单
            if flagStr == CoOrderDetailsCellViewHotel.HOTEL_DEL_ORDER
            {
                
            }
            //删除保险订单
            if flagStr == CoOrderDetailsCellViewInsurance.INSURANCE_DEL_ORDER
            {
                
            }
            
        }
        
        
    }
    
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var totalCount = 0
        
        
        if flightItems != nil {
            totalCount += self.flightItems.count
        }
        if hotelItems != nil {
            totalCount += self.hotelItems.count
        }
        if suranceItems != nil {
            totalCount += self.suranceItems.count
        }
        
        return totalCount
    }
    
    
    
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //        var cell:CoOldOrderDetailsTableCellView = CoOldOrderDetailsTableViewCell(style: .default, reuseIdentifier: tableViewCell_reuseIdentifier)
        
        
        var flightCount = 0
        if flightItems != nil {
            flightCount = flightItems.count
        }
        var hotelCount = 0
        if hotelItems != nil {
            hotelCount = hotelItems.count
        }
        var suranceCount = 0
        if suranceItems != nil {
            suranceCount = suranceItems.count
        }
        
        
        
        let isShow = cellIsShowArray[indexPath.row]
        
        var cell:UITableViewCell! = nil
        if indexPath.row < flightCount      //机票cell
        {
            let cellViewFlight:CoOrderDetailsCellViewFlight = Bundle.main.loadNibNamed("CoOldOrderDetailsTableCellView", owner: nil, options: nil)?[0] as! CoOrderDetailsCellViewFlight
            cellViewFlight.cellShowHideListener = self
            cellViewFlight.indexPath = indexPath
            cell = cellViewFlight
            
            cellViewFlight.btn_right_del_order.isHidden = true
            
            //中间详情 的 展开与收起
            let constrains = cellViewFlight.view_middlle_total_container.constraints
            for  constraint in constrains
            {
                if constraint.firstAttribute == NSLayoutAttribute.top
                {
                    
                    if isShow   //显示
                    {
                        cellViewFlight.top_shadow_5_line_view.isHidden = false
                        cellViewFlight.view_total_price_top_line.isHidden = false
                        cellViewFlight.view_middlle_total_container.isHidden = false
                        
                        constraint.constant = 0
                        
                        //设置TableViewCell的详情展开与隐藏动画
                        if selectedCellIndexPath != nil
                        {
                            if indexPath.row == self.selectedCellIndexPath.row
                            {
                                self.viewRoateAnimation(view: cellViewFlight.btn_top_show_hide_info, fromDegree: 0, toDegree: 180, duration: 0.3)
                            }
                        }
                    }
                    else   //隐藏
                    {
                        cellViewFlight.top_shadow_5_line_view.isHidden = true
                        cellViewFlight.view_total_price_top_line.isHidden = false
                        cellViewFlight.view_middlle_total_container.isHidden = true
                        
                        constraint.constant = -419
                        
                        
                        
                        //设置TableViewCell的详情展开与隐藏动画
                        if selectedCellIndexPath != nil
                        {
                            if indexPath.row == self.selectedCellIndexPath.row
                            {
                                self.viewRoateAnimation(view: cellViewFlight.btn_top_show_hide_info, fromDegree: 180, toDegree: 360, duration: 0.3)
                            }
                        }
                    }
                    
                }
            }
            
            
            let flightVo:CoOldOrderDetail.FlightVo = flightItems[indexPath.row]
            
            //机票当前的状态
            let flightTicketStatusStr = CoOldOrderDetailsController.getFlightStateStr(flightTicketState: flightVo.ticketState)
            
            cellViewFlight.btn_flight_order_status.isEnabled = false
            //设置小订单状态对应的文字和文字颜色
            cellViewFlight.btn_flight_order_status.setTitle(flightTicketStatusStr, for: .disabled)
            cellViewFlight.btn_flight_order_status.setTitleColor(flightVo.ticketState.color, for: .disabled)
            
            //符合差旅政策
            if flightVo.contrary == nil {
                cellViewFlight.showHideNotFitPolicyView(isShow: false)
            }
            else
            {
                cellViewFlight.showHideNotFitPolicyView(isShow: true)
                
                cellViewFlight.label_nofit_policy_content.text = flightVo.contrary?.contraryTravelPolicyDesc
                cellViewFlight.label_notfit_policy_reason_content.text = flightVo.contrary?.contraryReason
            }
            
            let legCount = flightVo.legs.count
            
            let takeOffInfo = flightVo.legs[0].takeOffAirportName.replacingOccurrences(of: "国际机场", with: "").replacingOccurrences(of: "机场", with: "")+flightVo.legs[0].takeOffTerminal
            let arriveInfo = flightVo.legs[legCount-1].arriveAirportName.replacingOccurrences(of: "国际机场", with: "").replacingOccurrences(of: "机场", with: "")+flightVo.legs[legCount-1].arriveTerminal
            cellViewFlight.label_top_big_title.text =  "\(takeOffInfo) - \(arriveInfo)"
            
            let takeOffMonthdayStr = "\(numChangeTwoDigital(num: flightVo.legs[0].takeOffTime.month))-\(numChangeTwoDigital(num: flightVo.legs[0].takeOffTime.day))"
            let takeOffHourMinute = "\(numChangeTwoDigital(num: flightVo.legs[0].takeOffTime.hour)):\(numChangeTwoDigital(num: flightVo.legs[0].takeOffTime.minute))"
            let arriveHourMinute = "\(numChangeTwoDigital(num: flightVo.legs[legCount-1].arriveTime.hour)):\(numChangeTwoDigital(num: flightVo.legs[legCount-1].arriveTime.minute))"
            cellViewFlight.label_top_sub_title.text = "\(takeOffMonthdayStr) \(takeOffHourMinute)\(NSLocalizedString("order.details.depart", comment:"出发"))   |   \(arriveHourMinute)\(NSLocalizedString("order.details.arrive", comment:"到达"))"
            
            cellViewFlight.label_ticket_num_content.text = "\(flightVo.legs[0].flightName) \(flightVo.legs[0].flightNo)"
            cellViewFlight.label_fly_time_content.text = "\(flightVo.flyTime)"
            
            var cabinType:String = flightVo.legs[0].cabinType
            if cabinType == "F" {
                cabinType = NSLocalizedString("order.details.flight.topcabin", comment:"头等舱")
            }
            else if cabinType == "C" {
                cabinType = NSLocalizedString("order.details.flight.businesscabin", comment:"公务舱")
            }
            else if cabinType == "Y" {
                cabinType = "经济舱"
            }
            cellViewFlight.label_cabin_content.text = cabinType
            
            //            //出票时限取消了
            //            cellViewFlight.label_ticket_out_timelimit_content.text = "取消"
            
            let passengers:[CoOldOrderDetail.FlightVo.Passenger] = flightVo.passengers
            cellViewFlight.addPassageInf(passengers: passengers)
            
            cellViewFlight.label_order_price.text = "¥\(flightVo.price.description0)"
            
            
            //联系人Tab
            cellViewFlight.label_bottom_contact_name_content.text = flightVo.contact.name
            cellViewFlight.label_bottom_contact_phone.text = flightVo.contact.mobile
            //设置联系人的电子邮件
            var emailArrayStr = ""
            for i in 0..<flightVo.contact.email.count
            {
                let emailStr = flightVo.contact.email[i]
                if i<=0
                {
                    emailArrayStr += emailStr
                }
                else   //不是第一个
                {
                    emailArrayStr += (","+emailStr)
                }
                
            }
            cellViewFlight.label_bottom_contact_email.text = emailArrayStr
            
            
        }
        else if indexPath.row < flightCount+hotelCount   //酒店
        {
            let cellViewHotel = Bundle.main.loadNibNamed("CoOldOrderDetailsTableCellView", owner: nil, options: nil)?[1] as! CoOrderDetailsCellViewHotel
            cellViewHotel.cellShowHideListener = self
            cellViewHotel.indexPath = indexPath
            
            cell = cellViewHotel
            
            
            cellViewHotel.btn_del_order.isHidden = true
            
            
            let constrains = cellViewHotel.view_middle_total_container.constraints
            for  constraint in constrains
            {
                if constraint.firstAttribute == NSLayoutAttribute.top
                {
                    
                    if isShow   //显示
                    {
                        cellViewHotel.top_shadow_5_line_view.isHidden = false
                        cellViewHotel.view_total_price_top_line.isHidden = false
                        cellViewHotel.view_middle_total_container.isHidden = false
                        
                        constraint.constant = 0
                        
                        //设置TableViewCell的详情展开与隐藏动画
                        if selectedCellIndexPath != nil
                        {
                            if indexPath.row == self.selectedCellIndexPath.row
                            {
                                self.viewRoateAnimation(view: cellViewHotel.top_right_showhide_details, fromDegree: 0, toDegree: 180, duration: 0.3)
                            }
                        }
                    }
                    else   //隐藏
                    {
                        cellViewHotel.top_shadow_5_line_view.isHidden = true
                        cellViewHotel.view_total_price_top_line.isHidden = false
                        cellViewHotel.view_middle_total_container.isHidden = true
                        
                        constraint.constant = -339
                        
                        
                        
                        //设置TableViewCell的详情展开与隐藏动画
                        if selectedCellIndexPath != nil
                        {
                            if indexPath.row == self.selectedCellIndexPath.row
                            {
                                self.viewRoateAnimation(view: cellViewHotel.top_right_showhide_details, fromDegree: 180, toDegree: 360, duration: 0.3)
                            }
                        }
                    }
                    
                }
            }
            
            let itemPos = indexPath.row - flightCount
            
            
            let hotelVo:CoOldOrderDetail.HotelVo = hotelItems[itemPos]
            
            //酒店订单当前的状态
            let hotelBookStatusStr = CoOldOrderDetailsController.getHotelBookStateStr(bookStatus: hotelVo.hotelBookState)
            cellViewHotel.btn_top_right_order_status.isEnabled = false
            //设置小订单状态对应的文字和文字颜色
            cellViewHotel.btn_top_right_order_status.setTitle(hotelBookStatusStr, for: .disabled)
            cellViewHotel.btn_top_right_order_status.setTitleColor(hotelVo.hotelBookState.color, for: .disabled)
            
            if hotelVo.contrary == nil   //符合差旅政策
            {
                cellViewHotel.showHideNotFitPolicyView(isShow: false)
            }
            else
            {
                cellViewHotel.showHideNotFitPolicyView(isShow: true)
                
                cellViewHotel.label_nofit_policy_content.text = hotelVo.contrary?.contraryTravelPolicyDesc
                cellViewHotel.label_nofit_policy_reason_content.text = hotelVo.contrary?.contraryReason
            }
            
            cellViewHotel.top_left_big_title.text = hotelVo.hotelName
            
            
            // "标准间"字段  -> 房型
            let bedTypeStr = hotelVo.roomType
            
            
            let checkInMonthDay = "\(numChangeTwoDigital(num: hotelVo.checkInDate.month))- \(numChangeTwoDigital(num: hotelVo.checkInDate.day))"
            let checkOutMonthDay = "\(numChangeTwoDigital(num: hotelVo.checkOutDate.month))- \(numChangeTwoDigital(num: hotelVo.checkOutDate.day))"
            let subTitleStr = "\(bedTypeStr)   |   \(checkInMonthDay)\(NSLocalizedString("order.details.hotel.checkin", comment:"入住"))   |   \(checkOutMonthDay)\(NSLocalizedString("order.details.hotel.leave", comment:"离店"))"
            cellViewHotel.top_left_sub_title.text = subTitleStr
            
            
            //床型
            cellViewHotel.label_house_type_content.text = hotelVo.bedTypeName
            cellViewHotel.label_late_time_content.text = hotelVo.arriveLastTime
            
            // 担保状态   退改政策取消
            cellViewHotel.label_protected_status_content.text = CoOldOrderDetailsController.getHotelGuaranteeStateStr(guaranteeState: hotelVo.guaranteeState)
            
            cellViewHotel.addPassageInf(passengers: hotelVo.passengers)
            
            //酒店的联系人   (不是入住人）
            cellViewHotel.label_bottom_contact_name_content.text = hotelVo.contact.name
            cellViewHotel.label_bottom_contact_phone_content.text = hotelVo.contact.mobile
            //设置联系人的电子邮件
            var emailArrayStr = ""
            for i in 0..<hotelVo.contact.email.count
            {
                let emailStr = hotelVo.contact.email[i]
                if i<=0
                {
                    emailArrayStr += emailStr
                }
                else   //不是第一个
                {
                    emailArrayStr += (","+emailStr)
                }
                
            }
            cellViewHotel.label_bottom_contact_email_contentt.text = emailArrayStr
            
            cellViewHotel.label_total_price_content.text = "¥\(hotelVo.price.description0)"
            
        }
        else if indexPath.row < flightCount+hotelCount+suranceCount       //保险cell
        {
            let cellViewInsurance = Bundle.main.loadNibNamed("CoOldOrderDetailsTableCellView", owner: nil, options: nil)?[2] as! CoOrderDetailsCellViewInsurance
            cellViewInsurance.cellShowHideListener = self
            cellViewInsurance.indexPath = indexPath
            
            cell = cellViewInsurance
            
            
            cellViewInsurance.btn_del_order.isHidden = true
            
            
            let constrains = cellViewInsurance.view_middlle_total_container.constraints
            for  constraint in constrains
            {
                if constraint.firstAttribute == NSLayoutAttribute.top
                {
                    
                    if isShow   //显示
                    {
                        cellViewInsurance.top_shadow_5_line_view.isHidden = false
                        cellViewInsurance.view_total_price_top_line.isHidden = false
                        cellViewInsurance.view_middlle_total_container.isHidden = false
                        
                        constraint.constant = 0
                        
                        
                        //设置TableViewCell的详情展开与隐藏动画
                        if selectedCellIndexPath != nil
                        {
                            if indexPath.row == self.selectedCellIndexPath.row
                            {
                                self.viewRoateAnimation(view: cellViewInsurance.btn_top_showhide, fromDegree: 0, toDegree: 180, duration: 0.3)
                            }
                        }
                    }
                    else   //隐藏
                    {
                        cellViewInsurance.top_shadow_5_line_view.isHidden = true
                        cellViewInsurance.view_total_price_top_line.isHidden = false
                        cellViewInsurance.view_middlle_total_container.isHidden = true
                        
                        constraint.constant = -271
                        
                        
                        
                        
                        //设置TableViewCell的详情展开与隐藏动画
                        if selectedCellIndexPath != nil
                        {
                            if indexPath.row == self.selectedCellIndexPath.row
                            {
                                self.viewRoateAnimation(view: cellViewInsurance.btn_top_showhide, fromDegree: 180, toDegree: 360, duration: 0.3)
                            }
                        }
                    }
                    
                }
            }
            
            let itemPos = indexPath.row - flightCount - hotelCount
            
            
            let insuranceVo:CoOldOrderDetail.SuranceVo = suranceItems[itemPos]
            
            //保险的状态
            let insuranceStatus = insuranceVo.suranceState
            let insuranceStatusStr = CoOldOrderDetailsController.getInsuranceStateStr(insuranceState: insuranceStatus)
            
            cellViewInsurance.btn_order_status.isEnabled = false
            //设置小订单状态对应的文字和文字颜色
            cellViewInsurance.btn_order_status.setTitle(insuranceStatusStr, for: .disabled)
            cellViewInsurance.btn_order_status.setTitleColor(insuranceStatus.color, for: .disabled)
            
            cellViewInsurance.label_top_big_title.text = insuranceVo.suranceCompany
            
            let startMonthDayStr = "\(numChangeTwoDigital(num: insuranceVo.startDate.month))-\(numChangeTwoDigital(num: insuranceVo.startDate.day))"
            let endMonthdayStr = "\(numChangeTwoDigital(num: insuranceVo.endDate.month))-\(numChangeTwoDigital(num: insuranceVo.endDate.day))"
            cellViewInsurance.label_sub_title.text = "\(startMonthDayStr)\(NSLocalizedString("order.details.insurance.start", comment:"生效"))   |   \(endMonthdayStr)\(NSLocalizedString("order.details.insurance.end", comment:"截止"))"
            
            
            cellViewInsurance.label_insurance_num.text = insuranceVo.suranceNo
            cellViewInsurance.label_insuranced_people_content.text = insuranceVo.insuredName
            
            //保险时效
            let startDateStr = "\(insuranceVo.startDate.year)-\(numChangeTwoDigital(num: insuranceVo.startDate.month))-\(numChangeTwoDigital(num: insuranceVo.startDate.day))"
            let endDateStr = "\(insuranceVo.endDate.year)-\(numChangeTwoDigital(num: insuranceVo.endDate.month))-\(numChangeTwoDigital(num: insuranceVo.endDate.day))"
            let  insurance_time_str = "\(startDateStr) ~ \(endDateStr)"
            cellViewInsurance.label_insurance_time_content.text = insurance_time_str
            
            cellViewInsurance.label_insurance_type.text = insuranceVo.suranceName
            
            cellViewInsurance.label_total_price.text = "¥\(insuranceVo.price.description0)"
            
            
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        myContentView.myTableView.deselectRow(at: indexPath, animated: true)
        
        //展开与隐藏订单的详情
        selectedCellIndexPath = indexPath
        var isShow = cellIsShowArray[indexPath.row]
        isShow = !isShow
        cellIsShowArray[indexPath.row] = isShow
        myContentView.myTableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    
}


