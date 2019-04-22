//
//  PersonalMainMoreCell.swift
//  shanglvjia
//
//  Created by tbi on 2018/7/20.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PersonalMainMoreCell: UITableViewCell {
    
    typealias PersonalMainMoreCellSelectedBlock = (NSInteger)->Void
    public var personalMainMoreCellSelectedBlock:PersonalMainMoreCellSelectedBlock!
    

    let bgView:UIView = UIView()
    var controller = PersonalMainHomeViewController()
    
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
        addSubview(bgView)
        bgView.backgroundColor  = TBIThemeWhite
        bgView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(10)
            make.height.equalTo(70)
        }
        let btnArr = [["imgName":"personal_blue_air","title":"机票预订"],["imgName":"personal_orange_hotel","title":"酒店预订"],["imgName":"personal_red_visa","title":"签证预订"]]
        let btnWidth = ScreenWindowWidth/3
        for i in 0...btnArr.count-1{
            let button:UIButton = UIButton()
            button.frame = CGRect(x:(CGFloat(i) * btnWidth),y:0,width:btnWidth,height:70)
            button.setTitle(btnArr[i]["title"]!, for: UIControlState.normal)
            button.setTitleColor(UIColor.clear, for: UIControlState.normal)
            
            let imgView:UIImageView = UIImageView()
            let label:UILabel = UILabel(text: btnArr[i]["title"]!,color: TBIThemePrimaryTextColor,size: 12)
            label.textAlignment = NSTextAlignment.center
            imgView.image = UIImage(named:btnArr[i]["imgName"]!)
            bgView.addSubview(button)
            button.addSubview(label)
            button.addSubview(imgView)
            imgView.snp.makeConstraints({ (make) in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(-8)
            })
            label.snp.makeConstraints({ (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(imgView.snp.bottom).offset(5)
            })
            
            //线
            let lineLabel:UILabel = UILabel()
            bgView.addSubview(lineLabel)
            lineLabel.backgroundColor = TBIThemeBaseColor
            lineLabel.snp.makeConstraints({ (make) in
                make.centerY.equalToSuperview()
                make.width.equalTo(1)
                make.height.equalTo(50)
                make.left.equalTo(button.snp.right)
            })
            
            button.addTarget(self, action: #selector(titleButtonClick(sender:)), for: UIControlEvents.touchUpInside)
        }
    }
    func titleButtonClick(sender:UIButton){
        if sender.titleLabel?.text == "机票预订" && personalMainMoreCellSelectedBlock != nil {
            personalMainMoreCellSelectedBlock(0)
        }
        if sender.titleLabel?.text == "酒店预订" && personalMainMoreCellSelectedBlock != nil {
            personalMainMoreCellSelectedBlock(1)
        }
        if sender.titleLabel?.text == "签证预订" && personalMainMoreCellSelectedBlock != nil {
            personalMainMoreCellSelectedBlock(2)
        }
    }
}
