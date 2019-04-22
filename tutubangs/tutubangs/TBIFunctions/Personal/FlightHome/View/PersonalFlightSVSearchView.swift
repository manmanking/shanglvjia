//
//  PersonalFlightSVSearchView.swift
//  shanglvjia
//
//  Created by tbi on 2018/8/3.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import SwiftDate
import IQKeyboardManagerSwift

class PersonalFlightSVSearchView: UIView ,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate{

    public var flightSearchViewType:FlightCommonSearchViewENUM = FlightCommonSearchViewENUM.Default
    
    // 传递 搜索 页面 所有的 参数 修改
    typealias FlightSVSearchViewServicesParametersTypeBlock = (FlightSVSearchViewServicesType,NSInteger) ->Void
    
    public var flightSVSearchViewServicesParametersTypeBlock:FlightSVSearchViewServicesParametersTypeBlock!
    
    //单程往返切换
    // typealias SearchTypeBlock = (Bool) ->Void
    
    /// 将交换的  起始机场
    typealias FlightSVSearchViewExchangeAddressPointBlock = (NSInteger)->Void
    
    public var flightSVSearchViewExchangeAddressPointBlock:FlightSVSearchViewExchangeAddressPointBlock!
    
    /// 机票 行程 类型  即 单程  往返 类型
    typealias FlightSVSearchViewServicesRouterTypeBlock = (FlightServicesRouteType,NSInteger)->Void
    
    public var flightSVSearchViewServicesRouterTypeBlock:FlightSVSearchViewServicesRouterTypeBlock!
    
    /// 多程 添加一程
    typealias FlightSVSearchViewMoreTripAddTripBlock = (String)->Void
    
    public var flightSVSearchViewMoreTripAddTripBlock:FlightSVSearchViewMoreTripAddTripBlock!
    
    
    typealias FlightSVSearchViewMoreTripDeleteTripBlock = (NSInteger)->Void
    
    public var flightSVSearchViewMoreTripDeleteTripBlock:FlightSVSearchViewMoreTripDeleteTripBlock!
    
    
    
    /// 搜索 按钮的 方法
    typealias FlightSVSearchViewSearchBlock = (String)->Void
    
    public var flightSVSearchViewSearchBlock:FlightSVSearchViewSearchBlock!
    
    //public var searchTypeBlock:SearchTypeBlock?
    
    /// 基础背景  容器
    private let baseBackgroundView:UIView = UIView()
    
    private let whiteBaseBackgroundView:UIView = UIView()
    
    /// 子基础 背景  容器
    private let subBaseBackgroundView:UIView = UIView()
    
    /// 行程 类型 背景  容器
    private let routeBaseBackgroundView:UIView = UIView()
    
    /// 行程 类型 子背景  容器
    private let routeSubbaseBackgroundView:UIView = UIView()
    
    /// 行程 类型 选中 标记
    private let routeSelectedFlagImageView:UIImageView = UIImageView()
    
    //单程
    private let  oneWayLabel:UILabel = UILabel()
    
    private let oneWayTipDefault:String = "单程"
    
    private let roundTripTipDefault:String = "往返"
    
//    private let moreTripTipDefault:String = "多程"
    //往返ewsasaa
    private let  roundTripLabel:UILabel = UILabel()
    
    //多程
//    private let  moreRoundTripLabel:UILabel = UILabel()
    
    /// 地址 背景  容器
    private let addressBaseBackgroundView:UIView = UIView()
    
    //转
    private let  flightCycleImageView:UIImageView = UIImageView()
    //飞机
    private let  flightPlaneImageView:UIImageView = UIImageView()
    
    private let  flightStartPointTextField:UITextField = UITextField()
    
    
    private let  flightEndPointTextField:UITextField = UITextField()
    
    private let startAirPortTipDefault:String =  ""//"天津滨海机场"
    
    private let startAirPortPlaceholderTipDefault:String = "起飞机场"
    
    private let endAirPortTipDefault:String =  ""// "上海虹桥机场"
    
    private let endAirPortPlaceholderTipDefault:String = "到达机场"
    
    /// 日期 背景  容器
    private let dayBaseBackgroundView:UIView = UIView()
    
    private let daySubbaseLeftBackgroundView:UIView = UIView()
    
    /// 单程  右侧 起飞 时间 背景 容器
    //private let daySubbaseRightHourBackgroundView:UIView = UIView()
    
    /// 起飞时间
    private let  startDayLabel:UILabel = UILabel()
    
    /// 起飞时间 周值
    private var startDayWeekLabel:UILabel = UILabel()
    
    
    /// 返程 起飞 日期 背景 容器
    private let daySubbaseRightDateBackgroundView:UIView = UIView()
    
    /// 到达时间
    private let  endDayLebl:UILabel = UILabel()
    /// 到达时间 周值
    private var endDayWeekLabel:UILabel = UILabel()
    
