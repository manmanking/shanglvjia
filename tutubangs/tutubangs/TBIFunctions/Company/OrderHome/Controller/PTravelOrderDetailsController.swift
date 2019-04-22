//
//  PTravelOrderDetailsController.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/7/7.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import RxSwift

class PTravelOrderDetailsController: CompanyBaseViewController 
{
    
    var mTravelOrderNo:String = "XXXX"
    var travelOrderDetails:PSpecialOrderDetails! = nil
    //var curentPsgItemIndex = -1
    
    //add by manman start of line
    fileprivate var shutDownTime:Timer!
    fileprivate var shutDownInt:Int = 0
    
    
    
    // end of line
    
    
    
    let bag = DisposeBag()
    
    let contentYOffset:CGFloat = 20+44
    var myContentView:PTravelOrderDetailsView! = nil
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        //设置头部的导航栏
        self.title = "旅游详情"  //"旅游详情"
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont.systemFont(ofSize: 16),NSForegroundColorAttributeName:UIColor.white]
        setNavigationBackButton(backImage: "back")
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIColor.creatImageWithColor(color: TBIThemeBlueColor), for: .any, barMetrics: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(goBackgroundAction), name: NSNotification.Name.init(rawValue: GoBackground), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(goForegroundAction), name: NSNotification.Name.init(rawValue: GoForeground), object: nil)
        
        //initView()
        //setUp()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getTravelOrderDetailFromServer(orderNo: self.mTravelOrderNo)
    }
    
    
    //重写  头部左侧的🔙Btn
    override func backButtonAction(sender: UIButton)
    {
        //是否包含预定页
        var isContainReservePage = false
        
        let viewControllers = self.navigationController?.viewControllers
        if (viewControllers?.count ?? 0) <= 4
        {
            for vc in viewControllers!
            {
                if vc is TravelOrderViewController
                {
                    isContainReservePage = true
                    break
                }
            }
        }
        else
        {
            let index = self.navigationController?.viewControllers.index(of: self)
            for i in 0..<3
            {
                let vc = viewControllers?[index! - i - 1]
                if vc is TravelOrderViewController
                {
                    isContainReservePage = true
                    break
                }
            }
        }
        
        if isContainReservePage  //包含预定页
        {
//            self.navigationController?.popToRootViewController(animated: false)
//            let tabbarView:BaseTabBarController = UIApplication.shared.keyWindow?.rootViewController as!BaseTabBarController
//            tabbarView.selectedIndex = 2
            popOrderView()
        }
        else
        {
            self.navigationController?.popViewController(animated: true)
            self.navigationController?.navigationBar.shadowImage = UIImage.init(named: "border")
        }
        
    }
    
    func initView() -> Void
    {
        myContentView = PTravelOrderDetailsView(frame: CGRect(x: 0, y: 0, width: ScreenWindowWidth, height: ScreentWindowHeight - contentYOffset))
        self.view.addSubview(myContentView)
        
        setViewByData()
    }
    
    //设置事件监听
    func setClickListener() -> Void
    {
        //价格明细对应的点击事件
        myContentView.topRightPriceDetailsTapArea.addOnClickListener(target: self, action: #selector(priceDetailsClk))

        //状态View的头部左侧点击事件
        let tapRecognizerLeft:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(statusTopLeftClk(recognizer:)))
        myContentView.topLeftRefundTicketView.addGestureRecognizer(tapRecognizerLeft)
            
//      //状态View的头部右侧点击事件
        let tapRecognizerRight:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(statusTopRightClk(recognizer:)))
        myContentView.topRightChangeTicketView.addGestureRecognizer(tapRecognizerRight)
        
        //报销凭证
        myContentView.freeChargeView.addOnClickListener(target: self, action: #selector(freeChangeEvidenceClk))
        
        //联系客服
        myContentView.bottomBtn.addOnClickListener(target: self, action: #selector(contactCustomerServiceClk))
        
        //设置旅客Item的监听事件
        for i in 0..<myContentView.psgItemViewList.count
        {
            let psgItemView = myContentView.psgItemViewList[i]
            
            //curentPsgItemIndex = i
            psgItemView.tag = i
            let tapRecoginser:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(psgItemClk(recognizer:)))
            
            psgItemView.addGestureRecognizer(tapRecoginser)
        }
    }

    func setViewByData() -> Void
    {
        myContentView.travelOrderDetails = self.travelOrderDetails
        myContentView.initView()
        
        //“更新”头部的订单状态View  还需要设置相应的“事件监听”
        myContentView.travelOrderStatus = self.travelOrderDetails.orderSpecialStatusEnum
        
        //支付时限 新需求
        // add by manman start of line  2017-09-22 
        
        if self.shutDownInt == 0 {
            myContentView.setStatusViewIsShow(isShow: false, leftImageShow: false, rightImageShow: false, leftText: .unknow, rightText: .unknow)
            
        }
        
        
        
        //end of line
        
        
        
        self.setClickListener()
        
        //设置头部的状态栏
        myContentView.topOrderStatusView.leftTopShowStatusLabel.text = self.travelOrderDetails.orderSpecialStatusEnum.description
        myContentView.topOrderStatusView.middleOrderNoLabel.text = "订单号" + self.travelOrderDetails.orderNo
        myContentView.topOrderStatusView.rightTopShowPriceLabel.text = "¥\(self.travelOrderDetails.totalAmount?.description0 ?? "0")"
        
        //报销凭证的 隐藏
        if ((travelOrderDetails.invoiceType ?? "未知") == "未知") && ((travelOrderDetails.logisticsAddress ?? "") == "") && ((travelOrderDetails.logisticsPhone ?? "") == "") && ((travelOrderDetails.invoiceTitle ?? "") == "")
        {
            myContentView.freeChargeView.clipsToBounds = true
            myContentView.freeChargeView.snp.updateConstraints{(make)->Void in
                make.height.equalTo(0)
                make.top.equalTo(myContentView.middleContactsView.snp.bottom).offset(0)
            }
        }
        
    }
    
    
    
    func setUp()
    {
        
        let form  = PersonalLoginUserForm(userName: "18630857599", passWord: "Aa111111")
        UserService.sharedInstance
            .personalLogin(form)
            .subscribe{ event in
                if case .next(let e) = event
                {
                    UserDefaults.standard.set(e, forKey: TOKEN_KEY)
                    self.mTravelOrderNo = "520170708103879"
                    self.getTravelOrderDetailFromServer(orderNo: self.mTravelOrderNo)
                }
                if case .error(let e) = event
                {
                    print("=====失败======\n \(e)")
                    //处理异常
                    try? self.validateHttp(e)
                }
            }.disposed(by: bag)
    }

    /// 获取旅游订单详情
    func getTravelOrderDetailFromServer(orderNo:String)
    {
        self.showLoadingView()
        weak var weakSelf = self
        let orderService = OrderService.sharedInstance
        orderService.travelOrderDetailBy(orderNo: orderNo)
        .subscribe{ event in
            weakSelf?.hideLoadingView()
            if case .next(let e) = event
            {
                print(e)
                weakSelf?.travelOrderDetails = e
                //对旅客类型进行排序
                weakSelf?.travelOrderDetails.orderSpecialPersonInfoList.sort{(o1,o2)->Bool in
                    return (o1.personTypeEnum.rawValue < o2.personTypeEnum.rawValue)
                }
                weakSelf?.shutDownInt = ((weakSelf?.travelOrderDetails.timeRemaining) ?? 0) / 60
                
                weakSelf?.initView()
                //支付时限
                // add by manman  start of line
                
                if (weakSelf?.shutDownInt)! > 0
                {
                    weakSelf?.shutDownRegular()
                }else
                {
                    weakSelf?.myContentView.topOrderStatusView.remainTimeLabel.isHidden = true
                }
                
                
                
                // end of line
            }
            if case .error(let e) = event
            {
                print("=====失败======\n \(e)")
                //处理异常
                try? weakSelf?.validateHttp(e)
            }
            }.disposed(by: bag)
    }

    func cancelOrderFromServer(orderNo:String) -> Void
    {
        self.showLoadingView()
        weak var weakSelf = self
        let orderService = OrderService.sharedInstance
        orderService.cancelOrder(orderNo: orderNo)
            .subscribe{ event in
                weakSelf?.hideLoadingView()
                if case .next(let e) = event
                {
                    print(e)
                    
                    //self.showAlertView(messageStr: "取消订单成功", okActionMethod: nil)
                    //0 “更新”头部的订单状态View
                    //3--已取消（支付之前用户取消）
                    //self.travelOrderDetails.orderSpecialStatusEnum = .canceled
                    
                    
                    
//                    weakSelf?.travelOrderDetails.orderSpecialStatus = "3"
//                    weakSelf?.myContentView.travelOrderStatus = self.travelOrderDetails.orderSpecialStatusEnum
//                    
//                    //设置头部的状态栏
//                    weakSelf?.myContentView.topOrderStatusView.leftTopShowStatusLabel.text = self.travelOrderDetails.orderSpecialStatusEnum.description
//                    
                    
                    // add by manman on 2017-09-27 start of line 
                    // 成功 后 返回上一页
                    weakSelf?.navigationController?.popViewController(animated: true)
                    
                    
                    //end of line
                    
                    
                    
                    
                    
                }
                if case .error(let e) = event
                {
                    print("=====失败======\n \(e)")   
                    //处理异常
                    try? weakSelf?.validateHttp(e)
                }
            }.disposed(by: bag)
    }
    
    
    //MARK:------count Down
    func goBackgroundAction() {
        goBackgroundDate = Date()
        shutDownTime.invalidate()
        
    }
    
    
    func goForegroundAction() {
        goForegroundDate = Date()
        timeInterval =  goForegroundDate.timeIntervalSince(goBackgroundDate)
        
        self.shutDownInt = self.shutDownInt - Int(round(timeInterval))
        shutDownRegular()
        
    }
    
    
    
    
    
    //MARK:------- 添加新需求  支付时限
    // add by manman start of line 
    
    
    func shutDownRegular() {
        
        shutDownTime = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(shutDownStart(timer:)), userInfo: "", repeats: true)
        shutDownTime.fire()
    }
    
    func shutDownStart(timer:Timer) {
        //printDebugLog(message: "second \(self.shutDownInt)")
        self.shutDownInt -= 1
        
        guard self.shutDownInt > 0 else {
            
            shutDownTime.invalidate()
            if shutDownInt == 0 {
                myContentView.topOrderStatusView.remainTimeLabel.isHidden = true
                
                
                
                switch self.travelOrderDetails.orderSpecialStatusEnum {
                case PSpecialOrderDetails.TravelOrderStatus.waitPay:
                    self.getTravelOrderDetailFromServer(orderNo: self.mTravelOrderNo)
                default:
                    break
                    
                }
                
                
                
            }
            
            return
        }
        
        myContentView.topOrderStatusView.remainTimeLabel.text = "剩余时间" + convertMinute(number:self.shutDownInt)
    }
    
    func convertMinute(number:NSInteger) -> String {
        let minuter:NSInteger = number / 60
        let second:NSInteger = number % 60
        let result:String = minuter.description + ":" + second.description
        return result
    }
    
    
    //end of line
    
    
    
    
    
    
    
    
    
    
    
    
}

