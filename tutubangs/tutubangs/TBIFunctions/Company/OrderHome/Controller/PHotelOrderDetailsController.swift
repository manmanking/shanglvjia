//
//  PHotelOrderDetailsController.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/6/28.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import RxSwift

class PHotelOrderDetailsController: CompanyBaseViewController 
{
    let bag = DisposeBag()
    
    var hotelOrderNO = "XXXXXXXXX"
    var hotelOrderDetail:HotelOrderDetail! = nil
    
    var contentYOffset:CGFloat = 20 + 44
    var myContentView:PHotelOrderDetailsView! = nil

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        //设置头部的导航栏
        self.title = "酒店详情"  //"酒店详情"
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont.systemFont(ofSize: 16),NSForegroundColorAttributeName:UIColor.white]
        setNavigationBackButton(backImage: "back")
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIColor.creatImageWithColor(color: TBIThemeBlueColor), for: .any, barMetrics: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        
        
        //initView()
        
        //setUp()
        //self.hotelOrderNO = "220170630103760"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getHotelDetailFromService(hotelOrderNo: self.hotelOrderNO)
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
                if vc is ReserveRoomViewController
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
                if vc is ReserveRoomViewController
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
    
    
    func setViewByData() -> Void
    {
        initView()
        
        //设置 myContentView 的数据
        myContentView.hotelOrderDetail = hotelOrderDetail
        
        //对 myContentView 进行布局
        myContentView.initView()
        
        //设置头部的状态对应的View
        //获取的“订单状态”有问题  -设置状态对应的文字的“颜色”
        myContentView.topOrderStatusView.leftTopShowStatusLabel.text = "\(hotelOrderDetail.orderHotelStatus)"
        myContentView.topOrderStatusView.leftTopShowStatusLabel.textColor = hotelOrderDetail.orderHotelStatus.color
        myContentView.topOrderStatusView.middleOrderNoLabel.text = "订单编号" + hotelOrderDetail.orderNo
        myContentView.topOrderStatusView.rightTopShowPriceLabel.text = "¥\(hotelOrderDetail.orderTotalAmount.description0)"
        //TODO: 缺少"支付方式"字段   -    到店支付X
        myContentView.topOrderStatusView.rightMiddlePayWayLabel.text = "到店支付"
        
        //设置事件监听
        setClickListener()
    }
    
    
    func initView() -> Void
    {
        myContentView = PHotelOrderDetailsView(frame: CGRect(x: 0, y: 0, width: ScreenWindowWidth, height: ScreentWindowHeight - contentYOffset))
        self.view.addSubview(myContentView)
        
        //设置事件监听
        //setClickListener()
    }

    //设置事件监听
    func setClickListener() -> Void
    {
        //我要退票
        myContentView.topLeftChangeTicketView.addOnClickListener(target: self, action: #selector(changeTicketClk))
        
        //我要改签
        myContentView.topRightContactHotelView.addOnClickListener(target: self, action: #selector(contactHotelClk))
        
        //联系客服
        myContentView.bottomBtn.addOnClickListener(target: self, action: #selector(contactCustomerServiceClk))
        
        //价格明细对应的点击事件
        myContentView.topRightPriceDetailsTapArea.addOnClickListener(target: self, action: #selector(priceDetailsClk))
    }
    
    //登陆账户
    func setUp()
    {
        //        BASE_URL = "http://172.17.18.124:8080/api/v1"
        let form  = PersonalLoginUserForm(userName: "13600000008", passWord: "111111")
        //let form  = PersonalLoginUserForm(userName: "18630857599", passWord: "Aa111111")
        UserService.sharedInstance
            .personalLogin(form)
            .subscribe{ event in
                if case .next(let e) = event
                {
                    UserDefaults.standard.set(e, forKey: TOKEN_KEY)
                    
                    self.hotelOrderNO = "220170630103760"
                    self.getHotelDetailFromService(hotelOrderNo: self.hotelOrderNO)
                }
                if case .error(let e) = event
                {
                    print("=====失败======\n \(e)")
                    //处理异常
                    try? self.validateHttp(e)
                }
            }.disposed(by: bag)
    }
    
    // 获取酒店订单详情
    func getHotelDetailFromService(hotelOrderNo:String)
    {
        self.showLoadingView()
        let orderService = OrderService.sharedInstance
        //220170630103760
        orderService.hotelDetailBy(hotelOrderNo)
            .subscribe{ event in
                self.hideLoadingView()
                if case .next(let e) = event
                {
                    print(e)
                    self.hotelOrderDetail = e
                    self.setViewByData()
                }
                if case .error(let e) = event
                {
                    print("=====失败======\n \(e)")
                    //处理异常
                    try? self.validateHttp(e)
                }
            }.disposed(by: bag)
        
    }
    
    
}

extension PHotelOrderDetailsController
{
    //TODO:价格明细
    func priceDetailsClk() -> Void
    {
        print("^_^  Hotel价格明细")
        let vc = PHotelPriceDetailsController()
        vc.costList = hotelOrderDetail.costList
        vc.productBreakfast = hotelOrderDetail.productBreakfast
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //修改订单
    func changeTicketClk() -> Void
    {
        
        let phoneStr = "telprompt://" + "4006735858"
        UIApplication.shared.openURL(URL(string: phoneStr)!)
        
        //print("😢 修改订单")
    }
    
    //联系酒店
    func contactHotelClk() -> Void
    {
        print("😢 联系酒店 hotelPhone = \(hotelOrderDetail.hotelPhone)")
        
        //let phoneStr = "telprompt://" + "4006735858"
        let phoneStr = "telprompt://" + hotelOrderDetail.hotelPhone
        UIApplication.shared.openURL(URL(string: phoneStr)!)
    }
    
    //联系客服
    func contactCustomerServiceClk() -> Void
    {
        print("^_^  联系客服")
        
        let phoneStr = "telprompt://" + "4006735858"
        UIApplication.shared.openURL(URL(string: phoneStr)!)
    }
    
}

extension PHotelOrderDetailsController
{
    /// 酒店订单状态
    ///
    /// - waitConfirm:  	待确认
    /// - payed:  	已支付
    /// - haveRoom:  	确认有房
    /// - noRoom:  	确认无房
    /// - comfirm:  	已确认
    /// - cancel:  	已取消
    /// - offLine:  	转线下
    /// - commitEnsure: 已提交需要担保
    /// - commitNoConfirm:  	已提交非及时确认订单
    /// - exception:  	异常订单
    /// - commit: 已提交
    /// - unknow: 未知
    //获取酒店订单状态
    func getHotelOrderStatusStr(hotelStatus:HotelOrderDetail.HotelStatus) -> String
    {
        var hotelStatusStr = "未知状态"
        
        switch hotelStatus
        {
        case .waitConfirm:
            hotelStatusStr = "待确认"
        case .payed:
            hotelStatusStr = "已支付"
        case .haveRoom:
            hotelStatusStr = "确认有房"
        case .noRoom:
            hotelStatusStr = "确认无房"
        
        case .comfirm:
            hotelStatusStr = "已确认"
        case .cancel:
            hotelStatusStr = "已取消"
        case .offLine:
            hotelStatusStr = "转线下"
        case .commitEnsure:
            hotelStatusStr = "已提交需要担保"
        
            
        case .commitNoConfirm:
            hotelStatusStr = "已提交非及时确认订单"
        case .exception:
            hotelStatusStr = "异常订单"
        case .commit:
            hotelStatusStr = "已提交"
            
        case .unknow:
            hotelStatusStr = "未知"
        
        }
        
        return hotelStatusStr
    }
}

//设置"酒店"小订单状态对应的文字和文字颜色
extension HotelOrderDetail.HotelStatus
{
    var color:UIColor{
        switch self
        {
        case .haveRoom,.noRoom:
            return UIColor(r: 70, g: 162, b: 255)
        case .exception:
            return UIColor(r: 230, g: 67, b: 64)
        case .payed,.comfirm,.commit:
            return UIColor(r: 49, g: 193, b: 124)
            
        case .cancel,.offLine:
            return UIColor(r: 136, g: 136, b: 136)
        case .waitConfirm,.commitEnsure,.commitNoConfirm:
            return UIColor(r: 255, g: 93, b: 7)
            
        case .unknow:
            return UIColor.darkGray
        }
    }
}








