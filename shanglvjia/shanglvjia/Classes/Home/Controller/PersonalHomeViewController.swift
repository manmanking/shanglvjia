//
//  PersonalHomeViewController.swift
//  shop
//
//  Created by SLMF on 2017/4/20.
//  Copyright © 2017年 zhangwangwang. All rights reserved.
//

import UIKit
import SwiftyJSON

extension HomeViewController {
    
    func setPersonalHomeView() {
        self.view.addSubview(baseScrollView)
        self.setScrollBanner()
        self.setHomeTabBar()
        self.setHomeHotlineView()
        self.setAD()
        self.setLowerPriceView()
    }
}

//MARK: setLowerPriceView
extension HomeViewController {
    
    func setLowerPriceView() {
        //通过接口取idList值
        
        self.baseScrollView.addSubview(lowerPriceView)
        let height = (UIScreen.main.bounds.width - 30) / 345 * 130 - 130
        lowerPriceView.snp.makeConstraints { (make) in
            make.top.equalTo(self.adView.snp.bottom).offset(10)
            make.left.equalToSuperview()
            make.height.equalTo(501.75 + height)
            make.width.equalToSuperview()
        }
    }
    
    func setLowerPriceDate(model:[HomeInfoModel.SpecialMainListResponse],imageUrl:[String]) {
        let count:CGFloat = CGFloat(model.count * 95)
        lowerPriceView.snp.updateConstraints { (make) in
            make.height.equalTo(count + 230 )
        }
        let personalHeight = 64 + personalCycleScrollView.bounds.size.height + tabBarView.bounds.size.height + 10 + hotlineView.bounds.size.height + 10 + adView.bounds.size.height + 10  + count + 230 + 44
        baseScrollView.contentSize = CGSize.init(width: 0, height: personalHeight)
        baseScrollView.showsVerticalScrollIndicator = false
        
        self.lowerPriceView.setContentViews(model: model,imageUrl: imageUrl)
        self.lowerPriceView.homeLowerPriceIdViewBlock = { (id) in
            let specialProductView = SpecialDetailViewController()
            let productId = homeInfoModel?.airticketsHot[id].productId
            specialProductView.productId = productId
            self.navigationController?.pushViewController(specialProductView, animated: true)
        }
        self.lowerPriceView.homeLowerPriceViewBlock = { (title) in
            print("viewcontroller into here ...")
           self.intoNextSpecialProductView(selectedCategory: SpecialProductCategory.Default)
        }
        self.lowerPriceView.homeLowerPriceAdViewBlock = { () in
            let adv:HomeInfoModel.AdvPic = self.specialAdv[0]
            switch adv.remark1 {
            case "hotel":
                let remark2:[String] = adv.remark2.components(separatedBy: "_")
                let remark3:[String] = adv.remark3.components(separatedBy:"_")
                let hotelListView = HotelListViewController()
                hotelListView.title = remark2[0]
                hotelListView.searchCondition.cityId = remark2[1]
                hotelListView.searchCondition.keyWord = remark2[2]
                hotelListView.searchCondition.arrivalDate = remark3[0]
                hotelListView.searchCondition.departureDate = remark3[1]
                self.navigationController?.pushViewController(hotelListView, animated: true)
                break
            case "travel":
                let remark2:String = adv.remark2
                let travelProductView = TravelDetailViewController()
                travelProductView.productId = remark2
                self.navigationController?.pushViewController(travelProductView, animated: false)
                break
            case "special":
                let remark2:String = adv.remark2
                let specialProductView = SpecialDetailViewController()
                let productId = remark2
                specialProductView.productId = productId
                self.navigationController?.pushViewController(specialProductView, animated: false)
                break
            case "adv":
                let adView = ADViewController()
                adView.tarUrl = adv.advUrl
                adView.title = adv.advTitle
                self.navigationController?.pushViewController(adView, animated: false)
                break
            default:
                break
            }
        }
    }
    
    
    func intoNextSpecialProductView(selectedCategory:SpecialProductCategory) {
//        getSpecialProductCategory()
        let specialProductView = SpecialProductViewController()
            specialProductView.selectedCategoryIndex = selectedCategory
            print(selectedCategory)
        //if specialProductView.titleTopCategoryListDataSources.count < 2 {
            let allModel:SpecialProductCategoryModel =  SpecialProductCategoryModel()
            allModel.id = ""
            allModel.productType = "全部"
            specialProductView.titleTopCategoryListDataSources.append(allModel)
            //self.getSpecialProductCategoryFormNetwork()
        self.showLoadingView()
        weak var weakSelf = self
        SpecialProductService.sharedInstance
            .getSpecialProductCategory()
            .subscribe{ event in
                weakSelf?.hideLoadingView()
                if case .next(let result) = event
                {
                    //print(result)
                    if (specialProductView.titleTopCategoryListDataSources.count) > 1
                    {
                        specialProductView.titleTopCategoryListDataSources.removeAll()
                        let allModel:SpecialProductCategoryModel =  SpecialProductCategoryModel()
                        allModel.id = ""
                        allModel.productType = "全部"
                        specialProductView.titleTopCategoryListDataSources.append(allModel)
                    }
                    specialProductView.titleTopCategoryListDataSources.append(contentsOf: result)
                    weakSelf?.navigationController?.pushViewController((specialProductView), animated: true)

                }
                if case .error(let result) = event
                {
                    print("=====失败======\n \(result)")
                    //处理异常
                    try? weakSelf?.validateHttp(result)
                }
            }.disposed(by: bag)
        
        
        
        //}else
//        {
//            self.navigationController?.pushViewController(specialProductView, animated: true)    
//        }
    }
    
