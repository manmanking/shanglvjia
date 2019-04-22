//
//  VisaWriteInfoViewController.swift
//  shanglvjia
//
//  Created by tbi on 2018/7/18.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import SwiftDate
import RxSwift

class VisaWriteInfoViewController: PersonalBaseViewController,PayManagerStateProtocol {
    
    
    public var visaItem:VisaProductListResponse.BaseVisaProductListVo = VisaProductListResponse.BaseVisaProductListVo()
    
    
    public var travelSuranceArr:[VisaOrderAddResquest.TravelSuranceResponse] = Array()
    
    public var delayDay:NSInteger = 0
    
    // 出行人
    public var peopleCount:Int = 1
    
    
    /// 是否需要二次确认   "0不需要tc二次确认；1需要tc二次确认
    public var needTcconfirm:String = "0"
    
    /// 邮箱
    public var email:String = ""
    
    ///是否选择发票
    public var isBill: Bool = false
    ///个人 公司
    public var typeIndex: NSInteger = 0
    ///自提 到付
    public var sendTypeIndex: NSInteger = 0
    ///发票类型数组
    public var invoiceArr:[PTravelNearbyDetailModel.InvoicesModel] = Array()
    
    public var billTypeStr : String = ""
    public var billTypeValueStr : String = ""
    fileprivate var invoiceTitleArr:[String] = Array()
    fileprivate var invoiceValueArr:[String] = Array()
    
    ///是否同意条款
    public var isSelected: Bool = false
    
    fileprivate var detailTable = UITableView()
    
    fileprivate let footerView:TravelPriceInfoView = TravelPriceInfoView()
    let bag = DisposeBag()
    //一个人单价
    fileprivate var countPrice:Double = 0
    
    fileprivate var localtotalPrice:Float = 0
    
    
    fileprivate var travelSuranceValueArr:[Bool] = Array()
    
    fileprivate let visaSuranceTableViewCellIdentify:String = "visaSuranceTableViewCellIdentify"
    
    ///价格明细
    fileprivate var priceArr:[(priceTitle:String,price:String)] = Array()
    /// 出发日期
    fileprivate var leaveTime:String = ""
    
    fileprivate var contactName:Variable = Variable("")
    fileprivate var contactPhone:Variable = Variable("")
    fileprivate var contactEmail:Variable = Variable("")
    
    ///发票信息
    fileprivate var personalName:Variable = Variable("")
    fileprivate var companyHeader:Variable = Variable("")
    fileprivate var companyTaxNum:Variable = Variable("")
    fileprivate var companyBankName:Variable = Variable("")
    fileprivate var companyBankNum:Variable = Variable("")
    fileprivate var companyAddress:Variable = Variable("")
    fileprivate var companyPhone:Variable = Variable("")
    ///地址
    fileprivate var addressCity:Variable = Variable("")
    fileprivate var addressStreet:Variable = Variable("")
    
    ///地址
    fileprivate var sendAddressCity:Variable = Variable("")
    fileprivate var sendAddressStreet:Variable = Variable("")
    
