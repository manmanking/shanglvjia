//
//  PSepcialHotelDetailMapCell.swift
//  shanglvjia
//
//  Created by tbi on 2018/7/31.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PSepcialHotelDetailMapCell: UITableViewCell {

    private var bgImageView = UIImageView()
     private var bgView = UIView()
    private var lookMapLabel = UILabel.init(text: "查看地图", color: PersonalThemeNormalColor, size: 12)
    var addressLabel = UILabel.init(text: "", color: PersonalThemeMajorTextColor, size: 12)
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
        self.addSubview(bgImageView)
        bgImageView.addSubview(bgView)
        bgView.addSubview(addressLabel)
        bgView.addSubview(lookMapLabel)
        
        bgImageView.image = UIImage(named:"p_hotel_map")
        bgImageView.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalToSuperview()
            make.height.equalTo(70)
        }
        
        bgView.backgroundColor = TBIThemeWhite
        bgView.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalToSuperview().inset(10)
        }
        
        lookMapLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview()
        }
        addressLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalTo(-80)
            make.top.bottom.equalToSuperview()
        }
    }

    func setCellWithData(address:String)  {
        addressLabel.text = address
    }
}
