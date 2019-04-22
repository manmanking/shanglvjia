//
//  PersonalHotelIntroCell.swift
//  tutubangs
//
//  Created by tbi on 2018/10/25.
//  Copyright © 2018 manman. All rights reserved.
//

import UIKit

class PersonalHotelIntroCell: UITableViewCell {

    private let oneTitleLabel = UILabel.init(text: "", color: PersonalThemeMajorTextColor, size: 13)
    private let oneContentLabel = UILabel.init(text: "", color: PersonalThemeMinorTextColor, size: 13)
    private let twoTitleLabel = UILabel.init(text: "", color: PersonalThemeMajorTextColor, size: 13)
    private let twoContentLabel = UILabel.init(text: "", color: PersonalThemeMinorTextColor, size: 13)
    
//    private let hotelStarTitleLabel = UILabel.init(text: "酒店星级", color: PersonalThemeMajorTextColor, size: 13)
//     private let hotelStarContentLabel = UILabel.init(text: "", color: PersonalThemeMinorTextColor, size: 13)
//    private let dictNameTitleLabel = UILabel.init(text: "行政区", color: PersonalThemeMajorTextColor, size: 13)
//    private let dictNameContentLabel = UILabel.init(text: "", color: PersonalThemeMinorTextColor, size: 13)
//    private let openTimeTitleLabel = UILabel.init(text: "开业时间", color: PersonalThemeMajorTextColor, size: 13)
//    private let openTimeContentLabel = UILabel.init(text: "", color: PersonalThemeMinorTextColor, size: 13)
//    private let zxTimeTitleLabel = UILabel.init(text: "装修时间", color: PersonalThemeMajorTextColor, size: 13)
//    private let zxTimeContentLabel = UILabel.init(text: "", color: PersonalThemeMinorTextColor, size: 13)
//    private let telTitleLabel = UILabel.init(text: "电话", color: PersonalThemeMajorTextColor, size: 13)
//    private let telContentLabel = UILabel.init(text: "", color: PersonalThemeMinorTextColor, size: 13)
//    private let corpTitleLabel = UILabel.init(text: "所属集团", color: PersonalThemeMajorTextColor, size: 13)
//    private let corpContentLabel = UILabel.init(text: "", color: PersonalThemeMinorTextColor, size: 13)
//    private let ppTitleLabel = UILabel.init(text: "所属品牌", color: PersonalThemeMajorTextColor, size: 13)
//    private let ppContentLabel = UILabel.init(text: "", color: PersonalThemeMinorTextColor, size: 13)
//    private let buyTitleLabel = UILabel.init(text: "商圈", color: PersonalThemeMajorTextColor, size: 13)
//    private let buyContentLabel = UILabel.init(text: "", color: PersonalThemeMinorTextColor, size: 13)
    
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
        self.selectionStyle = .none
        self.backgroundColor = TBIThemeWhite
        creatCellUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func creatCellUI(){
        self.addSubview(oneTitleLabel)
        self.addSubview(oneContentLabel)
        self.addSubview(twoTitleLabel)
        self.addSubview(twoContentLabel)
        
        oneTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(10)
            make.width.equalTo(70)
            make.bottom.equalToSuperview()
            make.height.equalTo(15)
            
        }
        oneContentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(oneTitleLabel.snp.right).offset(5)
            make.centerY.equalTo(oneTitleLabel)
            make.right.equalTo(ScreenWindowWidth/2)
        }
        twoTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(ScreenWindowWidth/2)
            make.centerY.equalTo(oneTitleLabel)
            make.width.equalTo(70)
        }
        twoContentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(twoTitleLabel.snp.right).offset(5)
            make.centerY.equalTo(oneTitleLabel)
            make.right.equalTo(-15)
        }
    }
    func setCellWithData(oneTitle:String,oneContent:String,twoTitle:String,twoContent:String){
        oneTitleLabel.text = oneTitle
        oneContentLabel.text = oneContent
        twoTitleLabel.text = twoTitle
        twoContentLabel.text = twoContent
    }
}
