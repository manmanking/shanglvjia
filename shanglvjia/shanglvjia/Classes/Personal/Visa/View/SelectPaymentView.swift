//
//  SelectPaymentView.swift
//  shanglvjia
//
//  Created by tbi on 2018/7/18.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class SelectPaymentView: UIView {


    typealias selectPaymentBlock = (Int)->Void
    public var paymentBlock:selectPaymentBlock!
    
    private var baseBackgroundView:UIView = UIView()
    var bgView = UIView()
    var titleLabel = UILabel(text:"支付方式",color:TBIThemePrimaryTextColor,size:16)
     var lineLabel = UILabel()
    var okButton = UIButton()
    var selectPayButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        baseBackgroundView.backgroundColor = TBIThemeBackgroundViewColor
        self.addSubview(baseBackgroundView)
        baseBackgroundView.addSubview(bgView)
        bgView.addSubview(titleLabel)
        bgView.addSubview(lineLabel)
        bgView.addSubview(okButton)
        
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        bgView.layer.cornerRadius=4.0
        bgView.clipsToBounds=true
        bgView.backgroundColor=TBIThemeWhite
        bgView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.equalTo(40)
            make.right.equalTo(-40)
            make.height.equalTo(300)
        }
        
        titleLabel.textAlignment=NSTextAlignment.center
        titleLabel.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(45)
        }
        lineLabel.backgroundColor=TBIThemeBaseColor
        lineLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        okButton.setBackgroundImage(UIImage (named: "yellow_btn_gradient"), for: UIControlState.normal)
        okButton.titleLabel?.font=UIFont.systemFont(ofSize: 18)
        okButton.layer.cornerRadius=4.0
        okButton.clipsToBounds=true
        okButton.addTarget(self, action: #selector(okButtonClick), for: UIControlEvents.touchUpInside)
        okButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(22)
            make.right.equalToSuperview().offset(-22)
            make.bottom.equalToSuperview().offset(-15)
            make.height.equalTo(46)
        }
        
        let parArray = [["imgName":"ic_weixin","title":"微信支付"],["imgName":"ic_zhifubao","title":"支付宝"]]
        for i in 0...parArray.count-1 {
            creatPayView(name: parArray[i]["imgName"]!, title: parArray[i]["title"]!, topOrigin:CGFloat(56 + 60*i),tagIndex:i)
        }
    }
    func creatPayView(name:String,title:String,topOrigin:CGFloat,tagIndex:Int){
        let payBgView:UIButton = UIButton()
        let nameImage:UIImageView = UIImageView()
        let titleLabel:UILabel = UILabel.init(text: title, color: PersonalThemeMajorTextColor, size: 16)
        bgView.addSubview(payBgView)
        payBgView.addSubview(nameImage)
        payBgView.addSubview(titleLabel)
        
        payBgView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(topOrigin)
            make.height.equalTo(60)
        }

        payBgView.tag = tagIndex
        payBgView.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        payBgView.setImage(UIImage(named:"visa_pay_noselect"), for: UIControlState.normal)
        payBgView.setImage(UIImage(named:"visa_pay_select"), for: UIControlState.selected)
        payBgView.addTarget(self, action: #selector(selectPayment(sender:)), for: UIControlEvents.touchUpInside)
        
        nameImage.image = UIImage(named:name)
        nameImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(0)
            make.width.height.equalTo(24)
        }
        titleLabel.numberOfLines = 2
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameImage.snp.right).offset(15)
            make.centerY.equalToSuperview()
        }
        ///更多支付方式
        if (titleLabel.text?.hasPrefix("支"))!
        {
            let moreBtn = UIButton.init(title: "更多支付方式", titleColor: TBIThemePlaceholderColor, titleSize: 13)
            let buttonLine:UILabel = UILabel()
            payBgView.addSubview(moreBtn)
            moreBtn.addSubview(buttonLine)
            
            moreBtn.backgroundColor = TBIThemeWhite
            moreBtn.snp.makeConstraints({ (make) in
                make.top.bottom.left.right.equalToSuperview()
            })
            moreBtn.addTarget(self, action: #selector(moreBtnClick(sender:)), for: UIControlEvents.touchUpInside)
            buttonLine.backgroundColor = TBIThemeGrayLineColor
            buttonLine.snp.makeConstraints({ (make) in
                make.left.right.equalToSuperview()
                make.height.equalTo(1)
                make.top.equalToSuperview().offset(10)
            })
        }
        
        ///微信支付 富文本
        if (titleLabel.text?.hasPrefix("微"))!
        {
//            let attrs = NSMutableAttributedString(string:titleLabel.text!)
//            attrs.addAttributes([NSForegroundColorAttributeName :PersonalThemeMinorTextColor, NSFontAttributeName : UIFont.systemFont( ofSize: 11.0)],range: NSMakeRange(5,4))
//            titleLabel.attributedText = attrs
            let tuijianImage:UIImageView = UIImageView.init(imageName: "ic_order_wechatpay_recommend")
            payBgView.addSubview(tuijianImage)
            tuijianImage.snp.makeConstraints({ (make) in
                make.left.equalTo(titleLabel.snp.right).offset(3)
                make.centerY.equalTo(titleLabel)
                make.width.equalTo(54)
                make.height.equalTo(18)
            })
            
            /// 默认勾选微信支付
            payBgView.isSelected = true
            selectPayButton = payBgView
            
        }
        
       
    }
    ///更多支付方式 显示支付宝
    func moreBtnClick(sender:UIButton) {
        sender.removeFromSuperview()
    }
    ///确认支付
    func okButtonClick()  {
        ///选择微信支付
        if selectPayButton.tag == 0{
            if WXApi.isWXAppInstalled(){
                if paymentBlock != nil {
                    paymentBlock(selectPayButton.tag)
                }
                self.removeFromSuperview()
            }else{
                popPersonalNewAlertView(content: "您还没有安装微信客户端，请选择其他支付方式", titleStr: "提示", btnTitle: "确定")
            }
        }else{
            if paymentBlock != nil {
                paymentBlock(selectPayButton.tag)
            }
            self.removeFromSuperview()
        }
        
    }
    ///数据
    func setView(money:String){
        okButton.setTitle("确认支付 ¥ \(money)", for: UIControlState.normal)
    }
    ///选择支付方式
    func selectPayment(sender:UIButton){
        if selectPayButton == sender {
             selectPayButton.isSelected = true
        }else{
            selectPayButton.isSelected = false
            sender.isSelected = true
            selectPayButton = sender;
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.removeFromSuperview()
        paymentBlock(99)
    }
}
