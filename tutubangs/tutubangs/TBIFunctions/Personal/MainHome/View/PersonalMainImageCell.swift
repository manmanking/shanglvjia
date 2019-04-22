//
//  PersonalMainImageCell.swift
//  shanglvjia
//
//  Created by tbi on 2018/7/20.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PersonalMainImageCell: UITableViewCell {

    private let travelImage:UIImageView = UIImageView()
    private let bgView:UIView = UIView()
    private let titleLabel = UILabel.init(text: "", color: PersonalThemeMajorTextColor, size: 15)
    private let desLabel = UILabel.init(text: "", color: PersonalThemeMinorTextColor, size: 13)
     private let leftLineImage:UIImageView = UIImageView()
     private let rightLineImage:UIImageView = UIImageView()
    private let leftLine = UILabel()
    private let rightLine = UILabel()
    public let allviewButton = UIButton.init(title: "全景介绍", titleColor: PersonalThemeMajorTextColor, titleSize: 15)
    
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
        self.backgroundColor = TBIThemeBaseColor
        self.selectionStyle = UITableViewCellSelectionStyle.none
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
        bgView.backgroundColor = TBIThemeWhite
        self.addSubview(bgView)
        bgView.addSubview(travelImage)
        bgView.addSubview(titleLabel)
        bgView.addSubview(desLabel)
        bgView.addSubview(leftLineImage)
        bgView.addSubview(rightLineImage)
        bgView.addSubview(leftLine)
        bgView.addSubview(rightLine)
        bgView.addSubview(allviewButton)
        
        travelImage.image = UIImage(named:"main_info")
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.height.equalTo(205*ScreenWindowWidth/325 + 40)
            make.bottom.left.right.equalToSuperview()
        }
        travelImage.snp.makeConstraints { (make) in
            make.top.equalTo(70*ScreenWindowWidth/325)
             make.height.equalTo(120*ScreenWindowWidth/325)
            make.left.right.equalToSuperview().inset(10*ScreenWindowWidth/325)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(20*ScreenWindowWidth/325)
            make.height.equalTo(25)
        }
        desLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
            make.height.equalTo(17)
        }
        leftLineImage.image = UIImage(named:"ic_yellow_line")
        leftLineImage.snp.makeConstraints { (make) in
            make.right.equalTo(titleLabel.snp.left).offset(-5)
            make.centerY.equalTo(titleLabel)
            make.width.height.equalTo(12)
        }
        rightLineImage.image = UIImage(named:"ic_yellow_line")
        rightLineImage.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right).offset(5)
            make.centerY.equalTo(titleLabel)
            make.width.height.equalTo(12)
        }
        leftLine.backgroundColor = TBIThemeBaseColor
        rightLine.backgroundColor = TBIThemeBaseColor
        leftLine.snp.makeConstraints { (make) in
           make.width.equalTo(80)
            make.right.equalTo(leftLineImage.snp.left).offset(-4)
            make.height.equalTo(1)
            make.centerY.equalTo(leftLineImage)
        }
        rightLine.snp.makeConstraints { (make) in
            make.width.equalTo(80)
            make.left.equalTo(rightLineImage.snp.right).offset(4)
            make.height.equalTo(1)
            make.centerY.equalTo(leftLineImage)
        }
        allviewButton.snp.makeConstraints { (make) in
            make.width.equalTo(80)
            make.left.bottom.equalToSuperview().inset(15)
            make.height.equalTo(30)
        }
        allviewButton.layer.cornerRadius = 2.0
        allviewButton.layer.borderColor = PersonalThemeMinorTextColor.cgColor
        allviewButton.layer.borderWidth = 1.0
    }
    func fillDataSources(imageName:String,title:String,des:String) {
       
        travelImage.image = UIImage(named:imageName)
        titleLabel.text = title
        desLabel.text = des
        
    }
    
}
