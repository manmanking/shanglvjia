//
//  OrderListTableViewCell.swift
//  shop
//
//  Created by akrio on 2017/5/12.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class OrderListTableViewCell: UITableViewCell {
    var typeLabel = UILabel(text: "酒店", color: TBIThemeMinorTextColor, size: 14)
    var statusLabel = UILabel(text: "待支付", color: TBIThemeBlueColor, size: 14)
    private var titleLineView = UIView()
    private var detailLineView = UIView()
    var nameLabel = UILabel(text: "北京快捷酒店", color: TBIThemePrimaryTextColor, size: 17)
    var descriptionLabel = UILabel(text: "标准间   |   含早   |   03-05入住   |   03-08离店", color: TBIThemeMinorTextColor, size: 14)
    var priceLabel = UILabel(text: "￥360", color: TBIThemeOrangeColor, size: 20)
    private var detailBtn = UIButton(title: "查看订单", titleColor: TBIThemeOrangeColor, titleSize: 12)
    var clickCallback:()->Void = { _ in }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initView() {
        titleLineView.backgroundColor = TBIThemeGrayLineColor
        detailLineView.backgroundColor = TBIThemeGrayLineColor
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none //禁用按压效果
        //新建一个title栏的view
        let titleView = UIView()
        titleView.backgroundColor = UIColor.white
        self.contentView.addSubview(titleView)
        titleView.snp.makeConstraints{make in
            make.left.equalTo(self.contentView)
            make.right.equalTo(self.contentView)
            make.top.equalTo(self.contentView)
            make.height.equalTo(44)
        }
        //添加类型名字(机票 酒店 签证)
        titleView.addSubview(typeLabel)
        typeLabel.snp.makeConstraints{ make in
            make.left.equalTo(titleView).offset(15)
            make.centerY.equalTo(titleView)
        }
        //添加订单状态(待支付 处理中 已完成)
        titleView.addSubview(statusLabel)
        statusLabel.snp.makeConstraints{ make in
            make.right.equalTo(titleView).offset(-15)
            make.centerY.equalTo(titleView)
        }
        //添加下方横线
        titleView.addSubview(titleLineView)
        titleLineView.snp.makeConstraints{ make in
            make.bottom.equalTo(titleView)
            make.right.equalTo(titleView).offset(-15)
            make.left.equalTo(titleView).offset(15)
            make.height.equalTo(0.5)
        }
        //添加中间文案container
        let mainContainer = UIView()
        mainContainer.backgroundColor = UIColor.white
        self.contentView.addSubview(mainContainer)
        mainContainer.snp.makeConstraints{make in
            make.top.equalTo(titleView.snp.bottom)
            make.left.equalTo(titleView)
            make.right.equalTo(titleView)
            make.height.equalTo(90)
        }
        //酒店名
        self.contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints{make in
            make.top.equalTo(mainContainer).offset(20)
            make.left.equalTo(mainContainer).offset(15)
            make.right.equalTo(mainContainer)
        }
        //房间描述
        self.contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints{make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.left.equalTo(mainContainer).offset(15)
            make.right.equalTo(mainContainer)
        }
        //添加下方横线
        mainContainer.addSubview(detailLineView)
        detailLineView.snp.makeConstraints{ make in
            make.bottom.equalTo(mainContainer)
            make.right.equalTo(mainContainer).offset(-15)
            make.left.equalTo(mainContainer).offset(15)
            make.height.equalTo(0.5)
        }
        //添加最下方container
        let bottomContainer = UIView()
        self.contentView.addSubview(bottomContainer)
        bottomContainer.backgroundColor = UIColor.white
        bottomContainer.snp.makeConstraints{ make in
            make.top.equalTo(mainContainer.snp.bottom)
            make.left.equalTo(titleView)
            make.right.equalTo(titleView)
            make.height.equalTo(44)
        }
        //添加价格
        bottomContainer.addSubview(priceLabel)
        priceLabel.snp.makeConstraints{make in
            make.left.equalTo(bottomContainer).offset(15)
            make.centerY.equalTo(bottomContainer)
        }
        priceLabel.font = UIFont.boldSystemFont(ofSize: 20)
        //添加查看详情按钮
        detailBtn.layer.borderColor = TBIThemeOrangeColor.cgColor
        detailBtn.layer.borderWidth = 0.5
        detailBtn.layer.cornerRadius = 2
        detailBtn.addTarget(self, action:#selector(handleRegister(sender:)), for: .touchUpInside)
        bottomContainer.addSubview(detailBtn)
        detailBtn.snp.makeConstraints{make in
            make.centerY.equalTo(bottomContainer)
            make.right.equalTo(bottomContainer).offset(-15)
            make.width.equalTo(77)
            make.height.equalTo(27)
        }
    }
    func handleRegister(sender: UIButton){
        clickCallback()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
