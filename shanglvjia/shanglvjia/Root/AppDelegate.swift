             //
//  AppDelegate.swift
//  shop
//
//  Created by TBI on 2017/4/5.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import RxSwift
import Alamofire
import IQKeyboardManagerSwift
import Reachability
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,JPUSHRegisterDelegate{

   
    
    var window: UIWindow?
    let bag = DisposeBag()
    
    var reach: Reachability?
    
    let reachability = Reachability()!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        if #available(iOS 10.0, *) {
            let localNotifi = UNUserNotificationCenter.current()
            localNotifi.requestAuthorization(options: [.alert, .badge, .carPlay, .sound], completionHandler: { (flag, error) in
                if error == nil {
                    print("success")
                }
            })
        }else {
            let setting = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(setting)
        }
        application.registerForRemoteNotifications()

        //Thread.sleep(forTimeInterval:3)
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        checkVersion()
        IQKeyboardManager.sharedManager().enable = true
        setWellcomeView()
        configAmapAPIKey()
        configUMengApiKey()
        serRegisterWechat()
        configRegisterJPush(option: launchOptions)
        getHotelCity()
        window?.makeKeyAndVisible()

        if UIDevice.current.systemVersion._bridgeToObjectiveC().floatValue >= 9.0 && UIDevice.current.systemVersion._bridgeToObjectiveC().floatValue < 10.0 {
            systemVersion9 = true
            print("into here",UIDevice.current.systemVersion)
        }
        //declare this property where it won't go out of scope relative to your listener
        //declare this inside of viewWillAppear
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
        
        UserDefaults.standard.set(false, forKey: pushNewMessage)
        
        return true

    }
    
    
    
    ///  获得酒店城市
    func getHotelCity() {
        CityService.sharedInstance
            .getHotelCity()
            .subscribe{ event in
                switch event{
                case .next(let e):
                    let encodeData:Data = NSKeyedArchiver.archivedData(withRootObject: e)
                    UserDefaults.standard.set(encodeData, forKey: PersonalNormalHotelCityKey)
                case .error:
                    break
                case .completed:
                    break
                }
            }.addDisposableTo(self.bag)
    }
    
    
    // 判断网络
    func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            print("连接wift")
        case .cellular:
            print("连接窝峰数据")
        case .none:
            print("没有网络")
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        print(#function,#line)
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: GoBackground), object: nil)
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        application.applicationIconBadgeNumber = DBManager.shareInstance.userNotificationNum()
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        print(#function,#line)
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: GoForeground), object: nil)
        
        guard UserDefaults.standard.object(forKey:storeVersion) != nil else {
            return 
        }

        let newVersion:String = UserDefaults.standard.object(forKey:storeVersion) as! String
        
        let currentVersion =  localVersion()
        if currentVersion.compare(newVersion) == ComparisonResult.orderedAscending
        {
            let message = "新版可用,请立即更新至" + newVersion
            showSystemAlertView(titleStr: "更新", message: message)
            
        }
        
        
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    
    
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        let result:Bool = UMSocialManager.default().handleOpen(url, sourceApplication: sourceApplication, annotation: annotation)
        if !result
        {
            if url.host == "safepay"
            {
                
              PayManager.sharedInstance.aliPayResponse(url:url)  
                
            }else
            {
                WXApi.handleOpen(url, delegate: PayManager.sharedInstance)
            }
            
            
//            if ([url.host isEqualToString:@"safepay"]) {
//                //跳转支付宝钱包进行支付，处理支付结果
//                [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//                    NSLog(@"result = %@",resultDic);
//                    }];
//            }
        }
        
        return result
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let result:Bool = UMSocialManager.default().handleOpen(url, options: options)
        if !result
        {
            if  url.host == "safepay" {
                
                PayManager.sharedInstance.aliPayResponse(url:url)
                
            }
            else
            {
                WXApi.handleOpen(url, delegate: PayManager.sharedInstance)
            }
        }
        
        return result
        
    }
    
    //MARK:-----JpushDelegate-----
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        printDebugLog(message: error)
    }

    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        
        
        var userInfo = notification.request.content.userInfo
        userInfo[pushNewMessage] = true
        printDebugLog(message: userInfo)
        UserDefaults.standard.set(true, forKey: pushNewMessage)
        if notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self) ?? false {
            JPUSHService.handleRemoteNotification(userInfo)
            handlerNotification(userInfo: userInfo as! Dictionary<String, Any>)
        }
        completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue))
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        var userInfo = response.notification.request.content.userInfo
        UserDefaults.standard.set(false, forKey: pushNewMessage)
        userInfo[pushNewMessage] = false
        printDebugLog(message: userInfo)
        JPUSHService.resetBadge()
        if response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self) ?? false {
            JPUSHService.handleRemoteNotification(userInfo)
            handlerNotification(userInfo: userInfo as! Dictionary<String, Any>)
        }
        completionHandler()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        UserDefaults.standard.set(false, forKey: pushNewMessage)
        JPUSHService.handleRemoteNotification(userInfo)
        handlerNotification(userInfo: userInfo as! Dictionary<String, Any>)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        JPUSHService.handleRemoteNotification(userInfo)
        handlerNotification(userInfo: userInfo as! Dictionary<String, Any>)
        printDebugLog(message: userInfo)
    }
    
    func handlerNotification(userInfo:Dictionary<String,Any>) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationJpushHandlerName), object:nil , userInfo: userInfo)
    }
    
    
    
}

