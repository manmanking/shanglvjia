//
//  TabViewController.swift
//  shop
//
//  Created by akrio on 2017/5/11.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
private var paddingLR:CGFloat = 15 /// 左右边距
class TabViewController: CompanyBaseViewController {
    let titleView = HomeTitleView()
    /// 下方横线高度
    var lineHeight:CGFloat = 2
    /// 下方横线颜色
    var lineColor = TBIThemeDarkBlueColor
    /// tab栏高度
    var tabHeight:CGFloat = 44
    /// tab栏背景色
    var tabColor = UIColor.white
    /// tab栏中默认字体颜色
    var tabItemColor:UIColor =  UIColor.init(r:145/255 , g: 145/255, b: 145/255) // =  UIColor.init()// UIColor(colorLiteralRed: 145/255, green: 145/255, blue: 145/255, alpha: 1)
    var tabBorderColor:UIColor = UIColor.init(r:229/255 , g: 229/255, b: 229/255)// = UIColor(colorLiteralRed: 229/255, green: 229/255, blue: 229/255, alpha: 1)
    /// 总宽度
    var allWidth = UIScreen.main.bounds.size.width
    /// 达到滚动的最小比例,值越大项与项之间间隔越大 (tab全长 - 所有tab项文字的总长度)/(所有tab个数-1[tab项之间空白间隔的个数])
    var scrollerMinScale:CGFloat = 0.17
    /// 默认字体
    var tabFont = UIFont.systemFont(ofSize: 14.0)
    
    var tab:TabModel!
    var selectLine:UIView!
    var tabView:UIScrollView!
    var main:UIScrollView!
    var tabBarItems: [UIButton] = []
    
    var tabBarsItem:[TabBarItem] = []
    /// 是否流出下面 tablebar高度
    var companyHeader:Bool = false
    
