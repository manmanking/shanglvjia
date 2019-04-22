//
//  SpecialOrderViewController.swift
//  shop
//
//  Created by TBI on 2017/7/8.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import SwiftDate
import RxCocoa
import RxSwift

class SpecialOrderViewController: CompanyBaseViewController {

    fileprivate let disposeBag = DisposeBag()
    
    //选中成人价格  儿童
    fileprivate var buyListOne:[[String:Any]] = [[:]]
    //选中单房差
    fileprivate var buyListTwo:[[String:Any]] = [[:]]
    //产品信息
    fileprivate var travelItem:TravelListItem?
    //价格信息
    fileprivate var priceData:SpecialPriceListItem?
    //产品类型
    fileprivate var travelCategorys:TravelCategorys?
    
    fileprivate let tableView = UITableView()
    
    //联系人cell
    let travelContactTableCellIdentify = "travelContactTableCellIdentify"
    
    //出行人cell
    let travelPersonTableCellIdentify = "travelPersonTableCellIdentify"
    
    //出行人title
    let travelTitleTableCellIdentify = "travelTitleTableCellIdentify"
    
    
    fileprivate var personList:[[String:Any]] = []
    
    fileprivate var invoiceFlag:Int = 0
    
    fileprivate let footerView:TravelOrderFooterView = TravelOrderFooterView()
    
    
    fileprivate var invoice:TravelForm.OrderSpecialInfo.Invoice = TravelForm.OrderSpecialInfo.Invoice()
    
    fileprivate var logistics:TravelForm.OrderSpecialInfo.Logistics = TravelForm.OrderSpecialInfo.Logistics()
    
    //旅游订单提交实体
    fileprivate var travelForm:TravelForm.OrderSpecialInfo =  TravelForm.OrderSpecialInfo()
    
    fileprivate var totalAmount:Double = 0
    
     fileprivate var agreedFlag:Bool = false
    
    //旅客信息
    fileprivate var orderSpecialPersonInfoList:[TravelForm.OrderSpecialInfo.OrderSpecialPersonInfo]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation(title:"订单确认")
        
        let userDetail = UserService.sharedInstance.userDetail()
        travelForm.contactPhone.value = userDetail?.userName ?? ""
        initView()
        initTableView()
        sumPrice()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func backButtonAction(sender:UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
}
extension SpecialOrderViewController{
    
    
    //设置数据
    func  setData(travelItem:TravelListItem?,travelCategorys:TravelCategorys?,priceData:SpecialPriceListItem?,buyListOne:[[String:Any]],buyListTwo:[[String:Any]]){
        self.buyListOne = buyListOne
        self.buyListTwo = buyListTwo
        self.travelItem = travelItem
        self.priceData = priceData
        self.travelCategorys = travelCategorys
        for index in 0..<buyListOne.count {
            let number = buyListOne[index]["number"] as? Int ?? 0
            if  number == 1 {
                personList.append(["title":buyListOne[index]["title"] ?? "","name":"","type":buyListOne[index]["type"] ?? ""])
            }else {
                for _ in 0..<number{
                    personList.append(["title":(buyListOne[index]["title"] as? String ?? ""),"name":"","type":buyListOne[index]["type"] ?? ""])
                }
            }
            
        }
        orderSpecialPersonInfoList = Array.init(repeating: TravelForm.OrderSpecialInfo.OrderSpecialPersonInfo(), count: personList.count)
    }
    
    
    func initView (){
        self.view.addSubview(footerView)
        footerView.submitButton.setTitle((self.travelItem?.confirm ?? false) ? "去抢购":"去付款", for: UIControlState.normal)
        footerView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(50)
        }
        footerView.submitButton.addTarget(self, action: #selector(submitClick(btn:)), for: .touchUpInside)
    }
    
    /// 算价格
    fileprivate func sumPrice(){
        totalAmount = 0
        for index in 0..<buyListOne.count {
            totalAmount += ((buyListOne[index]["price"] as? Double) ?? 0) * Double(buyListOne[index]["number"] as? Int ?? 0)
        }
        for index in 0..<buyListTwo.count {
            totalAmount += ((buyListTwo[index]["price"] as? Double) ?? 0) * Double(buyListTwo[index]["number"] as? Int ?? 0)
        }
        if  invoiceFlag == 1 {
            totalAmount += 10
        }
        footerView.priceCountLabel.text = String(format: "%.0f",totalAmount)
    }
    
