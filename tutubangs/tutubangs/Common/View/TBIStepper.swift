//
//  TBIStepper.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/7/6.
//  Copyright © 2017年 TBI. All rights reserved.
//

//TBIStepper:     -[显示数字]+

import UIKit

class TBIStepper: UIView
{
    
    var currentValue:Int = 0
    {
        didSet
        {
            self.setButtonIsEnableView()
        }
    }
    
    let leftMinusBtn:UIButton = UIButton(title: "-", titleColor: TBIThemePlaceholderTextColor, titleSize: 16)
    let middleShowNumLabel = UILabel(text: "0", color: TBIThemePrimaryTextColor, size: 14)
    let rightAddBtn:UIButton = UIButton(title: "+", titleColor: TBIThemePlaceholderTextColor, titleSize: 16)
    
    var minNum:Int = 0
    var maxNum:Int = Int.max
    //步长
    var stepNum:Int = 1
    
    var onMyDelegate:OnTBIStepperValueChangedListener! = nil
    
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        //self.bounds.size = CGSize(width: 73, height: 20)
        
        initView()
    }
    
    init(stepNum:Int,currentValue:Int,minNum:Int,maxNum:Int = Int.max,frame:CGRect = CGRect(x: 0, y: 0, width: 0, height: 0))
    {
        super.init(frame: frame)
        
        self.stepNum = stepNum
        self.minNum = minNum
        self.maxNum = maxNum
        
        self.currentValue = currentValue
        if currentValue < minNum
        {
            self.currentValue = minNum
        }
        else if currentValue > maxNum
        {
            self.currentValue = maxNum
        }
        
        
        initView()
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initView() -> Void
    {
        
        layoutInitView()
        leftMinusBtn.setEnlargeEdgeWithTop(20 ,left: 20, bottom: 20, right: 20)
        rightAddBtn.setEnlargeEdgeWithTop(20 ,left: 20, bottom: 20, right: 20)
        self.setButtonIsEnableView()
        self.setOnClickListener()
    }
    
    
    
    //设置左右的按钮🔘是否可用
    func setButtonIsEnableView() -> Void
    {
        middleShowNumLabel.text = "\(currentValue)"
        
        if currentValue <= minNum  //不能再减小
        {
            leftMinusBtn.isEnabled = false
            leftMinusBtn.setTitleColor(TBIThemePlaceholderTextColor, for: .normal)
        }
        else   //可以减小
        {
            leftMinusBtn.isEnabled = true
            leftMinusBtn.setTitleColor(TBIThemePrimaryTextColor, for: .normal)
        }
        
        if currentValue >= maxNum  //不能再增大
        {
            rightAddBtn.isEnabled = false
            rightAddBtn.setTitleColor(TBIThemePlaceholderTextColor, for: .normal)
        }
        else   //可以增大
        {
            rightAddBtn.isEnabled = true
            rightAddBtn.setTitleColor(TBIThemePrimaryTextColor, for: .normal)
        }
    }
    
    func layoutInitView() -> Void
    {
        //self.backgroundColor = .red
        
        self.layer.cornerRadius = 2
        self.clipsToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = TBIThemeGrayLineColor.cgColor
        
        //左侧
        self.addSubview(leftMinusBtn)
        leftMinusBtn.snp.makeConstraints{(make)->Void in
            make.left.top.bottom.equalTo(0)
            make.width.equalTo(25)
        }
        
        let leftMiddleSegLine = UIView()
        leftMiddleSegLine.backgroundColor = TBIThemeGrayLineColor
        self.addSubview(leftMiddleSegLine)
        leftMiddleSegLine.snp.makeConstraints{(make)->Void in
            make.left.equalTo(leftMinusBtn.snp.right)
            make.top.bottom.equalTo(0)
            make.width.equalTo(1)
        }
        
        //右侧
        self.addSubview(rightAddBtn)
        rightAddBtn.snp.makeConstraints{(make)->Void in
            make.right.top.bottom.equalTo(0)
            make.width.equalTo(25)
        }
        
        let rightMiddleSegLine = UIView()
        rightMiddleSegLine.backgroundColor = TBIThemeGrayLineColor
        self.addSubview(rightMiddleSegLine)
        rightMiddleSegLine.snp.makeConstraints{(make)->Void in
            make.right.equalTo(rightAddBtn.snp.left)
            make.top.bottom.equalTo(0)
            make.width.equalTo(1)
        }
        
        //中间的显示数字🔢Label
        self.addSubview(middleShowNumLabel)
        middleShowNumLabel.textAlignment = .center
        middleShowNumLabel.snp.makeConstraints{(make)->Void in
            make.top.bottom.equalTo(0)
            make.left.equalTo(leftMiddleSegLine.snp.right)
            make.right.equalTo(rightMiddleSegLine.snp.left)
        }
        
    }
    
    //设置监听事件
    func setOnClickListener() -> Void
    {
        leftMinusBtn.addOnClickListener(target: self, action: #selector(minusValue))
        rightAddBtn.addOnClickListener(target: self, action: #selector(addValue))
    }
    
    func minusValue() -> Void
    {
        if currentValue > minNum
        {
            currentValue -= 1
            
            if onMyDelegate != nil
            {
                onMyDelegate.valueChanged(stepper: self, value: currentValue)
            }
        }
    }
    
    func addValue() -> Void
    {
        if currentValue < maxNum
        {
            currentValue += 1
            
            if onMyDelegate != nil
            {
                onMyDelegate.valueChanged(stepper: self, value: currentValue)
            }
        }
    }
    
    

}

protocol OnTBIStepperValueChangedListener
{
    func valueChanged(stepper:TBIStepper,value:Int) -> Void
}




