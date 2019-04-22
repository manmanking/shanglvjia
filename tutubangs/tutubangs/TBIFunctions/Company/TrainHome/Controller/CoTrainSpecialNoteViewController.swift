//
//  CoTrainSpecialNoteViewController.swift
//  shop
//
//  Created by TBI on 2018/1/8.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class CoTrainSpecialNoteViewController: CompanyBaseViewController {

    let scrollView = UIScrollView(frame: UIScreen.main.bounds)
    
    let  vi = CoTrainSpecialNoteView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation(title:"特别提示")
        setNavigationBackButton(backImage: "")
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentSize = CGSize.init(width: 0, height: 780)
        self.view.addSubview(scrollView)
        scrollView.addSubview(vi)
        vi.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.width.equalTo(ScreenWindowWidth)
            make.height.equalTo(ScreentWindowHeight)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func backButtonAction(sender:UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
