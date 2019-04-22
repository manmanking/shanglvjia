//
//  PIntegralListCell.swift
//  shanglvjia
//
//  Created by tbi on 07/09/2018.
//  Copyright © 2018 TBI. All rights reserved.
//

import UIKit

class PIntegralListCell: UITableViewCell {

    private let titleLabel = UILabel.init(text: "", color: PersonalThemeMajorTextColor, size: 15)
    private let timeLabel = UILabel.init(text: "", color: PersonalThemeMinorTextColor, size: 13)
    
    private let moneyLabel = UILabel.init(text: "", color: PersonalThemeRedColor, size: 21)
    
    private let lineLabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = TBIThemeWhite
        initView()
    }
    func initView(){
        self.addSubview(lineLabel)
        self.addSubview(titleLabel)
        self.addSubview(timeLabel)
        self.addSubview(moneyLabel)
        
        lineLabel.backgroundColor = TBIThemeGrayLineColor
        lineLabel.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(19)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(13)
        }
        moneyLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(15)
        }
        
    }
    func fillCell(){
        titleLabel.text = "预订机票"
        timeLabel.text = "2018-08-08"
        moneyLabel.text = "+2880"
//        let moneyAttrs = NSMutableAttributedString(string:"+" + "2880")
//        moneyAttrs.addAttributes([ NSFontAttributeName : UIFont.systemFont(ofSize: 12)],range: NSMakeRange(0,1))
//        moneyLabel.attributedText = moneyAttrs
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
