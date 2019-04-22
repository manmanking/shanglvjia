
//
//  MyOrderCell.swift
//  shanglvjia
//
//  Created by tbi on 2018/5/8.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import SwiftDate

class MyOrderCell: UITableViewCell {
    var bgView = UIView()
    
    //航空公司图标 (1:机票，2：酒店，3：火车票，4：专车)
    var styleImage = UIImageView(imageName:"ic_order_air")
    //目标label
    var targetLabel = UILabel(text: "天津 —— 上海", color: TBIThemePrimaryTextColor, size: 15)
    //状态 (1:计划中，2：审批中，3：待订妥，4：已订妥，5：已取消)
    var stateLabel = UILabel(text: "计划中", color: TBIThemeDarkBlueColor, size: 15)
    //线
    var lineLabel = UILabel()
    //订单号
    var orderNumLabel = UILabel(text: "订单号10008999", color: UIColor.gray, size: 14)
    //行程时间
    var targetTimeLabel = UILabel(text: "2018-05-20", color: UIColor.gray, size: 14)
    //姓名
    var nameLabel = UILabel(text: "王南南", color: UIColor.gray, size: 14)
    //订单时间
    var orderTimeLabel = UILabel(text: "预定日期 2018-05-01", color: UIColor.gray, size: 13)
    //消费
    var moneyLabel = UILabel(text: "¥1290", color: TBIThemeRedColor, size: 13)
   
    
  
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor=TBIThemeMinorColor
        self.selectionStyle=UITableViewCellSelectionStyle.none
        
        creatCellUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func creatCellUI() {
        bgView.backgroundColor=UIColor.white
        self.contentView.addSubview(bgView)
        
        targetLabel.numberOfLines=2
        lineLabel.backgroundColor=TBIThemeGrayLineColor
        orderTimeLabel.textAlignment=NSTextAlignment.center
        orderTimeLabel.layer.masksToBounds=true
        orderTimeLabel.backgroundColor=TBIThemeButtonBGGrayColor
        orderTimeLabel.layer.cornerRadius=15
        moneyLabel.textAlignment=NSTextAlignment.center
        moneyLabel.layer.masksToBounds=true
        moneyLabel.backgroundColor=TBIThemeRedBGColor
        moneyLabel.layer.cornerRadius=15
        stateLabel.textAlignment=NSTextAlignment.right
        bgView.addSubview(styleImage)
        bgView.addSubview(targetLabel)
        bgView.addSubview(stateLabel)
        bgView.addSubview(lineLabel)
        bgView.addSubview(orderNumLabel)
        bgView.addSubview(targetTimeLabel)
        bgView.addSubview(nameLabel)
        bgView.addSubview(orderTimeLabel)
        bgView.addSubview(moneyLabel)
        

        
        styleImage.snp.makeConstraints { (make) in
//            make.left.equalTo(bgView).offset(15)
            make.left.equalTo(15)
            make.top.equalTo(bgView).offset(9)
            make.width.equalTo(26)
            make.height.equalTo(26)
        }

        targetLabel.font=UIFont.boldSystemFont(ofSize: 15)
        targetLabel.snp.makeConstraints { (make) in
            make.left.equalTo(styleImage.snp.right).offset(15)
            make.right.equalTo(-75)
            make.centerY.equalTo(styleImage)
        }
        stateLabel.font=UIFont.boldSystemFont(ofSize: 15)
        stateLabel.snp.makeConstraints { (make) in
            make.right.equalTo(bgView.snp.right).offset(-15)
            make.top.equalTo(styleImage)
            make.width.equalTo(50)
        }
        lineLabel.snp.makeConstraints { (make) in
            make.top.equalTo(targetLabel.snp.bottom).offset(12)
//            make.left.equalTo(bgView)
            make.left.equalTo(0)
            make.height.equalTo(0.5)
            make.width.equalTo(ScreenWindowWidth)
        }
        orderNumLabel.snp.makeConstraints { (make) in
            make.left.equalTo(styleImage)
            make.top.equalTo(lineLabel.snp.bottom).offset(15)
            make.right.equalTo(bgView.snp.right)
        }
        targetTimeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(orderNumLabel)
            make.top.equalTo(orderNumLabel.snp.bottom).offset(13)
            make.right.equalTo(bgView.snp.right)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(targetTimeLabel)
            make.top.equalTo(targetTimeLabel.snp.bottom).offset(13)
            make.right.equalTo(bgView.snp.right)
        }
        orderTimeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(targetTimeLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(15)
            make.width.equalTo(170)
            make.height.equalTo(30)
        }
        moneyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(orderTimeLabel)
            make.right.equalTo(bgView.snp.right).offset(-10)
            make.width.equalTo(70)
            make.height.equalTo(orderTimeLabel.snp.height)
        }

        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(moneyLabel.snp.bottom).offset(10)
        }
//        self.contentView.snp.makeConstraints { (make) in
//            make.top.equalTo(self)
//            make.left.right.equalTo(self);
//            make.bottom.equalTo(moneyLabel.snp.bottom).offset(20);
//        }
        
    }
    func setCellWithModel(model:MyOrderModel.orderInfo)  {
        targetLabel.text=model.orderTitle .isEmpty ? " " : model.orderTitle
        stateLabel.text=model.orderState == "1" ? "计划中": model.orderState == "2" ? "审批中" : model.orderState == "3" ? "待订妥" : model.orderState == "4" ? "已订妥" : "已取消"
        orderNumLabel.text="订单号 " + model.orderNo
        targetTimeLabel.text=model.orderDetail
        nameLabel.text=model.orderPsgNames

        orderTimeLabel.text = "创建时间 " + CommonTool.stamp(to: model.createTime, withFormat: "yyyy-MM-dd")
        
        styleImage.image=UIImage(named:model.orderType == "1" ? "ic_order_air" : model.orderType == "2" ? "ic_order_hotel" : model.orderType == "3" ? "ic_order_train" : "ic_order_car")
        moneyLabel.text="¥" + model.amount
        
        
    }

}