//总代理 
extension AppDelegate {
    
    /// 选择要展示的控制器 
    func selectShowViewController(type:String) {
        
//        let service = CityService.sharedInstance
//        service.bufferAllCity().subscribe{ event in
//            if case .next(let e) = event {
//                print(e)
//            }
//            if case .error(let e) = event {
//                print("=====失败======")
//                print(e)
//            }
//        }.addDisposableTo(bag)
        let oldVersion = UserDefaults.standard.string(forKey: SystemVersionKey)
        let currentVersion = Bundle.main.version
        if  (oldVersion == nil || oldVersion?.compare(currentVersion) == .orderedAscending) && type.isEmpty == true  {
            //进入新特性页面
            //window?.rootViewController = UINavigationController(rootViewController : NewfeatureViewController())
            let baseTabBar =  BaseTabBarController()
            baseTabBar.isCompanyLogin = type
            window?.rootViewController = baseTabBar
        }
        else {
            let baseTabBar =  BaseTabBarController()
            baseTabBar.isCompanyLogin = type
            window?.rootViewController =  baseTabBar
        }
    }
    
    
    fileprivate func setWellcomeView()
    {
        
        guard UserDefaults.standard.object(forKey: firstTime) == nil else {
            self.selectShowViewController(type:"")
            return
        }
     
        let wellcomeView = WellcomeViewController()
        window?.rootViewController = wellcomeView
        
        // 返回 true 是 企业登陆  false 随便看看
        wellcomeView.wellcomeViewControllerSelectedResult = { (result) in
            UserDefaults.standard.set(firstTime, forKey: firstTime)
            self.selectShowViewController(type: firstCompanyLogin)
//            if result {
//                self.selectShowViewController(type: firstCompanyLogin)
//            }else
//            {
//                self.selectShowViewController(type: "")
//            }

        }
    }
    
    
   
    
    
    func checkVersion() {
        
       weak var weakSelf = self
        HomeService.sharedInstance
            .getAppStoreVersion()
            .subscribe{ event in
            if case .next(let newVersion) = event {
                print("checkVersion" + newVersion)
                UserDefaults.standard.set(newVersion, forKey: storeVersion)
                let currentVersion =  weakSelf?.localVersion()
                
                if currentVersion?.compare(newVersion) == ComparisonResult.orderedAscending
                {
                    let message = "新版可用,请立即更新至" + newVersion
                    weakSelf?.showSystemAlertView(titleStr: "更新", message: message)
                    
                }
                
            }
            if case .error(let e) = event {
                print("=====失败======")
                print(e)
            }
        }.disposed(by: bag)
        
    }
    
    
    func localVersion() -> String {
        return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    }
    
    func jumpToAppStore() {
        //https://itunes.apple.com/cn/app/%E5%95%86%E6%97%85%E5%AE%B6/id1078483304?mt=8
        //https://itunes.apple.com/cn/app/%E6%B4%A5%E6%97%85%E7%BA%A6%E8%BD%A6/id1135359905?mt=8
        //https://itunes.apple.com/cn/app/商旅家/id1078483304?mt=8
        let urlStr:String = "itms-apps://itunes.apple.com/cn/app/%E5%95%86%E6%97%85%E5%AE%B6/id1078483304?mt=8"
        
        UIApplication.shared.openURL(URL.init(string: urlStr)!)
    }
    
  
    
