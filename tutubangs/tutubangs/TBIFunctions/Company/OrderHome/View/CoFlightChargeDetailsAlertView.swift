//
//  CoFlightChargeDetailsAlertView.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/5/27.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class CoFlightChargeDetailsAlertView: UIView {

    private var baseBackgroundView:UIView = UIView()
    private var contentContainerView:UIView = UIView()
    
    var showTextArray:[(String,String,String)] = []
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
//        showTextArray.append(("成人机票","X3人","¥1800"))
//        showTextArray.append(("机场建设","X3人","¥150"))
//        showTextArray.append(("订单总价","","¥1950"))
        
        
        baseBackgroundView.backgroundColor = TBIThemeBackgroundViewColor
        baseBackgroundView.addOnClickListener(target: self, action: #selector(cancelButtonAction))
        self.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        contentContainerView.backgroundColor = UIColor.white
        contentContainerView.layer.cornerRadius = 7
        contentContainerView.clipsToBounds = true
        self.addSubview(contentContainerView)
        contentContainerView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(35)
            make.centerY.equalToSuperview()
        }
        //setDataSources()
        
        //setSubUIViewlayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func cancelButtonAction() {
        self.removeFromSuperview()
    }
    
    func setSubUIViewlayout() -> Void
    {
        
        let topView = UIView()
        contentContainerView.addSubview(topView)
        topView.snp.makeConstraints{(make)->Void in
            make.left.right.top.equalTo(0)
            make.height.equalTo(60)
        }
        let topTitleLabel = UILabel(text: "费用明细", color: TBIThemePrimaryTextColor, size: 17)
        topView.addSubview(topTitleLabel)
        topTitleLabel.snp.makeConstraints{(make)->Void in
            make.center.equalToSuperview()
        }
        
        let contentLineView = UIView()
        contentContainerView.addSubview(contentLineView)
        contentLineView.backgroundColor = TBIThemeGrayLineColor
        contentLineView.snp.makeConstraints{(make)->Void in
            make.top.equalTo(topView.snp.bottom)
            make.left.right.equalTo(0)
            make.height.equalTo(1)
        }
        
        let subContentView = UIView()
        contentContainerView.addSubview(subContentView)
        //subContentView.backgroundColor = UIColor.blue
        subContentView.snp.makeConstraints{(make)->Void in
            make.top.equalTo(contentLineView.snp.bottom)
            make.left.right.bottom.equalTo(0)
            
            if showTextArray.count == 3
            {
                make.height.equalTo(175)
            }
            else
            {
                make.height.equalTo(175 + (showTextArray.count - 3)*26)
            }
            
        }
        
        var lastItemContainerView:UIView!
        
        
        for k in 0..<showTextArray.count
        {
            
            let showTextItem = showTextArray[k]
            
            
            let itemContainerView = UIView()
            subContentView.addSubview(itemContainerView)
            
            itemContainerView.snp.makeConstraints{(make)->Void in
                make.left.equalTo(30)
                make.right.equalTo(-30)
                
                if k==0
                {
                    make.top.equalTo(30)
                }
                else
                {
                    make.top
                    .equalTo(lastItemContainerView.snp.bottom).offset(10)
                }
            
            }
            lastItemContainerView = itemContainerView
            
            
            
            let textLabel1 = UILabel(text: showTextItem.0, color: TBIThemePrimaryTextColor, size:  14)
            itemContainerView.addSubview(textLabel1)
            textLabel1.snp.makeConstraints{(make)->Void in
                make.top.equalTo(0)
                make.left.equalTo(0)
                make.bottom.equalTo(0)
            }
            
            if k != (showTextArray.count - 1)
            {
                let textLabel2 = UILabel(text: showTextItem.1, color: TBIThemeTipTextColor, size: 14)
                itemContainerView.addSubview(textLabel2)
                textLabel2.snp.makeConstraints{(make)->Void in
                    make.top.equalTo(0)
                    make.center.equalToSuperview()
                    make.bottom.equalTo(0)
                }
                
            }
            
            let textLabel3 = UILabel(text: showTextItem.2, color: TBIThemeOrangeColor, size: k == (showTextArray.count - 1) ? 20 : 14)
            itemContainerView.addSubview(textLabel3)
            textLabel3.snp.makeConstraints{(make)->Void in
                make.top.equalTo(0)
                make.right.equalTo(0)
                make.bottom.equalTo(0)
            }
            
            
            
        }
        
        
        
        
    }
    
    
}
