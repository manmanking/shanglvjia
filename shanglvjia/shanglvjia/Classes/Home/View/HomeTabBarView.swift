//
//  HomeTabBarView.swift
//  shop
//
//  Created by SLMF on 2017/4/18.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class HomeTabBarView: UIView {
    
    let airPlaneButton: HomeTabBarButtonView
    let hotelButton: HomeTabBarButtonView
    let travelButton: HomeTabBarButtonView
    let vehicleButton: HomeTabBarButtonView
    let visaButton: HomeTabBarButtonView
    
    fileprivate let distence = (UIScreen.main.bounds.width - 5 * 44 - 50) / 4
    
    init() {
        airPlaneButton = HomeTabBarButtonView.init(imageName: "Home_Personal_Plane", labelStr: "机票")
        hotelButton = HomeTabBarButtonView.init(imageName: "Home_Personal_Hotel", labelStr: "酒店")
        travelButton = HomeTabBarButtonView.init(imageName: "Home_Personal_Travel", labelStr: "旅游")
        vehicleButton = HomeTabBarButtonView.init(imageName: "Home_Personal_Car", labelStr: "接送机")
        visaButton = HomeTabBarButtonView.init(imageName: "Home_Personal_Visa", labelStr: "签证")
        super.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        self.backgroundColor = .white
        self.addSubview(airPlaneButton)
        self.addSubview(hotelButton)
        self.addSubview(travelButton)
        self.addSubview(vehicleButton)
        self.addSubview(visaButton)
        airPlaneButton.snp.makeConstraints{(make) in
            make.left.equalToSuperview().offset(25)
            make.top.equalToSuperview().offset(15)
            make.width.equalTo(44)
            make.height.equalTo(66)
        }
        hotelButton.snp.makeConstraints{(make) in
            make.left.equalTo(airPlaneButton.snp.right).offset(distence)
            make.top.equalTo(airPlaneButton.snp.top)
            make.width.equalTo(44)
            make.height.equalTo(66)
        }
        travelButton.snp.makeConstraints{(make) in
            make.left.equalTo(hotelButton.snp.right).offset(distence)
            make.top.equalTo(hotelButton.snp.top)
            make.width.equalTo(44)
            make.height.equalTo(66)
        }
        vehicleButton.snp.makeConstraints{(make) in
            make.left.equalTo(travelButton.snp.right).offset(distence)
            make.top.equalTo(travelButton.snp.top)
            make.width.equalTo(44)
            make.height.equalTo(66)
        }
        visaButton.snp.makeConstraints{(make) in
            make.left.equalTo(vehicleButton.snp.right).offset(distence)
            make.top.equalTo(vehicleButton.snp.top)
            make.width.equalTo(44)
            make.height.equalTo(66)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
