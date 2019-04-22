//
//  TBIPaymentView.swift
//  shop
//
//  Created by manman on 2017/7/10.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

enum PaymentState {
    case Success
    case Failure
    
}

class TBIPaymentView: UIView {

    typealias TBIPaymentViewBlock = (String)->Void
   
    public var paymentViewBlock:TBIPaymentViewBlock!
    private var baseBackgroundView:UIView = UIView()
    private var subBaseBackgroundView:UIView = UIView()
    private var subTipInfoBackgroundView:UIView = UIView()
    private var tipImageView:UIImageView = UIImageView()
    private var tipTitleLabel:UILabel = UILabel()
    private var firstButton:UIButton = UIButton()
    private var secondButton:UIButton = UIButton()
    public var paymentState:PaymentState = PaymentState.Success
    {
        didSet
        {
            switch paymentState {
            case .Success:
                tipImageView.image = UIImage.init(named: "ic_pay_success")
                tipTitleLabel.text = "支付成功"
                break
            case .Failure:
                tipImageView.image = UIImage.init(named: "ic_pay_failure")
                tipTitleLabel.text = "支付失败"
                break
            default:
                break
            }
            
            
        }
        
        
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(baseBackgroundView)
        baseBackgroundView.backgroundColor = UIColor.clear
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        subBaseBackgroundView.backgroundColor = UIColor.gray
        subBaseBackgroundView.alpha = 0.4
        baseBackgroundView.addSubview(subBaseBackgroundView)
        subBaseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        subTipInfoBackgroundView.backgroundColor = UIColor.white
        subTipInfoBackgroundView.layer.cornerRadius = 7
        baseBackgroundView.addSubview(subTipInfoBackgroundView)
        subTipInfoBackgroundView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(250)
            make.top.equalToSuperview().inset(170)
            make.height.equalTo(300)
        }
        setUIViewAutolayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUIViewAutolayout()
    {
        tipImageView.image = UIImage.init(named: "ic_pay_success")
        subTipInfoBackgroundView.addSubview(tipImageView)
        tipImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(36)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
        }
        
        tipTitleLabel.text = "支付成功"
        tipTitleLabel.font = UIFont.systemFont( ofSize: 16)
        tipTitleLabel.textColor = TBIThemeOrangeColor
        subTipInfoBackgroundView.addSubview(tipTitleLabel)
        tipTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(tipImageView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(16)
        }
        
        firstButton.setTitle("查看订单", for: UIControlState.normal)
        firstButton.backgroundColor = TBIThemeBlueColor
        firstButton.layer.cornerRadius = 4
        firstButton.addTarget(self, action: #selector(firstButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        subTipInfoBackgroundView.addSubview(firstButton)
        firstButton.snp.makeConstraints { (make) in
            make.top.equalTo(tipTitleLabel.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(35)
        }
        
        secondButton.setTitle("返回首页", for: UIControlState.normal)
        secondButton.backgroundColor = TBIThemeBlueColor
        secondButton.layer.cornerRadius = 4
        secondButton.addTarget(self, action: #selector(secondButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        subTipInfoBackgroundView.addSubview(secondButton)
        secondButton.snp.makeConstraints { (make) in
            make.top.equalTo(firstButton.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(35)
        }
    }
    
    
    
    
    
    
    func cancleAction() {
        
        self.removeFromSuperview()
        
    }
    
    
    func firstButtonAction(sender:UIButton) {
        
        print("firstButtonAction ...")
        paymentViewBlock("order")
        cancleAction()
        
    }
    
    
    func secondButtonAction(sender:UIButton) {
        print("secondButtonAction ...")
        
        paymentViewBlock("first")
        cancleAction()
    }
    
    
    
    
}
