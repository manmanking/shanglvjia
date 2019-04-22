//
//  ReserveCompanyRoomPersonerTableViewCell.swift
//  shop
//
//  Created by manman on 2017/5/16.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

enum ReserveCompanyRoomPersonerButtonState {
    case add
    case delete
}



class ReserveCompanyRoomPersonerTableViewCell: UITableViewCell {

    typealias ReserveCompanyRoomPersonerDeleteBlock = (IndexPath,NSInteger)->Void
    
    typealias ReserveCompanyRoomPersonerAddBlock = (IndexPath)->Void
    
    public var reserveCompanyRoomPersonerDeleteBlock:ReserveCompanyRoomPersonerDeleteBlock!
    public var reserveCompanyRoomPersonerAddBlock:ReserveCompanyRoomPersonerAddBlock!
    
    private let holderName:String = "新增入住人"
    private var baseBackgroundView = UIView()
    private var subBackgroundView = UIView()
    private var titleRoomNumLabel:UILabel = UILabel()
    private var titleFirstPersonNameLabel:UITextField = UITextField()
    private var titleFirstPersonTelLabel:UILabel = UILabel()
    private var titleSecondPersonNameLabel:UITextField = UITextField()
    private var titleSecondPersonTelLabel:UILabel = UILabel()
    private var deletePersonButton:UIButton = UIButton()
    private var addPersonButton:UIButton = UIButton()
    private var cellIndex:IndexPath = IndexPath()
    
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        deletePersonButton.tag = 1001
        addPersonButton.tag = 1002
        
