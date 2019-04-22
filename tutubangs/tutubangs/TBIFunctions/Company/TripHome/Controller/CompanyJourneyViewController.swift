//
//  CompanyJourneyViewController.swift
//  shop
//
//  Created by TBI on 2017/6/15.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import MJRefresh
import RxSwift
import SwiftDate

class CompanyJourneyViewController: CompanyBaseViewController {
    
    let titleView = HomeTitleView()
    
    let bag = DisposeBag()
    
    fileprivate var  journeyArr:PersonalJourneyListResponse = PersonalJourneyListResponse()
    
    //共用cell
    fileprivate let journeyTableViewCellIdentify = "journeyTableViewCellIdentify"
    
    //旅游cell
    fileprivate let journeyTravelTableViewCellIdentify = "journeyTravelTableViewCellIdentify"
    
    fileprivate let companyTableView = UITableView()
    
    fileprivate let personalTableView = UITableView()
    
    fileprivate var pageNo:NSInteger = 1
    
    
    var days = 30
    
    var data:[CompanyJourneyResult]?
    
    var personalData:[MyTripListResponse]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        //initPersonalTableView ()
        companyTableView.addLeftSlideListener(target: self, action:  #selector(tableActive(tap:)))
        //personalTableView.addRightSlideListener(target: self, action:  #selector(tableActive(tap:)))
        setNavigationController()
    }
    override func viewDidAppear(_ animated: Bool) {
        setNavigationController()
    }
    
