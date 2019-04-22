//
//  FlightNewBusinessOrderViewController.swift
//  shop
//
//  Created by zhangwangwang on 2017/5/31.
//  Copyright © 2017年 zhangwangwang. All rights reserved.
//

import UIKit
import SwiftDate
import RxCocoa
import RxSwift

class FlightNewBusinessOrderViewController: BaseViewController {

    fileprivate let disposeBag = DisposeBag()
    
    //行程cell
    fileprivate let flightSelectCabinsHeaderCellIdentify = "flightSelectCabinsHeaderCellIdentify"
    
    //选中舱位cell
    fileprivate let flightSelectCabinTableCellIdentify = "flightSelectCabinTableCellIdentify"
    
    //退改签cell
    fileprivate let flightClickTableCellIdentify =  "flightClickTableCellIdentify"
    
    fileprivate let flightDefaultTableCellIdentify = "flightDefaultTableCellIdentify"
    
    //违背cell
    fileprivate let flightContraryOrderTableCellIdentify = "flightContraryOrderTableCellIdentify"
    
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
    
    fileprivate var  selectFlightList:[[String:Any]] = []
    
    fileprivate var  selectCabinList:[[String:Any]] = []
    
    fileprivate var  newCreate:CoNewFlightForm.Create?
    
    lazy var flightOrderFooterView:FlightOrderFooterView = FlightOrderFooterView()
    
    fileprivate var flightPriceInfoView:FlightPriceInfoView?
    
    fileprivate let titleButton = UIButton(title: "更多",titleColor: TBIThemePrimaryTextColor,titleSize: 13)
    
    fileprivate let rightImg = UIImageView(imageName: "ic_down")
    
    fileprivate var personList:[CoNewFlightForm.Create.Passenger] = Array()
    
    let bgView = UIView()
    
    var travelNo:String? = nil
    
    //违背
    fileprivate var contrarySection:Int = 0
    
    //违背描述
    fileprivate var contraryDescribe:String?
    
    //保险提示section
    fileprivate var insuranceMessageSection:Int = 0
    
    //保险section
    fileprivate var insuranceSection:Int = 0
    
    //保险是否默认全选
    fileprivate var insuranceAll:Bool = false
    
    //保险节点是否显示count
    fileprivate var insurancePersonCount:Int  = 0
    
    fileprivate var travellerList:[Traveller] = Array()
    //用户详情
    fileprivate var userDetail:UserDetail?
    
    //新版自定义字段
    fileprivate var coNewOrderCustomConfig:CoNewOrderCustomConfig?
    
    //出差单节点信息
    fileprivate var travelModel:ModifyAndCreateCoNewOrderFrom = ModifyAndCreateCoNewOrderFrom()
    
    //保险是否超过7天
    fileprivate var insuranceDays:Bool = false
    
    //出差单节点
    fileprivate var travelSection:Int = 0
    
    //成本中心节点
    fileprivate var costCenterSection:Int = 0
    
    //成本中心
    fileprivate var costCenterList:[String] = []
    
    //自定义节点
    fileprivate var customFieldsSection:Int = 0
    
    //保险人数
    fileprivate var insuranceCount:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        setNavigationController()
        initTableView()
        initFooterView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
extension  FlightNewBusinessOrderViewController {
    
