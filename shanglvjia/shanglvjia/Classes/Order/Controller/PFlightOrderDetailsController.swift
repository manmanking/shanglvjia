//
//  PFlightOrderDetailsController.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/6/21.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import RxSwift

class PFlightOrderDetailsController: CompanyBaseViewController 
{
    let bag = DisposeBag()
    
    var flightOrderNO:String = "xxxxxxxxxxxxx"
    var pFlightOrderDetail:FlightOrderDetail! = nil
    
    var isGOBackJourney:Bool   //是否为去返程
    {
        return myContentView.isGOBackJourney
    }
    
    //add by manman start of line
    fileprivate var shutDownTime:Timer!
    fileprivate var shutDownInt:Int = 0
    
    fileprivate var testShutDownInt:Int = 0 * 60
    
    
    
    // end of line
    
    var myContentView:PFlightOrderDetailsView! = nil
    var contentYOffset:CGFloat = 20 + 44
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        //设置头部的导航栏
        self.title = "机票详情"  //"机票详情"
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont.systemFont(ofSize: 16),NSForegroundColorAttributeName:UIColor.white]
        setNavigationBackButton(backImage: "back")
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIColor.creatImageWithColor(color: TBIThemeBlueColor), for: .any, barMetrics: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(goBackgroundAction), name: NSNotification.Name.init(rawValue: GoBackground), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(goForegroundAction), name: NSNotification.Name.init(rawValue: GoForeground), object: nil)
        
        
        //initView()

        //setUp()
        //self.flightOrderNO = "120160706101089"
       
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
         self.getFlightDetailFromServer(orderNo: self.flightOrderNO)
        
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
//                if vc is FlightPersonalOrderViewController
//                {
//                    isContainReservePage = true
//                    break
//                }
            }
        }
        else
        {
            let index = self.navigationController?.viewControllers.index(of: self)
            for i in 0..<3
            {
                let vc = viewControllers?[index! - i - 1]
//                if vc is FlightPersonalOrderViewController
//                {
//                    isContainReservePage = true
//                    break
//                }
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
        myContentView = PFlightOrderDetailsView(frame: CGRect(x: 0, y: 0, width: ScreenWindowWidth, height: ScreentWindowHeight-contentYOffset))
        self.view.addSubview(myContentView)
    }
    
    //设置事件监听
    func setClickListener() -> Void
    {
//        //我要退票
//        myContentView.topLeftRefundTicketView.addOnClickListener(target: self, action: #selector(refundTicketClk))
//        //我要改签
//        myContentView.topRightChangeTicketView.addOnClickListener(target: self, action: #selector(changeTicketClk))
        //状态View的头部左侧点击事件
        let tapRecognizerLeft:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(statusTopLeftClk(recognizer:)))
        myContentView.topLeftRefundTicketView.addGestureRecognizer(tapRecognizerLeft)
        
        //      //状态View的头部右侧点击事件
        let tapRecognizerRight:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(statusTopRightClk(recognizer:)))
        myContentView.topRightChangeTicketView.addGestureRecognizer(tapRecognizerRight)
        
        
        
        //查看退改签政策
        myContentView.lookChangeTicketRuleView.addOnClickListener(target: self, action: #selector(lookChangeTicketRuleClk))
        
        //报销凭证
        myContentView.freeChargeView.addOnClickListener(target: self, action: #selector(freeChangeEvidenceClk))
        
        //联系客服
        myContentView.bottomBtn.addOnClickListener(target: self, action: #selector(contactCustomerServiceClk))
        
        //价格明细对应的点击事件
        myContentView.topRightPriceDetailsTapArea.addOnClickListener(target: self, action: #selector(priceDetailsClk))
    }
    
    func setViewByData() -> Void
    {
        initView()
        //中间的航班信息View
        myContentView.flightDetailDataList = pFlightOrderDetail.flightList
        myContentView.guestListArray = []
        for flightInf in pFlightOrderDetail.flightList
        {
            myContentView.guestListArray.append(flightInf.guestList)
        }
        myContentView.mContact = pFlightOrderDetail.contact
        
        myContentView.orderTime = pFlightOrderDetail.orderTime
        myContentView.operateMsgs = pFlightOrderDetail.operateMsgs
        //0 “更新”头部的订单状态View  还需要设置相应的“事件监听”    TODO:设置当前旅游订单的状态  0
        myContentView.flightOrderStatus = self.pFlightOrderDetail.orderStatus
        
        myContentView.initView()
        //1 “更新”头部的订单状态View  还需要设置相应的“事件监听”    TODO:设置当前旅游订单的状态  1
        myContentView.flightOrderStatus = self.pFlightOrderDetail.orderStatus
        
        
        //支付时限 新需求
        // add by manman start of line  2017-09-22
        
        if self.shutDownInt <= testShutDownInt {
            myContentView.setStatusViewIsShow(isShow: false, leftImageShow: false, rightImageShow: false, leftText: .unknow, rightText: .unknow)
            
        }
        
        
        
        //end of line
        
        
        
        
        //设置事件监听
        setClickListener()
        
        
        //头部的订单状态View
        //头部状态的左侧
        myContentView.topOrderStatusView.leftTopShowStatusLabel.text = pFlightOrderDetail.orderStatus.description
        myContentView.topOrderStatusView.middleOrderNoLabel.text = "订单号" + self.flightOrderNO
        //头部状态的右侧
        myContentView.topOrderStatusView.rightTopShowPriceLabel.text = "¥\(pFlightOrderDetail.charges.totalPrice.description0)"
        
        //报销凭证的 隐藏
        if (pFlightOrderDetail.invoiceInformation.invoiceType == .unknow) && (pFlightOrderDetail.invoiceInformation.address == "") && (pFlightOrderDetail.invoiceInformation.phone == "") && (pFlightOrderDetail.invoiceInformation.invoiceHeader == "")
        {
            myContentView.freeChargeView.clipsToBounds = true
            myContentView.freeChargeView.snp.updateConstraints{(make)->Void in
                make.height.equalTo(0)
                make.top.equalTo(myContentView.middleContactsView.snp.bottom).offset(0)
            }
        }
        
        //中间的航班信息View
        myContentView.updateFlightInfView()
    }
    
    
    //登陆账户
    func setUp()
    {
        //        BASE_URL = "http://172.17.18.124:8080/api/v1"
        let form  = PersonalLoginUserForm(userName: "13600000008", passWord: "111111")
        UserService.sharedInstance
            .personalLogin(form)
            .subscribe{ event in
                if case .next(let e) = event
                {
                    UserDefaults.standard.set(e, forKey: TOKEN_KEY)
                    
                    self.flightOrderNO = "120160706101089"
                    self.getFlightDetailFromServer(orderNo: self.flightOrderNO)
                }
                if case .error(let e) = event
                {
                    print("=====失败======\n \(e)")
                    //处理异常
                    try? self.validateHttp(e)
                }
            }.disposed(by: bag)
    }
    
    /// 获取机票订单详情
    func getFlightDetailFromServer(orderNo:String)
    {
        //往返程 多航段 120160706101089
        //单程 单航段 120160706101089
        weak var weakSelf = self
        self.showLoadingView()
        let orderService = OrderService.sharedInstance
        orderService.flightDetailBy(orderNo)
            .subscribe{ event in
                weakSelf?.hideLoadingView()
                if case .next(let e) = event
                {
                    //print(e)
                    
                    weakSelf?.pFlightOrderDetail = e
                    weakSelf?.shutDownInt = ((weakSelf?.pFlightOrderDetail.timeRemaining) ?? 0)
                    weakSelf?.setViewByData()
                    
                    //支付时限
                    // add by manman  start of line
                    if (weakSelf?.shutDownInt)! > (weakSelf?.testShutDownInt)!
                    {
                        
                        if weakSelf?.shutDownTime != nil
                        {
                            weakSelf?.shutDownTime.invalidate()
                        }
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
        weak var weakSelf = self
        self.showLoadingView()
        let orderService = OrderService.sharedInstance
        orderService.cancelOrder(orderNo: orderNo)
            .subscribe{ event in
                weakSelf?.hideLoadingView()
                if case .next(let e) = event
                {
                    //print(e)
                    
                    //self.showAlertView(messageStr: "取消订单成功", okActionMethod: nil)
                    //TODO:取消订单成功
                    //self.navigationController?.popViewController(animated: true)
                    //“更新”头部的订单状态View  还需要设置相应的“事件监听”    设置当前旅游订单的状态
                    // old *** self.pFlightOrderDetail.orderStatus = .cancel

                    // 原来的操作
//                    self.pFlightOrderDetail.flightList[0].state = .canceled
//                    self.myContentView.flightOrderStatus = self.pFlightOrderDetail.orderStatus
//                    
//                    //更新头部状态的左侧
//                    self.myContentView.topOrderStatusView.leftTopShowStatusLabel.text = self.pFlightOrderDetail.orderStatus.description
//                    
                    
                    // add by manman on 2017-09-27 start of line
                    // 成功 后 返回上一页
                    weakSelf?.navigationController?.popViewController(animated: true)
                    
                    
                    //end of line
                    
                    
                 //王阳
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
        shutDownTime = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(shutDownStart(timer:)), userInfo: "", repeats: true)
        shutDownTime.fire()
    }
    
    func shutDownStart(timer:Timer) {
        //printDebugLog(message: "second \(self.shutDownInt)")
        
        self.shutDownInt -= 1
        
        guard self.shutDownInt > testShutDownInt else {
            
            shutDownTime.invalidate()
            if shutDownInt <= testShutDownInt {
                myContentView.topOrderStatusView.remainTimeLabel.isHidden = true
                
                
                switch self.pFlightOrderDetail.orderStatus {
                case FlightOrderDetail.FlightOrderState.waitpay:
                    self.getFlightDetailFromServer(orderNo: self.flightOrderNO)
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
    
    
    
    
    
    //暂时 不用方法  以后将 数据 销毁 统一放在这个方法
    deinit {
        
    }
    
    
    
    
    
}

extension PFlightOrderDetailsController
{
    //价格明细
    func priceDetailsClk() -> Void
    {
        print("^_^  价格明细")
        
        //let flightVo:CoOldOrderDetail.FlightVo = self.pFlightOrderDetail.detailsOfCharges
        
        let peopleNum = self.pFlightOrderDetail.flightList[0].guestList.count
        let isGOBack = self.pFlightOrderDetail.charges.backCharges == nil ? false : true
        
        //"价格明细"弹出框   个人版的多了两行  "保险费"和"快递费"
        var showTextArray:[(String,String,String)] = []
        
        if !isGOBack       //单程
        {
            showTextArray.append(("成人机票","x\(peopleNum)人","¥\(self.pFlightOrderDetail.charges.goCharges.airTicketPrice.description0)"))
            showTextArray.append(("机场建设","x\(peopleNum)人","¥\(self.pFlightOrderDetail.charges.goCharges.taxation.description0)"))
            if self.pFlightOrderDetail.charges.goCharges.insuranceCost != 0
            {
                showTextArray.append(("保险费","x\(peopleNum)人","¥\(self.pFlightOrderDetail.charges.goCharges.insuranceCost.description0)"))
            }
            if self.pFlightOrderDetail.charges.goCharges.expressCharge != 0
            {
                showTextArray.append(("快递费","x\(peopleNum)人","¥\(self.pFlightOrderDetail.charges.goCharges.expressCharge.description0)"))
            }
            
            showTextArray.append(("订单总价","x\(peopleNum)人","¥\(self.pFlightOrderDetail.charges.totalPrice.description0)"))
        }
        else //往返程
        {
            //去程
            showTextArray.append(("去程机票","x\(peopleNum)人","¥\(self.pFlightOrderDetail.charges.goCharges.airTicketPrice.description0)"))
            showTextArray.append(("去程机建","x\(peopleNum)人","¥\(self.pFlightOrderDetail.charges.goCharges.taxation.description0)"))
            if self.pFlightOrderDetail.charges.goCharges.insuranceCost != 0
            {
                showTextArray.append(("去程保险费","x\(peopleNum)人","¥\(self.pFlightOrderDetail.charges.goCharges.insuranceCost.description0)"))
            }
            //if self.pFlightOrderDetail.charges.goCharges.expressCharge != 0
            //{
                //showTextArray.append(("去程快递费","x\(peopleNum)人","¥\(self.pFlightOrderDetail.charges.goCharges.expressCharge.description0)"))
            //}
            
            //返程
            showTextArray.append(("返程机票","x\(peopleNum)人","¥\(self.pFlightOrderDetail.charges.backCharges!.airTicketPrice.description0)"))
            showTextArray.append(("返程机建","x\(peopleNum)人","¥\(self.pFlightOrderDetail.charges.backCharges!.taxation.description0)"))
            if self.pFlightOrderDetail.charges.backCharges!.insuranceCost != 0
            {
                showTextArray.append(("返程保险费","x\(peopleNum)人","¥\(self.pFlightOrderDetail.charges.backCharges!.insuranceCost.description0)"))
            }
            //if self.pFlightOrderDetail.charges.backCharges!.expressCharge != 0
            //{
                //showTextArray.append(("返程快递费","x\(peopleNum)人","¥\(self.pFlightOrderDetail.charges.backCharges!.expressCharge.description0)"))
            //}
            
            //总的快递费
            if self.pFlightOrderDetail.charges.expressCharge != 0
            {
                //快递的单数
                var expressChargeNum = 1;
                if self.pFlightOrderDetail.charges.backCharges != nil
                {
                    expressChargeNum = 2
                }
                
                showTextArray.append(("快递费","x\(expressChargeNum)单","¥\(self.pFlightOrderDetail.charges.expressCharge.description0)"))
            }
            
            //订单的总价
            showTextArray.append(("订单总价","x\(peopleNum)人","¥\(self.pFlightOrderDetail.charges.totalPrice.description0)"))
        }
        
        
        let alertView = PFlightChargeDetailsAlertView(frame: ScreenWindowFrame)
        alertView.showTextArray = showTextArray
        alertView.setSubUIViewlayout()
        KeyWindow?.addSubview(alertView)
        //self.view?.addSubview(alertView)
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
    
    //TODO:我要退款
    func topStatusBtnDealMethod(tag:Int) -> Void
    {
        
        switch PFlightOrderDetailsView.PFlightOrderBtnText(rawValue: tag)!
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
            self.cancelOrderFromServer(orderNo: self.flightOrderNO)
            
        case .pay:    //我要支付
            //print("我要支付")
            let vc = PaymentViewController()
            vc.orderNum = self.flightOrderNO
            vc.productTypePayment = .Flight
            self.navigationController?.pushViewController(vc, animated: true)
            
        case .unknow:    //未知
            print("未知")
        }
        
    }
    
    
    //查看退改签政策
    func lookChangeTicketRuleClk() -> Void
    {
        print("^_^  查看退改签政策")
        
        if !self.isGOBackJourney  //不为去返程
        {
            let title:[(title:String,content:String)] = [("退改签规则","")]
            let subFirstTitle:[(title:String,content:String)] = [("",pFlightOrderDetail.flightList[0].fareConditions)]
            let tbiALertView = TBIAlertView.init(frame: ScreenWindowFrame)
            tbiALertView.setDataSources(dataSource: [title,subFirstTitle])
            
            KeyWindow?.addSubview(tbiALertView)
            //self.view?.addSubview(tbiALertView)
        }
        else   //去返程
        {
            let title:[(title:String,content:String)] = [("退改签规则","")]
            let subFirstTitle:[(title:String,content:String)] = [("去程",pFlightOrderDetail.flightList[0].fareConditions)]
            let subSecondTitle:[(title:String,content:String)] = [("返程",pFlightOrderDetail.flightList[1].fareConditions)]
            let tbiALertView = TBIAlertView.init(frame: ScreenWindowFrame)
            tbiALertView.setDataSources(dataSource: [title,subFirstTitle,subSecondTitle])
            
            KeyWindow?.addSubview(tbiALertView)
            //self.view?.addSubview(tbiALertView)
        }
        
        
    }
    
    //报销凭证
    func freeChangeEvidenceClk() -> Void
    {
        //print("^_^  报销凭证")
        
        let vc = PFlightOrderFreeChargeController()
        vc.freeChargeDetails = pFlightOrderDetail.invoiceInformation
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //联系客服
    func contactCustomerServiceClk() -> Void
    {
        print("^_^  联系客服")
        
        let phoneStr = "telprompt://" + "4006735858"
        UIApplication.shared.openURL(URL(string: phoneStr)!)
    }
    
}

extension PFlightOrderDetailsController
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










