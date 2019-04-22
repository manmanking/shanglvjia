//
//  ApprovalDetailSubordersTableViewCell.swift
//  shanglvjia
//
//  Created by manman on 2018/5/22.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class ApprovalDetailSubordersTableViewCell: UITableViewCell {

    typealias ApprovalDetailSubordersTableViewCellSelectedBlock  = (String)->Void
    
    public var approvalDetailSubordersTableViewCellSelectedBlock:ApprovalDetailSubordersTableViewCellSelectedBlock!
    
    private let baseBackgroundView:UIView = UIView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = TBIThemeBaseColor
        baseBackgroundView.backgroundColor = TBIThemeWhite
        self.contentView.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(5)
        }
    }
    
   
    
    
    func fillLocalDataSources(order:[(title:String,contentType:ApprovalOrderDetailViewController.ApprovalDeitailSubordersType)],selectedOrder:String) {
        
        for (index,element) in order.enumerated() {
            let viewY:NSInteger = NSInteger(floorf(Float(index / 2))) * 32 + NSInteger((floorf(Float(index / 2)) + 1) * 15)
            var viewX:NSInteger = 0
            
            if index % 2  == 1 {
                viewX = NSInteger((ScreenWindowWidth - 45) / 2 + 15 * 2)
            }else {
                viewX = 15
            }
           
            let tmpButton:UIButton = UIButton()
            tmpButton.setTitle(element.title, for: UIControlState.normal)
            tmpButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            tmpButton.addTarget(self, action: #selector(selectedOrderButton(sender:)), for: UIControlEvents.touchUpInside)
            tmpButton.layer.cornerRadius = 16
            tmpButton.clipsToBounds = true
            baseBackgroundView.addSubview(tmpButton)
            tmpButton.snp.makeConstraints { (make) in
                make.top.equalToSuperview().inset(viewY)
                make.left.equalToSuperview().inset(viewX)
                make.width.equalTo((ScreenWindowWidth - 45 ) / 2 )
                make.height.equalTo(32)
            }
//            if index == 0 {
//                tmpButton.backgroundColor = TBIThemeBlueColor
//            }else {

//            }
            
            if element.title == selectedOrder {
                tmpButton.backgroundColor = TBIThemeDarkBlueColor
            }else{
                tmpButton.backgroundColor = TBIThemeButtonGrayColor
            }

        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    func selectedOrderButton(sender:UIButton) {
        
        if approvalDetailSubordersTableViewCellSelectedBlock != nil {
            approvalDetailSubordersTableViewCellSelectedBlock(sender.titleLabel?.text ?? "")
        }
    }
    
    
    

}
