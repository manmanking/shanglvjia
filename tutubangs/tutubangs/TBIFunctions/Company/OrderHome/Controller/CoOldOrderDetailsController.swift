//
//  CoOldOrderDetailsController.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/5/22.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import RxSwift

//订单详情的显示和隐藏的监听器
protocol OnMyTableViewHeaderListener
{
    func onClickListener(tableViewFooter:UIView,flagStr:String) -> Void
}

//订单详情的显示和隐藏的监听器
protocol OnTableCellShowHideListener {
    
    func onShowHide(tableCell:UITableViewCell,flagStr:String, indexPath:IndexPath) -> Void
}

//订单详情底部的点击事件
protocol OnMyTableViewFooterListener
{
    func onClickListener(tableViewFooter:UIView,flagStr:String) -> Void
}

//顶部的返回键🔙对应的事件
enum OrderDetailsBackEvent
{
    case prePage   //跳转到上一页
    case homePage  //跳转到主页
    case orderList //跳转到订单列表页
}


class CoOldOrderDetailsController: CompanyBaseViewController{
    //static var isNewVersionOrder:Bool = false
    
    
    var topBackEvent:OrderDetailsBackEvent = .prePage
    
    //外部调用时传递过来的大订单号 参数
    var mBigOrderNOParams = "200053461"
    
    var selectedCellIndexPath:IndexPath!
    
    let bag = DisposeBag()
    var contentView:CoOrderDetailsViewXib!
    
    var cellIsShowArray:[Bool]! = []
    //订单是否被删除的数组
    var cellOrder_IsDelArray:[Bool] = []
    
    
    var orderDetails:CoOldOrderDetail!
    /// 机票小订单
    var flightItems:[CoOldOrderDetail.FlightVo]!
    /// 酒店小订单
    var hotelItems:[CoOldOrderDetail.HotelVo]!
    /// 保险小订单
    var suranceItems:[CoOldOrderDetail.SuranceVo]!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("order.details.title", comment: "订单详情")   //"订单详情"
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont.systemFont(ofSize: 16),NSForegroundColorAttributeName:UIColor.white]
        setNavigationBackButton(backImage: "back")
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIColor.creatImageWithColor(color: TBIThemeBlueColor), for: .any, barMetrics: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        //self.navigationController?.navigationBar.shadowImage = UIImage.init(named: "border")
        
        CoOrderDetailsViewXib.isNewVersionOrder = false   //企业版老版
        contentView = CoOrderDetailsViewXib(frame: CGRect(x: 0, y: 0, width: ScreenWindowWidth, height: ScreentWindowHeight-20-44))
        self.view.addSubview(contentView)
        
        
        contentView.onContentFooterListener = self
        contentView.myTableView.delegate = self
        contentView.myTableView.dataSource = self
        
        //未加载数据前， 隐藏底部的布局
        contentView.tableFooterView.isHidden = true
        //未加载数据前， 隐藏底部的送审和取消的容器视图
        contentView.bottom2BtnContainerView.isHidden = true
        
        
        //setUp0()
        getCoOldOrderDetailsFromServer(orderParams: self.mBigOrderNOParams)
    }
    
    //测试时使用的
