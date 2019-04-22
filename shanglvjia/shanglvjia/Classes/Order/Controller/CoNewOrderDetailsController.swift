//
//  CoNewOrderDetailsControllerViewController.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/6/5.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import RxSwift


class CoNewOrderDetailsController: CompanyBaseViewController
{
    //var cellIndexPath:IndexPath = IndexPath(row: 0, section: 0)
    
    
    private let oldVersionCellIdentify:String = "oldVersionCellIdentify"
    
    fileprivate let coOrderDetailsCellViewTrainIdentify = "coOrderDetailsCellViewTrainIdentify"
    
    fileprivate let coOrderDetailsCellViewCarIdentify = "coOrderDetailsCellViewCarIdentify"
    
    var topBackEvent:OrderDetailsBackEvent = .prePage
    
    //static var isNewVersionOrder:Bool = false
    
    //外部调用时传递过来的大订单号 参数
    var mBigOrderNOParams = "1000001502"
    
    var selectedCellIndexPath:IndexPath!
    
    let bag = DisposeBag()
    var contentView:CoOrderDetailsViewXib!
    
    var cellIsShowArray:[Bool]! = []
    //订单是否被删除的数组
    var cellOrder_IsDelArray:[Bool] = []
    
    
    var orderDetails:CoNewOrderDetail!
    /// 机票小订单
    var flightItems:[CoNewOrderDetail.FlightVo]!
    /// 酒店小订单
    var hotelItems:[CoNewOrderDetail.HotelVo]!
    /// 保险小订单
    var suranceItems:[CoNewOrderDetail.SuranceVo]!
    /// 火车票小订单
    var trainItems:[CoNewOrderDetail.TrainVo]!
    /// 专车小订单
    var carItems:[CoNewOrderDetail.CarVo]!
    
