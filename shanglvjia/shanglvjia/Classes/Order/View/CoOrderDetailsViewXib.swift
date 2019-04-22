//
//  CoOldOrderDetailsViewXib.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/5/23.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit


class CoOrderDetailsViewXib:UIView
{
    //送审订单
    static let STATUS_BTN_TO_REVIEW = 1001
    //提交订单
    static let STATUS_BTN_COMMIT_ORDER = 1002
    //撤回订单
    static let STATUS_BTN_BACK_ORDER = 1003
    
    
    //取消送审
    static let CANCEL_REVIEW_CLK = "CANCEL_REVIEW_CLK"
    //去送审
    static let TO_REVIEW_CLK = "TO_REVIEW_CLK"
    
    //是否为新版的订单
    static var isNewVersionOrder:Bool = false
    
    //容器视图 ： 取消和送审的容器视图
    let bottom2BtnContainerView = UIView()
    
    var bottomLeftCancelBtn:UIButton!
    var bottomRightReViewBtn:UIButton!
    
    
    let screenWidth:Int = Int(UIScreen.main.bounds.size.width)
    let screenHeight:Int = Int(UIScreen.main.bounds.size.height)
    
    let tableViewCell_reuseIdentifier="CoOldOrderDetailsTableCellView"
    
    /// 表格
    var myTableView: UITableView!
    
    var tableHeadView:CoOrderDetailsTableHeadView? = nil
    
    
    // add by manman  FTMS 丰田销售定制化
    
    public var  tableCustomHeaderView:OrderDetailCompanyTableHeaderView?

    //设置 当前视图底部的送审和取消送审按钮的   事件监听器
    var onContentFooterListener:OnMyTableViewFooterListener!
    
    var tableFooterView:CoOrderDetailsFooterView!
    
    
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        initView()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initView() -> Void
    {
        
        let frame0 = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height-54)
        self.myTableView = UITableView(frame: frame0, style: .plain)
        self.addSubview(myTableView)
        self.myTableView.backgroundColor =  TBIThemeBaseColor         //f5f5f9
        
        addBottomViewReviewAndCancelBtn()
        
        
        tableFooterView=Bundle.main.loadNibNamed("CoOldOrderDetailsFooterView", owner: nil, options: nil)?.first as! CoOrderDetailsFooterView
        
        //去掉TableView的默认分割线
        myTableView.separatorStyle = .none
        
        // 设置 tabelView 行高,自动计算行高
        myTableView.rowHeight = UITableViewAutomaticDimension;
        // 设置预估行高 --> 先让 tableView 能滚动，在滚动的时候再去计算显示的 cell 的真正的行高，并且调整 tabelView 的滚动范围
        myTableView.estimatedRowHeight = 2

        
        if CoOrderDetailsViewXib.isNewVersionOrder   //新版   (该高度包含 一个 自定义的字段)
        {
            tableHeadView = CoOrderDetailsTableHeadView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 609))
        }
        else     //老版
        {
            //tableHeadView = CoOrderDetailsTableHeadView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 100))
            tableHeadView = CoOrderDetailsTableHeadView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 400))
        }
        
        
        //丰田销售定制化 version second 
        // start of line
//        if tableCustomHeaderView != nil {
//            myTableView.tableHeaderView = tableCustomHeaderView
//        }else
//        {
//           myTableView.tableHeaderView = tableHeadView
//        }
//        
        
        // end of line  
        myTableView.tableHeaderView = tableHeadView
        myTableView.tableFooterView = tableFooterView
    }
    
    func setFTMSCustomUIViewAutolayout() {
        myTableView.tableHeaderView = tableCustomHeaderView
    }
    
    
    
    
    
    
    
    
    
    
    
    //TODO:设置企业版新版的头部新增的界面
    func updateNewVersionHeadViewSize() -> Void
    {
        if tableHeadView?.newVersionDIYDataSource.count == 0
        {
            //tableHeadView?.frame.size.height = 582 - (17+25+25)
            //tableHeadView?.frame.size.height = 609 - (17+25+25)
            tableHeadView?.frame.size.height = 609 - (20 + 25 * 3)//modify by manman
        }
        else if (tableHeadView?.newVersionDIYDataSource.count)! > 1
        {
            let dataCount:CGFloat = CGFloat((tableHeadView?.newVersionDIYDataSource.count)!)
            
            
            //tableHeadView?.frame.size.height = CGFloat(582 + (dataCount-1.0)*(8+18))
            tableHeadView?.frame.size.height = CGFloat(609 + (dataCount-1.0)*(8+18))
        }
    }
    
    
    //添加底部的View   取消和送审Btn
    func addBottomViewReviewAndCancelBtn() -> Void
    {
        bottom2BtnContainerView.backgroundColor = .red
        
        self.addSubview(bottom2BtnContainerView)
        //bottom2BtnContainerView.backgroundColor = UIColor.black
        bottom2BtnContainerView.snp.makeConstraints{(make)->Void in
            make.left.bottom.right.equalTo(0)
            make.height.equalTo(54)
        }
        
        let leftCancelBtn = UIButton(title: "取消", titleColor: .white, titleSize: 18)
        self.bottomLeftCancelBtn = leftCancelBtn
        bottom2BtnContainerView.addSubview(leftCancelBtn)
        leftCancelBtn.backgroundColor = TBIThemeRedColor
        leftCancelBtn.snp.makeConstraints{(make)->Void in
            make.left.top.bottom.equalTo(0)
            make.width.equalTo(self.bounds.size.width/2)
        }
        //取消送审
        leftCancelBtn.addOnClickListener(target: self, action: #selector(cancelReViewClk))
        
        let rightReViewBtn = UIButton(title: "送审", titleColor: .white, titleSize: 18)
        self.bottomRightReViewBtn = rightReViewBtn
        bottom2BtnContainerView.addSubview(rightReViewBtn)
        rightReViewBtn.backgroundColor = TBIThemeGreenColor
        rightReViewBtn.snp.makeConstraints{(make)->Void in
            make.right.top.bottom.equalTo(0)
            make.width.equalTo(self.bounds.size.width/2)
        }
        //去送审
        rightReViewBtn.addOnClickListener(target: self, action: #selector(toReViewClk))
        
    }
    
    
    
    //取消送审
    func cancelReViewClk() -> Void
    {
        //print("cancelReViewClk")
        if onContentFooterListener != nil
        {
            onContentFooterListener.onClickListener(tableViewFooter: self, flagStr: CoOrderDetailsViewXib.CANCEL_REVIEW_CLK)
        }
    }
    
    //去送审
    func toReViewClk() -> Void
    {
        //print("toReViewClk")
        if onContentFooterListener != nil
        {
            onContentFooterListener.onClickListener(tableViewFooter: self, flagStr: CoOrderDetailsViewXib.TO_REVIEW_CLK)
        }
    }
    
}