    private let daySubbaseRightDateWeekBackgroundView:UIView = UIView()
    
    /// 起飞日期  时间
    private let  startDayRightHourLebl:UILabel = UILabel()
    
    
    /// 期望时间 背景  容器
    //private let hourBaseBackgroundView:UIView = UIView()
    
    private let hourStartHourLabel:UILabel = UILabel()
    
    private let hourEndHourLabel:UILabel = UILabel()
    
    private let searchButton:UIButton = UIButton()
    
    
    
    //当前是单程还是往返 多程
    private var flightServicesRouteType:FlightServicesRouteType = FlightServicesRouteType.OneWay
    
    //
    private var flightServicesViewType:FlightServicesViewType = FlightServicesViewType.Default
    
    // 添加多程
    
    private let moreTripTableView:UITableView = UITableView()
    
    private let tableViewCustomCellIdentify:String = "tableViewCustomCellIdentify"
    private let tableViewNormalCellIdentify:String = "tableViewNormalCellIdentify"
    private let tableViewAddCellIdentify:String = "tableViewAddCellIdentify"
    
    private let tableViewAddCellHeight:NSInteger = 44
    
    private var moreTripChangeCellIndex:NSInteger = 0
    
    
    
    /// 记录动画的 是否为第一次
    private var routeTripDateAnimationTime:NSInteger = 1
    
    
    //
    private var tableViewDataSources:[FlightSVSearchConditionModel] = Array()
    
    
    var showTime:Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        subBaseBackgroundView.layer.cornerRadius = 3
        subBaseBackgroundView.clipsToBounds = true
        baseBackgroundView.addSubview(subBaseBackgroundView)
        subBaseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        self.baseBackgroundView.layoutIfNeeded()
        print(#function,#line,subBaseBackgroundView)
        //fillLocalDataSources()
        setUIViewAutolayout()
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUIViewAutolayout() {
        
        //航段信息
        subBaseBackgroundView.addSubview(routeBaseBackgroundView)
        routeBaseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(47)
        }
        setRouteBaseBackgroundViewAutolayout()
        whiteBaseBackgroundView.backgroundColor = TBIThemeWhite
        subBaseBackgroundView.addSubview(whiteBaseBackgroundView)
        whiteBaseBackgroundView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(45)
            make.left.right.equalToSuperview().inset(5)
            make.bottom.equalToSuperview()
        }
        
        //机场信息
        subBaseBackgroundView.addSubview(addressBaseBackgroundView)
        addressBaseBackgroundView.snp.makeConstraints { (make) in
            make.top.equalTo(routeBaseBackgroundView.snp.bottom).inset(2)
            make.left.right.equalToSuperview()
            make.height.equalTo(55)
        }
        
        setAddressBaseBackgroundViewAutolayout()
        //日期 信息
        subBaseBackgroundView.addSubview(dayBaseBackgroundView)
        dayBaseBackgroundView.snp.makeConstraints { (make) in
            make.top.equalTo(addressBaseBackgroundView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(55)
        }
        setDayBaseBackgroundViewAutolayout()
        dayBaseBackgroundView.addSubview(daySubbaseRightDateWeekBackgroundView)
        daySubbaseRightDateWeekBackgroundView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(2)
            make.right.equalToSuperview().offset(ScreenWindowWidth/2)
            make.bottom.equalToSuperview().inset(2)
            make.width.equalToSuperview().dividedBy(2)
        }
        setDaySubbaseRightDateBackgroundViewAutolayout()
        
