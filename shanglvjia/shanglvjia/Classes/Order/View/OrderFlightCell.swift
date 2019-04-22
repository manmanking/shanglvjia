//
//  OrderFlightCell.swift
//  shanglvjia
//
//  Created by tbi on 2018/5/10.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class OrderFlightCell: UITableViewCell {

    let flightOrderVC = FlightOrderDetaileViewController()
    var alertStr = String()
    let bgView = UIView()
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
    //共享
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
    
//    let messageImage = UIImageView.init(imageName: "ico_attention")
    
//    var messageLabel = UILabel.init(text: "什么是协议价?", color: TBIThemeBlueColor, size: 10)
    
    let tuigaiButton = UIButton()
    
    ///  航程是否隔天 +1天
    private var flyDaysLabel:UILabel = UILabel()
    
    
    //准点率
    //private var mealCodeLabel:UILabel = UILabel()
    
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
        self.bgView.layer.cornerRadius = 2
        self.addSubview(bgView)
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
        
        //
        //        self.addSubview(messageLabel)
        //        messageLabel.snp.makeConstraints { (make) in
        //            make.right.equalTo(-25)
        //            make.top.equalTo(bgView.snp.bottom).offset(4)
        //        }
        //
        //        self.addSubview(messageImage)
        //        messageImage.snp.makeConstraints { (make) in
        //            make.width.height.equalTo(10)
        //            make.centerY.equalTo(messageLabel.snp.centerY)
        //            make.right.equalTo(messageLabel.snp.left).offset(-5)
        //        }
        
        flightNameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(28)
            make.top.equalToSuperview().offset(15)
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
            make.centerX.equalTo(bgView.snp.centerX)
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
//        mealCodeLabel.font = UIFont.systemFont(ofSize: 11)
//        mealCodeLabel.textColor = TBIThemeMinorTextColor
//        mealCodeLabel.textAlignment = NSTextAlignment.center
//        bgView.addSubview(mealCodeLabel)
//        mealCodeLabel.snp.remakeConstraints { (make) in
//            make.left.equalToSuperview().inset(15)
//            make.height.equalTo(14)
//            make.width.equalTo((ScreenWindowWidth - 40)/4)
//            make.bottom.equalToSuperview().inset(10)
//        }
        
        
//        firstLine.backgroundColor = TBIThemePlaceholderColor
//        bgView.addSubview(firstLine)
//        firstLine.snp.makeConstraints { (make) in
//            make.left.equalTo(mealCodeLabel.snp.right).offset(2)
//            make.height.equalTo(12)
//            make.centerY.equalTo(mealCodeLabel)
//            make.width.equalTo(1)
//        }
        
//        flightTypeLabel.font = UIFont.systemFont(ofSize: 11)
//        flightTypeLabel.textColor = TBIThemeMinorTextColor
//        flightTypeLabel.textAlignment = NSTextAlignment.center
//        bgView.addSubview(flightTypeLabel)
//        flightTypeLabel.snp.remakeConstraints { (make) in
//            make.left.equalTo(firstLine.snp.right).offset(2)
//            make.centerY.equalTo(mealCodeLabel)
//            make.width.equalTo((ScreenWindowWidth - 40)/4)
//            make.height.equalTo(14)
//        }
//        secondLine.backgroundColor = TBIThemePlaceholderColor
//        bgView.addSubview(secondLine)
//        secondLine.snp.makeConstraints { (make) in
//            make.left.equalTo(flightTypeLabel.snp.right).offset(2)
//            make.height.equalTo(12)
//            make.centerY.equalTo(flightTypeLabel)
//            make.width.equalTo(1)
//        }
        
//        flightTypeBulkLabel.font = UIFont.systemFont(ofSize: 11)
//        flightTypeBulkLabel.textColor = TBIThemeMinorTextColor
//        flightTypeBulkLabel.textAlignment = NSTextAlignment.center
//        bgView.addSubview(flightTypeBulkLabel)
//        flightTypeBulkLabel.snp.remakeConstraints { (make) in
//            make.left.equalTo(secondLine.snp.right).offset(2)
//            make.centerY.equalTo(flightTypeLabel)
//            make.width.equalTo((ScreenWindowWidth - 40)/4)
//            make.height.equalTo(14)
//        }
        
//        thirdLine.backgroundColor = TBIThemePlaceholderColor
//        bgView.addSubview(thirdLine)
//        thirdLine.snp.makeConstraints { (make) in
//            make.left.equalTo(flightTypeBulkLabel.snp.right).offset(2)
//            make.height.equalTo(12)
//            make.centerY.equalTo(mealCodeLabel)
//            make.width.equalTo(1)
//        }
        
//        duringTimeLabel.font = UIFont.systemFont(ofSize: 11)
//        duringTimeLabel.textColor = TBIThemeMinorTextColor
//        duringTimeLabel.textAlignment = NSTextAlignment.center
//        bgView.addSubview(duringTimeLabel)
//        duringTimeLabel.snp.makeConstraints { (make) in
//            make.width.equalTo((ScreenWindowWidth - 40)/4)
//            make.centerY.equalTo(mealCodeLabel)
//            make.height.equalTo(14)
//            make.right.equalToSuperview().inset(15)
//        }
        
        
        
        stopOverCityLabel.isHidden = true
        bgView.addSubview(stopOverCityLabel)
        stopOverCityLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(arrowImage.snp.centerX)
            make.top.equalTo(arrowImage.snp.bottom).offset(4)
        }
    }

    func setCellWithModel(model:OrderDetailModel) {
        
        if model.takeoffTime.isNotEmpty {
            takeOffDateLabel.text = model.takeoffTime.components(separatedBy: " ")[1]
        }
        if model.arriveTime.isNotEmpty {
            arriveDateLabel.text = model.arriveTime.components(separatedBy: " ")[1]
        }
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
            arriveAirportLabel.text = model.segments[model.segments.count-1].arriveAirport + model.segments[model.segments.count-1].arriveTerminal
            takeOffAirportLabel.text = model.segments[0].takeoffAirport + model.segments[0].takeoffTerminal
            
            airCompanyImage.image=UIImage(named:model.segments[0].marketAirline)
            flightNameLabel.text=model.segments[0].marketAirlineCH + model.segments[0].marketAirline + model.segments[0].marketFlightNo
            
            if model.segments[0].share {
                flightStatusLabel.text=" 共享"
            }
          
            alertStr = model.segments[0].ei
           tuigaiButton.addTarget(self, action: #selector(tuigaiButtonClick(sender:)), for: UIControlEvents.touchUpInside)
        }
    
//        duringTimeLabel.text = "约22小时50分"
//        mealCodeLabel.text = "准点率 100%"
//        flightTypeBulkLabel.text = "无餐饮"
//        flightTypeLabel.text = "中型机"
        
    }
    func tuigaiButtonClick(sender:UIButton)
    {

        popNewAlertView(content:alertStr,titleStr:"退改签说明",btnTitle:"我知道了",imageName:"",nullStr:"")
    }
}
