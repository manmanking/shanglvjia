//
//  TravelOnOffNumCell.swift
//  shanglvjia
//
//  Created by tbi on 2018/7/26.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class TravelOnOffNumCell: UITableViewCell {

    typealias SwithStatusBlock = (Bool,Int) ->Void
    public var swithStatusBlock:SwithStatusBlock!
    
    var leftLabel = UILabel(text: "发票", color: PersonalThemeMajorTextColor, size: 15)
    let  gtSwitch = UISwitch()
    let titleLabel:UILabel = UILabel.init(text: "xx", color: PersonalThemeMinorTextColor, size: 15)
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
        creatCellUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func creatCellUI(){
        self.addSubview(leftLabel)
        self.addSubview(gtSwitch)
        self.addSubview(titleLabel)
        self.addSubview(numView)
        self.addSubview(lineLabel)
        
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(0)
            make.height.equalTo(45)
            make.width.equalTo(270)
        }
        
        gtSwitch.onTintColor = PersonalThemeNormalColor
        gtSwitch.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalTo(leftLabel)
        }
        gtSwitch.addTarget(self, action: #selector(switchChange(sender:)), for: UIControlEvents.valueChanged)
        
        
        lineLabel.backgroundColor = TBIThemeBaseColor
        lineLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(leftLabel.snp.bottom)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(leftLabel.snp.bottom)
            make.bottom.equalToSuperview()
            make.height.equalTo(45)
            make.width.equalTo(270)
        }
        numView.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.top.equalTo(titleLabel)
            make.width.equalTo(90)
            make.height.equalTo(titleLabel)
        }
    }

    func fillCell(isBill:Bool,title:String,description:String,section:Int){
        gtSwitch.isOn = isBill
        leftLabel.text = title
        titleLabel.text = description
        
        gtSwitch.tag = section
        
        if isBill == false{
           titleLabel.isHidden = true
            numView.isHidden = true
        }else{
            titleLabel.isHidden = false
            numView.isHidden = false
        }
    }
    func switchChange(sender:UISwitch){
        if swithStatusBlock != nil{
            swithStatusBlock(sender.isOn,sender.tag)
        }
    }
}
