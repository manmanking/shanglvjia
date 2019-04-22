//
//  SubmitOrderFailureViewController.swift
//  shanglvjia
//
//  Created by manman on 2018/5/29.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class SubmitOrderFailureViewController: CompanyBaseViewController {

    public let submitOrderFailureView:SubmitOrderFailureView = SubmitOrderFailureView()
    
    public var submitOrderStatus:SubmitOrderStatus = SubmitOrderStatus.Success_Payment
    public var submitOrderViewType:AppModelCatoryENUM = AppModelCatoryENUM.Default
    public var failureStr:String = ""
    
    private let submitOrderViewGoHomeTipDefault:String = "home"
    private let submitOrderViewGoRebookTipDefault:String = "reorder"
    private let submitOrderViewGoOrderTipDefault:String = "order"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=TBIThemeWhite
        initView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
       self.navigationController?.setNavigationBarHidden(true, animated: true)
        submitOrderFailureView.fillDataSources(orderStatus: submitOrderStatus)
    }
    
    func initView() -> Void
    {
        
        self.view.addSubview(submitOrderFailureView)
        submitOrderFailureView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        weak var weakSelf = self
        
        submitOrderFailureView.submitOrderFailureViewGoHomeBlock = { (action) in
            weakSelf?.nextView(type: action)
        }
        
    }
    
    
    func nextView(type:String) {
        printDebugLog(message: submitOrderStatus)
        if(type == submitOrderViewGoHomeTipDefault)
        {
            goHomeAction()
        }
        if(type == submitOrderViewGoOrderTipDefault)
        {
            if submitOrderStatus == .Personal_Success_Payment ||
                submitOrderStatus == .Personal_Success_Submit_Order ||
                submitOrderStatus == .Personal_Success_nopay ||
                submitOrderStatus == .Personal_Success_SecondSubmit ||
                submitOrderStatus == .Personal_Success_Change{
                goPersonalOrderAction()
            }else{
                 goOrderAction()
            }
            
        }
        if(type == submitOrderViewGoRebookTipDefault)
        {
            if  submitOrderStatus == .Personal_Failure_Payment ||  submitOrderStatus == .Personal_Failure_Submit_Order
                ||  submitOrderStatus == .Personal_Failure_SecondSubmit || submitOrderStatus == .Personal_Failure_Change
            {
                 reorderPersonalOrderAction()
            }else{
                 reOrderAction()
            }
            
        }
    }
    
    
    
    func goHomeAction() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    func goOrderAction() {
        self.navigationController?.childViewControllers.forEach{
            if let controller = $0 as? OrderTabController {
                self.navigationController?.popToViewController(controller, animated: true)
                return
            }
        }
        let vc = OrderTabController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func goPersonalOrderAction() {
        self.navigationController?.childViewControllers.forEach{
            if let controller = $0 as? PersonalOrderListViewController {
                self.navigationController?.popToViewController(controller, animated: true)
                return
            }
        }
        let vc = PersonalOrderListViewController()
        vc.isBack = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func reOrderAction() {
        //return
    
        let vc : CompanyBaseViewController = self.navigationController!.viewControllers[1] as! CompanyBaseViewController;
        self.navigationController?.popToViewController(vc, animated: true)
    }
    func reorderPersonalOrderAction() {
       
        switch submitOrderViewType {
        case .PersonalVisa:
            gotoVisaDetailView()
        default:
            gotoDefaultCategorySearchHomeView()
        }
    }
    
    
    func gotoVisaDetailView() {
        
        self.navigationController?.childViewControllers.forEach{
            if let controller = $0 as? VisaDetailViewController {
                self.navigationController?.popToViewController(controller, animated: true)
                return
            }
        }
        
//        let vc : PersonalBaseViewController = self.navigationController!.viewControllers[1] as! PersonalBaseViewController;
//        self.navigationController?.popToViewController(vc, animated: true)
        
        
        
        
    }
    
    /// 重新预订 回到 当前模块的 首页
    func gotoDefaultCategorySearchHomeView()  {
        let vc : PersonalBaseViewController = self.navigationController!.viewControllers[1] as! PersonalBaseViewController;
        self.navigationController?.popToViewController(vc, animated: true)
    }
    
    
    
    enum SubmitOrderStatus:NSInteger {
        case Success_Payment = 1
        case Failure_Payment = 2
        case Success_SecondSubmit = 3
        case Failure_SecondSubmit = 4
        case Success_Submit_Order = 5
        case Failure_Submit_Order = 6
        case Personal_Success_Payment = 101
        case Personal_Failure_Payment = 102
        case Personal_Success_SecondSubmit = 103
        case Personal_Failure_SecondSubmit = 104
        case Personal_Success_Submit_Order = 105
        case Personal_Failure_Submit_Order = 106
        case Personal_Failure_Submit_Order_lowStocks = 107
        case Personal_Success_nopay = 108
        case Personal_Success_Change = 109
        case Personal_Failure_Change = 110
        case None = 0
    }
    
    enum SubmitOrderType:NSInteger {
        case Company_Order_Flight = 11
        case Company_Order_Train = 12
        case Company_Order_Hotel = 13
        case Company_Order_Car = 14
        case Personal_Order_Flight = 21
        case Personal_Order_Train = 22
        case Personal_Order_Car = 23
        case Personal_Order_Hotel = 24
        case Personal_Order_Visa = 25
        case Personal_Order_Travel = 26
        case None = 0
    }
    
    enum SubmitOrderNextViewType:NSInteger {
        
        // 企业 从 1- 100
        case Company_GOHome = 1
        case Company_Order = 51
        case Company_Order_Rebook = 52
        case Company_Flight = 11
        case Company_Hotel = 21
        case Company_Train = 31
        case Company_Car = 41
        
        
        
        // 个人 101 - 200
        case Personal_GOHome = 101
        case Personal_Order = 151
        case Personal_Order_Rebook = 152
        case Personal_Flight = 111
        case Personal_Hotel = 121
        case Personal_Train = 131
        case Personal_Car = 141
        
    }
    

}
