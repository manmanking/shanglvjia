//
//  PropellingManager.swift
//  shanglvjia
//
//  Created by manman on 2018/9/13.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PropellingManager: NSObject {

    //public var delegate:<JPUSHRegisterDelegate>?
    
    static let shareInstance = PropellingManager()
    
    private override init() {
        
    }
    
    public func configJpushRegister(option: [UIApplicationLaunchOptionsKey: Any]?,delegate:UIResponder) {
        
        let entity = JPUSHRegisterEntity()
        entity.types = NSInteger(JPAuthorizationOptions.alert.rawValue) | NSInteger(JPAuthorizationOptions.badge.rawValue) | NSInteger(JPAuthorizationOptions.sound.rawValue)
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: delegate as! JPUSHRegisterDelegate)
        JPUSHService.setup(withOption: option, appKey:JPushAppKey , channel: JPusHChannel, apsForProduction:false)
    }
    
    
    func HandlerNETReceiveMessage(userInfo:Dictionary<String,Any>) {
        
        
    }
    
    
    
}
