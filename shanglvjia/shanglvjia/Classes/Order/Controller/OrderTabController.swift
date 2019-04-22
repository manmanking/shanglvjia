//
//  OrderTabController.swift
//  shop
//
//  Created by akrio on 2017/6/19.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class OrderTabController: CompanyBaseViewController {
    let titleView = HomeTitleView()
    //标题和内容
    var pageTitleView:SGPageTitleView?
    var pageContentView:SGPageContentView?
    
    var selectItemsIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor=UIColor.white
        self.automaticallyAdjustsScrollViewInsets = false
   
        // 设置 UI
        setupUIView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.setNavigationColor()
        setTitleView()
        setNavigationImage()
    }
    //图片加载
    func setNavigationImage() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor=UIColor.white
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        
        /// 新版订单更新
        setNavigationBackButton(backImage: "left")
    }

    
    func setTitleView() {
        self.setTitle(titleStr: "我的订单",titleColor:TBIThemePrimaryTextColor)
        
    }
    
    override func backButtonAction(sender:UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
extension OrderTabController
{
    func setupUIView(){
        let configuration = SGPageTitleViewConfigure()
        configuration.titleColor=UIColor.gray
        configuration.titleFont=UIFont.systemFont(ofSize: 14)
        configuration.titleSelectedColor=TBIThemeDarkBlueColor
        configuration.indicatorColor=TBIThemeDarkBlueColor
        configuration.titleSelectedFont=UIFont.boldSystemFont(ofSize: 15)
        configuration.indicatorHeight = 3;
        configuration.bottomSeparatorColor=TBIThemeGrayLineColor
        
        var titleArr=[String]()
        let userDetail = UserService.sharedInstance.userDetail()
        if userDetail?.companyUser?.companyCode == "FTMS" {
            titleArr=["全部","计划中","待订妥","已订妥"]
        }else{
            titleArr=["全部","计划中","审批中","待订妥","已订妥"]
        }
        
        //标题视图
        self.pageTitleView=SGPageTitleView(frame:CGRect(x:0,y:0,width:Int(ScreenWindowWidth),height:45),delegate:self,titleNames:titleArr,configure:configuration)
        self.pageTitleView?.selectedIndex=selectItemsIndex
        self.pageTitleView?.backgroundColor=TBIThemeWhite
        
        self.pageTitleView?.layer.shadowColor=UIColor.gray.cgColor
        self.pageTitleView?.layer.shadowOffset=CGSize(width: 0, height: 0)
        self.pageTitleView?.layer.shadowOpacity=0.5
        for i in 0...(titleArr.count-1) {
            let myOrderTableVC = MyOrderViewController()
            myOrderTableVC.stateStr=titleArr[i]
            self.addChildViewController(myOrderTableVC)
        }
        
        // 内容视图
        self.pageContentView = SGPageContentView(frame: CGRect(x: 0, y: 45, width:Int(ScreenWindowWidth), height: Int(ScreentWindowHeight) - 45), parentVC: self, childVCs: self.childViewControllers)
        self.pageContentView!.delegatePageContentView = self
        self.view.addSubview(self.pageContentView!)
        self.view.addSubview(self.pageTitleView!)
       
        
    }
}
////MARK: - SGPageTitleViewDelegate
extension OrderTabController: SGPageTitleViewDelegate, SGPageContentViewDelegate {
    /// 联动 pageContent 的方法
    func pageTitleView(_ pageTitleView: SGPageTitleView!, selectedIndex: Int) {
        
        self.pageContentView!.setPageContentViewCurrentIndex(selectedIndex)
        // 修改完订单状态之后 回到列表页面需要修改订单状态
        // add by manman start of line  2018-06-27
        // 刷新改页面状态
        // 有了新方法 丢掉
//        let viewController:MyOrderViewController = self.childViewControllers[selectedIndex] as! MyOrderViewController
//        viewController.initData()
        
        // end of line
        
    }
    
    /// 联动 SGPageTitleView 的方法
    func pageContentView(_ pageContentView: SGPageContentView!, progress: CGFloat, originalIndex: Int, targetIndex: Int) {
        self.pageTitleView!.setPageTitleViewWithProgress(progress, originalIndex: originalIndex, targetIndex: targetIndex)
    }
}


