//
//  NewMineHomeCell.swift
//  shanglvjia
//
//  Created by tbi on 2018/7/6.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
class PersonalMineHomeCell: UITableViewCell {
   
    typealias cellClickBlock = (String) ->Void
    var clickBlock:cellClickBlock?
    
    let bgView:PersonalMineShadowView = PersonalMineShadowView()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initView(){
        self.addSubview(bgView)
    }
    func setCellWithArray(array:NSArray){
        
        bgView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(10)
            make.height.equalTo(50*array.count)
            make.bottom.equalTo(0)
        }
        ///
        CommonTool.removeSubviews(onBgview: bgView)
        
        let btnWidth = ScreenWindowWidth - 30
        for i in 0...array.count-1{
            let button:UIButton = UIButton()
            button.frame = CGRect(x:0,y:(50 * CGFloat(i)),width:btnWidth,height:50)
            button.setTitle(((array[i] as? [String : String])?["title"])!, for: UIControlState.normal)
            button.setTitleColor(UIColor.clear, for: UIControlState.normal)
            
            let imgView:UIImageView = UIImageView()
            let arrowView:UIImageView = UIImageView()
            let label:UILabel = UILabel(text: ((array[i] as? [String : String])?["title"])!,color: TBIThemePrimaryTextColor,size: 15)
            label.textAlignment = NSTextAlignment.center
            imgView.image = UIImage(named:((array[i] as? [String : String])?["imgName"])!)
            arrowView.image = UIImage(named:"Common_Forward_Arrow_Gray")
            
            bgView.addSubview(button)
            button.addSubview(label)
            button.addSubview(imgView)
            button.addSubview(arrowView)
            
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
            label.snp.makeConstraints({ (make) in
                make.left.equalTo(imgView.snp.right).offset(10)
                make.centerY.equalToSuperview()
            })
            arrowView.snp.makeConstraints({ (make) in
                make.right.equalTo(-20)
                make.centerY.equalToSuperview()
            })
            button.addTarget(self, action: #selector(cellButtonClick(sender:)), for: UIControlEvents.touchUpInside)
        }
    }
    
    func cellButtonClick(sender:UIButton) {
       
        clickBlock?((sender.titleLabel?.text)!)
    }

}
