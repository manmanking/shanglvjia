//
//  PTravelOrderDetailsView.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/7/7.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class PTravelOrderDetailsView: UIView
{
    
    enum TravelOrderBtnText:Int
    {
        case refund = 1001   //我要退款
        case change = 1002   //我要修改
        case cancel = 1003   //取消订单
        case pay = 1004         //我要支付
        case unknow = -1
        
        var description:String
        {
            switch self
            {
            case .refund:
                return "我要退款"
            case .change:
                return "我要修改"
            case .cancel:
                return "取消订单"
            case .pay:
                return "我要支付"
            case .unknow:
                return "未知"
            }
        }
    }
    
    
    public var remainTime:NSInteger = 0
    
    
    //设置当前旅游订单的状态
    var travelOrderStatus:PSpecialOrderDetails.TravelOrderStatus! = nil
    {
        didSet
        {
            let currentStatus = travelOrderStatus ?? .unknow
            switch currentStatus
            {
            case .reservedSuccess,.payed:
                setStatusViewIsShow(isShow: true, leftImageShow: true, rightImageShow: true, leftText: .refund, rightText: .change)
            case .waitPay:
                setStatusViewIsShow(isShow: true, leftImageShow: false, rightImageShow: false, leftText: .cancel, rightText: .pay)
            case .busyBuying:
                setStatusViewIsShow(isShow: true, leftImageShow: false, rightImageShow: true, leftText: .cancel, rightText: .change)
            case .offline,.canceled,.busyBuyFailure,.unknow:
                setStatusViewIsShow(isShow: false, leftImageShow: false, rightImageShow: false, leftText: .unknow, rightText: .unknow)
            }
        }
    }
    
    //旅游订单详情
    var travelOrderDetails:PSpecialOrderDetails! = nil
    var psgItemViewList:[UIView] = []
    
    let myScrollView = UIScrollView()
    let myScrollContentView = UIView()
    
   
    
    
    //****头部的旅游状态的视图
    var topOrderStatusView:TopOrderStatusView! = nil
    //价格明细对应的点击事件View（热区）
    let topRightPriceDetailsTapArea = UIView()
    //头部的旅游状态 左侧按钮🔘
    var topLeftRefundTicketView:UIView! = nil
    //头部的旅游状态 右侧按钮🔘
    var topRightChangeTicketView:UIView! = nil
    
    //***旅游内容描述的View
    let travelContentDescContainer = UIView()
    
    //***旅客的View
    let psgContainerView = UIView()
    var psgItemCount = 0
    
    //***中间的联系人视图
    var middleContactsView:UIView! = nil
    
    //中间的报销凭证视图
    var freeChargeView:UIView! = nil
    
    //中间的下单时间⌚️相关的视图
    var middleOrderTimeView:UIView! = nil
    
    //最底部的按钮🔘
    var bottomBtn:UIButton! = nil
    
    
    
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        //initView()
    }
    
    
    
    func setStatusViewIsShow(isShow:Bool,leftImageShow:Bool,rightImageShow:Bool,leftText:TravelOrderBtnText,rightText:TravelOrderBtnText) -> Void
    {
        guard (self.topOrderStatusView != nil)  else {
            return
        }
        
        topOrderStatusView.leftBottomContentLabel.text = leftText.description
        topOrderStatusView.rightBottomContentLabel.text = rightText.description
        
        
        topLeftRefundTicketView.clipsToBounds = true
        topRightChangeTicketView.clipsToBounds = true
        
        if isShow
        {
            topLeftRefundTicketView.snp.updateConstraints{(make)->Void in
                make.height.equalTo(35)
                make.bottom.equalTo(-15)
            }
            topRightChangeTicketView.snp.updateConstraints{(make)->Void in
                make.height.equalTo(35)
            }
            
            if leftImageShow
            {
                topOrderStatusView.leftBottomContentImageView.snp.updateConstraints{(make)->Void in
                    make.width.equalTo(18)
                    make.height.equalTo(16)
                }
            }
            else
            {
                topOrderStatusView.leftBottomContentImageView.snp.updateConstraints{(make)->Void in
                    make.width.equalTo(0)
                    make.height.equalTo(16)
                }
            }
            
            if rightImageShow
            {
                topOrderStatusView.rightBottomContentImageView.snp.updateConstraints{(make)->Void in
                    make.width.equalTo(18)
                    make.height.equalTo(16)
                }
            }
            else
            {
                topOrderStatusView.rightBottomContentImageView.snp.updateConstraints{(make)->Void in
                    make.width.equalTo(0)
                    make.height.equalTo(16)
                }
            }
        }
        else
        {
            topLeftRefundTicketView.snp.updateConstraints{(make)->Void in
                make.height.equalTo(0)
                make.bottom.equalTo(0)
            }
            topRightChangeTicketView.snp.updateConstraints{(make)->Void in
                make.height.equalTo(0)
            }
        }
        
        
        topLeftRefundTicketView.tag = leftText.rawValue
        topRightChangeTicketView.tag = rightText.rawValue
        
    }
    
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() -> Void
    {
        self.myScrollView.backgroundColor = TBIThemeBaseColor
        
        self.addSubview(myScrollView)
        myScrollView.snp.makeConstraints{(make)->Void in
            make.left.right.top.bottom.equalTo(0)
        }
        myScrollView.addSubview(myScrollContentView)
        myScrollContentView.snp.makeConstraints{(make)->Void in
            make.left.right.top.bottom.equalTo(0)
            make.width.equalTo(ScreenWindowWidth)
        }
        
        layoutTopOrderStatusView()
        layoutTravelContentDescContainer()
        layoutPsgContainerView()
        layoutMiddleContactsView()
        layoutFreeChargeView()
        layoutOrderTimeView()
        layoutBottomBtn()
    }
    
    //设置头部的订单状态的整体View
    func layoutTopOrderStatusView() -> Void
    {
        topOrderStatusView = TopOrderStatusView()
        topOrderStatusView.backgroundColor = .white
        myScrollContentView.addSubview(topOrderStatusView)
        topOrderStatusView.snp.makeConstraints{(make)->Void in
            make.left.right.top.equalTo(0)
        }
        
        //        //左半部分
        //        let leftTopShowStatusLabel = UILabel(text: "已订妥", color: TBIThemeOrangeColor, size: 16)
        topOrderStatusView.addSubview(topOrderStatusView.leftTopShowStatusLabel)
        topOrderStatusView.leftTopShowStatusLabel.snp.makeConstraints{(make)->Void in
            make.left.top.equalTo(15)
        }
        
        //增加时限的视图
        //  add by manman start of line 
        topOrderStatusView.addSubview(topOrderStatusView.remainTimeLabel)
        topOrderStatusView.remainTimeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(topOrderStatusView.leftTopShowStatusLabel.snp.right).offset(5)
            make.centerY.equalTo(topOrderStatusView.leftTopShowStatusLabel)
        }
        
        
        
        
        //end of line
        
        
        
        
        //let middleOrderNoLabel = UILabel(text: "订单编号8888888888888", color: TBIThemePrimaryTextColor, size: 11)
        topOrderStatusView.addSubview(topOrderStatusView.middleOrderNoLabel)
        topOrderStatusView.middleOrderNoLabel.snp.makeConstraints{(make)->Void in
            make.left.equalTo(15)
            make.top.equalTo(topOrderStatusView.leftTopShowStatusLabel.snp.bottom).offset(2)
        }
        
        //左部分：底部的按钮🔘
        let leftBottomContainerView = UIView()
        leftBottomContainerView.layer.cornerRadius = 5
        topLeftRefundTicketView = leftBottomContainerView
        leftBottomContainerView.backgroundColor = TBIThemeBlueColor
        topOrderStatusView.addSubview(leftBottomContainerView)
        leftBottomContainerView.snp.makeConstraints{(make)->Void in
            make.left.equalTo(15)
            make.top.equalTo(topOrderStatusView.middleOrderNoLabel.snp.bottom).offset(15)
            make.height.equalTo(35)
            make.width.equalTo((self.frame.size.width-15-15-15) / 2)
            
            make.bottom.equalTo(-15)
        }
        let leftBottomContentView = UIView()
        leftBottomContainerView.addSubview(leftBottomContentView)
        leftBottomContentView.snp.makeConstraints{(make)->Void in
            make.center.equalToSuperview()
        }
        //let leftBottomContentImageView = UIImageView(imageName: "ic_customer service_white")
        //leftBottomContentImageView.backgroundColor = .red
        leftBottomContentView.addSubview(topOrderStatusView.leftBottomContentImageView)
        topOrderStatusView.leftBottomContentImageView.snp.makeConstraints{(make)->Void in
            make.left.top.bottom.equalTo(0)
            
            make.width.equalTo(18)
            make.height.equalTo(16)
        }
        //let leftBottomContentLabel = UILabel(text: "我要退票", color: .white, size: 14)
        leftBottomContentView.addSubview(topOrderStatusView.leftBottomContentLabel)
        topOrderStatusView.leftBottomContentLabel.snp.makeConstraints{(make)->Void in
            make.right.top.bottom.equalTo(0)
            make.left.equalTo(topOrderStatusView.leftBottomContentImageView.snp.right).offset(5)
        }
        
        //        //右半部分
        //        let rightTopShowPriceLabel = UILabel(text: "¥650", color: TBIThemeOrangeColor, size: 16)
        topOrderStatusView.addSubview(topOrderStatusView.rightTopShowPriceLabel)
        topOrderStatusView.rightTopShowPriceLabel.snp.makeConstraints{(make)->Void in
            make.right.equalTo(-33)
            make.top.equalTo(15)
        }
        
        //价格明细对应的点击事件View（热区）
        topOrderStatusView.addSubview(topRightPriceDetailsTapArea)
        topRightPriceDetailsTapArea.snp.makeConstraints{(make)->Void in
            make.right.top.equalTo(0)
            make.bottom.equalTo(topOrderStatusView.rightTopShowPriceLabel.snp.bottom).offset(25)
            make.width.equalToSuperview().multipliedBy(0.3)
        }
        
        //let rightMiddlePriceDetailsLabel = UILabel(text: "价格明细", color: TBIThemePrimaryTextColor, size: 11)
        topOrderStatusView.addSubview(topOrderStatusView.rightMiddlePriceDetailsLabel)
        topOrderStatusView.rightMiddlePriceDetailsLabel.snp.makeConstraints{(make)->Void in
            make.right.equalTo(-33)
            
            make.top.equalTo(topOrderStatusView.rightTopShowPriceLabel.snp.bottom).offset(2)
        }
        
        //右部分：底部的按钮🔘
        let rightBottomContainerView = UIView()
        rightBottomContainerView.layer.cornerRadius = 5
        topRightChangeTicketView = rightBottomContainerView
        rightBottomContainerView.backgroundColor = TBIThemeBlueColor
        topOrderStatusView.addSubview(rightBottomContainerView)
        rightBottomContainerView.snp.makeConstraints{(make)->Void in
            make.right.equalTo(-15)
            make.top.equalTo(topOrderStatusView.middleOrderNoLabel.snp.bottom).offset(15)
            make.height.equalTo(35)
            make.width.equalTo((self.frame.size.width-15-15-15) / 2)
            
            //make.bottom.equalTo(-15)
        }
        let rightBottomContentView = UIView()
        rightBottomContainerView.addSubview(rightBottomContentView)
        rightBottomContentView.snp.makeConstraints{(make)->Void in
            make.center.equalToSuperview()
        }
        //let rightBottomContentImageView = UIImageView(imageName: "ic_customer service_white")
        //rightBottomContentImageView.backgroundColor = .red
        rightBottomContentView.addSubview(topOrderStatusView.rightBottomContentImageView)
        topOrderStatusView.rightBottomContentImageView.snp.makeConstraints{(make)->Void in
            make.left.top.bottom.equalTo(0)
            
            make.width.equalTo(18)
            make.height.equalTo(16)
        }
        //let rightBottomContentLabel = UILabel(text: "我要改签", color: .white, size: 14)
        rightBottomContentView.addSubview(topOrderStatusView.rightBottomContentLabel)
        topOrderStatusView.rightBottomContentLabel.snp.makeConstraints{(make)->Void in
            make.right.top.bottom.equalTo(0)
            make.left.equalTo(topOrderStatusView.rightBottomContentImageView.snp.right).offset(5)
        }
        
        //最右侧的箭头➡️
        let rightArrowImageView = UIImageView(imageName: "ic_right_gray")
        topOrderStatusView.addSubview(rightArrowImageView)
        rightArrowImageView.snp.makeConstraints{(make)->Void in
            make.width.equalTo(8)
            make.height.equalTo(14)
            
            make.right.equalTo(-15)
            make.centerY.equalTo(topOrderStatusView.rightTopShowPriceLabel.snp.bottom).offset(3)
        }
        
    }
    
    
    //旅游内容描述的View
    func layoutTravelContentDescContainer() -> Void
    {
        travelContentDescContainer.backgroundColor = .white
        myScrollContentView.addSubview(travelContentDescContainer)
        travelContentDescContainer.snp.makeConstraints{(make)->Void in
            make.left.right.equalTo(0)
            make.top.equalTo(topOrderStatusView.snp.bottom).offset(10)
        }
        
        //头部的文字描述View
        let travelContentDescTitleContainer = UIView()
        travelContentDescContainer.addSubview(travelContentDescTitleContainer)
        travelContentDescTitleContainer.snp.makeConstraints{(make)->Void in
            make.left.right.top.equalTo(0)
        }
        
        let travelContentDescTitleLeftImage = UIImageView(imageName: "ic_travel")
        travelContentDescTitleContainer.addSubview(travelContentDescTitleLeftImage)
        travelContentDescTitleLeftImage.snp.makeConstraints{(make)->Void in
            make.left.equalTo(15)
            make.width.height.equalTo(14)
            make.top.equalTo(14)
        }
        //旅游产品的名称
        let travelContentDescTitleRightLabel = UILabel(text: self.travelOrderDetails.specialProductName, color: TBIThemePrimaryTextColor, size: 14)
        travelContentDescTitleRightLabel.numberOfLines = -1
        travelContentDescTitleContainer.addSubview(travelContentDescTitleRightLabel)
        travelContentDescTitleRightLabel.snp.makeConstraints{(make)->Void in
            make.left.equalTo(travelContentDescTitleLeftImage.snp.right).offset(5)
            make.right.equalTo(-15)
            make.top.equalTo(14)
            make.bottom.equalTo(-14)
        }
        
        let travelContentDescTitleBottomSegLine = UIView()
        travelContentDescTitleBottomSegLine.backgroundColor = TBIThemeGrayLineColor
        travelContentDescTitleContainer.addSubview(travelContentDescTitleBottomSegLine)
        travelContentDescTitleBottomSegLine.snp.makeConstraints{(make)->Void in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(0)
            make.height.equalTo(1)
        }
        
        //产品的View
        let contentDescProductContainer = UIView()
        travelContentDescContainer.addSubview(contentDescProductContainer)
        contentDescProductContainer.snp.makeConstraints{(make)->Void in
            make.left.right.equalTo(0)
            make.top.equalTo(travelContentDescTitleContainer.snp.bottom)
            make.bottom.equalTo(0)
        }
        //产品类型
        let productTypeContainer = UIView()
        contentDescProductContainer.addSubview(productTypeContainer)
        productTypeContainer.snp.makeConstraints{(make)->Void in
            make.left.right.equalTo(0)
            make.top.equalTo(15)
        }
        let productTypeLeftLabel = UILabel(text: "产品类型", color: TBIThemeTipTextColor, size: 13)
        productTypeContainer.addSubview(productTypeLeftLabel)
        productTypeLeftLabel.snp.makeConstraints{(make)->Void in
            make.left.equalTo(15)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
        }
        //产品类型的描述
        let productTypeRightLabel = UILabel(text: travelOrderDetails.specialCategoryName, color: TBIThemePrimaryTextColor, size: 13)
        productTypeContainer.addSubview(productTypeRightLabel)
        productTypeRightLabel.snp.makeConstraints{(make)->Void in
            make.left.equalTo(100)
            make.right.equalTo(-15)
            make.top.equalTo(0)
        }
        //出行日期
        let departDateContainer = UIView()
        contentDescProductContainer.addSubview(departDateContainer)
        departDateContainer.snp.makeConstraints{(make)->Void in
            make.left.right.equalTo(0)
            make.top.equalTo(productTypeContainer.snp.bottom).offset(10)
            make.bottom.equalTo(-15)
        }
        let departDateLeftLabel = UILabel(text: "出行日期", color: TBIThemeTipTextColor, size: 13)
        departDateContainer.addSubview(departDateLeftLabel)
        departDateLeftLabel.snp.makeConstraints{(make)->Void in
            make.left.equalTo(15)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
        }
        //出行日期的字符串
        let formatter0 = DateFormatter()
        formatter0.dateFormat = "yyyy-MM-dd"
        let startDate:Date = formatter0.date(from: travelOrderDetails.startDate)!
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "yyyy年M月d日"
        let startDateStr:String = formatter1.string(from: startDate)
        
        let departDateRightLabel = UILabel(text: startDateStr, color: TBIThemePrimaryTextColor, size: 13)
        departDateContainer.addSubview(departDateRightLabel)
        departDateRightLabel.snp.makeConstraints{(make)->Void in
            make.left.equalTo(100)
            make.right.equalTo(-15)
            make.top.equalTo(0)
        }
        
    }
    
    //旅客的View
    func layoutPsgContainerView() -> Void
    {
        psgContainerView.backgroundColor = .white
        myScrollContentView.addSubview(psgContainerView)
        psgContainerView.snp.makeConstraints{(make)->Void in
            make.left.right.equalTo(0)
            make.top.equalTo(travelContentDescContainer.snp.bottom).offset(10)
        }
        
        self.psgItemViewList = []
        psgItemCount = travelOrderDetails.orderSpecialPersonInfoList.count
        var lastPsgItemView:UIView! = nil
        for i in 0..<psgItemCount
        {
            let psgItemContainer = UIView()
            self.psgItemViewList.append(psgItemContainer)
            psgContainerView.addSubview(psgItemContainer)
            psgItemContainer.snp.makeConstraints{(make)->Void in
                make.left.right.equalTo(0)
                make.height.equalTo(44)
                
                if i == 0
                {
                    make.top.equalTo(0)
                }
                else
                {
                    make.top.equalTo(lastPsgItemView.snp.bottom)
                }
                
                if i == (psgItemCount - 1)
                {
                    make.bottom.equalTo(0)
                }
            }
            lastPsgItemView = psgItemContainer
            
            let itemLeftLabel = UILabel(text: "leftLabel \(i)", color: TBIThemeTipTextColor, size: 13)
            psgItemContainer.addSubview(itemLeftLabel)
            itemLeftLabel.snp.makeConstraints{(make)->Void in
                make.left.equalTo(15)
                make.centerY.equalToSuperview()
            }
            
            let itemRightLabel = UILabel(text: "itemRightLabel \(i)", color: TBIThemePrimaryTextColor, size: 13)
            psgItemContainer.addSubview(itemRightLabel)
            itemRightLabel.snp.makeConstraints{(make)->Void in
                make.left.equalTo(100)
                make.right.equalTo(-15)
                make.centerY.equalToSuperview()
            }
            
            let rightArrowImageView = UIImageView(imageName: "ic_right_gray")
            psgItemContainer.addSubview(rightArrowImageView)
            rightArrowImageView.snp.makeConstraints{(make)->Void in
                make.right.equalTo(-15)
                make.centerY.equalToSuperview()
            }
            
            if i != (psgItemCount - 1)
            {
                let itemBottomSegLine = UIView()
                itemBottomSegLine.backgroundColor = TBIThemeGrayLineColor
                psgItemContainer.addSubview(itemBottomSegLine)
                itemBottomSegLine.snp.makeConstraints{(make)->Void in
                    make.left.right.bottom.equalTo(0)
                    make.height.equalTo(1)
                }
            }
            
            let psgItem = travelOrderDetails.orderSpecialPersonInfoList[i]
            if psgItem.personTypeEnum == .adult
            {
                itemLeftLabel.text = psgItem.personTypeEnum.description + "\(i+1)"
            }
            else
            {
                itemLeftLabel.text = psgItem.personTypeEnum.description
            }
            itemRightLabel.text = psgItem.personNameCn
            
        }
        
    }
    
    
    
    //中间的联系人视图
    func layoutMiddleContactsView() -> Void
    {
        middleContactsView = UIView()
        middleContactsView.backgroundColor = .white
        myScrollContentView.addSubview(middleContactsView)
        middleContactsView.snp.makeConstraints{(make)->Void in
            make.left.right.equalTo(0)
            make.top.equalTo(psgContainerView.snp.bottom).offset(10)
            
        }
        
        let leftContactTxt = UILabel(text: "联系人", color: TBIThemeTipTextColor, size: 13)
        middleContactsView.addSubview(leftContactTxt)
        leftContactTxt.snp.makeConstraints{(make)->Void in
            make.left.top.equalTo(15)
        }
        
        //联系人姓名
        let rightTopContactName = UILabel(text: travelOrderDetails.contactName, color: TBIThemePrimaryTextColor, size: 13)
        middleContactsView.addSubview(rightTopContactName)
        rightTopContactName.snp.makeConstraints{(make)->Void in
            make.top.equalTo(15)
            make.left.equalTo(100)
        }
        
        //联系人手机号
        let rightBottomContactPhone = UILabel(text: travelOrderDetails.contactPhone, color: TBIThemePrimaryTextColor, size: 13)
        middleContactsView.addSubview(rightBottomContactPhone)
        rightBottomContactPhone.snp.makeConstraints{(make)->Void in
            make.top.equalTo(rightTopContactName.snp.bottom).offset(10)
            make.left.equalTo(100)
            
            make.bottom.equalTo(-15)
        }
    }
    
    //设置报销凭证视图
    func layoutFreeChargeView() -> Void
    {
        freeChargeView = UIView()
        freeChargeView.backgroundColor = .white
        myScrollContentView.addSubview(freeChargeView)
        freeChargeView.snp.makeConstraints{(make)->Void in
            make.left.right.equalTo(0)
            make.top.equalTo(middleContactsView.snp.bottom).offset(10)
            
            make.height.equalTo(44)
        }
        
        let freeChargelabel = UILabel(text: "报销凭证", color: TBIThemePrimaryTextColor, size: 13)
        freeChargeView.addSubview(freeChargelabel)
        freeChargelabel.snp.makeConstraints{(make)->Void in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
        
        let rightArrowImageView = UIImageView(imageName: "ic_right_gray")
        freeChargeView.addSubview(rightArrowImageView)
        rightArrowImageView.snp.makeConstraints{(make)->Void in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
        }
        
    }

    //中间的下单时间⌚️相关的视图
    func layoutOrderTimeView() -> Void
    {
        //总容器视图
        middleOrderTimeView = UIView()
        middleOrderTimeView.backgroundColor = .white
        myScrollContentView.addSubview(middleOrderTimeView)
        middleOrderTimeView.snp.makeConstraints{(make)->Void in
            make.left.right.equalTo(0)
            make.top.equalTo(freeChargeView.snp.bottom).offset(10)
            
            make.height.equalTo(44)
        }
        
        let leftTimelabel = UILabel(text: "下单时间", color: TBIThemePrimaryTextColor, size: 13)
        middleOrderTimeView.addSubview(leftTimelabel)
        leftTimelabel.snp.makeConstraints{(make)->Void in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
        //下单时间
        let dateFormater0 = DateFormatter()
        dateFormater0.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let createDate:Date = dateFormater0.date(from: travelOrderDetails.createDate) ?? Date()
        let dateFormater1 = DateFormatter()
        dateFormater1.dateFormat = "yyyy-M-d hh:mm"
        let createDateStr:String = dateFormater1.string(from: createDate)
        
        let rightTimeLabel = UILabel(text: createDateStr, color: TBIThemePrimaryTextColor, size: 13)
        middleOrderTimeView.addSubview(rightTimeLabel)
        rightTimeLabel.snp.makeConstraints{(make)->Void in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
        }
    }
    
    //最底部的按钮🔘
    func layoutBottomBtn() -> Void
    {
        bottomBtn = UIButton(title: "联系客服", titleColor: .white, titleSize: 18)
        bottomBtn.layer.cornerRadius = 5
        myScrollContentView.addSubview(bottomBtn)
        bottomBtn.snp.makeConstraints{(make)->Void in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(middleOrderTimeView.snp.bottom).offset(15)
            
            make.height.equalTo(47)
            
            make.bottom.equalTo(-15)
        }
        
        bottomBtn.backgroundColor = TBIThemeBlueColor
    }
    
    
}

extension PTravelOrderDetailsView
{
    
    
    
    //将<10的数转换为01的形式
    func numChangeTwoDigital(num:Int) -> String
    {
        if num<10
        {
            return "0\(num)"
        }
        
        return "\(num)"
    }
    
    class TopOrderStatusView:UIView
    {
        //左半部分
        let leftTopShowStatusLabel = UILabel(text: "已订妥", color: TBIThemeOrangeColor, size: 16)
        
        //添加时限视图
        // add by manman start of line 
        let remainTimeLabel = UILabel(text: "剩余时间29:29", color: TBIThemeOrangeColor, size: 16)
        
        
        
        // end of line
        
        
        
        
        let middleOrderNoLabel = UILabel(text: "订单编号8888888888888", color: TBIThemePrimaryTextColor, size: 11)
        
        let leftBottomContentImageView = UIImageView(imageName: "ic_customer service_white")
        let leftBottomContentLabel = UILabel(text: "我要退票", color: .white, size: 14)
        
        //右半部分
        let rightTopShowPriceLabel = UILabel(text: "¥650", color: TBIThemeOrangeColor, size: 16)
        let rightMiddlePriceDetailsLabel = UILabel(text: "价格明细", color: TBIThemePrimaryTextColor, size: 11)
        
        let rightBottomContentImageView = UIImageView(imageName: "ic_customer service_white")
        let rightBottomContentLabel = UILabel(text: "我要改签", color: .white, size: 14)
    }
    
}




















