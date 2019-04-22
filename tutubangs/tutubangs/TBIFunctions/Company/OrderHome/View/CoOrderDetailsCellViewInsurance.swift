//
//  CoOldOrderDetailsCellViewInsurance.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/5/24.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class CoOrderDetailsCellViewInsurance: UITableViewCell {

    static let INSURANCE_SHOWHIDE_DETAILS = "INSURANCE_SHOWHIDE_DETAILS"
    static let INSURANCE_GIVE_MONEY = "INSURANCE_GIVE_MONEY"
    static let INSURANCE_DEL_ORDER = "INSURANCE_DEL_ORDER"
    
    //cell显示隐藏的delegate
    public var cellShowHideListener:OnTableCellShowHideListener!
    public var indexPath:IndexPath!
    
    //订单状态的btn
    @IBOutlet weak var btn_order_status: UIButton!
    
    //头部的大标题
    @IBOutlet weak var label_top_big_title: UILabel!
    //头部的小标题
    @IBOutlet weak var label_sub_title: UILabel!
    
    //头部右侧的展开隐藏的btn
    @IBOutlet weak var btn_top_showhide: UIButton!
    //头部显示隐藏信息的view
    @IBOutlet weak var view_show_hide__info_container: UIView!
    
    //头部的阴影分割线
    @IBOutlet weak var top_shadow_5_line_view: UIView!
    
    
    
    //中间展示详情视图的大容器
    @IBOutlet weak var view_middlle_total_container: UIView!
    //违背政策的容器视图
    @IBOutlet weak var view_nofit_policy_container: UIView!
    //不符合差旅政策的容器视图下方的分割线
    @IBOutlet weak var view_notfit_policy_line: UIView!
    
    //违背政策的Tab
    //违背政策的内容
    @IBOutlet weak var label_notfit_policy_content: NSLayoutConstraint!
    //违背政策的原因的内容
    @IBOutlet weak var label_nofit_policy_reason_content: UILabel!
    
    //保险单号的Tab
    //保险单号的内容
    @IBOutlet weak var label_insurance_num: UILabel!
    //被投保人的内容
    @IBOutlet weak var label_insuranced_people_content: UILabel!
    //保险时效的内容
    @IBOutlet weak var label_insurance_time_content: UILabel!
    //投保类型的内容
    @IBOutlet weak var label_insurance_type: UILabel!
    //理赔信息的内容
    @IBOutlet weak var label_insurance_info_content: UILabel!
    
    
    //总价格上面的分割线
    @IBOutlet weak var view_total_price_top_line: UIView!
    
    //价格的Tab
    //保险价格的Tab
    @IBOutlet weak var label_total_price: UILabel!
    //删除订单的btn
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
    
    
    
    func initView() -> Void {
        
        //头部的阴影分割线
        let shadow_5_line_subView = UIImageView(imageName: "ic_c_shadow")
        top_shadow_5_line_view.addSubview(shadow_5_line_subView)
        top_shadow_5_line_view.backgroundColor = UIColor.clear
        shadow_5_line_subView.snp.makeConstraints{(make)->Void in
            make.left.right.top.bottom.equalTo(0)
        }
        top_shadow_5_line_view.isHidden = true
        
        
        
        
        showHideNotFitPolicyView(isShow: false)
        
        //展开关闭详情
        btn_top_showhide.addOnClickListener(target: self, action: #selector(showHideInfoClk))
        
        //理赔信息的Label
        label_insurance_info_content.addOnClickListener(target: self, action: #selector(giveMoneyClk))
        
        //删除订单的btn
        btn_del_order.addOnClickListener(target: self, action: #selector(delOrderClk))
        
    }
    
    //显示隐藏订单的详细信息
    @objc private func showHideInfoClk()
    {
        cellShowHideListener.onShowHide(tableCell: self, flagStr: CoOrderDetailsCellViewInsurance.INSURANCE_SHOWHIDE_DETAILS, indexPath: indexPath)
        
    }
    
    //理赔信息的Label
    @objc private func giveMoneyClk()
    {
        cellShowHideListener.onShowHide(tableCell: self, flagStr: CoOrderDetailsCellViewInsurance.INSURANCE_GIVE_MONEY, indexPath: indexPath)
        
    }
    
    //删除订单的btn
    @objc private func delOrderClk()
    {
        cellShowHideListener.onShowHide(tableCell: self, flagStr: CoOrderDetailsCellViewInsurance.INSURANCE_DEL_ORDER, indexPath: indexPath)
        
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
                    view_notfit_policy_line.isHidden = false
                    
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
                    view_notfit_policy_line.isHidden = true
                    
                    constraint.constant = -95
                }
                
            }
        }
    }
    
}
