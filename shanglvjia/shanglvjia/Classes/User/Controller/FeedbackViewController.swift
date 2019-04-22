//
//  FeedbackViewController.swift
//  shop
//
//  Created by TBI on 2017/5/8.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import RxSwift

class FeedbackViewController: CompanyBaseViewController {
    
    let bag = DisposeBag()
    
    let feedbackView:FeedbackView  =  FeedbackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.setNavigationColor()
        setBlackTitleAndNavigationColor(title:"意见反馈")
//        setNavigationBackButton(backImage: "back")
        feedbackView.frame = CGRect(x: 0, y: 0, width: ScreenWindowWidth, height: ScreentWindowHeight)
        self.view.addSubview(feedbackView)
        feedbackView.submitButton.addTarget(self,action:#selector(submitButtonAction(sender:)),for: UIControlEvents.touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func backButtonAction(sender:UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    func submitButtonAction(sender:UIButton) {
        
        let userDetail = UserService.sharedInstance.userDetail()
        weak var weakSelf = self
        let form = FeedBackVO(id: userDetail?.id ?? "", contact: feedbackView.contactText.text ?? "", opinion: feedbackView.feedbackText.text ?? "")
        weakSelf?.showLoadingView()
        FeedBackService.sharedInstance.feedback(form)
            .subscribe{event in
                weakSelf?.hideLoadingView()
                if case .next(let e) = event {
                    print("=====成功======")
                    print(e)
        
                    self.navigationController?.pushViewController(FeedbackSuccessViewController() , animated: true)
                    
                }
                if case .error(let e) = event {
                    try? self.validateHttp(e)
                    
                }
            }
        .disposed(by: bag)
 
    }


}
