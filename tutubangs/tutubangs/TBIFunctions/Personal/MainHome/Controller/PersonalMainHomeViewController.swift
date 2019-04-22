//
//  PersonalMainHomeViewController.swift
//  shanglvjia
//
//  Created by manman on 2018/7/16.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import RxSwift

class PersonalMainHomeViewController: PersonalBaseViewController {

     private var switchAccountRightButton:UIButton = UIButton()
    
    private var mainTable = UITableView()
    ///导航头
    private var topView:PersonalNavbarTopView = PersonalNavbarTopView()
    private let bag = DisposeBag()
    
    fileprivate var selectTypeArr = [["imgName":"xxx","title":"xxx"]]
    
    fileprivate var bottomArr = [["imgName":"xxx","title":"xxx","desc":"xxx"]]
    
    fileprivate var cycleScrollView = SDCycleScrollView()
    
    fileprivate var topicArray:[PersonalTopicModel] = Array()
    /// 广告头
//    private lazy var cycleScrollView: SDCycleScrollView = {
//        let headerView = SDCycleScrollView()
//        headerView.frame = CGRect(x: 0, y: 0, width: Int(ScreenWindowWidth), height: 190)
//        headerView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight
//        return headerView
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.view.backgroundColor = TBIThemeWhite
       
        localDataSource()
        setUIViewAutolayout()
        initTopView()
        
