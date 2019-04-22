//
//  HotelSearchConditionViewController.swift
//  shanglvjia
//
//  Created by manman on 2018/4/24.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class HotelSearchConditionViewController: CompanyBaseViewController,UITableViewDelegate,UITableViewDataSource {

    private let MAXRangeSliderValue:Double = 40//2000
    
    private var rangeSliderLowerValue:Float = 200
    private var rangeSliderHighValue:Float = 2000
    
    
    
    typealias HotelSearchConditionViewSearchBlock = (String)->Void
    
    public var hotelSearchConditionViewSearchBlock:HotelSearchConditionViewSearchBlock!
    
    private let tableViewCellIdentify:String = "tableViewCellIdentify"
    private let priceBackgroundView:UIView = UIView()
    private let priceTitleLabel:UILabel = UILabel()
    private let priceTitleContentExampleLabel:UILabel = UILabel()
    private let lowPriceLabel:UILabel = UILabel()
    private let heightPriceLabel:UILabel = UILabel()
    //private let slider:UISlider = UISlider()
    let rangeSlider = RangeSlider(frame: CGRect.zero)
    
    private let recommendBackgroundView:UIView = UIView()
    private let recommendSubBackgroundView:UIView = UIView()
    private let recommendTitleLabel:UILabel = UILabel()
    private let recommendTitleContentLabel:UILabel = UILabel()
    private let recommendTitleContentButton:UIButton = UIButton()
    private let recommendTitleButtonFlag:UIButton = UIButton()
    
    
    private let hotelClassBackgroundView:UIView = UIView()
    private let hotelClassSubBackgroundView:UIView = UIView()
    private let hotelClassTitleLabel:UILabel = UILabel()
    private let hotelClassTitleContentLabel:UILabel = UILabel()
    private let hotelClassTitleContentButton:UIButton = UIButton()
    private let hotelClassTitleButtonFlag:UIButton = UIButton()
    
    private let hotelBrandBackgroundView:UIView = UIView()
    private let hotelBrandSubBackgroundView:UIView = UIView()
    private let hotelBrandTitleLabel:UILabel = UILabel()
    private let hotelBrandTitleContentLabel:UILabel = UILabel()
    private let hotelBrandTitleContentButton:UIButton = UIButton()
    private let hotelBrandTitleButtonFlag:UIButton = UIButton()
    
    
    private let tableView:UITableView = UITableView()
    private let searchButton:UIButton = UIButton()
    
    private var tableViewDataSourcesRecommend:[(title:String,content:String)] = Array()
    private var tableViewDataSourcesClass:[(title:String,content:String)] = Array()
    private var tableViewDataSourcesBrand:[CityCategoryRegionModel.HotelBrandInfos] = Array()
    
    
    private var currentSearchConditionCategory:SearchCategoryListType = SearchCategoryListType.SearchCategory_Recommend
    private var currentSearchConditionCategoryRecommondIndex:NSInteger = 0
    private var currentSearchConditionCategoryClassIndex:NSInteger = 0
    private var currentSearchConditionCategoryBrandIndex:NSInteger = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //setNavigationBgColor(color: TBIThemeWhite)
        setBlackTitleAndNavigationColor(title: "筛选条件")
        setNavigationBackButton(backImage: "left")
        setNavigationRightButton(title:"重置",titleColor:TBIThemeDarkBlueColor)
        self.view.backgroundColor = TBIThemeWhite
        setUIViewAutolayout()
       
    }
    
    func setUIViewAutolayout() {
        self.view.addSubview(priceBackgroundView)
        priceBackgroundView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(117)
        }
        
        priceTitleLabel.text = "价格区间"
        priceTitleLabel.font = UIFont.systemFont(ofSize: 14)
        priceTitleLabel.textColor = TBIThemePrimaryTextColor
        priceBackgroundView.addSubview(priceTitleLabel)
        priceTitleLabel.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().inset(15)
            make.height.equalTo(16)
            make.width.equalTo(60)
        }
        
        priceTitleContentExampleLabel.text = "¥0 - 不限"
        priceTitleContentExampleLabel.textColor = TBIThemePrimaryTextColor
        priceTitleContentExampleLabel.font = UIFont.systemFont(ofSize: 14)
        priceBackgroundView.addSubview(priceTitleContentExampleLabel)
        priceTitleContentExampleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(priceTitleLabel)
            make.left.equalTo(priceTitleLabel.snp.right).offset(38)
            make.height.equalTo(16)
            make.right.equalToSuperview()
        }
        
        let margin: CGFloat = 20.0
        let width = ScreenWindowWidth - 2.0 * margin
        rangeSlider.frame = CGRect(x: margin, y: margin + topLayoutGuide.length + 20,
                                    width: width, height: 31.0)
        rangeSlider.lowerValue = 0.5
        rangeSlider.upperValue = 0.6
        rangeSlider.stepValue = 50
        self.view.addSubview(rangeSlider)
        rangeSlider.addTarget(self, action: #selector(rangeSliderValueChanged(_:)), for: UIControlEvents.valueChanged)
        self.view.addSubview(recommendBackgroundView)
        recommendBackgroundView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(rangeSlider.snp.bottom).offset(32)
            make.height.equalTo(40)
        }
        recommendTitleLabel.text = "推荐指数"
        recommendTitleLabel.font = UIFont.systemFont(ofSize: 14)
        recommendTitleLabel.textColor = TBIThemePrimaryTextColor
        recommendBackgroundView.addSubview(recommendTitleLabel)
        recommendTitleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalTo(100)
        }
        recommendSubBackgroundView.layer.borderColor = TBIThemePlaceholderColor.cgColor
        recommendSubBackgroundView.layer.borderWidth = 1
        recommendSubBackgroundView.layer.cornerRadius = 4
        recommendBackgroundView.addSubview(recommendSubBackgroundView)
        recommendSubBackgroundView.snp.makeConstraints { (make) in
            make.left.equalTo(recommendTitleLabel.snp.right).offset(20)
            make.top.right.height.equalToSuperview()
        }
