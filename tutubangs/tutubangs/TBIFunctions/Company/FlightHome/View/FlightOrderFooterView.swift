//
//  FlightOrderFooterView.swift
//  shop
//
//  Created by TBI on 2017/5/17.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class FlightOrderFooterView: UIView {

    let priceCountLabel = UILabel(text: "", color: TBIThemePrimaryWarningColor, size: 20)
    
    let priceButton = UIButton()
    
   
    
    lazy var leftView:UIView = {
        let vi = UIView()
        vi.backgroundColor = TBIThemeWhite
        let line = UILabel(color: TBIThemeGrayLineColor)
        let titleLabel = UILabel(text: "订单总价", color: TBIThemePrimaryTextColor, size: 13)
        let yLabel = UILabel(text: "¥", color: TBIThemeRedColor, size: 13)
        vi.addSubview(line)
        vi.addSubview(titleLabel)
        vi.addSubview(self.priceCountLabel)
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
        self.priceCountLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-44)
            make.centerY.equalToSuperview()
        }
        yLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.priceCountLabel.snp.bottom).offset(-3)
            make.right.equalTo(self.priceCountLabel.snp.left)
        }
        return vi
    }()
    
    let submitButton:UIButton = UIButton(title: PersonalType == true ? "去付款":"去预订",titleColor: TBIThemeWhite,titleSize: 16)
        
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
        addSubview(priceButton)
        priceButton.setImage(UIImage(named: "ic_up_gray"), for: UIControlState.normal)
        priceButton.setImage(UIImage(named: "ic_down_gray"), for: UIControlState.selected)
        submitButton.backgroundColor = TBIThemeDarkBlueColor
        //priceButton.setEnlargeEdge(top: 20, left: 400, bottom: 20, right: 0)
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
    }

}