    var selectItemsIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if companyHeader {
////            setTitleView()
//        }else{
//            self.setNavigationBackButton(backImage: "back")
//        }
//        initNavigation(title: self.title ?? "")
        
        
        //tabItemColor =
        //UIColor(colorLiteralRed: , green: 145/255, blue: 145/255, alpha: 1)
        //tabBorderColor =
        //UIColor(colorLiteralRed: 229/255, green: 229/255, blue: 229/255, alpha: 1)
        setTitle(titleStr: "订单审批", titleColor: TBIThemePrimaryTextColor)
        setNavigationBgColor(color:TBIThemeWhite)
        setNavigationBackButton(backImage: "left")
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        //setNavigationRightButton(title:"编辑", selectedtitle: "取消")
        automaticallyAdjustsScrollViewInsets = false
        //测试数据
        let tabItems = tabBarsItem.map{TabItem($0.text,font:tabFont)}
        tab = TabModel(tabsItems: tabItems,allWidth:allWidth,scrollerMinScale: scrollerMinScale)
        //初始化tab信息
        self.navigationController?.navigationBar.isTranslucent = false
        tabView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: tabHeight))
        tabView.showsVerticalScrollIndicator = false
        tabView.showsHorizontalScrollIndicator = false
        //绘制下边线
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: tabHeight - 0.5, width: tabView.frame.size.width * CGFloat(tabItems.count), height: 0.5)
        bottomBorder.backgroundColor = tabBorderColor.cgColor
        tabView.layer.addSublayer(bottomBorder)
        //添加tabItem
        var xPoint:CGFloat = paddingLR
        for (index,tabItem) in tab.tabsItems.enumerated() {
            let button = UIButton()
            button.frame.size = CGSize(width: tabItem.size.width, height: tabHeight)
            button.frame.origin = CGPoint(x: xPoint, y: 0)
            button.setTitle(tabItem.title, for: .normal)
            button.titleLabel?.text = tabItem.title
            button.titleLabel?.font = tabItem.font
            button.setTitleColor(tabItemColor, for: .normal)
            button.setTitleColor(lineColor, for: .highlighted)
            button.tag = index
            tabView.addSubview(button)
            xPoint += tabItem.size.width + CGFloat(tab.padding)
            tabBarItems += [button]
            button.addTarget(self, action:#selector(tabItemClick), for: .touchUpInside)
        }
        
        //selectItem(0)
        tabView.contentSize = CGSize(width: xPoint - CGFloat(tab.padding) + 2 * paddingLR, height: tabHeight)
        tabView.backgroundColor = tabColor
        //初始化下方横线
        selectLine = UIView(frame: CGRect(x:paddingLR, y: tabHeight - lineHeight, width: tabItems[0].size.width, height: lineHeight))
        selectLine.backgroundColor = lineColor
        //添加一个scroller到页面中
        let count:CGFloat = CGFloat(tabItems.count)
        var frame = CGRect(x: 0, y: tabHeight + tabView.frame.origin.y, width: self.view.bounds.width, height: self.view.bounds.height - tabHeight - 64 - 50)
        if !companyHeader{
            frame = CGRect(x: 0, y: tabHeight + tabView.frame.origin.y, width: self.view.bounds.width, height: self.view.bounds.height - tabHeight - 64)
        }
        main = UIScrollView(frame: frame)
        main.backgroundColor = UIColor.black
        main.contentSize = CGSize(width: frame.width * count, height: frame.height)
        main.showsHorizontalScrollIndicator = false
        for xPoint in 0..<tabItems.count {
            //添加若干个view
            let tabViewController = tabBarsItem[xPoint].controller
            tabViewController.view.frame = CGRect(x:  CGFloat(xPoint) * main.bounds.width, y: 0, width:main.bounds.width, height: main.bounds.height)
            self.addChildViewController(tabViewController)
            main.addSubview(tabViewController.view)
        }
        //开启分页功能
        main.isPagingEnabled = true
        //滚动到边缘不回弹
        main.bounces = false
        main.delegate = self
        self.view.addSubview(main)
        self.view.addSubview(tabView)
        tabView.addSubview(selectLine)
        selectItems(selectItemsIndex)
    }
    override func viewDidAppear(_ animated: Bool) {
        //        self.view.frame.origin.y = 0
        
        super.viewDidAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var isClick = false
    func tabItemClick(sender:UIButton){
        isClick = true
        let index = sender.tag
        selectItem(index)
        //调整下方线的位置
        UIView.animate(withDuration: 0.3){
            self.selectLine.frame.origin.x = sender.frame.origin.x
            self.selectLine.frame.size.width = sender.frame.size.width
            var linePositionX = self.selectLine.frame.origin.x - self.view.bounds.size.width/2 + self.selectLine.frame.size.width/2
            if (linePositionX < paddingLR){
                linePositionX = paddingLR
            }
            if linePositionX > self.tabView.contentSize.width - self.tabView.bounds.width {
                linePositionX = self.tabView.contentSize.width - self.tabView.bounds.width
            }
            self.main.contentOffset.x = CGFloat(index) * self.tabView.bounds.width
            self.tabView.contentOffset.x = linePositionX - paddingLR
            self.isClick = false
        }
    }
    /// 点亮按钮
    ///
    /// - Parameter index: tabBarItems中的索引
    func selectItem(_ index:Int){
        tabBarItems.forEach{$0.setTitleColor(tabItemColor, for: .normal)}
        tabBarItems[index].setTitleColor(lineColor, for: .normal)
    }
    
    /// 设置默认选中页
    func selectItems(_ index:Int){
        tabItemClick(sender:tabBarItems[index])
    }
    
}
extension TabViewController:UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isClick else {
            return
        }
        let pagerContentOffsetX = scrollView.contentOffset.x
        //滑动比例
        let indexScale = pagerContentOffsetX/scrollView.contentSize.width * CGFloat(tab.tabsItems.count)
        //计算当松开手后，所处的页面index
        let index:Int = lroundf(Float(indexScale));
        //计算当前项之前的总距离
        let preWidth = tab.tabsItems[0..<Int(indexScale)].reduce(CGFloat()){
            $0 + $1.size.width + CGFloat(tab.padding)
        }
        //高亮松开手之后选中项
        selectItem(index)
        //计算tab下方线和scroller滑动比例
        let lineOffset = (indexScale - CGFloat(Int(indexScale))) * (tab.tabsItems[Int(indexScale)].size.width + CGFloat(tab.padding))
        self.selectLine.frame.origin.x = preWidth + lineOffset + paddingLR
        let currentLineWidht = tab.tabsItems[Int(indexScale)].size.width //当前tabitem线长短
        var nextLineWidht:CGFloat = 0
        //调整下方线长短
        if Int(indexScale)+1 > tab.tabsItems.count - 1 {
            nextLineWidht = currentLineWidht
        }else {
            nextLineWidht = tab.tabsItems[Int(indexScale)+1].size.width //趋势tabitem线长短
        }
        let moveScale = indexScale - CGFloat(Int(indexScale)) //移动比例
        self.selectLine.frame.size.width = currentLineWidht + (nextLineWidht - currentLineWidht) * moveScale
        //始终保持下方线居中
        var linePositionX = selectLine.frame.origin.x - self.view.bounds.size.width/2 + selectLine.frame.size.width/2
        if (linePositionX < paddingLR){
            linePositionX = paddingLR
        }
        if linePositionX > tabView.contentSize.width - self.tabView.bounds.width{
            linePositionX = tabView.contentSize.width - self.tabView.bounds.width
        }
        tabView.setContentOffset(CGPoint(x:linePositionX - paddingLR,y:0) , animated: true)
        tabView.contentOffset.x = linePositionX - paddingLR
    }
    func setTitleView() {
        self.navigationItem.titleView = titleView
        if PersonalType {
            active(sender: titleView.businessButton)
        } else {
            active(sender: titleView.personalButton)
        }
        titleView.businessButton.addTarget(self, action: #selector(active(sender:)), for: .touchUpInside)
        titleView.personalButton.addTarget(self, action: #selector(active(sender:)), for: .touchUpInside)
    }
    
    func active(sender: UIButton) {
        switch sender {
        case titleView.personalButton://个人出行
            titleView.businessButton.unActive()
            titleView.businessLabel.isHidden = true
            titleView.personalButton.active()
            titleView.personalLabel.isHidden = false
            PersonalType =  true
        case titleView.businessButton://公务出行
            if islogin(role: nil) {
                return
            }
            titleView.businessButton.active()
            titleView.businessLabel.isHidden = false
            titleView.personalButton.unActive()
            titleView.personalLabel.isHidden = true
            PersonalType =  false
        default:
            break
        }
    }
    
    override func rightButtonAction(sender: UIButton) {
        
        if sender.isSelected == true {
            sender.isSelected = false
            setNavigationBackButton(backImage: "left")
        }else {
            sender.isSelected = true
            setNavigationBackButtonTitle(title: "待审批全选")
        }
    }
    
    
    
    override func backButtonAction(sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
struct TabModel {
    /// 所有tab栏
    var tabsItems:[TabItem]
    var allWidth:CGFloat
    /// 达到滚动的最小比例
    var scrollerMinScale:CGFloat
    var padding:CGFloat {
        //计算所有tab标题宽度
        let tabsWidth = tabsItems.reduce(CGFloat(0)){$0+$1.size.width}
        //计算每个tabItem最小间距
        let minPadding = allWidth * scrollerMinScale
        //如果当前tabItem项间距小于计算的最小间距(minPadding)，则说明需要滚动
        guard (allWidth - tabsWidth)/CGFloat(tabsItems.count - 1) > minPadding else {
            //如果发生滚动，则每个tabItem间距为最小间距(minPadding)
            return minPadding
        }
        //如果不需要滚动则使tabitem平局分布于页面之上
        
        return (allWidth - tabsWidth - 2 * paddingLR)/CGFloat(tabsItems.count - 1)
    }
    init(tabsItems:[TabItem],allWidth:CGFloat = UIScreen.main.bounds.size.width,scrollerMinScale:CGFloat = 0.77) {
        self.tabsItems = tabsItems
        self.allWidth = allWidth
        self.scrollerMinScale = scrollerMinScale
    }
}
/// 每个小标题
struct TabItem {
    /// 标题
    let title:String
    /// 字体
    let font:UIFont
    /// 文字所占大小
    var size:CGSize {
        return NSString(string: title).size(attributes: [NSFontAttributeName: font])
    }
    init(_ title:String,font:UIFont = UIFont.systemFont(ofSize: 14.0)) {
        self.title = title
        self.font = font
    }
}

struct TabBarItem{
    let text:String
    let controller:UIViewController
}
