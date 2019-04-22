//
//  PersonalFlightBookProtocolTableViewCell.swift
//  shanglvjia
//
//  Created by manman on 2018/8/21.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PersonalFlightBookProtocolTableViewCell: UITableViewCell {
    
    typealias PersonalFlightBookProtocolCellBlock = (Bool)->Void
    
    public var personalFlightBookProtocolCellBlock:PersonalFlightBookProtocolCellBlock!

    private var selectedButton:UIButton = UIButton()
    
    private var contentLabel:UILabel = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = TBIThemeBaseColor
        setUIViewAutolayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUIViewAutolayout() {
        
        selectedButton.setImage(UIImage.init(named: "visa_pay_noselect"), for: UIControlState.normal)
        selectedButton.setImage(UIImage.init(named: "visa_pay_select"), for: UIControlState.selected)
        selectedButton.addTarget(self, action: #selector(selectedButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        self.contentView.addSubview(selectedButton)
        selectedButton.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(15)
        }
        
        contentLabel.textColor = PersonalThemeNormalColor
        contentLabel.font = UIFont.systemFont(ofSize: 15)
        self.contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.top.bottom.right.equalToSuperview()
            make.left.equalTo(selectedButton.snp.right).offset(5)
        }
    }
    
    
    func fillDataSources(content:String) {
        guard content.isEmpty == false else {
            return
        }
        //contentLabel.text = content
        let protocolStr = NSMutableAttributedString.init(string:content)
        protocolStr.addAttributes([NSForegroundColorAttributeName :PersonalThemeMinorTextColor],range: NSMakeRange(0,content.count - 4))
        contentLabel.attributedText = protocolStr
    }
    
    
    
    func selectedButtonAction(sender:UIButton) {
        sender.isSelected = !sender.isSelected
        if personalFlightBookProtocolCellBlock != nil {
            personalFlightBookProtocolCellBlock(sender.isSelected)
        }
    }
    

}
