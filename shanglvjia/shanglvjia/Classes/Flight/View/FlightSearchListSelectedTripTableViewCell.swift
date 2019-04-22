//
//  FlightSearchListSelectedTripTableViewCell.swift
//  shanglvjia
//
//  Created by manman on 2018/3/30.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class FlightSearchListSelectedTripTableViewCell: UITableViewCell {

    private let currentSectionTripTitleLabel:UILabel = UILabel()
    
    private let currentSectionTripDateLabel:UILabel = UILabel()
    
    private let currentSectionTripAirportLabel:UILabel = UILabel()
    
    private let currentSectionTripHoursLabel:UILabel = UILabel()
    
    private let currentSectionTripFlightCompanyLabel:UILabel = UILabel()
    
    
 
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = TBIThemeDarkBlueColor
        setUIViewAutoLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUIViewAutoLayout() {
        currentSectionTripTitleLabel.textColor = TBIThemeBlueColor
        currentSectionTripTitleLabel.backgroundColor = TBIThemeWhite
        currentSectionTripTitleLabel.textAlignment = NSTextAlignment.center
        currentSectionTripTitleLabel.font = UIFont.systemFont(ofSize: 11)
        currentSectionTripTitleLabel.layer.cornerRadius = 4
        currentSectionTripTitleLabel.clipsToBounds = true
        currentSectionTripTitleLabel.adjustsFontSizeToFitWidth = true
        self.contentView.addSubview(currentSectionTripTitleLabel)
        currentSectionTripTitleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.equalTo(22)
            make.width.equalTo(40)
            make.left.equalToSuperview().inset((ScreenWindowWidth / 5 - 40) / 2)
            
        }
        currentSectionTripDateLabel.textColor = TBIThemeWhite
        currentSectionTripDateLabel.font = UIFont.systemFont(ofSize: 11)
        currentSectionTripDateLabel.textAlignment = NSTextAlignment.center
        self.contentView.addSubview(currentSectionTripDateLabel)
        currentSectionTripDateLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(currentSectionTripTitleLabel.snp.right).offset((ScreenWindowWidth / 5 - 40) / 4)
            make.width.equalTo((ScreenWindowWidth - 20) / 5)
            make.height.equalTo(22)
            
        }
        currentSectionTripAirportLabel.textColor = TBIThemeWhite
        currentSectionTripAirportLabel.font = UIFont.systemFont(ofSize: 11)
        currentSectionTripAirportLabel.textAlignment = NSTextAlignment.center
        self.contentView.addSubview(currentSectionTripAirportLabel)
        currentSectionTripAirportLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(currentSectionTripDateLabel.snp.right)
            make.width.equalTo((ScreenWindowWidth - 20) / 5)
            make.height.equalTo(22)
            
        }
        currentSectionTripHoursLabel.textColor = TBIThemeWhite
        currentSectionTripHoursLabel.font = UIFont.systemFont(ofSize: 11)
        currentSectionTripHoursLabel.textAlignment = NSTextAlignment.center
        self.contentView.addSubview(currentSectionTripHoursLabel)
        currentSectionTripHoursLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(currentSectionTripAirportLabel.snp.right)
            make.width.equalTo((ScreenWindowWidth - 20) / 5)
            make.height.equalTo(22)
            
        }
        currentSectionTripFlightCompanyLabel.textColor = TBIThemeWhite
        currentSectionTripFlightCompanyLabel.font = UIFont.systemFont(ofSize: 11)
        currentSectionTripFlightCompanyLabel.textAlignment = NSTextAlignment.center
        self.contentView.addSubview(currentSectionTripFlightCompanyLabel)
        currentSectionTripFlightCompanyLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(10)
            make.width.equalTo((ScreenWindowWidth - 20) / 5)
            make.height.equalTo(22)
            
        }
    }
    
    
    func fillDataSources(flight:FlightSVSearchResultVOModel.AirfareVO,type:NSInteger,currentTrip:NSInteger) {
        if type == 1 {
            currentSectionTripTitleLabel.text = "去程"
        }else{
            switch currentTrip {
            case 1:
                currentSectionTripTitleLabel.text = "第一程"
            case 2:
                currentSectionTripTitleLabel.text = "第二程"
            case 3:
                currentSectionTripTitleLabel.text = "第三程"
            case 4:
                currentSectionTripTitleLabel.text = "第四程"
            default:
                break
            }
        }
        
        currentSectionTripDateLabel.text = Date.init(timeIntervalSince1970: TimeInterval((flight.flightInfos.first?.takeOffDate)! / 1000)).string(custom:"MM月dd日")
        currentSectionTripAirportLabel.text = (flight.flightInfos.first?.takeOffCity)! + "-" + (flight.flightInfos.last?.arriveCity)!
        currentSectionTripHoursLabel.text = Date.init(timeIntervalSince1970: TimeInterval((flight.flightInfos.first?.takeOffDate)! / 1000)).string(custom:"HH:mm") + "-" + Date.init(timeIntervalSince1970: TimeInterval((flight.flightInfos.last?.arriveDate)! / 1000)).string(custom:"HH:mm")
        currentSectionTripFlightCompanyLabel.text = (flight.flightInfos.first?.flightShortName)! + (flight.flightInfos.first?.flightCode)! + (flight.flightInfos.first?.flightNo)!
        
    }
    

}
