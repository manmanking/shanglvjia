//
//  HotelCompanyChoiceRoleView.swift
//  shop
//
//  Created by manman on 2017/5/18.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class HotelCompanyChoiceRoleView: UIView,UIAccelerometerDelegate{

    typealias HotelCompanyChoiceRoleResultBlock = (NSInteger,String)->Void
    public  var hotelCompanyChoiceRoleResultBlock:HotelCompanyChoiceRoleResultBlock!
    
    private var baseBackgroundView = UIView()
    private var subBackgroundView = UIView()
    private var selectedIndex:NSInteger = 5
    //价格筛选
    public var choiceRoleViewDataSourcesArr:[String] = Array()
    private var forMineButton = UIButton()
    private var forOtherButton = UIButton()
    private var cancelButton = UIButton()
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        baseBackgroundView.backgroundColor = UIColor.black
        baseBackgroundView.alpha = 0.6
        self.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
            
            make.top.left.bottom.right.equalToSuperview()
            
        }
        
        baseBackgroundView.addOnClickListener(target: self, action: #selector(tapAction(tap:)))
        self.addSubview(subBackgroundView)
        subBackgroundView.backgroundColor = TBIThemeBaseColor
        subBackgroundView.snp.makeConstraints { (make) in
            
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(220)
            
        }
        
        setUIViewAutolayout()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //roleView.choiceRoleViewDataSourcesArr = ["为自己预订","为他人预定"]
    func setUIViewAutolayout() {
        
        forMineButton.setTitle("为自己预订", for: UIControlState.normal)
        forMineButton.addTarget(self, action: #selector(forMineButtonAction(sender:)), for:UIControlEvents.touchUpInside)
        forMineButton.titleLabel?.font = UIFont.systemFont( ofSize: 18)
        forMineButton.backgroundColor = UIColor.white
        forMineButton.setTitleColor(TBIThemePrimaryTextColor, for: UIControlState.normal)
        subBackgroundView.addSubview(forMineButton)
        forMineButton.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(80)
        }
        
        forOtherButton.setTitle("为他人预定", for: UIControlState.normal)
        forOtherButton.backgroundColor = UIColor.white
        forOtherButton.titleLabel?.font = UIFont.systemFont( ofSize: 18)
        forOtherButton.addTarget(self, action: #selector(forOtherButtonAction(sender:)), for:UIControlEvents.touchUpInside)
        forOtherButton.setTitleColor(TBIThemePrimaryTextColor, for: UIControlState.normal)
        subBackgroundView.addSubview(forOtherButton)
        forOtherButton.snp.makeConstraints { (make) in
            make.top.equalTo(forMineButton.snp.bottom).offset(0.5)
            make.left.right.equalToSuperview()
            make.height.equalTo(80)
        }
        
        
    
        cancelButton.setTitle("取消", for: UIControlState.normal)
        cancelButton.backgroundColor = UIColor.white
        cancelButton.titleLabel?.font = UIFont.systemFont( ofSize: 18)
        cancelButton.addTarget(self, action: #selector(cancelAction), for:UIControlEvents.touchUpInside)
        cancelButton.setTitleColor(TBIThemePrimaryTextColor, for: UIControlState.normal)
        subBackgroundView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.top.equalTo(forOtherButton.snp.bottom).offset(10)
            make.left.bottom.right.equalToSuperview()
        }
    
    }
    
    
    
    func fillDataSources(titleArr:Array<String>) {
        
        if titleArr.count > 2 {
            forMineButton.setTitle(titleArr[0], for: UIControlState.normal)
            //forOtherButton.currentTitle = titleArr[0]
            forOtherButton.setTitle(titleArr[1], for: UIControlState.normal)
        }
        
        
    }
    
    
    @objc private func tapAction(tap:UITapGestureRecognizer) {
        cancelAction()
    }
    
    @objc private func forMineButtonAction(sender:UIButton) {
        printDebugLog(message: "forMineButtonAction")
        hotelCompanyChoiceRoleResultBlock(selectedIndex,"测试1")
        cancelAction()
    }
    
    
   @objc private  func forOtherButtonAction(sender:UIButton) {
        hotelCompanyChoiceRoleResultBlock(selectedIndex,"测试2")
        cancelAction()
    }
    
    @objc private func cancelAction() {
        self.removeFromSuperview()
    }
    
    

}