    func initData(){
        
        //带出出差地点
        travelModel.destinations = [Variable(takeOffCompanyModel?.legList.first?.arriveCity ?? "")]
        
        //选择乘客信息
        travellerList = PassengerManager.shareInStance.passengerDraw()//searchTravellerResult
        costCenterList =  travellerList.first?.costCenterName.components(separatedBy: "-") ?? []
        
        //用户详情
        userDetail = UserService.sharedInstance.userDetail()
        newCreate  = CoNewFlightForm.Create()
        newCreate?.linkmanName = Variable(userDetail?.companyUser?.name ?? "")
        newCreate?.linkmanEmail = Variable(userDetail?.companyUser?.emails.first ?? "")
        newCreate?.linkmanMobile = Variable(userDetail?.companyUser?.mobile ?? "")
        newCreate?.depFlightId =   takeOffCompanyModel?.id ?? ""
        newCreate?.depCabinId  =   takeOffCompanyModel?.cabinList[takeOffCompanyCabinRow ?? 0].id ?? ""
        if searchModel.type ==  2 {
            newCreate?.rtnFlightId =   arriveCompanyModel?.id ?? ""
            newCreate?.rtnCabinId  =   arriveCompanyModel?.cabinList[arriveCompanyCabinRow ?? 0].id ?? ""
        }
        
        let insurancePermission = userDetail?.companyUser?.permissions.first{$0 == UserDetail.CompanyUser.Permission.insurance}
        let insuranceAllPermission = userDetail?.companyUser?.permissions.first{$0 == UserDetail.CompanyUser.Permission.insuranceAll}
        
        
        if searchModel.type == 2 {
            for index in  0..<(takeOffCompanyModel?.legList.count)!{
                selectFlightList.append(["flightModel":(takeOffCompanyModel?.legList[index])!,"type":"去","direct":takeOffCompanyModel?.direct ?? true,"stopOver":takeOffCompanyModel?.stop ?? false])
            }
            for index in  0..<(arriveCompanyModel?.legList.count)!{
                selectFlightList.append(["flightModel":(arriveCompanyModel?.legList[index])!,"type":"返","direct":arriveCompanyModel?.direct ?? true,"stopOver":takeOffCompanyModel?.stop ?? false])
            }
            selectCabinList.append(["cabinModel":takeOffCompanyModel?.cabinList[takeOffCompanyCabinRow!] as Any,"type":"去程"])
            selectCabinList.append(["cabinModel":arriveCompanyModel?.cabinList[arriveCompanyCabinRow!] as Any,"type":"返程"])
            
            //是否符合差标
            if takeOffCompanyModel?.cabinList[takeOffCompanyCabinRow!].contraryPolicy ?? false{
                contrarySection = 1
                contraryDescribe = takeOffCompanyModel?.cabinList[takeOffCompanyCabinRow!].contraryPolicyDesc
            }
            if arriveCompanyModel?.cabinList[arriveCompanyCabinRow!].contraryPolicy ?? false{
                contrarySection = 1
                contraryDescribe = arriveCompanyModel?.cabinList[arriveCompanyCabinRow!].contraryPolicyDesc
            }
            
            ///判断往返程日期是否超过7天
            let departureDate = DateInRegion(string: searchModel.departureDate, format: .custom("yyyy-MM-dd"), fromRegion: regionRome)!
            let returnDate = DateInRegion(string: searchModel.returnDate, format: .custom("yyyy-MM-dd"), fromRegion: regionRome)!
            let days = (returnDate.timeIntervalSinceReferenceDate - departureDate.timeIntervalSinceReferenceDate).in(.day)
            if  days ?? 1 > 7 {insuranceDays = true}
            
            //是否显示保险提示 往返就提示
            if searchModel.type == 2 { insuranceMessageSection = 1}
        }else {
            for index in  0..<(takeOffCompanyModel?.legList.count)!{
                selectFlightList.append(["flightModel":(takeOffCompanyModel?.legList[index])!,"type":"单","direct":takeOffCompanyModel?.direct ?? true,"stopOver":takeOffCompanyModel?.stop ?? false])
            }
            selectCabinList.append(["cabinModel":takeOffCompanyModel?.cabinList[takeOffCompanyCabinRow!] as Any,"type":"单程"])
            
            //是否符合差标
            if takeOffCompanyModel?.cabinList[takeOffCompanyCabinRow!].contraryPolicy ?? false{
                contrarySection = 1
                contraryDescribe = takeOffCompanyModel?.cabinList[takeOffCompanyCabinRow!].contraryPolicyDesc
            }
        }
        
        if insurancePermission == nil {
            insuranceSection = 0
        }else {
            insuranceSection = 1
        }
        if insuranceAllPermission == nil {
            insuranceAll  = false
        }else {
            insuranceAll = true
        }
        // 遍历出人的信息计算是否购买保险
        for index in  0..<travellerList.count{
            let mo = travellerList[index]
            var person = CoNewFlightForm.Create.Passenger(uid: mo.uid, mobile: mo.mobile, birthday: mo.birthday, gender: .female, depInsurance: false, rtnInsurance: false, depTravelCards: [CoNewFlightForm.Create.Passenger.Card()], certNo: "", certType: .identityCard)
            let certificate = mo.certificates.first{ $0.type == 1} ?? mo.certificates.first
            
            person.gender = mo.gender
            person.birthday = mo.birthday
            person.certNo = certificate?.number ?? ""
            person.certType = certificate?.type ?? 1
            if insuranceAll == true {
                person.depInsurance = true
                if searchModel.type == 2{//往返
                    if insuranceDays{//如果是往返且超过7天
                        person.rtnInsurance = true
                    }}
                
            }
            
            personList.append(person)
        }
        
        
        //获取公司出差单配置信息
        CoNewOrderService.sharedInstance.getCustomConfigBy().subscribe{ event in
            if case .next(let e) = event {
                self.coNewOrderCustomConfig = e
                if e.customFields.count > 0 && self.travelNo == nil{
                    self.customFieldsSection = 1
                }
                self.tableView.reloadData()
            }
            if case .error(let e) = event {
                try? self.validateHttp(e)
                
            }
            }.disposed(by: disposeBag)
        if self.travelNo == nil {
            travelSection = 1
            costCenterSection = 1
        }else {
            travelSection = 0
            costCenterSection = 0
            customFieldsSection = 0 
        }
    }
    
