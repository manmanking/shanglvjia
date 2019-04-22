//
//  TravelBookNumCell.swift
//  shanglvjia
//
//  Created by tbi on 2018/7/26.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class TravelBookNumCell: UITableViewCell {

    let titleLabel:UILabel = UILabel.init(text: "xx", color: PersonalThemeMajorTextColor, size: 15)
    let numView:ChangeNumButton = ChangeNumButton()
    let lineLabel:UILabel = UILabel()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor=TBIThemeWhite
        self.selectionStyle=UITableViewCellSelectionStyle.none
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initView() {
        addSubview(titleLabel)
        addSubview(numView)
        addSubview(lineLabel)
        
        lineLabel.backgroundColor = TBIThemeGrayLineColor
        lineLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.right.equalToSuperview()
            make.height.equalTo(1)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
        numView.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.height.equalToSuperview()
            make.width.equalTo(90)
        }
        
        
    }

}
