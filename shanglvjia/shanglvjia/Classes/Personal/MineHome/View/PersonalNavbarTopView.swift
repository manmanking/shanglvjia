//
//  NavbarTopView.swift
//  shanglvjia
//
//  Created by tbi on 2018/7/6.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PersonalNavbarTopView: UIView,UITextFieldDelegate{
    
    typealias PersonalNavbarTopViewSearchBlock = (String)->Void
    
    public var personalNavbarTopViewSearchBlock:PersonalNavbarTopViewSearchBlock!

    private var searchKeywordDefaultTip:String = "搜索签证国家/地区"
    
    let leftButton:UIButton = UIButton()
    let rightButton:UIButton = UIButton()
    let searchTf = CustomTextField(fontSize:13)
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initView()
    {
        self.addSubview(leftButton)
        self.addSubview(rightButton)
        
        leftButton.contentHorizontalAlignment = .left
        leftButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.equalTo(15)
            make.width.equalTo(50)
            make.top.equalTo(kNavigationHeight - 44)
        }
        rightButton.contentHorizontalAlignment = .right
        rightButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.right.equalTo(-15)
            make.width.equalTo(leftButton)
            make.top.equalTo(leftButton)
        }
    }
    func creatSearchView() {
        let bgView:UIView = UIView()
        let searchImage:UIImageView = UIImageView()
        self.addSubview(bgView)
        bgView.addSubview(searchImage)
        
        bgView.addSubview(searchTf)
        
        bgView.backgroundColor = UIColor.init(white: 1, alpha: 0.8)
        bgView.layer.cornerRadius = 2.0
        bgView.clipsToBounds = true
        bgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(40)
            make.centerY.equalTo(leftButton)
            make.height.equalTo(30)
            make.right.equalToSuperview().inset(25)
        }
        
        searchImage.image = UIImage.init(named: "ic_search")
        searchImage.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(15)
        }
        searchTf.placeholder = searchKeywordDefaultTip
        searchTf.textAlignment = .center
        searchTf.clearButtonMode = .whileEditing
        searchTf.returnKeyType = UIReturnKeyType.search
        searchTf.delegate = self
        searchTf.returnKeyType = UIReturnKeyType.search
        searchTf.snp.makeConstraints { (make) in
            make.centerX.centerY.height.equalToSuperview()
            make.width.equalToSuperview().inset(20)
        }
    }
    
    public func fillDataSources(keyword:String) {
        searchTf.text = keyword
    }
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard textField.text?.isEmpty == false else {
            
            return true
        }
        
        if personalNavbarTopViewSearchBlock != nil {
            personalNavbarTopViewSearchBlock(textField.text!)
            
        }
        return true
    }
    
    
}