    func setNavigationController (){
        setBlackTitleAndNavigationColor(title:"预订信息")
    }
    
    override func backButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension FlightNewBusinessOrderViewController: UITableViewDelegate,UITableViewDataSource{
    
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
        return 4 + contrarySection + insuranceMessageSection + insuranceSection + travelSection + costCenterSection + customFieldsSection
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
            return 2 + insurancePersonCount
        }
        if section == 0 {
            return  selectFlightList.count
        }else if section == 1 {
            return selectCabinList.count + 1
        }else if section == 2 + contrarySection{
            return travellerList.count + 1
        }else if section == 3 + contrarySection + insuranceMessageSection + insuranceSection{
            return 1
        }else if section == 3 + contrarySection + insuranceMessageSection + insuranceSection + travelSection + costCenterSection{
//            return costCenterList.count
            return 1
        }else if section == 3 + contrarySection + insuranceMessageSection + insuranceSection + travelSection + costCenterSection + customFieldsSection{
            return coNewOrderCustomConfig?.customFields.count ?? 0
        }
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if contrarySection == 1 && indexPath.section == 2{//违反节点
            let cell = tableView.dequeueReusableCell(withIdentifier: flightContraryOrderTableCellIdentify) as! FlightContraryOrderTableCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.newFillCell(model: newCreate,describe:contraryDescribe ?? "")
            cell.messageField.rx.text.orEmpty.bind(to: (newCreate?.reason)!).addDisposableTo(disposeBag)
            return cell
        }
        //往返保险提示
        if insuranceMessageSection == 1 && indexPath.section == 3 + contrarySection{
            let infoFill = UIImageView(imageName: "info_fill")
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
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: flightSectionHeaderTableCellIdentify) as! FlightSectionHeaderTableCell
                cell.selectionStyle = UITableViewCellSelectionStyle.none
//                var count = insuranceDays == true ? travellerList.count * 2 : travellerList.count
//                if insuranceAll == false {
//                    count = 0
//                }
                cell.fillCell(title: "航空意外险",copies: insuranceCount, insuranceAll: insuranceAll)
                cell.rightSwitch.addTarget(self, action: #selector(stateChanged(switchState:)), for: .valueChanged)
                return cell
            }
            if indexPath.row == 2+insurancePersonCount-1 {
                
                let cell = UITableViewCell()
                cell.addSubview(titleButton)
                cell.addSubview(rightImg)
                titleButton.snp.makeConstraints({ (make) in
                    make.center.equalToSuperview()
                })
                rightImg.snp.makeConstraints({ (make) in
                    make.centerY.equalToSuperview()
                    make.left.equalTo(titleButton.snp.right).offset(3)
                })
                titleButton.addTarget(self, action: #selector(upOnDown(sender:)), for: .touchUpInside)
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                return cell
            }
            //保险cell
            let cell = tableView.dequeueReusableCell(withIdentifier: flightCompanyInsuranceTableCellIdentify) as! FlightCompanyInsuranceTableCell
            cell.newFillCell(insuranceAll: insuranceAll,insuranceDays:insuranceDays, model: personList[indexPath.row - 1],personModel:travellerList[indexPath.row - 1])
            
            cell.startButtom.tag = indexPath.row - 1 + 100
            cell.returnButtom.tag = indexPath.row - 1 + 200
            cell.birthdayEdit.tag = indexPath.row - 1 + 300
            cell.sexEdit.tag = indexPath.row - 1 + 400
            
//            cell.startButtom.addTarget(self, action:#selector(startClick(sender: )), for: .touchUpInside)
//            cell.returnButtom.addTarget(self, action:#selector(returnClick(sender: )), for: .touchUpInside)
            cell.birthdayEdit.addTarget(self, action:#selector(birthdayAction(sender: )), for: .touchUpInside)
            cell.sexEdit.addTarget(self, action:#selector(sexClick(sender: )), for: .touchUpInside)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: flightSelectCabinsHeaderCellIdentify) as! FlightSelectHeaderTableCell
            cell.companyFillCell(model: selectFlightList[indexPath.row],row:indexPath.row)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }else if indexPath.section == 1 {
            if indexPath.row + 1 == selectCabinList.count + 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: flightClickTableCellIdentify) as! FlightClickTableCell
                cell.fillCell(title: "退改签规则")
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: flightSelectCabinTableCellIdentify) as! FlightSelectCabinTableCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.companyFillCell(model: selectCabinList[indexPath.row])
            return cell
        }else if indexPath.section == 2 + contrarySection{
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: flightSectionHeaderTableCellIdentify) as! FlightSectionHeaderTableCell
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                cell.fillCell(title: "乘机人(共\(travellerList.count)人)",copies: 2,insuranceAll:false)
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: flightCompanyPersonTableCellIdentify) as! FlightCompanyPersonTableCell
                cell.fillCell(model: travellerList[indexPath.row - 1], certNo: personList[indexPath.row - 1].certNo,index:indexPath.row)
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                return cell
            }
        }else if indexPath.section == 3 + contrarySection + insuranceMessageSection + insuranceSection{
            let cell = tableView.dequeueReusableCell(withIdentifier: flightCompanyContactTableCellIdentify) as! FlightCompanyContactTableCell
            cell.newFillCell(model: newCreate)
            //cell.nameField.rx.text.orEmpty.bind(to: (newCreate?.linkmanName)!).addDisposableTo(disposeBag)
            cell.phoneField.rx.text.orEmpty.bind(to: (newCreate?.linkmanMobile)!).addDisposableTo(disposeBag)
            cell.emailField.rx.text.orEmpty.bind(to: (newCreate?.linkmanEmail)!).addDisposableTo(disposeBag)
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }else if indexPath.section == 3 + contrarySection + insuranceMessageSection + insuranceSection + travelSection{//出差单
            let cell = tableView.dequeueReusableCell(withIdentifier: flightTravelTableCellIdentify) as! FlightTravelTableCell
            cell.fillCell(model: coNewOrderCustomConfig, companyCode: "")
            cell.fillCellData(model: travelModel)
            cell.oneCell.addOnClickListener(target: self, action: #selector(travelDateNewClick(tap: )))
            cell.twoCell.addOnClickListener(target: self, action: #selector(travelDateNewClick(tap: )))
            cell.fourCell.addOnClickListener(target: self, action: #selector(travelTargetClick(tap: )))
            cell.cityContentLabel.rx.text.orEmpty.bind(to: travelModel.destinations[0]).addDisposableTo(disposeBag)
            cell.reasonContentLabel.rx.text.orEmpty.bind(to: travelModel.reason).addDisposableTo(disposeBag)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }else if indexPath.section == 3 + contrarySection + insuranceMessageSection + insuranceSection + travelSection + costCenterSection{//成本中心
//            let cell = FlightCostCenterTableCell()
//            cell.fillCell(content: costCenterList[indexPath.row], index: indexPath)
//            cell.selectionStyle = UITableViewCellSelectionStyle.none
//            return cell
            let cell = NewFlightCostCenterTableCell()
            cell.selectionStyle = UITableViewCellSelectionStyle.none
//            cell.titleLabel.addOnClickListener(target: self, action: #selector(flightCostCenterNewClick(tap: )))
            return cell
        }else if indexPath.section == 3 + contrarySection + insuranceMessageSection + insuranceSection + travelSection + costCenterSection + customFieldsSection{
            let cell = FlightCustomTableCell()
            cell.fillCell(model: coNewOrderCustomConfig?.customFields[indexPath.row], index: indexPath)
            cell.contentField.rx.text.orEmpty.bind(to: (coNewOrderCustomConfig?.customFields[indexPath.row].value)!).addDisposableTo(disposeBag)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
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
            if indexPath.row == 0 {
                return 124.5
            }else  {
                return 119.5
            }
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
        return 44
    }
    
    // MARK: 点击cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 && indexPath.row == selectCabinList.count{//退改点击提示
            
            let title:[(title:String,content:String)] = [("退改签规则","")]
            if searchModel.type == 2 {
                let subFirstTitle:[(title:String,content:String)] = [("去程",takeOffCompanyModel?.cabinList[takeOffCompanyCabinRow!].ei ?? "")]
                let subSecondTitle:[(title:String,content:String)] = [("返程",arriveCompanyModel?.cabinList[arriveCompanyCabinRow!].ei ?? "")]
                let tbiALertView = TBIAlertView.init(frame: ScreenWindowFrame)
                tbiALertView.setDataSources(dataSource: [title,subFirstTitle,subSecondTitle])
                KeyWindow?.addSubview(tbiALertView)
            }else {
                let subFirstTitle:[(title:String,content:String)] = [("单程",takeOffCompanyModel?.cabinList[takeOffCompanyCabinRow!].ei ?? "")]
                let tbiALertView = TBIAlertView.init(frame: ScreenWindowFrame)
                tbiALertView.setDataSources(dataSource: [title,subFirstTitle])
                KeyWindow?.addSubview(tbiALertView)
            }
            
        }
        
        if indexPath.section == 2 + contrarySection{//跟证件信息
            if indexPath.row != 0 {
                let vc = FlightModifyPersonController()
                vc.flightModifyPersonBlockResult = { (result) in
                    print( "controller",result)
                    let model = result as! CoNewFlightForm.Create.Passenger
                    self.personList[indexPath.row - 1].certType = model.certType
                    self.personList[indexPath.row - 1].certNo = model.certNo
                    self.personList[indexPath.row - 1].mobile = model.mobile
                    self.personList[indexPath.row - 1].depTravelCards =  model.depTravelCards
                    self.personList[indexPath.row - 1].rtnTravelCards = model.rtnTravelCards
                    self.tableView.reloadSections([2 + self.contrarySection], with: UITableViewRowAnimation.automatic)
                    
                }
                vc.passenger = personList[indexPath.row - 1]
                vc.travellerModel = travellerList[indexPath.row - 1]
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        if indexPath.section == 3 + contrarySection + insuranceMessageSection + insuranceSection + travelSection + costCenterSection{
            flightCostCenterNewClick()
        }
        if indexPath.section == 3 + contrarySection + insuranceMessageSection + insuranceSection + travelSection + costCenterSection + customFieldsSection && 1 == customFieldsSection{
                    let type = [1,2,3] // 1,2,3是选择类型
                    if type.contains(coNewOrderCustomConfig?.customFields[indexPath.row].type.rawValue ?? 0)
                    {

                        let optionsView = TBICommonOptionsView(frame: ScreenWindowFrame,count: coNewOrderCustomConfig?.customFields[indexPath.row].defaultValue.count ?? 0)
                        if coNewOrderCustomConfig?.customFields[indexPath.row].type.rawValue == 3 {//多选
                            optionsView.optionsType = .multiple
                        }else {//单选
                            optionsView.optionsType = .single
                        }
                        weak var weakSelf = self
                        optionsView.commonOptionsBlock = { (selecedData) in
                            weakSelf?.coNewOrderCustomConfig?.customFields[indexPath.row].selectValue = selecedData
                            weakSelf?.tableView.reloadData()
                        }
                        optionsView.datasource = coNewOrderCustomConfig?.customFields[indexPath.row].defaultValue ?? []
                        optionsView.selectedData = coNewOrderCustomConfig?.customFields[indexPath.row].selectValue ?? []
                        KeyWindow?.addSubview(optionsView)
                  }
        }
       
        
    }
    //出差时间
    func travelDateClick(tap:UITapGestureRecognizer){
        
        let index = IndexPath(row: 0, section:  3 + contrarySection + insuranceMessageSection + insuranceSection + travelSection)
        let cell = self.tableView.cellForRow(at: index) as? FlightTravelTableCell
        let startDate = cell?.startDateContentLabel.text != "" ? cell?.startDateContentLabel.text:(DateInRegion()+3.day).string(custom: "yyyy-MM-dd")
        let endDate = cell?.endDateContentLabel.text != "" ? cell?.startDateContentLabel.text:(DateInRegion()+8.day).string(custom: "yyyy-MM-dd")
        
        let vc:TBISpecailCalendarViewController = TBISpecailCalendarViewController()
        vc.selectedDates = [startDate! + " 00:00:00",endDate! + " 00:00:00"]
        vc.isMultipleTap = true
        vc.showDateTitle = ["起始","结束"]
        vc.titleColor = TBIThemePrimaryTextColor
        vc.bacButtonImageName = "back"
        vc.hotelSelectedDateAcomplishBlock = { (parameters) in
            let sdate = DateInRegion(string: parameters[0], format: .custom("YYYY-MM-dd hh:mm:ss"), fromRegion: regionRome)!
            let edate = DateInRegion(string: parameters[1], format: .custom("YYYY-MM-dd hh:mm:ss"), fromRegion: regionRome)!
            cell?.startDateContentLabel.text = sdate.string(custom: "YYYY-MM-dd")
            cell?.endDateContentLabel.text = edate.string(custom: "YYYY-MM-dd")
//            self.travelModel.departureDate = sdate.absoluteDate.unix
//            self.travelModel.returnDate    = edate.absoluteDate.unix
            
        }
        _ = self.navigationController?.pushViewController(vc, animated: true)

    }
    
    //出差时间
    func travelDateNewClick(tap:UITapGestureRecognizer){
        
        let index = IndexPath(row: 0, section:  3 + contrarySection + insuranceMessageSection + insuranceSection + travelSection)
        let cell = self.tableView.cellForRow(at: index) as? FlightTravelTableCell
        let startDate = cell?.startDateContentLabel.text != "" ? cell?.startDateContentLabel.text:(DateInRegion()+3.day).string(custom: "yyyy-MM-dd")
        let endDate = cell?.endDateContentLabel.text != "" ? cell?.startDateContentLabel.text:(DateInRegion()+8.day).string(custom: "yyyy-MM-dd")
        
        let vc:TBICalendarViewController = TBICalendarViewController()
        vc.calendarAlertType = TBICalendarAlertType.Flight
        vc.calendarTypeAlert = ["请选择起始日期","请选择结束日期"]
        vc.selectedDates = [startDate! + " 00:00:00",endDate! + " 00:00:00"]
        vc.isMultipleTap = true
        vc.showDateTitle = ["起始","结束"]
        vc.titleColor = TBIThemePrimaryTextColor
        vc.bacButtonImageName = "back"
        vc.hotelSelectedDateAcomplishBlock = { (parameters,action) in
            
            guard action == TBICalendarAction.Done else {
                return
            }
            let sdate = DateInRegion(string: (parameters?[0])!, format: .custom("YYYY-MM-dd hh:mm:ss"), fromRegion: regionRome)!
            let edate = DateInRegion(string: (parameters?[1])!, format: .custom("YYYY-MM-dd hh:mm:ss"), fromRegion: regionRome)!
            cell?.startDateContentLabel.text = sdate.string(custom: "YYYY-MM-dd")
            cell?.endDateContentLabel.text = edate.string(custom: "YYYY-MM-dd")
//            self.travelModel.departureDate = sdate.absoluteDate.unix
//            self.travelModel.returnDate    = edate.absoluteDate.unix
            
        }
        _ = self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    
    
    
    
    func flightCostCenterNewClick() {
        var alertContentArray:[(key:String,value:String)] = []//设置数据 [(key:String,value:String)]   -key为用户名，value为用户对应的成本中心
        let costCenterStr:String? = self.costCenterList.joined(separator: " - ")
        for traveller in travellerList{
            alertContentArray.append((key:traveller.name,value:traveller.costCenterName))
        }
        let tbiALertView2 = TBIAlertView2.init(frame: ScreenWindowFrame)
        tbiALertView2.titleStr = "成本中心"
        tbiALertView2.dataSource = alertContentArray
        tbiALertView2.initView()
        KeyWindow?.addSubview(tbiALertView2)
    }
    
    
    
    
    
    //出差目的
    func travelTargetClick(tap:UITapGestureRecognizer){
        let index = IndexPath(row: 0, section:  3 + contrarySection + insuranceMessageSection + insuranceSection + travelSection)
        let cell = self.tableView.cellForRow(at: index) as? FlightTravelTableCell
        cell?.cityContentLabel.resignFirstResponder()
        cell?.reasonContentLabel.resignFirstResponder()
        let titleArr:[String] = coNewOrderCustomConfig?.travelTargets ?? [""]

        let roleView = TBIFinderView.init(frame: ScreenWindowFrame)
        roleView.finderViewSelectedResultBlock = { (cellIndex) in
            cell?.purposeContentLabel.text = titleArr[cellIndex]
            self.travelModel.purpose = titleArr[cellIndex]
        }
        KeyWindow?.addSubview(roleView)
        roleView.reloadDataSources(titledataSources: titleArr, flageImage: nil)
    }
    
    
    //航空意外险
    func stateChanged(switchState: UISwitch) {
        for index in 0..<personList.count{
            if switchState.isOn {
                personList[index].depInsurance = true
                if searchModel.type == 2{//往返
                    if insuranceDays{//如果是往返且超过7天
                        personList[index].rtnInsurance = true
                    }}
            }else {
                personList[index].depInsurance = false
                personList[index].rtnInsurance = false
            }
        }
        flightOrderFooterView.priceCountLabel.text = sumPrice()
        insuranceAll = switchState.isOn
        tableView.reloadData()
//        tableView.reloadSections([3 + contrarySection + insuranceMessageSection], with: UITableViewRowAnimation.automatic)
//        let index = IndexPath(row: 0, section: 3 + contrarySection + insuranceMessageSection)
//        let cell = tableView.cellForRow(at: index) as! FlightSectionHeaderTableCell
//        cell.rightSwitch.isOn = switchState.isOn
        
    }
    
    //去程保险
    func startClick(sender: UIButton){
        if  sender.isSelected == false {
            personList[sender.tag - 100].depInsurance = true
            sender.isSelected = true
        }else {
            personList[sender.tag - 100].depInsurance = false
            sender.isSelected = false
        }
        flightOrderFooterView.priceCountLabel.text = sumPrice()
        tableView.reloadSections([3 + contrarySection + insuranceMessageSection], with: UITableViewRowAnimation.automatic)
    }
    
    //返程保险
    func returnClick(sender: UIButton){
        if  sender.isSelected == false {
            personList[sender.tag - 200].rtnInsurance = true
            sender.isSelected = true
        }else {
            personList[sender.tag - 200].rtnInsurance = false
            sender.isSelected = false
        }
        flightOrderFooterView.priceCountLabel.text = sumPrice()
        tableView.reloadSections([3 + contrarySection + insuranceMessageSection], with: UITableViewRowAnimation.automatic)
    }
    
    //生日
    func birthdayClick(sender: UIButton){
        let datePicker = TBIDatePickerView(frame: ScreenWindowFrame)
        datePicker.date = self.personList[sender.tag - 300].birthday
        datePicker.datePickerResultBlock = { (date) in
            self.personList[sender.tag - 300].birthday = date
            let index = IndexPath(row: sender.tag - 300 + 1, section: 3 + self.contrarySection + self.insuranceMessageSection)
            let cell = self.tableView.cellForRow(at: index) as? FlightCompanyInsuranceTableCell
            cell?.birthdayContentLabel.text = date
        }
        KeyWindow?.addSubview(datePicker)
        
    }
    
    //sex
    func sexClick(sender: UIButton){
        let titleArr:[String] = ["男","女"]
        let roleView = TBIFinderView.init(frame: ScreenWindowFrame)
        roleView.fontSize = UIFont.systemFont(ofSize: 16)
        roleView.finderViewSelectedResultBlock = { (cellIndex) in
            self.personList[sender.tag - 400].gender = cellIndex == 0 ? "M" : "F"
            let index = IndexPath(row: sender.tag - 400 + 1, section: 3 + self.contrarySection + self.insuranceMessageSection)
            let cell = self.tableView.cellForRow(at: index) as? FlightCompanyInsuranceTableCell
            cell?.sexContentLabel.text = cellIndex == 0 ? "男" : "女"
        }
        KeyWindow?.addSubview(roleView)
        roleView.reloadDataSources(titledataSources: titleArr, flageImage: nil)
    }
    
    //展开收起
    func upOnDown(sender: UIButton){
        if  sender.isSelected == false {
            sender.isSelected = true
            rightImg.image = UIImage(named: "ic_up_blue")
            insurancePersonCount  = travellerList.count
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
    
    
    
    
}
extension  FlightNewBusinessOrderViewController{
    
    func initFooterView(){
        bgView.backgroundColor = TBIThemeBackgroundViewColor
        KeyWindow?.addSubview(bgView)//放到主视图上
        self.view.addSubview(flightOrderFooterView)
        bgView.isHidden = true
        flightOrderFooterView.priceCountLabel.text = sumPrice()
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
            
            let count = personList.count
            let takeOffPrice = (takeOffCompanyModel?.cabinList[takeOffCompanyCabinRow!].price)! * count
            let takeOffTax = (takeOffCompanyModel?.cabinList[takeOffCompanyCabinRow!].tax)! * count
            
            insuranceCount = 0
            for index in 0..<personList.count{
                if personList[index].depInsurance == true {
                    insuranceCount += 1
                }
                if personList[index].rtnInsurance == true {
                    insuranceCount += 1
                }
            }
            if searchModel.type == 2 {
                let arrivePrice =  (arriveCompanyModel?.cabinList[arriveCompanyCabinRow!].price)! * count
                let arriveTax =  (arriveCompanyModel?.cabinList[arriveCompanyCabinRow!].tax)! * count
                flightPriceInfoView?.initView(personCount: count, takeOffPrice: Int(takeOffPrice), takeOffTax: Int(takeOffTax),arrivePrice: Int(arrivePrice),arriveTax:Int(arriveTax), iScourier:false, takeOffFlueTaxAmountPrice: 0, arriveFlueTaxAmountPrice: 0,insuranceCount:insuranceCount, type: 2)
            }else {
                flightPriceInfoView?.initView(personCount: count, takeOffPrice: Int(takeOffPrice), takeOffTax: Int(takeOffTax),arrivePrice: 0,arriveTax:0, iScourier:false, takeOffFlueTaxAmountPrice: 0, arriveFlueTaxAmountPrice: 0,insuranceCount:insuranceCount, type: searchModel.type)
            }
            
            
            self.view.addSubview(flightPriceInfoView!)
            var height:Double = 110
            if FlightManager.shareInStance.flightConditionDraw().first?.type == 1 { height += 56}
            if  insuranceAll { height += 44}
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
    
    func sumPrice() -> String{
        var countPrice = 0
        let count = personList.count
        countPrice += (takeOffCompanyModel?.cabinList[takeOffCompanyCabinRow!].price)! * count
        countPrice += (takeOffCompanyModel?.cabinList[takeOffCompanyCabinRow!].tax)! * count
        if searchModel.type == 2 {
            countPrice +=  (arriveCompanyModel?.cabinList[arriveCompanyCabinRow!].price)! * count
            countPrice +=  (arriveCompanyModel?.cabinList[arriveCompanyCabinRow!].tax)! * count
        }
        insuranceCount = 0
        for index in 0..<personList.count{
            if personList[index].depInsurance == true {
                insuranceCount += 1
            }
            if personList[index].rtnInsurance == true {
                insuranceCount += 1
            }
        }
        countPrice += insuranceCount*20
        return String(countPrice)
        
    }
    
    //提交订单
    func submitOrder(sender: UIButton) {
        newCreate?.passangers = personList
        newCreate?.orderNo = self.travelNo
        if  travelNo == nil {
            travelModel.apvRuleId  = travellerList.first?.apvRuleId ?? ""
            travelModel.costCenterIds.removeAll()
            travelModel.costCenterNames.removeAll()
            travelModel.uids.removeAll()
            for index in 0..<travellerList.count{
                travelModel.costCenterIds.append(travellerList[index].costCenterId)
                travelModel.costCenterNames.append(travellerList[index].costCenterName)
                travelModel.uids.append(travellerList[index].uid)
            }
            //自定义节点
            var opinions:[ModifyAndCreateCoNewOrderFrom.CustomFieldPara] = []
            let count = coNewOrderCustomConfig?.customFields.count ?? 0
            for index in 0..<count{
                var model = ModifyAndCreateCoNewOrderFrom.CustomFieldPara()
                model.id = coNewOrderCustomConfig?.customFields[index].id
                model.value = coNewOrderCustomConfig?.customFields[index].value.value
                if !(coNewOrderCustomConfig?.customFields[index].selectValue?.isEmpty ?? true) {
                    model.value = coNewOrderCustomConfig?.customFields[index].selectValue.map{$0.toString()}
                }
                if coNewOrderCustomConfig?.customFields.first?.required ?? false{
                    if model.value?.isEmpty ?? true{
                        alertView(title: "错误",message: "请输入自定义字段")
                        return
                        
                    }
                }
                opinions.append(model)
            }
            travelModel.opinions = opinions
            
            newCreate?.orderForm  = travelModel
            if contrarySection == 1{//违背了差旅政策 用不必须输入违背原因
                if newCreate?.reason.value.isEmpty ?? true {
                    alertView(title: "错误",message: "请输入违背原因")
                    return
                }
            }
            if coNewOrderCustomConfig?.travelDateFlag ?? false{//出差时间
//                if (newCreate?.orderForm?.departureDate ?? 0) < 100{
//                    alertView(title: "错误",message: "请选择出差时间")
//                    return
//                }
            }
            if coNewOrderCustomConfig?.travelDestFlag ?? false{//出差地点
                if newCreate?.orderForm?.destinations.first?.value.isEmpty ?? false{
                    alertView(title: "错误",message: "请输入出差地点")
                    return
                }
            }
            if coNewOrderCustomConfig?.travelTargetFlag ??  false{//出差目的
                if newCreate?.orderForm?.purpose.isEmpty ?? false{
                    alertView(title: "错误",message: "请选择出差目的")
                    return
                }
            }
            if coNewOrderCustomConfig?.travelPurposeFlag ?? false{//出差事由
                if newCreate?.orderForm?.reason.value.isEmpty ?? false{
                    alertView(title: "错误",message: "请输入出差事由")
                    return
                }
            }
        }
        showLoadingView()
        CoNewFlightService.sharedInstance.create(newCreate!).subscribe{ event in
            self.hideLoadingView()
            if case .next(let e) = event {
//                let alertController = UIAlertController(title: "成功", message: e, preferredStyle: .alert)
//                let okAction = UIAlertAction(title: "确定", style: .default){ action in
//                    alertController.removeFromParentViewController()
//                }
//                alertController.addAction(okAction)
//                self.present(alertController, animated: true)
                self.presentOrderDetails(orderNo: e)
                return
            }
            if case .error(let e) = event {
                try? self.validateHttp(e)
                
            }
            }.disposed(by: disposeBag)
        
    }
    
    
    /// 跳到定单详情页面
    ///
    /// - Parameter orderNo:
    func presentOrderDetails (orderNo:String){
        let vc = CoNewOrderDetailsController()
        vc.topBackEvent = .homePage
        vc.mBigOrderNOParams = orderNo
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
