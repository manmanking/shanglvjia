//
//  VisaOrderCell.swift
//  shanglvjia
//
//  Created by tbi on 2018/7/18.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class VisaOrderCell: UITableViewCell {

    var leftLabel = UILabel(text: "基本信息", color: UIColor.gray, size: 15)
    var rightLabel = UILabel(text: "基本信息", color: TBIThemePrimaryTextColor, size: 15)
    var arrowImage = UIImageView()
    let lineLabel = UILabel()
    
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
        creatCellUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func creatCellUI(){
        self.contentView.addSubview(leftLabel)
        self.contentView.addSubview(rightLabel)
        self.contentView.addSubview(arrowImage)
        self.contentView.addSubview(lineLabel)
        
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.bottom.equalTo(0)
            make.width.equalTo(75)
            make.height.equalTo(45)
        }
        rightLabel.snp.makeConstraints { (make) in
            make.left.equalTo(leftLabel.snp.right).offset(13)
            make.top.bottom.equalTo(leftLabel)
            make.right.equalToSuperview().offset(-25)
            
        }
        arrowImage.isHidden = true
        arrowImage.image = UIImage(named:"ic_right_gray")
        arrowImage.snp.makeConstraints { (make) in
           make.right.equalToSuperview().inset(23)
            make.centerY.equalToSuperview()
        }
        lineLabel.isHidden = true
        lineLabel.backgroundColor = TBIThemeGrayLineColor
        lineLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    func setCell(leftStr:String,rightStr:String)  {
        leftLabel.text=leftStr
        rightLabel.text=rightStr .isEmpty ? " " : rightStr
        if rightLabel.text == "请添加乘客信息" || (rightLabel.text?.contains("请选择"))!{
            rightLabel.textColor = TBIThemePlaceholderColor
        }else{
             rightLabel.textColor = PersonalThemeMajorTextColor
        }
        
        if leftStr.isEmpty == true {
            rightLabel.snp.remakeConstraints { (make) in
                make.left.equalTo(15)
                make.top.bottom.equalToSuperview()
                make.right.equalToSuperview().offset(-25)
                make.height.equalTo(45)
            }
        }else {
            rightLabel.snp.remakeConstraints { (make) in
                make.left.equalTo(leftLabel.snp.right).offset(13)
                make.top.bottom.equalTo(leftLabel)
                make.right.equalToSuperview().offset(-25)
                
            }
            
        }
        
        
    }
}
