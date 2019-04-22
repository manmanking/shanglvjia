//
//  CoTrainSearchView.swift
//  shop
//
//  Created by TBI on 2017/12/26.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import SnapKit


class CoTrainSearchView: UIView ,UITextFieldDelegate {
    
    //单程往返切换
    typealias SearchTypeBlock = (Bool) ->Void
    //查询参数类型  1开始城市 2到达城市 3开始日期 4到达日期 5开始时间 6到达时间
    typealias ParametersTypeBlock = (FlightSearchView.ParametersType) ->Void
  
    var searchTypeBlock:SearchTypeBlock?
    
    var parametersTypeBlock:ParametersTypeBlock?

    
    //当前是单程还是往返
    var type: Int = 0
    
    let  headerView:CoGoBackHeaderView = CoGoBackHeaderView()
    
    let  contentView:UIView = UIView(frame: CGRect.init(x: 0, y: 0, width: ScreenWindowWidth - 10, height: 257))
    
    let  startCity = UILabel.init(text: "出发城市", color: TBIThemePrimaryTextColor, size: 18)// UITextField(placeholder: NSLocalizedString("start.city", comment: "出发城市"),fontSize: 18)
    
    let  arriveCity = UILabel.init(text: "到达城市", color: TBIThemePrimaryTextColor, size: 18)//UITextField(placeholder: NSLocalizedString("arrive.city", comment: "到达城市"),fontSize: 18)
    
    let  startCityline = UILabel(color: TBIThemeGrayLineColor)
    
    
    //转
    let  trainCycle = UIImageView(imageName: "ic_roundtrip")
    
    let  startDateTextField = UITextField(placeholder: NSLocalizedString("start.date", comment: "出发日期"),fontSize: 18)
    
    let  arriveDateTextField = UITextField(placeholder: NSLocalizedString("arrive.date", comment: "到达日期"),fontSize: 18)
    
    let  dateline = UILabel(color: TBIThemeGrayLineColor)
    
    let  gtLabel = UILabel(text:"只看高铁动车", color: TBIThemePrimaryTextColor, size: 18)
    
    let  gtSwitch = UISwitch()
    
    let  gtline = UILabel(color: TBIThemeGrayLineColor)
    
    let  searchButton = UIButton(title: NSLocalizedString("search.button", comment: "查询"),titleColor: TBIThemeWhite,titleSize: 18)
    
    var showTime:Bool = true
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
   
    //企业往返页面初始化
    func companySearchRoundTripView(){
        //翻转图片的方向
        let selectImage = UIImage(named:"ic_car_pickup")
        let flipImageOrientation = ((selectImage?.imageOrientation.rawValue)! + 4) % 8
        let flipImage =  UIImage.init(cgImage: (selectImage?.cgImage)!, scale: (selectImage?.scale)!, orientation: UIImageOrientation(rawValue: flipImageOrientation)!)
        self.headerView.bgImg.image = flipImage
        arriveDateTextField.isHidden = false
    }
    
    //单程
    func companySearchOneWayView(){
        let selectImage = UIImage(named:"ic_car_pickup")
        self.headerView.bgImg.image = selectImage
        arriveDateTextField.isHidden = true
    }
    
