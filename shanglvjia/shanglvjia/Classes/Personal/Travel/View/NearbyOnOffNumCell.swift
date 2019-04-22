//
//  NearbyOnOffNumCell.swift
//  shanglvjia
//
//  Created by tbi on 2018/8/15.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class NearbyOnOffNumCell: UITableViewCell {

    typealias SwithStatusBlock = (Bool,Int) ->Void
    public var swithStatusBlock:SwithStatusBlock!
    
    var leftLabel = UILabel(text: "发票", color: PersonalThemeMajorTextColor, size: 15)
    let  gtSwitch = UISwitch()
    
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
        
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.bottom.equalTo(0)
            make.height.equalTo(45)
            make.width.equalTo(270)
        }
        
        gtSwitch.onTintColor = PersonalThemeNormalColor
        gtSwitch.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalTo(leftLabel)
        }
        gtSwitch.addTarget(self, action: #selector(switchChange(sender:)), for: UIControlEvents.valueChanged)
    }
    func fillCell(isBill:Bool,title:String,section:Int){
        gtSwitch.isOn = isBill
        leftLabel.text = title
        
        gtSwitch.tag = section
        
        
    }
    func switchChange(sender:UISwitch){
        if swithStatusBlock != nil{
            swithStatusBlock(sender.isOn,sender.tag)
        }
    }

}
