//
//  CoOldOrderDetailsFooterView.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/5/23.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class CoOrderDetailsFooterView: UIView
{
    //送审订单
    static let STATUS_BTN_TO_REVIEW = 1001
    //提交订单
    static let STATUS_BTN_COMMIT_ORDER = 1002
    //撤回订单
    static let STATUS_BTN_BACK_ORDER = 1003
    
    //确认提交订单
    static let STATUS_BTN_CONFORM_SUBMIT_ORDER = 1004
    
    
    //添加机票
    static let ADD_FLIGHT_CLK = "ADD_FLIGHT_CLK"
    //添加酒店
    static let ADD_HOTEL_CLK = "ADD_HOTEL_CLK"
    //添加火车票
    static let ADD_TRAIN_CLK = "ADD_TRAIN_CLK"
    //添加专车
    static let ADD_CAR_CLK = "ADD_CAR_CLK"
    //取消送审
    static let CANCEL_REVIEW_CLK = "CANCEL_REVIEW_CLK"
    //去送审
    static let TO_REVIEW_CLK = "TO_REVIEW_CLK"
    

    //审批记录的个数
    var reviewItemCount = 3
    var reviewRecordArray:[(String,String,Int,Bool)] = []
    
    var onFooterListener:OnMyTableViewFooterListener!
    
    
    //审批记录整个Tab的容器视图
    @IBOutlet weak var approvalRecordContainer: UIView!
    @IBOutlet weak var approvalRecordContainerBottomSegLine: UIView!
    
    
    
    //审批记录的内容 的 容器视图
    @IBOutlet weak var view_review_content_container: UIView!
    
    
    //添加机票酒店的容器视图
    @IBOutlet weak var view_addflighthotel_container: UIView!
    @IBOutlet weak var view_addflighthotel_container_bottom_segline: UIView!
    
    
    //添加机票的容器视图
    @IBOutlet weak var view_add_flight_container: UIView!
    //添加酒店的容器视图
    @IBOutlet weak var view_add_hotel_container: UIView!
    
    let addFilght = CoOrderAddCellView(imageName: "ic_c_add_ticket", title: "添加机票")
    
    let addHotel  = CoOrderAddCellView(imageName: "ic_c_add_hotel", title: "添加酒店")
    
    let addTrain  = CoOrderAddCellView(imageName: "ic_c_add_train", title: "添加火车票")
    
    let addCar    = CoOrderAddCellView(imageName: "ic_c_add_car", title: "添加专车")
    
    //底部送审的容器视图
    @IBOutlet weak var view_bottom_review_container: UIView!
    
    //底部的取消送审btn
    @IBOutlet private weak var btn_bottom_cancel_review: UIButton!
    //底部的送审视图
    @IBOutlet private weak var btn_bottom_to_review: UIButton!
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        //print("^_^ CoOldOrderDetailsFooterView")
        
        //addReviewContentItemView()
        
        self.backgroundColor = TBIThemeBaseColor
        
        //设置包含送审和取消送审的容器视图 height = 0
//        for c0 in view_bottom_review_container.constraints
//        {
//            if c0.firstAttribute == .height
//            {
//                c0.constant = 0
//            }
//        }
        if UserService.sharedInstance.userDetail()?.companyUser?.newVersion ?? true {
            view_addflighthotel_container.subviews.forEach{$0.removeFromSuperview()}
             //如果是新版走新的布局
            var permissions = 0
            var flightPermission = false
            var hotelPermission = false
            var trainPermission = false
            var carPermission = false
            if UserService.sharedInstance.userDetail()?.companyUser?.permissions.contains(.flight) ?? false{
                permissions = permissions + 1
                flightPermission = true
                if 1 == permissions {
                    addFilght.line.isHidden = true
                }
            }
            if UserService.sharedInstance.userDetail()?.companyUser?.permissions.contains(.hotel) ?? false{
                permissions = permissions + 1
                hotelPermission = true
                if 1 == permissions {
                    addHotel.line.isHidden = true
                }
            }
            if UserService.sharedInstance.userDetail()?.companyUser?.permissions.contains(.train) ?? false{
                permissions = permissions + 1
                trainPermission = true
                if 1 == permissions {
                    addTrain.line.isHidden = true
                }
            }
            if UserService.sharedInstance.userDetail()?.companyUser?.permissions.contains(.car) ?? false{
                permissions = permissions + 1
                carPermission = true
                if 1 == permissions {
                    addCar.line.isHidden = true
                }
            }
            view_addflighthotel_container.addSubview(addFilght)
            if flightPermission {
                addFilght.snp.makeConstraints({ (make) in
                    make.left.top.bottom.equalToSuperview()
                    make.width.equalToSuperview().dividedBy(permissions)
                })
            }else {
                addFilght.isHidden = true
                addFilght.snp.makeConstraints({ (make) in
                    make.left.top.bottom.equalToSuperview()
                    make.width.equalTo(0)
                })
            }
            
            view_addflighthotel_container.addSubview(addHotel)
            if hotelPermission {
                addHotel.snp.makeConstraints({ (make) in
                    make.top.bottom.equalToSuperview()
                    make.left.equalTo(addFilght.snp.right)
                    make.width.equalToSuperview().dividedBy(permissions)
                })
            }else {
                addHotel.isHidden = true
                addHotel.snp.makeConstraints({ (make) in
                    make.top.bottom.equalToSuperview()
                    make.left.equalTo(addFilght.snp.right)
                    make.width.equalTo(0)
                })
            }
            view_addflighthotel_container.addSubview(addTrain)
            if trainPermission {
                addTrain.snp.makeConstraints({ (make) in
                    make.top.bottom.equalToSuperview()
                    make.left.equalTo(addHotel.snp.right)
                    make.width.equalToSuperview().dividedBy(permissions)
                })
            }else {
                addTrain.isHidden = true
                addTrain.snp.makeConstraints({ (make) in
                    make.top.bottom.equalToSuperview()
                    make.left.equalTo(addHotel.snp.right)
                    make.width.equalTo(0)
                })
            }
            view_addflighthotel_container.addSubview(addCar)
            if carPermission {
                addCar.snp.makeConstraints({ (make) in
                    make.top.bottom.equalToSuperview()
                    make.left.equalTo(addTrain.snp.right)
                    make.width.equalToSuperview().dividedBy(permissions)
                })
            }else {
                addCar.isHidden = true
                addCar.snp.makeConstraints({ (make) in
                    make.top.bottom.equalToSuperview()
                    make.left.equalTo(addTrain.snp.right)
                    make.width.equalTo(0)
                })
            }
            //添加机票
            addFilght.addOnClickListener(target: self, action: #selector(addAirplaneTicketClk))
            //添加酒店
            addHotel.addOnClickListener(target: self, action: #selector(addHotelClk))
            //添加火车票
            addTrain.addOnClickListener(target: self, action: #selector(addTrainClk))
            //添加专车
            addCar.addOnClickListener(target: self, action: #selector(addCarClk))
        }else {
            let lineView0 = UIView()
            view_addflighthotel_container.addSubview(lineView0)
            lineView0.backgroundColor = TBIThemeGrayLineColor
            lineView0.snp.makeConstraints{(make)->Void in
                make.width.equalTo(1)
                make.height.equalTo(50)
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview()
            }
            //view_addflighthotel_container
            
            
            // 丰田销售 定制
            // start of line
            
            if UserService.sharedInstance.userDetail() != nil &&
                UserService.sharedInstance.userDetail()?.companyUser?.companyCode == Toyota
            {
                //showFTMSSpecialConfig = 1
                //   计划中 已拒绝 才显示按钮
                lineView0.isHidden = true
                view_add_flight_container.isHidden = true
                
                view_add_hotel_container.snp.updateConstraints({ (make) in
                    
                    make.top.left.bottom.right.equalToSuperview()
                })
                
                
            }
            
            
            if UserService.sharedInstance.userDetail() != nil &&
                !((UserService.sharedInstance.userDetail()?.companyUser?.permissions.contains(UserDetail.CompanyUser.Permission.flight)) ?? true)
            {
                lineView0.isHidden = true
                view_add_flight_container.isHidden = true
                
                view_add_hotel_container.snp.updateConstraints({ (make) in
                    
                    make.top.left.bottom.right.equalToSuperview()
                })
            }
            
            
            if UserService.sharedInstance.userDetail() != nil &&
                !((UserService.sharedInstance.userDetail()?.companyUser?.permissions.contains(UserDetail.CompanyUser.Permission.hotel)) ?? true)
            {
                lineView0.isHidden = true
                view_add_hotel_container.isHidden = true
                
                view_add_flight_container.snp.updateConstraints({ (make) in
                    
                    make.top.left.bottom.right.equalToSuperview()
                })
            }
            
            
            
            
            // end of line
            
            
            
            
            
            
            //添加机票
            view_add_flight_container.addOnClickListener(target: self, action: #selector(addAirplaneTicketClk))
            //添加酒店
            view_add_hotel_container.addOnClickListener(target: self, action: #selector(addHotelClk))
            
            //取消送审
            btn_bottom_cancel_review.addOnClickListener(target: self, action: #selector(cancelReViewClk))
            //去送审
            btn_bottom_to_review.addOnClickListener(target: self, action: #selector(toReViewClk))
        }
        
        
    }
    
    
    //添加机票
    func addAirplaneTicketClk() -> Void
    {
        //print("addAirplaneTicketClk")
        if onFooterListener != nil
        {
            onFooterListener.onClickListener(tableViewFooter: self, flagStr: CoOrderDetailsFooterView.ADD_FLIGHT_CLK)
        }
    }
    
    //添加酒店
    func addHotelClk() -> Void
    {
        //print("addHotelClk")
        if onFooterListener != nil
        {
            onFooterListener.onClickListener(tableViewFooter: self, flagStr: CoOrderDetailsFooterView.ADD_HOTEL_CLK)
        }
    }
    
    //添加火车票
    func addTrainClk() -> Void
    {
        //print("addHotelClk")
        if onFooterListener != nil
        {
            onFooterListener.onClickListener(tableViewFooter: self, flagStr: CoOrderDetailsFooterView.ADD_TRAIN_CLK)
        }
    }
    
    //添加专车
    func addCarClk() -> Void
    {
        //print("addHotelClk")
        if onFooterListener != nil
        {
            onFooterListener.onClickListener(tableViewFooter: self, flagStr: CoOrderDetailsFooterView.ADD_CAR_CLK)
        }
    }
    //取消送审
    func cancelReViewClk() -> Void
    {
        //print("cancelReViewClk")
        if onFooterListener != nil
        {
            onFooterListener.onClickListener(tableViewFooter: self, flagStr: CoOrderDetailsFooterView.CANCEL_REVIEW_CLK)
        }
    }
    
    //去送审
    func toReViewClk() -> Void
    {
        //print("toReViewClk")
        if onFooterListener != nil
        {
            onFooterListener.onClickListener(tableViewFooter: self, flagStr: CoOrderDetailsFooterView.TO_REVIEW_CLK)
        }
    }
    
    
    
    
    //审批记录的内容 的 容器视图 添加 item
    func addReviewContentItemView() -> Void
    {
        let bigNumArray = ["一","二","三","四","五","六","七","八","九","十","十一","十二","十三","十四","十五"]
        
        reviewItemCount = reviewRecordArray.count
        
        //隐藏之前所有的子视图
        for subView in view_review_content_container.subviews
        {
            subView.isHidden = true
        }
        
        //当没有审批记录时
        if reviewItemCount == 0
        {
            let containerView = UIView()
            view_review_content_container.addSubview(containerView)
            containerView.snp.makeConstraints{(make)->Void in
                make.top.equalTo(25)
                make.left.right.equalTo(0)
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
            
            
            let leftLabel = UILabel(text: "\(bigNumArray[reviewItem.2 - 1])级／\(reviewItem.0)", color: TBIThemePrimaryTextColor, size: 14)
            containerView.addSubview(leftLabel)
            containerView.addSubview(leftLabel)
            leftLabel.snp.makeConstraints{(make)->Void in
                
                make.left.top.bottom.equalTo(0)
            }
            
            let approvalResult:Bool = reviewItem.3
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
    
}

class CoOrderAddCellView: UIView {
    
    fileprivate let icImge:UIImageView!
    
    fileprivate let titleLabel:UILabel!
    
    let line = UILabel(color: TBIThemeGrayLineColor)
    
    init(imageName:String,title:String) {
        icImge = UIImageView.init(imageName: imageName)
        titleLabel =  UILabel(text: title, color: TBIThemeMinorTextColor, size: 12)
        super.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 100))
        self.backgroundColor = TBIThemeWhite
        addSubview(icImge)
        icImge.snp.makeConstraints { (make) in
            make.width.height.equalTo(44)
            make.top.equalTo(15)
            make.centerX.equalToSuperview()
        }
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(icImge.snp.bottom).offset(10)
        }
        addSubview(line)
        line.snp.makeConstraints { (make) in
            make.width.equalTo(1)
            make.height.equalTo(50)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