    public var selectedPassengerArr:[PersonalTravellerInfoRequest] = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillDataSources()
        initTableView()
        initFooterView()
        PayManager.sharedInstance.delegate = self
        
        
    }
    
    func fillDataSources() {
        
        contactName = Variable(DBManager.shareInstance.personalContactNameDraw())
        contactPhone = Variable(DBManager.shareInstance.personalContactPhoneDraw())
        contactEmail = Variable(DBManager.shareInstance.personalContactEmailDraw())
        
        if invoiceArr.count>0{
            for model in invoiceArr{
                invoiceTitleArr.append(model.name)
                invoiceValueArr.append(model.value)
            }
            billTypeStr = invoiceTitleArr[0]
            billTypeValueStr = invoiceValueArr[0]
        }
        
        travelSuranceValueArr.removeAll()
        for _ in travelSuranceArr {
            travelSuranceValueArr.append(false)
        }
        personalBaseInfoNET()
        
    }
    
    func caculateAmount() {
        
        
        
        
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setBlackTitleAndNavigationColor(title: "填写信息")
        self.view.backgroundColor = TBIThemeBaseColor
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func initTableView() {
        self.view.addSubview(detailTable)
        detailTable.backgroundColor = TBIThemeBaseColor
        detailTable.separatorStyle=UITableViewCellSeparatorStyle.none
        // 设置预估行高 --> 先让 tableView 能滚动，在滚动的时候再去计算显示的 cell 的真正的行高，并且调整 tabelView 的滚动范围
        detailTable.estimatedRowHeight = 200
        detailTable.delegate = self
        detailTable.dataSource = self
        detailTable.bounces = false
        detailTable.rowHeight = UITableViewAutomaticDimension
        detailTable.tableFooterView = initTableFooterView()
        detailTable.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(1)
            make.bottom.equalToSuperview().inset(54)
        }
        detailTable.register(VisaContactCell.self, forCellReuseIdentifier: "VisaContactCell")
        detailTable.register(VisaTitleCell.self, forCellReuseIdentifier: "VisaTitleCell")
        detailTable.register(VisaOrderCell.self, forCellReuseIdentifier: "VisaOrderCell")
        detailTable.register(VisaBillCell.self, forCellReuseIdentifier: "VisaBillCell")
        detailTable.register(VisaOrderAddressCell.self, forCellReuseIdentifier: "VisaOrderAddressCell")
        detailTable.register(PersonalFlightInvoiceTableViewCell.self, forCellReuseIdentifier: visaSuranceTableViewCellIdentify)
        
        //fillDataSource()
        //personalBaseInfoNET()
    }
    
    func initFooterView(){
        self.view.addSubview(footerView)
        footerView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(54)
        }
        footerView.submitButton.setTitle("提交订单", for: UIControlState.normal)
        //footerView.fillDataSources(visaItemPrice: visaItem.saleRate.TwoOfTheEffectiveFraction(), visaProductName: visaItem.visaName, visaCount:peopleCount)
        priceArr.append((priceTitle: visaItem.visaName, price: "¥\(visaItem.saleRate.TwoOfTheEffectiveFraction())x\(peopleCount)"))
        
        var visaItemPriceFloat:Float = 0
        
        if visaItem.saleRate.TwoOfTheEffectiveFraction().isEmpty == false {
            visaItemPriceFloat = Float(visaItem.saleRate.TwoOfTheEffectiveFraction()) ?? 0
        }
        localtotalPrice = visaItemPriceFloat
        footerView.totalPriceLabel.text = visaItemPriceFloat.TwoOfTheEffectiveFraction()
        footerView.setViewWithArray(dataArr:priceArr)
        
        KeyWindow?.addSubview(footerView.backBlackView)
        footerView.priceButton.addTarget(self, action: #selector(priceInfo(sender:)), for: .touchUpInside)
        footerView.priceButton.addTarget(self, action: #selector(priceInfo(sender:)), for: .touchUpInside)
        footerView.submitButton.addTarget(self, action: #selector(submitOrder(sender:)), for: .touchUpInside)
    }
    func initTableFooterView() ->PersonalProtocalView{
        let tableFooter:PersonalProtocalView = PersonalProtocalView.init(frame: CGRect(x:0,y:0,width:ScreenWindowWidth,height:33))
        weak var weakSelf = self
        ///点击block
        tableFooter.viewClickBlock = {
            let vc:PersonlBookNotesViewController = PersonlBookNotesViewController()
            vc.idStr = "visa"
            weakSelf?.navigationController?.pushViewController(vc, animated: true)
        }
        tableFooter.selectClickBlock = {(isSelect) in
            weakSelf?.isSelected = isSelect
        }
        return tableFooter
    }
    func showPaymentView(orderId:String) {
        weak var weakSelf = self
        let payView:SelectPaymentView = SelectPaymentView(frame:ScreenWindowFrame)
        let amountPrices = localtotalPrice.TwoOfTheEffectiveFraction()
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
                weakSelf?.visaNeedSecondSubmit(orderStatus: SubmitOrderFailureViewController.SubmitOrderStatus.Personal_Success_nopay)
            default:
                break
            }
            weakSelf?.choicePaymentType(type:paymentType, orderId: orderId)
            
        }
        KeyWindow?.addSubview(payView)
    }
    
    //MARK: -------- NET ------
    
    
    func personalBaseInfoNET(){
        weak var weakSelf = self
        PersonalMineService.sharedInstance.queryPersonalBaseInfo()
            .subscribe { (event) in
                switch event {
                case .next(let result):
                    
                    printDebugLog(message: result.mj_keyValues())
                    
                    weakSelf?.addressCity.value = result.province + result.city + result.distrct
                    weakSelf?.addressStreet.value = result.address
                    weakSelf?.personalName.value = result.cnName
                    weakSelf?.companyHeader.value = result.invoiceTitle
                    weakSelf?.companyTaxNum.value = result.taxIdCode
                    weakSelf?.companyBankName.value = result.bank
                    weakSelf?.companyBankNum.value = result.bankAccount
                    weakSelf?.companyAddress.value = result.companyAddress
                    weakSelf?.companyPhone.value = result.bankFax
                    weakSelf?.detailTable.reloadData()
                    
                case .error:
                    
                    break
                case .completed:
                    break
                }
        }
    }
    
    
    //MARK: -------- Action ------
    override func backButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //提交订单
    func submitOrder(sender: UIButton) {
        ///提交==隐藏费用明细
        footerView.priceButton.isSelected = false
        footerView.backBlackView.isHidden = true
        
        guard leaveTime.isEmpty == false else {
            showSystemAlertView(titleStr: "提示", message: "请填写出发日期")
            return
        }
        
        guard contactName.value.isEmpty == false else {
            showSystemAlertView(titleStr: "提示", message: "请填写联系人姓名")
            return
        }
        guard contactPhone.value.isEmpty == false  else {
            showSystemAlertView(titleStr: "提示", message: "请填写联系人手机号")
            return
        }
        guard contactPhone.value.validate(ValidateType.phone) == true else{
            showSystemAlertView(titleStr: "提示", message: "手机号格式错误")
            return
        }
        guard contactEmail.value.isEmpty == false  else {
            showSystemAlertView(titleStr: "提示", message: "请填写联系人邮箱")
            return
        }
        guard contactEmail.value.validate(ValidateType.email) == true else{
            showSystemAlertView(titleStr: "提示", message: "邮箱格式错误")
            return
        }
        
        
        DBManager.shareInstance.personalContactNameStore(name: contactName.value)
        DBManager.shareInstance.personalContactPhoneStore(phone: contactPhone.value)
        DBManager.shareInstance.personalContactEmailStore(email: contactEmail.value)
        
        
        guard selectedPassengerArr.count > 0 else {
            showSystemAlertView(titleStr: "提示", message: "请填写出行人")
            return
        }
        if isSelected == false{
            showSystemAlertView(titleStr: "提示", message: "请先阅读预订条款")
            return
        }
        
        let visaMaxDate:Date = (leaveTime.stringToDate(dateFormat: "yyyy-MM-dd") + visaPassportMaxDate.month)
        for element in selectedPassengerArr {
            let passportIdExpridDate = element.passportExpireDate.stringToDate(dateFormat: "yyyy-MM-dd")
            
            if visaMaxDate.compare(passportIdExpridDate) == .orderedDescending {
                let nameStr = element.chName.isEmpty ?  element.enNameFirst + element.enNameSecond : element.chName
                showSystemAlertView(titleStr: "提示", message: nameStr + "的护照即将到期，请您更新护照后继续办理")
                return
            }
        }
        
        
        
        
        let request:VisaOrderAddResquest = VisaOrderAddResquest()
        let expense = VisaOrderAddResquest.VisaOrderExpenseResquest()
        
        // 发票信息
        if isBill {
            request.needInvoice = "1"
            request.expense = expense
            if billTypeStr == "电子发票" ||  billTypeStr == "纸质发票"{
                if typeIndex == 0 {
                    if personalName.value.isEmpty == true {
                        showSystemAlertView(titleStr: "提示", message: "请填写个人发票姓名")
                        return
                    }
                    expense.exPersonName = personalName.value
                    
                }else{
                    
                    if companyHeader.value.isEmpty == true || companyTaxNum.value.isEmpty == true ||
                        companyBankName.value.isEmpty == true || companyBankNum.value.isEmpty == true ||
                        companyAddress.value.isEmpty == true || companyPhone.value.isEmpty == true {
                        showSystemAlertView(titleStr: "提示", message: "请输入正确的公司发票信息")
                        return
                    }
                    expense.exTitle = companyHeader.value
                    expense.exItin = companyTaxNum.value
                    expense.exBank = companyBankName.value
                    expense.exBankNo = companyBankNum.value
                    expense.exCompanyAddress = companyAddress.value
                    expense.exCompanyPhone = companyPhone.value
                    
                    
                }
                if billTypeStr == "电子发票"{
                    expense.address = ""
                }else{
                    if addressCity.value.isEmpty == true || addressStreet.value.isEmpty == true{
                        showSystemAlertView(titleStr: "提示", message: "请输入地址信息")
                    }
                    expense.address = addressCity.value + addressStreet.value
                }
                ///个人或公司
                expense.exType = typeIndex.description
            }
            if billTypeStr == "行程单"{
                expense.address = addressCity.value + addressStreet.value
            }
            expense.exKind = billTypeValueStr
            expense.exContent = "代办签证"
            
            var visaItemPriceFloat:Float = 0
            visaItemPriceFloat = visaItem.saleRate
            visaItemPriceFloat = visaItemPriceFloat * Float(peopleCount)
            expense.exAmount = visaItemPriceFloat.OneOfTheEffectiveFraction()
        }
        
        // 保险
        request.surances.removeAll()
        for (index,element) in travelSuranceValueArr.enumerated() {
            if element == true {
                request.surances.append(travelSuranceArr[index])
            }
        }
        let isNeed:[Bool] = travelSuranceValueArr.filter { (element) -> Bool in
            if element == true {return true}
            return false
        }
        
        if isNeed.count > 0 {
            request.needSurance = "1"
        }
        
        for element in selectedPassengerArr {
            request.passengers.append(element.convertPassengerModel())
        }
        
        //        for element in selectedPassengerArr {
        //            let temPassenger = VisaOrderAddResquest.BaseVisaPassengerVo()
        //            temPassenger.vpName = element.enNameFirst + element.enNameSecond
        //            temPassenger.vpPassportno = element.passportNo
        //            request.passengers.append(temPassenger)
        //        }
        
        // 联系人
        request.deptDate = leaveTime
        request.contactEmail = contactEmail.value
        request.contactPhone = contactPhone.value
        request.contactName = contactName.value
        request.orderCount = peopleCount.description
        request.productName = visaItem.visaName
        
        request.productId = visaItem.id
        
        
        ///是否需要寄送
        request.needSend = sendTypeIndex.description
        if sendTypeIndex == 1{
            request.address = "\(sendAddressCity.value)\(sendAddressStreet.value)"
        }else{
            request.address = ""
        }
        
        
        weak var weakSelf = self
        showLoadingView()
        VisaServices.sharedInstance
            .submitOrder(request: request)
            .subscribe { (event) in
                weakSelf?.hideLoadingView()
                switch event {
                case .next(let element):
                    printDebugLog(message: element)
                    print("into here ....")
                    if element.orderStatus == "1" {
                        weakSelf?.visaNeedSecondSubmit(orderStatus: SubmitOrderFailureViewController.SubmitOrderStatus.Personal_Success_SecondSubmit)
                        
                    }else {
                        weakSelf?.showPaymentView(orderId:element.orderNo)//DEBUG_PaymentWechat_Num
                    }
                    
                case .error(_):
                    weakSelf?.intoNextSubmitOrderFailureView(orderStatus: SubmitOrderFailureViewController.SubmitOrderStatus.Personal_Failure_SecondSubmit)
                case .completed:
                    break
                    
                }
            }.addDisposableTo(self.bag)
    }
    
    func choicePaymentType(type:PaymentType,orderId:String) {
        switch type {
        case PaymentType.AliPay:
            aliPayOrderInfo(type: type,orderId: orderId)
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
    
    
    
    func visaNeedSecondSubmit(orderStatus:SubmitOrderFailureViewController.SubmitOrderStatus) {
        intoNextSubmitOrderFailureView(orderStatus: orderStatus)
    }
    
    
    //MARK:------PayManagerDelegate
    func payManagerDidRecvFailureInfo(parameters: Dictionary<String, Any>?) {
        printDebugLog(message: "failure")
        intoNextSubmitOrderFailureView(orderStatus: SubmitOrderFailureViewController.SubmitOrderStatus.Personal_Failure_Payment)
        
        
    }
    func payManagerDidRecvSuccessInfo(parameters: Dictionary<String, Any>?) {
        printDebugLog(message: "success")
        intoNextSubmitOrderFailureView(orderStatus:SubmitOrderFailureViewController.SubmitOrderStatus.Personal_Success_Payment)
    }
    
    
    //支付状态页面
    func intoNextSubmitOrderFailureView(orderStatus:SubmitOrderFailureViewController.SubmitOrderStatus) {
        let submitOrderFailureView = SubmitOrderFailureViewController()
        submitOrderFailureView.submitOrderViewType = .PersonalVisa
        submitOrderFailureView.submitOrderStatus = orderStatus
        self.navigationController?.pushViewController(submitOrderFailureView, animated: true)
    }
    
    
    
}
extension VisaWriteInfoViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5 + 1 +  (invoiceArr.count == 0 ? 0 : 1)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 4 {
            return travelSuranceArr.count
        }
        if section == 2{
            if selectedPassengerArr.count == 0{
                return 1
            }else{
                return peopleCount
            }
        }
        return  1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }else if section == 2 || section == 3{
            return 55
        }else{
            if section == 4 && travelSuranceArr.count == 0{
                return 0
            }
            return 10
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 4 + 2 {
            ///行程单：45*4 发票：个人 45*5，公司：45*10
            if isBill{
                if billTypeStr == "行程单"{
                    return 180
                }else if billTypeStr == "前台索要"{
                    return 90
                }else if billTypeStr == "电子发票"{
                    return typeIndex == 0 ? 225 : 450
                }else{
                    return typeIndex == 0 ? 315 : 540
                }
                
            }else{
                return 45
            }
        }else{
            if indexPath.section == 4 {
                return 55
                
            }
            if indexPath.section == 5{
                ///邮寄地址
                ///return sendTypeIndex == 0 ? 45 : 135
                return 135
            }
            
            return indexPath.section == 3 ? 132 : UITableViewAutomaticDimension
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 2 || section == 3 {
            let headView:VisaSectionHeaderView = VisaSectionHeaderView()
            headView.titleLabel.text = section == 2 ? "出行人" : "联系人"
            if section == 2{
                if selectedPassengerArr.count == 0{
                     headView.rightButton.isHidden = true
                }else{
                     headView.rightButton.isHidden = false
                     headView.rightButton.setTitle("修改出行人", for: .normal)
                    headView.rightButton.addTarget(self, action: #selector(modifyPassengers), for: .touchUpInside)
                }
            }else{
                headView.rightButton.isHidden = true
            }
            return headView
        }else{
            let view:UIView = UIView()
            view.backgroundColor = TBIThemeBaseColor
            return view
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        ///联系人
        if indexPath.section == 3{
            let cell:VisaContactCell = tableView.dequeueReusableCell(withIdentifier: "VisaContactCell") as! VisaContactCell
            cell.fillDataSources(name:contactName.value,phone:contactPhone.value,email:contactEmail.value)
            
            cell.nameField.rx.text.orEmpty.bind(to: contactName).addDisposableTo(bag)
            cell.phoneField.rx.text.orEmpty.bind(to: contactPhone).addDisposableTo(bag)
            cell.emailField.rx.text.orEmpty.bind(to: contactEmail).addDisposableTo(bag)
            contactName.value = cell.nameField.text!
            contactPhone.value = cell.phoneField.text!
            contactEmail.value = cell.emailField.text!
            
            return cell
        }else if indexPath.section == 0{
            ///订单标题
            let cell:VisaTitleCell = tableView.dequeueReusableCell(withIdentifier: "VisaTitleCell") as! VisaTitleCell
            cell.fillDataSources(visaName:visaItem.visaName)
            cell.titleLabel.font = UIFont.systemFont(ofSize: 14)
            return cell
        } else if indexPath.section == 4 {
            weak var weakSelf = self
            let cell:PersonalFlightInvoiceTableViewCell = tableView.dequeueReusableCell(withIdentifier:visaSuranceTableViewCellIdentify) as! PersonalFlightInvoiceTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.fillDataSources(title: travelSuranceArr[indexPath.row].suranceName, content: "\(travelSuranceArr[indexPath.row].suranceSalePrice.floatValue)/人x \(selectedPassengerArr.count)份", isOpen: travelSuranceValueArr[indexPath.row], indexPathCell: indexPath.row,suranceDes:travelSuranceArr[indexPath.row].suranceDesc)
            cell.personalFlightInvoiceTableViewBlock = { selectedStatus,selectedIndex in
                weakSelf?.travelSuranceValueArr[selectedIndex] = selectedStatus
                weakSelf?.calculatePriceInfo()
            }
            return cell
            
            
            
        }else if indexPath.section == 4 + 2{
            ///发票
            weak var weakSelf  = self
            let cell:VisaBillCell = tableView.dequeueReusableCell(withIdentifier: "VisaBillCell") as! VisaBillCell
            cell.fillCell(isBill:isBill,type:typeIndex,billName:"代办签证",billType:billTypeStr,typeArr:invoiceTitleArr, valueArr: invoiceValueArr)
            cell.companyOrPersonalBlock = { btnTag in
                weakSelf?.typeIndex = btnTag
                weakSelf?.detailTable.reloadData()
            }
            cell.billTypeReturnBlock = { typeStr,valueStr in
                weakSelf?.billTypeStr = typeStr
                weakSelf?.billTypeValueStr = valueStr
                weakSelf?.detailTable.reloadData()
            }
            
            cell.personalName.text = personalName.value
            cell.personalName.rx.text.orEmpty.bind(to: personalName).addDisposableTo(bag)
            
            cell.companyHeader.text = companyHeader.value
            cell.companyHeader.rx.text.orEmpty.bind(to: companyHeader).addDisposableTo(bag)
            
            cell.companyTaxNum.text = companyTaxNum.value
            cell.companyTaxNum.rx.text.orEmpty.bind(to: companyTaxNum).addDisposableTo(bag)
            
            cell.companyBankName.text = companyBankName.value
            cell.companyBankName.rx.text.orEmpty.bind(to: companyBankName).addDisposableTo(bag)
            
            cell.companyBankNum.text = companyBankNum.value
            cell.companyBankNum.rx.text.orEmpty.bind(to: companyBankNum).addDisposableTo(bag)
            
            cell.companyAddress.text = companyAddress.value
            cell.companyAddress.rx.text.orEmpty.bind(to: companyAddress).addDisposableTo(bag)
            
            cell.companyPhone.text = companyPhone.value
            cell.companyPhone.rx.text.orEmpty.bind(to: companyPhone).addDisposableTo(bag)
            
            cell.addressCity.text = addressCity.value
            cell.addressCity.rx.text.orEmpty.bind(to: addressCity).addDisposableTo(bag)
            
            cell.addressStreet.text = addressStreet.value
            cell.addressStreet.rx.text.orEmpty.bind(to: addressStreet).addDisposableTo(bag)
            
            cell.provincePickerResultBlock = {(province,city,area)in
                weakSelf?.addressCity.value = province + city + area
            }
            
            cell.gtSwitch.addTarget(self, action: #selector(switchBill(sender:)), for: UIControlEvents.valueChanged)
            return cell
        }else if indexPath.section == 5{
            ///邮寄地址
            weak var weakSelf  = self
            let cell:VisaOrderAddressCell = tableView.dequeueReusableCell(withIdentifier: "VisaOrderAddressCell") as! VisaOrderAddressCell
            cell.fillCell(type:sendTypeIndex)
            cell.companyOrPersonalBlock = { btnTag in
                weakSelf?.sendTypeIndex = btnTag
                weakSelf?.detailTable.reloadData()
            }
            cell.addressCity.text = sendAddressCity.value
            cell.addressCity.rx.text.orEmpty.bind(to: sendAddressCity).addDisposableTo(bag)
            
            cell.addressStreet.text = sendAddressStreet.value
            cell.addressStreet.rx.text.orEmpty.bind(to: sendAddressStreet).addDisposableTo(bag)
            
            cell.provincePickerResultBlock = {(province,city,area)in
                weakSelf?.sendAddressCity.value = province + city + area
            }
            return cell
        }else{
            let cell:VisaOrderCell = tableView.dequeueReusableCell(withIdentifier: "VisaOrderCell") as! VisaOrderCell
            ///出行人
            if indexPath.section == 2{
                cell.arrowImage.isHidden = true
                if selectedPassengerArr.count == 0{
                    cell.lineLabel.isHidden = true
                    cell.setCell(leftStr: "", rightStr: "请选择\(peopleCount)位出行人")
                }else{
                    if indexPath.row == peopleCount - 1{
                        cell.lineLabel.isHidden = true
                    }else{
                        cell.lineLabel.isHidden = false
                    }
                    var name:String = ""
                    if selectedPassengerArr.count > indexPath.row {
                        name = (selectedPassengerArr[indexPath.row].chName.isEmpty ? "\(selectedPassengerArr[indexPath.row].enNameFirst) \(selectedPassengerArr[indexPath.row].enNameSecond)":selectedPassengerArr[indexPath.row].chName)
                    }
                    
                    
                    cell.setCell(leftStr: "第\(indexPath.row + 1)人", rightStr: name)
                }
            }else{
                ///选择时间
                cell.arrowImage.isHidden = false
                cell.lineLabel.isHidden = true
                cell.setCell(leftStr: "出发日期", rightStr: leaveTime)
            }
            
            return cell
            
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1{
            //选择日期
            selectDate()
        }
        ///选择出行人
        if indexPath.section == 2{
            if selectedPassengerArr.count == 0{
                guard leaveTime.isEmpty == false else {
                    showSystemAlertView(titleStr: "提示", message: "请填写出发日期")
                    return
                }
                
                
                weak var weakSelf = self
                let tripListVC:TripPeopleListViewController = TripPeopleListViewController()
                tripListVC.modelInternationalType = .PersonalVisa
                tripListVC.needPassengerSum = peopleCount
                tripListVC.selectedPassengerArr = selectedPassengerArr
                tripListVC.tripPeopleListViewSelectedBlock = { selectedPassenger in
                    weakSelf?.selectedPassengerArr = selectedPassenger
                    weakSelf?.calculatePriceInfo()
                    weakSelf?.detailTable.reloadSections([2,4], with: UITableViewRowAnimation.none)
                }
                self.navigationController?.pushViewController(tripListVC, animated: true)
            }
            
        }
    }
    func modifyPassengers(){
        guard leaveTime.isEmpty == false else {
            showSystemAlertView(titleStr: "提示", message: "请填写出发日期")
            return
        }
        
        
        weak var weakSelf = self
        let tripListVC:TripPeopleListViewController = TripPeopleListViewController()
        tripListVC.modelInternationalType = .PersonalVisa
        tripListVC.needPassengerSum = peopleCount
        tripListVC.selectedPassengerArr = selectedPassengerArr
        tripListVC.tripPeopleListViewSelectedBlock = { selectedPassenger in
            weakSelf?.selectedPassengerArr = selectedPassenger
            weakSelf?.calculatePriceInfo()
            weakSelf?.detailTable.reloadSections([2,4], with: UITableViewRowAnimation.none)
        }
        self.navigationController?.pushViewController(tripListVC, animated: true)
    }
}
extension VisaWriteInfoViewController {
    
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
    ///选择出发日期
    func selectDate(){
        weak var weakSelf = self
        let vc:TBICalendarViewController = TBICalendarViewController()
        vc.isMultipleTap = false
        vc.calendarAlertType = TBICalendarAlertType.PersonalVisa
        vc.calendarTypeAlert = ["请选择出行日期"]
        vc.delayDay = delayDay
        vc.titleColor = TBIThemePrimaryTextColor
        vc.hotelSelectedDateAcomplishBlock = { (parameters,action) in
            if action == TBICalendarAction.Back {
                return
            }
            let formatter = DateFormatter()
            formatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone?
            formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
            
            let date:Date = formatter.date(from:(parameters?[0])!)!
            
            weakSelf?.leaveTime = date.string(custom: "YYYY-MM-dd")
            weakSelf?.detailTable.reloadData()
        }
        _ = self.navigationController?.pushViewController(vc, animated: true)
    }
    ///是否需要发票
    func switchBill(sender:UISwitch){
        isBill = sender.isOn
        detailTable.reloadData()
    }
    ///计算费用
    func calculatePriceInfo(){
        if selectedPassengerArr.isEmpty == false {
            peopleCount = selectedPassengerArr.count
        }
        
        priceArr.removeAll()
        priceArr.append((priceTitle: visaItem.visaName, price: "¥\(visaItem.saleRate.TwoOfTheEffectiveFraction())x\(peopleCount)"))
        
        var visaItemPriceFloat:Float = 0
        
        if visaItem.saleRate.TwoOfTheEffectiveFraction().isEmpty == false {
            visaItemPriceFloat = Float(visaItem.saleRate.TwoOfTheEffectiveFraction()) ?? 0
        }
        var totalPrice:Float = visaItemPriceFloat * Float(peopleCount)
        if travelSuranceArr.isEmpty == false {
            for i in 0...travelSuranceValueArr.count-1{
                if travelSuranceValueArr[i] == true{
                    priceArr.append((priceTitle: travelSuranceArr[i].suranceName, price: "¥\(travelSuranceArr[i].suranceSalePrice)x\(peopleCount)"))
                    totalPrice = totalPrice + Float(travelSuranceArr[i].suranceSalePrice) * Float(peopleCount)
                    
                }
            }
        }
        
        
        //        var passengerNum:Float = 0.0
        //        if selectedPassengerArr.isEmpty == false {
        //            passengerNum = Float(selectedPassengerArr.count)
        //        }
        
        localtotalPrice = totalPrice //* passengerNum
        footerView.totalPriceLabel.text = totalPrice.TwoOfTheEffectiveFraction()
        footerView.setViewWithArray(dataArr:priceArr)
        
        
        
    }
}