    func initView(){
        
        startCity.textAlignment = .left
        arriveCity.textAlignment = .right
        arriveDateTextField.textAlignment = .right
        searchButton.layer.cornerRadius = 5
        searchButton.setBackgroundImage(UIImage (named: "yellow_btn_gradient"), for: UIControlState.normal)
        searchButton.clipsToBounds=true
        
        self.backgroundColor = UIColor.clear
        self.contentView.addCorner(byRoundingCorners: [UIRectCorner.bottomLeft, UIRectCorner.bottomRight], radii: 3)
       
        addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(45)
        }
        contentView.backgroundColor = TBIThemeWhite
        addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
        }
        contentView.addSubview(startCityline)
        startCityline.snp.makeConstraints{(make) in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(55)
            make.height.equalTo(0.5)
        }
        startCity.tintColor = TBIThemeWhite
        contentView.addSubview(startCity)
        startCity.snp.makeConstraints{(make) in
            make.top.equalToSuperview()
            make.bottom.equalTo(startCityline.snp.top)
            make.left.equalTo(startCityline.snp.left)
            make.width.equalTo((ScreenWindowWidth - 76)/2)
        }
        arriveCity.tintColor = TBIThemeWhite
        contentView.addSubview(arriveCity)
        arriveCity.snp.makeConstraints{(make) in
            make.top.equalToSuperview()
            make.bottom.equalTo(startCityline.snp.top)
            make.right.equalTo(startCityline.snp.right)
            make.width.equalTo((ScreenWindowWidth - 76)/2)
            //make.height.equalTo(40)
        }
        contentView.addSubview(trainCycle)
        trainCycle.snp.makeConstraints{(make) in
            make.height.equalTo(36)
            make.width.equalTo(36)
            make.centerY.equalTo(startCity.snp.centerY)
            make.centerX.equalToSuperview()
        }
        contentView.addSubview(dateline)
        dateline.snp.makeConstraints{(make) in
            make.top.equalTo(startCityline.snp.bottom).offset(55)
            make.height.equalTo(0.5)
            make.left.equalTo(15)
            make.right.equalTo(-15)
        }
        startDateTextField.tintColor = TBIThemeWhite
        contentView.addSubview(startDateTextField)
        startDateTextField.snp.makeConstraints{(make) in
            make.top.equalTo(startCityline.snp.bottom)
            make.left.equalTo(dateline.snp.left)
            make.bottom.equalTo(dateline.snp.top)
            make.width.equalTo(dateline.snp.width)//.dividedBy(2)
            //make.height.equalTo(40)
        }
        //返回时间先隐藏
        arriveDateTextField.isHidden = true
        arriveDateTextField.tintColor = TBIThemeWhite
        contentView.addSubview(arriveDateTextField)
        arriveDateTextField.snp.makeConstraints{ (make) in
            make.top.equalTo(startCityline.snp.bottom)
            make.right.equalTo(dateline.snp.right)
            make.bottom.equalTo(dateline.snp.top)
            make.width.equalTo(dateline.snp.width).dividedBy(2)
            //make.height.equalTo(40)
        }
        contentView.addSubview(gtline)
        gtline.snp.makeConstraints{(make) in
            make.top.equalTo(dateline.snp.bottom).offset(55)
            make.height.equalTo(0.5)
            make.left.equalTo(15)
            make.right.equalTo(-15)
        }
        contentView.addSubview(gtLabel)
        gtLabel.snp.makeConstraints{(make) in
            make.top.equalTo(dateline.snp.bottom)
            make.left.equalTo(gtline.snp.left)
            make.bottom.equalTo(gtline.snp.top)
            make.width.equalTo(gtline.snp.width).dividedBy(1.5)
            //make.height.equalTo(40)
        }
        contentView.addSubview(gtSwitch)
        gtSwitch.onTintColor = PersonalThemeNormalColor
        gtSwitch.snp.makeConstraints { (make) in
            make.right.equalTo(-33)
            make.centerY.equalTo(gtLabel.snp.centerY)
            make.height.equalTo(20)
            make.width.equalTo(32)
        }
        
        contentView.addSubview(searchButton)
        searchButton.snp.makeConstraints{(make) in
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalTo(-15)
            make.height.equalTo(47)
        }
        
        headerView.oneWay.addOnClickListener(target: self, action: #selector(oneWayClick(tap:)))
        headerView.roundTrip.addOnClickListener(target: self, action: #selector(roundTripClick(tap:)))
        trainCycle.addOnClickListener(target: self, action: #selector(click(tap:)))
        startCity.addOnClickListener(target: self, action: #selector(parametersClick(tap:)))
        arriveCity.addOnClickListener(target: self, action: #selector(parametersClick(tap:)))
        startDateTextField.delegate = self
        arriveDateTextField.delegate = self
    }
    
    func fillDataSources(searchCondition:TrainSearchConditionModel)  {
        startCity.text = searchCondition.fromStationName
        arriveCity.text  = searchCondition.toStationName
        
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone?
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let attrStartDate = NSMutableAttributedString()
        let startDate:Date =  formatter.date(from: searchCondition.departureDateFormat)!
        let arriveDate:Date = formatter.date(from: searchCondition.returnDateFormat)!
        let startMonth = NSAttributedString.init(string:startDate.string(custom: "M月d日"), attributes: [NSForegroundColorAttributeName : TBIThemePrimaryTextColor, NSFontAttributeName : UIFont.systemFont(ofSize: 20)])
        let startWeek = NSAttributedString.init(string: startDate.string(custom: "EEE"), attributes: [NSForegroundColorAttributeName : TBIThemeMinorTextColor, NSFontAttributeName : UIFont.systemFont(ofSize: 14)])
        attrStartDate.append(startMonth)
        attrStartDate.append(startWeek)
       startDateTextField.attributedText = attrStartDate
        
        let attrArriveDate = NSMutableAttributedString()
        let arriveMonth = NSAttributedString.init(string:arriveDate.string(custom: "M月d日"), attributes: [NSForegroundColorAttributeName : TBIThemePrimaryTextColor, NSFontAttributeName : UIFont.systemFont(ofSize: 20)])
        let arriveWeek = NSAttributedString.init(string: arriveDate.string(custom: "EEE"), attributes: [NSForegroundColorAttributeName : TBIThemeMinorTextColor, NSFontAttributeName : UIFont.systemFont(ofSize: 14)])
        attrArriveDate.append(arriveMonth)
        attrArriveDate.append(arriveWeek)
        arriveDateTextField.attributedText = attrArriveDate
        
        
    }
    
    
    
    
    
    //参数点击事件
    func parametersClick(tap:UITapGestureRecognizer){
        let vi = tap.view as! UILabel
        switch vi {
        case startCity:
            parametersTypeBlock!(FlightSearchView.ParametersType.startCity)
        case arriveCity:
            parametersTypeBlock!(FlightSearchView.ParametersType.arriveCity)
        case startDateTextField:
            parametersTypeBlock!(FlightSearchView.ParametersType.startDate)
        case arriveDateTextField:
            parametersTypeBlock!(FlightSearchView.ParametersType.arriveDate)

        default:
            return
        }
    }
    
    func oneWayClick(tap:UITapGestureRecognizer){
        self.companySearchOneWayView()
        self.type = 0
        //searchTypeBlock!(false)
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
            self.headerView.bgImg.frame.origin.x = self.headerView.oneWay.frame.origin.x
        }, completion: { (finished) -> Void in
            self.headerView.oneWay.textColor = TBIThemePrimaryTextColor
            self.headerView.roundTrip.textColor = TBIThemeWhite
            
        })
    }
    
    func roundTripClick(tap:UITapGestureRecognizer){
        self.companySearchRoundTripView()
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
            self.headerView.bgImg.frame.origin.x = self.headerView.roundTrip.frame.origin.x
        }, completion: { (finished) -> Void in
            self.headerView.oneWay.textColor = TBIThemeWhite
            self.headerView.roundTrip.textColor = TBIThemePrimaryTextColor
        })
        self.type = 1
        //searchTypeBlock!(true)
    }
    
    //header点击事件
    func click(tap:UITapGestureRecognizer){
        let vi = tap.view
        if vi == trainCycle{
            
            let tmpStartCity:String = startCity.text ?? ""
            let tmpArriveCity:String = arriveCity.text ?? ""
            startCity.text = tmpArriveCity
            arriveCity.text = tmpStartCity
            UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
                self.trainCycle.transform = self.trainCycle.transform.rotated(by: CGFloat(Double.pi/1.0))
            }, completion: { (finished) -> Void in
               
            })
            searchTypeBlock!(true)
        }
        
        
    }

    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        switch textField {
        case startCity:
            parametersTypeBlock!(FlightSearchView.ParametersType.startCity)
        case arriveCity:
            parametersTypeBlock!(FlightSearchView.ParametersType.arriveCity)
        case startDateTextField:
            parametersTypeBlock!(FlightSearchView.ParametersType.startDate)
        case arriveDateTextField:
            parametersTypeBlock!(FlightSearchView.ParametersType.arriveDate)
        default:
            return
        }
        
    }
}

