//
//  CompanyHomeViewController.swift
//  shop
//
//  Created by SLMF on 2017/4/20.
//  Copyright © 2017年 zhangwangwang. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftDate

extension HomeViewController {
    
    func setCompanyHomeView() {
        self.view.addSubview(companyScrollView)
        self.setCompanyScrollBanner()
        self.setCompanyNoticeView()
        //self.setCompanyMainFuncView()
        //self.setCompanyHomeJourneyListView()
        
        
    }
}

//MARK: setCompanyHomeTripListView
extension HomeViewController {
    
//    func setCompanyHomeJourneyListView() {
//        let tableViewCount:Int = newtripSection+flightSection+hotelSection+approvalSection+trainSection+carSection
//        var height = 197.5 * CGFloat(data?.count ?? 0)
//        if tableViewCount <= 2 {
//            height +=  220
//            companyImg.image = UIImage.init(named: "enterpriseSlogan_12")
//            companyImg.frame = CGRect(x: 0, y: 0, width: ScreenWindowWidth, height: 170)
//        }else {
//            companyImg.image = UIImage.init(named: "enterpriseSlogan_34")
//            companyImg.frame = CGRect(x: 0, y: 0, width: ScreenWindowWidth, height: 130)
//            height +=  160
//        }
//
//        let companyHeight = 64 + companyCycleScrollView.bounds.size.height + companyNoticeView.bounds.size.height + 10 + companyMainTableView.bounds.size.height + 15 + height + 34
//
//        companyScrollView.contentSize = CGSize.init(width: 0, height: companyHeight)
//        companyScrollView.showsVerticalScrollIndicator = false
//
//        journeyTableView.snp.remakeConstraints { (make) in
//            make.left.right.equalToSuperview()
//            make.width.equalTo(ScreenWindowWidth)
//            make.top.equalTo(companyMainTableView.snp.bottom).offset(10)
//            make.height.equalTo(height)
//        }
//
//
//
//    }
}

