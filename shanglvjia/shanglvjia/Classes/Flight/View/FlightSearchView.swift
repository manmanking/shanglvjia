//
//  FlightSearchView.swift
//  shop
//
//  Created by TBI on 2017/4/21.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import SnapKit



class FlightSearchView: UIView ,UITextFieldDelegate {
    
    //单程往返切换
    typealias SearchTypeBlock = (Bool) ->Void
    //查询参数类型  1开始城市 2到达城市 3开始日期 4到达日期 5开始时间 6到达时间
    typealias ParametersTypeBlock = (ParametersType) ->Void
    
    var searchTypeBlock:SearchTypeBlock?
    
    var parametersTypeBlock:ParametersTypeBlock?
    
    var constraint:Constraint?  //线条动画需要先装起来
    
    //当前是单程还是往返
    var type: Int = 0

    //单程
    let  oneWay = UILabel(text:NSLocalizedString("flight.one.way", comment: "单程"), color: TBIThemeBlueColor, size: 14)
    //往返
    let  roundTrip = UILabel(text:NSLocalizedString("flight.round.trip", comment: "往返"), color:TBIThemePrimaryTextColor, size: 14)
    
    let  line = UILabel(color: TBIThemeBlueColor)
    
    let  startCity = UITextField(placeholder: NSLocalizedString("start.city", comment: "出发城市"),fontSize: 18)//UILabel(text: NSLocalizedString("start.city", comment: "出发城市"),color: TBIThemePlaceholderTextColor,size: 16)
    
    let  arriveCity = UITextField(placeholder: NSLocalizedString("arrive.city", comment: "到达城市"),fontSize: 18)//UILabel(text: NSLocalizedString("arrive.city", comment: "到达城市"),color: TBIThemePlaceholderTextColor,size: 16)
    
    let  startCityline = UILabel(color: TBIThemeGrayLineColor)
    
    let  arriveCityline = UILabel(color: TBIThemeGrayLineColor)
    
    //var  startCityCode:String?
    
    //var  arriveCityCode:String?
    
    //转
    let  flightCycle = UIImageView(imageName: "Personal_ic_air_change")
    //飞机
    let  flightPlane = UIImageView(imageName: "Personal_ic_air_to")
    
    let  startDate = UITextField(placeholder: NSLocalizedString("start.date", comment: "出发日期"),fontSize: 20)
    
    let  arriveDate = UITextField(placeholder: NSLocalizedString("arrive.date", comment: "到达日期"),fontSize: 20)
    
    let  dateline = UILabel(color: TBIThemeGrayLineColor)
    
    let  startTime = UITextField(placeholder: NSLocalizedString("start.time", comment: "出发时间"),fontSize: 20)//UILabel(text: NSLocalizedString("start.time", comment: "出发时间"),color: TBIThemePlaceholderTextColor,size: 16)
    
    let  arriveTime = UITextField(placeholder: NSLocalizedString("arrive.time", comment: "到达时间"),fontSize: 20) // UILabel(text: NSLocalizedString("arrive.time", comment: "到达时间"),color: TBIThemePlaceholderTextColor,size: 16)
    
    let  timeline = UILabel(color: TBIThemeGrayLineColor)
    
    let  searchButton = UIButton(title: NSLocalizedString("search.button", comment: "查询"),titleColor: TBIThemeWhite,titleSize: 18)
    
