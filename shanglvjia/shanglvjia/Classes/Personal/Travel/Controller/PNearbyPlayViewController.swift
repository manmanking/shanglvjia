//
//  PNearbyPlayViewController.swift
//  shanglvjia
//
//  Created by tbi on 2018/7/30.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import RxSwift

class PNearbyPlayViewController: PersonalBaseViewController {

    fileprivate var detailTable = UITableView()
    ///
    fileprivate var footerView:TravelPriceInfoView = TravelPriceInfoView()
    
    ///联系人
    let bag = DisposeBag()
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
    ///成人儿童数量
    fileprivate var adultNum:NSInteger = 1
    fileprivate var childNum:NSInteger = 0
    
    fileprivate var bookNumArr = NSMutableArray()
    
    var nearbyModel:PTravelNearbyDetailModel = PTravelNearbyDetailModel()
    ///下单model
    var orderModel:PTravelOrderAddRequest = PTravelOrderAddRequest()
    
    fileprivate var boolArray:[Bool] = Array()
    fileprivate var onOffNumArr:[PTravelNearbyDetailModel.NearbyProductResponse] = Array()
    fileprivate var totalPrice:String  = ""
    ///
    fileprivate var priceArr:[(priceTitle:String,price:String)] = Array()
    
    ///单价 测试
    public var unitPrice = "0"
    /// 出发日期
    public var leaveTime:String = ""
    /// 产品Id
    public var productId:String = ""
    public var productName = ""
    public var stokeId = ""
    ///库存数量
    public var stocks = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillLocalDataSource()
         initTableView()
        initFooterView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setBlackTitleAndNavigationColor(title: "预订信息")
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
        detailTable.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(1)
            make.bottom.equalToSuperview().inset(54)
        }
        detailTable.register(VisaContactCell.self, forCellReuseIdentifier: "VisaContactCell")
        detailTable.register(VisaTitleCell.self, forCellReuseIdentifier: "VisaTitleCell")
        detailTable.register(VisaOrderCell.self, forCellReuseIdentifier: "VisaOrderCell")
        detailTable.register(TravelBookNumCell.self, forCellReuseIdentifier: "TravelBookNumCell")
        detailTable.register(NearbyOnOffNumCell.self, forCellReuseIdentifier: "NearbyOnOffNumCell")
  
        
    }
    func fillLocalDataSource(){
        
        ///预订数量
        bookNumArr.add("\(unitPrice)元／位")
        
        /// 数据源  附加产品
        ///遍历products，type=2的时候add onOffNumArr
        if nearbyModel.products.count>0{
            for i in 0...nearbyModel.products.count - 1{
                if nearbyModel.products[i].type == "2"
                {
                    onOffNumArr.append(nearbyModel.products[i])
                    boolArray.append(false)
                    
                }
            }
        }
        ///保险
        if nearbyModel.surances.count>0{
            for i in 0...nearbyModel.surances.count - 1{
                let model = PTravelNearbyDetailModel.NearbyProductResponse(jsonData: "")
                model?.productName = nearbyModel.surances[i].suranceName
                model?.saleRate = nearbyModel.surances[i].suranceSalePrice
                model?.type = "6"
                onOffNumArr.append(model!)
                boolArray.append(false)
            }
        }
        calculatePriceInfo()

    }
    func initFooterView(){
        self.view.addSubview(footerView)
        footerView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(54)
        }
        
        footerView.setViewWithArray(dataArr:priceArr)
        
        KeyWindow?.addSubview(footerView.backBlackView)
        footerView.priceButton.addTarget(self, action: #selector(priceInfo(sender:)), for: .touchUpInside)
        footerView.priceButton.addTarget(self, action: #selector(priceInfo(sender:)), for: .touchUpInside)
        footerView.submitButton.addTarget(self, action: #selector(nextOrder(sender:)), for: .touchUpInside)
    }
    //MARK: -------- Action ------
    override func backButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension PNearbyPlayViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4 + onOffNumArr.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2{
            return bookNumArr.count
        }
        return 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }else if section == 2 || section == 3{
            return 55
        }else{
            return 10
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2{
            return 45
        }
        if indexPath.section > 3{
            
                return 45
           
        }
        return indexPath.section == 3 ? 132 : UITableViewAutomaticDimension
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 3 || section == 2 {
            let headView:VisaSectionHeaderView = VisaSectionHeaderView()
            headView.titleLabel.text = section == 2 ? "预订数量" : "联系人"
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
        }else if indexPath.section == 1{
            let cell:VisaOrderCell = tableView.dequeueReusableCell(withIdentifier: "VisaOrderCell") as! VisaOrderCell
            ///选择时间
            cell.lineLabel.isHidden = true
            cell.arrowImage.isHidden = true
            cell.setCell(leftStr: "出发日期", rightStr: leaveTime)
            return cell
            
        }else if indexPath.section == 0{
            ///订单标题
            let cell:VisaTitleCell = tableView.dequeueReusableCell(withIdentifier: "VisaTitleCell") as! VisaTitleCell
            cell.fillDataSources(visaName:productName)
            cell.titleLabel.font = UIFont.systemFont(ofSize: 14)
            return cell
        }else if indexPath.section == 2{
            ///预订数量
            let cell:TravelBookNumCell = tableView.dequeueReusableCell(withIdentifier: "TravelBookNumCell") as! TravelBookNumCell
            cell.titleLabel.text = bookNumArr[indexPath.row] as? String
             ///成人最大数
            if indexPath.row == 0{
                cell.numView.initStartNum(minNum: 1, maxNum: Int(stocks)! , num:(adultNum))
            }
            weak var weakSelf = self
            cell.numView.returnNumberBlock = { (num) in
                weakSelf?.returnNumWithCell(sectionIndex:indexPath.section,cellIndex: indexPath.row, number: num)
            }
            if indexPath.row == 0{
                cell.lineLabel.isHidden = true
            }else{
                cell.lineLabel.isHidden = false
            }
            return cell
        }else {
            let cell:NearbyOnOffNumCell = tableView.dequeueReusableCell(withIdentifier: "NearbyOnOffNumCell") as! NearbyOnOffNumCell
            weak var weakSelf = self
            
            let onOffNumModel = onOffNumArr[indexPath.section - 4]
            cell.fillCell(isBill: boolArray[indexPath.section - 4],title:"\(onOffNumModel.productName)：\(onOffNumModel.saleRate)元",section:indexPath.section)
            ///是否需要签证
            cell.swithStatusBlock = { (status,senderTag) in
                weakSelf?.boolArray[senderTag - 4] = status
                if status == false{
                    weakSelf?.onOffNumArr[indexPath.section - 4].count = "0"
                }else{
                    weakSelf?.onOffNumArr[indexPath.section - 4].count = "1"
                }
                weakSelf?.calculatePriceInfo()
                weakSelf?.detailTable.reloadData()
            }
            return cell
            
        }
    }
    
    func returnNumWithCell(sectionIndex:NSInteger,cellIndex:NSInteger,number:NSInteger){
        switch sectionIndex {
        case 2:
            switch cellIndex {
            case 0:
                adultNum = number
            case 1:
                childNum = number
            default:
                return
            }
        
        default:
            return
        }
        ///计算费用
        calculatePriceInfo()
        detailTable.reloadData()
        
    }
}
extension PNearbyPlayViewController{
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
        