//MARK: setCompanyMainFuncView
extension HomeViewController {
    
    
//    func setCompanyMainFuncView() {//TODO 出现过野指针异常
//        companyMainTableView.dataSource = self
//        companyMainTableView.delegate = self
//        companyMainTableView.register(CompanyHomeMainTableCellView.classForCoder(), forCellReuseIdentifier: companyHomeMainCellViewIdentify)
//        companyMainTableView.separatorStyle = .none
//        companyMainTableView.backgroundColor = TBIThemeBaseColor
//        companyMainTableView.isScrollEnabled = false
//        self.companyScrollView.addSubview(companyMainTableView)
//        companyMainTableView.snp.makeConstraints { (make) in
//            make.top.equalTo(self.companyNoticeView.snp.bottom).offset(10)
//            make.left.right.equalToSuperview()
//            make.width.equalTo(companyScrollView)
//            make.height.equalTo(Double(newtripSection+flightSection+hotelSection+approvalSection+trainSection+carSection)*84.5)
//        }
//
//        journeyTableView.dataSource = self
//        journeyTableView.delegate = self
//        journeyTableView.backgroundColor = TBIThemeBaseColor
//        journeyTableView.separatorStyle = .none
//        journeyTableView.isScrollEnabled = false
//        journeyTableView.register(MineHomeTableViewFooterView.classForCoder(), forHeaderFooterViewReuseIdentifier: mineHomeTableViewHeaderViewIdentify)
//        journeyTableView.register(JourneyTableViewCell.classForCoder(), forCellReuseIdentifier: journeyTableViewCellIdentify)
//        self.companyScrollView.addSubview(journeyTableView)
//
//        companyImg.frame = CGRect(x: 0, y: 0, width: ScreenWindowWidth, height: 130)
//        journeyTableView.tableFooterView =  companyImg
//
//        journeyTableView.snp.makeConstraints { (make) in
//            make.left.right.equalToSuperview()
//            make.width.equalTo(companyScrollView)
//            make.height.equalTo(0)
//            make.top.equalTo(companyMainTableView.snp.bottom).inset(10)
//        }
//
//
//    }
    
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView == companyMainTableView{
            return 0
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if tableView == companyMainTableView{
            return nil
        }
        let footerView:MineHomeTableViewFooterView = tableView.dequeueReusableHeaderFooterView(withIdentifier:  mineHomeTableViewHeaderViewIdentify) as! MineHomeTableViewFooterView
        return footerView
    
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == companyMainTableView{
            return 1
        }
        return data?.count ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == companyMainTableView{
            return  newtripSection+flightSection+hotelSection+approvalSection+trainSection+carSection
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == companyMainTableView{
            return 84.5
        }else {
            return 187.5
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == companyMainTableView{
            let cell: CompanyHomeMainTableCellView = tableView.dequeueReusableCell(withIdentifier: companyHomeMainCellViewIdentify) as! CompanyHomeMainTableCellView
            cell.selectionStyle = .none
            if flightSection != 0 && indexPath.row == 0 {
                cell.fillData(titleImageName: "Home_Business_Plane", titleStr: "机票", descStr: "FLIGHTS", focusImageStr: "Common_Forward_Arrow_Gray", row: indexPath.row)
            }
            if hotelSection != 0 && indexPath.row == 0 + flightSection {
                cell.fillData(titleImageName: "Home_Business_Hotel", titleStr: "酒店", descStr: "HOTELS", focusImageStr: "Common_Forward_Arrow_Gray", row: indexPath.row)
            }
            
            if trainSection != 0 && indexPath.row == 0 + flightSection + hotelSection{
                cell.fillData(titleImageName: "Home_Business_train", titleStr: "火车票", descStr: "TRAINS", focusImageStr: "Common_Forward_Arrow_Gray", row: indexPath.row)
            }
            
            if trainSection != 0 && indexPath.row == 0 + flightSection + hotelSection + trainSection{
                cell.fillData(titleImageName: "Home_Business_car", titleStr: "用车", descStr: "CARS", focusImageStr: "Common_Forward_Arrow_Gray", row: indexPath.row)
            }
        
            if approvalSection != 0 && indexPath.row == 0 + flightSection + hotelSection + trainSection + carSection{
                cell.fillData(titleImageName: "Home_Business_Approval", titleStr: "快速审批", descStr: "Fast travel approval", focusImageStr: "Common_Forward_Arrow_Gray", row: indexPath.row)
            }
            if newtripSection != 0 && indexPath.row == 0 + flightSection + hotelSection + approvalSection + trainSection + carSection{
                cell.fillData(titleImageName: "Home_Business_Newtrip", titleStr: "新建出差单", descStr: "Create new trip order",  focusImageStr: "Common_Forward_Arrow_Gray", row: indexPath.row)
            }
            
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.journeyTableViewCellIdentify) as! JourneyTableViewCell
            cell.selectionStyle = .none
            cell.fillCell(model: data?[indexPath.section])
            return cell
        }
        
    }
    
    //tabel点击事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == companyMainTableView {
            if flightSection != 0 && indexPath.row == 0 {
                choiceRoleViewNew(.Flight)
            
            }
            
            if hotelSection != 0 && indexPath.row == 0 + flightSection
            {
                choiceRoleViewNew(.Hotel)
                //sexClick()
            
            }
            
            if trainSection != 0 && indexPath.row == 0 + flightSection + hotelSection
            {
                choiceRoleViewNew(.Train)
            }
            
            if trainSection != 0 && indexPath.row == 0 + flightSection + trainSection + hotelSection
            {
                choiceRoleViewNew(.Car)
            }
            
            if approvalSection != 0 && indexPath.row == 0 + flightSection + hotelSection + trainSection + carSection
            {
                //判断用户类型来决定新老版
                guard let version = UserService.sharedInstance.userDetail()?.companyUser?.newVersion else {
                    return
                }
             if version {
                //订单控制器
                let allController = CoNewExaminesViewController()
                let tabAll = TabBarItem(text: "全部", controller: allController)
                
                let waitApprovalController = CoNewExaminesViewController()
                waitApprovalController.orderState = .waitApproval
                let tabWaitApproval = TabBarItem(text: "待审批", controller: waitApprovalController)
                
                let agreeController = CoNewExaminesViewController()
                agreeController.orderState = .agree
                let tabAgree = TabBarItem(text: "已通过", controller: agreeController)
                
                let rejectController = CoNewExaminesViewController()
                rejectController.orderState = .reject
                let tabReject = TabBarItem(text: "已拒绝", controller:rejectController)
                
                let tabs = [tabAll,tabWaitApproval,tabAgree,tabReject]
                let orderController = TabViewController()
                orderController.tabBarsItem = tabs
                orderController.companyHeader = false
                orderController.setTitle(titleStr: "订单审批")
                orderController.setNavigationBackButton(backImage: "back")
                self.navigationController?.pushViewController(orderController, animated: true)
            }else {
                //订单控制器
                let allController = CoOldExaminesViewController()
                let tabAll = TabBarItem(text: "全部", controller: allController)
                
                let waitApprovalController = CoOldExaminesViewController()
                waitApprovalController.orderState = .waitApproval
                let tabWaitApproval = TabBarItem(text: "待审批", controller: waitApprovalController)
                
                let agreeController = CoOldExaminesViewController()
                agreeController.orderState = .agree
                let tabAgree = TabBarItem(text: "已通过", controller: agreeController)
                
                let rejectController = CoOldExaminesViewController()
                rejectController.orderState = .reject
                let tabReject = TabBarItem(text: "已拒绝", controller:rejectController)
                
                let tabs = [tabAll,tabWaitApproval,tabAgree,tabReject]
                let orderController = TabViewController()
                orderController.tabBarsItem = tabs
                orderController.companyHeader = false
                orderController.setTitle(titleStr: "订单审批")
                orderController.setNavigationBackButton(backImage:"")
                self.navigationController?.pushViewController(orderController, animated: true)
                }
            
            }
            if newtripSection != 0 && indexPath.row == 0 + flightSection + hotelSection + approvalSection + trainSection + carSection{
                let details = UserDefaults.standard.string(forKey: USERINFO)
                if details != nil {
                    let jdetails = JSON(parseJSON: details!)
                    let traveller = Traveller(jsonData:jdetails["coUser"]["traveller"])
                    //searchTravellerResult.removeAll()
                    PassengerManager.shareInStance.passengerDeleteAll()
                    //searchTravellerResult.append(traveller)
                    PassengerManager.shareInStance.passengerAdd(passenger: traveller)
                }
                let vc = CoNewTravelNoViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if tableView == journeyTableView{
            let model = data?[indexPath.section]
            if model?.type == 1
            {
                var dataSource:[(String,String)] = []
                dataSource.append(("出行时间",model?.flight.departureDate.string(custom: "yyyy-MM-dd") ?? ""))
                let time = (model?.flight.departureDate.string(custom: "HH:mm") ?? "") + " - " + (model?.flight.arriveDate.string(custom: "HH:mm") ?? "")
                dataSource.append(("起飞时间",time))
                dataSource.append(("出发机场",model?.flight.departureAirport ?? ""))
                dataSource.append(("到达机场",model?.flight.arriveAirport ?? ""))
                dataSource.append(("航班信息",(model?.flight.companyName ?? "")+(model?.flight.flightNo ?? "")))
                //topTitle:头部的标题 ， bottomBtnTitle：底部按钮🔘的文字 ，
                //contentDataSource:[(String,String)] <---> [(左侧文字，右侧文字)]: 中间内容的数据
                //clickEnum:枚举 可取值：cancel-移除弹出框视图,btnClick-点击底部按钮
                let alertView = TBIAlertViewKeyValue.getNewInstance(topTitle: "机票行程", bottomBtnTitle: "联系客服", contentDataSource: dataSource){ clickEnum in
                    switch clickEnum {
                    case .cancel:
                        break
                    case .btnClick:
                        self.getHotLine(type: 1)
                    }
                }
                KeyWindow?.addSubview(alertView)
                
            }
             else if model?.type == 2
            {
                var dataSource:[(String,String)] = []
                dataSource.append(("到店日期",model?.hotel.arriveDate.string(custom: "yyyy-MM-dd") ?? ""))
                dataSource.append(("酒店名称",model?.hotel.hotelName ?? ""))
                dataSource.append(("房型名称",model?.hotel.roomName ?? ""))
                dataSource.append(("联系电话",model?.hotel.contactNumber ?? ""))
                dataSource.append(("酒店地址",model?.hotel.address ?? ""))
                //topTitle:头部的标题 ， bottomBtnTitle：底部按钮🔘的文字 ，
                //contentDataSource:[(String,String)] <---> [(左侧文字，右侧文字)]: 中间内容的数据
                //clickEnum:枚举 可取值：cancel-移除弹出框视图,btnClick-点击底部按钮
                let alertView = TBIAlertViewKeyValue.getNewInstance(topTitle: "酒店行程", bottomBtnTitle: "联系客服", contentDataSource: dataSource){ clickEnum in
                    switch clickEnum {
                    case .cancel:
                        break
                    case .btnClick:
                        self.getHotLine(type: 1)
                    }
                }
                KeyWindow?.addSubview(alertView)
            }
            else if model?.type == 3
            {
                var dataSource:[(String,String)] = []
                dataSource.append(("出行时间",model?.train.startTime.string(custom: "yyyy-MM-dd") ?? ""))
                let startTime = model?.train.startTime.string(custom: "HH:mm") ?? ""
                let endTime = model?.train.endTime.string(custom: "HH:mm") ?? ""
                dataSource.append(("发车时间","\(startTime)-\(endTime)"))
                dataSource.append(("出发车站",model?.train.fromStationNameCn ?? ""))
                dataSource.append(("到达车站",model?.train.toStationNameCn ?? ""))
                dataSource.append(("车次",model?.train.checi ?? ""))
                dataSource.append(("坐席",model?.train.siteCode ?? ""))
                let alertView = TBIAlertViewKeyValue.getNewInstance(topTitle: "火车票行程", bottomBtnTitle: "联系客服", contentDataSource: dataSource){ clickEnum in
                    switch clickEnum {
                    case .cancel:
                        break
                    case .btnClick:
                        self.getHotLine(type: 1)
                    }
                }
                KeyWindow?.addSubview(alertView)
            }
            else if model?.type == 4
            {
                var dataSource:[(String,String)] = []
                dataSource.append(("用车时间",model?.car.startTime.string(custom: "yyyy-MM-dd HH:mm") ?? ""))
                dataSource.append(("用车类型",model?.car.orderType.description ?? ""))
                dataSource.append(("出发地",model?.car.startAddress ?? ""))
                dataSource.append(("目的地",model?.car.endAddress ?? ""))
                dataSource.append(("司机姓名",model?.car.driverName ?? ""))
                dataSource.append(("司机手机号",model?.car.driverPhone ?? ""))
                dataSource.append(("车牌号",model?.car.driverNO ?? ""))
                let alertView = TBIAlertViewKeyValue.getNewInstance(topTitle: "专车行程", bottomBtnTitle: "联系客服", contentDataSource: dataSource){ clickEnum in
                    switch clickEnum {
                    case .cancel:
                        break
                    case .btnClick:
                        self.getHotLine(type: 1)
                    }
                }
                KeyWindow?.addSubview(alertView)
            }
        }
    }
    
    
    //下面弹出方法
    func choiceRoleViewNew(_ type: HotelCompanyStaffViewType) {
        let userDetail = UserService.sharedInstance.userDetail()
        if userDetail?.companyUser?.secretary ?? false{
            weak var weakSelf = self
            let titleArr:[String] = ["为自己预订","为他人或多人预订"]
            //ic_inbound tourism_blue
            //let flagArr:[String] = ["ic_inbound_tourism_blue","ic_overseas_travel_blue"]
            let roleView = TBIFinderView.init(frame: ScreenWindowFrame)
            roleView.rowHeight = 80
            roleView.fontSize = UIFont.systemFont(ofSize: 18)
            roleView.finderViewSelectedResultBlock = { (cellIndex) in
                weakSelf?.choiceRole(type ,index: cellIndex)
            }
            KeyWindow?.addSubview(roleView)
            roleView.reloadDataSources(titledataSources: titleArr, flageImage: nil)
        }else {
            forMinePlay(type)
        }
    }
    
    //为自己定 为他人定中转方法
    func choiceRole(_ type:HotelCompanyStaffViewType,index:NSInteger) {
        
        switch index {
        case 0:
          forMinePlay(type)
        case 1:
          forOtherPlay(type)
        default: break
            
        }
        
        
    }

    func forMinePlay(_ type: HotelCompanyStaffViewType) {
        let details = UserDefaults.standard.string(forKey: USERINFO)
        if details != nil {
            let jdetails = JSON(parseJSON: details!)
            let traveller = Traveller(jsonData:jdetails["coUser"]["traveller"])
            //searchTravellerResult.removeAll()
            PassengerManager.shareInStance.passengerDeleteAll()
            //searchTravellerResult.append(traveller)
            PassengerManager.shareInStance.passengerAdd(passenger:traveller)
        }
        if type == HotelCompanyStaffViewType.Flight{

//            let flightSearchViewController = FlightSearchViewController()
            let flightSVSearchViewController = FlightSVSearchViewController()
            //self.navigationController?.navigationBar.shadowImage = UIImage.init(named: "border")
            self.navigationController?.pushViewController(flightSVSearchViewController, animated: true)
        }else if type == HotelCompanyStaffViewType.Hotel{
            
            //personalDataSourcesArr = searchTravellerResult
            //searchCompanyView()
            hotelSVSearchCompanyView()
            
        }else if type == HotelCompanyStaffViewType.Train {
            let trainController = CoTrainSearchViewController()
            self.navigationController?.pushViewController(trainController, animated: true)
        }else if type == HotelCompanyStaffViewType.Car{
            let carController = CoCarSearchViewController()
            //self.present(carController, animated: true, completion: nil)
            self.navigationController?.pushViewController(carController, animated: true)
        }
        
        
    }

    //为他人预定  进入 选择乘客信息页面
    func forOtherPlay(_ type: HotelCompanyStaffViewType){
        //清除历史信息
//        if searchTravellerResult.count > 0 {
//            searchTravellerResult.removeAll()
            //personalDataSourcesArr.removeAll()
//        }
         _ = PassengerManager.shareInStance.passengerDeleteAll()
        
        
        let staffView = HotelCompanyStaffViewController()
        staffView.hotelCompanyStaffViewType = type
        self.navigationController?.pushViewController(staffView, animated: true)
        
    }
    
    // 进入企业搜索页面
    private func searchCompanyView() {
//        let searchCompanyView = HotelCompanySearchViewController()
//        searchCompanyView.travelNo = ""//订单号
//        self.navigationController?.pushViewController(searchCompanyView, animated: true)
    }
    
    // 进入企业搜索页面
    private func hotelSVSearchCompanyView() {
        let searchCompanyView = HotelSVCompanySearchViewController()
        searchCompanyView.travelNo = ""//订单号
        self.navigationController?.pushViewController(searchCompanyView, animated: true)
    }
    
    
    
    
}

//MARK: setCompanyNoticeView
extension HomeViewController {
    