extension PTravelOrderDetailsController
{
    //旅游订单详情 的 "价格明细" 显示的容     弹出"对话框"
    func priceDetailsClk() -> Void
    {
        print("^_^  价格明细")
        
        var showTextArray:[(String,String,String)] = []
        if self.travelOrderDetails.adultNum > 0
        {
            showTextArray.append(("成人","x\(self.travelOrderDetails.adultNum ?? 0)","¥\(self.travelOrderDetails.adultPrice?.description0 ?? "0")"))
        }
        if travelOrderDetails.childBedNum > 0
        {
            showTextArray.append(("儿童(占床)","x\(travelOrderDetails.childBedNum ?? 0)","¥\(self.travelOrderDetails.childBedPrice?.description0 ?? "0")"))
        }
        if travelOrderDetails.childNobedNum > 0
        {
            showTextArray.append(("儿童(不占床)","x\(travelOrderDetails.childNobedNum ?? 0)","¥\(self.travelOrderDetails.childNobedPrice?.description0 ?? "0")"))
        }
        if travelOrderDetails.roomNum > 0
        {
            showTextArray.append(("单房差","x\(travelOrderDetails.roomNum ?? 0)","¥\(self.travelOrderDetails.singleRoomDifference?.description0 ?? "0")"))
        }
        
        var hasFreeCharge = true    //是否有报销凭证
        //报销凭证的 隐藏
        if ((travelOrderDetails.invoiceType ?? "未知") == "未知") && ((travelOrderDetails.logisticsAddress ?? "") == "") && ((travelOrderDetails.logisticsPhone ?? "") == "") && ((travelOrderDetails.invoiceTitle ?? "") == "")
        {
            hasFreeCharge = false
        }
        if hasFreeCharge
        {
            showTextArray.append(("快递费","x\(1)","¥\(10)"))
        }
        
        showTextArray.append(("订单总价","","¥\(travelOrderDetails.totalAmount?.description0 ?? "0")"))
        
        let alertView = CoFlightChargeDetailsAlertView(frame: ScreenWindowFrame)
        alertView.showTextArray = showTextArray
        alertView.setSubUIViewlayout()
        KeyWindow?.addSubview(alertView)
    }
    