    func setNavigationController() {
        self.setNavigationColor()
        self.navigationController?.navigationBar.isTranslucent = false
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(imageUrl:UserDefaults.standard.object(forKey:kMainHomeLogoUrl) as! String, target: self, action: #selector(leftItemClick(sender:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "ic_stroke_prompt", target: self, action: #selector(leftItemClick(sender:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "ic_phone_white", target: self, action: #selector(rightItemClick(sender:)))
        setTitleView()
    }
    
   
    func rightItemClick(sender:UIButton) {
        print("这是要打电话吗？")
        if PersonalType == true{
            UIApplication.shared.openURL(NSURL(string :"tel://"+DefHotLine)! as URL)
        }else{
            self.navigationController?.pushViewController(EnterpriseHotLineController(), animated: true)
        }
    }
    
    func leftItemClick(sender: UIBarButtonItem) {
        popNewAlertView(content:"行程中显示的是您个人或者公司秘书为您订妥的近期行程。如有问题请您及时与客服人员联系，我们将竭诚为您服务。",titleStr:"行程说明",btnTitle:"我知道了",imageName:"",nullStr:"")

    }
    
    func setTitleView() {
        //self.navigationItem.titleView = titleView
        setTitle(titleStr: "我的行程")
        active(sender: PersonalType ? titleView.personalButton :titleView.businessButton)
        titleView.businessButton.addTarget(self, action: #selector(active(sender:)), for: .touchUpInside)
        titleView.personalButton.addTarget(self, action: #selector(active(sender:)), for: .touchUpInside)
    }
    
    func tableActive(tap:UITapGestureRecognizer) {
        let view = tap.view as! UITableView
        switch view {
        case companyTableView://个人出行
            if islogin(role: personalLogin) {
                return
            }
            self.personalTableView.mj_header.beginRefreshing()
            titleView.businessButton.unActive()
            titleView.businessLabel.isHidden = true
            titleView.personalButton.active()
            titleView.personalLabel.isHidden = false
            PersonalType =  true
            personalTableView.isHidden = false
            companyTableView.isHidden = true
        case personalTableView://公务出行
            if islogin(role: companyLogin) {
                return
            }
            companyTableView.isHidden = false
            self.companyTableView.mj_header.beginRefreshing()
            titleView.businessButton.active()
            titleView.businessLabel.isHidden = false
            titleView.personalButton.unActive()
            titleView.personalLabel.isHidden = true
            companyTableView.isHidden = false
            personalTableView.isHidden = true
            PersonalType =  false
        default:
            break
        }
    }

    
    func active(sender: UIButton) {
        switch sender {
        case titleView.personalButton://个人出行
            if islogin(role: personalLogin) {
                return
            }
            personalTableView.isHidden = false
            companyTableView.isHidden = true
            self.personalTableView.mj_header.beginRefreshing()
            titleView.businessButton.unActive()
            titleView.businessLabel.isHidden = true
            titleView.personalButton.active()
            titleView.personalLabel.isHidden = false
            PersonalType =  true
            
        case titleView.businessButton://公务出行
            if islogin(role: companyLogin) {
                return
            }
            companyTableView.isHidden = false
            self.companyTableView.mj_header.beginRefreshing()
            titleView.businessButton.active()
            titleView.businessLabel.isHidden = false
            titleView.personalButton.unActive()
            titleView.personalLabel.isHidden = true
            personalTableView.isHidden = true
            PersonalType =  false
        default:
            break
        }
    }
}

extension CompanyJourneyViewController: UITableViewDelegate,UITableViewDataSource{
    
    func initTableView() {
        //scrollview加载高度不变
        automaticallyAdjustsScrollViewInsets = false
        companyTableView.dataSource = self
        companyTableView.delegate = self
        companyTableView.backgroundColor = TBIThemeBaseColor
        companyTableView.separatorStyle = .none
        companyTableView.register(MineHomeTableViewFooterView.classForCoder(), forHeaderFooterViewReuseIdentifier: mineHomeTableViewHeaderViewIdentify)
        companyTableView.register(JourneyTableViewCell.classForCoder(), forCellReuseIdentifier: journeyTableViewCellIdentify)
        companyTableView.register(JourneyTravelTableViewCell.classForCoder(), forCellReuseIdentifier: journeyTravelTableViewCellIdentify)
        companyTableView.register(UINib(nibName: "TableNoDateView", bundle: nil), forHeaderFooterViewReuseIdentifier: "TableNoDateView")
        self.view.addSubview(companyTableView)
        companyTableView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        weak var weakSelf = self
        //监听下拉刷新 上啦加载
        companyTableView.mj_header = MJRefreshNormalHeader{
            weakSelf?.pageNo = 1
            weakSelf?.getTrip(isRefresh: true, pageNo: (weakSelf?.pageNo)!)
        }
        //初始化上拉加载
        companyTableView.mj_footer = MJRefreshAutoNormalFooter{
            weakSelf?.getTrip(isRefresh: false, pageNo: (weakSelf?.pageNo)!)
        }
        //在开始隐藏上啦加载更多
        companyTableView.mj_footer.isHidden = true
        
    }
    
    
    
    func getTrip(isRefresh:Bool,pageNo:NSInteger)  {
        self.showLoadingView()
        weak var weakSelf = self
        let page:NSNumber = NSNumber.init(value: pageNo)
        MyTirpService.sharedInstance.getUserTrip(pageNo: page.stringValue)
            .subscribe{ event in
            weakSelf?.hideLoadingView()
            switch event{
            case .next(let e):
                weakSelf?.pageNo += 1
                if isRefresh == true {
                    weakSelf?.journeyArr = e
                    weakSelf?.companyTableView.mj_header.endRefreshing()
                    weakSelf?.companyTableView.mj_footer.isHidden = self.data?.count == 0
                }else {
                    if e.count == 0 {
                        weakSelf?.companyTableView.mj_footer.endRefreshingWithNoMoreData()
                    }else {
                        weakSelf?.companyTableView.mj_footer.endRefreshing()
                        weakSelf?.journeyArr.journeyInfos.append(contentsOf: e.journeyInfos)
                    }
                }
                weakSelf?.companyTableView.reloadData()
            case .error(let e):
                self.companyTableView.mj_footer.endRefreshing()
                try? self.validateHttp(e)
            case .completed:
                break
            }
            }.addDisposableTo(self.bag)
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        if journeyArr.journeyInfos.count == 0 {
//                return 1
//            }else {
//                return journeyArr.journeyInfos.count
//            }
//    }
//
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if journeyArr.journeyInfos.count == 0 || data == nil{
//            return 0
//        }
        return journeyArr.journeyInfos.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
       
        if journeyArr.journeyInfos.count == 0 {
            return tableView.frame.height
        }
        return 10
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if journeyArr.journeyInfos.count == 0 {
            if let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableNoDateView") as? TableNoDateView {
                footer.setType(.noTrip)
                return footer
            }
        }
        let footerView:MineHomeTableViewFooterView = tableView.dequeueReusableHeaderFooterView(withIdentifier: mineHomeTableViewHeaderViewIdentify) as! MineHomeTableViewFooterView
        return footerView
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: journeyTableViewCellIdentify) as! JourneyTableViewCell
        cell.selectionStyle = .none
       cell.fillDataSources(model: journeyArr.journeyInfos[indexPath.row])
        // cell.fillCell(model: journeyArr.journeyInfos[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var number = 1
        if (journeyArr.journeyInfos[indexPath.row].type == 4) {
            number = 2
        }
        return CGFloat(188.5 + Double(15 * number) - 9.0)
    }
    //点击事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = journeyArr.journeyInfos[indexPath.row]
        if model.type == 1
        {
            
            let departureDate:Date = Date.init(timeIntervalSince1970: TimeInterval((model.airInfo?.departureDate)!))
            let arriveDate:Date = Date.init(timeIntervalSince1970: TimeInterval((model.airInfo?.arriveDate)!))
                var dataSource:[(String,String)] = []
            dataSource.append(("出行时间",departureDate.string(custom: "yyyy-MM-dd") ))
            let time = (departureDate.string(custom: "HH:mm") ) + " - " + (arriveDate.string(custom: "HH:mm"))
                dataSource.append(("起飞时间",time))
            dataSource.append(("出发机场",model.airInfo?.departureAirport ?? ""))
                dataSource.append(("到达机场",model.airInfo?.arriveAirport ?? ""))
                dataSource.append(("航班信息",(model.airInfo?.companyName ?? "")+(model.airInfo?.flightNo ?? "")))
                self.alertInfo(dataSource:dataSource,title:"机票行程")
                
            }
            else if model.type == 2
            {
                let arriveDate:Date = Date.init(timeIntervalSince1970: TimeInterval((model.hotelInfo?.arriveDate)!))
                let leaveDate:Date = Date.init(timeIntervalSince1970: TimeInterval((model.hotelInfo?.leaveDate)!))
                var dataSource:[(String,String)] = []
                dataSource.append(("到店日期",arriveDate.string(custom: "yyyy-MM-dd") ))
                dataSource.append(("酒店名称",model.hotelInfo?.hotelName ?? ""))
                dataSource.append(("房型名称",model.hotelInfo?.roomName ?? ""))
                dataSource.append(("联系电话",model.hotelInfo?.contactNumber ?? ""))
                dataSource.append(("酒店地址",model.hotelInfo?.address ?? ""))
                self.alertInfo(dataSource:dataSource,title:"酒店行程")
            }
            else if model.type == 3
            {
                
                let startDate:Date = Date.init(timeIntervalSince1970: TimeInterval((model.trainInfo?.startTime)!))
                let endDate:Date = Date.init(timeIntervalSince1970: TimeInterval((model.trainInfo?.endTime)!))
                var dataSource:[(String,String)] = []
                dataSource.append(("出行时间",startDate.string(custom: "yyyy-MM-dd") ))
                let startTime = startDate.string(custom: "HH:mm")
                let endTime = endDate.string(custom: "HH:mm")
                dataSource.append(("发车时间","\(startTime)-\(endTime)"))
                dataSource.append(("出发车站",model.trainInfo?.fromStationNameCn ?? ""))
                dataSource.append(("到达车站",model.trainInfo?.toStationNameCn ?? ""))
                dataSource.append(("车次",model.trainInfo?.checi ?? ""))
                dataSource.append(("坐席",model.trainInfo?.siteInfo ?? ""))
                self.alertInfo(dataSource:dataSource,title:"火车票行程")
            }
            else if model.type == 4
            {
                   let startTime:Date = Date.init(timeIntervalSince1970: TimeInterval((model.carInfo?.startTime)!))
                var dataSource:[(String,String)] = []
                dataSource.append(("用车时间",startTime.string(custom: "yyyy-MM-dd HH:mm") ))
                var orderTypeStr:String = "" //用车类型：1.接机；2.送机；3.预约用车
                switch model.carInfo?.orderType {
                case 1?:
                    orderTypeStr = "接机"
                case 2?:
                    orderTypeStr = "送机"
                case 99?:
                    orderTypeStr = "预约用车"
                default:
                    break
                }
                dataSource.append(("用车类型",orderTypeStr))
                dataSource.append(("出发地",model.carInfo?.startAddress ?? ""))
                dataSource.append(("目的地",model.carInfo?.endAddress ?? ""))
                dataSource.append(("司机姓名",model.carInfo?.driverName ?? ""))
                dataSource.append(("司机手机号",model.carInfo?.driverPhone ?? ""))
                dataSource.append(("车牌号",model.carInfo?.driverNO ?? ""))
                self.alertInfo(dataSource:dataSource,title:"专车行程")
            }
    }
    
    /// 显示详情
    ///
    /// - Parameter dataSource: 详情数据
    func alertInfo(dataSource:[(String,String)],title:String){
        //topTitle:头部的标题 ， bottomBtnTitle：底部按钮🔘的文字 ，
        //contentDataSource:[(String,String)] <---> [(左侧文字，右侧文字)]: 中间内容的数据
        //clickEnum:枚举 可取值：cancel-移除弹出框视图,btnClick-点击底部按钮
        let alertView = TBIAlertViewKeyValue.getNewInstance(topTitle: title, bottomBtnTitle: "联系客服", contentDataSource: dataSource){ clickEnum in
            switch clickEnum {
            case .cancel:
                break
            case .btnClick:
                self.getHotLine(type: 0)
            }
        }
        KeyWindow?.addSubview(alertView)
    }
}
