//
//  TravelFooterView.swift
//  shop
//
//  Created by TBI on 2017/6/27.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit


class TravelFooterView: UIView {

    typealias ThroughBlock = (String) ->Void
    
    typealias FilterBlock = (_ clickActionEnum:TravelManyConditionFilterView.ClickActionEnum,_ start1Date:Date?,_ start2Date:Date?,_ journeyDayIndex:Int,_ priceAreaIndex:Int) ->Void
    
    typealias PriceSortSortBlock = (Sort) ->Void
    
    //类型 true为旅游 false本地游
    var isLocalTravel:Bool = true
    
    // 出发时间
    var throughButton = UIButton()
    var throughTitleLabel = UILabel(text: "途经地", color: TBIThemeWhite, size: 11)
    var throughBlock:ThroughBlock!
    
    
    //刷选
    var filterButton = UIButton()
    fileprivate var filterTitleLabel = UILabel(text: "筛选", color: TBIThemeWhite, size: 11)
    var filterBlock:FilterBlock!
    
    // 价格刷选
    fileprivate var priceSortButton = UIButton()
    fileprivate var priceSortTitleLabel = UILabel(text: "价格排序", color: TBIThemeWhite, size: 11)
    var priceSortSortBlock:PriceSortSortBlock!
    
    
    //0 默认 1升  2降
    private var priceSortFlag:Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black
        self.alpha = 0.6
        initView()
        
    }
    
    
    var parentViewController:UIViewController!
    {
        var myViewOption = self.superview
        while let myView = myViewOption
        {
            let nextResponder = myView.next
            if let vc = (nextResponder as? UIViewController)
            {
                return vc
            }
            
            myViewOption = myViewOption?.superview
        }
        
        return nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initButtonSelected () {
        filterButton.isSelected = false
        throughButton.isSelected = false
        priceSortButton.isSelected = false
    }
    
    func initView(){
        let  edge = (UIScreen.main.bounds.width-72)/6
        filterButton.addTarget(self, action: #selector(filterButtonAction(sender:)), for: UIControlEvents.touchUpInside)
      
        filterButton.setEnlargeEdgeWithTop(6 ,left: edge, bottom: 20, right:edge)
        filterButton.setImage(UIImage.init(named: "ic_travel filter_white"), for: UIControlState.normal)
        filterButton.setImage(UIImage.init(named: "ic_travel filter_orange"), for: UIControlState.selected)
        
        throughButton.addTarget(self, action: #selector(throughButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        throughButton.setEnlargeEdgeWithTop(6 ,left: edge, bottom: 20, right:edge)
        throughButton.setImage(UIImage.init(named: "ic_via_white"), for: UIControlState.normal)
        throughButton.setImage(UIImage.init(named: "ic_via_orange"), for: UIControlState.selected)
        
        priceSortButton.addTarget(self, action: #selector(priceSortButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        priceSortButton.setEnlargeEdgeWithTop(6 ,left: edge, bottom: 20, right:edge)
        priceSortButton.setImage(UIImage.init(named: "ic_price_white"), for: UIControlState.normal)
        priceSortButton.setImage(UIImage.init(named: "ic_price_orange"), for: UIControlState.selected)
        
        addSubview(throughButton)
        throughButton.snp.makeConstraints { (make) in
            make.top.equalTo(2)
            make.left.equalToSuperview().offset(64)
            make.height.width.equalTo(32)
        }
        addSubview(throughTitleLabel)
        throughTitleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(-4)
            make.centerX.equalTo(throughButton.snp.centerX).offset(-2)
        }
        
        addSubview(filterButton)
        filterButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(2)
            make.height.width.equalTo(32)
        }
        addSubview(filterTitleLabel)
        filterTitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(filterButton.snp.centerX).offset(-2)
            make.bottom.equalTo(-4)
        }
        addSubview(priceSortButton)
        priceSortButton.snp.makeConstraints { (make) in
            make.top.equalTo(2)
            make.right.equalToSuperview().offset(-64)
            make.height.width.equalTo(32)
        }
        
        addSubview(priceSortTitleLabel)
        priceSortTitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(priceSortButton.snp.centerX)
            make.bottom.equalTo(-4)
        }
    }
    /// 刷选
    func filterButtonAction(sender:UIButton) {
       
        
        let alertView = TravelManyConditionFilterView.getInstance(viewController:parentViewController,isLocalTravel: isLocalTravel) { (clickActionEnum, startDate0, startDate1, journeyDayIndex, priceAreaIndex) in
            switch clickActionEnum {
            case .ok:
                self.filterBlock(clickActionEnum,startDate0,startDate1,journeyDayIndex,priceAreaIndex)
                
            case .cancel:
                break
                
            }
        }
        //TODO:*******我改了 ^_^
        //KeyWindow?.addSubview(alertView)
        parentViewController.view.addSubview(alertView)
        
    }
    

    
    func throughButtonAction(sender:UIButton) {
        
        throughBlock("")
       
    }
    
    
    
    
    func priceSortButtonAction(sender:UIButton) {
        printDebugLog(message: "flightPriceSortButtonAction  view ...")
        switch priceSortFlag {
        case 0:
            priceSortFlag = 1
            sender.isSelected = true
            priceSortSortBlock(Sort.priceAsc)
            priceSortTitleLabel.text = "价格升序"
        case 1:
            priceSortFlag = 2
            sender.isSelected = true
            priceSortSortBlock(Sort.priceDesc)
            priceSortTitleLabel.text = "价格降序"
        case 2:
            priceSortFlag = 0
            sender.isSelected = false
             priceSortSortBlock(Sort.priceSort)
            priceSortTitleLabel.text = "价格排序"
        default:
            break
        }
    }

    
}

