//
//  FlightViewController.swift
//  shop
//
//  Created by zhangwangwang on 2017/4/20.
//  Copyright © 2017年 zhangwangwang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftDate

/// 个人机票 begin
//查询条件信息
//var searchModel: CommercialFlightSearchForm = CommercialFlightSearchForm(takeOffAirportCode: "TSN", arriveAirportCode: "SHA",takeOffAirportName: "天津",arriveAirportName: "上海", type: 0, travellerUids: [""])
////选中去程航班信息信息
//var takeOffModel:FlightListItem?
////选中回程航班信息
//var arriveModel:FlightListItem?
////选中去程航班信息
//var takeOffCabinRow:Int?
////选中回程航班信息
//var arriveCabinRow:Int?
///// 个人信息end
//
///// 企业信息begin
////  去成航班信息
//var takeOffCompanyModel:CoFlightSearchResult.FlightItem?
////  回程航班信息
//var arriveCompanyModel:CoFlightSearchResult.FlightItem?
////选中去程航班信息
//var takeOffCompanyCabinRow:Int?
////选中回程航班信息
//var arriveCompanyCabinRow:Int?



/// 企业信息end

class FlightSearchViewController: BaseViewController {
    
    fileprivate let service = CityService.sharedInstance
    
    fileprivate let bag = DisposeBag()
    
    fileprivate let  bgImgView = UIImageView(imageName: "bg_airplane_ticket_business")
    //选项卡view
    fileprivate let hearderView = FlightSearchView()
    
    fileprivate let tableView: UITableView = UITableView()
    
    fileprivate let pickViewTimeDataSourcesArr:[String] = ["01:00","02:00","03:00","04:00","05:00","06:00","07:00","08:00","09:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00","20:00","21:00","22:00","23:00","00:00"]
    
    
    fileprivate let pickerTimeView:TBIPickerView = TBIPickerView()
    
    fileprivate var userDetail:UserDetail?
    
    var travelNo:String? = nil
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation(title:"机票查询")
        self.navigationController?.navigationBar.isTranslucent = false
        initView()
        let time = (userDetail?.companyUser?.coDefTakeOffTimeStr.isNotEmpty ?? false) ? " " + (userDetail?.companyUser?.coDefTakeOffTimeStr)! + ":00" : " 00:00:00"
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        let departureDate = DateInRegion() //+ 1.day
        let returnDate = DateInRegion() + 10.day
        searchModel.departureDate = departureDate.string(custom: "YYYY-MM-dd")
        searchModel.returnDate =  returnDate.string(custom: "YYYY-MM-dd")
        
        let startDate = DateInRegion(string: departureDate.string(custom: "YYYY-MM-dd") + time, format: .custom("YYYY-MM-dd HH:mm:ss"), fromRegion: regionRome)!
        let endDate = DateInRegion(string: returnDate.string(custom: "YYYY-MM-dd") + time, format: .custom("YYYY-MM-dd HH:mm:ss"), fromRegion: regionRome)!
        
        searchModel.departureDates =  startDate.absoluteDate
        searchModel.returnDates    =  endDate.absoluteDate
        
        searchModel.arriveAirportCode = "SHA"
        searchModel.takeOffAirportCode = "TSN"

        if PersonalType {
            searchModel.takeOffAirportName = "天津"
            searchModel.arriveAirportName = "上海"
            self.hearderView.startCity.text =  "天津"
            self.hearderView.arriveCity.text = "上海"
        }else {
            searchModel.takeOffAirportName = "天津滨海机场"
            searchModel.arriveAirportName = "上海虹桥机场"
            self.hearderView.startCity.text =  "天津滨海机场"
            self.hearderView.arriveCity.text = "上海虹桥机场"
        }
        
        setDate()
        
