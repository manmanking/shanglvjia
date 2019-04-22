//
//  BaseTabBarControllerViewController.swift
//  shop
//
//  Created by TBI on 2017/4/5.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {
    
    
    private var companyControllerArr:[UINavigationController] = Array()
    
    private var personalControllerArr:[UINavigationController] = Array()
    
    public var isCompanyLogin:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.tabBar.isTranslucent = false
        self.tabBar.backgroundColor = .white
        setAppStatusDefaultActive()
        
    }
    
    
    private func setPersonalController() {
        let personalHomeView = PersonalMainHomeViewController()
       
        let homeNav:UINavigationController =  addChildViewController(childController:personalHomeView , title: "首页", imageName: "Tab_Home")
        let personalTripHomeView = PersonalOrderListViewController()
        let tripNav:UINavigationController = addChildViewController(childController: personalTripHomeView, title: "订单", imageName: "Tab_Order")
        let personalMineHomeView = PersonalMineHomeViewController()
        //addChildViewController(childController:  OrderTabController(), title: "订单", imageName: "Tab_Order")
        let mineNav:UINavigationController =  addChildViewController(childController:personalMineHomeView, title: "我的", imageName: "Tab_Mine")
        self.viewControllers = [homeNav,tripNav,mineNav]
    }
    
    
    /// 设置 企业状态 控制器
    private func setCompanyController() {
        companyControllerArr.removeAll()
        let homeView = NewHomeViewController()//HomeViewController()
        //homeView.isCompanyLogin = isCompanyLogin
        let homeNav:UINavigationController =  addChildViewController(childController:homeView , title: "首页", imageName: "Tab_Home")
        let tripNav:UINavigationController = addChildViewController(childController: CompanyJourneyViewController(), title: "行程", imageName: "Tab_Trip")
        //addChildViewController(childController:  OrderTabController(), title: "订单", imageName: "Tab_Order")
        let mineNav:UINavigationController =  addChildViewController(childController: MineHomeViewController(), title: "我的", imageName: "Tab_Mine")
        
        self.viewControllers = [homeNav,tripNav,mineNav]
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //addChildViewControllers()
       
        
        
    }
    
    
    /// 检测上次 推出时 所使用权限 下次进入时 还需要在这个权限内 继续
    /// 若是首次 进入 则进入 默认页面
    func checkPreLoginAccountRight() {
        
        DBManager.shareInstance.getCurrentAccountRight()
        
        
    }
    
    
    
    public func setAppStatusDefaultActive() {
        if DBManager.shareInstance.getCurrentActive() == DBManager.AppActiveStatus.Company_Active {
            setCompanyController()
        }else{
            setPersonalController()
        }
        
    }
    
    public func setAppStatusActive(appStatus:DBManager.AppActiveStatus) {
        
        switch appStatus {
        case .Company_Active:
            DBManager.shareInstance.currentActiveCompany()
            setCompanyController()
        case .Personal_Active:
            DBManager.shareInstance.currentActivePersonal()
            setPersonalController()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
        /**
         # 初始化子控制器
         - parameter childControllerName: 需要初始化的控制器
         - parameter title:               标题
         - parameter imageName:           图片名称
         */
   private func addChildViewController(childController: UIViewController, title: String, imageName: String)->UINavigationController {
            childController.tabBarItem.image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
            childController.tabBarItem.selectedImage = UIImage(named:imageName + "_Selected")?.withRenderingMode(.alwaysOriginal)
            childController.title = title
            self.tabBar.tintColor = TBIThemeBlueColor
            let navC = BaseNavigationController(rootViewController: childController)//UINavigationController(rootViewController: childController)
            return navC
        }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
    }
    
    
    
    
}

// MARK: - 基础TabBar
extension BaseTabBarController {
    
    
//    /**
//     * 添加子控制器
//     */
//    func addChildViewControllers() {
//        let homeView = NewHomeViewController()//HomeViewController()
//        //homeView.isCompanyLogin = isCompanyLogin
//        addChildViewController(childController:homeView , title: "首页", imageName: "Tab_Home")
//        addChildViewController(childController: CompanyJourneyViewController(), title: "行程", imageName: "Tab_Trip")
//        //addChildViewController(childController:  OrderTabController(), title: "订单", imageName: "Tab_Order")
//        addChildViewController(childController: NewMineHomeViewController(), title: "我的", imageName: "Tab_Mine")
//    }
//
//    /**
//     # 初始化子控制器
//     - parameter childControllerName: 需要初始化的控制器
//     - parameter title:               标题
//     - parameter imageName:           图片名称
//     */
//    func addChildViewController(childController: UIViewController, title: String, imageName: String) {
//        childController.tabBarItem.image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
//        childController.tabBarItem.selectedImage = UIImage(named:imageName + "_Selected")?.withRenderingMode(.alwaysOriginal)
//        childController.title = title
//        self.tabBar.tintColor = TBIThemeBlueColor
//        let navC = BaseNavigationController(rootViewController: childController)//UINavigationController(rootViewController: childController)
//        addChildViewController(navC)
//    }

}
