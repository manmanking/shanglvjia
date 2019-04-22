//
//  CoOldOrderDetailsTableHeadView.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/5/23.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class CoOrderDetailsTableHeadView: UIView
{
    var onHeaderListener:OnMyTableViewHeaderListener!
    
    //成本中心
    static let COST_CENTER_CLK = "COST_CENTER_CLK"
    
    //添加机票
    static let CHANGR_ORDER_DETAILS = "CHANGR_ORDER_DETAILS"
    
    //修改订单的View
    let changeOrderBtn = UIButton()
    
    
    
    //老版出差单详情的固定字段
    var oldVersionTopViewFixedDataSource:[(String,String)] = []
    
    //新版出差单详情的固定字段
    var newVersionTopViewFixedDataSource:[(String,String)] = []
    
    //新版出差单详情的定制字段
    var newVersionDIYDataSource:[(String,String)] = []
    
    var newVersionOrderTopAddView = UIView()
    //老版的订单详情的固定字段的视图
    var oldVersionOrderTopAddView = UIView()
    
    var commonTopStatusContainerView = UIView()
    

    //var tableTopView = self
    
    var circleViewArray:[UIImageView] = []
    var lineViewArray:[UIView] = []
    var statusTextViewArray:[UILabel] = []
    
    //状态对应的的文字
    var statusTextArray:[String] = []
    var statusNum:Int = 0
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//    
//    override func awakeFromNib()->Void
//    {
//        super.awakeFromNib()
//        
//        print("^_^    CoOldOrderDetailsTableHeadView")
//        initView()
//    }
    
    func initView() -> Void {
        
        self.backgroundColor = UIColor.white
        
        commonTopStatusContainerView.backgroundColor = TBIThemeBlueColor
        self.addSubview(commonTopStatusContainerView)
        commonTopStatusContainerView.snp.makeConstraints{(make)->Void in
            make.left.right.top.equalTo(0)
            make.height.equalTo(100)
        }
        
        
        //TODO:  测试使用
        //setNewVersionAddOrderDetailsView()
        
        //layoutTableTopView();
    }
    
    //TODO:只用于测试使用
    //新版出差单详情的固定字段
    func setFixedDIYNewVersionDataSource() -> Void
    {
        newVersionTopViewFixedDataSource = []
        
        for i in 0..<9
        {
            newVersionTopViewFixedDataSource.append(("left\(i)","right\(i)"))
        }
        
        
        newVersionDIYDataSource = []
        for i in 0..<1
        {
            newVersionDIYDataSource.append(("left diy \(i)","right diy \(i)"))
        }
        
    }
    
    //对TableTopView进行布局
    func layoutTableTopView() -> Void
    {
        //隐藏子视图
        for subView in commonTopStatusContainerView.subviews
        {
            subView.isHidden = true
        }
        
        circleViewArray = []
        lineViewArray = []
        statusTextViewArray = []
        
        
        statusNum = statusTextArray.count
        
        //var i:Int = 0
        
        let lineNum = statusNum-1
        let circleStatusViewRadious = 8
        
        var marginEdge = 21
        if statusTextArray[0].characters.count >= 3
        {
            marginEdge = 27
        }
        
        let lineDistanceX:Int = (Int(ScreenWindowWidth)-(marginEdge*2)-(circleStatusViewRadious*2))/lineNum
        //设置中间线条的line
        for i in 0..<lineNum
        {
            let lineView = UIView();
            commonTopStatusContainerView.addSubview(lineView)
            //将线添加进数组
            lineViewArray.append(lineView)
            
            
            
            lineView.tag = i
            //lineView.backgroundColor = UIColor.white
            
            if i==0 {
                lineView.snp.makeConstraints{ (make) ->Void in
                    make.height.equalTo(4)
                    make.width.equalTo(lineDistanceX-13)
                    make.top.equalTo(38-2)
                    
                    make.centerX.equalTo(marginEdge-3+circleStatusViewRadious+lineDistanceX/2+3)
                    //make.left.equalTo(marginEdge+circleStatusViewRadious)
                }
            }
            else
            {
                //lineView.backgroundColor = UIColor.init(r: 154, g: 198, b: 250)
                
                lineView.snp.makeConstraints{ (make) ->Void in
                    make.height.equalTo(4)
                    make.width.equalTo(lineDistanceX-13)
                    make.top.equalTo(38-2)
                    
                    make.centerX.equalTo(marginEdge-3+circleStatusViewRadious+lineDistanceX*i+lineDistanceX/2+3)
                    //make.left.equalTo(marginEdge+circleStatusViewRadious+lineDistanceX*i)
                }
            }
            
            
        }
        
        //设置订单状态的Image
        for i in 0..<statusNum
        {
            let orderStatusImage = UIImageView()
            orderStatusImage.backgroundColor = UIColor.clear
            //orderStatusImage.image = UIImage(named: "ic_c_complete")
            orderStatusImage.tag=i
            commonTopStatusContainerView.addSubview(orderStatusImage)
            //将圆形状态添加进数组
            circleViewArray.append(orderStatusImage)
            
            if i==0
            {
                orderStatusImage.snp.makeConstraints { (make) -> Void in
                    make.width.height.equalTo(16)
                    make.left.equalTo(marginEdge)
                    make.top.equalTo(30)
                }
            }
            else
            {
                //orderStatusImage.image = UIImage(named: "ic_c_current")
                
                orderStatusImage.snp.makeConstraints { (make) -> Void in
                    make.width.height.equalTo(16)
                    make.top.equalTo(30)
                    make.left.equalTo(marginEdge+lineDistanceX*i)
                }
            }
            
        }
        
        
        
        for i in 0..<statusNum
        {
            let statusLabel = UILabel(text: statusTextArray[i], color: UIColor.white, size: 13)
            statusLabel.backgroundColor = UIColor.clear
            commonTopStatusContainerView.addSubview(statusLabel)
            statusTextViewArray.append(statusLabel)
            
            
            statusLabel.snp.makeConstraints { (make) -> Void in
                make.height.equalTo(13)
                make.top.equalTo(56)
                make.centerX.equalTo(circleViewArray[i].snp.centerX)
            }
        }
        
    }
    
    //TODO: 设置当前整体的订单状态的视图
    func setCurrentTotalOrderStatus(currentStatusNo:Int) -> Void
    {
        for i in 0..<statusNum
        {
            if i < currentStatusNo
            {
                //TODO:需要设置图片
                circleViewArray[i].image = UIImage(named: "ic_c_complete")
            }
            else if i == currentStatusNo
            {
                //circleViewArray[i].image = UIImage(named: "ic_c_current")
                circleViewArray[i].image = UIImage(named: "ic_c_complete")
            }
            else if i > currentStatusNo
            {
                //TODO:需要设置图片
                //circleViewArray[i].image = UIImage(named: "ic_c_complete")
                circleViewArray[i].layer.cornerRadius = 16.0/2
                circleViewArray[i].backgroundColor = UIColor.init(r: 154, g: 198, b: 250)
                
                statusTextViewArray[i].textColor = UIColor.init(r: 154, g: 198, b: 250)
            }
            
            
            
            if i != statusNum-1
            {
                if i < currentStatusNo
                {
                    lineViewArray[i].backgroundColor = UIColor.white
                }
                else
                {
                    lineViewArray[i].backgroundColor = UIColor.init(r: 154, g: 198, b: 250)
                }
            }
        }
        
    }
    
    //老版的出差单固定字段页面
    func setOldVersionAddOrderDetailsView() -> Void
    {
        //隐藏子视图
        for subView in oldVersionOrderTopAddView.subviews
        {
            subView.isHidden = true
        }
        
        self.addSubview(oldVersionOrderTopAddView)
        oldVersionOrderTopAddView.snp.makeConstraints{(make)->Void in
            make.left.right.equalTo(0)
            make.top.equalTo(commonTopStatusContainerView.snp.bottom)
        }
        //每一组内item的个数
        let oneGroupInitemCount = 3
        var lastLabelContainerView:UIView!
        
        //let countNum = newVersionTopViewFixedDataSource.count
        //print("^_^    countNum = \(countNum)")
        
        //设置固定的字段  对应的视图
        for i in 0..<oldVersionTopViewFixedDataSource.count
        {
            let containerView = UIView()
            //containerView.backgroundColor = UIColor.white
            oldVersionOrderTopAddView.addSubview(containerView)
            containerView.snp.makeConstraints{(make)->Void in
                make.left.equalTo(15)
                make.right.equalTo(-15)
                if i%oneGroupInitemCount == 0
                {
                    if i == 0
                    {
                        make.top.equalTo(25)
                    }
                    else
                    {
                        make.top.equalTo(lastLabelContainerView.snp.bottom).offset(50)
                    }
                }
                else if i%oneGroupInitemCount != 0
                {
                    make.top.equalTo(lastLabelContainerView.snp.bottom).offset(8)
                }
                
                //                if i == newVersionTopViewFixedDataSource.count-1
                //                {
                //                    make.bottom.equalTo(-25)
                //                }
                
            }
            
            lastLabelContainerView = containerView
            
            
            
            let leftLabel = UILabel(text: oldVersionTopViewFixedDataSource[i].0, color: TBIThemeTipTextColor, size: 15)
            containerView.addSubview(leftLabel)
            leftLabel.snp.makeConstraints{(make)->Void in
                make.left.top.bottom.equalTo(0)
            }
            
            let rightLabel = UILabel(text: oldVersionTopViewFixedDataSource[i].1, color: TBIThemePrimaryTextColor, size: 15)
            containerView.addSubview(rightLabel)
            rightLabel.snp.makeConstraints{(make)->Void in
                make.top.bottom.equalTo(0)
                make.left.equalTo(100)
                make.right.equalTo(0)
            }
            
            
            if i%oneGroupInitemCount == oneGroupInitemCount-1
            {
                let lineView = UIView()
                lineView.backgroundColor = TBIThemeGrayLineColor
                oldVersionOrderTopAddView.addSubview(lineView)
                lineView.snp.makeConstraints{(make)->Void in
                    make.left.equalTo(15)
                    make.right.equalTo(-15)
                    make.height.equalTo(1)
                    
                    make.top.equalTo(containerView.snp.bottom).offset(24)
                }
                if i == (oldVersionTopViewFixedDataSource.count - 1)
                {
                    lineView.isHidden = true
                }
            }
        }
        
        //TODO:设置TableHeader最下方的分割线  ^_^height=12
        if lastLabelContainerView != nil
        {
            let bottomSegLineView = UIView()
            oldVersionOrderTopAddView.addSubview(bottomSegLineView)
            bottomSegLineView.backgroundColor = TBIThemeBaseColor
            bottomSegLineView.snp.makeConstraints{(make)->Void in
                make.left.right.equalTo(0)
                make.top.equalTo(lastLabelContainerView.snp.bottom).offset(25)
                make.height.equalTo(12)
            }
        }
    }
    
    //新版的出差单设置头部的订单详情
    func setNewVersionAddOrderDetailsView() -> Void
    {
        //newVersionOrderTopAddView.backgroundColor = TBIThemeGrayLineColor
        
        //隐藏子视图
        for subView in newVersionOrderTopAddView.subviews
        {
            subView.isHidden = true
        }
        
        self.addSubview(newVersionOrderTopAddView)
        newVersionOrderTopAddView.snp.makeConstraints{(make)->Void in
            make.left.right.equalTo(0)
            make.top.equalTo(commonTopStatusContainerView.snp.bottom)
        }
        
        //TODO:测试时使用
        //self.setFixedDIYNewVersionDataSource()
        
        
        var lastLabelContainerView:UIView!
        
        //let countNum = newVersionTopViewFixedDataSource.count
        //print("^_^    countNum = \(countNum)")
        
        //设置固定的字段
        for i in 0..<newVersionTopViewFixedDataSource.count
        {
            let containerView = UIView()
            //containerView.backgroundColor = UIColor.white
            newVersionOrderTopAddView.addSubview(containerView)
            containerView.snp.makeConstraints{(make)->Void in
                make.left.equalTo(15)
                make.right.equalTo(-15)
                if i%3 == 0
                {
                    if i == 0
                    {
                        make.top.equalTo(25)
                    }
                    else
                    {
                        make.top.equalTo(lastLabelContainerView.snp.bottom).offset(50)
                    }
                }
                else if i%3 != 0
                {
                    make.top.equalTo(lastLabelContainerView.snp.bottom).offset(8)
                }
                
//                if i == newVersionTopViewFixedDataSource.count-1
//                {
//                    make.bottom.equalTo(-25)
//                }
                
            }
            
            lastLabelContainerView = containerView
            
            
            
            let leftLabel = UILabel(text: newVersionTopViewFixedDataSource[i].0, color: TBIThemeTipTextColor, size: 15)
            containerView.addSubview(leftLabel)
            leftLabel.snp.makeConstraints{(make)->Void in
                make.left.top.bottom.equalTo(0)
            }
            
            let rightLabel = UILabel(text: newVersionTopViewFixedDataSource[i].1, color: TBIThemePrimaryTextColor, size: 15)
            containerView.addSubview(rightLabel)
            rightLabel.snp.makeConstraints{(make)->Void in
                make.top.bottom.equalTo(0)
                make.left.equalTo(100)
            }
            
            if i == 6
            {
                //成本中心的查看详情
                rightLabel.text = "查看详情"
                rightLabel.textColor = TBIThemeBlueColor
                //TODO:成本中心
                rightLabel.addOnClickListener(target: self, action: #selector(costCenterClk))
            }
            
            
            if i%3 == 3-1
            {
                let lineView = UIView()
                lineView.backgroundColor = TBIThemeGrayLineColor
                newVersionOrderTopAddView.addSubview(lineView)
                lineView.snp.makeConstraints{(make)->Void in
                    make.left.equalTo(15)
                    make.right.equalTo(-15)
                    make.height.equalTo(1)
                    
                    make.top.equalTo(containerView.snp.bottom).offset(24)
                }
                
            }
            
            
        }
        
        
        //设置定制的字段
        for i in 0..<newVersionDIYDataSource.count
        {
            let containerView = UIView()
            containerView.backgroundColor = UIColor.white
            newVersionOrderTopAddView.addSubview(containerView)
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
            }
            
            if i == newVersionDIYDataSource.count-1
            {
                
                let lineView = UIView()
                lineView.backgroundColor = TBIThemeGrayLineColor
                newVersionOrderTopAddView.addSubview(lineView)
                lineView.snp.makeConstraints{(make)->Void in
                    make.left.equalTo(0)
                    make.right.equalTo(0)
                    make.height.equalTo(1)
                    
                    make.top.equalTo(containerView.snp.bottom).offset(24)
                }
            }
        }
        
        
        //修改订单的View
        //let changeOrderBtn = UIButton()
        changeOrderBtn.setTitle("修改出差单", for: .normal)
        changeOrderBtn.setTitleColor(TBIThemeBlueColor, for: .normal)
        changeOrderBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        changeOrderBtn.backgroundColor = UIColor.white
        
        newVersionOrderTopAddView.addSubview(changeOrderBtn)
        changeOrderBtn.snp.makeConstraints{(make)->Void in
        
            make.left.right.equalTo(0)
            make.height.equalTo(44)
            make.top.equalTo(lastLabelContainerView.snp.bottom).offset(25)
            
        }
        
        //最底部的分割线视图
        let bottomSegView = UIView()
        bottomSegView.backgroundColor = TBIThemeBaseColor
        newVersionOrderTopAddView.addSubview(bottomSegView)
        
        bottomSegView.snp.makeConstraints{(make)->Void in
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(changeOrderBtn.snp.bottom)
            make.height.equalTo(10)
        }
        
        
        changeOrderBtn.addOnClickListener(target: self, action: #selector(changeOrderClk))
        
    }
    
    //修改出差单
    func changeOrderClk() -> Void
    {
        if onHeaderListener != nil
        {
            onHeaderListener.onClickListener(tableViewFooter: self, flagStr: CoOrderDetailsTableHeadView.CHANGR_ORDER_DETAILS)
        }
    }
    
    func costCenterClk() -> Void
    {
        if onHeaderListener != nil
        {
            onHeaderListener.onClickListener(tableViewFooter: self, flagStr: CoOrderDetailsTableHeadView.COST_CENTER_CLK)
        }
    }
    
    
    
    
    
    

}
