//
//  PSepcialHotelBookInfoCell.swift
//  shanglvjia
//
//  Created by tbi on 2018/7/30.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PSepcialHotelBookInfoCell: UITableViewCell {

    var roomLabel = UILabel.init(text: "", color: PersonalThemeMajorTextColor, size: 15)
    var mealLabel = UILabel.init(text: "", color: PersonalThemeMajorTextColor, size: 12)
    var descLabel = UILabel.init(text: "", color: PersonalThemeMinorTextColor, size: 13)
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
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView(){
        self.addSubview(roomLabel)
        self.addSubview(mealLabel)
        self.addSubview(descLabel)
        
        roomLabel.font = UIFont.boldSystemFont(ofSize: 15)
        roomLabel.snp.makeConstraints { (make) in
            make.left.top.equalTo(15)
        }
        mealLabel.snp.makeConstraints { (make) in
            make.left.equalTo(roomLabel.snp.right).offset(15)
            make.bottom.equalTo(roomLabel)
        }
        descLabel.numberOfLines = 3
        descLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(roomLabel.snp.bottom).offset(15)
            make.bottom.equalToSuperview().inset(8)
        }
    }
    func setCellWithData(title:String,hotelName:String,meal:String,address:String,phone:String)  {
        roomLabel.text = title
        mealLabel.text = meal
        descLabel.text = hotelName + "\n" + "地址:" + address + "\n" + "电话:" + phone
    }
}
