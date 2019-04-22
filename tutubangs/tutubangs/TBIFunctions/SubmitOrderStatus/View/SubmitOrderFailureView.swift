//
//  SubmitOrderFailureView.swift
//  shanglvjia
//
//  Created by manman on 2018/5/29.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class SubmitOrderFailureView: UIView {

    typealias SubmitOrderFailureViewGoHomeBlock = (String)->Void
    
    public var submitOrderFailureViewGoHomeBlock:SubmitOrderFailureViewGoHomeBlock!
    
    
    static let BACKHOMEPAGE_BTN = "BACKHOMEPAGE_BTN"
    static let MYORDERPAGE_BTN = "MYORDERPAGE_BTN"
    
    private let flagImageView:UIImageView = UIImageView()
    
    private let successTextLabel = UILabel(text: "提交失败", color: TBIThemePrimaryTextColor, size: 18)
    private let topSubTipContentLabel = UILabel(text: "请重新下单", color: TBIThemeTipTextColor, size: 15)
    
    private let backHomePageBtn = UIButton(title: "返回首页", titleColor: UIColor.white, titleSize: 20)
    private let lookOrderBtn = UIButton(title: "查看订单", titleColor: UIColor.white, titleSize: 20)
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        setUIViewAutolayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUIViewAutolayout() -> Void
    {
        self.backgroundColor = TBIThemeBaseColor
        
        let topContentView = UIView()
        topContentView.backgroundColor = UIColor.white
        self.addSubview(topContentView)
        topContentView.snp.makeConstraints{(make)->Void in
            make.left.right.bottom.top.equalTo(0)
            
        }
        
        topContentView.addSubview(flagImageView)
        flagImageView.snp.makeConstraints{(make)->Void in
            //make.top.left.right.equalToSuperview()
            //make.height.equalTo(300)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(100)
            make.top.equalTo(130+kNavigationHeight)
        }
 
        topContentView.addSubview(successTextLabel)
        successTextLabel.snp.makeConstraints{(make)->Void in
            make.centerX.equalToSuperview()
            make.top.equalTo(flagImageView.snp.bottom).offset(40)
        }
        
        topSubTipContentLabel.textAlignment = .center
        topSubTipContentLabel.numberOfLines = 2
        topContentView.addSubview(topSubTipContentLabel)
        topSubTipContentLabel.snp.makeConstraints{(make)->Void in
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(successTextLabel.snp.bottom).offset(15)
        }
        
        
        
        //设置地下的两个btn
        
       
        backHomePageBtn.layer.borderColor=TBIThemeDarkBlueColor.cgColor
        backHomePageBtn.setTitleColor(TBIThemeDarkBlueColor, for: UIControlState.normal)
        backHomePageBtn.layer.borderWidth=1.0
        backHomePageBtn.layer.cornerRadius = 4
        topContentView.addSubview(backHomePageBtn)
        backHomePageBtn.snp.makeConstraints{(make)->Void in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalToSuperview().offset(-100)
            make.height.equalTo(47)
        }
        
        lookOrderBtn.clipsToBounds=true
        lookOrderBtn.layer.cornerRadius = 4
        topContentView.addSubview(lookOrderBtn)
        lookOrderBtn.snp.makeConstraints{(make)->Void in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(backHomePageBtn.snp.top).offset(-20)
            make.height.equalTo(47)
        }
        
        backHomePageBtn.addOnClickListener(target: self, action: #selector(goHomeAction(sender:)))
        
    }
    
    
    /// 更改视图文案
    func fillDataSources(orderStatus:SubmitOrderFailureViewController.SubmitOrderStatus) {
        
        switch orderStatus {
        case .Success_Payment:
            visaSuccessPayment()
        case .Failure_Payment():
            visaFailurePayment()
        case .Success_SecondSubmit:
            visaSecondSubmitSuccess()
        case .Failure_SecondSubmit:
            visaSecondSubmitFailure()
        case .Success_Submit_Order:
            orderDataSuccess()
        case .Failure_Submit_Order:
            orderDataFailure()
            
        case .Personal_Success_Payment:
            personalSuccessPayment()
        case .Personal_Failure_Payment():
            personalFailurePayment()
        case .Personal_Success_SecondSubmit:
            personalSecondSubmitSuccess()
        case .Personal_Failure_SecondSubmit:
            personalSecondSubmitFailure()
        case .Personal_Success_Submit_Order:
            personalOrderDataSuccess()
        case .Personal_Failure_Submit_Order:
            personalSecondSubmitFailure()
        case .Personal_Failure_Submit_Order_lowStocks:
            personalLowStocksFailure()
        case .Personal_Success_nopay:
            personalNopaySuccess()
        case .Personal_Success_Change:
            personalChangeSuccess()
        case .Personal_Failure_Change:
            personalChangeFailure()
            
        default:
            return
        }
        
    }
    
    func orderDataSuccess(){
      successUI()
      successTextLabel.text = "订单提交成功"
      topSubTipContentLabel.text = "请尽快完成送审，以免影响您的出行安排"
        
    }
    func orderDataFailure() {
        failureUI()
        successTextLabel.text = "提交失败"
        topSubTipContentLabel.text = "请重新下单"
    }
    func visaSuccessPayment() {
        successUI()
        successTextLabel.text = "恭喜您，您的订单已支付成功"
        topSubTipContentLabel.text = "请按要求寄送材料，谢谢您的配合"
    }
    func visaFailurePayment() {
        failureUI()
        successTextLabel.text = "订单支付失败"
        topSubTipContentLabel.text = "此团期已售罄，请重新选择"
    }
    func visaSecondSubmitSuccess(){
        successUI()
       successTextLabel.text = "恭喜您，您的订单已提交成功"
       topSubTipContentLabel.text = "请按要求寄送材料，谢谢您的配合"
    }
    func visaSecondSubmitFailure(){
        failureUI()
       successTextLabel.text = "订单提交失败"
       topSubTipContentLabel.text = "此团期已售罄，请重新选择"
    }
    func personalSuccessPayment() {
        successUI()
        successTextLabel.text = "订单支付成功"
        topSubTipContentLabel.text = "感谢您选择途途帮，客服会尽快为您预定 "
    }
    func personalFailurePayment() {
        failureUI()
        successTextLabel.text = "订单支付失败"
        topSubTipContentLabel.text = "支付失败"
    }
    func personalSecondSubmitSuccess(){
        successUI()
        successTextLabel.text = "订单提交成功"
        topSubTipContentLabel.text = "客服会尽快为您处理，请您及时关注"
    }
    func personalSecondSubmitFailure(){
        failureUI()
        successTextLabel.text = "订单创建失败"
        topSubTipContentLabel.text = "很遗憾，您的订单提交失败"
    }
    func personalOrderDataSuccess(){
        successUI()
        successTextLabel.text = "订单提交成功"
        topSubTipContentLabel.text = "恭喜您，您的订单提交成功"
        
    }
    func personalLowStocksFailure(){
        failureUI()
        successTextLabel.text = "订单创建失败"
        topSubTipContentLabel.text = "很遗憾，您的订单提交失败"
    }
    func personalNopaySuccess(){
        successUI()
        successTextLabel.text = "订单提交成功"
        topSubTipContentLabel.text = "当前资源紧张，请您在20分钟内尽快支付"
    }
    func personalChangeSuccess(){
        successUI()
        successTextLabel.text = "改签订单提交成功"
        topSubTipContentLabel.text = "感谢您选择途途帮，客服会尽快为您预定"
    }
    func personalChangeFailure(){
        failureUI()
        successTextLabel.text = "改签订单提交失败"
        topSubTipContentLabel.text = "改签订单提交失败"
    }
    ///成功失败UI
    func successUI() {
        flagImageView.image = UIImage.init(named: "ic_success")
        successTextLabel.textColor=TBIThemeDarkBlueColor
        backHomePageBtn.layer.borderColor=TBIThemeDarkBlueColor.cgColor
        backHomePageBtn.setTitleColor(TBIThemeDarkBlueColor, for: UIControlState.normal)
        lookOrderBtn.setBackgroundImage(UIImage (named: "yellow_btn_gradient"), for: UIControlState.normal)
        
        lookOrderBtn.addOnClickListener(target: self, action: #selector(lookOrderBtnAction(sender:)))
    }
    func failureUI() {
        flagImageView.image = UIImage.init(named: "ic_failure")
        successTextLabel.textColor=TBIThemeRedColor
        backHomePageBtn.layer.borderColor=TBIThemeRedColor.cgColor
        backHomePageBtn.setTitleColor(TBIThemeRedColor, for: UIControlState.normal)
        lookOrderBtn.setBackgroundImage(UIImage (named: "red_btn_gradient"), for: UIControlState.normal)
        lookOrderBtn.setTitle("重新预订", for: UIControlState.normal)
        lookOrderBtn.addOnClickListener(target: self, action: #selector(reorderBtnAction(sender:)))
    }
    
    
    //返回首页
    func goHomeAction(sender:UIButton)
    {
        if submitOrderFailureViewGoHomeBlock != nil
        {
            submitOrderFailureViewGoHomeBlock("home")
        }
    }
    func lookOrderBtnAction(sender:UIButton)
    {
        if submitOrderFailureViewGoHomeBlock != nil
        {
            submitOrderFailureViewGoHomeBlock("order")
        }
    }
    func reorderBtnAction(sender:UIButton)
    {
        if submitOrderFailureViewGoHomeBlock != nil
        {
            submitOrderFailureViewGoHomeBlock("reorder")
        }
    }
    
}
