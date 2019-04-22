//
//  SingleContentTableViewCell.swift
//  shop
//
//  Created by manman on 2017/7/29.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class SingleContentTableViewCell: UITableViewCell,UITextFieldDelegate{

    
    typealias SingleContentTableViewCellComplateBlock = (String,IndexPath)->Void
    
    public var singleContentTableViewCellComplateBlock:SingleContentTableViewCellComplateBlock!
    
    private var baseBackgroundView = UIView()
    
    //public var categoryTitleLabel = UILabel()
    
    private var cellIndexPath:IndexPath = IndexPath()
    
    private var categoryTitleDescriptionLabel = UILabel()
    
    private var contentTextField = UITextField()
    
    private var intoDetailFlageImageView = UIImageView()
    
    private var intoDetailFlagLabel = UILabel()
    
    private var bottomLine = UILabel()
    
    private var intoNextBool:Bool = false
    
    
    
    
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
        
        baseBackgroundView.backgroundColor = UIColor.white
        self.contentView.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
            
            make.top.left.bottom.right.equalToSuperview()
            
        }
        setUIViewAutolayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUIViewAutolayout()
    {
        contentTextField.textAlignment = NSTextAlignment.left
        contentTextField.delegate = self
        contentTextField.font = UIFont.systemFont(ofSize: 13)
        baseBackgroundView.addSubview(contentTextField)
        contentTextField.snp.makeConstraints { (make) in
            
            make.top.bottom.equalToSuperview().inset(5)
            make.left.equalToSuperview()
            make.right.equalToSuperview().inset(15)
            
        }
        
        
        bottomLine.backgroundColor = TBIThemeGrayLineColor
        baseBackgroundView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            
            make.bottom.equalToSuperview().inset(1)
            make.height.equalTo(0.5)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            
        }
    }
    
    public func fillDataSources(content:String,placeHolder:String,contentEnable:Bool,showLine:Bool,indexPath:IndexPath) {
        
        contentTextField.text = content
        contentTextField.placeholder = placeHolder
        contentTextField.isEnabled = contentEnable
        bottomLine.isHidden = !showLine
        cellIndexPath = indexPath
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if singleContentTableViewCellComplateBlock != nil {
            singleContentTableViewCellComplateBlock(textField.text!,cellIndexPath)
        }
        
        
    }
    
    
    
    
    
    

}