        baseBackgroundView.backgroundColor = TBIThemeBaseColor
        self.contentView.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        
        subBackgroundView.backgroundColor = UIColor.white
        self.contentView.addSubview(subBackgroundView)
        subBackgroundView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.left.bottom.right.equalToSuperview()
        }
        
        
        setUIAutolayout()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    func setUIAutolayout() {
       
        titleRoomNumLabel.text = "房间1"
        titleRoomNumLabel.textColor = TBIThemeBlueColor
        titleRoomNumLabel.font = UIFont.systemFont( ofSize: 13)
        subBackgroundView.addSubview(titleRoomNumLabel)
        titleRoomNumLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(15)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(14)
            
        }
        
        
        let firstLine:UILabel = UILabel()
        firstLine.backgroundColor = TBIThemeGrayLineColor
        subBackgroundView.addSubview(firstLine)
        firstLine.snp.makeConstraints { (make) in
            
            make.top.equalTo(titleRoomNumLabel.snp.bottom).offset(15)
            make.height.equalTo(0.5)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            
        }
        
        titleFirstPersonNameLabel.text = "赵飞飞"
        titleFirstPersonNameLabel.textColor = TBIThemePrimaryTextColor
        titleFirstPersonNameLabel.font = UIFont.systemFont( ofSize: 13)
        subBackgroundView.addSubview(titleFirstPersonNameLabel)
        titleFirstPersonNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(firstLine.snp.bottom).offset(15)
            make.left.equalToSuperview().inset(15)
            make.height.equalTo(14)
            make.width.equalTo(100)
        }
        
        
        titleFirstPersonTelLabel.text = "13555555555"
        titleFirstPersonTelLabel.textColor = TBIThemePrimaryTextColor
        titleFirstPersonTelLabel.adjustsFontSizeToFitWidth = true
        titleFirstPersonTelLabel.font = UIFont.systemFont( ofSize: 13)
        subBackgroundView.addSubview(titleFirstPersonTelLabel)
        titleFirstPersonTelLabel.snp.makeConstraints { (make) in
            make.top.equalTo(firstLine.snp.bottom).offset(15)
            make.left.equalTo(titleFirstPersonNameLabel.snp.right).offset(5)
            make.centerY.equalTo(titleFirstPersonNameLabel.snp.centerY)
            make.height.equalTo(14)
            make.width.equalTo(100)
        }
        
        
        deletePersonButton.setImage(UIImage.init(named: "HotelDeleteHollow"), for: UIControlState.normal)
        deletePersonButton.addTarget(self, action: #selector(deletePersonButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        subBackgroundView.addSubview(deletePersonButton)
        deletePersonButton.snp.makeConstraints { (make) in
            //make.top.equalTo(firstLine.snp.bottom).offset(15)
            make.centerY.equalTo(titleFirstPersonTelLabel.snp.centerY)
            make.right.equalToSuperview().inset(15)
            make.width.height.equalTo(20)
            
        }
        
        let secondLine:UILabel = UILabel()
        secondLine.backgroundColor = TBIThemeGrayLineColor
        subBackgroundView.addSubview(secondLine)
        secondLine.snp.makeConstraints { (make) in
            
            make.top.equalTo(titleFirstPersonNameLabel.snp.bottom).offset(8)
            make.height.equalTo(0.5)
            make.left.equalToSuperview().inset(15)
            make.right.equalToSuperview()
            
        }
        
        titleSecondPersonNameLabel.placeholder = "新增入住人"
        titleSecondPersonNameLabel.textColor = TBIThemePrimaryTextColor
        titleSecondPersonNameLabel.font = UIFont.systemFont( ofSize: 13)
        subBackgroundView.addSubview(titleSecondPersonNameLabel)
        titleSecondPersonNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(secondLine.snp.bottom).offset(15)
            make.left.equalToSuperview().inset(15)
            make.height.equalTo(14)
            make.width.equalTo(100)
        }
        
        
        titleSecondPersonTelLabel.text = ""
        titleSecondPersonTelLabel.textColor = TBIThemePrimaryTextColor
        titleSecondPersonTelLabel.adjustsFontSizeToFitWidth = true
        titleSecondPersonTelLabel.font = UIFont.systemFont( ofSize: 13)
        subBackgroundView.addSubview(titleSecondPersonTelLabel)
        titleSecondPersonTelLabel.snp.makeConstraints { (make) in
            make.top.equalTo(secondLine.snp.bottom).offset(15)
            make.left.equalTo(titleSecondPersonNameLabel.snp.right).offset(5)
            make.height.equalTo(14)
            make.width.equalTo(100)
        }
        
        
        addPersonButton.setImage(UIImage.init(named: "HotelAddHollow"), for: UIControlState.normal)
        addPersonButton.addTarget(self, action: #selector(addPersonButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        subBackgroundView.addSubview(addPersonButton)
        addPersonButton.snp.makeConstraints { (make) in
            //make.top.equalTo(secondLine.snp.bottom).offset(15)
            make.right.equalToSuperview().inset(15)
            make.centerY.equalTo(titleSecondPersonTelLabel.snp.centerY)
            make.width.height.equalTo(20)
            
        }
    }
    
    
    
    @objc private func deletePersonButtonAction(sender:UIButton) {
        printDebugLog(message: "company book delete ...")
        var row = 1
        if sender.tag == 1002 {
            row = 2
        }
        
        
        self.reserveCompanyRoomPersonerDeleteBlock(cellIndex,row)
    }
    
    @objc private func addPersonButtonAction(sender:UIButton) {
        printDebugLog(message: "company book add ...")
        self.reserveCompanyRoomPersonerAddBlock(cellIndex)
    }
    
    
   private func setButtonState(state:ReserveCompanyRoomPersonerButtonState,button:UIButton) {
        
        switch state {
        case .add:
            button.removeTarget(self, action: nil, for: UIControlEvents.touchUpInside)
            button.setImage(UIImage.init(named:"HotelAddHollow"), for: UIControlState.normal)
            button.addTarget(self, action: #selector(addPersonButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        
            break
            
        case.delete:
            button.removeTarget(self, action: nil, for: UIControlEvents.touchUpInside)
            button.setImage(UIImage.init(named:"HotelDeleteHollow"), for: UIControlState.normal)
            button.addTarget(self, action: #selector(deletePersonButtonAction(sender:)), for: UIControlEvents.touchUpInside)
            break
        }
        
        
    }
    
    
    
    
    
    
    
    func fillDataSources(roomNum:String,firstName:String,firstTel:String,secondName:String,secondTel:String,index:IndexPath) {
        
        titleRoomNumLabel.text =  "房间" + roomNum
        if firstName.isEmpty == true || firstName == holderName {
            titleFirstPersonNameLabel.placeholder = holderName
            titleFirstPersonNameLabel.text = ""
        }else {
            titleFirstPersonNameLabel.text = firstName
        }
        
        if firstName == holderName {
            titleSecondPersonNameLabel.placeholder = firstName
            titleSecondPersonNameLabel.text = ""
        }else
        {
            titleSecondPersonNameLabel.placeholder = ""
            titleSecondPersonNameLabel.text = firstName
        }
        
        if firstName.characters.count > 0  && firstName != holderName{
          setButtonState(state: ReserveCompanyRoomPersonerButtonState.delete, button: deletePersonButton)
        }else
        {
            setButtonState(state: ReserveCompanyRoomPersonerButtonState.add, button: deletePersonButton)
        }
        titleFirstPersonTelLabel.text = firstTel
        if secondName == holderName {
            titleSecondPersonNameLabel.placeholder = secondName
            titleSecondPersonNameLabel.text = ""
        }else
        {
            titleSecondPersonNameLabel.placeholder = ""
            titleSecondPersonNameLabel.text = secondName
        }
        if secondName.characters.count > 0 && secondName != holderName {
            setButtonState(state: ReserveCompanyRoomPersonerButtonState.delete, button: addPersonButton)
        }else
        {
            setButtonState(state: ReserveCompanyRoomPersonerButtonState.add, button: addPersonButton)
        }
        titleSecondPersonTelLabel.text = secondTel
        cellIndex = index
    
    }
    
    
   
    
    
    
    
    
}
