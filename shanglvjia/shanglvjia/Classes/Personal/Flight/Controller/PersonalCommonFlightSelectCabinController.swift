//
//  PersonalCommonFlightSelectCabinController.swift
//  shanglvjia
//
//  Created by tbi on 2018/8/6.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import RxSwift

class PersonalCommonFlightSelectCabinController: PersonalBaseViewController {

    
    public var personalOnsaleFlightListViewType:AppModelCatoryENUM = AppModelCatoryENUM.PersonalFlight
    
    public var flightViewType:FlightCommonSearchViewENUM = FlightCommonSearchViewENUM.Default
    
    fileprivate let bag = DisposeBag()
    
    fileprivate let flightTableViewHeaderIdentify = "flightTableViewHeaderCellIdentify"
    
    fileprivate let flightSelectCabinsContentSVTableViewCell = "PCommonSelectCabinsContentCell"
    
    fileprivate let flightTripTransferHeaderViewIdentify:String = "PersonalFlightTripTransferViewIdentify"
    
    fileprivate let tableView = UITableView()
    
    fileprivate var firstFlightSVSearchCondition:FlightSVSearchConditionModel = FlightSVSearchConditionModel()
    
    public var flightCabinInfo: PCommonFlightSVSearchModel.AirfareVO = PCommonFlightSVSearchModel.AirfareVO()
    
    fileprivate var recommendFlightCabinInfoArr:[RecommendFlightResultVOModel] = Array()
    
     fileprivate var type:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBlackTitleAndNavigationColor(title: "")
        setNavigationBackButton(backImage: "left")
        self.view.backgroundColor = TBIThemeBaseColor
        
        /// 设置标题
        var startCity:String = ""
        var arriveCity:String = ""
        firstFlightSVSearchCondition = PCommonFlightManager.shareInStance.flightConditionDraw().first! //tableViewDataSources.first!
        startCity = PCommonFlightManager.shareInStance.flightConditionDraw()[firstFlightSVSearchCondition.currentTripSection - 1].takeOffCity
        arriveCity = PCommonFlightManager.shareInStance.flightConditionDraw()[firstFlightSVSearchCondition.currentTripSection - 1].arriveCity
        setTitleView(start: startCity, arrive: arriveCity)
        setTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        
        var startCity:String =  ""
        var arriveCity:String = ""
        startCity = PCommonFlightManager.shareInStance.flightConditionDraw()[firstFlightSVSearchCondition.currentTripSection - 1].takeOffCity
        arriveCity = PCommonFlightManager.shareInStance.flightConditionDraw()[firstFlightSVSearchCondition.currentTripSection - 1].arriveCity
        if firstFlightSVSearchCondition.currentTripSection == 2 && firstFlightSVSearchCondition.type == 1  {
            startCity = firstFlightSVSearchCondition.arriveCity
            arriveCity = firstFlightSVSearchCondition.takeOffCity
        }
        setTitleView(start:startCity, arrive:arriveCity )
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // 设置标题
    func setTitleView(start: String, arrive: String) {
        let titleView: UIView = {
            let vi = UIView()
            let labelStart = UILabel.init(text: start, color: TBIThemePrimaryTextColor, size: 16)
            let imageView = UIImageView(imageName: "ic_air_to")
            let labelArrive = UILabel.init(text: arrive, color: TBIThemePrimaryTextColor, size: 16)
            
            vi.addSubview(labelStart)
            vi.addSubview(imageView)
            vi.addSubview(labelArrive)
            
            imageView.snp.makeConstraints{ (make) in
                make.height.equalTo(15)
                make.width.equalTo(20)
                make.center.equalTo(vi.snp.center)
            }
            labelStart.snp.makeConstraints{ (make) in
                //make.top.equalTo(imageView.snp.top).offset(-7)
                make.right.equalTo(imageView.snp.left).offset(-6)
                make.centerY.equalToSuperview()
            }
            labelArrive.snp.makeConstraints{ (make) in
                //make.top.equalTo(labelStart.snp.top)
                make.left.equalTo(imageView.snp.right).offset(6)
                make.centerY.equalToSuperview()
            }
            return vi
        }()
        self.navigationItem.titleView = titleView
    }
}
extension PersonalCommonFlightSelectCabinController:UITableViewDelegate,UITableViewDataSource {
    
