//
//  FlightTripCityTitleView.swift
//  shanglvjia
//
//  Created by manman on 2018/6/8.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class FlightTripCityTitleView: UIView {

    private let baseBackgroundView:UIView = UIView()
    private let startCityLabel:UILabel = UILabel()
    private let arriveCityLabel:UILabel = UILabel()
    private let tripIndexLabel:UILabel = UILabel()
    private let flagImageView:UIImageView = UIImageView()
  
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = TBIThemeWhite
        self.addSubview(baseBackgroundView)
        baseBackgroundView.backgroundColor = TBIThemeWhite
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        setUIViewAutolayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUIViewAutolayout()  {
        
        tripIndexLabel.font = UIFont.systemFont(ofSize: 16)
        tripIndexLabel.adjustsFontSizeToFitWidth = true
        tripIndexLabel.textColor = TBIThemePrimaryTextColor
        baseBackgroundView.addSubview(tripIndexLabel)
        tripIndexLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.height.equalTo(44)
            make.top.bottom.equalToSuperview()
        }
        
        
        startCityLabel.font = UIFont.systemFont(ofSize: 16)
        startCityLabel.adjustsFontSizeToFitWidth = true
        startCityLabel.textColor = TBIThemePrimaryTextColor
        baseBackgroundView.addSubview(startCityLabel)
        startCityLabel.snp.makeConstraints { (make) in
            make.left.equalTo(tripIndexLabel.snp.right).offset(2)
            make.height.equalTo(44)
            make.top.bottom.equalToSuperview()
        }
        
        flagImageView.image = UIImage.init(named:"ic_air_to")
        baseBackgroundView.addSubview(flagImageView)
        flagImageView.snp.makeConstraints { (make) in
            make.left.equalTo(startCityLabel.snp.right).offset(5)
            make.height.equalTo(15)
            make.width.equalTo(20)
            make.centerY.equalToSuperview()
        }
        arriveCityLabel.font = UIFont.systemFont(ofSize: 16)
        arriveCityLabel.adjustsFontSizeToFitWidth = true
        arriveCityLabel.textColor = TBIThemePrimaryTextColor
        baseBackgroundView.addSubview(arriveCityLabel)
        arriveCityLabel.snp.makeConstraints { (make) in
            make.left.equalTo(flagImageView.snp.right).offset(5)
            make.height.equalTo(44)
            make.top.bottom.equalToSuperview()
        }
    }
    
    
    func fillDataSources(type:NSInteger,startCity:String,arriveCity:String,tripIndex:NSInteger) {
        switch type {
        case 0:
            setSingleTrip(startCity: startCity, arriveCity: arriveCity)
        case 1:
            setRoundTrip(startCity: startCity, arriveCity: arriveCity, tripIndex: tripIndex)
        case 2:
            setMoreTrip(startCity: startCity, arriveCity: arriveCity, tripIndex: tripIndex)
        default:
            break
        }
    }
    
    func setSingleTrip(startCity:String,arriveCity:String) {
        startCityLabel.text = startCity
        arriveCityLabel.text = arriveCity
        tripIndexLabel.isHidden = true
    }
    func fillPersonalDataSources(type:NSInteger,startCity:String,arriveCity:String) {
        switch type {
            //单程
        case 0:
            startCityLabel.text = startCity
            arriveCityLabel.text = arriveCity
            tripIndexLabel.isHidden = true
            flagImageView.image = UIImage(named:"ic_air_to")
            //往返
        case 1:
            startCityLabel.text = startCity
            arriveCityLabel.text = arriveCity
            tripIndexLabel.isHidden = true
            flagImageView.image = UIImage(named:"ic_air_roundtrip")
        default:
            break
        }
    }
    
    
    
    func setRoundTrip(startCity:String,arriveCity:String,tripIndex:NSInteger)  {
        if tripIndex == 1 {
            tripIndexLabel.text = "选去程:"
            tripIndexLabel.isHidden = false
        }else
        {
            tripIndexLabel.text = "选返程:"
            tripIndexLabel.isHidden = false
        }
        tripIndexLabel.snp.remakeConstraints { (make) in
            make.left.equalToSuperview()
            make.height.equalTo(44)
            make.top.bottom.equalToSuperview()
        }
        startCityLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(tripIndexLabel.snp.right).offset(2)
            make.top.bottom.equalToSuperview()
        }
        
        startCityLabel.text = startCity
        arriveCityLabel.text = arriveCity
    }
    
    func setMoreTrip(startCity:String,arriveCity:String,tripIndex:NSInteger)  {
        var tripIndexStr:String = ""
        switch tripIndex {
        case 1 :
            tripIndexStr = "第一程:"
        case 2:
            tripIndexStr = "第二程:"
        case 3:
            tripIndexStr = "第三程:"
        case 4:
            tripIndexStr = "第四程:"
        default:
            break
        }
        tripIndexLabel.text = tripIndexStr
        tripIndexLabel.isHidden = false
        tripIndexLabel.snp.remakeConstraints { (make) in
            make.left.equalToSuperview()
            make.height.equalTo(44)
            make.top.bottom.equalToSuperview()
        }
        startCityLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(tripIndexLabel.snp.right).offset(2)
            make.top.bottom.equalToSuperview()
        }
        
        startCityLabel.text = startCity
        arriveCityLabel.text = arriveCity
    }
    
    
    
    
    

}
