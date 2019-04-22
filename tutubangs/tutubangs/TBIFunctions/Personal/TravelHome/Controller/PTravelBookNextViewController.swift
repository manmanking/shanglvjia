//
//  PTravelBookNextViewController.swift
//  shanglvjia
//
//  Created by tbi on 2018/7/26.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import RxSwift

class PTravelBookNextViewController: PersonalBaseViewController {

    fileprivate var detailTable = UITableView()
    ///
    fileprivate var footerView:TravelPriceInfoView = TravelPriceInfoView()
    ///
    public var priceArr:[(priceTitle:String,price:String)] = Array()
    ///条款
    public var remindStr = ""
    ///是否需要二次确认
    public var needConfig = ""
    ///国际还是国内
    public var isWorld = false
    ///是自由行
    public var isIndepend = false
    // 出行人
    public var adultCount:Int = 0
    public var childCount:Int = 0
    public var selectedPassengerArr:[PersonalTravellerInfoRequest] = Array()
    ///是否选择发票
    public var isBill: Bool = false
    ///个人 公司
    public var typeIndex: NSInteger = 0
    public var billTypeStr : String = ""
    public var billTypeValueStr : String = ""
    ///是否同意条款
    public var isSelected: Bool = false
    ///发票类型数组
    public var invoiceArr:[PTravelNearbyDetailModel.InvoicesModel] = Array()
    fileprivate var invoiceTitleArr:[String] = Array()
    fileprivate var invoiceValueArr:[String] = Array()
    
    ///下单model
    var orderModel:PTravelOrderAddRequest = PTravelOrderAddRequest()
    
    
    let bag = DisposeBag()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        initFooterView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setBlackTitleAndNavigationColor(title: "提交旅游订单")
        self.view.backgroundColor = TBIThemeBaseColor
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: -------- Action ------
    override func backButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
        detailTable.register(VisaOrderCell.self, forCellReuseIdentifier: "VisaOrderCell")
        detailTable.register(VisaBillCell.self, forCellReuseIdentifier: "VisaBillCell")
        
        if invoiceArr.count>0{
            for model in invoiceArr{
                invoiceTitleArr.append(model.name)
                invoiceValueArr.append(model.value)
            }
            billTypeStr = invoiceTitleArr[0]
            billTypeValueStr = invoiceValueArr[0]
        }
        
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
        
        footerView.setViewWithArray(dataArr:priceArr)
        footerView.submitButton.setTitle("提交订单", for: UIControlState.normal)
        