    func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.bounces = false
        tableView.register(FLightSelectCabinsHeaderCellView.classForCoder(), forHeaderFooterViewReuseIdentifier:flightTableViewHeaderIdentify )
        tableView.register(PersonalFlightTripTransferView.classForCoder(), forHeaderFooterViewReuseIdentifier: flightTripTransferHeaderViewIdentify)
        tableView.register(PCommonSelectCabinsContentCell.classForCoder(), forCellReuseIdentifier: flightSelectCabinsContentSVTableViewCell)
        tableView.separatorStyle = .none
        tableView.backgroundColor = TBIThemeBaseColor
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(1)
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //MARK:- UITableViewDataSources
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (PCommonFlightManager.shareInStance.selectedFlightTripDraw().last?.cabins.count)!
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 71
      
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:PCommonSelectCabinsContentCell = tableView.dequeueReusableCell(withIdentifier: flightSelectCabinsContentSVTableViewCell) as! PCommonSelectCabinsContentCell
        cell.selectionStyle = .none
        weak var weakSelf = self
        cell.fillDataSources(cabin: (PCommonFlightManager.shareInStance.selectedFlightTripDraw().last?.cabins[indexPath.row])!,index:indexPath.row)
        cell.flightSelectCabinsContentSVCellSelectedBlock = { (index) in
            weakSelf?.verifyAhtoPolicy(index: index)
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if PCommonFlightManager.shareInStance.selectedFlightTripDraw().last?.flightInfos.count ?? 0 > 1 {
            ///中转的头
            return 215
        }
        if PCommonFlightManager.shareInStance.selectedFlightTripDraw().last!.flightInfos.first?.share ?? false{
            ///不是中转的头
            return 170
        }
         ///不是中转的头
        return 145
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if (PCommonFlightManager.shareInStance.selectedFlightTripDraw().last?.flightInfos.count)! > 1 {
            let headerView:PersonalFlightTripTransferView = tableView.dequeueReusableHeaderFooterView(withIdentifier:flightTripTransferHeaderViewIdentify) as! PersonalFlightTripTransferView
            headerView.fillDataSources(airfare: PCommonFlightManager.shareInStance.selectedFlightTripDraw().last!)
            return headerView
        }else
        {
            let headerView:FLightSelectCabinsHeaderCellView = tableView.dequeueReusableHeaderFooterView(withIdentifier:flightTableViewHeaderIdentify) as! FLightSelectCabinsHeaderCellView
            headerView.fillDataSourcesCommon(airfare:PCommonFlightManager.shareInStance.selectedFlightTripDraw().last!)
            return headerView
            
        }
    }
    
    
    
    
    
    //显示协议价格明细
    func messageDetail() {
        let title:[(title:String,content:String)] = [("什么是协议价?","")]
        let subFirstTitle:[(title:String,content:String)] = [("", "津旅商务与贵公司、航空公司共同签订三方协议，贵公司员工乘坐某些航班的舱位会享有价格上的优惠。")]
        let tbiALertView = TBIAlertView.init(frame: ScreenWindowFrame)
        tbiALertView.setDataSources(dataSource: [title,subFirstTitle])
        KeyWindow?.addSubview(tbiALertView)
        
    }
    
    
    /// 进入预定页面 OR 继续选择航班
    func intoNextView() {
        switch flightViewType {
        case .RebookCommonFlight:
            rebookCommonFlight()
        case .Default:
            intoCommitOrder()
        }
      

    
    }
    
    func intoCommitOrder() {
        let personalFlightOrderViewController = PersonalFlightOrderViewController()
        personalFlightOrderViewController.personalFlightOrderViewType = AppModelCatoryENUM.PersonalFlight
        // 单程 进入下单页面
        if firstFlightSVSearchCondition.type ==  0 {
            self.navigationController?.pushViewController(personalFlightOrderViewController, animated: true)
        }else if firstFlightSVSearchCondition.type == 1 { //进入返程  的返程 页面
            
            if firstFlightSVSearchCondition.currentTripSection == 1{
                firstFlightSVSearchCondition.currentTripSection = 2
                // 这个保存的是 个人的 还是 定投  特惠
                FlightManager.shareInStance.addSearchFlightCondition(searchCondition: firstFlightSVSearchCondition, tripSection:0)
                let vcp = PFlightSearchListViewController()
                self.navigationController?.pushViewController(vcp, animated: true)
            }else{ // 进入 预定页面
                
                self.navigationController?.pushViewController(personalFlightOrderViewController, animated: true)
            }
        }
    }
    
