//
//  VisaOrderFooterView.swift
//  shanglvjia
//
//  Created by tbi on 2018/7/18.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class VisaOrderFooterView: UIView {


    let totalPriceLabel = UILabel(text: "", color: TBIThemePrimaryWarningColor, size: 20)
    
    let priceButton = UIButton()
    
    let backBlackView = UIView()
    let priceTitleLabel = UILabel(text: "费用明细", color: TBIThemePrimaryTextColor, size: 16)
    let priceLine = UILabel(color: TBIThemeGrayLineColor)
    let whiteView:UIView = UIView()
    let visaTitleLabel = UILabel(text: "", color: PersonalThemeMinorTextColor, size: 13)
    let visaPriceLabel = UILabel(text: "", color: PersonalThemeMinorTextColor, size: 13)
    
    
    lazy var leftView:UIView = {
        let vi = UIView()
        vi.backgroundColor = TBIThemeWhite
        let line = UILabel(color: TBIThemeGrayLineColor)
        let titleLabel = UILabel(text: "总价", color: TBIThemePrimaryTextColor, size: 13)
        let yLabel = UILabel(text: "¥", color: TBIThemePrimaryWarningColor, size: 13)
        vi.addSubview(line)
        vi.addSubview(titleLabel)
        vi.addSubview(self.totalPriceLabel)
        vi.addSubview(yLabel)
        line.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalTo(0)
            make.height.equalTo(0.5)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
        self.totalPriceLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-44)
            make.centerY.equalToSuperview()
        }
        yLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.totalPriceLabel.snp.bottom).offset(-3)
            make.right.equalTo(self.totalPriceLabel.snp.left)
        }
        return vi
    }()
    
    let submitButton:UIButton = UIButton(title: "立即支付",titleColor: TBIThemeWhite,titleSize: 20)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView(){
        backBlackView.backgroundColor = TBIThemeBackgroundViewColor
        backBlackView.isHidden = true
        addSubview(backBlackView)
        totalPriceLabel.font = UIFont.boldSystemFont(ofSize: 20)
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        addSubview(leftView)
        addSubview(submitButton)
        addSubview(priceButton)
        priceButton.setImage(UIImage(named: "ic_down_gray"), for: UIControlState.normal)
        priceButton.setImage(UIImage(named: "ic_up_gray"), for: UIControlState.selected)
        submitButton.setBackgroundImage(UIImage (named: "yellow_btn_gradient"), for: UIControlState.normal)
        submitButton.customInterval = 3
        priceButton.setEnlargeEdgeWithTop(20 ,left: 400, bottom: 20, right: 0)
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
        priceButton.snp.makeConstraints { (make) in
            make.right.equalTo(submitButton.snp.left).offset(-15)
            make.centerY.equalToSuperview()
        }
        
        ///明细
        backBlackView.addSubview(whiteView)
        whiteView.addSubview(priceTitleLabel)
        whiteView.addSubview(priceLine)
        
        priceTitleLabel.layer.cornerRadius = 15
        priceTitleLabel.clipsToBounds = true
        priceTitleLabel.textAlignment = .center
        priceTitleLabel.backgroundColor = TBIThemeWhite
        priceTitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-48)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        priceLine.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(0.5)
            make.top.equalTo(priceTitleLabel.snp.bottom)
        }
        whiteView.backgroundColor = TBIThemeWhite
        whiteView.snp.makeConstraints { (make) in
            make.top.equalTo(priceTitleLabel.snp.centerY)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        whiteView.addSubview(visaTitleLabel)
        visaTitleLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(15)
            make.top.equalTo(priceLine.snp.bottom).offset(15)
            make.height.equalTo(13)
        })
        whiteView.addSubview(visaPriceLabel)
        visaPriceLabel.snp.makeConstraints({ (make) in
            make.right.equalTo(-15)
            make.top.equalTo(visaTitleLabel.snp.top)
            make.height.equalTo(13)
        })
        
    }
    func fillDataSources(visaItemPrice:String,visaProductName:String,visaCount:NSInteger)  {
        visaTitleLabel.text = visaProductName
        visaPriceLabel.text = "¥\(visaItemPrice)x\(visaCount)"
        var visaItemPriceFloat:Float = 0
        if visaItemPrice.isEmpty == false {
            visaItemPriceFloat = Float(visaItemPrice) ?? 0
        }
        totalPriceLabel.text =  (visaItemPriceFloat * Float(visaCount)).TwoOfTheEffectiveFraction()
    }

}
