//
//  PersonalMessageCell.swift
//  shanglvjia
//
//  Created by tbi on 05/09/2018.
//  Copyright © 2018 TBI. All rights reserved.
//

import UIKit

class PersonalMessageCell: UITableViewCell {

    
    private let bgView:PersonalMineShadowView = PersonalMineShadowView()
    private let titleLabel = UILabel.init(text: "", color: PersonalThemeMajorTextColor, size: 15)
    private let contentLabel = UILabel.init(text: "", color: PersonalThemeMinorTextColor, size: 14)
    private let lineLabel = UILabel()
    private let timeLabel = UILabel.init(text: "", color: PersonalThemeMinorTextColor, size: 12)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.backgroundColor = TBIThemeBaseColor
        initView()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initView(){
        bgView.backgroundColor = TBIThemeWhite
        self.addSubview(bgView)
        
        bgView.addSubview(titleLabel)
        bgView.addSubview(contentLabel)
        bgView.addSubview(lineLabel)
        bgView.addSubview(timeLabel)
        
        
        titleLabel.numberOfLines = 0
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(18)
            make.left.right.equalToSuperview().inset(10)
        }
        contentLabel.numberOfLines = 0
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(10)
        }
        
        lineLabel.backgroundColor = TBIThemeBaseColor
        lineLabel.snp.makeConstraints { (make) in
           make.top.equalTo(contentLabel.snp.bottom).offset(18)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        timeLabel.textAlignment = .center
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(lineLabel.snp.bottom).offset(18)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(15)
        }
        bgView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(13)
            make.left.right.equalToSuperview().inset(10)
        }
    }
    func setCellWithModel(model:PersonalMessageModel.PushListVo,type:String){
        
        timeLabel.text = CommonTool.stamp(to: model.gmtCreate, withFormat: "yyyy年MM月dd日")
        printDebugLog(message: type)
        if type == "1"{
            contentLabel.text = ""
            titleLabel.text = model.msgContent
        }else{
            contentLabel.text = model.msgContent
            titleLabel.text = model.msgTitle
        }
        
        if (contentLabel.text?.isEmpty)!{
            lineLabel.snp.remakeConstraints { (make) in
                make.top.equalTo(titleLabel.snp.bottom).offset(18)
                make.left.right.equalToSuperview().inset(10)
                make.height.equalTo(1)
            }
        }else{
            lineLabel.snp.remakeConstraints { (make) in
                make.top.equalTo(contentLabel.snp.bottom).offset(18)
                make.left.right.equalToSuperview().inset(10)
                make.height.equalTo(1)
            }
        }
    }

}