        switchAccountRightButtonViewAutolayout()
        getHomeBanner()
        getPersonalSubcatetoryBanner()
        addNotificationObserable()

        
    }

    override func viewWillAppear(_ animated: Bool) {
   
        PCommonFlightManager.shareInStance.resetAllFlightInfo()
        navigationController?.setNavigationBarHidden(true, animated: false)
        initTopView()
        getTopicListSG()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //autoScrollTimeInterval
    func initTopView(){
        topView.frame = CGRect(x:0,y:0,width:Int(ScreenWindowWidth),height:kNavigationHeight)
        let isNewMessage = UserDefaults.standard.object(forKey: pushNewMessage) as! Bool
        if isNewMessage {
            topView.rightButton.setImage(UIImage(named:"personal_homepage_white_message_red"), for: UIControlState.normal)
        }else {
            topView.rightButton.setImage(UIImage(named:"personal_homepage_white_message"), for: UIControlState.normal)
        }
        
        topView.rightButton.addTarget(self, action: #selector(rightButtonClick), for: UIControlEvents.touchUpInside)
        mainTable.addSubview(topView)
    }
    func rightButtonClick()  {
        let vc:PersonalMessageViewController = PersonalMessageViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK:- 定制视图
    func setUIViewAutolayout() {
        //tableView.frame = view.bounds
        mainTable.delegate = self
        mainTable.dataSource = self
        mainTable.separatorStyle = .none
        //mainTable.tableHeaderView =  cycleScrollView
        mainTable.bounces = false
        mainTable.showsVerticalScrollIndicator = false
        mainTable.estimatedRowHeight = 50
        mainTable.register(PersonalMainSelectTypeCell.self, forCellReuseIdentifier: "PersonalMainSelectTypeCell")
        mainTable.register(PersonalMainMoreCell.self, forCellReuseIdentifier: "PersonalMainMoreCell")
        mainTable.register(PersonalMainTopicCell.self, forCellReuseIdentifier: "PersonalMainTopicCell")
        self.view.addSubview(mainTable)
        mainTable.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(44-kNavigationHeight)
        }
        
    }
    
    
    func addNotificationObserable() {
        NotificationCenter.default.addObserver(self, selector: #selector(handlerPushMessageInfo(notification:)), name:NSNotification.Name(rawValue: notificationJpushHandlerName), object: nil)
    }
    
    
    
    
    ///本地数据
    func localDataSource(){
        selectTypeArr.removeAll()
//        selectTypeArr.append(["imgName":"personal_star_alliance","title":"航司特供机票\n千米高空飞行,丰田的责任"])
//        //selectTypeArr.append(["imgName":"personal_skyteam","title":"丰田协议机票\n千米高空飞行,丰田的责任"])
//        selectTypeArr.append(["imgName":"personal_bule_seal","title":"公司采购酒店\n甄选无忧住房,丰田的关爱"])
//        selectTypeArr.append(["imgName":"personal_orange_chair","title":"员工旅行推荐\n精致舒心旅程,员工的期待"])
        
        selectTypeArr.append(["imgName":"personal_star_alliance","title":"航司特供机票\n  "])
        //selectTypeArr.append(["imgName":"personal_skyteam","title":"丰田协议机票\n千米高空飞行,丰田的责任"])
        selectTypeArr.append(["imgName":"personal_bule_seal","title":"公司采购酒店\n  "])
        selectTypeArr.append(["imgName":"personal_orange_chair","title":"员工旅行推荐\n  "])
        
        
        
        bottomArr.removeAll()
        bottomArr.append(["imgName":"im_singapore_subject","title":"丰田员工心想狮城之旅","desc":"来自新加坡旅游局的热忱推荐"])
        bottomArr.append(["imgName":"im_japan_subject","title":"丰田员工日本完美假期","desc":"来自日本旅游局的独家推荐"])
        
    }
    
    func switchAccountRightButtonViewAutolayout() {
        switchAccountRightButton.setTitle("  去往差旅 ", for: UIControlState.normal)
        switchAccountRightButton.setBackgroundImage(UIImage.init(named: "personal_blue_change"), for: UIControlState.normal)
        switchAccountRightButton.layer.shadowOffset =  CGSize.init(width: 1, height: 1)
        switchAccountRightButton.layer.shadowOpacity = 0.8
        switchAccountRightButton.layer.shadowColor = TBIThemeBaseColor.cgColor
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
    
    
    func handlerPushMessageInfo(notification:Notification) {
        
        
        let isNewMessage:Bool = (notification.userInfo![pushNewMessage] as? Bool) ?? false
        if isNewMessage {
            topView.rightButton.setImage(UIImage(named:"personal_homepage_white_message_red"), for: UIControlState.normal)
            return
        }else {
            topView.rightButton.setImage(UIImage(named:"personal_homepage_white_message"), for: UIControlState.normal)
        }
        printDebugLog(message: "personal main")
        printDebugLog(message: notification)
        let messagetype = notification.userInfo!["type"] as! String
        intoNextPersonalMessageView(messageType: messagetype)
    }
    
    
    
    //MARK:-----Action------
    /// 切换到 个人页面
    @objc private func switchLocalAccountMainView() {
        let isSuccess:Bool =  switchAccountMainView(appStatus: DBManager.AppActiveStatus.Company_Active)
        if isSuccess == false {
            showBindingCompanyAccountView()
        }
    }
    
    
    func intoNextPersonalMessageView(messageType type:String) {
        let tabViewController:BaseTabBarController = getCurrentViewController() as! BaseTabBarController
        let navicontionController:UINavigationController = tabViewController.selectedViewController as! UINavigationController
        if navicontionController.childViewControllers.last?.isKind(of:PersonalMessageViewController.self) ?? false {
            return
        }
        let personalMessageView = PersonalMessageViewController()
        personalMessageView.messageType = type
        navicontionController.pushViewController(personalMessageView, animated: true)
        
//        printDebugLog(message:viewController.navigationController?.viewControllers)
//
//        if self.navigationController?.viewControllers.last?.isKind(of: PersonalMessageViewController.self) ?? false {
//            return
//        }
//
//        self.navigationController?.pushViewController(personalMessageView, animated: true)
    }
    
    /// 进入特价产品
    func intoNextSpecailOfferServicesView(index:NSInteger) {
        switch index {
        case 0:
            showSpecialOfferFlightView()
        case 1:
            showSpecialOfferHotelView()
        case 2:
            showSpecialOfferTravelView()
        default:
            break
        }
        //case 1:
        //showSpecialOfferFlightView()
    }
    
    func intoNextServicesView(index:NSInteger) {
        switch index {
        case 0:
            showFlightView()
        case 1:
            showHotelView()
        case 2:
            showVisaView()
        default:
            break
        }
        
    }
    
    
    
    
    
    /// 特价机票
    func showSpecialOfferFlightView()  {
        let pFlightView = PSpecialOfferFlightViewController()
        self.navigationController?.pushViewController(pFlightView, animated: true)
    }
    
    /// 机票
    func showFlightView() {
        let pFlightView = PFlightViewController()
        self.navigationController?.pushViewController(pFlightView, animated: true)
    }
    
    
    /// 特价酒店
    func showSpecialOfferHotelView()  {
        PersonalHotelManager.shareInstance.resetAllSearchCondition()
        let pHotelView = PSpecailOfferHotelViewController()
        self.navigationController?.pushViewController(pHotelView, animated: true)
        
    }
    /// 酒店
    func showHotelView()  {
        PersonalHotelManager.shareInstance.resetAllSearchCondition()
        let pHotelView = PHotelSearchViewController()
        self.navigationController?.pushViewController(pHotelView, animated: true)
        
    }
    
    /// 特价 旅游
    func showSpecialOfferTravelView()  {
        ///旅游
        let travelVC = PersonalTravelViewController()
        self.navigationController?.pushViewController(travelVC, animated: true)
    }
    /// 签证
    func showVisaView()  {
        let visaView = VisaListViewController()
        self.navigationController?.pushViewController(visaView, animated: true)
    }
    
    
    
    
    //MARK:------NET------
    func getHomeBanner() {
        weak var weakSelf = self
        PersonalMainServices.sharedInstance
            .getPersonalMainHomeBanner()
            .subscribe { (event) in
                switch event {
                case .next(let element):
                    printDebugLog(message: element)
                weakSelf?.cycleScrollView.imageURLStringsGroup = element
                case .error(let error):
                    try? weakSelf?.validateHttp(error)
                case .completed:
                    break
                    
                }
            }.addDisposableTo(self.bag)
    }
    
    func getPersonalSubcatetoryBanner() {
        PersonalBannerManager.shareInstance.getPersonalBannerFromNET()
    }
    func getTopicListSG(){
        weak var weakSelf = self
        topicArray.removeAll()
        PersonalTravelServices.sharedInstance.personalTopicDetail(id: "1")
            .subscribe{(event) in
                switch event {
                case .next(let result):
                    printDebugLog(message: result.count)
                    if result.count>0{
                        weakSelf?.topicArray.append(result.first!)
                       weakSelf?.getTopicListJP()
                    }
                case .error(_):
                    break
                case .completed:
                    break
                }
        }
        
    }
    func getTopicListJP(){
        weak var weakSelf = self
        PersonalTravelServices.sharedInstance.personalTopicDetail(id: "2")
            .subscribe{(event) in
                switch event {
                case .next(let result):
                    printDebugLog(message: result.count)
                    if result.count>0{
                        weakSelf?.topicArray.append(result.first!)
                    }
                    weakSelf?.mainTable.reloadData()
                case .error(_):
                    break
                case .completed:
                    break
                }
        }
    }
   
    

}
extension PersonalMainHomeViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2 + topicArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        weak var weakSelf = self
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalMainSelectTypeCell",for: indexPath) as! PersonalMainSelectTypeCell
            cell.setCellWithArray(array: selectTypeArr as NSArray)
            cycleScrollView = cell.cycleScrollView
            cell.selectTypeBlock = { senderTag in
               weakSelf?.intoNextSpecailOfferServicesView(index: senderTag)
            }
            return cell
        }else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalMainMoreCell",for: indexPath) as! PersonalMainMoreCell
            cell.personalMainMoreCellSelectedBlock = { selectedIndex in
               weakSelf?.intoNextServicesView(index: selectedIndex)
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalMainTopicCell",for: indexPath) as! PersonalMainTopicCell
            cell.fillData(rowIndex: indexPath.row,model:topicArray[indexPath.row-2])
            
            cell.selectRowIndexClickBlock = { (num,typeStr) in
               weakSelf?.allviewButtonClick(num: num, typeStr: typeStr)
            }
            return cell
        }
        
    }

    func allviewButtonClick(num:Int,typeStr:String){
        
        if typeStr == "allView"{
            let specialSpotsView = PersonalSpecialSpotsViewController()
            if num == 2{
                printDebugLog(message: "跳新加坡全景介绍")
                specialSpotsView.internationalCountry = "SG"
            }
            if num == 3{
                printDebugLog(message: "日本全景介绍")
                specialSpotsView.internationalCountry = "JP"
            }
        self.navigationController?.pushViewController(specialSpotsView, animated: true)
        }
        if typeStr == "product"{
            let detailView = PTravelDetailViewController()
            let model = topicArray[num-2]
            if num == 2{
                printDebugLog(message: "跳新加坡产品详情")
            }
            if num == 3{
                printDebugLog(message: "跳日本产品详情")
            }
            detailView.idStr = model.productId
            detailView.typeStr = "2"
            detailView.productName = model.contentName
            detailView.productPrice = model.price
            self.navigationController?.pushViewController(detailView, animated: true)
        }
        if typeStr == "more"{
            ///旅游
            let travelVC = PersonalTopicDetailViewController()
            if num == 2{
                printDebugLog(message: "跳新加坡查看更多")
                travelVC.nationStr = "subject"
                self.navigationController?.pushViewController(travelVC, animated: true)
            }
            if num == 3{
                printDebugLog(message: "跳日本查看更多")
                travelVC.nationStr = "japan"
                self.navigationController?.pushViewController(travelVC, animated: true)
            }
        }
    }
}

