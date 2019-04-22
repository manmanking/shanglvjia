//
//  QuestionDetailsViewController.swift
//  shop
//
//  Created by TBI on 2017/5/9.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import RxSwift

class FAQDetailsViewController: CompanyBaseViewController {
    
    let bag = DisposeBag()
    
    var detail:FAQDetail?
    
    var  detailTitle:UILabel = UILabel(text:"", color: TBIThemePrimaryTextColor, size: 20)
    
    let  detailContent:UILabel = UILabel(text:"", color: TBIThemeMinorTextColor, size: 14)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "问题详情"
        let backButton = UIButton(frame:CGRect(x:0,y:5,width:70,height:18))
        navigationController?.setNavigationBarHidden(false, animated: false)
        backButton.setImage(#imageLiteral(resourceName: "back"), for: UIControlState.normal)
        backButton.contentHorizontalAlignment = .left
        backButton.setTitle(" 返回", for: .normal)
        backButton.rx.controlEvent(.touchUpInside).subscribe{ _ in
            self.navigationController?.popToRootViewController(animated: true)
            self.navigationController?.isNavigationBarHidden = true
            }.addDisposableTo(bag)
        let backBarButton = UIBarButtonItem.init(customView: backButton)
        // 设置导航栏的leftButton
        self.navigationItem.leftBarButtonItem = backBarButton
        initView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initView(){
        detailTitle.text = detail?.title
        detailContent.text = detail?.content
        detailContent.numberOfLines=0
        detailContent.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.view.addSubview(detailTitle)
        self.view.addSubview(detailContent)
        detailTitle.snp.makeConstraints{ make in
            make.top.equalTo(94)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(20)
        }
        detailContent.snp.makeConstraints{ make in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(detailTitle.snp.bottom).offset(15)
            make.height.equalTo(50)
        }
    }


}