        searchButton.setTitle("查询", for: UIControlState.normal)
        searchButton.setTitleColor(TBIThemeWhite, for: UIControlState.normal)
        searchButton.setBackgroundImage(UIImage (named: "yellow_btn_gradient"), for: UIControlState.normal)
        searchButton.clipsToBounds=true
        searchButton.layer.cornerRadius = 5
        searchButton.addTarget(self, action: #selector(searchButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        subBaseBackgroundView.addSubview(searchButton)
        searchButton.snp.remakeConstraints { (make) in
            make.top.equalTo(dayBaseBackgroundView.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(47)
        }
        setTableViewAutolayout()
        
    }
    
    //设置tableView 布局
    func setTableViewAutolayout() {
        
        moreTripTableView.delegate = self
        moreTripTableView.dataSource = self
        moreTripTableView.isScrollEnabled = false
        moreTripTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        moreTripTableView.register(PersonalFlightSearchTVTableViewCell.classForCoder(), forCellReuseIdentifier: tableViewCustomCellIdentify)
        moreTripTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: tableViewNormalCellIdentify)
        moreTripTableView.register(MoreTripTableViewAddCell.classForCoder(), forCellReuseIdentifier: tableViewAddCellIdentify)
        self.subBaseBackgroundView.addSubview(moreTripTableView)
        moreTripTableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(45)
            make.left.right.equalToSuperview()
            make.height.equalTo( 110 * tableViewDataSources.count + 80 + tableViewAddCellHeight)
        }
    }
    
    
    
    
    
    override func layoutSubviews() {
        print(#function,#line,subBaseBackgroundView.bounds)
        //subBaseBackgroundView.corner(byRoundingCorners: [UIRectCorner.bottomLeft,UIRectCorner.bottomRight], radii: 2)
    }
    
    /// 设置 行程类型 布局
    private func setRouteBaseBackgroundViewAutolayout() {
        routeSubbaseBackgroundView.backgroundColor = TBIThemeBackgroundViewColor
        routeSubbaseBackgroundView.layer.cornerRadius = 2
        routeBaseBackgroundView.addSubview(routeSubbaseBackgroundView)
        routeSubbaseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(5)
            make.bottom.equalToSuperview()
        }
        routeSelectedFlagImageView.image = UIImage(named: "ic_car_pickup")?
            .resizableImage(withCapInsets: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 15),
                            resizingMode: UIImageResizingMode.stretch)
        routeSelectedFlagImageView.contentMode = UIViewContentMode.scaleToFill
        routeBaseBackgroundView.addSubview(routeSelectedFlagImageView)
        routeSelectedFlagImageView.snp.remakeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().inset(4)
            make.bottom.equalToSuperview().offset(1)
            make.width.equalToSuperview().dividedBy(2)
        }
        oneWayLabel.text = oneWayTipDefault
        oneWayLabel.textAlignment = NSTextAlignment.center
        oneWayLabel.addOnClickListener(target: self, action: #selector(oneWayAction))
        oneWayLabel.font = UIFont.boldSystemFont(ofSize: 16)
        oneWayLabel.textColor = TBIThemePrimaryTextColor
        routeBaseBackgroundView.addSubview(oneWayLabel)
        oneWayLabel.snp.makeConstraints{(make) in
            make.top.left.equalToSuperview().inset(5)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2).inset(4)
        }
        
        roundTripLabel.text = roundTripTipDefault
        roundTripLabel.textAlignment = NSTextAlignment.center
        roundTripLabel.addOnClickListener(target: self, action: #selector(roundTripAction))
        roundTripLabel.font = UIFont.systemFont(ofSize: 16)
        roundTripLabel.textColor = TBIThemeWhite
        routeBaseBackgroundView.addSubview(roundTripLabel)
        roundTripLabel.snp.makeConstraints{(make) in
            make.top.equalToSuperview().inset(5)
            make.bottom.equalToSuperview()
            make.left.equalTo(oneWayLabel.snp.right).offset(8)
            make.width.equalToSuperview().dividedBy(2).inset(4)
        }
//        moreRoundTripLabel.text = moreTripTipDefault
//        moreRoundTripLabel.textAlignment = NSTextAlignment.center
//        moreRoundTripLabel.addOnClickListener(target: self, action: #selector(moreRoundTripAction))
//        moreRoundTripLabel.font = UIFont.systemFont(ofSize: 14)
//        moreRoundTripLabel.textColor = TBIThemeWhite
//        routeBaseBackgroundView.addSubview(moreRoundTripLabel)
//        moreRoundTripLabel.snp.makeConstraints{(make) in
//            make.right.top.equalToSuperview().inset(5)
//            make.bottom.equalToSuperview()
//            make.width.equalToSuperview().dividedBy(3).inset(8)
//        }
        
        
    }
    
    /// 设置 地址 布局
    private func setAddressBaseBackgroundViewAutolayout() {
        flightStartPointTextField.text = startAirPortTipDefault
        flightStartPointTextField.delegate = self
        flightStartPointTextField.font = UIFont.systemFont(ofSize: 18)
        flightStartPointTextField.textAlignment = NSTextAlignment.left
        addressBaseBackgroundView.addSubview(flightStartPointTextField)
        flightStartPointTextField.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(21)
            make.width.equalToSuperview().dividedBy(2).inset(20)
        }
        flightEndPointTextField.text = endAirPortTipDefault
        flightEndPointTextField.delegate = self
        flightEndPointTextField.font = UIFont.systemFont(ofSize: 18)
        flightEndPointTextField.textAlignment = NSTextAlignment.right
        addressBaseBackgroundView.addSubview(flightEndPointTextField)
        flightEndPointTextField.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().inset(21)
            make.width.equalToSuperview().dividedBy(2).inset(20)
        }
        
        flightCycleImageView.image = UIImage.init(named: "Personal_ic_air_change")
        addressBaseBackgroundView.addSubview(flightCycleImageView)
        flightCycleImageView.snp.remakeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(30)
        }
        flightPlaneImageView.image = UIImage.init(named:"Personal_ic_air_to")
        flightPlaneImageView.addOnClickListener(target: self, action: #selector(exchangeAddressPoint))
        addressBaseBackgroundView.addSubview(flightPlaneImageView)
        flightPlaneImageView.snp.remakeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        let bottomLine:UILabel = UILabel()
        bottomLine.backgroundColor = TBIThemeGrayLineColor
        addressBaseBackgroundView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints{(make) in
            make.bottom.equalToSuperview().inset(1)
            make.height.equalTo(0.5)
            make.left.right.equalToSuperview().inset(20)
        }
    }
    
    /// 设置 日期 布局
    private func setDayBaseBackgroundViewAutolayout() {
        
        let bottomLine:UILabel = UILabel()
        bottomLine.backgroundColor = TBIThemeGrayLineColor
        dayBaseBackgroundView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints{(make) in
            make.bottom.equalToSuperview().inset(1)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(0.5)
        }
        daySubbaseLeftBackgroundView.addOnClickListener(target: self, action: #selector(leftStartDateAction))
        dayBaseBackgroundView.addSubview(daySubbaseLeftBackgroundView)
        daySubbaseLeftBackgroundView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(1)
            make.width.equalToSuperview()//.dividedBy(2).inset(10)
        }
        startDayLabel.adjustsFontSizeToFitWidth = true
        startDayLabel.font = UIFont.systemFont(ofSize: 16)
        startDayLabel.addOnClickListener(target: self, action: #selector(startDayAction(sender:)))
        daySubbaseLeftBackgroundView.addSubview(startDayLabel)
        startDayLabel.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        startDayWeekLabel.font = UIFont.systemFont(ofSize: 10)
        startDayWeekLabel.adjustsFontSizeToFitWidth = true
        startDayWeekLabel.textColor = PersonalThemeMinorTextColor
        daySubbaseLeftBackgroundView.addSubview(startDayWeekLabel)
        startDayWeekLabel.snp.makeConstraints { (make) in
            make.left.equalTo(startDayLabel.snp.right).offset(5)
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(11)
        }
        
        
    }
    
    /// 设置返程的日期
    private func setDaySubbaseRightDateBackgroundViewAutolayout() {
        endDayWeekLabel.font = UIFont.systemFont(ofSize: 10)
        endDayWeekLabel.adjustsFontSizeToFitWidth = true
        endDayWeekLabel.textColor = PersonalThemeMinorTextColor
        daySubbaseRightDateWeekBackgroundView.addSubview(endDayWeekLabel)
        endDayWeekLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(11)
        }
        endDayLebl.adjustsFontSizeToFitWidth = true
        endDayLebl.font = UIFont.systemFont(ofSize: 16)
        endDayLebl.addOnClickListener(target: self, action: #selector(endDayAction(sender:)))
        daySubbaseRightDateWeekBackgroundView.addSubview(endDayLebl)
        endDayLebl.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.right.equalTo(endDayWeekLabel.snp.left).inset(-5)
            make.height.equalTo(18)
        }
    }
    
    private func onewayAnimation() {
        weak var weakSelf = self
        print(#function,#line,flightServicesRouteType)
        if flightSVSearchViewServicesRouterTypeBlock != nil {
            flightSVSearchViewServicesRouterTypeBlock(flightServicesRouteType,tableViewDataSources.count)
        }
        adjustFlightSVSearchView(type: flightServicesViewType)
        UIView.animate(withDuration:0.3, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
            
            switch weakSelf?.flightServicesRouteType {
            case .OneWay?:
                let selectImage = UIImage(named:"ic_car_pickup")
                weakSelf?.routeSelectedFlagImageView.image = selectImage
                weakSelf?.routeSelectedFlagImageView.snp.remakeConstraints({ (make) in
                    make.top.equalToSuperview()
                    make.left.equalToSuperview().inset(4)
                    make.bottom.equalToSuperview().offset(1)
                    make.width.equalToSuperview().dividedBy(2)
                })
                weakSelf?.layoutIfNeeded()
            case .RoundTrip?:
                let selectImage = UIImage(named:"ic_car_pickup")
                //翻转图片的方向
                let flipImageOrientation = ((selectImage?.imageOrientation.rawValue)! + 4) % 8
                let flipImage =  UIImage.init(cgImage: (selectImage?.cgImage)!, scale: (selectImage?.scale)!, orientation: UIImageOrientation(rawValue: flipImageOrientation)!)
                 weakSelf?.routeSelectedFlagImageView.image = flipImage
                weakSelf?.routeSelectedFlagImageView.snp.remakeConstraints({ (make) in
                    make.top.equalToSuperview()
                    make.bottom.equalToSuperview().offset(1)
                    make.right.equalToSuperview().inset(4)
                    make.width.equalToSuperview().dividedBy(2)
                })
                weakSelf?.layoutIfNeeded()
            case .MoreTrip?:
                weakSelf?.routeSelectedFlagImageView.snp.remakeConstraints({ (make) in
                    make.top.equalToSuperview()
                    make.right.equalToSuperview().inset(5)
                    make.bottom.equalToSuperview().offset(1)
                    make.width.equalToSuperview().dividedBy(2)
                })
                weakSelf?.layoutIfNeeded()
            case .none:
                break
            }
        }, completion: { (finished) -> Void in
            
            switch weakSelf?.flightServicesRouteType {
            case .OneWay?:
                weakSelf?.oneWayLabel.textColor = TBIThemePrimaryTextColor
                weakSelf?.oneWayLabel.font = UIFont.boldSystemFont(ofSize: 16)
                weakSelf?.roundTripLabel.textColor = TBIThemeWhite
                weakSelf?.roundTripLabel.font = UIFont.systemFont(ofSize: 16)
//                weakSelf?.moreRoundTripLabel.textColor = TBIThemeWhite
            case .RoundTrip?:
                weakSelf?.oneWayLabel.textColor = TBIThemeWhite
                weakSelf?.oneWayLabel.font = UIFont.systemFont(ofSize: 16)
                weakSelf?.roundTripLabel.textColor = TBIThemePrimaryTextColor
                weakSelf?.roundTripLabel.font = UIFont.boldSystemFont(ofSize: 16)
//                weakSelf?.moreRoundTripLabel.textColor = TBIThemeWhite
            case .MoreTrip?:
                weakSelf?.oneWayLabel.textColor = TBIThemeWhite
                weakSelf?.roundTripLabel.textColor = TBIThemeWhite
                weakSelf?.roundTripLabel.font = UIFont.systemFont(ofSize: 16)
                weakSelf?.oneWayLabel.font = UIFont.systemFont(ofSize: 16)
//                weakSelf?.moreRoundTripLabel.textColor = TBIThemePrimaryTextColor
            case .none:
                break
            }
        })
    }
    
    private func cycleAnmation() {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3) //设置动画时间
        flightCycleImageView.transform = flightCycleImageView.transform.rotated(by: CGFloat(Double.pi/1.0))
        UIView.commitAnimations()
    }
    
    
    ///MARK:------ 平移出去
    func viewTranslationAnmation(view:UIView) {
        guard routeTripDateAnimationTime != 1 else{
            routeTripDateAnimationTime = 0
            return
        }
        //routeTripDateAnimationFlag == false  &&
        if  flightServicesRouteType == FlightServicesRouteType.OneWay{//判断是不是第一次切换
            UIView.animate(withDuration: 0.3, animations: {
                view.center = CGPoint.init(x: ScreenWindowWidth * 1.5, y: view.center.y)
            })
        } else if  flightServicesRouteType == FlightServicesRouteType.RoundTrip{ //routeTripDateAnimationFlag == true  &&
            UIView.animate(withDuration: 0.3, animations: {
                view.center = CGPoint.init(x: ScreenWindowWidth * 0.75, y: view.center.y)
            })
        }
        
        
    }
    
    
    
    
    private func flightServicesDefTakeOffTimeTypeView(){
        
        subBaseBackgroundView.insertSubview(moreTripTableView, belowSubview: whiteBaseBackgroundView)
        if flightServicesRouteType == FlightServicesRouteType.OneWay {
            viewTranslationAnmation(view: daySubbaseRightDateWeekBackgroundView)
            searchButton.snp.remakeConstraints({ (make) in
                make.top.equalTo(dayBaseBackgroundView.snp.bottom).offset(30)
                make.left.right.equalToSuperview().inset(20)
                make.height.equalTo(47)
            })
            
        }else if flightServicesRouteType == FlightServicesRouteType.RoundTrip {
            //if daySubbaseRightDateWeekBackgroundView.isHidden == true {
            //daySubbaseRightDateWeekBackgroundView.isHidden = false
            viewTranslationAnmation(view: daySubbaseRightDateWeekBackgroundView)
            searchButton.snp.remakeConstraints({ (make) in
                make.top.equalTo(dayBaseBackgroundView.snp.bottom).offset(30)
                make.left.right.equalToSuperview().inset(20)
                make.height.equalTo(47)
            })
            //}
        }else if flightServicesRouteType == FlightServicesRouteType.MoreTrip {
            self.subBaseBackgroundView.bringSubview(toFront: moreTripTableView)
        }
        
    }
    func flightServicesDefaultView() {
        
        if flightServicesRouteType == FlightServicesRouteType.OneWay {
            if daySubbaseRightDateWeekBackgroundView.isHidden == false {
                daySubbaseRightDateWeekBackgroundView.isHidden = true
            }
        }else if flightServicesRouteType == FlightServicesRouteType.RoundTrip {
            if daySubbaseRightDateWeekBackgroundView.isHidden == true {
                daySubbaseRightDateWeekBackgroundView.isHidden = false
            }
        }
        searchButton.snp.remakeConstraints({ (make) in
            make.top.equalTo(dayBaseBackgroundView.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(47)
        })
    }
    
    
    
    //MARK:-----------UItableViewDataSources-----------
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewDataSources.count + 2
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:PersonalFlightSearchTVTableViewCell = tableView
            .dequeueReusableCell(withIdentifier: tableViewCustomCellIdentify) as! PersonalFlightSearchTVTableViewCell
        var isShowDelete:Bool = false
        if tableViewDataSources.count > 2 {
            isShowDelete = true
        }
        
        if tableViewDataSources.count > indexPath.row {
            cell.fillDataSources(flightModel: tableViewDataSources[indexPath.row], index: indexPath.row, isShowDelete: isShowDelete)
            weak var weakSelf = self
            cell.flightSearchTVTableViewCellExchangeAddressPointBlock = { (_ , cellIndex) in
                weakSelf?.moreTripChangeCellIndex = cellIndex
                weakSelf?.exchangeAddressPoint()
            }
            cell.flightSearchTVTableViewCellServicesParametersTypeBlock = {(servicesType,cellIndex) in
                weakSelf?.moreTripChangeCellIndex = cellIndex
                weakSelf?.flightSVSearchViewServicesParametersTypeBlock(servicesType,cellIndex)
            }
            cell.flightSearchTVTableViewCellDeleteBlock = { (_ ,cellIndex) in
                
                weakSelf?.flightSVSearchViewMoreTripDeleteTripBlock(cellIndex)
            }
        }
        
        
        if tableViewDataSources.count  == indexPath.row {
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: tableViewNormalCellIdentify)!
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            let moreTripSubmitButton:UIButton = UIButton()
            moreTripSubmitButton.setBackgroundImage(UIImage (named: "yellow_btn_gradient"), for: UIControlState.normal)
            moreTripSubmitButton.clipsToBounds=true
            moreTripSubmitButton.layer.cornerRadius = 4
            moreTripSubmitButton.setTitle("查询", for: UIControlState.normal)
            moreTripSubmitButton.addTarget(self, action: #selector(searchButtonAction(sender:)), for: UIControlEvents.touchUpInside)
            cell.contentView.addSubview(moreTripSubmitButton)
            moreTripSubmitButton.snp.makeConstraints({ (make) in
                make.centerY.equalToSuperview()
                make.left.right.equalToSuperview().inset(20)
                make.height.equalTo(47)
            })
            
            return cell
        }
        if tableViewDataSources.count + 1  == indexPath.row  {
            let cell:MoreTripTableViewAddCell = tableView
                .dequeueReusableCell(withIdentifier: tableViewAddCellIdentify)! as! PersonalFlightSVSearchView.MoreTripTableViewAddCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.fillDataSources(title: "再加一程(最多同时预订4个航段)")
            return cell
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableViewDataSources.count == indexPath.row {
            return 80
        }
        if tableViewDataSources.count + 1 == indexPath.row {
            return CGFloat(tableViewAddCellHeight)
        }
        return 55 * 2
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableViewDataSources.count + 1 == indexPath.row  && tableViewDataSources.count < 4{
            if tableViewDataSources.last?.arriveAirportName.isEmpty == true ||
                tableViewDataSources.last?.arriveAirportName == endAirPortPlaceholderTipDefault
            {
                let count:NSInteger = tableViewDataSources.count
                showSystemAlertView(title: "提示", message: "请完善第\(count.description)程的到达机场")
                return
            }
            moreTripAddTripAction()
        }
    }
    
    
    func moreTripAddTripAction() {
        if flightSVSearchViewMoreTripAddTripBlock != nil {
            flightSVSearchViewMoreTripAddTripBlock("再加一程")
        }
        onewayAnimation()
        
    }
    
    func showSystemAlertView(title:String,message:String) {
        
        let alertView = UIAlertView.init(title: title, message: message, delegate: self, cancelButtonTitle: "确定")
        alertView.show()
    }
    
    enum FlightServicesRouteType:NSInteger {
        case OneWay = 0
        case RoundTrip = 1
        case MoreTrip = 2
    }
    
    enum FlightServicesViewType:String{
        case LowPriceView = "LowPriceView"
        case DefTakeOffTime = "DefTakeOffTime"
        case Default = "Default"
    }
    
    //MARK:-------------getter setter----------
    
    /// 获取 机票 服务类型
    public func getFlightServicesRouteType() ->FlightServicesRouteType {
        return flightServicesRouteType
    }
    
    
    
    
    //MARK:-------------fillDataSources----------
    
    // add by manman on 2018-03-22 //,defTakeOffStartHour:String,defLandingStartHour:String
    public func fillMoreTripDataSources(dataSoureces:[FlightSVSearchConditionModel]) {
        
        
        if  flightSearchViewType != .Default {
            setRebookCommonFlightSearchView()
        }
        // 首先 将 单程 和往返 写入数据
        
        if dataSoureces.first?.takeOffAirportName != nil && dataSoureces.first?.takeOffAirportName.isEmpty == false {
            flightStartPointTextField.text = dataSoureces.first?.takeOffAirportName
        }else
        {
            flightStartPointTextField.text = startAirPortTipDefault
        }
        //到达机场
        if dataSoureces.first?.arriveAirportName != nil && dataSoureces.first?.arriveAirportName.isEmpty == false{
            flightEndPointTextField.text = dataSoureces.first?.arriveAirportName
        }else
        {
            flightEndPointTextField.text = endAirPortTipDefault
        }
        
        
        let formatter:DateFormatter = DateFormatter()
        formatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone?
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        
        if  dataSoureces.first?.departureDate != 0 {
            let departureDate:Date = formatter.date(from: (dataSoureces.first?.departureDateFormat)!)!
            startDayLabel.text = departureDate.string(custom:"MM月dd日")
            startDayWeekLabel.text = departureDate.string(custom: "EEE")
        }
        if  dataSoureces.first?.returnDate != 0 {
            let returnDate:Date = formatter.date(from: (dataSoureces.first?.returnDateFormat)!)!
            endDayLebl.text = returnDate.string(custom: "MM月dd日")
            endDayWeekLabel.text = returnDate.string(custom: "EEE")
         
        }
        
        // 多程 写入 数据
        tableViewDataSources = dataSoureces
        moreTripTableView.snp.remakeConstraints({ (remake) in
            remake.top.equalToSuperview().inset(45)
            remake.left.right.equalToSuperview()
            remake.height.equalTo( 110 * tableViewDataSources.count + 80 + tableViewAddCellHeight)
        })
        moreTripTableView.reloadData()
    }
    
    
    func setRebookCommonFlightSearchView() {
        routeBaseBackgroundView.isUserInteractionEnabled = false
        addressBaseBackgroundView.isUserInteractionEnabled = false
        
    }
    
    
    
    public func adjustFlightSVSearchView(type:FlightServicesViewType){
        flightServicesViewType = type
        switch type {
        case .DefTakeOffTime:
            flightServicesDefTakeOffTimeTypeView()
        case .LowPriceView:
            flightServicesDefaultView()
        case .Default:
            flightServicesDefaultView()
        }
    }
    
    
    
    
    //MARK:------------UITextFieldDelegate ------------
    // 起飞 到达 机场 修改
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        
        switch textField {
        case flightStartPointTextField:
            print(#function,#line)
            flightSVSearchViewServicesParametersTypeBlock!(FlightSVSearchViewServicesType.startCity,0)
        case flightEndPointTextField:
            print(#function,#line)
            flightSVSearchViewServicesParametersTypeBlock!(FlightSVSearchViewServicesType.arriveCity,0)
        default:
            break
        }
        
        return false
    }
    @objc private func startDayAction(sender:UITapGestureRecognizer) {
        changeValue(sender: sender)
    }
    @objc private func endDayAction(sender:UITapGestureRecognizer) {
        changeValue(sender: sender)
    }
    @objc private func startDayRightHourAction(sender:UITapGestureRecognizer) {
        changeValue(sender: sender)
    }
    @objc private func hourStartHourAction(sender:UITapGestureRecognizer) {
        changeValue(sender: sender)
    }
    @objc private func hourEndHourAction(sender:UITapGestureRecognizer) {
        changeValue(sender: sender)
    }
    
    @objc private func changeValue(sender:UITapGestureRecognizer) {
        let tmpLabel:UILabel = sender.view as! UILabel
        var index = 0
        switch flightServicesRouteType {
        case .OneWay,.RoundTrip:
            index = 0
        case .MoreTrip:
            index = moreTripChangeCellIndex
        default:
            index = 0
        }
        
        switch tmpLabel {
        case startDayLabel:
            flightSVSearchViewServicesParametersTypeBlock(FlightSVSearchViewServicesType.startDate,index)
            break
        case endDayLebl:
            flightSVSearchViewServicesParametersTypeBlock(FlightSVSearchViewServicesType.arriveDate,index)
            break
        case startDayRightHourLebl:
            flightSVSearchViewServicesParametersTypeBlock(FlightSVSearchViewServicesType.startTime,index)
            break
        case hourStartHourLabel:
            flightSVSearchViewServicesParametersTypeBlock(FlightSVSearchViewServicesType.startTime,index)
            break
        case hourEndHourLabel:
            flightSVSearchViewServicesParametersTypeBlock(FlightSVSearchViewServicesType.arriveTime,index)
            break
            
        default:
            break
        }
    }
    
    
    func leftStartDateAction() {
        var index = 0
        switch flightServicesRouteType {
        case .OneWay,.RoundTrip:
            index = 0
        case .MoreTrip:
            index = moreTripChangeCellIndex
        default:
            index = 0
        }
        flightSVSearchViewServicesParametersTypeBlock(FlightSVSearchViewServicesType.startDate,index)
    }
    
    
    
    //MARK:---------------Action-----------------
    
    /// 单程
    func oneWayAction(){
        guard flightServicesRouteType != FlightServicesRouteType.OneWay else { return }
        moreTripChangeCellIndex = 0
        flightServicesRouteType = FlightServicesRouteType.OneWay
        onewayAnimation()
    }
    
    /// 往返
    func roundTripAction(){
        guard flightServicesRouteType != FlightServicesRouteType.RoundTrip else { return }
        flightServicesRouteType = FlightServicesRouteType.RoundTrip
        moreTripChangeCellIndex = 0
        routeTripDateAnimationTime = 0
        
        onewayAnimation()
        
    }
    /// 多程
//    func moreRoundTripAction(){
//        guard flightServicesRouteType != FlightServicesRouteType.MoreTrip else { return }
//        flightServicesRouteType = FlightServicesRouteType.MoreTrip
//        moreTripChangeCellIndex = 0
//        onewayAnimation()
//        //add by manman on 2018-03-22  添加更新数据
//        // 由于原来存在全局变量 现在 将 每次都需要同部署
//        moreTripTableView.reloadData()
//
//    }
    // 起始位置 互换
    func exchangeAddressPoint()  {
        
        guard flightStartPointTextField.text?.isEmpty  == false || flightEndPointTextField.text?.isEmpty == false else { return }
        
        if  flightSVSearchViewExchangeAddressPointBlock != nil {
            flightSVSearchViewExchangeAddressPointBlock(moreTripChangeCellIndex)
            cycleAnmation()
        }
        
    }
    /// 搜索
    func searchButtonAction(sender:UIButton) {
        
        var isSuccess:Bool = false
        if flightServicesRouteType == FlightServicesRouteType.MoreTrip {
            
            for element in tableViewDataSources {
                if element.arriveAirportCode.isEmpty == true || element.takeOffAirportCode.isEmpty == true {
                    isSuccess = true
                    break
                }
            }
        }
        
        for element in tableViewDataSources {
            if element.arriveAirportCode ==  element.takeOffAirportCode{
                showSystemAlertView(title: "提示", message: "出发机场与到达机场不能相同")
                return
            }
        }
        if isSuccess {
            showSystemAlertView(title: "提示", message: "请完善机场信息")
            return
        }
        
        if flightServicesRouteType == FlightServicesRouteType.MoreTrip
        {
            for i in 0...tableViewDataSources.count-2
            {
                if CommonTool.stamp(to: tableViewDataSources[i+1].departureDate.description, withFormat: "yyyy-MM-dd") < CommonTool.stamp(to: tableViewDataSources[i].departureDate.description, withFormat: "yyyy-MM-dd")
                {
                    showSystemAlertView(title: "提示", message: "后一程日期不能早于前一程日期")
                    return
                }
            }
        }
        
        
        if DEBUG { print(#function,#line) }
        if flightSVSearchViewSearchBlock != nil
        {
            flightSVSearchViewSearchBlock("search Action")
        }
    }
    
    
    
    
    class MoreTripTableViewAddCell: UITableViewCell {
        
        let baseBackgroundView:UIView = UIView()
        
        let addFlagImageView:UIImageView = UIImageView()
        
        let titleLabel:UILabel = UILabel()
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.contentView.addSubview(baseBackgroundView)
            self.contentView.backgroundColor = TBIThemeBaseColor
            baseBackgroundView.backgroundColor = TBIThemeWhite
            baseBackgroundView.layer.cornerRadius = 2
            baseBackgroundView.snp.makeConstraints { (make) in
                make.top.equalToSuperview().inset(5)
                make.left.bottom.right.equalToSuperview()
            }
            
            addFlagImageView.image = UIImage.init(named: "ic_add")
            baseBackgroundView.addSubview(addFlagImageView)
            addFlagImageView.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().inset(5)
                make.width.height.equalTo(20)
            }
            titleLabel.font = UIFont.systemFont(ofSize: 12)
            titleLabel.textColor = PersonalThemeMajorTextColor
            baseBackgroundView.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.left.equalTo(addFlagImageView.snp.right).offset(5)
                make.right.equalToSuperview()
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        public func fillDataSources(title:String) {
            titleLabel.text = title
        }
        
    }
    
    enum FlightSVSearchViewServicesType : NSInteger {
        case startCity  = 1 //开始城市
        case arriveCity = 2 //到达城市
        case startDate  = 3 //开始日期
        case arriveDate = 4 //到达日期
        case startTime  = 5 //开始时间
        case arriveTime = 6 //到达时间
    }

}
