//
//  OrderPriceDetailView.swift
//  shanglvjia
//
//  Created by tbi on 2018/5/18.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class FlightPriceDetailView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initView(personCount:Int,takeOffPrice:Int,takeOffTax:Int,insuranceCount:Int) {
        let takeOffTitleLabel = UILabel(text: "票价", color: TBIThemePrimaryTextColor, size: 13)
        
        let takeOffPersonLabel = UILabel(text: " x \(personCount)人", color: TBIThemeMinorTextColor, size: 13)
        let takeOffPriceLabel = UILabel(text: "¥\(takeOffPrice)", color: TBIThemeOrangeColor, size: 13)
        
        let takeOffTaxTitleLabel = UILabel(text: "机建", color: TBIThemePrimaryTextColor, size: 13)
        
        let takeOffTaxPersonLabel = UILabel(text: " x \(personCount)人", color: TBIThemeMinorTextColor, size: 13)
        let takeOffTaxPriceLabel = UILabel(text: "¥\(takeOffTax)", color: TBIThemeOrangeColor, size: 13)
        
        addSubview(takeOffTitleLabel)
        takeOffTitleLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(15)
            make.top.equalTo(15)
            make.height.equalTo(13)
        })
        addSubview(takeOffPersonLabel)
        takeOffPersonLabel.snp.makeConstraints({ (make) in
            make.right.equalTo(-15)
            make.top.equalTo(takeOffTitleLabel.snp.top)
            make.height.equalTo(13)
        })
        addSubview(takeOffPriceLabel)
        takeOffPriceLabel.snp.makeConstraints({ (make) in
            make.right.equalTo(takeOffPersonLabel.snp.left)
            make.top.equalTo(takeOffTitleLabel.snp.top)
            make.height.equalTo(13)
        })
        addSubview(takeOffTaxTitleLabel)
        takeOffTaxTitleLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(15)
            make.top.equalTo(takeOffTitleLabel.snp.bottom).offset(8)
            make.height.equalTo(takeOffTaxTitleLabel)
        })
        addSubview(takeOffTaxPersonLabel)
        takeOffTaxPersonLabel.snp.makeConstraints({ (make) in
            make.right.equalTo(-15)
            make.top.equalTo(takeOffTaxTitleLabel.snp.top)
            make.height.equalTo(takeOffTaxTitleLabel)
        })
        addSubview(takeOffTaxPriceLabel)
        takeOffTaxPriceLabel.snp.makeConstraints({ (make) in
            make.right.equalTo(takeOffTaxPersonLabel.snp.left)
            make.top.equalTo(takeOffPriceLabel.snp.bottom).offset(8)
            make.height.equalTo(takeOffTaxTitleLabel)
            
            if insuranceCount == 0
            {
                 make.bottom.equalTo(-5)
            }
        })
        
        if insuranceCount != 0{
            //快递title
            let courierTitleLabel = UILabel(text: "保险", color: TBIThemePrimaryTextColor, size: 13)
            
            let courierCountLabel = UILabel(text: " x \(insuranceCount)份", color: TBIThemeMinorTextColor, size: 13)
            
            let courierPriceLabel = UILabel(text: "¥\(insuranceCount*20)", color: TBIThemeOrangeColor, size: 13)
            
            addSubview(courierTitleLabel)
            courierTitleLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(15)
                make.bottom.equalTo(-5)
            })
            addSubview(courierCountLabel)
            courierCountLabel.snp.makeConstraints({ (make) in
                make.right.equalTo(-15)
                make.bottom.equalTo(courierTitleLabel.snp.bottom)
            })
            addSubview(courierPriceLabel)
            courierPriceLabel.snp.makeConstraints({ (make) in
                make.right.equalTo(courierCountLabel.snp.left)
                make.bottom.equalTo(courierTitleLabel.snp.bottom)
            })
        }
        
    }
    
    
}