        self.hearderView.searchButton.addTarget(self, action: #selector(submit(sender:)), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setDate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func backButtonAction(sender:UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    

}

extension  FlightSearchViewController{
    
    
    func setDate(){
        let attrStartData = NSMutableAttributedString()
        let sdate = DateInRegion(string: searchModel.departureDate, format: .custom("YYYY-MM-dd"), fromRegion: regionRome)!
        let rdate = DateInRegion(string: searchModel.returnDate, format: .custom("YYYY-MM-dd"), fromRegion: regionRome)!
        
        let startMonth = NSAttributedString.init(string: sdate.string(custom: "M月d日"), attributes: [NSForegroundColorAttributeName : TBIThemePrimaryTextColor, NSFontAttributeName : UIFont.systemFont(ofSize: 20)])
        let startWeek = NSAttributedString.init(string: sdate.string(custom: "EEE"), attributes: [NSForegroundColorAttributeName : TBIThemePrimaryTextColor, NSFontAttributeName : UIFont.systemFont(ofSize: 14)])
        attrStartData.append(startMonth)
        attrStartData.append(startWeek)
        let attrReturnData = NSMutableAttributedString()
        let returnMonth = NSAttributedString.init(string: rdate.string(custom: "M月d日"), attributes: [NSForegroundColorAttributeName : TBIThemePrimaryTextColor, NSFontAttributeName : UIFont.systemFont(ofSize: 20)])
        let returnWeek = NSAttributedString.init(string: rdate.string(custom: "EEE"), attributes: [NSForegroundColorAttributeName : TBIThemePrimaryTextColor, NSFontAttributeName : UIFont.systemFont(ofSize: 14)])
        attrReturnData.append(returnMonth)
        attrReturnData.append(returnWeek)
        
        
        
        self.hearderView.startDate.attributedText = attrStartData
        self.hearderView.arriveDate.attributedText = attrReturnData
    
    }
    //初始化页面
    func initView(){
        bgImgView.image = UIImage.init(named: PersonalType ? "bg_airplane ticket_personal":"bg_airplane_ticket_business")
        self.view.addSubview(bgImgView)
        bgImgView.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalToSuperview()
        }
        userDetail = UserService.sharedInstance.userDetail()
        
        let travellerList = PassengerManager.shareInStance.passengerDraw()
        
        userDetail?.companyUser?.lowestPriceInterval = Int(travellerList.first?.lowestPriceInterval ?? "0")
        //如果时间是0不显示time
        if userDetail?.companyUser?.lowestPriceInterval == 0{
            hearderView.showTime = false
        }
        
        hearderView.startTime.text = userDetail?.companyUser?.coDefTakeOffTimeStr
        hearderView.arriveTime.text = userDetail?.companyUser?.coDefTakeOffTimeStr
        self.view.backgroundColor = TBIThemeBaseColor
        hearderView.backgroundColor = TBIThemeWhite
        hearderView.layer.cornerRadius = 5
        self.view.addSubview(hearderView)
        let lowestPriceInterval:String = String(describing: userDetail?.companyUser?.lowestPriceInterval ?? 24)
        
        let borderView:UIView = {
            let vi = UIView()
            vi.layer.cornerRadius = 5
            vi.backgroundColor = TBIThemeWhite
            let label = UILabel()
            let infoFill = UIImageView(imageName: "info_fill")
            
            let message = NSMutableAttributedString(string:String(format: NSLocalizedString("flight.travel.message", comment: ""),arguments:[lowestPriceInterval]))
            message.addAttributes([NSForegroundColorAttributeName :TBIThemePlaceholderTextColor, NSFontAttributeName : UIFont.systemFont(ofSize: 14.0)],range: NSMakeRange(0,message.length))
            message.addAttributes([NSForegroundColorAttributeName : TBIThemeOrangeColor, NSFontAttributeName : UIFont.systemFont(ofSize: 14.0)],range: NSMakeRange(22,1))
            label.attributedText = message
            label.numberOfLines = 0
            label.lineBreakMode = NSLineBreakMode.byWordWrapping
            vi.addSubview(label)
            vi.addSubview(infoFill)
            label.snp.makeConstraints{(make) in
                make.left.equalTo(26)
                make.right.equalTo(-10)
                make.top.equalTo(8)
                make.bottom.equalTo(-8)
            }
            infoFill.snp.makeConstraints{(make) in
                make.height.width.equalTo(14)
                make.top.equalTo(9)
                make.right.equalTo(label.snp.left).offset(-5)
            }
            return vi
        }()
        
        if PersonalType == false && userDetail?.companyUser?.lowestPriceInterval != 0{
            hearderView.companySearchOneWayView()
            self.view.addSubview(borderView)
            borderView.snp.makeConstraints{(make) in
                make.left.right.equalToSuperview().inset(8)
                make.top.equalTo(hearderView.snp.bottom).offset(10)
            }
        }else {
            hearderView.searchOneWayView()
        }
    
