//
//  PTravelBookViewController.swift
//  shanglvjia
//
//  Created by tbi on 2018/7/26.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import RxSwift

class PTravelBookViewController: PersonalBaseViewController {
    
    /// 产品Id
    public var productId:String = ""
    public var productName = ""
    ///单价 测试
    public var unitPrice = "1"
    ///库存ID
    public var stokeId = ""
    ///库存数量
    public var stocks = ""
    
    
    fileprivate var detailTable = UITableView()
    ///
    fileprivate var footerView:TravelPriceInfoView = TravelPriceInfoView()
    
    fileprivate var bookNumArr = NSMutableArray()
    ///
    fileprivate var priceArr:[(priceTitle:String,price:String)] = Array()

    fileprivate var onOffNumArr:[PTravelIndependentDetailModel.IndependentProductResponse] = Array()
    fileprivate var hotelArr:[PTravelIndependentDetailModel.IndependentProductResponse] = Array()
    fileprivate var carArr:[PTravelIndependentDetailModel.IndependentProductResponse] = Array()
    ///总价
    fileprivate var totalPrice:String  = ""
    /// 出发日期
    var leaveTime:String = ""
    
    var travelModel:PTravelIndependentDetailModel = PTravelIndependentDetailModel()
    
    ///下单model
    var orderModel:PTravelOrderAddRequest = PTravelOrderAddRequest()
    
    ///发票类型数组
    public var invoiceArr:[PTravelNearbyDetailModel.InvoicesModel] = Array()
    ///成人、儿童、房间 数量
    fileprivate var adultNum:NSInteger = 1
    fileprivate var childNum:NSInteger = 0
    fileprivate var roomNum:NSInteger = 0
    fileprivate var childProductNum:NSInteger = 0

    
    fileprivate var numArray:[String] = Array()
    fileprivate var boolArray:[Bool] = Array()
    
    let bag = DisposeBag()
    fileprivate var contactName:Variable = Variable("")
    fileprivate var contactPhone:Variable = Variable("")
    fileprivate var contactEmail:Variable = Variable("")
    ///上车地点
    fileprivate var carAddress:Variable = Variable("")
    fileprivate var carTime:String = ""
    