//    override func viewDidAppear(_ animated: Bool)
//    {
//        super.viewDidAppear(animated)
//        
//        let alert = CoOrderSelectedPsgView(frame: ScreenWindowFrame)
//        alert.initView()
//        KeyWindow?.addSubview(alert)
//    }
    
    //TODO:重写  头部左侧的🔙Btn
    override func backButtonAction(sender: UIButton)
    {
        switch topBackEvent
        {
        case .prePage:
            self.navigationController?.popViewController(animated: true)
            self.navigationController?.navigationBar.shadowImage = UIImage.init(named: "border")
            
        case .orderList:
            //print("orderlist")
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
    
    //获取企业版老版订单详情。   从服务器
    func getCoOldOrderDetailsFromServer(orderParams:String)
    {
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
                
                self.cellIsShowArray = []
                self.cellOrder_IsDelArray = []
                for _ in 0..<totalCount
                {
                    self.cellIsShowArray.append(false)
                    self.cellOrder_IsDelArray.append(false)
                }
                
                //设置TableView的头部的布局
                self.setMyTableHeadView()
                //设置TableView的尾部的布局
                self.setMyTableFooterView()
                
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

    
    //设置表格的头部的状态的视图
    func setMyTableHeadView() -> Void
    {
        if self.orderDetails == nil
        {
            return
        }
        
        
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
        let curStatusStr:String = CoOldOrderDetailsController.getOrderStateStr(orderState: orderStateArray[orderCurIndex])
        
        var orderStatusStrArray:[String] = []
        for orderStatus in orderStateArray
        {
            orderStatusStrArray.append(CoOldOrderDetailsController.getOrderStateStr(orderState: orderStatus))
        }
        
        contentView.tableHeadView?.statusTextArray = orderStatusStrArray
        contentView.tableHeadView?.layoutTableTopView()
        contentView.tableHeadView?.setCurrentTotalOrderStatus(currentStatusNo: orderCurIndex)
        
        //设置头部的固定字段对应的View   老版
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
        //headFixedDataSource.append((NSLocalizedString("order.approval.order.status", comment:"订单状态"),curStatusStr))
        headFixedDataSource.append((NSLocalizedString("order.details.create.user", comment:"创建用户"),orderDetails.bookerName))
        headFixedDataSource.append((NSLocalizedString("order.details.create.time", comment:"创建时间"),orderCreateTimeStr))
        
        headFixedDataSource.append((NSLocalizedString("order.details.business.traveller", comment:"出差旅客"),passageNames))
        headFixedDataSource.append((NSLocalizedString("order.details.business.purpose", comment:"出差目的"),orderDetails.travelPurpose))
        headFixedDataSource.append((NSLocalizedString("order.details.business.resaon", comment:"出差事由"),orderDetails.travelDesc))
        
        contentView.tableHeadView?.oldVersionTopViewFixedDataSource = headFixedDataSource
        contentView.tableHeadView?.setOldVersionAddOrderDetailsView()
        //contentView.tableHeadView?.backgroundColor = UIColor.red
        
    }
    
    // 设置表格的底部的视图
    func setMyTableFooterView() -> Void
    {
        //测试结束后关闭注释
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
            let historyApprovaItem = sortHistoryApprovalInfos[i]
            
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
        
        
        
//        //historyApprovaCount---审批记录数         ***设置TableFooter的frame的高度   放在了后面
//        if historyApprovaCount > 0
//        {
//            //设置TableViewFooter的大小
//            contentView.myTableView.tableFooterView?.frame.size.height = CGFloat(316+((17+10)*(historyApprovaCount-1)))-54
//        }
//        else
//        {
//            contentView.myTableView.tableFooterView?.frame.size.height = (316-54)
//        }
        
        
        
        //设置底部的按钮
        if orderDetails.state == .approving   //审批中   显示底部的按钮
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
        else if (orderDetails.state == .planing)||(orderDetails.state == .rejected) //计划中||拒绝
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
            
            
            if orderDetails.approvalType == .approval
            {
                contentView.bottomRightReViewBtn.tag = CoOrderDetailsFooterView.STATUS_BTN_TO_REVIEW
                contentView.bottomRightReViewBtn.setTitle(NSLocalizedString("order.details.approval", comment:"送审"), for: .normal)
            }
            else if orderDetails.approvalType == .noApproval
            {
                contentView.bottomRightReViewBtn.tag = CoOrderDetailsFooterView.STATUS_BTN_COMMIT_ORDER
                contentView.bottomRightReViewBtn.setTitle(NSLocalizedString("order.details.confirmcommit", comment:"确认提交"), for: .normal)
            }
        }
        else if orderDetails.state == .passed //TODO:已通过
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
        else   //隐藏底部的按钮  0🔘 problem
        {
            contentView.bottom2BtnContainerView.isHidden = true

            
            let frame0 = CGRect(x: 0, y: 0, width: self.contentView.frame.size.width, height: self.contentView.frame.size.height)
            contentView.myTableView.frame = frame0
            
            //self.view.layoutSubviews()
            //print("^_^  ccc")
        }
        
        //TODO:设置 "审批记录View" 和 "添加机票添加酒店"View 的 显示
        var tableFooterHeight = 0
        if orderDetails.approvalType == .approval  //送审  显示 “审批记录” 视图
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
        
        if (orderDetails.state == .planing)||(orderDetails.state == .rejected) //计划中||拒绝  显示 “添加机票添加酒店” 按钮
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
        
        
//        //historyApprovaCount---审批记录数。      ***在此处。   设置TableFooter的frame的高度   
//        if historyApprovaCount > 0
//        {
//            //设置TableViewFooter的大小
//            contentView.myTableView.tableFooterView?.frame.size.height = CGFloat(316+((17+10)*(historyApprovaCount-1)))-54
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
            
            let curStatus = orderDetails.state
            
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
    
    //TODO:  获取旅客List的详情
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
                     _ = PassengerManager.shareInStance.passengerDeleteAll()
                    for i in 0..<travelList.count
                    {
                        let travel = travelList[i]
                        //searchTravellerResult.append(travel)
                        PassengerManager.shareInStance.passengerAdd(passenger: travel)
                    }
                    
                    if CoOrderSelectedPsgView.isAddFlight  //  去添加机票  旧版的
                    {
                        //let flightSearchViewController = FlightSearchViewController()
                        let flightSearchViewController = FlightSVSearchViewController()
                        flightSearchViewController.travelNo = self.orderDetails.orderNo
                        self.navigationController?.navigationBar.shadowImage = UIImage.init(named: "border")
                        self.navigationController?.pushViewController(flightSearchViewController, animated: true)
                    }
                    else    //去添加酒店
                    {
                        //print("去添加酒店")
                        
                        //personalDataSourcesArr = searchTravellerResult
                        //let searchCompanyView = HotelCompanySearchViewController()
                        let searchCompanyView = HotelSVCompanySearchViewController()
                        searchCompanyView.travelNo = self.orderDetails.orderNo   //订单号
                        self.navigationController?.pushViewController(searchCompanyView, animated: true)
                    }
                    
                }
                if case .error(let e) = event {
                    print("=====失败======\n \(e)")
                    //处理异常
                    try? self.validateHttp(e)
                }
            }.disposed(by: bag)
    }
    
}

