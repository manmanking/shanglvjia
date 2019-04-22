//
//  PersonalFlightInvoiceTableViewCell.swift
//  shanglvjia
//
//  Created by manman on 2018/8/8.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PersonalFlightInvoiceTableViewCell: UITableViewCell {
    
    typealias PersonalFlightInvoiceTableViewBlock = (Bool,NSInteger)->Void
    
    public var personalFlightInvoiceTableViewBlock:PersonalFlightInvoiceTableViewBlock!

    private var titleCategoryLabel:UILabel = UILabel()
    private var titleContentLabel:UILabel = UILabel()
    public let  cutSwitch:UISwitch = UISwitch()
    private var cellIndex:NSInteger = 0
    
    private let warningImage = UIImageView()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = TBIThemeWhite
        setUIViewAutolayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUIViewAutolayout() {
        titleCategoryLabel.text = "发票"
        titleCategoryLabel.textColor = TBIThemeMinorTextColor
        titleCategoryLabel.font = UIFont.systemFont(ofSize: 15)
        self.contentView.addSubview(titleCategoryLabel)
        titleCategoryLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(15)
        }
        
        titleContentLabel.text = "发票"
        titleContentLabel.textColor = TBIThemeMinorTextColor
        titleContentLabel.font = UIFont.systemFont(ofSize: 15)
        self.contentView.addSubview(titleContentLabel)
        titleContentLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(titleCategoryLabel.snp.right).offset(38)
        }
        
        
        cutSwitch.isOn = true
        cutSwitch.onTintColor = PersonalThemeNormalColor
        cutSwitch.addTarget(self, action: #selector(cutAction(sender:)), for: UIControlEvents.valueChanged)
        self.contentView.addSubview(cutSwitch)
        cutSwitch.snp.makeConstraints { (make) in
            //make.top.bottom.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(30)
            make.right.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
        }
        
        warningImage.image = UIImage(named:"warningBlue")
        self.contentView.addSubview(warningImage)
        warningImage.snp.makeConstraints { (make) in
            make.width.equalTo(15)
            make.height.equalTo(15)
            make.left.equalTo(titleContentLabel.snp.right).offset(5)
            make.centerY.equalTo(titleContentLabel)
        }
  
    }
    
    
    func fillDataSources(title:String,content:String,isOpen:Bool,indexPathCell:NSInteger) {
        titleCategoryLabel.text = title
        titleContentLabel.text = content
        cutSwitch.isOn = isOpen
        cellIndex = indexPathCell
    }
    
    //MARK:-----------Action-----
    func cutAction(sender:UISwitch) {
        if personalFlightInvoiceTableViewBlock != nil {
            personalFlightInvoiceTableViewBlock(sender.isOn,cellIndex)
        }
    }
    

}
