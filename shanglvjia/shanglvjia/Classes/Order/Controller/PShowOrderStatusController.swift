//
//  PShowOrderStatusController.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/6/29.
//  Copyright © 2017年 TBI. All rights reserved.
//

//个人版的订单状态的页面

import UIKit

class PShowOrderStatusController: CompanyBaseViewController
{
    enum OrderTypeEnum
    {
        case flight
        case hotel
        case travel
    }
    
    var orderType:OrderTypeEnum = .hotel //设置跳转页面的类型
    var lookOrderNum:String = "" //查看订单的订单号
    
    let contentYOffset:CGFloat = 0
    var myContentView:PShowOrderStatusView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        initView()
    }
    
    func initView() -> Void
    {
        self.title = "订单状态"   //"订单状态"
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont.systemFont(ofSize: 16),NSForegroundColorAttributeName:UIColor.white]
        setNavigationBackButton(backImage: "back")
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIColor.creatImageWithColor(color: TBIThemeBlueColor), for: .any, barMetrics: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        
        
        
        
        myContentView = PShowOrderStatusView(frame: CGRect(x: 0, y: contentYOffset, width: ScreenWindowWidth, height: ScreentWindowHeight - contentYOffset))
        self.view.addSubview(myContentView)
        
        myContentView.myDelegate = self
    }
    
    //TODO:重写  头部左侧的🔙Btn
    override func backButtonAction(sender: UIButton)
    {
//        self.navigationController?.popToRootViewController(animated: false)
//        let tabbarView:BaseTabBarController = UIApplication.shared.keyWindow?.rootViewController as!BaseTabBarController
//        tabbarView.selectedIndex = 2
        popOrderView()
    }

}

extension PShowOrderStatusController:OnMyClickListener
{
    func onMyClick(clkView:UIView,flagStr:String)
    {
        print("^_^  flagStr=" + flagStr)
        
        //继续预定
        if flagStr == PShowOrderStatusView.GOONRESERVEPAGE_BTN
        {
            print("^_^  继续预定")
            //let indexVC = self.navigationController?.viewControllers.index(of: self)
            //self.navigationController?.popToViewController((self.navigationController?.viewControllers[indexVC! - 2])!, animated: false)
            self.navigationController?.popToRootViewController(animated: false)
            let tabbarView:BaseTabBarController = UIApplication.shared.keyWindow?.rootViewController as! BaseTabBarController
            tabbarView.selectedIndex = 0
            
            if orderType == .flight
            {
                //let vc = FlightSearchViewController()
                let vc = FlightSVSearchViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if orderType == .hotel
            {
                //let vc = HotelSearchViewController()
                let vc = HotelSVCompanySearchViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if orderType == .travel
            {
                let vc = TravelHomeViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if flagStr == PShowOrderStatusView.LOOKORDERPAGE_BTN    //查看订单
        {
            print("^_^  查看订单")
            
//            self.navigationController?.popToRootViewController(animated: false)
//            let tabbarView:BaseTabBarController = UIApplication.shared.keyWindow?.rootViewController as! BaseTabBarController
//            tabbarView.selectedIndex = 2
            popOrderView()
            
            if orderType == .flight
            {
                let vc = PFlightOrderDetailsController()
                vc.flightOrderNO =  lookOrderNum
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if orderType == .hotel
            {
                let vc = PHotelOrderDetailsController()
                vc.hotelOrderNO =  lookOrderNum
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if orderType == .travel
            {
                let vc = PTravelOrderDetailsController()
                vc.mTravelOrderNo =  lookOrderNum
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        
    }
}



