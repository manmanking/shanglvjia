//
//  BaseViewController.swift
//  shop
//
//  Created by TBI on 2017/4/5.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import SwiftyJSON



var goBackgroundDate:Date = Date()
var goForegroundDate:Date = Date()
var timeInterval:TimeInterval = 0




class BaseViewController: UIViewController,HttpValidate,LoginValidate,UIAlertViewDelegate {

    let lodingView = LoadingView(frame: ScreenWindowFrame)
    
    private var loadingIsShow:Bool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.extendedLayoutIncludesOpaqueBars = true
        
        if DEBUG
        {
            print("viewController name=\(self)")
        }
        //verifyLocationServicesEnabled()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /// 设置Title名
    ///
    /// - Parameter titleStr: 
    func setTitle (titleStr:String) {
        let textLabel = UILabel(frame:CGRect(x:0,y:0,width:100,height:44))
        textLabel.text = titleStr as String
        textLabel.textColor = UIColor.white
        textLabel.font = UIFont.systemFont(ofSize: 16)
        textLabel.textAlignment = NSTextAlignment.center
        self.navigationItem.titleView = textLabel
    }
    
    /// 设置title名称和颜色
    ///
    /// - Parameters:
    ///   - titleStr:
    ///   - titleColor:
    func setTitle (titleStr:String,titleColor:UIColor) {
        let textLabel = UILabel(frame:CGRect(x:0,y:0,width:100,height:44))
        textLabel.text = titleStr as String
        textLabel.textColor = titleColor
        textLabel.font = UIFont.systemFont(ofSize: 16)
        textLabel.textAlignment = NSTextAlignment.center
        self.navigationItem.titleView = textLabel
    }
    
    /// 设置title名
    ///
    /// - Parameter titleName:
    func setTitleImage (titleName:String)  {
        
        let imageView:UIImageView = UIImageView.init(image:UIImage.init(named: titleName))
        imageView.contentMode = UIViewContentMode.scaleToFill
        navigationItem.titleView = imageView
    }
    
    /// 设置barColor
    ///
    /// - Parameter color: =
    func setNavigationBgColor(color:UIColor) {
        navigationController?.navigationBar.barTintColor = color
    }
    
    
    /// 设置navigation title
    ///
    /// - Parameter title: =
    func setNavigation(title:String){
        setTitle(titleStr: title)
        self.view.backgroundColor = TBIThemeBaseColor
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        setNavigationBgColor(color:TBIThemeBlueColor)
    }
    
    
    /// 蓝底白字
    func setWhiteTitleAndNavigationColor(title:String) {
        setTitle(titleStr: title)
        setNavigationBackButton(backImage: "back")
        self.navigationController?.navigationBar.setNavigationColor(color:TBIThemeDarkBlueColor,alpha:1)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    }
    
