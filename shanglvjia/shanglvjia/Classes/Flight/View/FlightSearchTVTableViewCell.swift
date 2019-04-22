//
//  FlightSearchTVTableViewCell.swift
//  shanglvjia
//
//  Created by manman on 2018/3/20.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import SwiftDate

class FlightSearchTVTableViewCell: UITableViewCell {
    
    
    typealias FlightSearchTVTableViewCellServicesParametersTypeBlock = (FlightSVSearchView.FlightSVSearchViewServicesType,NSInteger) ->Void
    
    public var flightSearchTVTableViewCellServicesParametersTypeBlock:FlightSearchTVTableViewCellServicesParametersTypeBlock!
    
    
    typealias FlightSearchTVTableViewCellExchangeAddressPointBlock = (String,NSInteger)->Void
    
    public var flightSearchTVTableViewCellExchangeAddressPointBlock:FlightSearchTVTableViewCellExchangeAddressPointBlock!
    
    typealias FlightSearchTVTableViewCellDeleteBlock = (String,NSInteger)->Void
    
    public var flightSearchTVTableViewCellDeleteBlock:FlightSearchTVTableViewCellDeleteBlock!
    
    private var cellIndex:NSInteger = 0
    
    /// 基础背景  容器
    private let baseBackgroundView:UIView = UIView()
    
    private let subBaseBackgroundView:UIView = UIView()
    
    /// 地址 背景  容器
    private let addressBaseBackgroundView:UIView = UIView()
    
    private let deleteTripButton:UIButton = UIButton()
    
    //转
    private let  flightCycleImageView:UIImageView = UIImageView()
    //飞机
    private let  flightPlaneImageView:UIImageView = UIImageView()
    
    private let  flightStartPointLabel:UILabel = UILabel()
    
    private let  flightEndPointLabel:UILabel = UILabel()
    
    private let startAirPortTipDefault:String = "天津滨海机场"
    
    private let endAirPortTipDefault:String = "上海虹桥机场"
    
    private let startAirPortPlaceholderTipDefault:String = "起飞机场"
    
    private let endAirPortPlaceholderTipDefault:String = "到达机场"
    
    /// 日期 背景  容器
    private let dateBaseBackgroundView:UIView = UIView()
    
    private let dateSubbaseLeftBackgroundView:UIView = UIView()
    
    /// 单程  右侧 起飞 时间 背景 容器
    private let dateSubbaseRightHourBackgroundView:UIView = UIView()
    
    /// 起飞时间
    private let startDateDayLabel:UILabel = UILabel()
    
    /// 起飞时间 周值
    private var startDateWeekLabel:UILabel = UILabel()
    
    /// 起飞日期  时间
    private let startDayRightHourLebl:UILabel = UILabel()
    
    /// 期望时间 背景  容器
    private let hourBaseBackgroundView:UIView = UIView()
    
    private let hourStartHourLabel:UILabel = UILabel()
    
