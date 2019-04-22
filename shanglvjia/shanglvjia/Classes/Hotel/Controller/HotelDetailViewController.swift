//
//  HotelDetailViewController.swift
//  shop
//
//  Created by manman on 2017/4/22.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import RxSwift
import SwiftyJSON



class HotelDetailViewController: CompanyBaseViewController,UITableViewDelegate,UITableViewDataSource{
    
    private let hotelDetailTableViewHeaderViewIdentify = "hotelDetailTableViewHeaderViewIdentify"
    
    private let hotelDetailTableViewCellIdentify = "hotelDetailTableViewCellIdentify"
    // 企业差标
    public var accordTravel:Float = 0
    //订单跳转 本页面标志
    public var travelNo:String = ""
    public var fromWhere:String = ""
    public var checkinDateStr:String = String()
    public var checkoutDateStr:String = String()
    public var hotelDetailForm:HotelDetailForm = HotelDetailForm()
    public var searchCondition:HotelSearchForm = HotelSearchForm()
    private var hotelDetail:OHotel = OHotel()
    private var tableViewDataSources:[RoomModel] = Array()
    let bag = DisposeBag()
    private var tableView = UITableView()
    private var noHotelRoomView:UIView = UIView()
    public var roomDetailRequest:HotelRoomDetailRequest = HotelRoomDetailRequest()
    
    private var hotelSVDetail:HotelDetailResult = HotelDetailResult()
    
    private var tableViewSVDataSources:[HotelDetailResult.HotelRoomPlan] = Array()
    
    /// 违反差标是否可以购买
    var anOrder:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //setTitle(titleStr: "酒店查询")
//        setTitle(titleStr: self.title!)
//        setNavigationBackButton(backImage: "")
        setBlackTitleAndNavigationColor(title:self.title!)
        
        self.view.backgroundColor = TBIThemeBaseColor
        setUIViewAutolayout()
        
//        if fromWhere == ""
//        {
//            getHotelDetailFromNetwork()
//        }else
//        {
//            getHotelCompanyDetailFromNetwork()
//        }
        getHotelDetail()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationBgColor(color:TBIThemeWhite)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- 定制视图
    
    func setUIViewAutolayout() {
        
        noHotelRoomView.frame = CGRect.init(x: 0, y:261, width: noHotelRoomView.frame.width, height:noHotelRoomView.frame.height - 261)
        let  subHotelRoomView:UIView = UIView.init(frame:CGRect.init(x: 0, y:261, width: ScreenWindowWidth, height:ScreentWindowHeight - 261))
        //subHotelRoomView.backgroundColor = UIColor.green
        noHotelRoomView.addSubview(subHotelRoomView)
        //noHotelRoomView.backgroundColor = UIColor.red
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = TBIThemeBaseColor
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.register(HotelDetailTableViewCell.classForCoder(), forCellReuseIdentifier: hotelDetailTableViewCellIdentify)
        tableView.register(HotelDetailTableViewHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: hotelDetailTableViewHeaderViewIdentify)
        tableView.backgroundView = noHotelRoomView
        let noHotelImge =  UIImageView.init(imageName: "ic_no_hotel_secondVersion")
        subHotelRoomView.addSubview(noHotelImge)
        noHotelImge.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(150)
            make.width.equalTo(172)
        }
        
        noHotelRoomView.isHidden = true
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(1)
        }
    }
    
    //MARK:- UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if self.hotelDetail.oHotel?.hotelRooms != nil {
//            return (self.hotelDetail.oHotel?.hotelRooms?.count)!
//        }

        //更换新数据 华美
        
        if tableViewSVDataSources.count > 0
        {
            return tableViewSVDataSources.count
        }
