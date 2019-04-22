//
//  AssuranceInfoTableViewCell.swift
//  shop
//
//  Created by manman on 2017/4/26.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class AssuranceInfoTableViewCell: UITableViewCell,UITextFieldDelegate{
    
    
    typealias AssuranceInfoResultBlock = (String,String,IndexPath)->Void
    public var assuranceInfoResultBlock:AssuranceInfoResultBlock!
    private var titleAssurance  = "担保金额"
    private var baseBackgroundView = UIView()
    private var titleLabel  = UILabel()
    private var contentTextField = UITextField()
    private var bottomLine = UILabel()
    private var cellIndex:IndexPath = IndexPath()
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        baseBackgroundView.backgroundColor = UIColor.white
        self.contentView.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
            
            make.top.left.bottom.right.equalToSuperview()
            
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(AssuranceInfoKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        //注册键盘消失的通知
        setUIViewAutolayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUIViewAutolayout() {
        
        titleLabel.textAlignment = NSTextAlignment.left
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        baseBackgroundView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            
            make.top.bottom.equalToSuperview().inset(15)
            make.left.equalToSuperview().inset(15)
            make.width.equalTo(103)
            
        }
        
        contentTextField.font = UIFont.systemFont( ofSize: 16)
        baseBackgroundView.addSubview(contentTextField)
        contentTextField.delegate = self
        contentTextField.snp.makeConstraints { (make) in
            
            make.top.bottom.equalToSuperview().inset(5)
            make.left.equalTo(titleLabel.snp.right).offset(5)
            make.right.equalToSuperview().inset(30)
            
        }
        
        
        bottomLine.backgroundColor = TBIThemeGrayLineColor
        baseBackgroundView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            
            make.bottom.equalToSuperview().inset(1)
            make.height.equalTo(0.5)
            make.left.equalToSuperview().inset(15)
            make.right.equalToSuperview()
            
        }
        
        
        
    }
    
    
    func fillDatasources(title:String,contentEnable:Bool,content:String,
                         contentPlacrHolder:String,showLine:Bool,cellIndexPath:IndexPath?)  {
        if cellIndexPath != nil {
            cellIndex = cellIndexPath!
        }
        
        titleLabel.text = title
        bottomLine.isHidden = !showLine
        contentTextField.isEnabled = contentEnable
        if content.isEmpty == true
        {
            contentTextField.text = ""
            contentTextField.placeholder = contentPlacrHolder
        }else
        {
            contentTextField.text = content
            contentTextField.placeholder = ""
        }
        
        
        
        if titleAssurance == title
        {
            contentTextField.textColor = TBIThemeOrangeColor
             if content.range(of: "¥") == nil
             {
                contentTextField.text = "¥" + content
            }
            
        }else
        {
            contentTextField.textColor = TBIThemePrimaryTextColor
        }
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        assuranceInfoResultBlock(contentTextField.text!,titleLabel.text!,cellIndex)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        contentTextField.resignFirstResponder()
        return true
    }
    
    
    @objc private  func AssuranceInfoKeyboardWillHide() {
       // assuranceInfoResultBlock(contentTextField.text!,titleLabel.text!,cellIndex)
    }
    
    
    
    

}
