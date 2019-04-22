//
//  PSpecailFlightSelectCabinsViewController.swift
//  shanglvjia
//
//  Created by tbi on 2018/8/7.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PSpecailFlightSelectCabinsViewController: PersonalBaseViewController {

    
    fileprivate let tablePersonalSepcailViewCellIdentify = "PersonalFlightListCell"
    fileprivate let tablePSpecialFlightSelectCabinCellIdentify = "PSpecialFlightSelectCabinCell"
    
    fileprivate var flightTripCityTitleView:FlightTripCityTitleView = FlightTripCityTitleView()
    
    public var personalOnsaleFlightListViewType:AppModelCatoryENUM = AppModelCatoryENUM.PersonalSpecialHotel
    
    fileprivate let listTableView = UITableView()
    
    var startCity:String = ""
    var arriveCity:String = ""
    var tripType:NSInteger = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = TBIThemeBaseColor
        setBlackTitleAndNavigationColor(title: "")
        setNavigationBackButton(backImage: "left")
        
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
    override func backButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    

}
extension PSpecailFlightSelectCabinsViewController:UITableViewDataSource,UITableViewDelegate {
    func setTableView() {
        listTableView.frame = self.view.frame
        listTableView.dataSource = self
        listTableView.delegate = self
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
        
        if section == 0 && PersonalSpecialFlightManager.shareInStance.selectedFlightTripInfoDraw().count > 0  {
            return PersonalSpecialFlightManager.shareInStance.selectedFlightTripInfoDraw().count
        }
        return (PersonalSpecialFlightManager.shareInStance.selectedFlightTripInfoDraw().last?.cabinInfos.count)!
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && PersonalSpecialFlightManager.shareInStance.selectedFlightTripInfoDraw().count  > 0 {
            return 152
        }
        return 80
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
        if indexPath.section == 0{
            
        let cell = tableView.dequeueReusableCell(withIdentifier: self.tablePersonalSepcailViewCellIdentify) as! PersonalFlightListCell
        
            if tripType == 0{
                cell.goLabel.text = ""
                cell.fillDataSources(flightInfo:PersonalSpecialFlightManager.shareInStance.selectedFlightTripInfoDraw().first!)
            }else{
                if indexPath.row == 0{
                    cell.fillDataSources(flightInfo:PersonalSpecialFlightManager.shareInStance.selectedFlightTripInfoDraw().first!)
                    cell.goLabel.text = " 去 "
                }else{
                    cell.fillDataSourcesSpecialReturnFlightInfo(airfare:PersonalSpecialFlightManager.shareInStance.selectedFlightTripInfoDraw().last!)
                    cell.goLabel.text = " 返 "
                }
            }
            return cell
        }else{
             let cell = tableView.dequeueReusableCell(withIdentifier: self.tablePSpecialFlightSelectCabinCellIdentify) as! PSpecialFlightSelectCabinCell
            cell.fillDataSources(cabin:(PersonalSpecialFlightManager.shareInStance.selectedFlightTripInfoDraw().last?.cabinInfos[indexPath.row])!,index:indexPath.row)
            weak var weakSelf = self
            cell.flightSelectCabinsContentSVCellSelectedBlock = { (index) in
                weakSelf?.intoNextView(selectedIndex: index)
            }
            return cell
        }
    }
    func intoNextView(selectedIndex:NSInteger) {
        
        let personalFlightOrderViewController:PersonalFlightOrderViewController = PersonalFlightOrderViewController()
       
        
        let selectedFlightTrip = PersonalSpecialFlightManager.shareInStance.selectedFlightTripInfoDraw()
        selectedFlightTrip.last?.selectedCabinsIndex = selectedIndex
       PersonalSpecialFlightManager.shareInStance.selectedFlightTripInfoStore(flightTripArr: selectedFlightTrip)
        
        personalFlightOrderViewController.personalFlightOrderViewType = AppModelCatoryENUM.PersonalSpecialFlight
        self.navigationController?.pushViewController(personalFlightOrderViewController, animated: true)
        
    }
}
