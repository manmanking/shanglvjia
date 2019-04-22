//
//  CoTrainOrderViewController.swift
//  shop
//
//  Created by TBI on 2017/12/28.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import RxSwift
import SwiftDate

class CoTrainOrderViewController: CompanyBaseViewController {
    
    fileprivate let tableView = UITableView()
    
    fileprivate let coTrainOrderTableViewCellIdentify = "coTrainOrderTableViewCellIdentify"
    
    fileprivate let coTrainOrderPassengerHeaderTableViewCellIdentify = "coTrainOrderPassengerHeaderTableViewCellIdentify"
    
    fileprivate let coTrainOrderPassengerTableViewCellIdentify = "coTrainOrderPassengerTableViewCellIdentify"
    
    fileprivate let coTrainOrderContactPersonTableViewCellIdentify = "coTrainOrderContactPersonTableViewCellIdentify"
    
    
    fileprivate let coTrainOrderRemarkReasonTableViewCellIdentify = "coTrainOrderRemarkReasonTableViewCellIdentify"
    
    //违背cell
    fileprivate let trainContraryOrderTableCellIdentify = "trainContraryOrderTableCellIdentify"
    ///手动输入违背原因
    fileprivate var disReason:String = ""
    //订单备注
    fileprivate let addRemarkCellIdentify = "AddRemarkCell"
    
    fileprivate let coTrainOrderChoicesSeatTableViewCellIdentify = "coTrainOrderChoicesSeatTableViewCellIdentify"
    
    //出差单
    fileprivate  let flightTravelTableCellIdentify = "flightTravelTableCellIdentify"
    
    //联系人信息
    fileprivate  let flightCompanyContactTableCellIdentify = "flightCompanyContactTableCellIdentify"
    ///联系人选择
    fileprivate var contactPeopleDataSources:[String] = Array()
    
    fileprivate var trainList:[(price:Double,type:Int,seat:SeatTrain,model:CoTrainAvailInfo)] = []
    
    fileprivate var trainSVList:[(price:Double,type:Int,seat:SeatTrain,model:QueryTrainResponse.TrainAvailInfo)] = []
    
    //按钮点击事件标示位
    fileprivate var clickFlag:Bool = true
    
    //选择旅客信息
    //fileprivate var travellerList:[Traveller] = Array()
    
    fileprivate var travellerSVList:[QueryPassagerResponse] = Array()
    
    /// 是否显示出差单 1 显示 0 不显示
    fileprivate var travelSection:NSInteger = 0
    
    
   // fileprivate var userDetail:UserDetail?
    
    fileprivate var userSVDetail:LoginResponse?
    
    fileprivate let disposeBag = DisposeBag()
    
    var travelNo:String? = nil
    
    //新版自定义字段
    fileprivate var coNewOrderCustomConfig:CoNewOrderCustomConfig?
    
    fileprivate var orderCustomConfig:LoginResponse.UserBaseTravelConfig = LoginResponse.UserBaseTravelConfig()
    
    //自定义节点
    fileprivate var customFieldsSection:Int = 0
    
    fileprivate var travelModel:ModifyAndCreateCoNewOrderFrom = ModifyAndCreateCoNewOrderFrom()
    
    fileprivate let footerView:CoTrainOrderFooterView = CoTrainOrderFooterView()
    
    //一个人单价
    fileprivate var countPrice:Double = 0
    
    fileprivate var priceInfoView:CoTrainPriceInfoView?
    
    // 提交订单信息
    fileprivate var coomitModel:CoTrainCommitForm?
    
    // 乘车人
    fileprivate var passengers:[CoTrainCommitForm.SubmitTrainInfo.PassengerInfo] = []
    
    // 没有证件信息可以修改的乘客
    fileprivate var updateFlag:[String] = []
    
    let bgView = UIView()
    
    fileprivate var departureDate:String = ""
    
    fileprivate var returnDate:String = ""
    
    fileprivate var departureDateFormat:String = ""
    
    fileprivate var returnDateFormat:String = ""
    
    fileprivate let bag = DisposeBag()
    
    fileprivate var time = 0
    
    //订单备注
    fileprivate var remarkSection:Int = 0
    
    fileprivate var orderRemark = Variable("")
    
    //违背 1 显示 违背原因 0 不显示
    fileprivate var contrarySection:Int = 0
    
    /// 违背原因
    fileprivate var contraryReason = Variable("")
    
    /// 选座 存储
    fileprivate var goSelectedSeatArr:[(line:String,seatNo:String)] = Array()
    
    fileprivate var backSelectedSeatArr:[(line:String,seatNo:String)] = Array()
    
    /// 去程可以选座 0 不可以  1 可以选座
    fileprivate var isChoiceSeatFunctionFromTrip:NSInteger = 0
    
    /// 返程可以选座 0 不可以  1 可以选座
    fileprivate var isChoiceSeatFunctionBackTrip:NSInteger = 0
    ///是否可以选座
    fileprivate var isChoiceSeatFunction:Int = 0
    
    //fileprivate var result:CoTrainResultItem?
    fileprivate var result:[String] = Array()
    
    fileprivate var lodingsView:UIView?
    
    fileprivate var travelPurposesDataSources:[String] = Array()
    
    fileprivate var dispolicyReasonDataSources:[String] = Array()
    
    fileprivate var checkTime:Timer?
    
    /// 下单返回单号
    fileprivate var orderNo:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBlackTitleAndNavigationColor(title:"核对订单")
        setNavigationBackButton(backImage: "left")
        initTableView()
        initData ()
        initFooterView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func backButtonAction(sender:UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}

extension  CoTrainOrderViewController: UITableViewDelegate,UITableViewDataSource {
    
