//
//  TBISortCriteriaView.swift
//  shop
//
//  Created by manman on 2017/4/20.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit



// up 升 down 降 level 默认
let hotelListPriceOrderState = "hotelListpriceOrderState"

//星级排序。down 降 level 默认
let hotelListStarOrderState = "hotelListStarOrderState"


//1 升序 0 降序
var hotelListPriceOrderStateInteger:NSInteger = 1

class TBISortCriteriaView: UIView {

    typealias PriceScreenBlock = (Dictionary<String,Any>) ->Void
    typealias PriceOrderBlock = (Dictionary<String,Any>) ->Void
    typealias StarScreenBlock = (Dictionary<String,Any>) ->Void
    typealias StarOrderBlock = (Dictionary<String,Any>) ->Void
    
    private var baseBackgroundView = UIView()
    
    private var subBackgroundView = UIView()
    
    private var selectedButton = UIButton()
    
    //价格筛选
    var priceDataSourcesArr:[String] = Array()
    private var priceDataSourcesSelectedIndex:[NSInteger] = Array()
    private var customPrice:String = ""    
    public var priceScreenButton = UIButton()
    private var priceScreenTitleLabel = UILabel()
    public  var priceScreenBlock:PriceScreenBlock!
    
    
    //价格排序
    fileprivate var priceOrderButton = UIButton()
    fileprivate var priceOrderTitleLabel = UILabel()
    var priceOrderBlock:PriceOrderBlock!
    
    // 星级筛选
    var starDataSourcesArr:[String] = Array()
    private var starDataSourcesSelectedIndex:[NSInteger] = Array()
    public var starScreenButton = UIButton()
    fileprivate var startScreenTitleLabel = UILabel()
    var starScreenBlock:StarScreenBlock!
    
    
    // 星级 排序
    fileprivate var starOrderButton = UIButton()
    fileprivate var starOrderTitleLabel = UILabel()
    var starOrderBlock:StarOrderBlock!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        baseBackgroundView.backgroundColor = UIColor.black
        baseBackgroundView.alpha = 0.6
        self.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
            
