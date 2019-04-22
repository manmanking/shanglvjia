//
//  MineHomeTableViewCell.swift
//  shop
//
//  Created by TBI on 2017/4/28.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class MineHomeTableViewCell: UITableViewCell {
    
    var leftImg:UIImageView?
    
    var rightImg:UIImageView?
    
    var journeyLabel:UILabel?
    
    var line:UILabel?
    
    var rightLabel:UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
        super.awakeFromNib()
        leftImg  = UIImageView(imageName: "")
        rightImg = UIImageView(imageName: "ic_right_gray")
        journeyLabel = UILabel(text: "",color: TBIThemePrimaryTextColor,size: 17)
        rightLabel = UILabel(text: "",color: TBIThemeBlueColor,size: 15)
        rightLabel?.isHidden = true
        self.addSubview(leftImg!)
        self.addSubview(rightImg!)
        self.addSubview(journeyLabel!)
        self.addSubview(rightLabel!)
        leftImg!.snp.makeConstraints{(make) in
            make.left.equalTo(15)
            make.width.height.equalTo(29)
            make.centerY.equalToSuperview()
        }
        journeyLabel!.snp.makeConstraints{(make) in
            make.left.equalTo(leftImg!.snp.right).offset(15)
            make.centerY.equalToSuperview()
        }
        rightImg!.snp.makeConstraints{(make) in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
        }
        rightLabel!.snp.makeConstraints{(make) in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
        }
        line = UILabel(color: TBIThemeGrayLineColor)
        self.addSubview(line!)
        line!.snp.makeConstraints{(make) in
            make.height.equalTo(0.5)
            make.left.equalTo(journeyLabel!.snp.left)
            make.right.equalTo(0)
            make.bottom.equalToSuperview()
        }

    }
    
    
    //初始化下面cell
    func  initAllCell(imgName:String,title:String,index:Int,isShowBottomLine:Bool){
        leftImg?.image =  UIImage(named: imgName)
        journeyLabel?.text = NSLocalizedString(title, comment: "")
//        if index == 2 {
//            line?.isHidden = true
//        }else {
//            line?.isHidden = false
//        }
        
        line?.isHidden = !isShowBottomLine
        
        rightLabel?.isHidden = true
        rightImg?.isHidden = false
    }
    
    //初始化下面cell
    func  initOneCell(imgName:String,title:String,index:Int,count:Int,isCompanny:Bool){
        leftImg?.image =  UIImage(named: imgName)
        journeyLabel?.text = NSLocalizedString(title, comment: title)
        
        //控制线条
        if index == 0 && count != 1{
            line?.isHidden = false
        }else {
            line?.isHidden = true
            rightLabel?.isHidden = true
            if index != 0{
                rightImg?.isHidden = true
                journeyLabel?.font = UIFont.systemFont(ofSize: 16)
                journeyLabel!.snp.remakeConstraints{(make) in
                    make.left.equalTo(59)
                    if index == 1 {
                        make.top.equalTo(15)
                    } else if index == 2{
                        make.bottom.equalTo(-12)
                    }
                    
                }
            }
        }
        if index == 0 && !isCompanny && count == 1{
             rightImg?.isHidden = false
        }
        //控制右边显示文字
        if index == 0 && isCompanny {
            journeyLabel?.text = "已绑定企业账号"
            journeyLabel?.font = UIFont.systemFont(ofSize: 17)
            rightLabel?.isHidden = false
            rightImg?.isHidden = true
            if count == 1 {
                rightLabel?.text = "展开"
            } else {
                rightLabel?.text = "收起"
            }
        }
      
    }


}
