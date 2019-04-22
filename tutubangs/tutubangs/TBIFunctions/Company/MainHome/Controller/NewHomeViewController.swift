//
//  NewCompanyHomeViewController.swift
//  shop
//
//  Created by TBI on 2018/1/30.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SwiftDate
import SwiftyJSON
import UserNotifications

/// 适配屏幕高度
let adaptationRatio = BaseViewController.adaptationRatio()

/// 适配屏幕宽度
let adaptationRatioWidth = BaseViewController.adaptationRatioWidth()

///  planning 计划中
/// waitForapprove 审批中
/// waitForTicket 待定妥
/// ticketed 已定妥
enum CoCompanyOrderStatus {
    case Planning
    case WaitForapprove
    case WaitForTicket
    case Ticketed
}

//选择车型
protocol CoCompanyOrderStatusListener
{
    func onClickListener(status:CoCompanyOrderStatus) -> Void
}


class NewHomeViewController: CompanyBaseViewController {
    
    
    fileprivate var switchAccountRightButton:UIButton = UIButton()
    
    let bag = DisposeBag()
    
    fileprivate var homeModel:HomeInfoModel?
    
    
    fileprivate let commpanyBgScrollView:UIScrollView =  UIScrollView(frame: UIScreen.main.bounds)
    
    /// 广告头
    fileprivate let cycleScrollView:SDCycleScrollView = SDCycleScrollView()
    
    fileprivate var loopBannerImageArr:[String] = Array()
    
    /// 搜索页按钮
    fileprivate let searchView:NewCompanyHomeBgSearchView = NewCompanyHomeBgSearchView()
    
    /// 公告
    fileprivate let companyNoticeView = NewCompanyHomeNoticeView.init(frame: CGRect(x:0,y:0,width:ScreenWindowWidth,height:35))
    
    /// 订单
    fileprivate let companyOrderView:NewCompanyHomeBgOrderView = NewCompanyHomeBgOrderView()
    
    /// 审批
    fileprivate let approvalView:NewCompanyHomeApprovalView = NewCompanyHomeApprovalView()
    
    /// vip
    fileprivate let vipView:NewCompanyHomeVipView = NewCompanyHomeVipView()
    
    /// newTrip
    fileprivate let newTripView:NewCompanyHomeNewTripView = NewCompanyHomeNewTripView()
    
    /// 行程count
    fileprivate var countModel:CompanyJourneyCountResult?
    
    fileprivate var companyAdv:[HomeInfoModel.AdvPic] = []
    
    fileprivate var servicesPhoneArray:[ServicesPhoneModel] = Array()
    
    fileprivate var  permissionsList:[(title:String,image:String,type:CoCompanyBusinessType,isClick:Bool)] = [(title:"",image:"ic_flights_grey",type:.Flight,isClick:false)
        ,(title:"",image:"ic_trains_grey",type:.Hotel,isClick:false)
        ,(title:"",image:"ic_hotels_grey",type:.Car,isClick:false)
        ,(title:"",image:"ic_cars_grey",type:.Car,isClick:false)
        ,(title:"ic_quick_approval_grey",image:"ic_approval_grey"
            ,type:.Approval,isClick:false),(title:"ic_bulid_grey"
                ,image:"ic_book_grey",type:.NewTrip,isClick:false)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        switchAccountRightButtonViewAutolayout()
    }
    
    
    
    func switchAccountRightButtonViewAutolayout() {
        switchAccountRightButton.setTitle("  去往个人 ", for: UIControlState.normal)
        switchAccountRightButton.setBackgroundImage(UIImage.init(named: "ic_orange_change"), for: UIControlState.normal)
        switchAccountRightButton.layer.shadowOffset =  CGSize.init(width: 1, height: 1)
        switchAccountRightButton.layer.shadowOpacity = 0.8
        switchAccountRightButton.layer.shadowColor = TBIThemeBaseColor.cgColor
        switchAccountRightButton.layer.shadowRadius = 5
        switchAccountRightButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        switchAccountRightButton.addTarget(self, action: #selector(switchLocalAccountMainView), for: UIControlEvents.touchUpInside)
        self.view.addSubview(switchAccountRightButton)
        switchAccountRightButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
            make.width.equalTo(67)
            make.height.equalTo(36)
        }
        self.view.bringSubview(toFront: switchAccountRightButton)
    }
    
    
    /// 切换到 个人页面
    @objc private func switchLocalAccountMainView() {
        let isSuccess =  switchAccountMainView(appStatus: DBManager.AppActiveStatus.Personal_Active)
        
        // 企业账号 无个人权限 隐藏 切换按钮
        
//        if isSuccess == false {
////            showSystemAlertView(titleStr: "提示", message: "没有权限开启新功能")
//            ///没有个人权限 跳到绑定个人账号页面
//            let bindVC : ChanegePsdViewController = ChanegePsdViewController()
//            bindVC.type = "bindPersonal"
//            self.navigationController?.pushViewController(bindVC, animated: true)
//        }
    }
    
    
    