        footerView.totalPriceLabel.text = orderModel.totalRate
        
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
            vc.idStr = "travel"
            weakSelf?.navigationController?.pushViewController(vc, animated: true)
         }
        tableFooter.selectClickBlock = {(isSelect) in
            weakSelf?.isSelected = isSelect
        }
        return tableFooter
    }

}
extension PTravelBookNextViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 + (invoiceArr.count == 0 ? 0 : 1)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            if selectedPassengerArr.count == 0{
                return 1
            }else{
                return (adultCount + childCount)
            }
        }
        return  1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 50
        }else{
            return 35
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1{
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
        }else{
            return 45///出行人
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headView:VisaSectionHeaderView = VisaSectionHeaderView()
            headView.titleLabel.text = "出行人"
           
                if selectedPassengerArr.count == 0{
                    headView.rightButton.isHidden = true
                }else{
                    headView.rightButton.isHidden = false
                    headView.rightButton.setTitle("修改出行人", for: .normal)
                    headView.rightButton.addTarget(self, action: #selector(modifyPassengers), for: .touchUpInside)
                }
            
            return headView
        }else{
            let view:UIView = UIView()
            view.backgroundColor = TBIThemeBaseColor
            let warningButton = UIButton.init(title: "  温馨提示", titleColor: PersonalThemeRedColor, titleSize: 12)
            view.addSubview(warningButton)
            warningButton.contentHorizontalAlignment = .left
            warningButton.addTarget(self, action: #selector(warningButtonClick), for: UIControlEvents.touchUpInside)
            warningButton.setImage(UIImage(named:"warningRed"), for: .normal)
            warningButton.snp.makeConstraints({ (make) in
                make.top.bottom.equalToSuperview()
                make.left.equalTo(15)
                make.width.equalTo(200)
            })
            return view
        }
    }
    func warningButtonClick(){//
        popPersonalNewAlertView(content:personalFlightWarmTipDefault, titleStr: "温馨提示" , btnTitle: "确定")
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        ///出行人
        if indexPath.section == 0{
            let cell:VisaOrderCell = tableView.dequeueReusableCell(withIdentifier: "VisaOrderCell") as! VisaOrderCell
            if selectedPassengerArr.count == 0{
                cell.lineLabel.isHidden = true
                cell.setCell(leftStr: "", rightStr: "请选择\(adultCount+childCount)位出行人")
            }else{
                if indexPath.row == adultCount + childCount - 1{
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
            
//                if indexPath.row < adultCount{
//                    if isIndepend == true{
//                        cell.setCell(leftStr: "第\(indexPath.row + 1)成人", rightStr: name)
//                    }else{
//                        cell.setCell(leftStr: "第\(indexPath.row + 1)出行人", rightStr: name)
//                    }
//
//                }else{
//                    cell.setCell(leftStr: "第\(indexPath.row + 1)儿童", rightStr: name)
//                }
            
            return cell
        }else{
            ///发票
            weak var weakSelf  = self
            let cell:VisaBillCell = tableView.dequeueReusableCell(withIdentifier: "VisaBillCell") as! VisaBillCell
            cell.fillCell(isBill:isBill,type:typeIndex,billName:"旅游费",billType:billTypeStr,typeArr:invoiceTitleArr,valueArr: invoiceValueArr)
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
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ///选择出行人
        if indexPath.section == 0{
            if selectedPassengerArr.count == 0{
                 selectPassengers()
            }
        }
    }
    func modifyPassengers(){
        selectPassengers()
    }
    func selectPassengers(){
        weak var weakSelf = self
        let tripListVC:TripPeopleListViewController = TripPeopleListViewController()
        tripListVC.needPassengerSum = adultCount + childCount
        tripListVC.childPassengerSum = childCount
        tripListVC.isIndepend = isIndepend
        if isWorld{
            ///国际
            tripListVC.modelInternationalType = AppModelInternationalType.PersonalInternationalTravel
        }else{
            tripListVC.modelInternationalType = AppModelInternationalType.PersonalMainlandTravel
        }
        tripListVC.selectedPassengerArr = selectedPassengerArr
        tripListVC.tripPeopleListViewSelectedBlock = { selectedPassenger in
            ///weakSelf?.selectedPassengerArr = selectedPassenger
            var tempAdultArr:[PersonalTravellerInfoRequest] = Array()
            var tempChildArr:[PersonalTravellerInfoRequest] = Array()
            //成人儿童分开展示
            for i in 0...selectedPassenger.count-1{
                if selectedPassenger[i].isChild{
                    tempChildArr.append(selectedPassenger[i])
                }else{
                    tempAdultArr.append(selectedPassenger[i])
                }
            }
            weakSelf?.selectedPassengerArr = tempAdultArr + tempChildArr
            
            weakSelf?.detailTable.reloadSections([0], with: UITableViewRowAnimation.none)
        }
        self.navigationController?.pushViewController(tripListVC, animated: true)
    }
    ///是否需要发票
    func switchBill(sender:UISwitch){
        isBill = sender.isOn
        detailTable.reloadSections([1], with: .none)
    }
}
extension PTravelBookNextViewController{
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
    //下一步
    func nextOrder(sender: UIButton)
    {
        ///提交==隐藏费用明细
        footerView.priceButton.isSelected = false
        footerView.backBlackView.isHidden = true
        
        guard selectedPassengerArr.count > 0 else {
            showSystemAlertView(titleStr: "提示", message: "请填写出行人")
            return
        }
        if isSelected == false{
            showSystemAlertView(titleStr: "提示", message: "请先阅读预订条款")
            return
        }
        
        ///提交
        ///出行人
        orderModel.passengers.removeAll()
        for element in selectedPassengerArr {
            let temPassenger = PTravelOrderAddRequest.BaseVisaPassengerVo()
            temPassenger.gtpBirthday = element.birthday
            ///如果是国际 选择护照
            if isWorld{
                //////如果是国际 选择护照
                temPassenger.gtpCertType = "2"
                temPassenger.gtpCertNo = element.passportNo
                temPassenger.gtpCertDate = element.passportExpireDate
            }else{
                ///国内 选择身份证，没有身份证的话选择护照
                if element.certNo.isEmpty{
                    temPassenger.gtpCertType = "2"
                    temPassenger.gtpCertNo = element.passportNo
                    temPassenger.gtpCertDate = element.passportExpireDate
                }else{
                    temPassenger.gtpCertType = "1"
                    temPassenger.gtpCertNo = element.certNo
                }
                
            }            
            temPassenger.gtpChName = element.chName
            temPassenger.gtpEnFirstname = element.enNameFirst
            temPassenger.gtpEnLastname = element.enNameSecond
            temPassenger.gtpPhone = element.mobile
            temPassenger.gtpType = (element.isChild ? "1":"0")
            temPassenger.gtpSex = (element.gender.isEmpty ? "1" : element.gender)
            orderModel.passengers.append(temPassenger)
        }
        orderModel.needInvoice = "0"
        orderModel.priceDetail = CommonTool.replace(CommonTool.replace(priceArr.description, withInstring: "(", withOut: "{"), withInstring: ")", withOut: "}")
        ///发票
        if isBill{
            orderModel.expense.exKind = billTypeValueStr
            orderModel.expense.exContent = "旅游费"
            orderModel.needInvoice = "1"
            orderModel.expense.exAmount = orderModel.totalRate
            if billTypeStr == "电子发票" ||  billTypeStr == "纸质发票"{
                ///个人或公司
                orderModel.expense.exType = typeIndex.description
                
                if typeIndex == 0{
                    if personalName.value.isEmpty == true {
                        showSystemAlertView(titleStr: "提示", message: "请填写个人发票姓名")
                        return
                    }
                    orderModel.expense.exPersonName = personalName.value
                    orderModel.expense.exTitle = ""
                    orderModel.expense.exItin = ""
                    orderModel.expense.exBank = ""
                    orderModel.expense.exBankNo = ""
                    orderModel.expense.exCompanyAddress = ""
                    orderModel.expense.exCompanyPhone = ""
                }else{
                    if companyHeader.value.isEmpty == true || companyTaxNum.value.isEmpty == true ||
                        companyBankName.value.isEmpty == true || companyBankNum.value.isEmpty == true ||
                        companyAddress.value.isEmpty == true || companyPhone.value.isEmpty == true {
                        showSystemAlertView(titleStr: "提示", message: "请输入正确的公司发票信息")
                        return
                    }
                    orderModel.expense.exPersonName = ""
                    orderModel.expense.exTitle = companyHeader.value
                    orderModel.expense.exItin = companyTaxNum.value
                    orderModel.expense.exBank = companyBankName.value
                    orderModel.expense.exBankNo = companyBankNum.value
                    orderModel.expense.exCompanyAddress = companyAddress.value
                    orderModel.expense.exCompanyPhone = companyPhone.value
                }
                if billTypeStr == "电子发票"{
                    orderModel.expense.address = ""
                }else{
                    if addressCity.value.isEmpty == true || addressStreet.value.isEmpty == true{
                        showSystemAlertView(titleStr: "提示", message: "请输入地址信息")
                    }
                    orderModel.expense.address = addressCity.value + addressStreet.value
                }
            }
            if billTypeStr == "行程单"{
                orderModel.expense.address = addressCity.value + addressStreet.value
            }
            
        }
        
        weak var weakSelf = self
        showLoadingView()
        PersonalTravelServices.sharedInstance.personalTravelOrder(request: orderModel)
            .subscribe { (event) in
                weakSelf?.hideLoadingView()
                switch event {
                case .next(let element):
                    printDebugLog(message: element)
                    ///下单成功以后需要确认0否1是
                    if weakSelf?.needConfig == "0" {
                        // 去支付
                        weakSelf?.showPaymentView(orderId:element.orderNo)
                    }else{
                        // 需要二次确认
                        weakSelf?.travelNeedSecondSubmit(orderStatus: SubmitOrderFailureViewController.SubmitOrderStatus.Personal_Success_SecondSubmit)
                    }
                    
                case .error(_):
                   weakSelf?.travelNeedSecondSubmit(orderStatus: SubmitOrderFailureViewController.SubmitOrderStatus.Personal_Failure_SecondSubmit)
                case .completed:
                    break
                    
                }
            }.addDisposableTo(self.bag)
    }
    
    func travelNeedSecondSubmit(orderStatus:SubmitOrderFailureViewController.SubmitOrderStatus) {
        intoNextSubmitOrderFailureView(orderStatus: orderStatus)
    }
    //支付状态页面
    func intoNextSubmitOrderFailureView(orderStatus:SubmitOrderFailureViewController.SubmitOrderStatus) {
        let submitOrderFailureView = SubmitOrderFailureViewController()
        submitOrderFailureView.submitOrderStatus = orderStatus
        self.navigationController?.pushViewController(submitOrderFailureView, animated: true)
    }
    func showPaymentView(orderId:String) {
        weak var weakSelf = self
        let payView:SelectPaymentView = SelectPaymentView(frame:ScreenWindowFrame)
//        let amountPrices = orderModel.totalRate
        let amountPrices = orderModel.totalRate
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
                weakSelf?.travelNeedSecondSubmit(orderStatus: SubmitOrderFailureViewController.SubmitOrderStatus.Personal_Success_nopay)
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
}
