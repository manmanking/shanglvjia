//
//  POnsaleFlightSelectCabinController.swift
//  shanglvjia
//
//  Created by tbi on 2018/8/8.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import RxSwift

class POnsaleFlightSelectCabinController: PersonalBaseViewController {
    fileprivate let tablePersonalSepcailViewCellIdentify = "PersonalFlightListCell"
    fileprivate let tablePSpecialFlightSelectCabinCellIdentify = "PSpecialFlightSelectCabinCell"
    let bag = DisposeBag()
    fileprivate var flightTripCityTitleView:FlightTripCityTitleView = FlightTripCityTitleView()
    
    public var personalOnsaleFlightListViewType:AppModelCatoryENUM = AppModelCatoryENUM.PersonalOnsaleFlight
    
    fileprivate let listTableView = UITableView()
    
    /// 0 国内 1 国际
    public var nationString:String = "0"
    // A 定投 F 特惠
    public var specialString:String = "A"
    
    var startCity:String = ""
    var arriveCity:String = ""
    var tripType:NSInteger = 0
    var nationType:String = ""
    var productId:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = TBIThemeBaseColor
        setBlackTitleAndNavigationColor(title: "")
        setNavigationBackButton(backImage: "left")
       
        fillDataSources()
        setTableView()
        setTitleView(start:startCity, arrive:arriveCity )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    ///导航标题
    func setTitleView(start: String, arrive: String) {
        guard start.isEmpty == false || arrive.isEmpty == false else {
            return
        }
        let startCityWidth:NSNumber = NSNumber.init(value:Float(start.getTextWidth(font: UIFont.systemFont(ofSize: 16), height: 44)))
        let arriveCityWidth:NSNumber = NSNumber.init(value:Float(arrive.getTextWidth(font: UIFont.systemFont(ofSize: 16), height: 44)))
        var titleWidth:NSInteger = 0
        
        titleWidth = startCityWidth.intValue + arriveCityWidth.intValue + 20
        
        flightTripCityTitleView.frame = CGRect.init(x: Int((ScreenWindowWidth - 150)/2), y: 0, width: titleWidth, height: 44)
        flightTripCityTitleView.fillPersonalDataSources(type: tripType, startCity: start, arriveCity: arrive)
        
        self.navigationItem.titleView?.addSubview(flightTripCityTitleView)
        flightTripCityTitleView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(titleWidth)
        }
    }
    
    
    
    func fillDataSources() {
        
//        if nationString == "1" {
//            let selectedTrip = PersonalOnsaleFlightManager.shareInStance.selectedFlightTripDraw()
//            selectedTrip.last?.cabins.removeAll()
//            PersonalOnsaleFlightManager.shareInStance.selectedFlightTripStore(flightTripArr: selectedTrip)
//        }
        
        
        getInternationalFlightCabinInfoNET()
        
    }
  
    
    //MARK:------NET-----
    func getInternationalFlightCabinInfoNET() {
        guard nationString == "1" else {
            return
        }
        
        weak var weakSelf = self

        let airfareCacheId:String = PersonalOnsaleFlightManager.shareInStance.selectedFlightTripDraw().last?.cacheId ?? ""
        let flightCacheId:String = PersonalOnsaleFlightManager.shareInStance.selectedFlightTripDraw().last?.flightCacheId ?? ""

        showLoadingView()
        let request:[String:Any] = ["airFareCacheId":airfareCacheId,"productId":productId,"flightCacheId":flightCacheId]
        PersonalFlightServices.sharedInstance.onsalePersonalFlightCabinInfo(request: request)
            .subscribe{ event in
                weakSelf?.hideLoadingView()
                

                switch event {
                case .next(let element):
                    printDebugLog(message: element.mj_keyValues())
                    
                    let selectedFlightTrip =  PersonalOnsaleFlightManager.shareInStance.selectedFlightTripDraw()
                        //.last?.cabins = element.airfares.first?.cabins
                    selectedFlightTrip.last?.cabins = (element.airfares.first?.cabins)!
                    PersonalOnsaleFlightManager.shareInStance.selectedFlightTripStore(flightTripArr: selectedFlightTrip)
                    weakSelf?.listTableView.reloadData()
                case .error(let error):
                    weakSelf?.hideLoadingView()
                    try? weakSelf?.validateHttp(error)
                case .completed:
                    break

                }
            }.addDisposableTo(self.bag)


        
        
    }
    
    
    
    
    //MARK:-----Action-----
    override func backButtonAction(sender: UIButton) {
        if PersonalOnsaleFlightManager.shareInStance.selectedFlightTripDraw().count > 1{
            PersonalOnsaleFlightManager.shareInStance.deleteSelectedFlightLastTrip()
        }
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
}
extension POnsaleFlightSelectCabinController:UITableViewDataSource,UITableViewDelegate {
    func setTableView() {
        listTableView.frame = self.view.frame
        listTableView.dataSource = self
        listTableView.delegate = self
        listTableView.bounces = false
        listTableView.register(PersonalFlightListCell.classForCoder(), forCellReuseIdentifier: self.tablePersonalSepcailViewCellIdentify)
        listTableView.register(PSpecialFlightSelectCabinCell.classForCoder(), forCellReuseIdentifier: self.tablePSpecialFlightSelectCabinCellIdentify)
        listTableView.separatorStyle = .none
        listTableView.backgroundColor = TBIThemeBaseColor
        self.view.addSubview(listTableView)
        listTableView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    //MARK:- UITableViewDataSources
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 && PersonalOnsaleFlightManager.shareInStance.selectedFlightTripDraw().count > 0  {
            let mainland:Bool = PersonalOnsaleFlightManager.shareInStance.selectedFlightTripDraw().first?.flightNation == "0" ? true : false
            if tripType == 0{
                return 1
            }else{
                if mainland {return 1 }
                else {return 2}
                
                
                
            }
            //return PersonalOnsaleFlightManager.shareInStance.selectedFlightTripDraw().count
        }
        return (PersonalOnsaleFlightManager.shareInStance.selectedFlightTripDraw().last?.cabins.count)!
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && PersonalOnsaleFlightManager.shareInStance.selectedFlightTripDraw().count  > 0 {
            return 152
        }
        return 80
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: self.tablePersonalSepcailViewCellIdentify) as! PersonalFlightListCell
            let mainland:Bool = PersonalOnsaleFlightManager.shareInStance.selectedFlightTripDraw().first?.flightNation == "0" ? true : false
            if tripType == 0{
                cell.goLabel.text = ""
                cell.fillOnsaleDataSources(airfare:PersonalOnsaleFlightManager.shareInStance.selectedFlightTripDraw()[indexPath.row])
            }else if mainland == false
            {
                if indexPath.row == 0{
                    cell.fillOnsaleDataSources(airfare:PersonalOnsaleFlightManager.shareInStance.selectedFlightTripDraw()[indexPath.row])
                    cell.goLabel.text = " 去 "
                }else{
                    cell.fillOnsaleDataSources(airfare:PersonalOnsaleFlightManager.shareInStance.selectedFlightTripDraw()[indexPath.row])
                    cell.goLabel.text = " 返 "
                }
            }else {
                
                if PersonalOnsaleFlightManager.shareInStance.selectedFlightTripDraw().count > 1 {
                    cell.fillOnsaleDataSources(airfare:PersonalOnsaleFlightManager.shareInStance.selectedFlightTripDraw().last!)
                    cell.goLabel.text = " 返 "
                }else{
                    cell.fillOnsaleDataSources(airfare:PersonalOnsaleFlightManager.shareInStance.selectedFlightTripDraw()[indexPath.row])
                    cell.goLabel.text = " 去 "
                    
                }
                
                
                
                
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: self.tablePSpecialFlightSelectCabinCellIdentify) as! PSpecialFlightSelectCabinCell
            cell.fillDataSourcesOnsale(cabin:(PersonalOnsaleFlightManager.shareInStance.selectedFlightTripDraw().last?.cabins[indexPath.row])!,index:indexPath.row)
            weak var weakSelf = self
            cell.flightSelectCabinsContentSVCellSelectedBlock = { (index) in
                weakSelf?.intoNextView(selectedIndex:index)
            }
            return cell
        }
    }
    func intoNextView(selectedIndex:NSInteger) {
        let selectedFlightTrip = PersonalOnsaleFlightManager.shareInStance.selectedFlightTripDraw()
        
        if nationString == "0" && tripType == 1 && selectedFlightTrip.count < 2 {
            let returnVC: POnsaleFlightReturnViewController = POnsaleFlightReturnViewController()
            ///添加选择航
            
            selectedFlightTrip.last?.selectedCabinIndex = selectedIndex
            PersonalOnsaleFlightManager.shareInStance.selectedFlightTripStore(flightTripArr: selectedFlightTrip)
            returnVC.arriveCity = arriveCity
            returnVC.startCity = startCity
            returnVC.productId = productId
            returnVC.nationString = nationString
            returnVC.specialString = specialString
            //returnVC.type = nationType
            self.navigationController?.pushViewController(returnVC, animated: true)
        }else{
            let personalFlightOrderViewController:PersonalFlightOrderViewController = PersonalFlightOrderViewController()
            let selectedFlightTrip = PersonalOnsaleFlightManager.shareInStance.selectedFlightTripDraw()
            selectedFlightTrip.last?.selectedCabinIndex = selectedIndex
            if selectedFlightTrip.last?.flightNation == "1" && selectedFlightTrip.last?.flightTripType == "1" {
                
                for element in selectedFlightTrip {
                    element.cabins = (selectedFlightTrip.last?.cabins)!
                    element.selectedCabinIndex = selectedIndex
                }
            }
            PersonalOnsaleFlightManager.shareInStance.selectedFlightTripStore(flightTripArr: selectedFlightTrip)
            for element in PersonalOnsaleFlightManager.shareInStance.selectedFlightTripDraw(){
                printDebugLog(message: element.cabins.first?.cacheId)
            }
            //personalFlightOrderViewController.nationString = nationString
            personalFlightOrderViewController.specialString = specialString
            
            
            
            personalFlightOrderViewController.personalFlightOrderViewType = AppModelCatoryENUM.PersonalOnsaleFlight
            self.navigationController?.pushViewController(personalFlightOrderViewController, animated: true)
        }
        
        
        
    }
}

