//
//  PersonalProtocalView.swift
//  shanglvjia
//
//  Created by tbi on 2018/7/31.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PersonalProtocalView: UIView {

    ///标题按钮的点击回调
    typealias ViewClickBlock = () ->Void
    public var viewClickBlock:ViewClickBlock?
    
    typealias SelectClickBlock = (Bool) ->Void
    public var selectClickBlock:SelectClickBlock!
    
    private let imageView = UIImageView()
    private let protocolLabel = UILabel.init(text: "请提交前确认您已阅读预订条款", color: PersonalThemeNormalColor, size: 12)
    private var isSelected : Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = TBIThemeBaseColor
        creatView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func creatView() {
        self.addSubview(imageView)
        self.addSubview(protocolLabel)
        
        imageView.image = UIImage(named:"visa_pay_noselect")
        imageView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
        protocolLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imageView.snp.right).offset(5)
            make.centerY.equalToSuperview()
        }
        let protocolStr = NSMutableAttributedString(string:"请提交前确认您已阅读预订条款")
        protocolStr.addAttributes([NSForegroundColorAttributeName :PersonalThemeMinorTextColor],range: NSMakeRange(0,10))
        protocolLabel.attributedText = protocolStr
        
        protocolLabel.addOnClickListener(target: self, action: #selector(protocolLabelClick(tap:)))
        imageView.addOnClickListener(target: self, action: #selector(imageViewClick(tap:)))
    }
    func protocolLabelClick(tap:UITapGestureRecognizer)  {
        if viewClickBlock != nil{
            viewClickBlock!()
        }
    }
    func imageViewClick(tap:UITapGestureRecognizer)  {
        
        isSelected = !isSelected
        
        if isSelected == false {
            imageView.image = UIImage(named:"visa_pay_noselect")
        }else{
            imageView.image = UIImage(named:"visa_pay_select")
        }
        if selectClickBlock != nil{
            selectClickBlock(isSelected)
        }
        
    }
    
}
