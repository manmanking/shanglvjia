//
//  PSpecialOfferFlightViewController.swift
//  shanglvjia
//
//  Created by manman on 2018/7/27.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import MJRefresh
import RxSwift

class PSpecialOfferFlightViewController: PersonalBaseViewController {
    
    fileprivate let bag = DisposeBag()
    
    
    fileprivate var page : Int = 1
    
    /// 0 国内 1 国际
    fileprivate var nationString:String = "0"
    
    fileprivate var flightTripNationType:PersonalFlightTripNationTypeEnum = PersonalFlightTripNationTypeEnum.Mainland
    
    // A 定投 F 特惠
    //fileprivate var flightTripOnsaleORSpecialType:String = "A"
    
    fileprivate var flightTripOnsaleORSpecialType = PersonalFlightTripSpecialOrOnSaleTypeEnum.PersonalFlight_SpecialType
    
    
    fileprivate var companyCode:String = ""
    
    fileprivate var listTableView:UITableView = UITableView()
    
    fileprivate var headView:PSepcialFlightListHeaderView = PSepcialFlightListHeaderView()
    
    fileprivate var listArray:[PSpecialFlightListModel.BaseFlightProductListVo] = Array()
    
    override func viewWillAppear(_ animated: Bool) {
        initNavigation(title:"",bgColor:TBIThemeBlueColor,alpha:0,isTranslucent:true)
        setNavigationBackButton(backImage: "BackCircle")
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        //重置已选航班信息
        PersonalSpecialFlightManager.shareInStance.resetAllFlightInfo()
        listTableView.mj_header.beginRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = TBIThemeBaseColor
        setUIViewAutolayout()
    }
    
    func setUIViewAutolayout()
    {
        setHeaderViewAutolayout()
        setTableViewAutolayout()
 
    }
    
    func setHeaderViewAutolayout() {
        //headView.frame = CGRect(x:0,y:0,width:ScreenWindowWidth,height:224)
        self.view.addSubview(headView)
        headView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(276) // + 224
        }
        weak var weakSelf = self
        headView.specialOrOfferBlock = { (selectedFlightTripNationType) in
            weakSelf?.flightTripNationType = selectedFlightTripNationType
            weakSelf?.companyCode = ""
            weakSelf?.SpecialOfferFlightNet()
        }
        
