//
//  PFlightOrderDetailsView.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/6/21.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import SwiftDate

class PFlightOrderDetailsView: UIView
{
    enum PFlightOrderBtnText:Int
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
                return "我要改签"
            case .cancel:
                return "取消订单"
            case .pay:
                return "我要支付"
            case .unknow:
                return "未知"
            }
        }
    }
    
//    case waitpay = "待支付"
//    case payed = "已支付待订妥"
//    case cancel = "已取消"
//    case offline = "转线下"
//    case faded = "已退票"
//    case success = "已出票"
//    case unkonw = "未知"
//    //TODO:设置当前旅游订单的状态
    var flightOrderStatus:FlightOrderDetail.FlightOrderState! = nil
    {
        didSet
        {
            let currentStatus = flightOrderStatus ?? .unkonw
            switch currentStatus
            {
            case .waitpay:
                setStatusViewIsShow(isShow: true, leftImageShow: false, rightImageShow: false, leftText: .cancel, rightText: .pay)
            case .payed://.waitPay:
                setStatusViewIsShow(isShow: true, leftImageShow: true, rightImageShow: true, leftText: .refund, rightText: .change)
            case .canceled,.finished,.unkonw,.exit,.applyExit,.fk://.busyBuying:
                setStatusViewIsShow(isShow: false, leftImageShow: false, rightImageShow: false, leftText: .unknow, rightText: .unknow)
            case .line://.offline,.canceled,.busyBuyFailure,.unknow:
                setStatusViewIsShow(isShow: true, leftImageShow: true, rightImageShow: true, leftText: .refund, rightText: .change)
            }
        }
    }
    
    // 操作记录
    var operateMsgs:[FlightOrderDetail.OperateMsg] = []
    // 下单日期
    var orderTime:DateInRegion! = nil
    
    
    
    var isGOBackJourney:Bool   //是否为去返程
    {
        if flightDetailDataList.count >= 2
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    //航段CellView的数组
    var flightCellViewList:[FlightOrderDetailsItemCell] = []
    var flightDetailDataList:[FlightOrderDetail.FlightDetail] = []
    // 旅客信息
    var guestListArray:[[FlightOrderDetail.Guest]] = []
    
    // 联系人信息
    var mContact:FlightOrderDetail.Contact! = nil
    
    
    
    var myScrollView:UIScrollView! = nil
    var myScrollContentView:UIView! = nil
    
    //价格明细对应的点击事件View（热区）
    let topRightPriceDetailsTapArea = UIView()
    
    //我要退票按钮🔘
    var topLeftRefundTicketView:UIView! = nil
    //我要改签按钮🔘
    var topRightChangeTicketView:UIView! = nil
    //查看退改签规则的视图
    var lookChangeTicketRuleView:UIView! = nil
    
    //头部的航班状态的视图
    var topOrderStatusView:PFlightOrderDetailsView.TopOrderStatusView! = nil
    //中间航班信息的视图
    var middleFlightInfoView:UIView! = nil
    var flightInfoCount:Int
    {
        var totalCount = 0
        for i in 0..<flightDetailDataList.count
        {
            totalCount += (flightDetailDataList[i].legs.count)
        }
        
        return totalCount
    }
    
    //中间的乘机人容器视图
    var middlePsgContainerView:UIView! = nil
    var psgCount:Int
    {
        return guestListArray[0].count
    }
    
    //中间的联系人视图
    var middleContactsView:UIView! = nil
    
    //中间的报销凭证视图
    var freeChargeView:UIView! = nil
    
    //中间的订票时间⌚️相关的视图
    var middleTicketTimeView:UIView! = nil
    var ticketTimeNum:Int
    {
        return (operateMsgs.count+1)
    }
    
    //最底部的按钮🔘
    var bottomBtn:UIButton! = nil
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        //initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setStatusViewIsShow(isShow:Bool,leftImageShow:Bool,rightImageShow:Bool,leftText:PFlightOrderBtnText,rightText:PFlightOrderBtnText) -> Void
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
    
    func initView() -> Void
    {
        myScrollView = UIScrollView()
        myScrollView.backgroundColor = TBIThemeBaseColor
        self.addSubview(myScrollView)
        myScrollView.snp.makeConstraints{(make)->Void in
            make.left.right.top.bottom.equalTo(0)
        }
        
        myScrollContentView = UIView()
        myScrollContentView.backgroundColor = TBIThemeBaseColor
        myScrollView.addSubview(myScrollContentView)
        myScrollContentView.snp.makeConstraints{(make)->Void in
            make.left.right.top.bottom.equalTo(0)
            
            make.width.equalTo(self.frame.size.width)
        }
        
        layoutTopOrderStatusView()
        layoutMiddleFlightInf()
        layoutMiddlePsgContainerView()
        layoutMiddleContactsView()
        layoutFreeChargeView()
        layoutTicketTimeView()
        layoutBottomBtn()
        
    }
    
    //设置头部的订单状态的整体View
    func layoutTopOrderStatusView() -> Void
    {
        topOrderStatusView = PFlightOrderDetailsView.TopOrderStatusView()
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
        leftBottomContainerView.layer.cornerRadius = 3
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
        rightBottomContainerView.layer.cornerRadius = 3
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
    
    //中间航班信息的视图
    func layoutMiddleFlightInf() -> Void
    {
        middleFlightInfoView = UIView()
        middleFlightInfoView.backgroundColor = .white
        myScrollContentView.addSubview(middleFlightInfoView)
        middleFlightInfoView.snp.makeConstraints{(make)->Void in
            make.left.right.equalTo(0)
            make.top.equalTo(topOrderStatusView.snp.bottom).offset(10)
        }
        
        //头部标题
        let middleFlightInfoTopView = UIView()
        middleFlightInfoView.addSubview(middleFlightInfoTopView)
        middleFlightInfoTopView.snp.makeConstraints{(make)->Void in
            make.left.right.top.equalTo(0)
            make.height.equalTo(37)
        }
        let topTitlelabel = UILabel(text: "航班信息", color: TBIThemeTipTextColor, size: 13)
        middleFlightInfoTopView.addSubview(topTitlelabel)
        topTitlelabel.snp.makeConstraints{(make)->Void in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
        let topSegLine = UIView()
        topSegLine.backgroundColor = TBIThemeGrayLineColor
        middleFlightInfoTopView.addSubview(topSegLine)
        topSegLine.snp.makeConstraints{(make)->Void in
            make.left.right.equalTo(0)
            make.bottom.equalToSuperview()
            
            make.height.equalTo(0.5)
        }
        
        
        //中间航班多个item的信息的内容
        let middleFlightInfoMiddleView = UIView()
        //middleFlightInfoMiddleView.backgroundColor = .red
        middleFlightInfoView.addSubview(middleFlightInfoMiddleView)
        middleFlightInfoMiddleView.snp.makeConstraints{(make)->Void in
            make.left.right.equalTo(0)
            make.top.equalTo(middleFlightInfoTopView.snp.bottom)
            
            //make.height.equalTo(30)
        }
        
        self.flightCellViewList = []
        var lastFlightInfView:UIView! = nil
        for i in 0..<flightInfoCount
        {
            let flightInfCell:FlightOrderDetailsItemCell =  FlightOrderDetailsItemCell(style: .default, reuseIdentifier: "aaa")
            self.flightCellViewList.append(flightInfCell)
            
            flightInfCell.typeLabel.isHidden = true
            middleFlightInfoMiddleView.addSubview(flightInfCell)
            flightInfCell.snp.makeConstraints{(make)->Void in
                make.left.right.equalTo(0)
                make.height.equalTo(130)
                
                if i == 0
                {
                    make.top.equalTo(0)
                }
                else
                {
                    make.top.equalTo(lastFlightInfView.snp.bottom)
                }
                
                if i == flightInfoCount-1
                {
                    make.bottom.equalTo(0)
                }
            }
            lastFlightInfView = flightInfCell
            if i == flightInfoCount-1
            {
                flightInfCell.bottomSegLine.isHidden = true
            }
            
        }
        
        
        
        
        //底部的视图
        let middleFlightInfoBottomView = UIView()
        lookChangeTicketRuleView = middleFlightInfoBottomView
        middleFlightInfoView.addSubview(middleFlightInfoBottomView)
        middleFlightInfoBottomView.snp.makeConstraints{(make)->Void in
            make.left.right.equalTo(0)
            make.top.equalTo(middleFlightInfoMiddleView.snp.bottom)
            make.height.equalTo(37)
            
            make.bottom.equalTo(0)
        }
        let bottomTitlelabel = UILabel(text: "查看退改签规则", color: TBIThemeBlueColor, size: 11)
        middleFlightInfoBottomView.addSubview(bottomTitlelabel)
        bottomTitlelabel.snp.makeConstraints{(make)->Void in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
        let bottomSegLine = UIView()
        bottomSegLine.backgroundColor = TBIThemeGrayLineColor
        middleFlightInfoBottomView.addSubview(bottomSegLine)
        bottomSegLine.snp.makeConstraints{(make)->Void in
            make.left.right.equalTo(0)
            make.top.equalToSuperview()
            
            make.height.equalTo(0.5)
        }
    }
    
    
    //中间的乘机人容器视图
    func layoutMiddlePsgContainerView() -> Void
    {
        middlePsgContainerView = UIView()
        middlePsgContainerView.backgroundColor = .white
        myScrollContentView.addSubview(middlePsgContainerView)
        middlePsgContainerView.snp.makeConstraints{(make)->Void in
            make.left.right.equalTo(0)
            make.top.equalTo(middleFlightInfoView.snp.bottom).offset(10)
        }
        
        var lastPsgItemView:UIView! = nil
        for i in 0..<psgCount
        {
            let psgItemView:PsgOrderDetailsItemCell = PsgOrderDetailsItemCell()
            psgItemView.isGoBack = self.isGOBackJourney
            psgItemView.orderStatue = flightOrderStatus
            print("******isGoBack = \(psgItemView.isGoBack)")
            print("******psgItemView.orderStatue = \(psgItemView.orderStatue)")
            psgItemView.initView()
            middlePsgContainerView.addSubview(psgItemView)
            psgItemView.snp.makeConstraints{(make)->Void in
                make.left.right.equalTo(0)
                
                if i == 0
                {
                    make.top.equalTo(0)
                }
                else
                {
                    make.top.equalTo(lastPsgItemView.snp.bottom)
                }
                
                if i == psgCount-1
                {
                    make.bottom.equalTo(0)
                }
            }
            lastPsgItemView  = psgItemView
            if i == psgCount-1
            {
                psgItemView.bottomSegView.isHidden = true
            }
            
            
            if !isGOBackJourney   //单程
            {
                let guest = guestListArray[0][i]
                
                //有票号
                if(flightOrderStatus == .finished || flightOrderStatus == .exit || flightOrderStatus == .line)//往返程
                {
                    psgItemView.rightContentLabelList[0].text = guest.guestName
                    psgItemView.rightContentLabelList[1].text = "身份证"+guest.guestCardID
                    psgItemView.rightContentLabelList[2].text = "常旅卡号"+guest.guestTravelID
                    psgItemView.rightContentLabelList[3].text = "票号"+guest.flightNumber
                }
                else //无票号
                {
                    psgItemView.rightContentLabelList[0].text = guest.guestName
                    psgItemView.rightContentLabelList[1].text = "身份证"+guest.guestCardID
                    psgItemView.rightContentLabelList[2].text = "常旅卡号"+guest.guestTravelID
                    //psgItemView.rightContentLabelList[3].text = "票号"+guest.flightNumber
                }
                
                //若常旅卡号为空
                if guest.guestTravelID.trimmingCharacters(in: .whitespaces) == ""
                {
                    psgItemView.rightContentLabelList[2].snp.updateConstraints{(make)->Void in
                        make.top.equalTo(psgItemView.rightContentLabelList[1].snp.bottom).offset(-16)
                    }
                    psgItemView.rightContentLabelList[2].isHidden = true
                }
                
            }
            else //往返程
            {
                
                let guestGo = guestListArray[0][i]
                let guestBack = guestListArray[1][i]
                
                //有票号
                if(flightOrderStatus == .finished || flightOrderStatus == .exit || flightOrderStatus == .line)//往返程
                {
                    //去返程的常旅卡号和票号需要设置
                    psgItemView.rightContentLabelList[0].text = guestGo.guestName
                    psgItemView.rightContentLabelList[1].text = "身份证"+guestGo.guestCardID
                    psgItemView.rightContentLabelList[2].text = "去程常旅卡号"+guestGo.guestTravelID
                    psgItemView.rightContentLabelList[3].text = "去程票号"+guestGo.flightNumber
                    psgItemView.rightContentLabelList[4].text = "返程常旅卡号"+guestBack.guestTravelID
                    psgItemView.rightContentLabelList[5].text = "返程票号"+guestBack.flightNumber
                    
                    //设置 去返程常旅卡item 是否显示
                    self.setGoBackJourneyCardIsHiden(guestGo: guestGo, guestBack: guestBack, psgItemView: psgItemView,goItemIndex: 2,backItemIndex: 4)
                    
                }
                else //无票号
                {
                    //去返程的常旅卡号和票号需要设置
                    psgItemView.rightContentLabelList[0].text = guestGo.guestName
                    psgItemView.rightContentLabelList[1].text = "身份证"+guestGo.guestCardID
                    psgItemView.rightContentLabelList[2].text = "去程常旅卡号"+guestGo.guestTravelID
                    //psgItemView.rightContentLabelList[3].text = "去程票号"+guestGo.flightNumber
                    psgItemView.rightContentLabelList[3].text = "返程常旅卡号"+guestBack.guestTravelID
                    //psgItemView.rightContentLabelList[5].text = "返程票号"+guestBack.flightNumber
                    
                    //设置 去返程常旅卡item 是否显示
                    self.setGoBackJourneyCardIsHiden(guestGo: guestGo, guestBack: guestBack, psgItemView: psgItemView,goItemIndex: 2,backItemIndex: 3)
                }
                
            }
            
            
        }
        
    }
    
    //设置 去返程常旅卡item 是否显示
    func setGoBackJourneyCardIsHiden(guestGo:FlightOrderDetail.Guest,guestBack:FlightOrderDetail.Guest,psgItemView:PsgOrderDetailsItemCell,goItemIndex:Int,backItemIndex:Int) -> Void
    {
        // 若常旅卡号为空,隐藏该视图   去程
        if guestGo.guestTravelID.trimmingCharacters(in: .whitespaces) == ""
        {
            //获得当前视图
            let currentView = psgItemView.rightContentLabelList[goItemIndex]
            let preView = psgItemView.rightContentLabelList[goItemIndex-1]
            
            //对当前视图进行布局
            currentView.snp.remakeConstraints{(make)->Void in
                make.left.right.equalTo(0)
                make.top.equalTo(preView.snp.top)
                
                //若返程常旅卡号为空时  ,设置距离底部的约束
                if guestBack.guestTravelID.trimmingCharacters(in: .whitespaces) == ""
                {
                    make.bottom.equalTo(-15)
                }
            }
            
            
            psgItemView.rightContentLabelList[goItemIndex].isHidden = true
            
            
        }
        
        // 若常旅卡号为空,隐藏该视图   返程
        if guestBack.guestTravelID.trimmingCharacters(in: .whitespaces) == ""
        {
            //获得当前视图
            let currentView = psgItemView.rightContentLabelList[backItemIndex]
            let preView = psgItemView.rightContentLabelList[backItemIndex-1]
            
            psgItemView.clipsToBounds = true
            currentView.snp.remakeConstraints{(make)->Void in
                make.left.right.equalTo(0)
                make.top.equalTo(preView.snp.top)
                make.bottom.equalTo(-15)
                
            }
            
            psgItemView.rightContentLabelList[backItemIndex].isHidden = true
        }
        else  //返程常旅卡号 不为空
        {
            // 若常旅卡号为空   去程
            if guestGo.guestTravelID.trimmingCharacters(in: .whitespaces) == ""
            {
                //获得当前视图
                let currentView = psgItemView.rightContentLabelList[backItemIndex]
                let preView = psgItemView.rightContentLabelList[backItemIndex-1]
                
                currentView.snp.remakeConstraints{(make)->Void in
                    make.left.right.equalTo(0)
                    make.top.equalTo(preView.snp.bottom).offset(20)
                    make.bottom.equalTo(-15)
                }
            }
        }
        
        //分割线，隐藏
        if guestGo.guestTravelID.trimmingCharacters(in: .whitespaces) == ""  &&
            guestBack.guestTravelID.trimmingCharacters(in: .whitespaces) == ""
        {
            var lastBottomSegLine:UIView! = nil
            //分割线，隐藏
            for itemView in psgItemView.subviews
            {
                if itemView.tag == 111  //若为分割线，就隐藏
                {
                    lastBottomSegLine = itemView
                }
                for subItemView in itemView.subviews
                {
                    if subItemView.tag == 111  //若为分割线，就隐藏
                    {
                        lastBottomSegLine = subItemView
                    }
                }
            }
            
            lastBottomSegLine.isHidden = true
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
            make.top.equalTo(middlePsgContainerView.snp.bottom).offset(10)
            
        }
        
        let leftContactTxt = UILabel(text: "联系人", color: TBIThemeTipTextColor, size: 13)
        middleContactsView.addSubview(leftContactTxt)
        leftContactTxt.snp.makeConstraints{(make)->Void in
            make.left.top.equalTo(15)
        }
        
        let rightTopContactName = UILabel(text: mContact.contactName, color: TBIThemePrimaryTextColor, size: 13)
        middleContactsView.addSubview(rightTopContactName)
        rightTopContactName.snp.makeConstraints{(make)->Void in
            make.top.equalTo(15)
            make.left.equalTo(100)
        }
        
        let rightBottomContactPhone = UILabel(text: mContact.contactPhone, color: TBIThemePrimaryTextColor, size: 13)
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
        //TODO:报销凭证
        
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
    
    //中间的订票时间⌚️相关的视图
    func layoutTicketTimeView() -> Void
    {
        middleTicketTimeView = UIView()
        middleTicketTimeView.backgroundColor = .white
        myScrollContentView.addSubview(middleTicketTimeView)
        middleTicketTimeView.snp.makeConstraints{(make)->Void in
            make.left.right.equalTo(0)
            make.top.equalTo(freeChargeView.snp.bottom).offset(10)
            
            //make.bottom.equalTo(-20)
        }
        
        var lastItemView:UIView! = nil
        for i in 0..<ticketTimeNum
        {
            let ticketTimeItemCellView = UIView()
            middleTicketTimeView.addSubview(ticketTimeItemCellView)
            ticketTimeItemCellView.snp.makeConstraints{(make)->Void in
                make.left.right.equalTo(0)
                make.height.equalTo(44)
                
                if i == 0
                {
                    make.top.equalTo(0)
                }
                else
                {
                    make.top.equalTo(lastItemView.snp.bottom).offset(1)
                }
                
                if i == ticketTimeNum-1
                {
                    make.bottom.equalTo(0)
                }
            }
            lastItemView = ticketTimeItemCellView
            
            let leftTimelabel = UILabel(text: "订票时间\(i)", color: TBIThemePrimaryTextColor, size: 13)
            ticketTimeItemCellView.addSubview(leftTimelabel)
            leftTimelabel.snp.makeConstraints{(make)->Void in
                make.left.equalTo(15)
                make.centerY.equalToSuperview()
            }
            
            let rightTimeLabel = UILabel(text: "订票内容\(i)", color: TBIThemePrimaryTextColor, size: 13)
            ticketTimeItemCellView.addSubview(rightTimeLabel)
            rightTimeLabel.snp.makeConstraints{(make)->Void in
                make.right.equalTo(-15)
                make.centerY.equalToSuperview()
            }
            
            //添加分割线
            if i != ticketTimeNum-1
            {
                let bottomSegView = UIView()
                bottomSegView.backgroundColor = TBIThemeGrayLineColor
                ticketTimeItemCellView.addSubview(bottomSegView)
                bottomSegView.snp.makeConstraints{(make)->Void in
                    make.left.right.equalTo(0)
                    make.bottom.equalTo(0)
                    make.height.equalTo(1)
                }
            }
            
            
            
            //TODO:根据服务器获取的数据进行 "订票时间" Tab相关的显示
            if i == 0
            {
                leftTimelabel.text = "订票时间"
                
                rightTimeLabel.text = "\(orderTime.year)-\(orderTime.month)-\(orderTime.day) "+numChangeTwoDigital(num: orderTime.hour)+":"+numChangeTwoDigital(num: orderTime.minute)
            }
            else if i>0
            {
                var leftContentStr = ""
                let operateMsg = operateMsgs[i-1]
                
                /// - fade: 退
                /// - modify: 改
                /// - unknow: 未知
                switch operateMsg.operateType
                {
                case .fade:
                    leftContentStr = "退票时间"
                case .modify:
                    leftContentStr = "改签时间"
                case .unknow:
                    leftContentStr = "未知时间"
                }
                
                leftTimelabel.text = leftContentStr
                
                rightTimeLabel.text = "\(operateMsg.createDate.year)-\(operateMsg.createDate.month)-\(operateMsg.createDate.day) "+numChangeTwoDigital(num: operateMsg.createDate.hour)+":"+numChangeTwoDigital(num: operateMsg.createDate.minute)
            }
            
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
            make.top.equalTo(middleTicketTimeView.snp.bottom).offset(15)
            
            make.height.equalTo(47)
            
            make.bottom.equalTo(-15)
        }
        
        bottomBtn.backgroundColor = TBIThemeBlueColor
    }
    
}


extension PFlightOrderDetailsView
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
    
    
    
    
    
    //填充航班信息View的List
    func updateFlightInfView() -> Void
    {
        //单程
        if flightDetailDataList.count <= 1
        {
            let flightDetail:FlightOrderDetail.FlightDetail = flightDetailDataList[0]
            
            for i in 0..<flightDetail.legs.count
            {
                
                let flightLeg = flightDetail.legs[i]
                let flightCellView:FlightOrderDetailsItemCell = flightCellViewList[i]
                
                setOneFlifhtInfoView(flightCellView: flightCellView, flightDetail: flightDetail, flightLeg: flightLeg, isGOType: nil)
                
            }
        }
        else if flightDetailDataList.count <= 2   //往返程
        {
            //去程
            let flightDetailGo:FlightOrderDetail.FlightDetail = flightDetailDataList[0]
            for i in 0..<flightDetailGo.legs.count
            {
                
                let flightLeg = flightDetailGo.legs[i]
                let flightCellView:FlightOrderDetailsItemCell = flightCellViewList[i]
                
                setOneFlifhtInfoView(flightCellView: flightCellView, flightDetail: flightDetailGo, flightLeg: flightLeg, isGOType: "去")
                
            }
            
            //返程
            let flightDetailBack:FlightOrderDetail.FlightDetail = flightDetailDataList[1]
            for i in 0..<flightDetailBack.legs.count
            {
                
                let flightLeg = flightDetailBack.legs[i]
                let flightCellView:FlightOrderDetailsItemCell = flightCellViewList[i+flightDetailGo.legs.count]
                
                setOneFlifhtInfoView(flightCellView: flightCellView, flightDetail: flightDetailBack, flightLeg: flightLeg, isGOType: "返")
                
            }
        }
    }
    
    func setOneFlifhtInfoView(flightCellView:FlightOrderDetailsItemCell,flightDetail:FlightOrderDetail.FlightDetail,flightLeg:FlightOrderDetail.FlightDetail.Leg,isGOType:String!) -> Void
    {
        
        if let isGOTypeStr =  isGOType
        {
            flightCellView.typeLabel.isHidden = false
            flightCellView.typeLabel.text = isGOTypeStr
            
        }
        else
        {
            flightCellView.typeLabel.isHidden = true
            
            //当最左侧的：“去”／“返”隐藏时
            flightCellView.airCompanyImage.snp.remakeConstraints{(make)->Void in
                make.top.equalTo(13)
                make.width.height.equalTo(12)
                make.left.equalTo(13)
            }
        }
        flightCellView.airCompanyImage.image = UIImage(named: flightDetail.airlineCode)
        
        //需要 航空公司名称+机场二字码+航班号 （如：厦航MF8460）
        flightCellView.flightNameLabel.text = flightDetail.airlineName + flightDetail.airlineCode + flightLeg.flightNo
        
        flightCellView.flightDateLabel.text = "\(flightLeg.takeOffTime.month)月\(flightLeg.takeOffTime.day)日"
        flightCellView.topRightCabinNameLabel.text = flightLeg.cabinType
        
        flightCellView.takeOffCityLabel.text = flightLeg.takeOffCity
        flightCellView.arriveCityLabel.text = flightLeg.arriveCity
        
        flightCellView.takeOffDateLabel.text = numChangeTwoDigital(num: flightLeg.takeOffTime.hour) + ":" + numChangeTwoDigital(num: flightLeg.takeOffTime.minute)
        flightCellView.arriveDateLabel.text = numChangeTwoDigital(num: flightLeg.arriveTime.hour) + ":" + numChangeTwoDigital(num: flightLeg.arriveTime.minute)
        flightCellView.stopOverLabel.isHidden = !flightDetail.stopOver
        
        flightCellView.takeOffAirportLabel.text = flightLeg.takeOffAirline + flightLeg.takeOffTerm
        flightCellView.arriveAirportLabel.text = flightLeg.arriveAirline + flightLeg.arriveTerm
        
        //TODO: 飞机类型（如：波音738） ***暂时先隐藏该View
        //flightCellView.craftTypeLabel.text = flightLeg.
        flightCellView.craftTypeLabel.isHidden = true
    }
}











