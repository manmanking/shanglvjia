//
//  TBIFuctionCategoryView.swift
//  shop
//
//  Created by manman on 2017/4/11.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit






enum CategoryTitleDirection {
    case Top
    case Bottom
    case Left
    case Right
}





class TBIFuctionCategoryView: TBIBaseView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    //默认设置
    //后期 放开 四个方向
    var titleDirection:CategoryTitleDirection = CategoryTitleDirection.Bottom
    
    
    var datasourcesArr:[[String]]!
    
    
    
    fileprivate var baseBackgroundView = UIView()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(baseBackgroundView)
        baseBackgroundView.backgroundColor = UIColor.white
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setUIViewAutolayout() {
        
        for tmpCategoryArr in datasourcesArr {
            
            
            
            
        }
        
        
        
        
    }
    
    //基础信息
    func createCategoryButton(titleStr:String,normalImage:String,heightImage:String) -> UIButton  {
        var button = UIButton()
        button.addTarget(self, action: #selector(categoryButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        if titleStr.isEmpty == false {
            button.setTitle(titleStr, for: UIControlState.normal)
        }
        if normalImage.isEmpty == false {
            button.setImage(UIImage.init(named: normalImage), for: UIControlState.normal)
        }
        if heightImage.isEmpty == false{
            button.setImage(UIImage.init(named: heightImage), for: UIControlState.selected)
        }
        
        
        return button
        
        
    }
    
    
    
    func categoryButtonAction(sender:UIButton) {
        if DEBUG {
            NSLog("category button %s %d",#function,#line)
        }
    }
    
    
    
    

}
