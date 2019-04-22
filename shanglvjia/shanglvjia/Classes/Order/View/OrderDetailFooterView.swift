//
//  OrderDetailFooterView.swift
//  shanglvjia
//
//  Created by tbi on 2018/5/10.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class OrderDetailFooterView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    //价钱
    let priceCountLabel = UILabel(text: "", color: TBIThemeRedColor, size: 20)
    //箭头button
    let priceButton = UIButton()
    
    lazy var leftView:UIView = {
        let vi = UIView()
        vi.backgroundColor = TBIThemeWhite
        let line = UILabel(color: TBIThemeGrayLineColor)
        let titleLabel = UILabel(text: "总价", color: TBIThemePrimaryTextColor, size: 13)
        let yLabel = UILabel(text: "¥ ", color: TBIThemeRedColor, size: 13)
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
//            make.left.equalTo(yLabel.snp.right)
            make.right.equalTo(-44)
            make.centerY.equalToSuperview()
        }
        yLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.priceCountLabel.snp.bottom).offset(-3)
            //            make.left.equalTo(titleLabel.snp.right).offset(10)
            make.right.equalTo(self.priceCountLabel.snp.left)
        }
        return vi
    }()
    
    let submitButton:UIButton = UIButton(title: "",titleColor: TBIThemeWhite,titleSize: 16)
    let leftButton : UIButton = UIButton(title: "",titleColor: TBIThemeWhite,titleSize: 16)
    let rightButton : UIButton = UIButton(title: "",titleColor: TBIThemeWhite,titleSize: 16)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        initView()
    }
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViewWithStr(orderTy:String){
        self.isUserInteractionEnabled=true
        print("orderTy \(orderTy)")
        addSubview(leftView)
        addSubview(submitButton)
        addSubview(leftButton)
        addSubview(rightButton)
        addSubview(priceButton)
        priceButton.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        priceButton.titleLabel?.font=UIFont.systemFont(ofSize: 14)
        priceButton.setImage(UIImage(named: "ic_up_gray"), for: UIControlState.normal)
        priceButton.setImage(UIImage(named: "ic_down_gray"), for: UIControlState.selected)
  
        if orderTy != "4"
        {
            priceButton.setEnlargeEdgeWithTop(20 ,left: 400, bottom: 20, right: 0)
        }
        
        leftView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.height.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(ScreenWindowWidth/2)
        }
        if orderTy == "4"{
            leftView.isHidden=true
            priceButton.isHidden=true
        }else{
            leftView.isHidden=false
            priceButton.isHidden=false
        }
        
        if orderTy == "3"
        {
            leftButton.isHidden=true
            rightButton.isHidden=true
//            submitButton.isHidden=false
            submitButton.backgroundColor=TBIThemeDarkBlueColor
            submitButton.setTitle("申请退订", for: UIControlState.normal)
        }else{
            leftButton.backgroundColor=TBIThemeShallowBlueColor
            leftButton.setTitle("改签", for: UIControlState.normal)
            rightButton.backgroundColor=TBIThemeDarkBlueColor
            rightButton.setTitle("退票", for: UIControlState.normal)
        }
        submitButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.height.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(orderTy == "4" ? 1:2)
        }
        rightButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.height.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(orderTy == "4" ? 2:4)
        }
        leftButton.snp.makeConstraints { (make) in
            make.right.equalTo(rightButton.snp.left)
            make.height.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(orderTy == "4" ? 2:4)
        }
        
        priceButton.snp.makeConstraints { (make) in
            make.right.equalTo(leftView).offset(-15)
            make.centerY.equalToSuperview()
        }
    }


}
