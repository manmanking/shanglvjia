//
//  CoNewUpdateTravelNoViewController.swift
//  shop
//
//  Created by TBI on 2017/6/22.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import SwiftDate
import RxCocoa
import RxSwift

class CoNewUpdateTravelNoViewController: CompanyBaseViewController  {

    fileprivate let disposeBag = DisposeBag()
    
    fileprivate let tableView:UITableView = UITableView()
    
    fileprivate let coNewTravelContactTableViewCellIdentify = "coNewTravelContactTableViewCellIdentify"
    
    fileprivate let coNewCustomerTableViewCellIdentify = "coNewCustomerTableViewCellIdentify"
    
    //出差单
    fileprivate  let flightTravelTableCellIdentify = "flightTravelTableCellIdentify"
    
    fileprivate  let flightCustomTableCellIdentify = "flightCustomTableCellIdentify"
    
    public  var flag: Bool? //true新建  false修改
    
    fileprivate var travellerList:[Traveller] = Array()
    //用户详情
    fileprivate var userDetail:UserDetail?
    //新版自定义字段
    fileprivate var coNewOrderCustomConfig:CoNewOrderCustomConfig?
    
    fileprivate var commitBtn = UIButton(title: "", titleColor: TBIThemeWhite, titleSize: 16)
    
    fileprivate var resetBtn = UIButton(title: "重置", titleColor: TBIThemeWhite, titleSize: 16)
    
    //成本中心
    fileprivate var costCenterList:[String] = []
    
    var  coNewOrderDetail:CoNewOrderDetail?
    
    //出差单节点信息
    fileprivate var travelModel:ModifyAndCreateCoNewOrderFrom = ModifyAndCreateCoNewOrderFrom()
    
    //  add by manman on start of line   on 2017-08-31
    
    // 备注信息 是否显示 动态配置 0 需要显示  1不显示
    fileprivate var  showRemarkSection:NSInteger = 0
    
