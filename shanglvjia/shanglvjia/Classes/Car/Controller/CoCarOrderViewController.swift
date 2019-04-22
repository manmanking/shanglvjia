//
//  CoCarOrderViewController.swift
//  shop
//
//  Created by TBI on 2018/1/22.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import RxSwift
import SwiftDate

class CoCarOrderViewController: CompanyBaseViewController {

    fileprivate let tableView = UITableView()
    
    
    fileprivate let coTrainOrderPassengerHeaderTableViewCellIdentify = "coTrainOrderPassengerHeaderTableViewCellIdentify"
    
    fileprivate let coTrainOrderPassengerTableViewCellIdentify = "coTrainOrderPassengerTableViewCellIdentify"
    
    fileprivate let coTrainOrderContactPersonTableViewCellIdentify = "coTrainOrderContactPersonTableViewCellIdentify"
    
    fileprivate let coCarOrderTableViewCellIdentify = "coCarOrderTableViewCellIdentify"
    
    //出差单
    fileprivate  let flightTravelTableCellIdentify = "flightTravelTableCellIdentify"

    //联系人信息
    fileprivate  let flightCompanyContactTableCellIdentify = "flightCompanyContactTableCellIdentify"
    ///联系人选择
    //fileprivate var contactPeopleDataSources:[String] = Array()
    fileprivate var localLinkmanEmail:Variable = Variable("")
    fileprivate var localLinkmanName:Variable = Variable("")
    fileprivate var localLinkmanMobile:Variable = Variable("")
    fileprivate var localLinkmanUid:String = ""
    
    //违背cell
    fileprivate let trainContraryOrderTableCellIdentify = "trainContraryOrderTableCellIdentify"
    
    //订单备注
    fileprivate let addRemarkCellIdentify = "AddRemarkCell"
    
    var travelNo:String? = nil
    
    //选择旅客信息
    fileprivate var travellerList:[Traveller] = Array()
    
    fileprivate var userDetail:UserDetail?
    
    fileprivate let disposeBag = DisposeBag()
    
    //新版自定义字段
    fileprivate var coNewOrderCustomConfig:CoNewOrderCustomConfig?
    
    fileprivate var companyCustomSVConfig:LoginResponse.UserBaseTravelConfig?
    
    //自定义节点
    fileprivate var customFieldsSection:Int = 0
    
    // 没有手机号码可以修改的乘客
    fileprivate var updateFlag:[String] = []
    
    fileprivate var travelModel:ModifyAndCreateCoNewOrderFrom = ModifyAndCreateCoNewOrderFrom()
    
    // 乘车人
    fileprivate var passengers:[CoCarForm.CarPassenger] = []
    
    fileprivate var departureDate:String = ""
    
    fileprivate var returnDate:String = ""
    
    fileprivate var  commitModel = CoCarForm()
    
    var  coCarForm:CoCarForm.CarVO = CoCarForm.CarVO()
    /// POI搜索
    fileprivate let amapSearch:AMapSearchAPI = AMapSearchAPI()
    
    
    let submitButton:UIButton = UIButton(title: "立即预订",titleColor: TBIThemeWhite,titleSize: 20)
    
    fileprivate  let bag = DisposeBag()
    
    var time:String = ""
    
    var mileage:String = ""
    
    ///-----------------NEWOBT---------
    
    /// 是否显示出差单 1 显示 0 不显示
    fileprivate var travelSection:NSInteger = 0
    //订单备注
    fileprivate var remarkSection:Int = 0
    fileprivate var orderRemark = Variable("")
    
    fileprivate var passengerList:[QueryPassagerResponse] = Array()
    
    /// 用户信息
    fileprivate var userSVDetail:LoginResponse = LoginResponse()
    
    fileprivate var travelPurposesDataSources:[String] = Array()
    
    /// 出差事由
    fileprivate var reason =  Variable("")
    /// 出差地
    fileprivate var destinations = Variable("")
    
    fileprivate var purpose:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         setBlackTitleAndNavigationColor(title: "核对订单")
        setNavigationBackButton(backImage: "left")
        localDataSources()
        initTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func backButtonAction(sender:UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}
extension CoCarOrderViewController:UITableViewDelegate,UITableViewDataSource {
    
