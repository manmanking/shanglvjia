//
//  PersonalBaseViewController.swift
//  shanglvjia
//
//  Created by manman on 2018/7/16.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import MapKit


class PersonalBaseViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let isSuccess = TBIFileManager.shareInstance.writeTextToDefaultFile(text:"test")
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func showBindingCompanyAccountView() {
        let changeVC:ChanegePsdViewController = ChanegePsdViewController()
        changeVC.type = "bindNum"
        self.navigationController?.pushViewController(changeVC, animated: true)
        
//        let companyAccountView = CompanyAccountViewController()
//        self.navigationController?.pushViewController(companyAccountView, animated: true)
        
    }
    
    
    func checkInstallMapType(latitudeBaidu:String , longitudeBaidu: String,latitudeGoogle:String , longitudeGoogle: String,distionName:String) {
        guard (latitudeBaidu.isEmpty == false && longitudeBaidu.isEmpty == false) &&
            (latitudeGoogle.isEmpty == false && longitudeGoogle.isEmpty == false) else {
            return
        }
        
        weak var weakSelf = self
        let alertView:UIAlertController = UIAlertController.init(title: "请选择导航App", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let systemMap:Bool = UIApplication.shared.canOpenURL(URL.init(string:"http://maps.apple.com/")!)
        let destionCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: Double(latitudeGoogle)!, longitude: Double(longitudeGoogle)!)
        var mapTypeArr:[String] = Array()
        //weak var weakSelf = self
        //let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(Double()!, Double()!);
        if systemMap {
            
            let qqAction:UIAlertAction = UIAlertAction.init(title: "苹果地图", style: UIAlertActionStyle.default) { (action) in
                
//                weakSelf?.hotel2Map(lat: latitude, lon: longitude, hotelName: distionName)
//                return
                
                let currentLocation = MKMapItem.forCurrentLocation()
                var destion = MKMapItem()
                if #available(iOS 10.0, *) {
                    destion = MKMapItem.init(placemark: MKPlacemark.init(coordinate: destionCoordinate))
                } else {
                    destion = MKMapItem.init(placemark: MKPlacemark.init(coordinate: destionCoordinate, addressDictionary: nil))
                }
                destion.name = distionName
                MKMapItem.openMaps(with: [destion], launchOptions: nil)
                
            }
            alertView.addAction(qqAction)
            
        }
        let baidumap:Bool = UIApplication.shared.canOpenURL(URL.init(string:"baidumap://")!)
        if baidumap {
            mapTypeArr.append("百度地图")
            let qqAction:UIAlertAction = UIAlertAction.init(title: "百度地图", style: UIAlertActionStyle.default) { (action) in
                let hotelMapDestination:String = "baidumap://map/geocoder?location=" + latitudeBaidu + "," + longitudeBaidu + "&coord_type=gcj02&src=" + "com.tbi.shanglvjia.debug"
                
                weakSelf?.hotel2Map(hotelMap2Geo: hotelMapDestination)
                return
               
                let firstBaseInfoStr:String = "baidumap://map/direction?origin={{我的位置}}&"
                let coorde:String = "destination=latlng:\((latitudeBaidu)),\((longitudeBaidu))|name=\((distionName ))"
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
                let hotelMapDestination = "iosamap://viewMap?sourceApplication=途途帮&poiname=" + distionName + "&lat=" + latitudeGoogle + "&lon=" + longitudeGoogle + "&dev=1"
                weakSelf?.hotel2Map(hotelMap2Geo: hotelMapDestination)
                return
                
                let firstBaseInfoStr:String = "iosamap://navi?sourceApplication=com.tbi.shanglvjia.tutubangs&backScheme=iosamap://"
                let coorde:String = "&lat=" + (latitudeGoogle) + "&lon=" + (longitudeGoogle)
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
                
//                weakSelf?.hotel2Map(lat: latitude, lon: longitude, hotelName: distionName)
//                return
                //@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving",appName,urlScheme,desCoordinate.latitude, desCoordinate.longitude
                let firstBaseInfoStr:String = "comgooglemaps://?x-source=商旅家(公务版)&x-success=com.tbi.shanglvjia.tutubangs"
                //+ (weakSelf?.hotelDetailResult.hotelDetailInfo.hotelName ?? "终点位置")!
                let coorde:String = "&saddr=&daddr=" + (latitudeGoogle) + "," + (longitudeGoogle)
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

                let hotelMapDestination:String = "https://apis.map.qq.com/tools/poimarker?type=0&marker=coord:" + latitudeGoogle + "," + longitudeGoogle + ";title:" + distionName + "&key=OB4BZ-D4W3U-B7VVO-4PJWW-6TKDJ-WPB77&referer=途途帮"
                
                weakSelf?.hotel2Map(hotelMap2Geo: hotelMapDestination)
                return
                //let desCoordinate = coordinate
                
                /*
                 
                 "apis.map.qq.com/tools/poimarker?type=0&marker=coord:39.96554,116.26719;title:成都;addr:北京市海淀区复兴路32号院|
                 coord:39.87803,116.19025;title:成都园;addr:北京市丰台区射击场路15号北京园博园|
                 coord:39.88129,116.27062;title:老成都;addr:北京市丰台区岳各庄梅市口路西府景园六号楼底商|
                 coord:39.9982,116.19015;title:北京园博园成都园;addr:北京市丰台区园博园内&key=OB4BZ-D4W3U-B7VVO-4PJWW-6TKDJ-WPB77&referer=myapp"
                 
                 https://apis.map.qq.com/tools/poimarker?type=0&marker=coord:39.96554,116.26719;title:成都;addr:北京市海淀区复兴路32号院|coord:39.87803,116.19025;title:成都园;addr:北京市丰台区射击场路15号北京园博园|coord:39.88129,116.27062;title:老成都;addr:北京市丰台区岳各庄梅市口路西府景园六号楼底商|coord:39.9982,116.19015;title:北京园博园成都园;addr:北京市丰台区园博园内&key=OB4BZ-D4W3U-B7VVO-4PJWW-6TKDJ-WPB77&referer=myapp
                 
                 */
                
                
                
                let firstBaseInfoStr:String = "qqmap://map/routeplan?type=drive&from=我的位置&to=" + (distionName )
                let coorde:String = "&tocoord=" + (latitudeGoogle) + "," + (longitudeGoogle)
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
    
    func hotel2Map(hotelMap2Geo:String) {
        let mapUrl:URL = URL.init(string:hotelMap2Geo.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!
        UIApplication.shared.openURL(mapUrl)
    }
    
    
    

}
