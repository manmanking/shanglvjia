//
//  ChangeNumButton.swift
//  shanglvjia
//
//  Created by tbi on 2018/7/26.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class ChangeNumButton: UIView {

    typealias ReturnNumberBlock = (NSInteger) ->Void
    public var returnNumberBlock:ReturnNumberBlock!
    
    let reduceButton:UIButton = UIButton()
    let addButton:UIButton = UIButton()
    let numLabel:UILabel = UILabel.init(text: "", color: PersonalThemeMajorTextColor, size: 15)
    var startNum:NSInteger = 1
    var minNumber:NSInteger = 1
    var maxNumber:NSInteger = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView(){
        addSubview(addButton)
        addSubview(reduceButton)
        addSubview(numLabel)
        
        addButton.setImage(UIImage(named:"travel_jiahao"), for: UIControlState.normal)
        addButton.contentHorizontalAlignment = .right
        addButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.width.height.equalTo(45)
        }
        addButton.addTarget(self, action: #selector(addButtonClick(sender:)), for: UIControlEvents.touchUpInside)
        
        reduceButton.setImage(UIImage(named:"travel_jianhao"), for: UIControlState.normal)
        reduceButton.contentHorizontalAlignment = .left
        reduceButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.width.height.equalTo(45)
        }
         reduceButton.addTarget(self, action: #selector(reduceButtonClick(sender:)), for: UIControlEvents.touchUpInside)
        
        numLabel.text = startNum.description
        numLabel.textAlignment = .center
        numLabel.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(40)
        }
        if startNum == minNumber {
            reduceButton.isEnabled = false
        }
    }
    func initStartNum(minNum:NSInteger,maxNum:NSInteger,num:NSInteger){
        startNum = num
        numLabel.text = startNum.description
        if startNum == 1 {
            reduceButton.isEnabled = false
        }
        if startNum >= maxNum{
            addButton.isEnabled = false
        }else{
             addButton.isEnabled = true
        }
        if startNum <= minNum{
            reduceButton.isEnabled = false
        }else{
            reduceButton.isEnabled = true
        }
        minNumber = minNum
        maxNumber = maxNum
    }
    func addButtonClick(sender:UIButton)  {
        startNum = startNum + 1
        numLabel.text = startNum.description
        if returnNumberBlock != nil {
            returnNumberBlock(startNum)
        }
         reduceButton.isEnabled = true
    }
    func reduceButtonClick(sender:UIButton)  {
        guard startNum - 1 >= minNumber else {
            reduceButton.isEnabled = false
            return
        }
        startNum -= 1
        if startNum == minNumber {
            reduceButton.isEnabled = false
        }
         numLabel.text = startNum.description
        if returnNumberBlock != nil {
            returnNumberBlock(startNum)
        }
        
    }
}
