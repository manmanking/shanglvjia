//
//  PHotelFilterCell.swift
//  shanglvjia
//
//  Created by tbi on 2018/8/2.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PHotelFilterCell: UITableViewCell {

    private var lineLabel = UILabel()
    let titleLabel:UILabel = UILabel.init(text: "", color: PersonalThemeMinorTextColor, size: 14)
    let rightButton:UIButton = UIButton()
    
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
        self.backgroundColor = TBIThemeWhite
        self.selectionStyle = .none
        
        creatView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func creatView(){
        self.addSubview(lineLabel)
        self.addSubview(titleLabel)
        self.addSubview(rightButton)
        
        lineLabel.backgroundColor = TBIThemeGrayLineColor
        lineLabel.snp.makeConstraints { (make) in
            make.bottom.right.equalToSuperview()
            make.height.equalTo(1)
            make.left.equalTo(0)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.bottom.equalToSuperview()
        }
        rightButton.isHidden = true
        rightButton.setImage(UIImage(named:"hotel_select_duihao"), for: UIControlState.normal)
        rightButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.width.equalTo(44)
            make.top.bottom.equalToSuperview()
        }
    }
}