    // 出差地点 是否显示 动态配置 0 需要显示  1不显示
    fileprivate var  showDestionRow:NSInteger = 0
    
    
    
    
    //end of line
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        setNavigationController()
        initTableView()
        // Do any additional setup after loading the view.
    }
    
    func setNavigationController (){
        setTitle(titleStr: "修改出差单")
        self.view.backgroundColor = TBIThemeBaseColor
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        setNavigationBgColor(color:TBIThemeBlueColor)
        setNavigationBackButton(backImage: "back")
    }
    
    override func backButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initData(){
//        travelModel.departureDate = coNewOrderDetail?.startDate?.absoluteDate.unix ?? 0
//        travelModel.returnDate =    coNewOrderDetail?.endDate?.absoluteDate.unix ?? 0
        travelModel.purpose    =    coNewOrderDetail?.purpose ?? ""
        travelModel.reason    =     Variable(coNewOrderDetail?.reason ?? "")
        travelModel.destinations  = coNewOrderDetail?.destinations.reduce([], {$0 + [Variable($1)]}) ?? [Variable("")]
        if travelModel.destinations.isEmpty {
            travelModel.destinations = [Variable("")]
        }
        
        var opinions:[ModifyAndCreateCoNewOrderFrom.CustomFieldPara] = []
        let count = coNewOrderDetail?.customFields.count  ?? 0
        for index in 0..<count{
            var model = ModifyAndCreateCoNewOrderFrom.CustomFieldPara()
            model.id = coNewOrderDetail?.customFields[index].id.id
            model.value = coNewOrderDetail?.customFields[index].values.toString()
            opinions.append(model)
        }
        travelModel.opinions   =  opinions
        
//        costCenterList =  travellerList.first?.costCenterName.components(separatedBy: "-") ?? []
//        print(costCenterList)
        //用户详情
        userDetail = UserService.sharedInstance.userDetail()
        if userDetail?.companyUser?.companyCode == Toyota {
            showDestionRow = 1
        }
        
        
        
        
        
        self.showLoadingView()
        
        weak var weakSelf = self
        //获取公司出差单配置信息
        CoNewOrderService.sharedInstance
                         .getCustomConfigBy()
                         .subscribe{ event in
                                    if case .next(let e) = event {
                                        weakSelf?.coNewOrderCustomConfig = e
                                        if !(weakSelf?.coNewOrderCustomConfig?.customFields.isEmpty ?? true){
                                            weakSelf?.coNewOrderCustomConfig?.customFields[0].selectValue = weakSelf?.coNewOrderDetail?.customFields.first?.values
                                            if weakSelf?.coNewOrderCustomConfig?.customFields.first?.id.isEmpty == true
                                            {
                                                weakSelf?.showRemarkSection = 1
                                            }
                                        }
                                      
                                        weakSelf?.tableView.reloadData()
                                    }
                                    if case .error(let e) = event {
                                         try? weakSelf?.validateHttp(e)
                                    }
                                    }.disposed(by: disposeBag)
        let ids = coNewOrderDetail?.psgInfos.reduce([], {$0 + [$1.id]})
        HotelCompanyService.sharedInstance
                           .getTravellersBy(ids ?? [])
                           .subscribe{ event in
                                    weakSelf?.hideLoadingView()
                                    if case .next(let e) = event {
                                        weakSelf?.travellerList = e
                                        weakSelf?.tableView.reloadData()
                                        weakSelf?.costCenterList =  weakSelf?.travellerList.first?.costCenterName.components(separatedBy: "-") ?? []
                                    }
                                    if case .error(let e) = event {
                                        try? weakSelf?.validateHttp(e)
                                    }
                            }.disposed(by: disposeBag)
        
        
        
    }
    
    /// 提交出差单
    ///
    /// - Parameter sender:
    func submitTravel(sender: UIButton) {
        
        travelModel.costCenterIds.removeAll()
        travelModel.costCenterNames.removeAll()
        travelModel.uids.removeAll()
        if travellerList.isEmpty{
            alertView(title: "提示",message: "请选择至少一个用户")
            return
        }
        //审批规则id
        travelModel.apvRuleId  = travellerList.first?.apvRuleId ?? ""
        for index in 0..<travellerList.count{
            travelModel.costCenterIds.append(travellerList[index].costCenterId)
            travelModel.costCenterNames.append(travellerList[index].costCenterName)
            travelModel.uids.append(travellerList[index].uid)
        }
        var opinions:[ModifyAndCreateCoNewOrderFrom.CustomFieldPara] = []
        let count = coNewOrderCustomConfig?.customFields.count ?? 0
        for index in 0..<count{
            var model = ModifyAndCreateCoNewOrderFrom.CustomFieldPara()
            model.id = coNewOrderCustomConfig?.customFields[index].id
            model.resultId = coNewOrderDetail?.customFields.first?.id.resultId
            model.value = coNewOrderCustomConfig?.customFields[index].value.value
            if !(coNewOrderCustomConfig?.customFields[index].selectValue?.isEmpty ?? true) {
                model.value = coNewOrderCustomConfig?.customFields[index].selectValue.map{$0.toString()}
            }
            if coNewOrderCustomConfig?.customFields.first?.required ?? false{
                if model.value?.isEmpty ?? true{
                    alertView(title: "提示",message: "请输入自定义字段")
                    return
                    
                }
            }
            opinions.append(model)
        }
        travelModel.opinions = opinions
        
        
        if coNewOrderCustomConfig?.travelDateFlag ?? false{//出差时间
//            if travelModel.departureDate < 100{
//                alertView(title: "提示",message: "请选择出差时间")
//                return
//            }
        }
        if coNewOrderCustomConfig?.travelDestFlag ?? false{//出差地点
            if travelModel.destinations.first?.value.isEmpty ?? false{
                alertView(title: "提示",message: "请输入出差地点")
                return
            }
        }
        if coNewOrderCustomConfig?.travelTargetFlag ??  false{//出差目的
            if travelModel.purpose.isEmpty{
                alertView(title: "提示",message: "请选择出差目的")
                return
            }
        }
        if coNewOrderCustomConfig?.travelPurposeFlag ?? false{//出差事由
            if travelModel.reason.value.isEmpty{
                alertView(title: "提示",message: "请输入出差事由")
                return
            }
        }
        showLoadingView()
        CoNewOrderService.sharedInstance.modify(coNewOrderDetail?.orderNo ?? "", form: travelModel).subscribe{ event in
            self.hideLoadingView()
            if case .next(let e) = event {
                self.presentOrderDetails(orderNo: e.orderNo)
            }
            if case .error(let e) = event {
                print("=====失败======")
                try? self.validateHttp(e)
            }
            }.disposed(by: disposeBag)
        
        
    }
    
    /// 跳到出差单详情页面
    ///
    /// - Parameter orderNo:
    func presentOrderDetails (orderNo:String){
        let vc = CoNewOrderDetailsController()
        vc.mBigOrderNOParams = orderNo
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 重置数据
    ///
    /// - Parameter sender:
    func resetTravel(sender: UIButton) {
//        travelModel.departureDate = 0
//        travelModel.returnDate = 0
        travelModel.destinations = [Variable("")]
        travelModel.purpose = ""
        travelModel.reason =  Variable("")
        let index = IndexPath(row: 0, section:  2)
        let cell = self.tableView.cellForRow(at: index) as? FlightTravelTableCell
        cell?.startDateContentLabel.text = ""
        cell?.endDateContentLabel.text = ""
        cell?.cityContentLabel.text = ""
        cell?.reasonContentLabel.text = ""
        cell?.purposeContentLabel.text  = ""
        if !(coNewOrderCustomConfig?.customFields.isEmpty ?? false){
            let indexCustom = IndexPath(row: 0, section:  4)
            let cellCustom = self.tableView.cellForRow(at: indexCustom) as? FlightCustomTableCell
            cellCustom?.contentField.text = ""
            coNewOrderCustomConfig?.customFields[0].value = Variable("")
        }
        tableView.reloadData()
    }
}
extension CoNewUpdateTravelNoViewController: UITableViewDelegate,UITableViewDataSource{
    