        headView.specialFlightListHeaderViewSelectedFlightCompanyBlock = { selectedFlightCompany in
            weakSelf?.companyCode = selectedFlightCompany.companyCode
            weakSelf?.SpecialOfferFlightNet()
        
        }
    }
    
    
    func updateHeaderView(type:PersonalFlightTripNationTypeEnum) {
        var height:NSInteger = 276
        headView.snp.updateConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(height) // + 224
        }
    }
    
    
    func setTableViewAutolayout() {
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.backgroundColor = TBIThemeBaseColor
        listTableView.separatorStyle = .none
        //listTableView.tableHeaderView = headView
        listTableView.register(PSepcialFlightListCell.self, forCellReuseIdentifier: "PSepcialFlightListCell")
        listTableView.register(UINib(nibName: "TableNoDateView", bundle: nil), forHeaderFooterViewReuseIdentifier: "TableNoDateView")
        self.view.addSubview( listTableView)
        listTableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(headView.snp.bottom)
        }
        //监听下拉刷新 上啦加载
        listTableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(PSpecialOfferFlightViewController.initData))
        //        listTableView.mj_header.beginRefreshing()
        listTableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(PSpecialOfferFlightViewController.loadMoreData))
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func backButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func initData(){
        page = 1
        SpecialOfferFlightNet(pageNo:page )
    }
    func loadMoreData(){
        page  = page + 1
        SpecialOfferFlightNet(pageNo:page )
    }
    
    
    enum  PersonalFlightTripNationTypeEnum:NSInteger {
        case Mainland = 0
        case International = 1
    }
    
    enum PersonalFlightTripSpecialOrOnSaleTypeEnum:String {
        case PersonalFlight_SpecialType = "A" // 定投
        case PersonalFlight_OnsaleType = "F" //特价
    }
    
    
    
    

}
extension PSpecialOfferFlightViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if flightTripOnsaleORSpecialType == .PersonalFlight_SpecialType {
            return 92
        }
        return 75
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if (listArray.count ) == 0 {
            return tableView.frame.height
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if (listArray.count ) == 0 {
            if let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableNoDateView") as? TableNoDateView {
                footer.setType(.noPersonal)
                footer.messageLabel.text="当前条件下暂未查询到机票"
                return footer
            }
        }
        return nil
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PSepcialFlightListCell  = tableView.dequeueReusableCell(withIdentifier: "PSepcialFlightListCell") as! PSepcialFlightListCell
        cell.fillCellData(model:listArray[indexPath.row])
        if flightTripOnsaleORSpecialType == .PersonalFlight_SpecialType && listArray[indexPath.row].productType == "F" {
            cell.lowImage.isHidden = false
            
        }else{
             cell.lowImage.isHidden = true
        }
        
        if flightTripOnsaleORSpecialType == .PersonalFlight_SpecialType {
            cell.codeImage.snp.remakeConstraints { (make) in
                make.left.equalTo(15)
                make.centerY.equalToSuperview().offset(-15)
                make.height.width.equalTo(19)
            }
        }else{
            cell.codeImage.snp.remakeConstraints { (make) in
                make.left.equalTo(5)
                make.centerY.equalToSuperview().offset(-15)
                make.height.equalTo(19)
                make.width.equalTo(0)
            }
        }
        return cell

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
//        let date = Date()
//        let timeFormatter = DateFormatter()
//        timeFormatter.dateFormat = "yyyy-MM-dd"
        let strNowTime =  Date().string(custom: "yyyy-MM-dd")
        let model:PSpecialFlightListModel.BaseFlightProductListVo = listArray[indexPath.row]
        //// A 定投 F 特惠
        if model.productType == PersonalFlightTripSpecialOrOnSaleTypeEnum.PersonalFlight_SpecialType.rawValue {
            
            if strNowTime < model.saleStartTime
            {
                showSystemAlertView(titleStr: "提示", message: "还未开售")
                return
            }
            let listVC:PSepcialFlightListViewController = PSepcialFlightListViewController()
            listVC.remainTicket = model.stock
            listVC.productId = model.id
            listVC.type = nationString
            listVC.nationString = PersonalFlightTripNationTypeEnum.init(rawValue:NSInteger(model.flightType ?? "0")!)!  //nationString
            listVC.specialString = flightTripOnsaleORSpecialType.rawValue//"A"//specialString
            listVC.arriveCity = model.destination
            listVC.startCity = model.departure
            listVC.flightTrip = (model.tripType.isEmpty ? "0" : model.tripType)
            self.navigationController?.pushViewController(listVC, animated: true)
        }else{
            //let model:PSpecialFlightListModel.BaseFlightProductListVo = listArray[indexPath.row]
            if strNowTime < model.saleStartTime
            {
                showSystemAlertView(titleStr: "提示", message: "还未开售")
                return
            }
            let listVC:POnsaleFlightListViewController = POnsaleFlightListViewController()
            listVC.productId = model.id
            listVC.type = model.flightType
            listVC.nationString = PersonalFlightTripNationTypeEnum.init(rawValue:NSInteger(model.flightType ?? "0")!)!
            listVC.specialString = flightTripOnsaleORSpecialType.rawValue//"F"//specialString
            listVC.arriveCity = model.destination
            listVC.startCity = model.departure
            listVC.flightTrip = (model.tripType.isEmpty ? "0" : model.tripType)
            self.navigationController?.pushViewController(listVC, animated: true)
            
        }
       
    }


    func SpecialOfferFlightNet(pageNo:Int = 1){
        if pageNo != 1{
            showLoadingView()
        }        
//
         weak var weakSelf = self
        let request:[String:Any] = ["num":pageNo,"size":"10","companyCode":companyCode,"flightType":flightTripNationType.rawValue.description,"startCount":"0"]
        PersonalFlightServices.sharedInstance
            .sepcialPersonalFlightList(request: request)
            .subscribe{ event in
            weakSelf?.hideLoadingView()
            weakSelf?.listTableView.mj_header.endRefreshing()
                
                switch event {
                case .next(let element):
                    printDebugLog(message: element.mj_keyValues())
                    
                    if  element.companyMap.isEmpty == false {
                        if element.companyMap.count > 4 {
                            weakSelf?.headView.snp.remakeConstraints({ (update) in
                                update.top.left.right.equalToSuperview()
                                update.height.equalTo(276)
                            })
                        }else {
                            weakSelf?.headView.snp.remakeConstraints({ (update) in
                                update.top.left.right.equalToSuperview()
                                update.height.equalTo(240)
                            })
                        }
                        weakSelf?.headView.fillDataSourcesCompany(companys: element.companyMap, selectedCompanyCode: (weakSelf?.companyCode)!)
                    }
                    weakSelf?.listTableView.mj_footer.endRefreshing()
                    if element.responsesList.isEmpty == true {
                        weakSelf?.listArray.removeAll()
                        weakSelf?.listTableView.reloadData()
                        return
                    }
                    if pageNo == 1 {
                        weakSelf?.listArray.removeAll()
                        weakSelf?.listArray = element.responsesList
                    }else {
                        weakSelf?.listArray.append(contentsOf: element.responsesList)
                    }
                    
                   
                    if element.responsesList.count <= (weakSelf?.listArray.count)!
                    {
                        weakSelf?.listTableView.mj_footer.endRefreshingWithNoMoreData()
                    }
                    
                    weakSelf?.listTableView.reloadData()
                case .error(let error):
                    try? weakSelf?.validateHttp(error)
                case .completed:
                    break
                    
                }
                
        }.disposed(by: self.bag)
    }
}

