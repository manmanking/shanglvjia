//
//  CoApprovalSuccessView.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/6/8.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class CoApprovalSuccessView: UIView
{
    static let BACKHOMEPAGE_BTN = "BACKHOMEPAGE_BTN"
    static let MYORDERPAGE_BTN = "MYORDERPAGE_BTN"
    
    let successTextLabel = UILabel(text: "送审成功", color: TBIThemePrimaryTextColor, size: 17)
    let topSubTipContentLabel = UILabel(text: "请随时关注您的审批进度", color: TBIThemeTipTextColor, size: 13)
    let myOrderPageBtn = UIButton(title: "我的订单", titleColor: TBIThemePrimaryTextColor, titleSize: 20)
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
        
        topContentView.addSubview(successTextLabel)
        successTextLabel.snp.makeConstraints{(make)->Void in
            make.top.equalTo(successImageView.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }
        
        topContentView.addSubview(topSubTipContentLabel)
        topSubTipContentLabel.snp.makeConstraints{(make)->Void in
            make.top.equalTo(successTextLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-40)
        }
        
        
        //设置地下的两个btn
        
        let backHomePageBtn = UIButton(title: "返回首页", titleColor: UIColor.white, titleSize: 20)
        backHomePageBtn.setBackgroundImage(UIImage (named: "yellow_btn_gradient"), for: UIControlState.normal)
        backHomePageBtn.layer.cornerRadius = 4
        backHomePageBtn.clipsToBounds=true
        self.addSubview(backHomePageBtn)
        backHomePageBtn.snp.makeConstraints{(make)->Void in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(topContentView.snp.bottom).offset(30)
            make.height.equalTo(47)
        }
        
        myOrderPageBtn.backgroundColor = UIColor.white
        myOrderPageBtn.layer.borderWidth = 1
        myOrderPageBtn.layer.borderColor = TBIThemeGrayLineColor.cgColor
        myOrderPageBtn.layer.cornerRadius = 4
        self.addSubview(myOrderPageBtn)
        myOrderPageBtn.snp.makeConstraints{(make)->Void in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(backHomePageBtn.snp.bottom).offset(15)
            make.height.equalTo(47)
        }
        
        backHomePageBtn.addOnClickListener(target: self, action: #selector(backHomePageClk(clkView:)))
        myOrderPageBtn.addOnClickListener(target: self, action: #selector(myOrderPageClk(clkView:)))
        
    }
   
    //返回首页
    func backHomePageClk(clkView:UIView) -> Void
    {
        if myDelegate != nil
        {
            myDelegate.onMyClick(clkView: clkView, flagStr: CoApprovalSuccessView.BACKHOMEPAGE_BTN)
        }
    }
    
    //我的订单
    func myOrderPageClk(clkView:UIView) -> Void
    {
        if myDelegate != nil
        {
            myDelegate.onMyClick(clkView: clkView, flagStr: CoApprovalSuccessView.MYORDERPAGE_BTN)
        }
    }
    
    
    
    
    
}




