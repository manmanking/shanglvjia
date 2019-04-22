//
//  FAQTableViewCell.swift
//  shop
//
//  Created by akrio on 2017/5/1.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class FAQTableViewCell: UITableViewCell {
    let titleLabel:UILabel = UILabel(text: "11", color: UIColor.black, size: 16)
    init(_ title:String,reuseIdentifier:String?,hasLine:Bool = true) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        titleLabel.text = title
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints{make in
            make.centerY.equalTo(self)
            make.left.equalTo(15)
        }
        if hasLine {
            let line = UIView()
            line.backgroundColor = UIColor(r: 229, g: 229, b: 229)
            self.addSubview(line)
            line.snp.makeConstraints{make in
                make.bottom.equalTo(self)
                make.left.equalTo(15)
                make.right.equalTo(self)
                make.height.equalTo(0.5)
            }
        }
        self.accessoryType = .disclosureIndicator
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