// 订单总价下一步footer
class TravelOrderFooterView: UIView {
    
    let priceCountLabel = UILabel(text: "0", color: TBIThemePrimaryWarningColor, size: 20)
    
    lazy var leftView:UIView = {
        let vi = UIView()
        vi.backgroundColor = TBIThemeWhite
        let line = UILabel(color: TBIThemeGrayLineColor)
        let titleLabel = UILabel(text: "订单总价", color: TBIThemePrimaryTextColor, size: 13)
        let yLabel = UILabel(text: "¥", color: TBIThemePrimaryWarningColor, size: 13)
        vi.addSubview(line)
        vi.addSubview(titleLabel)
        vi.addSubview(self.priceCountLabel)
        vi.addSubview(yLabel)
        line.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalTo(0)
            make.height.equalTo(1)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
        yLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            //make.left.equalTo(80)
            make.bottom.equalTo(titleLabel.snp.bottom)
//            make.bottom.equalTo(self.priceCountLabel.snp.bottom)
//            make.right.equalTo(self.priceCountLabel.snp.left)
        }
        
        self.priceCountLabel.snp.makeConstraints { (make) in
            //make.right.equalTo(-44)
            make.left.equalTo(yLabel.snp.right)
            make.bottom.equalTo(titleLabel.snp.bottom).offset(2)
        }
       
        return vi
    }()
    
    let submitButton:UIButton = UIButton(title: "",titleColor: TBIThemeWhite,titleSize: 16)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView(){
        addSubview(leftView)
        addSubview(submitButton)
        submitButton.backgroundColor = TBIThemePrimaryWarningColor
        leftView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.height.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
        }
        submitButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.height.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
        }
    }

}


class TravelLocalFooterView: UIView {
    
    typealias ThroughBlock = (String) ->Void
    
    typealias FilterBlock = (_ clickActionEnum:TravelManyConditionFilterView.ClickActionEnum,_ start1Date:Date?,_ start2Date:Date?,_ journeyDayIndex:Int,_ priceAreaIndex:Int) ->Void
    
    typealias PriceSortSortBlock = (Sort) ->Void
    