    func initData () {
        countPrice = 0
        if TrainManager.shareInstance.trainSearchConditionDraw().type == 2 {
            let fromPrice = getPrice(seat:TrainManager.shareInstance.trainStartStationDraw().selectedTrains,
                                     model:TrainManager.shareInstance.trainStartStationDraw())
            let toPrice = getPrice(seat:TrainManager.shareInstance.trainEndStationDraw().selectedTrains,
                                   model:TrainManager.shareInstance.trainEndStationDraw())
            countPrice = countPrice + fromPrice + toPrice
            trainSVList.append((price:fromPrice,type: 1,seat:TrainManager.shareInstance.trainStartStationDraw().selectedTrains, model: TrainManager.shareInstance.trainStartStationDraw()))
            trainSVList.append((price:toPrice,type: 2,seat: TrainManager.shareInstance.trainEndStationDraw().selectedTrains, model: TrainManager.shareInstance.trainEndStationDraw()))
        }else {
            let price = getPrice(seat:TrainManager.shareInstance.trainStartStationDraw().selectedTrains,model:TrainManager.shareInstance.trainStartStationDraw())
          countPrice = countPrice + price
            trainSVList.append((price:price,type: 0,seat: TrainManager.shareInstance.trainStartStationDraw().selectedTrains, model: TrainManager.shareInstance.trainStartStationDraw()))
        }
        travellerSVList = PassengerManager.shareInStance.passengerSVDraw()
        var i = 1
        for travel in travellerSVList {
            var passengerInfo = CoTrainCommitForm.SubmitTrainInfo.PassengerInfo()
            passengerInfo.passengerId = "\(i)"
            i = i + 1
            passengerInfo.piaoType = "1"
            passengerInfo.passengerName = travel.name
            passengerInfo.parId = travel.passagerId
            passengerInfo.sex = travel.sex
            passengerInfo.phone = travel.mobiles.first ?? ""
            passengerInfo.birthday = travel.birthday
            passengerInfo.email = travel.emails.first ?? ""
            if travel.certInfos.count > 0 {
                 let cards = travel.certInfos.filter{$0.certType == "1"}
                if cards.isEmpty {
                    passengerInfo.passportNo =  Variable(travel.certInfos.first?.certNo ?? "")
                    passengerInfo.passportTypeseId = "\(travel.certInfos.first?.certType ?? "1")"
                }else {
                    passengerInfo.passportNo = Variable(cards.first?.certNo ?? "")
                    passengerInfo.passportTypeseId = "\(cards.first?.certType ?? "1")"
                }
            }else {
                updateFlag.append(passengerInfo.passengerId)
            }
            passengers.append(passengerInfo)
           
        }
        
        userSVDetail = DBManager.shareInstance.userDetailDraw()
        coomitModel = CoTrainCommitForm()
        coomitModel?.accountId = userSVDetail?.busLoginInfo.userBaseInfo.uid ?? ""
        coomitModel?.contactInfo.contactUid = userSVDetail?.busLoginInfo.userBaseInfo.uid ?? ""
        coomitModel?.contactInfo.contactName = Variable(userSVDetail?.busLoginInfo.userBaseInfo.name ?? "")
        coomitModel?.contactInfo.contactPhone = Variable(userSVDetail?.busLoginInfo.userBaseInfo.mobiles.first ?? "")
        coomitModel?.contactInfo.contactEmail = Variable(userSVDetail?.busLoginInfo.userBaseInfo.emails.first ?? "")
       
        departureDate = ""
        departureDateFormat = TrainManager.shareInstance.trainSearchConditionDraw().departDate + " 00:00:00"
        travelModel.departureDate = "" //  TrainManager.shareInstance.trainSearchConditionDraw().departDate
        if TrainManager.shareInstance.trainSearchConditionDraw().returnDate.isNotEmpty {
            travelModel.returnDate = ""// TrainManager.shareInstance.trainSearchConditionDraw().returnDate
            returnDate = ""
            returnDateFormat = TrainManager.shareInstance.trainSearchConditionDraw().returnDate + " 00:00:00"
        }
        travelModel.destinations = [Variable(TrainManager.shareInstance.trainSearchConditionDraw().city)]
        
//        ///联系人
//        contactPeopleDataSources.removeAll()
//
//
//        var isContainUser:Bool = false
//        isContainUser = travellerSVList.contains(where: { (element) -> Bool in
//            if element.passagerId == userSVDetail?.userBaseInfo.uid {
//                return true
//            }
//            return false
//        })
//        for element in travellerSVList {
//            contactPeopleDataSources.append(element.name)
////            if element.passagerId != userSVDetail?.userBaseInfo.uid{
////
////            }
//        }
//        if isContainUser == false {
//            contactPeopleDataSources.append((userSVDetail?.userBaseInfo.name)!)
//        }
//
        
        //是否显示 违背原因
        // 返程
        if TrainManager.shareInstance.trainSearchConditionDraw().type == 2 {
            if TrainManager.shareInstance.trainStartStationDraw().selectedTrainsPolicy == "1" || TrainManager.shareInstance.trainEndStationDraw().selectedTrainsPolicy == "1" {
                contrarySection = 1
            }else{
                contrarySection = 0
            }
        }
        //订单备注
        remarkSection = 1
        // 单程
        if TrainManager.shareInstance.trainSearchConditionDraw().type == 0  {
            if TrainManager.shareInstance.trainStartStationDraw().selectedTrainsPolicy == "1" {
                contrarySection = 1
            }else{
                contrarySection = 0
            }
        }
        
        

        verifyWetherChoicesSeatRight()
        
        //        //获取公司出差单配置信息
        orderCustomConfig = (DBManager.shareInstance.userDetailDraw()?.busLoginInfo.userBaseInfo.travelConfig)!
        filterTravelPurposesDataSources()
        filterDispolicyReasonDataSources()
        // 是否显示出差单信息
        if orderCustomConfig.hasTravel == "1" {
            travelSection = 1
        }else {
            travelSection = 0
        }
        
        tableView.reloadData()
    }
    
    
    /// 过滤出差目的
    func filterTravelPurposesDataSources() {
        guard  (orderCustomConfig.travelPurposes.count) > 0 else {
            return
        }
        
        
        let travelPurpose = orderCustomConfig.travelPurposes.filter({ $0.type == "3" })
        travelPurposesDataSources = (travelPurpose.flatMap({ (element) -> String in
            return element.chDesc
        }))
    }
    /// 过滤 违背原因
    func filterDispolicyReasonDataSources() {
        guard userSVDetail?.busLoginInfo.userBaseInfo.disPolicy.count ?? 0 > 0 else {
            return
        }
        
        
        let dispolicyReason:[LoginResponse.TravelPurposes] = (userSVDetail?.busLoginInfo.userBaseInfo.disPolicy.filter({ $0.type == "3" }))!
        dispolicyReasonDataSources = dispolicyReason.flatMap({ (element) -> String? in
            return element.chDesc
        })
        dispolicyReasonDataSources.append("手动输入")
        
    }
    
    
    
    /// 验证是否 有选座的权限
    func verifyWetherChoicesSeatRight() {
        
        var edzRight:Bool =  false
        var ydzRight:Bool =  false
        var swzRight:Bool =  false
        
        // 去程
        if  (TrainManager.shareInstance.trainStartStationDraw().selectedTrains == SeatTrain.edzSeat &&
            (NSInteger(TrainManager.shareInstance.trainStartStationDraw().edzNum) ?? 0) > 0)
        {
            edzRight = true
        }else { edzRight = false }
        if  (TrainManager.shareInstance.trainStartStationDraw().selectedTrains == SeatTrain.ydzSeat &&
            (NSInteger(TrainManager.shareInstance.trainStartStationDraw().ydzNum) ?? 0) > 0)
        {
            ydzRight = true
        }else { ydzRight = false }
        
        if  (TrainManager.shareInstance.trainStartStationDraw().selectedTrains == SeatTrain.swzSeat &&
            (NSInteger(TrainManager.shareInstance.trainStartStationDraw().swzNum) ?? 0) > 0)
        {
            swzRight = true
        }else { swzRight = false }
        
        if edzRight == true || ydzRight == true || swzRight == true {
            isChoiceSeatFunctionFromTrip = 1
        }else { isChoiceSeatFunctionFromTrip = 0 }
        //返程
        if  (TrainManager.shareInstance.trainEndStationDraw().selectedTrains == SeatTrain.edzSeat &&
                (NSInteger(TrainManager.shareInstance.trainEndStationDraw().edzNum) ?? 0) > 0)
        {
            edzRight = true
        }else { edzRight = false }
        if  (TrainManager.shareInstance.trainEndStationDraw().selectedTrains == SeatTrain.ydzSeat &&
                (NSInteger(TrainManager.shareInstance.trainEndStationDraw().ydzNum) ?? 0) > 0)
        {
            ydzRight = true
        }else { ydzRight = false }
        
        if  (TrainManager.shareInstance.trainEndStationDraw().selectedTrains  == SeatTrain.swzSeat &&
                (NSInteger(TrainManager.shareInstance.trainEndStationDraw().swzNum) ?? 0) > 0)
        {
            swzRight = true
        }else { swzRight = false }
        
        if edzRight == true || ydzRight == true || swzRight == true {
            isChoiceSeatFunctionBackTrip = 1
        }else { isChoiceSeatFunctionBackTrip = 0 }
        
        if isChoiceSeatFunctionFromTrip == 1 || isChoiceSeatFunctionBackTrip == 1 {
            isChoiceSeatFunction = 1
        }else { isChoiceSeatFunction = 0 }
        
        
    }
    
    
    func getPrice (seat:SeatTrain,model:CoTrainAvailInfo) -> Double{
        switch seat {
            //二等、一等、商务、特等、硬座、硬卧、软卧、无座、软座、高级软卧
        case .edzSeat:
            return Double(model.edzPrice) ?? 0
        case .ydzSeat:
            return Double(model.ydzPrice) ?? 0
        case .swzSeat:
            return Double(model.swzPrice) ?? 0
        case .tdzSeat:
            return Double(model.tdzPrice) ?? 0
        case .yzSeat:
            return Double(model.yzPrice) ?? 0
        case .ywSeat:
            return Double(model.ywPrice) ?? 0
        case .rwSeat:
            return Double(model.rwPrice) ?? 0
        case .wzSeat:
            return Double(model.wzPrice) ?? 0
        case .rzSeat:
            return Double(model.rzPrice) ?? 0
        case .gjrwSeat:
             return Double(model.gjrwPrice) ?? 0
        default:
            return 0
        }
    }
    