    //发送通知消息
    func scheduleNotification(data:PersonalOrderCountResponseVO){
        
        if #available(iOS 10, *){
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            let content = UNMutableNotificationContent()
            let number = data.approving
            DBManager.shareInstance.setUserNotificationCompanyNum(company: number)
            if number != 0 {
                content.title = "审批通知"
                content.subtitle = DateInRegion().string(custom: "YYYY-MM-dd")
                content.body = "您有待审批的出差单"
                //content.badge = NSNumber.init(integerLiteral: number)
            }
            
            content.badge = NSNumber.init(value: DBManager.shareInstance.userNotificationNum())
            content.sound = UNNotificationSound(named: UILocalNotificationDefaultSoundName)
            
            let action = UNTextInputNotificationAction.init(identifier: "replyAction", title: "回复", options: .destructive)
            let category = UNNotificationCategory.init(identifier: "category", actions: [action,action,action,action], intentIdentifiers: [], options: .customDismissAction)
            content.categoryIdentifier = "category"
            
            //触发发送通知
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
            let request = UNNotificationRequest(identifier: "com.tbi.shop", content: content, trigger: trigger)
            UNUserNotificationCenter.current().setNotificationCategories([category])
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
                if error == nil {
                    print("trigger success")
                }
            })
            
        }else {
            UIApplication.shared.cancelAllLocalNotifications()
            let localNotifi = UILocalNotification()
            localNotifi.fireDate = NSDate.init(timeIntervalSinceNow: 5) as Date //通知发出时间
            //localNotifi.alertBody = "通知" //内容
            //localNotifi.alertAction = "解锁"
            if #available(iOS 8.2, *) {
                localNotifi.alertTitle = "message"
            } else {
                
            }
            localNotifi.applicationIconBadgeNumber = data.approving
            localNotifi.hasAction = false
            UIApplication.shared.scheduleLocalNotification(localNotifi)
        }
        
    }
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func backButtonAction(sender:UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}

extension NewHomeViewController {
    
    /// 方法二：简单使用
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = navBarBottom
        self.navigationController?.navigationBar.homeChange(TBIThemeBlueColor, with: scrollView, andValue: height)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initData()
        self.navigationController?.navigationBar.isTranslucent = true
        //self.navigationController?.navigationBar.star()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        setNavigationImage()
        scrollViewDidScroll(commpanyBgScrollView)
        
        let currentUserRight = DBManager.shareInstance.getCurrentAccountRight()
        if currentUserRight == .Only_Company {
            switchAccountRightButton.isHidden = true
        }else {
            switchAccountRightButton.isHidden = false
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.reset()
    }
}


extension NewHomeViewController{
    func initView () {
        commpanyBgScrollView.backgroundColor = TBIThemeBaseColor
        commpanyBgScrollView.showsVerticalScrollIndicator = false
        commpanyBgScrollView.contentSize =  CGSize(width: 0, height: ScreentWindowHeight)
        self.view.addSubview(commpanyBgScrollView)
        commpanyBgScrollView.snp.makeConstraints { (make) in
            make.left.top.bottom.right.equalToSuperview()
        }
        /// 设置轮播图
        cycleScrollView.pageControlDotSize = CGSize.init(width: 14, height: 8)
        cycleScrollView.currentPageDotImage = UIImage.init(named: "ic_ellipse_white")
        cycleScrollView.pageDotImage = UIImage.init(named: "ic_circle_white")
        cycleScrollView.pageControlStyle =  SDCycleScrollViewPageContolStyleClassic
        cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter
        cycleScrollView.placeholderImage = UIImage(named:"bg_default_travel")
        cycleScrollView.pageControlBottomOffset = 10
        cycleScrollView.backgroundColor = TBIThemeBaseColor
        cycleScrollView.delegate = self
        commpanyBgScrollView.addSubview(cycleScrollView)
        cycleScrollView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().inset(-navBarBottom)
            make.height.equalTo(180*adaptationRatio)
        }
        /// 设置机票酒店查询按钮
        searchView.delegate = self
        self.commpanyBgScrollView.addSubview(searchView)
        searchView.snp.makeConstraints { (make) in
            make.top.equalTo(cycleScrollView.snp.bottom).offset(-10)
            make.left.right.equalToSuperview()
            make.width.equalTo(ScreenWindowWidth)
            make.height.equalTo(193*adaptationRatio)
        }
        
