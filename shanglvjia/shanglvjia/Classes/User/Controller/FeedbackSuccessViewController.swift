//
//  FeedbackSuccessViewController.swift
//  shop
//
//  Created by TBI on 2017/5/11.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import RxSwift

class FeedbackSuccessViewController: CompanyBaseViewController {
    
    let bag = DisposeBag()
    
    let  bgView = UIView()

    let  success = UIImageView(imageName: "ic_success")
    
    let  successTitle = UILabel(text:NSLocalizedString("mine.feedback.success.title", comment: "反馈成功"), color: TBIThemePrimaryTextColor, size: 17)
    
    let  successMessage = UILabel(text:NSLocalizedString("mine.feedback.success.message", comment: ""), color: TBIThemeMinorTextColor, size: 13)
    
    let  successToHome = UIButton(title: NSLocalizedString("mine.feedback.success.home", comment: "返回首页"),titleColor: TBIThemeWhite,titleSize: 18)
    
    let  successToMineHome = UIButton(title: NSLocalizedString("mine.feedback.success.mine.home", comment: "个人中心"),titleColor: TBIThemePrimaryTextColor,titleSize: 18)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        self.navigationItem.hidesBackButton = true
        self.title = NSLocalizedString("mine.feedback.success.title",comment: "反馈成功")
        successToHome.rx.controlEvent(.touchUpInside).subscribe{ _ in
            self.intoMainView(from: "成功")
            }.addDisposableTo(bag)
        successToMineHome.rx.controlEvent(.touchUpInside).subscribe{ _ in
            _ = self.navigationController?.popToRootViewController(animated: false)
            let tabbarView:BaseTabBarController = UIApplication.shared.keyWindow?.rootViewController as!BaseTabBarController
            tabbarView.selectedIndex = 2//3
            }.addDisposableTo(bag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
extension  FeedbackSuccessViewController {
    
    func initView(){
        self.view.backgroundColor = TBIThemeBaseColor
        bgView.backgroundColor = TBIThemeWhite
        successToHome.setBackgroundImage(UIImage (named: "yellow_btn_gradient"), for: UIControlState.normal)
        successToMineHome.backgroundColor = TBIThemeWhite
        successToHome.layer.cornerRadius = 5
        successToHome.clipsToBounds=true
        successToMineHome.layer.cornerRadius = 5
        self.view.addSubview(bgView)
        self.view.addSubview(successToHome)
        self.view.addSubview(successToMineHome)
        bgView.addSubview(success)
        bgView.addSubview(successTitle)
        bgView.addSubview(successMessage)
        bgView.snp.makeConstraints{ make in
            make.left.right.equalTo(0)
            make.top.equalTo(0)
            make.height.equalTo(185)
        }
        success.snp.makeConstraints{ make in
            make.height.width.equalTo(60)
            make.centerX.equalToSuperview()
            make.top.equalTo(30)
        }
        successTitle.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(success.snp.bottom).offset(15)
        }
        successMessage.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(successTitle.snp.bottom).offset(10)
        }
        successToHome.snp.makeConstraints{ make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(47)
            make.top.equalTo(bgView.snp.bottom).offset(30)
        }
        successToMineHome.snp.makeConstraints{ make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(47)
            make.top.equalTo(successToHome.snp.bottom).offset(15)
        }
        
    
    }
}
