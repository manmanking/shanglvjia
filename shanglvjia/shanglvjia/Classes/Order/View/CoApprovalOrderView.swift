//
//  CoApprovalOrderView.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/6/6.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class CoApprovalOrderView: UIView
{
    //审批记录的个数
    var footerReviewItemCount = 3
    var footerReviewRecordArray:[(String,String,Bool)] = []
    //审批记录的容器视图
    let view_review_content_container = UIView()
    
    //是否为新版的订单
    static var isNewVersionOrder:Bool = false
    
    //成本中心
    static let COST_CENTER_CLK = "COST_CENTER_CLK"
    
    static let BUSINESS_REASON:String = "BUSINESSREASON"
    
    static let REJECT_APPROVAL = "REJECT_APPROVAL"
    static let AGREE_APPROVAL = "AGREE_APPROVAL"
    
    
    var onTableHeaderListener:OnMyTableViewHeaderListener!
    
    //点击事件的delegate
    var onTableFooterListener:OnMyTableViewFooterListener!
    
    //tableVuiew头部固定的几个字段   新版的9个字段。   老版的七个字段
    var myHeadFixedDataSource:[(String,String)] = []
    
    //新版出差单详情的定制字段
    var newVersionDIYDataSource:[(String,String)] = []
    
    
    var myTableView:UITableView!
    var myTableHeadView:UIView = UIView()
    //TODO:TableVIew的FooterView
    var myTableFooterView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWindowWidth, height: 50))
    
    //当前View的底部视图
    var myContentFooterView:UIView = UIView()
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        initView()
    }

    func initView() -> Void
    {
        myTableView = UITableView(frame: CGRect(x: 0, y: 0, width: ScreenWindowWidth, height: self.frame.size.height-54))
        myTableView.backgroundColor = TBIThemeBaseColor
        
        //setDataSource测试时使用
        //setDataSource()
        setTableHeaderView()
        myTableView.tableHeaderView = self.myTableHeadView
        myTableHeadView.backgroundColor = .white
        //setTableFooterView()
        myTableView.tableFooterView = self.myTableFooterView
        myTableFooterView.backgroundColor = .white
        
        setContentFooterView()
        
        
        //去掉TableView的默认分割线
        myTableView.separatorStyle = .none
        
        // 设置 tabelView 行高,自动计算行高
        myTableView.rowHeight = UITableViewAutomaticDimension;
        // 设置预估行高 --> 先让 tableView 能滚动，在滚动的时候再去计算显示的 cell 的真正的行高，并且调整 tabelView 的滚动范围
        myTableView.estimatedRowHeight = 2
        
        
        self.addSubview(myTableView)
        
    }
    
    //TODO: 测试时使用
    func setDataSource() -> Void
    {
        var myCount = 7
        if CoApprovalOrderView.isNewVersionOrder
        {
            myCount = 9
        }
        
        
        myHeadFixedDataSource = []
        for i in 0..<myCount
        {
            myHeadFixedDataSource.append(("name\(i)","value\(i)"))
        }
        
        if CoApprovalOrderView.isNewVersionOrder
        {
            newVersionDIYDataSource = []
            for i in 0..<0
            {
                newVersionDIYDataSource.append(("left diy \(i)","right diy \(i)"))
            }
        }
    }
    
    //设置Content的Footer布局
    func setContentFooterView() -> Void
    {
        let contentFooterView = myContentFooterView
        
        contentFooterView.frame = CGRect(x: 0, y: self.frame.size.height-54, width: ScreenWindowWidth, height: 54)
        self.addSubview(contentFooterView)
        
        let rejectBtn = UIButton(title: "拒绝", titleColor: UIColor.white, titleSize: 18)
        myContentFooterView.addSubview(rejectBtn)
        rejectBtn.backgroundColor = TBIThemeRedColor
        rejectBtn.snp.makeConstraints{(make)->Void in
            make.left.top.bottom.equalTo(0)
            make.width.equalTo(contentFooterView.frame.size.width/2)
        }
        
        let agreetBtn = UIButton(title: "同意", titleColor: UIColor.white, titleSize: 18)
        myContentFooterView.addSubview(agreetBtn)
        agreetBtn.backgroundColor = TBIThemeGreenColor
        agreetBtn.snp.makeConstraints{(make)->Void in
            make.right.top.bottom.equalTo(0)
            make.width.equalTo(contentFooterView.frame.size.width/2)
        }
        
        
        rejectBtn.addOnClickListener(target: self, action: #selector(rejectApprovalClk))
        agreetBtn.addOnClickListener(target: self, action: #selector(agreeApprovalClk))
    }
    
    
    
    //审批拒绝
    func rejectApprovalClk() -> Void
    {
        if onTableFooterListener != nil
        {
            onTableFooterListener.onClickListener(tableViewFooter: myContentFooterView, flagStr: CoApprovalOrderView.REJECT_APPROVAL)
        }
    }
    
    //审批同意
    func agreeApprovalClk() -> Void
    {
        if onTableFooterListener != nil
        {
            onTableFooterListener.onClickListener(tableViewFooter: myContentFooterView, flagStr: CoApprovalOrderView.AGREE_APPROVAL)
        }
    }
    
    //TODO:设置TableView的Footer布局
    func setTableFooterView() -> Void
    {
        //设置 "审批记录View" 的高度
        var tableFooterHeight = 0
        if footerReviewRecordArray.count > 0
        {
            tableFooterHeight += (71 + 64 + (21+10)*(footerReviewRecordArray.count-1))
        }
        else
        {
            tableFooterHeight += (71 + 64)
        }
        self.myTableFooterView.frame.size.height = CGFloat(tableFooterHeight)
        
        
        let reviewTitleContainer = UIView()
        self.myTableFooterView.addSubview(reviewTitleContainer)
        reviewTitleContainer.snp.makeConstraints{(make)->Void in
            make.left.right.top.equalTo(0)
            make.height.equalTo(44)
        }
        let reviewTitleLabel = UILabel(text: "审批记录", color: TBIThemeTipTextColor, size: 14)
        reviewTitleContainer.addSubview(reviewTitleLabel)
        reviewTitleLabel.snp.makeConstraints{(make)->Void in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
        let reviewTitleBottomSegLine = UIView()
        reviewTitleBottomSegLine.backgroundColor = TBIThemeGrayLineColor
        reviewTitleContainer.addSubview(reviewTitleBottomSegLine)
        reviewTitleBottomSegLine.snp.makeConstraints{(make)->Void in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(0)
            
            make.height.equalTo(1)
        }
        
        let reviewBottom20pxLine = UIView()
        reviewBottom20pxLine.backgroundColor = TBIThemeBaseColor
        self.myTableFooterView.addSubview(reviewBottom20pxLine)
        reviewBottom20pxLine.snp.makeConstraints{(make)->Void in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
            
            make.height.equalTo(20)
        }
        
        //审批记录的内容 的 容器视图 添加 item
        let bigNumArray = ["一","二","三","四","五","六","七","八","九","十","十一","十二","十三","十四","十五"]
        footerReviewItemCount = footerReviewRecordArray.count
        
        self.myTableFooterView.addSubview(view_review_content_container)
        view_review_content_container.snp.makeConstraints{(make)->Void in
            make.top.equalTo(44)
            make.bottom.equalTo(-20)
            make.left.right.equalTo(0)
        }
        //隐藏之前所有的子视图
        for subView in view_review_content_container.subviews
        {
            subView.isHidden = true
        }
        
        //当没有审批记录时
        if footerReviewItemCount == 0
        {
            let containerView = UIView()
            view_review_content_container.addSubview(containerView)
            containerView.snp.makeConstraints{(make)->Void in
                make.top.equalTo(25)
                make.left.right.equalTo(15)
            }
            
            let leftLabel = UILabel(text: "暂无审批记录", color: TBIThemePrimaryTextColor, size: 14)
            containerView.addSubview(leftLabel)
            containerView.addSubview(leftLabel)
            leftLabel.snp.makeConstraints{(make)->Void in
                make.left.top.bottom.equalTo(0)
            }
            
            return
        }
        
        
        var lastContainerView:UIView!
        
        
        for i in 0..<footerReviewItemCount
        {
            let reviewItem = footerReviewRecordArray[i]
            
            let containerView = UIView()
            view_review_content_container.addSubview(containerView)
            
            containerView.snp.makeConstraints{(make)->Void in
                
                if i == 0
                {
                    make.top.equalTo(25)
                }
                else
                {
                    make.top.equalTo(lastContainerView.snp.bottom).offset(10)
                }
                
                if i == footerReviewItemCount-1
                {
                    //make.bottom.equalTo(-25)
                }
                
                make.left.equalTo(15)
                make.right.equalTo(-15)
            }
            
            
            let leftLabel = UILabel(text: "\(bigNumArray[i])级／\(reviewItem.0)", color: TBIThemePrimaryTextColor, size: 14)
            containerView.addSubview(leftLabel)
            containerView.addSubview(leftLabel)
            leftLabel.snp.makeConstraints{(make)->Void in
                
                make.left.top.bottom.equalTo(0)
            }
            
            let approvalResult:Bool = reviewItem.2
            var approvalResultStr = ""
            if approvalResult   //已同意
            {
                approvalResultStr = "已同意"
            }
            else     //已拒绝
            {
                approvalResultStr = "已拒绝"
            }
            
            let textColor = approvalResult ? TBIThemeGreenColor :TBIThemeRedColor
            let rightLabel = UILabel(text: "\(reviewItem.1)    \(approvalResultStr)", color: textColor, size: 14)
            
            containerView.addSubview(rightLabel)
            rightLabel.snp.makeConstraints{(make)->Void in
                
                make.right.top.bottom.equalTo(0)
            }
            
            
            lastContainerView = containerView
        }
    }
    
    
    //设置TableView的Header布局
    func setTableHeaderView() -> Void
    {
        let tableHeaderView = myTableHeadView
        
        //设置TableHeader的大小
        if !CoApprovalOrderView.isNewVersionOrder  //老版的
        {
            //tableHeaderView.frame = CGRect(x: 0, y: 0, width: ScreenWindowWidth, height: 275)
            tableHeaderView.frame = CGRect(x: 0, y: 0, width: ScreenWindowWidth, height: 300 + 25)
        }
        else     //新版
        {
            //tableHeaderView.frame = CGRect(x: 0, y: 0, width: ScreenWindowWidth, height: 439)
            tableHeaderView.frame = CGRect(x: 0, y: 0, width: ScreenWindowWidth, height: 470 + 25)
        }
        
        if myHeadFixedDataSource.count <= 0
        {
            return
        }
        
        
        //若为新版。 更新TableHeader的大小
        if CoApprovalOrderView.isNewVersionOrder
        {
            updateNewVersionHeadViewSize()
        }
        
        //每一组内item的个数
        var oneGroupInitemCount = 4
//        if myHeadFixedDataSource.count == 9
//        {
//            oneGroupInitemCount = 3
//        }
        
        
        
        
        var lastLabelContainerView:UIView!
        
        //let countNum = newVersionTopViewFixedDataSource.count
        //print("^_^    countNum = \(countNum)")
        
        //设置固定的字段  对应的视图
        for i in 0..<myHeadFixedDataSource.count
        {
            let containerView = UIView()
            //containerView.backgroundColor = UIColor.white
            tableHeaderView.addSubview(containerView)
            containerView.snp.makeConstraints{(make)->Void in
                make.left.equalTo(15)
                make.right.equalTo(-15)
                //if i%(oneGroupInitemCount) == 0
                if (!CoApprovalOrderView.isNewVersionOrder && ((i == 0) || (i == 4) || (i == 8) || (i == 12))) ||
                   (CoApprovalOrderView.isNewVersionOrder && ((i == 0) || (i == 4) || (i == 7) || (i == 10)))
                {
                    if i == 0
                    {
                        make.top.equalTo(25)
                    }
                    else
                    {
                        make.top.equalTo(lastLabelContainerView.snp.bottom).offset(50)
                    }
                    
                    if (i != 0) && !CoApprovalOrderView.isNewVersionOrder //老版的
                    {
                        oneGroupInitemCount = 4
                    }
                    else if (i != 0) && CoApprovalOrderView.isNewVersionOrder //新版的
                    {
                        oneGroupInitemCount = 3
                    }
                }
                else //if i%oneGroupInitemCount != 0
                {
                    make.top.equalTo(lastLabelContainerView.snp.bottom).offset(8)
                }
                
                //                if i == newVersionTopViewFixedDataSource.count-1
                //                {
                //                    make.bottom.equalTo(-25)
                //                }
                
            }
            
            lastLabelContainerView = containerView
            
            
            
            let leftLabel = UILabel(text: myHeadFixedDataSource[i].0, color: TBIThemeTipTextColor, size: 15)
            containerView.addSubview(leftLabel)
            leftLabel.snp.makeConstraints{(make)->Void in
                make.left.top.bottom.equalTo(0)
            }
            
            let rightLabel = UILabel(text: myHeadFixedDataSource[i].1, color: TBIThemePrimaryTextColor, size: 15)
            containerView.addSubview(rightLabel)
            rightLabel.snp.makeConstraints{(make)->Void in
                make.top.bottom.equalTo(0)
                make.left.equalTo(100)
                make.right.equalTo(0)
            }
            
            //订单状态
            if i == 1
            {
                rightLabel.textColor = TBIThemeBlueColor
            }
            
            
            // add by manman start of line
            // 新需求  待审批出差单 页面
            // 出差是由
            // 由于 需要显示的数据 太多 需要 更改显示方式 修改为 成本中心 样式
            if  i == 8 && CoApprovalOrderView.isNewVersionOrder && myHeadFixedDataSource[8].1.isEmpty == false {
                //出差是由的查看详情
                rightLabel.text = "查看详情"
                rightLabel.textColor = TBIThemeBlueColor
                rightLabel.addOnClickListener(target: self, action: #selector(businessReason))
            }
            
            
            
            // end of line
            
            
            //成本中心
            if i == 9  && CoApprovalOrderView.isNewVersionOrder
            {
                //成本中心的查看详情
                rightLabel.text = "查看详情"
                rightLabel.textColor = TBIThemeBlueColor
                //TODO:成本中心
                rightLabel.addOnClickListener(target: self, action: #selector(costCenterClk))
            }
            
            
            //if i%oneGroupInitemCount == oneGroupInitemCount-1
            if (!CoApprovalOrderView.isNewVersionOrder && ((i == 3) || (i == 7) || (i == 11) || (i == 15))) ||
                (CoApprovalOrderView.isNewVersionOrder && ((i == 3) || (i == 6) || (i == 9) || (i == 12)))
            {
                let lineView = UIView()
                lineView.backgroundColor = TBIThemeGrayLineColor
                tableHeaderView.addSubview(lineView)
                lineView.snp.makeConstraints{(make)->Void in
                    make.left.equalTo(15)
                    make.right.equalTo(-15)
                    make.height.equalTo(1)
                    
                    make.top.equalTo(containerView.snp.bottom).offset(24)
                }
               
                if CoApprovalOrderView.isNewVersionOrder  //新版
                {
                    if ( newVersionDIYDataSource.count == 0 ) && (i == myHeadFixedDataSource.count - 1 )
                    {
                        lineView.backgroundColor = .clear
                    }
                }
            }
            
            
        }
        
        
        if lastLabelContainerView == nil
        {
            return 
        }
        if CoApprovalOrderView.isNewVersionOrder    //新版的
        {
            //设置定制的字段   对应的视图
            for i in 0..<newVersionDIYDataSource.count
            {
                let containerView = UIView()
                containerView.backgroundColor = UIColor.white
                tableHeaderView.addSubview(containerView)
                containerView.snp.makeConstraints{(make)->Void in
                    make.left.equalTo(15)
                    make.right.equalTo(-15)
                    if i == 0
                    {
                        make.top.equalTo(lastLabelContainerView.snp.bottom).offset(50)
                    }
                    else
                    {
                        make.top.equalTo(lastLabelContainerView.snp.bottom).offset(8)
                    }
                    
                }
                
                lastLabelContainerView = containerView
                
                
                
                let leftLabel = UILabel(text: newVersionDIYDataSource[i].0, color: TBIThemeTipTextColor, size: 15)
                containerView.addSubview(leftLabel)
                leftLabel.snp.makeConstraints{(make)->Void in
                    make.left.top.bottom.equalTo(0)
                    
                    make.width.equalTo(80)
                }
                
                let rightLabel = UILabel(text: newVersionDIYDataSource[i].1, color: TBIThemePrimaryTextColor, size: 15)
                containerView.addSubview(rightLabel)
                rightLabel.snp.makeConstraints{(make)->Void in
                    make.top.bottom.equalTo(0)
                    make.left.equalTo(100)
                    make.right.equalTo(0)
                }
                
                if i == newVersionDIYDataSource.count-1
                {
                    
                    let lineView = UIView()
                    lineView.backgroundColor = .clear//TBIThemeGrayLineColor
                    tableHeaderView.addSubview(lineView)
                    lineView.snp.makeConstraints{(make)->Void in
                        make.left.equalTo(0)
                        make.right.equalTo(0)
                        make.height.equalTo(1)
                        
                        make.top.equalTo(containerView.snp.bottom).offset(24)
                    }
                }
            }
        }
        
        
        //TODO:设置TableHeader最下方的分割线  ^_^height=12
        if lastLabelContainerView != nil
        {
            let bottomSegLineView = UIView()
            tableHeaderView.addSubview(bottomSegLineView)
            bottomSegLineView.backgroundColor = TBIThemeBaseColor
            bottomSegLineView.snp.makeConstraints{(make)->Void in
                make.left.right.equalTo(0)
                make.top.equalTo(lastLabelContainerView.snp.bottom).offset(25)
                make.height.equalTo(12)
            }
        }
        
        
    }
    
    
    
    //TODO:对企业版新版   TableHeader大小重新计算    进行界面大小更新
    func updateNewVersionHeadViewSize() -> Void
    {
        if newVersionDIYDataSource.count == 0
        {
            myTableHeadView.frame.size.height = 470 - (17+25+25) + 25
        }
        else if newVersionDIYDataSource.count > 1
        {
            let dataCount:CGFloat = CGFloat((newVersionDIYDataSource.count))
            
            
            myTableHeadView.frame.size.height = CGFloat(470 + (dataCount-1.0)*(8+18)) + 25
        }
    }
    
    @objc private func businessReason() {
        if onTableHeaderListener != nil
        {
            onTableHeaderListener.onClickListener(tableViewFooter: self, flagStr: CoApprovalOrderView.BUSINESS_REASON)
        }
    }
    
    
    
    func costCenterClk() -> Void
    {
        if onTableHeaderListener != nil
        {
            onTableHeaderListener.onClickListener(tableViewFooter: self, flagStr: CoApprovalOrderView.COST_CENTER_CLK)
        }
    }
    
}





