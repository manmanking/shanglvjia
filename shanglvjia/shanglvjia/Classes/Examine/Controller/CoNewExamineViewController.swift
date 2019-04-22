//
//  CoNewExamineViewController.swift
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
class CoNewExamineViewController: CompanyBaseViewController {
    
    fileprivate let managerSVArr:[(key:Int,value:[QueryApproveResponseVO.ApprovePerInfo])] = Array()
    public var orderNoArr:[String] = Array()
    public var orderType:String = ""
    
    public var newExamineViewType:NewExamineViewType = NewExamineViewType.Default
    
    public var approveGroupInfos:QueryApproveResponseVO.ApproveGroupInfo = QueryApproveResponseVO.ApproveGroupInfo()
    fileprivate let orderService = CoNewOrderService.sharedInstance
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
        //        UserDefaults.standard.set("301_239b0461d2134fb7a51e029e6b2b70b0", forKey: TOKEN_KEY)
        self.view.backgroundColor = TBIThemeBaseColor
        //        //模拟数条审批人信息
        //        let m1 = CoManagerListItem(apverName: "张三", apverUid: "1", apverEmails: ["1@qq.com"])
        //        let m2 = CoManagerListItem(apverName: "李四", apverUid: "2", apverEmails: ["2@qq.com"])
        //        let m3 = CoManagerListItem(apverName: "王五", apverUid: "3", apverEmails: ["3@qq.com"])
        //        let ms = [m1,m2,m3]
        //        managers.append((key:1,value:ms))
        //        managers.append((key:2,value:ms))
        //        managers.append((key:3,value:ms))
        