//        recommendTitleContentLabel.text = "不限"
//        recommendTitleContentButton.setTitle("不限", for: UIControlState.normal)
//        recommendTitleContentLabel.addOnClickListener(target: self, action: #selector(searchCategoryList(tap:)))
//        recommendTitleContentLabel.font = UIFont.systemFont(ofSize: 14)
//        recommendTitleContentLabel.textColor = TBIThemePrimaryTextColor
//        recommendSubBackgroundView.addSubview(recommendTitleContentLabel)
//        recommendTitleContentLabel.snp.makeConstraints { (make) in
//            make.top.equalToSuperview()
//            make.left.equalToSuperview().inset(15)
//            make.height.equalToSuperview()
//            make.right.equalToSuperview()
//        }
        
        recommendTitleContentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        recommendTitleContentButton.setTitle("不限", for: UIControlState.normal)//.text = "不限"
        recommendTitleContentButton.addTarget(self, action: #selector(searchCategoryList(sender:)), for: UIControlEvents.touchUpInside)
        recommendTitleContentButton.setTitleColor(TBIThemePrimaryTextColor, for: UIControlState.normal)
        recommendTitleContentButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        recommendSubBackgroundView.addSubview(recommendTitleContentButton)
        recommendTitleContentButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().inset(15)
            make.height.equalToSuperview()
            make.right.equalToSuperview()
        }

        
        
        recommendTitleButtonFlag.setImage(UIImage.init(named: "HotelDown"), for: UIControlState.normal)
        recommendTitleButtonFlag.setImage(UIImage.init(named: "ic_up"), for: UIControlState.selected)
        recommendSubBackgroundView.addSubview(recommendTitleButtonFlag)
        recommendTitleButtonFlag.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(15)
            make.width.height.equalTo(6)
        }
        
        
        
        self.view.addSubview(hotelClassBackgroundView)
        hotelClassBackgroundView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(recommendBackgroundView.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
        hotelClassTitleLabel.text = "酒店档次"
        hotelClassTitleLabel.font = UIFont.systemFont(ofSize: 14)
        hotelClassTitleLabel.textColor = TBIThemePrimaryTextColor
        hotelClassBackgroundView.addSubview(hotelClassTitleLabel)
        hotelClassTitleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalTo(100)
        }
        hotelClassSubBackgroundView.layer.borderColor = TBIThemePlaceholderColor.cgColor
        hotelClassSubBackgroundView.layer.borderWidth = 1
        hotelClassSubBackgroundView.layer.cornerRadius = 4
        hotelClassBackgroundView.addSubview(hotelClassSubBackgroundView)
        hotelClassSubBackgroundView.snp.makeConstraints { (make) in
            make.left.equalTo(hotelClassTitleLabel.snp.right).offset(20)
            make.top.right.height.equalToSuperview()
        }