    //提交订单
    func submitClick(btn: UIButton) {
       

        ///特价产品id
        travelForm.specialProductsMainId =  travelItem?.productId ?? ""
        /// 特价产品类型ID
        travelForm.specialProductsCategoryId = travelCategorys?.categoryId ?? ""
        /// 特价产品价格ID
        travelForm.specialProductsPriceId =  priceData?.priceId ?? ""
        /// 销售日期
        travelForm.saleDate = priceData?.saleDate.string(custom: "yyyy-MM-dd") ?? ""
        /// 总价格
        travelForm.totalAmount = totalAmount
        
        for index in 0..<buyListOne.count {
            let type = buyListOne[index]["type"] as! PriceType
            switch type {
            case .adultPrice:
                travelForm.adultNum = (buyListOne[index]["number"] as? Int) ?? 0
            case .childBedPrice:
                travelForm.childBedNum = (buyListOne[index]["number"] as? Int) ?? 0
            case .childNobedPrice:
                travelForm.childNobedNum = (buyListOne[index]["number"] as? Int) ?? 0
            default:
                break
            }
        }
        
        for index in 0..<buyListTwo.count {
            let type = buyListTwo[index]["type"] as! PriceType
            switch type {
            case .singleRoomDifference:
                travelForm.roomNum = (buyListOne[index]["number"] as? Int) ?? 0
            default:
                break
            }
        }
        /// 是否需要发票
        travelForm.isNeedInvoice = String(describing:invoiceFlag)
        travelForm.invoice = invoice
        travelForm.logistics = logistics
        
        var travelList = orderSpecialPersonInfoList
        for index in 0..<(travelList?.count ?? 0){
            let type:PriceType = personList[index]["type"] as! PriceType
            switch type {
            case .adultPrice:
                travelList?[index].personType = "0"
            case .childBedPrice:
                travelList?[index].personType = "1"
            case .childNobedPrice:
                travelList?[index].personType = "2"
            default:
                break
            }
        }
        /// 人员信息列表
        travelForm.orderSpecialPersonInfoList = travelList
        
        if !agreedFlag {
            self.alertView(title: "提示", message: "请同意服务协议")
            return
        }
        self.showLoadingView()
        weak var weakSelf = self
        SpecialProductService.sharedInstance.submitSpecial(travelForm).subscribe{ event in
            weakSelf?.hideLoadingView()
            if case .next(let result) = event {
                if weakSelf?.travelItem?.confirm ?? false{//跳到首页
                     let view:SuccessOrderView = SuccessOrderView(titleText:"您的预订已提交成功",messageText:"马上为您确定余票情况,请您保持手机\(self.travelForm.contactPhone.value)畅通,谢谢!")
                    view.returnHomeBlock = {
                        weakSelf?.intoMainView(from:"")
                    }
                    KeyWindow?.addSubview(view)
                }else {//跳到支付页面
                    let paymentView = PaymentViewController()
                    paymentView.orderNum = result.orderNo
                    paymentView.productTypePayment = ProductTypePayment.Special
                    weakSelf?.navigationController?.pushViewController(paymentView, animated: true)
                }
            }
            if case .error(let e) = event {
                try? self.validateHttp(e)
                
            }
            }.disposed(by: disposeBag)
        
    }
    
    
}
extension SpecialOrderViewController: UITableViewDataSource, UITableViewDelegate {
    
    func initTableView (){
        let headerView = TravelOrderHeaderTableViewCell(listOne:buyListOne,listTwo:buyListTwo,productType:travelCategorys?.categoryName,saleDate:priceData?.saleDate,title:travelItem?.productName)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = TBIThemeBaseColor
        tableView.tableHeaderView = headerView
        tableView.register(TravelContactTableCell.classForCoder(), forCellReuseIdentifier: travelContactTableCellIdentify)
        
        tableView.register(TravelPersonTableCell.classForCoder(), forCellReuseIdentifier: travelPersonTableCellIdentify)
        tableView.register(TravelTitleTableCell.classForCoder(), forCellReuseIdentifier: travelTitleTableCellIdentify)
        
        tableView.register(MineHomeTableViewFooterView.classForCoder(), forHeaderFooterViewReuseIdentifier: mineHomeTableViewHeaderViewIdentify)
        
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(10)
            make.bottom.equalTo(-50)
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1 + personList.count
        }else if section == 2 {
            return 1 + invoiceFlag
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let footerView:MineHomeTableViewFooterView = tableView.dequeueReusableHeaderFooterView(withIdentifier: mineHomeTableViewHeaderViewIdentify) as! MineHomeTableViewFooterView
        return footerView
    }
    
