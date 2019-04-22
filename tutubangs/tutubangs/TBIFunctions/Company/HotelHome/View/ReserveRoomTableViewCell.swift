//
//  ReserveRoomTableViewCell.swift
//  shop
//
//  Created by manman on 2017/4/22.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit




class ReserveRoomTableViewCell: UITableViewCell,UITextFieldDelegate {

    typealias ReserveRoomTableViewContentResultBlock = (UITextField,IndexPath)->Void
    
    
    
    public var reserveRoomTableViewContentResultBlock:ReserveRoomTableViewContentResultBlock!
    
    private var cellIndexPath:IndexPath = IndexPath()
    
    private let guaranteePolicy = "担保政策"
    
    private let businessInfo = "出差信息"
    
    private let breachPolicy = "违背政策"
    
    private let breachReason = "违背原因"
    
    private var baseBackgroundView = UIView()

    public var categoryTitleLabel = UILabel()

    
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
    
    func setUIViewAutolayout()
    {
        categoryTitleLabel.textAlignment = NSTextAlignment.left
        categoryTitleLabel.font = UIFont.systemFont(ofSize: 13)
        baseBackgroundView.addSubview(categoryTitleLabel)
        categoryTitleLabel.snp.makeConstraints { (make) in
            
            make.top.bottom.equalToSuperview().inset(5)
            make.left.equalToSuperview().inset(15)
            make.width.equalTo(100)
            
        }
       
        contentTextField.font = UIFont.systemFont( ofSize: 13)
        contentTextField.delegate = self
        contentTextField.returnKeyType = UIReturnKeyType.done
        baseBackgroundView.addSubview(contentTextField)
        contentTextField.snp.makeConstraints { (make) in
            
            make.top.bottom.equalToSuperview().inset(5)
            make.left.equalTo(categoryTitleLabel.snp.right).offset(5)
            make.right.equalToSuperview().inset(30)
            
        }
        
        categoryTitleDescriptionLabel.font = UIFont.systemFont( ofSize: 13)
        categoryTitleDescriptionLabel.numberOfLines = 0
        baseBackgroundView.addSubview(categoryTitleDescriptionLabel)
        categoryTitleDescriptionLabel.snp.makeConstraints { (make) in
            
            make.top.equalTo(categoryTitleLabel.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(15)
            
        }
        intoDetailFlageImageView.image = UIImage.init(named: "Common_Forward_Arrow_Gray")
        baseBackgroundView.addSubview(intoDetailFlageImageView)
        intoDetailFlageImageView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
            make.height.equalTo(13)
            make.width.equalTo(7)
        }
        
        intoDetailFlagLabel.font = UIFont.systemFont( ofSize: 13)
        intoDetailFlagLabel.textColor = TBIThemeBlueColor
        baseBackgroundView.addSubview(intoDetailFlagLabel)
        intoDetailFlagLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-23)
            make.centerY.equalToSuperview()
        }
        
        bottomLine.backgroundColor = TBIThemeGrayLineColor
        baseBackgroundView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            
            make.bottom.equalToSuperview().inset(1)
            make.height.equalTo(0.5)
            make.left.equalToSuperview().inset(15)
            make.right.equalToSuperview()
        }
    }
    
    func fillDataSource(title:String,
                        subTitle:String = "", //最右面的字
                        contentPlaceHolder:String,
                        contentCertain:Bool,
                        content:String,
                        contentEnable:Bool,
                        intoNextEnable:Bool,
                        showLineEnable:Bool,
                        cellIndex:IndexPath) {
        clearDataSources()
        cellIndexPath = cellIndex
        
        //担保政策 页面布局
        if title == guaranteePolicy {
            categoryTitleLabel.text = title
            categoryTitleLabel.textColor = TBIThemeBlueColor
            categoryTitleLabel.snp.removeConstraints()
            categoryTitleLabel.snp.makeConstraints({ (make) in
                make.top.equalToSuperview().inset(15)
                make.left.equalToSuperview().inset(15)
                make.height.equalTo(13)
                make.width.equalTo(100)
            })
            
            categoryTitleDescriptionLabel.text = content
            contentTextField.isUserInteractionEnabled = false
            intoDetailFlageImageView.isHidden = !intoNextEnable
            bottomLine.isHidden = !showLineEnable
            intoNextBool = !intoNextBool
            intoDetailFlagLabel.text = ""
            intoDetailFlagLabel.isHidden = true
        } else {
            categoryTitleDescriptionLabel.text = ""
            
            categoryTitleLabel.text = title
            categoryTitleLabel.textColor = TBIThemePrimaryTextColor
            categoryTitleLabel.snp.removeConstraints()
            categoryTitleLabel.snp.makeConstraints({ (make) in
                make.top.bottom.equalToSuperview().inset(5)
                make.left.equalToSuperview().inset(15)
                make.width.equalTo(100)
            })
            
            if contentPlaceHolder.isEmpty == false {
                contentTextField.placeholder = contentPlaceHolder
                //必填项  更改 占位符 颜色
                if contentCertain == true {
                    //"请输入(必填)"
                    contentTextField.attributedPlaceholder = NSAttributedString(string:contentPlaceHolder,attributes:[NSForegroundColorAttributeName: TBIThemePrimaryWarningColor])
                } else {
                   contentTextField.attributedPlaceholder = NSAttributedString(string:contentPlaceHolder,attributes:[NSForegroundColorAttributeName: TBIThemeGrayLineColor])
                }
            }
            if content.isEmpty == false {
                contentTextField.text = content
            }
            contentTextField.isUserInteractionEnabled = contentEnable
            contentTextField.textColor = UIColor.black
            if subTitle.characters.count > 0 {
                intoDetailFlagLabel.text = subTitle
                intoDetailFlagLabel.isHidden = false
//                intoDetailFlageImageView.isHidden = false
//                intoNextEnable = false;
            }else
            {
                intoDetailFlagLabel.text = ""
                intoDetailFlagLabel.isHidden = true
            }
                intoDetailFlageImageView.isHidden = !intoNextEnable
            
            bottomLine.isHidden = !showLineEnable
            intoNextBool = !intoNextBool
            
            contentTextField.snp.removeConstraints()
            contentTextField.snp.makeConstraints { (make) in
                make.top.bottom.equalToSuperview().inset(5)
                make.left.equalTo(categoryTitleLabel.snp.right).offset(5)
                make.right.equalToSuperview().inset(30)
            }
        }
        
        if breachPolicy == title  || breachReason == title || businessInfo == title {
            categoryTitleLabel.textColor = TBIThemeBlueColor
            contentTextField.textColor = UIColor.red
        }
        
    }
    
    
    
    func clearDataSources() {
        categoryTitleLabel.text = ""
        contentTextField.text = ""
        contentTextField.placeholder = ""
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        printDebugLog(message: "into here")
        if (textField.text?.characters.count)! >= 1 {
            reserveRoomTableViewContentResultBlock(textField,cellIndexPath)
        }
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
}