    func rebookCommonFlight() {
        
        let request:PersonalFlightReorderRequireRequest = PersonalFlightReorderRequireRequest()
        
        for element in  PCommonFlightManager.shareInStance.selectedFlightTripDraw() {
            let selectedCabinsIndex:NSInteger = element.selectedCabinIndex!
            let flightInfo:CommitParamVOModel.CommitFlightVO = CommitParamVOModel.CommitFlightVO()
            flightInfo.cabinCacheId = element.cabins[selectedCabinsIndex].cacheId
            flightInfo.flightCacheId = element.flightCacheId
            request.flights.append(flightInfo)
        }
        
        request.orderId = PCommonFlightManager.shareInStance.flightConditionDraw().first?.specialOrderId ?? ""
        request.passagerIds = (PCommonFlightManager.shareInStance.flightConditionDraw().first?.travellerUids.components(separatedBy: ",")) ?? [""]
        request.orderNo = PCommonFlightManager.shareInStance.flightConditionDraw().first?.orderNo ?? ""
        request.orderStatus = PCommonFlightManager.shareInStance.flightConditionDraw().first?.orderStatus ?? ""
        request.requireDetail = PCommonFlightManager.shareInStance.flightConditionDraw().first?.requireDetail ?? ""

        weak var weakSelf = self
        PersonalFlightServices.sharedInstance
            .rebookCommonFlight(request:request)
            .subscribe{ event in
                weakSelf?.hideLoadingView()
                switch event {
                    
                case .next(let result):
                    printDebugLog(message: result)
                    if result{
                        weakSelf?.intoNextSubmitOrderFailureView(orderStatus: SubmitOrderFailureViewController.SubmitOrderStatus.Personal_Success_Change)
                    }else{
                        weakSelf?.intoNextSubmitOrderFailureView(orderStatus: SubmitOrderFailureViewController.SubmitOrderStatus.Personal_Failure_Change)
                    }
                case .error(let error):
                    try? weakSelf?.validateHttp(error)
                case .completed:
                    break
                }
               
            }.disposed(by: self.bag)
        
    }
    
    //支付状态页面
    func intoNextSubmitOrderFailureView(orderStatus:SubmitOrderFailureViewController.SubmitOrderStatus) {
        let submitOrderFailureView = SubmitOrderFailureViewController()
        submitOrderFailureView.submitOrderStatus = orderStatus
        self.navigationController?.pushViewController(submitOrderFailureView, animated: true)
    }
    
    
    
    
    
    func verifyAhtoPolicy(index:NSInteger){
        guard (PCommonFlightManager.shareInStance.selectedFlightTripDraw().last?.cabins.count)! > index else {
            return
        }
        
        let selectedFlightTrip = PCommonFlightManager.shareInStance.selectedFlightTripDraw().last
        selectedFlightTrip?.selectedCabinIndex = index
        PCommonFlightManager.shareInStance.addSelectedFlightTrip(searchCondition: selectedFlightTrip!, tripSection: firstFlightSVSearchCondition.currentTripSection)

        
            selectedFlightTrip?.selectedCabinIndex = index
            selectedFlightTrip?.contraryPolicy = (selectedFlightTrip?.cabins[(selectedFlightTrip?.selectedCabinIndex ?? 0)!].contraryPolicy)!
            guard verifyWetherContraryPolicyCanOrder(policy:selectedFlightTrip?.contraryPolicy ?? false) == true else {
                return
            }
            
            
            PCommonFlightManager.shareInStance.addSelectedFlightTrip(searchCondition: selectedFlightTrip!, tripSection: firstFlightSVSearchCondition.currentTripSection)
            intoNextView()

        
    }
    
    
    
    override func backButtonAction(sender: UIButton) {
        PCommonFlightManager.shareInStance.deleteSelectedFlightLastTrip()
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    //MARK:------NET---------
    
    
    
    
    
    /// 验证是否可以预订
    /// 在 返回 true 可以预订 false 不可以
    func verifyWetherContraryPolicyCanOrder(policy:Bool) -> Bool {
        let userInfo = DBManager.shareInstance.userDetailDraw()
        if userInfo?.busLoginInfo.userBaseInfo.canOrder == "0" && policy == true  {
            showSystemAlertView(titleStr: "提示", message: "本次查询结果无符合政策的航班")
            return false
        }
        return true
    }
    
    
    
    
    
}
extension PersonalCommonFlightSelectCabinController {
    
    func setNavigationController (){
        if PCommonFlightManager.shareInStance.flightConditionDraw().first?.type == 2 ||
            (PCommonFlightManager.shareInStance.flightConditionDraw().first?.type == 1 &&
                PCommonFlightManager.shareInStance.flightConditionDraw().first?.currentTripSection == 1){
            setTitle(titleStr: "去程航班信息")
        }else if PCommonFlightManager.shareInStance.flightConditionDraw().first?.type == 1 &&
            PCommonFlightManager.shareInStance.flightConditionDraw().first?.currentTripSection == 2 {
            setTitle(titleStr: "返程航班信息")
        }else {
            setTitle(titleStr: "航班信息")
        }
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        //setNavigationBgColor(color:TBIThemeBlueColor)
        setNavigationBackButton(backImage: "back")
    }
    
}

