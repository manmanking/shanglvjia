//
//  HotelMapNavigationViewController.swift
//  shanglvjia
//
//  Created by manman on 2018/6/14.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import MapKit

class HotelMapNavigationViewController: CompanyBaseViewController,MAMapViewDelegate ,AMapLocationManagerDelegate{

    public var hotelDetailResult:HotelDetailResult = HotelDetailResult()
    
    private let pointReuseIndentifier:String = "pointReuseIndetifier"
    
    private let mapView:MAMapView = MAMapView()
    
    private var hotelPointAnnotation:MAPointAnnotation = MAPointAnnotation()
    
    private let locationManager:AMapLocationManager = AMapLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = TBIThemeBaseColor
        setBlackTitleAndNavigationColor(title: "地图")
        setUIViewAutolayout()
    }
    
    
    func setUIViewAutolayout() {
        
        
        
        mapView.delegate = self
        mapView.showsCompass = false
        mapView.mapType = MAMapType.standard
        mapView.zoomLevel = 17
        mapView.showsUserLocation = false
        self.view.addSubview(mapView)
        self.view.sendSubview(toBack: mapView)
        mapView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
         setMapViewCenter(latitude: hotelDetailResult.hotelDetailInfo.latitudeGoogle, longtitude: hotelDetailResult.hotelDetailInfo.longitudeGoogle)
        
//        setHotelItemToMap()
//        selectedHotelShowTip()
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        setHotelItemToMap()
    }
    
    func setHotelItemToMap() {
        guard hotelDetailResult.hotelDetailInfo.latitudeGoogle.isEmpty == false && hotelDetailResult.hotelDetailInfo.longitudeGoogle.isEmpty == false  else {
            return
        }
        let localDefault:CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: CLLocationDegrees.init(floatLiteral: Double(hotelDetailResult.hotelDetailInfo.latitudeGoogle)! ), longitude: CLLocationDegrees.init(floatLiteral: Double(hotelDetailResult.hotelDetailInfo.longitudeGoogle)!))
        hotelPointAnnotation.coordinate = localDefault
        hotelPointAnnotation.title = hotelDetailResult.hotelDetailInfo.hotelName
        let hotelItemAnnotation:MAAnimatedAnnotation = MAAnimatedAnnotation()
        hotelItemAnnotation.title = hotelDetailResult.hotelDetailInfo.hotelName
        hotelItemAnnotation.coordinate = localDefault
        mapView.addAnnotation(hotelPointAnnotation)
        mapView.selectAnnotation(hotelPointAnnotation, animated: true)
       
        
        
    }
    
    func selectedHotelShowTip() {
        
        
    }
    
    
    
    
    func setMapViewCenter(latitude:String,longtitude:String) {
        let locationCoordinate = CLLocationCoordinate2D.init(latitude: Double(latitude)!, longitude: Double(longtitude)!)
        mapView.setCenter(locationCoordinate, animated: true)
    }
    
    ///MARk:-------MAMapViewDelegate---------
    internal func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
      
        if annotation is MAPointAnnotation {
            
            var annotationView:MAAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndentifier)
            if annotationView == nil {
                annotationView = MAAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndentifier)
            }
            printDebugLog(message: "into here  mapview for")
            annotationView?.canShowCallout = true
            let rightButton:UIButton = UIButton()
            rightButton.setTitle("导航", for: UIControlState.normal)
            rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
            rightButton.setBackgroundImage(UIImage (named: "yellow_btn_gradient"), for: UIControlState.normal)
            rightButton.clipsToBounds=true
            rightButton.frame = CGRect.init(x: 0, y: 0, width: 46, height: 46)
            rightButton.addTarget(self, action: #selector(mapNaviQuick(sender:)), for: UIControlEvents.touchUpInside)
            annotationView?.rightCalloutAccessoryView = rightButton
            annotationView?.image = UIImage.init(named: "ic_hotel")
            annotationView?.centerOffset = CGPoint.init(x: 0, y: -10)
            return annotationView
        }
        return nil
        
    }
    
    
    func mapViewDidFinishLoadingMap(_ mapView: MAMapView!) {
        printDebugLog(message: "into here  mapview for finish")
    }
    func mapViewDidFailLoadingMap(_ mapView: MAMapView!, withError error: Error!) {
        printDebugLog(message: "地图加载失败")
    }
    
    func checkInstallMapType() {
        var alertView:UIAlertController = UIAlertController.init(title: "请选择导航App", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let systemMap:Bool = UIApplication.shared.canOpenURL(URL.init(string:"http://maps.apple.com/")!)
        let destionCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: Double(hotelDetailResult.hotelDetailInfo.latitudeGoogle)!, longitude: Double(hotelDetailResult.hotelDetailInfo.longitudeGoogle)!)
        var mapTypeArr:[String] = Array()
        weak var weakSelf = self
        //let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(Double()!, Double()!);
        if systemMap {
            
            let qqAction:UIAlertAction = UIAlertAction.init(title: "苹果地图", style: UIAlertActionStyle.default) { (action) in
                
                let currentLocation = MKMapItem.forCurrentLocation()
                var destion = MKMapItem()
                if #available(iOS 10.0, *) {
                   destion = MKMapItem.init(placemark: MKPlacemark.init(coordinate: destionCoordinate))
                } else {
                    destion = MKMapItem.init(placemark: MKPlacemark.init(coordinate: destionCoordinate, addressDictionary: nil))
                }
                destion.name = weakSelf?.hotelDetailResult.hotelDetailInfo.hotelName ?? "终点位置"
                MKMapItem.openMaps(with: [currentLocation,destion], launchOptions: [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving])
                
            }
            alertView.addAction(qqAction)
            
        }
        let baidumap:Bool = UIApplication.shared.canOpenURL(URL.init(string:"baidumap://")!)
        if baidumap {
            mapTypeArr.append("百度地图")
            let qqAction:UIAlertAction = UIAlertAction.init(title: "百度地图", style: UIAlertActionStyle.default) { (action) in
                    let firstBaseInfoStr:String = "baidumap://map/direction?origin={{我的位置}}&"
                    let coorde:String = "destination=latlng:\((weakSelf?.hotelDetailResult.hotelDetailInfo.latitude)!),\((weakSelf?.hotelDetailResult.hotelDetailInfo.longitude)!)|name=\((weakSelf?.hotelDetailResult.hotelDetailInfo.hotelName ?? "终点位置")!)"
                    let endStr = "&mode=driving&src=com.tbi.shanglvjia.tutubangs"
                    let urlMapStr:String = (firstBaseInfoStr + coorde + endStr)
                    let mapUrl:URL = URL.init(string:urlMapStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!
                    UIApplication.shared.openURL(mapUrl)
                
            }
            alertView.addAction(qqAction)
        }
        
        let gaodemap:Bool = UIApplication.shared.canOpenURL(URL.init(string:"iosamap://")!)
        if gaodemap {
            mapTypeArr.append("高德地图")
            let qqAction:UIAlertAction = UIAlertAction.init(title: "高德地图", style: UIAlertActionStyle.default) { (action) in
                    
                    //let desCoordinate = coordinate
                    // @"iosamap://path?sourceApplication=applicationName&sid=BGVIS1&sname=%@&did=BGVIS2&dlat=%f&dlon=%f&dev=0&m=0&t=0",@"我的位置",desCoordinate.latitude, desCoordinate.longitude
                //"iosamap://navi?sourceApplication=app名&backScheme=iosamap://&lat=\(self.centerLat)&lon=\(self.centerLng)&dev=0&style=2"
                    let firstBaseInfoStr:String = "iosamap://navi?sourceApplication=com.tbi.shanglvjia.tutubangs&backScheme=iosamap://"
                        //+ (weakSelf?.hotelDetailResult.hotelDetailInfo.hotelName ?? "终点位置")!
                    let coorde:String = "&lat=" + (weakSelf?.hotelDetailResult.hotelDetailInfo.latitudeGoogle)! + "&lon=" + (weakSelf?.hotelDetailResult.hotelDetailInfo.longitudeGoogle)!
                    let endStr = "&dev=0&style=2"
                    let urlMapStr:String = (firstBaseInfoStr + coorde + endStr)
                    let mapUrl:URL = URL.init(string:urlMapStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!
                    UIApplication.shared.openURL(mapUrl)
                }
                alertView.addAction(qqAction)
        }
        
        let googlemap:Bool = UIApplication.shared.canOpenURL(URL.init(string:"comgooglemaps://")!)
        if googlemap {
            mapTypeArr.append("谷歌地图")
            let qqAction:UIAlertAction = UIAlertAction.init(title: "谷歌地图", style: UIAlertActionStyle.default) { (action) in
                
                //@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving",appName,urlScheme,desCoordinate.latitude, desCoordinate.longitude
                let firstBaseInfoStr:String = "comgooglemaps://?x-source=商旅家(公务版)&x-success=com.tbi.shanglvjia.tutubangs"
                    //+ (weakSelf?.hotelDetailResult.hotelDetailInfo.hotelName ?? "终点位置")!
                let coorde:String = "&saddr=&daddr=" + (weakSelf?.hotelDetailResult.hotelDetailInfo.latitudeGoogle)! + "," + (weakSelf?.hotelDetailResult.hotelDetailInfo.longitudeGoogle)!
                let endStr = "&directionsmode=driving"
                let urlMapStr:String = (firstBaseInfoStr + coorde + endStr)
                let mapUrl:URL = URL.init(string:urlMapStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!
                UIApplication.shared.openURL(mapUrl)
            }
            alertView.addAction(qqAction)
        }
        let qqmap:Bool = UIApplication.shared.canOpenURL(URL.init(string:"qqmap://")!)
        if qqmap {
            mapTypeArr.append("腾讯地图")
            let qqAction:UIAlertAction = UIAlertAction.init(title: "腾讯地图", style: UIAlertActionStyle.default) { (action) in
                
                //let desCoordinate = coordinate
                let firstBaseInfoStr:String = "qqmap://map/routeplan?type=drive&from=我的位置&to=" + (weakSelf?.hotelDetailResult.hotelDetailInfo.hotelName ?? "终点位置")!
                let coorde:String = "&tocoord=" + (weakSelf?.hotelDetailResult.hotelDetailInfo.latitudeGoogle)! + "," + (weakSelf?.hotelDetailResult.hotelDetailInfo.longitudeGoogle)!
                let endStr = "&policy=1&referer=MapJump"
                let urlMapStr:String = (firstBaseInfoStr + coorde + endStr)
                let mapUrl:URL = URL.init(string:urlMapStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!
                UIApplication.shared.openURL(mapUrl)
            }
            alertView.addAction(qqAction)
        }
        let cancelAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel)
            
            //[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        alertView.addAction(cancelAction)
        
        
        self.present(alertView, animated: true, completion: nil)
        
    }
    
    
    
    
    
    
    
    
    
    func mapNaviQuick(sender:UIButton) {
        
        checkInstallMapType()

    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func backButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