    func setCompanyNoticeView() {
        let radView = UIView()
        radView.backgroundColor = .white
        radView.layer.cornerRadius = 10
        self.companyScrollView.addSubview(radView)
        radView.snp.makeConstraints{(make) in
            make.left.equalToSuperview()
            make.top.equalTo(self.companyCycleScrollView.snp.bottom).offset(-10)
            make.width.equalToSuperview()
            make.height.equalTo(20)
        }
//        self.companyScrollView.addSubview(companyNoticeView)
//        companyNoticeView.snp.makeConstraints { (make) in
//            make.top.equalTo(self.companyCycleScrollView.snp.bottom)
//            make.left.right.equalToSuperview()
//            make.width.equalToSuperview()
//            make.height.equalTo(48.5)
//        }
//        //公告 回调
//        companyNoticeView.companyHomeNoticeViewSelectedResult = { (selectedIndex,dataSources) in
//            //print("selcted ",selectedIndex,dataSources)
//            
//            let vc = CoAllNoticeListController()
//            vc.noticeList = dataSources
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
    }
    

    
    
}


//MARK: setCompanyScrollBanner
extension HomeViewController {
    
    func setCompanyScrollBanner() {
        self.companyScrollView.addSubview(companyCycleScrollView)
        companyCycleScrollView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(130)
            make.width.equalToSuperview()
        }
//        companyImageScrollView.setImages(initCompanyImagesNameArray())
//        companyImageScrollView.setButtonTouchUpInsideClosure { (index) in
//            print("图片\(index)")
//        }
    }
    
    func initCompanyImagesNameArray() -> Array<AnyObject>{
        var imagesNameArray: Array<AnyObject> = []
        //添加本地图片
        imagesNameArray.append("Home_Banner_1" as AnyObject)
        imagesNameArray.append("Home_Banner_2" as AnyObject)
        imagesNameArray.append("Home_Banner_3" as AnyObject)
        for index in 0..<(homeInfoModel?.pics_2.count ?? 0){
            imagesNameArray.append(homeInfoModel?.pics_2[index] as AnyObject)
        }
        return imagesNameArray
    }
}
