//
//  BusinessFlightSelectCabinViewController.swift
//  shop
//
//  Created by TBI on 2017/5/23.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class BusinessFlightSelectCabinViewController: CompanyBaseViewController, UITableViewDataSource, UITableViewDelegate {

    fileprivate let flightTableViewHeaderIdentify = "flightTableViewHeaderCellIdentify"
    fileprivate let flightSelectCabinTableViewCellIdentify = "flightSelectCabinTableViewCellIdentify"
    
    fileprivate let flightSelectCabinsContentSVTableViewCell = "FlightSelectCabinsContentSVTableViewCell"
    
    fileprivate let flightTripTransferHeaderViewIdentify:String = "FlightTripTransferHeaderViewIdentify"
    
    fileprivate let tableView = UITableView()
    
    var travelNo:String? = nil
    
    /// 违反差标是否可以购买
    var anOrder:Bool = true
    
    var flightDate: String = ""
    
    fileprivate var firstFlightSVSearchCondition:FlightSVSearchConditionModel = FlightSVSearchConditionModel()
    
    public var flightCabinInfo: FlightSVSearchResultVOModel.AirfareVO = FlightSVSearchResultVOModel.AirfareVO()
    
    fileprivate var recommendFlightCabinInfoArr:[RecommendFlightResultVOModel] = Array()
    
    
    /// 选中的餐位是否 违背 政策 true 违背。false 符合 
    fileprivate var selectedFlightCabincontraryPolicy:Bool = false
    
    //public var tableViewDataSources:[FlightSVSearchConditionModel] = Array()
    
    fileprivate var type:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setNavigationController()
        setBlackTitleAndNavigationColor(title: "")
        setNavigationBackButton(backImage: "left")
        self.view.backgroundColor = TBIThemeBaseColor
        /// 设置标题
        var startCity:String = ""
        var arriveCity:String = ""
        firstFlightSVSearchCondition = FlightManager.shareInStance.flightConditionDraw().first! //tableViewDataSources.first!
        startCity = FlightManager.shareInStance.flightConditionDraw()[firstFlightSVSearchCondition.currentTripSection - 1].takeOffCity
        arriveCity = FlightManager.shareInStance.flightConditionDraw()[firstFlightSVSearchCondition.currentTripSection - 1].arriveCity        
        setTitleView(start: startCity, arrive: arriveCity)
        setTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        var startCity:String =  ""
        var arriveCity:String = ""
        startCity = FlightManager.shareInStance.flightConditionDraw()[firstFlightSVSearchCondition.currentTripSection - 1].takeOffCity
        arriveCity = FlightManager.shareInStance.flightConditionDraw()[firstFlightSVSearchCondition.currentTripSection - 1].arriveCity
        if firstFlightSVSearchCondition.currentTripSection == 2 && firstFlightSVSearchCondition.type == 1  {
            startCity = firstFlightSVSearchCondition.arriveCity
            arriveCity = firstFlightSVSearchCondition.takeOffCity
        }
        setTitleView(start:startCity, arrive:arriveCity )
        

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

extension BusinessFlightSelectCabinViewController {
    
    func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FLightSelectCabinsHeaderCellView.classForCoder(), forHeaderFooterViewReuseIdentifier:flightTableViewHeaderIdentify )
        tableView.register(FlightTripTransferView.classForCoder(), forHeaderFooterViewReuseIdentifier: flightTripTransferHeaderViewIdentify)
        tableView.register(FlightSelectCabinsContentSVTableViewCell.classForCoder(), forCellReuseIdentifier: flightSelectCabinsContentSVTableViewCell)
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

        return (FlightManager.shareInStance.selectedFlightTripDraw().last?.cabins.count)!
       
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

         return 71
        //        switch indexPath.row {
