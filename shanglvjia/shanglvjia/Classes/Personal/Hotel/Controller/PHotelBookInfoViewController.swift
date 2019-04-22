//
//  PHotelBookInfoViewController.swift
//  shanglvjia
//
//  Created by tbi on 2018/7/30.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import SwiftDate

class PHotelBookInfoViewController: PersonalBaseViewController {
    
    
    /// 1 预付 2 现付
    public var presaleType:String = ""
    
    ///预订数量
    public var bookMaxRoomNum:NSInteger = 1
    
    public var bookInfoType:AppModelCatoryENUM = AppModelCatoryENUM.Default
    
    /// 定投酒店 信息
    public var specialHotelRoomInfo:SpecialHotelDetailResponse.RoomInfo = SpecialHotelDetailResponse.RoomInfo()

    public var hotelItemInfo:SpecialHotelListResponse.SpecialHotelInfo = SpecialHotelListResponse.SpecialHotelInfo()
    
    public var hotelFax:String = ""
    
    public var cityName:String = ""
    
    public var cityId:String = ""
    
    /// 普通个人酒店
    public var personalNormalHotelRoom:HotelDetailResult.HotelRoomInfo = HotelDetailResult.HotelRoomInfo()
    
    public var hotelNormalDetailInfo:PersonalHotelDetailResult = PersonalHotelDetailResult()
    
    /// 入店
    public var checkInDate:Date = Date()
    
    /// 离店
    public var checkOutDate:Date = Date()
    
    fileprivate var detailTable = UITableView()
    ///
    fileprivate var footerView:TravelPriceInfoView = TravelPriceInfoView()
    
    /// 预定时间 数组
    fileprivate var bookDateArr:[SpecialHotelDetailResponse.PriceDetailInfo] = Array()
    
    
    
    ///从上一个页面传model过来
    
    ///
    fileprivate var priceArr:[(priceTitle:String,price:String)] = Array()
    ///单价 测试
    let unitPrice = "6999"
    ///预订数量
    fileprivate var bookNum:NSInteger = 1
    
