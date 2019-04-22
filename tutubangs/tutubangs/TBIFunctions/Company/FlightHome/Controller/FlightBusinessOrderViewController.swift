

//
//  FlightBusinessOrderViewController.swift
//  shop
//
//  Created by TBI on 2017/5/23.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import SwiftDate
import RxCocoa
import RxSwift

class FlightBusinessOrderViewController: CompanyBaseViewController {
    
    let disposeBag = DisposeBag()
    
    //行程cell
    fileprivate let flightSelectCabinsHeaderCellIdentify = "flightSelectCabinsHeaderCellIdentify"
    
    //选中舱位cell
    fileprivate let flightSelectCabinTableCellIdentify = "flightSelectCabinTableCellIdentify"
    
    //退改签cell
    fileprivate let flightClickTableCellIdentify =  "flightClickTableCellIdentify"
    
    fileprivate let flightDefaultTableCellIdentify = "flightDefaultTableCellIdentify"
    
    //违背cell
    fileprivate let flightContraryOrderTableCellIdentify = "flightContraryOrderTableCellIdentify"
    
    //订单备注
    fileprivate let addRemarkCellIdentify = "AddRemarkCell"
    
    //保险点击cell
    fileprivate  let flightSectionHeaderTableCellIdentify = "flightSectionHeaderTableCellIdentify"
    
    //联系人信息
    fileprivate  let flightCompanyContactTableCellIdentify = "flightCompanyContactTableCellIdentify"
    
    //person
    fileprivate  let flightCompanyPersonTableCellIdentify = "flightCompanyPersonTableCellIdentify"
    
    //保险信息
    fileprivate  let flightCompanyInsuranceTableCellIdentify = "flightCompanyInsuranceTableCellIdentify"
    
    //出差单
    fileprivate  let flightTravelTableCellIdentify = "flightTravelTableCellIdentify"
    
  
    fileprivate let tableView = UITableView()
    //选中机票信息
    fileprivate var  selectFlightList:[[String:Any]] = []
    //选中餐位信息
    fileprivate var  selectCabinList:[[String:Any]] = []
    
    fileprivate var  oldCreate:CoOldFlightForm.Create?
    
    lazy var flightOrderFooterView:FlightOrderFooterView = FlightOrderFooterView()
    
    fileprivate var flightPriceInfoView:FlightPriceInfoView?
    
    fileprivate let titleButton = UIButton(title: "更多",titleColor: TBIThemePrimaryTextColor,titleSize: 13)
    
    fileprivate let rightImg = UIImageView(imageName: "ic_down")
    
    fileprivate var personList:[CoOldFlightForm.Create.Passenger] = Array()
    
    let bgView = UIView()
    
    //违背
    fileprivate var contrarySection:Int = 0
    
    //违背描述
    fileprivate var contraryDescribe:String?
    
    //保险提示section
    fileprivate var insuranceMessageSection:Int = 0
    
    //保险section
    fileprivate var insuranceSection:Int = 0
    
    /// 默认选中
    fileprivate var insuranceSectionDefaultStatus:Bool = true

    
    fileprivate var insurancePersonCount:Int  = 0
    
    fileprivate var travellerList:[Traveller] = Array()
    
    fileprivate var userDetail:UserDetail?
    
    //出差单节点
    fileprivate var travelSection:Int = 0
    
    //成本中心节点
    fileprivate var costCenterSection:Int = 0
    
    //订单备注
    fileprivate var remarkSection:Int = 0
    
    //成本中心
    fileprivate var costCenterList:[String] = []
    
    //保险人数
    fileprivate var insuranceCount:Int = 0
    
    //保险是否超过7天
    fileprivate var insuranceDays:Bool = false
    
    var travelNo:String? = nil
    
    
    //MARK:-------NEWOBT--------
    
    /// 选中的仓位信息
    fileprivate var selectedCabinsArr:[FlightSVSearchResultVOModel.CabinVO] = Array()
    
    /// 选中 航班信息
    fileprivate var selectedFlightTripArr:[FlightSVSearchResultVOModel.AirfareVO] = Array()
    
    
    
    /// 用户信息
    fileprivate var userSVDetail:LoginResponse = LoginResponse()
    
    /// 第一个 搜索条件
    fileprivate var firstFlightSVSearchCondition:FlightSVSearchConditionModel = FlightSVSearchConditionModel()
    
    /// 旅客信息 NEWOBT
    fileprivate var travellerSVList:[QueryPassagerResponse] = Array()
    
    fileprivate var companyCustomSVConfig:LoginResponse.UserBaseTravelConfig?
    
    fileprivate var travelPurposesDataSources:[String] = Array()
    
    fileprivate var dispolicyReasonDataSources:[String] = Array()
    
    
    ///联系人选择
    fileprivate var contactPeopleDataSources:[String] = Array()
    
    /// 保险检测返回数据
    fileprivate var suranceInfoResultVO:SuranceInfoResultVO = SuranceInfoResultVO()
    
    fileprivate var localLinkmanEmail:Variable = Variable("")
    fileprivate var localLinkmanName:Variable = Variable("")
    fileprivate var localLinkmanMobile:Variable = Variable("")
    
    /// 出差事由
    fileprivate var reason =  Variable("")
    /// 出差地
    fileprivate var destinations = Variable("")
    
    /// 出差目的
    fileprivate var purpose:String = ""
    
    /// 违背原因
    fileprivate var contraryReason = Variable("")
    
    /// YYYY-MM-DD
    fileprivate var travelStartDate:String = ""
    
    fileprivate var travelEndDate:String = ""
    
    fileprivate var orderRemark = Variable("")
    
    fileprivate var reserveRoomViewCategoryBusinseeRemarkPlaceHolderTip:String = "请添加订单备注"
    
    ///手动输入违背原因
    fileprivate var disReason:String = ""
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setBlackTitleAndNavigationColor(title: "预订信息")
        fillLocalData()
        
