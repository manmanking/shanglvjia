//
//  FlightPriceInfoView.swift
//  shop
//
//  Created by TBI on 2017/5/20.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class FlightPriceInfoView: UIView {
    
    let priceTitleLabel = UILabel(text: "费用明细", color: TBIThemePrimaryTextColor, size: 16)
    
    let priceLine = UILabel(color: TBIThemeGrayLineColor)
    
    let line =  UILabel(color: TBIThemeGrayLineColor)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView(personCount:Int,takeOffPrice:Int,takeOffTax:Int,
                  arrivePrice:Int,arriveTax:Int,iScourier:Bool,
                  takeOffFlueTaxAmountPrice:NSInteger,arriveFlueTaxAmountPrice:NSInteger,
                  insuranceCount:Int,type:NSInteger){
        
        addSubview(priceTitleLabel)
        addSubview(priceLine)
        
        var flueTaxTop:NSInteger = 0
        priceTitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(22)
        }
        priceLine.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(0.5)
            make.top.equalTo(44)
        }
        
        if type == 1 { //往返
            flueTaxTop = 167 + 46
            let takeOffTitleLabel = UILabel(text: "去程票价", color: TBIThemePrimaryTextColor, size: 13)
           
            let takeOffPersonLabel = UILabel(text: "X\(personCount)人", color: TBIThemeMinorTextColor, size: 13)
            let takeOffPriceLabel = UILabel(text: "¥\(takeOffPrice)", color: TBIThemeOrangeColor, size: 13)
            
            let takeOffTaxTitleLabel = UILabel(text: "去程机建", color: TBIThemePrimaryTextColor, size: 13)
            let takeOffTaxPersonLabel = UILabel(text: "X\(personCount)人", color: TBIThemeMinorTextColor, size: 13)
            let takeOffTaxPriceLabel = UILabel(text: "¥\(takeOffTax)", color: TBIThemeOrangeColor, size: 13)
            
            addSubview(takeOffTitleLabel)
            takeOffTitleLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(15)
                make.top.equalTo(priceLine.snp.bottom).offset(15)
            })
            addSubview(takeOffPersonLabel)
            takeOffPersonLabel.snp.makeConstraints({ (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(takeOffTitleLabel.snp.top)
            })
            addSubview(takeOffPriceLabel)
            takeOffPriceLabel.snp.makeConstraints({ (make) in
                make.right.equalTo(-15)
                make.centerY.equalTo(takeOffTitleLabel)
            })
            addSubview(takeOffTaxTitleLabel)
            takeOffTaxTitleLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(15)
                make.top.equalTo(takeOffTitleLabel.snp.bottom).offset(10)
            })
            addSubview(takeOffTaxPersonLabel)
            takeOffTaxPersonLabel.snp.makeConstraints({ (make) in
                make.centerX.equalToSuperview()
                //make.top.equalTo(takeOffTaxTitleLabel.snp.top)
                make.centerY.equalTo(takeOffTaxTitleLabel)
            })
            addSubview(takeOffTaxPriceLabel)
            takeOffTaxPriceLabel.snp.makeConstraints({ (make) in
                make.right.equalTo(-15)
                //make.top.equalTo(takeOffPriceLabel.snp.bottom).offset(10)
                make.centerY.equalTo(takeOffTaxTitleLabel)
            })
            
            let takeOffFuelTaxTitleLabel = UILabel(text: "燃油费", color: TBIThemePrimaryTextColor, size: 13)
            
            let takeOffFuelTaxPersonLabel = UILabel(text: "X\(personCount)份", color: TBIThemeMinorTextColor, size: 13)
            
            let takeOffFuelTaxPriceLabel = UILabel(text: "¥\(personCount * takeOffFlueTaxAmountPrice)", color: TBIThemeOrangeColor, size: 13)
            
            
            
            
            addSubview(takeOffFuelTaxTitleLabel)
            takeOffFuelTaxTitleLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(15)
                make.top.equalTo(takeOffTaxPriceLabel.snp.bottom).offset(10)
                make.height.equalTo(13)
            })
            addSubview(takeOffFuelTaxPersonLabel)
            takeOffFuelTaxPersonLabel.snp.makeConstraints({ (make) in
                make.centerX.equalToSuperview()
                make.centerY.equalTo(takeOffFuelTaxTitleLabel)
                make.height.equalTo(13)
            })
            addSubview(takeOffFuelTaxPriceLabel)
            takeOffFuelTaxPriceLabel.snp.makeConstraints({ (make) in
                make.right.equalTo(-15)
                make.centerY.equalTo(takeOffFuelTaxTitleLabel)
                make.height.equalTo(13)
            })
            
            let arriveTitleLabel = UILabel(text: "返程票价", color: TBIThemePrimaryTextColor, size: 13)
            
            let arrivePersonLabel = UILabel(text: "X\(personCount)人", color: TBIThemeMinorTextColor, size: 13)
            let arrivePriceLabel = UILabel(text: "¥\(arrivePrice)", color: TBIThemeOrangeColor, size: 13)
            
            let arriveTaxTitleLabel = UILabel(text: "返程机建", color: TBIThemePrimaryTextColor, size: 13)
            
            let arriveTaxPersonLabel = UILabel(text: "X\(personCount)人", color: TBIThemeMinorTextColor, size: 13)
            let arriveTaxPriceLabel = UILabel(text: "¥\(arriveTax)", color: TBIThemeOrangeColor, size: 13)
            
            
            
            addSubview(arriveTitleLabel)
            arriveTitleLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(15)
                make.top.equalTo(takeOffFuelTaxTitleLabel.snp.bottom).offset(10)
            })
            addSubview(arrivePersonLabel)
            arrivePersonLabel.snp.makeConstraints({ (make) in
                make.centerX.equalToSuperview()
                //make.top.equalTo(arriveTitleLabel.snp.top)
                make.centerY.equalTo(arriveTitleLabel)
            })
            addSubview(arrivePriceLabel)
            arrivePriceLabel.snp.makeConstraints({ (make) in
                make.right.equalTo(-15)
                //make.top.equalTo(arriveTitleLabel.snp.top)
                make.centerY.equalTo(arriveTitleLabel)
                make.height.equalTo(15)
            })
            addSubview(arriveTaxTitleLabel)
            arriveTaxTitleLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(15)
                make.top.equalTo(arriveTitleLabel.snp.bottom).offset(10)
                
            })
            addSubview(arriveTaxPersonLabel)
            arriveTaxPersonLabel.snp.makeConstraints({ (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(arriveTaxTitleLabel.snp.top)
            })
            addSubview(arriveTaxPriceLabel)
            arriveTaxPriceLabel.snp.makeConstraints({ (make) in
                make.right.equalTo(-15)
                make.top.equalTo(arriveTaxTitleLabel.snp.top)
            })
            
            
            let arriveFuelTaxTitleLabel = UILabel(text: "燃油费", color: TBIThemePrimaryTextColor, size: 13)
            
            let arriveFuelTaxPersonLabel = UILabel(text: "X\(personCount)份", color: TBIThemeMinorTextColor, size: 13)
            
            let arriveFuelTaxPriceLabel = UILabel(text: "¥\(personCount * arriveFlueTaxAmountPrice)", color: TBIThemeOrangeColor, size: 13)
            
            addSubview(arriveFuelTaxTitleLabel)
            arriveFuelTaxTitleLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(15)
                make.top.equalTo(arriveTaxPriceLabel.snp.bottom).offset(10)
                make.height.equalTo(13)
            })
            addSubview(arriveFuelTaxPersonLabel)
            arriveFuelTaxPersonLabel.snp.makeConstraints({ (make) in
                make.centerX.equalToSuperview()
                make.centerY.equalTo(arriveFuelTaxTitleLabel)
                make.height.equalTo(13)
            })
            addSubview(arriveFuelTaxPriceLabel)
            arriveFuelTaxPriceLabel.snp.makeConstraints({ (make) in
                make.right.equalTo(-15)
                make.centerY.equalTo(arriveFuelTaxTitleLabel)
                make.height.equalTo(13)
            })
            
            
            
        }else { //单程
            
            flueTaxTop = 110
            let takeOffTitleLabel = UILabel(text: "票价", color: TBIThemePrimaryTextColor, size: 13)
            
            let takeOffPersonLabel = UILabel(text: "X\(personCount)人", color: TBIThemeMinorTextColor, size: 13)
            let takeOffPriceLabel = UILabel(text: "¥\(takeOffPrice)", color: TBIThemeOrangeColor, size: 13)
            
            let takeOffTaxTitleLabel = UILabel(text: "机建", color: TBIThemePrimaryTextColor, size: 13)
            
            let takeOffTaxPersonLabel = UILabel(text: "X\(personCount)人", color: TBIThemeMinorTextColor, size: 13)
            let takeOffTaxPriceLabel = UILabel(text: "¥\(takeOffTax)", color: TBIThemeOrangeColor, size: 13)
            
            addSubview(takeOffTitleLabel)
            takeOffTitleLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(15)
                make.top.equalTo(priceLine.snp.bottom).offset(15)
                make.height.equalTo(13)
            })
            addSubview(takeOffPersonLabel)
            takeOffPersonLabel.snp.makeConstraints({ (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(takeOffTitleLabel.snp.top)
                make.height.equalTo(13)
            })
            addSubview(takeOffPriceLabel)
            takeOffPriceLabel.snp.makeConstraints({ (make) in
                make.right.equalTo(-15)
                make.top.equalTo(takeOffTitleLabel.snp.top)
                make.height.equalTo(13)
            })
            addSubview(takeOffTaxTitleLabel)
            takeOffTaxTitleLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(15)
                make.top.equalTo(takeOffTitleLabel.snp.bottom).offset(10)
                make.height.equalTo(13)
            })
            addSubview(takeOffTaxPersonLabel)
            takeOffTaxPersonLabel.snp.makeConstraints({ (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(takeOffTaxTitleLabel.snp.top)
                make.height.equalTo(13)
            })
            addSubview(takeOffTaxPriceLabel)
            takeOffTaxPriceLabel.snp.makeConstraints({ (make) in
                make.right.equalTo(-15)
                make.top.equalTo(takeOffPriceLabel.snp.bottom).offset(10)
                make.height.equalTo(13)
            })
            flueTaxTop += 23
            //燃油 费用
            let takeOffFuelTaxTitleLabel = UILabel(text: "燃油费", color: TBIThemePrimaryTextColor, size: 13)
            
            let takeOffFuelTaxPersonLabel = UILabel(text: "X\(personCount)份", color: TBIThemeMinorTextColor, size: 13)
            
            let takeOffFuelTaxPriceLabel = UILabel(text: "¥\(personCount * takeOffFlueTaxAmountPrice)", color: TBIThemeOrangeColor, size: 13)
            
            addSubview(takeOffFuelTaxTitleLabel)
            takeOffFuelTaxTitleLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(15)
                make.top.equalToSuperview().inset(flueTaxTop)
                make.height.equalTo(13)
            })
            addSubview(takeOffFuelTaxPersonLabel)
            takeOffFuelTaxPersonLabel.snp.makeConstraints({ (make) in
                make.centerX.equalToSuperview()
                make.centerY.equalTo(takeOffFuelTaxTitleLabel)
                make.height.equalTo(13)
            })
            addSubview(takeOffFuelTaxPriceLabel)
            takeOffFuelTaxPriceLabel.snp.makeConstraints({ (make) in
                make.right.equalTo(-15)
                make.centerY.equalTo(takeOffFuelTaxTitleLabel)
                make.height.equalTo(13)
            })
            addSubview(line)
            if type == 1 {
                line.snp.makeConstraints({ (make) in
                    make.left.equalTo(15)
                    make.right.equalTo(-15)
                    make.height.equalTo(0.5)
                    make.top.equalTo(flueTaxTop)
                })
            }else{
                line.snp.makeConstraints({ (make) in
                    make.left.equalTo(15)
                    make.right.equalTo(-15)
                    make.height.equalTo(0.5)
                    make.top.equalTo(flueTaxTop - 18)
                })
            }
            
        }
        
       
        
       
        
        
        
        
        if iScourier{
            addSubview(line)
            if searchModel.type == 2 {
                line.snp.makeConstraints({ (make) in
                    make.left.equalTo(15)
                    make.right.equalTo(-15)
                    make.height.equalTo(0.5)
                    make.top.equalTo(flueTaxTop)
                })
            }else{
                line.snp.makeConstraints({ (make) in
                    make.left.equalTo(15)
                    make.right.equalTo(-15)
                    make.height.equalTo(0.5)
                    make.top.equalTo(flueTaxTop)
                })
            }
           
            //快递title
            let courierTitleLabel = UILabel(text: "快递", color: TBIThemePrimaryTextColor, size: 13)
            
            let courierCountLabel = UILabel(text: "X1单", color: TBIThemeMinorTextColor, size: 13)
            
            let courierPriceLabel = UILabel(text: "¥10", color: TBIThemeOrangeColor, size: 13)
            
            addSubview(courierTitleLabel)
            courierTitleLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(15)
                make.bottom.equalTo(-15)
            })
            addSubview(courierCountLabel)
            courierCountLabel.snp.makeConstraints({ (make) in
                make.centerX.equalToSuperview()
                make.bottom.equalTo(courierTitleLabel.snp.bottom)
            })
            addSubview(courierPriceLabel)
            courierPriceLabel.snp.makeConstraints({ (make) in
                make.right.equalTo(-15)
                make.bottom.equalTo(courierTitleLabel.snp.bottom)
            })
           
            
            
            
        }
        
        
        if insuranceCount != 0{
            addSubview(line)
            if type == 1 {
                line.snp.remakeConstraints({ (make) in
                    make.left.equalTo(15)
                    make.right.equalTo(-15)
                    make.height.equalTo(0.5)
                    make.top.equalTo(flueTaxTop + 10)
                })
            }else{
                line.snp.remakeConstraints({ (make) in
                    make.left.equalTo(15)
                    make.right.equalTo(-15)
                    make.height.equalTo(0.5)
                    make.top.equalTo(flueTaxTop - 18)
                })
            }
            
            //保险 title
            let courierTitleLabel = UILabel(text: "保险", color: TBIThemePrimaryTextColor, size: 13)
            
            let courierCountLabel = UILabel(text: "X\(insuranceCount)份", color: TBIThemeMinorTextColor, size: 13)
            
            let courierPriceLabel = UILabel(text: "¥\(insuranceCount*20)", color: TBIThemeOrangeColor, size: 13)
            
            addSubview(courierTitleLabel)
            courierTitleLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(15)
                make.bottom.equalTo(-15)
            })
            addSubview(courierCountLabel)
            courierCountLabel.snp.makeConstraints({ (make) in
                make.centerX.equalToSuperview()
                make.bottom.equalTo(courierTitleLabel.snp.bottom)
            })
            addSubview(courierPriceLabel)
            courierPriceLabel.snp.makeConstraints({ (make) in
                make.right.equalTo(-15)
                make.bottom.equalTo(courierTitleLabel.snp.bottom)
            })
        }
        
        
        
        
        
    }

}