        ///传model到下一页
        guard adultNum != 0 else {
            showSystemAlertView(titleStr: "提示", message: "请选择出行人数")
            return
        }
        guard contactName.value.isEmpty == false else {
            showSystemAlertView(titleStr: "提示", message: "请填写联系人姓名")
            return
        }
        guard contactPhone.value.isEmpty == false && contactPhone.value.validate(ValidateType.phone) == true else {
            showSystemAlertView(titleStr: "提示", message: "请填写正确的联系人手机号")
            return
        }
        if contactEmail.value.isNotEmpty{
            guard contactEmail.value.validate(ValidateType.email) == true else{
                showSystemAlertView(titleStr: "提示", message: "邮箱格式错误")
                return
            }
        }
        
        orderModel.adultCount = adultNum.description
        orderModel.adultTicketRate = unitPrice
        orderModel.childCount = childNum.description
        orderModel.childTicketRate = "0"
        orderModel.contactEmail = contactEmail.value
        orderModel.contactName =  contactName.value
        orderModel.contactPhone =  contactPhone.value
        orderModel.deptDate = leaveTime
        orderModel.stockId = stokeId
        orderModel.needTcConfirm = nearbyModel.needTcConfirm
        orderModel.productId = productId
        orderModel.productName = productName
        orderModel.totalRate = totalPrice
        orderModel.type = nearbyModel.type
        
        
        orderModel.products.removeAll()
        for productInfo in nearbyModel.products{
            let temPassenger = PTravelOrderAddRequest.BaseTravelOrderProductVo()
            temPassenger.productName = productInfo.productName
            temPassenger.saleRate = productInfo.saleRate
            temPassenger.type = productInfo.type
            temPassenger.id = productInfo.id
            temPassenger.costRate = productInfo.costRate
            temPassenger.productNo = productInfo.productNo
            if productInfo.type == "1"{
                ///type = 1 普通产品必选，count=人头数
                temPassenger.count = (adultNum + childNum).description
            }else{
                ///type = 2 附加产品可选，count=选择的数量
                temPassenger.count = productInfo.count
            }
            ///== 0不上传
            ///count != 0 添加进去
            if temPassenger.count == "" || temPassenger.count == "0"
            {
                
            }else{
                orderModel.products.append(temPassenger)
            }
            
            
        }
        
