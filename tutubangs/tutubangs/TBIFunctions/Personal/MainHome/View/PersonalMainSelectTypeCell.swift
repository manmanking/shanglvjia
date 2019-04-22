//
//  PersonalMainSelectTypeCell.swift
//  shanglvjia
//
//  Created by tbi on 2018/7/20.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PersonalMainSelectTypeCell: UITableViewCell {

    typealias selectTypeClickBlock = (Int) ->Void
    var selectTypeBlock:selectTypeClickBlock?
    
    let bgView:UIView = UIView()
    
    /// 广告头
     var cycleScrollView: SDCycleScrollView = SDCycleScrollView()
    
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
        //cycleScrollView.frame = CGRect(x: 0, y: 0, width: Int(ScreenWindowWidth), height: 190)
        cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight
        cycleScrollView.autoScrollTimeInterval = 6
        cycleScrollView.pageControlBottomOffset = 10
        cycleScrollView.backgroundColor = TBIThemeBaseColor
        cycleScrollView.currentPageDotImage = UIImage.init(named: "ic_ellipse_white")
        cycleScrollView.pageDotImage = UIImage.init(named: "ic_circle_white")
        cycleScrollView.pageControlStyle =  SDCycleScrollViewPageContolStyleClassic
        cycleScrollView.placeholderImage = UIImage(named:"bg_default_travel")
        self.addSubview(cycleScrollView)
        cycleScrollView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(190)
        }
        
        self.addSubview(bgView)
    }
    func setCellWithArray(array:NSArray){
        
        bgView.backgroundColor = TBIThemeWhite
        bgView.layer.cornerRadius = 10.0
        bgView.clipsToBounds = true
        bgView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(10)
            make.top.equalTo(cycleScrollView.snp.bottom).offset(-10)
            make.height.equalTo(80*array.count)
            make.bottom.equalTo(0)
        }
        ///
        CommonTool.removeSubviews(onBgview: bgView)
        
        let btnWidth = ScreenWindowWidth - 12
        for i in 0...array.count-1{
            let button:UIButton = UIButton()
            button.frame = CGRect(x:0,y:(80 * CGFloat(i)),width:btnWidth,height:80)
            button.tag = i
            
            let imgView:UIImageView = UIImageView()
            let arrowView:UIImageView = UIImageView()
            let str =  ((array[i] as? [String : String])?["title"])!
            let label:UILabel = UILabel(text: "" ,color: TBIThemePrimaryTextColor,size: 15)
            let desLabel:UILabel = UILabel(text: "" ,color: PersonalThemeMinorTextColor,size: 13)

            imgView.image = UIImage(named:((array[i] as? [String : String])?["imgName"])!)
            arrowView.image = UIImage(named:"Common_Forward_Arrow_Gray")
            
            bgView.addSubview(button)
            button.addSubview(label)
            button.addSubview(imgView)
            button.addSubview(arrowView)
            button.addSubview(desLabel)
            
            //线
            if i != array.count-1{
                let lineLabel:UILabel = UILabel()
                lineLabel.backgroundColor = TBIThemeBaseColor
                button.addSubview(lineLabel)
                lineLabel.snp.makeConstraints({ (make) in
                    make.left.equalTo(imgView)
                    make.bottom.equalToSuperview().offset(-1)
                    make.height.equalTo(1)
                    make.right.equalToSuperview()
                })
            }
            
            imgView.snp.makeConstraints({ (make) in
                make.left.equalToSuperview().offset(15)
                make.centerY.equalToSuperview()
            })
            label.text = String(str.split(separator: "\n")[0])
            label.snp.makeConstraints({ (make) in
                make.left.equalTo(imgView.snp.right).offset(25)
                make.top.equalTo(imgView.snp.top)
                make.bottom.equalTo(imgView.snp.bottom) //.snp.centerY
            })
            
//            desLabel.text = String(str.split(separator: "\n")[1])
//            desLabel.snp.makeConstraints({ (make) in
//                make.left.equalTo(imgView.snp.right).offset(25)
//                make.top.equalTo(imgView.snp.centerY)
//                make.bottom.equalTo(imgView)
//            })
            arrowView.snp.makeConstraints({ (make) in
                make.right.equalTo(-15)
                make.centerY.equalToSuperview()
            })
            button.addTarget(self, action: #selector(cellButtonClick(sender:)), for: UIControlEvents.touchUpInside)
        }
    }
    func cellButtonClick(sender:UIButton) {
        
        selectTypeBlock?(sender.tag)
    }
}
