//
//  PShowOrderStatusView.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/6/29.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class PShowOrderStatusView: UIView
{
    static let GOONRESERVEPAGE_BTN = "GOONRESERVEPAGE_BTN"   //继续预订
    static let LOOKORDERPAGE_BTN = "LOOKORDERPAGE_BTN"       //查看订单
    
    let topOrderStatusTextLabel = UILabel(text: "待订妥", color: TBIThemePrimaryTextColor, size: 17)
    let topSubTipContentLabel = UILabel(text: "您已下单下单成功，请等待专属服务人员为您确认房间", color: TBIThemeTipTextColor, size: 13)
    
    let goonReservePageBtn = UIButton(title: "继续预订", titleColor: UIColor.white, titleSize: 20)
    let lookOrderPageBtn = UIButton(title: "查看订单", titleColor: TBIThemePrimaryTextColor, titleSize: 20)
    
    var myDelegate:OnMyClickListener!
    
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initView() -> Void
    {
        self.backgroundColor = TBIThemeBaseColor
        
        let topContentView = UIView()
        topContentView.backgroundColor = UIColor.white
        self.addSubview(topContentView)
        topContentView.snp.makeConstraints{(make)->Void in
            make.left.right.top.equalTo(0)
        }
        
        let successImageView = UIImageView(imageName: "ic_success")
        topContentView.addSubview(successImageView)
        successImageView.snp.makeConstraints{(make)->Void in
            make.width.height.equalTo(60)
            make.top.equalTo(30)
            make.centerX.equalToSuperview()
        }
        
        topContentView.addSubview(topOrderStatusTextLabel)
        topOrderStatusTextLabel.snp.makeConstraints{(make)->Void in
            make.top.equalTo(successImageView.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }
        
        topContentView.addSubview(topSubTipContentLabel)
        topSubTipContentLabel.snp.makeConstraints{(make)->Void in
            make.top.equalTo(topOrderStatusTextLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-40)
        }
        
        
        //设置底下的两个btn
        
        goonReservePageBtn.backgroundColor = TBIThemeBlueColor
        goonReservePageBtn.layer.cornerRadius = 3
        self.addSubview(goonReservePageBtn)
        goonReservePageBtn.snp.makeConstraints{(make)->Void in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(topContentView.snp.bottom).offset(30)
            make.height.equalTo(47)
        }
        
        lookOrderPageBtn.backgroundColor = UIColor.white
        lookOrderPageBtn.layer.borderWidth = 1
        lookOrderPageBtn.layer.borderColor = TBIThemeGrayLineColor.cgColor
        lookOrderPageBtn.layer.cornerRadius = 3
        self.addSubview(lookOrderPageBtn)
        lookOrderPageBtn.snp.makeConstraints{(make)->Void in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(goonReservePageBtn.snp.bottom).offset(15)
            make.height.equalTo(47)
        }
        
        goonReservePageBtn.addOnClickListener(target: self, action: #selector(goonReservePageClk(clkView:)))
        lookOrderPageBtn.addOnClickListener(target: self, action: #selector(lookOrderPageClk(clkView:)))
        
    }
    
    //继续预订
    func goonReservePageClk(clkView:UIView) -> Void
    {
        if myDelegate != nil
        {
            myDelegate.onMyClick(clkView: clkView, flagStr: PShowOrderStatusView.GOONRESERVEPAGE_BTN)
        }
    }
    
    //查看订单
    func lookOrderPageClk(clkView:UIView) -> Void
    {
        if myDelegate != nil
        {
            myDelegate.onMyClick(clkView: clkView, flagStr: PShowOrderStatusView.LOOKORDERPAGE_BTN)
        }
    }
    

}