    // MARK: 创建cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: travelTitleTableCellIdentify, for: indexPath) as! TravelTitleTableCell
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: travelPersonTableCellIdentify, for: indexPath) as! TravelPersonTableCell
            let title = personList[indexPath.row - 1]["title"] as? String ?? ""
            let name =  personList[indexPath.row - 1]["name"] as? String ?? ""
            cell.fillCell(title: title,name: name,index:indexPath.row)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: travelContactTableCellIdentify, for: indexPath) as! TravelContactTableCell
            cell.fillCell(model: travelForm)
            cell.nameField.rx.text.orEmpty.bind(to: travelForm.contactName).addDisposableTo(disposeBag)
            cell.phoneField.rx.text.orEmpty.bind(to: travelForm.contactPhone).addDisposableTo(disposeBag)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }else if indexPath.section == 2{
            if indexPath.row == 0 {
                let cell =  TravelTitleInvoiceTableCell()
                cell.fillCell(invoiceFlag: invoiceFlag)
                cell.rightSwitch.addTarget(self, action: #selector(stateChanged(switchState:)), for: .valueChanged)
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                return cell
            }
            let cell = TravelInvoiceTableCell()
            cell.fillCell(invoice: invoice, logistics: logistics)
            cell.invoiceField.rx.text.orEmpty.bind(to: invoice.invoiceTitle).addDisposableTo(disposeBag)
            cell.addressField.rx.text.orEmpty.bind(to: logistics.logisticsAddress).addDisposableTo(disposeBag)
            cell.phoneField.rx.text.orEmpty.bind(to: logistics.logisticsPhone).addDisposableTo(disposeBag)
            cell.nameField.rx.text.orEmpty.bind(to: logistics.logisticsName).addDisposableTo(disposeBag)
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.companyButton.addTarget(self, action: #selector(companyInvoiceTypeClick(btn:)), for: .touchUpInside)
            cell.personalButton.addTarget(self, action: #selector(personalInvoiceTypeClick(btn:)), for: .touchUpInside)
            return cell
        }else {
            let cell = TravelOrderFooterTableViewCell()
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.fillCell(flag: agreedFlag)
            //cell.addOnClickListener(target: self, action: #selector(protocolButtonAction))
            cell.protocolButton.addTarget(self, action: #selector(protocolButtonAction(sender:)), for: .touchUpInside)
            cell.rightMessageLabel.addOnClickListener(target: self, action: #selector(protocolRightMessageAction))
            return cell
        }
        
        
    }
    // MARK: 点击cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row != 0 {
                weak var weakSelf = self
                let vc = TravellerListViewController()
                vc.selectPersonInfoList = orderSpecialPersonInfoList
                vc.personType = self.personList[indexPath.row - 1]["title"] as! String == "成人" ? 1:2
                vc.personSelectedResultBlock = { (person) in
                    weakSelf?.personList[indexPath.row - 1]["name"] = person?.nameChi
                    var model = TravelForm.OrderSpecialInfo.OrderSpecialPersonInfo()
                    model.initData(model: person!)
                    weakSelf?.orderSpecialPersonInfoList?[indexPath.row - 1] = model
                    weakSelf?.tableView.reloadData()
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    // MARK: row高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 37
            }
        }else if indexPath.section == 1 {
            return  126
        }else if indexPath.section == 2 {
            if indexPath.row == 0 {
                return 44
            }
            return 264 + 22
        }else if indexPath.section == 3 {
            return 30
        }
        return 44
    }
    
    //发票类型个人
    func personalInvoiceTypeClick(btn: UIButton) {
        invoice.invoiceType = "1"
        let index = IndexPath(row: 1, section: 2)
        tableView.reloadRows(at: [index], with: UITableViewRowAnimation.automatic)
    }
    
    //发票类型公司
    func companyInvoiceTypeClick(btn: UIButton) {
        invoice.invoiceType = "0"
        let index = IndexPath(row: 1, section: 2)
        tableView.reloadRows(at: [index], with: UITableViewRowAnimation.automatic)
    }
    
    //报销凭证
    func stateChanged(switchState: UISwitch) {
        if switchState.isOn {
            invoiceFlag = 1
        }else {
            invoiceFlag = 0
        }
        sumPrice()
        tableView.reloadSections([2], with: UITableViewRowAnimation.automatic)
        let index = IndexPath(row: 0, section: 2)
        let cell = tableView.cellForRow(at: index) as! TravelTitleInvoiceTableCell
        cell.rightSwitch.isOn = switchState.isOn
    }
    
    
    //阅读服务协议
    func protocolRightMessageAction()
    {
        agreedFlag = true
        //sender.isSelected = true
        let vc = AboutOurDetailsShowTextController()
        vc.navTitleStr = "服务协议"
        vc.titleStr = "服务协议"
        
        vc.fileNameStr = "register_service_protocal.html"
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    //同意or取消服务协议
    func protocolButtonAction(sender:UIButton)
    {
        if  agreedFlag == true {
            agreedFlag = false
            sender.isSelected = false
        }else {
            agreedFlag = true
            sender.isSelected = true
        }
    
    }
    
}
