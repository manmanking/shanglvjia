//
//  ApprovalOrderDetailViewController.swift
//  shanglvjia
//
//  Created by manman on 2018/5/18.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import RxSwift
import MJExtension

class ApprovalOrderDetailViewController: CompanyBaseViewController,UITableViewDelegate,UITableViewDataSource {

    let bag = DisposeBag()
    public var approvalId:String = ""
    
    public var orderState:CoExamineState? = nil
    
    private let tableView:UITableView = UITableView()
    private var tableViewBaseInfoCellIdentify:String = "tableViewBaseInfoCellIdentify"
    private var tableViewFlightInfoCellIdentify:String = "tableViewFlightInfoCellIdentify"
    private var tableViewDetailChargeCellIdentify:String = "tableViewDetailChargeCellIdentify"
    private var tableViewDetailPassengerCellIdentify:String = "tableViewDetailPassengerCellIdentify"
    private var tableViewDetailSubordersTableViewCellIdentify:String = "tableViewDetailSubordersTableViewCellIdentify"
    private var tableViewDetailTrainInfoCellIdentify:String = "tableViewDetailTrainInfoCellIdentify"
    
    private var tableViewCellIdentify:String = "tableViewCellIdentify"
    
    private let bottomAllAgreeTipDefault:String = "通过全部订单"
    private let bottomAllDisagreeTipDefault:String = "拒绝全部订单"
    
    private var offsetY:CGFloat = 0
    
    
    
    private var approveDetailResponseVO:ApproveDetailResponseVO = ApproveDetailResponseVO()
    
    private var tableViewDataSources:[(title:String,content:String)] = Array()
    private var tableViewOrdersDataSources:[(title:String,contentType:ApprovalDeitailSubordersType)] = Array()
    
    private var tableViewTicketInfoDataSources:[(title: String, content: String, right: String)] = Array()
    private var baseInfoDataSources:[(title: String, content: String, right: String)] = Array()
    private var contactPersonalDataSources:[(title: String, content: String, right: String)] = Array()
    private var applyInfoDataSources:[(title: String, content: String, right: String)] = Array()
    private var spendingInfoDataSources:[(title: String, content: String, right: String)] = Array()
    private var approvalInfoDataSources:[(title: String, content: String, right: String)] = Array()
    private var passengerInfoDataSources:[ApproveDetailResponseVO.PassengerResponse] = Array()
    
    private var flightOrderDetail:ApproveDetailResponseVO.ApprovalOrderDetail?
    
    private var trainOrderDetail:ApproveDetailResponseVO.ApprovalOrderDetail?
    
    private var bottomBackgroundView:UIView = UIView()
    
    
    /// 审批记录 1 显示。0 不显示
    private var approvalSection:NSInteger = 1
    
    /// 当前显示的订单
    private var selectedShowOrder:String = ""
    
