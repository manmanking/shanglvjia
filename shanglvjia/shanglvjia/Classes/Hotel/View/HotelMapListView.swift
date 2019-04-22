//
//  HotelMapListView.swift
//  shanglvjia
//
//  Created by manman on 2018/4/26.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit


class HotelMapListView: UIView ,MAMapViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

    typealias  HotelMapListViewSelectedBlock = (NSInteger)->Void
    
    typealias  HotelMapListViewUpdateHotelBlock = (Double,Double)->Void
    
    public var hotelMapListViewUpdateHotelBlock:HotelMapListViewUpdateHotelBlock!
    
    public var hotelMapListViewSelectedBlock:HotelMapListViewSelectedBlock!
    
    private let userLocationReuseIndetifier:String = "userLocationReuseIndetifier"
    
    private let pointReuseIndentifier:String = "pointReuseIndetifier"
    
    private let collectionViewCellIdentify:String = "collectionViewCellIdentify"
    
    private var hotelList:HotelListNewModel = HotelListNewModel()
    
    private let mapView:MAMapView = MAMapView()
    
    private var hotelListCollection:UICollectionView?
    
    private var scrollViewItemWidth:Double = 353
    
    /// 地图中间的酒店 选中的酒店
    private var currentMapCenterHotel:NSInteger = 0

    private var selectedHotelPoint:MAPointAnnotation = MAPointAnnotation()
    
    ///  酒店当前城市的 差标价格
    private var currentPolicyPrice:String = ""
    
    private var userLocationButton:UIButton = UIButton()
    

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        currentPolicyPrice = HotelManager.shareInstance.searchConditionCityCategoryRegionDraw().travelpolicyLimit
        setUIViewAutolayout()
    }
    
   
    private func setUIViewAutolayout() {
       
        mapView.delegate = self
        mapView.showsCompass = false
        mapView.zoomLevel = 15
        mapView.showsUserLocation = false
        self.addSubview(mapView)
        mapView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        let flow:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        flow.scrollDirection = UICollectionViewScrollDirection.horizontal
        flow.itemSize = CGSize.init(width: scrollViewItemWidth, height: 129)//init(width: scrollViewItemWidth, height: 129)
        flow.minimumLineSpacing = 5
        flow.sectionInset = UIEdgeInsets.init(top: 0, left:10, bottom: 0, right: 10)
        hotelListCollection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flow)
        hotelListCollection?.showsVerticalScrollIndicator = false
        hotelListCollection?.backgroundColor = UIColor.clear
        hotelListCollection?.delegate = self
        hotelListCollection?.dataSource = self
        hotelListCollection?.isPagingEnabled = false
        hotelListCollection?.register(HotelMapListPatternCollectionViewCell.classForCoder(), forCellWithReuseIdentifier:collectionViewCellIdentify)
        self.addSubview(hotelListCollection!)
        hotelListCollection?.snp.makeConstraints({ (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(129)
            make.bottom.equalToSuperview().inset(54)
        })
        
        userLocationButton.isHidden = true
        userLocationButton.backgroundColor = TBIThemeWhite
        userLocationButton.layer.cornerRadius = 2
        userLocationButton.setImage(UIImage.init(named: "ic_hotel_backLocation"), for: UIControlState.normal)
        userLocationButton.addTarget(self, action: #selector(userLocationAction(sender:)), for: UIControlEvents.touchUpInside)
        self.addSubview(userLocationButton)
        userLocationButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(15)
            make.width.height.equalTo(20)
            make.bottom.equalTo((hotelListCollection?.snp.top)!).offset(-15)
        }
        
        verifyUserLocationEnable()
        
    }
    
    private func fillLocalDataSources() {
        
    }
    
    public func fillDataSources(hotelDataSources:HotelListNewModel,isMapSearch:Bool = false) {
        currentMapCenterHotel = 0
        hotelList = hotelDataSources
        hotelListCollection?.reloadData()
        addHotel2Map(isMapSearch: isMapSearch)
       
        
        //let indexPath:IndexPath = IndexPath.init(row: currentMapCenterHotel, section: 0)
        //hotelListCollection?.scrollToItem(at:indexPath , at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
        
    }
    
    
    /// 校验是否在 本地 定位
    func verifyUserLocationEnable() {
        weak var weakSelf = self
        MapManager.sharedInstance.startLocation()
        MapManager.sharedInstance.locationCityBlock = { (cityName,location) in
            let searchCondition:HotelListRequest = HotelManager.shareInstance.searchConditionUserDraw()
            if cityName.isEmpty == false && cityName.contains(searchCondition.cityName) {
                weakSelf?.userLocationButton.isHidden = false
            }
            
//            if searchCondition.currentCityName.isEmpty == false && cityName.contains(searchCondition.currentCityName) == true {
//                    weakSelf?.userLocationButton.isHidden = false
//            }
        }
    }
    
    
    /// 设置 地图显示 中心 酒店
    func resetMapCenter(hotel:HotelListNewItem) {
          let localDefault:CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: CLLocationDegrees.init(floatLiteral: Double(hotel.latitude)! ), longitude: CLLocationDegrees.init(floatLiteral: Double(hotel.longitude )!))
        mapView.setCenter(localDefault, animated: true)
    }
    
    
    
    /// 首次将酒店展示在酒店
    func addHotel2Map(isMapSearch:Bool = false) {
        guard hotelList.result.count > 0 else {
            return
        }
        var hotel:[MAPointAnnotation] = Array()
        for element in hotelList.result {
            let pointAnnotation:MAAnimatedAnnotation = MAAnimatedAnnotation()
            let localDefault:CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: CLLocationDegrees.init(floatLiteral: Double(element.latitude)! ), longitude: CLLocationDegrees.init(floatLiteral: Double(element.longitude )!))
            pointAnnotation.coordinate = localDefault
            pointAnnotation.title = element.hotelName
            hotel.append(pointAnnotation)
        }
        if mapView.annotations.count > 0 {
            mapView.removeAnnotations(mapView.annotations)
        }
        if hotel.count > currentMapCenterHotel {
            selectedHotelPoint = hotel[currentMapCenterHotel]
        }
        
        mapView.addAnnotations(hotel)
        mapView.selectAnnotation(selectedHotelPoint, animated: true)
        if hotelList.result.count > currentMapCenterHotel && isMapSearch == false {
            resetMapCenter(hotel: hotelList.result[currentMapCenterHotel])
            
        }
        
        
    }
    
    ///MARk:-------气泡-----
    func setMapViewSelectedHotel() {
    
        let element:HotelListNewItem = hotelList.result[currentMapCenterHotel]
        let pointAnnotation:MAAnimatedAnnotation = MAAnimatedAnnotation()
        let localDefault:CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: CLLocationDegrees.init(floatLiteral: Double(element.latitude)! ), longitude: CLLocationDegrees.init(floatLiteral: Double(element.longitude )!))
        pointAnnotation.coordinate = localDefault
        pointAnnotation.title = element.hotelName
        mapView.selectAnnotation(pointAnnotation, animated: true)
    }
    
    
    
    ///MARk:-------MAMapViewDelegate---------
    internal func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        guard annotation is MAUserLocation == false else {
            var userView = mapView.dequeueReusableAnnotationView(withIdentifier: userLocationReuseIndetifier)
            if userView == nil {
                userView = MAAnnotationView(annotation: annotation, reuseIdentifier: userLocationReuseIndetifier)
            }
            userView!.image = UIImage(named: "userPosition")
            return userView!
        }
        if annotation is MAPointAnnotation {
            
            var annotationView:MAAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndentifier)
            if annotationView == nil {
                annotationView = MAAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndentifier)
            }
            annotationView?.canShowCallout = true
            annotationView?.image = UIImage.init(named: "ic_hotel")
            annotationView?.centerOffset = CGPoint.init(x: 0, y: -10)
            return annotationView
        }
        return nil
        
    }
    func mapView(_ mapView: MAMapView!, didSelect view: MAAnnotationView!) {
        for (index,element) in hotelList.result.enumerated() {
            if view.annotation.coordinate.latitude ==  Double(element.latitude) &&
                view.annotation.coordinate.longitude == Double(element.longitude) {
                currentMapCenterHotel = index
                
            }
        }
        view.image = UIImage.init(named: "ic_hotel_sel")
        let indexPath:IndexPath = IndexPath.init(row: currentMapCenterHotel, section: 0)
        hotelListCollection?.scrollToItem(at:indexPath , at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
    }
    
    func mapView(_ mapView: MAMapView!, didDeselect view: MAAnnotationView!) {
        if view.annotation is MAPointAnnotation {
            view.image = UIImage.init(named:"ic_hotel")
        }
        
    }
    
    func mapView(_ mapView: MAMapView!, mapDidMoveByUser wasUserAction: Bool) {

        //HotelManager
        printDebugLog(message: wasUserAction == true ? "是":"否")

        if hotelMapListViewUpdateHotelBlock != nil && wasUserAction == true {
            let lon:Double = mapView.centerCoordinate.longitude
            let lat:Double = mapView.centerCoordinate.latitude
            hotelMapListViewUpdateHotelBlock(lon,lat)
        }
        
        
//        printDebugLog(message: wasUserAction == true ? "是":"否")
//
//        if hotelMapListViewUpdateHotelBlock != nil && wasUserAction == true {
//            let lon:Double = mapView.centerCoordinate.longitude
//            let lat:Double = mapView.centerCoordinate.latitude
//            hotelMapListViewUpdateHotelBlock(lon,lat)
//        }
    }
    
    
    
    //MARK:------UICollectionViewDataSource--------

    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hotelList.result.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:HotelMapListPatternCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellIdentify, for: indexPath) as! HotelMapListPatternCollectionViewCell
        if hotelList.result.count > indexPath.row {
            cell.fillDataSources(hotelItem: hotelList.result[indexPath.row], policyPrice:currentPolicyPrice)
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        printDebugLog(message: "选中")
        hotelMapListViewSelectedBlock(indexPath.row)
        //        currentMapCenterHotel = indexPath.row
        //        setMapViewSelectedHotel()
    }
    
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        
//
//        
//    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("willDisplay",indexPath.item)
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        caculateScrollViewContentOffsetX(offsetX: scrollView.contentOffset.x)
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            caculateScrollViewContentOffsetX(offsetX: scrollView.contentOffset.x)
        }
    }
    
    func caculateScrollViewContentOffsetX(offsetX:CGFloat) {
        
       
        let selectedItem:NSInteger = caculateScrollViewHotelItem(offsetX: offsetX)
        if hotelList.result.count > selectedItem {
            adjustMapSelectedHotel(selectedItem: selectedItem)
        }else {
            if hotelList.result.count > selectedItem - 1 && selectedItem - 1 >= 0 {
                adjustMapSelectedHotel(selectedItem: selectedItem - 1)
            }
        }
    
    }
    
    func caculateScrollViewHotelItem(offsetX:CGFloat) -> NSInteger {
        let selectedItem:NSInteger = NSNumber.init(value:ceilf(Float(offsetX / CGFloat(scrollViewItemWidth)))).intValue
        return selectedItem
    }
    
    
    
    
    func adjustMapSelectedHotel(selectedItem:NSInteger) {
        currentMapCenterHotel = selectedItem
        addHotel2Map()
    }
    
    
    func userLocationAction(sender:UIButton) {
        weak var weakSelf = self
        MapManager.sharedInstance.startLocation()
        MapManager.sharedInstance.locationCityBlock = { (_ ,location) in
            printDebugLog(message: location)
            guard location != nil else {
                return
            }
            weakSelf?.mapView.setCenter((location?.coordinate)!, animated: true)
            let lon:Double = location?.coordinate.longitude ?? 0
            let lat:Double = location?.coordinate.latitude ?? 0
            weakSelf?.hotelMapListViewUpdateHotelBlock(lon,lat)
            
        }
    }
    
    //MARK:----------Action---------
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    


}