    func getPrice (seat:SeatTrain,model:QueryTrainResponse.TrainAvailInfo) -> Double{
        switch seat {
        //二等、一等、商务、特等、硬座、硬卧、软卧、无座、软座、高级软卧
        case .edzSeat:
            return Double(model.edzPrice) ?? 0
        case .ydzSeat:
            return Double(model.ydzPrice) ?? 0
        case .swzSeat:
            return Double(model.swzPrice) ?? 0
        case .tdzSeat:
            return Double(model.tdzPrice) ?? 0
        case .yzSeat:
            return Double(model.yzPrice) ?? 0
        case .ywSeat:
            return Double(model.ywPrice) ?? 0
        case .rwSeat:
            return Double(model.rwPrice) ?? 0
        case .wzSeat:
            return Double(model.wzPrice) ?? 0
        case .rzSeat:
            return Double(model.rzPrice) ?? 0
        case .gjrwSeat:
            return Double(model.gjrwPrice) ?? 0
        default:
            return 0
        }
    }
    func getZWCode (seat:SeatTrain,model:QueryTrainResponse.TrainAvailInfo) -> String{
        switch seat {
            //   9:商务座, P:特等座,  M:一等座,  O（大写字母O，不是数字0）:二等座,6:高级软卧,4:软卧,3:硬卧,2:软座,1:硬座
        //二等、一等、商务、特等、硬座、硬卧、软卧、无座、软座、高级软卧
        case .edzSeat:
            return "O"
        case .ydzSeat:
            return "M"
        case .swzSeat:
            return "9"
        case .tdzSeat:
            return "P"
        case .yzSeat:
            return "1"
        case .ywSeat:
            return "3"
        case .rwSeat:
            return "4"
        case .wzSeat:
            if model.trainType == "G" || model.trainType == "D" || model.trainType == "C" {
                return "O"
            }
            return "1"
        case .rzSeat:
            return "2"
        case .gjrwSeat:
            return "6"
        default:
            return ""
        }
    }
    
    func getZWCode (seat:SeatTrain,model:CoTrainAvailInfo) -> String{
        switch seat {
         //   9:商务座, P:特等座,  M:一等座,  O（大写字母O，不是数字0）:二等座,6:高级软卧,4:软卧,3:硬卧,2:软座,1:硬座
        //二等、一等、商务、特等、硬座、硬卧、软卧、无座、软座、高级软卧
        case .edzSeat:
            return "O"
        case .ydzSeat:
            return "M"
        case .swzSeat:
            return "9"
        case .tdzSeat:
            return "P"
        case .yzSeat:
            return "1"
        case .ywSeat:
            return "3"
        case .rwSeat:
            return "4"
        case .wzSeat:
            if model.trainType == "G" || model.trainType == "D" || model.trainType == "C" {
                return "O"
            }
            return "1"
        case .rzSeat:
            return "2"
        case .gjrwSeat:
            return "6"
        default:
            return ""
        }
    }
    
    func getTrainSeatPolicy(seatType:SeatTrain) ->String {
        switch seatType {
        case .edzSeat:
            return "O"
        case .ydzSeat:
            return "M"
        case .swzSeat:
            return "9"
        case .tdzSeat:
            return "P"
        case .yzSeat:
            return "1"
        case .ywSeat:
            return "3"
        case .rwSeat:
            return "4"
        case .wzSeat:
            return "1"
        case .rzSeat:
            return "2"
        case .gjrwSeat:
            return "6"
        default:
            return ""
        }
    }
    
    
    
    
    func initFooterView(){
        bgView.backgroundColor = TBIThemeBackgroundViewColor
        KeyWindow?.addSubview(bgView)//放到主视图上
        self.view.addSubview(footerView)
        bgView.isHidden = true
        bgView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(54)
        }
        
