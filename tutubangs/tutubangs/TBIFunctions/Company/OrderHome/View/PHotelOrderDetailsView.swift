//
//  PHotelOrderDetailsView.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/6/28.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class PHotelOrderDetailsView: UIView
{
    //酒店的详情 Data
    var hotelOrderDetail:HotelOrderDetail! = nil
    
    var myScrollView:UIScrollView! = nil
    var myScrollContentView:UIView! = nil
    
    //头部的酒店🏨状态的视图
    var topOrderStatusView:TopOrderStatusView! = nil
    //价格明细对应的点击事件View（热区）
    let topRightPriceDetailsTapArea = UIView()
    //修改订单按钮🔘
    var topLeftChangeTicketView:UIView! = nil
    //联系酒店按钮🔘
    var topRightContactHotelView:UIView! = nil
    
    //中间酒店名称的容器视图
    var middleHotelNameView:UIView! = nil
    //中间房间信息的容器视图
    var middleRoomTabView:UIView! = nil
    //中间的入住人的容器视图
    var middlePsgTabView:UIView! = nil
    //布局预定日期选项卡
    var middleReserveDateView:UIView! = nil
    //最底部联系客服Btn🔘
    var bottomBtn:UIButton! = nil
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        //initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        //设置头部的订单状态的整体View
        layoutTopOrderStatusView()
        layoutMiddleHotelNameView()
        layoutMiddleRoomTabView()
        layoutMiddlePsgTabView()
        layoutMiddleReserveDateView()
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
        
        //左半部分
        //let leftTopShowStatusLabel = UILabel(text: "已订妥", color: TBIThemeOrangeColor, size: 16)
        topOrderStatusView.addSubview(topOrderStatusView.leftTopShowStatusLabel)
        topOrderStatusView.leftTopShowStatusLabel.snp.makeConstraints{(make)->Void in
            make.left.top.equalTo(15)
        }
        //let middleOrderNoLabel = UILabel(text: "订单编号8888888888888", color: TBIThemePrimaryTextColor, size: 11)
        topOrderStatusView.addSubview(topOrderStatusView.middleOrderNoLabel)
        topOrderStatusView.middleOrderNoLabel.snp.makeConstraints{(make)->Void in
            make.left.equalTo(15)
            make.top.equalTo(topOrderStatusView.leftTopShowStatusLabel.snp.bottom).offset(2)
        }
        
        //左部分：底部的按钮🔘
        let leftBottomContainerView = UIView()
        leftBottomContainerView.layer.cornerRadius = 5
        topLeftChangeTicketView = leftBottomContainerView
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
        let leftBottomContentImageView = UIImageView(imageName: "ic_customer service_white")
        //leftBottomContentImageView.backgroundColor = .red
        leftBottomContentView.addSubview(leftBottomContentImageView)
        leftBottomContentImageView.snp.makeConstraints{(make)->Void in
            make.left.top.bottom.equalTo(0)
            
            make.width.equalTo(18)
            make.height.equalTo(16)
        }
        let leftBottomContentLabel = UILabel(text: "修改订单", color: .white, size: 14)
        leftBottomContentView.addSubview(leftBottomContentLabel)
        leftBottomContentLabel.snp.makeConstraints{(make)->Void in
            make.right.top.bottom.equalTo(0)
            make.left.equalTo(leftBottomContentImageView.snp.right).offset(5)
        }
        
        //右半部分
        //let rightTopShowPriceLabel = UILabel(text: "¥650", color: TBIThemeOrangeColor, size: 16)
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
        //***** 到店支付
        //let rightMiddlePayWayLabel = UILabel(text: "到店支付", color: TBIThemePrimaryTextColor, size: 11)
        topOrderStatusView.addSubview(topOrderStatusView.rightMiddlePayWayLabel)
        topOrderStatusView.rightMiddlePayWayLabel.snp.makeConstraints{(make)->Void in
            make.right.equalTo(topOrderStatusView.rightTopShowPriceLabel.snp.left).offset(-5)
            
            make.bottom.equalTo(topOrderStatusView.rightTopShowPriceLabel.snp.bottom).offset(-2)
        }
        
        
        //右部分：底部的按钮🔘
        let rightBottomContainerView = UIView()
        rightBottomContainerView.layer.cornerRadius = 5
        topRightContactHotelView = rightBottomContainerView
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
        let rightBottomContentImageView = UIImageView(imageName: "ic_customer service_white")
        //rightBottomContentImageView.backgroundColor = .red
        rightBottomContentView.addSubview(rightBottomContentImageView)
        rightBottomContentImageView.snp.makeConstraints{(make)->Void in
            make.left.top.bottom.equalTo(0)
            
            make.width.equalTo(18)
            make.height.equalTo(16)
        }
        let rightBottomContentLabel = UILabel(text: "联系酒店", color: .white, size: 14)
        rightBottomContentView.addSubview(rightBottomContentLabel)
        rightBottomContentLabel.snp.makeConstraints{(make)->Void in
            make.right.top.bottom.equalTo(0)
            make.left.equalTo(rightBottomContentImageView.snp.right).offset(5)
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
    
    //设置酒店名称的视图
    func layoutMiddleHotelNameView() -> Void
    {
        middleHotelNameView = UIView()
        middleHotelNameView.backgroundColor = .white
        myScrollContentView.addSubview(middleHotelNameView)
        middleHotelNameView.snp.makeConstraints{(make)->Void in
            make.left.right.equalTo(0)
            make.top.equalTo(topOrderStatusView.snp.bottom).offset(10)
        }

        let topHotelNameLabel = UILabel(text: hotelOrderDetail.hotelName, color: TBIThemePrimaryTextColor, size: 16)
        middleHotelNameView.addSubview(topHotelNameLabel)
        topHotelNameLabel.snp.makeConstraints{(make)->Void in
            make.left.top.equalTo(15)
            make.right.equalTo(-15)
        }
        let bottomSubHotelAddressLabel = UILabel(text: hotelOrderDetail.hotelAddress, color: TBIThemeTipTextColor, size: 13)
        middleHotelNameView.addSubview(bottomSubHotelAddressLabel)
        bottomSubHotelAddressLabel.snp.makeConstraints{(make)->Void in
            make.left.equalTo(15)
            make.top.equalTo(topHotelNameLabel.snp.bottom).offset(6)
            make.right.equalTo(-15)
            make.bottom.equalTo(-15)
        }
    }
    
    
    //设置房间信息的视图
    func layoutMiddleRoomTabView() -> Void
    {
        middleRoomTabView = UIView()
        middleRoomTabView.backgroundColor = .white
        myScrollContentView.addSubview(middleRoomTabView)
        middleRoomTabView.snp.makeConstraints{(make)->Void in
            make.left.right.equalTo(0)
            make.top.equalTo(middleHotelNameView.snp.bottom).offset(10)
        }
        //高级大床房
        let topBedNameLabel = UILabel(text: hotelOrderDetail.roomName, color: TBIThemePrimaryTextColor, size: 16)
        middleRoomTabView.addSubview(topBedNameLabel)
        topBedNameLabel.snp.makeConstraints{(make)->Void in
            make.left.top.equalTo(15)
            make.right.equalTo(-15)
        }
        //4月7日 - 4月9日 2晚 2间
        let bedDateStr = "\(hotelOrderDetail.arrivalDate.month)月\(hotelOrderDetail.arrivalDate.day)日" + " - " +
        "\(hotelOrderDetail.departureDate.month)月\(hotelOrderDetail.departureDate.day)日" + " " +
        "\(hotelOrderDetail.nightDay)晚" + " " + "\(hotelOrderDetail.numberOfRooms)间"
        let middleBedDateLabel = UILabel(text: bedDateStr, color: TBIThemePrimaryTextColor, size: 13)
        middleRoomTabView.addSubview(middleBedDateLabel)
        middleBedDateLabel.snp.makeConstraints{(make)->Void in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(topBedNameLabel.snp.bottom).offset(6)
        }
        
        //含早 | 单床1.8米
        let bedOtherInfStr = hotelOrderDetail.productBreakfast + " | " + hotelOrderDetail.roomBedType
        let bottomBedOtherInfLabel = UILabel(text: bedOtherInfStr, color: TBIThemeTipTextColor, size: 13)
        middleRoomTabView.addSubview(bottomBedOtherInfLabel)
        bottomBedOtherInfLabel.snp.makeConstraints{(make)->Void in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(middleBedDateLabel.snp.bottom).offset(6)
            make.bottom.equalTo(-15)
        }
    }
    
    //设置入住人的视图
    func layoutMiddlePsgTabView() -> Void
    {
        var psgTabDataSource:[(String,String)] = []
        //TODO: "入住人" 可能为 多个
        psgTabDataSource.append(("入住人",hotelOrderDetail.customerName))
        psgTabDataSource.append(("联系人",hotelOrderDetail.contactName))
        psgTabDataSource.append(("联系电话",hotelOrderDetail.contactPhone))
        psgTabDataSource.append(("特殊要求",hotelOrderDetail.noteToHotel))
        let lastArriveHotelStr = "最晚" + numChangeTwoDigital(num:hotelOrderDetail.latestArrlivalTime.hour) + ":" + numChangeTwoDigital(num: hotelOrderDetail.latestArrlivalTime.minute) + "前"
        psgTabDataSource.append(("到店时间",lastArriveHotelStr))
        
        middlePsgTabView = UIView()
        middlePsgTabView.backgroundColor = .white
        myScrollContentView.addSubview(middlePsgTabView)
        middlePsgTabView.snp.makeConstraints{(make)->Void in
            make.left.right.equalTo(0)
            make.top.equalTo(middleRoomTabView.snp.bottom).offset(10)
        }
        
        //let itemCount = 5
        let itemCount = psgTabDataSource.count
        
        var lastItemView:UIView! = nil
        for i in 0..<itemCount
        {
            let itemContainerView = UIView()
            middlePsgTabView.addSubview(itemContainerView)
            itemContainerView.snp.makeConstraints{(make)->Void in
                make.left.right.equalTo(0)
                if i == 0
                {
                    make.top.equalTo(15)
                }
                else
                {
                    make.top.equalTo(lastItemView.snp.bottom).offset(10)
                }
                
                if i == itemCount-1
                {
                    make.bottom.equalTo(-15)
                }
            }
            lastItemView = itemContainerView
            
            
            
            let leftLabel = UILabel(text: "left \(i)", color: TBIThemeTipTextColor, size: 13)
            itemContainerView.addSubview(leftLabel)
            leftLabel.snp.makeConstraints{(make)->Void in
                make.left.equalTo(15)
                make.top.bottom.equalTo(0)
                make.width.equalTo(80)
            }
            let rightLabel = UILabel(text: "入住人 right \(i)", color: TBIThemePrimaryTextColor, size: 13)
            itemContainerView.addSubview(rightLabel)
            rightLabel.snp.makeConstraints{(make)->Void in
                make.left.equalTo(100)
                make.top.bottom.equalTo(0)
                make.right.equalTo(-15)
            }
            
            leftLabel.text = psgTabDataSource[i].0
            rightLabel.text = psgTabDataSource[i].1
        }
    }
    
    //布局预定日期选项卡视图
    func layoutMiddleReserveDateView() -> Void
    {
        var reserveDateTabDataSource:[(String,String)] = []
        let reserveDateStr = "\(hotelOrderDetail.createDate.year)" + "-" + numChangeTwoDigital(num: hotelOrderDetail.createDate.month) + "-" + numChangeTwoDigital(num: hotelOrderDetail.createDate.day)
        + " " + numChangeTwoDigital(num: hotelOrderDetail.createDate.hour) + ":" + numChangeTwoDigital(num: hotelOrderDetail.createDate.minute)
        reserveDateTabDataSource.append(("预定日期",reserveDateStr))
        let hotelGuaranteeStr = hotelOrderDetail.isGuarantee ? "担保" : "未担保"
        reserveDateTabDataSource.append(("担保情况",hotelGuaranteeStr))
        
        
        middleReserveDateView = UIView()
        middleReserveDateView.backgroundColor = .white
        myScrollContentView.addSubview(middleReserveDateView)
        middleReserveDateView.snp.makeConstraints{(make)->Void in
            make.left.right.equalTo(0)
            make.top.equalTo(middlePsgTabView.snp.bottom).offset(10)
        }
        
        //let itemCount = 2
        let itemCount = reserveDateTabDataSource.count
        
        var lastItemView:UIView! = nil
        for i in 0..<itemCount
        {
            let itemContainerView = UIView()
            middleReserveDateView.addSubview(itemContainerView)
            itemContainerView.snp.makeConstraints{(make)->Void in
                make.left.right.equalTo(0)
                if i == 0
                {
                    make.top.equalTo(15)
                }
                else
                {
                    make.top.equalTo(lastItemView.snp.bottom).offset(10)
                }
                
                if i == itemCount-1
                {
                    make.bottom.equalTo(-15)
                }
            }
            lastItemView = itemContainerView
            
            
            
            let leftLabel = UILabel(text: "left \(i)", color: TBIThemeTipTextColor, size: 13)
            itemContainerView.addSubview(leftLabel)
            leftLabel.snp.makeConstraints{(make)->Void in
                make.left.equalTo(15)
                make.top.bottom.equalTo(0)
                make.width.equalTo(80)
            }
            let rightLabel = UILabel(text: "日期选项 right \(i)", color: TBIThemePrimaryTextColor, size: 13)
            itemContainerView.addSubview(rightLabel)
            rightLabel.snp.makeConstraints{(make)->Void in
                make.left.equalTo(100)
                make.top.bottom.equalTo(0)
                make.right.equalTo(-15)
            }
            
            
            leftLabel.text = reserveDateTabDataSource[i].0
            rightLabel.text = reserveDateTabDataSource[i].1
        }
    }
    
    //最底部的联系客服按钮🔘
    func layoutBottomBtn() -> Void
    {
        bottomBtn = UIButton(title: "联系客服", titleColor: .white, titleSize: 18)
        bottomBtn.layer.cornerRadius = 5
        myScrollContentView.addSubview(bottomBtn)
        bottomBtn.snp.makeConstraints{(make)->Void in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(middleReserveDateView.snp.bottom).offset(15)
            
            make.height.equalTo(47)
            
            make.bottom.equalTo(-15)
        }
        
        bottomBtn.backgroundColor = TBIThemeBlueColor
    }

}

extension PHotelOrderDetailsView
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
        let middleOrderNoLabel = UILabel(text: "订单编号8888888888888", color: TBIThemePrimaryTextColor, size: 11)
        
        //右半部分
        let rightTopShowPriceLabel = UILabel(text: "¥650", color: TBIThemeOrangeColor, size: 16)
        let rightMiddlePriceDetailsLabel = UILabel(text: "价格明细", color: TBIThemePrimaryTextColor, size: 11)
        //到店支付
        let rightMiddlePayWayLabel = UILabel(text: "到店支付", color: TBIThemePrimaryTextColor, size: 11)
    }
}




