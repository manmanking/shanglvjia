//
//  PersonalSpecialHotelCityViewController.swift
//  shanglvjia
//
//  Created by manman on 2018/9/10.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PersonalSpecialHotelCityViewController: PersonalBaseViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    typealias PersonalSpecialHotelCityViewSelectedBlcok = (String,String)->Void
    
    public var personalSpecialHotelCityViewSelectedBlcok:PersonalSpecialHotelCityViewSelectedBlcok!
    
    public var cityInterArr:[HotelCityModel] = Array() //新加坡、东京，大阪，京都，名古屋
    
    fileprivate var collectionViewCellIdentify:String = "collectionViewCellIdentify"
    
    fileprivate var cityCollection:UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setNavigation(title: "选择城市")
        setBlackTitleAndNavigationColor(title: "选择城市")
        
        //fillLocalDataSources()
        setUIViewAutolayout()
    }

    func fillLocalDataSources() {
        
        guard cityInterArr.isEmpty == true else {
            return
        }
        
        // 东京   179897 大阪  180027 新加坡
        let firstCity = HotelCityModel()
        firstCity.cnName = "东京"
        firstCity.elongId = "179900"
        let secondCity = HotelCityModel()
        secondCity.cnName = "新加坡"
        secondCity.elongId = "180027"
        let thirdCity = HotelCityModel()
        thirdCity.cnName = "大阪"
        thirdCity.elongId = "179897"
        let forthCity = HotelCityModel()
        forthCity.cnName = "京都"
        forthCity.elongId = "6131486"
        let fifthCity = HotelCityModel()
        fifthCity.cnName = "名古屋"
        fifthCity.elongId = "6127908"
        cityInterArr = [firstCity,secondCity,thirdCity,forthCity,fifthCity]
    }
    
    
    func setUIViewAutolayout() {
        let flow:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        flow.scrollDirection = UICollectionViewScrollDirection.vertical
        flow.headerReferenceSize = CGSize.init(width: ScreenWindowWidth - 30, height: 40)
        flow.footerReferenceSize = CGSize.init(width: ScreenWindowWidth - 30, height: 40)
        flow.minimumLineSpacing = 10
        flow.minimumInteritemSpacing = 5
        flow.itemSize = CGSize.init(width: 79, height: 32)
        flow.sectionInset = UIEdgeInsets.init(top: 0, left:10, bottom: 0, right: 10)
        cityCollection?.showsVerticalScrollIndicator = false
        cityCollection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flow)
        cityCollection?.delegate = self
        cityCollection?.dataSource = self
        cityCollection?.backgroundColor = TBIThemeWhite
        cityCollection?.register(CityCategoryRegionCollectionViewCell.classForCoder(), forCellWithReuseIdentifier:collectionViewCellIdentify)
        self.view.addSubview(cityCollection!)
        cityCollection?.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(5)
            make.bottom.equalToSuperview()
            
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return cityInterArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:CityCategoryRegionCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier:collectionViewCellIdentify , for: indexPath) as! CityCategoryRegionCollectionViewCell
        
        cell.fillDataSources(title: cityInterArr[indexPath.row].cnName, isSelected: false)
        return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        printDebugLog(message: "\(indexPath.row)")
        if personalSpecialHotelCityViewSelectedBlcok != nil {
            personalSpecialHotelCityViewSelectedBlcok(cityInterArr[indexPath.row].cnName,cityInterArr[indexPath.row].elongId)
            backButtonAction(sender: UIButton())
        }
    }
    
    
    
    
    override func backButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
