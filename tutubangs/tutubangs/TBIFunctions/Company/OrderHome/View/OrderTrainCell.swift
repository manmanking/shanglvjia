//
//  OrderTrainCell.swift
//  shanglvjia
//
//  Created by tbi on 2018/5/15.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class OrderTrainCell: UITableViewCell {

    let bgView = UIView()
    
    //航班日期
    var flightDateLabel = UILabel.init(text: "", color: TBIThemeMinorTextColor, size: 13)
    //起飞时间
    var takeOffDateLabel = UILabel.init(text: "", color: TBIThemePrimaryTextColor, size: 25)

    //
    let arrowImage = UIImageView.init(imageName: "ic_ari_timeto")
    //经停标签
    var stopOverLabel = UILabel.init(text: "", color: TBIThemeMinorTextColor, size: 11)
    
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
    //+1
    var flyDaysLabel = UILabel.init(text: "", color: TBIThemeMinorTextColor, size: 11)
    
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
        bgView.addSubview(flightDateLabel)
        bgView.addSubview(takeOffDateLabel)
        bgView.addSubview(arrowImage)
        bgView.addSubview(stopOverLabel)
        bgView.addSubview(arriveDateLabel)
        bgView.addSubview(takeOffAirportLabel)
        bgView.addSubview(craftTypeLabel)
        bgView.addSubview(arriveAirportLabel)
        bgView.addSubview(flyDaysLabel)
        
        bgView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview()//-17.5
        }
        flightDateLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(13)
            make.top.equalToSuperview().offset(15)
        }
        takeOffDateLabel.snp.makeConstraints { (make) in
            make.right.equalTo(arrowImage.snp.left).offset(-30)
            make.top.equalTo(flightDateLabel.snp.bottom).offset(25)
            make.height.equalTo(30)
        }
        arriveDateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(arrowImage.snp.right).offset(30)
            make.top.equalTo(takeOffDateLabel.snp.top)
            make.height.equalTo(30)
        }
        
        flyDaysLabel.snp.makeConstraints { (make) in
            make.left.equalTo(arriveDateLabel.snp.right).offset(2)
            make.top.equalTo(arriveDateLabel.snp.top).offset(-5)
            make.width.equalTo(40)
            make.height.equalTo(20)
        }
        
        arrowImage.snp.makeConstraints { (make) in
            make.width.equalTo(50)
            make.height.equalTo(5)
            make.centerX.equalTo(bgView.snp.centerX)
            make.centerY.equalTo(takeOffDateLabel.snp.centerY)
        }
        stopOverLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(arrowImage.snp.centerX)
            make.bottom.equalTo(arrowImage.snp.bottom).offset(-4)
        }
        takeOffAirportLabel.snp.makeConstraints { (make) in
            make.right.equalTo(takeOffDateLabel.snp.right)
            make.top.equalTo(takeOffDateLabel.snp.bottom).offset(5)
        }
        arriveAirportLabel.snp.makeConstraints { (make) in
            make.left.equalTo(arriveDateLabel.snp.left)
            make.top.equalTo(takeOffAirportLabel.snp.top)
        }
        bgView.addSubview(stopOverCityLabel)
        stopOverCityLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(arrowImage.snp.centerX)
            make.top.equalTo(arrowImage.snp.bottom)
        }
    }

    func setCellWithModel(model:OrderDetailModel) {
        takeOffAirportLabel.text = model.startStationName
        if model.startTime.isNotEmpty {
            takeOffDateLabel.text = model.startTime.components(separatedBy: " ")[1]
        }
        if model.arriveTime.isNotEmpty {
            arriveDateLabel.text = model.arriveTime.components(separatedBy: " ")[1]
        }
       
        if(model.trainDay == "0")
        {
            flyDaysLabel.isHidden=true
        }else{
            flyDaysLabel.text="+" + "\(model.trainDay)" + "天"
        }
        
        arriveAirportLabel.text = model.endStationName
        
        if model.arriveTime.isNotEmpty
        {
            
            flightDateLabel.text = CommonTool.replace(CommonTool.returnSubString(model.arriveTime, withStart:5, withLenght: 5), withInstring: "-", withOut: "月")  + "日"
        }
        
        stopOverLabel.text=model.trainCode
        stopOverCityLabel.text=CommonTool.returnRuntime(model.runTime)
            
        }
}
