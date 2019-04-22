//
//  MapManager.swift
//  shop
//
//  Created by manman on 2017/6/3.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class MapManager: NSObject,AMapLocationManagerDelegate {

    typealias MapManagerLocationCityBlock = (String,CLLocation?)->Void
    public  var locationCityBlock:MapManagerLocationCityBlock!
    static  let sharedInstance = MapManager()
    private let locationManager:AMapLocationManager = AMapLocationManager()
    
    private override init() {
        super.init()
        print("init ...")
        configLocationMap()
    }

    
   private func configLocationMap()  {
        print("init configLocationMap ...")
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.pausesLocationUpdatesAutomatically = false
        //locationManager.allowsBackgroundLocationUpdates = true
        locationManager.locationTimeout = 6
        locationManager.reGeocodeTimeout = 3
    
                
    
    
        //locationManager.allowsBackgroundLocationUpdates = true
        //startSerialLocation()
    }
    
    
    
    public func startLocation()
    {
        //locationManager.startUpdatingLocation()
        locateAction()
    }
    
    
    //单次定位
    private func locateAction()
    {
        weak var weakSelf = self
        locationManager.requestLocation(withReGeocode: true, completionBlock: { (location, regeocode, error) in
            if (error != nil)
            {
                weakSelf?.locationCityBlock("定位",nil)
                return
            }
            var cityName = ""
            //逆地理信息
            guard regeocode?.city != nil else
            {
                
                cityName = "定位了"//页面做处理了
                weakSelf?.locationCityBlock(cityName,location)
                return
            }
            cityName = (regeocode?.city)!
            weakSelf?.locationCityBlock(cityName,location)
        })
    }
    
    
    
}


extension MapManager
{
//    func amapLocationManager(_ manager: AMapLocationManager!, didFailWithError error: Error!) {
//        
//        print("amapLocationManager",manager.classForCoder,"error",error)
//        
//    }
//    
//    
//    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!) {
//        NSLog("location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
//    }
//    
    
    // 逆地理编码 请求
    func searchReGeocodeWithCoordinate(coordinate:CLLocationCoordinate2D){
        
//        let rego = AMapReGeocodeSearchRequest()
//        rego.location = AMapGeoPoint.location(withLatitude: CGFloat(coordinate.latitude), longitude: CGFloat(coordinate.longitude));
//        rego.requireExtension = true
//        locationManager.amap
        
//        .aMapReGoecodeSearch(rego)
        
    }
    
    
    
    
}
