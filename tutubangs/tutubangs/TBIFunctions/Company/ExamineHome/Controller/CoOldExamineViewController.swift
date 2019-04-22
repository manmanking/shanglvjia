//
//  CoOldExamineViewController.swift
//  shop
//
//  Created by akrio on 2017/6/1.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

private let apperItemHeight:Float = 85
private let reasonItemHeight:Float = 50
class CoOldExamineViewController: CompanyBaseViewController {
    var orderNo = "200053608"
    fileprivate let orderService = CoOldOrderService.sharedInstance
    fileprivate let bag = DisposeBag()
    fileprivate var managers:[(key:Int,value:[CoManagerListItem])] = []
    fileprivate var managersView:[SelectApperItemView] = []
    fileprivate var reasons:[String] = ["因公出差","外出探亲"]
    var reasonFrom:SelectReasonItemView = SelectReasonItemView()
    var descriptionFrom:ExamineFormItemView = ExamineFormItemView()
    var submitBtn:BaseButton = BaseButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBackButton(backImage: "back")
        self.setTitle(titleStr: "填写送审信息")
//        UserDefaults.standard.set("301_77507d86735f4ab18720fbe56ab50f01", forKey: TOKEN_KEY)
        self.view.backgroundColor = TBIThemeBaseColor
        //        //模拟数条审批人信息
        //        let m1 = CoManagerListItem(apverName: "张三", apverUid: "1", apverEmails: ["1@qq.com"])
        //        let m2 = CoManagerListItem(apverName: "李四", apverUid: "2", apverEmails: ["2@qq.com"])
        //        let m3 = CoManagerListItem(apverName: "王五", apverUid: "3", apverEmails: ["3@qq.com"])
        //        let ms = [m1,m2,m3]
        //        managers.append((key:1,value:ms))
        //        managers.append((key:2,value:ms))
        //        managers.append((key:3,value:ms))
        showLoadingView()
        orderService.getManagers(self.orderNo).subscribe{ event in
            self.hideLoadingView()
            if case .next(let e) = event {
                self.managers = e
                for (index,manager) in self.managers.enumerated() {
                    if let firlstManager = manager.value.first {
                        let apperView = Bundle.main.loadNibNamed("SelectApperItemView", owner: nil, options: nil)?.first as! SelectApperItemView
                        apperView.setTitle(manager.key)
                        apperView.mailLabel.text = firlstManager.apverEmails.first
                        apperView.nameLabel.text = firlstManager.apverName
                        apperView.id = firlstManager.apverUid
                        self.view.addSubview(apperView)
                        apperView.snp.makeConstraints{ make in
                            make.left.right.equalTo(self.view)
                            make.height.equalTo(86)
                            if index == 0 {
                                make.top.equalTo(self.view)
                            }else {
                                make.top.equalTo(self.managersView.last!.snp.bottom)
                            }
                        }
                        //添加点击事件
                        apperView.clickCallback = {id in
                            self.showAppers(index,id)
                        }
                        
                        self.managersView.append(apperView)
                    }
                    
                }
                
                self.reasonFrom = Bundle.main.loadNibNamed("SelectReasonItemView", owner: nil, options: nil)?.first as! SelectReasonItemView
                self.reasonFrom.titleLabel.text = "出差原因"
                self.reasonFrom.textField.placeholder = "请选择出差原因"
                self.view.addSubview(self.reasonFrom)
                self.reasonFrom.snp.makeConstraints{ make in
                    make.left.right.equalTo(self.view)
                    make.top.equalTo(self.managersView.last!.snp.bottom)
                    make.height.equalTo(44)
                    
                }
                self.reasonFrom.textField.isUserInteractionEnabled = false
                self.reasonFrom.textClickCallback = { id,_ in
                    self.showReasons(id)
                }
                self.descriptionFrom = Bundle.main.loadNibNamed("ExamineFormItemView", owner: nil, options: nil)?.first as! ExamineFormItemView
                self.descriptionFrom.titleLabel.text = "出差说明"
                self.descriptionFrom.textField.placeholder = "请输入出差事由"
                self.view.addSubview(self.descriptionFrom)
                self.descriptionFrom.snp.makeConstraints{ make in
                    make.left.right.equalTo(self.view)
                    make.top.equalTo(self.reasonFrom.snp.bottom)
                    make.height.equalTo(44)
                    
                }
                self.submitBtn = Bundle.main.loadNibNamed("BaseButton", owner: nil, options: nil)?.first as! BaseButton
                self.submitBtn.setTitle("确认送审", for: .normal)
                self.submitBtn.setBackgroundImage(UIImage (named: "yellow_btn_gradient"), for: UIControlState.normal)
                self.view.addSubview(self.submitBtn)
                self.submitBtn.snp.makeConstraints{ make in
                    make.left.equalTo(self.view).offset(20)
                    make.right.equalTo(self.view).offset(-20)
                    make.top.equalTo(self.descriptionFrom.snp.bottom).offset(30)
                    make.height.equalTo(46)
                    
                }
                self.submitBtn.addTarget(self, action: #selector(self.submitClick(sender:)), for: .touchUpInside)
//                let descriptionValid = self.descriptionFrom.textField.rx.text.orEmpty.map{
//                    $0.characters.count > 0
//                }
                let descriptionValid = self.reasonFrom.textField.rx.text.orEmpty.map{
                    $0.characters.count > 0
                }
                Observable
                    .combineLatest([descriptionValid]){ $0.reduce(true){$0&&$1} && self.reasonFrom.textField.text?.isNotEmpty ?? false }
                    .do(onNext: { validate in
                        if validate {
                            self.submitBtn.setBackgroundImage(UIImage (named: "yellow_btn_gradient"), for: UIControlState.normal)
                        }else {
                            self.submitBtn.backgroundColor = UIColor.gray
                        }
                    })
                    .bind(to: self.submitBtn.rx.isEnabled)
                    .addDisposableTo(self.bag)
            }
            if case .error(let e) = event {
                try? self.validateHttp(e)
            }
            }.addDisposableTo(self.bag)
    }
    