        /// 设置公司公告
        self.commpanyBgScrollView.addSubview(companyNoticeView)
        companyNoticeView.snp.makeConstraints { (make) in
            make.top.equalTo(searchView.snp.bottom).offset(7*adaptationRatio)
            make.left.right.equalToSuperview()
            make.width.equalTo(ScreenWindowWidth)
            make.height.equalTo(35*adaptationRatio)
        }
        companyNoticeView.companyHomeNoticeViewSelectedResult = { (selectedIndex,dataSources) in
            let vc = CoAllNoticeListController()
            vc.noticeList = dataSources
            self.navigationController?.pushViewController(vc, animated: true)
        }
        /// 设置我的订单
        self.commpanyBgScrollView.addSubview(companyOrderView)
        companyOrderView.delegate = self
        companyOrderView.snp.makeConstraints { (make) in
            make.top.equalTo(companyNoticeView.snp.bottom).offset(7*adaptationRatio)
            make.left.right.equalToSuperview()
            make.width.equalTo(ScreenWindowWidth)
            make.height.equalTo(96*adaptationRatio)
        }
        
        /// 设置审批
        self.commpanyBgScrollView.addSubview(approvalView)
        approvalView.delegate = self
        approvalView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(companyOrderView.snp.bottom).offset(7*adaptationRatio)
            make.height.equalTo(96*adaptationRatio)
            make.width.equalTo((ScreenWindowWidth - 7*adaptationRatio)/2)
        }
        /// vip服务
        vipView.addOnClickListener(target: self, action: #selector(vipClick(tap:)))
        self.commpanyBgScrollView.addSubview(vipView)
        vipView.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.top.equalTo(companyOrderView.snp.bottom).offset(7*adaptationRatio)
            make.height.equalTo(96*adaptationRatio)
            make.width.equalTo((ScreenWindowWidth - 7*adaptationRatio)/2)
        }
        