//        case 0:
//            return 154//144
//        default:
//
//        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:FlightSelectCabinsContentSVTableViewCell = tableView.dequeueReusableCell(withIdentifier: flightSelectCabinsContentSVTableViewCell) as! FlightSelectCabinsContentSVTableViewCell
        cell.selectionStyle = .none
        weak var weakSelf = self
        cell.fillDataSources(cabin: (FlightManager.shareInStance.selectedFlightTripDraw().last?.cabins[indexPath.row])!,index:indexPath.row)
        cell.flightSelectCabinsContentSVCellSelectedBlock = { (policy,index) in
            weakSelf?.verifyAhtoPolicy(policy: policy, index: index)
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if FlightManager.shareInStance.selectedFlightTripDraw().last?.flightInfos.count ?? 0 > 1 {
            return 215
        }
        if FlightManager.shareInStance.selectedFlightTripDraw().last!.flightInfos.first?.share ?? false{
            ///不是中转的头
            return 170
        }
        return 145
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if (FlightManager.shareInStance.selectedFlightTripDraw().last?.flightInfos.count)! > 1 {
            let headerView:FlightTripTransferView = tableView.dequeueReusableHeaderFooterView(withIdentifier:flightTripTransferHeaderViewIdentify) as! FlightTripTransferView
            headerView.fillDataSources(airfare: FlightManager.shareInStance.selectedFlightTripDraw().last!)
            return headerView
        }else
        {
            let headerView:FLightSelectCabinsHeaderCellView = tableView.dequeueReusableHeaderFooterView(withIdentifier:flightTableViewHeaderIdentify) as! FLightSelectCabinsHeaderCellView
            headerView.fillDataSources(airfare:FlightManager.shareInStance.selectedFlightTripDraw().last!)
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
        
        let flightBusinessOrderViewController = FlightBusinessOrderViewController()
        // 单程 进入下单页面
        if firstFlightSVSearchCondition.type ==  0 {
            self.navigationController?.pushViewController(flightBusinessOrderViewController, animated: true)
        }else if firstFlightSVSearchCondition.type == 1 { //进入返程  的返程 页面
            
            if firstFlightSVSearchCondition.currentTripSection == 1{
                firstFlightSVSearchCondition.currentTripSection = 2

                FlightManager.shareInStance.addSearchFlightCondition(searchCondition: firstFlightSVSearchCondition, tripSection:0)
                let vcp = FlightBusinessSearchListViewController()
                vcp.anOrder = self.anOrder
                vcp.travelNo = self.travelNo
                self.navigationController?.pushViewController(vcp, animated: true)
            }else{ // 进入 预定页面
                
                self.navigationController?.pushViewController(flightBusinessOrderViewController, animated: true)
            }
            
            
        }else if firstFlightSVSearchCondition.type == 2 {
            firstFlightSVSearchCondition.currentTripSection += 1
            if firstFlightSVSearchCondition.currentTripSection > firstFlightSVSearchCondition.maxTripInt {
                self.navigationController?.pushViewController(flightBusinessOrderViewController, animated: true)
            }else
            {
                FlightManager.shareInStance.addSearchFlightCondition(searchCondition: firstFlightSVSearchCondition, tripSection:0)
                let vcp = FlightBusinessSearchListViewController()
                vcp.anOrder = self.anOrder
                vcp.travelNo = self.travelNo
                self.navigationController?.pushViewController(vcp, animated: true)
            }
        }
    }
    
    
    
    func showRecommendedFlightView() {
        let recommendedFlightView:RecommendedFlightView = RecommendedFlightView()
        KeyWindow?.addSubview(recommendedFlightView)
        recommendedFlightView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        weak var weakSelf = self
        recommendedFlightView.recommendedFlightViewSelectedFlightCabinBlock = { selectedIndex in
            weakSelf?.modifyFlightInfo(selectedIndex: selectedIndex)
        }
        
        recommendedFlightView.fillDataSources(recommendDataSources: recommendFlightCabinInfoArr)
        
    }
    
    
    
    
    func verifyAhtoPolicy(policy:Bool,index:NSInteger){
        guard (FlightManager.shareInStance.selectedFlightTripDraw().last?.cabins.count)! > index else {
            return
        }
        
        let selectedFlightTrip = FlightManager.shareInStance.selectedFlightTripDraw().last
        selectedFlightTrip?.selectedCabinIndex = index
        FlightManager.shareInStance.addSelectedFlightTrip(searchCondition: selectedFlightTrip!, tripSection: firstFlightSVSearchCondition.currentTripSection)        
        //let isspecial:String = PassengerManager.shareInStance.passengerSVDraw().first?.isSpecial ?? ""
        let isspecial:Bool = DBManager.shareInstance.verifySpecialFilterPolicy(passenger: PassengerManager.shareInStance.passengerSVDraw().first!)
        if  isspecial == true { //
            getRecommendFlightTrip()
            return
        }else
        {
           
            let selectedFlightTrip = FlightManager.shareInStance.selectedFlightTripDraw().last
            selectedFlightTrip?.selectedCabinIndex = index
            selectedFlightTrip?.contraryPolicy = (selectedFlightTrip?.cabins[(selectedFlightTrip?.selectedCabinIndex ?? 0)!].contraryPolicy)!
            guard verifyWetherContraryPolicyCanOrder(policy:selectedFlightTrip?.contraryPolicy ?? false) == true else {
                return
            }
            
            
            FlightManager.shareInStance.addSelectedFlightTrip(searchCondition: selectedFlightTrip!, tripSection: firstFlightSVSearchCondition.currentTripSection)
            intoNextView()
        }
        
    }
    // 若选中推荐 航班  则将 加入的航班信息 和 仓位信息 作替换
    func modifyFlightInfo(selectedIndex:NSInteger) {
        
        var policy:Bool = false
        if selectedIndex == 0 {
            policy = true
        }
        guard verifyWetherContraryPolicyCanOrder(policy:policy) == true else {
            return
        }
        
        //替换数据 选择推荐的仓位信息
        if selectedIndex == 1 {
//
            // 替换上面的方法
            
            let selectedFlightTrip = FlightManager.shareInStance.selectedFlightTripDraw().last
            selectedFlightTrip?.contraryPolicy = false
            selectedFlightTrip?.hasRecommendFlightTrip = true
            selectedFlightTrip?.recommendFlightTrip = recommendFlightCabinInfoArr.first?.result.airfares.last
            FlightManager.shareInStance.addSelectedFlightTrip(searchCondition: selectedFlightTrip!, tripSection: firstFlightSVSearchCondition.currentTripSection)
  
        }else {
            /// 替换上面的方法
            let selectedFlightTrip = FlightManager.shareInStance.selectedFlightTripDraw().last
            selectedFlightTrip?.contraryPolicy = true
            selectedFlightTrip?.cabins[selectedFlightTrip?.selectedCabinIndex ?? 0].contraryPolicy = true
            selectedFlightTrip?.hasRecommendFlightTrip = false
            FlightManager.shareInStance.addSelectedFlightTrip(searchCondition: selectedFlightTrip!, tripSection: firstFlightSVSearchCondition.currentTripSection)
        }
        
        intoNextView()
        
    }
    
    
    
    
    override func backButtonAction(sender: UIButton) {
        FlightManager.shareInStance.deleteSelectedFlightLastTrip()
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    //MARK:------NET---------
    
    /// 获取推荐航班
    func getRecommendFlightTrip() {
        
        let request:RecommendRightFlightVOModel = RecommendRightFlightVOModel()
        let selectedCabinsIndex:NSInteger = FlightManager.shareInStance.selectedFlightTripDraw().last?.selectedCabinIndex ?? 0
        let requestFlightCabins = FlightManager.shareInStance.selectedFlightTripDraw().last?.cabins[selectedCabinsIndex]
        let commitFlight:CommitParamVOModel.CommitFlightVO = CommitParamVOModel.CommitFlightVO()
        commitFlight.cabinCacheId = requestFlightCabins?.cacheId ?? ""
        commitFlight.flightCacheId = requestFlightCabins?.flightCacheId ?? ""
        request.flights = [commitFlight]
        request.travelPolicyId = PassengerManager.shareInStance.passengerSVDraw().first?.policyId ?? ""
        printDebugLog(message: request.mj_keyValues())
        showLoadingView()
        weak var weakSelf = self
        _ = FlightService.sharedInstance
            .getrightFlightList(request:request)
            .subscribe{ event in
                weakSelf?.hideLoadingView()
                
                switch event {
                case .next(let result):
                    printDebugLog(message: result.first?.mj_keyValues())
                    weakSelf?.selectedFlightCabincontraryPolicy = result.first?.contraryPolicy ?? false
                    if result.first?.contraryPolicy == false || result.first?.result.airfares.count == 0 {
                        weakSelf?.modifyFlightCabinsContraryPolicy(policy: (result.first?.contraryPolicy)!)
                        
                    }
                    if (result.first?.result.airfares.count ?? 0) > 0 {
                        weakSelf?.recommendFlightCabinInfoArr.removeAll()
                        weakSelf?.recommendFlightCabinInfoArr.append(result.first!)
                        weakSelf?.showRecommendedFlightView()
                    }
                case .error(let error):
                    try? self.validateHttp(error)
                case .completed:
                    break
                    
                }
                
            }
        }
    
    
    /// 修改仓位 是否符合 差旅政策
    func modifyFlightCabinsContraryPolicy(policy:Bool) {
        guard verifyWetherContraryPolicyCanOrder(policy:policy) == true else {
            return
        }
        let selectedFlightTrip = FlightManager.shareInStance.selectedFlightTripDraw().last
        selectedFlightTrip?.contraryPolicy = policy
        selectedFlightTrip?.cabins[selectedFlightTrip?.selectedCabinIndex ?? 0].contraryPolicy = policy
        selectedFlightTrip?.hasRecommendFlightTrip = false
        FlightManager.shareInStance.addSelectedFlightTrip(searchCondition:selectedFlightTrip!, tripSection:firstFlightSVSearchCondition.currentTripSection)
        intoNextView()
    }
    
    
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
extension BusinessFlightSelectCabinViewController {
    
    func setNavigationController (){
        if FlightManager.shareInStance.flightConditionDraw().first?.type == 2 ||
            (FlightManager.shareInStance.flightConditionDraw().first?.type == 1 &&
                FlightManager.shareInStance.flightConditionDraw().first?.currentTripSection == 1){
            setTitle(titleStr: "去程航班信息")
        }else if FlightManager.shareInStance.flightConditionDraw().first?.type == 1 &&
            FlightManager.shareInStance.flightConditionDraw().first?.currentTripSection == 2 {
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