    //
    //    func getSpecialProductCategoryFormNetwork() {
    //        weak var weakSelf = self
    //        self.showLoadingView()
    //        SpecialProductService.sharedInstance
    //            .getSpecialProductCategory()
    //            .subscribe{ event in
    //                weakSelf?.hideLoadingView()
    //                if case .next(let result) = event
    //                {
    //                    print(result)
    //                    if (weakSelf?.specialProductView.titleTopCategoryListDataSources.count)! > 1
    //                    {
    //                        weakSelf?.specialProductView.titleTopCategoryListDataSources.removeAll()
    //                        let allModel:SpecialProductCategoryModel =  SpecialProductCategoryModel()
    //                        allModel.id = ""
    //                        allModel.productType = "全部"
    //                        weakSelf?.specialProductView.titleTopCategoryListDataSources.append(allModel)
    //                    }
    //                    weakSelf?.specialProductView.titleTopCategoryListDataSources.append(contentsOf: result)
    //                    weakSelf?.navigationController?.pushViewController((weakSelf?.specialProductView)!, animated: true)
    //
    //                }
    //                if case .error(let result) = event
    //                {
    //                    print("=====失败======\n \(result)")
    //                    //处理异常
    //                    try? weakSelf?.validateHttp(result)
    //                }
    //            }.disposed(by: bag)
    //    }
    
    
    
    
    
    
    
    
    
    
    
    
}

extension HomeViewController: SDCycleScrollViewDelegate{
    //／ 轮播图点击回掉
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        var adv:HomeInfoModel.AdvPic
        if cycleScrollView == personalCycleScrollView{
            adv = self.personalAdv[index]
        }else {
            adv = self.companyAdv[index]
        }
        switch adv.remark1 {
        case "hotel":
            let remark2:[String] = adv.remark2.components(separatedBy: "_")
            let remark3:[String] = adv.remark3.components(separatedBy:"_")
            if cycleScrollView == personalCycleScrollView{
                let hotelListView = HotelListViewController()
                hotelListView.title = remark2[0]
                hotelListView.searchCondition.cityId = remark2[1]
                hotelListView.searchCondition.keyWord = remark2[2]
                hotelListView.searchCondition.arrivalDate = remark3[0]
                hotelListView.searchCondition.departureDate = remark3[1]
                self.navigationController?.pushViewController(hotelListView, animated: true)
            }
            if cycleScrollView == companyCycleScrollView {
              
                // 广告页 跳转  将 自己带入到 备选状态
                // 没有备选的旅客  将自己加入到备选状态
                // 旅客信息  应该 由一个旅客管理  统一处理
                //add by manman on 2017-10-11 start of line
                
                let details = UserDefaults.standard.string(forKey: USERINFO)
                if details != nil {
                    let jdetails = JSON(parseJSON: details!)
                    let traveller = Traveller(jsonData:jdetails["coUser"]["traveller"])
                    //personalDataSourcesArr.removeAll()
                    _ = PassengerManager.shareInStance.passengerDeleteAll()
                    //personalDataSourcesArr.append(traveller)
                    PassengerManager.shareInStance.passengerAdd(passenger: traveller)
                }
                
                
                //end of line
                
                
                let hotelCompanyListView = HotelCompanyListViewController()
                hotelCompanyListView.title = remark2[0]
                hotelCompanyListView.searchCondition.cityId = remark2[1]
                hotelCompanyListView.searchCondition.keyWord = remark2[2]
                hotelCompanyListView.searchCondition.arrivalDate = remark3[0]
                hotelCompanyListView.searchCondition.departureDate = remark3[1]
                self.navigationController?.pushViewController(hotelCompanyListView, animated: true)
            }
            break
        case "travel":
            let remark2:String = adv.remark2
            let travelProductView = TravelDetailViewController()
            travelProductView.productId = remark2
            self.navigationController?.pushViewController(travelProductView, animated: false)
            break
        case "special":
            let remark2:String = adv.remark2
            let specialProductView = SpecialDetailViewController()
            let productId = remark2
            specialProductView.productId = productId
            self.navigationController?.pushViewController(specialProductView, animated: false)
            break
        case "adv":
            let adView = ADViewController()
            adView.tarUrl = adv.advUrl
            adView.title = adv.advTitle
            self.navigationController?.pushViewController(adView, animated: false)
            break
        default:
            break
        }
    }
}