        hearderView.snp.makeConstraints{(make) in
            make.left.right.top.equalToSuperview().inset(8)
            make.height.equalTo(264)
        }
        //去程回程切换
        hearderView.searchTypeBlock = { (parameter) in
            if parameter && self.userDetail?.companyUser?.lowestPriceInterval != 0{//如果是企业时间为0页没有时间选项
                self.hearderView.snp.remakeConstraints{(make) in
                    make.left.right.top.equalToSuperview().inset(8)
                    make.height.equalTo(314)
                }
            }else{
                self.hearderView.snp.remakeConstraints{(make) in
                    make.left.right.top.equalToSuperview().inset(8)
                    make.height.equalTo(264)
                }
            }
        }
        hearderView.parametersTypeBlock = { (parameter) in
            switch parameter {
            case FlightSearchView.ParametersType.startCity:
                let citySelectorViewController = CitySelectorViewController()
                citySelectorViewController.citySelectorBlock = { (cityName,cityCode) in
                    self.hearderView.startCity.text = cityName
                    searchModel.takeOffAirportCode = cityCode
                    searchModel.takeOffAirportName = cityName
                    
                }
                citySelectorViewController.setCityType(type: PersonalType == true ? .flightCity : .flightAirport)
                self.service.getGroups(PersonalType == true ?.flightCity:.flightAirport).subscribe{ event in
                    if case .next(let e) = event {
                        citySelectorViewController.city = e
                        self.navigationController?.pushViewController(citySelectorViewController, animated: true)
                    }
                }.addDisposableTo(self.bag)

            case FlightSearchView.ParametersType.arriveCity:
                let citySelectorViewController = CitySelectorViewController()
                citySelectorViewController.citySelectorBlock = { (cityName,cityCode) in
                    self.hearderView.arriveCity.text = cityName
                    searchModel.arriveAirportName  = cityName
                    searchModel.arriveAirportCode =  cityCode
                }
                citySelectorViewController.setCityType(type: PersonalType == true ? .flightCity : .flightAirport)
                self.service.getGroups(PersonalType == true ?.flightCity:.flightAirport).subscribe{ event in
                    if case .next(let e) = event {
                        citySelectorViewController.city = e
                        self.navigationController?.pushViewController(citySelectorViewController, animated: true)
                    }
                    }.addDisposableTo(self.bag)
            case FlightSearchView.ParametersType.startDate:
                //self.nextViewSpecialCalendar()
                self.nextViewTBICalendar()
                return
            case FlightSearchView.ParametersType.arriveDate:
                //self.nextViewSpecialCalendar()
                self.nextViewTBICalendar()
                return
            case FlightSearchView.ParametersType.startTime:
                //出发时间
                self.selectDate(type:1)
                return
            case FlightSearchView.ParametersType.arriveTime:
                //到达时间
                self.selectDate(type:2)
                return
            }
        }
    }
    
    func selectDate(type:Int){
        KeyWindow?.addSubview(pickerTimeView)
        pickerTimeView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        pickerTimeView.fillDataSources(dataSourcesArr: pickViewTimeDataSourcesArr)
        pickerTimeView.pickerViewSelectedRow = {(selectedIndex,title) in
            if type ==  1 {
                let date = DateInRegion(string: searchModel.departureDate + " " + title , format: .custom("yyyy-MM-dd HH:mm"), fromRegion: regionRome)
                searchModel.departureDates = date?.absoluteDate
                self.hearderView.startTime.text = title
            }else {
                let date = DateInRegion(string: searchModel.returnDate + " " + title , format: .custom("yyyy-MM-dd HH:mm"), fromRegion: regionRome)
                searchModel.returnDates = date?.absoluteDate
                self.hearderView.arriveTime.text = title
            }
         
        }
        
    }
    