        //setNavigationController()
        initTableView()
        initFooterView()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    /// 填写本地数据
    func fillLocalData() {
        
        firstFlightSVSearchCondition = FlightManager.shareInStance.flightConditionDraw().first!
        //用户详情
        userSVDetail = DBManager.shareInstance.userDetailDraw()!
        localLinkmanName = Variable(userSVDetail.busLoginInfo.userBaseInfo.name )
        localLinkmanEmail =  Variable(userSVDetail.busLoginInfo.userBaseInfo.emails.first ?? "")
        localLinkmanMobile = Variable(userSVDetail.busLoginInfo.userBaseInfo.mobiles.first ?? "")
        
        //选择乘客信息
        // travellerList = PassengerManager.shareInStance.passengerDraw()//searchTravellerResult
        travellerSVList = PassengerManager.shareInStance.passengerSVDraw()
        costCenterList.removeAll()
        contactPeopleDataSources.removeAll()
        for element in travellerSVList {
            costCenterList.append(element.costInfoName)
            if element.passagerId != userSVDetail.busLoginInfo.userBaseInfo.uid{
               contactPeopleDataSources.append(element.name)
            }
        }
        contactPeopleDataSources.append(userSVDetail.busLoginInfo.userBaseInfo.name)
        
        /// 单程
        if firstFlightSVSearchCondition.type == 0 {
            //是否符合差标
            if FlightManager.shareInStance.selectedFlightTripDraw().first?.contraryPolicy == true {
                contrarySection = 1
                let selectedCabinsIndex:NSInteger = FlightManager.shareInStance.selectedFlightTripDraw().last?.selectedCabinIndex ?? 0
                
                contraryDescribe =  FlightManager.shareInStance.selectedFlightTripDraw()
                    .last?.cabins[selectedCabinsIndex].contraryPolicyDesc ?? ""
            }else {
                contrarySection = 0
            }
//            if firstFlightSVSearchCondition.flightCabincontraryPolicy == true {
//                contrarySection = 1
//                contraryDescribe =  FlightManager.shareInStance.flightTripCabinFullInfoDraw().first?.contraryPolicyDesc
//            }else {
//                contrarySection = 0
//            }
            
            
            
        }else if firstFlightSVSearchCondition.type == 1 { /// 往返
            // 去程 是否符合差标
            let selectedDepartureFlightTrip = FlightManager.shareInStance.selectedFlightTripDraw().first
            // 返程 是否符合差标
            let selectedReturnFlightTrip = FlightManager.shareInStance.selectedFlightTripDraw().last
            // 违背
            if selectedDepartureFlightTrip?.contraryPolicy == true || selectedReturnFlightTrip?.contraryPolicy == true {
                contrarySection = 1
                contraryDescribe =  selectedDepartureFlightTrip?.cabins[(selectedDepartureFlightTrip?.selectedCabinIndex)!].contraryPolicyDesc ?? ""
            }else {
                contrarySection =  0
            }
            
            
           
            // 违背
            if selectedReturnFlightTrip?.contraryPolicy == true || selectedDepartureFlightTrip?.contraryPolicy == true {
                contrarySection = 1
                contraryDescribe = selectedReturnFlightTrip?.cabins[(selectedReturnFlightTrip?.selectedCabinIndex)!].contraryPolicyDesc ?? ""
            }else {
                contrarySection =  0
            }
            
            
            
//
//
//
//            if FlightManager.shareInStance.flightTripCabinFullInfoDraw().first?.contraryPolicy == true {
//                contrarySection = 1
//                contraryDescribe =  FlightManager.shareInStance.flightTripCabinFullInfoDraw().first?.contraryPolicyDesc
//            }
//
//            if firstFlightSVSearchCondition.flightCabincontraryPolicy == true {
//                contrarySection = 1
//                contraryDescribe =  FlightManager.shareInStance.flightTripCabinFullInfoDraw().first?.contraryPolicyDesc
//            }else {
//                contrarySection = 0
//            }
//
//            // 返程 是否符合差标
//            if FlightManager.shareInStance.flightTripCabinFullInfoDraw()[1].contraryPolicy == true {
//                contrarySection = 1
//                contraryDescribe =  FlightManager.shareInStance.flightTripCabinFullInfoDraw()[1].contraryPolicyDesc
//            }
//
//            if firstFlightSVSearchCondition.backFlightCabincontraryPolicy == true {
//                contrarySection = 1
//                contraryDescribe =  FlightManager.shareInStance.flightTripCabinFullInfoDraw()[1].contraryPolicyDesc
//            }else {
//                contrarySection = 0
//            }
            
            
        }else if firstFlightSVSearchCondition.type == 2 { //多程
            
            for (_,element) in  FlightManager.shareInStance.selectedFlightTripDraw().enumerated() {
                if element.contraryPolicy == true {
                    contrarySection = 1
                    contraryDescribe =  element.cabins[element.selectedCabinIndex ?? 0].contraryPolicyDesc
                    break
                }
            }

        }
        
        //保险 是否可以购买保险
        if DBManager.shareInstance.userDetailDraw()?.busLoginInfo.userBaseInfo.needInsurance == "1" {
            insuranceSection = 1
            if DBManager.shareInstance.userDetailDraw()?.busLoginInfo.userBaseInfo.defultInsurance == "1" {
                insuranceSectionDefaultStatus = true
            }else {
                insuranceSectionDefaultStatus = false
            }
            
        }else{
            insuranceSection = 0
        }
        
        if insuranceSection == 1  {
            checkInsurance()
        }
        
        
//        // 是否显示出差单信息
//        travelSection  = 1
        
        companyCustomSVConfig = DBManager.shareInstance.userDetailDraw()?.busLoginInfo.userBaseInfo.travelConfig
        filterTravelPurposesDataSources()
        filterDispolicyReasonDataSources()
        // 是否显示出差单信息
        if companyCustomSVConfig?.hasTravel == "1" {
            travelSection = 1
        }else {
            travelSection = 0
        }
        
        //成本中心
        costCenterSection = 1
        //订单备注
        remarkSection = 1
        
        
        // 遍历出人的信息计算是否购买保险
        for index in  0..<travellerSVList.count{
            let mo = travellerSVList[index]
            var person = CoOldFlightForm.Create.Passenger(uid: mo.passagerId, mobile: mo.mobiles.first ?? "", birthday: mo.birthday, gender: .female, depInsurance: false, rtnInsurance: false, depTravelCards: [CoOldFlightForm.Create.Passenger.Card()], certNo: "", certType: .identityCard)
            let certificate = mo.certInfos.first{ $0.certType == "1"} ?? mo.certInfos.first

            person.gender = mo.sex
            person.birthday = mo.birthday
            person.certNo = certificate?.certNo ?? ""
            person.certType =  NSInteger(certificate?.certType ?? "1")!
//            if insuranceAll == true {
//                person.depInsurance = true
//                if searchModel.type == 2{//往返
//                    if insuranceDays{//如果是往返且超过7天
//                        person.rtnInsurance = true
//                    }}
//
//            }

            personList.append(person)
        }
    }
    //MARK:--------------------NET---------------
    
    /// 验证是否购买保险
    func checkInsurance(){
        showLoadingView()
        let suranceInfoParamVO:SuranceInfoParamVO = SuranceInfoParamVO()
        var flightCabinsArr:[CommitParamVOModel.CommitFlightVO] = Array()
        for element in FlightManager.shareInStance.selectedFlightTripDraw() {
            let selectedCabinsIndex:NSInteger = element.selectedCabinIndex ?? 0
            var selectedCabins = element.cabins[selectedCabinsIndex]
            if element.hasRecommendFlightTrip == true {
                selectedCabins = (element.recommendFlightTrip?.cabins.first)!
            }
            let tmpCommitCabins:CommitParamVOModel.CommitFlightVO = CommitParamVOModel.CommitFlightVO()
            tmpCommitCabins.accordPolicy = element.contraryPolicy == true ? "0" : "1"
            tmpCommitCabins.cabinCacheId = selectedCabins.cacheId
            tmpCommitCabins.flightCacheId = selectedCabins.flightCacheId
            flightCabinsArr.append(tmpCommitCabins)
        }
        suranceInfoParamVO.flights = flightCabinsArr//FlightManager.shareInStance.flightTripCabinDraw()
        suranceInfoParamVO.passangers =  PassengerManager.shareInStance.passengerLocalconvertToTravellerNET()
        weak var weakSelf = self
        _ = FlightService.sharedInstance
            .checkInsurance(request:suranceInfoParamVO)
            .subscribe{ event in
                weakSelf?.hideLoadingView()
                if case .next(let e) = event {
                    printDebugLog(message: e.mj_keyValues())
                    weakSelf?.suranceInfoResultVO = e
                    let indexPath = IndexPath.init(row: 0, section:3 + (weakSelf?.contrarySection)! + (weakSelf?.insuranceMessageSection)! )
                    //section.index(of:3 + (weakSelf?.contrarySection)! + (weakSelf?.insuranceMessageSection)!)
                    //.init(index:3 + (weakSelf?.contrarySection)! + (weakSelf?.insuranceMessageSection)!)
                    weakSelf?.tableView.reloadSections([indexPath.section], with: UITableViewRowAnimation.automatic)
                    if weakSelf?.insuranceSectionDefaultStatus == true {
                        //weakSelf?.stateChanged(switchState: UISwitch().isOn)
                        weakSelf?.flightOrderFooterView.priceCountLabel.text = weakSelf?.caculateFlightAmountPrice()
                    }
                    
                }
        }
    }
    
    
    
    
    
    
}
extension  FlightBusinessOrderViewController {
    
    func setNavigationController (){
        
    }
    
    override func backButtonAction(sender: UIButton) {

        let firstSearchCondition = FlightManager.shareInStance.flightConditionDraw().first
        if firstSearchCondition?.type == 2 {
            firstSearchCondition?.currentTripSection -= 1
        }
        FlightManager.shareInStance.addSearchFlightCondition(searchCondition: firstSearchCondition!, tripSection: 0)
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension FlightBusinessOrderViewController: UITableViewDelegate,UITableViewDataSource{
    
    func initTableView() {
        titleButton.setTitle("更多", for: .normal)
        titleButton.setTitle("收起", for: .selected)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MineHomeTableViewFooterView.classForCoder(), forHeaderFooterViewReuseIdentifier: mineHomeTableViewHeaderViewIdentify)
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: flightDefaultTableCellIdentify)
        tableView.register(FlightSelectHeaderTableCell.classForCoder(), forCellReuseIdentifier: flightSelectCabinsHeaderCellIdentify)
        tableView.register(FlightSelectCabinTableCell.classForCoder(), forCellReuseIdentifier: flightSelectCabinTableCellIdentify)
        tableView.register(FlightClickTableCell.classForCoder(), forCellReuseIdentifier: flightClickTableCellIdentify)
        tableView.register(FlightContraryOrderTableCell.classForCoder(), forCellReuseIdentifier: flightContraryOrderTableCellIdentify)
         tableView.register(AddRemarkCell.classForCoder(), forCellReuseIdentifier: addRemarkCellIdentify)
        tableView.register(FlightSectionHeaderTableCell.classForCoder(), forCellReuseIdentifier: flightSectionHeaderTableCellIdentify)
        tableView.register(FlightCompanyContactTableCell.classForCoder(), forCellReuseIdentifier: flightCompanyContactTableCellIdentify)
        tableView.register(FlightCompanyPersonTableCell.classForCoder(), forCellReuseIdentifier: flightCompanyPersonTableCellIdentify)
        tableView.register(FlightCompanyInsuranceTableCell.classForCoder(), forCellReuseIdentifier: flightCompanyInsuranceTableCellIdentify)
        tableView.register(FlightTravelTableCell.classForCoder(), forCellReuseIdentifier: flightTravelTableCellIdentify)
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = TBIThemeBaseColor
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(54)
        }
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4 + contrarySection + insuranceSection + travelSection + costCenterSection + remarkSection
            //+ customFieldsSection
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if insuranceMessageSection == 1 && section == 3 + contrarySection{
            return 5
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView:MineHomeTableViewFooterView = tableView.dequeueReusableHeaderFooterView(withIdentifier: mineHomeTableViewHeaderViewIdentify) as! MineHomeTableViewFooterView
        return footerView
    }
    