    ///  航段 标记
    private let showTripLebl:UILabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        baseBackgroundView.backgroundColor = UIColor.white
        setUIViewAutolayout()
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUIViewAutolayout() {
        baseBackgroundView.addSubview(addressBaseBackgroundView)
        addressBaseBackgroundView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(55)
        }
        setAddressBaseBackgroundViewAutolayout()
        baseBackgroundView.addSubview(dateBaseBackgroundView)
        dateBaseBackgroundView.snp.makeConstraints { (make) in
            make.top.equalTo(addressBaseBackgroundView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(55)
        }
        setDateBaseBackgroundViewAutolayout()
        showTripLebl.backgroundColor = TBIThemeBlueColor
        showTripLebl.textColor = TBIThemeWhite
        showTripLebl.layer.cornerRadius = 4
        showTripLebl.clipsToBounds = true
        showTripLebl.font = UIFont.systemFont(ofSize: 9)
        showTripLebl.textAlignment = NSTextAlignment.center
        baseBackgroundView.addSubview(showTripLebl)
        showTripLebl.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(20)
            make.width.height.equalTo(12)
        }
        
        
    }
    /// 设置 地址 布局
    private func setAddressBaseBackgroundViewAutolayout() {
        flightStartPointLabel.text = startAirPortTipDefault
        flightStartPointLabel.addOnClickListener(target: self, action: #selector(takeOffAirportAction(sender:)))
        flightStartPointLabel.font = UIFont.systemFont(ofSize: 18)
        flightStartPointLabel.textAlignment = NSTextAlignment.left
        addressBaseBackgroundView.addSubview(flightStartPointLabel)
        flightStartPointLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(38)
            make.width.equalToSuperview().dividedBy(2).inset(30)
        }
        flightEndPointLabel.text = ""
        flightEndPointLabel.addOnClickListener(target: self, action: #selector(arriveAirportAction(sender:)))
        flightEndPointLabel.textColor = TBIThemePrimaryTextColor
        flightEndPointLabel.font = UIFont.systemFont(ofSize: 18)
        flightEndPointLabel.textAlignment = NSTextAlignment.right
        addressBaseBackgroundView.addSubview(flightEndPointLabel)
        flightEndPointLabel.snp.makeConstraints { (make) in
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
        flightPlaneImageView.addOnClickListener(target: self, action: #selector(exchangeAddressAirport))
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
            make.right.equalToSuperview().inset(20)
            make.left.equalToSuperview().inset(40)
        }
        
        
        
    }
    /// 设置 日期 布局
    private func setDateBaseBackgroundViewAutolayout() {
        
        let bottomLine:UILabel = UILabel()
        bottomLine.backgroundColor = TBIThemeGrayLineColor
        dateBaseBackgroundView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints{(make) in
            make.bottom.equalToSuperview().inset(1)
            make.right.equalToSuperview().inset(20)
            make.left.equalToSuperview().inset(40)
            make.height.equalTo(0.5)
        }
        deleteTripButton.setImage(UIImage.init(named: "ic_air_closed"), for: UIControlState.normal)
        deleteTripButton.addTarget(self, action: #selector(deleteTrip(sender:)), for: UIControlEvents.touchUpInside)
        dateBaseBackgroundView.addSubview(deleteTripButton)
        deleteTripButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(20)
            make.right.equalToSuperview().inset(15)
        }
        dateBaseBackgroundView.addSubview(dateSubbaseLeftBackgroundView)
        dateSubbaseLeftBackgroundView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().inset(38)
            make.bottom.equalToSuperview().inset(1)
            make.width.equalToSuperview().dividedBy(2).inset(10)
        }
        startDateDayLabel.adjustsFontSizeToFitWidth = true
        startDateDayLabel.font = UIFont.systemFont(ofSize: 16)
        startDateDayLabel.text = "4月10"
        startDateDayLabel.addOnClickListener(target: self, action: #selector(startDateAction(sender:)))
        dateSubbaseLeftBackgroundView.addSubview(startDateDayLabel)
        startDateDayLabel.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        startDateWeekLabel.font = UIFont.systemFont(ofSize: 10)
        startDateWeekLabel.adjustsFontSizeToFitWidth = true
        startDateWeekLabel.text = "周二"
        startDateWeekLabel.textColor = TBIThemePlaceholderColor
        dateSubbaseLeftBackgroundView.addSubview(startDateWeekLabel)
        startDateWeekLabel.snp.makeConstraints { (make) in
            make.left.equalTo(startDateDayLabel.snp.right).offset(5)
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(11)
        }

        
    }
    
    // 起始位置 互换
    func exchangeAddressAirport()  {
            //cycleAnmation()
        if flightEndPointLabel.text == endAirPortPlaceholderTipDefault {
            return
        }
        if flightSearchTVTableViewCellExchangeAddressPointBlock != nil {
            flightSearchTVTableViewCellExchangeAddressPointBlock("exchange",cellIndex)
            let tmpExchangeAddressPoint:String = flightStartPointLabel.text ?? ""
            flightStartPointLabel.text = flightEndPointLabel.text
            flightEndPointLabel.text = tmpExchangeAddressPoint
            cycleAnmation(view:flightCycleImageView)
        }
    }
    
    private func cycleAnmation(view:UIView) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3) //设置动画时间
        view.transform = view.transform.rotated(by: CGFloat(Double.pi/1.0))
        UIView.commitAnimations()
    }
    
    func cycleAnmationNew()  {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z") // 让其在z轴旋转
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = NSNumber(value: Double.pi * 2.0) // 旋转角度
        rotationAnimation.duration = 4 // 旋转周期
        rotationAnimation.isCumulative = false // 旋转累加角度
        rotationAnimation.repeatCount = 1 // 旋转次数
        flightCycleImageView.layer.add(rotationAnimation, forKey: nil)//rotationAnimation

    }
    
    
    
    func fillDataSources(flightModel:FlightSVSearchConditionModel,index:NSInteger,isShowDelete:Bool) {
        
        printDebugLog(message: flightModel.takeOffAirportName)
        printDebugLog(message: flightModel.arriveAirportName)
        flightStartPointLabel.text = flightModel.takeOffAirportName
        if flightModel.arriveAirportName.isEmpty == true || flightModel.arriveAirportName == endAirPortPlaceholderTipDefault {
            flightEndPointLabel.text = endAirPortPlaceholderTipDefault
            flightEndPointLabel.textColor = TBIThemePlaceholderLabelColor
        }else
        {
            flightEndPointLabel.text = flightModel.arriveAirportName
            flightEndPointLabel.textColor = TBIThemePrimaryTextColor
        }
        let formatter:DateFormatter = DateFormatter()
        formatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0) as TimeZone?
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let departureDate:Date = formatter.date(from: flightModel.departureDateFormat)!
        startDateDayLabel.text = departureDate.string(custom: "MM月dd日")
        startDateWeekLabel.text = departureDate.string(custom: "EEE")
        cellIndex = index
        showTripLebl.text = (index + 1).description
        deleteTripButton.isHidden = !isShowDelete
    }
    
    
    
    //MARK:-------------Action------------
    
    func deleteTrip(sender:UIButton) {
        if flightSearchTVTableViewCellDeleteBlock != nil {
            flightSearchTVTableViewCellDeleteBlock("",cellIndex)
        }
    }
    
    
    
    /// 起飞机场
    @objc private func takeOffAirportAction(sender:UITapGestureRecognizer) {
        changeValue(sender: sender)
    }
    
    /// 到达机场
    @objc private func arriveAirportAction(sender:UITapGestureRecognizer) {
        changeValue(sender: sender)
    }
    
    /// 起飞时间
    @objc private func startDateAction(sender:UITapGestureRecognizer) {
        changeValue(sender: sender)
    }
  
    
    @objc private func changeValue(sender:UITapGestureRecognizer) {
        let tmpLabel:UILabel = sender.view as! UILabel
        switch tmpLabel {
        case flightStartPointLabel:
            flightSearchTVTableViewCellServicesParametersTypeBlock(FlightSVSearchView.FlightSVSearchViewServicesType.startCity,cellIndex)
            break
        case flightEndPointLabel:
            flightSearchTVTableViewCellServicesParametersTypeBlock(FlightSVSearchView.FlightSVSearchViewServicesType.arriveCity,cellIndex)
            break
        case startDateDayLabel:
            flightSearchTVTableViewCellServicesParametersTypeBlock(FlightSVSearchView.FlightSVSearchViewServicesType.startDate,cellIndex)
            break
        default:
            break
        }
    }
    
 
}