    func localDataSources() {
        initAddress()
        passengerList = PassengerManager.shareInStance.passengerSVDraw()
        for travel in passengerList {
            var passengerInfo = CoCarForm.CarPassenger()
            passengerInfo.name = travel.name
            passengerInfo.parId = travel.passagerId
            if travel.certInfos.count > 0 {
                let cards = travel.certInfos.filter{$0.certType == "1"}
                if cards.isEmpty {
                    passengerInfo.cardNo =  travel.certInfos.first?.certNo ?? ""//travel.certificates.first?.number ?? ""
                    passengerInfo.cardType = Int(travel.certInfos.first?.certType ?? "1")! //travel.certificates.first?.type ?? 1
                }else {
                    passengerInfo.cardNo = cards.first?.certNo ?? ""
                    passengerInfo.cardType = Int(travel.certInfos.first?.certType ?? "1")! //cards.first?.type ?? 1
                }
            }
            if travel.mobiles.count ==  0 {
                updateFlag.append(passengerInfo.parId)
            }else {
                passengerInfo.phone = Variable(travel.mobiles.first!)
            }
            if travel.emails.count > 0 {
                passengerInfo.email = travel.emails.first ?? ""
            }
            
            passengers.append(passengerInfo)

        }
        
        
        userSVDetail =  DBManager.shareInstance.userDetailDraw()!
        commitModel.carContact.parId = userSVDetail.busLoginInfo.userBaseInfo.uid // userDetail?.companyUser?.parId ?? ""
//        commitModel.carContact.name = userSVDetail.userBaseInfo.name//userDetail?.companyUser?.name ?? ""
//        commitModel.carContact.phone = userSVDetail.userBaseInfo.mobiles.first ?? ""//userDetail?.companyUser?.mobile ?? ""
//        commitModel.carContact.email = userSVDetail.userBaseInfo.emails.first ?? ""//userDetail?.companyUser?.emails.first ?? ""
        localLinkmanName = Variable(userSVDetail.busLoginInfo.userBaseInfo.name )
        localLinkmanEmail =  Variable(userSVDetail.busLoginInfo.userBaseInfo.emails.first ?? "")
        localLinkmanMobile = Variable(userSVDetail.busLoginInfo.userBaseInfo.mobiles.first ?? "")
        localLinkmanUid = userSVDetail.busLoginInfo.userBaseInfo.uid
        
        //commitModel.accountId = userSVDetail.userBaseInfo.//userDetail?.companyUser?.accountId ?? ""
        commitModel.corpCode = userSVDetail.busLoginInfo.userBaseInfo.corpCode//userDetail?.companyUser?.corpCode ?? ""
        //报销人信息
        coCarForm.expenseName = userSVDetail.busLoginInfo.userBaseInfo.name //userDetail?.companyUser?.name ?? ""
        coCarForm.expenseCostcenterid = userSVDetail.busLoginInfo.userBaseInfo.costCenterId//userDetail?.companyUser?.costCenterId ?? ""
        coCarForm.expenseCostcentername  = userSVDetail.busLoginInfo.userBaseInfo.costCenterName//userDetail?.companyUser?.costCenterName ?? ""
        coCarForm.expenseParid  =  userSVDetail.busLoginInfo.userBaseInfo.uid//userDetail?.companyUser?.parId ?? ""
        
//        travelModel.departureDate = DateInRegion(string: coCarForm.startTime, format: .custom("YYYY-MM-dd"), fromRegion: regionRome)?.absoluteDate.unix ?? DateInRegion().absoluteDate.unix
//        travelModel.returnDate = DateInRegion(string: coCarForm.startTime, format: .custom("YYYY-MM-dd"), fromRegion: regionRome)?.absoluteDate.unix ?? DateInRegion().absoluteDate.unix
        travelModel.destinations = [Variable(coCarForm.startCityName)]
//        departureDate = coCarForm.startTime
//        returnDate = coCarForm.startTime
        
        ///联系人
        //contactDataSource()
        
        // 公司个性化 配置
        companyCustomSVConfig = DBManager.shareInstance.userDetailDraw()?.busLoginInfo.userBaseInfo.travelConfig
        filterTravelPurposesDataSources()
        // 是否显示出差单信息
        if companyCustomSVConfig?.hasTravel == "1" {
            travelSection = 1
        }else {
            travelSection = 0
        }
        //订单备注
        remarkSection = 1
        tableView.reloadData()
    }
   
    
    func initTableView() {
        tableView.frame = self.view.frame
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CoCarOrderTableViewCell.self, forCellReuseIdentifier: coCarOrderTableViewCellIdentify)
        