    //选择日期
    func nextViewSpecialCalendar () {
        let time = (userDetail?.companyUser?.coDefTakeOffTimeStr.isNotEmpty ?? false) ? " " + (userDetail?.companyUser?.coDefTakeOffTimeStr)! + ":00" : " 00:00:00"
        let vc:TBISpecailCalendarViewController = TBISpecailCalendarViewController()
        if hearderView.type == 0 {
            vc.selectedDates = searchModel.departureDate == nil ? [""] : [searchModel.departureDate + time]
            vc.isMultipleTap = false
            vc.showDateTitle = [""]
            vc.titleColor = TBIThemePrimaryTextColor
            vc.bacButtonImageName = "back"
            vc.hotelSelectedDateAcomplishBlock = { (parameters) in
                let dateString = parameters[0].replacingOccurrences(of: " 00:00:00", with: time)
                let date = DateInRegion(string: dateString, format: .custom("YYYY-MM-dd HH:mm:ss"), fromRegion: regionRome)!
                searchModel.departureDate = date.string(custom: "YYYY-MM-dd")
                self.hearderView.startDate.text = date.string(custom: "yyyy年M月d日")
                let edate = date + 10.day
                searchModel.returnDate = edate.string(custom: "YYYY-MM-dd")
                
                searchModel.departureDates = date.absoluteDate
                searchModel.returnDates = edate.absoluteDate
                
                self.setDate()
                
            }
        }else if hearderView.type ==  1 {
            vc.selectedDates = [searchModel.departureDate + time,searchModel.returnDate + time]
            vc.isMultipleTap = true
            vc.showDateTitle = ["去程","返程"]
            vc.titleColor = TBIThemePrimaryTextColor
            vc.bacButtonImageName = "back"
            vc.hotelSelectedDateAcomplishBlock = { (parameters) in
                let sdateString = parameters[0].replacingOccurrences(of: " 00:00:00", with: time)
                let edateString = parameters[1].replacingOccurrences(of: " 00:00:00", with: time)
                
                let sdate = DateInRegion(string: sdateString, format: .custom("YYYY-MM-dd HH:mm:ss"), fromRegion: regionRome)!
                let edate = DateInRegion(string: edateString, format: .custom("YYYY-MM-dd HH:mm:ss"), fromRegion: regionRome)!
                searchModel.departureDate = sdate.string(custom: "YYYY-MM-dd")
                searchModel.returnDate = edate.string(custom: "YYYY-MM-dd")
                searchModel.departureDates = sdate.absoluteDate
                searchModel.returnDates = edate.absoluteDate
                self.setDate()
                
            }
        }
        _ = self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //选择日期
    func nextViewTBICalendar () {
        let time = (userDetail?.companyUser?.coDefTakeOffTimeStr.isNotEmpty ?? false) ? " " + (userDetail?.companyUser?.coDefTakeOffTimeStr)! + ":00" : " 00:00:00"
        let vc:TBICalendarViewController = TBICalendarViewController()
        if hearderView.type == 0 {
            vc.selectedDates = searchModel.departureDate == nil ? [""] : [searchModel.departureDate + time]
            vc.isMultipleTap = false
            vc.showDateTitle = [""]
            vc.titleColor = TBIThemePrimaryTextColor
            vc.bacButtonImageName = "back"
            vc.hotelSelectedDateAcomplishBlock = { (parameters,action) in
                if action == TBICalendarAction.Back {
                    return
                }
                let dateString = parameters?[0].replacingOccurrences(of: " 00:00:00", with: time)
                let date = DateInRegion(string: dateString!, format: .custom("YYYY-MM-dd HH:mm:ss"), fromRegion: regionRome)!
                searchModel.departureDate = date.string(custom: "YYYY-MM-dd")
                self.hearderView.startDate.text = date.string(custom: "yyyy年M月d日")
                let edate = date + 10.day
                searchModel.returnDate = edate.string(custom: "YYYY-MM-dd")
                
                searchModel.departureDates = date.absoluteDate
                searchModel.returnDates = edate.absoluteDate
                
                self.setDate()
                
            }
        }else if hearderView.type ==  1 {
            vc.selectedDates = [searchModel.departureDate + time,searchModel.returnDate + time]
            vc.isMultipleTap = true
            vc.calendarAlertType = TBICalendarAlertType.Flight
            vc.calendarTypeAlert = ["请选择去程日期","请选择返程日期"]
            vc.showDateTitle = ["去程","返程"]
            vc.titleColor = TBIThemePrimaryTextColor
            vc.bacButtonImageName = "back"
            vc.hotelSelectedDateAcomplishBlock = { (parameters,action) in
                if action == TBICalendarAction.Back {
                    return
                }
                let sdateString = parameters?[0].replacingOccurrences(of: " 00:00:00", with: time)
                let edateString = parameters?[1].replacingOccurrences(of: " 00:00:00", with: time)
                
                let sdate = DateInRegion(string: sdateString!, format: .custom("YYYY-MM-dd HH:mm:ss"), fromRegion: regionRome)!
                let edate = DateInRegion(string: edateString!, format: .custom("YYYY-MM-dd HH:mm:ss"), fromRegion: regionRome)!
                searchModel.departureDate = sdate.string(custom: "YYYY-MM-dd")
                searchModel.returnDate = edate.string(custom: "YYYY-MM-dd")
                searchModel.departureDates = sdate.absoluteDate
                searchModel.returnDates = edate.absoluteDate
                self.setDate()
                
            }
        }
        _ = self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    

    
}

extension FlightSearchViewController {
    
    func submit(sender: UIButton) {
//        if PersonalType { //个人
//            let vc = FlightPersonalSearchListViewController()
//            searchModel.type = hearderView.type
//            vc.setTitleView(start: self.hearderView.startCity.text!, arrive: self.hearderView.arriveCity.text!)
//            self.navigationController?.pushViewController(vc, animated: true)
//        } else {//公司
//
//
//        }
        let vc = FlightBusinessSearchListViewController()
        searchModel.type = hearderView.type
        vc.travelNo = self.travelNo
        self.navigationController?.pushViewController(vc, animated: true)
      
    }
}
