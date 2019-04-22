//
//  CoApprovalSuccessController.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/6/8.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

protocol OnMyClickListener
{
    func onMyClick(clkView:UIView,flagStr:String)
}

class CoApprovalSuccessController: CompanyBaseViewController
{
    var myContentView:CoApprovalSuccessView!
    var type:SuccessType = .submit
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
      
        initView()
       
        //新需求 现在存在两个状态  送审成功 提交成功
        // 提交成功 包含 拒绝 和 同意
        // add by manman  start of  line 2018-03-06
        
        if type == .submit {
              setBlackTitleAndNavigationColor(title: "送审成功")
            myContentView.successTextLabel.text = "送审成功"
            myContentView.topSubTipContentLabel.text = "请随时关注您的审批进度"
            myContentView.myOrderPageBtn.setTitle("我的订单", for: .normal)
        }
        else if type == .refer || type == .approval {
            setBlackTitleAndNavigationColor(title: "提交成功") 
            myContentView.successTextLabel.text = "提交成功"
            myContentView.topSubTipContentLabel.text = "谢谢您的审批操作"
            myContentView.myOrderPageBtn.setTitle("快速审批", for: .normal)
        }
        
        //end of line
        
        

    }
    
    func initView() -> Void
    {
        myContentView = CoApprovalSuccessView(frame: CGRect(x: 0, y: 0, width: ScreenWindowWidth, height: ScreentWindowHeight))
        self.view.addSubview(myContentView)
        
        myContentView.myDelegate = self
    }
    /// 成功页面状态
    ///
    /// - submit: 送审成功
    /// - approval: 审批成功
    //  -  refer:  提交成功
    enum SuccessType {
        case submit
        case approval
        case refer   //提交成功
    }
    override func backButtonAction(sender:UIButton) {
        self.navigationController?.popToRootViewController(animated: false)
        return
//        let tabbarView:BaseTabBarController = UIApplication.shared.keyWindow?.rootViewController as!BaseTabBarController
        
        
        if type  == .submit {
            //tabbarView.selectedIndex = 2
            popOrderView()
        }
    }
}

extension CoApprovalSuccessController:OnMyClickListener
{
    func onMyClick(clkView:UIView,flagStr:String)
    {
        print("^_^  flagStr=" + flagStr)
        
        //返回首页
        if flagStr == CoApprovalSuccessView.BACKHOMEPAGE_BTN
        {
            self.present(BaseTabBarController(), animated: true)
        }
        else if flagStr == CoApprovalSuccessView.MYORDERPAGE_BTN    //我的订单
        {
            if type  == .submit || type == .refer{
//                self.navigationController?.popToRootViewController(animated: false)
//                let tabbarView:BaseTabBarController = UIApplication.shared.keyWindow?.rootViewController as!BaseTabBarController
//                tabbarView.selectedIndex = 2
                
                
                popOrderView()
                refreshOrderListStatus()
            }else {
                self.navigationController?.childViewControllers.forEach{
                    if let controller = $0 as? TabViewController {
                        self.navigationController?.popToViewController(controller, animated: true)
                        return
                    }
                }
            }
        }
        
    }
    
    func refreshOrderListStatus() {
        NotificationCenter.default.post(name: NSNotification.Name.init("orderRefreshListNotificationKey"), object: nil)
    }
    
    
}


