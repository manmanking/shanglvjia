//
//  PersonalVisaCountryViewController.swift
//  shanglvjia
//
//  Created by manman on 2018/8/24.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PersonalVisaCountryViewController: PersonalBaseViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    typealias PersonalVisaCountrySelectedBlock = (NSInteger,NSInteger)->Void
    
    public var continentResultArr:[ContinentModel] = Array()
    
    public var personalVisaCountrySelectedBlock:PersonalVisaCountrySelectedBlock!
    
    private var continenCategoryHeaderCollection:UICollectionView?
    
    private var countryCollection:UICollectionView?
    
    public var selectedContinrnCategoryIndex:NSInteger = 0

    private var selectedCountryIndex:NSInteger = 0
    
    private var continenCategoryHeaderCollectionCellIdentify:String = "continenCategoryHeaderCollectionCellIdentify"
    
    private var countryCollectionCellIdentify:String = "countryCollectionCellIdentify"
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = TBIThemeBaseColor
        //setNavigationBackButtonTitle(title: "选择国家")
        setUIViwAutolayout()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        setBlackTitleAndNavigationColor(title: "选择国家")
    }
    
    func setUIViwAutolayout() {
        setHeaderView()
        setCountryCollectionView()
    }
    
    func setHeaderView() {
        let flow:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        flow.scrollDirection = UICollectionViewScrollDirection.horizontal
//        flow.headerReferenceSize = CGSize.init(width: ScreenWindowWidth - 30, height: 40)
//        flow.footerReferenceSize = CGSize.init(width: ScreenWindowWidth - 30, height: 40)
        flow.minimumLineSpacing = 10
        flow.minimumInteritemSpacing = 5
        flow.itemSize = CGSize.init(width: 79, height: 32)
        flow.sectionInset = UIEdgeInsets.init(top: 0, left:10, bottom: 0, right: 10)
        continenCategoryHeaderCollection?.showsVerticalScrollIndicator = false
        continenCategoryHeaderCollection?.showsHorizontalScrollIndicator = false
        continenCategoryHeaderCollection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flow)
        continenCategoryHeaderCollection?.delegate = self
        continenCategoryHeaderCollection?.dataSource = self
        continenCategoryHeaderCollection?.backgroundColor = TBIThemeWhite
        continenCategoryHeaderCollection?.register(ContinenCategoryHeaderCollectionViewCell.self, forCellWithReuseIdentifier:continenCategoryHeaderCollectionCellIdentify)
        self.view.addSubview(continenCategoryHeaderCollection!)
        continenCategoryHeaderCollection?.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
            
        }
    }
    
    
    func setCountryCollectionView() {
        let flow:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        flow.scrollDirection = UICollectionViewScrollDirection.vertical
        flow.headerReferenceSize = CGSize.init(width: ScreenWindowWidth - 30, height: 10)
        flow.footerReferenceSize = CGSize.init(width: ScreenWindowWidth - 30, height: 40)
        flow.minimumLineSpacing = 10
        flow.minimumInteritemSpacing = 5
        flow.itemSize = CGSize.init(width: 79, height: 32)
        flow.sectionInset = UIEdgeInsets.init(top: 0, left:10, bottom: 0, right: 10)
        countryCollection?.showsVerticalScrollIndicator = false
        countryCollection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flow)
        countryCollection?.delegate = self
        countryCollection?.dataSource = self
        countryCollection?.backgroundColor = TBIThemeWhite
        countryCollection?.register(CityCategoryRegionCollectionViewCell.self, forCellWithReuseIdentifier:countryCollectionCellIdentify)
        self.view.addSubview(countryCollection!)
        countryCollection?.snp.makeConstraints { (make) in
            make.top.equalTo((continenCategoryHeaderCollection?.snp.bottom)!).offset(1)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            
        }
    }
    
    
    //MARK:-------UICollectionViewDataSource----
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        return caculateItemForSection(collectionView:collectionView,section:section)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return configCollectionCellItem(collectionView:collectionView,indexPath:indexPath)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        printDebugLog(message: indexPath)
        if continenCategoryHeaderCollection == collectionView {
            selectedContinrnCategoryIndex = indexPath.row
            selectedCountryIndex = 0
            continenCategoryHeaderCollection?.reloadData()
        }else {
            selectedCountryIndex = indexPath.row
        }
        countryCollection?.reloadData()
        if countryCollection == collectionView  && personalVisaCountrySelectedBlock != nil  {
            personalVisaCountrySelectedBlock(selectedContinrnCategoryIndex,selectedCountryIndex)
            backButtonAction(sender: UIButton())
        }
    }
    
    func caculateItemForSection(collectionView: UICollectionView,section:NSInteger) -> NSInteger {
        if collectionView == continenCategoryHeaderCollection {
            return continentResultArr.count
        }else {
            if selectedContinrnCategoryIndex <= continentResultArr.count {
                return continentResultArr[selectedContinrnCategoryIndex].data.count
            }
            return 0
            
        }
    }
    func configCollectionCellItem(collectionView: UICollectionView,indexPath:IndexPath)->UICollectionViewCell {
        
        if collectionView == continenCategoryHeaderCollection {
            
            let cellItem:ContinenCategoryHeaderCollectionViewCell = continenCategoryHeaderCollection?.dequeueReusableCell(withReuseIdentifier: continenCategoryHeaderCollectionCellIdentify, for: indexPath) as! ContinenCategoryHeaderCollectionViewCell
            var isSelected:Bool = false
            if selectedContinrnCategoryIndex == indexPath.row {
                isSelected = true
            }
            cellItem.fillDataSources(title: continentResultArr[indexPath.row].ctName, isSelected: isSelected)
            return cellItem
        }else {
           
            let cellItem:CityCategoryRegionCollectionViewCell = countryCollection?.dequeueReusableCell(withReuseIdentifier: countryCollectionCellIdentify, for: indexPath) as! CityCategoryRegionCollectionViewCell
            var isSelected:Bool = false
            if selectedCountryIndex == indexPath.row {
                isSelected = true
            }
            cellItem.fillDataSources(title: continentResultArr[selectedContinrnCategoryIndex].data[indexPath.row].countryNameCn,isSelected:isSelected)
            return cellItem
        }
    }
    
    override func backButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    

}
