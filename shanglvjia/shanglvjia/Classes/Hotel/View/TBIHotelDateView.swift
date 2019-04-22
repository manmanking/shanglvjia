//
//  TBIHotelDateView.swift
//  shop
//
//  Created by manman on 2017/4/26.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

typealias ChoiceDateBlock = (String)->Void


class TBIHotelDateView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    public var customTextAlignment:NSTextAlignment = NSTextAlignment.center
    private let baseBackgroundView = UIView()
    private let titleLabel = UILabel()
    private let choiceDateButton = UIButton()
    
    var choiceDateBlock:ChoiceDateBlock!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        baseBackgroundView.backgroundColor = UIColor.white
        baseBackgroundView.clipsToBounds = true
        baseBackgroundView.layer.borderColor = TBIThemeGrayLineColor.cgColor
        baseBackgroundView.layer.borderWidth = 0.5
        baseBackgroundView.layer.cornerRadius = 2
        self.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
            
            make.top.left.bottom.right.equalToSuperview()
        }
        
        
        setUIViewAutolayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
       
        
    }
    
    
    func setUIViewAutolayout() {
        
        titleLabel.text = "12"
        titleLabel.textColor = TBIThemePrimaryTextColor
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.font = UIFont.systemFont( ofSize: 16)
        baseBackgroundView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(20)
            
        }
        choiceDateButton.setImage(UIImage.init(named: "HotelDownGray"), for: UIControlState.normal)
        
        choiceDateButton.addTarget(self, action: #selector(choiceDateButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        choiceDateButton.backgroundColor = UIColor.init(red:186/255 , green: 212/255, blue: 237/255, alpha: 1)
        choiceDateButton.setEnlargeEdgeWithTop(0, left: ScreenWindowWidth/4 - 10, bottom: 0, right: 0)
        choiceDateButton.layer.borderWidth = 0.5
        choiceDateButton.layer.borderColor = TBIThemeGrayLineColor.cgColor
        baseBackgroundView.addSubview(choiceDateButton)
        choiceDateButton.snp.makeConstraints { (make) in
            
            make.top.bottom.right.equalToSuperview()
            make.left.equalTo(titleLabel.snp.right)
        }
        
    }
    
    
    
    //设置日期时间
    func setDate(title:String) {
        titleLabel.text = title
        
    }
    
    //获得日期时间
    func getDate() -> String {
        return (titleLabel.text?.description)!
    }
    
    
    //选择日期出发事件
    func choiceDateButtonAction(sender:UIButton) {
        titleLabel.textAlignment = customTextAlignment
        printDebugLog(message:"choiceDateButtonAction  ....  AssuranceInfoViewController" )
        self.choiceDateBlock((titleLabel.text?.description)!)
        
    }
    
    
}
