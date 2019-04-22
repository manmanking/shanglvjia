//
//  PHotelPriceView.swift
//  shanglvjia
//
//  Created by tbi on 2018/8/2.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PHotelPriceView: UIView {
    
    typealias ReturnSearchPirceBlock = (String,String) -> Void
    var returnSearchPirceBlock:ReturnSearchPirceBlock!
    
    private let MAXRangeSliderValue:Double = 40//2000
    
    private var rangeSliderLowerValue:Float = 200
    private var rangeSliderHighValue:Float = 2000

    private let priceTitleLabel:UILabel = UILabel()
    private let priceTitleContentExampleLabel:UILabel = UILabel()
    private let lowPriceLabel:UILabel = UILabel()
    private let heightPriceLabel:UILabel = UILabel()
    //private let slider:UISlider = UISlider()
    let rangeSlider = RangeSlider(frame: CGRect.zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = TBIThemeWhite
        creatView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func creatView(){
        priceTitleLabel.text = "价格区间"
        priceTitleLabel.font = UIFont.systemFont(ofSize: 14)
        priceTitleLabel.textColor = PersonalThemeMajorTextColor
        self.addSubview(priceTitleLabel)
        priceTitleLabel.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().inset(15)
            make.height.equalTo(16)
            make.width.equalTo(60)
        }
        
        priceTitleContentExampleLabel.text = "¥0 - 不限"
        priceTitleContentExampleLabel.textColor = PersonalThemeMajorTextColor
        priceTitleContentExampleLabel.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(priceTitleContentExampleLabel)
        priceTitleContentExampleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(priceTitleLabel)
            make.left.equalTo(priceTitleLabel.snp.right).offset(38)
            make.height.equalTo(16)
            make.right.equalToSuperview()
        }
        
        rangeSlider.lowerValue = 0.5
        rangeSlider.upperValue = 0.6
        rangeSlider.stepValue = 50
        rangeSlider.trackTintColor = UIColor.init(r: 255, g: 170, b: 0, alpha: 0.5)
        self.addSubview(rangeSlider)
        rangeSlider.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(31)
            make.top.equalToSuperview().offset(70)
        }
        ///初始化slider的位置
        setRangeSliderValue(lower:Float(0) , high: Float(hotelSearchMaxPrice))
        rangeSlider.addTarget(self, action: #selector(rangeSliderValueChanged(_:)), for: UIControlEvents.valueChanged)
    }
    /// 设置 rangeSlider
    func setRangeSliderValue(lower:Float,high:Float) {
        
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
        
        if returnSearchPirceBlock != nil{
            returnSearchPirceBlock(lowerStr,highStr)
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        printDebugLog(message: touches)
        printDebugLog(message: event)
    }
    
}