    /// 默认 是 机票类型
    private var selectedShowOrderType:ApprovalDeitailSubordersType = ApprovalDeitailSubordersType.Flight
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle(titleStr: "审批单详情", titleColor: TBIThemePrimaryTextColor)
        setNavigationBackButton(backImage: "left")
        setUIViewAutolayout()
        //fillLocalDataSources()
        getApprocalDetail()
    }
    
    func setUIViewAutolayout() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.register(ApprovalDetalBaseInfoTableViewCell.self, forCellReuseIdentifier:tableViewBaseInfoCellIdentify)
        tableView.register(ApprovalDetailFlightInfoTableViewCell.self, forCellReuseIdentifier: tableViewFlightInfoCellIdentify)
        tableView.register(ApprovalDetailChargeTableViewCell.self, forCellReuseIdentifier: tableViewDetailChargeCellIdentify)
        tableView.register(ApprovalDetailPassengerTableViewCell.self, forCellReuseIdentifier:tableViewDetailPassengerCellIdentify)
        tableView.register(ApprovalDetailSubordersTableViewCell.self, forCellReuseIdentifier: tableViewDetailSubordersTableViewCellIdentify)
        tableView.register(ApprovalDetailTrainInfoTableViewCell.self, forCellReuseIdentifier: tableViewDetailTrainInfoCellIdentify)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableViewCellIdentify)
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        self.view.addSubview(bottomBackgroundView)
        bottomBackgroundView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(56)
        }
        setBottomBackgroundView()
        bottomBackgroundView.isHidden = true
        if  orderState == CoExamineState.waitApproval {
            bottomBackgroundView.isHidden = false
        }
        
    }
    func setBottomBackgroundView() {
        let firstButton:UIButton  = UIButton()
        firstButton.setTitle(bottomAllAgreeTipDefault, for: UIControlState.normal)
        firstButton.setTitleColor(TBIThemeWhite, for: UIControlState.normal)
        firstButton.backgroundColor = TBIThemeGreenColor
        firstButton.addTarget(self, action: #selector(agreeAllApprovalOrder(sender:)), for: UIControlEvents.touchUpInside)
        bottomBackgroundView.addSubview(firstButton)
        firstButton.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
        }
        let secondButton:UIButton  = UIButton()
        secondButton.setTitle(bottomAllDisagreeTipDefault, for: UIControlState.normal)
        secondButton.addTarget(self, action: #selector(agreeAllApprovalOrder(sender:)), for: UIControlEvents.touchUpInside)
        secondButton.setTitleColor(TBIThemeRedColor, for: UIControlState.normal)
        secondButton.backgroundColor = TBIThemeWhite
        bottomBackgroundView.addSubview(secondButton)
        secondButton.snp.makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
        }
    }
    
    
    
    func fillLocalDataSources() {
        tableViewDataSources = [("基本信息",""),("航班信息",""),("费用明细",""),("乘机人",""),("联系人",""),("申请单",""),("审批记录","")]
        tableView.reloadData()
    }
    
    func separateDataSources() {
        approvalDetailSubOrder()
        selectedShowOrder = tableViewOrdersDataSources.first?.title ?? ""
        selectedShowOrderType = tableViewOrdersDataSources.first?.contentType ?? ApprovalDeitailSubordersType.Flight
        changeShowOrderDetail(selectedOrder: selectedShowOrder)
    }
    
    func approvalDetailSubOrder() {
        if approveDetailResponseVO.carResponses?.count ?? 0 > 0 {
            for element in approveDetailResponseVO.carResponses! {
                let tmpDataSources:(title:String,contentType:ApprovalDeitailSubordersType) = (element.orderNo,ApprovalDeitailSubordersType.Car)
                tableViewOrdersDataSources.append(tmpDataSources)
            }
            
        }
        if approveDetailResponseVO.flightResponses?.count ?? 0 > 0 {
            for element in approveDetailResponseVO.flightResponses! {
                let tmpDataSources:(title:String,contentType:ApprovalDeitailSubordersType) = (element.orderNo,ApprovalDeitailSubordersType.Flight)
                tableViewOrdersDataSources.append(tmpDataSources)
            }
        }
        if approveDetailResponseVO.hotelResponses?.count ?? 0 > 0 {
            for element in approveDetailResponseVO.hotelResponses! {
                let tmpDataSources:(title:String,contentType:ApprovalDeitailSubordersType) = (element.orderNo,ApprovalDeitailSubordersType.Hotel)
                tableViewOrdersDataSources.append(tmpDataSources)
            }
        }
        if approveDetailResponseVO.trainResponses?.count ?? 0 > 0 {
            for element in approveDetailResponseVO.trainResponses! {
                let tmpDataSources:(title:String,contentType:ApprovalDeitailSubordersType) = (element.orderNo,ApprovalDeitailSubordersType.Train)
                tableViewOrdersDataSources.append(tmpDataSources)
            }
        }
        
    }
    
    
    //MARK:------基本信息----------
    func separateBaseInfoDataSources(orderType:ApprovalDeitailSubordersType,selectedOrder:String) {
        
        switch orderType {
        case .Flight:
            adjustFlightBaseinfo(selectedOrder: selectedOrder)
        case .Hotel:
            adjustHotelBaseinfo(selectedOrder: selectedOrder)
        case .Train:
            adjustTrainBaseinfo(selectedOrder: selectedOrder)
        case .Car:
            adjustCarBaseinfo(selectedOrder: selectedOrder)
            
        default:
            break
        }

    }
    
    func adjustFlightBaseinfo(selectedOrder:String) {
        guard selectedOrder.isEmpty == false && approveDetailResponseVO.flightResponses?.count ?? 0 > 0 else {
            return
        }
        
        var approvalOrderDetail:ApproveDetailResponseVO.ApprovalOrderDetail =  ApproveDetailResponseVO.ApprovalOrderDetail()
        
        for element in approveDetailResponseVO.flightResponses! {
            if element.orderNo == selectedOrder {
                approvalOrderDetail = element
                break
            }
        }
        approvalOrderDetail.accordPolicy = approvalOrderDetail.accordPolicy == "1" ? "0" : "1"
        adjustBaseInfo(selectedOrderDetail: approvalOrderDetail)
        
    }
    func adjustHotelBaseinfo(selectedOrder:String) {
        guard selectedOrder.isEmpty == false && approveDetailResponseVO.hotelResponses?.count ?? 0 > 0 else {
            return
        }
        
        var approvalOrderDetail:ApproveDetailResponseVO.ApprovalOrderDetail =  ApproveDetailResponseVO.ApprovalOrderDetail()
        
        for element in approveDetailResponseVO.hotelResponses! {
            if element.orderNo == selectedOrder {
                approvalOrderDetail = element
                break
            }
        }
        adjustBaseInfo(selectedOrderDetail: approvalOrderDetail)
    }
    func adjustTrainBaseinfo(selectedOrder:String) {
        guard selectedOrder.isEmpty == false && approveDetailResponseVO.trainResponses?.count ?? 0 > 0 else {
            return
        }
        
        var approvalOrderDetail:ApproveDetailResponseVO.ApprovalOrderDetail =  ApproveDetailResponseVO.ApprovalOrderDetail()
        
        for element in approveDetailResponseVO.trainResponses! {
            if element.orderNo == selectedOrder {
                approvalOrderDetail = element
                break
            }
        }
        adjustBaseInfo(selectedOrderDetail: approvalOrderDetail)
    }
    func adjustCarBaseinfo(selectedOrder:String) {
        guard selectedOrder.isEmpty == false && approveDetailResponseVO.carResponses?.count ?? 0 > 0 else {
            return
        }
        
        var approvalOrderDetail:ApproveDetailResponseVO.ApprovalOrderDetail =  ApproveDetailResponseVO.ApprovalOrderDetail()
        
        for element in approveDetailResponseVO.carResponses! {
            if element.orderNo == selectedOrder {
                approvalOrderDetail = element
                break
            }
        }
        approvalOrderDetail.accordPolicy = "1"
        adjustBaseInfo(selectedOrderDetail: approvalOrderDetail)
    }
    
    func adjustBaseInfo(selectedOrderDetail:ApproveDetailResponseVO.ApprovalOrderDetail) {
        baseInfoDataSources.removeAll()
        baseInfoDataSources.append(("基本信息","",""))
        if selectedOrderDetail.orderNo.isNotEmpty{
             baseInfoDataSources.append(("订单单号",selectedOrderDetail.orderNo ,""))
        }
        if selectedOrderDetail.createTime.isNotEmpty{
            baseInfoDataSources.append(("创建时间",selectedOrderDetail.createTime ,""))
        }
        if selectedOrderDetail.costCenter.isNotEmpty{
            baseInfoDataSources.append(("成本中心",selectedOrderDetail.costCenter ,""))
        }
        if selectedOrderDetail.contactName.isNotEmpty{
             baseInfoDataSources.append(("预订人",selectedOrderDetail.contactName ,""))
        }
        baseInfoDataSources.append(("差旅标准",selectedOrderDetail.accordPolicy == "1" ? "符合" : "违背  " + selectedOrderDetail.disPolicyReason ,""))
    }
    
    //MARK:------票务信息----------
    
    func separateTicketInfoDataSources(orderType:ApprovalDeitailSubordersType,selectedOrder:String) {
        
        switch orderType {
        case .Flight:
            adjustFlightTicketInfo(selectedOrder: selectedOrder)
        case .Hotel:
            adjustHotelTicketInfo(selectedOrder: selectedOrder)
        case .Train:
            adjustTrainTicketInfo(selectedOrder: selectedOrder)
        case .Car:
            adjustCarTicketInfo(selectedOrder: selectedOrder)
            
        default:
            break
        }
        
    }
    
    func adjustFlightTicketInfo(selectedOrder:String)  {
        guard selectedOrder.isEmpty == false && approveDetailResponseVO.flightResponses?.count ?? 0 > 0 else {
            return
        }
        
        for element in approveDetailResponseVO.flightResponses! {
            if element.orderNo == selectedOrder {
                flightOrderDetail = element
                break
            }
        }
        
        
        
        
    }
    
    func adjustTrainTicketInfo(selectedOrder:String)  {
        guard selectedOrder.isEmpty == false && approveDetailResponseVO.trainResponses?.count ?? 0 > 0 else {
            return
        }
        
        for element in approveDetailResponseVO.trainResponses! {
            if element.orderNo == selectedOrder {
                trainOrderDetail = element
                break
            }
        }
        
        
    }
    
    
    
    
    
    func adjustHotelTicketInfo(selectedOrder:String) {
        
        guard selectedOrder.isEmpty == false && approveDetailResponseVO.hotelResponses?.count ?? 0 > 0 else {
            return
        }
        
        var approvalOrderDetail:ApproveDetailResponseVO.ApprovalOrderDetail =  ApproveDetailResponseVO.ApprovalOrderDetail()
        
        for element in approveDetailResponseVO.hotelResponses! {
            if element.orderNo == selectedOrder {
                approvalOrderDetail = element
                break
            }
        }
        adjustHotelInfo(selectedOrderDetail:approvalOrderDetail)
        
        
        
        
    }
    func adjustCarTicketInfo(selectedOrder: String) {
        guard selectedOrder.isEmpty == false && approveDetailResponseVO.carResponses?.count ?? 0 > 0 else {
            return
        }
        
        var approvalOrderDetail:ApproveDetailResponseVO.ApprovalOrderDetail =  ApproveDetailResponseVO.ApprovalOrderDetail()
        
        for element in approveDetailResponseVO.carResponses! {
            if element.orderNo == selectedOrder {
                approvalOrderDetail = element
                break
            }
        }
        adjustCarInfo(selectedOrderDetail: approvalOrderDetail)
        
    }
    
    // 酒店信息
    func adjustHotelInfo(selectedOrderDetail:ApproveDetailResponseVO.ApprovalOrderDetail) {
        tableViewTicketInfoDataSources.removeAll()
        
        tableViewTicketInfoDataSources.append(("入住信息","",""))
        tableViewTicketInfoDataSources.append(("酒店名称",selectedOrderDetail.hotelName, ""))
        tableViewTicketInfoDataSources.append(("预订房型",selectedOrderDetail.roomType, ""))
        tableViewTicketInfoDataSources.append(("房间数量",selectedOrderDetail.passengers.count.description + "间", ""))
        
        tableViewTicketInfoDataSources.append(("入离时间",selectedOrderDetail.tripStart + "至" + selectedOrderDetail.tripEnd ,""))
        var passengerName:String = ""
        for element in selectedOrderDetail.passengers {
            passengerName += element.passengerName
            passengerName += ","
        }
        if passengerName.isEmpty == false {
            passengerName.remove(at: passengerName.index(before: passengerName.endIndex))
        }
        
        tableViewTicketInfoDataSources.append(("入住人",passengerName,""))
        tableViewTicketInfoDataSources.append(("最晚到店",selectedOrderDetail.latestArrivalTime, ""))
        
        var speArr = [String]()
        //遍历passengers
        for i in 0...(selectedOrderDetail.passengers.count)-1
        {
            if (selectedOrderDetail.passengers[i].special).isNotEmpty
            {
                speArr.append((selectedOrderDetail.passengers[i].special))
            }
        }
        tableViewTicketInfoDataSources.append(("特殊要求",speArr.count == 0 ? "无":speArr[0],""))
        
    }
    
    
    /// 专车信息
    func adjustCarInfo(selectedOrderDetail:ApproveDetailResponseVO.ApprovalOrderDetail) {
        tableViewTicketInfoDataSources.removeAll()
        tableViewTicketInfoDataSources.append(("专车信息","",""))
        tableViewTicketInfoDataSources.append(("用车类型",selectedOrderDetail.orderTypeCH,""))
        tableViewTicketInfoDataSources.append(("预约用车",selectedOrderDetail.carTypeCH,""))
        tableViewTicketInfoDataSources.append(("用车时间",selectedOrderDetail.startTime,""))
        tableViewTicketInfoDataSources.append(("上车地点",selectedOrderDetail.startAddress,""))
        tableViewTicketInfoDataSources.append(("下车地点",selectedOrderDetail.endAddress,""))
    }
    
    
    
    //MARK:-------费用明细-------
    func separateSpendingDetailDataSources(orderType:ApprovalDeitailSubordersType,selectedOrder:String) {
        switch orderType {
        case .Flight:
            adjustFlightSpendingDetailDataSources(selectedOrder: selectedOrder)
        case .Hotel:
            adjustHotelSpendingDetailDataSources(selectedOrder: selectedOrder)
        case .Train:
            adjustTrainSpendingDetailDataSources(selectedOrder: selectedOrder)
        case .Car:
            break
        default:
            break
        }
        
        
        
       
    }
    
    /// 机票费用明细
    func adjustFlightSpendingDetailDataSources(selectedOrder: String) {
        
        guard selectedOrder.isEmpty == false && approveDetailResponseVO.flightResponses?.count ?? 0 > 0 else {
            return
        }
        
        var approvalOrderDetail:ApproveDetailResponseVO.ApprovalOrderDetail =  ApproveDetailResponseVO.ApprovalOrderDetail()
        
        for element in approveDetailResponseVO.flightResponses! {
            if element.orderNo == selectedOrder {
                approvalOrderDetail = element
                break
            }
        }
        
        spendingInfoDataSources.removeAll()
        spendingInfoDataSources.append(("费用明细","",""))
        
        for i in 0...approvalOrderDetail.passengers.count - 1{
            if approvalOrderDetail.passengers[i].type == "0"
            {
                spendingInfoDataSources.append(("票价(\(approvalOrderDetail.passengers[i].psgName))", "X" + approvalOrderDetail.passengers.count.description ,"¥" + approvalOrderDetail.passengers[i].unitFare ))
                spendingInfoDataSources.append(("机建(\(approvalOrderDetail.passengers[i].psgName))","X" + approvalOrderDetail.passengers.count.description,"¥" + approvalOrderDetail.passengers[i].ocTax))
                if approvalOrderDetail.passengers[i].tcTax != "0"
                {
                    spendingInfoDataSources.append(("燃油费(\(approvalOrderDetail.passengers[i].psgName))","X" + approvalOrderDetail.passengers.count.description,"¥" + approvalOrderDetail.passengers[i].tcTax ))
                }
                if approvalOrderDetail.passengers[i].surances.count > 0 && approvalOrderDetail.passengers[i].surances[0].first == true{
                    spendingInfoDataSources.append(("保险(\(approvalOrderDetail.passengers[i].psgName))","X" + approvalOrderDetail.passengers.count.description,"¥" + (approvalOrderDetail.passengers[i].surances.first?.price)! ))
                }
            }
            
            if approvalOrderDetail.passengers[i].type == "2"
            {
                spendingInfoDataSources.append(("票价(\(approvalOrderDetail.passengers[i].psgName))", "X" + approvalOrderDetail.passengers.count.description ,"¥" + approvalOrderDetail.passengers[i].unitFare ))
                spendingInfoDataSources.append(("机建(\(approvalOrderDetail.passengers[i].psgName))","X" + approvalOrderDetail.passengers.count.description,"¥" + approvalOrderDetail.passengers[i].ocTax))
                if approvalOrderDetail.passengers[i].surances.count > 0 && approvalOrderDetail.passengers[i].surances[0].first == true{
                    spendingInfoDataSources.append(("保险(\(approvalOrderDetail.passengers[i].psgName))","X" + approvalOrderDetail.passengers.count.description,"¥" + (approvalOrderDetail.passengers[i].surances.first?.price)! ))
                }
                if approvalOrderDetail.passengers[i].tcTax != "0"
                {
                    spendingInfoDataSources.append(("燃油费(\(approvalOrderDetail.passengers[i].psgName))","X" + approvalOrderDetail.passengers.count.description,"¥" + approvalOrderDetail.passengers[i].tcTax ))
                }
                var gaiMoney : Double = 0
                for index in 0...(approvalOrderDetail.passengers[i].alters.count)-1{
                    gaiMoney += Double(approvalOrderDetail.passengers[i].alters[index].extraTotal)!
                 }
                spendingInfoDataSources.append(("改签费(\(approvalOrderDetail.passengers[i].psgName))","X" + approvalOrderDetail.passengers.count.description,"¥" + gaiMoney.description))
            }
            
            if approvalOrderDetail.passengers[i].type == "1"
            {
                if approvalOrderDetail.passengers[i].surances.count > 0 && approvalOrderDetail.passengers[i].surances[0].first == true{
                    spendingInfoDataSources.append(("保险(\(approvalOrderDetail.passengers[i].psgName))","X" + approvalOrderDetail.passengers.count.description,"¥" + (approvalOrderDetail.passengers[i].surances.first?.price)! ))
                }
                 spendingInfoDataSources.append(("退票费(\(approvalOrderDetail.passengers[i].psgName))","X" + approvalOrderDetail.passengers.count.description,"¥" + approvalOrderDetail.passengers[i].refund.extraPrice))
            }
             if approvalOrderDetail.passengers[i].type == "3"
             {
                if approvalOrderDetail.passengers[i].surances.count > 0 && approvalOrderDetail.passengers[i].surances[0].first == true{
                    spendingInfoDataSources.append(("保险(\(approvalOrderDetail.passengers[i].psgName))","X" + approvalOrderDetail.passengers.count.description,"¥" + (approvalOrderDetail.passengers[i].surances.first?.price)! ))
                }
                var gaiMoney : Double = 0
                for index in 0...(approvalOrderDetail.passengers[i].alters.count)-1
                {
                    gaiMoney += Double(approvalOrderDetail.passengers[i].alters[index].extraTotal)!
                }
                spendingInfoDataSources.append(("改签费(\(approvalOrderDetail.passengers[i].psgName))","X" + approvalOrderDetail.passengers.count.description,"¥" + gaiMoney.description))
                spendingInfoDataSources.append(("退票费(\(approvalOrderDetail.passengers[i].psgName))","X" + approvalOrderDetail.passengers.count.description,"¥" + approvalOrderDetail.passengers[i].refund.extraPrice))
             }
                
            
        }
        
        
        spendingInfoDataSources.append(("","","¥" + approvalOrderDetail.money ))
    }
    /// 酒店费用明细
    func adjustHotelSpendingDetailDataSources(selectedOrder: String) {
        guard selectedOrder.isEmpty == false && approveDetailResponseVO.hotelResponses?.count ?? 0 > 0 else {
            return
        }
        
        var approvalOrderDetail:ApproveDetailResponseVO.ApprovalOrderDetail =  ApproveDetailResponseVO.ApprovalOrderDetail()
        
        for element in approveDetailResponseVO.hotelResponses! {
            if element.orderNo == selectedOrder {
                approvalOrderDetail = element
                break
            }
        }
        
        
        spendingInfoDataSources.removeAll()
        spendingInfoDataSources.append(("费用明细","",""))
        for element in approvalOrderDetail.priceDetail {
            let timeInterval:TimeInterval  = TimeInterval.init(Float(element.date) ?? 1.0) / 1000
            let tmpDate:Date = Date.init(timeIntervalSince1970: timeInterval)
            let tmpDateStr = tmpDate.string(custom: "MM-dd")
            spendingInfoDataSources.append((tmpDateStr,approvalOrderDetail.meal,"¥" + element.memberRate.description))
        }
        spendingInfoDataSources.append(("","","¥" + approvalOrderDetail.money))
        
    }
    /// 火车票费用明细
    func adjustTrainSpendingDetailDataSources(selectedOrder: String) {
        guard selectedOrder.isEmpty == false && approveDetailResponseVO.trainResponses?.count ?? 0 > 0 else {
            return
        }
        
        var approvalOrderDetail:ApproveDetailResponseVO.ApprovalOrderDetail =  ApproveDetailResponseVO.ApprovalOrderDetail()
        
        for element in approveDetailResponseVO.trainResponses! {
            if element.orderNo == selectedOrder {
                approvalOrderDetail = element
                break
            }
        }
        spendingInfoDataSources.removeAll()
        spendingInfoDataSources.append(("费用明细","",""))
        for element in approvalOrderDetail.passengers {
            spendingInfoDataSources.append((element.siteInfo,"", "¥" + element.money))
        }
        spendingInfoDataSources.append(("","","¥" +  approvalOrderDetail.money ?? ""))
        
    }
    
    //MARK:-------乘车人---------
    func separatePassengerInfoDataSources(orderType:ApprovalDeitailSubordersType,selectedOrder:String){
        
        switch orderType {
        case .Flight:
            adjustFlightPassengerInfoDataSources(selectedOrder: selectedOrder)
        case .Train:
            adjustTrainPassengerInfoDataSources(selectedOrder: selectedOrder)
        case .Car,.Hotel:
            break
        default:
            break
        }
        
        
    }
    /// 机票乘车人
    func adjustFlightPassengerInfoDataSources(selectedOrder: String) {
        guard selectedOrder.isEmpty == false && approveDetailResponseVO.flightResponses?.count ?? 0 > 0 else {
            return
        }
        
        var approvalOrderDetail:ApproveDetailResponseVO.ApprovalOrderDetail =  ApproveDetailResponseVO.ApprovalOrderDetail()
        
        for element in approveDetailResponseVO.flightResponses! {
            if element.orderNo == selectedOrder {
                approvalOrderDetail = element
                break
            }
        }
       adjustPassengerInfoDataSources(selectedOrderDetail: approvalOrderDetail)
    }
    
    
    
    
    /// 火车票乘车人
    func adjustTrainPassengerInfoDataSources(selectedOrder: String) {
        guard selectedOrder.isEmpty == false && approveDetailResponseVO.trainResponses?.count ?? 0 > 0 else {
            return
        }
        
        var approvalOrderDetail:ApproveDetailResponseVO.ApprovalOrderDetail =  ApproveDetailResponseVO.ApprovalOrderDetail()
        
        for element in approveDetailResponseVO.trainResponses! {
            if element.orderNo == selectedOrder {
                approvalOrderDetail = element
                break
            }
        }
        
        adjustPassengerInfoDataSources(selectedOrderDetail: approvalOrderDetail)
    }
    
    
    /// 乘车人
    func adjustPassengerInfoDataSources(selectedOrderDetail: ApproveDetailResponseVO.ApprovalOrderDetail) {
        guard selectedOrderDetail.passengers.count > 0 else {
            return
        }
        passengerInfoDataSources.removeAll()
        for element in selectedOrderDetail.passengers {
            passengerInfoDataSources.append(element)
        }
    }
    
    //MARK:------联系人------
    func separateContactPersonalDataSources(orderType:ApprovalDeitailSubordersType,selectedOrder:String) {
        
        switch orderType {
        case .Flight:
            adjustFlightContactPersonalDataSources(selectedOrder: selectedOrder)
        case .Hotel:
            adjustHotelContactPersonalDataSources(selectedOrder: selectedOrder)
        case .Train:
            adjustTrainContactPersonalDataSources(selectedOrder: selectedOrder)
        case .Car:
            adjustCarContactPersonalDataSources(selectedOrder: selectedOrder)
        default:
            break
        }
        
    }
    
    /// 机票联系人
    func adjustFlightContactPersonalDataSources (selectedOrder: String) {
        guard selectedOrder.isEmpty == false && approveDetailResponseVO.flightResponses?.count ?? 0 > 0 else {
            return
        }
        
        var approvalOrderDetail:ApproveDetailResponseVO.ApprovalOrderDetail =  ApproveDetailResponseVO.ApprovalOrderDetail()
        for element in approveDetailResponseVO.flightResponses! {
            if element.orderNo == selectedOrder {
                approvalOrderDetail = element
                break
            }
        }
      adjustContactPersonalDataSources(selectedOrderDetail:approvalOrderDetail)
    }
    /// 酒店联系人
    func adjustHotelContactPersonalDataSources (selectedOrder: String) {
        guard selectedOrder.isEmpty == false && approveDetailResponseVO.hotelResponses?.count ?? 0 > 0 else {
            return
        }
        
        var approvalOrderDetail:ApproveDetailResponseVO.ApprovalOrderDetail =  ApproveDetailResponseVO.ApprovalOrderDetail()
        for element in approveDetailResponseVO.hotelResponses! {
            if element.orderNo == selectedOrder {
                approvalOrderDetail = element
                break
            }
        }
       adjustContactPersonalDataSources(selectedOrderDetail:approvalOrderDetail)
    }
    /// 火车票联系人
    func adjustTrainContactPersonalDataSources (selectedOrder: String) {
        guard selectedOrder.isEmpty == false && approveDetailResponseVO.trainResponses?.count ?? 0 > 0 else {
            return
        }
        
        var approvalOrderDetail:ApproveDetailResponseVO.ApprovalOrderDetail =  ApproveDetailResponseVO.ApprovalOrderDetail()
        for element in approveDetailResponseVO.trainResponses! {
            if element.orderNo == selectedOrder {
                approvalOrderDetail = element
                break
            }
        }
       adjustContactPersonalDataSources(selectedOrderDetail:approvalOrderDetail)
    }
    /// 专车联系人
    func adjustCarContactPersonalDataSources (selectedOrder: String) {
        guard selectedOrder.isEmpty == false && approveDetailResponseVO.carResponses?.count ?? 0 > 0 else {
            return
        }
        
        var approvalOrderDetail:ApproveDetailResponseVO.ApprovalOrderDetail =  ApproveDetailResponseVO.ApprovalOrderDetail()
        for element in approveDetailResponseVO.carResponses! {
            if element.orderNo == selectedOrder {
                approvalOrderDetail = element
                break
            }
        }
      adjustContactPersonalDataSources(selectedOrderDetail:approvalOrderDetail)
    }
    /// 联系人
    func adjustContactPersonalDataSources(selectedOrderDetail:ApproveDetailResponseVO.ApprovalOrderDetail) {
    
        contactPersonalDataSources.removeAll()
        contactPersonalDataSources.append(("联系人","",""))
        if selectedOrderDetail.contactName.isNotEmpty{
            contactPersonalDataSources.append(("姓名",selectedOrderDetail.contactName ,""))
        }
        if selectedOrderDetail.contactPhone .isNotEmpty{
            contactPersonalDataSources.append(("手机号码",selectedOrderDetail.contactPhone ,""))
        }
        if selectedOrderDetail.contactEmail.isNotEmpty{
             contactPersonalDataSources.append(("邮箱",selectedOrderDetail.contactEmail ,""))
        }
    }
    
    //MARK:------申请单------
    func separateApplyInfoDataSources(orderType:ApprovalDeitailSubordersType,selectedOrder:String) {
        
        switch orderType {
        case .Flight:
            adjustFlightApplyInfoDataSources(selectedOrder: selectedOrder)
        case .Hotel:
            adjustHotelApplyInfoDataSources(selectedOrder: selectedOrder)
        case .Train:
            adjustTrainApplyInfoDataSources(selectedOrder: selectedOrder)
        case .Car:
            adjustCarApplyInfoDataSources(selectedOrder: selectedOrder)
        default:
            break
        }
    }
    /// 机票 申请单
    func adjustFlightApplyInfoDataSources(selectedOrder:String) {
        guard selectedOrder.isEmpty == false && approveDetailResponseVO.flightResponses?.count ?? 0 > 0 else {
            return
        }
        
        var approvalOrderDetail:ApproveDetailResponseVO.ApprovalOrderDetail =  ApproveDetailResponseVO.ApprovalOrderDetail()
        for element in approveDetailResponseVO.flightResponses! {
            if element.orderNo == selectedOrder {
                approvalOrderDetail = element
                break
            }
        }
        adjustApplyInfoDataSources(selectedOrderDetail:approvalOrderDetail)
    }
    /// 酒店 申请单
    func adjustHotelApplyInfoDataSources(selectedOrder:String) {
        guard selectedOrder.isEmpty == false && approveDetailResponseVO.hotelResponses?.count ?? 0 > 0 else {
            return
        }
        
        var approvalOrderDetail:ApproveDetailResponseVO.ApprovalOrderDetail =  ApproveDetailResponseVO.ApprovalOrderDetail()
        for element in approveDetailResponseVO.hotelResponses! {
            if element.orderNo == selectedOrder {
                approvalOrderDetail = element
                break
            }
        }
        adjustApplyInfoDataSources(selectedOrderDetail:approvalOrderDetail)
    }
    /// 火车票 申请单
    func adjustTrainApplyInfoDataSources(selectedOrder:String) {
        guard selectedOrder.isEmpty == false && approveDetailResponseVO.trainResponses?.count ?? 0 > 0 else {
            return
        }
        
        var approvalOrderDetail:ApproveDetailResponseVO.ApprovalOrderDetail =  ApproveDetailResponseVO.ApprovalOrderDetail()
        for element in approveDetailResponseVO.trainResponses! {
            if element.orderNo == selectedOrder {
                approvalOrderDetail = element
                break
            }
        }
        adjustApplyInfoDataSources(selectedOrderDetail:approvalOrderDetail)
    }
    
    /// 专车 申请单
    func adjustCarApplyInfoDataSources(selectedOrder:String) {
        guard selectedOrder.isEmpty == false && approveDetailResponseVO.carResponses?.count ?? 0 > 0 else {
            return
        }
        
        var approvalOrderDetail:ApproveDetailResponseVO.ApprovalOrderDetail =  ApproveDetailResponseVO.ApprovalOrderDetail()
        for element in approveDetailResponseVO.carResponses! {
            if element.orderNo == selectedOrder {
                approvalOrderDetail = element
                break
            }
        }
        adjustApplyInfoDataSources(selectedOrderDetail:approvalOrderDetail)
    }
    func adjustApplyInfoDataSources(selectedOrderDetail:ApproveDetailResponseVO.ApprovalOrderDetail) {
        
        var passengerName:String = ""
        
        for element in selectedOrderDetail.passengers {
            passengerName += element.passengerName
            passengerName += ","
        }
        if passengerName.isEmpty == false {
            passengerName.remove(at: passengerName.index(before: passengerName.endIndex))
        }
        if selectedShowOrderType == ApprovalDeitailSubordersType.Car {
            passengerName = selectedOrderDetail.psgName
        }
        
        
        if selectedShowOrderType == ApprovalDeitailSubordersType.Flight ||
            selectedShowOrderType == ApprovalDeitailSubordersType.Train {
            for element in selectedOrderDetail.passengers {
                passengerName += element.psgName
                passengerName += ","
            }
            if passengerName.isEmpty == false {
                passengerName.remove(at: passengerName.index(before: passengerName.endIndex))
            }
        }
        
        applyInfoDataSources.removeAll()
        applyInfoDataSources.append(("申请单","",""))
        if passengerName.isNotEmpty
        {
            applyInfoDataSources.append(("出差人",passengerName,""))
        }
        if selectedOrderDetail.travel.startTime.isNotEmpty
        {
            applyInfoDataSources.append(("出差时间",selectedOrderDetail.travel.startTime + "至" + selectedOrderDetail.travel.endTime,""))
        }
        if selectedOrderDetail.travel.address.isNotEmpty
        {
             applyInfoDataSources.append(("出差地点",selectedOrderDetail.travel.address ,""))
        }
        if selectedOrderDetail.travel.target .isNotEmpty
        {
        applyInfoDataSources.append(("出差目的",selectedOrderDetail.travel.target ,""))
        }
        if selectedOrderDetail.travel.reason.isNotEmpty
        {
              applyInfoDataSources.append(("出差事由",selectedOrderDetail.travel.reason ,""))
        }
      
    }
    
    
    //MARK:------审批记录------
    func separateApprovalInfoDataSources(orderType:ApprovalDeitailSubordersType,selectedOrder:String) {
        
        switch orderType {
        case .Flight:
            adjustFlightApprovalInfoDataSources(selectedOrder: selectedOrder)
        case .Hotel:
            adjustHotelApprovalInfoDataSources(selectedOrder: selectedOrder)
        case .Train:
            adjustTrainApprovalInfoDataSources(selectedOrder: selectedOrder)
        case .Car:
            adjustCarApprovalInfoDataSources(selectedOrder: selectedOrder)
        default:
            break
        }
    }
    /// 机票 审批记录
    func adjustFlightApprovalInfoDataSources(selectedOrder:String) {
        guard selectedOrder.isEmpty == false && approveDetailResponseVO.flightResponses?.count ?? 0 > 0 else {
            return
        }
        
        var approvalOrderDetail:ApproveDetailResponseVO.ApprovalOrderDetail =  ApproveDetailResponseVO.ApprovalOrderDetail()
        for element in approveDetailResponseVO.flightResponses! {
            if element.orderNo == selectedOrder {
                approvalOrderDetail = element
                break
            }
        }
        adjustApprovalInfoDataSources(selectedOrderDetail:approvalOrderDetail)
    }
    /// 酒店 审批记录
    func adjustHotelApprovalInfoDataSources(selectedOrder:String) {
        guard selectedOrder.isEmpty == false && approveDetailResponseVO.hotelResponses?.count ?? 0 > 0 else {
            return
        }
        
        var approvalOrderDetail:ApproveDetailResponseVO.ApprovalOrderDetail =  ApproveDetailResponseVO.ApprovalOrderDetail()
        for element in approveDetailResponseVO.hotelResponses! {
            if element.orderNo == selectedOrder {
                approvalOrderDetail = element
                break
            }
        }
        adjustApprovalInfoDataSources(selectedOrderDetail:approvalOrderDetail)
    }
    /// 火车票 审批记录
    func adjustTrainApprovalInfoDataSources(selectedOrder:String) {
        guard selectedOrder.isEmpty == false && approveDetailResponseVO.trainResponses?.count ?? 0 > 0 else {
            return
        }
        
        var approvalOrderDetail:ApproveDetailResponseVO.ApprovalOrderDetail =  ApproveDetailResponseVO.ApprovalOrderDetail()
        for element in approveDetailResponseVO.trainResponses! {
            if element.orderNo == selectedOrder {
                approvalOrderDetail = element
                break
            }
        }
        adjustApprovalInfoDataSources(selectedOrderDetail:approvalOrderDetail)
    }
    
    /// 专车 审批记录
    func adjustCarApprovalInfoDataSources(selectedOrder:String) {
        guard selectedOrder.isEmpty == false && approveDetailResponseVO.carResponses?.count ?? 0 > 0 else {
            return
        }
        
        var approvalOrderDetail:ApproveDetailResponseVO.ApprovalOrderDetail =  ApproveDetailResponseVO.ApprovalOrderDetail()
        for element in approveDetailResponseVO.carResponses! {
            if element.orderNo == selectedOrder {
                approvalOrderDetail = element
                break
            }
        }
        adjustApprovalInfoDataSources(selectedOrderDetail:approvalOrderDetail)
    }
    
    func adjustApprovalInfoDataSources(selectedOrderDetail:ApproveDetailResponseVO.ApprovalOrderDetail) {
        guard selectedOrderDetail.approves.count > 0 else {
            return
        }
        approvalInfoDataSources.removeAll()
        approvalInfoDataSources.append(("审批记录","",""))
        
        for element in selectedOrderDetail.approves  {
            let dateStr:String = stringTimeStampConversToDateFormatterString(timeStamp:element.approveTime , dateFormat:"YYYY-MM-dd HH:mm" )
            let approvalBank:String = element.apverLevel + "/" + element.apverName
            approvalInfoDataSources.append((dateStr,approvalBank,element.statusCH))
        }

        
    }
    func stringTimeStampConversToDateFormatterString(timeStamp:NSInteger ,dateFormat:String) -> String {
        guard timeStamp > 0 && dateFormat.isEmpty == false else {
            return ""
        }
        
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = dateFormat
        let dateStamp:TimeInterval = TimeInterval.init(timeStamp)
        let date:Date = Date.init(timeIntervalSince1970:dateStamp / 1000 )
        let result:String = dateFormatter.string(from: date)
        return result
 
    }
    
    
    
    enum ApprovalDeitailSubordersType:NSInteger {
        case Flight = 1
        case Car = 2
        case Train = 3
        case Hotel = 4
    }
    
    
    
    
    //MARK:------NET------
    func getApprocalDetail()  {
        weak var weakSelf = self
        CoNewExanimeService.sharedInstance
            .getApprovalDetail(approvalId:approvalId)
            .subscribe{ event in
                switch event{
                case .next(let e):
                    printDebugLog(message: e)
                    weakSelf?.approveDetailResponseVO = e
                    weakSelf?.separateDataSources()
                case .error(let e):
                        try? weakSelf?.validateHttp(e)
                case .completed:
                    print("finish")
                }
            }.addDisposableTo((weakSelf?.bag)!)
        
        
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard  orderState == CoExamineState.waitApproval else {
            return
        }
        let contentOffsetY = scrollView.contentOffset.y
        if contentOffsetY > offsetY {
            bottomBackgroundView.isHidden = true
        } else {
            bottomBackgroundView.isHidden = false
        }
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        offsetY = scrollView.contentOffset.y
    }
    
    
    
    
    //MARK:--------UITableViewDatasources------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedShowOrderType {
        case .Flight,.Train:
            return 7 + approvalSection
        case .Hotel:
            return 6  + approvalSection
        case .Car:
            return 5  + approvalSection
        default:
            return 0
        }
        //return tableViewDataSources.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        weak var weakSelf = self
        // 订单
        if indexPath.row == 0 {
            let suborderCell:ApprovalDetailSubordersTableViewCell = tableView.dequeueReusableCell(withIdentifier:tableViewDetailSubordersTableViewCellIdentify) as! ApprovalDetailSubordersTableViewCell
            suborderCell.fillLocalDataSources(order: tableViewOrdersDataSources,selectedOrder:selectedShowOrder)
            suborderCell.selectionStyle = UITableViewCellSelectionStyle.none
            suborderCell.approvalDetailSubordersTableViewCellSelectedBlock = { selectedOrder in
                weakSelf?.changeShowOrderDetail(selectedOrder: selectedOrder)
            }
            return suborderCell
        }
        if indexPath.row == 1 {
            let baseInfoCell:ApprovalDetalBaseInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier:tableViewBaseInfoCellIdentify) as! ApprovalDetalBaseInfoTableViewCell
            baseInfoCell.fillDataSources(dataSources: baseInfoDataSources)
            return baseInfoCell
        }
        if indexPath.row == 2 {
              // 机票信息
            if  selectedShowOrderType == ApprovalDeitailSubordersType.Flight  && approveDetailResponseVO.flightResponses?.count ?? 0  > 0{
                let flightInfoCell:ApprovalDetailFlightInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier:tableViewFlightInfoCellIdentify) as! ApprovalDetailFlightInfoTableViewCell
                flightInfoCell.selectionStyle = UITableViewCellSelectionStyle.none
                flightInfoCell.fillDataSources(flightTrip: flightOrderDetail!)
                return flightInfoCell
            }else if selectedShowOrderType == ApprovalDeitailSubordersType.Train  && approveDetailResponseVO.trainResponses?.count ?? 0  > 0 {
                //火车票
                
                let trainInfoCell:ApprovalDetailTrainInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier:tableViewDetailTrainInfoCellIdentify) as! ApprovalDetailTrainInfoTableViewCell
                trainInfoCell.fillDataSources(trainDetail:trainOrderDetail!)
                trainInfoCell.selectionStyle = UITableViewCellSelectionStyle.none
                return trainInfoCell
            } else { // 酒店 专车
                let baseInfoCell:ApprovalDetalBaseInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier:tableViewBaseInfoCellIdentify) as! ApprovalDetalBaseInfoTableViewCell
                baseInfoCell.selectionStyle = UITableViewCellSelectionStyle.none
                baseInfoCell.fillDataSources(dataSources:tableViewTicketInfoDataSources)
                return baseInfoCell
            }
        }
        var rowChargeCell:NSInteger = 0
        if  selectedShowOrderType != ApprovalDeitailSubordersType.Car{
            rowChargeCell = 1
        }
        
        // 费用明细
        if indexPath.row == 3 && selectedShowOrderType != ApprovalDeitailSubordersType.Car  {
            
            let flightInfoCell:ApprovalDetailChargeTableViewCell = tableView.dequeueReusableCell(withIdentifier:tableViewDetailChargeCellIdentify) as! ApprovalDetailChargeTableViewCell
            flightInfoCell.selectionStyle = UITableViewCellSelectionStyle.none
            flightInfoCell.fillDataSources(dataSources: spendingInfoDataSources)
            return flightInfoCell
        }
        
        var rowPassengerCell:NSInteger = 0
        if selectedShowOrderType ==  ApprovalDeitailSubordersType.Flight || selectedShowOrderType ==  ApprovalDeitailSubordersType.Train {
            rowPassengerCell = 1
        }
        //乘机人
        if indexPath.row == 3 + rowChargeCell && passengerInfoDataSources.count > 0 && (selectedShowOrderType ==  ApprovalDeitailSubordersType.Flight || selectedShowOrderType ==  ApprovalDeitailSubordersType.Train) {
            
            let flightInfoCell:ApprovalDetailPassengerTableViewCell = tableView.dequeueReusableCell(withIdentifier:tableViewDetailPassengerCellIdentify) as! ApprovalDetailPassengerTableViewCell
            
            var title:String = "乘机人"
            if selectedShowOrderType ==  ApprovalDeitailSubordersType.Train {
                title = "乘车人"
            }
            
            flightInfoCell.fillDataSources(title:title, passengers:(passengerInfoDataSources))
            flightInfoCell.selectionStyle = UITableViewCellSelectionStyle.none
            weak var weakSelf = self
            flightInfoCell.approvalDetailPassengerTableViewCellBlock = { selectedIndex in
                weakSelf?.intoNextPassengerDetailView(index: selectedIndex)
            }
            return flightInfoCell
        }
        
        
        //联系人
        if indexPath.row == 3 + rowChargeCell + rowPassengerCell {
            let baseInfoCell:ApprovalDetalBaseInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier:tableViewBaseInfoCellIdentify) as! ApprovalDetalBaseInfoTableViewCell
            baseInfoCell.selectionStyle = UITableViewCellSelectionStyle.none
            baseInfoCell.fillDataSources(dataSources: contactPersonalDataSources)
            return baseInfoCell
        }
        //申请单
        if indexPath.row == 4 + rowChargeCell + rowPassengerCell {
            let baseInfoCell:ApprovalDetalBaseInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier:tableViewBaseInfoCellIdentify) as! ApprovalDetalBaseInfoTableViewCell
            baseInfoCell.selectionStyle = UITableViewCellSelectionStyle.none
            baseInfoCell.fillDataSources(dataSources: applyInfoDataSources)
            return baseInfoCell
        }
        //审批记录
        if indexPath.row == 5 + rowChargeCell + rowPassengerCell {
            let baseInfoCell:ApprovalDetalBaseInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier:tableViewBaseInfoCellIdentify) as! ApprovalDetalBaseInfoTableViewCell
            baseInfoCell.selectionStyle = UITableViewCellSelectionStyle.none
            baseInfoCell.fillDataSources(dataSources: approvalInfoDataSources)
            return baseInfoCell
        }
        
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentify)!
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //订单号
        if indexPath.row == 0 {
            return CGFloat(ceilf(Float(tableViewOrdersDataSources.count) / 2.0) * 50 + 15)
        }
        // 基本信息
        if indexPath.row == 1 {
            return CGFloat(baseInfoDataSources.count * 44 + 5)
        }
        //机票 火车票 票信息
        // 酒店 专车  入住信息
        if indexPath.row == 2 {
            switch selectedShowOrderType {
            case .Flight,.Train:
                return 144
            case .Hotel,.Car:
                return CGFloat(tableViewTicketInfoDataSources.count * 44 + 5 )
                
            }
        }
        
        var rowChargeCell:NSInteger = 0
        if selectedShowOrderType != ApprovalDeitailSubordersType.Car {
            rowChargeCell = 1
        }
        //费用明细
        if indexPath.row == 3 && selectedShowOrderType != ApprovalDeitailSubordersType.Car  {
            
            return CGFloat(spendingInfoDataSources.count * 44 + 5 )
        }
        var rowPassengerCell:NSInteger = 0
        if selectedShowOrderType == ApprovalDeitailSubordersType.Flight || selectedShowOrderType == ApprovalDeitailSubordersType.Train {
            rowPassengerCell = 1
        }
        
        // 机票 有乘机人信息
        if indexPath.row == 3 + rowChargeCell && passengerInfoDataSources.count > 0 {
            if selectedShowOrderType == ApprovalDeitailSubordersType.Flight {
                return CGFloat(passengerInfoDataSources.count * 55 + 44 + 5)
            }else {
                return CGFloat(passengerInfoDataSources.count * 70 + 44 + 5)
            }
            
        }

        if indexPath.row == 3 + rowChargeCell + rowPassengerCell {
            return CGFloat(contactPersonalDataSources.count * 44 + 5)
        }
        if indexPath.row == 4 + rowChargeCell + rowPassengerCell {
            return CGFloat(applyInfoDataSources.count * 44 + 5)
        }
        if indexPath.row == 5 + rowChargeCell + rowPassengerCell  {
            return CGFloat(approvalInfoDataSources.count * 44 + 5)
        }
        
        
        return 44
    }
    
    
    /// 修改显示 订单信息
    func changeShowOrderDetail(selectedOrder:String) {
        guard selectedOrder.isEmpty == false else {
            return
        }
        selectedShowOrder = selectedOrder
        
        
        for element in tableViewOrdersDataSources {
            if element.title == selectedShowOrder {
                selectedShowOrderType = element.contentType
                break
            }
        }
        
        separateBaseInfoDataSources(orderType: selectedShowOrderType, selectedOrder: selectedShowOrder)
        separateTicketInfoDataSources(orderType:selectedShowOrderType , selectedOrder:selectedShowOrder)
        separateSpendingDetailDataSources(orderType:selectedShowOrderType , selectedOrder:selectedShowOrder)
        separateContactPersonalDataSources(orderType:selectedShowOrderType , selectedOrder:selectedShowOrder)
        separateApplyInfoDataSources(orderType:selectedShowOrderType , selectedOrder:selectedShowOrder)
        separatePassengerInfoDataSources(orderType:selectedShowOrderType , selectedOrder:selectedShowOrder)
        separateApprovalInfoDataSources(orderType:selectedShowOrderType , selectedOrder: selectedShowOrder)
        if approvalInfoDataSources.count > 0 {
            approvalSection = 1
        }else {
            approvalSection = 0
        }
        tableView.reloadData()
    }
    
    
    
    
    /// 进入乘客详情
    func intoNextPassengerDetailView(index:NSInteger) {
        guard flightOrderDetail?.passengers.count ?? 0 > index else {
            return
        }
        let orderInsureView = OrderInsureViewController()
        let selectedSurance:OrderDetailModel.passenger.surance = OrderDetailModel.passenger.surance()
        selectedSurance.cusName = flightOrderDetail?.passengers[index].surances.first?.cusName ?? ""
        selectedSurance.suranceName = flightOrderDetail?.passengers[index].surances.first?.suranceName ?? ""
        selectedSurance.suranceNo = flightOrderDetail?.passengers[index].surances.first?.suranceNo ?? ""
        selectedSurance.suranceStart = flightOrderDetail?.passengers[index].surances.first?.suranceStart ?? ""
        selectedSurance.suranceEnd = flightOrderDetail?.passengers[index].surances.first?.suranceEnd ?? ""
        selectedSurance.suranceStatusCH = flightOrderDetail?.passengers[index].surances.first?.suranceStatusCH ?? ""
        selectedSurance.price = flightOrderDetail?.passengers[index].surances.first?.price ?? ""
        orderInsureView.suransModel = selectedSurance
        self.navigationController?.pushViewController(orderInsureView, animated: true)
    }
    
    /// 进入 拒绝页面
    func intoNextDisagreeView() {
        let approvalOpinionController = CoApprovalOpinionController()
        
        approvalOpinionController.isAgreeOrderParams = false
        approvalOpinionController.isNewVersionParams = CoApprovalOrderView.isNewVersionOrder
        approvalOpinionController.orderNoParams = approvalId
        self.navigationController?.pushViewController(approvalOpinionController, animated: true)
    }
    /// 进入审批成功页面
    func intoNextApprovalSuccessView() {
        let vc = CoApprovalSuccessController()
        vc.type = .approval
        self.navigationController?.pushViewController(vc , animated: true)
    }
    
    
    override func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK:-----Action-------
    
    func agreeAllApprovalOrder(sender:UIButton) {
        if sender.currentTitle == bottomAllDisagreeTipDefault {
            intoNextDisagreeView()
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        CoNewExanimeService.sharedInstance
            .approvalOrdersAgree(isAgree:true, approvalNo:[approvalId] , comment: "")
            .subscribe{ event in
                weakSelf?.hideLoadingView()
                switch event{
                case .next(let e):
                    printDebugLog(message: e)
                    weakSelf?.intoNextApprovalSuccessView()
                case .error(let e):
                    try? weakSelf?.validateHttp(e)
                case .completed:
                    print("finish")
                }
            }.addDisposableTo((weakSelf?.bag)!)
        
        
    }
    
    
    
    override func backButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    
    
    

}
