//
//  OrderDetailTitleCell.swift
//  shanglvjia
//
//  Created by tbi on 2018/5/9.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class OrderDetailTitleCell: UITableViewCell {

    //线
    var lineLabel = UILabel()
    //状态
    var titleLabel = UILabel(text: "基本信息", color: TBIThemePrimaryTextColor, size: 15)
    //线
    var bottomLineLabel = UILabel()
    //状态
    var rightLabel = UILabel(text: "2份", color: TBIThemePrimaryTextColor, size: 15)
    //箭头button
    let upButton = UIButton()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor=TBIThemeWhite
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
    
    func creatCellUI()  {
        lineLabel.backgroundColor=TBIThemeDarkBlueColor
        bottomLineLabel.backgroundColor=TBIThemeGrayLineColor
        self.contentView.addSubview(lineLabel)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(bottomLineLabel)
        self.contentView.addSubview(rightLabel)
        self.contentView.addSubview(upButton)
        upButton.isHidden=true
        
        lineLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(6)
            make.left.equalToSuperview()
            make.width.equalTo(3)
            make.height.equalTo(33)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(lineLabel.snp.right).offset(10)
            make.top.equalTo(lineLabel.snp.top)
            make.bottom.equalTo(lineLabel.snp.bottom)
            make.right.equalToSuperview().offset(-42)
        }
        rightLabel.snp.makeConstraints { (make) in
            make.top.equalTo(lineLabel.snp.top)
            make.bottom.equalTo(lineLabel.snp.bottom)
            make.width.equalTo(42)
            make.right.equalTo(0)
        }
        bottomLineLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.equalTo(0)
            make.height.equalTo(0.5)
            make.width.equalTo(ScreenWindowWidth)
            make.bottom.equalToSuperview()
        }
        
        upButton.contentHorizontalAlignment=UIControlContentHorizontalAlignment.right
        upButton.setImage(UIImage(named: "ic_down_gray"), for: UIControlState.normal)
        upButton.setImage(UIImage(named: "ic_up_gray"), for: UIControlState.selected)
        upButton.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
            make.width.equalTo(44)
        }
    }

}
