//
//  PHotelSubmitViewController.swift
//  shanglvjia
//
//  Created by tbi on 2018/7/31.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import RxSwift
import SwiftDate

class PHotelSubmitViewController: PersonalBaseViewController,PayManagerStateProtocol {

    public var elongType:String = ""
    
    /// 酒店的基本信息
    public var hotelBaseInfo:SubmitHotelOrderRequest.HotelBaseInfo = SubmitHotelOrderRequest.HotelBaseInfo()
    
    /// 入店
    public var checkInDate:Date = Date()
    
    /// 离店
    public var checkOutDate:Date = Date()
    
    
    public var roomAmount:Float = 0
    
    public var corpCode:String = ""
    
    fileprivate var detailTable = UITableView()
    ///
    fileprivate var footerView:TravelPriceInfoView = TravelPriceInfoView()
    ///
    public var priceArr:[(priceTitle:String,price:String)] = Array()
    
    // 出行人
    public var bookCount:Int = 0
    public var selectedPassengerArr:[PersonalTravellerInfoRequest] = Array()
    ///是否选择发票
    public var isBill: Bool = false
    ///个人 公司
    public var typeIndex: NSInteger = 0
    public var billTypeStr : String = ""
    public var billTypeValueStr : String = ""
    ///发票类型数组
    public var invoiceArr:[PTravelNearbyDetailModel.InvoicesModel] = Array()
    fileprivate var invoiceTitleArr:[String] = Array()
    fileprivate var invoiceValueArr:[String] = Array()
    
    ///是否同意条款
    public var isSelected: Bool = false
    let bag = DisposeBag()
    
    fileprivate let tableViewHeaderSectionTipViewIdentify:String = "tableViewHeaderSectionTipViewIdentify"
    
    
    ///联系人
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setBlackTitleAndNavigationColor(title: "提交酒店信息")
        self.view.backgroundColor = TBIThemeBaseColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        initFooterView()
        fillDataSources()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fillDataSources()  {
        PayManager.sharedInstance.delegate = self
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
        
    }
    

    func initTableView() {
        self.view.addSubview(detailTable)
        detailTable.backgroundColor = TBIThemeBaseColor
        detailTable.separatorStyle=UITableViewCellSeparatorStyle.none
        // 设置预估行高 --> 先让 tableView 能滚动，在滚动的时候再去计算显示的 cell 的真正的行高，并且调整 tabelView 的滚动范围
        detailTable.estimatedRowHeight = 200
        detailTable.delegate = self
        detailTable.dataSource = self
        detailTable.rowHeight = UITableViewAutomaticDimension
        detailTable.tableFooterView = initTableFooterView()
        detailTable.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(1)
            make.bottom.equalToSuperview().inset(54)
        }
        detailTable.register(VisaContactCell.self, forCellReuseIdentifier: "VisaContactCell")
        detailTable.register(VisaBillCell.self, forCellReuseIdentifier: "VisaBillCell")
        detailTable.register(VisaOrderCell.self, forCellReuseIdentifier: "VisaOrderCell")
        detailTable.register(PersonalHotelSubmitTipSectionCellView.self, forCellReuseIdentifier:tableViewHeaderSectionTipViewIdentify)
        
