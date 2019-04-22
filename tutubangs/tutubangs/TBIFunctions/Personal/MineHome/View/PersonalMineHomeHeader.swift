//
//  NewMineHomeHeader.swift
//  shanglvjia
//
//  Created by tbi on 2018/7/6.
//  Copyright © 2018年 TBI. All rights reserved.
//
import UIKit

class PersonalMineHomeHeader: UIView {
    
    typealias cellClickBlock = (String) ->Void
    var clickBlock:cellClickBlock?
    
    /// 懒加载，创建背景图片
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.contentMode = .scaleAspectFill
        bgImageView.image = UIImage(named: "bg_user")
        return bgImageView
    }()
    
    //为登录图片 头像
    let  unregisteredImage: UIView = {
        let view = UIView()
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "ic_unregistered_image")
        view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints{(make) in
            make.height.width.equalTo(72)
            make.left.equalTo(2)
            make.bottom.equalTo(-2)
        }
//        view.layer.borderWidth = 2
//        view.layer.borderColor = UIColor(r:255 ,g:255 ,b:255 ,alpha:0.4).cgColor
        view.layer.cornerRadius = 38
        return view
    }()//UIImageView(imageName: "unregisteredImage")
    //登录图片
    //let  loginImage = UIImageView(imageName: "ic_login_image")
    
    let  loginLabel = UIButton(title: NSLocalizedString("mine.login", comment: "登录/注册"),titleColor: TBIThemeWhite,titleSize: 18)
    
    let  integralLabel = UIButton(title: "",titleColor: TBIThemeWhite,titleSize: 13)
    
    let bgView:PersonalMineShadowView = PersonalMineShadowView()
    
    var waitButton:UIButton = UIButton()
    var payButton:UIButton = UIButton()
    var allButton:UIButton = UIButton()
    var payLabel:UILabel = UILabel.init(text: "", color: PersonalThemeNormalColor, size: 11)
    
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
        addSubview(bgView)
        addSubview(integralLabel)
//        scanButton.setImage(UIImage.init(named: "ic_scanning"), for: UIControlState.normal)
        
        // 布局
        bgImageView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(-44)
            make.bottom.equalTo(-50)
        }
        
        unregisteredImage.layer.borderWidth = 2.0
        unregisteredImage.layer.borderColor = TBIThemeWhite.cgColor
        unregisteredImage.snp.makeConstraints{(make) in
            make.height.width.equalTo(76)
            make.centerX.equalToSuperview().offset(-55)
            make.top.equalTo(75)
        }
        
        loginLabel.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        loginLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(unregisteredImage.snp.top)
            make.left.equalTo(unregisteredImage.snp.right).offset(30)
        }
        
        integralLabel.snp.makeConstraints { (make) in
            make.left.equalTo(loginLabel)
            make.height.equalTo(30)
            make.top.equalTo(loginLabel.snp.bottom)
        }
        bgView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalTo(0)
            make.height.equalTo(100)
        }
        
        let btnArr = [["imgName":"ic_user_unorder","title":"待订妥"],["imgName":"ic_user_unpaid","title":"待支付"],["imgName":"ic_user_all","title":"全部订单"]]
        let btnWidth = (ScreenWindowWidth - 30)/3
        for i in 0...btnArr.count-1{
            let button:UIButton = UIButton()
            button.frame = CGRect(x:(CGFloat(i) * btnWidth),y:0,width:btnWidth,height:100)
            button.setTitle(btnArr[i]["title"]!, for: UIControlState.normal)
            button.setTitleColor(UIColor.clear, for: UIControlState.normal)
            
            let imgView:UIImageView = UIImageView()
            let label:UILabel = UILabel(text: btnArr[i]["title"]!,color: TBIThemePrimaryTextColor,size: 14)
            label.textAlignment = NSTextAlignment.center
            imgView.image = UIImage(named:btnArr[i]["imgName"]!)
            bgView.addSubview(button)
            button.addSubview(label)
            button.addSubview(imgView)
            imgView.snp.makeConstraints({ (make) in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(-10)
            })
            label.snp.makeConstraints({ (make) in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(25)
            })
            if i == 0{
                waitButton = button
            }
            if i == 1{
                payButton = button
                imgView.addSubview(payLabel)
                payLabel.font = UIFont.boldSystemFont(ofSize: 11)
                payLabel.textAlignment = .center
                payLabel.layer.cornerRadius = 8
                payLabel.layer.borderWidth = 1.5
                payLabel.layer.borderColor = PersonalThemeNormalColor.cgColor
                payLabel.backgroundColor = TBIThemeWhite
                payLabel.clipsToBounds = true
                payLabel.snp.makeConstraints({ (make) in
                    make.right.equalTo(imgView.snp.right).offset(3)
                    make.top.equalTo(imgView.snp.top).offset(-3)
                    make.height.equalTo(16)
                })
            }
            if i == 2{
                allButton = button
            }
            
            button.addTarget(self, action: #selector(titleButtonClick(sender:)), for: UIControlEvents.touchUpInside)
        }
    }
    func titleButtonClick(sender:UIButton) {
        
        clickBlock?((sender.titleLabel?.text)!)
    }
    
    
}

