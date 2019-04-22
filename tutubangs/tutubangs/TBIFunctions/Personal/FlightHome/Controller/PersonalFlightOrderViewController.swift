//
//  PersonalFlightOrderViewController.swift
//  shanglvjia
//
//  Created by manman on 2018/8/7.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import RxSwift

// 普通 和 特惠 可以用一套 但是 特惠的国际 需要填写 productno 和 allCabinsid PersonalFlight

// 定投的走的是 PersonalSpecialFlight

class PersonalFlightOrderViewController: PersonalBaseViewController,PayManagerStateProtocol,UITableViewDelegate,UITableViewDataSource {
    
    
    public var personalFlightOrderViewType:AppModelCatoryENUM = AppModelCatoryENUM.Default
    
    private let bag:DisposeBag = DisposeBag()
    
    /// 0 国内 1 国际
    private var nationString:String = "0"
    // A 定投 F 特惠
    public var specialString:String = "A" // 普通的默认为A
    
    private let orderTableView = UITableView()
    
    private let orderTableViewCellRegularIdentify:String = "orderTableViewCellRegularIdentify"
    //
    private let orderTableViewFlightInfoCellIdentify:String = "orderTableViewFlightInfoCellIdentify"
    //
    
    private let orderTableViewContactInfoCellIdentify:String = "orderTableViewContactInfoCellIdentify"
    
    private let orderTableViewSectionHeaderViewIdentify:String = "orderTableViewSectionHeaderViewIdentify"
    
    
    private let orderTableViewInvoiceInfoCellIdentify:String = "orderTableViewInvoiceInfoCellIdentify"
    
    private let orderTableViewInsuranceInfoCellIdentify:String = "orderTableViewInsuranceInfoCellIdentify"
    //private var orderTableViewInvoiceInfoCellIdentify
    
    private let orderTableViewPassengerInfoCellIdentify:String = "orderTableViewPassengerInfoCellIdentify"
    
    private let orderTableViewPersonalFlightBookProtocolCellIdentify:String = "orderTableViewPersonalFlightBookProtocolCellIdentify"
    
    private let tableViewHeaderSectionTipViewIdentify:String = "tableViewHeaderSectionTipViewIdentify"
    
    private var personalFlightFooterView:PersonalFlightFooterView = PersonalFlightFooterView()
    
    private var footerView:TravelPriceInfoView = TravelPriceInfoView()
    
    ///发票类型数组
    public var invoiceArr:[PTravelNearbyDetailModel.InvoicesModel] = Array()
    
    ///个人 公司 0 个人 1 企业
    public var invoiceTypeIndex: NSInteger = 0
    
    public var billTypeStr : String = ""
    public var billTypeValueStr : String = ""
    fileprivate var billTypeArr:[String] = Array()
    fileprivate var invoiceValueArr:[String] = Array()
    
    ///发票类型数组
    public var suranceArr:[PTravelNearbyDetailModel.NearbySuranceResponse] = Array()
    
    /// 特惠数据
    private var onsaleFlightTrip:[PCommonFlightSVSearchModel.AirfareVO] = Array()
    
    /// 普通数据
    private var commonFlightTrip:[PCommonFlightSVSearchModel.AirfareVO] = Array()
    
    /// 定投数据
   // private var specialFlightTrip:[PSepcailFlightCabinModel.ResponsesListVo] = Array()
    
    /// 定投数据
    private var specialFlightTrip:[PersonalSpecialFlightInfoListResponse.BaseFlightAndReturnInfoVo] = Array()
    
    
    
    private var selectedPassengerArr:[PersonalTravellerInfoRequest] = Array()
    
    
    
    ///  温馨提示 section 1 存在 0 不存在
    private var warmTipDefaultSection:NSInteger = 1
    
    /// 保存订单详情
    private var pricesDetailArr:[(priceTitle:String,price:String)] = Array()
    
    
    /// 总金额
    private var amountPrices:Float = 0
    fileprivate var boolArray:[Bool] = Array()
    
    /// 保险份数
    private var insuranceNum:NSInteger = 0
    
    /// 保险
    private var  insuranceStatus:Bool = true
    
    /// 发票
    private var invoiceStatus:Bool = false
    
    
    /// 协议
    private var protocolStatus:Bool = false
   
    
    
    /// 是否国际 true 是国际  false 国内
    private var isFlightNation:Bool = false
    
    /// 是否 往返 true   单程 false
    private var isRoundTrip:Bool = false
    
    private var  isShowPricesDetailView:Bool = false
    
    
    private let disposeBag = DisposeBag()
    
    private var localLinkmanName:Variable = Variable("")
    private var localLinkmanEmail:Variable = Variable("")
    private var localLinkmanMobile:Variable = Variable("")
    
    
    ///发票信息
    fileprivate var invoicePersonalName:Variable = Variable("")
    fileprivate var invoiceCompanyHeader:Variable = Variable("")
    fileprivate var invoiceCompanyTaxNum:Variable = Variable("")
    fileprivate var invoiceCompanyBankName:Variable = Variable("")
    fileprivate var invoiceCompanyBankNum:Variable = Variable("")
    fileprivate var invoiceCompanyAddress:Variable = Variable("")
    fileprivate var invoiceCompanyPhone:Variable = Variable("")
    ///地址
    fileprivate var addressCity:Variable = Variable("")
    fileprivate var addressStreet:Variable = Variable("")
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBlackTitleAndNavigationColor(title: "填写信息")
        self.view.backgroundColor = TBIThemeBaseColor
        fillDataSources()
        setUIViewAutolayout()
        
    }
    
    func fillDataSources() {
        PayManager.sharedInstance.delegate = self
        localLinkmanName = Variable(DBManager.shareInstance.personalContactNameDraw())
        localLinkmanMobile = Variable(DBManager.shareInstance.personalContactPhoneDraw())
        localLinkmanEmail = Variable(DBManager.shareInstance.personalContactEmailDraw())
        
        
        
        switch personalFlightOrderViewType {
        case .PersonalFlight:
            fillCommonFlightTripDataSources()
        case .PersonalSpecialFlight:
            fillSpecialFlightTripDataSources()
        case .PersonalOnsaleFlight:
            fillPersonalOnsaleFlightDataSources()
            
        default: break
            
        }
        
        
        if isRoundTrip {
            insuranceNum = 2
        }
    }
    
    func fillPersonalOnsaleFlightDataSources()  {
        onsaleFlightTrip = PersonalOnsaleFlightManager.shareInStance.selectedFlightTripDraw()
        isFlightNation = onsaleFlightTrip.first?.flightNation == "0" ? false : true
        isRoundTrip = onsaleFlightTrip.first?.flightTripType == "1" ? true : false
        nationString = onsaleFlightTrip.first?.flightNation ?? "0"
        billTypeStr = "行程单"
        ///billTypeArr = ["行程单"]
        
    }
    func fillCommonFlightTripDataSources() {
        commonFlightTrip = PCommonFlightManager.shareInStance.selectedFlightTripDraw()
        isFlightNation =  false//commonFlightTrip.first?.flightNation == "0" ? false : true
        isRoundTrip = commonFlightTrip.count > 1 ? true : false
        nationString = commonFlightTrip.first?.flightNation ?? "0"
        billTypeStr = "行程单"
        ///billTypeArr = ["行程单"]
    }
    func fillSpecialFlightTripDataSources() {
        specialFlightTrip = PersonalSpecialFlightManager.shareInStance.selectedFlightTripInfoDraw()//.selectedFlightTripDraw()
        isFlightNation = specialFlightTrip.first?.flightNation == "0" ? false : true
        isRoundTrip = specialFlightTrip.last?.tripType == "1" ? true : false
        nationString = specialFlightTrip.first?.flightNation ?? "0"
        billTypeStr = "电子发票"
        ///billTypeArr = ["电子发票","纸质发票"]
    }
    
    
    func setUIViewAutolayout() {
        
        orderTableView.delegate = self
        orderTableView.dataSource = self
        orderTableView.bounces = false
        orderTableView.backgroundColor = TBIThemeBaseColor
        orderTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        orderTableView.register(UITableViewCell.self, forCellReuseIdentifier:orderTableViewCellRegularIdentify)
        orderTableView.register(FlightSelectHeaderTableCell.self, forCellReuseIdentifier: orderTableViewFlightInfoCellIdentify)
        orderTableView.register(VisaContactCell.self, forCellReuseIdentifier: orderTableViewContactInfoCellIdentify)
        orderTableView.register(PersonalFlightTableViewHeaderView.self, forCellReuseIdentifier:orderTableViewSectionHeaderViewIdentify )
        orderTableView.register(PersonalFlightInvoiceTableViewCell.self, forCellReuseIdentifier: orderTableViewInsuranceInfoCellIdentify)
        orderTableView.register(PersonalFlightBookProtocolTableViewCell.self, forCellReuseIdentifier: orderTableViewPersonalFlightBookProtocolCellIdentify)
        orderTableView.register(PersonalHotelSubmitTipSectionCellView.self, forCellReuseIdentifier: tableViewHeaderSectionTipViewIdentify)
        orderTableView.register(VisaOrderCell.self, forCellReuseIdentifier: orderTableViewPassengerInfoCellIdentify)
        orderTableView.register(VisaBillCell.self, forCellReuseIdentifier: orderTableViewInvoiceInfoCellIdentify)
        orderTableView.register(VisaTitleCell.self, forCellReuseIdentifier: "VisaTitleCell")
        orderTableView.register(VisaOrderAddressCell.self, forCellReuseIdentifier: "VisaOrderAddressCell")
        self.view.addSubview(orderTableView)
        orderTableView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(54)
        }
        
        initFooterView()
        fillDataSource()
    }
    //MARK: -------- NET ------
    
    
    func fillDataSource(){
        weak var weakSelf = self
        PersonalMineService.sharedInstance.queryPersonalBaseInfo()
            .subscribe { (event) in
                switch event {
                case .next(let result):
                    
                    printDebugLog(message: result.mj_keyValues())
                    
                    weakSelf?.addressCity.value = result.province + result.city + result.distrct
                    weakSelf?.addressStreet.value = result.address
                    weakSelf?.invoicePersonalName.value = result.cnName
                    weakSelf?.invoiceCompanyHeader.value = result.invoiceTitle
                    weakSelf?.invoiceCompanyTaxNum.value = result.taxIdCode
                    weakSelf?.invoiceCompanyBankName.value = result.bank
                    weakSelf?.invoiceCompanyBankNum.value = result.bankAccount
                    weakSelf?.invoiceCompanyAddress.value = result.companyAddress
                    weakSelf?.invoiceCompanyPhone.value = result.bankFax
                    weakSelf?.orderTableView.reloadData()
                    
                case .error:
                    
                    break
                case .completed:
                    break
                }
        }
        var productId  = ""
        var typeStr  = ""
        switch personalFlightOrderViewType {
        case .PersonalFlight:
            productId = " "
            typeStr = "1"
        case .PersonalSpecialFlight: // 定投
            productId = specialFlightTrip.first?.id ?? ""
            typeStr = "3"
        case .PersonalOnsaleFlight:
            productId = onsaleFlightTrip.first?.productId ?? ""
            typeStr = "2"
        default:break
        }
        PersonalFlightServices.sharedInstance
            .personalFlightInvoices(id:productId,type: typeStr)
            .subscribe { (event) in
                switch event {
                case .next(let result):
                    printDebugLog(message: result)
                    weakSelf?.invoiceArr = result.invoices
                    weakSelf?.suranceArr = result.surances
                    
                    if (weakSelf?.invoiceArr.count)!>0{
                        for model in (weakSelf?.invoiceArr)! {
                            weakSelf?.billTypeArr.append(model.name)
                            weakSelf?.invoiceValueArr.append(model.value)
                        }
                        weakSelf?.billTypeStr = (weakSelf?.billTypeArr[0])!
                        weakSelf?.billTypeValueStr = (weakSelf?.invoiceValueArr[0])!
                    }
                    if (weakSelf?.suranceArr.count)!>0{
                        for _ in (weakSelf?.suranceArr)! {
                            weakSelf?.boolArray.append(false)
                        }
                    }
                    
                     weakSelf?.orderTableView.reloadData()
                    
                case .error(let error):
                    break
                case .completed:
                    break
                }
        }
    }
    
    func setFooterViewAutolayout() {
        
        self.view.addSubview(personalFlightFooterView)
        personalFlightFooterView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(54)
        }
        weak var weakSelf = self
        personalFlightFooterView.personalFlightFooterViewPaymentBlock = {
            // 去提交订单
            weakSelf?.submitOrder()
        }
        
        personalFlightFooterView.personalFlightFooterViewShowPriceDetailBlock = { isShow in
            // 是否展示 详情
//            weakSelf?.showPricesDetailView(isShow: isShow)
        }
        
        
        
        caculateAmount()
        
    }
    func initFooterView(){
        self.view.addSubview(footerView)
        footerView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(54)
        }
        
       
        footerView.submitButton.setTitle("提交订单", for: UIControlState.normal)
        