        fillDataSource()
    }
    func fillDataSource(){
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
    func initFooterView(){
        self.view.addSubview(footerView)
        footerView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(54)
        }
        footerView.submitButton.setTitle("提交订单", for: UIControlState.normal)
        footerView.setViewWithArray(dataArr:priceArr)
        calculatePriceInfo()
        KeyWindow?.addSubview(footerView.backBlackView)
        footerView.priceButton.addTarget(self, action: #selector(priceInfo(sender:)), for: .touchUpInside)
        footerView.priceButton.addTarget(self, action: #selector(priceInfo(sender:)), for: .touchUpInside)
        footerView.submitButton.addTarget(self, action: #selector(nextOrder(sender:)), for: .touchUpInside)
        footerView.submitButton.customInterval = 3
    }
    func initTableFooterView() ->PersonalProtocalView{
        let tableFooter:PersonalProtocalView = PersonalProtocalView.init(frame: CGRect(x:0,y:0,width:ScreenWindowWidth,height:33))
        weak var weakSelf = self
        ///点击block
        tableFooter.viewClickBlock = {
            let vc:PersonlBookNotesViewController = PersonlBookNotesViewController()
            vc.idStr = "hotel"
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
        let amountPrices = roomAmount.TwoOfTheEffectiveFraction()
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
                weakSelf?.hotelNeedSecondSubmit(orderStatus: SubmitOrderFailureViewController.SubmitOrderStatus.Personal_Success_nopay)
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
            aliPayOrderInfo(type: type, orderId: orderId)
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

    
    
    //MARK:-----NET-----
    
    func submitNET(request:SubmitHotelOrderRequest) {
        weak var weakSelf = self
        showLoadingView()
        PersonalHotelServices.sharedInstance
            .hotelSpecialProductSubmitOrder(request: request)
            .subscribe { (event) in
                weakSelf?.hideLoadingView()
                switch event {
                case .next(let result):
                    printDebugLog(message: result)
                    if result.orderId.isEmpty == true {
                        // 订单失败
                        weakSelf?.hotelNeedSecondSubmit(orderStatus: SubmitOrderFailureViewController.SubmitOrderStatus.Personal_Failure_Submit_Order)
                        return
                    }
                    if result.orderStatus == "2" {
                        // 去支付
                        weakSelf?.showPaymentView(orderId:result.orderNo)
                    }else{
                        // 需要二次确认
                         weakSelf?.hotelNeedSecondSubmit(orderStatus: SubmitOrderFailureViewController.SubmitOrderStatus.Personal_Success_SecondSubmit)
                    }
                
                //                    weakSelf?.showSystemAlertView(titleStr: "提示", message: "生单成功")
                case .error(let error):
                    try? weakSelf?.validateHttp(error)
                case .completed:
                    break
                }
            }.addDisposableTo(self.bag)
        
        
        
    }
    func hotelNeedSecondSubmit(orderStatus:SubmitOrderFailureViewController.SubmitOrderStatus) {
        intoNextSubmitOrderFailureView(orderStatus: orderStatus)
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

    //支付状态页面
    func intoNextSubmitOrderFailureView(orderStatus:SubmitOrderFailureViewController.SubmitOrderStatus) {
        let submitOrderFailureView = SubmitOrderFailureViewController()
        submitOrderFailureView.submitOrderStatus = orderStatus
        self.navigationController?.pushViewController(submitOrderFailureView, animated: true)
    }
    
    
    
    //MARK: -------- Action ------
    override func backButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}
extension PHotelSubmitViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3 + (invoiceArr.count == 0 ? 0 : 1)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1{
            if selectedPassengerArr.count == 0{
                return 1
            }else{
                return bookCount
            }
        }
        return 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 || section == 1 {
            return 50
        }else{
            return 10
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 3{
            ///行程单：45*3 发票：个人 45*5，公司：45*10
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
        }else if indexPath.section == 1 {
            return 45///出行人
        }else if indexPath.section == 2 {
            return 15
        }else{
            return 132
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 || section == 1{
            let headView:VisaSectionHeaderView = VisaSectionHeaderView()
            headView.titleLabel.text = section == 0 ? "联系人" : "入住人"
            if headView.titleLabel.text == "入住人"{
                if selectedPassengerArr.count == 0{
                    headView.rightButton.isHidden = true
                }else{
                    headView.rightButton.isHidden = false
                    headView.rightButton.setTitle("修改入住人", for: .normal)
                    headView.rightButton.addTarget(self, action: #selector(selectPassengers), for: .touchUpInside)
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
        if indexPath.section == 0{
            let cell:VisaContactCell = tableView.dequeueReusableCell(withIdentifier: "VisaContactCell") as! VisaContactCell
            cell.fillDataSources(name:contactName.value,phone:contactPhone.value,email:contactEmail.value)
            cell.nameField.rx.text.orEmpty.bind(to: contactName).addDisposableTo(bag)
            cell.phoneField.rx.text.orEmpty.bind(to: contactPhone).addDisposableTo(bag)
            cell.emailField.rx.text.orEmpty.bind(to: contactEmail).addDisposableTo(bag)
            contactName.value = cell.nameField.text!
            contactPhone.value = cell.phoneField.text!
            contactEmail.value = cell.emailField.text!
            
            return cell
        }else if indexPath.section == 1{
            ///入住人
            let cell:VisaOrderCell = tableView.dequeueReusableCell(withIdentifier: "VisaOrderCell") as! VisaOrderCell
            cell.arrowImage.isHidden = true
            if selectedPassengerArr.count == 0{
                cell.lineLabel.isHidden = true
                 cell.setCell(leftStr: "", rightStr: "请选择\(bookCount)位入住人")
            }else{
                if indexPath.row == bookCount - 1{
                    cell.lineLabel.isHidden = true
                }else{
                    cell.lineLabel.isHidden = false
                }
                var name:String = ""
                if selectedPassengerArr.count > indexPath.row {
                    name = (selectedPassengerArr[indexPath.row].chName.isEmpty ? "\(selectedPassengerArr[indexPath.row].enNameSecond) \(selectedPassengerArr[indexPath.row].enNameFirst)":selectedPassengerArr[indexPath.row].chName)
                }
                cell.setCell(leftStr: "第\(indexPath.row + 1)间", rightStr: name)
            }
 
            return cell
        }else if indexPath.section == 2 {
            let cell :PersonalHotelSubmitTipSectionCellView = tableView.dequeueReusableCell(withIdentifier: tableViewHeaderSectionTipViewIdentify) as! PersonalHotelSubmitTipSectionCellView
            cell.fillDataSources(title: "温馨提示")
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        } else{
            ///发票
            weak var weakSelf  = self
            let cell:VisaBillCell = tableView.dequeueReusableCell(withIdentifier: "VisaBillCell") as! VisaBillCell
            cell.fillCell(isBill:isBill,type:typeIndex,billName:"代办酒店",billType:billTypeStr,typeArr:invoiceTitleArr, valueArr: invoiceValueArr)
            cell.companyOrPersonalBlock = { btnTag in
                weakSelf?.typeIndex = btnTag
                weakSelf?.detailTable.reloadSections([3], with: .none)
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
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ///选择出行人
        if indexPath.section == 1{
            if selectedPassengerArr.count == 0{
                selectPassengers()
            }
        }
        
        if indexPath.section == 2 {
            
            popPersonalNewAlertView(content:personalHotelWarmTipDefault,titleStr:"温馨提示",btnTitle:"确定")
        }
        
    }
    func selectPassengers(){
        weak var weakSelf = self
        let tripListVC:TripPeopleListViewController = TripPeopleListViewController()
        if hotelBaseInfo.regionType == "2" {
            tripListVC.modelInternationalType = .PersonalInternationalHotel
        }else{
            tripListVC.modelInternationalType = .PersonalMainlandHotel
        }
        tripListVC.peopleListViewType = .PersonalHotel
        tripListVC.needPassengerSum = bookCount
        tripListVC.selectedPassengerArr = selectedPassengerArr
        tripListVC.tripPeopleListViewSelectedBlock = { selectedPassenger in
            weakSelf?.selectedPassengerArr = selectedPassenger
            weakSelf?.detailTable.reloadSections([1], with: UITableViewRowAnimation.none)
        }
        self.navigationController?.pushViewController(tripListVC, animated: true)
    }
    ///是否需要发票
    func switchBill(sender:UISwitch){
        isBill = sender.isOn
        detailTable.reloadSections([3], with: .none)
    }
}
extension PHotelSubmitViewController{
    //价格详情
    func priceInfo(sender: UIButton) {
        if sender.isSelected == true {
            sender.isSelected = false
            footerView.backBlackView.isHidden = true
        }else
        {
            footerView.backBlackView.isHidden = false
            calculatePriceInfo()
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
    //下一步
    func nextOrder(sender: UIButton)
    {
        ///提交==隐藏费用明细
        footerView.priceButton.isSelected = false
        footerView.backBlackView.isHidden = true
        
        
        
        guard selectedPassengerArr.count > 0 else {
            showSystemAlertView(titleStr: "提示", message: "请填写入住人")
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
        
        
        DBManager.shareInstance.personalContactNameStore(name: contactName.value)
        DBManager.shareInstance.personalContactPhoneStore(phone: contactPhone.value)
        DBManager.shareInstance.personalContactEmailStore(email: contactEmail.value)
        
        ///签证   艺龙酒店是必填。机票 ，其他酒店，旅游为非必填
        ///corpCode == ""艺龙酒店
        if corpCode.isEmpty{
            guard contactEmail.value.isEmpty == false  else {
                showSystemAlertView(titleStr: "提示", message: "请填写联系人邮箱")
                return
            }
            guard contactEmail.value.validate(ValidateType.email) == true else{
                showSystemAlertView(titleStr: "提示", message: "邮箱格式错误")
                return
            }
        }else{
            if contactEmail.value.isNotEmpty{
                guard contactEmail.value.validate(ValidateType.email) == true else{
                    showSystemAlertView(titleStr: "提示", message: "邮箱格式错误")
                    return
                }
            }
        }
        
        
        if isSelected == false{
            showSystemAlertView(titleStr: "提示", message: "请先阅读预订条款")
            return
        }
        let expense = VisaOrderAddResquest.VisaOrderExpenseResquest()
        let request:SubmitHotelOrderRequest = SubmitHotelOrderRequest()
        
        
        if isBill == true {
            request.hotelExpenseVO = expense
            expense.exContent = "代办酒店"
            expense.exKind = billTypeValueStr
            expense.exAmount = roomAmount.TwoOfTheEffectiveFraction() //报销金额
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
        }
       
       
        
        
        ///提交
        
        
        request.elongType = elongType
        request.hotelPassengerInfos.removeAll()
        for element in selectedPassengerArr {
            let tmpPassenger:SubmitHotelOrderRequest.HotelPassengerInfo =  SubmitHotelOrderRequest.HotelPassengerInfo()
            tmpPassenger.gtpBirthday = element.birthday
            tmpPassenger.gtpCertNo = element.certNo
            tmpPassenger.gtpCertType = "1"
            tmpPassenger.gtpChName = element.chName
            tmpPassenger.gtpEnFirstname = element.enNameFirst
            tmpPassenger.gtpEnLastname = element.enNameSecond
            tmpPassenger.gtpPhone = element.mobile
            tmpPassenger.gtpType = (element.isChild ? "1":"0")
            
        request.hotelPassengerInfos.append(tmpPassenger)
        }
        request.hotelBaseInfo.payType = hotelBaseInfo.payType
        request.hotelBaseInfo.hotelCityName = hotelBaseInfo.hotelCityName
        request.hotelBaseInfo.hotelCityId = hotelBaseInfo.hotelCityId
        request.hotelBaseInfo.hotelProductId = hotelBaseInfo.hotelProductId
        request.hotelBaseInfo.bedType = hotelBaseInfo.bedType
        request.hotelBaseInfo.hotelCityName = hotelBaseInfo.hotelCityName
        request.hotelBaseInfo.contactPhone = hotelBaseInfo.contactPhone
        request.hotelBaseInfo.hotelDesc = hotelBaseInfo.hotelDesc
        request.hotelBaseInfo.hotelElongId = hotelBaseInfo.hotelElongId
        request.hotelBaseInfo.hotelCityId =  hotelBaseInfo.hotelCityId
        request.hotelBaseInfo.hotelAddress = hotelBaseInfo.hotelAddress
        request.hotelBaseInfo.hotelFax = hotelBaseInfo.hotelFax
        request.hotelBaseInfo.roomElongId = hotelBaseInfo.roomElongId
        request.hotelBaseInfo.roomCount = bookCount.description
        request.hotelBaseInfo.refundDesc = hotelBaseInfo.refundDesc
        
        
        request.hotelBaseInfo.tripStart =  NSNumber.init(value:checkInDate.timeIntervalSince1970 * 1000).intValue.description
        request.hotelBaseInfo.tripEnd =  NSNumber.init(value:checkOutDate.timeIntervalSince1970 * 1000).intValue.description
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let earliestArrivalTimeInterval:TimeInterval = (dateFormatter.date(from: checkInDate.string(custom: "YYYY-MM-dd") + " 13:00" )?.timeIntervalSince1970)!
        request.hotelBaseInfo.earliestArrivalTime =  NSNumber.init(value:earliestArrivalTimeInterval * 1000).intValue.description
        let latestArrivalTimeInterval:TimeInterval = (dateFormatter.date(from: checkInDate.string(custom: "YYYY-MM-dd") + " 22:00" )?.timeIntervalSince1970)!
        request.hotelBaseInfo.latestArrivalTime =  NSNumber.init(value:latestArrivalTimeInterval * 1000).intValue.description
        request.type = "5"
        request.hotelBaseInfo.orderSource = "2"
        // 联系人
        request.hotelBaseInfo.contactEmail = contactEmail.value
        request.hotelBaseInfo.contactName = contactName.value
        request.hotelBaseInfo.contactPhone = contactPhone.value
        request.hotelBaseInfo.roomType = hotelBaseInfo.roomType
        request.hotelBaseInfo.hotelDesc = hotelBaseInfo.hotelDesc
        request.hotelBaseInfo.hotelFax = hotelBaseInfo.hotelFax
        request.hotelBaseInfo.hotelLat = hotelBaseInfo.hotelLat
        request.hotelBaseInfo.hotelLong = hotelBaseInfo.hotelLong
        request.hotelBaseInfo.hotelName = hotelBaseInfo.hotelName
        request.hotelBaseInfo.hotelProductName = hotelBaseInfo.hotelProductName
        request.hotelBaseInfo.hotelRoomId = hotelBaseInfo.hotelRoomId
        request.hotelBaseInfo.mealCount = hotelBaseInfo.mealCount
        let bookRoom:NSInteger = caculateIntervalDay(fromDate: checkInDate, toDate: checkOutDate)
        
        request.hotelBaseInfo.totalPrice = roomAmount.TwoOfTheEffectiveFraction()
        let averagePrice = ceil(roomAmount / Float(bookRoom))
        request.hotelBaseInfo.perRate = averagePrice.description
        submitNET(request:request)
        
        
    }
    
    private func caculateIntervalDay(fromDate:Date,toDate:Date) -> NSInteger {
        
        let calendar = NSCalendar.init(identifier: NSCalendar.Identifier.gregorian)
        let result = calendar?.components(NSCalendar.Unit.day, from: fromDate, to: toDate, options: NSCalendar.Options.matchFirst)
        
        return (result?.day)!
    }
    
    
    
    
    ///计算费用
    func calculatePriceInfo(){
        
//        for element in priceArr {
//            let prices:Float = Float(element.price) ?? 0
//            roomAmount += prices
//        }
//
        
        footerView.setViewWithArray(dataArr:priceArr)
        
        footerView.totalPriceLabel.text = roomAmount.TwoOfTheEffectiveFraction()
    }
    
}