    func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = TBIThemeBaseColor
        tableView.register(MineHomeTableViewFooterView.classForCoder(), forHeaderFooterViewReuseIdentifier: mineHomeTableViewHeaderViewIdentify)
        tableView.register(CoNewTravelContactTableViewCell.classForCoder(), forCellReuseIdentifier:coNewTravelContactTableViewCellIdentify)
        tableView.register(FlightCustomTableCell.classForCoder(), forCellReuseIdentifier:flightCustomTableCellIdentify)
        tableView.register(CoNewCustomerTableViewCell.classForCoder(), forCellReuseIdentifier:coNewCustomerTableViewCellIdentify)
        tableView.register(FlightTravelTableCell.classForCoder(), forCellReuseIdentifier: flightTravelTableCellIdentify)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(54)
        }
        commitBtn.setTitle("保存", for: UIControlState.normal)
        self.view.addSubview(commitBtn)
        commitBtn.backgroundColor = TBIThemeGreenColor
        resetBtn.backgroundColor = TBIThemeRedColor
        commitBtn.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview()
            make.height.equalTo(54)
            make.width.equalToSuperview().dividedBy(2)
        }
        self.view.addSubview(resetBtn)
        resetBtn.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview()
            make.height.equalTo(54)
            make.width.equalToSuperview().dividedBy(2)
        }
        
        commitBtn.addTarget(self, action: #selector(submitTravel(sender:)), for: .touchUpInside)
        resetBtn.addTarget(self, action: #selector(resetTravel(sender:)), for: .touchUpInside)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5 - showRemarkSection
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 0 {
            return 1
        }else if section == 1 {
            return travellerList.count + 1
        }else if section == 3 {
//            return costCenterList.count
            return 1
        }else if section == 4 {
            return coNewOrderCustomConfig?.customFields.count ?? 0
        }
        return  1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView:MineHomeTableViewFooterView = tableView.dequeueReusableHeaderFooterView(withIdentifier: mineHomeTableViewHeaderViewIdentify) as! MineHomeTableViewFooterView
        return footerView
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: coNewTravelContactTableViewCellIdentify) as! CoNewTravelContactTableViewCell
            cell.fillCell(name: userDetail?.companyUser?.name ?? "")
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: coNewCustomerTableViewCellIdentify) as! CoNewCustomerTableViewCell
            if indexPath.row ==  0 {
                cell.fillCell(name: "", index: indexPath,delFlag: true)
            }else {
                var ids:[String] = []
                ids += coNewOrderDetail?.flightItems.map{ $0.passengers.map{ $0.id } }.flatMap{ $0 } ?? []
                ids += coNewOrderDetail?.hotelItems.map{ $0.passengers.map{ $0.id } }.flatMap{ $0 } ?? []
                let distinct = ids.distinct()
                let count = distinct.filter{$0 == travellerList[indexPath.row - 1].uid}.count
                if count > 0 {//不能删除已经有订单
                    cell.fillCell(name: travellerList[indexPath.row-1].name, index: indexPath,delFlag: false)
                }else {//能删除
                    cell.fillCell(name: travellerList[indexPath.row-1].name, index: indexPath,delFlag: true)
                }

                
            }
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }else if indexPath.section == 2{//出差单
            let cell = tableView.dequeueReusableCell(withIdentifier: flightTravelTableCellIdentify) as! FlightTravelTableCell
            
            var companyCode:String = ""
            if showDestionRow == 1 {
                companyCode = Toyota
            }
            
            cell.fillCell(model: coNewOrderCustomConfig, companyCode: companyCode)
            cell.fillCellData(model: travelModel)
            cell.oneCell.addOnClickListener(target: self, action: #selector(travelDateNewClick(tap: )))
            cell.twoCell.addOnClickListener(target: self, action: #selector(travelDateNewClick(tap: )))
            cell.fourCell.addOnClickListener(target: self, action: #selector(travelTargetClick(tap: )))
            cell.cityContentLabel.rx.text.orEmpty.bind(to: travelModel.destinations[0]).addDisposableTo(disposeBag)
            cell.reasonContentLabel.rx.text.orEmpty.bind(to: travelModel.reason).addDisposableTo(disposeBag)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }else if indexPath.section == 3 {//成本中心
//            let cell = FlightCostCenterTableCell()
//            cell.fillCell(content: costCenterList[indexPath.row], index: indexPath)
//            cell.selectionStyle = UITableViewCellSelectionStyle.none
//            return cell
            let cell = NewFlightCostCenterTableCell()
            cell.selectionStyle = UITableViewCellSelectionStyle.none
//            cell.titleLabel.addOnClickListener(target: self, action: #selector(flightCostCenterNewClick(tap: )))
            return cell
        }else if indexPath.section == 4{
            let cell = tableView.dequeueReusableCell(withIdentifier: flightCustomTableCellIdentify) as! FlightCustomTableCell
            cell.fillCell(model: coNewOrderCustomConfig?.customFields[indexPath.row], index: indexPath)
//            if !(travelModel.opinions?.isEmpty ?? true) {
//                cell.fillCell(model: travelModel.opinions?[indexPath.row])
//            }
            
            cell.contentField.rx.text.orEmpty.bind(to: (coNewOrderCustomConfig?.customFields[indexPath.row].value)!).addDisposableTo(disposeBag)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
        let cell = FlightCustomTableCell()
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 {
            
            
            return CGFloat(220 - showDestionRow * 44)
        }
        return 44
    }
    
    // MARK: 点击cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0 {//添加人
                let vc = HotelCompanyStaffViewController()
                vc.hotelCompanyStaffViewType = .NewOrder
                vc.reloadDataSources(dataSources: travellerList)
                vc.companyStaffViewNewOrderSelectedResult = { (flag) in
                    if flag {
                        self.travellerList = PassengerManager.shareInStance.passengerDraw()//searchTravellerResult
                        tableView.reloadSections([1], with: UITableViewRowAnimation.automatic)
                    }
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }else {//删除人
                var ids:[String] = []
                ids += coNewOrderDetail?.flightItems.map{ $0.passengers.map{ $0.id } }.flatMap{ $0 } ?? []
                ids += coNewOrderDetail?.hotelItems.map{ $0.passengers.map{ $0.id } }.flatMap{ $0 } ?? []
                let distinct = ids.distinct()
                let count = distinct.filter{$0 == travellerList[indexPath.row - 1].uid}.count
                if count > 0 {
                    //self.alertView(title: "提示", message: "该用户已创建订单不能删除!")
                    return
                }

                travellerList.remove(at: indexPath.row - 1)
                tableView.reloadSections([1], with: UITableViewRowAnimation.automatic)
            }
        }
        
        if indexPath.section == 4 {
            let type = [1,2,3] // 1,2,3是选择类型
            if type.contains(coNewOrderCustomConfig?.customFields[indexPath.row].type.rawValue ?? 0) {
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
        if indexPath.section == 3{
            flightCostCenterNewClick()
        }
    }
    
    
    //出差时间
    func travelDateClick(tap:UITapGestureRecognizer){
        
        let index = IndexPath(row: 0, section:  2)
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
        
        let index = IndexPath(row: 0, section:  2)
        let cell = self.tableView.cellForRow(at: index) as? FlightTravelTableCell
        let startDate = cell?.startDateContentLabel.text != "" ? cell?.startDateContentLabel.text:(DateInRegion()+3.day).string(custom: "yyyy-MM-dd")
        let endDate = cell?.endDateContentLabel.text != "" ? cell?.startDateContentLabel.text:(DateInRegion()+8.day).string(custom: "yyyy-MM-dd")
        
        let vc:TBICalendarViewController = TBICalendarViewController()
        vc.calendarAlertType = TBICalendarAlertType.Travel
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
        let index = IndexPath(row: 0, section:  2)
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


}