//        footerView.totalPriceLabel.text = orderModel.totalRate
        
        KeyWindow?.addSubview(footerView.backBlackView)
        footerView.priceButton.addTarget(self, action: #selector(priceInfo(sender:)), for: .touchUpInside)
        footerView.submitButton.addTarget(self, action: #selector(submitOrder), for: .touchUpInside)
        
        //caculateAmount()
    }
    //价格详情
    func priceInfo(sender: UIButton) {
        if sender.isSelected == true {
            sender.isSelected = false
            footerView.backBlackView.isHidden = true
        }else
        {
            footerView.backBlackView.isHidden = false
            footerView.backBlackView.addOnClickListener(target: self, action: #selector(removePriceInfo(tap:)))
            footerView.backBlackView.snp.makeConstraints({ (make) in
                make.top.right.left.equalToSuperview()
                make.bottom.equalTo(-54)
            })
            sender.isSelected = true
        }
    }
    func removePriceInfo(tap:UITapGestureRecognizer) {
        footerView.priceButton.isSelected = false
        footerView.backBlackView.isHidden = true
    }

    
    
    
    func caculateAmount()  {
        //pricesDetailArr //保存
        pricesDetailArr.removeAll()
        amountPrices = 0
        switch personalFlightOrderViewType {
        case .PersonalSpecialFlight:
            caculateSpecialFlightTripAmount()
        case .PersonalFlight:
            caculateCommonFlightTripAmount()
        case .PersonalOnsaleFlight:
            caculateOnsaleFlightTripAmount()
        default:break
            
        }
        
        
        var tmpInsuranceNum:NSInteger = 1
        if isRoundTrip {
            tmpInsuranceNum = 2
        }
        if selectedPassengerArr.count > 0 {
            insuranceNum = selectedPassengerArr.count * tmpInsuranceNum
        }
        if suranceArr.count>0{
            for i in 0...suranceArr.count-1{
                if boolArray[i] == true{
                    if selectedPassengerArr.count > 0 {
                        amountPrices += Float(selectedPassengerArr.count) * Float(suranceArr[i].suranceSalePrice)! * Float(tmpInsuranceNum)
                        pricesDetailArr.append((suranceArr[i].suranceName, "¥\(suranceArr[i].suranceSalePrice) X  \((selectedPassengerArr.count * tmpInsuranceNum).description)"))
                    }else{
                        amountPrices += Float(suranceArr[i].suranceSalePrice)! * Float(tmpInsuranceNum)
                        insuranceNum = tmpInsuranceNum
                        pricesDetailArr.append((suranceArr[i].suranceName,"¥\(suranceArr[i].suranceSalePrice) X \(tmpInsuranceNum)"))
                    }
                }
            }
            
        }
//        personalFlightFooterView.fillDataSources(pricesAmount: amountPrices)
        footerView.totalPriceLabel.text = amountPrices.TwoOfTheEffectiveFraction()
        footerView.setViewWithArray(dataArr:pricesDetailArr)
    }
    
    
    
    
    
    // 普通的 航班 价格
    func caculateCommonFlightTripAmount() {
        cacaulaterCommonDomesticFlightTripAmount()
    }
    
    /// 特惠的
    func caculateOnsaleFlightTripAmount() {
        if isFlightNation {
            caculaterOnsaleInternationalFlightTripAmount()
            //caculateCommonInternationalFlightTripAmount()
        }else{
            
            caculateOnsaleDomesticFlightTripAmount()
            //cacaulaterCommonDomesticFlightTripAmount()
        }
        
    }
    
    
    /// 定投
    func caculateSpecialFlightTripAmount() {
        var peopleNum:NSInteger = 1
        if selectedPassengerArr.count > 0 {
            peopleNum = selectedPassengerArr.count
        }
        amountPrices += ((specialFlightTrip.last?.cabinInfos[specialFlightTrip.last?.selectedCabinsIndex ?? 0].cabinPrice)! * Float(peopleNum))
        let prices:String = specialFlightTrip.last!.cabinInfos[specialFlightTrip.last!.selectedCabinsIndex ?? 0].cabinPrice.TwoOfTheEffectiveFraction()
        pricesDetailArr.append(("基础票价","¥" +  "\(prices) X \(peopleNum)"))
    }
    
    /// 特惠 国际
    func caculaterOnsaleInternationalFlightTripAmount() {
        var peopleNum:NSInteger = 1
        if selectedPassengerArr.count > 0 {
            peopleNum = selectedPassengerArr.count
        }
        if selectedPassengerArr.count > 0 {
//            // 是否包含自己
//            let myselfContain:Bool = selectedPassengerArr.contains { (element) -> Bool in
//                if element.relationType == "7"  {
//                    return true
//                }
//                return false
//            }
            // 是否包含 儿童。几个儿童
            let childArr = selectedPassengerArr.filter { (element) -> Bool in
                if element.isChild == true &&  element.relationType != "7" {
                    return true
                }else {
                    return false
                }
            }
            let passengerNum:NSInteger = selectedPassengerArr.count
            
            var ramainPassenger:NSInteger = passengerNum
            ramainPassenger -= childArr.count
//            if myselfContain {
//                ramainPassenger -= 1
//            }
            
            if childArr.count > 0 {
                amountPrices += (onsaleFlightTrip.last!.cabins[onsaleFlightTrip.last?.selectedCabinIndex ?? 0].childPrice.floatValue  * Float(childArr.count))
                amountPrices += (onsaleFlightTrip.last!.cabins[onsaleFlightTrip.last?.selectedCabinIndex ?? 0].childTax.floatValue  * Float(childArr.count))
                amountPrices += (onsaleFlightTrip.last!.cabins[onsaleFlightTrip.last?.selectedCabinIndex ?? 0].childFuelTax.floatValue * Float(childArr.count))
                pricesDetailArr.append(("儿童票价", "¥\(onsaleFlightTrip.last?.cabins[onsaleFlightTrip.last?.selectedCabinIndex ?? 0].childPrice.floatValue.TwoOfTheEffectiveFraction() ?? "0") X \(childArr.count) "))
                pricesDetailArr.append(("儿童基建", "¥\(onsaleFlightTrip.last?.cabins[onsaleFlightTrip.last?.selectedCabinIndex ?? 0].childTax.floatValue.TwoOfTheEffectiveFraction() ?? "0") X \(childArr.count)"))
                pricesDetailArr.append(("儿童燃油税","¥\(onsaleFlightTrip.last?.cabins[onsaleFlightTrip.last?.selectedCabinIndex ?? 0].childFuelTax.floatValue.TwoOfTheEffectiveFraction() ?? "0") X \(childArr.count)"))
            }
//            if myselfContain {
//                amountPrices += onsaleFlightTrip.last?.cabins[onsaleFlightTrip.last?.selectedCabinIndex ?? 0].price.floatValue ?? 0
//                pricesDetailArr.append(("票价(本人)", onsaleFlightTrip.last?.cabins[onsaleFlightTrip.last?.selectedCabinIndex ?? 0].price.floatValue.TwoOfTheEffectiveFraction() ?? "0"))
//                amountPrices += onsaleFlightTrip.last?.cabins[onsaleFlightTrip.last?.selectedCabinIndex ?? 0].tax.floatValue ?? 0
//                amountPrices += onsaleFlightTrip.last?.cabins[onsaleFlightTrip.last?.selectedCabinIndex ?? 0].fuelTax.floatValue ?? 0
//                pricesDetailArr.append(("基建(本人)", onsaleFlightTrip.last?.cabins[onsaleFlightTrip.last?.selectedCabinIndex ?? 0].tax.floatValue.TwoOfTheEffectiveFraction() ?? "0"))
//                pricesDetailArr.append(("燃油税(本人)", onsaleFlightTrip.last?.cabins[onsaleFlightTrip.last?.selectedCabinIndex ?? 0].fuelTax.floatValue.TwoOfTheEffectiveFraction() ?? "0"))
//            }
            
            if ramainPassenger > 0 {
                amountPrices += (onsaleFlightTrip.last!.cabins[onsaleFlightTrip.last?.selectedCabinIndex ?? 0].price.floatValue * Float(ramainPassenger))
                pricesDetailArr.append(("成人票价", "¥\(onsaleFlightTrip.last?.cabins[onsaleFlightTrip.last?.selectedCabinIndex ?? 0].price.floatValue.TwoOfTheEffectiveFraction() ?? "0") X \(ramainPassenger)"))
                amountPrices += (onsaleFlightTrip.last!.cabins[onsaleFlightTrip.last?.selectedCabinIndex ?? 0].tax.floatValue * Float(ramainPassenger))
                pricesDetailArr.append(("基建", "¥\(onsaleFlightTrip.last?.cabins[onsaleFlightTrip.last?.selectedCabinIndex ?? 0].tax.floatValue.TwoOfTheEffectiveFraction() ?? "0") X \(ramainPassenger)"))
                amountPrices += (onsaleFlightTrip.last!.cabins[onsaleFlightTrip.last?.selectedCabinIndex ?? 0].fuelTax.floatValue * Float(ramainPassenger))
                pricesDetailArr.append(("燃油税","¥\(onsaleFlightTrip.last?.cabins[onsaleFlightTrip.last?.selectedCabinIndex ?? 0].fuelTax.floatValue.TwoOfTheEffectiveFraction() ?? "0") X \(ramainPassenger)"))
            }
        }else{
            amountPrices += onsaleFlightTrip.last?.cabins[onsaleFlightTrip.last?.selectedCabinIndex ?? 0].price.floatValue ?? 0
            amountPrices += onsaleFlightTrip.last?.cabins[onsaleFlightTrip.last?.selectedCabinIndex ?? 0].tax.floatValue ?? 0
            amountPrices += onsaleFlightTrip.last?.cabins[onsaleFlightTrip.last?.selectedCabinIndex ?? 0].fuelTax.floatValue ?? 0
            pricesDetailArr.append(("票价", "¥" +   (onsaleFlightTrip.last?.cabins[onsaleFlightTrip.last?.selectedCabinIndex ?? 0].price.floatValue.TwoOfTheEffectiveFraction() ?? "0")))
            pricesDetailArr.append(("基建", "¥" +   (onsaleFlightTrip.last?.cabins[onsaleFlightTrip.last?.selectedCabinIndex ?? 0].tax.floatValue.TwoOfTheEffectiveFraction() ?? "0")))
            pricesDetailArr.append(("燃油税","¥" +   (onsaleFlightTrip.last?.cabins[onsaleFlightTrip.last?.selectedCabinIndex ?? 0].fuelTax.floatValue.TwoOfTheEffectiveFraction() ?? "0")))
            
        }
        
    }
    
    /// 特惠 国内
    func caculateOnsaleDomesticFlightTripAmount() {
        if selectedPassengerArr.count > 0 {  // 确定 角色 价格
//            // 是否包含自己
//            let myselfContain:Bool = selectedPassengerArr.contains { (element) -> Bool in
//                if element.relationType == "7" {
//                    return true
//                }
//                return false
//            }
            // 是否包含 儿童。几个儿童
            let childArr = selectedPassengerArr.filter { (element) -> Bool in
                if  element.isChild == true &&  element.relationType != "7" {
                    return true
                }else {
                    return false
                }
            }
            let passengerNum:NSInteger = selectedPassengerArr.count
            
            var ramainPassenger:NSInteger = passengerNum
            ramainPassenger -= childArr.count
//            if myselfContain {
//                ramainPassenger -= 1
//            }
            
            var flightTripType:String = ""
            if isRoundTrip {  flightTripType = "去程" }
            
            for (index,element) in onsaleFlightTrip.enumerated() {
                if index == 1  && isRoundTrip == true {flightTripType = "返程" }
                
                if childArr.count > 0 {
                    amountPrices += (element.cabins[element.selectedCabinIndex ?? 0].childPrice.floatValue * Float(childArr.count))
                    amountPrices += (element.cabins[element.selectedCabinIndex ?? 0].childTax.floatValue * Float(childArr.count))
                    amountPrices += (element.cabins[element.selectedCabinIndex ?? 0].childFuelTax.floatValue * Float(childArr.count))
                    pricesDetailArr.append(("儿童票价" + flightTripType, "¥\(element.cabins[element.selectedCabinIndex ?? 0].childPrice.floatValue.TwoOfTheEffectiveFraction()) X \(childArr.count) ")) //"票价(儿童)"
                    pricesDetailArr.append(("儿童基建" + flightTripType, "¥\(element.cabins[element.selectedCabinIndex ?? 0].childTax.floatValue.TwoOfTheEffectiveFraction()) X \(childArr.count)")) //基建(儿童)
                    pricesDetailArr.append(("儿童燃油税" + flightTripType,"¥\(element.cabins[element.selectedCabinIndex ?? 0].childFuelTax.floatValue.TwoOfTheEffectiveFraction()) X \(childArr.count)")) //燃油税(儿童)
                }
//                if myselfContain {
//                    amountPrices += element.cabins[element.selectedCabinIndex ?? 0].price.floatValue
//                    pricesDetailArr.append(("票价(本人)" + flightTripType, element.cabins[element.selectedCabinIndex ?? 0].price.floatValue.TwoOfTheEffectiveFraction()))
//                    amountPrices += element.cabins[element.selectedCabinIndex ?? 0].tax.floatValue
//                    amountPrices += element.cabins[element.selectedCabinIndex ?? 0].fuelTax.floatValue
//                    pricesDetailArr.append(("基建(本人)" + flightTripType, element.cabins[element.selectedCabinIndex ?? 0].tax.floatValue.TwoOfTheEffectiveFraction()))
//                    pricesDetailArr.append(("燃油税(本人)" + flightTripType, element.cabins[element.selectedCabinIndex ?? 0].fuelTax.floatValue.TwoOfTheEffectiveFraction()))
//                }
                
                if ramainPassenger > 0 {
                    amountPrices += (element.cabins[element.selectedCabinIndex ?? 0].price.floatValue * Float(ramainPassenger))
                    pricesDetailArr.append(("成人票价" + flightTripType, "¥\(element.cabins[element.selectedCabinIndex ?? 0].price.floatValue.TwoOfTheEffectiveFraction()) X \(ramainPassenger)")) //"票价"
                
                    amountPrices += (element.cabins[element.selectedCabinIndex ?? 0].tax.floatValue * Float(ramainPassenger))
                    pricesDetailArr.append(("基建" + flightTripType, "¥\(element.cabins[element.selectedCabinIndex ?? 0].tax.floatValue.TwoOfTheEffectiveFraction()) X \(ramainPassenger)"))
                    amountPrices += (element.cabins[element.selectedCabinIndex ?? 0].fuelTax.floatValue * Float(ramainPassenger))
                    pricesDetailArr.append(("燃油税" + flightTripType,"¥\(element.cabins[element.selectedCabinIndex ?? 0].fuelTax.floatValue.TwoOfTheEffectiveFraction()) X \(ramainPassenger)"))
                }
            }
            
        }else{ //默认 进来时 价格
            var flightTripType:String = "去程"
            for (index,element) in onsaleFlightTrip.enumerated() {
                if index == 1  && isRoundTrip == true {flightTripType = "返程" }
                amountPrices += element.cabins[element.selectedCabinIndex ?? 0].price.floatValue
                amountPrices += element.cabins[element.selectedCabinIndex ?? 0].tax.floatValue
                amountPrices += element.cabins[element.selectedCabinIndex ?? 0].fuelTax.floatValue
                pricesDetailArr.append(("票价" + flightTripType, "¥" +   (element.cabins[element.selectedCabinIndex ?? 0].price.floatValue.TwoOfTheEffectiveFraction())))
                pricesDetailArr.append(("基建" + flightTripType, "¥" +   (element.cabins[element.selectedCabinIndex ?? 0].tax.floatValue.TwoOfTheEffectiveFraction())))
                pricesDetailArr.append(("燃油税" + flightTripType, "¥" +   (element.cabins[element.selectedCabinIndex ?? 0].fuelTax.floatValue.TwoOfTheEffectiveFraction())))
                
            }
        }
    }
    
    ///  国内的 特惠航班 普通航班
    func cacaulaterCommonDomesticFlightTripAmount() {
        caculateCommonDemesticPersonalFlightTripAmount()
     
    }

    
    /// 普通的机票价格
    func caculateCommonDemesticPersonalFlightTripAmount(){
        
        if selectedPassengerArr.count > 0 {  // 确定 角色 价格
            // 是否包含自己
            let myselfContain:Bool = selectedPassengerArr.contains { (element) -> Bool in
                if element.relationType == "7" {
                    return true
                }
                return false
            }
            // 是否包含 儿童。几个儿童
            var childArr = selectedPassengerArr.filter { (element) -> Bool in
                if element.isChild && element.relationType != "7" {
                    return true
                }else {
                    return false
                }
            }
//            // 防止 本人 是 儿童
//            let myselfIsChild:Bool = selectedPassengerArr.contains { (element) -> Bool in
//                if element.relationType == "7" && element.isChild == true {
//                    return true
//                }
//                return false
//            }
            let passengerNum:NSInteger = selectedPassengerArr.count
            var ramainPassenger:NSInteger = passengerNum
            ramainPassenger -= childArr.count
            if myselfContain {
                ramainPassenger -= 1
            }
//            if selectedPassengerArr.count == 1 && myselfContain == true && childArr.count > 0 {
//                childArr.removeAll()
//            }
            
          
            
            
            
            
            var flightTripType:String = ""
            if isRoundTrip {  flightTripType = "去程" }
            for (index,element) in commonFlightTrip.enumerated() {
                
                let protocolPrice = element.cabins[element.selectedCabinIndex ?? 0].ifAccountCodePrice
                
                if index == 1  && isRoundTrip == true {flightTripType = "返程" }
                if childArr.count > 0 {
                    amountPrices += (element.cabins[element.selectedCabinIndex ?? 0].childPrice.floatValue * Float(childArr.count))
                    amountPrices += (element.cabins[element.selectedCabinIndex ?? 0].childTax.floatValue * Float(childArr.count))
                    amountPrices += (element.cabins[element.selectedCabinIndex ?? 0].childFuelTax.floatValue * Float(childArr.count))
                    pricesDetailArr.append(("儿童票价" + flightTripType, "¥\(element.cabins[element.selectedCabinIndex ?? 0].childPrice.floatValue.TwoOfTheEffectiveFraction()) X \(childArr.count) ")) //票价(儿童)
                    pricesDetailArr.append(("儿童基建" + flightTripType, "¥\(element.cabins[element.selectedCabinIndex ?? 0].childTax.floatValue.TwoOfTheEffectiveFraction()) X \(childArr.count)"))
                    pricesDetailArr.append(("儿童燃油税" + flightTripType,"¥\(element.cabins[element.selectedCabinIndex ?? 0].childFuelTax.floatValue.TwoOfTheEffectiveFraction()) X \(childArr.count)"))
                }
                if myselfContain {
                    amountPrices += element.cabins[element.selectedCabinIndex ?? 0].price.floatValue
                    pricesDetailArr.append(("本人票价" + flightTripType, "¥" +   (element.cabins[element.selectedCabinIndex ?? 0].price.floatValue.TwoOfTheEffectiveFraction())))
                    amountPrices += element.cabins[element.selectedCabinIndex ?? 0].tax.floatValue
                    amountPrices += element.cabins[element.selectedCabinIndex ?? 0].fuelTax.floatValue
                    pricesDetailArr.append(("本人基建" + flightTripType, "¥" +   (element.cabins[element.selectedCabinIndex ?? 0].tax.floatValue.TwoOfTheEffectiveFraction())))
                    pricesDetailArr.append(("本人燃油税" + flightTripType, "¥" +   (element.cabins[element.selectedCabinIndex ?? 0].fuelTax.floatValue.TwoOfTheEffectiveFraction())))
                }
                
                if ramainPassenger > 0 {
                    
                    var price:Float = 0
                    if protocolPrice {
                        price = element.cabins[element.selectedCabinIndex ?? 0].orginPrice.floatValue
                    }else {
                        price = element.cabins[element.selectedCabinIndex ?? 0].price.floatValue
                    }
                    
                    amountPrices += (price * Float(ramainPassenger))
                    pricesDetailArr.append(("家属票价" + flightTripType, "¥\(price.TwoOfTheEffectiveFraction()) X \(ramainPassenger)"))
                    amountPrices += (element.cabins[element.selectedCabinIndex ?? 0].tax.floatValue * Float(ramainPassenger))
                    pricesDetailArr.append(("家属基建" + flightTripType, "¥\(element.cabins[element.selectedCabinIndex ?? 0].tax.floatValue.TwoOfTheEffectiveFraction()) X \(ramainPassenger)"))
                    amountPrices += (element.cabins[element.selectedCabinIndex ?? 0].fuelTax.floatValue * Float(ramainPassenger))
                    pricesDetailArr.append(("家属燃油税" + flightTripType,"¥\(element.cabins[element.selectedCabinIndex ?? 0].fuelTax.floatValue.TwoOfTheEffectiveFraction()) X \(ramainPassenger)"))
                }
                
            }
           
        }else{ //默认 进来时 价格
            var flightTripType:String = "去"
            for (index,element) in commonFlightTrip.enumerated() {
                if index == 1  && isRoundTrip == true {flightTripType = "返" }
                amountPrices += element.cabins[element.selectedCabinIndex ?? 0].price.floatValue
                amountPrices += element.cabins[element.selectedCabinIndex ?? 0].tax.floatValue
                amountPrices += element.cabins[element.selectedCabinIndex ?? 0].fuelTax.floatValue
                pricesDetailArr.append(("票价" + flightTripType, "¥" +   (element.cabins[element.selectedCabinIndex ?? 0].price.floatValue.TwoOfTheEffectiveFraction())))
                pricesDetailArr.append(("基建" + flightTripType, "¥" +   (element.cabins[element.selectedCabinIndex ?? 0].tax.floatValue.TwoOfTheEffectiveFraction())))
                  pricesDetailArr.append(("燃油税" + flightTripType, "¥" +   (element.cabins[element.selectedCabinIndex ?? 0].fuelTax.floatValue.TwoOfTheEffectiveFraction())))
            }
//            footerView.totalPriceLabel.text = totalPrice
        }
        
    }
    /// 国际的航班
    func caculateCommonInternationalFlightTripAmount() {
        
        if selectedPassengerArr.count > 0 {  // 确定 角色 价格
            for passengerElement in selectedPassengerArr {
                var relationType:String = passengerElement.relationTypeLocal.getChineseRelation()
                for _ in commonFlightTrip {
                    amountPrices += commonFlightTrip.last?.cabins[(commonFlightTrip.first?.selectedCabinIndex)!].price.floatValue ?? 0
                    pricesDetailArr.append(("票价(" + relationType + ")" , "¥" +   (commonFlightTrip.last?
                        .cabins[(commonFlightTrip.first?.selectedCabinIndex)!].price
                        .floatValue.TwoOfTheEffectiveFraction() ?? "0")))
                    amountPrices += commonFlightTrip.last?
                        .cabins[(commonFlightTrip.first?.selectedCabinIndex)!].tax.floatValue ?? 0
                    pricesDetailArr.append(("基建(" + relationType + ")" , "¥" +   (commonFlightTrip.last?
                        .cabins[(commonFlightTrip.first?.selectedCabinIndex)!].tax
                        .floatValue.TwoOfTheEffectiveFraction() ?? "0")))
                    amountPrices += commonFlightTrip.last?
                        .cabins[(commonFlightTrip.first?.selectedCabinIndex)!].fuelTax
                        .floatValue ?? 0
                    pricesDetailArr.append(("燃油税(" + relationType + ")", "¥" +   (commonFlightTrip.last?
                        .cabins[(commonFlightTrip.first?.selectedCabinIndex)!].fuelTax
                        .floatValue.TwoOfTheEffectiveFraction() ?? "0")))

                }
            }
            
            if commonFlightTrip.count > 1 {
                amountPrices -= commonFlightTrip.last?.cabins[(commonFlightTrip.first?.selectedCabinIndex)!].price.floatValue ?? 0
            }
            
        }else{
            amountPrices += commonFlightTrip.last?.cabins[(commonFlightTrip.first?.selectedCabinIndex)!].price.floatValue ?? 0
            pricesDetailArr.append(("票价","¥" +  ( commonFlightTrip.last?
                .cabins[(commonFlightTrip.first?.selectedCabinIndex)!].price
                .floatValue.TwoOfTheEffectiveFraction() ?? "0")))
            amountPrices += commonFlightTrip.last?
                .cabins[(commonFlightTrip.first?.selectedCabinIndex)!].tax.floatValue ?? 0
            pricesDetailArr.append(("基建" , "¥" + (commonFlightTrip.last?
                .cabins[(commonFlightTrip.first?.selectedCabinIndex)!].tax
                .floatValue.TwoOfTheEffectiveFraction() ?? "0")))
            amountPrices += commonFlightTrip.last?
                .cabins[(commonFlightTrip.first?.selectedCabinIndex)!].fuelTax
                .floatValue ?? 0
            pricesDetailArr.append(("燃油税", "¥" +  (commonFlightTrip.last?
                .cabins[(commonFlightTrip.first?.selectedCabinIndex)!].fuelTax
                .floatValue.TwoOfTheEffectiveFraction() ?? "0")))
        }
    }
    
    func showChoicesPassengerView() {
        weak var weakSelf = self
        let tripListVC:TripPeopleListViewController = TripPeopleListViewController()
        if nationString == "1" {
            tripListVC.modelInternationalType = .PersonalInternationalFlight
        }else{
            tripListVC.modelInternationalType = .PersonalMainlandFlight
        }
        
        tripListVC.peopleListViewType = AppModelCatoryENUM.PersonalFlight
        tripListVC.selectedPassengerArr = selectedPassengerArr
        tripListVC.tripPeopleListViewSelectedBlock = { selectedPassenger in
            weakSelf?.selectedPassengerArr = selectedPassenger
            weakSelf?.caculateAmount()
            weakSelf?.orderTableView.reloadSections([1,3 + (weakSelf?.warmTipDefaultSection)!], with: UITableViewRowAnimation.none)
        }
        
        self.navigationController?.pushViewController(tripListVC, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func showPaymentView(orderIdArr:[String]) {
        guard orderIdArr.count > 0  else {
            return
        }
        var orderId:String = orderIdArr.first ?? ""
        for (index,element) in orderIdArr.enumerated() {
            if index == 0 { continue}
            orderId += ","
            orderId += element
        }
        weak var weakSelf = self
        let payView:SelectPaymentView = SelectPaymentView(frame:ScreenWindowFrame)
        let amountPrices = self.amountPrices.TwoOfTheEffectiveFraction()
        payView.setView(money: amountPrices)
        payView.paymentBlock = { btnTag in
            /// btnTag ==0微信支付 1：支付宝
            var paymentType:PaymentType = PaymentType.OtherPay
            switch btnTag {
            case 0:
                paymentType = PaymentType.Wechat
            case 1:
                paymentType = PaymentType.AliPay
            case 99:
                weakSelf?.flightNeedSecondSubmit(orderStatus: SubmitOrderFailureViewController.SubmitOrderStatus.Personal_Success_nopay)
            default:
                break
            }
            weakSelf?.choicePaymentType(type:paymentType, orderId: orderId)
            
        }
        KeyWindow?.addSubview(payView)
    }
    
    func choicePaymentType(type:PaymentType,orderId:String) {
        switch type {
        case PaymentType.AliPay:
            aliPayOrderInfo(type: type,orderId:orderId)
            break
        case PaymentType.Wechat:
            wechatOrderInfo(type: type, orderId: orderId)
            break
        case PaymentType.Unknow:
            break
        default: break
            
        }
        
        
        
    }
    
    
    func wechatOrderInfo(type:PaymentType,orderId:String)  {
        
        weak var weakSelf = self
        PaymentService.sharedInstance
            .wechatPersonalOrderInfo(order: orderId)
            .subscribe { (event) in
                weakSelf?.hideLoadingView()
                if case .next(let result) = event {
                    print(result)
                    PayManager.sharedInstance.wxPayRequst(order:result)
                }
                if case .error(let result) = event {
                    try? weakSelf?.validateHttp(result)
                    // weakSelf?.showSystemAlertView(titleStr: "提示", message: String(describing: result))
                }
                
            }.disposed(by: bag)
    }
    
    func aliPayOrderInfo(type:PaymentType,orderId:String)  {
        
        weak var weakSelf = self
        PaymentService.sharedInstance
            .alipayPersonalOrderInfo(order:orderId)
            .subscribe { (event) in
                weakSelf?.hideLoadingView()
                if case .next(let result) = event {
                    print(result)
                    PayManager.sharedInstance.aliPayRequest(order: result)
                }
                if case .error(let result) = event {
                    try? weakSelf?.validateHttp(result)
                    // weakSelf?.showSystemAlertView(titleStr: "提示", message: String(describing: result))
                }
            }.disposed(by: bag)
    }
    
    
    
    //MARK:------PayManagerDelegate
    func payManagerDidRecvFailureInfo(parameters: Dictionary<String, Any>?) {
        printDebugLog(message: "failure")
        intoNextSubmitOrderFailureView(orderStatus: SubmitOrderFailureViewController.SubmitOrderStatus.Personal_Failure_Payment)
        
        
    }
    func payManagerDidRecvSuccessInfo(parameters: Dictionary<String, Any>?) {
        printDebugLog(message: "success")
        intoNextSubmitOrderFailureView(orderStatus:SubmitOrderFailureViewController
            .SubmitOrderStatus.Personal_Success_Payment)
    }
    
    func flightNeedSecondSubmit(orderStatus:SubmitOrderFailureViewController.SubmitOrderStatus) {
        intoNextSubmitOrderFailureView(orderStatus: orderStatus)
    }
    
    //支付状态页面
    func intoNextSubmitOrderFailureView(orderStatus:SubmitOrderFailureViewController.SubmitOrderStatus) {
        let submitOrderFailureView = SubmitOrderFailureViewController()
        submitOrderFailureView.submitOrderStatus = orderStatus
        self.navigationController?.pushViewController(submitOrderFailureView, animated: true)
    }
    
    
    
    //MARK:-------NET------
    
    func submitOrder() {
        
        if footerView.backBlackView.isHidden == false {
            footerView.backBlackView.isHidden = true
        }
        
        
        guard protocolStatus == true else {
            showSystemAlertView(titleStr: "提示", message: "请阅读预订协议")
            return
        }
        
        
        guard selectedPassengerArr.count > 0 else {
            showSystemAlertView(titleStr: "提示", message: "请选择出行人")
            return
        }
        guard localLinkmanName.value.isEmpty == false else {
            showSystemAlertView(titleStr: "提示", message: "请填写联系人姓名")
            return
        }
        guard localLinkmanMobile.value.isEmpty == false  else {
            showSystemAlertView(titleStr: "提示", message: "请填写联系人手机号")
            return
        }
        guard localLinkmanMobile.value.validate(ValidateType.phone) == true else{
            showSystemAlertView(titleStr: "提示", message: "手机号格式错误")
            return
        }
        
        if localLinkmanEmail.value.isNotEmpty{
            guard localLinkmanEmail.value.validate(ValidateType.email) == true else{
                showSystemAlertView(titleStr: "提示", message: "邮箱格式错误")
                return
            }
        }
        
        DBManager.shareInstance.personalContactNameStore(name: localLinkmanName.value)
        DBManager.shareInstance.personalContactPhoneStore(phone: localLinkmanMobile.value)
        DBManager.shareInstance.personalContactEmailStore(email: localLinkmanEmail.value)
        
        
        
        if personalFlightOrderViewType == AppModelCatoryENUM.PersonalSpecialFlight {
            let remainTicket:NSNumber = (specialFlightTrip.last?.cabinInfos[specialFlightTrip.last?.selectedCabinsIndex ?? 0].stock)!
            
            guard selectedPassengerArr.count <= remainTicket.intValue else {
                showSystemAlertView(titleStr: "提示", message: "余票不足,请重新选择")
                return
            }
        }
        
        
        
        
        let request = PersonalFlightRequestModel()
         request.needInvoice = "0"
        let invoiceInfo:VisaOrderAddResquest.VisaOrderExpenseResquest = VisaOrderAddResquest.VisaOrderExpenseResquest()
        
        /// 发票信息
        if invoiceStatus {
            invoiceInfo.exKind = billTypeValueStr
            
            if billTypeStr == "电子发票" ||  billTypeStr == "纸质发票"{
                if invoiceTypeIndex == 0 {
                    if invoicePersonalName.value.isEmpty == true {
                        showSystemAlertView(titleStr: "提示", message: "请输入个人发票名称")
                        return
                    }
                    invoiceInfo.exPersonName = invoicePersonalName.value
                    invoiceInfo.exType = "0"
                }else{
                    if invoiceCompanyHeader.value.isEmpty == true || invoiceCompanyTaxNum.value.isEmpty == true ||
                        invoiceCompanyBankName.value.isEmpty == true || invoiceCompanyBankNum.value.isEmpty == true ||
                        invoiceCompanyAddress.value.isEmpty == true || invoiceCompanyPhone.value.isEmpty == true {
                        showSystemAlertView(titleStr: "提示", message: "请输入正确的公司发票信息")
                        return
                    }
                    invoiceInfo.exType = "1"
                    invoiceInfo.exBank = invoiceCompanyBankName.value
                    invoiceInfo.exBankNo = invoiceCompanyBankNum.value
                    invoiceInfo.exTitle = invoiceCompanyHeader.value
                    invoiceInfo.exItin = invoiceCompanyTaxNum.value
                    invoiceInfo.exCompanyAddress = invoiceCompanyAddress.value
                    invoiceInfo.exCompanyPhone = invoiceCompanyPhone.value
                }
                
                if billTypeStr == "电子发票"{
                    invoiceInfo.address = ""
                }else{
                    if addressCity.value.isEmpty == true || addressStreet.value.isEmpty == true{
                        showSystemAlertView(titleStr: "提示", message: "请输入地址信息")
                    }
                    invoiceInfo.address = addressCity.value + addressStreet.value
                }
                
            }
            if billTypeStr == "行程单"{
                invoiceInfo.address = addressCity.value + addressStreet.value
            }else {
                
            }
            
            invoiceInfo.exContent = "机票"
            
            invoiceInfo.exAmount = amountPrices.TwoOfTheEffectiveFraction()
            request.needInvoice = "1"
            request.expense = invoiceInfo
        }
        
//        if insuranceStatus {
//            request.needInsurance = "1"
//        }else{
//            request.needInsurance = "0"
//        }
        request.surances.removeAll()
        if suranceArr.count>0{
            for i in 0...suranceArr.count-1{
                if boolArray[i] == true{
                    let suranceInfo = suranceArr[i]
                    let temPassenger = PTravelNearbyDetailModel.NearbySuranceResponse(jsonData: "")
                    temPassenger?.id = suranceInfo.id
                    temPassenger?.suranceAgentPrice = suranceInfo.suranceAgentPrice
                    temPassenger?.suranceCompany = suranceInfo.suranceCompany
                    temPassenger?.suranceDesc = suranceInfo.suranceDesc
                    temPassenger?.suranceId = suranceInfo.suranceId
                    temPassenger?.suranceName = suranceInfo.suranceName
                    temPassenger?.suranceProductNo = suranceInfo.suranceProductNo
                    temPassenger?.suranceSalePrice = suranceInfo.suranceSalePrice
                    temPassenger?.count = insuranceNum.description
                    request.surances.append(temPassenger!)
                    
                }
            }
        }
        
        
        request.linkmanName = localLinkmanName.value
        request.linkmanEmail = localLinkmanEmail.value
        request.linkmanMobile = localLinkmanMobile.value
        switch personalFlightOrderViewType {
        case .PersonalFlight:
            request.orderType = "1"
        case .PersonalSpecialFlight: // 定投
            request.orderType = "3"
            request.productNo = specialFlightTrip.first?.id ?? ""
        case .PersonalOnsaleFlight:
            request.orderType = "2"
            request.productNo = onsaleFlightTrip.first?.productId ?? ""
        default:break
        }
       
        // 国内
        if isFlightNation == false {
            request.isInterQuery = "0"
        }else{ //国际
            request.isInterQuery = "1"
        }
        
        
        
        
        
        for element in selectedPassengerArr {
            let tmpPassenger:CommitParamVOModel.TravellerCommitInfoVO = CommitParamVOModel.TravellerCommitInfoVO()
            tmpPassenger.personName = element.chName
            tmpPassenger.birthday = element.birthday
            tmpPassenger.mobile = element.mobile
            tmpPassenger.personEnName = element.enNameFirst + "/" + element.enNameSecond
            tmpPassenger.gender = element.gender
            if isFlightNation == false {
                if element.certNo.isEmpty == false {
                    tmpPassenger.certNo = element.certNo
                    tmpPassenger.certType = "1"
                }else {
                    tmpPassenger.certType = "2"
                    tmpPassenger.certNo = element.passportNo
                    tmpPassenger.certExpire = element.passportExpireDate
                }
            }else{
                if element.passportNo.isEmpty == false {
                    tmpPassenger.certType = "2"
                    tmpPassenger.certNo = element.passportNo
                    tmpPassenger.certExpire = element.passportExpireDate
                }else {
                    tmpPassenger.certNo = element.certNo
                    tmpPassenger.certType = "1"
                }
                
                
            }
            tmpPassenger.personType = element.isChild == true ? "2": "1"
            if insuranceStatus == true {
                tmpPassenger.insuranceCount = "1"
            }
            
            if personalFlightOrderViewType == AppModelCatoryENUM.PersonalFlight &&
                element.relationTypeLocal == PersonalTravellerInfoRequest.UserRelationShip.Myself {
               tmpPassenger.canUseAccountCode = "1"
            }
            
           
            
            
            request.passangers.append(tmpPassenger)
        }
        request.orderSource = "2"
        
        request.flights = convertCommitFlightCabins()
       
        
        
       
        weak var weakSelf = self
        PersonalFlightServices.sharedInstance
            .personalFlightSubmitOrder(request:request)
            .subscribe { (event) in
                switch event {
                case .next(let result):
                    if result.status == "0" {
                        if result.payStatus == "2" {
                            weakSelf?.showPaymentView(orderIdArr:result.orderIds)
                            
                        }else {
                        ///需要二次确认的订单成功
                          weakSelf?.flightNeedSecondSubmit(orderStatus: SubmitOrderFailureViewController.SubmitOrderStatus.Personal_Success_SecondSubmit)
                        }
                    }else {
                          weakSelf?.flightNeedSecondSubmit(orderStatus: SubmitOrderFailureViewController.SubmitOrderStatus.Personal_Failure_SecondSubmit)
                    }
                   
                printDebugLog(message: result)
                
                case .error(let error):
                    weakSelf?.flightNeedSecondSubmit(orderStatus: SubmitOrderFailureViewController.SubmitOrderStatus.Personal_Failure_Submit_Order)
                   // try? weakSelf?.validateHttp(error)
                case .completed:
                    break
                }
        }//.disposed(by: DisposeBag())
    }
    
    
    
    
    
    
    func convertCommitFlightCabins() -> [CommitParamVOModel.CommitFlightVO] {
        switch personalFlightOrderViewType {
        case .PersonalFlight:
            return convertCommonFlightTripCommitFlightCabins()
        case .PersonalSpecialFlight:
            return convertSpecialFlightTripCommitFlightCabins()
        case .PersonalOnsaleFlight:
            return convertOnsaleFlightTripCommitFlightCabins()
        default: break
            
        }
        return  [CommitParamVOModel.CommitFlightVO()]
    }
    
    
    /// 普通的航班行程 转化为提交
    func convertCommonFlightTripCommitFlightCabins()->[CommitParamVOModel.CommitFlightVO] {
        var resultArr:[PCommonFlightSVSearchModel.CabinVO] = Array()
        for element in commonFlightTrip {
            var selectedCabins:PCommonFlightSVSearchModel.CabinVO = PCommonFlightSVSearchModel.CabinVO()
            selectedCabins = (element.cabins[element.selectedCabinIndex ?? 0])
            resultArr.append(selectedCabins)
        }
        return searchResultCabinsInfoConvertCommitCabinsInfo(cabins: resultArr)
    }
    func searchResultCabinsInfoConvertCommitCabinsInfo(cabins:[PCommonFlightSVSearchModel.CabinVO]) -> [CommitParamVOModel.CommitFlightVO] {
        
        var resultArr:[CommitParamVOModel.CommitFlightVO] = Array()
        
        for element in cabins {
            let tmpCabins = CommitParamVOModel.CommitFlightVO()
            tmpCabins.cabinCacheId = element.cacheId
            tmpCabins.flightCacheId = element.flightCacheId
            resultArr.append(tmpCabins)
        }
        return resultArr
    }
    
    /// 定投酒店
    func convertSpecialFlightTripCommitFlightCabins() ->[CommitParamVOModel.CommitFlightVO]  {
        // 单程
         var resultArr:[CommitParamVOModel.CommitFlightVO] = Array()
        
        let selectedFlightTrip = PersonalSpecialFlightManager.shareInStance.selectedFlightTripInfoDraw()//selectedFlightTripDraw()
        let tmpCabins = CommitParamVOModel.CommitFlightVO()
        tmpCabins.cabinCacheId = selectedFlightTrip.last?.cabinInfos[(selectedFlightTrip.last?.selectedCabinsIndex) ?? 0].cabinCacheId ?? ""
        tmpCabins.flightCacheId = selectedFlightTrip.last?.flightCacheId ?? ""
        resultArr.append(tmpCabins)
        
//        for element in PersonalSpecialFlightManager.shareInStance.selectedFlightTripDraw() {
////            var selectedCabins:PCommonFlightSVSearchModel.CabinVO = PCommonFlightSVSearchModel.CabinVO()
////            selectedCabins = (element.cabins[element.selectedCabinIndex ?? 0])
////            resultArr.append(selectedCabins)
//
//
//
//        }
        return resultArr
    }
    
    /// 特惠酒店
    func convertOnsaleFlightTripCommitFlightCabins() ->[CommitParamVOModel.CommitFlightVO]  {
        
        var resultArr:[CommitParamVOModel.CommitFlightVO] = Array()
        for element in onsaleFlightTrip {
            let tmpCabin = CommitParamVOModel.CommitFlightVO()
            if element.flightNation == "1" {
                tmpCabin.cabinCacheId = element.cacheId
            } else {
                tmpCabin.cabinCacheId = element.cabins[element.selectedCabinIndex!].cacheId
            }
            tmpCabin.allCabinCacheId = element.cabins[element.selectedCabinIndex!].cacheId
            tmpCabin.flightCacheId = element.flightCacheId
            
            
            resultArr.append(tmpCabin)
            
            if element.flightTripType == "1" && element.flightNation == "1" {
                break
            }
            
        }
        printDebugLog(message: resultArr.first?.mj_keyValues())
        return resultArr
    }
    
    
    
    
    //MARk:-------UITableViewDataSource----
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6 + 1 + warmTipDefaultSection
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            
            return caculateSectionRow(section: section)
        }
        if section == 1 {
            if selectedPassengerArr.count == 0 {
                return 2
            }
            return selectedPassengerArr.count + 1
        }

        if section == 2 + warmTipDefaultSection {
            return 2
        }

        if section == 5  + warmTipDefaultSection {
            
            if personalFlightOrderViewType == AppModelCatoryENUM.PersonalFlight {
                return commonFlightTrip.count + 1
            }
            return 2
        }
        if section == 3 + warmTipDefaultSection {
            ///保险数组
            return suranceArr.count
        }
        if section == 4 + warmTipDefaultSection {
            ///发票数组
            if invoiceArr.count == 0{
                return 0
            }
            
        }
        
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        weak var weakSelf = self
        if indexPath.section == 0 { // 机票信息
            let flightInfoCell:FlightSelectHeaderTableCell = tableView.dequeueReusableCell(withIdentifier:orderTableViewFlightInfoCellIdentify) as! FlightSelectHeaderTableCell
            flightInfoCell.selectionStyle = UITableViewCellSelectionStyle.none
            configCell(cell:flightInfoCell , indexPath: indexPath)
            return flightInfoCell
            
            
        }
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                let passengerHeaderCell:PersonalFlightTableViewHeaderView = tableView.dequeueReusableCell(withIdentifier:orderTableViewSectionHeaderViewIdentify) as! PersonalFlightTableViewHeaderView
                passengerHeaderCell.selectionStyle = UITableViewCellSelectionStyle.none
                    passengerHeaderCell.fillDataSources(title:"乘机人")
                if selectedPassengerArr.count == 0{
                    passengerHeaderCell.rightButton.isHidden = true
                }else{
                    passengerHeaderCell.rightButton.isHidden = false
                    passengerHeaderCell.rightButton.setTitle("修改乘机人", for: .normal)
                    passengerHeaderCell.rightButton.addTarget(self, action: #selector(showChoicesPassengerView), for: .touchUpInside)
                }
                return passengerHeaderCell
            }
            let passengerInfoCell:VisaOrderCell = tableView.dequeueReusableCell(withIdentifier: orderTableViewPassengerInfoCellIdentify) as! VisaOrderCell
            let passengerPlaceHolder = "请添加乘客信息"
            var tmpname:String = passengerPlaceHolder
            if selectedPassengerArr.count > 0 {
                tmpname = selectedPassengerArr[indexPath.row - 1].chName
                if indexPath.row == selectedPassengerArr.count{
                    passengerInfoCell.lineLabel.isHidden = true
                }else{
                    passengerInfoCell.lineLabel.isHidden = false
                }
            }
            if tmpname.isEmpty == true {
                tmpname = selectedPassengerArr[indexPath.row - 1].enNameFirst +  selectedPassengerArr[indexPath.row - 1].enNameSecond
            }
            
            var leftStr = "第\(indexPath.row)人"
            if tmpname == passengerPlaceHolder { leftStr = "" }
            
            passengerInfoCell.setCell(leftStr:leftStr, rightStr:tmpname)
            
            return passengerInfoCell
        }
        if indexPath.section == 2 && warmTipDefaultSection == 1 {
            
            let cell :PersonalHotelSubmitTipSectionCellView = tableView.dequeueReusableCell(withIdentifier: tableViewHeaderSectionTipViewIdentify) as! PersonalHotelSubmitTipSectionCellView
            cell.fillDataSources(title: "温馨提示")
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
            
        }
        
        
        if indexPath.section == 2 + warmTipDefaultSection {// 联系人
            if indexPath.row == 0 {
                let contactHeaderCell:PersonalFlightTableViewHeaderView = tableView.dequeueReusableCell(withIdentifier:orderTableViewSectionHeaderViewIdentify) as! PersonalFlightTableViewHeaderView
                contactHeaderCell.selectionStyle = UITableViewCellSelectionStyle.none
                contactHeaderCell.fillDataSources(title:"联系人")
                 contactHeaderCell.rightButton.isHidden = true
                return contactHeaderCell
            }
            let contactInfoCell:VisaContactCell = tableView.dequeueReusableCell(withIdentifier: orderTableViewContactInfoCellIdentify) as! VisaContactCell
            contactInfoCell.fillDataSources(name: localLinkmanName.value, phone: localLinkmanMobile.value, email: localLinkmanEmail.value)
            contactInfoCell.nameField.rx.text.orEmpty.bind(to: localLinkmanName).addDisposableTo(disposeBag)
            contactInfoCell.phoneField.rx.text.orEmpty.bind(to: localLinkmanMobile).addDisposableTo(disposeBag)
            contactInfoCell.emailField.rx.text.orEmpty.bind(to: localLinkmanEmail).addDisposableTo(disposeBag)
            return contactInfoCell
        }
        
        
        if indexPath.section == 3 + warmTipDefaultSection {
            let cell:PersonalFlightInvoiceTableViewCell = tableView.dequeueReusableCell(withIdentifier:orderTableViewInsuranceInfoCellIdentify) as! PersonalFlightInvoiceTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            let suranceModel = suranceArr[indexPath.row]
            cell.fillDataSources(title: suranceModel.suranceName, content: "\(suranceModel.suranceSalePrice)元/位x \(insuranceNum)份", isOpen: boolArray[indexPath.row], indexPathCell: indexPath.row,suranceDes:suranceModel.suranceDesc)
            printDebugLog(message: "这是 计算保险 cell")
            printDebugLog(message: "\(insuranceNum)")
            cell.personalFlightInvoiceTableViewBlock = { selectedStatus,selectIndex in
                weakSelf?.modifyInsurance(selectedStatus: selectedStatus,selectIndex:selectIndex)
            }
            return cell
        }
        if indexPath.section == 4 + warmTipDefaultSection {
//            ///行程单
//            if billTypeStr == "行程单"{
//                ///邮寄地址
//                weak var weakSelf  = self
//                let cell:VisaOrderAddressCell = tableView.dequeueReusableCell(withIdentifier: "VisaOrderAddressCell") as! VisaOrderAddressCell
//                cell.fillCellExpress(type:invoiceStatus)
//
//                cell.addressCity.text = addressCity.value
//                cell.addressCity.rx.text.orEmpty.bind(to: addressCity).addDisposableTo(bag)
//
//                cell.addressStreet.text = addressStreet.value
//                cell.addressStreet.rx.text.orEmpty.bind(to: addressStreet).addDisposableTo(bag)
//
//                cell.provincePickerResultBlock = {(province,city,area)in
//                    weakSelf?.addressCity.value = province + city + area
//                }
//                cell.gtSwitch.addTarget(self, action: #selector(modifyInvoiceStatus(sender:)), for: UIControlEvents.valueChanged)
//                return cell
//            }else{
                ///发票
                weak var weakSelf  = self
                let cell:VisaBillCell = tableView.dequeueReusableCell(withIdentifier: orderTableViewInvoiceInfoCellIdentify) as! VisaBillCell
                cell.fillCell(isBill:invoiceStatus,type:invoiceTypeIndex,billName:"机票",billType:billTypeStr,typeArr:billTypeArr,valueArr: invoiceValueArr)
                cell.companyOrPersonalBlock = { btnTag in
                    weakSelf?.invoiceTypeIndex = btnTag
                    weakSelf?.orderTableView.reloadSections([4 + (weakSelf?.warmTipDefaultSection)!], with: .none)
                }
                cell.billTypeReturnBlock = { typeStr,valueStr in
                    weakSelf?.billTypeStr = typeStr
                    weakSelf?.billTypeValueStr = valueStr
                    weakSelf?.orderTableView.reloadData()
                }
                
                cell.personalName.text = invoicePersonalName.value
                cell.personalName.rx.text.orEmpty.bind(to: invoicePersonalName).addDisposableTo(bag)
                
                cell.companyHeader.text = invoiceCompanyHeader.value
                cell.companyHeader.rx.text.orEmpty.bind(to: invoiceCompanyHeader).addDisposableTo(bag)
                
                cell.companyTaxNum.text = invoiceCompanyTaxNum.value
                cell.companyTaxNum.rx.text.orEmpty.bind(to: invoiceCompanyTaxNum).addDisposableTo(bag)
                
                cell.companyBankName.text = invoiceCompanyBankName.value
                cell.companyBankName.rx.text.orEmpty.bind(to: invoiceCompanyBankName).addDisposableTo(bag)
                
                cell.companyBankNum.text = invoiceCompanyBankNum.value
                cell.companyBankNum.rx.text.orEmpty.bind(to: invoiceCompanyBankNum).addDisposableTo(bag)
                
                cell.companyAddress.text = invoiceCompanyAddress.value
                cell.companyAddress.rx.text.orEmpty.bind(to: invoiceCompanyAddress).addDisposableTo(bag)
                
                cell.companyPhone.text = invoiceCompanyPhone.value
                cell.companyPhone.rx.text.orEmpty.bind(to: invoiceCompanyPhone).addDisposableTo(bag)
                
                cell.addressCity.text = addressCity.value
                cell.addressCity.rx.text.orEmpty.bind(to: addressCity).addDisposableTo(bag)
                
                cell.addressStreet.text = addressStreet.value
                cell.addressStreet.rx.text.orEmpty.bind(to: addressStreet).addDisposableTo(bag)
                
                cell.provincePickerResultBlock = {(province,city,area)in
                    weakSelf?.addressCity.value = province + city + area
                    
                }
                
                cell.gtSwitch.addTarget(self, action: #selector(modifyInvoiceStatus(sender:)), for: UIControlEvents.valueChanged)
                return cell
//            }
            
        }
        
        if indexPath.section == 5 + warmTipDefaultSection {
            if indexPath.row == 0 {
                let contactHeaderCell:PersonalFlightTableViewHeaderView = tableView.dequeueReusableCell(withIdentifier:orderTableViewSectionHeaderViewIdentify) as! PersonalFlightTableViewHeaderView
                contactHeaderCell.selectionStyle = UITableViewCellSelectionStyle.none
                contactHeaderCell.fillDataSources(title:"退改规则")
                 contactHeaderCell.rightButton.isHidden = true
                return contactHeaderCell
            }
            var tipStr:String = ""
            
            switch personalFlightOrderViewType {
            case .PersonalFlight:
               
                if isRoundTrip == true {
                    if indexPath.row == 1 {
                        let eiStr:String = commonFlightTrip.first!.cabins[commonFlightTrip.first!.selectedCabinIndex ?? 0].ei
                        tipStr = "去" + eiStr
                        
                    }else {
                        let eiStr:String = commonFlightTrip.last!.cabins[commonFlightTrip.last!.selectedCabinIndex ?? 0].ei
                        tipStr = "返" + eiStr
                        
                    }
                }else{
                    let eiStr:String = commonFlightTrip.first!.cabins[commonFlightTrip.first!.selectedCabinIndex ?? 0].ei
                    tipStr = eiStr
                }
               
            case .PersonalOnsaleFlight:
                let eiStr:String = onsaleFlightTrip.first!.cabins[onsaleFlightTrip.first!.selectedCabinIndex ?? 0].ei
                tipStr = eiStr
            case .PersonalSpecialFlight:
                let eiStr:String = specialFlightTrip.last!.cabinInfos[specialFlightTrip.last?.selectedCabinsIndex ?? 0].cabinEi
                tipStr = eiStr
            default: break
            }
            let cell:VisaTitleCell = tableView.dequeueReusableCell(withIdentifier: "VisaTitleCell") as! VisaTitleCell
            cell.fillDataSources(visaName:tipStr)
            cell.titleLabel.textColor  = TBIThemeMinorTextColor
            cell.titleLabel.font = UIFont.systemFont(ofSize: 14)
            return cell
            
        }
        if indexPath.section == 6 + warmTipDefaultSection {
            let cell:PersonalFlightBookProtocolTableViewCell = tableView.dequeueReusableCell(withIdentifier: orderTableViewPersonalFlightBookProtocolCellIdentify) as! PersonalFlightBookProtocolTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.fillDataSources(content: "请提交前确认您已阅读预订条款")
            cell.personalFlightBookProtocolCellBlock = { selectedStatus in
                
                weakSelf?.protocolStatus = selectedStatus
            }
            return cell
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: orderTableViewCellRegularIdentify)
        //cell?.textLabel?.text = indexPath.row.description
        
        return cell!
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0  {
            
                switch personalFlightOrderViewType {
                case .PersonalFlight:
                    if commonFlightTrip[indexPath.row].flightInfos.first?.share ?? false{
                        return 170
                    }
                case .PersonalSpecialFlight:
                    return 145
                case .PersonalOnsaleFlight:
                    return 145
                default: break
                    
                }
            
           return 145
        }
        if indexPath.section == 5 + warmTipDefaultSection{
            if indexPath.row>0{
                return UITableViewAutomaticDimension
            }
        }
        if indexPath.section == 2 && warmTipDefaultSection == 1{
            return 15
        }
        if indexPath.section == 2  + warmTipDefaultSection{
           
            return indexPath.row == 0 ? 45:132
        }
        if invoiceStatus && indexPath.section == 4 + warmTipDefaultSection {
            ///行程单：45*3 发票：个人 45*5，公司：45*10
            if invoiceStatus{
                
                if billTypeStr == "行程单"{
                    return 180
                }else if billTypeStr == "前台索要"{
                    return 90
                }else if billTypeStr == "电子发票"{
                    return invoiceTypeIndex == 0 ? 225 : 450
                }else{
                    return invoiceTypeIndex == 0 ? 315 : 540
                }
                
            }else{
                return 45
            }
            

        }else{
            return 45
        }
       
        
        return 44
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section == 1 || section == 2  {
//            return 55
//        }
        if section == 6 + warmTipDefaultSection {
            return 0
        }
        if section == 4 + warmTipDefaultSection {
            ///发票数组
            if invoiceArr.count == 0{
                return 0
            }
            
        }
        if section == 3 + warmTipDefaultSection {
            ///发票数组
            if suranceArr.count == 0{
                return 0
            }
            
        }
        if section == 0 {
            return 0
        }
        return 10
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
            let view:UIView = UIView()
            view.backgroundColor = TBIThemeBaseColor
            return view
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if selectedPassengerArr.count == 0{
                showChoicesPassengerView()
            }
            
        }
        
        if indexPath.section == 2 {
            
            popPersonalNewAlertView(content:personalFlightWarmTipDefault,titleStr:"温馨提示",btnTitle:"确定")
        }
        if indexPath.section == 3 + warmTipDefaultSection {
            
            let suranceModel = suranceArr[indexPath.row]
            if suranceModel.suranceDesc.isNotEmpty{
                popPersonalNewAlertView(content:suranceModel.suranceDesc,titleStr:"保险内容",btnTitle:"确定")
            }
        }
        
        if indexPath.section == 5 + warmTipDefaultSection {
            var tipStr:String = ""
            
            switch personalFlightOrderViewType {
            case .PersonalFlight:
               
                if isRoundTrip == true {
                    if indexPath.row == 1 {
                        tipStr = "去" + (commonFlightTrip.first?.cabins[commonFlightTrip.first?.selectedCabinIndex ?? 0].ei ?? "")
                        
                    }
                    else {tipStr = "返" + (commonFlightTrip.last?.cabins[commonFlightTrip.last?.selectedCabinIndex ?? 0].ei ?? "")}
                }else{
                    tipStr = (commonFlightTrip.first?.cabins[commonFlightTrip.first?.selectedCabinIndex ?? 0].ei ?? "")
                }
                
            case .PersonalOnsaleFlight:
                let eiStr:String = onsaleFlightTrip.first!.cabins[onsaleFlightTrip.first!.selectedCabinIndex ?? 0].ei
                tipStr = eiStr
            case .PersonalSpecialFlight:
                let eiStr:String = specialFlightTrip.last!.cabinInfos[specialFlightTrip.last?.selectedCabinsIndex ?? 0].cabinEi
                tipStr = eiStr
            default: break
            }
            popPersonalNewAlertView(content:tipStr,titleStr:"退改签说明",btnTitle:"确定")
        }
        
        if indexPath.section == 6 + warmTipDefaultSection {
            let vc:PersonlBookNotesViewController = PersonlBookNotesViewController()
            vc.idStr = "flight"
            self.navigationController?.pushViewController(vc, animated: true)
        }
       
    }
    
    //MARK:----------Cell------
    
    func caculateSectionRow(section:NSInteger) ->NSInteger {
        switch personalFlightOrderViewType {
        case .PersonalFlight:
            return caculateCommonFlightTrip(section: section)
        case .PersonalSpecialFlight:
            return caculateSpecialFlightTrip(section:section)
        case .PersonalOnsaleFlight:
            return caculateOnsaleFlightTrip(section:section)
        default:break
            
        }
        return 0
    }
    
    func caculateCommonFlightTrip(section:NSInteger) ->NSInteger {
        return commonFlightTrip.count
        
    }
    
    func caculateSpecialFlightTrip(section:NSInteger) ->NSInteger {
        return specialFlightTrip.count
    }
    func caculateOnsaleFlightTrip(section:NSInteger) ->NSInteger {
        return onsaleFlightTrip.count
        
    }
    
    
    
    
    func configCell(cell:FlightSelectHeaderTableCell,indexPath:IndexPath) {
        
        switch personalFlightOrderViewType {
        case .PersonalFlight:
            personalCommonFlightTrip(cell: cell,indexPath: indexPath)
        case .PersonalSpecialFlight:
            personalSpecialFlightTripCell(cell: cell, indexPath: indexPath)
        case .PersonalOnsaleFlight:
            personalOnsaleFlightTrip(cell:cell , indexPath: indexPath)
        default: break
            
        }
        
        
    }
    
    
    func personalCommonFlightTrip(cell:FlightSelectHeaderTableCell,indexPath:IndexPath) {
        
        cell.personalFlightFillDataSources(flightTripItem: commonFlightTrip[indexPath.row].flightInfos, row: indexPath.row)
        if commonFlightTrip.count > 1
        {
            cell.typeLabel.isHidden = false
            if indexPath.row == 0{
                
                cell.typeLabel.text = "去 "
            }else{
                cell.typeLabel.text = "返 "
            }
        }else{
            cell.typeLabel.isHidden = true
        }
    }
    
    func personalSpecialFlightTripCell(cell:FlightSelectHeaderTableCell,indexPath:IndexPath) {
        ///定投
        
       //cell.personalSpecialFlightFillDataSources(flightTripItem:specialFlightTrip , row: indexPath.row)
        cell.personalSpecialFlightInfoFillDataSources(flightTripItem: specialFlightTrip, row: indexPath.row)
        if specialFlightTrip.count > 1
        {
            cell.typeLabel.isHidden = false
            if indexPath.row == 0{
                
                cell.typeLabel.text = "去 "
            }else{
                cell.typeLabel.text = "返 "
            }
        }else{
            cell.typeLabel.isHidden = true
        }
        
        
    }
    func personalOnsaleFlightTrip(cell:FlightSelectHeaderTableCell,indexPath:IndexPath) {
        
        cell.personalFlightFillDataSources(flightTripItem: onsaleFlightTrip[indexPath.row].flightInfos, row: indexPath.row)
         if onsaleFlightTrip.count > 1
        {
            cell.typeLabel.isHidden = false
            if indexPath.row == 0{
                
                cell.typeLabel.text = "去 "
            }else{
                cell.typeLabel.text = "返 "
            }
         }else{
            cell.typeLabel.isHidden = true
        }
    }
    
    
    
    //MARK:-------Action------
    override func backButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func modifyInvoiceStatus(sender:UISwitch) {
        invoiceStatus = sender.isOn
        orderTableView.reloadSections([4 + warmTipDefaultSection], with: UITableViewRowAnimation.none)
    }
    
    func modifyInsurance(selectedStatus:Bool,selectIndex:NSInteger) {
        boolArray[selectIndex] = selectedStatus
        caculateAmount()
    }
    
    
    
    

}