    ///必选房间 的数
    fileprivate var roomCount:NSInteger = 0
    ///必选单价--酒店
    fileprivate var roomPrice:Double = 0.00
    ///必选单价--除去酒店和用车
    fileprivate var otherPrice:Double = 0.00
    ///必选单价--用车
    fileprivate var carPrice:Double = 0.00
    ///必选用车 的数
    fileprivate var carCount:NSInteger = 0
    
    
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
        detailTable.register(TravelOnOffNumCell.self, forCellReuseIdentifier: "TravelOnOffNumCell")
        detailTable.register(NearbyOnOffNumCell.self, forCellReuseIdentifier: "NearbyOnOffNumCell")
        detailTable.register(TravelCarOnOffNumCell.self, forCellReuseIdentifier: "TravelCarOnOffNumCell")
        
        
    }
    func initFooterView(){
        self.view.addSubview(footerView)
        footerView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(54)
        }
        
    
        KeyWindow?.addSubview(footerView.backBlackView)
        footerView.priceButton.addTarget(self, action: #selector(priceInfo(sender:)), for: .touchUpInside)
        footerView.priceButton.addTarget(self, action: #selector(priceInfo(sender:)), for: .touchUpInside)
        footerView.submitButton.addTarget(self, action: #selector(nextOrder(sender:)), for: .touchUpInside)
    }
    func fillLocalDataSource(){

        
        
        contactName = Variable(DBManager.shareInstance.personalContactNameDraw())
        contactPhone = Variable(DBManager.shareInstance.personalContactPhoneDraw())
        contactEmail = Variable(DBManager.shareInstance.personalContactEmailDraw())
        
        ///价格明细数组
        unitPrice = travelModel.minPrice
      
        ///预订数量
        bookNumArr.add("成人\(unitPrice)元／位")
        bookNumArr.add("儿童\(unitPrice)元／位")
        
        
        ///是否签证 是否用车的 数据源  附加产品
        ///遍历products，type=2的时候add onOffNumArr
        ///productType:1机票2酒店3签证4用车5目的地旅游6保险
        if travelModel.products.count>0{
            for i in 0...travelModel.products.count - 1{
                if travelModel.products[i].type == "2"
                {
                    onOffNumArr.append(travelModel.products[i])
                    boolArray.append(false)
                    numArray.append("1")
                    
                }else{
                    ///如果产品里边有酒店，展示房间数
                    if travelModel.products[i].productType == "2"{
                        bookNumArr[2] = "房间数"
                        roomPrice = roomPrice + Double(travelModel.products[i].saleRate)!
                        hotelArr.append(travelModel.products[i])
                        childProductNum = Int(travelModel.products[i].childNum)!
                    }
                    if travelModel.products[i].productType == "1" || travelModel.products[i].productType == "3" || travelModel.products[i].productType == "5" {
                        ///type=1，必选产品中的单价
                        otherPrice = otherPrice + Double(travelModel.products[i].saleRate)!
                    }
                    if travelModel.products[i].productType == "4"{
                        ///必选中的用车 用车数=总人数／personNum
                        ///必选产品中的单价
                        ///carPrice = carPrice + Double(travelModel.products[i].saleRate)!
                        carArr.append(travelModel.products[i])
                    }
                }
                
            }
        }
        if travelModel.surances.count>0{
            for i in 0...travelModel.surances.count - 1{
                let model = PTravelIndependentDetailModel.IndependentProductResponse(jsonData: "")
                model?.productName = travelModel.surances[i].suranceName
                model?.saleRate = travelModel.surances[i].suranceSalePrice
                model?.productType = "6"
                onOffNumArr.append(model!)
                boolArray.append(false)
                numArray.append("1")
            }
        }
        calculateRoomNum()
        calculatePriceInfo()
    }
    func returnDescription(type:String) -> String{
        switch type {
        case "1":
            return "请选择您需要购买的数量"
        case "2":
            return "请选择您需要购买的数量"
        case "3":
            return "请选择您需要购买的数量"
        case "4":
            return "请确定用车数量"
        case "5":
            return "目的地"
        case "6":
            return "保险"
        default:
            return ""
        }
    }
    //MARK: -------- Action ------
    override func backButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }


}
extension PTravelBookViewController:UITableViewDataSource,UITableViewDelegate{
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
            if boolArray[indexPath.section - 4] == false
            {
                return 45
            }
        }
       
        return indexPath.section == 3 ? 132 : UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 2 || section == 3 {
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
        }else if indexPath.section == 0{
            ///订单标题
            let cell:VisaTitleCell = tableView.dequeueReusableCell(withIdentifier: "VisaTitleCell") as! VisaTitleCell
            cell.fillDataSources(visaName:productName)
            cell.titleLabel.font = UIFont.systemFont(ofSize: 14)
            return cell
        }else if indexPath.section == 1{
            let cell:VisaOrderCell = tableView.dequeueReusableCell(withIdentifier: "VisaOrderCell") as! VisaOrderCell
             ///选择时间
             cell.lineLabel.isHidden = true
            cell.arrowImage.isHidden = true
             cell.setCell(leftStr: "出发日期", rightStr: leaveTime)
            return cell
            
        }else if indexPath.section == 2{
            ///预订数量
            let cell:TravelBookNumCell = tableView.dequeueReusableCell(withIdentifier: "TravelBookNumCell") as! TravelBookNumCell
            cell.titleLabel.text = bookNumArr[indexPath.row] as? String
            
            ///成人最大数
            if indexPath.row == 0{
                adultNum = adultNum > ((Int(stocks) ?? 1)-childNum) ? (Int(stocks)!-childNum) : adultNum
                adultNum = adultNum == 0 ? 1 : adultNum
                cell.numView.initStartNum(minNum: 1, maxNum:(Int(stocks) ?? 1)-childNum , num:(adultNum))
            }
            ///选儿童的时候限制最大最小，最大为最大房间数*配置的儿童数
            if indexPath.row == 1{
                ///如果没配置酒店，儿童数不限制最大
                var maxChildNum = 0
                if roomCount == 0{
                    maxChildNum = (Int(stocks) ?? 1)-adultNum
                }else{
                    maxChildNum =  ((adultNum == 0 ? roomCount : adultNum)*childProductNum )>((Int(stocks) ?? 1)-adultNum) ? ((Int(stocks) ?? 1)-adultNum)  : ((adultNum == 0 ? roomCount : adultNum)*childProductNum )
                }
                ///如果已显示的儿童数>最大儿童数，重置
                childNum = (childNum > maxChildNum ? 0 : childNum)
                
                cell.numView.initStartNum(minNum: 0, maxNum: maxChildNum , num:childNum)
                //printDebugLog(message: ((adultNum == 0 ? roomCount : roomNum)*childProductNum )>((Int(stocks) ?? 1)-adultNum) ? ((Int(stocks) ?? 1)-adultNum)  : ((adultNum == 0 ? roomCount : roomNum)*childProductNum ))
                
            }
            ///选房间数的时候限制最大最小，根据人数更新显示数量startnum
            if indexPath.row == 2{
                cell.numView.initStartNum(minNum: roomCount, maxNum: adultNum , num:(roomNum == 0 ? roomCount : roomNum))
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
        }else{
            let onOffNumModel = onOffNumArr[indexPath.section - 4]
            ///附加产品的保险和签证
            if onOffNumModel.productType == "6"
            {
                let cell:NearbyOnOffNumCell = tableView.dequeueReusableCell(withIdentifier: "NearbyOnOffNumCell") as! NearbyOnOffNumCell
                weak var weakSelf = self
                cell.fillCell(isBill: boolArray[indexPath.section - 4],title:"\(onOffNumModel.productName)：\(onOffNumModel.saleRate)元/位",section:indexPath.section)
                ///是否需要签证
                cell.swithStatusBlock = { (status,senderTag) in
                    weakSelf?.boolArray[senderTag - 4] = status
                    if status == false{
                        weakSelf?.onOffNumArr[indexPath.section - 4].count = "0"
                    }else{
                        weakSelf?.onOffNumArr[indexPath.section - 4].count = ((weakSelf?.adultNum)!+(weakSelf?.childNum)!).description
                    }
                    weakSelf?.calculatePriceInfo()
                    weakSelf?.detailTable.reloadData()
                }
                return cell
                
            }else if onOffNumModel.productType == "4"{
                ///附加产品---用车
                let cell:TravelCarOnOffNumCell = tableView.dequeueReusableCell(withIdentifier: "TravelCarOnOffNumCell") as! TravelCarOnOffNumCell
                weak var weakSelf = self
                cell.fillCell(isBill: boolArray[indexPath.section - 4],title:"\(onOffNumModel.productName)：\(onOffNumModel.saleRate)元/辆", description: "请选择您需要购买的数量",section:indexPath.section)
                ///是否需要用车
                cell.swithStatusBlock = { (status,senderTag) in
                    weakSelf?.boolArray[senderTag - 4] = status
                    if status == false{
                        onOffNumModel.count = "0"
                    }else{
                        onOffNumModel.count = (weakSelf?.numArray[indexPath.section - 4])!
                        ///限制最小选一个
                        cell.numView.initStartNum(minNum: 1, maxNum: 999 , num:Int((weakSelf?.numArray[indexPath.section - 4])!)!)
                                                
                    }
                    
                    weakSelf?.calculatePriceInfo()
                    weakSelf?.detailTable.reloadData()
                }
                
                cell.numView.returnNumberBlock = { (num) in
                    weakSelf?.onOffNumArr[indexPath.section - 4].count = num.description
                    weakSelf?.returnNumWithCell(sectionIndex:indexPath.section,cellIndex: indexPath.row, number: num)
                    ///计算fei yong ming xi
                    weakSelf?.calculatePriceInfo()
                    weakSelf?.detailTable.reloadData()
                }
                cell.useCarTimeReturnBlock = { (time) in
                    weakSelf?.carTime = time
                }
                cell.addressField.rx.text.orEmpty.bind(to: carAddress).addDisposableTo(bag)
                carAddress.value = cell.addressField.text!
                
                return cell
            }else{
                let cell:TravelOnOffNumCell = tableView.dequeueReusableCell(withIdentifier: "TravelOnOffNumCell") as! TravelOnOffNumCell
                weak var weakSelf = self
                
                let unitStr = onOffNumModel.productType == "2" ?"/间夜" :"/位"
                cell.fillCell(isBill: boolArray[indexPath.section - 4],title:"\(onOffNumModel.productName)：\(onOffNumModel.saleRate)元\(unitStr)",description:"请选择您需要购买的数量",section:indexPath.section)
                ///签证最大
                if onOffNumModel.productType == "3"{
                    let numb:Int = (weakSelf?.onOffNumArr[indexPath.section - 4].count == "" ?Int((weakSelf?.numArray[indexPath.section - 4])!) : Int((weakSelf?.onOffNumArr[indexPath.section - 4].count)!))!
                    cell.numView.initStartNum(minNum: 1, maxNum: adultNum+childNum , num:numb)
                  
                }
                
                ///是否需要签证
                cell.swithStatusBlock = { (status,senderTag) in
                    weakSelf?.boolArray[senderTag - 4] = status
                    if status == false{
                        onOffNumModel.count = "0"
                    }else{
                        onOffNumModel.count = (weakSelf?.numArray[indexPath.section - 4])!
                        ///限制最小选一个
                        cell.numView.initStartNum(minNum: 1, maxNum: 999 , num:Int((weakSelf?.numArray[indexPath.section - 4])!)!)
                        
                        
                    }
                    
                    weakSelf?.calculatePriceInfo()
                    weakSelf?.detailTable.reloadData()
                }
                
                cell.numView.returnNumberBlock = { (num) in
                    weakSelf?.onOffNumArr[indexPath.section - 4].count = num.description
                    weakSelf?.returnNumWithCell(sectionIndex:indexPath.section,cellIndex: indexPath.row, number: num)
                    ///计算fei yong ming xi
                    weakSelf?.calculatePriceInfo()
                    weakSelf?.detailTable.reloadData()
                }
                return cell
            }
            
            
        }
    }
    func calculateRoomNum(){
        if travelModel.products.count>0{
            for i in 0...travelModel.products.count - 1{
                
                ///计算房间数
                if travelModel.products[i].type == "1" && travelModel.products[i].productType == "2"{
                    //roomCount = (adultNum + childNum)%Int(travelModel.products[i].personNum)! == 0 ?(adultNum + childNum )/Int(travelModel.products[i].personNum)! : (adultNum + childNum + 1)/Int(travelModel.products[i].personNum)!
                    roomCount = (adultNum)%Int(travelModel.products[i].personNum)! == 0 ?(adultNum )/Int(travelModel.products[i].personNum)! : (((adultNum)/Int(travelModel.products[i].personNum)!) + 1)
                    
                }
                detailTable.reloadData()
                
            }
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.section == 1{
//            //选择日期
//            selectDate()
//        }
        if indexPath.section>3{
            let onOffNumModel = onOffNumArr[indexPath.section - 4]
            if onOffNumModel.productType == "3"{
                let detailVC:PTravelVisaDetailViewController = PTravelVisaDetailViewController()
                detailVC.idStr = onOffNumModel.productNo
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
        }
    }
    func returnNumWithCell(sectionIndex:NSInteger,cellIndex:NSInteger,number:NSInteger){
        switch sectionIndex {
        case 2:
            switch cellIndex {
            case 0:
                adultNum = number
                ///加减完数量以后算房间数
                calculateRoomNum()
                ///儿童数联动酒店数--bug3435
                var maxssChildNum = 0
                maxssChildNum =  ((adultNum == 0 ? roomCount : roomCount)*childProductNum )>((Int(stocks) ?? 1)-adultNum) ? ((Int(stocks) ?? 1)-adultNum)  : ((adultNum == 0 ? roomCount : roomCount)*childProductNum )
                if childNum > maxssChildNum
                {
                    childNum = 0
                }
                roomNum = 0
                printDebugLog(message: maxssChildNum)
               
            case 1:
                childNum = number
                detailTable.reloadData()
                ///儿童数联动酒店数--bug3435
                roomNum = roomCount
                if roomNum != 0 {
                    var maxsChildNum = 0
                    //maxsChildNum =  ((adultNum == 0 ? roomCount : roomNum)*childProductNum )>((Int(stocks) ?? 1)-adultNum) ? ((Int(stocks) ?? 1)-adultNum)  : ((adultNum == 0 ? roomCount : roomNum)*childProductNum )
                    maxsChildNum =  ((adultNum == 0 ? roomCount : roomCount)*childProductNum )>((Int(stocks) ?? 1)-adultNum) ? ((Int(stocks) ?? 1)-adultNum)  : ((adultNum == 0 ? roomCount : roomCount)*childProductNum )
                    if childNum > maxsChildNum{
                        //roomNum = roomNum + (childNum - maxsChildNum )/childProductNum
                        roomNum = roomNum + ((childNum - maxsChildNum )%childProductNum == 0 ? (childNum - maxsChildNum )/childProductNum:(childNum - maxsChildNum + 1)/childProductNum)
                    }
                    printDebugLog(message: roomCount)
                    printDebugLog(message: maxsChildNum)
                    printDebugLog(message: roomNum)
                }
                
                
            case 2:
                roomNum = number
                ///加减完数量以后算房间数
                calculateRoomNum()
               //childNum = ( childNum > (roomNum == 0 ? roomCount : roomNum)*childProductNum ?  (roomNum == 0 ? roomCount : roomNum)*childProductNum :  childNum)
                childNum = ( childNum > (roomNum == 0 ? roomCount : roomNum)*childProductNum ?  0 :  childNum)
                ///childNum = 0
                printDebugLog(message: childNum)
            default:
                return
            }
        default:
            return
        }
        ///计算费用
        calculatePriceInfo()
        
        
    }
}
extension PTravelBookViewController{
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
        guard leaveTime.isEmpty == false else {
            showSystemAlertView(titleStr: "提示", message: "请填写出发日期")
            return
        }
        guard adultNum != 0 else {
            showSystemAlertView(titleStr: "提示", message: "请选择出行人数")
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
        if contactEmail.value.isNotEmpty{
            guard contactEmail.value.validate(ValidateType.email) == true else{
                showSystemAlertView(titleStr: "提示", message: "邮箱格式错误")
                return
            }
        }
        
        
        DBManager.shareInstance.personalContactNameStore(name: contactName.value)
        DBManager.shareInstance.personalContactPhoneStore(phone: contactPhone.value)
        DBManager.shareInstance.personalContactEmailStore(email: contactEmail.value)
        
        orderModel.adultCount = adultNum.description
        orderModel.adultTicketRate = unitPrice
        orderModel.childCount = childNum.description
        orderModel.childTicketRate = unitPrice
        orderModel.contactEmail = contactEmail.value
        orderModel.contactName =  contactName.value
        orderModel.contactPhone =  contactPhone.value
        orderModel.deptDate = leaveTime
        orderModel.stockId = stokeId
        orderModel.needTcConfirm = travelModel.needTcConfirm
        orderModel.productId = productId
        orderModel.productName = productName
        orderModel.totalRate = totalPrice
        orderModel.type = travelModel.type
        orderModel.needSurance = "1"
        orderModel.roomCount = (roomNum - roomCount) < 0 ? "0" : (roomNum - roomCount).description
        orderModel.roomRate = roomPrice.description
        
        orderModel.products.removeAll()
        for productInfo in travelModel.products{
            let temPassenger = PTravelOrderAddRequest.BaseTravelOrderProductVo()
            temPassenger.nightNum = productInfo.nightNum
            temPassenger.personNum = productInfo.personNum
            temPassenger.productName = productInfo.productName
            temPassenger.productType = productInfo.productType
            temPassenger.saleRate = productInfo.saleRate
            temPassenger.supplier = productInfo.supplier
            temPassenger.supplierName = productInfo.supplierName
            temPassenger.currency = productInfo.currency
            temPassenger.type = productInfo.type
            temPassenger.costRate = productInfo.costRate
            temPassenger.productNo = productInfo.productNo
            if productInfo.type == "1"{
                ///type = 1 普通产品必选，count=人头数
                ///1机票2酒店3签证4用车5目的地旅游6保险
                if productInfo.productType == "1" || productInfo.productType == "3" || productInfo.productType == "5"{
                    temPassenger.count = (adultNum + childNum).description
                }
                if productInfo.productType == "2"{
                    temPassenger.count = roomCount.description
                }
                if productInfo.productType == "4"{
                    temPassenger.count = carCount.description
                }
               
            }else{
               
                    ///type = 2 附加产品可选，count=选择的数量
                    temPassenger.count = productInfo.count
                
                
                if productInfo.productType == "4"{
                    temPassenger.startTime = carTime
                    temPassenger.startPoint = carAddress.value
                }
            }
            ///count != 0 添加进去
            if temPassenger.count == "" || temPassenger.count == "0"
            {
                
            }else{
                orderModel.products.append(temPassenger)
            }
            
        }
        ///附加产品保险类
         orderModel.surances.removeAll()
        if travelModel.surances.count != 0{
            let startIndex = boolArray.count - travelModel.surances.count
            for i in startIndex ... boolArray.count-1{
                if boolArray[i] == true{
                    let suranceInfo = travelModel.surances[i-startIndex]
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
        
        
        printDebugLog(message: orderModel.mj_keyValues())
        let nextVC:PTravelBookNextViewController = PTravelBookNextViewController()
        nextVC.priceArr = priceArr
        nextVC.adultCount = adultNum
        nextVC.childCount = childNum
        nextVC.orderModel = orderModel
        nextVC.remindStr = travelModel.remind
        nextVC.needConfig = travelModel.needTcConfirm
        nextVC.isWorld = travelModel.needExit
        nextVC.isIndepend = true
        nextVC.invoiceArr =  invoiceArr
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
     ///计算费用
    func calculatePriceInfo(){
     
        ///总费用
        ///必选：otherPrice *总人头数+carPrice*1 + roomPrice*(roomNum-roomCount)*nightNum
        
        ///酒店
        var hotelPrice : Float = 0
        if hotelArr.count > 0{
            for i in 0...hotelArr.count-1{
//                hotelPrice = hotelPrice + Float(hotelArr[i].saleRate)! * Float(hotelArr[i].nightNum)! * Float(roomCount)
                hotelPrice = hotelPrice + Float(hotelArr[i].saleRate)! * Float(roomCount)
            }
        }
        ///必选中的用车服务费用
        var carsPrice : Float = 0
        if carArr.count>0{
            for i in 0...carArr.count-1{

                 carCount = (adultNum+childNum)%Int(carArr[i].personNum)! == 0 ?(adultNum+childNum )/Int(carArr[i].personNum)! : (1+((adultNum+childNum)/Int(carArr[i].personNum)!))
                carsPrice = carsPrice + Float(carArr[i].saleRate)! * Float(carCount)
                
                printDebugLog(message: "carCount\(carCount)")
                printDebugLog(message: "carsPrice\(carsPrice)")
            }
        }
        
        ///可选：房间差
        let roomCha = (roomNum-roomCount < 0 ? 0 : roomNum-roomCount)
        
        totalPrice = (Float(otherPrice) * Float(adultNum + childNum) + carsPrice + hotelPrice).TwoOfTheEffectiveFraction()
        printDebugLog(message: "\(otherPrice) * \(adultNum + childNum) + \(carsPrice) + \(hotelPrice) + \(roomPrice) * \(roomCha))")
        
        priceArr.removeAll()
        priceArr.append(("基本团费","¥\(totalPrice)"))
        ///如果有房间差
        if roomCha != 0{
            priceArr.append(("房间差","¥\((Float(roomPrice) * Float(roomCha)).TwoOfTheEffectiveFraction())"))
            totalPrice = ( Float(totalPrice)! + (Float(roomPrice) * Float(roomCha)) ).TwoOfTheEffectiveFraction()
        }
        
        if boolArray.count > 0{
            ///附加产品
            for i in 0...boolArray.count - 1{
                if boolArray[i] == true{
                    if onOffNumArr[i].productType == "6"{
                        let price = Float(onOffNumArr[i].saleRate)! * Float(adultNum + childNum)
                        //priceArr.append((priceTitle: onOffNumArr[i].productName, price: "¥\(price.TwoOfTheEffectiveFraction())"))
                        priceArr.append((priceTitle: onOffNumArr[i].productName, price: "¥\(onOffNumArr[i].saleRate)x\(adultNum + childNum)"))
                        totalPrice = ( Float(totalPrice)! + price ).TwoOfTheEffectiveFraction()
                    }else{
                        let price = Float(onOffNumArr[i].saleRate)! * Float(onOffNumArr[i].count)!
                        //priceArr.append((priceTitle: onOffNumArr[i].productName, price: "¥\(price.TwoOfTheEffectiveFraction())"))
                        priceArr.append((priceTitle: onOffNumArr[i].productName, price: "¥\(onOffNumArr[i].saleRate)x\(onOffNumArr[i].count)"))
                        totalPrice = ( Float(totalPrice)! + price ).TwoOfTheEffectiveFraction()
                    }
                    
                }
                
            }
        }
        
        
        footerView.totalPriceLabel.text = totalPrice
        footerView.setViewWithArray(dataArr:priceArr)
    }
}
extension PTravelBookViewController{
    ///选择出发日期
    func selectDate(){
        weak var weakSelf = self
        let vc:TBICalendarViewController = TBICalendarViewController()
        vc.isMultipleTap = false
        vc.calendarAlertType = TBICalendarAlertType.Default
        vc.showDateTitle = [""]
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
}