//MARK: setAD
extension HomeViewController {
    
    func setAD() {
        let raw: Float = Float((UIScreen.main.bounds.width - 30) / 345)
        self.baseScrollView.addSubview(adView)
        adView.snp.makeConstraints { (make) in
            make.top.equalTo(self.hotlineView.snp.bottom).offset(10)
            make.left.equalToSuperview()
            make.height.equalTo(110 * raw + 30)
            make.width.equalToSuperview()
        }
        adView.lowerPrice.addOnClickListener(target: self, action:  #selector(lowerPriceClick))
        adView.protocolHotel.addOnClickListener(target: self, action:  #selector(protocolHotelClick))
        adView.customTravel.addOnClickListener(target: self, action:  #selector(customTravelClick))
    }
    func  lowerPriceClick(){
//        let vc = SpecialProductViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
        self.intoNextSpecialProductView(selectedCategory: SpecialProductCategory.Flight)
    }
    func  protocolHotelClick(){
        let vc = HotelSearchViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func  customTravelClick(){
        if self.islogin() {
        let vc = TravelDIYIntentOrderController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

//MARK: setHomeHotline
extension HomeViewController {
    
    func setHomeHotlineView() {
        self.baseScrollView.addSubview(hotlineView)
        hotlineView.snp.makeConstraints{(make) in
            make.top.equalTo(self.tabBarView.snp.bottom).offset(10)
            make.left.equalToSuperview()
            make.height.equalTo(256.5)
            make.width.equalToSuperview()
        }
    }
    func setHomeHotlineData(model:[HomeInfoModel.SpecialMainListResponse]) {
        hotlineView.contentListView.contentSize = CGSize.init(width: 166 * model.count + 20, height: 0)
        hotlineView.contentListView.showsHorizontalScrollIndicator = false
        self.hotlineView.setContentViews(model: model)
        
        self.hotlineView.homeHotLineIdViewBlock = { (id) in
            let travelProductView = TravelDetailViewController()
            let productId = homeInfoModel?.travelHot[id].productId
            travelProductView.productId = productId
            self.navigationController?.pushViewController(travelProductView, animated: true)
        }
        self.hotlineView.homeHotLineViewBlock = { (title) in
            let vc = TravelHomeViewController()
            self.navigationController?.pushViewController(vc, animated: true)
          
        }
    }
}

//MARK: setHomeTabBar
extension HomeViewController {
    
    func setHomeTabBar() {
        let radView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        self.baseScrollView.addSubview(radView)
        radView.backgroundColor = .white
        radView.layer.cornerRadius = 10
        self.baseScrollView.addSubview(tabBarView)
        radView.snp.makeConstraints{(make) in
            make.left.equalToSuperview()
            make.top.equalTo(self.personalCycleScrollView.snp.bottom).offset(-10)
            make.width.equalToSuperview()
            make.height.equalTo(20)
        }
        tabBarView.snp.makeConstraints{(make) in
            make.left.equalToSuperview()
            make.top.equalTo(self.personalCycleScrollView.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(105.5)
        }
        self.tabBarView.airPlaneButton.addOnClickListener(target: self, action: #selector(forwardToNextController(tap:)))
        self.tabBarView.hotelButton.addOnClickListener(target: self, action: #selector(forwardToNextController(tap:)))
        self.tabBarView.travelButton.addOnClickListener(target: self, action: #selector(forwardToNextController(tap:)))
        self.tabBarView.vehicleButton.addOnClickListener(target: self, action: #selector(forwardToNextController(tap:)))
        self.tabBarView.visaButton.addOnClickListener(target: self, action: #selector(forwardToNextController(tap:)))
        
    }
    
    func forwardToNextController(tap: UITapGestureRecognizer) {
        if tap.view == self.tabBarView.airPlaneButton {
            let flightSearchViewController = FlightSearchViewController()
            self.navigationController?.navigationBar.shadowImage = UIImage.init(named: "border")
            self.navigationController?.pushViewController(flightSearchViewController, animated: true)
        }
        if tap.view == self.tabBarView.hotelButton {
            
            
           // testMethod()
           self.navigationController?.pushViewController(HotelSearchViewController(), animated: true)
        }
        if tap.view == self.tabBarView.travelButton {
//            let tabAll = TabBarItem(text: "全部", controller: TravelListViewController())
//            let tabFlightHotel = TabBarItem(text: "机+酒", controller: TravelListViewController())
//            let tabFlight = TabBarItem(text: "机票", controller: TravelListViewController())
//            let tabTravel = TabBarItem(text: "度假", controller: TravelListViewController())
//            let tabCar = TabBarItem(text: "机+车", controller: TravelListViewController())
//            let tabVisa = TabBarItem(text: "机+签", controller: TravelListViewController())
//            let tabM = TabBarItem(text: "酒+门", controller: TravelListViewController())
//            let tabs = [tabAll,tabFlightHotel,tabFlight,tabTravel,tabCar,tabVisa,tabM]
//            let travelController = TabViewController()
//            travelController.tabBarsItem = tabs
            let vc = TravelHomeViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            //self.navigationController?.pushViewController(TravelListViewController(), animated: true)
        }
        if tap.view == self.tabBarView.vehicleButton
        {
            //接送机
            print("接送机")
            intoNextSpecialProductView(selectedCategory: SpecialProductCategory.SpecialCar)
            
            
        }
        //签证
        if tap.view == self.tabBarView.visaButton {
            print("签证")
            intoNextSpecialProductView(selectedCategory: SpecialProductCategory.Visa)
        }
    }
    
    
    //MARK:--- 测试
    func testMethod() {
        let calendarView = TBICalendarViewController()
        calendarView.selectedDates = ["2017-07-14 16:00:00","2017-07-15 16:00:00"]
        self.navigationController?.pushViewController(calendarView, animated: true)
    }
    
    
}

//MARK: setScrollBanner
extension HomeViewController {
    
    func setScrollBanner() {
        self.baseScrollView.addSubview(personalCycleScrollView)
        personalCycleScrollView.snp.makeConstraints{(make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(130)
            make.width.equalTo(ScreenWindowWidth)
        }
//        self.baseScrollView.addSubview(imageScrollView)
//        imageScrollView.snp.makeConstraints{(make) in
//            make.left.equalToSuperview()
//            make.top.equalToSuperview()
//            make.height.equalTo(130)
//            make.width.equalToSuperview()
//        }
//        imageScrollView.setImages(initImagesNameArray())
//        imageScrollView.setButtonTouchUpInsideClosure { (index) in
//            print("图片\(index)")
//        }
    }
    
//    func initImagesNameArray() -> Array<AnyObject>{
//        var imagesNameArray: Array<AnyObject> = []
//        //添加本地图片
//        imagesNameArray.append("Home_Banner_1" as AnyObject)
//        imagesNameArray.append("Home_Banner_2" as AnyObject)
//        imagesNameArray.append("Home_Banner_3" as AnyObject)
//        return imagesNameArray
//    }
    
}

class HomeADView: UIView {
    
    let protocolHotel = UIImageView.init(image: UIImage.init(named: "Home_Personal_Banner_ProtocolHotel"))
    let customTravel = UIImageView.init(image: UIImage.init(named: "Home_Personal_Banner_CustomTravel"))
    let lowerPrice = UIImageView.init(image: UIImage.init(named: "Home_Personal_Banner_lowerPrice"))
    let raw: Float = Float((UIScreen.main.bounds.width - 30) / 345)
    
    init() {
        super.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        self.backgroundColor = .white
        self.addSubview(protocolHotel)
        self.addSubview(customTravel)
        self.addSubview(lowerPrice)
        protocolHotel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(15)
            make.width.equalTo(168 * raw)
            make.height.equalTo(110 * raw)
        }
        customTravel.snp.makeConstraints { (make) in
            make.left.equalTo(protocolHotel.snp.right).offset(10 * raw)
            make.top.equalTo(protocolHotel.snp.top)
            make.width.equalTo(protocolHotel.snp.width)
            make.height.equalTo(50 * raw)
        }
        lowerPrice.snp.makeConstraints { (make) in
            make.left.equalTo(customTravel.snp.left)
            make.top.equalTo(customTravel.snp.bottom).offset(10 * raw)
            make.width.equalTo(customTravel.snp.width)
            make.height.equalTo(customTravel.snp.height)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