     //丰田销售 定制化  是否显示  0非丰田   1 丰田 //更改需求 但是这个 暂时保存
    private var showFTMSSectionSpecialConfig:NSInteger = 0
    
    
    //丰田销售 定制化  是否显示  0非丰田   1 丰田
    private var showFTMSSectionSpecialConfigVersionSecond:NSInteger = 0
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = NSLocalizedString("order.details.title", comment: "订单详情")   //"订单详情"
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont.systemFont(ofSize: 16),NSForegroundColorAttributeName:UIColor.white]
        setNavigationBackButton(backImage: "back")
        self.navigationController?.navigationBar.isTranslucent = false
        self.setNavigationBgColor(color:TBIThemeBlueColor)
        self.navigationController?.navigationBar.setBackgroundImage(UIColor.creatImageWithColor(color: TBIThemeBlueColor), for: .any, barMetrics: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        //self.navigationController?.navigationBar.shadowImage = UIImage.init(named: "border")
        
        
        // 丰田销售 定制化  version first 
        // 需求变更  暂时 保存
//        
//        if UserService.sharedInstance.userDetail()?.companyUser?.companyCode == Toyota {
//            showFTMSSectionSpecialConfig = 1
//        }
//        
        
        // 丰田销售 定制化 version second 
        if UserService.sharedInstance.userDetail()?.companyUser?.companyCode == Toyota {
            showFTMSSectionSpecialConfigVersionSecond = 1
        }

        CoOrderDetailsViewXib.isNewVersionOrder = true     //企业版新版
        if CompanyBaseViewController.isIphoneX() {
            contentView = CoOrderDetailsViewXib(frame: CGRect(x: 0, y: 0, width: ScreenWindowWidth, height: ScreentWindowHeight-87))
        }else {
            contentView = CoOrderDetailsViewXib(frame: CGRect(x: 0, y: 0, width: ScreenWindowWidth, height: ScreentWindowHeight-20-44))
        }
        
        //contentView = CoOrderDetailsViewXib(frame: CGRect(x: 0, y: 0, width: 0, height:0))
        self.view.addSubview(contentView)
        
        
        contentView.onContentFooterListener = self
        contentView.myTableView.delegate = self
        contentView.myTableView.dataSource = self
        contentView.myTableView.register(CoOrderDetailsCellViewTrain.self, forCellReuseIdentifier: coOrderDetailsCellViewTrainIdentify)
        
        contentView.myTableView.register(CoOrderDetailsCellViewTrain.self, forCellReuseIdentifier: coOrderDetailsCellViewTrainIdentify)
        
        contentView.myTableView.register(CoOrderDetailsCellViewCar.self, forCellReuseIdentifier: coOrderDetailsCellViewCarIdentify)
        
        //BUG 355
        //  modify  by manman  on start of line 
        
//        contentView.myTableView.register(UINib.init(nibName: "CoOldOrderDetailsTableCellView", bundle: nil), forCellReuseIdentifier: oldVersionCellIdentify)
        
        // end of line  2017-09-06
        
        //未加载数据前， 隐藏底部的布局
        contentView.tableFooterView.isHidden = true
        //未加载数据前， 隐藏底部的送审和取消的容器视图
        contentView.bottom2BtnContainerView.isHidden = true
        
        //setUp0()
        getCoNewOrderDetailsFromServer(orderParams: self.mBigOrderNOParams)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            self.navigationController?.navigationBar.isTranslucent = false
    }
    
    //重写  头部左侧的🔙Btn
    override func backButtonAction(sender: UIButton) {
        switch topBackEvent
        {
        case .prePage:
            self.navigationController?.popViewController(animated: true)
            self.navigationController?.navigationBar.shadowImage = UIImage.init(named: "border")
            
        case .orderList:
//            print("orderlist")
//            self.navigationController?.popToRootViewController(animated: false)
//            let tabbarView:BaseTabBarController = UIApplication.shared.keyWindow?.rootViewController as!BaseTabBarController
//            tabbarView.selectedIndex = 2
            popOrderView()
        case .homePage:
            //print("homePage")
            self.navigationController?.popToRootViewController(animated: false)
            let tabbarView:BaseTabBarController = UIApplication.shared.keyWindow?.rootViewController as!BaseTabBarController
            tabbarView.selectedIndex = 0
        }
    }
    
    //获取企业版新版订单详情。   从服务器
    func getCoNewOrderDetailsFromServer(orderParams:String) {
        
        self.showLoadingView()
        let orderService = CoNewOrderService.sharedInstance
        orderService.getDetailBy(orderParams)
            .subscribe{ event in
            self.hideLoadingView()
            if case .next(let e) = event
            {
                print("=^_^====成功======")
                
                self.orderDetails = e
                print(self.orderDetails)
                
                self.flightItems = []
                self.hotelItems = []
                self.suranceItems = []
                self.trainItems = []
                self.carItems = []
                //设置机票，酒店，保险小订单
                for item in self.orderDetails.flightItems //机票小订单
                {
                    if item.state != .delete
                    {
                        self.flightItems.append(item)
                    }
                }
                for item in self.orderDetails.hotelItems //酒店小订单
                {
                    if (item.state != .delete) && (item.hotelBookState != .deleteApply)
                    {
                        self.hotelItems.append(item)
                    }
                }
                for item in self.orderDetails.trainItems // 火车票小订单
                {
                    if (item.trainOrderStatus != .delete)
                    {
                        self.trainItems.append(item)
                    }
                }
                for item in self.orderDetails.carItems // 专车订单
                {
                    if (item.carOrderStatus != .delete)
                    {
                        self.carItems.append(item)
                    }
                }
                for item in self.orderDetails.suranceItems //保险小订单
                {
                    self.suranceItems.append(item)
                }
                
                
                var totalCount = 0
                if self.flightItems != nil {
                    totalCount += self.flightItems.count
                }
                if self.hotelItems != nil {
                    totalCount += self.hotelItems.count
                }
                if self.trainItems != nil {
                    totalCount += self.trainItems.count
                }
                if self.carItems != nil {
                    totalCount += self.carItems.count
                }
                if self.suranceItems != nil {
                    totalCount += self.suranceItems.count
                }
                
                self.cellIsShowArray = []
                self.cellOrder_IsDelArray = []
                for i in 0..<totalCount
                {
                    self.cellIsShowArray.append(false)
                    
                    //机票小订单
                    if i < self.flightItems.count
                    {
                        var isDEl = true
                        
                        let pos = i
                        let flightItem = self.flightItems[pos]
                        
                        if flightItem.state == .active
                        {
                            isDEl = false
                        }
                        
                        self.cellOrder_IsDelArray.append(isDEl)
                    }    //酒店小订单🏨
                    else if i < (self.flightItems.count + self.hotelItems.count)
                    {
                        var isDEl = true
                        
                        let pos = i - self.flightItems.count
                        let hotelItem = self.hotelItems[pos]
                        
                        if hotelItem.state == .active
                        {
                            isDEl = false
                        }
                        
                        self.cellOrder_IsDelArray.append(isDEl)
                    }// 火车票小订单
                    else if i < (self.flightItems.count + self.hotelItems.count + self.trainItems.count)
                    {
                        var isDEl = true
                        
                        let pos = i - self.flightItems.count - self.hotelItems.count
                        let trainItem = self.trainItems[pos]
                        
                        if  trainItem.bookedTrainStatus == .wait && trainItem.trainOrderStatus == .active
                        {
                            isDEl = false
                        }
                        
                        self.cellOrder_IsDelArray.append(isDEl)
                    }// 专车小订单
                    else if i < (self.flightItems.count + self.hotelItems.count + self.trainItems.count + self.carItems.count)
                    {
                        var isDEl = true
                        
                        let pos = i - self.flightItems.count - self.hotelItems.count - self.trainItems.count
                        let carItem = self.carItems[pos]
                        
                        if carItem.bookedCarStatus == .wait && carItem.carOrderStatus == .active
                        {
                            isDEl = false
                        }
                        
                        self.cellOrder_IsDelArray.append(isDEl)
                    }
                    else   //保险小订单
                    {
                        self.cellOrder_IsDelArray.append(false)
                    }
                }
                
                //设置TableView的头部的布局
                self.setMyTableHeadView()
                //设置TableView的尾部的布局
                self.setMyTableFooterView()
                //刷新TableView
                self.contentView.myTableView.reloadData()
            }
            if case .error(let e) = event
            {
                print("=====失败======\n \(e)")
                //处理异常
                try? self.validateHttp(e)
                
            }
            }.disposed(by: bag)
    }
    
    func setUp0() {
        
        let form  = CompanyLoginUserForm(userName: "testliu", passWord: "Aa111111", companyCode: "newobt")
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
                self.getCoNewOrderDetailsFromServer(orderParams: self.mBigOrderNOParams)
            }.disposed(by: bag)
        
        
    }
    
    func setCustomHeaderViewAutolayout(companyCode:String) {
        
        switch companyCode {
        case Toyota:
            
            setFTMSCustomUIViewAutolayout()
            
            
            break
        default:
            break
        }
        
        
        
    }
    
    
    //设置表格的头部的状态的视图
    func setMyTableHeadView() -> Void
    {
        
        guard showFTMSSectionSpecialConfigVersionSecond == 0 else {
            setCustomHeaderViewAutolayout(companyCode: Toyota)
            return
        }
        
        
        
        
        if self.orderDetails == nil
        {
            return
        }
        
        //orderDetails.state
        //contentView.tableHeadView?.setCurrentTotalOrderStatus(statusNum: 0)
        
        //新版进行相应的设置
        let createTimeStr = "\(self.orderDetails.createTime.year)-\(numChangeTwoDigital(num: self.orderDetails.createTime.month))-\(numChangeTwoDigital(num: self.orderDetails.createTime.day))  \(numChangeTwoDigital(num:self.orderDetails.createTime.hour)):\(numChangeTwoDigital(num: self.orderDetails.createTime.minute))"
        
        var passageNamesStr = ""
        for i in 0..<self.orderDetails.psgNames.count
        {
            let name = self.orderDetails.psgNames[i]
            
            if i != self.orderDetails.psgNames.count-1
            {
                passageNamesStr += (name+"、")
            }
            else
            {
                passageNamesStr += name
            }
        }
        
        //出差地点
        var placeNamesStr = ""
        for i in 0..<self.orderDetails.destinations.count
        {
            let name = self.orderDetails.destinations[i]
            
            if i != self.orderDetails.destinations.count-1
            {
                placeNamesStr += (name+"、")
            }
            else
            {
                placeNamesStr += name
            }
        }
        
        //出差时间
        var goBackTime =  ""
        
        if self.orderDetails.startDate != nil
        {
            
            
            var businessStartTimeStr:String = "\(NSLocalizedString("order.details.startjourney", comment:"出差"))" + numChangeTwoDigital(num: (self.orderDetails.startDate?.month)!) + "-"+(numChangeTwoDigital(num: (self.orderDetails.startDate?.day)!))
            if self.orderDetails.startDate?.year == 1970 {
                businessStartTimeStr = ""
            }
            
            
            goBackTime += businessStartTimeStr
        }
        if self.orderDetails.endDate != nil
        {
            var businessEndTimeStr:String = "  \(NSLocalizedString("order.details.backjourney", comment:"返程"))" + numChangeTwoDigital(num: (self.orderDetails.endDate?.month)!) + "-"+(numChangeTwoDigital(num: (self.orderDetails.endDate?.day)!))
            if self.orderDetails.endDate?.year == 1970 {
                businessEndTimeStr = ""
            }
            
            
            goBackTime +=  businessEndTimeStr
        }
        
        //先把数组清空。固定字段
        contentView.tableHeadView?.newVersionTopViewFixedDataSource = []
        //必须9个元素
        contentView.tableHeadView?.newVersionTopViewFixedDataSource.append((NSLocalizedString("order.details.orderno", comment:"出差单号"),self.orderDetails.orderNo))
        contentView.tableHeadView?.newVersionTopViewFixedDataSource.append((NSLocalizedString("order.details.create.user", comment:"创建用户"),self.orderDetails.createPsgName))
        contentView.tableHeadView?.newVersionTopViewFixedDataSource.append((NSLocalizedString("order.details.create.time", comment:"创建时间"),createTimeStr))
        
        contentView.tableHeadView?.newVersionTopViewFixedDataSource.append((NSLocalizedString("order.details.business.traveller", comment:"出差旅客"),passageNamesStr))
        contentView.tableHeadView?.newVersionTopViewFixedDataSource.append((NSLocalizedString("order.details.business.place", comment:"出差地点"),placeNamesStr))
        contentView.tableHeadView?.newVersionTopViewFixedDataSource.append((NSLocalizedString("order.details.business.time", comment:"出差时间"),goBackTime))
        
        // 成本中心  有改动，变为弹出窗口
        contentView.tableHeadView?.newVersionTopViewFixedDataSource.append((NSLocalizedString("order.details.costcenter", comment:"成本中心"),"XXX"))
        
        contentView.tableHeadView?.newVersionTopViewFixedDataSource.append((NSLocalizedString("order.details.business.purpose", comment:"出差目的"),self.orderDetails.purpose))
        contentView.tableHeadView?.newVersionTopViewFixedDataSource.append((NSLocalizedString("order.details.business.resaon", comment:"出差事由"),self.orderDetails.reason))
        
        
        //先把数组清空。自定义字段
        contentView.tableHeadView?.newVersionDIYDataSource = []
        
        let customTextArray:[CoNewOrderDetail.CustomText] = self.orderDetails.customFields
        for i in 0..<customTextArray.count
        {
            let customText = customTextArray[i]
            
            var contentStr = ""
            for k in 0..<customText.values.count
            {
                let itemStr = customText.values[k]
                if k != customText.values.count-1
                {
                    contentStr += (itemStr+"、")
                }
                else
                {
                    contentStr += itemStr
                }
            }
            
            //定制的字段
            contentView.tableHeadView?.newVersionDIYDataSource.append((customText.title,contentStr))
        }
        
        
        contentView.tableHeadView?.setNewVersionAddOrderDetailsView()
        contentView.updateNewVersionHeadViewSize()
        
        //设置顶部视图的监听器
        if contentView.tableHeadView?.onHeaderListener == nil
        {
            contentView.tableHeadView?.onHeaderListener = self
        }
        
        
        
        //订单状态
        
        var orderStatus:(currentIndex:Int,states:[CoOrderState])!
        do {
            try orderStatus = orderDetails.getStates()
        }
        catch let discription
        {
            print(discription)
        }
        
        let orderCurIndex = orderStatus.currentIndex
        let orderStateArray:[CoOrderState] = orderStatus.states
        var orderStatusStrArray:[String] = []
        for orderStatus in orderStateArray
        {
            orderStatusStrArray.append(CoNewOrderDetailsController.getOrderStateStr(orderState: orderStatus))
        }
        
        contentView.tableHeadView?.statusTextArray = orderStatusStrArray
        contentView.tableHeadView?.layoutTableTopView()
        contentView.tableHeadView?.setCurrentTotalOrderStatus(currentStatusNo: orderCurIndex)
        
    }
    
    // 设置表格的底部的视图
    func setMyTableFooterView() -> Void
    {
        
        if orderDetails == nil
        {
            return
        }
        
        //已成功从服务器加载数据
        contentView.tableFooterView.isHidden = false
        //设置底部视图的监听器
        if contentView.tableFooterView.onFooterListener == nil
        {
            contentView.tableFooterView.onFooterListener = self
        }
        
        //底部送审（包含取消与送审按钮）的容器视图
        contentView.tableFooterView.view_bottom_review_container.isHidden = true
        
        //设置审批记录的内容
        var reviewRecordArray:[(String,String,Int,Bool)] = []
        let historyApprovaCount:Int = orderDetails.historyApprovalInfos.count
        let sortHistoryApprovalInfos = orderDetails.historyApprovalInfos.sorted{$0.datetime < $1.datetime}
        
        for i in 0..<historyApprovaCount
        {
            let historyApprovaItem = sortHistoryApprovalInfos[i]//orderDetails.historyApprovalInfos[i]
            
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
            
            reviewRecordArray.append((historyApprovaItem.apverName,"\(historyApprovaItem.datetime.year)-\(approvaDate_Month_Str)-\(approvaDate_Day_Str)",historyApprovaItem.apverLevel,historyApprovaItem.apvResult))
        }
        //设置审批记录 的 列表视图
        contentView.tableFooterView.reviewRecordArray = reviewRecordArray
        contentView.tableFooterView.addReviewContentItemView()
        
        
        
//        //historyApprovaCount---审批记录数
//        //设置tableFooterView的大小    ******放在了后面
//        if historyApprovaCount > 0
//        {
//            //设置TableViewFooter的大小
//            contentView.myTableView.tableFooterView?.frame.size.height = CGFloat(316+((17+10)*(historyApprovaCount-1))) - 54
//        }
//        else
//        {
//            contentView.myTableView.tableFooterView?.frame.size.height = (316-54)
//        }
        
        
        
        var orderStatus:(currentIndex:Int,states:[CoOrderState])!
        do {
            try orderStatus = orderDetails.getStates()
        }
        catch let discription
        {
            print(discription)
        }
        let curStatus = orderStatus.states[orderStatus.currentIndex]
        //设置底部的按钮
        if curStatus == .approving   //审批中    显示底部的按钮
        {
            //contentView.tableFooterView.btn_bottom_to_review
            contentView.bottom2BtnContainerView.isHidden = false
            contentView.myTableView.frame.size.height = ScreentWindowHeight-20-44-54
            
            //只显示一个按钮🔘
            contentView.bottomLeftCancelBtn.isHidden = true
            contentView.bottomRightReViewBtn.snp.remakeConstraints{(make)->Void in
                make.left.right.top.bottom.equalTo(0)
            }
            contentView.bottomRightReViewBtn.backgroundColor = TBIThemeRedColor
            
            contentView.bottomRightReViewBtn.tag = CoOrderDetailsFooterView.STATUS_BTN_BACK_ORDER
            let revokeApprovalStr = NSLocalizedString("order.details.revokeapproval", comment: "撤回送审")
            contentView.bottomRightReViewBtn.setTitle(revokeApprovalStr, for: .normal)
        }
        else if (curStatus == .planing)||(curStatus == .rejected) //计划中||拒绝
        {
            contentView.bottom2BtnContainerView.isHidden = false
            contentView.myTableView.frame.size.height = ScreentWindowHeight-20-44-54
            
            //显示两个按钮 🔘🔘
            contentView.bottomLeftCancelBtn.isHidden = false
            contentView.bottomLeftCancelBtn.snp.remakeConstraints{(make)->Void in
                make.left.top.bottom.equalTo(0)
                make.width.equalToSuperview().multipliedBy(0.5)
            }
            contentView.bottomRightReViewBtn.snp.remakeConstraints{(make)->Void in
                make.right.top.bottom.equalTo(0)
                make.width.equalToSuperview().multipliedBy(0.5)
            }
            contentView.bottomLeftCancelBtn.backgroundColor = TBIThemeRedColor
            contentView.bottomRightReViewBtn.backgroundColor = TBIThemeGreenColor
            
            if orderDetails.approvalType == .approval && showFTMSSectionSpecialConfig == 0 && showFTMSSectionSpecialConfigVersionSecond == 0
            {
                contentView.bottomRightReViewBtn.tag = CoOrderDetailsFooterView.STATUS_BTN_TO_REVIEW
                contentView.bottomRightReViewBtn.setTitle(NSLocalizedString("order.details.approval", comment:"送审"), for: .normal)
            }
            else if (orderDetails.approvalType == .noApproval || showFTMSSectionSpecialConfig == 1 ||
                 showFTMSSectionSpecialConfigVersionSecond ==  1)
            {
                contentView.bottomRightReViewBtn.tag = CoOrderDetailsFooterView.STATUS_BTN_COMMIT_ORDER
                contentView.bottomRightReViewBtn.setTitle(NSLocalizedString("order.details.confirmcommit", comment:"确认提交"), for: .normal)
            }
        }
        else if curStatus == .passed //TODO:已通过
        {
            contentView.bottom2BtnContainerView.isHidden = false
            contentView.myTableView.frame.size.height = ScreentWindowHeight-20-44-54
            
            
            //只显示一个按钮🔘
            contentView.bottomLeftCancelBtn.isHidden = true
            contentView.bottomRightReViewBtn.snp.remakeConstraints{(make)->Void in
                make.left.right.top.bottom.equalTo(0)
            }
            contentView.bottomRightReViewBtn.backgroundColor = TBIThemeGreenColor
            
            contentView.bottomRightReViewBtn.tag = CoOrderDetailsFooterView.STATUS_BTN_CONFORM_SUBMIT_ORDER
            contentView.bottomRightReViewBtn.setTitle(NSLocalizedString("order.details.confirmcommit", comment:"确认提交"), for: .normal)
        }
        else   //TODO:隐藏底部的按钮  0🔘 problem
        {
            contentView.bottom2BtnContainerView.isHidden = true
            
            let frame0 = CGRect(x: 0, y: 0, width: self.contentView.frame.size.width, height: ScreentWindowHeight-20-44)
            contentView.myTableView.frame = frame0
            
            //self.view.layoutSubviews()
            //print("^_^  ccc")
        }
        
        
        
        
        //TODO:设置 "审批记录View" 和 "添加机票添加酒店"View 的 显示
        var tableFooterHeight = 0
        if orderDetails.approvalType == .approval && showFTMSSectionSpecialConfig == 0 && showFTMSSectionSpecialConfigVersionSecond == 0  //送审  显示 “审批记录” 视图
        {
            if historyApprovaCount > 0
            {
                tableFooterHeight += (132 + (17+10)*(historyApprovaCount-1))
            }
            else
            {
                tableFooterHeight += 132
            }
            
        }
        else  //无需送审
        {
            tableFooterHeight += 0
            
            contentView.tableFooterView.approvalRecordContainer.isHidden = true
            contentView.tableFooterView.approvalRecordContainer.snp.remakeConstraints{(make)->Void in
                make.left.right.top.equalTo(0)
                make.height.equalTo(0)
            }
            
            //分割线
            contentView.tableFooterView.approvalRecordContainerBottomSegLine.snp.remakeConstraints{(make)->Void in
                make.left.right.equalTo(0)
                make.top.equalTo(contentView.tableFooterView.approvalRecordContainer.snp.bottom)
                make.height.equalTo(0)
            }
        }
        
        if (curStatus == .planing)||(curStatus == .rejected) //计划中||拒绝     显示 “添加机票添加酒店” 按钮
        {
            tableFooterHeight += 130
            
            contentView.tableFooterView.view_addflighthotel_container.isHidden = false
            contentView.tableFooterView.view_addflighthotel_container.snp.remakeConstraints{(make)->Void in
                make.left.right.equalTo(0)
                make.top.equalTo(contentView.tableFooterView.approvalRecordContainerBottomSegLine.snp.bottom)
                make.height.equalTo(100)
            }
            
            //分割线
            contentView.tableFooterView.view_addflighthotel_container_bottom_segline.snp.remakeConstraints{(make)->Void in
                make.left.right.equalTo(0)
                make.top.equalTo(contentView.tableFooterView.view_addflighthotel_container.snp.bottom)
                make.height.equalTo(15)
            }
        }
        else  //隐藏 “添加机票添加酒店” 按钮
        {
            tableFooterHeight += 0
            
            contentView.tableFooterView.view_addflighthotel_container.isHidden = true
            contentView.tableFooterView.view_addflighthotel_container.snp.remakeConstraints{(make)->Void in
                make.left.right.equalTo(0)
                make.top.equalTo(contentView.tableFooterView.approvalRecordContainerBottomSegLine.snp.bottom)
                make.height.equalTo(0)
            }
            
            //分割线
            contentView.tableFooterView.view_addflighthotel_container_bottom_segline.snp.remakeConstraints{(make)->Void in
                make.left.right.equalTo(0)
                make.top.equalTo(contentView.tableFooterView.view_addflighthotel_container.snp.bottom)
                make.height.equalTo(0)
            }
        }
        contentView.myTableView.tableFooterView?.frame.size.height = CGFloat(tableFooterHeight)
        
        //TODO:设置”修改出差单“的样式
        if (curStatus == .planing)||(curStatus == .rejected) //计划中||拒绝   "修改出差单"按钮🔘 可用
        {
            contentView.tableHeadView?.changeOrderBtn.isEnabled = true
            contentView.tableHeadView?.changeOrderBtn.setTitleColor(TBIThemeBlueColor, for: .normal)
        }
        else   //"修改出差单"按钮🔘 不可用
        {
            contentView.tableHeadView?.changeOrderBtn.isEnabled = false
            contentView.tableHeadView?.changeOrderBtn.setTitleColor(TBIThemeTipTextColor, for: .disabled)
        }
        
        
        
//        //*****在此处。 设置tableFooterView的大小
//        if historyApprovaCount > 0
//        {
//            //设置TableViewFooter的大小
//            contentView.myTableView.tableFooterView?.frame.size.height = CGFloat(316+((17+10)*(historyApprovaCount-1))) - 54
//        }
//        else
//        {
//            contentView.myTableView.tableFooterView?.frame.size.height = (316-54)
//        }
        
        
        
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
    
    
    //设置TableViewCell的 订单是否为删除状态
    func setOrderViewDelStatus(isDel:Bool,priceLabel:UILabel,delButton:UIButton) -> Void
    {
        if isDel
        {
            delButton.isEnabled = false
            delButton.backgroundColor = TBIThemeBaseColor
            delButton.setTitleColor(TBIThemeTipTextColor, for: .disabled)
            
            delButton.layer.cornerRadius = 3
            let colorref = TBIThemeTipTextColor.cgColor
            delButton.layer.borderColor = colorref
            delButton.layer.borderWidth = 1
            
            
            priceLabel.textColor = TBIThemeTipTextColor
        }
        else
        {
            var orderStatus:(currentIndex:Int,states:[CoOrderState])!
            do {
                try orderStatus = orderDetails.getStates()
            }
            catch let discription
            {
                print(discription)
            }
            let curStatus = orderStatus.states[orderStatus.currentIndex]
            
            
            
            if (curStatus == .planing) || (curStatus == .rejected)
            {
                delButton.isEnabled = true
                delButton.backgroundColor = UIColor.clear
                delButton.setTitleColor(TBIThemeRedColor, for: .normal)
                
                delButton.layer.cornerRadius = 3
                let colorref = TBIThemeRedColor.cgColor
                delButton.layer.borderColor = colorref
                delButton.layer.borderWidth = 1
            }
            else
            {
                delButton.isEnabled = false
                delButton.backgroundColor = UIColor.clear
                delButton.setTitleColor(TBIThemeTipTextColor, for: .disabled)
                
                delButton.layer.cornerRadius = 3
                let colorref = TBIThemeTipTextColor.cgColor
                delButton.layer.borderColor = colorref
                delButton.layer.borderWidth = 1
            }
            
            //左侧价格的颜色
            priceLabel.textColor = TBIThemeOrangeColor
        }
    }
    
    
    // 获取旅客List的详情
    func getTravelListFromServer(travelIdList:[String]) -> Void
    {
        self.showLoadingView()
        let hotelService = HotelCompanyService.sharedInstance
        hotelService
            .getTravellersBy(travelIdList)
            .subscribe{ event in
                self.hideLoadingView()
                if case .next(let e) = event {
                    print("=====成功======")
                    print(e)
                    
                    //进行页面的跳转
                    let travelList:[Traveller] = e
                    
                    //searchTravellerResult.removeAll()
                    PassengerManager.shareInStance.passengerDeleteAll()
                    for i in 0..<travelList.count
                    {
                        let travel = travelList[i]
                        //searchTravellerResult.append(travel)
                        PassengerManager.shareInStance.passengerAdd(passenger: travel)
                    }
                    
                    if CoOrderSelectedPsgView.addType == .flight  //  去添加机票
                    {
                        //let flightSearchViewController = FlightSearchViewController()
                        let flightSearchViewController = FlightSVSearchViewController()
                        flightSearchViewController.travelNo = self.orderDetails.orderNo
                        self.navigationController?.navigationBar.shadowImage = UIImage.init(named: "border")
                        self.navigationController?.pushViewController(flightSearchViewController, animated: true)
                    }
                    else  if CoOrderSelectedPsgView.addType == .hotel   //去添加酒店
                    {
                        //print("去添加酒店")
                        
                        //personalDataSourcesArr = searchTravellerResult
                        //let searchCompanyView = HotelCompanySearchViewController()
                        let searchCompanyView = HotelSVCompanySearchViewController()
                        searchCompanyView.travelNo = self.orderDetails.orderNo    //订单号
                        self.navigationController?.pushViewController(searchCompanyView, animated: true)
                    }else if CoOrderSelectedPsgView.addType == .train {
                        let searchCompanyView = CoTrainSearchViewController()
                        searchCompanyView.travelNo = self.orderDetails.orderNo    //订单号
                        self.navigationController?.pushViewController(searchCompanyView, animated: true)
                    }else if CoOrderSelectedPsgView.addType == .car {
                        let vc = CoCarSearchViewController()
                        vc.travelNo = self.orderDetails.orderNo
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
//                    if CoOrderSelectedPsgView.isAddFlight  //  去添加机票
//                    {
//                        let flightSearchViewController = FlightSearchViewController()
//                        flightSearchViewController.travelNo = self.orderDetails.orderNo
//                        self.navigationController?.navigationBar.shadowImage = UIImage.init(named: "border")
//                        self.navigationController?.pushViewController(flightSearchViewController, animated: true)
//                    }
//                    else    //去添加酒店
//                    {
//                        //print("去添加酒店")
//
//                        //personalDataSourcesArr = searchTravellerResult
//                        let searchCompanyView = HotelCompanySearchViewController()
//                        searchCompanyView.travelNo = self.orderDetails.orderNo    //订单号
//                        self.navigationController?.pushViewController(searchCompanyView, animated: true)
//                    }
                    
                    
                }
                if case .error(let e) = event {
                    print("=====失败======\n \(e)")
                    //处理异常
                    try? self.validateHttp(e)
                }
            }.disposed(by: bag)
    }
    
    func setFTMSCustomUIViewAutolayout() {
        
        
        
        
        
        
        
        //订单状态
        
        var orderStatus:(currentIndex:Int,states:[CoOrderState])!
        do {
            try orderStatus = orderDetails.getStates()
        }
        catch let discription
        {
            print(discription)
        }
        
        let orderCurIndex = orderStatus.currentIndex
        let orderStateArray:[CoOrderState] = orderStatus.states
        var orderStatusStrArray:[String] = []
        for orderStatus in orderStateArray
        {
            orderStatusStrArray.append(CoNewOrderDetailsController.getOrderStateStr(orderState: orderStatus))
        }
        contentView.tableCustomHeaderView = OrderDetailCompanyTableHeaderView(frame: CGRect(x: 0, y: 0, width: ScreenWindowWidth, height: 260))
        var orderInfoTmpArr:[(title:String ,content:String)] = Array()
        
        orderInfoTmpArr.append((title:"出差单号", content: self.orderDetails.orderNo))
        orderInfoTmpArr.append((title: "出差旅客", content: self.orderDetails.psgNames.toString()))
        orderInfoTmpArr.append((title: "创建用户", content: self.orderDetails.createPsgName))
        orderInfoTmpArr.append((title: "创建时间", content: self.orderDetails.createTime.string(custom:"yyyy-MM-dd hh:mm")))
        
        contentView.tableCustomHeaderView?.orderInfoArr = orderInfoTmpArr
        contentView.tableCustomHeaderView?.statusTextArray = orderStatusStrArray
        contentView.tableCustomHeaderView?.layoutTableTopView()
        contentView.tableCustomHeaderView?.setCurrentTotalOrderStatus(currentStatusNo: orderCurIndex)
        contentView.setFTMSCustomUIViewAutolayout()
    }
    
    
    
    
    
    
    
    
    
    
    
}

//处理TableView的TableViewCell
extension CoNewOrderDetailsController:UITableViewDelegate,UITableViewDataSource,OnTableCellShowHideListener,OnMyTableViewFooterListener, OnMyTableViewHeaderListener,SelectOrderPsgListener
{
    //从列表 选择乘客的 点击事件
    func selectedPsgClk(clkView:UIView,indexArray:[Int]) -> Void
    {
        //  去添加机票 || 去添加酒店
        if indexArray.count <= 0
        {
            print("^_^   请至少选择1个旅客")
            
            let alertController = UIAlertController(title: "", message: NSLocalizedString("order.details.choose.passager.hint", comment:"请至少选择1个旅客"),preferredStyle: .alert)
            let okAction = UIAlertAction(title: NSLocalizedString("common.validate.ok", comment:"确定"), style: .default, handler:nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        
        var travelIdList:[String] = []
        for i in 0..<indexArray.count
        {
            travelIdList.append(orderDetails.psgInfos[indexArray[i]].id)
        }
        getTravelListFromServer(travelIdList: travelIdList)
    }
    
    //订单详情底部的点击事件  和 顶部的点击事件
    func onClickListener(tableViewFooter:UIView,flagStr:String) -> Void
    {
        //顶部的点击事件
        //TODO: 修改出差单Clk
        if flagStr == CoOrderDetailsTableHeadView.CHANGR_ORDER_DETAILS  //修改出差单
        {
            print("^_^  CHANGR_ORDER_DETAILS")
            
            let vc = CoNewUpdateTravelNoViewController()
            vc.coNewOrderDetail = orderDetails
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if flagStr == CoOrderDetailsTableHeadView.COST_CENTER_CLK  //成本中心
        {
            print("^_^  COST_CENTER_CLK")
            
            var alertContentArray:[(key:String,value:String)] = []
            for i in 0..<orderDetails.psgNames.count
            {
                let psgName = orderDetails.psgNames[i]
                
                var costName = ""
                if orderDetails.costCenterNames.count == 1 {
                    var name = orderDetails.costCenterNames[0].components(separatedBy: ",")
                    if  i < name.count  {
                         costName = name[i]
                    }
                   
                }
                
//                if i >= orderDetails.costCenterNames.count  //旅客数比成本中心"多" （成本中心"少"）
//                {
//                    if orderDetails.costCenterNames.count == 1
//                    {
//
//                        costName = orderDetails.costCenterNames[0]
//                    }
//                }
//                else    //如果成本中心数 >= 旅客数
//                {
//                    costName = orderDetails.costCenterNames[i]
//                }
                
                alertContentArray.append((psgName,costName))
            }
            
            let tbiALertView2 = TBIAlertView2.init(frame: ScreenWindowFrame)
            tbiALertView2.titleStr = NSLocalizedString("order.details.costcenter", comment: "成本中心")   //"成本中心"
            tbiALertView2.dataSource = alertContentArray
            tbiALertView2.initView()
            KeyWindow?.addSubview(tbiALertView2)
        }
        
        
        //底部的点击事件
        //添加机票
        if flagStr == CoOrderDetailsFooterView.ADD_FLIGHT_CLK
        {
            print("^_^  ADD_FLIGHT_CLK")
            
            CoOrderSelectedPsgView.isAddFlight = true
            CoOrderSelectedPsgView.addType = .flight
            // 旅客数 > 1 时
            if orderDetails.psgInfos.count > 1
            {
                let alert = CoOrderSelectedPsgView(frame: ScreenWindowFrame)
                alert.psgNameArray = []
                for pasInf in orderDetails.psgInfos
                {
                    if pasInf.emails.count > 0
                    {
                        alert.psgNameArray.append((name:pasInf.name,email:pasInf.emails[0]))
                    }
                    else
                    {
                        alert.psgNameArray.append((name:pasInf.name,email:""))
                    }
                }
                alert.selectOrderPsgListener = self
                alert.initView()
                KeyWindow?.addSubview(alert)
            }
            else  // 旅客数 <= 1
            {
                self.selectedPsgClk(clkView:UIView(),indexArray:[0])
            }
            
        }
        else if flagStr == CoOrderDetailsFooterView.ADD_HOTEL_CLK   //添加酒店
        {
            print("^_^  ADD_HOTEL_CLK")
            
            CoOrderSelectedPsgView.isAddFlight = false
            CoOrderSelectedPsgView.addType = .hotel
            // 旅客数 > 1 时
            if orderDetails.psgInfos.count > 1
            {
                let alert = CoOrderSelectedPsgView(frame: ScreenWindowFrame)
                alert.psgNameArray = []
                for pasInf in orderDetails.psgInfos
                {
                    if pasInf.emails.count > 0
                    {
                        alert.psgNameArray.append((name:pasInf.name,email:pasInf.emails[0]))
                    }
                    else
                    {
                        alert.psgNameArray.append((name:pasInf.name,email:""))
                    }
                }
                alert.selectOrderPsgListener = self
                alert.initView()
                KeyWindow?.addSubview(alert)
            }
            else  // 旅客数 <= 1
            {
                self.selectedPsgClk(clkView:UIView(),indexArray:[0])
            }
            
        }
        else if flagStr == CoOrderDetailsFooterView.ADD_TRAIN_CLK   //添加火车票
        {
            print("^_^  ADD_TRAIN_CLK")
            
            CoOrderSelectedPsgView.isAddFlight = false
            CoOrderSelectedPsgView.addType = .train
            // 旅客数 > 1 时
            if orderDetails.psgInfos.count > 1
            {
                let alert = CoOrderSelectedPsgView(frame: ScreenWindowFrame)
                alert.psgNameArray = []
                for pasInf in orderDetails.psgInfos
                {
                    if pasInf.emails.count > 0
                    {
                        alert.psgNameArray.append((name:pasInf.name,email:pasInf.emails[0]))
                    }
                    else
                    {
                        alert.psgNameArray.append((name:pasInf.name,email:""))
                    }
                }
                alert.selectOrderPsgListener = self
                alert.initView()
                KeyWindow?.addSubview(alert)
            }
            else  // 旅客数 <= 1
            {
                self.selectedPsgClk(clkView:UIView(),indexArray:[0])
            }
            
        }
        else if flagStr == CoOrderDetailsFooterView.ADD_CAR_CLK   //添加专车
        {
            print("^_^  ADD_CAR_CLK")
            
            CoOrderSelectedPsgView.isAddFlight = false
            CoOrderSelectedPsgView.addType = .car
            // 旅客数 > 1 时
            if orderDetails.psgInfos.count > 1
            {
                let alert = CoOrderSelectedPsgView(frame: ScreenWindowFrame)
                alert.psgNameArray = []
                for pasInf in orderDetails.psgInfos
                {
                    if pasInf.emails.count > 0
                    {
                        alert.psgNameArray.append((name:pasInf.name,email:pasInf.emails[0]))
                    }
                    else
                    {
                        alert.psgNameArray.append((name:pasInf.name,email:""))
                    }
                }
                alert.selectOrderPsgListener = self
                alert.initView()
                KeyWindow?.addSubview(alert)
            }
            else  // 旅客数 <= 1
            {
                self.selectedPsgClk(clkView:UIView(),indexArray:[0])
            }
            
        }
        else if flagStr == CoOrderDetailsViewXib.CANCEL_REVIEW_CLK   //取消送审
        {
            //print("^_^  CANCEL_REVIEW_CLK self.orderDetails.orderNo=\(self.orderDetails.orderNo)")
            
            let alertController = UIAlertController(title: "", message: NSLocalizedString("order.details.iscancelapproval", comment:"是否取消?"),preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: NSLocalizedString("common.validate.cancel", comment:"取消"), style: .cancel, handler: nil)
            cancelAction.setValue(TBIThemePrimaryTextColor, forKey: "_titleTextColor")
            let okAction = UIAlertAction(title: NSLocalizedString("common.validate.ok", comment:"确定"), style: .default, handler:
            {action in
                
                self.showLoadingView()
                let orderService = CoNewOrderService.sharedInstance
                orderService.cancelBy(self.orderDetails.orderNo).subscribe{ event in
                    self.hideLoadingView()
                    if case .next(let e) = event
                    {
                        print("=^_^====取消送审 成功======")
                        let orderDetails0 = e
                        //刷新整个页面
                        self.getCoNewOrderDetailsFromServer(orderParams: orderDetails0.orderNo)
                    }
                    if case .error(let e) = event
                    {
                        print("=====失败======\n \(e)")
                        //let error = e as? HttpError
                        self.tipNetWorkError(httpError: e as? HttpError)
                    }
                }.disposed(by: self.bag)
                
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
        else if flagStr == CoOrderDetailsViewXib.TO_REVIEW_CLK   //去送审
        {
//            let tableViewFooter:CoOrderDetailsFooterView = tableViewFooter as! CoOrderDetailsFooterView
            
            print("^_^  TO_REVIEW_CLK tag=\(contentView.bottomRightReViewBtn.tag)")
            
            //去送审
            if contentView.bottomRightReViewBtn.tag == CoOrderDetailsFooterView.STATUS_BTN_TO_REVIEW
            {
                
                print("^_^  STATUS_BTN_TO_REVIEW")
                
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
                
                //TODO:是否有小订单处于删除申请中 - 去送审
                var isItemDeleteApplying = false
                //若酒店小订单处于“删除申请中”状态，则对话框提示不能送审
                for hotelItem in orderDetails.hotelItems
                {
                    if hotelItem.hotelBookState == .deleteApply  //删除申请中
                    {
                        isItemDeleteApplying = true
                        break
                    }
                }
                
                if isItemDeleteApplying      //有小订单（酒店🏨）处于删除申请中
                {
                    let alertController = UIAlertController(title: "", message: "订单删除申请中不能送审，请联系您的差旅顾问或重新创建出差单",preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "确认", style: .cancel, handler: nil)
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                else if totalCount <= 0   //没有小订单  弹出"对话框"询问
                {
                    let alertController = UIAlertController(title: "", message: "送审订单?",preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                    cancelAction.setValue(TBIThemePrimaryTextColor, forKey: "_titleTextColor")
                    let okAction = UIAlertAction(title: "确定", style: .default, handler:
                    {action in
                        let coNewExamineViewController = CoNewExamineViewController()
                        coNewExamineViewController.orderNoArr = [self.orderDetails.orderNo]
                        self.navigationController?.pushViewController(coNewExamineViewController, animated: true)
                    })
                    alertController.addAction(cancelAction)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                else    //含有小订单
                {
                    //新版订单送审
                    let coNewExamineViewController = CoNewExamineViewController()
                    coNewExamineViewController.orderNoArr = [orderDetails.orderNo]
                    self.navigationController?.pushViewController(coNewExamineViewController, animated: true)
                }
                
                
            }   //提交订单
            else if contentView.bottomRightReViewBtn.tag == CoOrderDetailsFooterView.STATUS_BTN_COMMIT_ORDER
            {
                //TODO:是否有小订单处于删除申请中  - 提交订单
                var isItemDeleteApplying = false
                //若酒店小订单处于“删除申请中”状态，则对话框提示不能确认提交
                for hotelItem in orderDetails.hotelItems
                {
                    if hotelItem.hotelBookState == .deleteApply  //删除申请中
                    {
                        isItemDeleteApplying = true
                        break
                    }
                }
                if isItemDeleteApplying      //有小订单（酒店🏨）处于删除申请中
                {
                    let alertController = UIAlertController(title: "", message: "订单删除申请中不能提交，请联系您的差旅顾问或重新创建出差单",preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "确认", style: .cancel, handler: nil)
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                
                
                
                let alertController = UIAlertController(title: "", message: NSLocalizedString("order.details.iscommitorder", comment:"提交订单?"),preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: NSLocalizedString("common.validate.cancel", comment:"取消"), style: .cancel, handler: nil)
                cancelAction.setValue(TBIThemePrimaryTextColor, forKey: "_titleTextColor")
                let okAction = UIAlertAction(title: NSLocalizedString("common.validate.ok", comment:"确定"), style: .default, handler:
                {action in
                    
                    self.showLoadingView()
                    let orderService = CoNewOrderService.sharedInstance
                    orderService.submit(self.orderDetails.orderNo).subscribe{ event in
                        self.hideLoadingView()
                        if case .next(let e) = event
                        {
                            print("=^_^====提交订单 成功======")
                            let orderDetails0 = e
                            //刷新整个页面
                            self.getCoNewOrderDetailsFromServer(orderParams: orderDetails0.orderNo)
                            
                            let vc = CoApprovalSuccessController()
                            vc.type = .refer //提交订单 成功
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        if case .error(let e) = event
                        {
                            print("=====提交订单 失败======\n \(e)")
                            //let error = e as? HttpError
                            self.tipNetWorkError(httpError: e as? HttpError)
                        }
                        }.disposed(by: self.bag)
                    
                })
                alertController.addAction(cancelAction)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                
            }   //撤回订单
            else if contentView.bottomRightReViewBtn.tag == CoOrderDetailsFooterView.STATUS_BTN_BACK_ORDER
            {
                
                let alertController = UIAlertController(title: "", message: NSLocalizedString("order.details.isrevokeapproval", comment:"撤回订单?"),preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: NSLocalizedString("common.validate.cancel", comment:"取消"), style: .cancel, handler: nil)
                cancelAction.setValue(TBIThemePrimaryTextColor, forKey: "_titleTextColor")
                let okAction = UIAlertAction(title: NSLocalizedString("common.validate.ok", comment:"确定"), style: .default, handler:
                {action in
                    
                    self.showLoadingView()
                    let orderService = CoNewOrderService.sharedInstance
                    orderService.revokeBy(self.orderDetails.orderNo).subscribe{ event in
                        self.hideLoadingView()
                        if case .next(let e) = event
                        {
                            print("=^_^====撤回订单 成功======")
                            let orderDetails0 = e
                            //刷新整个页面
                            self.getCoNewOrderDetailsFromServer(orderParams: orderDetails0.orderNo)
                        }
                        if case .error(let e) = event
                        {
                            print("=====撤回订单 失败======\n \(e)")
                            //let error = e as? HttpError
                            self.tipNetWorkError(httpError: e as? HttpError)
                        }
                        }.disposed(by: self.bag)
                    
                })
                alertController.addAction(cancelAction)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                
            }   //TODO:确认提交订单
            else if contentView.bottomRightReViewBtn.tag == CoOrderDetailsFooterView.STATUS_BTN_CONFORM_SUBMIT_ORDER
            {
                
                let alertController = UIAlertController(title: "", message: NSLocalizedString("order.details.isconfirmcommit", comment:"确认提交订单?"),preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: NSLocalizedString("common.validate.cancel", comment:"取消"), style: .cancel, handler: nil)
                cancelAction.setValue(TBIThemePrimaryTextColor, forKey: "_titleTextColor")
                let okAction = UIAlertAction(title: NSLocalizedString("common.validate.ok", comment:"确定"), style: .default, handler:
                {action in
                    
                    self.showLoadingView()
                    let orderService = CoNewOrderService.sharedInstance
                    orderService.confirmBy(self.orderDetails.orderNo).subscribe{ event in
                        self.hideLoadingView()
                        if case .next(let e) = event
                        {
                            print("=^_^====确认提交订单 成功======")
                            let orderDetails0 = e
                            //刷新整个页面
                            self.getCoNewOrderDetailsFromServer(orderParams: orderDetails0.orderNo)
                        }
                        if case .error(let e) = event
                        {
                            print("=====确认提交订单 失败======\n \(e)")
                            //let error = e as? HttpError
                            self.tipNetWorkError(httpError: e as? HttpError)
                        }
                        }.disposed(by: self.bag)
                    
                })
                alertController.addAction(cancelAction)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
            
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
        var trainCount = 0
        if trainItems != nil {
            trainCount = trainItems.count
        }
        var carCount = 0
        if carItems != nil {
            carCount = carItems.count
        }
        var suranceCount = 0
        if suranceItems != nil {
            suranceCount = suranceItems.count
        }
        
        //展开订单的详情
        if flagStr == CoOrderDetailsCellViewFlight.FLIGHT_SHOWHIDE_DETAILS ||
            flagStr == CoOrderDetailsCellViewHotel.HOTEL_SHOWHIDE_DETAILS  ||
            flagStr == CoOrderDetailsCellViewInsurance.INSURANCE_SHOWHIDE_DETAILS ||
            flagStr == CoOrderDetailsCellViewTrain.TRAIN_SHOWHIDE_DETAILS ||
            flagStr == CoOrderDetailsCellViewCar.CAR_SHOWHIDE_DETAILS
        {
            selectedCellIndexPath = indexPath
            
            var isShow = cellIsShowArray[indexPath.row]
            isShow = !isShow
            cellIsShowArray[indexPath.row] = isShow
            
            //contentView.myTableView.reloadData()
            contentView.myTableView.reloadRows(at: [indexPath], with: .fade)
        }
        else
        {
            print("^_^  flagStr = \(flagStr)")
            
            //机票费用 <---> 费用明细   的弹出框
            if flagStr == CoOrderDetailsCellViewFlight.FLIGHT_LOOK_CHARGE
            {
                
                let itemPos = indexPath.row
                let flightVo:CoNewOrderDetail.FlightVo = flightItems[itemPos]
                
                var showTextArray:[(String,String,String)] = []
                showTextArray.append((NSLocalizedString("order.details.adultflightticket", comment:"成人机票"),"x\(flightVo.passengers.count)"+NSLocalizedString("order.details.people", comment: "人"),"¥\(flightVo.price.description0)"))
                showTextArray.append((NSLocalizedString("order.details.airportbuildcharge", comment:"机场建设"),"x\(flightVo.passengers.count)"+NSLocalizedString("order.details.people", comment: "人"),"¥\(flightVo.tax.description0)"))
                showTextArray.append((NSLocalizedString("order.details.totalprice", comment:"订单总价"),"","¥\((flightVo.price + flightVo.tax).description0)"))
                
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
                let itemPos = indexPath.row-flightCount-hotelCount-trainCount-carCount
                let insuranceVo = suranceItems[itemPos]
                
                let title:[(title:String,content:String)] = [(NSLocalizedString("order.details.payinduction", comment:"理赔说明"),"")]
                let subFirstTitle:[(title:String,content:String)] = [("",insuranceVo.suranceDescribe )]
                let tbiALertView = TBIAlertView.init(frame: ScreenWindowFrame)
                tbiALertView.setDataSources(dataSource: [title,subFirstTitle])
                KeyWindow?.addSubview(tbiALertView)
            }
            
            
            
            //删除订单Clk    新版
            if flagStr == CoOrderDetailsCellViewFlight.FLIGHT_DEL_ORDER  ||
               flagStr == CoOrderDetailsCellViewHotel.HOTEL_DEL_ORDER  ||
               flagStr == CoOrderDetailsCellViewInsurance.INSURANCE_DEL_ORDER ||
               flagStr == CoOrderDetailsCellViewTrain.TRAIN_DEL_ORDER ||
               flagStr == CoOrderDetailsCellViewCar.CAR_DEL_ORDER
            {
                
                let alertController = UIAlertController(title: "", message: NSLocalizedString("common.validate.order.isdelete", comment:"确定删除?"),preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: NSLocalizedString("common.validate.cancel", comment:"取消"), style: .cancel, handler: nil)
                cancelAction.setValue(TBIThemePrimaryTextColor, forKey: "_titleTextColor")
                let okAction = UIAlertAction(title: NSLocalizedString("common.validate.ok", comment:"确定"), style: .default, handler:
                {action in
                    
                    var pos = indexPath.row
                    
                    if pos < flightCount    //机票小订单
                    {
                        pos = indexPath.row
                        let flightItem = self.flightItems[pos]
                        //删除机票小订单
                        self.showLoadingView()
                        let orderService = CoNewOrderService.sharedInstance
                        orderService.cancelFlightOrder(orderNo: self.orderDetails.orderNo, flightOrderNo: flightItem.id).subscribe{event in
                            self.hideLoadingView()
                            if case .next(let e) = event
                            {
                                print("=^_^====删除机票小订单 成功===\n e=\(e)===")
                                self.orderDetails = e
//                                //刷新Cell
//                                flightItem = e.flightItems[pos]
//                                self.flightItems[pos] = flightItem
//                                //刷新TableView的Cell
//                                self.cellOrder_IsDelArray[indexPath.row] = (flightItem.state == .active) ? false : true
//                                self.contentView.myTableView.reloadRows(at: [indexPath], with: .none)
                                
                                //删除Cell
                                self.flightItems.remove(at: pos)
                                
                                //self.contentView.myTableView.deleteRows(at: [indexPath], with: .right)
                                self.contentView.myTableView.reloadData()
                            }
                            if case .error(let e) = event {
                                print("=====删除机票小订单 失败======")
                                self.tipNetWorkError(httpError: e as? HttpError)
                            }
                            }.disposed(by: self.bag)
                    }
                    else if pos < (flightCount+hotelCount)    //酒店小订单
                    {
                        pos = indexPath.row - flightCount
                        let hotelItem = self.hotelItems[pos]
                        //删除酒店小订单
                        self.showLoadingView()
                        let orderService = CoNewOrderService.sharedInstance
                        orderService.cancelHotelOrder(orderNo: self.orderDetails.orderNo, hotelOrderNo: hotelItem.id).subscribe{event in
                            self.hideLoadingView()
                            if case .next(let e) = event
                            {
                                print("=^_^====删除酒店小订单 成功===\n e=\(e)===")
                                self.orderDetails = e
//                                //刷新Cell
//                                hotelItem = e.hotelItems[pos]
//                                self.hotelItems[pos] = hotelItem
//                                //刷新TableView的Cell
//                                self.cellOrder_IsDelArray[indexPath.row] = (hotelItem.state == .active) ? false : true
//                                self.contentView.myTableView.reloadRows(at: [indexPath], with: .none)
                                
                                //删除Cell
                                self.hotelItems.remove(at: pos)
                                //self.contentView.myTableView.deleteRows(at: [indexPath], with: .right)
                                self.contentView.myTableView.reloadData()
                            }
                            if case .error(let e) = event
                            {
                                print("=====删除酒店小订单 失败======")
                                
                                self.tipNetWorkError(httpError: e as? HttpError)
                            }
                            }.disposed(by: self.bag)
                    }  else if pos < (flightCount+hotelCount+trainCount)    //火车票小订单
                    {
                        pos = indexPath.row - flightCount - hotelCount
                        let trainItem = self.trainItems[pos]
                        //删除酒店小订单
                        self.showLoadingView()
                        let orderService = CoNewOrderService.sharedInstance
                        orderService.cancelTrainOrder(orderNo: self.orderDetails.orderNo, trainOrderNo: "\(trainItem.trainItemId)").subscribe{event in
                            self.hideLoadingView()
                            if case .next(let e) = event
                            {
                                print("=^_^====删除火车票小订单 成功===\n e=\(e)===")
                                self.orderDetails = e
                                
                                //删除Cell
                                self.trainItems.remove(at: pos)
                                //self.contentView.myTableView.deleteRows(at: [indexPath], with: .right)
                                self.contentView.myTableView.reloadData()
                            }
                            if case .error(let e) = event
                            {
                                print("=====删除火车票小订单 失败======")
                                
                                self.tipNetWorkError(httpError: e as? HttpError)
                            }
                            }.disposed(by: self.bag)
                    }else if pos < (flightCount+hotelCount+trainCount+carCount)    //火车票小订单
                    {
                        pos = indexPath.row - flightCount - hotelCount - trainCount
                        let carItem = self.carItems[pos]
                        //删除酒店小订单
                        self.showLoadingView()
                        let orderService = CoNewOrderService.sharedInstance
                        orderService.cancelCarOrder(orderNo: self.orderDetails.orderNo, carOrderNo: "\(carItem.carItemId)").subscribe{event in
                            self.hideLoadingView()
                            if case .next(let e) = event
                            {
                                print("=^_^====删除专车小订单 成功===\n e=\(e)===")
                                self.orderDetails = e
        
                                
                                //删除Cell
                                self.carItems.remove(at: pos)
                                //self.contentView.myTableView.deleteRows(at: [indexPath], with: .right)
                                self.contentView.myTableView.reloadData()
                            }
                            if case .error(let e) = event
                            {
                                print("=====删除专车小订单 失败======")
                                
                                self.tipNetWorkError(httpError: e as? HttpError)
                            }
                            }.disposed(by: self.bag)
                    }
                    
                    //TODO: 刷新整个TableView
                    //self.contentView.myTableView.reloadData()
                    
                    //self.cellOrder_IsDelArray[indexPath.row] = true
                    //self.contentView.myTableView.reloadRows(at: [indexPath], with: .none)
                
                })
                alertController.addAction(cancelAction)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                
                //TODO: 刷新整个TableView
                //self.contentView.myTableView.reloadData()
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
        if self.trainItems != nil {
            totalCount += self.trainItems.count
        }
        if self.carItems != nil {
            totalCount += self.carItems.count
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
        var trainCount = 0
        if self.trainItems != nil {
            trainCount = self.trainItems.count
        }
        var carCount = 0
        if self.carItems != nil {
            carCount = self.carItems.count
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
            //cellViewFlight.btn_right_del_order.isHidden = true
            //删除订单  企业版新版
            let isDelOrder = self.cellOrder_IsDelArray[indexPath.row]
            setOrderViewDelStatus(isDel: isDelOrder, priceLabel: cellViewFlight.label_order_price, delButton: cellViewFlight.btn_right_del_order)
            
            
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
            
            
            let flightVo:CoNewOrderDetail.FlightVo = flightItems[indexPath.row]
            
            if flightVo.suranceStatus == "1" {
                cellViewFlight.flight_insurance.isHidden = false
            }else {
                cellViewFlight.flight_insurance.isHidden = true
            }
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
            
            let hour = flightVo.flyTime / 60 < 1 ? 0:Int(flightVo.flyTime/60)
            let minutes = flightVo.flyTime - hour * 60
            cellViewFlight.label_fly_time_content.text = hour == 0 ? "\(minutes)分":"\(hour)时\(minutes)分"

            //cellViewFlight.label_fly_time_content.text = "\(flightVo.flyTime)"
            
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
            
            let passengers:[CoNewOrderDetail.FlightVo.Passenger] = flightVo.passengers
            cellViewFlight.addPassageInf(passengers: passengers)
            
            cellViewFlight.label_order_price.text = "¥\((flightVo.price + flightVo.tax).description0)"
            
            
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
            
            
            //return cellViewFlight
            
            
        }
        else if indexPath.row < flightCount+hotelCount   //酒店
        {
            let cellViewHotel = Bundle.main.loadNibNamed("CoOldOrderDetailsTableCellView", owner: nil, options: nil)?[1] as! CoOrderDetailsCellViewHotel
            cellViewHotel.cellShowHideListener = self
            cellViewHotel.indexPath = indexPath
            
            cell = cellViewHotel
            
            
            //cellViewHotel.btn_del_order.isHidden = true
            //删除订单  企业版新版
            let isDelOrder = self.cellOrder_IsDelArray[indexPath.row]
            setOrderViewDelStatus(isDel: isDelOrder, priceLabel: cellViewHotel.label_total_price_content, delButton: cellViewHotel.btn_del_order)
            
            
            
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
            
            
            let hotelVo:CoNewOrderDetail.HotelVo = hotelItems[itemPos]
            
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
            
            // modify by manman  on  2017-10-17 start of line
            // 担保状态 暂时为空
            // 担保状态   退改政策取消
            cellViewHotel.label_protected_status_content.text = "" //CoNewOrderDetailsController.getHotelGuaranteeStateStr(guaranteeState: hotelVo.guaranteeState)
            // end of line
            
            
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
            
            let priceFloat:Float = Float(hotelVo.price)
            cellViewHotel.label_total_price_content.text = "¥\(priceFloat.OneOfTheEffectiveFraction())"
            
        }else if indexPath.row < flightCount+hotelCount+trainCount //火车票cell
        {
            let trainCell = tableView.dequeueReusableCell(withIdentifier: coOrderDetailsCellViewTrainIdentify, for: indexPath) as! CoOrderDetailsCellViewTrain
            trainCell.selectionStyle = .none
            trainCell.cellShowHideListener = self
            trainCell.indexPath = indexPath
            
            let itemPos = indexPath.row - flightCount - hotelCount
            
            let isDelOrder = self.cellOrder_IsDelArray[indexPath.row]
            setOrderViewDelStatus(isDel: isDelOrder, priceLabel: trainCell.priceLabel, delButton: trainCell.deleteButton)
            
            let trainVo:CoNewOrderDetail.TrainVo = trainItems[itemPos]
            if isShow  // 显示
            {
                trainCell.fullCell(isShow: isShow,model:trainVo)
            }else // 隐藏
            {
                trainCell.fullCell(isShow: isShow,model:trainVo)
            }
           
            cell = trainCell
            
        }
        else if indexPath.row < flightCount+hotelCount+trainCount + carCount //专车cell
        {
            let carCell = tableView.dequeueReusableCell(withIdentifier: coOrderDetailsCellViewCarIdentify, for: indexPath) as! CoOrderDetailsCellViewCar
            carCell.selectionStyle = .none
            carCell.cellShowHideListener = self
            carCell.indexPath = indexPath
            
            let itemPos = indexPath.row - flightCount - hotelCount - trainCount
            
            let isDelOrder = self.cellOrder_IsDelArray[indexPath.row]
            setOrderViewDelStatus(isDel: isDelOrder, priceLabel: carCell.priceLabel, delButton: carCell.deleteButton)
            let carVo:CoNewOrderDetail.CarVo = carItems[itemPos]
            if isShow  // 显示
            {
                carCell.fullCell(isShow: isShow,model:carVo)
            }else // 隐藏
            {
                carCell.fullCell(isShow: isShow,model:carVo)
            }
            
            cell = carCell
            
        }
        else if indexPath.row < flightCount+hotelCount+trainCount+carCount+suranceCount       //保险cell
        {
            let cellViewInsurance = Bundle.main.loadNibNamed("CoOldOrderDetailsTableCellView", owner: nil, options: nil)?[2] as! CoOrderDetailsCellViewInsurance
            cellViewInsurance.cellShowHideListener = self
            cellViewInsurance.indexPath = indexPath
            
            cell = cellViewInsurance
            
            //保险隐藏 删除btn
            cellViewInsurance.btn_del_order.isHidden = true
            //删除订单  企业版新版
            let isDelOrder = self.cellOrder_IsDelArray[indexPath.row]
            setOrderViewDelStatus(isDel: isDelOrder, priceLabel: cellViewInsurance.label_total_price, delButton: cellViewInsurance.btn_del_order)
            
            
            
            
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
            
            let itemPos = indexPath.row - flightCount - hotelCount - trainCount - carCount
            
            
            let insuranceVo:CoNewOrderDetail.SuranceVo = suranceItems[itemPos]
            
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
            cellViewInsurance.label_sub_title.text = "\(startMonthDayStr)\(NSLocalizedString("order.details.insurance.start", comment:"生效")) | \(endMonthdayStr)\(NSLocalizedString("order.details.insurance.end", comment:"截止"))"
            
            
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
        // instead of upline start of line
        
        if systemVersion9
        {
            
            print("remove ...")
            cell.subviews.last?.removeFromSuperview()
            
            
        }
        
        // end of line
        
        return cell
    }
    
    
    //取消tableView一直选中的状态
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //取消选中的状态
        self.contentView.myTableView.deselectRow(at: indexPath, animated: true)
        
        //展开与隐藏订单的详情
        selectedCellIndexPath = indexPath
        var isShow = cellIsShowArray[indexPath.row]
        isShow = !isShow
        cellIsShowArray[indexPath.row] = isShow
        contentView.myTableView.reloadRows(at: [indexPath], with: .fade)
    }
    
}



//获取各个订单状态的String
extension CoNewOrderDetailsController
{
    //机票的当前的票状态
    static func  getFlightStateStr(flightTicketState:FlightTicketState) -> String
    {
        var flightTicketStatusStr = "未知状态"
        
        switch flightTicketState
        {
        case .success:   flightTicketStatusStr = "已出票"
        case .wait:   flightTicketStatusStr = "未出票"
        case .unknow:   flightTicketStatusStr = "未知状态"
        }
        
        return flightTicketStatusStr
    }
    
    //获得当前酒店订单的状态
    static func  getHotelBookStateStr(bookStatus:HotelBookState) -> String
    {
        var bookStatusStr = "未知状态"
        
        
        switch bookStatus {
        case .waitConfirm:    bookStatusStr = "待确认"
        case .payed:    bookStatusStr = "已支付"
        case .haveRoom:    bookStatusStr = "确认有房"
        case .noRoom:    bookStatusStr = "确认无房"
        case .comfirm:    bookStatusStr = "已确认"
        case .cancel:    bookStatusStr = "已取消"
        case .offLine:    bookStatusStr = "转线下"
        case .commitEnsure: bookStatusStr = "已提交需要担保"
        case .commitNoConfirm:    bookStatusStr = "已提交非及时确认订单"
        case .exception:    bookStatusStr = "异常订单"
        case .commit: bookStatusStr = "已提交"
        case .buy:    bookStatusStr = "已入账"
        case .ensureFail: bookStatusStr = "担保失败"
        case .confirmOrder:    bookStatusStr = "确认单"
        case .applyOrder:    bookStatusStr = "申请单"
        case .modifyOrder:    bookStatusStr = "修改单"
        case .cancelOrder:    bookStatusStr = "取消单"
        case .rejectOrder:    bookStatusStr = "拒绝单"
        case .test:    bookStatusStr = "测试"
        case .passengerCancel: bookStatusStr = "客户取消"
        case .roomConfirm: bookStatusStr = "房间确认"
        case .deleteApply: bookStatusStr = "删除申请中"
        case .unknow:      bookStatusStr = "未知状态"
        }
        
        return bookStatusStr
        
    }
    
    
    /// - onlyPay: 前台代付
    /// - collectionPay: 代收代付
    /// - prepay: 预付
    //获得当前酒店的 担保 的状态
    static func  getHotelGuaranteeStateStr(guaranteeState:HotelGuaranteeState) -> String
    {
        var guaranteeStatusStr = "未知状态"
        
        switch guaranteeState
        {
        case .guarantee:   guaranteeStatusStr = "信用卡担保"
        case .unGuarantee:   guaranteeStatusStr = "无需担保"
        case .unknow:   guaranteeStatusStr = "未知状态"
        }
        
        return guaranteeStatusStr
    }
    
    /// - apply: 申请中
    /// - effected: 已生效
    /// - revocationed: 已撤销
    /// - buyFail: 购买失败
    /// - retreatFail: 退保失败
    /// - unknow: 未知状态
    //获得当前 保险 的状态
    static func  getInsuranceStateStr(insuranceState:SuranceOrderState) -> String
    {
        var insuranceStateStr = "未知状态"
        
        switch insuranceState
        {
        case .apply:   insuranceStateStr = "申请中"
        case .effected:   insuranceStateStr = "已生效"
        case .revocationed:   insuranceStateStr = "已撤销"
        case .buyFail:   insuranceStateStr = "购买失败"
        case .retreatFail:   insuranceStateStr = "退保失败"
        case .unknow:   insuranceStateStr = "未知状态"
        case .repeaturchase: insuranceStateStr = "重复购买"
            
        }
        
        return insuranceStateStr
    }
    
    /// 新版出查单状态
    ///
    /// - cancel: 已取消
    /// - planing: 计划中
    /// - approving: 审批中
    /// - passed: 已通过
    /// - rejected: 已拒绝
    
    /// - willComplete: 待定妥
    /// - ompleted: 已定妥
    /// - offline: 转线下
    /// - sendBack: 订单退回
    /// - canceling: 申请取消
    
    /// - applying: 申请中
    /// - deleted: 已删除
    /// - deleting: 申请删除
    /// - unknow: 未知的状态
    
    //获取当前订单的状态
    static func  getOrderStateStr(orderState:CoOrderState) -> String
    {
        return orderState.description
    }
    
    
}
