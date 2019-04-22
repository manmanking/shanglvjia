//
//  CoOldOrderDetailsCellViewHotel.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/5/24.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class CoOrderDetailsCellViewHotel: UITableViewCell
{

    static let HOTEL_SHOWHIDE_DETAILS = "HOTEL_SHOWHIDE_DETAILS"
    static let HOTEL_DEL_ORDER = "HOTEL_DEL_ORDER"
    
    
    
    //cell显示隐藏的delegate
    public var cellShowHideListener:OnTableCellShowHideListener!
    public var indexPath:IndexPath!
    
    var passageItemCount = 0
    
    
    
    //头部右侧的订单状态
    @IBOutlet weak var btn_top_right_order_status: UIButton!
    //头部左侧的大标题
    @IBOutlet weak var top_left_big_title: UILabel!
    //头部左侧的小标题
    @IBOutlet weak var top_left_sub_title: UILabel!
    //头部右侧的显示隐藏btn
    @IBOutlet weak var top_right_showhide_details: UIButton!
    
    //头部的阴影分割线
    @IBOutlet weak var top_shadow_5_line_view: UIView!
    
    
    
    //中间展开内容的容器视图
    @IBOutlet weak var view_middle_total_container: UIView!
    
    //中间的入住联系人的容器视图
    @IBOutlet weak var view_middle_passage_container_view: UIView!
    //不符合差旅政策的容器视图
    @IBOutlet weak var view_nofit_policy_container: UIView!
    //不符合差旅政策容器视图下方的分割线
    @IBOutlet weak var view_notfit_policy_bottom_line: UIView!
    
    //违背政策的内容
    @IBOutlet weak var label_nofit_policy_content: UILabel!
    //违背政策原因的内容
    @IBOutlet weak var label_nofit_policy_reason_content: UILabel!
    
    
    
    
    
    //床型的内容
    @IBOutlet weak var label_house_type_content: UILabel!
    //最晚到店的内容
    @IBOutlet weak var label_late_time_content: UILabel!
    //担保状态的内容
    @IBOutlet weak var label_protected_status_content: UILabel!
    
    
    //middle下部的联系人的Tab
    //底部联系人姓名的内容
    @IBOutlet weak var label_bottom_contact_name_content: UILabel!
    //底部联系人手机的内容
    @IBOutlet weak var label_bottom_contact_phone_content: UILabel!
    //底部联系人邮箱的内容
    @IBOutlet weak var label_bottom_contact_email_contentt: UILabel!
    
    //总价格上面的分割线
    @IBOutlet weak var view_total_price_top_line: UIView!
    //底部总价格Tab
    //底部总价格的label
    @IBOutlet weak var label_total_price_content: UILabel!
    //底部删除订单的btn
    @IBOutlet weak var btn_del_order: UIButton!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        initView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func initView() -> Void
    {
        //showHideNotFitPolicyView(isShow: false)
        //addPassageInf()
        
        //头部的阴影分割线
        let shadow_5_line_subView = UIImageView(imageName: "ic_c_shadow")
        top_shadow_5_line_view.addSubview(shadow_5_line_subView)
        top_shadow_5_line_view.backgroundColor = UIColor.clear
        shadow_5_line_subView.snp.makeConstraints{(make)->Void in
            make.left.right.top.bottom.equalTo(0)
        }
        top_shadow_5_line_view.isHidden = true
        
        
        
        
        top_right_showhide_details.addOnClickListener(target: self, action: #selector(showHideInfoClk))
        
        //删除订单的btn
        btn_del_order.addOnClickListener(target: self, action:#selector(delOrderClk))
    }
    
    
    
    //显示隐藏订单的详细信息
    @objc private func showHideInfoClk()
    {
        
        cellShowHideListener.onShowHide(tableCell: self, flagStr: CoOrderDetailsCellViewHotel.HOTEL_SHOWHIDE_DETAILS, indexPath: indexPath)
        
    }
    
    //删除订单的btn
    @objc private func delOrderClk()
    {
        cellShowHideListener.onShowHide(tableCell: self, flagStr: CoOrderDetailsCellViewHotel.HOTEL_DEL_ORDER, indexPath: indexPath)
    }
    
    
    
    //TODO:  待优化   动态添加入住人信息   老版
    func addPassageInf(passengers:[CoOldOrderDetail.HotelVo.HotelPassenger]) -> Void
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
            
            
            if i==0  //第一个入住人
            {
                returnResultView = addPassageItemOneLineView(lastViewItem: last_passageItemContainer, islastView: false,isItemStart: true)
                
                last_passageItemContainer = returnResultView?.0
                leftLabel_1 = returnResultView?.1
                rightLabel_1 = returnResultView?.2
                
                
                //入住人数大于一个
                if passageItemCount > 1 {
                    returnResultView = addPassageItemOneLineView(lastViewItem: last_passageItemContainer, islastView: false,isItemStart: false)
                }
                else   //入住人只有一个。 则第一个入住人也是最后一个入住人
                {
                    returnResultView = addPassageItemOneLineView(lastViewItem: last_passageItemContainer, islastView: true,isItemStart: false)
                }
                
                last_passageItemContainer = returnResultView?.0
                leftLabel_2 = returnResultView?.1
                rightLabel_2 = returnResultView?.2
            }
            else if i != passageItemCount-1   //最后一个入住人
            {
                returnResultView = addPassageItemOneLineView(lastViewItem: last_passageItemContainer, islastView: false,isItemStart: true)
                
                last_passageItemContainer = returnResultView?.0
                leftLabel_1 = returnResultView?.1
                rightLabel_1 = returnResultView?.2
                
                
                
                
                returnResultView = addPassageItemOneLineView(lastViewItem: last_passageItemContainer, islastView: false,isItemStart: false)
                
                last_passageItemContainer = returnResultView?.0
                leftLabel_2 = returnResultView?.1
                rightLabel_2 = returnResultView?.2
            }
            else if i == passageItemCount-1   //不是第一个也不是最后一个入住人
            {
                returnResultView = addPassageItemOneLineView(lastViewItem: last_passageItemContainer, islastView: false,isItemStart: true)
                
                last_passageItemContainer = returnResultView?.0
                leftLabel_1 = returnResultView?.1
                rightLabel_1 = returnResultView?.2
                
                
                
                
                
                returnResultView = addPassageItemOneLineView(lastViewItem: last_passageItemContainer, islastView: true,isItemStart: false)
                
                last_passageItemContainer = returnResultView?.0
                leftLabel_2 = returnResultView?.1
                rightLabel_2 = returnResultView?.2
            }
           
            
            let passager:CoOldOrderDetail.HotelVo.HotelPassenger = passengers[i]
            
            //对入住人的一行进行设置
            if i==0 && passengers.count == 1  //当只有一个入住人时
            {
                leftLabel_1.text = "入住人"
                rightLabel_1.text = passager.name
                
                leftLabel_2.text = "联系手机"
                rightLabel_2.text = passager.mobile
            }
            else
            {
                leftLabel_1.text = "入住人\(i+1)"
                rightLabel_1.text = passager.name
                
                leftLabel_2.text = "联系手机"
                rightLabel_2.text = passager.mobile
            }
        }
        
        
    }
    
    //TODO:  待优化   动态添加入住人信息   新版
    func addPassageInf(passengers:[CoNewOrderDetail.HotelVo.HotelPassenger]) -> Void
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
            
            
            if i==0  //第一个入住人
            {
                returnResultView = addPassageItemOneLineView(lastViewItem: last_passageItemContainer, islastView: false,isItemStart: true)
                
                last_passageItemContainer = returnResultView?.0
                leftLabel_1 = returnResultView?.1
                rightLabel_1 = returnResultView?.2
                
                
                //入住人数大于一个
                if passageItemCount > 1 {
                    returnResultView = addPassageItemOneLineView(lastViewItem: last_passageItemContainer, islastView: false,isItemStart: false)
                }
                else   //入住人只有一个。 则第一个入住人也是最后一个入住人
                {
                    returnResultView = addPassageItemOneLineView(lastViewItem: last_passageItemContainer, islastView: true,isItemStart: false)
                }
                
                last_passageItemContainer = returnResultView?.0
                leftLabel_2 = returnResultView?.1
                rightLabel_2 = returnResultView?.2
            }
            else if i != passageItemCount-1   //最后一个入住人
            {
                returnResultView = addPassageItemOneLineView(lastViewItem: last_passageItemContainer, islastView: false,isItemStart: true)
                
                last_passageItemContainer = returnResultView?.0
                leftLabel_1 = returnResultView?.1
                rightLabel_1 = returnResultView?.2
                
                
                
                
                returnResultView = addPassageItemOneLineView(lastViewItem: last_passageItemContainer, islastView: false,isItemStart: false)
                
                last_passageItemContainer = returnResultView?.0
                leftLabel_2 = returnResultView?.1
                rightLabel_2 = returnResultView?.2
            }
            else if i == passageItemCount-1   //不是第一个也不是最后一个入住人
            {
                returnResultView = addPassageItemOneLineView(lastViewItem: last_passageItemContainer, islastView: false,isItemStart: true)
                
                last_passageItemContainer = returnResultView?.0
                leftLabel_1 = returnResultView?.1
                rightLabel_1 = returnResultView?.2
                
                
                
                
                
                returnResultView = addPassageItemOneLineView(lastViewItem: last_passageItemContainer, islastView: true,isItemStart: false)
                
                last_passageItemContainer = returnResultView?.0
                leftLabel_2 = returnResultView?.1
                rightLabel_2 = returnResultView?.2
            }
            
            
            let passager:CoNewOrderDetail.HotelVo.HotelPassenger = passengers[i]
            
            //对入住人的一行进行设置
            if i==0 && passengers.count == 1  //当只有一个入住人时
            {
                leftLabel_1.text = "入住人"
                rightLabel_1.text = passager.name
                
                leftLabel_2.text = "联系手机"
                rightLabel_2.text = passager.mobile
            }
            else
            {
                leftLabel_1.text = "入住人\(i+1)"
                rightLabel_1.text = passager.name
                
                leftLabel_2.text = "联系手机"
                rightLabel_2.text = passager.mobile
            }
        }
        
        
    }
    
    
    
    
    
    
    
    //添加入住人 的 一行信息
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