    fileprivate var roomAmount:Float = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBlackTitleAndNavigationColor(title: "酒店信息")
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.alpha = 1
        self.view.backgroundColor = TBIThemeBaseColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = TBIThemeBaseColor
        fillLocalDataSource()
        initTableView()
        initFooterView()
    }
    
    //MARK: -------- Action ------
    override func backButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
        detailTable.rowHeight = UITableViewAutomaticDimension
        detailTable.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(1)
            make.bottom.equalToSuperview().inset(54)
        }
        detailTable.register(VisaTitleCell.self, forCellReuseIdentifier: "VisaTitleCell")
        detailTable.register(TravelBookNumCell.self, forCellReuseIdentifier: "TravelBookNumCell")
        detailTable.register(PSepcialHotelBookInfoCell.self, forCellReuseIdentifier: "PSepcialHotelBookInfoCell")
        detailTable.register(PSepcialBookTimeCell.self, forCellReuseIdentifier: "PSepcialBookTimeCell")
     
    }
    func initFooterView(){
        self.view.addSubview(footerView)
        footerView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(54)
        }
        
        footerView.setViewWithArray(dataArr:priceArr)
        //calculatePriceInfo()
        caculateHotelRoomFee()
        KeyWindow?.addSubview(footerView.backBlackView)
        footerView.priceButton.addTarget(self, action: #selector(priceInfo(sender:)), for: .touchUpInside)
        footerView.priceButton.addTarget(self, action: #selector(priceInfo(sender:)), for: .touchUpInside)
        footerView.submitButton.addTarget(self, action: #selector(nextOrder(sender:)), for: .touchUpInside)
    }
    
    func matchBookHotelDate() {
        let checkInDateSecond:NSNumber = NSNumber.init(value:checkInDate.timeIntervalSince1970)
        let checkOutDateSecond:NSNumber = NSNumber.init(value:checkOutDate.timeIntervalSince1970)
        bookDateArr.removeAll()
        for element in specialHotelRoomInfo.ratePlanInfoList[specialHotelRoomInfo.selectedPlanInfoIndex].priceDetailInfoList {
            if checkInDateSecond.intValue <= element.saleDate / 1000 && checkOutDateSecond.intValue > element.saleDate / 1000 {
                printDebugLog(message: element.mj_keyValues())
                bookDateArr.append(element)
            }
        }
    }
    
    
    func fillLocalDataSource(){
       caculateHotelRoomFee()
       
        
       
        ///价格明细数组
        //priceArr.add(["priceTitle":"基本团费","price":"¥\(unitPrice)x\(bookNum)"])
    }
    
    
    func caculateHotelRoomFee() {
        priceArr.removeAll()
        roomAmount = 0
        switch  bookInfoType{
        case .PersonalHotel:
            fillPersonalNormalHotelRoomFee()
        case .PersonalSpecialHotel:
            fillSpecialHotelRoomFee()
        default: break
            
        }
        
        
//        for element in priceArr {
//            let prices:Float = Float(element.price) ?? 0
//            roomAmount += prices
//        }
        footerView.setViewWithArray(dataArr:priceArr)
        footerView.totalPriceLabel.text = roomAmount.TwoOfTheEffectiveFraction()
        
    }
    
    
    /// 计算定投酒店 费用
    func fillSpecialHotelRoomFee() {
        matchBookHotelDate()
        let dateFormatterString = DateFormatter()
        dateFormatterString.dateFormat = "MM月dd日"
        for element in bookDateArr {
            let dateStr:String = dateFormatterString.string(from: Date.init(timeIntervalSince1970: TimeInterval(element.saleDate / 1000)))
            roomAmount += element.saleRate * Float(bookNum)
            let tmpPrices:String = element.saleRate.TwoOfTheEffectiveFraction()
            priceArr.append((priceTitle:"房费" + dateStr, price:"¥ \(tmpPrices) X \(bookNum)"))
        }
    }
    
    func fillPersonalNormalHotelRoomFee() {
       
        let night:NSInteger = caculateIntervalDay(fromDate: checkInDate, toDate: checkOutDate)
        priceArr.removeAll()
        for i in 0...night - 1 {
            let tmpDate:Date =  checkInDate + i.day
            roomAmount += personalNormalHotelRoom.ratePlanInfoList[personalNormalHotelRoom
                .selectedPlanInfoIndex].rate * Float(bookNum)
            let tmpPrice:String = personalNormalHotelRoom.ratePlanInfoList[personalNormalHotelRoom
                .selectedPlanInfoIndex].rate.TwoOfTheEffectiveFraction()
            priceArr.append((priceTitle:"房费" + tmpDate.string(custom: "MM月dd日"), price: "¥ \(tmpPrice) X \(bookNum)"))
        }
        
        
    }
    private func caculateIntervalDay(fromDate:Date,toDate:Date) -> NSInteger {
        
        let calendar = NSCalendar.init(identifier: NSCalendar.Identifier.gregorian)
        let result = calendar?.components(NSCalendar.Unit.day, from: fromDate, to: toDate, options: NSCalendar.Options.matchFirst)
        
        return (result?.day)!
    }
    
}
extension PHotelBookInfoViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }else if section == 3{
            return 55
        }else{
            return 10
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 3 {
            let headView:VisaSectionHeaderView = VisaSectionHeaderView()
            headView.titleLabel.text = "退改规则"
            headView.titleLabel.snp.remakeConstraints { (make) in
                make.left.equalTo(15)
                make.top.bottom.equalToSuperview()
            }
            return headView
        }else{
            let view:UIView = UIView()
            view.backgroundColor = TBIThemeBaseColor
            return view
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        ///订单标题
        if indexPath.section == 0{
            let cell:PSepcialHotelBookInfoCell = tableView.dequeueReusableCell(withIdentifier: "PSepcialHotelBookInfoCell") as! PSepcialHotelBookInfoCell
            configCell(cell: cell, index: indexPath)
            return cell
        }else if indexPath.section == 1 {
            let cell:PSepcialBookTimeCell = tableView.dequeueReusableCell(withIdentifier: "PSepcialBookTimeCell") as! PSepcialBookTimeCell
            cell.fillDataSources(checkInDate: checkInDate, checkOutDate: checkOutDate)
            return cell
        }else  if indexPath.section == 2 {
            let cell:TravelBookNumCell = tableView.dequeueReusableCell(withIdentifier: "TravelBookNumCell") as! TravelBookNumCell
            cell.titleLabel.text = "预订房间数"
            weak var weakSelf = self
            //cell.numView.maxNumber = bookMaxRoomNum
            cell.numView.initStartNum(minNum: 1, maxNum:bookMaxRoomNum , num:bookNum)
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
            let cell:VisaTitleCell = tableView.dequeueReusableCell(withIdentifier: "VisaTitleCell") as! VisaTitleCell
            cell.titleLabel.font = UIFont.systemFont(ofSize: 13)
            var refundRule:String = ""
            switch bookInfoType {
            case .PersonalHotel:
                refundRule = personalNormalHotelRoom.ratePlanInfoList[personalNormalHotelRoom.selectedPlanInfoIndex].refundDesc
            case .PersonalSpecialHotel:
                refundRule = specialHotelRoomInfo.ratePlanInfoList[specialHotelRoomInfo.selectedPlanInfoIndex].productRemark
            default:break
            }
            
            cell.fillDataSources(visaName:refundRule)
            cell.titleLabel.textColor = PersonalThemeMinorTextColor
            cell.titleLabel.font = UIFont.systemFont(ofSize: 14)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            var refundRule:String = ""
            switch bookInfoType {
            case .PersonalHotel:
                refundRule = personalNormalHotelRoom.ratePlanInfoList[personalNormalHotelRoom.selectedPlanInfoIndex].refundDesc
            case .PersonalSpecialHotel:
                refundRule = specialHotelRoomInfo.ratePlanInfoList[specialHotelRoomInfo.selectedPlanInfoIndex].productRemark
            default:break
            }
            if refundRule.isEmpty == false {
                popPersonalNewAlertView(content:refundRule,titleStr:"退改规则",btnTitle:"确定")
            }
            
        }
        
        
    }
    
    
    func returnNumWithCell(sectionIndex:NSInteger,cellIndex:NSInteger,number:NSInteger){
        switch sectionIndex {
        case 2:
            switch cellIndex {
            case 0:
                bookNum = number
            default:
                return
            }
        default:
            return
        }
        ///计算费用
        //calculatePriceInfo()
        detailTable.reloadSections([2], with: UITableViewRowAnimation.none)
        caculateHotelRoomFee()
    }
    
    func configCell(cell:PSepcialHotelBookInfoCell,index:IndexPath) {
        switch  bookInfoType{
        case .PersonalHotel:
            configPersonalNormalHotelCell(cell: cell, index: index)
        case .PersonalSpecialHotel:
            configPersonalSpecialHotelCell(cell: cell, index: index)
            
        default: break
            
        }
    }
    
    /// 配置 定投酒店 cell
    func configPersonalSpecialHotelCell(cell:PSepcialHotelBookInfoCell,index:IndexPath) {
        cell.setCellWithData(title:specialHotelRoomInfo.roomName ,hotelName: hotelItemInfo.hotelName, meal:specialHotelRoomInfo.ratePlanInfoList[specialHotelRoomInfo.selectedPlanInfoIndex].ratePlanName, address:hotelItemInfo.address , phone:hotelItemInfo.hotelFax)
        
    }
    
    /// 配置 普通酒店 cell
    func configPersonalNormalHotelCell(cell:PSepcialHotelBookInfoCell,index:IndexPath) {
        cell.setCellWithData(title:personalNormalHotelRoom.roomTypeName ,hotelName: personalNormalHotelRoom.hotelName, meal:personalNormalHotelRoom.ratePlanInfoList[personalNormalHotelRoom.selectedPlanInfoIndex].ratePlanName, address:personalNormalHotelRoom.hotelAddress , phone:personalNormalHotelRoom.hotelPhone)
        
    }
    
    
    
    
}
extension PHotelBookInfoViewController{
    //价格详情
    func priceInfo(sender: UIButton) {
        if sender.isSelected == true {
            sender.isSelected = false
            footerView.backBlackView.isHidden = true
        }else
        {
            footerView.backBlackView.isHidden = false
            //calculatePriceInfo()
            caculateHotelRoomFee()
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
        
        guard bookNum != 0 else {
            showSystemAlertView(titleStr: "提示", message: "请选择房间数量")
            return
        }
        switch bookInfoType {
        case .PersonalSpecialHotel:
            personalSpecialHotelParameters()
        case .PersonalHotel:
            personalNormalHotelParameters()
        default: break
            
        }
      
    
    }
    
    /// 定投酒店
    func personalSpecialHotelParameters() {
        ///传model到下一页
        let submitVC:PHotelSubmitViewController = PHotelSubmitViewController()
        submitVC.hotelBaseInfo.hotelCityId = hotelItemInfo.cityId
        submitVC.hotelBaseInfo.hotelCityName = hotelItemInfo.cityName
        submitVC.hotelBaseInfo.hotelLat = hotelItemInfo.lat
        submitVC.hotelBaseInfo.hotelLong = hotelItemInfo.lon
        submitVC.hotelBaseInfo.hotelName = hotelItemInfo.hotelName
        submitVC.hotelBaseInfo.hotelDesc = hotelItemInfo.hotelDesc
        submitVC.hotelBaseInfo.roomType = specialHotelRoomInfo.roomName
        submitVC.hotelBaseInfo.hotelFax = hotelFax
        submitVC.hotelBaseInfo.payType = "1"
        submitVC.hotelBaseInfo.regionType = hotelItemInfo.regionType
        submitVC.hotelBaseInfo.hotelProductName = specialHotelRoomInfo.ratePlanInfoList[specialHotelRoomInfo
            .selectedPlanInfoIndex].ratePlanName
        submitVC.hotelBaseInfo.bedType = specialHotelRoomInfo.bedType
        submitVC.hotelBaseInfo.hotelProductId = specialHotelRoomInfo.ratePlanInfoList[specialHotelRoomInfo.selectedPlanInfoIndex].ratePlanId
        submitVC.elongType = "3"
        submitVC.hotelBaseInfo.hotelAddress = hotelItemInfo.address
        submitVC.hotelBaseInfo.hotelElongId = hotelItemInfo.elongId
        submitVC.priceArr = priceArr
        submitVC.bookCount = bookNum
        submitVC.checkInDate = checkInDate
        submitVC.checkOutDate = checkOutDate
        submitVC.roomAmount = roomAmount
        submitVC.hotelBaseInfo.refundDesc = specialHotelRoomInfo.ratePlanInfoList[specialHotelRoomInfo.selectedPlanInfoIndex].productRemark
        submitVC.corpCode = hotelItemInfo.groupCode
        self.navigationController?.pushViewController(submitVC, animated: true)
         printDebugLog(message: submitVC.hotelBaseInfo.mj_keyValues())
    }
    
    /// 普通酒店
    func personalNormalHotelParameters() {
        ///传model到下一页
        let submitVC:PHotelSubmitViewController = PHotelSubmitViewController()
        submitVC.hotelBaseInfo.hotelCityId = PersonalHotelManager.shareInstance.searchConditionUserDraw().cityId
        //hotelNormalDetailInfo.hotelDetailInfo.cityId// hotelItemInfo.elongId
        submitVC.hotelBaseInfo.hotelCityName = PersonalHotelManager.shareInstance.searchConditionUserDraw().cityName
            //hotelNormalDetailInfo.hotelDetailInfo.cityName
        submitVC.hotelBaseInfo.bedType = personalNormalHotelRoom.bedType //specialHotelRoomInfo.bedType
       
        submitVC.hotelBaseInfo.hotelProductId = personalNormalHotelRoom.ratePlanInfoList[personalNormalHotelRoom
            .selectedPlanInfoIndex].ratePlainId
        let corpCode:String = personalNormalHotelRoom.ratePlanInfoList[personalNormalHotelRoom
            .selectedPlanInfoIndex].corpCode
        if corpCode.isEmpty == false {
            submitVC.elongType = "1"
        }else{
            submitVC.elongType = "2"
        }
        submitVC.hotelBaseInfo.regionType = "1"
        submitVC.hotelBaseInfo.payType = presaleType
        submitVC.hotelBaseInfo.hotelLat = hotelNormalDetailInfo.hotelDetailInfo.latitude
        submitVC.hotelBaseInfo.hotelLong = hotelNormalDetailInfo.hotelDetailInfo.longitude
        submitVC.hotelBaseInfo.hotelName = hotelNormalDetailInfo.hotelDetailInfo.hotelName
        submitVC.hotelBaseInfo.hotelDesc = hotelNormalDetailInfo.hotelDetailInfo.hotelDesc
        submitVC.hotelBaseInfo.roomType = personalNormalHotelRoom.roomTypeName
        submitVC.hotelBaseInfo.hotelFax = hotelNormalDetailInfo.hotelDetailInfo.hotelPhone
        submitVC.hotelBaseInfo.roomElongId = personalNormalHotelRoom.ratePlanInfoList[personalNormalHotelRoom
            .selectedPlanInfoIndex].roomTypeId
        submitVC.hotelBaseInfo.hotelRoomId = personalNormalHotelRoom.hotelRoomId
        submitVC.hotelBaseInfo.hotelProductName = personalNormalHotelRoom.ratePlanInfoList[personalNormalHotelRoom
            .selectedPlanInfoIndex].ratePlanName
        submitVC.hotelBaseInfo.hotelAddress = personalNormalHotelRoom.hotelAddress//hotelItemInfo.address
        submitVC.hotelBaseInfo.hotelElongId = personalNormalHotelRoom.hotelElongId//hotelItemInfo.elongId
        submitVC.hotelBaseInfo.mealCount = personalNormalHotelRoom.ratePlanInfoList[personalNormalHotelRoom
            .selectedPlanInfoIndex].mealCount
        submitVC.hotelBaseInfo.refundDesc = personalNormalHotelRoom.ratePlanInfoList[personalNormalHotelRoom
            .selectedPlanInfoIndex].refundDesc
        submitVC.priceArr = priceArr
        submitVC.bookCount = bookNum
        submitVC.checkInDate = checkInDate
        submitVC.checkOutDate = checkOutDate
        submitVC.roomAmount = roomAmount
        submitVC.corpCode = personalNormalHotelRoom.ratePlanInfoList[personalNormalHotelRoom
            .selectedPlanInfoIndex].corpCode
        self.navigationController?.pushViewController(submitVC, animated: true)
        printDebugLog(message: submitVC.hotelBaseInfo.mj_keyValues())
    }
    
    
    
    ///计算费用
    func calculatePriceInfo() {
        
        var roomAmount:Float = 0
        for element in priceArr {
            let prices:Float = Float(element.price) ?? 0
            roomAmount += prices
        }
        footerView.setViewWithArray(dataArr:priceArr)
        footerView.totalPriceLabel.text = (roomAmount * Float(bookNum)).TwoOfTheEffectiveFraction()
    }
}
