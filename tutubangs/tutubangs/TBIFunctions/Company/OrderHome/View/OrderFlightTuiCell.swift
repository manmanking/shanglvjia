//
//  OrderFlightTuiCell.swift
//  shanglvjia
//
//  Created by tbi on 2018/5/22.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class OrderFlightTuiCell: UITableViewCell {

    //线
    var lineLabel = UILabel()
    //状态
    var titleLabel = UILabel(text: "基本信息", color: TBIThemePrimaryTextColor, size: 15)
    //线
    var bottomLineLabel = UILabel()
    let bgView = UIView()
    
    var alertStr = String()
    //航空公司图标
    var airCompanyImage = UIImageView(imageName:"BK")
    //航空公司名字
    var flightNameLabel = UILabel.init(text: "", color: TBIThemeMinorTextColor, size: 13)
    //航班日期
    var flightDateLabel = UILabel.init(text: "", color: TBIThemeMinorTextColor, size: 13)
    //起飞城市
    var takeOffCityLabel = UILabel.init(text: "", color: TBIThemePrimaryTextColor, size: 13)
    //到达城市
    var arriveCityLabel = UILabel.init(text: "", color: TBIThemePrimaryTextColor, size: 13)
    //起飞时间
    var takeOffDateLabel = UILabel.init(text: "", color: TBIThemePrimaryTextColor, size: 25)
    
    var flightStatusLabel = UILabel.init(text: "", color: TBIThemeShallowBlueColor, size: 12)
    //
    let arrowImage = UIImageView.init(imageName: "ic_ari_timeto")
    //经停标签
    var stopOverLabel = UILabel.init(text: "经停", color: TBIThemeMinorTextColor, size: 11)
    
    //经停标签
    var stopOverCityLabel = UILabel.init(text: "", color: TBIThemeMinorTextColor, size: 11)
    //到达时间
    var arriveDateLabel = UILabel.init(text: "", color: TBIThemePrimaryTextColor, size: 25)
    //起飞机场
    var takeOffAirportLabel = UILabel.init(text: "", color: TBIThemeMinorTextColor, size: 12)
    //
    var craftTypeLabel = UILabel.init(text: "", color: TBIThemeMinorTextColor, size: 12)
    //到达机场
    var arriveAirportLabel = UILabel.init(text: "", color: TBIThemeMinorTextColor, size: 12)
    
    let tuigaiButton = UIButton()
    
    ///  航程是否隔天 +1天
    var flyDaysLabel:UILabel = UILabel()
    
    
    //准点率
    private var mealCodeLabel:UILabel = UILabel()
    
    private let firstLine:UILabel = UILabel()
    /// 机型编号  有无餐饮
    private var flightTypeLabel:UILabel = UILabel()
    
    private let secondLine:UILabel = UILabel()
    
    /// 中型机
    private var flightTypeBulkLabel:UILabel = UILabel()
    
    private let thirdLine:UILabel = UILabel()
    /// 飞行时间
    private var duringTimeLabel:UILabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor=TBIThemeWhite
        self.selectionStyle=UITableViewCellSelectionStyle.none
        creatCellUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func creatCellUI() {
        self.backgroundColor = TBIThemeBaseColor
        self.bgView.backgroundColor = TBIThemeWhite
//        self.bgView.layer.cornerRadius = 2
        self.contentView.addSubview(bgView)
        
        lineLabel.backgroundColor=TBIThemeDarkBlueColor
        bottomLineLabel.backgroundColor=TBIThemeBaseColor
        bgView.addSubview(lineLabel)
        bgView.addSubview(titleLabel)
        bgView.addSubview(bottomLineLabel)
        
        bgView.addSubview(flightNameLabel)
        bgView.addSubview(airCompanyImage)
        bgView.addSubview(flightDateLabel)
        bgView.addSubview(takeOffDateLabel)
        bgView.addSubview(takeOffCityLabel)
        bgView.addSubview(arrowImage)
        bgView.addSubview(stopOverLabel)
        bgView.addSubview(arriveDateLabel)
        bgView.addSubview(arriveCityLabel)
        bgView.addSubview(takeOffAirportLabel)
        bgView.addSubview(craftTypeLabel)
        bgView.addSubview(arriveAirportLabel)
        bgView.addSubview(flightStatusLabel)
        stopOverLabel.isHidden = true
        
        bgView.addSubview(tuigaiButton)

        bgView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)//-17.5
        }
        lineLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(6)
            make.left.equalToSuperview()
            make.width.equalTo(3)
            make.height.equalTo(33)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(lineLabel.snp.right).offset(10)
            make.top.equalTo(lineLabel.snp.top)
            make.bottom.equalTo(lineLabel.snp.bottom)
            make.right.equalToSuperview().offset(-42)
        }
        bottomLineLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.equalTo(0)
            make.height.equalTo(1)
            make.width.equalTo(ScreenWindowWidth)
        }
        
        flightNameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(28)
            make.top.equalTo(bottomLineLabel.snp.bottom).offset(15)
        }
        airCompanyImage.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(13)
            make.centerY.equalTo(flightNameLabel.snp.centerY)
            make.width.height.equalTo(12)
        }
        flightStatusLabel.snp.makeConstraints { (make) in
            make.left.equalTo(flightNameLabel.snp.right).offset(2)
            make.centerY.equalTo(flightNameLabel.snp.centerY)
            make.height.equalTo(12)
            
        }
        tuigaiButton.setTitle("退改规则", for: UIControlState.normal)
        tuigaiButton.setTitleColor(TBIThemeShallowBlueColor, for: UIControlState.normal)
        tuigaiButton.titleLabel?.font=UIFont.systemFont(ofSize: 12)
        tuigaiButton.contentHorizontalAlignment=UIControlContentHorizontalAlignment.right
        
        tuigaiButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-14)
            make.top.equalTo(airCompanyImage)
            make.height.equalTo(airCompanyImage)
            make.width.equalTo(70)
        }
        
        flightDateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(flightStatusLabel.snp.right).offset(5)
            make.centerY.equalTo(flightNameLabel.snp.centerY)
        }
        
        
        takeOffDateLabel.snp.makeConstraints { (make) in
            make.right.equalTo(arrowImage.snp.left).offset(-30)
            make.top.equalTo(flightNameLabel.snp.bottom).offset(25)
            make.height.equalTo(30)
        }
        arriveDateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(arrowImage.snp.right).offset(30)
            make.top.equalTo(takeOffDateLabel.snp.top)
            make.height.equalTo(30)
        }
        flyDaysLabel.text = "+1天"
        flyDaysLabel.font = UIFont.systemFont(ofSize: 11)
        flyDaysLabel.isHidden=true
        flyDaysLabel.textColor = TBIThemePrimaryTextColor
        
        bgView.addSubview( flyDaysLabel)
        flyDaysLabel.snp.makeConstraints { (make) in
            make.left.equalTo(arriveDateLabel.snp.right).offset(2)
            make.top.equalTo(arriveDateLabel.snp.top).offset(-5)
            make.width.equalTo(40)
            make.height.equalTo(20)
        }
        takeOffCityLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(takeOffDateLabel.snp.top).offset(-2)
            make.centerX.equalTo(takeOffDateLabel.snp.centerX)
        }
        arriveCityLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(arriveDateLabel.snp.centerX)
            make.bottom.equalTo(arriveDateLabel.snp.top).offset(-2)
        }
        
        
        arrowImage.snp.makeConstraints { (make) in
            make.width.equalTo(50)
            make.height.equalTo(5)
            make.centerX.equalTo(self.contentView.snp.centerX)
            make.centerY.equalTo(takeOffDateLabel.snp.centerY)
        }
        stopOverLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(arrowImage.snp.centerX)
            make.bottom.equalTo(arrowImage.snp.bottom).offset(-5)
        }
        
        
        takeOffAirportLabel.snp.makeConstraints { (make) in
            make.right.equalTo(takeOffDateLabel.snp.right)
            make.top.equalTo(takeOffDateLabel.snp.bottom).offset(5)
        }
        craftTypeLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(arrowImage.snp.centerX)
            make.bottom.equalToSuperview().offset(-15)
        }
        arriveAirportLabel.snp.makeConstraints { (make) in
            make.left.equalTo(arriveDateLabel.snp.left)
            make.top.equalTo(takeOffAirportLabel.snp.top)
        }
        
        stopOverCityLabel.isHidden = true
        bgView.addSubview(stopOverCityLabel)
        stopOverCityLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(arrowImage.snp.centerX)
            make.top.equalTo(arrowImage.snp.bottom).offset(4)
        }
    }
    
    func setCellWithModel(model:OrderDetailModel) {
//        takeOffAirportLabel.text = model.takeoffAirport
//        if model.takeoffTime.isNotEmpty {
//            takeOffDateLabel.text = model.takeoffTime.components(separatedBy: " ")[1]
//        }
//        if model.arriveTime.isNotEmpty {
//            arriveDateLabel.text = model.arriveTime.components(separatedBy: " ")[1]
//        }
//        
//        arriveAirportLabel.text = model.arriveAirport
//        flightDateLabel.text = model.createTime
        if model.arriveTime.isNotEmpty
        {
            flightDateLabel.text = CommonTool.replace(CommonTool.returnSubString(model.arriveTime, withStart:5, withLenght: 5), withInstring: "-", withOut: "月")  + "日"
        }
        
        //判断segments的数量，两个以上为中转，一个：在判断stopover是否是经停
        if model.segments.count != 0 {
            if model.segments.count==2
            {
                stopOverLabel.isHidden=false
                stopOverLabel.text="转"
                stopOverCityLabel.isHidden=false
                stopOverCityLabel.text=model.segments[0].arriveCity
                
                if model.segments[0].flyDays == "1" || model.segments[1].flyDays == "1"{
                    flyDaysLabel.isHidden=false
                }
                
                
            }else{
                
                if model.segments[0].stopoverCity .isNotEmpty
                {
                    stopOverLabel.isHidden=false
                    stopOverCityLabel.isHidden=false
                    stopOverCityLabel.text=model.segments[0].stopoverCity
                }
                if model.segments[0].flyDays == "1" {
                    flyDaysLabel.isHidden=false
                }
                
            }
            arriveAirportLabel.text = model.segments[0].arriveAirport + model.segments[0].arriveTerminal
            takeOffAirportLabel.text = model.segments[0].takeoffAirport + model.segments[0].takeoffTerminal
            
            if model.takeoffTime.isNotEmpty {
               takeOffDateLabel.text = model.takeoffTime.components(separatedBy: " ")[1]
            }
            if model.arriveTime.isNotEmpty {
                arriveDateLabel.text = model.arriveTime.components(separatedBy: " ")[1]
            }
            
            airCompanyImage.image=UIImage(named:model.segments[0].marketAirline)
            flightNameLabel.text=model.segments[0].marketAirlineCH + model.segments[0].marketAirline + model.segments[0].marketFlightNo
            
            if model.segments[0].share {
                flightStatusLabel.text=" 共享"
            }
            
            alertStr = model.segments[0].ei
            tuigaiButton.addTarget(self, action: #selector(tuigaiButtonClick(sender:)), for: UIControlEvents.touchUpInside)
        }
        
    }
    func setCellWithPsg(model:OrderDetailModel.passenger) {
       if model.alters.count > 0
       {
        takeOffAirportLabel.text = model.alters[0].segments[0].takeoffAirport + model.alters[0].segments[0].takeoffTerminal
        if model.alters[0].segments[0].takeoffTime.isNotEmpty {
            takeOffDateLabel.text = model.alters[0].segments[0].takeoffTime.components(separatedBy: " ")[1]
        }
        
        if model.alters[0].segments[0].arriveTime.isNotEmpty {
            arriveDateLabel.text = model.alters[0].segments[model.alters[0].segments.count-1].arriveTime.components(separatedBy: " ")[1]
        }

        arriveAirportLabel.text = model.alters[0].segments[model.alters[0].segments.count-1].arriveAirport + model.alters[0].segments[model.alters[0].segments.count-1].arriveTerminal
        
        if model.alters[0].segments[0].arriveTime.isNotEmpty
        {
            flightDateLabel.text = CommonTool.replace(CommonTool.returnSubString(model.alters[0].segments[0].arriveTime, withStart:5, withLenght: 5), withInstring: "-", withOut: "月")  + "日"
        }
        

        //判断segments的数量，两个以上为中转，一个：在判断stopover是否是经停
        if model.alters[0].segments.count != 0 {
            if model.alters[0].segments.count==2
            {
                stopOverLabel.isHidden=false
                stopOverLabel.text="转"
                stopOverCityLabel.isHidden=false
                stopOverCityLabel.text=model.alters[0].segments[0].arriveCity

                if model.alters[0].segments[0].flyDays == "1" || model.alters[0].segments[1].flyDays == "1"{
                    flyDaysLabel.isHidden=false
                }


            }else{

                if model.alters[0].segments[0].stopoverCity .isNotEmpty
                {
                    stopOverLabel.isHidden=false
                    stopOverCityLabel.isHidden=false
                    stopOverCityLabel.text=model.alters[0].segments[0].stopoverCity
                }
                if model.alters[0].segments[0].flyDays == "1" {
                    flyDaysLabel.isHidden=false
                }

            }

            airCompanyImage.image=UIImage(named:model.alters[0].segments[0].marketAirline)
            flightNameLabel.text=model.alters[0].segments[0].marketAirlineCH + model.alters[0].segments[0].marketAirline + model.alters[0].segments[0].marketFlightNo

            if model.alters[0].segments[0].share {
                flightStatusLabel.text=" 共享"
            }

            alertStr = model.alters[0].segments[0].ei
            alertStr = alertStr.isEmpty ? "无" : alertStr
            tuigaiButton.addTarget(self, action: #selector(tuigaiButtonClick(sender:)), for: UIControlEvents.touchUpInside)
        }
        }
        
    }
    func tuigaiButtonClick(sender:UIButton)
    {
        
        popNewAlertView(content:alertStr,titleStr:"退改签说明",btnTitle:"我知道了",imageName:"",nullStr:"")
    }

}
