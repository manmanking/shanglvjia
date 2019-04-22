//
//  CoOldOrderDetailsFooterView.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/5/23.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class CoOldOrderDetailsFooterView: UIView
{
    //添加机票
    static let ADD_FLIGHT_CLK = "ADD_FLIGHT_CLK"
    //添加酒店
    static let ADD_HOTEL_CLK = "ADD_HOTEL_CLK"
    //取消送审
    static let CANCEL_REVIEW_CLK = "CANCEL_REVIEW_CLK"
    //去送审
    static let TO_REVIEW_CLK = "TO_REVIEW_CLK"
    

    //审批记录的个数
    var reviewItemCount = 3
    var reviewRecordArray:[(String,String,Bool)] = []
    
    var onFooterListener:OnMyTableViewFooterListener!
    
    
    
    //审批记录的内容 的 容器视图
    @IBOutlet weak var view_review_content_container: UIView!
    
    
    //添加机票的容器视图
    @IBOutlet weak var view_add_flight_container: UIView!
    //添加酒店的容器视图
    @IBOutlet weak var view_add_hotel_container: UIView!
    
    //底部的取消送审btn
    @IBOutlet weak var btn_bottom_cancel_review: UIButton!
    //底部的送审视图
    @IBOutlet weak var btn_bottom_to_review: UIButton!
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        //print("^_^ CoOldOrderDetailsFooterView")
        
        //addReviewContentItemView()
        
        //添加机票
        view_add_flight_container.addOnClickListener(target: self, action: #selector(addAirplaneTicketClk))
        //添加酒店
        view_add_hotel_container.addOnClickListener(target: self, action: #selector(addHotelClk))
        
        //取消送审
        btn_bottom_cancel_review.addOnClickListener(target: self, action: #selector(cancelReViewClk))
        //去送审
        btn_bottom_to_review.addOnClickListener(target: self, action: #selector(toReViewClk))
    }
    
    
    //添加机票
    func addAirplaneTicketClk() -> Void
    {
        //print("addAirplaneTicketClk")
        if onFooterListener != nil
        {
            onFooterListener.onClickListener(tableViewFooter: self, flagStr: CoOldOrderDetailsFooterView.ADD_FLIGHT_CLK)
        }
    }
    
    //添加酒店
    func addHotelClk() -> Void
    {
        //print("addHotelClk")
        if onFooterListener != nil
        {
            onFooterListener.onClickListener(tableViewFooter: self, flagStr: CoOldOrderDetailsFooterView.ADD_HOTEL_CLK)
        }
    }
    
    //取消送审
    func cancelReViewClk() -> Void
    {
        //print("cancelReViewClk")
        if onFooterListener != nil
        {
            onFooterListener.onClickListener(tableViewFooter: self, flagStr: CoOldOrderDetailsFooterView.CANCEL_REVIEW_CLK)
        }
    }
    
    //去送审
    func toReViewClk() -> Void
    {
        //print("toReViewClk")
        if onFooterListener != nil
        {
            onFooterListener.onClickListener(tableViewFooter: self, flagStr: CoOldOrderDetailsFooterView.TO_REVIEW_CLK)
        }
    }
    
    
    
    
    //审批记录的内容 的 容器视图 添加 item
    func addReviewContentItemView() -> Void
    {
        let bigNumArray = ["一","二","三","四","五","六","七","八","九"]
        
        reviewItemCount = reviewRecordArray.count
        
        //隐藏之前所有的子视图
        for subView in view_review_content_container.subviews
        {
            subView.isHidden = true
        }
        
        
        
        var lastContainerView:UIView!
        
        
        for i in 0..<reviewItemCount
        {
            let reviewItem = reviewRecordArray[i]
            
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
                
                if i == reviewItemCount-1
                {
                    make.bottom.equalTo(-25)
                }
                
                make.left.right.equalTo(0)
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
            
            let textColor = approvalResult ? TBIThemeGreenColor :TBIThemeBlueColor
            let rightLabel = UILabel(text: "\(reviewItem.1)    \(approvalResultStr)", color: textColor, size: 14)
            
            containerView.addSubview(rightLabel)
            rightLabel.snp.makeConstraints{(make)->Void in
                
                make.right.top.bottom.equalTo(0)
            }
            
            
            lastContainerView = containerView
        }
    }
    
    
    
    
    
    
    
    
    
    
}