    //类型 true为旅游 false本地游
    var isLocalTravel:Bool = true
    
  
    
    
    //刷选
    var filterButton = UIButton()
    fileprivate var filterTitleLabel = UILabel(text: "筛选", color: TBIThemeWhite, size: 11)
    var filterBlock:FilterBlock!
    
    // 价格刷选
    fileprivate var priceSortButton = UIButton()
    fileprivate var priceSortTitleLabel = UILabel(text: "价格排序", color: TBIThemeWhite, size: 11)
    var priceSortSortBlock:PriceSortSortBlock!
    
    
    //0 默认 1升  2降
    private var priceSortFlag:Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black
        self.alpha = 0.6
        initView()
        
    }
    
    
    var parentViewController:UIViewController!
    {
        var myViewOption = self.superview
        while let myView = myViewOption
        {
            let nextResponder = myView.next
            if let vc = (nextResponder as? UIViewController)
            {
                return vc
            }
            
            myViewOption = myViewOption?.superview
        }
        
        return nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initButtonSelected () {
        filterButton.isSelected = false
        
        priceSortButton.isSelected = false
    }
    
    func initView(){
        let  edge = (UIScreen.main.bounds.width-30)/4
        filterButton.addTarget(self, action: #selector(filterButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        
        filterButton.setEnlargeEdgeWithTop(6 ,left: edge, bottom: 20, right:edge)
        filterButton.setImage(UIImage.init(named: "ic_travel filter_white"), for: UIControlState.normal)
        filterButton.setImage(UIImage.init(named: "ic_travel filter_orange"), for: UIControlState.selected)
        
       
        
        priceSortButton.addTarget(self, action: #selector(priceSortButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        priceSortButton.setEnlargeEdgeWithTop(6 ,left: edge, bottom: 20, right:edge)
        priceSortButton.setImage(UIImage.init(named: "ic_price_white"), for: UIControlState.normal)
        priceSortButton.setImage(UIImage.init(named: "ic_price_orange"), for: UIControlState.selected)
        
        
        addSubview(filterButton)
        filterButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview().offset(-65)
            make.top.equalTo(2)
            make.height.width.equalTo(32)
        }
        addSubview(filterTitleLabel)
        filterTitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview().offset(-67)
            make.bottom.equalTo(-4)
        }
        addSubview(priceSortButton)
        priceSortButton.snp.makeConstraints { (make) in
            make.top.equalTo(2)
             make.centerX.equalToSuperview().offset(65)
            make.height.width.equalTo(32)
        }
        
        addSubview(priceSortTitleLabel)
        priceSortTitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(priceSortButton.snp.centerX)
            make.bottom.equalTo(-4)
        }
    }
    /// 刷选
    func filterButtonAction(sender:UIButton) {
        
        
        let alertView = TravelManyConditionFilterView.getInstance(viewController:parentViewController,isLocalTravel: isLocalTravel) { (clickActionEnum, startDate0, startDate1, journeyDayIndex, priceAreaIndex) in
            switch clickActionEnum {
            case .ok:
                self.filterBlock(clickActionEnum,startDate0,startDate1,journeyDayIndex,priceAreaIndex)
                
            case .cancel:
                break
                
            }
        }
        //TODO:*******我改了 ^_^
        //KeyWindow?.addSubview(alertView)
        parentViewController.view.addSubview(alertView)
        
    }
    

    
    
    
    func priceSortButtonAction(sender:UIButton) {
        printDebugLog(message: "flightPriceSortButtonAction  view ...")
        switch priceSortFlag {
        case 0:
            priceSortFlag = 1
            sender.isSelected = true
            priceSortSortBlock(Sort.priceAsc)
            priceSortTitleLabel.text = "价格升序"
        case 1:
            priceSortFlag = 2
            sender.isSelected = true
            priceSortSortBlock(Sort.priceDesc)
            priceSortTitleLabel.text = "价格降序"
        case 2:
            priceSortFlag = 0
            sender.isSelected = false
            priceSortSortBlock(Sort.priceSort)
            priceSortTitleLabel.text = "价格排序"
        default:
            break
        }
    }
    
    
}

