//
//  PersonalHotelIntroDetailCell.swift
//  tutubangs
//
//  Created by tbi on 2018/10/25.
//  Copyright © 2018 manman. All rights reserved.
//

import UIKit

class PersonalHotelIntroDetailCell: UITableViewCell {

    var leftLabel = UILabel(text: "标题", color: PersonalThemeMajorTextColor, size: 13)
    var rightLabel = UILabel(text: "内容", color: PersonalThemeMinorTextColor, size: 13)
    
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
    
    func creatCellUI(){
        rightLabel.numberOfLines=0
        self.contentView.addSubview(leftLabel)
        self.contentView.addSubview(rightLabel)
        
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(10)
            make.width.equalTo(70)
            make.height.equalTo(15)
        }
        rightLabel.snp.makeConstraints { (make) in
            make.left.equalTo(leftLabel.snp.right).offset(5)
            make.top.equalTo(leftLabel.snp.top)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(0)
            
        }
    }
    
    func setCell(leftStr:String,rightStr:String)  {
        leftLabel.text=leftStr
        rightLabel.text=rightStr .isEmpty ? " " : rightStr
    }

}