    var showTime:Bool = true

    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //个人单程页面初始化
    func searchOneWayView(){
        timeline.isHidden = true
        arriveTime.isHidden = true
        arriveDate.isHidden = true
        startTime.isHidden = true
        startDate.snp.remakeConstraints{(make) in
            make.left.equalTo(dateline.snp.left)
            make.bottom.equalTo(dateline.snp.top)
            make.width.equalTo(dateline.snp.width)
            make.height.equalTo(40)
        }
    }
    //企业单程页面初始化
    func companySearchOneWayView(){
        timeline.isHidden = true
        arriveDate.isHidden = true
        if !showTime{
            startDate.snp.remakeConstraints{(make) in
                make.left.equalTo(dateline.snp.left)
                make.bottom.equalTo(dateline.snp.top)
                make.width.equalTo(dateline.snp.width)
                make.height.equalTo(40)
            }
            startTime.isHidden = true
            arriveTime.isHidden = true
        }else {
            startDate.snp.remakeConstraints{(make) in
                make.left.equalTo(dateline.snp.left)
                make.bottom.equalTo(dateline.snp.top)
                make.width.equalTo(dateline.snp.width).dividedBy(2)
                make.height.equalTo(40)
            }
            startTime.isHidden = false
            arriveTime.isHidden = true
        }
        startTime.textAlignment  = NSTextAlignment.right
        startTime.snp.remakeConstraints{(make) in
            make.right.equalTo(dateline.snp.right)
            make.bottom.equalTo(dateline.snp.top)
            make.width.equalTo(dateline.snp.width).dividedBy(2)
            make.height.equalTo(40)
        }
    }
    //个人往返页面初始化
    func searchRoundTripView(){
        timeline.isHidden = true
        arriveTime.isHidden = true
        startTime.isHidden = true
        arriveDate.isHidden = false
//        startDate.snp.remakeConstraints{(make) in
//            make.left.equalTo(dateline.snp.left)
//            make.bottom.equalTo(dateline.snp.top)
//            make.width.equalTo(dateline.snp.width).dividedBy(2)
//            make.height.equalTo(40)
//        }
    }
    //企业往返页面初始化
    func companySearchRoundTripView(){
        timeline.isHidden = false
        arriveTime.isHidden = false
        arriveDate.isHidden = false
        startTime.textAlignment  = NSTextAlignment.left
        
        startDate.snp.remakeConstraints{(make) in
            make.left.equalTo(dateline.snp.left)
            make.bottom.equalTo(dateline.snp.top)
            make.width.equalTo(dateline.snp.width).dividedBy(2)
            make.height.equalTo(40)
        }
        
        startTime.snp.remakeConstraints{(make) in
            make.left.equalTo(timeline.snp.left)
            make.bottom.equalTo(timeline.snp.top)
            make.width.equalTo(timeline.snp.width).dividedBy(2)
            make.height.equalTo(40)
        }
        if !showTime{
            startTime.isHidden = true
            arriveTime.isHidden = true
        }
    }
    
    
    func initView(){
        oneWay.textAlignment = NSTextAlignment.center
        roundTrip.textAlignment = NSTextAlignment.center
        arriveCity.textAlignment = NSTextAlignment.right
        arriveDate.textAlignment = NSTextAlignment.right
        startTime.textAlignment  = NSTextAlignment.right
        arriveTime.textAlignment = NSTextAlignment.right
        searchButton.backgroundColor = TBIThemeOrangeColor
        searchButton.layer.cornerRadius = 5
        
        addSubview(oneWay)
        addSubview(roundTrip)
        addSubview(line)
        addSubview(startCity)
        addSubview(arriveCity)
        addSubview(startCityline)
        addSubview(arriveCityline)
        addSubview(flightCycle)
        addSubview(flightPlane)
        
        addSubview(startDate)
        addSubview(arriveDate)
        addSubview(dateline)
        addSubview(startTime)
        addSubview(arriveTime)
        addSubview(timeline)
        addSubview(searchButton)

        oneWay.snp.makeConstraints{(make) in
            make.left.top.equalTo(0)
            make.height.equalTo(44)
            make.width.equalTo(ScreenWindowWidth/2)
        }
        roundTrip.snp.makeConstraints{(make) in
            make.right.top.equalTo(0)
            make.height.equalTo(44)
            make.width.equalTo(ScreenWindowWidth/2)
        }
        line.snp.makeConstraints{(make) in
            make.height.equalTo(2)
            make.width.equalTo(ScreenWindowWidth/2)
            make.top.equalTo(oneWay.snp.bottom)
            self.constraint = make.left.equalTo(0).constraint
        }
        startCityline.snp.makeConstraints{(make) in
            make.left.equalTo(16)
            make.top.equalTo(line.snp.bottom).offset(60)
            make.height.equalTo(0.5)
            make.width.equalTo((ScreenWindowWidth-84)/2)
        }
        arriveCityline.snp.makeConstraints{(make) in
            make.right.equalTo(-16)
            make.top.equalTo(line.snp.bottom).offset(60)
            make.height.equalTo(0.5)
            make.width.equalTo((ScreenWindowWidth-84)/2)
        }
        flightCycle.snp.makeConstraints{(make) in
            make.height.equalTo(36)
            make.width.equalTo(36)
            make.bottom.equalTo(startCityline.snp.top)
            make.left.equalTo(startCityline.snp.right)
        }
        flightPlane.snp.makeConstraints{(make) in
            make.height.equalTo(16)
            make.width.equalTo(30)
            make.bottom.equalTo(startCityline.snp.top).offset(-10)
            make.left.equalTo(startCityline.snp.right).offset(6)
        }
        
        startCity.snp.makeConstraints{(make) in
            make.bottom.equalTo(startCityline.snp.top)
            make.left.equalTo(startCityline.snp.left)
            make.width.equalTo(startCityline.snp.width)
            make.height.equalTo(40)
        }
    
        arriveCity.snp.makeConstraints{(make) in
            make.bottom.equalTo(arriveCityline.snp.top)
            make.right.equalTo(arriveCityline.snp.right)
            make.width.equalTo(arriveCityline.snp.width)
            make.height.equalTo(40)
        }
        
        dateline.snp.makeConstraints{(make) in
            make.top.equalTo(startCityline.snp.bottom).offset(50)
            make.height.equalTo(0.5)
            make.left.equalTo(16)
            make.right.equalTo(-16)
        }
        startDate.snp.makeConstraints{(make) in
            make.left.equalTo(dateline.snp.left)
            make.bottom.equalTo(dateline.snp.top)
            make.width.equalTo(dateline.snp.width).dividedBy(2)
            make.height.equalTo(40)
        }
        //返回时间先隐藏
        arriveDate.snp.makeConstraints{ (make) in
            make.right.equalTo(dateline.snp.right)
            make.bottom.equalTo(dateline.snp.top)
            make.width.equalTo(dateline.snp.width).dividedBy(2)
            make.height.equalTo(40)
        }
        
        startTime.snp.makeConstraints{(make) in
            make.right.equalTo(dateline.snp.right)
            make.bottom.equalTo(dateline.snp.top)
            make.width.equalTo(dateline.snp.width).dividedBy(2)
            make.height.equalTo(40)
        }
      
        timeline.snp.makeConstraints{(make) in
            make.top.equalTo(dateline.snp.bottom).offset(50)
            make.height.equalTo(0.5)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            
        }
        arriveTime.snp.makeConstraints{(make) in
            make.right.equalTo(timeline.snp.right)
            make.bottom.equalTo(timeline.snp.top)
            make.width.equalTo(timeline.snp.width).dividedBy(2)
            make.height.equalTo(40)
        }
        
        searchButton.snp.makeConstraints{(make) in
            make.left.equalTo(7)
            make.right.equalTo(-7)
            make.bottom.equalTo(-30)
            make.height.equalTo(47)
        }
        
        oneWay.addOnClickListener(target: self, action: #selector(click(tap:)))
        roundTrip.addOnClickListener(target: self, action: #selector(click(tap:)))
        flightPlane.addOnClickListener(target: self, action: #selector(click(tap:)))
        
        startCity.delegate = self
        arriveCity.delegate = self
        startDate.delegate = self
        arriveDate.delegate = self
        startTime.delegate = self
        arriveTime.delegate = self


    }
    
    //参数点击事件
    func parametersClick(tap:UITapGestureRecognizer){
        let vi = tap.view as! UILabel
        switch vi {
        case startCity:
            parametersTypeBlock!(ParametersType.startCity)
        case arriveCity:
            parametersTypeBlock!(ParametersType.arriveCity)
        case startDate:
            parametersTypeBlock!(ParametersType.startDate)
        case arriveDate:
            parametersTypeBlock!(ParametersType.arriveDate)
        case startTime:
            parametersTypeBlock!(ParametersType.startTime)
        case arriveTime:
            parametersTypeBlock!(ParametersType.arriveTime)
        default:
            return
        }
    }
    
    //header点击事件
    func click(tap:UITapGestureRecognizer){
        let vi = tap.view
        if vi == oneWay{
            searchTypeBlock!(false)
            if PersonalType == false {
                companySearchOneWayView()
            }else {
                searchOneWayView()
            }
            playAnimation(oneWay)
            roundTrip.textColor = TBIThemePrimaryTextColor
            oneWay.textColor = TBIThemeBlueColor
            self.type = 0
            
        }else if vi == roundTrip{
            if PersonalType == false {
                companySearchRoundTripView()
                searchTypeBlock!(true) //公务出行往返需要加一行
            }else {
                searchTypeBlock!(false)
                searchRoundTripView()
            }
            playAnimation(roundTrip)
            oneWay.textColor = TBIThemePrimaryTextColor
            roundTrip.textColor = TBIThemeBlueColor
            type = 1
        }else if vi == flightPlane{
            
            //连续旋转
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(1.0) //设置动画时间
            self.flightCycle.transform = self.flightCycle.transform.rotated(by: CGFloat(Double.pi/1.0))
            UIView.commitAnimations()
            
            let takeCityCode = searchModel.takeOffAirportCode
            let takeCityName = searchModel.takeOffAirportName
            let arriveCode = searchModel.arriveAirportCode
            let arriveName = searchModel.arriveAirportName
            
            searchModel.takeOffAirportCode = arriveCode
            searchModel.arriveAirportCode = takeCityCode
            searchModel.takeOffAirportName = arriveName
            searchModel.arriveAirportName = takeCityName
            
            
            startCity.text = arriveName
            arriveCity.text = takeCityName
        }
     
        
    }
    //移动动画
    func playAnimation(_ label: UILabel) {
        constraint?.update(offset: label.frame.origin.x)
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        line.frame.origin.x  = label.frame.origin.x //移到对应坐标
        UIView.commitAnimations()
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        switch textField {
        case startCity:
            parametersTypeBlock!(ParametersType.startCity)
        case arriveCity:
            parametersTypeBlock!(ParametersType.arriveCity)
        case startDate:
            parametersTypeBlock!(ParametersType.startDate)
        case arriveDate:
            parametersTypeBlock!(ParametersType.arriveDate)
        case startTime:
            parametersTypeBlock!(ParametersType.startTime)
        case arriveTime:
            parametersTypeBlock!(ParametersType.arriveTime)
        default:
            return
        }
        
    }
    
    enum ParametersType : Int {
        case startCity  = 1 //开始城市
        case arriveCity = 2 //到达城市
        case startDate  = 3 //开始日期
        case arriveDate = 4 //到达日期
        case startTime  = 5 //开始时间
        case arriveTime = 6 //到达时间
    }

    
}
