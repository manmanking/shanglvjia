//
//  TBIAlertViewKeyValue.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/7/17.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

//弹出框-左侧为key，右侧为value的样式

class TBIAlertViewKeyValue: UIView
{

    fileprivate var clickDelegate:((_ clickAction:ClickActionEnum)->Void)! = nil
    
    private var baseBackgroundView:UIView = UIView()
    private var contentContainerView:UIView = UIView()

    var titleStr:String = ""
    var bottomBtnTitleStr = ""
    var contentDataSource:[(String,String)] = []
    
    init(frame: CGRect,titleStr:String,bottomBtnTitleStr:String,contentDataSource:[(String,String)])
    {
        super.init(frame: frame)
        
        self.titleStr = titleStr
        self.bottomBtnTitleStr = bottomBtnTitleStr
        self.contentDataSource = contentDataSource
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() -> Void
    {
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
        
        let topView = UIView()
        contentContainerView.addSubview(topView)
        topView.snp.makeConstraints{(make)->Void in
            make.left.right.top.equalTo(0)
            make.height.equalTo(60)
        }
        let topTitleLabel = UILabel(text: titleStr, color: TBIThemePrimaryTextColor, size: 17)
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
            
//            if showTextArray.count == 3
//            {
//                make.height.equalTo(175)
//            }
//            else
//            {
//                make.height.equalTo(175 + (showTextArray.count - 3)*26)
//            }
            
        }
        
        var lastItemContainerView:UIView!
        for k in 0..<contentDataSource.count
        {
            
            let showTextItem = contentDataSource[k]
            
            
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
                        .equalTo(lastItemContainerView.snp.bottom).offset(15)
                }
                
            }
            lastItemContainerView = itemContainerView
            
            let textLabel1 = UILabel(text: showTextItem.0, color: TBIThemeTipTextColor, size:  15)
            itemContainerView.addSubview(textLabel1)
            textLabel1.snp.makeConstraints{(make)->Void in
                make.top.equalTo(0)
                make.left.equalTo(0)
                make.bottom.equalTo(0)
            }
            
            let textLabel2 = UILabel(text: showTextItem.1, color: TBIThemePrimaryTextColor, size: 15)
            textLabel2.numberOfLines = 3
            textLabel2.textAlignment = .right
            itemContainerView.addSubview(textLabel2)
            textLabel2.snp.makeConstraints{(make)->Void in
                make.top.equalTo(0)
                //make.width.equalTo(180*adaptationRatio)
                make.right.equalTo(0)
                make.left.equalTo(textLabel1.snp.right)
                make.bottom.equalTo(0)
            }
        }
        
        let bottomBtn = UIButton(title: bottomBtnTitleStr, titleColor: .white, titleSize: 16)
        bottomBtn.backgroundColor = TBIThemeBlueColor
        bottomBtn.layer.cornerRadius = 3
        bottomBtn.addOnClickListener(target: self, action: #selector(bottomButtonAction))
        subContentView.addSubview(bottomBtn)
        bottomBtn.snp.makeConstraints{(make)->Void in
            make.top.equalTo(lastItemContainerView.snp.bottom).offset(30)
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.height.equalTo(40)
            
            //make.bottom.equalTo(-50)
        }
        
        if titleStr == "专车行程" {
            let messageLabel = UILabel(text: "如需取消或变更,请至少提前两小时联系客服人员", color: TBIThemePrimaryWarningColor, size: 13)
            messageLabel.textAlignment = .left
            messageLabel.numberOfLines = 2
            subContentView.addSubview(messageLabel)
            messageLabel.snp.makeConstraints({ (make) in
                //make.bottom.equalTo(-20)
                make.top.equalTo(bottomBtn.snp.bottom).offset(20)
                make.centerX.equalToSuperview()
                make.left.right.equalToSuperview().inset(30)
                make.bottom.equalTo(-30)
            })
        }else if titleStr == "机票行程" {
            let messageLabel = UILabel(text: "如需改签或退票，请及时联系客服人员", color: TBIThemePrimaryWarningColor, size: 13)
            messageLabel.textAlignment = .left
            messageLabel.numberOfLines = 2
            subContentView.addSubview(messageLabel)
            messageLabel.snp.makeConstraints({ (make) in
                //make.bottom.equalTo(-20)
                make.top.equalTo(bottomBtn.snp.bottom).offset(20)
                make.centerX.equalToSuperview()
                make.left.right.equalToSuperview().inset(30)
                make.bottom.equalTo(-30)
            })
        }else if titleStr == "酒店行程" {
            let messageLabel = UILabel(text: "如需取消或变更，请联系客服人员", color: TBIThemePrimaryWarningColor, size: 13)
            subContentView.addSubview(messageLabel)
            messageLabel.textAlignment = .left
            messageLabel.numberOfLines = 2
            messageLabel.snp.makeConstraints({ (make) in
                //make.bottom.equalTo(-20)
                make.top.equalTo(bottomBtn.snp.bottom).offset(20)
                make.centerX.equalToSuperview()
                make.left.right.equalToSuperview().inset(30)
                make.bottom.equalTo(-30)
            })
        }else if titleStr == "火车票行程" {
            let messageLabel = UILabel(text: "火车票不支持改签，如需退票，请至少提前1小时联系客服人员", color: TBIThemePrimaryWarningColor, size: 13)
            messageLabel.textAlignment = .left
            messageLabel.numberOfLines = 2
            subContentView.addSubview(messageLabel)
            messageLabel.snp.makeConstraints({ (make) in
                //make.bottom.equalTo(-20)
                make.top.equalTo(bottomBtn.snp.bottom).offset(20)
                make.centerX.equalToSuperview()
                make.left.right.equalToSuperview().inset(30)
                make.bottom.equalTo(-30)
            })
        }
        
        
    }
    
    //取消
    func cancelButtonAction()
    {
        self.removeFromSuperview()
        
        //取消
        if clickDelegate != nil
        {
            clickDelegate(.cancel)
        }
    }
    
    //点击了底部按钮
    func bottomButtonAction()
    {
        self.removeFromSuperview()
        
        if clickDelegate != nil
        {
            clickDelegate(.btnClick)
        }
    }
    
    
    enum ClickActionEnum
    {
        case cancel
        case btnClick
    }

}

extension TBIAlertViewKeyValue
{
    static func  getNewInstance(topTitle:String,bottomBtnTitle:String,contentDataSource:[(String,String)],clickBlock:((_ clickAction:ClickActionEnum)->Void)!) -> TBIAlertViewKeyValue
    {
        let instance = TBIAlertViewKeyValue(frame: ScreenWindowFrame, titleStr: topTitle, bottomBtnTitleStr: bottomBtnTitle, contentDataSource: contentDataSource)
        instance.clickDelegate = clickBlock
        
        return instance
    }
    
}