       // getManagers()
        fillLocalData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setBlackTitleAndNavigationColor(title: "填写送审信息")
    }
    
    
    
    func fillLocalData() {
        
        if approveGroupInfos.approveParInfo.firstLevel.count > 0 {
            var tmpGroup:[CoManagerListItem] = Array()
            for elemnt in approveGroupInfos.approveParInfo.firstLevel {
                let item:CoManagerListItem = CoManagerListItem.init(apverName:elemnt.parName , apverUid:elemnt.parId , apverEmails: [""])
                tmpGroup.append(item)
            }
            
            managers.append((key:1 , value: tmpGroup))
        }
        if approveGroupInfos.approveParInfo.secondLevel.count > 0 {
            var tmpGroup:[CoManagerListItem] = Array()
            for elemnt in approveGroupInfos.approveParInfo.secondLevel {
                let item:CoManagerListItem = CoManagerListItem.init(apverName:elemnt.parName , apverUid:elemnt.parId , apverEmails: [""])
                tmpGroup.append(item)
            }
            
            managers.append((key:2 , value: tmpGroup))
        }
        if approveGroupInfos.approveParInfo.thirdLevel.count > 0 {
            var tmpGroup:[CoManagerListItem] = Array()
            for elemnt in approveGroupInfos.approveParInfo.thirdLevel {
                let item:CoManagerListItem = CoManagerListItem.init(apverName:elemnt.parName , apverUid:elemnt.parId , apverEmails: [""])
                tmpGroup.append(item)
            }
            
            managers.append((key:3 , value: tmpGroup))
        }
        if approveGroupInfos.approveParInfo.forthLevel.count > 0 {
            var tmpGroup:[CoManagerListItem] = Array()
            for elemnt in approveGroupInfos.approveParInfo.forthLevel {
                let item:CoManagerListItem = CoManagerListItem.init(apverName:elemnt.parName , apverUid:elemnt.parId , apverEmails: [""])
                tmpGroup.append(item)
            }
            
            managers.append((key:4 , value: tmpGroup))
        }
        if approveGroupInfos.approveParInfo.fifthLevel.count > 0 {
            var tmpGroup:[CoManagerListItem] = Array()
            for elemnt in approveGroupInfos.approveParInfo.fifthLevel {
                let item:CoManagerListItem = CoManagerListItem.init(apverName:elemnt.parName , apverUid:elemnt.parId , apverEmails: [""])
                tmpGroup.append(item)
            }
            
            managers.append((key:5 , value: tmpGroup))
        }
        
        for (index,manager) in self.managers.enumerated() {
            if let firlstManager = manager.value.first {
                let apperView = Bundle.main.loadNibNamed("SelectApperItemView", owner: nil, options: nil)?.first as! SelectApperItemView
                apperView.setTitle(manager.key)
                apperView.mailLabel.text = ""
                apperView.nameLabel.text = firlstManager.apverName
                apperView.id = firlstManager.apverUid
                self.view.addSubview(apperView)
                apperView.snp.makeConstraints{ make in
                    make.left.right.equalTo(self.view)
                    make.height.equalTo(60)
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
        
        self.submitBtn = Bundle.main.loadNibNamed("BaseButton", owner: nil, options: nil)?.first as! BaseButton
        self.submitBtn.setTitle("确认送审", for: .normal)
        self.submitBtn.backgroundColor=TBIThemeDarkBlueColor
        self.view.addSubview(self.submitBtn)
        self.submitBtn.snp.makeConstraints{ make in
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
            make.top.equalTo(self.managersView.last!.snp.bottom).offset(30)
            make.height.equalTo(46)
            
        }
        self.submitBtn.addTarget(self, action: #selector(self.submitClick(sender:)), for: .touchUpInside)
        
        
        
    }
    
    
    func getManagers() {
        showLoadingView()
        orderService.getManagers("").subscribe{ event in
            self.hideLoadingView()
            switch event {
            case .next(let e):
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
                
                self.submitBtn = Bundle.main.loadNibNamed("BaseButton", owner: nil, options: nil)?.first as! BaseButton
                self.submitBtn.setTitle("确认送审", for: .normal)
                self.view.addSubview(self.submitBtn)
                self.submitBtn.snp.makeConstraints{ make in
                    make.left.equalTo(self.view).offset(20)
                    make.right.equalTo(self.view).offset(-20)
                    make.top.equalTo(self.managersView.last!.snp.bottom).offset(30)
                    make.height.equalTo(46)
                    
                }
                self.submitBtn.addTarget(self, action: #selector(self.submitClick(sender:)), for: .touchUpInside)
            case .error(let e):
                try? self.validateHttp(e)
            case .completed:
                break
            }
            }.addDisposableTo(self.bag)
    }
    
    
    func submitClick(sender: UIButton) {
        submitApproval()
    }
    
    
    func submitApproval() {
        let submitApproveVO:SubmitApproveVO = SubmitApproveVO()
        
        let submitApproveInfo:SubmitApproveVO.SubmitApproveInfo = SubmitApproveVO.SubmitApproveInfo()
        submitApproveInfo.approveId = approveGroupInfos.aproveId
        submitApproveInfo.approveLevel = approveGroupInfos.approveLevel
        for element in orderNoArr {
            let approveOrderInfo:SubmitApproveVO.ApproveOrderInfo = SubmitApproveVO.ApproveOrderInfo()
            approveOrderInfo.orderId = element
            approveOrderInfo.orderType = orderType
            submitApproveInfo.approveOrderInfos.append(approveOrderInfo)
        }
        
        for element in managersView {
            let approveParInfo:SubmitApproveVO.ApproveParInfo = SubmitApproveVO.ApproveParInfo()
            approveParInfo.approveLevel = element.level.description
            approveParInfo.parId = element.id
            approveParInfo.parName = element.nameLabel.text ?? ""
            submitApproveInfo.approveParInfos.append(approveParInfo)
        }
        submitApproveVO.submitApproveInfos.append(submitApproveInfo)
        
        self.showLoadingView()
        HomeService.sharedInstance.submitApproval(request:submitApproveVO)
            .subscribe{event in
            self.hideLoadingView()
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
    }
    
    func submitOldApproval() {
        //获取用户输入项
        let apvIds = managersView.map{ "\($0.id)|\($0.level)"}
        self.showLoadingView()
        orderService.submit("", apvIds: apvIds).subscribe{event in
            self.hideLoadingView()
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func backButtonAction(sender:UIButton) {
        switch newExamineViewType {
        case .OrderPlanSubmit:
            self.navigationController?.popViewController(animated: true)
        case .OrderSuccessSubmit:
            self.navigationController?.popToRootViewController(animated: true)
        case .Default:
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        //self.navigationController?.popViewController(animated: true)
    }
    
    
    enum NewExamineViewType:NSInteger {
        case OrderPlanSubmit = 1 // 计划中订单送审
        case OrderSuccessSubmit = 2 // 生单成功 送审
        case Default = 10
    }
    
    
    
}
/// 在菜单中的审批人实体
struct ApperItem {
    /// 唯一标示
    let id:String
    /// 姓名
    let name:String
    /// 邮箱
    let mail:String
}