//
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:HotelDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: hotelDetailTableViewCellIdentify) as! HotelDetailTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.fillDataSources(roomDetail: self.tableViewSVDataSources[indexPath.row], accordTravel: accordTravel)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44 * 4 + 75 + 10 + 10
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView:HotelDetailTableViewHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: hotelDetailTableViewHeaderViewIdentify) as! HotelDetailTableViewHeaderView
            headerView.fillDataSources(hotelDetail: hotelSVDetail.hotelDetailInfo)
        weak var weakSelf = self
        headerView.hotelDetailHeaderViewMoreBlock = { () in
            
            weakSelf?.hotelDetailHeaderViewMoreAction()
            
        }
        headerView.hotelDetailHeaderViewAddressDetailBlock = { _ in
            weakSelf?.showHotelInMap()
        }
        
        return headerView
        
    }
    
    
    
    //MARK:- UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 95
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        printDebugLog(message: "didSelectRow ")
        intoNextReserveRoomNew(selectedCell:indexPath.row)
    }
    
    private func intoNextReserveRoomNew(selectedCell:NSInteger)
    {
        /// 如果违背差标 且违背差标不可以购买
        if (tableViewSVDataSources[selectedCell].ratePlanInfo.rate ) > accordTravel && tableViewSVDataSources[selectedCell].ratePlanInfo.canBook == "0" {
            return
        }
        if self.tableViewSVDataSources[selectedCell].ratePlanInfo.status == false {
            return
        }
//        guard islogin() == true else {
//            return
//        }
        
        let  reserveCompanyRoomView = ReserveCompanyRoomViewController()
        reserveCompanyRoomView.title = hotelSVDetail.hotelDetailInfo.hotelName//self.hotelDetail.oHotel?.detail?.name
        reserveCompanyRoomView.accordTravel = accordTravel//self.accordTravel
        reserveCompanyRoomView.searchSVCondition = HotelManager.shareInstance.searchConditionUserDraw()
        reserveCompanyRoomView.hotelSVDetail = hotelSVDetail.hotelDetailInfo
        reserveCompanyRoomView.roomSelected = self.tableViewSVDataSources[selectedCell]
        reserveCompanyRoomView.roomSelected.hotelName = hotelSVDetail.hotelDetailInfo.hotelName
        //reserveCompanyRoomView.hotelRoomDetail = (self.hotelDetail.oHotel?.hotelRooms?[selectedCell])!
        //reserveCompanyRoomView.travelNo = self.travelNo
        self.navigationController?.pushViewController(reserveCompanyRoomView, animated: true)
        return
        
        
        
        
        if fromWhere == "" {
            let reserveRoomView = ReserveRoomViewController()
            reserveRoomView.title = hotelSVDetail.hotelDetailInfo.hotelName//self.hotelDetail.oHotel?.detail?.name
            reserveRoomView.hotelDetailForm = self.hotelDetailForm
            //reserveRoomView.hotelRoomDetail = (self.hotelDetail.oHotel?.hotelRooms?[selectedCell])!
            reserveRoomView.roomModel = self.tableViewDataSources[selectedCell]
            reserveRoomView.searchCondition = self.searchCondition
            self.navigationController?.pushViewController(reserveRoomView, animated: true)
        }else
        {
            
            
            let  reserveCompanyRoomView = ReserveCompanyRoomViewController()
            reserveCompanyRoomView.title = self.hotelDetail.oHotel?.detail?.name
            reserveCompanyRoomView.accordTravel = self.accordTravel
            reserveCompanyRoomView.hotelDetailForm = self.hotelDetailForm
            reserveCompanyRoomView.searchCondition = self.searchCondition
            reserveCompanyRoomView.roomModel = self.tableViewDataSources[selectedCell]
            //reserveCompanyRoomView.hotelRoomDetail = (self.hotelDetail.oHotel?.hotelRooms?[selectedCell])!
            reserveCompanyRoomView.travelNo = self.travelNo
            self.navigationController?.pushViewController(reserveCompanyRoomView, animated: true)
        }
        
        
    }
    
    
    // MARK:-  获得网络 数据
    
    func getHotelDetail() {
        showLoadingView()
        weak var weakSelf = self
        HotelService.sharedInstance
            .getHotelDetail(request:roomDetailRequest)
            .subscribe{ event in
                weakSelf?.hideLoadingView()
                switch event {
                case .next(let element):
                    printDebugLog(message: element.mj_keyValues())
                    weakSelf?.hotelSVDetail = element
                    weakSelf?.matchHotelRoomPlan(roomDetail: element.hotelRoomInfoList)
                    if weakSelf?.tableViewSVDataSources.count == 0
                    {
                        weakSelf?.noHotelRoomView.isHidden = false
                    }else
                    {
                        weakSelf?.noHotelRoomView.isHidden = true
                    }
                    weakSelf?.tableView.reloadData()
                case .error(let error):
                    try? weakSelf?.validateHttp(error)
                case .completed:
                    break
                }
            }.disposed(by: bag)
    }
    
    
    // 个人的
    func getHotelDetailFromNetwork()  {
        
        showLoadingView()
        weak var weakSelf = self
        HotelService.sharedInstance
            .getDetail(hotelDetailForm)
            .subscribe{ event in
                weakSelf?.hideLoadingView()
                if case .next(let result) = event {
                    
                    weakSelf?.hotelDetail = result
                    weakSelf?.matchRoomModel(dataSource: result)
                    if weakSelf?.tableViewDataSources.count == 0
                    {
                        weakSelf?.noHotelRoomView.isHidden = false
                    }else
                    {
                        weakSelf?.noHotelRoomView.isHidden = true
                    }
                    weakSelf?.tableView.reloadData()
                   
                }
                if case .error(let result) = event {
                    try? weakSelf?.validateHttp(result)
                    //weakSelf?.showSystemAlertView(titleStr: "提示", message: String(describing: result))
                }
                
            }.disposed(by: bag)
    }
    
    func getHotelCompanyDetailFromNetwork() {
        showLoadingView()
        weak var weakSelf = self
        HotelCompanyService.sharedInstance
            .getDetail(hotelDetailForm)
            .subscribe{ event in
                weakSelf?.hideLoadingView()
                if case .next(let result) = event {
                    
                    weakSelf?.hotelDetail = result
                    self.matchRoomModel(dataSource: result)
                    if weakSelf?.tableViewDataSources.count == 0
                    {
                        weakSelf?.noHotelRoomView.isHidden = false
                    }else
                    {
                        weakSelf?.noHotelRoomView.isHidden = true
                    }
                    weakSelf?.tableView.reloadData()
                    
                    print(result)
                    
                }
                if case .error(let result) = event {
                    print(result)
                    try? weakSelf?.validateHttp(result)
                       //weakSelf?.showSystemAlertView(titleStr: "提示", message: String(describing: result))
                }
                
            }.disposed(by: bag)
    }
    
    
    func matchRoomModel(dataSource:OHotel) {
        
        for  hotelRoom:HotelDetail.HotelRoom in (dataSource.oHotel?.hotelRooms)!
        {
            
            for plans:HotelDetail.OHotelRatePlan in hotelRoom.oHotelRatePlans! {
                let roomModel:RoomModel =  RoomModel()
                roomModel.hotelId = (dataSource.oHotel?.hotelId)!
                roomModel.roomId = hotelRoom.roomId!
                roomModel.roomName = hotelRoom.roomName!
                if hotelRoom.imgUrl != nil {
                    roomModel.imgUrl = hotelRoom.imgUrl!
                }
                if hotelRoom.imgBigUrl != nil {
                    roomModel.imgBigUrl = hotelRoom.imgBigUrl!
                }
                roomModel.ratePlanId = plans.ratePlanId!
                roomModel.ratePlanName = plans.ratePlanName
                roomModel.status = plans.status!
                roomModel.totalRate = plans.totalRate!
                roomModel.averageRate = plans.averageRate!
                roomModel.roomTypeId = plans.roomTypeId
                roomModel.bedType = hotelRoom.bedType!
                roomModel.oHotelNightlyRatesMap = plans.oHotelNightlyRatesMap
                if plans.oHotelGuaranteeRuleList != nil && (plans.oHotelGuaranteeRuleList?.count)! > 0 {
                    
                    roomModel.startTime = (plans.oHotelGuaranteeRuleList?.first?.startTime)!
                    roomModel.guaranteeRuleDescription = (plans.oHotelGuaranteeRuleList?.first?.description)!
                    roomModel.guranteeRuleId = plans.oHotelGuaranteeRuleList?.first?.guranteeRuleId
                    roomModel.timeGuarantee = plans.oHotelGuaranteeRuleList?.first?.timeGuarantee
                    roomModel.amountGuarantee = plans.oHotelGuaranteeRuleList?.first?.amountGuarantee
                    roomModel.amount = plans.oHotelGuaranteeRuleList?.first?.amount
                    
                }
                tableViewDataSources.append(roomModel)
            }
            
        }
        
    }
    
    func matchHotelRoomPlan(roomDetail:[HotelDetailResult.HotelRoomInfo]) {
        let userInfo = DBManager.shareInstance.userDetailDraw()
        
        for roomInfo in roomDetail {
            for roomPlan in roomInfo.ratePlanInfoList {
                let hotelRoomPlan:HotelDetailResult.HotelRoomPlan = HotelDetailResult.HotelRoomPlan()
                hotelRoomPlan.bedType = roomInfo.bedType
                hotelRoomPlan.capacity = roomInfo.capacity
                hotelRoomPlan.hotelElongId = roomInfo.hotelElongId
                hotelRoomPlan.cover = roomInfo.cover
                hotelRoomPlan.coverBig = roomInfo.coverBig
                hotelRoomPlan.roomElongId = roomInfo.roomElongId
                //hotelRoomPlan.hotelOwnId = roomInfo.
                hotelRoomPlan.roomTypeName = roomInfo.roomTypeName
                hotelRoomPlan.ratePlanInfo = roomPlan
                hotelRoomPlan.ratePlanInfo.canBook = userInfo?.busLoginInfo.userBaseInfo.canOrder ?? "0"
                tableViewSVDataSources.append(hotelRoomPlan)
            }
        }
        
      
    }
    
    //MARK:- Action
    
    func hotelDetailHeaderViewMoreAction() {
        
        let summaryView = HotelSummaryViewController()
        summaryView.hotelName =  hotelSVDetail.hotelDetailInfo.hotelName //(hotelDetail.oHotel?.detail?.name)!
        summaryView.hotelDescription = hotelSVDetail.hotelDetailInfo.hotelDesc//hotelDetail.oHotel?.detail?.description
        summaryView.hotelTraffic =  hotelSVDetail.hotelDetailInfo.trafficInfo
        summaryView.generalAmenities = hotelSVDetail.hotelDetailInfo.facilitiesV2List.toString()//(hotelDetail.oHotel?.detail?.generalAmenities)!
        self.navigationController?.pushViewController(summaryView, animated: true)
        
        
    }
    
    func showHotelInMap() {
        guard hotelSVDetail.hotelDetailInfo.latitude.isEmpty == false &&
            hotelSVDetail.hotelDetailInfo.longitude.isEmpty == false else {
            return
        }
        let mapNavigation = HotelMapNavigationViewController()
        mapNavigation.hotelDetailResult = hotelSVDetail
        self.navigationController?.pushViewController(mapNavigation, animated: true)
    }
    
    
    
    
    func logoutButtonAction(sender:UIButton) {
        
        printDebugLog(message: "logoutButtonAction ...")
        let companyAccountView = CompanyAccountViewController()
        companyAccountView.title = "企业账号登录"
        self.navigationController?.pushViewController(companyAccountView, animated: true)
//        let loginView = LoginViewController()
//        self.navigationController?.pushViewController(loginView, animated: true)
    }
    
    
    
    
    
    
    override func backButtonAction(sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
