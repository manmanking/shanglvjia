//
//  PSepcialFlightListHeaderView.swift
//  shanglvjia
//
//  Created by tbi on 2018/8/2.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PSepcialFlightListHeaderView: UIView {

    ///国际机票 国内机票 点击回调
    typealias SpecialOrOfferBlock = (PSpecialOfferFlightViewController.PersonalFlightTripNationTypeEnum) ->Void
    public var specialOrOfferBlock:SpecialOrOfferBlock!
    
    ///国际机票 国内机票 点击回调
    typealias ChinaOrNationBlock = (String) ->Void
    public var chinaOrNationBlock:ChinaOrNationBlock!
    
    typealias PSepcialFlightListHeaderViewSelectedFlightCompanyBlock = (PSpecialFlightListModel.BaseCompanyInfoVo)->Void
    public var specialFlightListHeaderViewSelectedFlightCompanyBlock:PSepcialFlightListHeaderViewSelectedFlightCompanyBlock!
    
    private var selectedCountryButton:UIButton = UIButton()
    
    
    let topImage = UIImageView()
    private let blackBGView = UIView()
    private var selectedContinentButton:MyTitleButton = MyTitleButton()
    fileprivate let titleArr = ["国内机票","国际机票"]
    fileprivate let specialButton = UIButton.init(title: "国内", titleColor: TBIThemeWhite, titleSize: 16)
    fileprivate let offerButton = UIButton.init(title: "国际", titleColor: TBIThemeWhite, titleSize: 16)
    fileprivate var localCompany:[PSpecialFlightListModel.BaseCompanyInfoVo] = Array()
    
    // 国际 国内 背景
    fileprivate var subMainLandORIntenationalBackgroundView:UIView = UIView()
    
    // 航司 背景
    fileprivate var subIntenationalCityBackgroundView:UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = TBIThemeWhite
        creatView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func creatView() {
        if PersonalBannerManager.shareInstance.getPersonalFlightBannerList().isEmpty == false {
            let bannerUrl:URL = URL.init(string: PersonalBannerManager.shareInstance.getPersonalFlightBannerList().first ?? "\(BASE_URL)/static/banner/subpage/flight/ios/banner_air@3x.png") as! URL
            topImage.sd_setImage(with:bannerUrl , placeholderImage: UIImage.init(named: "bg_default_travel"))
        }else {
            topImage.sd_setImage(with:URL.init(string:"\(BASE_URL)/static/banner/subpage/flight/ios/banner_air@3x.png"))
        }
        
        //topImage.sd_setImage(with: URL.init(string: "\(BASE_URL)/static/banner/subpage/flight/ios/banner_air@3x.png"))
        self.addSubview(topImage)
        self.addSubview(blackBGView)
        
        topImage.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(180)
        }
        blackBGView.backgroundColor = TBIThemeBackgroundViewColor
        blackBGView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(topImage)
            make.height.equalTo(40)
        }
        blackBGView.addSubview(specialButton)
        blackBGView.addSubview(offerButton)
        
        
        //定投
        specialButton.isSelected = true
        specialButton.tag = 2
        specialButton.setTitleColor(PersonalThemeMajorTextColor, for: .selected)
        specialButton.setBackgroundImage(UIImage(named:"ic_car_pickup"), for: .selected)
        specialButton.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(-5)
            make.width.equalToSuperview().dividedBy(2)
        }
        specialButton.addTarget(self, action: #selector(specialOfferButtonClick(sender:)), for: UIControlEvents.touchUpInside)
        // 特惠
        offerButton.tag = 3
        offerButton.setTitleColor(PersonalThemeMajorTextColor, for: .selected)
        let selectImage = UIImage(named:"ic_car_pickup")
        //翻转图片的方向
        let flipImageOrientation = ((selectImage?.imageOrientation.rawValue)! + 4) % 8
        let flipImage =  UIImage.init(cgImage: (selectImage?.cgImage)!, scale: (selectImage?.scale)!, orientation: UIImageOrientation(rawValue: flipImageOrientation)!)
        offerButton.setBackgroundImage(flipImage, for: .selected)
        offerButton.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(-5)
            make.width.equalToSuperview().dividedBy(2)
        }
        offerButton.addTarget(self, action: #selector(specialOfferButtonClick(sender:)), for: UIControlEvents.touchUpInside)
        //ic_car_pickup
        
        //setMainlandORIntenationalViewAutolayout()
        setIntenationCityViewAutolayout()
    }
    
    /// 设置 国际城市 背景
    func setIntenationCityViewAutolayout() {
        subIntenationalCityBackgroundView.backgroundColor = TBIThemeWhite
        self.addSubview(subIntenationalCityBackgroundView)
        subIntenationalCityBackgroundView.snp.makeConstraints { (make) in
            make.top.equalTo(topImage.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }
    }
    
    
    
    
    func setMainlandORIntenationalViewAutolayout() {
        self.addSubview(subMainLandORIntenationalBackgroundView)
        subMainLandORIntenationalBackgroundView.backgroundColor = TBIThemeWhite
        subMainLandORIntenationalBackgroundView.snp.makeConstraints { (make) in
            make.top.equalTo(topImage.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }
        
        for i in 0...titleArr.count-1 {
            let titileButton:MyTitleButton = MyTitleButton.init(type: UIButtonType.custom)
            titileButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            titileButton.setTitleColor(TBIThemeMinorTextColor, for: .normal)
            titileButton.setTitle(titleArr[i], for: .normal)
            titileButton.tag = i
            titileButton.addTarget(self, action: #selector(titileButtonClick(sender:)), for: UIControlEvents.touchUpInside)
            subMainLandORIntenationalBackgroundView.addSubview(titileButton)
            titileButton.snp.makeConstraints({ (make) in
                make.top.equalToSuperview()
                make.height.equalTo(44)
                make.left.equalTo(i*Int(ScreenWindowWidth/2))
                make.width.equalToSuperview().dividedBy(2)
            })
            if i == 0 {
                selectedContinentButton = titileButton
                selectedContinentButton.setTitleColor(PersonalThemeMajorTextColor, for: .normal)
                selectedContinentButton.lineLable.isHidden = false
            }
        }
  
    }
    
    func fillDataSourcesCompany(companys:[PSpecialFlightListModel.BaseCompanyInfoVo],selectedCompanyCode:String) {
        guard companys.isEmpty == false  else {
            return
        }
        localCompany.removeAll()
        for element in companys {
            localCompany.append(element)
        }
        if subIntenationalCityBackgroundView.subviews.isEmpty == false {
            for element in subIntenationalCityBackgroundView.subviews {
                element.removeFromSuperview()
            }
        }
        setInternationalCityButton(company:localCompany, selectedCompanyCode: selectedCompanyCode)
    }
    
    
    
    func setInternationalCityButton(company:[PSpecialFlightListModel.BaseCompanyInfoVo],selectedCompanyCode:String) {
        guard company.isEmpty == false else {
            return
        }
        
        let buttonWidth:NSInteger = NSInteger((ScreenWindowWidth - 60 ) / 4)
        
        for (index,element) in company.enumerated() {
            
            var line:NSInteger = 0
            var tmpIndex = index
            if tmpIndex / 4  > line {line += 1 ; tmpIndex = tmpIndex - (4 * line)}
            
            let titileButton:UIButton = UIButton()
            titileButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            titileButton.backgroundColor = TBIThemeBaseColor
            titileButton.layer.cornerRadius = 2.0
            titileButton.clipsToBounds = true
            titileButton.setTitleColor(PersonalThemeMajorTextColor, for: .normal)
            titileButton.setTitle(element.company, for: .normal)
            titileButton.setBackgroundImage(UIImage(named:"yellow_btn_gradient"), for: UIControlState.selected)
            titileButton.setTitleColor(TBIThemeWhite, for: UIControlState.selected)
            
            titileButton.addTarget(self, action: #selector(choicesFlightCompanyButtonAction(sender:)), for: UIControlEvents.touchUpInside)
            subIntenationalCityBackgroundView.addSubview(titileButton)
            titileButton.snp.makeConstraints({ (make) in
                make.top.equalToSuperview().inset(line * (31 + 10) + 10)
                make.height.equalTo(31)
                make.left.equalTo(tmpIndex * (buttonWidth + 10) + 15 )
                make.width.equalTo(buttonWidth)
            })
            if selectedCompanyCode == element.companyCode {
                selectedCountryButton.isSelected = false
                titileButton.isSelected = true
                selectedCountryButton = titileButton
            }
            
            
        }
        
    }
    
    
    
    ///点击标题
    func titileButtonClick(sender:MyTitleButton)  {
        // 选择分类的时候 默认选中第一个国家
        
        if  selectedContinentButton == sender{
            selectedContinentButton.setTitleColor(PersonalThemeMajorTextColor, for: .normal)
            selectedContinentButton.lineLable.isHidden = false
        }else{
            selectedContinentButton.setTitleColor(TBIThemeMinorTextColor, for: .normal)
            sender.setTitleColor(PersonalThemeMajorTextColor, for: .normal)
            selectedContinentButton.lineLable.isHidden = true
            sender.lineLable.isHidden = false
            selectedContinentButton = sender;
        }
        if chinaOrNationBlock != nil{
            chinaOrNationBlock(sender.tag.description)
        }
    }
    
    func choicesFlightCompanyButtonAction(sender:UIButton) {
        guard sender.isSelected == false else {
            return
        }
        selectedCountryButton.isSelected = false
        sender.isSelected = true
        selectedCountryButton = sender
        
        var selectedFlightCompany = PSpecialFlightListModel.BaseCompanyInfoVo()
        for element in localCompany {
            if element.company == sender.currentTitle {
                selectedFlightCompany = element
            }
        }
        
        if specialFlightListHeaderViewSelectedFlightCompanyBlock != nil {
            specialFlightListHeaderViewSelectedFlightCompanyBlock (selectedFlightCompany)
        }
    }
    
    
    
    
    func specialOfferButtonClick(sender:UIButton) {
        var tmpFlightTripType = PSpecialOfferFlightViewController.PersonalFlightTripNationTypeEnum.Mainland
        if sender != specialButton
        {
            offerButton.isSelected = true
            specialButton.isSelected = false
            //self.bringSubview(toFront: subMainLandORIntenationalBackgroundView)
            tmpFlightTripType = PSpecialOfferFlightViewController.PersonalFlightTripNationTypeEnum.International
        }else{
            specialButton.isSelected = true
            offerButton.isSelected = false
            //self.bringSubview(toFront: subIntenationalCityBackgroundView)
            tmpFlightTripType = PSpecialOfferFlightViewController.PersonalFlightTripNationTypeEnum.Mainland
        }
        if specialOrOfferBlock != nil{
            specialOrOfferBlock(tmpFlightTripType)
        }
    }
    
}