            make.top.left.bottom.right.equalToSuperview()
            
        }
        
        baseBackgroundView.addSubview(subBackgroundView)
        subBackgroundView.snp.makeConstraints { (make) in
            
            make.top.left.bottom.right.equalToSuperview()
            
        }
        
        setUIViewAutolayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setUIViewAutolayout() {
        
        priceScreenTitleLabel.text = "价格筛选"
        priceScreenTitleLabel.textAlignment = NSTextAlignment.center
        priceScreenTitleLabel.font = UIFont.systemFont(ofSize: 10)
        priceScreenTitleLabel.textColor = UIColor.white
        subBackgroundView.addSubview(priceScreenTitleLabel)
        priceScreenTitleLabel.snp.makeConstraints { (make) in
            
            make.left.equalToSuperview().offset(ScreenWindowWidth/8)
            make.bottom.equalToSuperview().offset(-6)
            make.width.equalToSuperview().dividedBy(7)
            make.height.equalTo(11)
            
        }
        
        
        
        priceScreenButton.addTarget(self, action: #selector(priceScreenButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        priceScreenButton.setImage(UIImage.init(named: "HotelListPriceScreenButtonNormal"), for: UIControlState.normal)
        priceScreenButton.setImage(UIImage.init(named: "HotelListPriceScreenButtonSelected"), for: UIControlState.selected)
        priceScreenButton.setTitle("价格筛选", for: UIControlState.normal)
        priceScreenButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        //priceScreenButton.setEnlargeEdge(top: 0, left: 20, bottom: 0, right: 20)
        priceScreenButton.setEnlargeEdgeWithTop(0, left: 20, bottom: 0, right: 20)
        subBackgroundView.addSubview(priceScreenButton)
        
        priceScreenButton.snp.makeConstraints { (make) in
            
            make.top.equalToSuperview().offset(6)
            make.centerX.equalTo(priceScreenTitleLabel.snp.centerX)
            make.width.equalTo(20)
            make.height.equalTo(24)
            
        }
        
        
        
        
        startScreenTitleLabel.text = "星级筛选"
        startScreenTitleLabel.textAlignment = NSTextAlignment.center
        startScreenTitleLabel.font = UIFont.systemFont(ofSize: 10)
        startScreenTitleLabel.textColor = UIColor.white
        subBackgroundView.addSubview(startScreenTitleLabel)
        startScreenTitleLabel.snp.makeConstraints { (make) in
            
            make.left.equalToSuperview().offset(ScreenWindowWidth/8*2+ScreenWindowWidth/12)
            make.bottom.equalToSuperview().offset(-6)
            make.width.equalToSuperview().dividedBy(7)
            make.height.equalTo(11)
            
        }
        
        
        
        starScreenButton.addTarget(self, action: #selector(starScreenButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        starScreenButton.setImage(UIImage.init(named: "HotelListStarScreenButtonNormal"), for: UIControlState.normal)
        starScreenButton.setImage(UIImage.init(named: "HotelListStarScreenButtonSelected"), for: UIControlState.selected)
        starScreenButton.setTitle("星级筛选", for: UIControlState.normal)
        starScreenButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        //starScreenButton.setEnlargeEdge(top: 0, left: 20, bottom: 0, right: 20)
        starScreenButton.setEnlargeEdgeWithTop(0, left: 20, bottom: 0, right: 20)
        subBackgroundView.addSubview(starScreenButton)
        
        starScreenButton.snp.makeConstraints { (make) in
            
            make.top.equalToSuperview().offset(6)
            make.centerX.equalTo(startScreenTitleLabel.snp.centerX)
            make.width.equalTo(20)
            make.height.equalTo(24)
            
        }
        
        
        starOrderTitleLabel.text = "星级排序"
        starOrderTitleLabel.textAlignment = NSTextAlignment.center
        starOrderTitleLabel.font = UIFont.systemFont(ofSize: 10)
        starOrderTitleLabel.textColor = UIColor.white
        subBackgroundView.addSubview(starOrderTitleLabel)
        starOrderTitleLabel.snp.makeConstraints { (make) in
            
            make.right.equalToSuperview().inset(ScreenWindowWidth/8*2+ScreenWindowWidth/12)
            make.bottom.equalToSuperview().offset(-6)
            make.width.equalToSuperview().dividedBy(7)
            make.height.equalTo(11)
            
        }
        
        
        
        starOrderButton.addTarget(self, action: #selector(starOrderButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        starOrderButton.setImage(UIImage.init(named: "HotelListStarOrderButtonNormal"), for: UIControlState.normal)
        starOrderButton.setImage(UIImage.init(named: "HotelListStarOrderButtonSelected"), for: UIControlState.selected)
        starOrderButton.setTitle("星级排序", for: UIControlState.normal)
        starOrderButton.setTitle("星级降序", for: UIControlState.selected)
        //starOrderButton.setEnlargeEdge(top: 0, left: 20, bottom: 0, right: 20)
        starOrderButton.setEnlargeEdgeWithTop(0, left: 20, bottom: 0, right: 20)
        starOrderButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        subBackgroundView.addSubview(starOrderButton)
        
        starOrderButton.snp.makeConstraints { (make) in
            
            make.top.equalToSuperview().offset(6)
            make.centerX.equalTo(starOrderTitleLabel.snp.centerX)
            make.width.equalTo(20)
            make.height.equalTo(24)
            
        }
        
        
        priceOrderTitleLabel.text = "价格排序"
        priceOrderTitleLabel.textAlignment = NSTextAlignment.center
        priceOrderTitleLabel.font = UIFont.systemFont(ofSize: 10)
        priceOrderTitleLabel.textColor = UIColor.white
        subBackgroundView.addSubview(priceOrderTitleLabel)
        priceOrderTitleLabel.snp.makeConstraints { (make) in
            
            make.right.equalToSuperview().inset(ScreenWindowWidth/8)
            make.bottom.equalToSuperview().offset(-6)
            make.width.equalToSuperview().dividedBy(7)
            make.height.equalTo(11)
            
        }
        
        
        
        priceOrderButton.addTarget(self, action: #selector(priceOrderButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        priceOrderButton.setImage(UIImage.init(named: "HotelListPriceOrderButtonNormal"), for: UIControlState.normal)
        priceOrderButton.setImage(UIImage.init(named: "HotelListPriceOrderButtonSelected"), for: UIControlState.selected)
        priceOrderButton.setTitle("价格排序", for: UIControlState.normal)
        priceOrderButton.setTitle("价格升序", for: UIControlState.selected)
        //priceOrderButton.setEnlargeEdge(top: 0, left: 20, bottom: 0, right: 20)
        priceOrderButton.setEnlargeEdgeWithTop(0, left: 20, bottom: 0, right: 20)
        priceOrderButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        subBackgroundView.addSubview(priceOrderButton)
        
        priceOrderButton.snp.makeConstraints { (make) in
            
            make.top.equalToSuperview().offset(6)
            make.centerX.equalTo(priceOrderTitleLabel.snp.centerX)
            make.width.equalTo(20)
            make.height.equalTo(24)
            
        }
        
        
        
        
    }
    
    
    
    //MARK:- Action
    //价格筛选
    func priceScreenButtonAction(sender:UIButton) {
        printDebugLog(message: "priceScreenButtonAction  view ...")
//        setButtonState(sender: sender)
//        selectedButton.isSelected = false
        
        if priceDataSourcesSelectedIndex.count == 0 {
            priceDataSourcesSelectedIndex.append(0)
        }
        
        weak var weakSelf = self
        let priceView = HotelCustomScreenView.init(frame: ScreenWindowFrame)
        priceView.hotelCustomScreenType = HotelCustomScreenType.Price
        priceView.datasource = priceDataSourcesArr
        if  priceDataSourcesSelectedIndex.count > 0
        {
            priceView.selectedIndexArr = priceDataSourcesSelectedIndex
        }
        
        if priceDataSourcesSelectedIndex.first == 5 {
            let priceArr = customPrice.components(separatedBy: "-")
            priceView.lowPrice = NSInteger(priceArr[0])!
            priceView.upPrice = NSInteger(priceArr[1])!
        }
        
        
        priceView.hotelCustomScreenDetermineConditionBlock = { (parameter) in
            
            weakSelf?.hotelCustomScreenDetermineConditionPriceResultAction(parameters:parameter)
            
        }
        
        KeyWindow?.addSubview(priceView)
        
    }
    
    func hotelCustomScreenDetermineConditionPriceResultAction(parameters:Dictionary<String,Any>) {
        print("价格筛选")
        print(parameters)
        
        priceDataSourcesSelectedIndex = parameters[HotelCustomScreenDetermineConditionDetailIndex] as! [NSInteger]
        if priceDataSourcesSelectedIndex.contains(5) {
            
            let price:[String] = parameters[HotelCustomScreenDetermineConditionDetail] as! Array
            customPrice = price.first!
        }
        self.priceScreenBlock(parameters)
        
        
    }
    
    
    //星级筛选
    func starScreenButtonAction(sender:UIButton) {
        printDebugLog(message: "startScreenButtonAction  view ...")
//        setButtonState(sender: sender)
        weak var weakSelf = self
        let priceView = HotelCustomScreenView.init(frame: ScreenWindowFrame)
        priceView.hotelCustomScreenType = HotelCustomScreenType.Star
        priceView.datasource = starDataSourcesArr
        
        if starDataSourcesSelectedIndex.count == 0 {
            starDataSourcesSelectedIndex.append(0)
        }
        
        if starDataSourcesSelectedIndex.count > 0 {
            priceView.selectedIndexArr = starDataSourcesSelectedIndex
        }
        priceView.hotelCustomScreenDetermineConditionBlock = { (parameter) in
            
            weakSelf?.hotelCustomScreenDetermineConditionStarResultAction(parameters:parameter)
            
        }
        
        KeyWindow?.addSubview(priceView)
    }
    
    func hotelCustomScreenDetermineConditionStarResultAction(parameters:Dictionary<String,Any>) {
        print("星级筛选")
        print(parameters)
        starDataSourcesSelectedIndex = parameters[HotelCustomScreenDetermineConditionDetailIndex] as! [NSInteger]
        self.starScreenBlock(parameters)
    }
    
    
    //星级排序
    func starOrderButtonAction(sender:UIButton) {
        printDebugLog(message: "startOrderButtonAction  view ...")

        var tmp:Dictionary<String,Any> = Dictionary()
        if priceOrderButton.isSelected == true {
            priceOrderButton.isSelected = false
            priceOrderTitleLabel.text = "价格排序"
            
        }
        if sender.isSelected == false
        {
            sender.isSelected = true
            tmp[hotelListStarOrderState] = "down"
            starOrderTitleLabel.text = "星级降序"
            
        }else
        {
            sender.isSelected = false
            tmp[hotelListStarOrderState] = "level"
            starOrderTitleLabel.text = "星级排序"
        }
        
        self.starOrderBlock(tmp)
        
        
    }
    //价格排序
    func priceOrderButtonAction(sender:UIButton) {
        printDebugLog(message: "priceOrderButtonAction  view ...")
        var tmp:Dictionary<String,Any> = Dictionary()
//        selectedButton.isSelected = false
//        selectedButton = sender
//        selectedButton.isSelected = true

        if starOrderButton.isSelected == true {
            starOrderButton.isSelected = false
            starOrderTitleLabel.text = "星级排序"
        }
        
        if sender.isSelected == true {
            print("已经被选中")
            if hotelListPriceOrderStateInteger == 1 {
                tmp[hotelListPriceOrderState] = "down"
                hotelListPriceOrderStateInteger = 0
                priceOrderTitleLabel.text = "价格降序"
            }else
            {
                tmp[hotelListPriceOrderState] = "level"
                sender.isSelected = false
                priceOrderTitleLabel.text = "价格排序"
            }
            
        }else
        {
//            sender.isSelected = true
//            hotelListPriceOrderStateInteger = 0
//            tmp[hotelListPriceOrderState] = "down"
//            priceOrderTitleLabel.text = "价格降序"
//            
            // second
            
            sender.isSelected = true
            hotelListPriceOrderStateInteger = 1
            tmp[hotelListPriceOrderState] = "up"
            priceOrderTitleLabel.text = "价格升序"
            
            
            
            print("已经未被选中")
            
        }
        
        self.priceOrderBlock(tmp)
    }
    
    
    func setButtonState(sender:UIButton) {
        
        if sender.isSelected == true {
            sender.isSelected = false
        }else
        {
            sender.isSelected = true
        }
    }
    
    

}