//        hotelClassTitleContentLabel.text = "不限"
//        hotelClassTitleContentLabel.addOnClickListener(target: self, action: #selector(searchCategoryList(tap:)))
//        hotelClassTitleContentLabel.font = UIFont.systemFont(ofSize: 14)
//        hotelClassTitleContentLabel.textColor = TBIThemePrimaryTextColor
//        hotelClassSubBackgroundView.addSubview(hotelClassTitleContentLabel)
//        hotelClassTitleContentLabel.snp.makeConstraints { (make) in
//            make.top.equalToSuperview()
//            make.left.equalToSuperview().inset(15)
//            make.height.equalToSuperview()
//            make.right.equalToSuperview()
//        }
        hotelClassTitleContentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        hotelClassTitleContentButton.setTitle("不限", for: UIControlState.normal)//.text = "不限"
        hotelClassTitleContentButton.addTarget(self, action: #selector(searchCategoryList(sender:)), for: UIControlEvents.touchUpInside)
        hotelClassTitleContentButton.setTitleColor(TBIThemePrimaryTextColor, for: UIControlState.normal)
        hotelClassTitleContentButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        //hotelClassTitleContentLabel.addOnClickListener(target: self, action: #selector(searchCategoryList(tap:)))
        //hotelClassTitleContentLabel.font = UIFont.systemFont(ofSize: 14)
        //hotelClassTitleContentLabel.textColor = TBIThemePrimaryTextColor
        hotelClassSubBackgroundView.addSubview(hotelClassTitleContentButton)
        hotelClassTitleContentButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().inset(15)
            make.height.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        
        
        hotelClassTitleButtonFlag.setImage(UIImage.init(named: "HotelDown"), for: UIControlState.normal)
        hotelClassTitleButtonFlag.setImage(UIImage.init(named: "ic_up"), for: UIControlState.selected)
        hotelClassSubBackgroundView.addSubview(hotelClassTitleButtonFlag)
        hotelClassTitleButtonFlag.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(15)
            make.width.height.equalTo(6)
        }
        self.view.addSubview(hotelBrandBackgroundView)
        hotelBrandBackgroundView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(hotelClassBackgroundView.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
        hotelBrandTitleLabel.text = "酒店品牌"
        hotelBrandTitleLabel.font = UIFont.systemFont(ofSize: 14)
        hotelBrandTitleLabel.textColor = TBIThemePrimaryTextColor
        hotelBrandBackgroundView.addSubview(hotelBrandTitleLabel)
        hotelBrandTitleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalTo(100)
        }
        hotelBrandSubBackgroundView.layer.borderColor = TBIThemePlaceholderColor.cgColor
        hotelBrandSubBackgroundView.layer.borderWidth = 1
        hotelBrandSubBackgroundView.layer.cornerRadius = 4
        hotelBrandBackgroundView.addSubview(hotelBrandSubBackgroundView)
        hotelBrandSubBackgroundView.snp.makeConstraints { (make) in
            make.left.equalTo(hotelBrandTitleLabel.snp.right).offset(20)
            make.top.right.height.equalToSuperview()
        }