    func configAmapAPIKey()
    {
        if AMapAPIKey.count != 0 {
            AMapServices.shared().apiKey = AMapAPIKey
        }else
        {
            printDebugLog(message: "高德地图APPKey为空")
        }
    }
    
    func serRegisterWechat() {
        
        WXApi.registerApp(WechatAppKey)
    }
    
    
    func configRegisterJPush(option: [UIApplicationLaunchOptionsKey: Any]?) {
        
        //PropellingManager.shareInstance.configJpushRegister(option: option,delegate:self)
        

        let entity = JPUSHRegisterEntity()
        entity.types = NSInteger(JPAuthorizationOptions.alert.rawValue) | NSInteger(JPAuthorizationOptions.badge.rawValue) | NSInteger(JPAuthorizationOptions.sound.rawValue)
//        if let isSuccess = IS_IOS8Later {
//
//        }
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        JPUSHService.setup(withOption: option, appKey:JPushAppKey , channel: JPusHChannel, apsForProduction:isProduct)
    }
    
    
    func configUMengApiKey()
    {
       
        configUMengStatistics()
        /* //打开调试日志
        [[UMSocialManager defaultManager] openLog:YES];
        
        //设置友盟appkey
        [[UMSocialManager defaultManager] setUmSocialAppkey:USHARE_DEMO_APPKEY];
        
        [self configUSharePlatforms];
        
        [self confitUShareSettings];
        */
        
        configUMengShare()
        configUMengSharePlatforms()
        
    }
    
    func configUMengStatistics() {
        let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        let configInstance = UMAnalyticsConfig.init()
        configInstance.appKey = UMAppKey
        configInstance.channelId = "App Store"
        configInstance.bCrashReportEnabled = true
        configInstance.ePolicy = BATCH
        MobClick.setAppVersion(appVersion)
        MobClick.start(withConfigure: configInstance)
        MobClick.setEncryptEnabled(true)
        
    }
    
    func configUMengShare() {
        UMSocialManager.default().openLog(true)
        UMSocialManager.default().umSocialAppkey = UMAppKey
    }
    func configUMengSharePlatforms() {
        //微信平台
        UMSocialManager.default().setPlaform(UMSocialPlatformType.wechatSession, appKey: WechatAppKey, appSecret: WechatAppsecert, redirectURL: nil)
        //qq平台
        UMSocialManager.default().setPlaform(UMSocialPlatformType.QQ, appKey: QQAppKey, appSecret: nil, redirectURL: nil)

    }
 
    func setLaunchImagView() {
        let launchImageView:UIImageView = UIImageView.init(image: UIImage.init(named: "wellcomeViewThird_V3"))
        print("into here ...",window?.frame)
        launchImageView.contentMode = .scaleAspectFill
        launchImageView.frame = (window?.frame)!
        window?.addSubview(launchImageView)
        window?.bringSubview(toFront: launchImageView)
        
        
        
        
        
        
    }
    /// 显示系统提示信息样式
    ///
    /// - Parameters:
    ///   - titleStr:
    ///   - message:
    func showSystemAlertView(titleStr:String,message:String) {
        //let alertView = UIAlertView.init(title: titleStr, message: message, delegate: self, cancelButtonTitle: "确定")
        weak var weakSelf = self
        let alertView = UIAlertController.init(title: "更新", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let conformAction = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default) { (alertAction) in
            weakSelf?.jumpToAppStore()
        }
        
        alertView.addAction(conformAction)
        self.window?.rootViewController?.present(alertView, animated: true, completion: { 
            
        })
        
    }
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        
        /**
         * 设置网络缓存
         **
         
         内存缓存 4M
         磁盘缓存 20M
         diskPath-》nil，会缓存到 cached 的 bundleId 目录下
         
         SDWebImage 的缓存
         
         1. 缓存时间--1周
         2. 处理缓存文件，监听系统退出到后台的事件
         - 遍历缓存文件夹，删除所有过期的文件
         - 继续遍历缓存文件夹，将最大的文件删除，一直删除到缓存文件的大小和指定的“磁盘限额”一致
         
         */
        
        let cache = URLCache(memoryCapacity: 4 * 1024 * 1024, diskCapacity: 20 * 1024 * 1024, diskPath: nil)
        //URLCache.setSharedURLCache(cache)
        URLCache.shared = cache
        return true
    }
    
    
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        
        // 在后台时
        if application.applicationState == .inactive {
            print( notification.alertBody ?? "ddd" )
        }else {
            print( notification.alertBody ?? "ddd" )
        }
    }
    
    
   

}