//处理TableView的TableViewCell
extension CoOldOrderDetailsController:UITableViewDelegate,UITableViewDataSource,OnTableCellShowHideListener,OnMyTableViewFooterListener, OnMyTableViewHeaderListener
{
    //订单详情底部的点击事件  和 顶部的点击事件
    func onClickListener(tableViewFooter:UIView,flagStr:String) -> Void
    {
        //顶部的点击事件
        if flagStr == CoOrderDetailsTableHeadView.CHANGR_ORDER_DETAILS  //修改出差单
        {
            print("^_^  CHANGR_ORDER_DETAILS")
        }
        
        //底部的点击事件
        //添加机票
        if flagStr == CoOrderDetailsFooterView.ADD_FLIGHT_CLK
            
        {
            CoOrderSelectedPsgView.isAddFlight = true
            
            let travelIdList:[String] = orderDetails.psgIds
            getTravelListFromServer(travelIdList: travelIdList)
        }
        else if flagStr == CoOrderDetailsFooterView.ADD_HOTEL_CLK //添加酒店
        {
            CoOrderSelectedPsgView.isAddFlight = false
            
            let travelIdList:[String] = orderDetails.psgIds
            getTravelListFromServer(travelIdList: travelIdList)
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
                let orderService = CoOldOrderService.sharedInstance
                orderService.cancelBy(self.orderDetails.orderNo).subscribe{ event in
                    self.hideLoadingView()
                    if case .next(let e) = event
                    {
                        print("=^_^====取消送审 成功======")
                        let orderDetails0 = e
                        //刷新整个页面
                        self.getCoOldOrderDetailsFromServer(orderParams: orderDetails0.orderNo)
                        
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
                
                //跳转到：送审成功的界面
                //self.present(CoApprovalSuccessController(), animated: true, completion: nil)
                
                //跳转到：去送审的界面
                //老版订单送审
                let coOldExamineViewController = CoOldExamineViewController()
                coOldExamineViewController.orderNo = orderDetails.orderNo
                self.navigationController?.pushViewController(coOldExamineViewController, animated: true)
                
                
            }   //提交订单
            else if contentView.bottomRightReViewBtn.tag == CoOrderDetailsFooterView.STATUS_BTN_COMMIT_ORDER
            {
                let alertController = UIAlertController(title: "", message: NSLocalizedString("order.details.iscommitorder", comment:"提交订单?"),preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: NSLocalizedString("common.validate.cancel", comment:"取消"), style: .cancel, handler: nil)
                cancelAction.setValue(TBIThemePrimaryTextColor, forKey: "_titleTextColor")
                let okAction = UIAlertAction(title: NSLocalizedString("common.validate.ok", comment:"确定"), style: .default, handler:
                {action in
                    
                    self.showLoadingView()
                    let orderService = CoOldOrderService.sharedInstance
                    orderService.submitOrder(self.orderDetails.orderNo).subscribe{ event in
                        self.hideLoadingView()
                        if case .next(let e) = event
                        {
                            print("=^_^====提交订单 成功======")
                            let orderDetails0 = e
                            //刷新整个页面
                            self.getCoOldOrderDetailsFromServer(orderParams: orderDetails0.orderNo)
                            
                            let vc = CoApprovalSuccessController()
                            vc.type = .refer //提交订单 成功
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        if case .error(let e) = event
                        {
                            print("=====提交订单 失败======\n \(e)")
                            //处理异常
                            try? self.validateHttp(e)
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
                    let orderService = CoOldOrderService.sharedInstance
                    orderService.revokeBy(self.orderDetails.orderNo).subscribe{ event in
                        self.hideLoadingView()
                        if case .next(let e) = event
                        {
                            print("=^_^====撤回订单 成功======")
                            let orderDetails0 = e
                            //刷新整个页面
                            self.getCoOldOrderDetailsFromServer(orderParams: orderDetails0.orderNo)
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
                
            } //TODO:确认提交订单
            else if contentView.bottomRightReViewBtn.tag == CoOrderDetailsFooterView.STATUS_BTN_CONFORM_SUBMIT_ORDER
            {
                let alertController = UIAlertController(title: "", message: NSLocalizedString("order.details.isconfirmcommit", comment:"确认提交订单?"),preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: NSLocalizedString("common.validate.cancel", comment:"取消"), style: .cancel, handler: nil)
                //cancelAction.setValue(TBIThemePrimaryTextColor, forKey: "_titleTextColor")
                let okAction = UIAlertAction(title: NSLocalizedString("common.validate.ok", comment:"确定"), style: .default, handler:
                {action in
                    
                    self.showLoadingView()
                    let orderService = CoOldOrderService.sharedInstance
                    orderService.confirmBy(self.orderDetails.orderNo).subscribe{ event in
                        self.hideLoadingView()
                        if case .next(let e) = event
                        {
                            print("=^_^====确认提交订单 成功======")
                            let orderDetails0 = e
                            //刷新整个页面
                            self.getCoOldOrderDetailsFromServer(orderParams: orderDetails0.orderNo)
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
                let flightVo:CoOldOrderDetail.FlightVo = flightItems[itemPos]
                
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
                let itemPos = indexPath.row-flightCount-hotelCount
                let insuranceVo = suranceItems[itemPos]
                
                let title:[(title:String,content:String)] = [(NSLocalizedString("order.details.payinduction", comment:"理赔说明"),"")]
                let subFirstTitle:[(title:String,content:String)] = [("",insuranceVo.suranceDescribe )]
                let tbiALertView = TBIAlertView.init(frame: ScreenWindowFrame)
                tbiALertView.setDataSources(dataSource: [title,subFirstTitle])
                KeyWindow?.addSubview(tbiALertView)
            }
            
            
            //TODO:删除订单Clk      老版暂时没有删除小订单功能
            if flagStr == CoOrderDetailsCellViewFlight.FLIGHT_DEL_ORDER ||
               flagStr == CoOrderDetailsCellViewHotel.HOTEL_DEL_ORDER   ||
               flagStr == CoOrderDetailsCellViewInsurance.INSURANCE_DEL_ORDER
            {
//                let alertController = UIAlertController(title: "", message: "确定删除",preferredStyle: .alert)
//                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
//                cancelAction.setValue(TBIThemePrimaryTextColor, forKey: "_titleTextColor")
//                let okAction = UIAlertAction(title: "确定", style: .default, handler:
//                {action in
//                    
//                    self.cellOrder_IsDelArray[indexPath.row] = true
//                    self.contentView.myTableView.reloadRows(at: [indexPath], with: .none)
//                    
//                })
//                
//                alertController.addAction(cancelAction)
//                alertController.addAction(okAction)
//                self.present(alertController, animated: true, completion: nil)
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
            
            //删除订单按钮隐藏
            cellViewFlight.btn_right_del_order.isHidden = true
//            //TODO:删除订单  企业版老版已经注释 cell
//            let isDelOrder = self.cellOrder_IsDelArray[indexPath.row]
//            setOrderViewDelStatus(isDel: isDelOrder, priceLabel: cellViewFlight.label_order_price, delButton: cellViewFlight.btn_right_del_order)
            
            
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
            
            
            let checkInMonthDay = "\(numChangeTwoDigital(num: hotelVo.checkInDate.month))-\(numChangeTwoDigital(num: hotelVo.checkInDate.day))"
            let checkOutMonthDay = "\(numChangeTwoDigital(num: hotelVo.checkOutDate.month))-\(numChangeTwoDigital(num: hotelVo.checkOutDate.day))"
            let subTitleStr = "\(bedTypeStr)   |   \(checkInMonthDay)\(NSLocalizedString("order.details.hotel.checkin", comment:"入住"))   |   \(checkOutMonthDay)\(NSLocalizedString("order.details.hotel.leave", comment:"离店"))"
            cellViewHotel.top_left_sub_title.text = subTitleStr
            
            
            //床型
            cellViewHotel.label_house_type_content.text = hotelVo.bedTypeName
            cellViewHotel.label_late_time_content.text = hotelVo.arriveLastTime
            
            // 担保状态   退改政策取消
            // modify by manman  on  2017-10-17 start of line
            // 担保状态 暂时为空
            cellViewHotel.label_protected_status_content.text = ""//CoOldOrderDetailsController.getHotelGuaranteeStateStr(guaranteeState: hotelVo.guaranteeState)
            
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
        // instead of upline start of line
        
        if systemVersion9
        {
            
            print("remove ...")
            cell.subviews.last?.removeFromSuperview()
            
            
        }
        
        // end of line
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    
    
    
    
}



//获取各个订单状态的String
extension CoOldOrderDetailsController
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
        case .confirmOrder:    bookStatusStr = "确认订单"
        case .applyOrder:    bookStatusStr = "申请订单"
        case .modifyOrder:    bookStatusStr = "修改订单"
        case .cancelOrder:    bookStatusStr = "取消订单"
        case .rejectOrder:    bookStatusStr = "拒绝订单"
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
    
    //取消tableView一直选中的状态
    //展开与隐藏订单的详情
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //取消选中
        self.contentView.myTableView.deselectRow(at: indexPath, animated: true)
        
        //展开与隐藏订单的详情
        selectedCellIndexPath = indexPath
        var isShow = cellIsShowArray[indexPath.row]
        isShow = !isShow
        cellIsShowArray[indexPath.row] = isShow
        contentView.myTableView.reloadRows(at: [indexPath], with: .fade)
    }
}

//设置"机票"小订单状态对应的文字和文字颜色
extension FlightTicketState
{
    var color:UIColor{
        switch self
        {
        case .success:
            return UIColor(r: 49, g: 193, b: 124)
        case .wait:
            return UIColor(r: 255, g: 93, b: 7)
        default:
            return UIColor.darkGray
        }
    }
}

//设置"酒店"小订单状态对应的文字和文字颜色
extension HotelBookState
{
    var color:UIColor{
        switch self
        {
        case .confirmOrder,.applyOrder,.roomConfirm,.haveRoom,.noRoom:
            return UIColor(r: 70, g: 162, b: 255)
        case .exception,.ensureFail,.rejectOrder:
            return UIColor(r: 230, g: 67, b: 64)
        case .payed,.comfirm,.commit,.buy:
            return UIColor(r: 49, g: 193, b: 124)
            
        case .passengerCancel,.cancelOrder:
            return UIColor(r: 136, g: 136, b: 136)
        case .waitConfirm,.commitEnsure,.commitNoConfirm,.test,.deleteApply,.modifyOrder:
             return UIColor(r: 255, g: 93, b: 7)
            
        default:
            return UIColor.darkGray
        }
    }
}

//设置"保险"小订单状态对应的文字和文字颜色
extension SuranceOrderState
{
    var color:UIColor{
        switch self
        {
        case .apply:
            return UIColor(r: 70, g: 162, b: 255)
        case .buyFail,.retreatFail:
            return UIColor(r: 230, g: 67, b: 64)
        case .effected:
            return UIColor(r: 49, g: 193, b: 124)
            
        case .revocationed:
             return UIColor(r: 255, g: 93, b: 7)
            
        default:
            return UIColor.darkGray
        }
    }
}


extension Double
{
    public var description0: String
    {
        if self.truncatingRemainder(dividingBy: 1) == 0
        {
            return "\(Int(self))"
        }
        return "\(self)"
    }
}


