        ///附加产品保险类
        orderModel.surances.removeAll()
        if nearbyModel.surances.count != 0{
            let startIndex = boolArray.count - nearbyModel.surances.count
            for i in startIndex ... boolArray.count-1{
                if boolArray[i] == true{
                    let suranceInfo = nearbyModel.surances[i-startIndex]
                    let temPassenger = PTravelOrderAddRequest.BaseSuranceOrderProductVo()
                    temPassenger.id = suranceInfo.id
                    temPassenger.suranceAgentPrice = suranceInfo.suranceAgentPrice
                    temPassenger.suranceCompany = suranceInfo.suranceCompany
                    temPassenger.suranceDesc = suranceInfo.suranceDesc
                    temPassenger.suranceId = suranceInfo.suranceId
                    temPassenger.suranceName = suranceInfo.suranceName
                    temPassenger.suranceProductNo = suranceInfo.suranceProductNo
                    temPassenger.suranceSalePrice = suranceInfo.suranceSalePrice
                    ///type = 1 普通产品必选，count=人头数
                    temPassenger.count = (adultNum + childNum).description
                    orderModel.surances.append(temPassenger)
                    
                }
            }
        }
        if orderModel.surances.count == 0{
            orderModel.needSurance = "0"
        }else{
             orderModel.needSurance = "1"
        }
        
        let nextVC:PTravelBookNextViewController = PTravelBookNextViewController()
        nextVC.priceArr = priceArr
        nextVC.adultCount = adultNum
        nextVC.childCount = childNum
        nextVC.orderModel = orderModel
        nextVC.remindStr = nearbyModel.orderattention
        nextVC.needConfig = nearbyModel.needTcConfirm
        nextVC.isWorld = nearbyModel.international
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    ///计算费用
    func calculatePriceInfo(){
        printDebugLog(message: adultNum)
        printDebugLog(message: childNum)
       
        ///总费用
        ///必选：unitprice * adultNum
        totalPrice = (Float(unitPrice)! * Float(adultNum)).TwoOfTheEffectiveFraction()
        
        priceArr.removeAll()
        priceArr.append(("基本团费","¥\(unitPrice)x\(adultNum)"))
        ///可选
        ///附加产品
        if boolArray.count>0{
            for i in 0...boolArray.count - 1{
                if onOffNumArr[i].type == "6"{
                    if boolArray[i] == true{
                        let price = Float(onOffNumArr[i].saleRate)! * Float(adultNum + childNum)
                        //priceArr.append((priceTitle: onOffNumArr[i].productName, price: "¥\(price.TwoOfTheEffectiveFraction())"))
                        priceArr.append((priceTitle: onOffNumArr[i].productName, price: "¥\(onOffNumArr[i].saleRate)x\(adultNum + childNum)"))
                        totalPrice = ( Float(totalPrice)! + price ).TwoOfTheEffectiveFraction()
                    }
                    
                }else{
                    if boolArray[i] == true{
                        let price = Float(onOffNumArr[i].saleRate)! * Float(onOffNumArr[i].count)!
                        priceArr.append((priceTitle: onOffNumArr[i].productName, price: "¥\(price.TwoOfTheEffectiveFraction())"))
                        totalPrice = ( Float(totalPrice)! + price ).TwoOfTheEffectiveFraction()
                    }
                }
                
            }
        }
        
        
        footerView.setViewWithArray(dataArr:priceArr)
        
        footerView.totalPriceLabel.text = totalPrice
    }
}
