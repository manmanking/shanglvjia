//
//  PersonalBannerManager.swift
//  tutubangs
//
//  Created by manman on 2018/10/12.
//  Copyright © 2018 manman. All rights reserved.
//

import UIKit

class PersonalBannerManager: NSObject {
    
    private var personalBanner:PersonalBannerModel = PersonalBannerModel()
    
    
    
    static let shareInstance = PersonalBannerManager()
    
    private override init() {
        super.init()
        //getPersonalBannerFromNET()
    }
    
    
    public func getPersonalBannerFromNET() {
        weak var weakSelf = self
        _ = PersonalBannerServices.sharedInstance
                .getPersonalBanner()
                .subscribe { (event) in
                    
                    switch event {
                    case .next(let result):
                        weakSelf?.personalBanner = result
                    case .error(_):
                        break
                    case .completed:
                        break
                    }
                }
        
        
    }
    
    
    public func getPersonalHotelBannerList() -> [String] {
        return personalBanner.hotelBanner
    }
    
    public func getPersonalFlightBannerList() -> [String] {
        return personalBanner.airBanner
    }
    
    public func getPersonalTravelBannerList() -> [String] {
        return personalBanner.tripBanner
    }
    
    public func getPersonalVisaBannerList() -> [String] {
        return personalBanner.visaBanner
    }
    

}