    func submitClick(sender: UIButton) {
        //获取用户输入项
        let apvIds = managersView.map{ "\($0.id)|\($0.level)"}
        let reason = reasonFrom.id
        let description = descriptionFrom.textField.text
        let form = CoOldOrderForm.Submit( firstApverId: managersView.first?.id ?? "", firstApverName: managersView.first?.nameLabel.text ?? "", apverIds: apvIds, purpose: reason, description: description ?? "")
        self.showLoadingView()
        orderService.submitOrder(self.orderNo,form).subscribe{event in
            switch event {
            case .next(_):
                let controller = CoApprovalSuccessController()
                self.navigationController?.pushViewController(controller, animated: true)
            case .error(let e):
                try? self.validateHttp(e)
            case .completed:
                self.hideLoadingView()
            }
            }.addDisposableTo(bag)
        print(form)
    }
    /// 展示对应级别审批人
    ///
    /// - Parameter index: 对应级别
    func showAppers(_ managerIndex:Int,_ selectId:String) {
        let menuView = Bundle.main.loadNibNamed("SelectGroupView", owner: nil, options: nil)?.first as! SelectGroupView
        KeyWindow?.addSubview(menuView)
        menuView.snp.makeConstraints{ make in
            make.left.right.bottom.top.equalTo(KeyWindow!)
            
        }
        let arr = managers[managerIndex].value
        var itemViews:[ApperMenuItem] = []
        for (index,apper) in arr.enumerated() {
            let apperMenuItem = Bundle.main.loadNibNamed("ApperMenuItem", owner: nil, options: nil)?.first as! ApperMenuItem
            menuView.scrollerView.addSubview(apperMenuItem)
            apperMenuItem.mailLabel.text = apper.apverEmails.first
            apperMenuItem.nameLabel.text = apper.apverName
            apperMenuItem.id = apper.apverUid
            apperMenuItem.snp.makeConstraints{ make in
                make.left.right.width.equalTo(menuView.scrollerView)
                if let last = itemViews.last {
                    make.top.equalTo(last.snp.bottom)
                }else{
                    //如果是第一个选择顶对齐
                    make.top.equalTo(menuView.scrollerView)
                }
                make.height.equalTo(apperItemHeight)
                //如果是最后一个设置bottom
                if index == arr.count - 1 {
                    make.bottom.equalTo(menuView.scrollerView).offset(1)
                }
            }
            itemViews.append(apperMenuItem)
            //同时监听点击事件
            apperMenuItem.clickCallback = { id in
                print(id)
                //获取选中审批人
                let selectApper =  arr.first{ $0.apverUid == id }!
                self.managersView[managerIndex].mailLabel.text = selectApper.apverEmails.first
                self.managersView[managerIndex].nameLabel.text = selectApper.apverName
                self.managersView[managerIndex].id = selectApper.apverUid
                menuView.removeFromSuperview()
            }
            //勾选选中项
            if apper.apverUid == selectId{
                apperMenuItem.selectImage.isHidden = false
            }
        }
        //根据审批人数量动态调整弹出高度
        if arr.count > 3 {
            menuView.menuView.snp.remakeConstraints{ make in
                make.height.equalTo(400)
            }
        }else {
            menuView.menuView.snp.updateConstraints{ make in
                let height = Float(arr.count) * apperItemHeight + menuView.bottomHeight
                make.height.equalTo(height - 1)
            }
            
        }
        
    }
    func showReasons(_ id:String) {
        let menuView = Bundle.main.loadNibNamed("SelectGroupView", owner: nil, options: nil)?.first as! SelectGroupView
        KeyWindow?.addSubview(menuView)
        menuView.snp.makeConstraints{ make in
            make.left.right.bottom.top.equalTo(KeyWindow!)
            
        }
        var itemViews:[SelectItemView] = []
        for (index,reason) in reasons.enumerated() {
            let reasonItem = Bundle.main.loadNibNamed("SelectItemView", owner: nil, options: nil)?.first as! SelectItemView
            menuView.scrollerView.addSubview(reasonItem)
            reasonItem.nameLabel.text = reason
            reasonItem.id = reason
            reasonItem.snp.makeConstraints{ make in
                make.left.right.width.equalTo(menuView.scrollerView)
                if let last = itemViews.last {
                    make.top.equalTo(last.snp.bottom)
                }else{
                    //如果是第一个选择顶对齐
                    make.top.equalTo(menuView.scrollerView)
                }
                make.height.equalTo(reasonItemHeight)
                //如果是最后一个设置bottom
                if index == reasons.count - 1 {
                    make.bottom.equalTo(menuView.scrollerView).offset(1)
                }
            }
            itemViews.append(reasonItem)
            //同时监听点击事件
            reasonItem.clickCallback = { id in
                print(id)
                //获取选中审批人
                self.reasonFrom.id = id
                self.reasonFrom.textField.text = id
//                let descriptionFromNotEmpty = self.descriptionFrom.textField.text?.isEmpty ?? false
//                if !descriptionFromNotEmpty {
//                    self.submitBtn.backgroundColor = TBIThemeBlueColor
//                }else {
//                    self.submitBtn.backgroundColor = UIColor.gray
//                }
                // 2017-10-19 先不判断出差说明字段
                self.submitBtn.setBackgroundImage(UIImage (named: "yellow_btn_gradient"), for: UIControlState.normal)
                self.submitBtn.isEnabled = true//descriptionFromNotEmpty
                menuView.removeFromSuperview()
            }
            //勾选选中项
            if reason == id{
                reasonItem.selectImage.isHidden = false
            }
        }
        //根据审批人数量动态调整弹出高度
        if reasons.count > 4 {
            menuView.menuView.snp.remakeConstraints{ make in
                make.height.equalTo(4 * reasonItemHeight + menuView.bottomHeight)
            }
        }else {
            menuView.menuView.snp.updateConstraints{ make in
                let height = Float(reasons.count) * reasonItemHeight + menuView.bottomHeight
                make.height.equalTo(height - 1)
            }
            
        }
        
    }
    override func backButtonAction(sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