        tableView.register(CoTrainOrderPassengerHeaderTableViewCell.self, forCellReuseIdentifier: coTrainOrderPassengerHeaderTableViewCellIdentify)
        tableView.register(CoTrainOrderPassengerTableViewCell.self, forCellReuseIdentifier: coTrainOrderPassengerTableViewCellIdentify)
        tableView.register(CoTrainOrderContactPersonTableViewCell.self, forCellReuseIdentifier: coTrainOrderContactPersonTableViewCellIdentify)
         tableView.register(AddRemarkCell.classForCoder(), forCellReuseIdentifier: addRemarkCellIdentify)
        tableView.register(FlightTravelTableCell.self, forCellReuseIdentifier: flightTravelTableCellIdentify)
        tableView.register(FlightCompanyContactTableCell.classForCoder(), forCellReuseIdentifier: flightCompanyContactTableCellIdentify)
        tableView.register(MineHomeTableViewFooterView.classForCoder(), forHeaderFooterViewReuseIdentifier: mineHomeTableViewHeaderViewIdentify)
        tableView.separatorStyle = .none
        tableView.backgroundColor = TBIThemeBaseColor
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(-54)
        }
        //submitButton.backgroundColor = TBIThemeOrangeColor
        self.view.addSubview(submitButton)
        submitButton.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(54)
        }
        submitButton.isSelected = true
        submitButton.backgroundColor = TBIThemeGrayLineColor
        submitButton.addTarget(self,action: #selector(submitOrder(sender:)), for: .touchUpInside)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        if userDetail?.companyUser?.newVersion ?? false{
//            if travelNo == nil {
//                /// 如果没有出差单号
//                return 5
//            }else {
//                //如果有出差单号
//                return 4
//            }
//
//        }else {
//            return 4
//        }
        return  4 + travelSection + remarkSection
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView:MineHomeTableViewFooterView = tableView.dequeueReusableHeaderFooterView(withIdentifier: mineHomeTableViewHeaderViewIdentify) as! MineHomeTableViewFooterView
        return footerView
    }
    
    //MARK:- UITableViewDataSources
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else if section == 1 {
            return passengers.count + 1
        }
        return  1
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 150
        }
        if indexPath.section == 2{
            return 132
        }
        if indexPath.section == 3  {
            return 44
        }
        if indexPath.section == 3 + travelSection {
            return 220
        }
        if indexPath.section == 3 + travelSection + remarkSection {
            return 70
        }
        return 44
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: coCarOrderTableViewCellIdentify) as! CoCarOrderTableViewCell
            cell.selectionStyle = .none
            cell.fullCell(model: coCarForm,time: time,mileage:mileage)
            return cell
        }else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: coTrainOrderPassengerHeaderTableViewCellIdentify) as! CoTrainOrderPassengerHeaderTableViewCell
                cell.selectionStyle = .none
                cell.fillCell(count: passengers.count)
                return cell
            }else { // 乘车人
                let cell = tableView.dequeueReusableCell(withIdentifier: coTrainOrderPassengerTableViewCellIdentify) as! CoTrainOrderPassengerTableViewCell
                cell.selectionStyle = .none
                cell.carFillCell(model: passengers[indexPath.row - 1],row:indexPath.row,count:passengers.count,updateFlag: updateFlag)
                cell.deleteBgView.tag = indexPath.row
                cell.deleteButton.tag = indexPath.row - 1 + 100
                cell.deleteButton.addTarget(self, action: #selector(deleteButton(sender:)), for: UIControlEvents.touchUpInside)
                cell.deleteBgView.addOnClickListener(target: self, action: #selector(deleteCellClick(tap:)))
                return cell
            }
        }else if indexPath.section == 2 {
            // 联系人
            let cell:FlightCompanyContactTableCell = tableView.dequeueReusableCell(withIdentifier: flightCompanyContactTableCellIdentify) as! FlightCompanyContactTableCell;
//            cell.fillDataSources(name:(commitModel.carContact.name),phone:(commitModel.carContact.phone),email:(commitModel.carContact.email))
//            cell.nameField.addOnClickListener(target: self, action: #selector(contactPeopleClick(tap: )))
//            cell.phoneField.rx.text.orEmpty.bind(to: Variable(commitModel.carContact.phone)).addDisposableTo(disposeBag)
//            cell.emailField.rx.text.orEmpty.bind(to: Variable(commitModel.carContact.email)).addDisposableTo(disposeBag)
            cell.fillDataSources(name:localLinkmanName.value,phone:localLinkmanMobile.value,email:localLinkmanEmail.value)
            //cell.nameField.addOnClickListener(target: self, action: #selector(contactPeopleClick(tap: )))
            weak var weakSelf = self
            cell.flightCompanyContactBlock = { _ in
                weakSelf?.contactPeopleClick()
            }
            cell.phoneField.rx.text.orEmpty.bind(to: localLinkmanMobile).addDisposableTo(disposeBag)
            cell.emailField.rx.text.orEmpty.bind(to: localLinkmanEmail).addDisposableTo(disposeBag)
//            localLinkmanMobile.value = cell.phoneField.text!
//            localLinkmanEmail.value = cell.emailField.text!
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }else if indexPath.section == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: coTrainOrderContactPersonTableViewCellIdentify) as! CoTrainOrderContactPersonTableViewCell
                cell.selectionStyle = .none
                cell.carFillCell(name: coCarForm.expenseName)
                return cell
        }else if indexPath.section == 3 + travelSection{
            let cell = tableView.dequeueReusableCell(withIdentifier: flightTravelTableCellIdentify) as! FlightTravelTableCell
            //cell.fillCell(model: coNewOrderCustomConfig, companyCode: "")
            cell.fillDataSources(model:companyCustomSVConfig! , companyCode: "")
            //cell.fillCellData(model: travelModel)
            cell.oneCell.addOnClickListener(target: self, action: #selector(travelDateNewClick(tap: )))
            cell.twoCell.addOnClickListener(target: self, action: #selector(travelDateNewClick(tap: )))
            cell.fourCell.addOnClickListener(target: self, action: #selector(travelTargetClick(tap: )))
            cell.cityContentLabel.rx.text.orEmpty.bind(to: destinations).addDisposableTo(disposeBag)
            cell.reasonContentLabel.rx.text.orEmpty.bind(to: reason).addDisposableTo(disposeBag)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }else if indexPath.section == 3 + travelSection  + remarkSection{//订单备注
            
            let cell = tableView.dequeueReusableCell(withIdentifier: addRemarkCellIdentify) as! AddRemarkCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.fillDataSourcesRemark(reason: orderRemark.value)
            //cell.messageField.rx.text.orEmpty.bind(to: orderRemark).addDisposableTo(disposeBag)
            cell.messageTextView.rx.text.orEmpty.bind(to: orderRemark).addDisposableTo(disposeBag)
            return cell
        }
        return UITableViewCell()
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        weak var weakSelf = self
        if indexPath.section == 1 {
            if indexPath.row != 0 {// 乘车人
                if updateFlag.contains(passengers[indexPath.row - 1].parId) {
                    let vc = CoCarPersonController()
                    vc.passenger = passengers[indexPath.row - 1]
                    vc.updateRow = indexPath.row - 1
                    vc.carPersonResultBlock = { (data,row) in
                        weakSelf?.passengers[row] = data
                        weakSelf?.tableView.reloadData()
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }else if indexPath.section == 3 { // 报销人
            let vc = CoExpenseController()
            vc.expenseSelectedResult = { (traveller) in
                weakSelf?.coCarForm.expenseName = traveller.name
                weakSelf?.coCarForm.expenseCostcenterid = traveller.costInfoId//costCenterId
                weakSelf?.coCarForm.expenseCostcentername  = traveller.costInfoName//costCenterName
                weakSelf?.coCarForm.expenseParid  = traveller.passagerId
                weakSelf?.tableView.reloadData()
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
//        else if indexPath.section == 3 + travelSection  + remarkSection//订单备注
//         {
//                weak var weakSelf = self
//                let approvalOpinionController = AddRemarkViewController()
//                approvalOpinionController.contentStr=orderRemark
//                approvalOpinionController.reBlock = {(remarkStr) in
//                    weakSelf?.orderRemark = remarkStr
//                }
//                self.navigationController?.pushViewController(approvalOpinionController, animated: true)
//         }
        
        
    }
    
    
    
    //出差目的
    func travelTargetClick(tap:UITapGestureRecognizer){
        let index = IndexPath(row: 0, section:  4)
        let cell = self.tableView.cellForRow(at: index) as? FlightTravelTableCell
        cell?.cityContentLabel.resignFirstResponder()
        cell?.reasonContentLabel.resignFirstResponder()
        let titleArr:[String] = travelPurposesDataSources
        weak var weakSelf = self
        
        let roleView = TBIFinderView.init(frame: ScreenWindowFrame)
        roleView.finderViewSelectedResultBlock = { (cellIndex) in
            cell?.purposeContentLabel.text = titleArr[cellIndex]
            weakSelf?.purpose = (weakSelf?.travelPurposesDataSources[cellIndex])!
        }
        KeyWindow?.addSubview(roleView)
        roleView.reloadDataSources(titledataSources: titleArr, flageImage: nil)
    }
    
    
    func filterTravelPurposesDataSources() {
        guard companyCustomSVConfig != nil && (companyCustomSVConfig?.travelPurposes.count)! > 0 else {
            return
        }
        
        
        let travelPurpose = companyCustomSVConfig?.travelPurposes.filter({ $0.type == "4" })
        travelPurposesDataSources = (travelPurpose?.flatMap({ (element) -> String in
            return element.chDesc
        })) ?? [""]
    }
    
    
    
    
    //出差时间
    func travelDateNewClick(tap:UITapGestureRecognizer){
        weak var weakSelf = self
        let index = IndexPath(row: 0, section:  4)
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
            let formatter = DateFormatter()
            formatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone?
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let sdate:Date = formatter.date(from: (parameters?[0])!) ?? Date()
            //DateInRegion(string: (parameters?[0])!, format: .custom("YYYY-MM-dd hh:mm:ss"), fromRegion: regionRome)!
            let edate:Date = formatter.date(from: (parameters?[1])!) ?? Date()
                //DateInRegion(string: (parameters?[1])!, format: .custom("YYYY-MM-dd hh:mm:ss"), fromRegion: regionRome)!
            cell?.startDateContentLabel.text = sdate.string(custom: "YYYY-MM-dd")
            cell?.endDateContentLabel.text = edate.string(custom: "YYYY-MM-dd")
            weakSelf?.departureDate = sdate.string(custom: "YYYY-MM-dd")
            weakSelf?.returnDate = edate.string(custom: "YYYY-MM-dd")
            
//            self.travelModel.departureDate = sdate.absoluteDate.unix
//            self.travelModel.returnDate    = edate.absoluteDate.unix
            weakSelf?.tableView.reloadData()
            
        }
        _ = self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    //点击删除按钮
    func deleteButton(sender:UIButton){
        let removePassenger:CoCarForm.CarPassenger =  passengers[sender.tag - 100]
        let removeSVPassenger:QueryPassagerResponse = QueryPassagerResponse()
        removeSVPassenger.passagerId = removePassenger.parId
        var isDeleteContactPerson = false
        if removePassenger.parId == localLinkmanUid {
            isDeleteContactPerson = true
        }
        
        let isDelete:Bool = PassengerManager.shareInStance.passengerSVDelete(passenger: removeSVPassenger)
        passengers.remove(at: sender.tag - 100)
        
        //contactDataSource()
        
        //20180622 删除以后更新数据
        if isDeleteContactPerson == true {
            localLinkmanName.value = passengers[0].name
            localLinkmanEmail.value = passengers[0].email
            localLinkmanMobile.value = passengers[0].phone.value
            localLinkmanUid = passengers[0].parId
        }
        
        
        self.tableView.reloadData()
        let index = IndexPath(row: sender.tag - 100 + 1, section: 1)
        let cell = self.tableView.cellForRow(at: index) as? CoTrainOrderPassengerTableViewCell
        //cell?.flag = false
        cell?.deleteImg.transform = (cell?.deleteImg.transform.rotated(by: CGFloat(-Double.pi/2)))!
    }
    
    //点击删除标示
    func deleteCellClick(tap:UITapGestureRecognizer){
        if passengers.count == 1{
            return
        }
        let index = IndexPath(row: tap.view?.tag ?? 0, section: 1)
        let cell = self.tableView.cellForRow(at: index) as? CoTrainOrderPassengerTableViewCell
        if cell?.flag ?? true{
            cell?.flag = false
            UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
                cell?.bgView.frame.origin.x = (cell?.bgView.frame.origin.x ?? 0) + 50
            }, completion: { (finished) -> Void in
                
            })
            UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
                cell?.deleteImg.transform = (cell?.deleteImg.transform.rotated(by: CGFloat(-Double.pi/2)))!
            }, completion: { (finished) -> Void in
                
            })
        }else {
            cell?.flag = true
            UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
                cell?.bgView.frame.origin.x = (cell?.bgView.frame.origin.x ?? 0) - 50
            }, completion: { (finished) -> Void in
                
            })
            UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
                cell?.deleteImg.transform = (cell?.deleteImg.transform.rotated(by: CGFloat(Double.pi/2)))!
            }, completion: { (finished) -> Void in
                
            })
        }
        
    }
    