//        /// 新建出差单
//        self.commpanyBgScrollView.addSubview(newTripView)
//        newTripView.delegate = self
//        newTripView.snp.makeConstraints { (make) in
//            make.right.equalToSuperview()
//            make.top.equalTo(vipView.snp.bottom).offset(7*adaptationRatio)
//            make.height.equalTo(44*adaptationRatio)
//            make.width.equalTo((ScreenWindowWidth - 7*adaptationRatio)/2)
//            make.bottom.equalTo(-7*adaptationRatio)
//        }
        
    }
    
    
    
    //图片加载
    func setNavigationImage() {
        let titleLabel = UIImageView.init(imageName: "ic_title_white")
        titleLabel.frame = CGRect(x:0,y:0,width:68*adaptationRatio,height:18*adaptationRatio)
        self.navigationItem.titleView = titleLabel
        
        let leftBtn : UIButton = UIButton.init(frame: CGRect(x:0,y:0,width:120,height:20))
        leftBtn.isUserInteractionEnabled = false
        //let leftImage:UIImageView = UIImageView.init()
        //leftImage.contentMode = UIViewContentMode.scaleAspectFill
        //leftImage.sd_setImage(with: URL.init(string: DBManager.shareInstance.userDetailDraw()?.userBaseInfo.corpLogo ?? ""))
        //leftBtn.setImage(leftImage.image, for: UIControlState.normal)
        //leftBtn.contentMode = UIViewContentMode.scaleAspectFill
        //leftBtn.setImage(UIImage.init(named:"ic_phone_white"), for: UIControlState.normal)
        leftBtn.sd_setImage(with:URL.init(string: DBManager.shareInstance.userDetailDraw()?.busLoginInfo.userBaseInfo.corpLogo ?? "") , for: UIControlState.normal)
        printDebugLog(message: DBManager.shareInstance.userDetailDraw()?.busLoginInfo.userBaseInfo.corpLogo ?? "")
        leftBtn.contentMode = UIViewContentMode.scaleAspectFit
        navigationItem.leftBarButtonItem =  UIBarButtonItem.init(customView: leftBtn)

        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "ic_phone_white", target: self, action: #selector(rightItemClick(sender:)))
        
        //去除导航栏的线
        self.navigationController?.navigationBar.shadowImage=UIImage()
        
        // add by manman on 2018-03-07
        // 需要在行程页面 添加 logo
        // start of  line
        
        if DBManager.shareInstance.userDetailDraw()?.busLoginInfo.userBaseInfo.corpLogo != nil && homeModel?.corpLogo.isEmpty == false {
            UserDefaults.standard.set(DBManager.shareInstance.userDetailDraw()?.busLoginInfo.userBaseInfo.corpLogo, forKey: kMainHomeLogoUrl)
        }else
        {
            UserDefaults.standard.set("", forKey: kMainHomeLogoUrl)
        }
        
        // end of line
        
    }
    
    func initData () {
        permissionsList = [(title:"",image:"ic_flights_grey",type:.Flight,isClick:false),(title:"",image:"ic_trains_grey",type:.Hotel,isClick:false),(title:"",image:"ic_hotels_grey",type:.Car,isClick:false),(title:"",image:"ic_cars_grey",type:.Car,isClick:false),(title:"ic_quick_approval_grey",image:"ic_approval_grey",type:.Approval,isClick:false),(title:"ic_bulid_grey",image:"ic_book_grey",type:.NewTrip,isClick:false)]
        if islogin(role: companyLogin) {
            return
        }
        guard let userInfo =  DBManager.shareInstance.userDetailDraw()  else {
            return
        }
        if  userInfo.busLoginInfo.resourceList.contains(where: { (element) -> Bool in
            if element.resourceRegex == FrontFlight { return true }
            else { return false }
            
        })  == true {
            permissionsList[0] = (title:"",image:"ic_flights",type:.Flight,isClick:true)
        }
        if userInfo.busLoginInfo.resourceList.contains(where: { (element) -> Bool in
            if element.resourceRegex == FrontHotel { return true }
            else { return false }
            
        }) ==  true  {
            permissionsList[2] = (title:"",image:"ic_hotels",type:.Hotel,isClick:true)
        }
        if userInfo.busLoginInfo.resourceList.contains(where: { (element) -> Bool in
            if element.resourceRegex == FrontCar { return true }
            else { return false }
            
        }) ==  true  {
            permissionsList[3] = (title:"",image:"ic_cars",type:.Car,isClick:true)
        }
        if userInfo.busLoginInfo.resourceList.contains(where: { (element) -> Bool in
            if element.resourceRegex == FrontTrain { return true }
            else { return false }
            
        }) ==  true {
            permissionsList[1] = (title:"",image:"ic_trains",type:.Train,isClick:true)
        }
        if userInfo.busLoginInfo.resourceList.contains(where: { (element) -> Bool in
            if element.resourceRegex == FrontApprove { return true }
            else { return false }
            
        }) ==  true {
            permissionsList[4] = (title:"ic_quick_approval",image:"ic_approval",type:.Approval,isClick:true)
            
        }

        
        searchView.fullCell(data: permissionsList)
        approvalView.fullCell(data: permissionsList[4])
        getNoticeSVList()
        getServicesPhone()
        personalOrderCount()
        getLoopBannerImage()
        getTrainBookMaxDate()
        let companyBookMaxDate:NSNumber = NSNumber.init(value: 90)
        let personalBookMaxDate:NSNumber = NSNumber.init(value: 90 * 2)
        UserDefaults.standard.set(companyBookMaxDate, forKey: hotelBookMaxDate)
        UserDefaults.standard.set(personalBookMaxDate, forKey: personalHotelBookMaxDate)
        
    }
    
    func getServicesPhone() {
        
        var servicesPhoneArr:[ServicesPhoneModel] = Array()
        let userInfo = DBManager.shareInstance.userDetailDraw()
        if userInfo?.busLoginInfo.userBaseInfo.corpBsaeInfo.airHotline.isEmpty == false {
            let servicesPhone:ServicesPhoneModel = ServicesPhoneModel()
            servicesPhone.phoneNum = userInfo?.busLoginInfo.userBaseInfo.corpBsaeInfo.airHotline ?? ""
            servicesPhone.platform =  EnterpriseHotLineController
                .TBIServicesCategoryServicesPhoneLocal.Air_ServicesPhone.rawValue
            servicesPhoneArr.append(servicesPhone)
        }
        if userInfo?.busLoginInfo.userBaseInfo.corpBsaeInfo.hotelHotline.isEmpty == false {
            let servicesPhone:ServicesPhoneModel = ServicesPhoneModel()
            servicesPhone.phoneNum = userInfo?.busLoginInfo.userBaseInfo.corpBsaeInfo.hotelHotline ?? ""
            servicesPhone.platform =  EnterpriseHotLineController
                .TBIServicesCategoryServicesPhoneLocal.Hotel_ServicesPhone.rawValue
            servicesPhoneArr.append(servicesPhone)
        }
        if userInfo?.busLoginInfo.userBaseInfo.corpBsaeInfo.trainHotline.isEmpty == false {
            let servicesPhone:ServicesPhoneModel = ServicesPhoneModel()
            servicesPhone.phoneNum = userInfo?.busLoginInfo.userBaseInfo.corpBsaeInfo.trainHotline ?? ""
            servicesPhone.platform =  EnterpriseHotLineController
                .TBIServicesCategoryServicesPhoneLocal.Train_ServicesPhone.rawValue
            servicesPhoneArr.append(servicesPhone)
        }
        if userInfo?.busLoginInfo.userBaseInfo.corpBsaeInfo.carHotline.isEmpty == false {
            let servicesPhone:ServicesPhoneModel = ServicesPhoneModel()
            servicesPhone.phoneNum = userInfo?.busLoginInfo.userBaseInfo.corpBsaeInfo.carHotline ?? ""
            servicesPhone.platform =  EnterpriseHotLineController
                .TBIServicesCategoryServicesPhoneLocal.Car_ServicesPhone.rawValue
            servicesPhoneArr.append(servicesPhone)
        }
        
        
        
        
        storeServicesPhoneLocal(servicesPhone: servicesPhoneArr)
        
        
//        weak var weakSelf = self
//        let userInfo = UserDefaults.standard.string(forKey: USERINFO)
//        if userInfo != nil {
//            let json = JSON(parseJSON: userInfo!)
//            let userDetail = UserDetail(jsonData:json)
//            let form = HotLineRequest(userName: userDetail.userName)
//            UserService.sharedInstance
//                .getHotLine(form)
//                .subscribe{ event in
//                    if case .next(let e) = event {
//                        weakSelf?.servicesPhoneArray.removeAll()
//                        for element in e
//                        {
//                            if element.platform.range(of: "nw") == nil
//                            {
//                                weakSelf?.servicesPhoneArray.append(element)
//                            }
//                        }
//
//                    }
//            }
//        }
    }
    
    func storeServicesPhoneLocal(servicesPhone:[ServicesPhoneModel]) {
        resetServicesPhoneLocalData()
        for element in servicesPhone {
            let servicesType = EnterpriseHotLineController.TBIServicesCategoryServicesPhoneLocal.init(type: element.platform)
            switch servicesType {
            case .Air_ServicesPhone:
                UserDefaults.standard.set(element.phoneNum, forKey: servicesPhoneAir)
            case .Air_OverTimeServicesPhone:
                UserDefaults.standard.set(element.phoneNum, forKey: servicesPhoneNWAir)
            case .Hotel_ServicesPhone:
                UserDefaults.standard.set(element.phoneNum, forKey: servicesPhoneHotel)
            case .Hotel_OverTimeServicesPhone:
                UserDefaults.standard.set(element.phoneNum, forKey: servicesPhoneNWHotel)
            case .Train_ServicesPhone:
                UserDefaults.standard.set(element.phoneNum, forKey: servicesPhoneTrain)
            case .Train_OverTimeServicesPhone:
                UserDefaults.standard.set(element.phoneNum, forKey: servicesPhoneNWTrain)
            case .Car_ServicesPhone:
                UserDefaults.standard.set(element.phoneNum, forKey: servicesPhoneCar)
            case .Car_OverTimeServicesPhone:
                UserDefaults.standard.set(element.phoneNum, forKey: servicesPhoneNWCar)
            }
        }
    }
    
    func resetServicesPhoneLocalData() {
        UserDefaults.standard.set("", forKey: servicesPhoneAir)
        UserDefaults.standard.set("", forKey: servicesPhoneNWAir)
        UserDefaults.standard.set("", forKey: servicesPhoneHotel)
        UserDefaults.standard.set("", forKey: servicesPhoneNWHotel)
        UserDefaults.standard.set("", forKey: servicesPhoneTrain)
        UserDefaults.standard.set("", forKey: servicesPhoneNWTrain)
        UserDefaults.standard.set("", forKey: servicesPhoneCar)
        UserDefaults.standard.set("", forKey: servicesPhoneNWCar)
    }
    
    //MARK:-----------------NET-----------------------
    
    //----------- 获取公告数据------------
    func getNoticeListFromService() -> Void
    {
        weak var weakSelf = self
        let coNoticeService = CoNoticeService.sharedInstance
        coNoticeService.getNoticeList()
            .subscribe{ event in
                if case .next(let result) = event
                {
                    print(result)
                    weakSelf?.companyNoticeView.reloadDataSources(dataSources: result)
                }
                if case .error(let result) = event
                {
                    print("=====失败======\n \(result)")
                    //处理异常
                    try? weakSelf?.validateHttp(result)
                }
            }.disposed(by: bag)
    }
    
    //----------- 获取公告数据------------
    func getNoticeSVList()
    {
        weak var weakSelf = self
        NoticesServices.sharedInstance
            .getNoticesList()
            .subscribe{ event in
                if case .next(let result) = event
                {
                    //printDebugLog(message: result)
                    //weakSelf?.companyNoticeView.reloadDataSources(dataSources: result)
                    weakSelf?.companyNoticeView.reloadSVDataSources(dataSources: result.notices)
                }
                if case .error(let result) = event
                {
                    print("=====失败======\n \(result)")
                    //处理异常
                    try? weakSelf?.validateHttp(result)
                }
            }.disposed(by: bag)
    }
    
    
    /// 获取轮播图
    func getLoopBannerImage() {
        weak var weakSelf = self
        HomeService.sharedInstance
            .getMainHomeImage()
            .subscribe{ event in
                
                switch event{
                case .next(let result):
                    weakSelf?.loopBannerImageArr.removeAll()
                    for element in result {
                        weakSelf?.loopBannerImageArr.append(element.url)
                    }
                    weakSelf?.cycleScrollView.imageURLStringsGroup = weakSelf?.loopBannerImageArr

                case .error(let error):
                     try? weakSelf?.validateHttp(error)
                case .completed:
                    break
                }
            }.disposed(by: bag)
    }
    

    
    
    
    /// 订单 数量
    func personalOrderCount() {
        weak var weakSelf = self
        HomeService.sharedInstance
            .personalOrderCount()
            .subscribe{ event in
                if case .next(let result) = event
                {
                    //printDebugLog(message: result)
                    //weakSelf?.companyNoticeView.reloadDataSources(dataSources: result)
                    weakSelf?.companyOrderView.fillDataSources(data: result)
                    weakSelf?.approvalView.fillDataSources(data: result)
                    weakSelf?.scheduleNotification(data: result)
                    
                }
                if case .error(let result) = event
                {
                    //处理异常
                    try? weakSelf?.validateHttp(result)
                }
            }.disposed(by: bag)
    }
    
    
    func getTrainBookMaxDate() {
        weak var weakSelf = self
        CoTrainService.sharedInstance
            .getTrainBookMaxDate()
            .subscribe{ event in
                switch event {
                case .next(let result):
                    UserDefaults.standard.set(result, forKey: trainBookMaxDate)
                case .error(let error):
                    //处理异常
                    try? weakSelf?.validateHttp(error)
                case .completed:
                    break
                    
                }
            }.disposed(by: bag)
    }
    
    
    
}
extension NewHomeViewController: CoCompanyOrderStatusListener{
    