//        hotelBrandTitleContentLabel.text = "不限"
//        hotelBrandTitleContentLabel.addOnClickListener(target: self, action: #selector(searchCategoryList(tap:)))
//        hotelBrandTitleContentLabel.font = UIFont.systemFont(ofSize: 14)
//        hotelBrandTitleContentLabel.textColor = TBIThemePrimaryTextColor
//        hotelBrandSubBackgroundView.addSubview(hotelBrandTitleContentLabel)
//        hotelBrandTitleContentLabel.snp.makeConstraints { (make) in
//            make.top.equalToSuperview()
//            make.left.equalToSuperview().inset(15)
//            make.height.equalToSuperview()
//            make.right.equalToSuperview()
//        }
        hotelBrandTitleContentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        hotelBrandTitleContentButton.setTitle("不限", for: UIControlState.normal)//.text = "不限"
        hotelBrandTitleContentButton.addTarget(self, action: #selector(searchCategoryList(sender:)), for: UIControlEvents.touchUpInside)
        hotelBrandTitleContentButton.setTitleColor(TBIThemePrimaryTextColor, for: UIControlState.normal)
        hotelBrandTitleContentButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        hotelBrandSubBackgroundView.addSubview(hotelBrandTitleContentButton)
        hotelBrandTitleContentButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().inset(15)
            make.height.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        
        
        hotelBrandTitleButtonFlag.setImage(UIImage.init(named: "HotelDown"), for: UIControlState.normal)
        hotelBrandTitleButtonFlag.setImage(UIImage.init(named: "ic_up"), for: UIControlState.selected)
        hotelBrandSubBackgroundView.addSubview(hotelBrandTitleButtonFlag)
        hotelBrandTitleButtonFlag.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(15)
            make.width.height.equalTo(6)
        }
        
        searchButton.setTitle("搜索", for: UIControlState.normal)
        searchButton.setBackgroundImage(UIImage (named: "yellow_btn_gradient"), for: UIControlState.normal)
        searchButton.clipsToBounds=true
        searchButton.layer.cornerRadius = 4
        searchButton.addTarget(self, action: #selector(searchButtonAction), for: UIControlEvents.touchUpInside)
        self.view.addSubview(searchButton)
        searchButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(hotelBrandBackgroundView.snp.bottom).offset(30)
            make.height.equalTo(44)
        }
        showAllHotelBrand()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.borderColor = TBIThemeBaseColor.cgColor
        tableView.layer.borderWidth = 1
        tableView.layer.cornerRadius = 4
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier:tableViewCellIdentify)
        self.view.addSubview(tableView)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
         fillDataSources()
    }
    
    
    func fillDataSources(){
       let searchCondition =  HotelManager.shareInstance.searchConditionUserDraw()
        setRangeSliderValue(lower:Float(searchCondition.lowRate) , high: Float(searchCondition.highRate))
        tableViewDataSourcesRecommend = [("不限",""),("五星","10"),("四星半","9"),("四星","8"),("四星以下","7")]
        tableViewDataSourcesClass = [("不限",""),("五星/豪华","5"),("四星/高档","4"),("三星/舒适","3"),("快捷/经济","2,1")]
        let hotelSearchCondition =  HotelManager.shareInstance.searchConditionUserDraw()
        // 酒店推荐指数
        if hotelSearchCondition.score.isEmpty == false {
            for element in tableViewDataSourcesRecommend {
                if hotelSearchCondition.score == element.content {
                    //recommendTitleContentLabel.text = element.title
                    recommendTitleContentButton.setTitle(element.title, for: UIControlState.normal)
                }
            }
        }
        // 酒店 档次
        if hotelSearchCondition.hotelStarRate.isEmpty == false {
            for (index,element) in tableViewDataSourcesClass.enumerated() {
                if hotelSearchCondition.hotelStarRate == element.content {
                    //hotelClassTitleContentLabel.text = element.title
                    hotelClassTitleContentButton.setTitle(element.title, for: UIControlState.normal)
                    if hotelClassTitleContentButton.currentTitle != "不限" {
                        configHotelBrandDataSources(index: index)
                    }
                }
            }
            
        }
        
        if hotelSearchCondition.brandId.isEmpty == false {
//            hotelBrandBackgroundView.isHidden = false
            for element in tableViewDataSourcesBrand {
                //hotelBrandTitleContentLabel.text = element.brandName
                if hotelSearchCondition.brandId == element.brandElongId {
                    printDebugLog(message: "set brandcontent")
                    printDebugLog(message: hotelSearchCondition.brandId)
                    printDebugLog(message: element.brandElongId)
                    printDebugLog(message: element.brandName)
                    //hotelBrandTitleContentLabel.text = element.brandName
                    hotelBrandTitleContentButton.setTitle(element.brandName, for: UIControlState.normal)
                }
            }
        }else {
//            hotelBrandBackgroundView.isHidden = true
        }
        
//        if  hotelClassTitleContentLabel.text != "不限" {
//            for (index,element) in tableViewDataSourcesClass.enumerated() {
//                if hotelSearchCondition.hotelStarRate == element.content {
//                    if hotelClassTitleContentLabel.text != "不限" {
//                        configHotelBrandDataSources(index: index)
//                    }
//                }
//            }
//        }
        
    }
    
    
    /// 设置 rangeSlider
    private func setRangeSliderValue(lower:Float,high:Float) {
        
        rangeSlider.lowerValue =  Double(lower) / MAXRangeSliderValue / rangeSlider.stepValue
        if high == 0 {
            rangeSlider.upperValue = 1.0
        }else {
            rangeSlider.upperValue = Double(high) / MAXRangeSliderValue / rangeSlider.stepValue
        }
        var highStr:String = ""
        rangeSliderLowerValue = Float(rangeSlider.lowerValue * MAXRangeSliderValue * rangeSlider.stepValue )
        rangeSliderHighValue = Float(rangeSlider.upperValue * MAXRangeSliderValue * rangeSlider.stepValue)
        highStr = floorf(rangeSliderHighValue).OneOfTheEffectiveFraction()
        if rangeSlider.upperValue >= 1.0 {
            highStr = "不限"
        }
        priceTitleContentExampleLabel.text = "¥" + floorf(rangeSliderLowerValue).OneOfTheEffectiveFraction() + "-" + highStr
    }
    
    
    func adjustTableView(type:SearchCategoryListType) {
       
        if currentSearchConditionCategory == type && tableView.isHidden == false{
            tableView.isHidden = true
            return
        }
        tableView.isHidden = false
        currentSearchConditionCategory = type
        switch type {
        case .SearchCategory_Recommend:
            tableView.snp.remakeConstraints { (make) in
                make.top.equalTo(recommendBackgroundView.snp.bottom)
                make.left.equalTo(recommendSubBackgroundView.snp.left)
                make.width.equalTo(recommendSubBackgroundView.snp.width)
                make.height.equalTo(5 * 44)
            }
            
        case .SearchCategory_Class:
            tableView.snp.remakeConstraints { (make) in
                make.top.equalTo(hotelClassBackgroundView.snp.bottom)
                make.left.equalTo(hotelClassSubBackgroundView.snp.left)
                make.width.equalTo(hotelClassSubBackgroundView.snp.width)
                make.height.equalTo(5 * 44)
            }
        case .SearchCategory_Brand:
            tableView.snp.remakeConstraints { (make) in
                make.top.equalTo(hotelBrandBackgroundView.snp.bottom)
                make.left.equalTo(hotelBrandSubBackgroundView.snp.left)
                make.width.equalTo(hotelBrandSubBackgroundView.snp.width)
                make.height.equalTo(5 * 44)
            }
            
        default:
            break
        }
        tableView.reloadData()
    }
    
    func testButton(sender:UIButton)  {
        printDebugLog(message: "debug")
    }
    
    func searchCategoryList(tap:UITapGestureRecognizer) {
        let tmpLabel:UILabel = tap.view as! UILabel
        switch tmpLabel {
        case recommendTitleContentLabel:
            adjustTableView(type: SearchCategoryListType.SearchCategory_Recommend)
        case hotelClassTitleContentLabel:
            adjustTableView(type: SearchCategoryListType.SearchCategory_Class)
        case hotelBrandTitleContentLabel:
            adjustTableView(type: SearchCategoryListType.SearchCategory_Brand)
        default:
            if tableView.isHidden == false {
                tableView.isHidden = true
            }
        }
    }
    
    func searchCategoryList(sender:UIButton) {
        switch sender {
        case recommendTitleContentButton:
            adjustTableView(type: SearchCategoryListType.SearchCategory_Recommend)
        case hotelClassTitleContentButton:
            adjustTableView(type: SearchCategoryListType.SearchCategory_Class)
        case hotelBrandTitleContentButton:
            adjustTableView(type: SearchCategoryListType.SearchCategory_Brand)
        default:
            if tableView.isHidden == false {
                tableView.isHidden = true
            }
        }
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if tableView.isHidden == false {
            tableView.isHidden = true
        }
    }
    
    //MARK:--------TableViewDataSources---------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentSearchConditionCategory {
        case .SearchCategory_Recommend:
            return tableViewDataSourcesRecommend.count
        case .SearchCategory_Class:
            return tableViewDataSourcesClass.count
        case .SearchCategory_Brand:
            return tableViewDataSourcesBrand.count
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentify)!
        return configCell(cell:cell , indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch currentSearchConditionCategory {
        case .SearchCategory_Recommend:
           selectedHotelRecommend(index: indexPath.row)
            
        case .SearchCategory_Class:
            selectedHotelClass(index: indexPath.row)
        case .SearchCategory_Brand:
           selectedHotelBrand(index: indexPath.row)
            
        default:
            break
        }

        tableView.isHidden = true
    }
    
    
    
    
    
    func configCell(cell:UITableViewCell,indexPath:IndexPath)->UITableViewCell{
        var showContent:String = ""
        switch currentSearchConditionCategory {
        case .SearchCategory_Recommend:
            if tableViewDataSourcesRecommend.count > indexPath.row {
                showContent = tableViewDataSourcesRecommend[indexPath.row].title
            }

            
        case .SearchCategory_Class:
            if tableViewDataSourcesClass.count > indexPath.row {
                showContent = tableViewDataSourcesClass[indexPath.row].title
            }

        case .SearchCategory_Brand:
            if tableViewDataSourcesBrand.count > indexPath.row {
                showContent = tableViewDataSourcesBrand[indexPath.row].brandName
            }

            
        default:
            break
        }
        cell.textLabel?.text = showContent
        return cell
    }
    
    /// 酒店 推荐指数
    func selectedHotelRecommend(index:NSInteger) {
        if tableViewDataSourcesRecommend.count > index {
            currentSearchConditionCategoryRecommondIndex = index
            //recommendTitleContentLabel.text = tableViewDataSourcesRecommend[index].title
            recommendTitleContentButton.setTitle(tableViewDataSourcesRecommend[index].title, for: UIControlState.normal)
            
            let searchCondition = HotelManager.shareInstance.searchConditionUserDraw()
            searchCondition.score = tableViewDataSourcesRecommend[index].content
            HotelManager.shareInstance.searchConditionUserStore(searchCondition: searchCondition)
        }
    }
    
    /// 酒店档次
    func selectedHotelClass(index:NSInteger) {
        if tableViewDataSourcesClass.count > index {
            currentSearchConditionCategoryClassIndex = index
            //hotelClassTitleContentLabel.text = tableViewDataSourcesClass[index].title
            hotelClassTitleContentButton.setTitle(tableViewDataSourcesClass[index].title, for: UIControlState.normal)
            let searchCondition = HotelManager.shareInstance.searchConditionUserDraw()
            searchCondition.hotelStarRate = tableViewDataSourcesClass[index].content
            HotelManager.shareInstance.searchConditionUserStore(searchCondition: searchCondition)
            
            configHotelBrandDataSources(index: index)
        }
    }
    
    
    /// 配置 酒店品牌 数据
    private func configHotelBrandDataSources(index:NSInteger) {
//        hotelBrandBackgroundView.isHidden = false
        switch index {
        case 0:
            
            // 0是不限 酒店品牌 消失
//            hotelBrandBackgroundView.isHidden = true
            //tableViewDataSourcesBrand
            showAllHotelBrand()
            //selectedHotelBrand(index: 0)
            break
        case 1:
            //1是 五星 豪华
            let brandCount:NSInteger = HotelManager.shareInstance.searchConditionCityCategoryRegionDraw()
                .cityBrandInfos?.forthClass!.count ?? 0
            if brandCount > 0 {
                tableViewDataSourcesBrand = (HotelManager.shareInstance.searchConditionCityCategoryRegionDraw()
                    .cityBrandInfos?.forthClass)!
            }
        case 2:
            // 2 是 四星 高档
            let brandCount:NSInteger = HotelManager.shareInstance.searchConditionCityCategoryRegionDraw()
                .cityBrandInfos?.thirdClass!.count ?? 0
            if brandCount > 0 {
                tableViewDataSourcesBrand = (HotelManager.shareInstance.searchConditionCityCategoryRegionDraw()
                    .cityBrandInfos?.thirdClass)!
            }
            break
        case 3:
            // 3 是 三星 舒适
            let brandCount:NSInteger = HotelManager.shareInstance.searchConditionCityCategoryRegionDraw()
                .cityBrandInfos?.secondClass!.count ?? 0
            if brandCount > 0 {
                tableViewDataSourcesBrand = (HotelManager.shareInstance.searchConditionCityCategoryRegionDraw()
                    .cityBrandInfos?.secondClass)!
            }
            break
        case 4:
            // 4 是 经济 快捷
            let brandCount:NSInteger = HotelManager.shareInstance.searchConditionCityCategoryRegionDraw()
                .cityBrandInfos?.firstClass!.count ?? 0
            if brandCount > 0 {
                tableViewDataSourcesBrand = (HotelManager.shareInstance.searchConditionCityCategoryRegionDraw()
                    .cityBrandInfos?.firstClass)!
            }
            break
        default:
            tableViewDataSourcesBrand.removeAll()
            break
        }
        ///酒店品牌第一个选项
        if tableViewDataSourcesBrand.count > 0 && tableViewDataSourcesBrand[0].brandName != "不限"{
            let hotelBrandsFirstIndex = CityCategoryRegionModel.HotelBrandInfos()
            hotelBrandsFirstIndex.brandName = "不限"
            tableViewDataSourcesBrand.insert(hotelBrandsFirstIndex, at: 0)
        }
        if index != 0 {
            //hotelBrandTitleContentLabel.text = "不限"
            hotelBrandTitleContentButton.setTitle("不限", for: UIControlState.normal)
            
        }
        tableView.reloadData()
    }
    
    func showAllHotelBrand() {
        
        tableViewDataSourcesBrand.removeAll()
        let hotelBrandsFirstIndex = CityCategoryRegionModel.HotelBrandInfos()
        hotelBrandsFirstIndex.brandName = "不限"
        hotelBrandTitleContentLabel.text = "不限"
        tableViewDataSourcesBrand.append(hotelBrandsFirstIndex)
        //1是 五星 豪华
        let forthBrandCount:NSInteger = HotelManager.shareInstance.searchConditionCityCategoryRegionDraw()
            .cityBrandInfos?.forthClass!.count ?? 0
        if forthBrandCount > 0 {
            tableViewDataSourcesBrand.append(contentsOf:(HotelManager.shareInstance.searchConditionCityCategoryRegionDraw()
                .cityBrandInfos?.forthClass)!)
        }
        // 2 是 四星 高档
        let thirdBrandCount:NSInteger = HotelManager.shareInstance.searchConditionCityCategoryRegionDraw()
            .cityBrandInfos?.thirdClass!.count ?? 0
        if thirdBrandCount > 0 {
            tableViewDataSourcesBrand.append(contentsOf:(HotelManager.shareInstance.searchConditionCityCategoryRegionDraw()
                .cityBrandInfos?.thirdClass)!)
        }
        // 3 是 三星 舒适
        let secondBrandCount:NSInteger = HotelManager.shareInstance.searchConditionCityCategoryRegionDraw()
            .cityBrandInfos?.secondClass!.count ?? 0
        if secondBrandCount > 0 {
            tableViewDataSourcesBrand.append(contentsOf:(HotelManager.shareInstance.searchConditionCityCategoryRegionDraw()
                .cityBrandInfos?.secondClass)!)
        }
        // 4 是 经济 快捷
        let firstBrandCount:NSInteger = HotelManager.shareInstance.searchConditionCityCategoryRegionDraw()
            .cityBrandInfos?.firstClass!.count ?? 0
        if firstBrandCount > 0 {
            tableViewDataSourcesBrand.append(contentsOf:(HotelManager.shareInstance.searchConditionCityCategoryRegionDraw()
                .cityBrandInfos?.firstClass)!)
        }
    }
    
    
    
    /// 酒店 品牌
    private func selectedHotelBrand(index:NSInteger) {
        if tableViewDataSourcesBrand.count > index {
            currentSearchConditionCategoryBrandIndex = index
            //hotelBrandTitleContentLabel.text = tableViewDataSourcesBrand[index].brandName
            hotelBrandTitleContentButton.setTitle(tableViewDataSourcesBrand[index].brandName, for: UIControlState.normal)
            let searchCondition = HotelManager.shareInstance.searchConditionUserDraw()
            searchCondition.brandId = tableViewDataSourcesBrand[index].brandElongId
            HotelManager.shareInstance.searchConditionUserStore(searchCondition: searchCondition)
            
        }
    }
    
    
    
    //MARK:------Action------
    func searchButtonAction() {
        if hotelSearchConditionViewSearchBlock != nil {
            hotelSearchConditionViewSearchBlock("")
        }
        backButtonAction(sender: UIButton())
    }
    func rangeSliderValueChanged(_ rangeSlider: RangeSlider) {
        var lowerStr:String = ""
        var highStr:String = ""
        rangeSliderLowerValue = Float(rangeSlider.lowerValue * MAXRangeSliderValue)
        rangeSliderHighValue = Float(rangeSlider.upperValue * MAXRangeSliderValue )
        
        lowerStr = (floorf(rangeSliderLowerValue) * Float(rangeSlider.stepValue)).OneOfTheEffectiveFraction()
        highStr = (floorf(rangeSliderHighValue) * Float(rangeSlider.stepValue)).OneOfTheEffectiveFraction()

        let searchCondition = HotelManager.shareInstance.searchConditionUserDraw()
        searchCondition.lowRate = NSInteger(lowerStr) ?? 0
        searchCondition.highRate = NSInteger(highStr) ?? 0
        HotelManager.shareInstance.searchConditionUserStore(searchCondition: searchCondition)
        
        if rangeSlider.upperValue >= 1.0 {
            highStr = "不限"
        }

        priceTitleContentExampleLabel.text = "¥" + lowerStr + "-" + highStr
        
    }
    
    override func rightButtonAction(sender: UIButton) {
        let searchCondition = HotelManager.shareInstance.searchConditionUserDraw()
        searchCondition.highRate = hotelSearchMaxPrice
        searchCondition.lowRate = 0
        searchCondition.score = ""
        //recommendTitleContentLabel.text = "不限"
        recommendTitleContentButton.setTitle("不限", for: UIControlState.normal)
        searchCondition.hotelStarRate = ""
        //hotelClassTitleContentLabel.text = "不限"
        hotelClassTitleContentButton.setTitle("不限", for: UIControlState.normal)
        searchCondition.brandId = ""
        //hotelBrandTitleContentLabel.text = "不限"
        hotelBrandTitleContentButton.setTitle("不限", for: UIControlState.normal)
//        hotelBrandBackgroundView.isHidden = true
        HotelManager.shareInstance.searchConditionUserStore(searchCondition:searchCondition)
        setRangeSliderValue(lower:Float(searchCondition.lowRate) , high: Float(searchCondition.highRate))
        
    }
    
    
    override func backButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    enum SearchCategoryListType:NSInteger {
        case SearchCategory_Recommend = 1
        case SearchCategory_Class = 2
        case SearchCategory_Brand = 3
    }
    
    
    
}
