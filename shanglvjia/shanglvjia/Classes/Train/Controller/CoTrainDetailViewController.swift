//
//  CoTrainDetailViewController.swift
//  shop
//
//  Created by TBI on 2017/12/28.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import RxSwift
import SwiftDate

class CoTrainDetailViewController: CompanyBaseViewController {
    
    fileprivate let headerView = CoTrainListHeaderView()
    
    fileprivate let tableView = UITableView()
    
    fileprivate let coTrainDetailHeaderTableViewIdentify = "coTrainDetailHeaderTableViewIdentify"
    
    fileprivate let coTrainDetailTableViewCellIdentify = "coTrainDetailTableViewCellIdentify"
    
    fileprivate var seatList:[(seat:SeatTrain,num:String,price:String,policy:Bool)] = []
    
    //fileprivate var model:CoTrainAvailInfo?
    
    fileprivate var trainInfoModel:QueryTrainResponse.TrainAvailInfo = QueryTrainResponse.TrainAvailInfo()
    
    fileprivate var type:Int = 0
    
      fileprivate var trainBookMax:NSInteger = 30
    
    fileprivate let bag = DisposeBag()
    
    fileprivate var flag = 0
    
    var travelNo:String? = nil
    
    /// 违反差标是否可以购买  true 可以购买。false 不可以购买
    var canOrder:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        type = TrainManager.shareInstance.trainSearchConditionDraw().type
        trainBookMax = UserDefaults.standard.object(forKey: trainBookMaxDate) as! NSInteger
        initView ()
        initData ()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if TrainManager.shareInstance.trainSearchConditionDraw().type ==  0 {
            setNavigation(title:"车次详情")
        }else if TrainManager.shareInstance.trainSearchConditionDraw().type ==  1 {
            setNavigation(title:"去程: 车次详情")
        }else {
            setNavigation(title:"返程: 车次详情")
        }
        setNavigationBackButton(backImage: "")
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func backButtonAction(sender:UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}

extension  CoTrainDetailViewController: UITableViewDelegate,UITableViewDataSource {
    
    func initData () {
        
        if TrainManager.shareInstance.trainSearchConditionDraw().type == 2{
            //回程
            //model = toCoTrainAvailInfo
            trainInfoModel = TrainManager.shareInstance.trainEndStationDraw()
        }else {
            //去程
            //model = formCoTrainAvailInfo
            trainInfoModel = TrainManager.shareInstance.trainStartStationDraw()
        }
        canOrder = DBManager.shareInstance.userDetailDraw()?.busLoginInfo.userBaseInfo.canOrder == "1" ? true : false
        seatList.removeAll()
        if flag == 0 {
            if trainInfoModel.edzNum != "--"{
                seatList.append((seat: SeatTrain.edzSeat, num: trainInfoModel.edzNum, price: trainInfoModel.edzPrice ,policy:(trainInfoModel.edzPolicy == "1" ?  false : true   )))
                
            }
            
            if trainInfoModel.ydzNum != "--"{
                seatList.append((seat: SeatTrain.ydzSeat, num: trainInfoModel.ydzNum, price: trainInfoModel.ydzPrice ,policy:trainInfoModel.ydzPolicy == "1" ?  false : true  ))
            }
            
            if trainInfoModel.swzNum != "--"{
                seatList.append((seat: SeatTrain.swzSeat, num: trainInfoModel.swzNum, price: trainInfoModel.swzPrice ,policy:trainInfoModel.swzPolicy == "1" ?  false : true  ))
            }
            
            if trainInfoModel.tdzNum != "--"{
                seatList.append((seat: SeatTrain.tdzSeat, num: trainInfoModel.tdzNum, price: trainInfoModel.tdzPrice ,policy:trainInfoModel.tdzPolicy == "1" ?  false : true  ))
                
            }
            if trainInfoModel.yzNum != "--"{
                seatList.append((seat: SeatTrain.yzSeat, num: trainInfoModel.yzNum, price: trainInfoModel.yzPrice ,policy:trainInfoModel.yzPolicy == "1" ?  false : true  ))
            }
            
            if trainInfoModel.ywNum != "--"{
                seatList.append((seat: SeatTrain.ywSeat, num: trainInfoModel.ywNum, price: trainInfoModel.ywPrice ,policy:trainInfoModel.ywPolicy == "1" ?  false : true  ))
            }
    
            if trainInfoModel.rwNum != "--"{
                seatList.append((seat: SeatTrain.rwSeat, num: trainInfoModel.rwNum, price: trainInfoModel.rwPrice ,policy:trainInfoModel.rwPolicy == "1" ?  false : true  ))
                }
            if trainInfoModel.wzNum != "--"{
            seatList.append((seat: SeatTrain.wzSeat, num: trainInfoModel.wzNum, price: trainInfoModel.wzPrice,policy:trainInfoModel.wzPolicy == "1" ?  false : true  ))
        }
            
            if trainInfoModel.rzNum != "--" {
                seatList.append((seat: SeatTrain.rzSeat, num: trainInfoModel.rzNum, price: trainInfoModel.rzPrice ,policy:trainInfoModel.rzPolicy == "1" ?  false : true  ))
        }

            if trainInfoModel.gjrwNum != "--"{
                seatList.append((seat: SeatTrain.gjrwSeat, num: trainInfoModel.gjrwNum, price: trainInfoModel.gjrwPrice ,policy:trainInfoModel.gjrwPolicy == "1" ?  false : true  ))
        }
            
        }
        tableView.reloadData()
    }
    
