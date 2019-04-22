//
//  CoOldOrderDetailsCellViewFlight.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/5/24.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class CoOrderDetailsCellViewFlight:UITableViewCell{

    //TODO:展开关闭详情  点击相关tablecell里的view。 分别需要作出回调的tag标志
    static let FLIGHT_SHOWHIDE_DETAILS = "FLIGHT_SHOWHIDE_DETAILS"
    
    static let FLIGHT_LOOK_CHARGE = "FLIGHT_LOOK_CHARGE"
    static let FLIGHT_CHANGE_POLICY = "FLIGHT_CHANGE_POLICY"
    
    static let FLIGHT_DEL_ORDER = "FLIGHT_DEL_ORDER"
    
    //cell显示隐藏的delegate
    public var cellShowHideListener:OnTableCellShowHideListener!
    public var indexPath:IndexPath!
    
    var passageItemCount = 0
    
    
    
    @IBOutlet weak var flight_insurance: UIImageView!
    
    //头部的机票订单状态
    @IBOutlet weak var btn_flight_order_status: UIButton!
    //头部的大标题
    @IBOutlet weak var label_top_big_title: UILabel!
    //头部的小标题
    @IBOutlet weak var label_top_sub_title: UILabel!
    //头部的显示隐藏信息的btn
    @IBOutlet weak var btn_top_show_hide_info: UIButton!
    //显示隐藏信息的容器View
    @IBOutlet weak var view_show_hide_info_container: UIView!
    
    //头部的阴影分割线
    @IBOutlet weak var top_shadow_5_line_view: UIView!
    
    
    //中间展示详情视图的大容器
    @IBOutlet weak var view_middlle_total_container: UIView!
    //违背政策的容器视图
    @IBOutlet weak var view_nofit_policy_container: UIView!
    //不符合政策下方的分割线
    @IBOutlet weak var view_notfit_policy_bottom_line: UIView!
    
    //乘机人的Tab
    @IBOutlet weak var view_middle_passage_container_view: UIView!
    
    
    
    //违背政策的Tab
    //违背政策的内容
    @IBOutlet weak var label_nofit_policy_content: UILabel!
    //违背政策的原因的内容
    @IBOutlet weak var label_notfit_policy_reason_content: UILabel!
    
    //机票航班的Tab
    //机票航班的内容
    @IBOutlet weak var label_ticket_num_content: UILabel!
    //飞行时长的内容
    @IBOutlet weak var label_fly_time_content: UILabel!
    //仓位的内容
    @IBOutlet weak var label_cabin_content: UILabel!
    
    //机票费用的内容
    @IBOutlet weak var label_ticket_charge_content: UILabel!
    //退改政策的内容
    @IBOutlet weak var label_change_policy_content: UILabel!
    
    //联系人Tab
    //联系人的内容
    @IBOutlet weak var label_passage_name_content: UILabel!
    //联系手机的内容
    @IBOutlet weak var label_contact_phone_content: UILabel!
    //身份证件的内容
    @IBOutlet weak var label_identity_num_content: UILabel!
    
    
    
    //底部联系人的Tab
    //底部联系人姓名的内容
    @IBOutlet weak var label_bottom_contact_name_content: UILabel!
    //底部联系人手机的内容
    @IBOutlet weak var label_bottom_contact_phone: UILabel!
    //底部联系人邮箱的内容
    @IBOutlet weak var label_bottom_contact_email: UILabel!
    
    
    
    //总价格上面的分割线
    @IBOutlet weak var view_total_price_top_line: UIView!
    //价格的Tab
    //价格
    @IBOutlet weak var label_order_price: UILabel!
    //删除订单的btn
    @IBOutlet weak var btn_right_del_order: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initView()
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//    }
    
    
    
    
    func initView() -> Void
    {
        //addPassageInf()
        //showHideNotFitPolicyView(isShow: false)
        
        //头部的阴影分割线
        let shadow_5_line_subView = UIImageView(imageName: "ic_c_shadow")
        top_shadow_5_line_view.addSubview(shadow_5_line_subView)
        top_shadow_5_line_view.backgroundColor = UIColor.clear
        shadow_5_line_subView.snp.makeConstraints{(make)->Void in
            make.left.right.top.bottom.equalTo(0)
        }
        top_shadow_5_line_view.isHidden = true
        
        //显示隐藏详情
        btn_top_show_hide_info.addOnClickListener(target: self, action: #selector(showHideInfoClk))
        
        //机票费用的详情Label
        label_ticket_charge_content.addOnClickListener(target: self, action:#selector(ticketChargeInfoClk))
        
        //退改政策的查看详情的Label
        label_change_policy_content.addOnClickListener(target: self, action:#selector(changePolicyClk))
        
        //删除订单的btn
        btn_right_del_order.addOnClickListener(target: self, action:#selector(delOrderClk))
    }
    
    
    
    //显示隐藏订单的详细信息
    @objc private func showHideInfoClk()
    {
        
        cellShowHideListener.onShowHide(tableCell: self, flagStr: CoOrderDetailsCellViewFlight.FLIGHT_SHOWHIDE_DETAILS, indexPath: indexPath)
        
    }

    //机票费用的详情Label
    @objc private func ticketChargeInfoClk()
    {
        cellShowHideListener.onShowHide(tableCell: self, flagStr: CoOrderDetailsCellViewFlight.FLIGHT_LOOK_CHARGE, indexPath: indexPath)
    }
    
    //退改政策的查看详情的Label
    @objc private func changePolicyClk()
    {
        cellShowHideListener.onShowHide(tableCell: self, flagStr: CoOrderDetailsCellViewFlight.FLIGHT_CHANGE_POLICY, indexPath: indexPath)
    }
    
    //删除订单的btn
    @objc private func delOrderClk()
    {
        cellShowHideListener.onShowHide(tableCell: self, flagStr: CoOrderDetailsCellViewFlight.FLIGHT_DEL_ORDER, indexPath: indexPath)
    }
    
    
    
    //TODO:待优化   动态添加乘机人信息  老版
    func addPassageInf(passengers:[CoOldOrderDetail.FlightVo.Passenger]) -> Void
    {
        
        passageItemCount = passengers.count
        
        let subViewArray = view_middle_passage_container_view.subviews
        for subView in subViewArray {
            subView.isHidden = true
        }
        
        
        var last_passageItemContainer:UIView!
        var returnResultView:(UIView,UILabel,UILabel)?
        
        
        for i in 0..<passageItemCount
        {
            var leftLabel_1:UILabel!
            var rightLabel_1:UILabel!
            var leftLabel_2:UILabel!
            var rightLabel_2:UILabel!
            var leftLabel_3:UILabel!
            var rightLabel_3:UILabel!
            
            
            if i==0  //第一个乘机人
            {
                returnResultView = addPassageItemOneLineView(lastViewItem: last_passageItemContainer, islastView: false,isItemStart: true)
                
                last_passageItemContainer = returnResultView?.0
                leftLabel_1 = returnResultView?.1
                rightLabel_1 = returnResultView?.2
                
                
                
                returnResultView = addPassageItemOneLineView(lastViewItem: last_passageItemContainer, islastView: false,isItemStart: false)
                
                last_passageItemContainer = returnResultView?.0
                leftLabel_2 = returnResultView?.1
                rightLabel_2 = returnResultView?.2
                
                
                
                //乘机人数大于一个
                if passageItemCount > 1 {
                    returnResultView = addPassageItemOneLineView(lastViewItem: last_passageItemContainer, islastView: false,isItemStart: false)
                }
                else   //乘机人只有一个。 则第一个乘机人也是最后一个乘机人
                {
                    returnResultView = addPassageItemOneLineView(lastViewItem: last_passageItemContainer, islastView: true,isItemStart: false)
                }
                
                last_passageItemContainer = returnResultView?.0
                leftLabel_3 = returnResultView?.1
                rightLabel_3 = returnResultView?.2
            }
            else if i != passageItemCount-1   //最后一个乘机人
            {
                returnResultView = addPassageItemOneLineView(lastViewItem: last_passageItemContainer, islastView: false,isItemStart: true)
                
                last_passageItemContainer = returnResultView?.0
                leftLabel_1 = returnResultView?.1
                rightLabel_1 = returnResultView?.2
                
                
                
                
                
                returnResultView = addPassageItemOneLineView(lastViewItem: last_passageItemContainer, islastView: false,isItemStart: false)
                
                last_passageItemContainer = returnResultView?.0
                leftLabel_2 = returnResultView?.1
                rightLabel_2 = returnResultView?.2
                
                
                
                
                
                returnResultView = addPassageItemOneLineView(lastViewItem: last_passageItemContainer, islastView: false,isItemStart: false)
                
                last_passageItemContainer = returnResultView?.0
                leftLabel_3 = returnResultView?.1
                rightLabel_3 = returnResultView?.2
            }
            else if i == passageItemCount-1   //不是第一个也不是最后一个乘机人
            {
                returnResultView = addPassageItemOneLineView(lastViewItem: last_passageItemContainer, islastView: false,isItemStart: true)
                
                last_passageItemContainer = returnResultView?.0
                leftLabel_1 = returnResultView?.1
                rightLabel_1 = returnResultView?.2
                
                
                
                
                
                returnResultView = addPassageItemOneLineView(lastViewItem: last_passageItemContainer, islastView: false,isItemStart: false)
                
                last_passageItemContainer = returnResultView?.0
                leftLabel_2 = returnResultView?.1
                rightLabel_2 = returnResultView?.2
                
                
                
                
                returnResultView = addPassageItemOneLineView(lastViewItem: last_passageItemContainer, islastView: true,isItemStart: false)
                
                last_passageItemContainer = returnResultView?.0
                leftLabel_3 = returnResultView?.1
                rightLabel_3 = returnResultView?.2
            }
            
            let passage:CoOldOrderDetail.FlightVo.Passenger = passengers[i]
            
            if passageItemCount == 1   //当乘机人只有一个时
            {
                //对乘机人Item进行设置
                leftLabel_1.text = "乘机人"
                rightLabel_1.text = passage.name
                
                leftLabel_2.text = "联系手机"
                rightLabel_2.text = passage.mobile
                
                leftLabel_3.text = "身份证件"
                rightLabel_3.text = passage.certNo
            }
            else
            {
                //对乘机人Item进行设置
                leftLabel_1.text = "乘机人\(i+1)"
                rightLabel_1.text = passage.name
                
                leftLabel_2.text = "联系手机"
                rightLabel_2.text = passage.mobile
                
                leftLabel_3.text = "身份证件"
                rightLabel_3.text = passage.certNo
            }
        }
        
        
    }
    
    
    //TODO:待优化   动态添加乘机人信息  新版
    func addPassageInf(passengers:[CoNewOrderDetail.FlightVo.Passenger]) -> Void
    {
        
        passageItemCount = passengers.count
        
        let subViewArray = view_middle_passage_container_view.subviews
        for subView in subViewArray {
            subView.isHidden = true
        }
        
        
        var last_passageItemContainer:UIView!
        var returnResultView:(UIView,UILabel,UILabel)?
        
        
        for i in 0..<passageItemCount
        {
            var leftLabel_1:UILabel!
            var rightLabel_1:UILabel!
            var leftLabel_2:UILabel!
            var rightLabel_2:UILabel!
            var leftLabel_3:UILabel!
            var rightLabel_3:UILabel!
            
            
            if i==0  //第一个乘机人
            {
                returnResultView = addPassageItemOneLineView(lastViewItem: last_passageItemContainer, islastView: false,isItemStart: true)
                
                last_passageItemContainer = returnResultView?.0
                leftLabel_1 = returnResultView?.1
                rightLabel_1 = returnResultView?.2
                
                
                
                returnResultView = addPassageItemOneLineView(lastViewItem: last_passageItemContainer, islastView: false,isItemStart: false)
                
                last_passageItemContainer = returnResultView?.0
                leftLabel_2 = returnResultView?.1
                rightLabel_2 = returnResultView?.2
                
                
                
                //乘机人数大于一个
                if passageItemCount > 1 {
                    returnResultView = addPassageItemOneLineView(lastViewItem: last_passageItemContainer, islastView: false,isItemStart: false)
                }
                else   //乘机人只有一个。 则第一个乘机人也是最后一个乘机人
                {
                    returnResultView = addPassageItemOneLineView(lastViewItem: last_passageItemContainer, islastView: true,isItemStart: false)
                }
                
                last_passageItemContainer = returnResultView?.0
                leftLabel_3 = returnResultView?.1
                rightLabel_3 = returnResultView?.2
            }
            else if i != passageItemCount-1   //最后一个乘机人
            {
                returnResultView = addPassageItemOneLineView(lastViewItem: last_passageItemContainer, islastView: false,isItemStart: true)
                
                last_passageItemContainer = returnResultView?.0
                leftLabel_1 = returnResultView?.1
                rightLabel_1 = returnResultView?.2
                
                
                
                
                
                returnResultView = addPassageItemOneLineView(lastViewItem: last_passageItemContainer, islastView: false,isItemStart: false)
                
                last_passageItemContainer = returnResultView?.0
                leftLabel_2 = returnResultView?.1
                rightLabel_2 = returnResultView?.2
                
                
                
                
                
                returnResultView = addPassageItemOneLineView(lastViewItem: last_passageItemContainer, islastView: false,isItemStart: false)
                
                last_passageItemContainer = returnResultView?.0
                leftLabel_3 = returnResultView?.1
                rightLabel_3 = returnResultView?.2
            }
            else if i == passageItemCount-1   //不是第一个也不是最后一个乘机人
            {
                returnResultView = addPassageItemOneLineView(lastViewItem: last_passageItemContainer, islastView: false,isItemStart: true)
                
                last_passageItemContainer = returnResultView?.0
                leftLabel_1 = returnResultView?.1
                rightLabel_1 = returnResultView?.2
                
                
                
                
                
                returnResultView = addPassageItemOneLineView(lastViewItem: last_passageItemContainer, islastView: false,isItemStart: false)
                
                last_passageItemContainer = returnResultView?.0
                leftLabel_2 = returnResultView?.1
                rightLabel_2 = returnResultView?.2
                
                
                
                
                returnResultView = addPassageItemOneLineView(lastViewItem: last_passageItemContainer, islastView: true,isItemStart: false)
                
                last_passageItemContainer = returnResultView?.0
                leftLabel_3 = returnResultView?.1
                rightLabel_3 = returnResultView?.2
            }
            
            let passage:CoNewOrderDetail.FlightVo.Passenger = passengers[i]
            
            if passageItemCount == 1   //当乘机人只有一个时
            {
                //对乘机人Item进行设置
                leftLabel_1.text = "乘机人"
                rightLabel_1.text = passage.name
                
                leftLabel_2.text = "联系手机"
                rightLabel_2.text = passage.mobile
                
                leftLabel_3.text = "身份证件"
                rightLabel_3.text = passage.certNo
            }
            else
            {
                //对乘机人Item进行设置
                leftLabel_1.text = "乘机人\(i+1)"
                rightLabel_1.text = passage.name
                
                leftLabel_2.text = "联系手机"
                rightLabel_2.text = passage.mobile
                
                leftLabel_3.text = "身份证件"
                rightLabel_3.text = passage.certNo
            }
        }
        
        
    }
    
    
    //添加乘机人 的 一行信息
    func addPassageItemOneLineView(lastViewItem:UIView!,islastView:Bool,isItemStart:Bool) -> (UIView,UILabel,UILabel) {
        
        let passageItemContainer = UIView()
        view_middle_passage_container_view.addSubview(passageItemContainer)
        
        //passageItemContainer.backgroundColor = UIColor.brown
        
        passageItemContainer.snp.makeConstraints{(make)->Void in
            
            make.left.equalTo(15)
            make.right.equalTo(-15)
            
            //头部
            if lastViewItem == nil
            {
                make.top.equalTo(25)
            }
            else if isItemStart    //乘客item的首行
            {
                make.top.equalTo(lastViewItem.snp.bottom).offset(25)
            }
            else
            {
                make.top.equalTo(lastViewItem.snp.bottom).offset(10)
            }
            
            if islastView
            {
                make.bottom.equalTo(-25)
            }
        }
        
        let leftLabel = UILabel(text: "leftLabel", color: TBIThemeMinorTextColor, size: 14)
        passageItemContainer.addSubview(leftLabel)
        leftLabel.snp.makeConstraints{(make)->Void in
            make.left.equalTo(0)
            make.top.bottom.equalTo(0)
        }
        
        
        let rightLabel = UILabel(text: "rightLabel", color: TBIThemePrimaryTextColor, size: 14)
        passageItemContainer.addSubview(rightLabel)
        rightLabel.snp.makeConstraints{(make)->Void in
            make.right.equalTo(0)
            make.top.bottom.equalTo(0)
        }
        
        
        let last_passageItemContainer = passageItemContainer
        
        return (last_passageItemContainer,leftLabel,rightLabel)
    }
    
    
    
    
    
    //隐藏违背政策的View
    func showHideNotFitPolicyView(isShow:Bool) -> Void
    {
        
        let constrains = view_nofit_policy_container.constraints
        for  constraint in constrains
        {
            if constraint.firstAttribute == NSLayoutAttribute.top
            {
                
                if isShow   //显示
                {
                    view_nofit_policy_container.isHidden = false
                    view_notfit_policy_bottom_line.isHidden = false
                    
                    constraint.constant = 0
                    
                    let subViews = view_nofit_policy_container.subviews
                    let subConstrains = subViews[0].constraints
                    for  subConstraint in subConstrains
                    {
                        if subConstraint.firstAttribute == NSLayoutAttribute.top
                        {
                            subConstraint.constant = 25
                        }
                    }
                    
                    let subConstrains2 = subViews[1].constraints
                    for  subConstraint2 in subConstrains2
                    {
                        if subConstraint2.firstAttribute == NSLayoutAttribute.top
                        {
                            subConstraint2.constant = 10
                        }
                    }
                }
                else   //隐藏
                {
                    view_nofit_policy_container.isHidden = true
                    view_notfit_policy_bottom_line.isHidden = true
                    
                    constraint.constant = -95
                }
                
            }
        }
    }
    
}
