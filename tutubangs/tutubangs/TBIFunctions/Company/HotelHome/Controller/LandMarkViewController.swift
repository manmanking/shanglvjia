//
//  LandMarkViewController.swift
//  shanglvjia
//
//  Created by manman on 2018/4/23.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class LandMarkViewController: CompanyBaseViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    typealias LandMarkViewSelectedRegionBlock = (CityCategoryRegionModel.RegionModel,NSInteger)->Void
    
    public var landMarkViewSelectedRegionBlock:LandMarkViewSelectedRegionBlock!
    
    public var elongId:String = ""
    
    private var regionCollection:UICollectionView?
    
    public var cityCategoryRegionModel:CityCategoryRegionModel = CityCategoryRegionModel()
    
    
    /// 地标 试图 展示的类型
    public var landMarkViewType:AppModelCatoryENUM = AppModelCatoryENUM.Default
    
    
    private var collectionSectionTitle:[String] = Array()
    
    private var collectionViewCellIdentify:String = "collectionViewCellIdentify"
    
    private var CityCategoryRegionCollectionReusableFooterViewIdentify:String = "CityCategoryRegionCollectionReusableFooterViewIdentify"
    
    private var CityCategoryRegionCollectionReusableHeaderViewIdentify:String = "CityCategoryRegionCollectionReusableHeaderViewIdentify"
    
    private var screentCapacityIteam:Int  = 0
    
    /// false 关闭。true 全部打开
    private var districtRegionFold:Bool = false
    private var landmarkRegionFold:Bool = false
    private var commericalRegionFold:Bool = false
    
    private var foldArr:[Bool] = Array()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBlackTitleAndNavigationColor(title: "区域位置")
        setNavigationBgColor(color: TBIThemeWhite)
        self.view.backgroundColor = TBIThemeBaseColor
        self.navigationController?.navigationBar.isTranslucent = false
        fillLocalData()
        setUIViewAutolayout()
       
        
    }
    
    
    func fillLocalData() {
        
        switch landMarkViewType {
        case .CompanyHotel:
            cityCategoryRegionModel = HotelManager.shareInstance
                .searchConditionCityCategoryRegionDraw()
        case .PersonalHotel:
            cityCategoryRegionModel = PersonalHotelManager.shareInstance
                .searchConditionCityCategoryRegionDraw()
        case .Default:
            cityCategoryRegionModel = HotelManager.shareInstance
                .searchConditionCityCategoryRegionDraw()
        default: break
            
        }
        
        screentCapacityIteam =  Int(floor((ScreenWindowWidth - 30)/80))
        foldArr = [districtRegionFold,landmarkRegionFold,commericalRegionFold]
        collectionSectionTitle = ["行政区","地标","商圈"]
        if cityCategoryRegionModel.commericalRegion.isEmpty == true {
            getLandmark(cityId: elongId)
        }
        
        
    }
    
    func getLandmark(cityId:String) {
        weak var weakSelf = self
        ///showLoadingView()
        let policyId:String = PassengerManager.shareInStance.passengerSVDraw().first?.policyId ?? ""
        _ = CityService.sharedInstance
            .getHotelLandMark(elongId: cityId, policyId: policyId) //
            .subscribe { (event) in
                weakSelf?.hideLoadingView()
                switch event {
                case .next(let element):
                    //printDebugLog(message: element.mj_keyValues())
                    PersonalHotelManager.shareInstance.searchConditionCityCategoryRegionStore(cityCategoryRegionModel: element)
                    weakSelf?.fillLocalData()
                    weakSelf?.regionCollection?.reloadData()
                    
                case .error(let error):
                    try?weakSelf?.validateHttp(error)
                case .completed:
                    break
                }
        }
    }
    
    
    
    func setUIViewAutolayout() {
        let flow:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        flow.scrollDirection = UICollectionViewScrollDirection.vertical
        flow.headerReferenceSize = CGSize.init(width: ScreenWindowWidth - 30, height: 40)
        flow.footerReferenceSize = CGSize.init(width: ScreenWindowWidth - 30, height: 40)
        flow.minimumLineSpacing = 10
        flow.minimumInteritemSpacing = 5
        flow.itemSize = CGSize.init(width: 79, height: 40)
        flow.sectionInset = UIEdgeInsets.init(top: 0, left:10, bottom: 0, right: 10)
        regionCollection?.showsVerticalScrollIndicator = false
        regionCollection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flow)
        regionCollection?.delegate = self
        regionCollection?.dataSource = self
        regionCollection?.backgroundColor = TBIThemeWhite
        regionCollection?.register(CityCategoryRegionCollectionViewCell.classForCoder(), forCellWithReuseIdentifier:collectionViewCellIdentify)
        regionCollection?.register(CityCategoryRegionCollectionReusableFooterView.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier:CityCategoryRegionCollectionReusableFooterViewIdentify )
        regionCollection?.register(CityCategoryRegionCollectionReusableHeaderView.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: CityCategoryRegionCollectionReusableHeaderViewIdentify)
        self.view.addSubview(regionCollection!)
        regionCollection?.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(5)
            make.bottom.equalToSuperview()
            
        }
        
        
        
        
    }
    
    //MARK:------UICollectionViewDataSource------
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            if cityCategoryRegionModel.districtRegion.count > screentCapacityIteam && districtRegionFold == false  {
                return screentCapacityIteam
            }
            return cityCategoryRegionModel.districtRegion.count
        case 1:
            if cityCategoryRegionModel.landmarkRegion.count > screentCapacityIteam && landmarkRegionFold == false  {
                return screentCapacityIteam
            }
            return cityCategoryRegionModel.landmarkRegion.count
        case 2:
            if cityCategoryRegionModel.commericalRegion.count > screentCapacityIteam && commericalRegionFold == false  {
                return screentCapacityIteam
            }
            return cityCategoryRegionModel.commericalRegion.count
        default:
            return 0
        }
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:CityCategoryRegionCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellIdentify, for: indexPath) as! CityCategoryRegionCollectionViewCell
            cell.fillDataSources(title:indexPath.row.description)
        if indexPath.section == 0 && cityCategoryRegionModel.districtRegion.count > 0 {
            cell.fillDataSources(title:cityCategoryRegionModel.districtRegion[indexPath.row].name)
        }
        if indexPath.section == 1 && cityCategoryRegionModel.landmarkRegion.count > 0{
            cell.fillDataSources(title:cityCategoryRegionModel.landmarkRegion[indexPath.row].name)
        }
        
        if indexPath.section == 2 && cityCategoryRegionModel.commericalRegion.count > 0{
            cell.fillDataSources(title:cityCategoryRegionModel.commericalRegion[indexPath.row].name)
        }
        
        return cell
        
    }
    
   
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if UICollectionElementKindSectionHeader == kind {
            
            let headerView:CityCategoryRegionCollectionReusableHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind:UICollectionElementKindSectionHeader , withReuseIdentifier: CityCategoryRegionCollectionReusableHeaderViewIdentify, for: indexPath) as! CityCategoryRegionCollectionReusableHeaderView
                headerView.fillDataSources(title: collectionSectionTitle[indexPath.section])
            return headerView
        }else{
            weak var weakSelf = self
            let footerView:CityCategoryRegionCollectionReusableFooterView = collectionView.dequeueReusableSupplementaryView(ofKind:UICollectionElementKindSectionFooter , withReuseIdentifier: CityCategoryRegionCollectionReusableFooterViewIdentify, for: indexPath) as! CityCategoryRegionCollectionReusableFooterView
            footerView.fillDataSources(section: indexPath.section, isFold: foldArr[indexPath.section])
            footerView.cityCategoryRegionCollectionReusableFooterViewMoreDataBlock = { (section,isFold) in
                weakSelf?.adjustCollectionShow(secction:section , fold: isFold)
            }
            return footerView
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var regionModel:CityCategoryRegionModel.RegionModel = CityCategoryRegionModel.RegionModel()
        switch indexPath.section {
        case 0:
            regionModel = cityCategoryRegionModel.districtRegion[indexPath.row]
        case 1:
            regionModel = cityCategoryRegionModel.landmarkRegion[indexPath.row]
        case 2:
            regionModel = cityCategoryRegionModel.commericalRegion[indexPath.row]
        default:
            break
        }
        if landMarkViewSelectedRegionBlock != nil {
            landMarkViewSelectedRegionBlock(regionModel,indexPath.section)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func adjustCollectionShow(secction:NSInteger ,fold:Bool) {
        switch secction {
        case 0:
            districtRegionFold = fold
            foldArr[secction] = districtRegionFold
            let sectionSet:IndexSet = IndexSet.init(integer: secction)
            regionCollection?.reloadSections(sectionSet)
        case 1:
            landmarkRegionFold = fold
            foldArr[secction] = landmarkRegionFold
            let sectionSet:IndexSet = IndexSet.init(integer: secction)
            regionCollection?.reloadSections(sectionSet)
        case 2:
            commericalRegionFold = fold
            foldArr[secction] = commericalRegionFold
            let sectionSet:IndexSet = IndexSet.init(integer: secction)
            regionCollection?.reloadSections(sectionSet)
            
        default:
            break
        }
    }
    
    
    
    
    //MARK:------NET-------
   
    
    
    //MARK:------Action-----
    override func backButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
