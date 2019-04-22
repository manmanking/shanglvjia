//
//  HomeViewController.swift
//  shop
//
//  Created by zhangwangwang on 2017/4/5.
//  Copyright © 2017年 zhangwangwang. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SwiftDate

var homeInfoModel:HomeInfoModel?


enum HomeViewType {
    case PersonalView
    case CompanyView
}




class HomeViewController: BaseViewController, UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate  {
    
    //MARK: NavigationBar
    
    // 引导页 分流 企业登陆
    public var isCompanyLogin:String = ""
    
    let titleView = HomeTitleView()
    
    let bag = DisposeBag()
    
    //MARK: personal properties
    let baseScrollView: UIScrollView = UIScrollView.init(frame: UIScreen.main.bounds)
    
    let companyHomeMainCellViewIdentify = "companyHomeMainCellViewIdentify"
    
    //行程cell
    let journeyTableViewCellIdentify = "journeyTableViewCellIdentify"
    
    //个人轮播图
    let personalCycleScrollView:SDCycleScrollView = SDCycleScrollView()
    //企业轮播图
    let companyCycleScrollView:SDCycleScrollView = SDCycleScrollView()
    
    //let specialProductView:SpecialProductViewController = SpecialProductViewController()

    let tabBarView = HomeTabBarView.init()
    let hotlineView = HomeHotLineView.init(list: [])
    let adView = HomeADView.init()
    let lowerPriceView = HomeLowerPriceView.init(list: [])
    
    //MARK: company properties
    let companyScrollView: UIScrollView = UIScrollView.init(frame: UIScreen.main.bounds)
    
   //var companyNoticeView = CompanyHomeNoticeView.init(frame: CGRect(x:0,y:0,width:ScreenWindowWidth,height:48.5))
 
    
    let companyMainTableView = UITableView()
    let companyTripView = ComapnyHomeTripListView.init()
    //MARK: constants
    
    let journeyTableView = UITableView()
    
    var data:[CompanyJourneyResult]?
    
    //定位
    private let mapManager =  MapManager.sharedInstance
    
    var flightSection:Int   = 0
    var hotelSection:Int    = 0
    var trainSection:Int    = 0
    var carSection:Int    = 0
    var approvalSection:Int = 0
    var newtripSection:Int  = 0
    
    var personalAdv:[HomeInfoModel.AdvPic] = []
    var companyAdv:[HomeInfoModel.AdvPic] = []
    var specialAdv:[HomeInfoModel.AdvPic] = []
    
    //公务出行底图
    let companyImg =  UIImageView(imageName:"enterpriseSlogan_34")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapManager.startLocation()
        mapManager.locationCityBlock = { (locationCityName,_) in
            if locationCityName.isNotEmpty{
                switch locationCityName {
                case "北京市":
                    cityName = "北京"
                case "天津市":
                    cityName = "北京"//"天津"
                default:
                    cityName = "北京"//"天津"
                }
                self.initData()
            }
        }
        
        //baseScrollView.backgroundColor = TBIThemeWhite
        //initHomeInfoModel()
        //companyNoticeView.reloadDataSources(dataSources: dataSourcesArr)
        self.automaticallyAdjustsScrollViewInsets = true
        self.view.backgroundColor = TBIThemeMinorColor
        self.setPersonalHomeView()
        self.setCompanyHomeView()
        //add by manman start of line
        self.setNavigationController()
       //end of line
//        self.getNoticeListFromService()
        if isCompanyLogin == firstCompanyLogin {
            LoginPageVisable = false
            let vc = CompanyAccountViewController()
            vc.title = "企业账号登录"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        initData()
        initHomeInfoModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        switch PersonalType {
        case true:
            homeTypeView(typeView: HomeViewType.CompanyView)
        case false:
            homeTypeView(typeView: HomeViewType.CompanyView)
        }
        
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        isCompanyLogin = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initHomeInfoModel(){
        self.personalCycleScrollView.delegate = self
        self.companyCycleScrollView.delegate = self
        personalCycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight
        personalCycleScrollView.pageControlBottomOffset = 10
        companyCycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight
        companyCycleScrollView.pageControlBottomOffset = 10
        HomeService.sharedInstance.getHomeInfo().subscribe{ event in
            if case .next(let e) = event {
                homeInfoModel =  e
//                self.setNavigationController()
                self.setNavigationImage()
                self.personalCycleScrollView.imageURLStringsGroup = e.pics_0.map{$0.advPic}
                self.companyCycleScrollView.imageURLStringsGroup = e.pics_1.map{$0.advPic}
                self.setHomeHotlineData(model: e.travelHot)
                self.setLowerPriceDate(model: e.airticketsHot,imageUrl: e.pics_2.map{$0.advPic})
                
                self.personalAdv = e.pics_0
                self.companyAdv = e.pics_1
                self.specialAdv = e.pics_2
            }
            if case .error(let e) = event {
                try? self.validateHttp(e)
                
            }
            }.disposed(by: bag)
    }
    
    
    func initJourneyDataInfo(){
        guard let userDetail = UserService.sharedInstance.userDetail() else {
            return
        }
        if userDetail.companyUser?.accountId != nil {
            let form = JourneySearchForm(startDate: DateInRegion().absoluteDate.unix, dayNum: 365)
            CompanyJourneyService.sharedInstance.getList(form).subscribe{ event in
                switch event{
                case .next(let e):
                    self.data = e
                    //self.setCompanyHomeJourneyListView()
                    self.journeyTableView.reloadData()
                case .error(let e):
                    try? self.validateHttp(e)
                case .completed:
                    break
                }
                }.addDisposableTo(bag)
        }
    }
}

//MARK: setNavigationController
extension HomeViewController {
    