//    ///选择联系人数据源
//    func contactDataSource(){
//        contactPeopleDataSources.removeAll()
//        for element in passengers {
//           contactPeopleDataSources.append(element.name)
//        }
//         var isContainUser = false
//        passengers.contains { (element) -> Bool in
//            if element.parId == userSVDetail.userBaseInfo.uid {
//                return true
//            }
//            return false
//        }
//        if isContainUser == false {
//            contactPeopleDataSources.append((userSVDetail.userBaseInfo.name))
//        }
//
//
//    }
    
}

extension CoCarOrderViewController: AMapSearchDelegate{
    
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        let model = response.pois.first
        if coCarForm.carType == "1" {
            coCarForm.startLatitude = "\(model?.location.latitude ?? 0)"
            coCarForm.stratLongitude = "\(model?.location.longitude ?? 0)"
            coCarForm.startCityName = model?.city ?? ""
        }else if coCarForm.carType == "2" {
            coCarForm.endLatitude = "\(model?.location.latitude ?? 0)"
            coCarForm.endLongitude = "\(model?.location.longitude ?? 0)"
            coCarForm.endCityName = model?.city ?? ""
        }
        
        drivingRouteSearch ()
    }
    
    /// 路线规划回调
    func onRouteSearchDone(_ request: AMapRouteSearchBaseRequest!, response: AMapRouteSearchResponse!) {
        if response.route  == nil {
            return
        }
      
        time = String(describing: (response.route.paths?.first?.duration ?? 0)/60 )    //分钟
        mileage = String(format: "%.1f", Double(response.route.paths?.first?.distance ?? 0)/1000)  //公里
        var date = DateInRegion(string: coCarForm.startTime, format: .custom("YYYY-MM-dd HH:mm"), fromRegion: regionRome)!
        date = date + (Int(time)?.minute ?? 0.minute)
        let str = date.string(custom: "YYYY-MM-dd HH:mm")
        coCarForm.endTime = str
        submitButton.isSelected = false
        submitButton.backgroundColor = TBIThemeDarkBlueColor
        self.tableView.reloadData()
    }
    
    func requestMapPoi(keyword:String) {
        let request:AMapPOIKeywordsSearchRequest = AMapPOIKeywordsSearchRequest()
        request.requireExtension = true
        request.keywords = keyword
        amapSearch.aMapPOIKeywordsSearch(request)
    }
    
    /// 驾车路线规划
    func drivingRouteSearch () {
        let request:AMapDrivingRouteSearchRequest = AMapDrivingRouteSearchRequest()
        let start = AMapGeoPoint()
        start.longitude = CGFloat(Double(coCarForm.stratLongitude) ?? 0)
        start.latitude = CGFloat(Double(coCarForm.startLatitude) ?? 0)
        let end = AMapGeoPoint()
        end.longitude = CGFloat(Double(coCarForm.endLongitude) ?? 0)
        end.latitude = CGFloat(Double(coCarForm.endLatitude) ?? 0)
        request.origin = start
        request.destination = end
        amapSearch.aMapDrivingRouteSearch(request)
    }
    
    func initAddress (){
        amapSearch.delegate = self
        if coCarForm.carType == "1"  {
            requestMapPoi(keyword: coCarForm.startAddress)
        }else if coCarForm.carType == "2" {
            requestMapPoi(keyword: coCarForm.endAddress)
        }else {
            drivingRouteSearch ()
        }
    }
    
    
    /// 跳到定单详情页面
    ///
    /// - Parameter orderNo:
    func presentOrderDetails (orderNo:String){
        if orderNo.isNotEmpty {
            let vc = CoNewOrderDetailsController()
            vc.mBigOrderNOParams = orderNo
            vc.topBackEvent = .homePage
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    //联系人
    func contactPeopleClick(){
        //如果是一个人不弹出
        //如果是一个人不弹出
        var isAble:Bool = false
        if passengers.count == 1 && passengers.first?.parId != userSVDetail.busLoginInfo.userBaseInfo.uid {
            isAble = true
        }
        
        
        guard  passengers.count > 1 || isAble == true else {
            return
        }
        let index = IndexPath(row: 0, section: 2)
        let cell = self.tableView.cellForRow(at: index) as? FlightCompanyContactTableCell
        weak var weakSelf = self
        var contactPersonDataSources:[String] = Array()
        
        var isContainUser:Bool = false
        isContainUser = passengers.contains(where: { (element) -> Bool in
            if element.parId == userSVDetail.busLoginInfo.userBaseInfo.uid {
                return true
            }
            return false
        })
        
        for element in passengers {
            contactPersonDataSources.append(element.name)
        }
        if isContainUser == false {
            contactPersonDataSources.append((userSVDetail.busLoginInfo.userBaseInfo.name))
        }
        
        let roleView = TBIFinderView.init(frame: ScreenWindowFrame)
        roleView.finderViewSelectedResultBlock = { (cellIndex) in
            cell?.nameContentLabel.text = contactPersonDataSources[cellIndex]
            weakSelf?.localLinkmanName.value = contactPersonDataSources[cellIndex]
            if cellIndex < (weakSelf?.passengers.count)!{
                cell?.phoneField.text = weakSelf?.passengers[cellIndex].phone.value
                cell?.emailField.text = weakSelf?.passengers[cellIndex].email
                weakSelf?.localLinkmanEmail.value = cell?.emailField.text ?? ""
                weakSelf?.localLinkmanMobile.value = cell?.phoneField.text ?? ""
                weakSelf?.localLinkmanUid = weakSelf?.passengers[cellIndex].parId ?? ""
            }else{
                cell?.phoneField.text = weakSelf?.userSVDetail.busLoginInfo.userBaseInfo.mobiles.first ?? ""
                cell?.emailField.text = weakSelf?.userSVDetail.busLoginInfo.userBaseInfo.emails.first ?? ""
                weakSelf?.localLinkmanEmail.value = cell?.emailField.text ?? ""
                weakSelf?.localLinkmanMobile.value = cell?.phoneField.text ?? ""
                weakSelf?.localLinkmanUid = weakSelf?.userSVDetail.busLoginInfo.userBaseInfo.uid ?? ""
            }
        }
        KeyWindow?.addSubview(roleView)
        roleView.reloadDataSources(titledataSources: contactPersonDataSources, flageImage: nil)
    }

    
    //预订
    func submitOrder(sender: UIButton) {
        if sender.isSelected == false {
            
            if  travelNo == nil {
                if companyCustomSVConfig?.travelTimeRequire == "1" || companyCustomSVConfig?.travelRetTimeRequire == "1" {//出差时间
                    if departureDate.isEmpty == true {
                        alertView(title: "提示",message: "请选择出差时间")
                        return
                    }
                }
                if companyCustomSVConfig?.travelDestRequire == "1" {//出差地点
                    if destinations.value.isEmpty == true {
                        alertView(title: "提示",message: "请输入出差地点")
                        return
                    }
                }
                if companyCustomSVConfig?.travelPurposeRequire == "1" {//出差目的
                    if purpose.isEmpty == true {
                        alertView(title: "提示",message: "请选择出差目的")
                        return
                    }
                }
                if companyCustomSVConfig?.travelReasonRequire == "1" {//出差事由
                    if reason.value.isEmpty == true {
                        alertView(title: "提示",message: "请输入出差事由")
                        return
                    }
                }
            }
            //let carForm = coCarForm
            commitModel.carVO = coCarForm
            commitModel.carPassengerList = passengers
            commitModel.orderVO.travelOrderNo = self.travelNo ?? ""
            commitModel.orderVO.startDate = departureDate
            commitModel.orderVO.endDate = returnDate
            commitModel.carVO.startTime = String(describing: DateInRegion(string: coCarForm.startTime, format: .custom("YYYY-MM-dd HH:mm"), fromRegion: regionRome)?.absoluteDate.unix ?? 0)
            commitModel.carVO.endTime = String(describing: DateInRegion(string: coCarForm.endTime, format: .custom("YYYY-MM-dd HH:mm"), fromRegion: regionRome)?.absoluteDate.unix ?? 0)
            
            commitModel.orderVO.travelDestination = travelModel.destinations.first?.value ?? ""
            commitModel.orderVO.travelPurposen = purpose
            commitModel.orderVO.travelReason = reason.value
            commitModel.orderVO.travelDestination = destinations.value
            commitModel.orderVO.remark = orderRemark.value
            commitModel.remark = orderRemark.value
            commitModel.carVO.remark = orderRemark.value
            //提交联系人
            commitModel.carContact.name = localLinkmanName.value
            commitModel.carContact.email = localLinkmanEmail.value
            commitModel.carContact.phone = localLinkmanMobile.value
            sender.backgroundColor = TBIThemeGrayLineColor
            
            sender.isSelected = true
            self.showLoadingView()
            commitOrder(commitModel:commitModel)
            
        }
        
    }
    
    func commitOrderOld(commitModel:CoCarForm) {
        
        
        
        
        CoCarService.sharedInstance.commit(model: commitModel).subscribe{ event in
            self.hideLoadingView()
            switch event{
            case .next(let e):
                print(e)
                self.presentOrderDetails(orderNo:e)
                break
            case .error(let e):
                try? self.validateHttp(e)
            case .completed:
                break
            }
            }.addDisposableTo(self.bag)
    }
    
    
    
    
    func commitOrder(commitModel:CoCarForm) {
        //let obtCarOrderVO:ObtCarOrderVO = ObtCarOrderVO.CoCarFormConvertObtCarOrderVO(model: commitModel)
        weak var weakSelf = self
        
        let submitCar:SubmitCarOrderVO = SubmitCarOrderVO().carFormConvertObtCarOrderVO(model:commitModel)
        _ = CoCarService.sharedInstance
            .commitOrder(parameters:submitCar)
            .subscribe{ event in
                self.hideLoadingView()
                switch event{
                case .next(let e):
                    print(e)
                    weakSelf?.verifyUserRightApproval(orderArr: [e])
                    //weakSelf?.getApproval(orderNo: e)
                    //self.presentOrderDetails(orderNo:e)
                    break
                case .error(_):
                        weakSelf?.intoNextSubmitOrderFailureView(orderStatus: false)
                //try? self.validateHttp(e)
                case .completed:
                    break
                }
            }
        
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
            orderInfo.orderType = "4"
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
        examineView.orderType = "4"
        self.navigationController?.pushViewController(examineView, animated: true)
    }
    
    func intoNextSubmitOrderFailureView(orderStatus:Bool) {
        let submitOrderFailureView = SubmitOrderFailureViewController()
        submitOrderFailureView.submitOrderStatus = orderStatus ? .Success_Submit_Order : .Failure_Submit_Order
        self.navigationController?.pushViewController(submitOrderFailureView, animated: true)
    }
    
    
    
    
}

