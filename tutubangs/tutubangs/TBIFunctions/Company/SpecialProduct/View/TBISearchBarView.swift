//
//  TBISearchBarView.swift
//  shop
//
//  Created by manman on 2017/7/4.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class TBISearchBarView: UIView,UITextFieldDelegate {

    typealias TBISearchBarViewBlock = (String)->Void
    public var searchBarViewBlock:TBISearchBarViewBlock!
    private var baseBackgroundView:UIView = UIView()
    private var subBaseBackgroundView:UIView = UIView()
    private var searchBarFlagImageView:UIImageView = UIImageView()
    private var searchBarTextField:UITextField = UITextField()
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        baseBackgroundView.backgroundColor = UIColor.white
        self.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        subBaseBackgroundView.backgroundColor = UIColor.white
        baseBackgroundView.addSubview(subBaseBackgroundView)
        subBaseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
       setUIViewAutolayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUIViewAutolayout() {
       
        searchBarFlagImageView.image = UIImage.init(named: "searchBarFlag")
        baseBackgroundView.addSubview(searchBarFlagImageView)
        searchBarFlagImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.width.height.equalTo(12)
        }
        searchBarTextField.placeholder = "关键字/目的地"
        searchBarTextField.textColor = TBIThemePrimaryTextColor
        searchBarTextField.delegate = self
        searchBarTextField.font = UIFont.systemFont( ofSize: 13)
        searchBarTextField.tintColor = TBIThemeBlueColor
        baseBackgroundView.addSubview(searchBarTextField)
        searchBarTextField.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(5)
            make.left.equalToSuperview().offset(25)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
        }
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchBarViewBlock(textField.text!)
        return true
    }
  
}
