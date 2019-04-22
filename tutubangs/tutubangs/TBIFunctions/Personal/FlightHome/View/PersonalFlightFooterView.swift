//
//  PersonalFlightFooterView.swift
//  shanglvjia
//
//  Created by manman on 2018/8/8.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PersonalFlightFooterView: UIView{

    
    typealias PersonalFlightFooterViewShowPriceDetailBlock = (Bool)->Void
    
    public var personalFlightFooterViewShowPriceDetailBlock:PersonalFlightFooterViewShowPriceDetailBlock!
    
    typealias PersonalFlightFooterViewPaymentBlock = ()->Void
    
    public var personalFlightFooterViewPaymentBlock:PersonalFlightFooterViewPaymentBlock!
    
    private let baseBackgroundView:UIView = UIView()
    
    private let leftBaseBackgroundView:UIView = UIView()
    
    private let rightBaseBackgroundView:UIView = UIView()
    
    private let paymentButton:UIButton = UIButton()

    private let totalPriceLabel:UILabel = UILabel()
    
    private let flagButton:UIButton = UIButton()
    
  
    
//    let priceButton = UIButton()
//
//    let backBlackView = UIView()
//
//    let priceLine = UILabel(color: TBIThemeGrayLineColor)
//    let whiteView:UIView = UIView()
//    let visaTitleLabel = UILabel(text: "", color: PersonalThemeMinorTextColor, size: 13)
//    let visaPriceLabel = UILabel(text: "", color: PersonalThemeMinorTextColor, size: 13)
//
//
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        baseBackgroundView.backgroundColor = TBIThemeBaseColor
        self.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        //leftBaseBackgroundView.addOnClickListener(target: self, action: #selector(pricesDetail))
        self.addSubview(leftBaseBackgroundView)
        leftBaseBackgroundView.backgroundColor = TBIThemeWhite
        leftBaseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
        }
        self.addSubview(rightBaseBackgroundView)
        rightBaseBackgroundView.backgroundColor = TBIThemeWhite
        rightBaseBackgroundView.snp.makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
        }
        
        setUIViewAutolayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setUIViewAutolayout() {
        setLeftViewAutolayout()
        setRightViewAutolayout()
        
    }
    
    func setLeftViewAutolayout() {
        
        totalPriceLabel.font = UIFont.systemFont(ofSize: 20)
        totalPriceLabel.textColor = TBIThemePrimaryWarningColor
        leftBaseBackgroundView.addSubview(totalPriceLabel)
        totalPriceLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(15)
        }
        flagButton.setImage(UIImage(named: "ic_up_gray"), for: UIControlState.normal)
        flagButton.setImage(UIImage(named: "ic_down_gray"), for: UIControlState.selected)
        flagButton.setEnlargeEdgeWithTop(10, left: 50, bottom: 10, right: 10)
        flagButton.addTarget(self, action: #selector(pricesDetail), for: UIControlEvents.touchUpInside)
        leftBaseBackgroundView.addSubview(flagButton)
        flagButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(totalPriceLabel.snp.right).offset(3)
        }
        
    }
    
    
    func setRightViewAutolayout() {
        paymentButton.setTitle("立即支付", for: UIControlState.normal)
        paymentButton.addTarget(self, action: #selector(paymentButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        paymentButton.setTitleColor(TBIThemeWhite, for: UIControlState.normal)
        paymentButton.setBackgroundImage(UIImage (named: "yellow_btn_gradient"), for: UIControlState.normal)
        rightBaseBackgroundView.addSubview(paymentButton)
        paymentButton.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
    }
    
   
    func fillDataSources(pricesAmount:Float) {
        
        totalPriceLabel.text =  "总价" + "¥" + pricesAmount.TwoOfTheEffectiveFraction()
    }

    
    
    //MARK:------Action-----
    
    func pricesDetail() {
        flagButton.isSelected = !flagButton.isSelected
        printDebugLog(message: "点击了")
        if personalFlightFooterViewShowPriceDetailBlock != nil {
            personalFlightFooterViewShowPriceDetailBlock(true)
        }
  
    }
    
    func paymentButtonAction(sender:UIButton) {
        if personalFlightFooterViewPaymentBlock != nil {
            personalFlightFooterViewPaymentBlock()
        }
    }

}
