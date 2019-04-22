//
//  CoApprovalOpinionController.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/6/6.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import RxSwift

//填写审批意见    页面
class CoApprovalOpinionController: CompanyBaseViewController{

    //是否同意审批
    var isAgreeOrderParams = false
    //订单号
    var orderNoParams = ""
    /// 当前审批ID
    var  currentApverIdParams:String = ""
    /// 当前审批级别
    var currentApvLevelParams:Int = -1
    //是否为新版
    var isNewVersionParams = false
    
    var myContentView:UIView!
    var myPlaceHolderLabel:UILabel!
    var myTopTextView:UITextView!
    
    let bag = DisposeBag()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        initView()
    }

    func initView() -> Void
    {
         setNavigationBackButton(backImage: "left")
        self.navigationController?.navigationBar.isTranslucent = false
//        self.navigationController?.navigationBar.setBackgroundImage(UIColor.creatImageWithColor(color: TBIThemeBlueColor), for: .any, barMetrics: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        
        
        
        myContentView = UIView()
        myContentView.backgroundColor = TBIThemeBaseColor
        myContentView.frame = CGRect(x: 0, y: 0, width: ScreenWindowWidth, height: ScreentWindowHeight-20-44)
        self.view.addSubview(myContentView)
        
//        let textViewBgView = UIView()
//        myContentView.addSubview(textViewBgView)
//        textViewBgView.backgroundColor = UIColor.white
//        textViewBgView.snp.makeConstraints{(make)->Void in
//            make.left.right.top.equalTo(0)
//            make.height.equalTo(200)
//        }
//
        let topTextView = UITextView()
        self.myTopTextView = topTextView
        self.myTopTextView.delegate = self
        myTopTextView.layer.cornerRadius = 3
        self.myTopTextView.returnKeyType = UIReturnKeyType.done
        myContentView.addSubview(topTextView)
        topTextView.snp.makeConstraints{(make)->Void in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(10)
            make.height.equalTo(200)
        }
        topTextView.textColor = TBIThemePrimaryTextColor
        topTextView.font = UIFont.systemFont(ofSize: 16)
        topTextView.delegate = self
        
        //设置UITextView的placeHolderText
        let placeHolderLabel = UILabel(text: NSLocalizedString("order.opinion.approval.writecontent.hint", comment:"请您填写审批意见"), color: TBIThemeTipTextColor, size: 16)
        self.myPlaceHolderLabel = placeHolderLabel
        myContentView.addSubview(placeHolderLabel)
        //placeHolderLabel.backgroundColor = UIColor.brown
        placeHolderLabel.snp.makeConstraints{(make)->Void in
            make.left.equalTo(18)
            make.top.equalTo(17)
        }
        
        
        let submitBtn = UIButton(title: "提交拒绝", titleColor: UIColor.white, titleSize: 18)
        submitBtn.layer.cornerRadius = 3
        submitBtn.backgroundColor = TBIThemeRedColor
        myContentView.addSubview(submitBtn)
        submitBtn.snp.makeConstraints{(make)->Void in
            make.left.equalTo(15)
            make.top.equalTo(myTopTextView.snp.bottom).offset(30)
            make.right.equalTo(-15)
            make.height.equalTo(48)
        }
        
        submitBtn.addOnClickListener(target: self, action: #selector(commitCommentAction(sender:)))
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //initNavigation(title:"审批意见",bgColor:TBIThemeWhite,alpha:0,isTranslucent:false)
        setTitle(titleStr:"审批意见" , titleColor: TBIThemePrimaryTextColor)
        self.navigationController?.navigationBar.isTranslucent = false
    }
    //重写  头部左侧的🔙Btn
    override func backButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.navigationBar.shadowImage = UIImage.init(named: "border")
    }
    
    
    func commitCommentAction(sender:UIButton) {
        let  commitContentStr:String = myTopTextView.text
        guard commitContentStr.isEmpty == false else {
            showSystemAlertView(titleStr: "提示", message: "请填写审批意见")
            return
        }
        let alertController = UIAlertController(title: "", message: NSLocalizedString("order.opinion.approval.is.reject", comment:"审批拒绝?"),preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("common.validate.cancel", comment:"取消"), style: .cancel, handler: nil)
        cancelAction.setValue(TBIThemePrimaryTextColor, forKey: "_titleTextColor")
        weak var weakSelf = self
        let okAction = UIAlertAction(title: NSLocalizedString("common.validate.ok", comment:"确定"), style: .default, handler: {action in
            weakSelf?.rejectAllApprovalOrder(comment:commitContentStr)
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    
    func rejectAllApprovalOrder(comment:String) {
        weak var weakSelf = self
        self.showLoadingView()
        CoNewExanimeService.sharedInstance
            .approvalOrdersReject(approvalNo:[orderNoParams] , comment: comment)
            .subscribe{ event in
                self.hideLoadingView()
                switch event{
                case .next(let e):
                    printDebugLog(message: e)
                    weakSelf?.intoNextApprovalSuccessView()
                case .error(let e):
                    try? weakSelf?.validateHttp(e)
                case .completed:
                    print("finish")
                }
            }.addDisposableTo((weakSelf?.bag)!)
        
        
    }
    
    
    
    //提交按钮的点击事件
    func commitOpinionClk()
    {
        let  commitContentStr:String = myTopTextView.text
        print("commitOpinionClk ^_^  \(commitContentStr)")
        
        
        if !isNewVersionParams  && !isAgreeOrderParams //老版的   审批拒绝
        {
            let alertController = UIAlertController(title: "", message: NSLocalizedString("order.opinion.approval.is.reject", comment:"审批拒绝?"),preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: NSLocalizedString("common.validate.cancel", comment:"取消"), style: .cancel, handler: nil)
            cancelAction.setValue(TBIThemePrimaryTextColor, forKey: "_titleTextColor")
            let okAction = UIAlertAction(title: NSLocalizedString("common.validate.ok", comment:"确定"), style: .default, handler:
            {action in
                
                let rejectBean = CoOldExanimeForm.Reject(comment: commitContentStr, currentApverId: self.currentApverIdParams, currentApvLevel: self.currentApvLevelParams)
                
                self.showLoadingView()
                let coOldExanimeService = CoOldExanimeService.sharedInstance
                coOldExanimeService.agree(self.orderNoParams, form: rejectBean).subscribe{ event in
                    self.hideLoadingView()
                    if case .next(let e) = event
                    {
                        print("=^_^==reject==成功======")
                        
                        // 新需求 拒绝 也需要跳转至 提交成功页面
                        // start of line
                        let vc = CoApprovalSuccessController()
                        vc.type = .approval
                        self.navigationController?.pushViewController(vc , animated: true)
                    }
                    if case .error(let e) = event
                    {
//                        print("===reject==失败======")
//                        print(e)
//                        
//                        if ((e as? HttpError) != nil)
//                        {
//                            self.tipNetWorkError(httpError: e as! HttpError)
//                        }
                        
                        print("=====失败======\n \(e)")
                        //处理异常
                        try? self.validateHttp(e)
                        
                    }
                    }.disposed(by: self.bag) 
                
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
        else if isNewVersionParams  && !isAgreeOrderParams  //新版的  审批拒绝
        {
            let alertController = UIAlertController(title: "", message: NSLocalizedString("order.opinion.approval.is.reject", comment:"审批拒绝?"),preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: NSLocalizedString("common.validate.cancel", comment:"取消"), style: .cancel, handler: nil)
            cancelAction.setValue(TBIThemePrimaryTextColor, forKey: "_titleTextColor")
            let okAction = UIAlertAction(title: NSLocalizedString("common.validate.ok", comment:"确定"), style: .default, handler:
            {action in
                
                let rejectBean = CoNewExanimeForm.Reject(comment: commitContentStr)
                self.showLoadingView()
                let coNewExanimeService = CoNewExanimeService.sharedInstance
                coNewExanimeService.agree(self.orderNoParams, form: rejectBean).subscribe{ event in
                    self.hideLoadingView()
                    if case .next(let e) = event
                    {
                        print("=^_^==reject==成功======")
                        
                        // 新需求 拒绝 也需要跳转至 提交成功页面
                        // start of line
                        let vc = CoApprovalSuccessController()
                        vc.type = .approval
                        self.navigationController?.pushViewController(vc , animated: true)
                        
                        // end of line
                        
                    }
                    if case .error(let e) = event
                    {
                        print("=====失败======\n \(e)")
                        //处理异常
                        try? self.validateHttp(e)
                        
                    }
                    }.disposed(by: self.bag)
                
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
        else if isNewVersionParams  && isAgreeOrderParams  //新版的  审批同意
        {
            let alertController = UIAlertController(title: "", message: NSLocalizedString("order.approval.order.ispass", comment:"通过审批?"),preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: NSLocalizedString("common.validate.cancel", comment:"取消"), style: .cancel, handler: nil)
            cancelAction.setValue(TBIThemePrimaryTextColor, forKey: "_titleTextColor")
            let okAction = UIAlertAction(title: NSLocalizedString("common.validate.ok", comment:"确定"), style: .default, handler:
            {action in
                
                let agreeBean = CoNewExanimeForm.Agree(comment: commitContentStr, currentApverLevel: self.currentApvLevelParams)
                
                self.showLoadingView()
                let coNewExanimeService = CoNewExanimeService.sharedInstance
                coNewExanimeService.agree(self.orderNoParams, form: agreeBean).subscribe{ event in
                    self.hideLoadingView()
                    if case .next(_) = event
                    {
                        print("=^_^==agree==成功======")
                      
                        let vc = CoApprovalSuccessController()
                        vc.type = .approval
                        self.navigationController?.pushViewController(vc , animated: true)
                        
                    }
                    if case .error(let e) = event
                    {
                        print("===agree==失败======")
                        
                        print("=====失败======\n \(e)")
                        //处理异常
                        try? self.validateHttp(e)
                        
                    }
                    }.disposed(by: self.bag)
                
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
        
    }
    
    
    /// 进入审批成功页面
    func intoNextApprovalSuccessView() {
        let vc = CoApprovalSuccessController()
        vc.type = .approval
        self.navigationController?.pushViewController(vc , animated: true)
    }
    
    
}



extension CoApprovalOpinionController:UITextViewDelegate
{
    public func textViewDidChange(_ textView: UITextView)
    {
        print("textViewDidChange   \(textView.text)")
        
        if (myTopTextView.text == nil) || (myTopTextView.text == "")
        {
            myPlaceHolderLabel.text = NSLocalizedString("order.opinion.approval.writecontent.hint", comment: "请您填写审批意见")   //"请您填写审批意见"
        }
        else
        {
            myPlaceHolderLabel.text = ""
        }
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n"{
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    //提示网络连接异常
    func tipNetWorkError(httpError:HttpError?) -> Void
    {
        if let error = httpError
        {
            switch error
            {
            case .timeout:
                
                self.showSystemAlertView(titleStr: NSLocalizedString("common.validate.hint", comment:"提示"), message: NSLocalizedString("common.validate.fail", comment:"失败"))
                
            case .serverException(let code,let message):
                print(message+"\(code)")
                self.showSystemAlertView(titleStr: NSLocalizedString("common.validate.hint", comment:"提示"), message: message)
                
            default :
                printDebugLog(message: "into here ...")
            }
        }
    }
}