    /// 白底黑字
    func setBlackTitleAndNavigationColor(title:String) {
        setTitle(titleStr: title, titleColor: TBIThemePrimaryTextColor)
        setNavigationBackButton(backImage: "left")
        self.navigationController?.navigationBar.setNavigationColor(color:TBIThemeWhite,alpha:1)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    

    /// 白色背景黑字背景
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - color: 颜色
    func initNavigation(title:String){
        setTitle(titleStr: title,titleColor: TBIThemePrimaryTextColor)
        self.navigationController?.navigationBar.setNavigationColor(color:TBIThemeWhite,alpha:1)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        self.navigationController?.navigationBar.isTranslucent = true
        setNavigationBackButton(backImage: "left")
    }
    
    /// 透明背景颜色白字
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - bgColor: 上拉时候背景颜色
    func initNavigation(title:String,bgColor:UIColor,alpha:CGFloat,isTranslucent:Bool){
        setTitle(titleStr: title,titleColor: TBIThemeWhite)
        self.navigationController?.navigationBar.setNavigationColor(color:bgColor,alpha:alpha)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        self.navigationController?.navigationBar.isTranslucent = isTranslucent
        setNavigationBackButton(backImage: "back")
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    //MARK:------JPush----
    func setJPushAlias(phone:String) {
        JPUSHService.setAlias(phone, completion: { (resCode, alias, tags) in
            print(#function,#line,resCode,alias ?? "",tags)
        }, seq: 1)
    }
    
    func setJpushTag(phone:String = "TOTOMSG") {
        JPUSHService.setTags([phone], completion: { (code, alias, tags) in
            print(#function,#line,code,alias ?? "",tags)
        }, seq: 1)
    }
    
    func deleteJPushAlias() {
        JPUSHService.deleteAlias({ (resCode, alias, tags) in
            print(#function,#line,resCode,alias ?? "",tags)
        }, seq: 1)
    }
    
    
    /// 设置线条
    func setNavigationColor(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        setNavigationBgColor(color:TBIThemeDarkBlueColor)
    }
    
    
    /// 返回 按钮
    ///
    /// - Parameter backImage: =
    func setNavigationBackButton(backImage:String) {
        // 设置导航栏标题的字体颜色
        //self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white];
        // 自定义导航栏的"返回"按钮
        let backButton = UIButton(frame:CGRect(x:0,y:0,width:44,height:44)) //UIButton(frame:CGRect(x:15,y:5,width:12,height:18))
        if backImage.isEmpty == false {
            backButton.setImage(UIImage(named:backImage as String), for: UIControlState.normal)
        }else
        {
            backButton.setImage(UIImage(named:"back"), for: UIControlState.normal)
        }
//        backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0)
        backButton.contentHorizontalAlignment=UIControlContentHorizontalAlignment.left
        
        backButton.addTarget(self, action:#selector(backButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        backButton.setEnlargeEdgeWithTop(15 ,left: 15, bottom: 10, right: 10)
        let backBarButton = UIBarButtonItem.init(customView: backButton)
        // 设置导航栏的leftButton
        self.navigationItem.leftBarButtonItem = backBarButton
    }
    
   
    /// - 设置返回 标题
    func setNavigationBackButtonTitle(title:String) {

        let backButton = UIButton(frame:CGRect(x:0,y:0,width:100,height:44))
        backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0)
        backButton.setTitle(title, for: UIControlState.normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        backButton.setTitleColor(TBIThemePrimaryTextColor, for: UIControlState.normal)
        backButton.addTarget(self, action:#selector(backButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        backButton.setEnlargeEdgeWithTop(15 ,left: 15, bottom: 10, right: 10)
        let backBarButton = UIBarButtonItem.init(customView: backButton)
        // 设置导航栏的leftButton
        self.navigationItem.leftBarButtonItem = backBarButton
    }
    /// 分享 按钮  OR  关闭按钮
    ///
    /// - Parameter title:
    func setNavigationRightButton(title:String) {
       
        setNavigationRightButton(title:title,titleColor:TBIThemePrimaryTextColor)
    }
    
    func setNavigationRightButton(title:String,titleColor:UIColor) {
        // 自定义导航栏的"返回"按钮
        let rightButton = UIButton(frame:CGRect(x:15,y:5,width:30,height:18))
        if title.isEmpty == false {
            rightButton.setTitle(title,for: UIControlState.normal)
        }else
        {
            rightButton.setTitle("",for: UIControlState.normal)
        }
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        rightButton.setTitleColor(titleColor, for: UIControlState.normal)
        rightButton.addTarget(self, action:#selector(rightButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        let rightBarButton = UIBarButtonItem.init(customView: rightButton)
        // 设置导航栏的leftButton
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    
    func setNavigationRightButton(title:String,selectedtitle:String) {
        let rightButton = UIButton(frame:CGRect(x:15,y:5,width:35,height:18))
        rightButton.setTitle(title, for: UIControlState.normal)
        rightButton.setTitleColor(TBIThemePlaceholderColor, for: UIControlState.normal)
        rightButton.setTitle(selectedtitle, for: UIControlState.selected)
        rightButton.setTitleColor(TBIThemePlaceholderColor, for: UIControlState.selected)
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        rightButton.addTarget(self, action:#selector(rightButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        let rightBarButton = UIBarButtonItem.init(customView: rightButton)
        // 设置导航栏的leftButton
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    
    
    
    /// 登录页面
    ///
    /// - Parameter from: 不同页面 展示不同的登录页面特性
    func showLoginView(from:String) {
        let loginViewController = CompanyAccountViewController()
        //转场效果  由下向上
        loginViewController.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.present(loginViewController, animated: true) {
            
        }
    }
    
    func showLoginViewAndBackOrigionView(form:String) {
        let companyAccountView = CompanyAccountViewController()
        companyAccountView.title = "企业账号登录"
        self.navigationController?.pushViewController(companyAccountView, animated: true)
//        let loginView = LoginViewController()
//        loginView.jumpFlag = false
//        self.navigationController?.pushViewController(loginView, animated: true)
    }
    
    
    /// 显示系统提示信息样式
    ///
    /// - Parameters:
    ///   - titleStr:
    ///   - message:
    
    func showSystemAlertView(titleStr:String,message:String) {
        
        let alertController = UIAlertController(title: titleStr,
                                                message: message , preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        if #available(iOS 9.0, *){
            cancelAction.setValue(PersonalThemeNormalColor, forKey: "titleTextColor")
        }
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    
    func showSystemAlertView(titleStr:String,message:String ,completeBlock:((UIAlertAction)->Void)?) {
        
        let alertController = UIAlertController(title: titleStr,
                                                message: message , preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: completeBlock)
        if #available(iOS 9.0, *){
            cancelAction.setValue(PersonalThemeNormalColor, forKey: "titleTextColor")
        }
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    /// 左边按钮事件
    ///
    /// - Parameter sender:
    func backButtonAction(sender:UIButton) {
        NSLog("未重写导航条返回按钮点击方法 %s %d",#function,#line)
    }
    
    /// 右边按钮事件
    ///
    /// - Parameter sender:
    func rightButtonAction(sender:UIButton) {
        NSLog("未重写导航条右侧按钮点击方法 %s %d",#function,#line)
    }
    
    /// 显示loading
    func showLoadingView () {
        if loadingIsShow == false {
            loadingIsShow = true
            KeyWindow?.addSubview(lodingView)
        }
        
    }
    /// 隐藏loading
    func hideLoadingView () {
        if loadingIsShow == true {
            loadingIsShow = false
            lodingView.removeFromSuperview()
        }
        
    }
    
    /// 弹出提示
    ///
    /// - Parameters:
    ///   - title: 提示title
    ///   - message: 提示消息
    func alertView(title:String,message:String){
        let alertController = UIAlertController(title: title,
                                                message: message , preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        if #available(iOS 9.0, *){
            cancelAction.setValue(PersonalThemeNormalColor, forKey: "titleTextColor")
        }
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
  
    
    func intoMainView(from:String) {
        NSLog("from %@ into main view ", from)
        LoginPageVisable = false
        _ = self.navigationController?.popToRootViewController(animated: false)
        let tabbarView:BaseTabBarController = UIApplication.shared.keyWindow?.rootViewController as!BaseTabBarController
        tabbarView.setAppStatusDefaultActive()
        tabbarView.selectedIndex = 0
    }
    
    
    /// 切换 账户 权限
    ///
    /// - Parameter appStatus:
    func switchAccountMainView(appStatus:DBManager.AppActiveStatus ) -> Bool{
        guard DBManager.shareInstance.getCurrentAccountRight() == DBManager.AccountAllRight.Both else {
            //showSystemAlertView(titleStr: "提示", message: "没有权限开启新功能")
            return false
        }
        // 企业跳转个人
        
        switch appStatus {
        case .Personal_Active:
            intoPersonalMainView()
        case .Company_Active:
            intoCompanyMainView()
        }
        return true
    }
    
    
    private func intoCompanyMainView() {
        
        let tabbarView:BaseTabBarController = UIApplication.shared.keyWindow?.rootViewController as!BaseTabBarController
        tabbarView.setAppStatusActive(appStatus: DBManager.AppActiveStatus.Company_Active)
        tabbarView.selectedIndex = 0
    }
    private func intoPersonalMainView() {
        let tabbarView:BaseTabBarController = UIApplication.shared.keyWindow?.rootViewController as!BaseTabBarController
        tabbarView.setAppStatusActive(appStatus: DBManager.AppActiveStatus.Personal_Active)
        tabbarView.selectedIndex = 0
    }
    
    
    /// 跳转到订单页面
    func popOrderView() {
        //self.navigationController?.popToRootViewController(animated: false)
//        let vc = OrderTabController()
//        self.navigationController?.pushViewController(vc, animated: true)
        
        self.navigationController?.childViewControllers.forEach{
            if let controller = $0 as? OrderTabController {
                self.navigationController?.popToViewController(controller, animated: true)
                return
            }
        }
        let vc = OrderTabController()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    //MARK:-------------add location verify
    
    func verifyLocationServicesEnabled() {

        print(#function,#line)

        if CLLocationManager.locationServicesEnabled() {
            // 本APP被禁止使用定位功能
            if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied
            {
                let alertView = UIAlertView.init(title: "APP已经被禁止使用定位功能", message: "请在iphone \"设置-商旅家-定位服务\" 中允许商旅家使用定位服务", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "设置")
                alertView.tag = 999
                alertView.show()

            }
        }else
        {
            //定位功能未开启
            if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied
            {
                let alertView = UIAlertView.init(title: "APP已经被禁止使用定位功能", message: "请在iphone \"设置-隐私-定位服务\" 中允许商旅家使用定位服务", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "设置")
                alertView.tag = 998
                alertView.show()


            }



        }

    }

    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {

//        guard buttonIndex == 1 else {
//            return
//        }
//        switch alertView.tag {
//        case 999:
//
//            let specialUrl:URL = URL.init(string:UIApplicationOpenSettingsURLString)!
//            if UIApplication.shared.canOpenURL(specialUrl)
//            {
//                UIApplication.shared.openURL(specialUrl)
//            }
//
//        case 998:
//            let specialUrl:URL = URL.init(string:"prefs:root=LOCATION_SERVICES")!
//            if UIApplication.shared.canOpenURL(specialUrl)
//            {
//                UIApplication.shared.openURL(specialUrl)
//            }
//
//        default:
//            break
//        }
    }

    
    
    
    func getCurrentViewController() -> UIViewController {
        
        var window = UIApplication.shared.keyWindow
        if window?.windowLevel != UIWindowLevelNormal {
            let windows = UIApplication.shared.windows
            for tmpWind in windows {
                if tmpWind.windowLevel == UIWindowLevelNormal {
                    window = tmpWind
                    break
                }
            }
        }
        
        let frontView = window?.subviews.first
        let nextResponder = frontView?.next
        if (nextResponder?.isKind(of: UIViewController.classForCoder()))! {
            return nextResponder as! UIViewController
        }else
        {
            return (window?.rootViewController)!
        }
    }
    
    //通用打电话的方法
    let hotLineEnterprise:Int = 1   //企业电话
    let hotLinePersonal:Int = 2     //个人电话
    func getHotLine (type:Int = 0) ->Void {
        //let userInfo = UserDefaults.standard.string(forKey: USERINFO)
        let userInfo = DBManager.shareInstance.userDetailDraw()
        switch type {
        case 0,hotLineEnterprise:
            if userInfo != nil {
                
                if userInfo?.busLoginInfo.userBaseInfo.corpCode.isEmpty == false {
                    self.navigationController?.pushViewController(EnterpriseHotLineController(), animated: true)
                }else{
                    UIApplication.shared.openURL(NSURL(string :"tel://"+DefHotLine)! as URL)
                }
            }else{
                UIApplication.shared.openURL(NSURL(string :"tel://"+DefHotLine)! as URL)
            }
            break;
        case hotLinePersonal:
            UIApplication.shared.openURL(NSURL(string :"tel://"+DefHotLine)! as URL)
            break;
        default:
            break;
        }
    }
}
/// 赵昭添加 有锅请找我
protocol LoginValidate {
    func islogin(role:String?) -> Bool
}
extension LoginValidate where Self:UIViewController {
   
    //判断用户是否登陆
    func islogin() -> Bool{
        let userDetail = UserService.sharedInstance.userDetail()
        if  userDetail == nil{
//            let vc = LoginViewController()
//            vc.jumpFlag =  false
//            self.navigationController?.pushViewController(vc, animated: true)
            
            let vc = CompanyAccountViewController()
            vc.title = "企业账号登录"
            self.navigationController?.pushViewController(vc, animated: true)
            return false
        }else {
            return true
        }
    }
    
    func loginNewObt()->Bool {
       
        let loginSVView = LoginSVViewController()
//        loginSVView.view.backgroundColor = TBIThemeWhite
//        loginSVView.setNavigationBackButton(backImage: "")
        self.navigationController?.pushViewController(loginSVView, animated: true)
        return true
    }
    
    
    
    /// 判断用户是否登录是否有企业权限 没有踢到登陆页
    func islogin(role:String?) -> Bool{
        
        let userDetail = DBManager.shareInstance.userDetailDraw()
        if userDetail == nil ||
            (userDetail?.busLoginInfo.token.isEmpty == true &&
                userDetail?.cusLoginInfo.token.isEmpty == true  ){
          return  loginNewObt()
        }
        return false
        //let userDetail = UserService.sharedInstance.userDetail()
        
        
        
        if userDetail == nil {
            let navigationController = getBaseNavigationController()
            if navigationController != nil
            {
                print("im here ...")
                print(navigationController.childViewControllers)
                if (navigationController.childViewControllers.last?.isKind(of: CompanyAccountViewController.classForCoder()))!
                {
                    return true
                }
            }
            let vc = CompanyAccountViewController()
            vc.title = "企业账号登录"
            self.navigationController?.pushViewController(vc, animated: true)
            return true
        }
//        }else {
//            /// 个人用户登陆 点击企业功能需要绑定
//            if userDetail?.companyUser?.accountId == nil && role == companyLogin {
//                let vc = CompanyAccountViewController()
//                vc.title = bingCompanyAccount
//                if !LoginPageVisable {
//                    LoginPageVisable = true
//                    let nav = getBaseNavigationController()
//                    if nav != nil
//                    {
//                        print("im here ...")
//                        print(nav.childViewControllers)
//                        if (nav.childViewControllers.last?.isKind(of: CompanyAccountViewController.classForCoder()))!
//                        {
//                            return true
//                        }
//                    }
//
//                    nav.pushViewController(vc, animated: true)
//                }
//
//                return true
//            }
//        }
//        //用户没有登陆
//        if userDetail == nil && role == personalLogin{
//            print("个人登陆 ")
//            let vc = LoginViewController()
//            if !LoginPageVisable {
//                LoginPageVisable = true
//                PersonalType =  true
//                let nav = getBaseNavigationController()
//                nav.pushViewController(vc, animated: true)
//            }
//            return true
//            // 企业登陆
//        }else if userDetail == nil && role == companyLogin
//        {
//            let vc = LoginViewController()
//            if !LoginPageVisable {
//                LoginPageVisable = true
//                PersonalType =  true
//                let nav = getBaseNavigationController()
//                nav.pushViewController(vc, animated: true)
//            }
//            return true
//
//        }else {
//            /// 个人用户登陆 点击企业功能需要绑定
//            if userDetail?.companyUser?.accountId == nil && role == companyLogin {
//                let vc = CompanyAccountViewController()
//                vc.title = bingCompanyAccount
//                if !LoginPageVisable {
//                    LoginPageVisable = true
//                    let nav = getBaseNavigationController()
//                    nav.pushViewController(vc, animated: true)
//                }
//
//                return true
//            }
//        }
        return false
    }
    
    func getBaseNavigationController() -> BaseNavigationController{
        _ = self.navigationController?.popToRootViewController(animated: false)
        let tabbarView:BaseTabBarController = UIApplication.shared.keyWindow?.rootViewController as!BaseTabBarController
        tabbarView.selectedIndex = 0
        
        let nav = tabbarView.childViewControllers[0] as! BaseNavigationController
        return nav
    }
}

class FlightBaseViewController:BaseViewController{

    /// 弹出提示
    ///
    /// - Parameters:
    ///   - title: 提示title
    ///   - message: 提示消息
//    func flightNoAlertView(title:String,message:String){
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "确定", style: .default){ action in
//            alertController.removeFromParentViewController()
//            self.navigationController?.popViewController(animated: true)
//        }
//        alertController.addAction(okAction)
//        self.present(alertController, animated: true)
//    }
    
}

extension BaseViewController {
    
    class func isIphoneX() -> Bool {
        return UIScreen.main.bounds.equalTo(CGRect(x: 0, y: 0, width: 375, height: 812))
    }
    
    class func adaptationRatio() -> CGFloat {
        //375   * 667     1      375.0  667.0  4.7    1
        //540   * 960     1.44   414.0  736.0  5.5    1.1下·
        //562  * 1218     1.5    375    812           1.22
        //320 8 480               320          3.5
        if UIScreen.main.bounds.equalTo(CGRect(x: 0, y: 0, width: 375, height: 812)) {
            return 1.18
        }else if UIScreen.main.bounds.equalTo(CGRect(x: 0, y: 0, width: 375, height: 736)) {
            return 1
        }else if UIScreen.main.bounds.equalTo(CGRect(x: 0, y: 0, width: 414, height: 736)) {
            return 1.11
        }else if UIScreen.main.bounds.equalTo(CGRect(x: 0, y: 0, width: 320, height: 568)) {
            return 0.84
        }else if UIScreen.main.bounds.equalTo(CGRect(x: 0, y: 0, width: 320, height: 480)) {
            return 0.72
        }
        return 1
    }
    
    class func adaptationRatioWidth() -> CGFloat {
        //375   * 667     1      375.0  667.0  4.7    1
        //540   * 960     1.44   414.0  736.0  5.5    1.1下·
        //562  * 1218     1.5    375    812           1.22
        if UIScreen.main.bounds.equalTo(CGRect(x: 0, y: 0, width: 375, height: 812)) {
            return 1
        }else if UIScreen.main.bounds.equalTo(CGRect(x: 0, y: 0, width: 375, height: 736)) {
            return 1
        }else if UIScreen.main.bounds.equalTo(CGRect(x: 0, y: 0, width: 414, height: 736)) {
            return 1.11
        }else if UIScreen.main.bounds.equalTo(CGRect(x: 0, y: 0, width: 320, height: 568)) {
            return 0.84
        }
        return 1
    }
    
    class func navBarBottom() -> CGFloat {
        return self.isIphoneX() ? 88 : 64;
    }
    class func tabBarHeight() -> CGFloat {
        return self.isIphoneX() ? 83 : 49;
    }
    class func screenWidth() -> Int {
        return Int(UIScreen.main.bounds.size.width)
    }
    class func screenHeight() -> Int {
        return Int(UIScreen.main.bounds.size.height)
    }
}