class CoGoBackHeaderView: UIView{
    
    let  bgView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWindowWidth - 10, height: 40))
    
    let  bgImg:UIImageView = UIImageView()
    
    //单程
    let  oneWay = UILabel(text:NSLocalizedString("flight.one.way", comment: "单程"), color: TBIThemeWhite, size: 16)
    //往返
    let  roundTrip = UILabel(text:NSLocalizedString("flight.round.trip", comment: "往返"), color:TBIThemeWhite, size: 16)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initView (){
        self.backgroundColor = UIColor.clear
        bgView.addCorner(byRoundingCorners: [UIRectCorner.topLeft, UIRectCorner.topRight], radii: 3)
        bgView.backgroundColor = TBIThemeBackgroundViewColor
        addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(40)
        }
        bgImg.image = UIImage(named: "ic_car_pickup")?.resizableImage(withCapInsets: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 15), resizingMode: UIImageResizingMode.stretch)
        addSubview(bgImg)
        bgImg.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
            //make.bottom.equalTo(1)
            make.width.equalTo((ScreenWindowWidth - 10)/2)
        }
        oneWay.textColor =  TBIThemePrimaryTextColor
        oneWay.textAlignment = .center
        addSubview(oneWay)
        oneWay.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview()
            make.width.equalTo((ScreenWindowWidth - 10)/2)
            make.top.equalTo(5)
        }
        roundTrip.textAlignment = .center
        addSubview(roundTrip)
        roundTrip.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview()
            make.width.equalTo((ScreenWindowWidth - 10)/2)
            make.top.equalTo(5)
        }
        
    }
    
    
}