    func initTableView() {
        tableView.frame = self.view.frame
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CoTrainDetailTableViewCell.self, forCellReuseIdentifier: coTrainDetailTableViewCellIdentify)
        tableView.register(CoTrainDetailHeaderTableView.classForCoder(), forHeaderFooterViewReuseIdentifier: coTrainDetailHeaderTableViewIdentify)
        tableView.separatorStyle = .none
        tableView.backgroundColor = TBIThemeBaseColor
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView:CoTrainDetailHeaderTableView = tableView.dequeueReusableHeaderFooterView(withIdentifier: coTrainDetailHeaderTableViewIdentify) as! CoTrainDetailHeaderTableView
        //headerView.message.addOnClickListener(target: self, action:  #selector(detailClick(tap:)))
        if TrainManager.shareInstance.trainSearchConditionDraw().type == 2{
            //headerView.fillCell(model: toCoTrainAvailInfo)
            headerView.fillDataSources(model:TrainManager.shareInstance.trainEndStationDraw())
        }else {
            //headerView.fillCell(model: formCoTrainAvailInfo)
            headerView.fillDataSources(model:TrainManager.shareInstance.trainStartStationDraw())
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 126
    }
    
    //MARK:- UITableViewDataSources
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  seatList.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: coTrainDetailTableViewCellIdentify) as! CoTrainDetailTableViewCell
        cell.selectionStyle = .none
        cell.fillCell(model: seatList[indexPath.row],anOrder:canOrder,row: indexPath.row)
        cell.bookingButton.tag = indexPath.row
        cell.bookingButton.addTarget(self, action: #selector(booking(sender:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    //预订
    func booking(sender: UIButton) {
        if seatList[sender.tag].policy == false && !canOrder{
            return
        }
        

        
        if seatList[sender.tag].num != "0" {
            
            let vc = CoTrainOrderViewController()
            vc.travelNo = self.travelNo
            if TrainManager.shareInstance.trainSearchConditionDraw().type ==  0 {
                let selectedTrainTrip = TrainManager.shareInstance.trainStartStationDraw()
                selectedTrainTrip.selectedTrains = seatList[sender.tag].seat
                selectedTrainTrip.selectedTrainsPolicy = seatList[sender.tag].policy ==  false ? "1" : "0"
                TrainManager.shareInstance.trainStartStationStore(from: selectedTrainTrip)
                self.navigationController?.pushViewController(vc, animated: true)
            }else if TrainManager.shareInstance.trainSearchConditionDraw().type == 1{
                
                let selectedTrainTrip = TrainManager.shareInstance.trainStartStationDraw()
                selectedTrainTrip.selectedTrains = seatList[sender.tag].seat
                selectedTrainTrip.selectedTrainsPolicy = seatList[sender.tag].policy ==  false ? "1" : "0"
                TrainManager.shareInstance.trainStartStationStore(from: selectedTrainTrip)
                let searchCondition = TrainManager.shareInstance.trainSearchConditionDraw()
                searchCondition.type = 2
                TrainManager.shareInstance.trainSearchConditionStore(searchCondition: searchCondition)
                let vcp = CoTrainListViewController()
                vcp.travelNo = self.travelNo
                self.navigationController?.pushViewController(vcp, animated: true)
            }else if TrainManager.shareInstance.trainSearchConditionDraw().type == 2{
                let selectedTrainTrip = TrainManager.shareInstance.trainEndStationDraw()
                selectedTrainTrip.selectedTrains = seatList[sender.tag].seat
                selectedTrainTrip.selectedTrainsPolicy = seatList[sender.tag].policy ==  false ? "1" : "0"
                TrainManager.shareInstance.trainEndStationStore(to: selectedTrainTrip)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }

    }
    
}
extension  CoTrainDetailViewController {
    
    func initView () {
        setHeaderView()
        initTableView()
    }
    
    
    func setHeaderView() {
        self.view.addSubview(headerView)
        
        initDateLabel()
        
        headerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(40)
        }
        headerView.previousLabel.addOnClickListener(target: self, action: #selector(beforeDateClick(tap:)))
        headerView.nextLabel.addOnClickListener(target: self, action: #selector(nextDateClick(tap:)))
        headerView.dateView.addOnClickListener(target: self, action: #selector(dateClick(tap:)))
    }
    
    
    func dateClick (tap:UITapGestureRecognizer) {
        weak var weakSelf = self
        let vc:TBICalendarViewController = TBICalendarViewController()
        vc.isMultipleTap = false
        vc.calendarAlertType = TBICalendarAlertType.Train
        vc.showDateTitle = [""]
        vc.titleColor = TBIThemePrimaryTextColor
        vc.bacButtonImageName = "back"
        vc.hotelSelectedDateAcomplishBlock = { (parameters,action) in
            
            weakSelf?.adjustTrainDate(parameters: parameters, action: action)
            weakSelf?.initDateLabel()
            weakSelf?.updateData()
        }
        _ = self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func adjustTrainDate(parameters:Array<String>?,action:TBICalendarAction) {
        guard action != TBICalendarAction.Back && parameters != nil  else {
            return
        }
        let trainSearchCondition = TrainManager.shareInstance.trainSearchConditionDraw()
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone?
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let date:Date = formatter.date(from:(parameters?[0])!)!
        if TrainManager.shareInstance.trainSearchConditionDraw().type == 2 {
            trainSearchCondition.returnDateFormat = (parameters?[0])!
            formatter.dateFormat = "YYYY-MM-dd"
            formatter.timeZone = NSTimeZone.local
            trainSearchCondition.returnDate = formatter.string(from: date)
        }else {
            
            trainSearchCondition.departureDateFormat = (parameters?[0])!
            formatter.dateFormat = "YYYY-MM-dd"
            formatter.timeZone = NSTimeZone.local
            trainSearchCondition.departDate = formatter.string(from:date)
        }
        
        TrainManager.shareInstance.trainSearchConditionStore(searchCondition: trainSearchCondition)
    }
    
    
    
    
    
    /// 初始化中间日期星期
    func initDateLabel(){
        if TrainManager.shareInstance.trainSearchConditionDraw().type == 2 {
            let date = DateInRegion(string: TrainManager.shareInstance.trainSearchConditionDraw().returnDate, format: .custom("YYYY-MM-dd"), fromRegion: regionRome)!
            headerView.dateView.dayLabel.text = date.string(custom: "EEE")
            let index = TrainManager.shareInstance.trainSearchConditionDraw().returnDate.index(TrainManager.shareInstance.trainSearchConditionDraw().returnDate.endIndex, offsetBy: -5)
            headerView.dateView.dayLabel.text = TrainManager.shareInstance.trainSearchConditionDraw().returnDate.substring(from: index) + " \(date.string(custom: "EEE"))"
        }else {
            let date = DateInRegion(string: TrainManager.shareInstance.trainSearchConditionDraw().departDate, format: .custom("YYYY-MM-dd"), fromRegion: regionRome)!
            headerView.dateView.dayLabel.text = date.string(custom: "EEE")
            let index = TrainManager.shareInstance.trainSearchConditionDraw().departDate.index(TrainManager.shareInstance.trainSearchConditionDraw().departDate.endIndex, offsetBy: -5)
    
            headerView.dateView.dayLabel.text = TrainManager.shareInstance.trainSearchConditionDraw().departDate.substring(from: index) + " \(date.string(custom: "EEE"))"
        }

    }
    //下一天
    func nextDateClick(tap:UITapGestureRecognizer){
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone?
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let searchCondition = TrainManager.shareInstance.trainSearchConditionDraw()
        if TrainManager.shareInstance.trainSearchConditionDraw().type == 2 {
            let date = formatter.date(from: searchCondition.returnDateFormat)!
            let returnDate = date + 1.day
            let compareComponent = returnDate.compare(to: (Date() + trainBookMax.day).startOfDay, granularity: Calendar.Component.day)
            if compareComponent != ComparisonResult.orderedAscending {
                showSystemAlertView(titleStr: "提示", message: "超出可预定日期,请重新选择!")
                return
            }
            
            searchCondition.returnDateFormat = formatter.string(from: returnDate)
            formatter.dateFormat = "YYYY-MM-dd"
            formatter.timeZone = NSTimeZone.local
            searchCondition.returnDate =  formatter.string(from: returnDate)

            
            
        }else {
            let date = formatter.date(from: searchCondition.departureDateFormat)!
            let departDate =  date + 1.day
            let compareComponent = departDate.compare(to: (Date() + trainBookMax.day).startOfDay, granularity: Calendar.Component.day)
            if compareComponent != ComparisonResult.orderedAscending {
                showSystemAlertView(titleStr: "提示", message: "超出可预定日期,请重新选择!")
                return
            }
            
            
            searchCondition.departureDateFormat = formatter.string(from: departDate)
            formatter.dateFormat = "YYYY-MM-dd"
            formatter.timeZone = NSTimeZone.local
            
            searchCondition.departDate = formatter.string(from: departDate)
        }
        TrainManager.shareInstance.trainSearchConditionStore(searchCondition: searchCondition)
        initDateLabel()
        updateData()
    }
    //上一天
    func beforeDateClick(tap:UITapGestureRecognizer){
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone?
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let searchCondition = TrainManager.shareInstance.trainSearchConditionDraw()
        
        let today = Date()
        if TrainManager.shareInstance.trainSearchConditionDraw().type == 2{
            
            let date = formatter.date(from: searchCondition.returnDateFormat)!
            //DateInRegion(string: searchCondition.returnDate, format: .custom("YYYY-MM-dd"), fromRegion: regionRome)!
            let returnDate = date - 1.day
            if today > date {
                self.alertView(title: "提示", message: "该日期此车不运行")
                return
            }
            searchCondition.returnDateFormat =  formatter.string(from: returnDate)
            formatter.dateFormat = "YYYY-MM-dd"
            formatter.timeZone = NSTimeZone.local
            
            searchCondition.returnDate = formatter.string(from: returnDate)
            
            
        }else {
            let date:Date = formatter.date(from: searchCondition.departureDateFormat)!
            let departureDate =  date - 1.day
            if today > date {
                self.alertView(title: "提示", message: "该日期此车不运行")
                return
            }
            searchCondition.departureDateFormat = formatter.string(from:departureDate)
            formatter.dateFormat = "YYYY-MM-dd"
            formatter.timeZone = NSTimeZone.local
            searchCondition.departDate =  formatter.string(from: departureDate)
        }
        TrainManager.shareInstance.trainSearchConditionStore(searchCondition: searchCondition)
        initDateLabel()
        updateData()
    }
    
    
    func updateData(){
        let travel = PassengerManager.shareInStance.passengerSVDraw().first
        weak var weakSelf = self
        if TrainManager.shareInstance.trainSearchConditionDraw().type == 2{
            self.showLoadingView()
            weak var weakSelf = self
            CoTrainService.sharedInstance.search(fromStation:TrainManager.shareInstance.trainSearchConditionDraw().toStation, toStation:  TrainManager.shareInstance.trainSearchConditionDraw().fromStation, travelDate: TrainManager.shareInstance.trainSearchConditionDraw().returnDate ,policy:travel?.policyId ?? "").subscribe{ event in
                self.hideLoadingView()
                switch event{
                case .next(let e):
                   // printDebugLog(message: e.mj_keyValues())
                    let model = e.trainAvailInfos.filter{$0.trainCode == weakSelf?.trainInfoModel.trainCode }.first
                    if model == nil {
                        weakSelf?.flag = 1
                        KeyWindow?.addSubview(CoNoTrainsView(frame: ScreenWindowFrame))
                    }else
                    {
                        weakSelf?.flag = 0
                        TrainManager.shareInstance.trainStartStationStore(from: model!)
                    }
                    
                    weakSelf?.initData()
                case .error(let e):
                    try? weakSelf?.validateHttp(e)
                case .completed:
                    break
                }
                }.addDisposableTo((weakSelf?.bag)!)

        }else {
            self.showLoadingView()
            CoTrainService.sharedInstance
                .search(fromStation: TrainManager.shareInstance.trainSearchConditionDraw().fromStation,
                        toStation: TrainManager.shareInstance.trainSearchConditionDraw().toStation,
                        travelDate: TrainManager.shareInstance.trainSearchConditionDraw().departDate,
                        policy:travel?.policyId ?? "")
                .subscribe{ event in
                    self.hideLoadingView()
                    switch event{
                    case .next(let e):
                        //printDebugLog(message: e.mj_keyValues())
                        let model = e.trainAvailInfos.filter{$0.trainCode == weakSelf?.trainInfoModel.trainCode }.first
                        if model == nil {
                            weakSelf?.flag = 1
                            KeyWindow?.addSubview(CoNoTrainsView(frame: ScreenWindowFrame))
                        }else
                        {
                            weakSelf?.flag = 0
                            TrainManager.shareInstance.trainStartStationStore(from: model!)
                        }
                        
                        weakSelf?.initData()
                    case .error(let e):
                        try? self.validateHttp(e)
                    case .completed:
                        break
                    }
            }.addDisposableTo(self.bag)
        }
    }
    
    
    func detailClick(tap:UITapGestureRecognizer){
          self.navigationController?.pushViewController(CoTrainSpecialNoteViewController(), animated: true)
    }
}
