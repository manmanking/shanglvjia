//
//  AddRemarkCell.swift
//  shanglvjia
//
//  Created by tbi on 2018/6/19.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class AddRemarkCell: UITableViewCell,UITextFieldDelegate,UITextViewDelegate {

    let messageLabel = UILabel(text: "违背原因", color: TBIThemePrimaryTextColor, size: 13)
    
    let contraryDefaultTip:String = "输入违背原因"
    
    let messageField = UITextField(placeholder: "输入违背原因",fontSize: 13)
    
    private var messageTextViewPlaceHolderTip:String = "请添加订单备注"
    
    public let messageTextView:UITextView = UITextView()
    
    let remarkDefaultTip:String = "添加备注"
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
        
        addSubview(messageLabel)
        //addSubview(messageField)
    
        messageLabel.snp.makeConstraints { (make) in
            make.left.equalTo(23)
            make.centerY.equalToSuperview()
        }
//        messageField.delegate = self
//        messageField.snp.makeConstraints { (make) in
//            make.left.equalTo(100)
//            make.right.equalTo(-23)
//            make.top.bottom.equalToSuperview()
//        }

        addSubview(messageTextView)
       //messageTextView.isSelectable = false
        //messageTextView.textAlignment = NSTextAlignment.center
        messageTextView.text = messageTextViewPlaceHolderTip
        messageTextView.font = UIFont.systemFont(ofSize: 13)
        messageTextView.textColor = TBIThemePlaceholderTextColor
        messageTextView.delegate = self
        messageTextView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
            make.left.equalToSuperview().inset(100)
            make.right.equalToSuperview().inset(23)
        }
        
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func fillDataSourcesRemark(reason:String) {
        //        contraryField.text = describe
        
        if reason.isEmpty == false && reason != messageTextViewPlaceHolderTip {
            messageTextView.textColor = TBIThemePrimaryTextColor
            messageTextView.text = reason
            //messageField.text = reason
        }else{
            //messageField.text = ""
            messageTextView.textColor = TBIThemePlaceholderTextColor
            messageTextView.text = messageTextViewPlaceHolderTip
        }
        messageLabel.text = "添加备注"
        //messageField.textColor = TBIThemePrimaryTextColor
//        messageField.attributedPlaceholder = NSAttributedString(string:messageTextViewPlaceHolderTip,attributes:[NSForegroundColorAttributeName: TBIThemePlaceholderColor])
//         messageTextView.attributedText = NSAttributedString(string:messageTextViewPlaceHolderTip,attributes:[NSForegroundColorAttributeName: TBIThemePlaceholderColor])
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text!
        let len = text.count + string.count - range.length
        return len<=50
        
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == messageTextViewPlaceHolderTip {
            textView.text = ""
            
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty == true  {
            textView.text = messageTextViewPlaceHolderTip
            textView.textColor = TBIThemePlaceholderTextColor
            
        }else{
            
        }
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        textView.textColor = TBIThemePrimaryTextColor
        let existText = textView.text!
        let textHeight = existText.getTextHeigh(font: UIFont.systemFont(ofSize: 13), width: ScreenWindowWidth - 100 - 23)
        printDebugLog(message: existText)
        printDebugLog(message: textHeight)
        
        if textHeight > 30 && textHeight < 40  {
            textView.snp.remakeConstraints { (update) in
                update.left.equalToSuperview().inset(100)
                update.right.equalToSuperview().inset(23)
                update.centerY.equalToSuperview()
                update.height.equalTo(40)
               
            }
        }else if textHeight > 40 {
            textView.snp.remakeConstraints { (update) in
                update.left.equalToSuperview().inset(100)
                update.right.equalToSuperview().inset(23)
                update.centerY.equalToSuperview()
                update.top.bottom.equalToSuperview()
                //update.height.equalTo(70)
                
            }
        }else if textHeight < 30 {
            textView.snp.remakeConstraints { (update) in
                update.centerY.equalToSuperview()
                update.height.equalTo(20)
                update.left.equalToSuperview().inset(100)
                update.right.equalToSuperview().inset(23)
                
            }
        }
        
        
        let len = existText.count + text.count - range.length
        return len<=50
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        switch action {
        case #selector(cut(_:)):
            printDebugLog(message: "into here")
            return false
        case  #selector(paste(_:))://禁止粘贴
            return false
        case #selector(select(_:)):// 禁止选择
            return false
        case #selector(selectAll(_:)): // 禁止全选
            return false
        default:
            break
            
        }
        
        return  super.canPerformAction(action, withSender: sender)//[super canPerformAction:action withSender:sender];
    }
    
}