        footerView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(54)
        }
        let price = countPrice * Double(passengers.count)
        if price.truncatingRemainder(dividingBy: 1) == 0 {
            footerView.priceCountLabel.text = "\(Int(price))"
        }else {
            footerView.priceCountLabel.text = "\(price)"
        }
        footerView.priceButton.addTarget(self, action: #selector(priceInfo(sender:)), for: .touchUpInside)
        bgView.addOnClickListener(target: self, action: #selector(removePriceInfo(tap:)))
        footerView.priceButton.addTarget(self, action: #selector(priceInfo(sender:)), for: .touchUpInside)
        footerView.submitButton.addTarget(self, action: #selector(submitOrder(sender:)), for: .touchUpInside)
    }
    
    func initTableView() {
        tableView.frame = self.view.frame
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CoTrainOrderTableViewCell.self, forCellReuseIdentifier: coTrainOrderTableViewCellIdentify)
        tableView.register(FlightContraryOrderTableCell.classForCoder(), forCellReuseIdentifier: trainContraryOrderTableCellIdentify)
        tableView.register(AddRemarkCell.classForCoder(), forCellReuseIdentifier: addRemarkCellIdentify)
        tableView.register(CoTrainOrderPassengerHeaderTableViewCell.self, forCellReuseIdentifier: coTrainOrderPassengerHeaderTableViewCellIdentify)
        tableView.register(CoTrainOrderPassengerTableViewCell.self, forCellReuseIdentifier: coTrainOrderPassengerTableViewCellIdentify)
        tableView.register(CoTrainOrderContactPersonTableViewCell.self, forCellReuseIdentifier: coTrainOrderContactPersonTableViewCellIdentify)
        tableView.register(FlightTravelTableCell.self, forCellReuseIdentifier: flightTravelTableCellIdentify)
        tableView.register(FlightCompanyContactTableCell.classForCoder(), forCellReuseIdentifier: flightCompanyContactTableCellIdentify)
        tableView.register(MineHomeTableViewFooterView.classForCoder(), forHeaderFooterViewReuseIdentifier: mineHomeTableViewHeaderViewIdentify)
        tableView.register(TBITrainSeatViewCell.self, forCellReuseIdentifier: coTrainOrderChoicesSeatTableViewCellIdentify)
        
        //
        tableView.separatorStyle = .none
        tableView.backgroundColor = TBIThemeBaseColor
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(-54)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {

        return  3 + contrarySection + travelSection + isChoiceSeatFunction + remarkSection
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
            return trainSVList.count
        }
        if contrarySection == 1 && section == 1{//违背信息节点
            return 1
        }
        
        if section == 1 + contrarySection {
            return passengers.count + 1
        }else if section == 2 + contrarySection && isChoiceSeatFunction == 1 {
            return isChoiceSeatFunctionBackTrip + isChoiceSeatFunctionFromTrip
        }
        
        return  1
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 1{
                return 118
            }
            return 123
        }
        
        if contrarySection == 1 && indexPath.section == 1{
            return 44
        }
        
        // 选座 分组 一人 展示一排座位 多人展示2排座位
        if isChoiceSeatFunction == 1 && indexPath.section == 2 + contrarySection {
            if passengers.count == 1 { return 100 }
            else { return 100 + 64 }
            
        }
        ///联系人
        if  indexPath.section == 2 + isChoiceSeatFunction + contrarySection
        {
            return 132
        }
        if indexPath.section == 2 + contrarySection + travelSection + isChoiceSeatFunction && travelSection == 1 {
            return 220
        }
        if indexPath.section == 3 + contrarySection + travelSection + isChoiceSeatFunction {
            return 70
        }
        
        return 44
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: coTrainOrderTableViewCellIdentify) as! CoTrainOrderTableViewCell
            cell.selectionStyle = .none
            //cell.fillCell(model: trainList[indexPath.row])
            cell.fillDataSources(model: trainSVList[indexPath.row])
            return cell
        }else if indexPath.section == 1 && contrarySection == 1{ //违反政策节点
            weak var weakSelf = self
            let cell = tableView.dequeueReusableCell(withIdentifier: trainContraryOrderTableCellIdentify) as! FlightContraryOrderTableCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.fillDataSourcesTrain(reason: contraryReason.value)
            cell.flightContraryOrderTableDispolicyBlock = { _ in
               weakSelf?.showDispolicyReasonView()
            }
            //cell.oldFillCell(model: oldCreate,describe:contraryDescribe ?? "")
           // cell.messageField.rx.text.orEmpty.bind(to: contraryReason).addDisposableTo(disposeBag)
            return cell
        }else if indexPath.section == 1 + contrarySection { //乘车人
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: coTrainOrderPassengerHeaderTableViewCellIdentify) as! CoTrainOrderPassengerHeaderTableViewCell
                cell.selectionStyle = .none
                cell.fillCell(count: passengers.count)
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: coTrainOrderPassengerTableViewCellIdentify) as! CoTrainOrderPassengerTableViewCell
                cell.selectionStyle = .none
                cell.fillCell(model: passengers[indexPath.row - 1],row:indexPath.row,count:passengers.count,updateFlag: updateFlag)
                cell.deleteBgView.tag = indexPath.row
                cell.deleteButton.tag = indexPath.row - 1 + 100
                cell.deleteButton.addTarget(self, action: #selector(deleteButton(sender:)), for: UIControlEvents.touchUpInside)
                cell.deleteBgView.addOnClickListener(target: self, action: #selector(deleteCellClick(tap:)))
                return cell
            }
        }else if indexPath.section == 2 + contrarySection && isChoiceSeatFunction == 1 { // 选择座位
            let cell:TBITrainSeatViewCell = tableView.dequeueReusableCell(withIdentifier: coTrainOrderChoicesSeatTableViewCellIdentify) as! TBITrainSeatViewCell
            var title:String = ""
            var seatType:SeatTrain = SeatTrain.defaultSeat
            if isChoiceSeatFunctionFromTrip == 1 && indexPath.row == 0 {
                title = "去"
                seatType = TrainManager.shareInstance.trainStartStationDraw().selectedTrains
            }
            if isChoiceSeatFunctionFromTrip == 0 && isChoiceSeatFunctionBackTrip == 1 && indexPath.row == 0 {
                title = "返"
                seatType = TrainManager.shareInstance.trainEndStationDraw().selectedTrains
            }
            if isChoiceSeatFunctionFromTrip == 1 && isChoiceSeatFunctionBackTrip == 1 && indexPath.row == 1 {
                title = "返"
                seatType = TrainManager.shareInstance.trainEndStationDraw().selectedTrains
            }
            cell.customUIViewAutolayout(passengersum: passengers.count, title:title,seatType: seatType)
            weak var weakSelf = self
            cell.trainSeatViewCellSelectedSeatBlock = { (selectedSeat,title) in
                if title == "去" {
                    weakSelf?.goSelectedSeatArr = selectedSeat
                }else {
                    weakSelf?.backSelectedSeatArr = selectedSeat
                }
                
            }
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }else if  indexPath.section == 2 + isChoiceSeatFunction + contrarySection{ //联系人
            // 联系人
            let cell:FlightCompanyContactTableCell = tableView.dequeueReusableCell(withIdentifier: flightCompanyContactTableCellIdentify) as! FlightCompanyContactTableCell
            cell.fillDataSources(name:(coomitModel?.contactInfo.contactName.value)!,phone:(coomitModel?.contactInfo.contactPhone.value)!,email:(coomitModel?.contactInfo.contactEmail.value)!)
            weak var weakSelf = self
            cell.flightCompanyContactBlock = { _ in
                weakSelf?.contactPersonAction()
            }
            //cell.nameField.addOnClickListener(target: self, action: #selector(contactPersonAction))
            cell.phoneField.rx.text.orEmpty.bind(to: (coomitModel?.contactInfo.contactPhone)!).addDisposableTo(disposeBag)
            cell.emailField.rx.text.orEmpty.bind(to: (coomitModel?.contactInfo.contactEmail)!).addDisposableTo(disposeBag)
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }else if indexPath.section == 2 + contrarySection + travelSection + isChoiceSeatFunction && travelSection == 1
        {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: flightTravelTableCellIdentify) as! FlightTravelTableCell
                //MARK:-----modify
                //cell.fillCell(model: coNewOrderCustomConfig, companyCode: "")
                cell.fillDataSources(model: orderCustomConfig, companyCode: "")
                cell.fillCellData(model: travelModel)
                cell.oneCell.addOnClickListener(target: self, action: #selector(travelDateNewClick(tap: )))
                cell.twoCell.addOnClickListener(target: self, action: #selector(travelDateNewClick(tap: )))
                cell.fourCell.addOnClickListener(target: self, action: #selector(travelTargetClick(tap: )))
                cell.cityContentLabel.rx.text.orEmpty.bind(to: travelModel.destinations[0]).addDisposableTo(disposeBag)
                cell.reasonContentLabel.rx.text.orEmpty.bind(to: travelModel.reason).addDisposableTo(disposeBag)
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                return cell
            
        }else if indexPath.section == 3 + contrarySection + travelSection + isChoiceSeatFunction {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: addRemarkCellIdentify) as! AddRemarkCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.fillDataSourcesRemark(reason: orderRemark.value)
//            cell.messageField.rx.text.orEmpty.bind(to: orderRemark).addDisposableTo(disposeBag)
            cell.messageTextView.rx.text.orEmpty.bind(to: orderRemark).addDisposableTo(disposeBag)
            return cell
        }
        return UITableViewCell()
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 + contrarySection {
            if indexPath.row != 0 {
                if updateFlag.contains(passengers[indexPath.row - 1].passengerId) {
                //if passengers[indexPath.row - 1].passportNo.value.isEmpty {
                    let vc = CoTrainPassengerController()
                    vc.passenger = passengers[indexPath.row - 1]
                    vc.updateRow = indexPath.row - 1
                    weak var weakSelf = self
                    
                    vc.trainPassengerResultBlock = { (data,row) in
                        weakSelf?.passengers[row] = data
                        weakSelf?.tableView.reloadData()
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
}

extension CoTrainOrderViewController {
    
    //价格详情
    func priceInfo(sender: UIButton) {
        if sender.isSelected == true {
            sender.isSelected = false
            bgView.isHidden = true
            priceInfoView?.removeFromSuperview()
        }else
        {
            priceInfoView = CoTrainPriceInfoView()
            if TrainManager.shareInstance.trainSearchConditionDraw().type == 2 {
                let fromPrice = getPrice(seat:TrainManager.shareInstance.trainStartStationDraw().selectedTrains ,
                                         model:TrainManager.shareInstance.trainStartStationDraw())
                let toPrice = getPrice(seat:TrainManager.shareInstance.trainEndStationDraw().selectedTrains ,
                                       model:TrainManager.shareInstance.trainEndStationDraw())
                priceInfoView?.initView(personCount: passengers.count, formPrice: fromPrice, toPrice: toPrice)
            }else {
                let price = getPrice(seat:TrainManager.shareInstance.trainStartStationDraw().selectedTrains ,
                                     model:TrainManager.shareInstance.trainStartStationDraw())
                priceInfoView?.initView(personCount: passengers.count, formPrice: price, toPrice: 0)
            }
            
            
            self.view.addSubview(priceInfoView!)
            var height:Double = 92
            if TrainManager.shareInstance.trainSearchConditionDraw().type == 2 { height += 30}
            self.view.addSubview(priceInfoView!)
            priceInfoView?.snp.makeConstraints({ (make) in
                make.left.right.equalTo(0)
                make.bottom.equalTo(footerView.snp.top)
                make.height.equalTo(height)
            })
            bgView.snp.updateConstraints({ (make) in
                make.bottom.equalToSuperview().inset(54+height)
            })
            bgView.isHidden = false
            sender.isSelected = true
        }
    }
    
    func removePriceInfo(tap:UITapGestureRecognizer) {
        footerView.priceButton.isSelected = false
        bgView.isHidden = true
        priceInfoView?.removeFromSuperview()
    }
    
    //出差目的
    func travelTargetClick(tap:UITapGestureRecognizer){
        let index = IndexPath(row: 0, section:  3 + isChoiceSeatFunction + contrarySection)
        let cell = self.tableView.cellForRow(at: index) as? FlightTravelTableCell
        cell?.cityContentLabel.resignFirstResponder()
        cell?.reasonContentLabel.resignFirstResponder()
        let titleArr:[String] = travelPurposesDataSources//DBManager.shareInstance.userDetailDraw()?.userBaseInfo.travelPurposes ?? [""]//coNewOrderCustomConfig?.travelTargets ?? [""]
        weak var weakSelf = self
        let roleView = TBIFinderView.init(frame: ScreenWindowFrame)
        roleView.finderViewSelectedResultBlock = { (cellIndex) in
            cell?.purposeContentLabel.text = titleArr[cellIndex]
            weakSelf?.travelModel.purpose = titleArr[cellIndex]
            let indexSet:IndexSet = IndexSet.init(integer:(3 + (weakSelf?.isChoiceSeatFunction ?? 0)!))
            weakSelf?.tableView.reloadSections(indexSet, with: UITableViewRowAnimation.automatic)
        }
        KeyWindow?.addSubview(roleView)
        roleView.reloadDataSources(titledataSources: titleArr, flageImage: nil)
    }
    
    
    /// 违背原因  展示
    func showDispolicyReasonView() {
        weak var weakSelf = self
        let roleView = TBIFinderView.init(frame: ScreenWindowFrame)
        roleView.finderViewSelectedResultBlock = { (cellIndex) in
            
            weakSelf?.dispolicyReasonSelected(index: cellIndex)
            
        }
        KeyWindow?.addSubview(roleView)
        roleView.reloadDataSources(titledataSources: dispolicyReasonDataSources, flageImage: nil)
    }
    
    func dispolicyReasonSelected(index:NSInteger) {
        guard dispolicyReasonDataSources.count >= index else {
            return
        }
        if  index == dispolicyReasonDataSources.count - 1 {
            // 进入手动输入 页面
            showManualDispolicyReasonView()
        }else{
            disReason = ""
        }
        contraryReason.value = dispolicyReasonDataSources[index]
        let indexpath:IndexPath = IndexPath.init(row: 0, section: 1)
        tableView.reloadRows(at:[indexpath] , with: UITableViewRowAnimation.automatic)
        
    }
    /// 展示 手动输入 违背原因
    func showManualDispolicyReasonView()  {
        weak var weakSelf = self
        let dispolicyReasonView = AddDispolicyReasonViewController()
        dispolicyReasonView.contentStr = disReason
        dispolicyReasonView.addDispolicyReasonViewResultBlock = { reason in
            
//            if reason.isEmpty == false {
//                weakSelf?.contraryReason.value = reason
//                let indexpath:IndexPath = IndexPath.init(row: 0, section: 1)
//                let cell:FlightContraryOrderTableCell = weakSelf?.tableView.cellForRow(at:indexpath) as! FlightContraryOrderTableCell
//                cell.messageContentLabel.text = weakSelf?.contraryReason.value
//            }
            weakSelf?.disReason = reason
            weakSelf?.contraryReason.value = reason
            let indexPath:IndexPath = IndexPath.init(row: 0, section: 1)
            weakSelf?.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
        
        self.navigationController?.pushViewController(dispolicyReasonView, animated: true)
    }
    
    
    
    
    
    
    //出差时间
    func travelDateNewClick(tap:UITapGestureRecognizer){
        weak var weakSelf = self
        
        let index = IndexPath(row: 0, section:  3 + isChoiceSeatFunction + contrarySection )
        let cell = self.tableView.cellForRow(at: index) as? FlightTravelTableCell
        let startDate = cell?.startDateContentLabel.text != "" ? cell?.startDateContentLabel.text:(DateInRegion()+3.day).string(custom: "yyyy-MM-dd")
        let endDate = cell?.endDateContentLabel.text != "" ? cell?.startDateContentLabel.text:(DateInRegion()+8.day).string(custom: "yyyy-MM-dd")
        
        let vc:TBICalendarViewController = TBICalendarViewController()
        vc.calendarAlertType = TBICalendarAlertType.Flight
        vc.calendarTypeAlert = ["请选择起始日期","请选择结束日期"]
        vc.selectedDates = [departureDateFormat,returnDateFormat]
        vc.isMultipleTap = true
        vc.showDateTitle = ["起始","结束"]
        vc.titleColor = TBIThemePrimaryTextColor
        vc.bacButtonImageName = "back"
        vc.hotelSelectedDateAcomplishBlock = { (parameters,action) in
            
            guard action == TBICalendarAction.Done else {
                return
            }
            weakSelf?.departureDateFormat = (parameters?.first)!
            weakSelf?.returnDateFormat = (parameters?.last)!
            let formatter = DateFormatter()
            formatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone?
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let sdate:Date = formatter.date(from: (parameters?[0])!)!
            //DateInRegion(string: (parameters?[0])!, format: .custom("YYYY-MM-dd hh:mm:ss"), fromRegion: regionRome)!
            let edate:Date = formatter.date(from: (parameters?[1])!)!
                //DateInRegion(string: (parameters?[1])!, format: .custom("YYYY-MM-dd hh:mm:ss"), fromRegion: regionRome)!
            cell?.startDateContentLabel.text = sdate.string(custom: "YYYY-MM-dd")
            cell?.endDateContentLabel.text = edate.string(custom: "YYYY-MM-dd")
            weakSelf?.departureDate = sdate.string(custom: "YYYY-MM-dd")
            weakSelf?.returnDate = edate.string(custom: "YYYY-MM-dd")
            
            weakSelf?.travelModel.departureDate = sdate.string(custom: "YYYY-MM-dd") //sdate.absoluteDate.unix
            weakSelf?.travelModel.returnDate    = edate.string(custom: "YYYY-MM-dd")//edate.absoluteDate.unix
            
            
        }
        _ = self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    /// 修改联系人
    func contactPersonAction() {
        //如果是一个人不弹出
        var isAble:Bool = false
        if passengers.count == 1 && passengers.first?.parId != userSVDetail?.busLoginInfo.userBaseInfo.uid {
          isAble = true
        }
        
        
        guard  passengers.count > 1 || isAble == true else {
            return
        }
        let index = IndexPath(row: 0, section: 2 + isChoiceSeatFunction + contrarySection)
        let cell = self.tableView.cellForRow(at: index) as? FlightCompanyContactTableCell
        weak var weakSelf = self
        var contactPersonDataSources:[String] = Array()
        
        var isContainUser:Bool = false
        isContainUser = passengers.contains(where: { (element) -> Bool in
            if element.parId == userSVDetail?.busLoginInfo.userBaseInfo.uid {
                return true
            }
            return false
        })
        
        for element in passengers {
            contactPersonDataSources.append(element.passengerName)
        }
        if isContainUser == false {
            contactPersonDataSources.append((userSVDetail?.busLoginInfo.userBaseInfo.name)!)
        }
        printDebugLog(message: contactPersonDataSources)
        
        let roleView = TBIFinderView.init(frame: ScreenWindowFrame)
        roleView.finderViewSelectedResultBlock = { (cellIndex) in
            cell?.nameContentLabel.text = contactPersonDataSources[cellIndex]
            weakSelf?.coomitModel?.contactInfo.contactName.value = contactPersonDataSources[cellIndex]
            printDebugLog(message: "selected index")
            printDebugLog(message: cellIndex)
            
            if cellIndex < (weakSelf?.passengers.count)!{
                cell?.phoneField.text = weakSelf?.passengers[cellIndex].phone
                cell?.emailField.text = weakSelf?.passengers[cellIndex].email
                weakSelf?.coomitModel?.contactInfo.contactEmail.value =  weakSelf?.passengers[cellIndex].email ?? ""
                weakSelf?.coomitModel?.contactInfo.contactPhone.value = weakSelf?.passengers[cellIndex].phone ?? ""
                weakSelf?.coomitModel?.contactInfo.contactUid = weakSelf?.passengers[cellIndex].parId ?? ""
                printDebugLog(message: weakSelf?.coomitModel?.contactInfo)
            }else{
                cell?.phoneField.text = weakSelf?.userSVDetail?.busLoginInfo.userBaseInfo.mobiles.first ?? ""
                cell?.emailField.text = weakSelf?.userSVDetail?.busLoginInfo.userBaseInfo.emails.first ?? ""
                weakSelf?.coomitModel?.contactInfo.contactEmail.value = weakSelf?.userSVDetail?.busLoginInfo.userBaseInfo.emails.first ?? ""
                weakSelf?.coomitModel?.contactInfo.contactPhone.value = weakSelf?.userSVDetail?.busLoginInfo.userBaseInfo.mobiles.first ?? ""
                weakSelf?.coomitModel?.contactInfo.contactUid = weakSelf?.userSVDetail?.busLoginInfo.userBaseInfo.uid ?? ""
                printDebugLog(message: weakSelf?.coomitModel?.contactInfo)
            }
        }
        KeyWindow?.addSubview(roleView)
        roleView.reloadDataSources(titledataSources: contactPersonDataSources, flageImage: nil)
        
    }
    
    
    
    //点击删除按钮
    func deleteButton(sender:UIButton){
        
        
        let deletePassenger = passengers[sender.tag - 100]
        var isContain = false
        if deletePassenger.parId == coomitModel?.contactInfo.contactUid {
            isContain = true
        }
        printDebugLog(message: "deletePassenger")
        printDebugLog(message: deletePassenger)
        
        passengers.remove(at: sender.tag - 100)
        if isContain == true {
            coomitModel?.contactInfo.contactEmail.value = passengers.last?.email ?? ""
            coomitModel?.contactInfo.contactName.value = passengers.last?.passengerName ?? ""
            coomitModel?.contactInfo.contactPhone.value = passengers.last?.phone ?? ""
            coomitModel?.contactInfo.contactUid = passengers.last?.parId ?? ""
        }
        printDebugLog(message: coomitModel?.contactInfo)

        
        let index = IndexPath(row: sender.tag - 100 + 1, section: 1 + contrarySection)
        let cell = self.tableView.cellForRow(at: index) as? CoTrainOrderPassengerTableViewCell
        //cell?.flag = false
        cell?.deleteImg.transform = (cell?.deleteImg.transform.rotated(by: CGFloat(-Double.pi/2)))!
        let price = countPrice * Double(passengers.count)
        if price.truncatingRemainder(dividingBy: 1) == 0 {
            footerView.priceCountLabel.text = "\(Int(price))"
        }else {
            footerView.priceCountLabel.text = "\(price)"
        }
        print("====删除\(sender.tag - 100)")
        
        self.tableView.reloadData()
        
    }
    
    //点击删除标示
    func deleteCellClick(tap:UITapGestureRecognizer){
        if passengers.count == 1{
            return
        }
        let index = IndexPath(row: tap.view?.tag ?? 0, section: 1 + contrarySection)
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
    
    //预订
    func submitOrder(sender: UIButton) {
        if sender.isSelected == false {
            priceInfoView?.isHidden = true
            bgView.isHidden = true
            
            if  travelNo == nil {
                
                if orderCustomConfig.travelRetTimeRequire == "1"{//出差时间
                    if departureDate.isEmpty  == true || returnDate.isEmpty == true {
                        showSystemAlertView(titleStr: "必填项", message: "请选择出差时间")
                        return
                    }
                }
                if orderCustomConfig.travelDestRequire == "1" {//出差地点
                    if travelModel.destinations.first?.value.isEmpty ?? true{
                        alertView(title: "提示",message: "请输入出差地点")
                        return
                    }
                }
                if orderCustomConfig.travelPurposeRequire == "1" {//出差目的
                    if travelModel.purpose.isEmpty{
                        alertView(title: "提示",message: "请选择出差目的")
                        return
                    }
                }
                if orderCustomConfig.travelReasonRequire == "1" {//出差事由
                    if travelModel.reason.value.isEmpty{
                        alertView(title: "提示",message: "请输入出差事由")
                        return
                    }
                }
            }
            
            
            if contrarySection == 1 && contraryReason.value.isEmpty == true {
                alertView(title: "提示",message: "填写违背原因")
                return
            }
            
            
            if TrainManager.shareInstance.trainSearchConditionDraw().type == 2 {
                
                var goTrip = CoTrainCommitForm.SubmitTrainInfo()
                /// 去程火车票信息
                goTrip.trainDate = TrainManager.shareInstance.trainSearchConditionDraw().departDate
                goTrip.fromStation = TrainManager.shareInstance.trainStartStationDraw().fromStationCode
                //formCoTrainAvailInfo?.fromStationCode ?? ""
                if TrainManager.shareInstance.trainStartStationDraw().selectedTrainsPolicy == "1" {
                    goTrip.disPolicyReason = contraryReason.value
                }
                goTrip.accordPolicy = TrainManager.shareInstance.trainStartStationDraw().selectedTrainsPolicy == "1" ? "0":"1"
                goTrip.trainNo = TrainManager.shareInstance.trainStartStationDraw().trainNo//
                goTrip.trainCode = TrainManager.shareInstance.trainStartStationDraw().trainCode
                goTrip.toStation = TrainManager.shareInstance.trainStartStationDraw().toStationCode
                //formCoTrainAvailInfo?.toStationCode ?? ""
                goTrip.arriveDay  = TrainManager.shareInstance.trainStartStationDraw().arriveDay
                goTrip.startStationName = TrainManager.shareInstance.trainStartStationDraw().startStationName
                goTrip.endStationName = TrainManager.shareInstance.trainStartStationDraw().endStationName
                goTrip.trainStartDate = TrainManager.shareInstance.trainStartStationDraw().trainStartDate
                goTrip.trainType = TrainManager.shareInstance.trainStartStationDraw().trainType
                goTrip.checi = TrainManager.shareInstance.trainStartStationDraw().trainCode//formCoTrainAvailInfo?.trainCode ?? ""
                goTrip.startTime = TrainManager.shareInstance.trainStartStationDraw().startTime//formCoTrainAvailInfo?.startTime ?? ""
                goTrip.arriveTime = TrainManager.shareInstance.trainStartStationDraw().arriveTime//formCoTrainAvailInfo?.arriveTime ?? ""
                goTrip.runTime = TrainManager.shareInstance.trainStartStationDraw().runTime//formCoTrainAvailInfo?.runTime ?? ""
                /// 出差单信息
                goTrip.travelStartTime = departureDate
                goTrip.travelEndTime = returnDate
                goTrip.travelDestination = travelModel.destinations.first?.value ?? ""
                goTrip.travelPurposen = travelModel.purpose
                goTrip.travelReason = travelModel.reason.value
                goTrip.remark = orderRemark.value
                
                for (index,passenger) in passengers.enumerated() {
                    var pass = CoTrainCommitForm.SubmitTrainInfo.PassengerInfo()
                    pass = passenger
                    pass.passengerId = NSNumber.init(value: 1 + index).stringValue
                    pass.price = "\(getPrice(seat:TrainManager.shareInstance.trainStartStationDraw().selectedTrains ,model:TrainManager.shareInstance.trainStartStationDraw()))"
                    pass.zwcode = getZWCode(seat:TrainManager.shareInstance.trainStartStationDraw().selectedTrains ,model:TrainManager.shareInstance.trainStartStationDraw())
                    goTrip.passengers.append(pass)
                }
                
                var backTrip = CoTrainCommitForm.SubmitTrainInfo()
                // 回程火车票信息
                backTrip.trainDate = TrainManager.shareInstance.trainSearchConditionDraw().returnDate
                //toCoTrainAvailInfo?.fromStationCode ?? ""
                if TrainManager.shareInstance.trainEndStationDraw().selectedTrainsPolicy == "1" {
                    backTrip.disPolicyReason = contraryReason.value
                }
                backTrip.accordPolicy = TrainManager.shareInstance.trainEndStationDraw().selectedTrainsPolicy == "1" ? "0":"1"
                backTrip.arriveDay  = TrainManager.shareInstance.trainEndStationDraw().arriveDay
                backTrip.startStationName = TrainManager.shareInstance.trainEndStationDraw().startStationName
                backTrip.fromStation = TrainManager.shareInstance.trainEndStationDraw().fromStationCode
                print("back start",backTrip.startStationName,TrainManager.shareInstance.trainEndStationDraw().startStationName)
                
                backTrip.endStationName = TrainManager.shareInstance.trainEndStationDraw().endStationName
                backTrip.toStation = TrainManager.shareInstance.trainEndStationDraw().toStationCode
                print("back end",backTrip.endStationName,TrainManager.shareInstance.trainEndStationDraw().endStationName)
                backTrip.trainNo = TrainManager.shareInstance.trainEndStationDraw().trainNo//
                backTrip.trainCode = TrainManager.shareInstance.trainEndStationDraw().trainCode
                backTrip.trainStartDate = TrainManager.shareInstance.trainEndStationDraw().trainStartDate
                backTrip.trainType = TrainManager.shareInstance.trainEndStationDraw().trainType
                backTrip.checi = TrainManager.shareInstance.trainEndStationDraw().trainCode//toCoTrainAvailInfo?.trainCode ?? ""
                backTrip.startTime = TrainManager.shareInstance.trainEndStationDraw().startTime//toCoTrainAvailInfo?.startTime ?? ""
                backTrip.arriveTime = TrainManager.shareInstance.trainEndStationDraw().arriveTime//toCoTrainAvailInfo?.arriveTime ?? ""
                backTrip.runTime = TrainManager.shareInstance.trainEndStationDraw().runTime//toCoTrainAvailInfo?.runTime ?? ""
                backTrip.remark = orderRemark.value
                for (index,passenger) in passengers.enumerated() {
                    var pass = CoTrainCommitForm.SubmitTrainInfo.PassengerInfo()
                    pass = passenger
                    pass.passengerId =  NSNumber.init(value: 1 + index).stringValue
                    pass.price = "\(getPrice(seat:TrainManager.shareInstance.trainEndStationDraw().selectedTrains ,model:TrainManager.shareInstance.trainEndStationDraw()))"
                    pass.zwcode = getZWCode(seat:TrainManager.shareInstance.trainEndStationDraw().selectedTrains ,model:TrainManager.shareInstance.trainEndStationDraw())
                    backTrip.passengers.append(pass)
                }
                coomitModel?.goTrip = goTrip
                coomitModel?.backTrip = backTrip
                
            }else {
                var goTrip = CoTrainCommitForm.SubmitTrainInfo()
                /// 去程火车票信息
                goTrip.trainDate = TrainManager.shareInstance.trainSearchConditionDraw().departDate
                //formCoTrainAvailInfo?.fromStationCode ?? ""
                goTrip.disPolicyReason = contraryReason.value
                goTrip.accordPolicy = TrainManager.shareInstance.trainStartStationDraw().selectedTrainsPolicy == "1" ? "0":"1"
                goTrip.arriveDay  = TrainManager.shareInstance.trainStartStationDraw().arriveDay
                goTrip.fromStation = TrainManager.shareInstance.trainStartStationDraw().fromStationCode
                goTrip.startStationName = TrainManager.shareInstance.trainStartStationDraw().startStationName
                goTrip.endStationName = TrainManager.shareInstance.trainStartStationDraw().endStationName
                goTrip.toStation = TrainManager.shareInstance.trainStartStationDraw().toStationCode
                goTrip.trainNo = TrainManager.shareInstance.trainStartStationDraw().trainNo//
                goTrip.trainCode = TrainManager.shareInstance.trainStartStationDraw().trainCode
                goTrip.trainStartDate = TrainManager.shareInstance.trainStartStationDraw().trainStartDate
                goTrip.trainType = TrainManager.shareInstance.trainStartStationDraw().trainType
                
                //formCoTrainAvailInfo?.toStationCode ?? ""
                goTrip.checi = TrainManager.shareInstance.trainStartStationDraw().trainCode//formCoTrainAvailInfo?.trainCode ?? ""
                goTrip.startTime = TrainManager.shareInstance.trainStartStationDraw().startTime//formCoTrainAvailInfo?.startTime ?? ""
                goTrip.arriveTime = TrainManager.shareInstance.trainStartStationDraw().arriveTime//formCoTrainAvailInfo?.arriveTime ?? ""
                goTrip.runTime = TrainManager.shareInstance.trainStartStationDraw().runTime//formCoTrainAvailInfo?.runTime ?? ""
                /// 出差单信息
                goTrip.travelStartTime = departureDate
                goTrip.travelEndTime = returnDate
                goTrip.travelDestination = travelModel.destinations.first?.value ?? ""
                goTrip.travelPurposen = travelModel.purpose
                goTrip.travelReason = travelModel.reason.value
                goTrip.remark = orderRemark.value
                
                for (index,passenger) in passengers.enumerated() {
                    var pass = CoTrainCommitForm.SubmitTrainInfo.PassengerInfo()
                    pass = passenger
                    pass.passengerId = NSNumber.init(value: 1 + index).stringValue
                    pass.passportNo = passenger.passportNo
                    pass.price = "\(getPrice(seat:TrainManager.shareInstance.trainStartStationDraw().selectedTrains ,model:TrainManager.shareInstance.trainStartStationDraw()))"
                    pass.zwcode = getZWCode(seat:TrainManager.shareInstance.trainStartStationDraw().selectedTrains ,model:TrainManager.shareInstance.trainStartStationDraw())
                    goTrip.passengers.append(pass)
                }
                coomitModel?.goTrip = goTrip
            }
            coomitModel?.travelNo = self.travelNo ?? ""
            lodingsView  = trainAnimationView(view: KeyWindow)
            sender.backgroundColor = TBIThemeGrayLineColor
            sender.isSelected = true
            
            commitOrder(commitModel: coomitModel!)
        }
       
    }
    
    func commitOrder(commitModel:CoTrainCommitForm) {
        weak var weakSelf = self
        //storeOrderCity()
        let submitParameter:SubmitTrainParams = SubmitTrainParams().CoTrainCommitFormConvertSubmitTrainParams(model: commitModel)
        var goSelectedSeat:String = ""
        var backSelectedSeat:String = ""
        if goSelectedSeatArr.count > 0 {
            for element in goSelectedSeatArr {
                goSelectedSeat += element.line + element.seatNo
            }
        }
        submitParameter.goTrip?.siteSelect = goSelectedSeat
        
        if backSelectedSeatArr.count > 0 {
            for element in backSelectedSeatArr {
                backSelectedSeat += element.line + element.seatNo
            }
        }
        if (submitParameter.goTrip?.passengers.count ?? 0)! > 0 {
            for ( index,element) in (submitParameter.goTrip?.passengers.enumerated())! {
                let birthdayDate:Date = Date.init(timeIntervalSince1970: TimeInterval((NSInteger(element.birthday) ?? 0) / 1000))
                submitParameter.goTrip?.passengers[index].birthday = birthdayDate.string(custom: "YYYY-MM-dd")
            }
        }
        if (submitParameter.backTrip?.passengers.count ?? 0)! > 0 {
            for ( index,element) in (submitParameter.backTrip?.passengers.enumerated())! {
                let birthdayDate:Date = Date.init(timeIntervalSince1970: TimeInterval((NSInteger(element.birthday) ?? 0) / 1000))
                submitParameter.backTrip?.passengers[index].birthday = birthdayDate.string(custom: "YYYY-MM-dd")
            }
        }
        
        submitParameter.backTrip?.siteSelect = backSelectedSeat
        
        // 添加 差标
        
        
        CoTrainService.sharedInstance
            .commit(model: submitParameter)
            .subscribe{ event in
                if weakSelf?.footerView.submitButton.isSelected == true {
                    weakSelf?.footerView.submitButton.isSelected = false
                    weakSelf?.footerView.submitButton.backgroundColor = TBIThemeDarkBlueColor
                }
                switch event{
                case .next(let e):
                    weakSelf?.result = e
                    printDebugLog(message: e)
                    weakSelf?.checkStatus()
                case .error(let e):
                    weakSelf?.lodingsView?.removeFromSuperview()
                    weakSelf?.intoNextSubmitOrderFailureView(orderStatus: false)
                    //try? self.validateHttp(e)
                    
                    
                    
                case .completed:
                    break
                }
            }.addDisposableTo(self.bag)
    }
    
//    ///保存当前订单 的城市
//    func storeOrderCity() {
//        var historyCityArr = DBManager.shareInstance.userHistoryCityRecordDraw()
//        let currentOrderCity = HotelCityModel()
//        currentOrderCity.elongId = TrainManager.shareInstance.trainSearchConditionDraw()
//        currentOrderCity.cnName = HotelManager.shareInstance.searchConditionUserDraw().cityName
//        historyCityArr?.append(currentOrderCity)
//        DBManager.shareInstance.userHistoryCityRecordStore(cityArr: historyCityArr!)
//    }
//
    func checkStatus () {
        if  checkTime == nil{
            checkTime = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(checkTime(timer:)), userInfo: nil, repeats: true)
            printDebugLog(message: "reset time")
            printDebugLog(message: Date().timeIntervalSince1970)
        }
        checkTime?.fire()
    }
    
    func checkTime(timer:Timer) {
        time += 1
        printDebugLog(message: time)
        printDebugLog(message: Date().timeIntervalSince1970)
        weak var weakSelf = self
        if time !=  1{
            if result.count > 0 {
                CoTrainService.sharedInstance.check(model: result)
                    .subscribe{ event in
                       
                        if weakSelf?.footerView.submitButton.isSelected == true {
                            weakSelf?.footerView.submitButton.isSelected = false
                            weakSelf?.footerView.submitButton.backgroundColor = TBIThemePrimaryWarningColor
                        }
                      
                    switch event{
                    case .next(let e):
                        if e.status != "2" { // 等待状态
                            timer.invalidate()
                            if weakSelf?.checkTime != nil {
                                weakSelf?.checkTime = nil
                                weakSelf?.time = 0
                            }
                        }
                        
                       if e.status == "0" {
                            //weakSelf?.orderNo = e.travelOrderNo
                            weakSelf?.lodingsView?.removeFromSuperview()
                            let view = CoTrainSuccessView(frame: ScreenWindowFrame)
                            view.trainSuccessBlock = {
                                weakSelf?.verifyUserRightApproval(orderArr: e.travelOrderNo)
                                //weakSelf?.getApproval(orderNoArr:e.travelOrderNo)
                                //weakSelf?.presentOrderDetails()
                            }
                            KeyWindow?.addSubview(view)
                            
                        }else if e.status == "-1" {
                            weakSelf?.lodingsView?.removeFromSuperview()
                            weakSelf?.alertView(title: "提示", message: e.msg)
                        
                       }else if e.status == "-2" {
                            //weakSelf?.orderNo = e.travelOrderNo
                            weakSelf?.lodingsView?.removeFromSuperview()
                        
                            let alertController = UIAlertController(title: "提示", message: e.msg, preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "确定", style: .default){ action in
                                alertController.removeFromParentViewController()
                                weakSelf?.presentOrderDetails()
                            }
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true)
                      }
                    case .error(let e):
                        timer.invalidate()
                        if weakSelf?.checkTime != nil {
                            weakSelf?.checkTime = nil
                            weakSelf?.time = 0
                        }
                        weakSelf?.lodingsView?.removeFromSuperview()
                        weakSelf?.intoNextSubmitOrderFailureView(orderStatus: false)
                        try? self.validateHttp(e)
                    case .completed:
                        break
                    }
                    }.addDisposableTo(self.bag)
            }
            
        }
        if time == 12 {
            timer.invalidate()
            weakSelf?.lodingsView?.removeFromSuperview()
            weakSelf?.alertView(title: "提示", message: "占座失败")
        }
        
    }
    
    //等待动画
    func trainAnimationView(view:UIView?) ->UIView{
        let lodingView = TrainLoadingView(frame: ScreenWindowFrame)
        view?.addSubview(lodingView)
        return lodingView
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
            orderInfo.orderType = "3"
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
        examineView.orderType = "3"
        self.navigationController?.pushViewController(examineView, animated: true)
    }
    
    func intoNextSubmitOrderFailureView(orderStatus:Bool) {
        let submitOrderFailureView = SubmitOrderFailureViewController()
        submitOrderFailureView.submitOrderStatus = orderStatus ? .Success_Submit_Order : .Failure_Submit_Order
        self.navigationController?.pushViewController(submitOrderFailureView, animated: true)
    }
    
    
    
    /// 跳到定单详情页面
    ///
    /// - Parameter orderNo:
    func presentOrderDetails (){
        self.navigationController?.popToRootViewController(animated: true)
        
//        if self.orderNo != nil {
//            let vc = CoNewOrderDetailsController()
//            vc.mBigOrderNOParams = self.orderNo ?? ""
//            vc.topBackEvent = .homePage
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
        
    }
}