    //状态View的 头部左侧 点击事件
    func statusTopLeftClk(recognizer:UITapGestureRecognizer) -> Void
    {
        //print("😢 头部左侧 tag = \(recognizer.view!.tag)")
        
        topStatusBtnDealMethod(tag: recognizer.view!.tag)
    }
    
    //状态View的 头部右侧 点击事件
    func statusTopRightClk(recognizer:UITapGestureRecognizer) -> Void
    {
        //print("😢 头部右侧 tag = \(recognizer.view!.tag)")
        
        topStatusBtnDealMethod(tag: recognizer.view!.tag)
    }
    
    
    
    //报销凭证
    func freeChangeEvidenceClk() -> Void
    {
        print("^_^  报销凭证")
        
        let vc = PTravelOrderFreeChargeController()
        vc.travelOrderDetails = self.travelOrderDetails
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //联系客服
    func contactCustomerServiceClk() -> Void
    {
        print("^_^  联系客服")
        
        let phoneStr = "telprompt://" + "4006735858"
        UIApplication.shared.openURL(URL(string: phoneStr)!)
    }
    
    func psgItemClk(recognizer:UIGestureRecognizer) -> Void
    {
        let indexNum:Int = (recognizer.view?.tag)!
        
        //print("^_^ indexNum = \(indexNum)")
        
        let vc = PTravelOrderPersonInfoController()
        vc.personInfo = travelOrderDetails.orderSpecialPersonInfoList[indexNum]
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    //TODO:我要退款
    func topStatusBtnDealMethod(tag:Int) -> Void
    {
        
        switch PTravelOrderDetailsView.TravelOrderBtnText(rawValue: tag)!
        {
        case .refund:    //我要退款
            print("我要退款")
            let phoneStr = "telprompt://" + "4006735858"
            UIApplication.shared.openURL(URL(string: phoneStr)!)
            
        case .change:    //我要修改
            print("我要修改")
            let phoneStr = "telprompt://" + "4006735858"
            UIApplication.shared.openURL(URL(string: phoneStr)!)
            
        case .cancel:    //取消订单
            //print("取消订单")
            self.cancelOrderFromServer(orderNo: self.travelOrderDetails.orderNo)
            
        case .pay:    //我要支付
            //print("我要支付")
            let vc = PaymentViewController()
            vc.orderNum = self.travelOrderDetails.orderNo
            vc.productTypePayment = ProductTypePayment.Travel
            self.navigationController?.pushViewController(vc, animated: true)
            
        case .unknow:    //未知
            print("未知")
        }
        
    }
    
}

extension PTravelOrderDetailsController
{
    //显示AlertView
    func showAlertView(titleStr:String = "",messageStr:String,isHasCancel:Bool = false,okActionMethod:(()->Void)!) -> Void
    {
        let alertController = UIAlertController(title: titleStr, message: messageStr,preferredStyle: .alert)
        
        if isHasCancel
        {
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            cancelAction.setValue(TBIThemePrimaryTextColor, forKey: "_titleTextColor")
            alertController.addAction(cancelAction)
        }
        
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




