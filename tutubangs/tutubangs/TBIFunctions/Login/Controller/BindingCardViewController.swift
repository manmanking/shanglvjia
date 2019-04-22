//
//  BindingCardViewController.swift
//  shanglvjia
//
//  Created by tbi on 2018/7/5.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class BindingCardViewController: BaseViewController {

    public var userId:String = ""
    let idCardView:BindingCardView  =  BindingCardView()
    var idCardText:String = ""
    /// 用户信息
    fileprivate var userSVDetail:LoginResponse = LoginResponse()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = TBIThemeBaseColor
        setBlackTitleAndNavigationColor(title: "绑定身份证")
        initView ()
        // Do any additional setup after loading the view.
    }

    func initView()  {
        idCardView.frame = CGRect(x: 0, y: 0, width: ScreenWindowWidth, height: ScreentWindowHeight)
        self.view.addSubview(idCardView)
        idCardView.bindCard(cardNum:idCardText)
        if idCardText.isEmpty{
            ///绑定
            idCardView.submitButton.addTarget(self, action: #selector(bindCert), for: UIControlEvents.touchUpInside)
        }else{
            ///解绑
        }
        
    }
    override func backButtonAction(sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    ///绑定身份证
    func bindCert()  {
        if CommonTool.isIdcardNum(with: idCardView.oldPwTextField.text)
        {
            showLoadingView()
            weak var weakSelf = self
            let request:[String:Any] = ["certNo":idCardView.oldPwTextField.text,"certType":"1","userId":userId]
            _ = LoginServices.sharedInstance
                .bindCert(request: request)
                .subscribe{ event in
                    weakSelf?.hideLoadingView()
                    switch event {
                    case .next(let e):
                        DBManager.shareInstance.userDetailStore(userDetail: e)
                        DBManager.shareInstance.currentActivePersonal()
                        printDebugLog(message: DBManager.shareInstance.userDetailDraw()?.mj_keyValues())
                        weakSelf?.intoMainView(from: "企业账号登录")
                    case .error(let e):
                        printDebugLog(message: e)
                        try? weakSelf?.validateHttp(e)
                    case .completed:
                        printDebugLog(message: "completed")
                    }
            }
        }else{
            
            showSystemAlertView(titleStr: "提示", message: "请输入合法的身份证号")
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
