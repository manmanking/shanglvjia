//
//  FlightModifyTravellerTableViewCell.swift
//  shop
//
//  Created by manman on 2017/5/26.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class FlightModifyTravellerTableViewCell: UITableViewCell,UITextFieldDelegate {

    
    typealias FlightModifyTravellerCellBlock = (IndexPath,String,String)->Void
    
    public var  flightModifyTravellerCellBlock:FlightModifyTravellerCellBlock!
    
    private var cellIndexPath:IndexPath = IndexPath()
    
    private var baseBackgroundView = UIView()
    
    public var categoryTitleLabel = UILabel()
    
    private var contentTextField = UITextField()
    
    private var intoDetailFlageImageView = UIImageView()
    
    private var intoNextBool:Bool = false
    private var bottomLabel:UILabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        baseBackgroundView.backgroundColor = UIColor.white
        self.contentView.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
            
            make.top.left.bottom.right.equalToSuperview()
            
        }
        setUIViewAutolayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUIViewAutolayout()
    {
        categoryTitleLabel.textAlignment = NSTextAlignment.left
        categoryTitleLabel.font = UIFont.systemFont(ofSize: 13)
        baseBackgroundView.addSubview(categoryTitleLabel)
        categoryTitleLabel.snp.makeConstraints { (make) in
            
            make.top.bottom.equalToSuperview().inset(5)
            make.left.equalToSuperview().inset(15)
            make.width.equalTo(100)
            
        }
        
        contentTextField.font = UIFont.systemFont( ofSize: 13)
        contentTextField.delegate = self
        baseBackgroundView.addSubview(contentTextField)
        contentTextField.snp.makeConstraints { (make) in
            
            make.top.bottom.equalToSuperview().inset(5)
            make.left.equalTo(categoryTitleLabel.snp.right).offset(5)
            make.right.equalToSuperview().inset(30)
            
        }
        
        intoDetailFlageImageView.image = UIImage.init(named: "Common_Forward_Arrow_Gray")
        baseBackgroundView.addSubview(intoDetailFlageImageView)
        intoDetailFlageImageView.snp.makeConstraints { (make) in
            
            make.right.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
            make.height.equalTo(13)
            make.width.equalTo(7)
            
        }
        
        
        bottomLabel.backgroundColor = TBIThemeGrayLineColor
        baseBackgroundView.addSubview(bottomLabel)
        bottomLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(1)
            make.left.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
    }
    
    func fillDataSource(title:String,contentPlaceHolder:String,
                        content:String,contentEnable:Bool,intoNextEnable:Bool,cellIndex:IndexPath ,showLine:Bool) {
        clearDataSources()
        cellIndexPath = cellIndex

        bottomLabel.isHidden = !showLine
        
        categoryTitleLabel.text = title
        categoryTitleLabel.textColor = TBIThemePrimaryTextColor
        if contentPlaceHolder.isEmpty == false {
            
            contentTextField.placeholder = contentPlaceHolder
        }
        if content.isEmpty == false {
            contentTextField.text = content
        }
        contentTextField.isUserInteractionEnabled = contentEnable
        contentTextField.textColor = UIColor.black
        intoDetailFlageImageView.isHidden = !intoNextEnable
        intoNextBool = !intoNextBool
        
        contentTextField.snp.removeConstraints()
        contentTextField.snp.makeConstraints { (make) in
            
            make.top.bottom.equalToSuperview().inset(5)
            make.left.equalTo(categoryTitleLabel.snp.right).offset(5)
            make.right.equalToSuperview().inset(30)
            
        }
        
    }
    
    
    
    
    func clearDataSources() {
        categoryTitleLabel.text = ""
        contentTextField.text = ""
        contentTextField.placeholder = ""
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        printDebugLog(message: "into here")
        if (textField.text?.characters.count)! >= 1 {
            flightModifyTravellerCellBlock(cellIndexPath,categoryTitleLabel.text!,contentTextField.text!)
        }
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        flightModifyTravellerCellBlock(cellIndexPath,categoryTitleLabel.text!,contentTextField.text!)
        
        return true
    }
    
}
    