    //MARK:- UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if contrarySection == 1 && section == 2{//违背信息节点
            return 1
        }
        if insuranceMessageSection == 1 && section == 3 + contrarySection{//往返保险信息提示节点
            return 1
        }
        if insuranceSection == 1 && section == 3 + contrarySection + insuranceMessageSection{//保险节点信息
            return 1 // 2 + insurancePersonCount
        }
        if section == 0 { // 机票信息
            return  FlightManager.shareInStance.selectedFlightTripDraw().count
            //return caculateFlightTripRowNum()
        }else if section == 1 { // 票价信息
            return  FlightManager.shareInStance.selectedFlightTripDraw().count + 1
            //return caculateCabinsRowNum()
            //return FlightManager.shareInStance.flightTripCabinFullInfoDraw().count + 1
        }else if section == 2 + contrarySection{
            return travellerSVList.count + 1
        }else if section == 3 + contrarySection + insuranceMessageSection + insuranceSection{
            return 1
        }else if section == 3 + contrarySection + insuranceMessageSection + insuranceSection + travelSection + costCenterSection{
            //            return costCenterList.count
            return 1
        }
        else if section == 3 + contrarySection + insuranceMessageSection + insuranceSection + travelSection + costCenterSection + remarkSection{
            //            return 订单备注
            return 1
        }
        return 1
    
    }
    
    /// 计算行程 个数
    func caculateFlightTripRowNum() -> NSInteger {
        
        if firstFlightSVSearchCondition.type == 0 {
            return 1
        }
        if firstFlightSVSearchCondition.type == 1 {
            return 2
        }
        
        return firstFlightSVSearchCondition.maxTripInt
    }
    
    /// 计算 仓位个数
    func caculateCabinsRowNum() ->NSInteger {
        if firstFlightSVSearchCondition.type == 0 {
            return 2
        }
        if firstFlightSVSearchCondition.type == 1 {
            return 3
        }
        
        return firstFlightSVSearchCondition.maxTripInt + 1
    }
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if contrarySection == 1 && indexPath.section == 2{//违反政策节点
            let cell = tableView.dequeueReusableCell(withIdentifier: flightContraryOrderTableCellIdentify) as! FlightContraryOrderTableCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            //cell.oldFillCell(model: oldCreate,describe:contraryDescribe ?? "")
            weak var weakSelf = self
            cell.fillDataSources(reason: contraryReason.value,describe:contraryDescribe ?? "")
            cell.flightContraryOrderTableDispolicyBlock = { _ in
                weakSelf?.showDispolicyReasonView()
            }
            //cell.messageField.rx.text.orEmpty.bind(to: contraryReason).addDisposableTo(disposeBag)
            return cell
        }
        //往返保险提示
        if insuranceMessageSection == 1 && indexPath.section == 3 + contrarySection{
            let infoFill = UIImageView(imageName: "ic_hotel_remark")
            let titleLabel = UILabel(text: "往返航班相隔时间小于或等于七天,购买一份保险往返程即可受保!", color: TBIThemePlaceholderTextColor, size: 11)
            let cell = UITableViewCell()
            cell.addSubview(titleLabel)
            cell.addSubview(infoFill)
            infoFill.snp.makeConstraints({ (make) in
                make.left.equalTo(23)
                make.height.width.equalTo(14)
                make.centerY.equalToSuperview()
            })
            titleLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(infoFill.snp.right).offset(5)
                make.centerY.equalToSuperview()
            })
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
        if insuranceSection == 1 && indexPath.section == 3 + contrarySection + insuranceMessageSection{//保险节点信息
            if indexPath.row == 0 && self.suranceInfoResultVO.suranceCacheId.isEmpty == false {
                let cell = tableView.dequeueReusableCell(withIdentifier: flightSectionHeaderTableCellIdentify) as! FlightSectionHeaderTableCell
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                cell.fillDataSources(title: self.suranceInfoResultVO.suranceName, price: self.suranceInfoResultVO.surancePrice, copies:self.suranceInfoResultVO.suranceCount , insuranceAll: insuranceSectionDefaultStatus)
                cell.rightSwitch.addTarget(self, action: #selector(stateChanged(switchState:)), for: .valueChanged)
                return cell
            }
        }
        
        // 机票信息展示
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: flightSelectCabinsHeaderCellIdentify) as! FlightSelectHeaderTableCell
            //cell.fillDataSources(flightTrip: FlightManager.shareInStance.selectedFlightTripDraw()[indexPath.row], row: indexPath.row)
            cell.fillDataSources(flightTrip: caculateShowFlightTripModel(index: indexPath.row), row: indexPath.row, tripType: firstFlightSVSearchCondition.type)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }else if indexPath.section == 1 { //"退改签规则"
            let cabinNum = FlightManager.shareInStance.selectedFlightTripDraw().count
            if indexPath.row + 1 == cabinNum + 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: flightClickTableCellIdentify) as! FlightClickTableCell
                cell.fillCell(title: "退改签规则")
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                return cell
            }
            // 票价信息
            let cell = tableView.dequeueReusableCell(withIdentifier: flightSelectCabinTableCellIdentify) as! FlightSelectCabinTableCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            //cell.fillDataSources(cabin: FlightManager.shareInStance.flightTripCabinFullInfoDraw()[indexPath.row])
            cell.fillDataSources(cabin: caculateShowFlightCabinsModel(index: indexPath.row), tripType:firstFlightSVSearchCondition.type,row:indexPath.row)
            return cell
        }else if indexPath.section == 2 + contrarySection{ // 乘机人
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: flightSectionHeaderTableCellIdentify) as! FlightSectionHeaderTableCell
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                cell.fillCell(title: "乘机人(共\(travellerSVList.count)人)",copies: 2,insuranceAll:false)
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: flightCompanyPersonTableCellIdentify) as! FlightCompanyPersonTableCell
//                cell.fillCell(model: travellerSVList[indexPath.row - 1],certNo:personList[indexPath.row - 1].certNo,index:indexPath.row)
                cell.fillDataSourcs(passenger:travellerSVList[indexPath.row - 1] , cellIndex: indexPath.row)
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                return cell
            }
        }else if indexPath.section == 3 + contrarySection + insuranceMessageSection + insuranceSection{ // 联系人
            let cell:FlightCompanyContactTableCell = tableView.dequeueReusableCell(withIdentifier: flightCompanyContactTableCellIdentify) as! FlightCompanyContactTableCell
            cell.fillDataSources(name:localLinkmanName.value,phone:localLinkmanMobile.value,email:localLinkmanEmail.value)
            weak var weakSelf = self
            cell.flightCompanyContactBlock = { _ in
                weakSelf?.contactPeopleClick()
            }
//            cell.nameField.rx.text.orEmpty.bind(to: localLinkmanName).addDisposableTo(disposeBag)
            //cell.nameField.addOnClickListener(target: self, action: #selector(contactPeopleClick(tap: )))
//            cell.phoneField.addOnClickListener(target: self, action: #selector(contactPeopleClick(tap: )))
//            cell.emailField.addOnClickListener(target: self, action: #selector(contactPeopleClick(tap: )))
            cell.phoneField.rx.text.orEmpty.bind(to: localLinkmanMobile).addDisposableTo(disposeBag)
            cell.emailField.rx.text.orEmpty.bind(to: localLinkmanEmail).addDisposableTo(disposeBag)
            localLinkmanMobile.value = cell.phoneField.text!
            localLinkmanEmail.value = cell.emailField.text!
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }else if indexPath.section == 3 + contrarySection + insuranceMessageSection + insuranceSection + travelSection{//出差单
            let cell = tableView.dequeueReusableCell(withIdentifier: flightTravelTableCellIdentify) as! FlightTravelTableCell
            cell.fillDataSources(model:companyCustomSVConfig! , companyCode: "")
            cell.oneCell.addOnClickListener(target: self, action: #selector(travelDateNewClick(tap: )))
            cell.twoCell.addOnClickListener(target: self, action: #selector(travelDateNewClick(tap: )))
            cell.fourCell.addOnClickListener(target: self, action: #selector(travelTargetClick(tap: )))
            cell.cityContentLabel.rx.text.orEmpty.bind(to: destinations).addDisposableTo(disposeBag)
            cell.reasonContentLabel.rx.text.orEmpty.bind(to: reason).addDisposableTo(disposeBag)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }else if indexPath.section == 3 + contrarySection + insuranceMessageSection + insuranceSection + travelSection + costCenterSection{//成本中心
           
            let cell = NewFlightCostCenterTableCell()
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.titleLabel2.addOnClickListener(target: self, action: #selector(flightCostCenterNewClick))
            return cell
        }
        else if indexPath.section == 3 + contrarySection + insuranceMessageSection + insuranceSection + travelSection + costCenterSection + remarkSection{//订单备注
            
            let cell = tableView.dequeueReusableCell(withIdentifier: addRemarkCellIdentify) as! AddRemarkCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.fillDataSourcesRemark(reason: orderRemark.value)
            cell.messageTextView.rx.text.orEmpty.bind(to: orderRemark).addDisposableTo(disposeBag)
            //cell.messageField.rx.text.orEmpty.bind(to: orderRemark).addDisposableTo(disposeBag)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: flightDefaultTableCellIdentify)!
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
      
    }
    
    
    //MARK:- UITableViewDelegat
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if contrarySection == 1 && indexPath.section == 2{
            return 88
        }
        if insuranceMessageSection == 1 && indexPath.section == 3 + contrarySection{
            return 27
        }
        if insuranceSection == 1 && indexPath.section == 3 + contrarySection + insuranceMessageSection{//保险节点信息
            if indexPath.row == 0 || indexPath.row == 2+insurancePersonCount-1{
                return 44
            }
            return 120
        }
        if indexPath.section == 0 {
//            if indexPath.row == 0 {
            if FlightManager.shareInStance.selectedFlightTripDraw()[indexPath.row].flightInfos.first?.share ?? false{
                ///不是中转的头
                return 140
            }
                return 124.5
//            }else  {
//                return 119.5
//            }
        }else if indexPath.section == 1{
            return 44
        }else if indexPath.section == 2 + contrarySection{
            if indexPath.row == 0 {
                return 44
            }else {
                return 66
            }
        }else if indexPath.section == 3 + contrarySection + insuranceMessageSection + insuranceSection{
            return 132
        }else if indexPath.section == 3 + contrarySection + insuranceMessageSection + insuranceSection + travelSection{
            return 220
        }
        if indexPath.section == 3 + contrarySection + insuranceMessageSection + insuranceSection + travelSection + costCenterSection + remarkSection {
            return 70
        }
        
        return 44
    }
    func flightCostCenterNewClick() {
        var alertContentArray:[(key:String,value:String)] = []//设置数据 [(key:String,value:String)]   -key为用户名，value为用户对应的成本中心
        let costCenterStr:String? = self.costCenterList.joined(separator: " - ")
        for traveller in travellerSVList{
            alertContentArray.append((key:traveller.name,value:traveller.costInfoName))
        }
        let tbiALertView2 = TBIAlertView2.init(frame: ScreenWindowFrame)
        tbiALertView2.titleStr = "成本中心"
        tbiALertView2.dataSource = alertContentArray
        tbiALertView2.initView()
        KeyWindow?.addSubview(tbiALertView2)
    }
    
    /// 获取显示机票行程信息
    func caculateShowFlightTripModel(index:NSInteger) ->FlightSVSearchResultVOModel.AirfareVO {
        var showFlightTripModel:FlightSVSearchResultVOModel.AirfareVO = FlightSVSearchResultVOModel.AirfareVO()
        let selectedFlightTrip = FlightManager.shareInStance.selectedFlightTripDraw()[index]
        if selectedFlightTrip.hasRecommendFlightTrip == true {
            showFlightTripModel = selectedFlightTrip.recommendFlightTrip!
        }else {
            showFlightTripModel = selectedFlightTrip
        }

        return showFlightTripModel
    }
    
    
    func caculateShowFlightCabinsModel(index:NSInteger) -> FlightSVSearchResultVOModel.CabinVO {
        var showFlightCabinModel:FlightSVSearchResultVOModel.CabinVO = FlightSVSearchResultVOModel.CabinVO()
        
        let selectedFlightTrip = FlightManager.shareInStance.selectedFlightTripDraw()[index]
        if selectedFlightTrip.hasRecommendFlightTrip == true {
            showFlightCabinModel = (selectedFlightTrip.recommendFlightTrip?.cabins.first)!
        }else {
            showFlightCabinModel = (selectedFlightTrip.cabins[(selectedFlightTrip.selectedCabinIndex)!])
        }
        

        
        return showFlightCabinModel
    }
    
    
    
    
    
    
    // MARK: 点击cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 && indexPath.row == FlightManager.shareInStance.selectedFlightTripDraw().count {//退改点击提示 //selectCabinList.count
            let title:[(title:String,content:String)] = [("退改签规则","")]
            var subSecondTitle:[[(title:String,content:String)]] = Array()
            if FlightManager.shareInStance.flightConditionDraw().first?.type == 1 {
                // 去程
                let selectedDepatureFlightTrip = FlightManager.shareInStance.selectedFlightTripDraw().first
                var depatureCabinsEi = ""
                if selectedDepatureFlightTrip?.hasRecommendFlightTrip == true {
                    depatureCabinsEi = selectedDepatureFlightTrip?.recommendFlightTrip?.cabins.first?.ei ?? ""
                }else {
                    depatureCabinsEi = selectedDepatureFlightTrip?.cabins[selectedDepatureFlightTrip?.selectedCabinIndex ?? 0].ei ?? ""
                }
                //返程
                let selectedReturnFlightTrip = FlightManager.shareInStance.selectedFlightTripDraw().last
                var returnCabinsEi = ""
                if selectedReturnFlightTrip?.hasRecommendFlightTrip == true {
                    returnCabinsEi = selectedReturnFlightTrip?.recommendFlightTrip?.cabins.first?.ei ?? ""
                }else {
                    returnCabinsEi = selectedReturnFlightTrip?.cabins[selectedReturnFlightTrip?.selectedCabinIndex ?? 0].ei ?? ""
                }
                
                let first:[(title:String,content:String)]  = [("去程",CommonTool.replace("去程\n" + depatureCabinsEi, withInstring: "<br/>", withOut: "\n"))]
                let second:[(title:String,content:String)]  = [("\n返程",CommonTool.replace("返程\n" + returnCabinsEi, withInstring: "<br/>", withOut: "\n"))]
                subSecondTitle = [title,first,second]
            }else  if FlightManager.shareInStance.flightConditionDraw().first?.type == 2 {
                subSecondTitle.append(title)
                for (index,element) in FlightManager.shareInStance.selectedFlightTripDraw().enumerated() {
                    var depatureCabinsEi = ""
                    if element.hasRecommendFlightTrip == true {
                        depatureCabinsEi = element.recommendFlightTrip?.cabins.first?.ei ?? ""
                    }else {
                        depatureCabinsEi = element.cabins[element.selectedCabinIndex ?? 0].ei
                    }
                    
                    switch index {
                    case 0:
                        let first:[(title:String,content:String)]  = [("第一程",CommonTool.replace("第一程\n" + depatureCabinsEi, withInstring: "<br/>", withOut: "\n"))]
                        subSecondTitle.append(first)
                    case 1:
                        let second:[(title:String,content:String)]  = [("第二程", CommonTool.replace("\n第二程\n" + depatureCabinsEi, withInstring: "<br/>", withOut: "\n"))]
                        subSecondTitle.append(second)
                    case 2:
                        let third:[(title:String,content:String)]  = [("第三程", CommonTool.replace("\n第三程\n" + depatureCabinsEi, withInstring: "<br/>", withOut: "\n"))]
                        subSecondTitle.append(third)
                    case 3:
                        let forth:[(title:String,content:String)]  = [("第四程",CommonTool.replace("\n第四程\n" + depatureCabinsEi, withInstring: "<br/>", withOut: "\n") )]
                        subSecondTitle.append(forth)
                    default:
                        break
                    }
                    
                }
                
                
            } else if FlightManager.shareInStance.flightConditionDraw().first?.type == 0 {
                let selectedFlightTrip = FlightManager.shareInStance.selectedFlightTripDraw().last
                let selectedCabins = selectedFlightTrip?.cabins[(selectedFlightTrip?.selectedCabinIndex)!]
                subSecondTitle = [title,[("单程",CommonTool.replace(selectedCabins?.ei ?? "", withInstring: "<br/>", withOut: "\n"))]]
            }
//            let tbiALertView = TBIAlertView.init(frame: ScreenWindowFrame)
//            tbiALertView.setDataSources(dataSource: subSecondTitle)
//            KeyWindow?.addSubview(tbiALertView)
            var str : String = ""
            for i in 0...subSecondTitle.count-1
            {
                str = str + subSecondTitle[i][0].content
            }
            popNewAlertView(content:str,titleStr:"退改签说明",btnTitle:"我知道了",imageName:"",nullStr:"")
        }
        
        if indexPath.section == 2 + contrarySection{//跟证件信息
            if indexPath.row != 0 {
               let vc = FlightModifyPersonController()
                vc.travellerSVModel = travellerSVList[indexPath.row - 1]
                vc.passenger = personList[indexPath.row - 1]
                weak var weakSelf = self
                vc.flightModifyPersonBlockResult = { (result,phone) in
                    print( "controller",result,phone)
                    if result.certType == "1" {
                        
                        var selectedCert:LoginResponse.UserBaseCertInfo = LoginResponse.UserBaseCertInfo()
                        
                        for (index,element) in (weakSelf?.travellerSVList[indexPath.row - 1].certInfos.enumerated())! {
                            
                            if element.certNo == result.certNo && element.certType == result.certType {
                                selectedCert = element
                                weakSelf?.travellerSVList[indexPath.row - 1].certInfos.remove(at: index)
                                
                                weakSelf?.travellerSVList[indexPath.row - 1].certInfos.insert(selectedCert
                                    , at: 0)
                            }
                        }
                        
//                        weakSelf?.travellerSVList[indexPath.row - 1].certInfos.first?.certType = result.certType
//                        weakSelf?.travellerSVList[indexPath.row - 1].certInfos.first?.certNo = result.certNo
                    }else if result.certType == "2" {
                        for (index,element) in (weakSelf?.travellerSVList[indexPath.row - 1].certInfos.enumerated())! {
                            if element.certType == "2"
                            {
                                let tmpElement:LoginResponse.UserBaseCertInfo = element
                                weakSelf?.travellerSVList[indexPath.row - 1].certInfos.remove(at: index)
                                weakSelf?.travellerSVList[indexPath.row - 1].certInfos.insert(tmpElement, at: 0)
                                
                            }
                        }
                    }
                    if phone.isEmpty == false {
                        if weakSelf?.travellerSVList[indexPath.row - 1].mobiles.count ?? 0 > 0 {
                            weakSelf?.travellerSVList[indexPath.row - 1].mobiles[0] = phone//model.mobile
                        }else{
                            weakSelf?.travellerSVList[indexPath.row - 1].mobiles.append(phone) //model.mobile
                        }
                    }
                    
                    self.tableView.reloadSections([2 + self.contrarySection], with: UITableViewRowAnimation.automatic)
                }
               self.navigationController?.pushViewController(vc, animated: true)
            }
        }
//        if indexPath.section == 3 + contrarySection + insuranceMessageSection + insuranceSection + travelSection + costCenterSection + remarkSection{//订单备注
//            weak var weakSelf = self
//            let approvalOpinionController = AddRemarkViewController()
//            approvalOpinionController.contentStr=orderRemark
//            approvalOpinionController.reBlock = {(remarkStr) in
//                weakSelf?.orderRemark = remarkStr
//            }
//            self.navigationController?.pushViewController(approvalOpinionController, animated: true)
//        }
        
    }
    
    //航空意外险
    func stateChanged(switchState: UISwitch) {
        insuranceSectionDefaultStatus = switchState.isOn
        flightOrderFooterView.priceCountLabel.text = caculateFlightAmountPrice()

    }
  
    func choiceSexAction(sender:UIButton) {
        weak var weakSelf = self
        let titleArr:[String] = ["男","女"]
        let roleView = TBIFinderView.init(frame: ScreenWindowFrame)
        roleView.fontSize = UIFont.systemFont(ofSize: 16)
        roleView.finderViewSelectedResultBlock = { (cellIndex) in
            weakSelf?.personList[sender.tag - 400].gender = cellIndex == 0 ? "M" : "F"
            let index = IndexPath(row: sender.tag - 400 + 1, section: 3 + (weakSelf?.contrarySection)! + (weakSelf?.insuranceMessageSection)!)
            let cell = weakSelf?.tableView.cellForRow(at: index) as? FlightCompanyInsuranceTableCell
            cell?.sexContentLabel.text = cellIndex == 0 ? "男" : "女"
        }
        KeyWindow?.addSubview(roleView)
        roleView.reloadDataSources(titledataSources: titleArr, flageImage: nil)
    }
    
    
    
    
    
    //展开收起
    func upOnDown(sender: UIButton){
        if  sender.isSelected == false {
            sender.isSelected = true
            titleButton.titleLabel?.text = "收起"
             rightImg.image = UIImage(named: "ic_up_blue")
            insurancePersonCount  = travellerSVList.count
        }else{
            sender.isSelected = false
            insurancePersonCount =  0
            rightImg.image = UIImage(named: "ic_down")
        }
        tableView.reloadSections([3 + contrarySection + insuranceMessageSection], with: UITableViewRowAnimation.automatic)

    }
    
    
    func birthdayAction(sender:UIButton) {
        let birthdayView =  TBIBirthdayDateView.init(frame: ScreenWindowFrame)
        birthdayView.birthdayDateViewResult = { (result) in
            self.personList[sender.tag - 300].birthday = result
            let index = IndexPath(row: sender.tag - 300 + 1, section: 3 + self.contrarySection + self.insuranceMessageSection)
            let cell = self.tableView.cellForRow(at: index) as? FlightCompanyInsuranceTableCell
            cell?.birthdayContentLabel.text = result
            
        }
        birthdayView.reloadData(birthday: self.personList[sender.tag - 300].birthday)
        KeyWindow?.addSubview(birthdayView)
    }
    //联系人
    func contactPeopleClick(){
        //如果是一个人不弹出
        if contactPeopleDataSources.count > 1{
            let index = IndexPath(row: 0, section:  3 + contrarySection + insuranceMessageSection + insuranceSection)
            let cell = self.tableView.cellForRow(at: index) as? FlightCompanyContactTableCell
            weak var weakSelf = self
        
            let roleView = TBIFinderView.init(frame: ScreenWindowFrame)
            roleView.finderViewSelectedResultBlock = { (cellIndex) in
                cell?.nameContentLabel.text = weakSelf?.contactPeopleDataSources[cellIndex]
                 weakSelf?.localLinkmanName = Variable((weakSelf?.contactPeopleDataSources[cellIndex])!)
                if cellIndex < (weakSelf?.travellerSVList.count)!{
                    cell?.phoneField.text = weakSelf?.travellerSVList[cellIndex].mobiles.first ?? ""
                    cell?.emailField.text = weakSelf?.travellerSVList[cellIndex].emails.first ?? ""
                    weakSelf?.localLinkmanEmail.value = cell?.emailField.text ?? ""
                    weakSelf?.localLinkmanMobile.value = cell?.phoneField.text ?? ""
                }else{
                    cell?.phoneField.text = weakSelf?.userSVDetail.busLoginInfo.userBaseInfo.mobiles.first ?? ""
                    cell?.emailField.text = weakSelf?.userSVDetail.busLoginInfo.userBaseInfo.emails.first ?? ""
                    weakSelf?.localLinkmanEmail.value = cell?.emailField.text ?? ""
                    weakSelf?.localLinkmanMobile.value = cell?.phoneField.text ?? ""
                }
            }
            KeyWindow?.addSubview(roleView)
            roleView.reloadDataSources(titledataSources: contactPeopleDataSources, flageImage: nil)
        }
    }
    //出差时间
    func travelDateNewClick(tap:UITapGestureRecognizer){
        
        let index = IndexPath(row: 0, section:  3 + contrarySection + insuranceMessageSection + insuranceSection + travelSection)
        let cell = self.tableView.cellForRow(at: index) as? FlightTravelTableCell
        let startDate = cell?.startDateContentLabel.text != "" ? cell?.startDateContentLabel.text:(DateInRegion()+3.day).string(custom: "yyyy-MM-dd")
        let endDate = cell?.endDateContentLabel.text != "" ? cell?.startDateContentLabel.text:(DateInRegion()+8.day).string(custom: "yyyy-MM-dd")
        
        let startDateFormatStr:String = (FlightManager.shareInStance.flightConditionDraw().first?.departureDateFormat)!
        let endDateFormateStr:String = (FlightManager.shareInStance.flightConditionDraw().first?.returnDateFormat)!
        
        weak var weakSelf = self
        let vc:TBICalendarViewController = TBICalendarViewController()
        vc.calendarAlertType = TBICalendarAlertType.Flight
        vc.calendarTypeAlert = ["请选择起始日期","请选择结束日期"]
        vc.selectedDates = [startDateFormatStr,endDateFormateStr]
        vc.isMultipleTap = true
        vc.showDateTitle = ["起始","结束"]
        vc.titleColor = TBIThemePrimaryTextColor
        vc.bacButtonImageName = "back"
        vc.hotelSelectedDateAcomplishBlock = { (parameters,action) in
            
            guard action == TBICalendarAction.Done else {
                return
            }
            let formatter:DateFormatter = DateFormatter()
            formatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone?
            formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
            
            
            let sdate:Date = formatter.date(from:(parameters?[0])!) ?? Date()
            //DateInRegion(string: (parameters?[0])!, format: .custom("YYYY-MM-dd hh:mm:ss"), fromRegion: regionRome)!
            let edate:Date = formatter.date(from: (parameters?[1])!) ?? Date()
                //DateInRegion(string: (parameters?[1])!, format: .custom("YYYY-MM-dd hh:mm:ss"), fromRegion: regionRome)!
            formatter.timeZone = NSTimeZone.local
            formatter.dateFormat = "YYYY-MM-dd"
            cell?.startDateContentLabel.text = formatter.string(from:sdate)
            weakSelf?.travelStartDate = formatter.string(from:sdate)
            cell?.endDateContentLabel.text = formatter.string(from: edate)
            weakSelf?.travelEndDate = formatter.string(from:edate)
        }
        _ = self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    //出差目的
    func travelTargetClick(tap:UITapGestureRecognizer){
        let index = IndexPath(row: 0, section:  3 + contrarySection + insuranceMessageSection + insuranceSection + travelSection)
        let cell = self.tableView.cellForRow(at: index) as? FlightTravelTableCell
        cell?.cityContentLabel.resignFirstResponder()
        cell?.reasonContentLabel.resignFirstResponder()
        //coNewOrderCustomConfig?.travelTargets ?? [""]
        weak var weakSelf = self
        
        let roleView = TBIFinderView.init(frame: ScreenWindowFrame)
        roleView.finderViewSelectedResultBlock = { (cellIndex) in
            cell?.purposeContentLabel.text = weakSelf?.travelPurposesDataSources[cellIndex]
            weakSelf?.purpose = (weakSelf?.travelPurposesDataSources[cellIndex])!
        }
        KeyWindow?.addSubview(roleView)
        roleView.reloadDataSources(titledataSources: travelPurposesDataSources, flageImage: nil)
    }
    
    
    /// 违背原因  展示
    func showDispolicyReasonView() {
         weak var weakSelf = self
        let roleView = TBIFinderView.init(frame: ScreenWindowFrame)
        roleView.finderViewSelectedResultBlock = { (cellIndex) in
            
            weakSelf?.dispolicyReasonSelected(index: cellIndex)
            
        }
        KeyWindow?.addSubview(roleView)
        roleView.reloadDataSources(titledataSources: dispolicyReasonDataSources, flageImage: nil)
    }
    
    func dispolicyReasonSelected(index:NSInteger) {
        guard dispolicyReasonDataSources.count >= index else {
            return
        }
        
        if  index == dispolicyReasonDataSources.count - 1 {
           // 进入手动输入 页面
            showManualDispolicyReasonView()
        }else{
            disReason = ""
        }
        contraryReason.value = dispolicyReasonDataSources[index]
        let indexpath:IndexPath = IndexPath.init(row: 0, section: 2)
        tableView.reloadRows(at: [indexpath], with: UITableViewRowAnimation.automatic)
//        let cell:FlightContraryOrderTableCell = tableView.cellForRow(at:indexpath) as! FlightContraryOrderTableCell
//        cell.messageContentLabel.text = contraryReason.value
        
    }
    
    /// 展示 手动输入 违背原因 //"请输入违背原因"
    func showManualDispolicyReasonView()  {
        weak var weakSelf = self
        let dispolicyReasonView = AddDispolicyReasonViewController()
        dispolicyReasonView.contentStr = disReason
        dispolicyReasonView.addDispolicyReasonViewResultBlock = { reason in
            
//            if reason.isEmpty == false {
//                weakSelf?.contraryReason.value = reason
//                let indexpath:IndexPath = IndexPath.init(row: 0, section: 2)
//                let cell:FlightContraryOrderTableCell = weakSelf?.tableView.cellForRow(at:indexpath) as! FlightContraryOrderTableCell
//                cell.messageContentLabel.text = weakSelf?.contraryReason.value
//            }else {
//
//            }
            weakSelf?.disReason = reason
            weakSelf?.contraryReason.value = reason
            let indexpath:IndexPath = IndexPath.init(row: 0, section: 2)
            weakSelf?.tableView.reloadRows(at: [indexpath], with: UITableViewRowAnimation.automatic)
            
            
        }
        
        self.navigationController?.pushViewController(dispolicyReasonView, animated: true)
    }
    
    
    
    
    /// 过滤出差目的
    func filterTravelPurposesDataSources() {
        guard companyCustomSVConfig != nil && (companyCustomSVConfig?.travelPurposes.count)! > 0 else {
            return
        }
        
        
        let travelPurpose = companyCustomSVConfig?.travelPurposes.filter({ $0.type == "1" })
        travelPurposesDataSources = (travelPurpose?.flatMap({ (element) -> String in
            return element.chDesc
        })) ?? [""]
    }
    
    
    /// 过滤 违背原因
    func filterDispolicyReasonDataSources() {
        guard userSVDetail.busLoginInfo.userBaseInfo.disPolicy.count > 0 else {
            return
        }
        
        
        let dispolicyReason = userSVDetail.busLoginInfo.userBaseInfo.disPolicy.filter({ $0.type == "1" })
        dispolicyReasonDataSources = (dispolicyReason.flatMap({ (element) -> String in
            return element.chDesc
        }))
        dispolicyReasonDataSources.append("手动输入")
        
    }
    
    
    
    
    
   
    
}
extension  FlightBusinessOrderViewController{
    
    func initFooterView(){
        bgView.backgroundColor = TBIThemeBackgroundViewColor
        KeyWindow?.addSubview(bgView)//放到主视图上
        self.view.addSubview(flightOrderFooterView)
        bgView.isHidden = true
        flightOrderFooterView.priceCountLabel.text = caculateFlightAmountPrice()
        bgView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(54)
        }
        
        flightOrderFooterView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(54)
        }
        bgView.addOnClickListener(target: self, action: #selector(removePriceInfo(tap:)))
        flightOrderFooterView.priceButton.addTarget(self, action: #selector(priceInfo(sender:)), for: .touchUpInside)
        flightOrderFooterView.submitButton.addTarget(self, action: #selector(submitOrder(sender:)), for: .touchUpInside)
    }
    func removePriceInfo(tap:UITapGestureRecognizer) {
        flightOrderFooterView.priceButton.isSelected = false
        bgView.isHidden = true
        flightPriceInfoView?.removeFromSuperview()
    }
    //价格详情
    func priceInfo(sender: UIButton) {
        if sender.isSelected == true {
            sender.isSelected = false
            bgView.isHidden = true
            flightPriceInfoView?.removeFromSuperview()
        }else
        {
            
            flightPriceInfoView = FlightPriceInfoView()
            flightPriceInfoView?.backgroundColor = TBIThemeWhite
            
            let count = travellerSVList.count
            var fuelTaxAmount:NSInteger = 0
//            var takeOffPrice = (FlightManager.shareInStance.flightTripCabinFullInfoDraw().first?.price.intValue ?? 0) * count
//            //(takeOffCompanyModel?.cabinList[takeOffCompanyCabinRow!].price)! * count
//            var takeOffTax = (FlightManager.shareInStance.flightTripCabinFullInfoDraw().first?.tax.intValue ?? 0) * count
//                //(takeOffCompanyModel?.cabinList[takeOffCompanyCabinRow!].tax)! * count
            
            
            if insuranceSectionDefaultStatus {
                insuranceCount = suranceInfoResultVO.suranceCount
            }else
            {
                insuranceCount = 0
            }
            
            
            // 单程 与 多程。
            if FlightManager.shareInStance.flightConditionDraw().first?.type != 1 {
                var prices:NSInteger = 0
                var tax:NSInteger = 0
                for element in FlightManager.shareInStance.selectedFlightTripDraw() {
                    if element.hasRecommendFlightTrip == true {
                        prices += element.recommendFlightTrip?.cabins.first?.price.intValue ?? 0
                        tax += element.recommendFlightTrip?.cabins.first?.tax.intValue ?? 0
                        if (element.cabins.first?.fuelTax.intValue ?? 0) > 0 {
                            fuelTaxAmount += element.cabins.first?.fuelTax.intValue ?? 0
                        }
                        
                    }else {
                        prices += element.cabins[element.selectedCabinIndex ?? 0].price.intValue
                        tax += element.cabins[element.selectedCabinIndex ?? 0].tax.intValue
                        if (element.cabins[element.selectedCabinIndex ?? 0].fuelTax.intValue ) > 0 {
                            fuelTaxAmount += element.cabins[element.selectedCabinIndex ?? 0].fuelTax.intValue
                        }
                    }
                }
                flightPriceInfoView?.initView(personCount: count, takeOffPrice: Int(prices * count), takeOffTax: Int(tax * count),arrivePrice: 0,arriveTax:0, iScourier:false,takeOffFlueTaxAmountPrice: fuelTaxAmount, arriveFlueTaxAmountPrice: 0,insuranceCount:insuranceCount, type: 0)
            }else{ //往返
                var depaturePrices:NSInteger = 0
                var depaturetax:NSInteger = 0
                var depatureFuelTax:NSInteger = 0
                var returnPrices:NSInteger = 0
                var returnTax:NSInteger = 0
                var returnFuelTax:NSInteger = 0
                // 去程
                let selectedDepatureFlightTrip = FlightManager.shareInStance.selectedFlightTripDraw().first
                if selectedDepatureFlightTrip?.hasRecommendFlightTrip == true {
                    depaturePrices = selectedDepatureFlightTrip?.recommendFlightTrip?.cabins.first?.price.intValue ?? 0
                    depaturetax = selectedDepatureFlightTrip?.recommendFlightTrip?.cabins.first?.tax.intValue ?? 0
                    if (selectedDepatureFlightTrip?.recommendFlightTrip?.cabins.first?.fuelTax.intValue ?? 0) > 0 {
                        depatureFuelTax = (selectedDepatureFlightTrip?.recommendFlightTrip?.cabins.first?.fuelTax.intValue)!
                    }
                    
                }else {
                    depaturePrices = selectedDepatureFlightTrip?.cabins[selectedDepatureFlightTrip?.selectedCabinIndex ?? 0].price.intValue ?? 0
                    depaturetax = selectedDepatureFlightTrip?.cabins[selectedDepatureFlightTrip?.selectedCabinIndex ?? 0].tax.intValue ?? 0
                    if (selectedDepatureFlightTrip?.cabins[selectedDepatureFlightTrip?.selectedCabinIndex ?? 0].fuelTax.intValue ?? 0) > 0 {
                        depatureFuelTax = (selectedDepatureFlightTrip?.cabins[(selectedDepatureFlightTrip?.selectedCabinIndex)!].fuelTax.intValue ?? 0)!
                    }
                }
                //返程
                let selectedReturnFlightTrip = FlightManager.shareInStance.selectedFlightTripDraw().last
                if selectedReturnFlightTrip?.hasRecommendFlightTrip == true {
                    depaturePrices = selectedReturnFlightTrip?.recommendFlightTrip?.cabins.first?.price.intValue ?? 0
                    depaturetax = selectedReturnFlightTrip?.recommendFlightTrip?.cabins.first?.tax.intValue ?? 0
                    if (selectedDepatureFlightTrip?.recommendFlightTrip?.cabins.first?.fuelTax.intValue ?? 0) > 0 {
                        returnFuelTax = (selectedDepatureFlightTrip?.recommendFlightTrip?.cabins.first?.fuelTax.intValue)!
                    }
                    
                }else {
                    returnPrices = selectedReturnFlightTrip?.cabins[selectedDepatureFlightTrip?.selectedCabinIndex ?? 0].price.intValue ?? 0
                    returnTax = selectedReturnFlightTrip?.cabins[selectedDepatureFlightTrip?.selectedCabinIndex ?? 0].tax.intValue ?? 0
                    if (selectedReturnFlightTrip?.cabins[selectedDepatureFlightTrip?.selectedCabinIndex ?? 0].fuelTax.intValue ?? 0) > 0 {
                        returnFuelTax = (selectedReturnFlightTrip?.cabins[selectedDepatureFlightTrip?.selectedCabinIndex ?? 0].fuelTax.intValue)!
                    }
                }
                
                flightPriceInfoView?.initView(personCount: count, takeOffPrice: Int(depaturePrices * count),
                                              takeOffTax: Int(depaturetax * count),arrivePrice:  Int(returnPrices * count),
                                              arriveTax:Int(returnTax * count), iScourier:false, takeOffFlueTaxAmountPrice:depatureFuelTax, arriveFlueTaxAmountPrice: returnFuelTax,insuranceCount:insuranceCount,type: 1)
                
            }
            
          
            
            
//            // 新的
//            // 往返
//            if FlightManager.shareInStance.flightConditionDraw().first?.type == 1 {
//                let arrivePrice =  (FlightManager.shareInStance.flightTripCabinFullInfoDraw().last?.price.intValue ?? 0)! * count
//                let arriveTax =  (FlightManager.shareInStance.flightTripCabinFullInfoDraw().last?.tax.intValue)! * count
//                flightPriceInfoView?.initView(personCount: count, takeOffPrice: Int(takeOffPrice), takeOffTax: Int(takeOffTax),arrivePrice: Int(arrivePrice),arriveTax:Int(arriveTax), iScourier:false,insuranceCount:insuranceCount)
//            } else if FlightManager.shareInStance.flightConditionDraw().first?.type == 2 { //多程
//                for element in FlightManager.shareInStance.flightTripCabinFullInfoDraw() {
//                    takeOffPrice += (element.price.intValue * count)
//                    takeOffTax += (element.tax.intValue * count)
//                }
//
//                flightPriceInfoView?.initView(personCount: count, takeOffPrice: Int(takeOffPrice), takeOffTax: Int(takeOffTax),arrivePrice: 0,arriveTax:0, iScourier:false,insuranceCount:insuranceCount)
//
//            }else //单程
//            {
//                  flightPriceInfoView?.initView(personCount: count, takeOffPrice: Int(takeOffPrice), takeOffTax: Int(takeOffTax),arrivePrice: 0,arriveTax:0, iScourier:false,insuranceCount:insuranceCount)
//            }
//
            self.view.addSubview(flightPriceInfoView!)
            var height:Double = 110
            if FlightManager.shareInStance.flightConditionDraw().first?.type == 1 { height += 56}
            if  insuranceSectionDefaultStatus { height += 44}
            if FlightManager.shareInStance.flightConditionDraw().first?.type == 1 {
                height += 70
            }else{
               height += 44
            }
            
            self.view.addSubview(flightPriceInfoView!)
            flightPriceInfoView?.snp.makeConstraints({ (make) in
                make.left.right.equalTo(0)
                make.bottom.equalTo(flightOrderFooterView.snp.top)
                make.height.equalTo(height)
            })
            bgView.snp.updateConstraints({ (make) in
                make.bottom.equalToSuperview().inset(54+height)
            })
            bgView.isHidden = false
            sender.isSelected = true
        }
    }
    
    
    /// 计算总价
    func caculateFlightAmountPrice() ->String {
        var amountPrice = 0
        var fuelTaxAmount:NSInteger = 0
        let sumPerson:NSInteger = travellerSVList.count
        for element in FlightManager.shareInStance.selectedFlightTripDraw() {
            if element.hasRecommendFlightTrip == true {
                amountPrice += element.recommendFlightTrip?.cabins.first?.price.intValue ?? 0
                amountPrice += element.recommendFlightTrip?.cabins.first?.tax.intValue ?? 0
                if (element.recommendFlightTrip?.cabins.first?.fuelTax.intValue ?? 0) > 0 {
                   fuelTaxAmount += element.recommendFlightTrip?.cabins.first?.fuelTax.intValue ?? 0
                }
            }else {
                amountPrice += element.cabins[element.selectedCabinIndex ?? 0].price.intValue
                amountPrice += element.cabins[element.selectedCabinIndex ?? 0].tax.intValue
                if (element.cabins[element.selectedCabinIndex ?? 0].fuelTax.intValue ) > 0 {
                    fuelTaxAmount += element.cabins[element.selectedCabinIndex ?? 0].fuelTax.intValue 
                }
            }
            
        }
//        var insurancePrice :Float = 0
//        if insuranceSection == 1 && suranceInfoResultVO.suranceCount > 0 {
//            insurancePrice = Float(suranceInfoResultVO.suranceCount) * Float(suranceInfoResultVO.surancePrice) ?? 0
//        }
//
        fuelTaxAmount = fuelTaxAmount * sumPerson
        amountPrice = amountPrice * sumPerson  //+ insurancePrice
        amountPrice += fuelTaxAmount
        
//
//        // 单程
//        if firstFlightSVSearchCondition.type == 0 {
//            let selectedFlightTrip = FlightManager.shareInStance.selectedFlightTripDraw().last
//
//            if selectedFlightTrip?.hasRecommendFlightTrip == true {
//                selectedCabins = (selectedFlightTrip?.recommendFlightTrip?.cabins.last)!
//            }else {
//                selectedCabins = (selectedFlightTrip?.cabins[(selectedFlightTrip?.selectedCabinIndex)!])!
//            }
//        }
//
//        var priceNum:NSInteger = 0
        
        
        
        
        
//        //人数
//        let flightType = FlightManager.shareInStance.flightConditionDraw().first?.type
//        // 仓位
//        //let cabinsInfo:[FlightSVSearchResultVOModel.CabinVO] = FlightManager.shareInStance.flightTripCabinFullInfoDraw()
//        if flightType == 0 {
//            amountPrice = caculateFlightSingleWayAmountPrice().intValue * sumPerson
//        }else if flightType == 1 {
//            amountPrice = caculateFlightRoundtripAmountPrice().intValue * sumPerson
//        }else if flightType == 2 {
//
//            amountPrice = caculateFlightMultirideAmountPrice().intValue * sumPerson
//        }
        
        if suranceInfoResultVO.suranceCacheId.isEmpty == false && insuranceSectionDefaultStatus == true {
            amountPrice += suranceInfoResultVO.suranceCount * (NSInteger(suranceInfoResultVO.surancePrice) ?? 1)
        }
        
        return amountPrice.description
    }
    
    
    /// 单程
    func caculateFlightSingleWayAmountPrice()->NSNumber {
       
        var selectedCabins = FlightSVSearchResultVOModel.CabinVO()
        // 单程
        if firstFlightSVSearchCondition.type == 0 {
            let selectedFlightTrip = FlightManager.shareInStance.selectedFlightTripDraw().last
            
            if selectedFlightTrip?.hasRecommendFlightTrip == true {
                selectedCabins = (selectedFlightTrip?.recommendFlightTrip?.cabins.last)!
            }else {
                selectedCabins = (selectedFlightTrip?.cabins[(selectedFlightTrip?.selectedCabinIndex)!])!
            }
        }
        
        var priceNum:NSInteger = 0
        priceNum = selectedCabins.price.intValue  + selectedCabins.tax.intValue
        return NSNumber.init(value: priceNum)
    }
    
    
    //提交订单
    func submitOrder(sender: UIButton) {
        weak var weakSelf = self
        
        if contrarySection == 1  && contraryReason.value.isEmpty == true {
             showSystemAlertView(titleStr: "必填项", message: "填写违背原因")
            return
        }
        
        if companyCustomSVConfig?.travelTimeRequire == "1" &&  (travelStartDate.isEmpty == true || travelEndDate.isEmpty == true ) {
            showSystemAlertView(titleStr: "必填项", message: "请选择出差时间")
            return
        }
        // 出差地点
        if companyCustomSVConfig?.travelDestRequire == "1" && destinations.value.isEmpty == true {
            showSystemAlertView(titleStr: "必填项", message: "出差地点填写错误")
            return
        }
        //出差目的
        if companyCustomSVConfig?.travelPurposeRequire == "1" && purpose.isEmpty == true {
            showSystemAlertView(titleStr: "必填项", message: "出差目的填写错误")
            return
        }
        //出差是由
        if companyCustomSVConfig?.travelReasonRequire == "1"  && reason.value.isEmpty == true {
            showSystemAlertView(titleStr: "必填项", message: "出差事由填写错误")
            return
        }
        
        
        
        let request:CommitParamVOModel = CommitParamVOModel()
        request.hasTravelApply = "1"
        request.travelDest =  destinations.value
        request.travelPurpose = purpose
        request.travelReason = reason.value
        request.travelRetTime = travelEndDate
        request.travelTime = travelStartDate
        
        request.linkmanEmail = localLinkmanEmail.value
        request.linkmanName = localLinkmanName.value
        request.linkmanMobile = localLinkmanMobile.value
        request.orderSource = "2"
        //request.flights = FlightManager.shareInStance.flightTripCabinDraw()
        request.flights = convertCommitFlightCabins()
        
        if orderRemark.value != reserveRoomViewCategoryBusinseeRemarkPlaceHolderTip {
            request.comment = orderRemark.value
        }
        
        
        request.passangers = PassengerManager.shareInStance.passengerLocalconvertToTravellerNET()
        if insuranceSectionDefaultStatus == true {
            request.insuranceCacheId  = self.suranceInfoResultVO.suranceCacheId
            for element in request.passangers {
                element.insuranceCount = suranceInfoResultVO.suranceCount.description
            }
        } 
        
        showLoadingView()
       _ = FlightService.sharedInstance
            .commitOrder(request:request)
            .subscribe{ event in
            weakSelf?.hideLoadingView()
                switch event {
                case .next(let element):
                    printDebugLog(message: element)
                    weakSelf?.verifyUserRightApproval(orderArr: element)
                //weakSelf?.getApproval(orderNoArr: element)
                case .error( _):
                        weakSelf?.intoNextSubmitOrderFailureView(orderStatus: false)
                //try? self.validateHttp(error)
                case .completed:
                    break
                }
        }

    }
    
    func convertCommitFlightCabins() -> [CommitParamVOModel.CommitFlightVO] {
        var resultArr:[FlightSVSearchResultVOModel.CabinVO] = Array()
        
        
        // 单程
        for element in FlightManager.shareInStance.selectedFlightTripDraw() {
           var selectedCabins:FlightSVSearchResultVOModel.CabinVO = FlightSVSearchResultVOModel.CabinVO()
            if element.hasRecommendFlightTrip == true  {
                
                selectedCabins = (element.recommendFlightTrip?.cabins.last)!
            }else {
                selectedCabins = (element.cabins[element.selectedCabinIndex ?? 0])
            }
            
            resultArr.append(selectedCabins)
            
        }
        
        
        return searchResultCabinsInfoConvertCommitCabinsInfo(cabins: resultArr)
        
    }
    
    func searchResultCabinsInfoConvertCommitCabinsInfo(cabins:[FlightSVSearchResultVOModel.CabinVO]) -> [CommitParamVOModel.CommitFlightVO] {
        
        var resultArr:[CommitParamVOModel.CommitFlightVO] = Array()
        
        for element in cabins {
            let tmpCabins = CommitParamVOModel.CommitFlightVO()
            tmpCabins.accordPolicy = element.contraryPolicy == true ? "1":"0"
            tmpCabins.cabinCacheId = element.cacheId
            tmpCabins.flightCacheId = element.flightCacheId
            if tmpCabins.accordPolicy == "1" {
                tmpCabins.disPolicyReason = contraryReason.value
            }
            
            resultArr.append(tmpCabins)
        }
        return resultArr
    }
    
    
    /// 单程
    func caculateFlightSingleWayCabins()->[CommitParamVOModel.CommitFlightVO] {
       
        var selectedCabins:FlightSVSearchResultVOModel.CabinVO = FlightSVSearchResultVOModel.CabinVO()
        // 单程
        if firstFlightSVSearchCondition.type == 0 {
            let selectedFlightTrip = FlightManager.shareInStance.selectedFlightTripDraw().last
            
            
            if selectedFlightTrip?.hasRecommendFlightTrip == true  {
                
                selectedCabins = (selectedFlightTrip?.recommendFlightTrip?.cabins.last)!
            }else {
                selectedCabins = (selectedFlightTrip?.cabins[selectedFlightTrip?.selectedCabinIndex ?? 0])!
            }
        }
        
      
        return searchResultCabinsInfoConvertCommitCabinsInfo(cabins: [selectedCabins])
    }
    
    /// 验证 是否需要送审
    func verifyUserRightApproval(orderArr:[String]) {
        
        if DBManager.shareInstance.userDetailDraw()?.busLoginInfo.userBaseInfo.oaCorp == "1" {
            intoNextSubmitOrderFailureView(orderStatus: true)
        }else{
            getApproval(orderNoArr: orderArr)
            
        }
    }
    
    
    func getApproval(orderNoArr:[String]) {
        weak var weakSelf = self
        let request:QueryApproveVO = QueryApproveVO()
        for element in orderNoArr {
            let orderInfo:QueryApproveVO.ApproveOrderInfo = QueryApproveVO.ApproveOrderInfo()
            orderInfo.orderId = element
            orderInfo.orderType = "1"
            request.approveOrderInfos.append(orderInfo)
        }
        
        showLoadingView()
        _ = HomeService.sharedInstance
            .getApproval(request:request )
            .subscribe { (event) in
                weakSelf?.hideLoadingView()
                switch event {
                case .next(let element):
                    printDebugLog(message: element.mj_keyValues())
                    if element.approveGroupInfos.count > 0 {
                        weakSelf?.intoNextNewExamineView(approvalGroup: element.approveGroupInfos.first!, orderNoArr: orderNoArr)
                    }else {
                        weakSelf?.intoNextSubmitOrderFailureView(orderStatus: true)
                    }
                case .error(let error):
                    try? weakSelf?.validateHttp(error)
                case .completed:
                    break
                }
                
        }
    }
    
    
    func intoNextNewExamineView(approvalGroup:QueryApproveResponseVO.ApproveGroupInfo,orderNoArr:[String]) {
        let examineView = CoNewExamineViewController()
        examineView.approveGroupInfos = approvalGroup
        examineView.orderNoArr = orderNoArr
        examineView.orderType = "1"
        self.navigationController?.pushViewController(examineView, animated: true)
    }
    
    func intoNextSubmitOrderFailureView(orderStatus:Bool) {
        let submitOrderFailureView = SubmitOrderFailureViewController()
        submitOrderFailureView.submitOrderStatus = orderStatus ? .Success_Submit_Order : .Failure_Submit_Order
        self.navigationController?.pushViewController(submitOrderFailureView, animated: true)
    }
  
}