    func onClickListener(status:CoCompanyOrderStatus) -> Void{
        
        let userDetail = UserService.sharedInstance.userDetail()
        
        if userDetail?.companyUser?.companyCode == "FTMS" {
            let vc = OrderTabController()
            switch status {
            case .Planning:
                vc.selectItemsIndex = 1
            case .Ticketed:
                vc.selectItemsIndex = 3
            case .WaitForapprove:
                break
            case .WaitForTicket:
                vc.selectItemsIndex = 2
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            
                let vc = OrderTabController()
                switch status {
                case .Planning:
                    vc.selectItemsIndex = 1
                case .Ticketed:
                    vc.selectItemsIndex = 4
                case .WaitForapprove:
                    vc.selectItemsIndex = 2
                case .WaitForTicket:
                    vc.selectItemsIndex = 3
                }
                self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func vipClick (tap:UITapGestureRecognizer) {
            self.navigationController?.pushViewController(CoVipViewController(), animated: true)
    }
}

extension NewHomeViewController: CoBusinessTypeListener{
    
    func rightItemClick(sender:UIButton) {
        getHotLine()
    }
    
    ///  监听跳转
    func onClickListener(type:CoCompanyBusinessType) -> Void {
        switch type {
        case .Flight:
            choiceRoleViewNew(.Flight)
        case .Hotel:
            choiceRoleViewNew(.Hotel)
        case .Car:
            choiceRoleViewNew(.Car)
        case .Train:
            choiceRoleViewNew(.Train)
        case .Approval:
            //判断用户类型来决定新老版
//            guard let version = UserService.sharedInstance.userDetail()?.companyUser?.newVersion else {
//                return
//            }
            if true {
                //订单控制器
                let allController = CoNewExaminesViewController()
                let tabAll = TabBarItem(text: "全部", controller: allController)
                
                let waitApprovalController = CoNewExaminesViewController()
                waitApprovalController.orderState = .waitApproval
                let tabWaitApproval = TabBarItem(text: "待审批", controller: waitApprovalController)
                
                let agreeController = CoNewExaminesViewController()
                agreeController.orderState = .agree
                let tabAgree = TabBarItem(text: "已通过", controller: agreeController)
                
                let rejectController = CoNewExaminesViewController()
                rejectController.orderState = .reject
                let tabReject = TabBarItem(text: "已拒绝", controller:rejectController)
                
                let tabs = [tabAll,tabWaitApproval,tabAgree,tabReject]
                let orderController = TabViewController()
                orderController.tabBarsItem = tabs
                orderController.companyHeader = false
                orderController.setTitle(titleStr: "订单审批")
                orderController.setNavigationBackButton(backImage: "back")
                orderController.selectItemsIndex = 1
                self.navigationController?.pushViewController(orderController, animated: true)
                
            }else {
                //订单控制器
                let allController = CoOldExaminesViewController()
                let tabAll = TabBarItem(text: "全部", controller: allController)
                
                let waitApprovalController = CoOldExaminesViewController()
                waitApprovalController.orderState = .waitApproval
                let tabWaitApproval = TabBarItem(text: "待审批", controller: waitApprovalController)
                
                let agreeController = CoOldExaminesViewController()
                agreeController.orderState = .agree
                let tabAgree = TabBarItem(text: "已通过", controller: agreeController)
                
                let rejectController = CoOldExaminesViewController()
                rejectController.orderState = .reject
                let tabReject = TabBarItem(text: "已拒绝", controller:rejectController)
                
                let tabs = [tabAll,tabWaitApproval,tabAgree,tabReject]
                let orderController = TabViewController()
                orderController.tabBarsItem = tabs
                orderController.companyHeader = false
                //orderController.setTitle(titleStr: "订单审批")
                orderController.setNavigationBackButton(backImage:"")
                orderController.selectItemsIndex = 1
                self.navigationController?.pushViewController(orderController, animated: true)
                
            }
        case .NewTrip:
            let details = UserDefaults.standard.string(forKey: USERINFO)
            if details != nil {
                let jdetails = JSON(parseJSON: details!)
                let traveller = Traveller(jsonData:jdetails["coUser"]["traveller"])
                PassengerManager.shareInStance.passengerDeleteAll()
                PassengerManager.shareInStance.passengerAdd(passenger: traveller)
            }
            let vc = CoNewTravelNoViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    //下面弹出方法
    func choiceRoleViewNew(_ type: HotelCompanyStaffViewType) {
        //let userDetail = UserService.sharedInstance.userDetail()
        let userDetail = DBManager.shareInstance.userDetailDraw()
        if userDetail?.busLoginInfo.userBaseInfo.isSecretary.isEmpty == false
            && (userDetail?.busLoginInfo.userBaseInfo.isSecretary == "1" || userDetail?.busLoginInfo.userBaseInfo.isSecretary == "3") {
            weak var weakSelf = self
            let titleArr:[String] = ["为自己预订","为他人或多人预订"]
            let roleView = TBIFinderView.init(frame: ScreenWindowFrame)
            roleView.rowHeight = 80
            roleView.fontSize = UIFont.systemFont(ofSize: 18)
            roleView.finderViewSelectedResultBlock = { (cellIndex) in
                weakSelf?.choiceRole(type ,index: cellIndex)
            }
            KeyWindow?.addSubview(roleView)
            roleView.reloadDataSources(titledataSources: titleArr, flageImage: nil)
        }else {
            forMinePlay(type)
        }
    }
    
    //为自己定 为他人定中转方法
    func choiceRole(_ type:HotelCompanyStaffViewType,index:NSInteger) {
        resetSearchCondition()
        switch index {
        case 0:
            forMinePlay(type)
        case 1:
            forOtherPlay(type)
        default: break
            
        }
        
    }
    
    func resetSearchCondition() {
        HotelManager.shareInstance.resetAllSearchCondition()
        FlightManager.shareInStance.resetAllFlightInfo()
    }
    
    
    
    
    
    func forMinePlay(_ type: HotelCompanyStaffViewType) {
        //        let details = UserDefaults.standard.string(forKey: USERINFO)
        //        let detail = DBManager.shareInstance.userDetailDraw()
        //
        //        if details != nil {
        //            let jdetails = JSON(parseJSON: details!)
        //            let traveller = Traveller(jsonData:jdetails["coUser"]["traveller"])
        //            PassengerManager.shareInStance.passengerDeleteAll()
        //            PassengerManager.shareInStance.passengerAdd(passenger:traveller)
        //        }
        
        PassengerManager.shareInStance.passengerSelf()
        if type == HotelCompanyStaffViewType.Flight{
            //            let flightSearchViewController = FlightSearchViewController()
            let flightSearchViewController = FlightSVSearchViewController()
            self.navigationController?.navigationBar.shadowImage = UIImage.init(named: "border")
            self.navigationController?.pushViewController(flightSearchViewController, animated: true)
        }else if type == HotelCompanyStaffViewType.Hotel{
            //let searchCompanyView = HotelCompanySearchViewController()
            
            let searchCompanyView = HotelSVCompanySearchViewController()
            searchCompanyView.travelNo = ""//订单号
            self.navigationController?.pushViewController(searchCompanyView, animated: true)
        }else if type == HotelCompanyStaffViewType.Train {
            let trainController = CoTrainSearchViewController()
            self.navigationController?.pushViewController(trainController, animated: true)
        }else if type == HotelCompanyStaffViewType.Car{
            let carController = CoCarSearchViewController()
            self.navigationController?.pushViewController(carController, animated: true)
        }
        
        
    }
    
    //为他人预定  进入 选择乘客信息页面
    func forOtherPlay(_ type: HotelCompanyStaffViewType){
        
        _ = PassengerManager.shareInStance.passengerSVDeleteAll()
        let staffView = HotelCompanyStaffViewController()
        staffView.hotelCompanyStaffViewType = type
        self.navigationController?.pushViewController(staffView, animated: true)
        
    }
    
}

extension NewHomeViewController: SDCycleScrollViewDelegate{
    //／ 轮播图点击回掉
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        var adv:HomeInfoModel.AdvPic
        guard self.companyAdv.count > index else {
            return
        }
        if cycleScrollView == cycleScrollView{
            adv = self.companyAdv[index]
        }else {
            return
        }
        switch adv.remark1 {
        case "hotel":
            let remark2:[String] = adv.remark2.components(separatedBy: "_")
            let remark3:[String] = adv.remark3.components(separatedBy:"_")
            if cycleScrollView == cycleScrollView {
                
                // 广告页 跳转  将 自己带入到 备选状态
                // 没有备选的旅客  将自己加入到备选状态
                // 旅客信息  应该 由一个旅客管理  统一处理
                //add by manman on 2017-10-11 start of line
                
                let details = UserDefaults.standard.string(forKey: USERINFO)
                if details != nil {
                    let jdetails = JSON(parseJSON: details!)
                    let traveller = Traveller(jsonData:jdetails["coUser"]["traveller"])
                    //personalDataSourcesArr.removeAll()
                    _ = PassengerManager.shareInStance.passengerDeleteAll()
                    //personalDataSourcesArr.append(traveller)
                    PassengerManager.shareInStance.passengerAdd(passenger: traveller)
                }
                
                
                //end of line
                
                
                let hotelCompanyListView = HotelCompanyListViewController()
                hotelCompanyListView.title = remark2[0]
                hotelCompanyListView.searchCondition.cityId = remark2[1]
                hotelCompanyListView.searchCondition.keyWord = remark2[2]
                hotelCompanyListView.searchCondition.arrivalDate = remark3[0]
                hotelCompanyListView.searchCondition.departureDate = remark3[1]
                self.navigationController?.pushViewController(hotelCompanyListView, animated: true)
            }
            break
        case "travel":
            let remark2:String = adv.remark2
            let travelProductView = TravelDetailViewController()
            travelProductView.productId = remark2
            self.navigationController?.pushViewController(travelProductView, animated: false)
            break
        case "special":
            let remark2:String = adv.remark2
            let specialProductView = SpecialDetailViewController()
            let productId = remark2
            specialProductView.productId = productId
            self.navigationController?.pushViewController(specialProductView, animated: false)
            break
        case "adv":
            let adView = ADViewController()
            adView.tarUrl = adv.advUrl
            adView.title = adv.advTitle
            self.navigationController?.pushViewController(adView, animated: false)
            break
        default:
            break
        }
    }
}