    fileprivate func initData() {
        flightSection = 0
        newtripSection = 0
        hotelSection = 0
        approvalSection = 0
        trainSection = 0
        carSection = 0
        guard let version = UserService.sharedInstance.userDetail() else {
            return
        }
        //add by manman on 2017-09-05 丰田销售定制化 不需要 新建出差单
        if version.companyUser?.newVersion ?? false && version.companyUser?.companyCode != Toyota{//是否新版本用户
            newtripSection = 1
        }
        if (version.companyUser?.permissions.filter{$0 == UserDetail.CompanyUser.Permission.flight}.count ?? 0) > 0{
            flightSection = 1
        }
        if (version.companyUser?.permissions.filter{$0 == UserDetail.CompanyUser.Permission.hotel}.count ?? 0) > 0{
            hotelSection = 1
        }
        if (version.companyUser?.permissions.filter{$0 == UserDetail.CompanyUser.Permission.approval}.count ?? 0) > 0{
            approvalSection = 1
        }
        if (version.companyUser?.permissions.filter{$0 == UserDetail.CompanyUser.Permission.train}.count ?? 0) > 0{
            trainSection = 1
        }
        if (version.companyUser?.permissions.filter{$0 == UserDetail.CompanyUser.Permission.car}.count ?? 0) > 0{
            carSection = 1
        }
        
        companyMainTableView.snp.updateConstraints { (make) in
            make.height.equalTo(Double(newtripSection+flightSection+hotelSection+approvalSection+trainSection+carSection)*84.5)
        }
//        if !PersonalType {
//            initJourneyDataInfo()
//        }
        companyMainTableView.reloadData()
        
    }
    
    func setNavigationController() {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.titleView = titleView
        titleView.businessButton.addTarget(self, action: #selector(businessButtonActive(sender:)), for: .touchUpInside)
        titleView.personalButton.addTarget(self, action: #selector(personalButtonActive(sender:)), for: .touchUpInside)
        //homeTypeView(typeView: HomeViewType.CompanyView)
        
        // end of line
    }
    
    func homeTypeView(typeView:HomeViewType) {
        if islogin(role: companyLogin) {
            return
        }
        PersonalType =  false
        self.initData()
        titleView.businessButton.active()
        titleView.businessLabel.isHidden = false
        titleView.personalButton.unActive()
        titleView.personalLabel.isHidden = true
        self.baseScrollView.isHidden = true
        self.companyScrollView.isHidden = false
        //self.getNoticeListFromService()
        self.initJourneyDataInfo()
   
//        switch typeView {
//        case .PersonalView:
//            titleView.businessButton.unActive()
//            titleView.businessLabel.isHidden = true
//            titleView.personalButton.active()
//            titleView.personalLabel.isHidden = false
//            self.baseScrollView.isHidden = false
//            self.companyScrollView.isHidden = true
//            PersonalType =  true
//            break
//        case .CompanyView:
//            if islogin(role: companyLogin) {
//                return
//            }
//            PersonalType =  false
//            self.initData()
//            titleView.businessButton.active()
//            titleView.businessLabel.isHidden = false
//            titleView.personalButton.unActive()
//            titleView.personalLabel.isHidden = true
//            self.baseScrollView.isHidden = true
//            self.companyScrollView.isHidden = false
//            self.getNoticeListFromService()
//            self.initJourneyDataInfo()
//            break
//        default:
//            break
//        }
    }
    
    //公务出行
    func businessButtonActive(sender:UIButton) {
        homeTypeView(typeView: HomeViewType.CompanyView)
    }
    
    //个人出行
    func personalButtonActive(sender:UIButton) {
        homeTypeView(typeView: HomeViewType.PersonalView)
    }
    
    //图片加载
    func setNavigationImage() {
        self.setNavigationColor()
        self.navigationController?.navigationBar.isTranslucent = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageUrl: homeInfoModel?.corpLogo ?? "", target: self, action: #selector(rightItemClick(sender:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "ic_phone_white", target: self, action: #selector(rightItemClick(sender:)))
    }
    func rightItemClick(sender:UIButton) {
        getHotLine()
    }
    
    
//    // end of line
//    func getNoticeListFromService() -> Void
//    {
//        //self.showLoadingView()
//        weak var weakSelf = self
//        let coNoticeService = CoNoticeService.sharedInstance
//        coNoticeService.getNoticeList()
//            .subscribe{ event in
//                //weakSelf?.hideLoadingView()
//                if case .next(let result) = event
//                {
//                    print(result)
//                    weakSelf?.companyNoticeView.reloadDataSources(dataSources: result)
//                }
//                if case .error(let result) = event
//                {
//                    print("=====失败======\n \(result)")
//                    //处理异常
//                    try? weakSelf?.validateHttp(result)
//                }
//            }.disposed(by: bag)
//    }

    
}


