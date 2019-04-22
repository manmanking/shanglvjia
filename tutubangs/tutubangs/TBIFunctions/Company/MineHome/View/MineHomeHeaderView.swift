//
//  MineHomeHeaderView.swift
//  shop
//
//  Created by TBI on 2017/4/27.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class MineHomeHeaderView: UIView {
    
    
    
    typealias MineHomeHeaderViewScanBlock = ()->Void
    
    public var mineHomeHeaderViewScanBlock:MineHomeHeaderViewScanBlock!

      private var scanButton:UIButton = UIButton()
    
    /// 懒加载，创建背景图片
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.contentMode = .scaleAspectFill
        bgImageView.image = UIImage(named: "group")
        return bgImageView
    }()
    
    //为登录图片
    let  unregisteredImage: UIView = {
        let view = UIView()
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "ic_unregistered_image")
        view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints{(make) in
            make.height.width.equalTo(60)
            make.left.equalTo(2)
            make.bottom.equalTo(-2)
        }
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor(r:255 ,g:255 ,b:255 ,alpha:0.4).cgColor
        view.layer.cornerRadius = 32
        return view
    }()//UIImageView(imageName: "unregisteredImage")
    //登录图片
    //let  loginImage = UIImageView(imageName: "ic_login_image")
    
    let  loginLabel = UIButton(title: NSLocalizedString("mine.login", comment: "登录/注册"),titleColor: TBIThemeWhite,titleSize: 17)

    let  userNameLabel = UILabel(text: "HELLO",color: TBIThemeWhite,size: 17)

    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView(){
        addSubview(bgImageView)
        addSubview(unregisteredImage)
        addSubview(loginLabel)
        addSubview(userNameLabel)
        scanButton.setImage(UIImage.init(named: "ic_scanning"), for: UIControlState.normal)
        scanButton.addTarget(self, action: #selector(scanButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        addSubview(scanButton)
        
        // 布局
        bgImageView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(self)
            make.top.equalTo(-44)
        }
        unregisteredImage.snp.makeConstraints{(make) in
            make.height.width.equalTo(64)
            make.left.equalTo(20)
            make.bottom.equalTo(-40)
        }
        loginLabel.snp.makeConstraints{ (make) in
            make.left.equalTo(unregisteredImage.snp.right).offset(20)
            make.centerY.equalTo(unregisteredImage.snp.centerY).offset(14)
        }
        userNameLabel.snp.makeConstraints{ (make) in
            make.left.equalTo(loginLabel.snp.left)
            make.bottom.equalTo(loginLabel.snp.top)
        }
        scanButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(unregisteredImage.snp.centerY)
            make.right.equalToSuperview().inset(15)
            make.width.height.equalTo(28)
        }
        
    }
    
    
    func scanButtonAction(sender:UIButton) {
        if mineHomeHeaderViewScanBlock != nil {
            mineHomeHeaderViewScanBlock()
        }
    }
    
    
}
