//
//  FeedbackView.swift
//  shop
//
//  Created by TBI on 2017/5/8.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class FeedbackView: UIView,UITextViewDelegate,UITextFieldDelegate{

    let  feedbackTitle = UILabel(text:NSLocalizedString("mine.questions.comments.title", comment: "问题和意见"), color: TBIThemeMinorTextColor, size: 14)
    
    let  contactTitle = UILabel(text:NSLocalizedString("mine.contact.title", comment: "联系方式"), color: TBIThemeMinorTextColor, size: 14)
    
    let  feedbackText = UITextView()
    
    let  bgView = UIView()
    
    let  contactText = CustomTextField(fontSize: 16)
    
    let  feedbackPlaceholder =  UILabel(text:NSLocalizedString("mine.questions.comments.message", comment: ""), color: TBIThemePlaceholderTextColor, size: 16)
    
    let  submitButton = UIButton(title: NSLocalizedString("mine.feedback.submit", comment: "提交反馈"),titleColor: TBIThemeWhite,titleSize: 18)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textViewDidChange(_ textView: UITextView){
        if textView.text == "" {
            feedbackPlaceholder.isHidden = false
        }else {
            feedbackPlaceholder.isHidden = true
        }
    }
    
    
    func initView(){
        self.backgroundColor = TBIThemeMinorColor
        self.addSubview(feedbackTitle)
        self.addSubview(contactTitle)
        self.addSubview(contactText)
        self.addSubview(submitButton)
        self.addSubview(bgView)
        
        feedbackText.delegate = self
        feedbackPlaceholder.numberOfLines=0
        feedbackText.returnKeyType = UIReturnKeyType.done
        feedbackPlaceholder.lineBreakMode = NSLineBreakMode.byWordWrapping
        bgView.addSubview(feedbackText)
        bgView.addSubview(feedbackPlaceholder)
        bgView.backgroundColor = TBIThemeWhite
        feedbackText.font = UIFont.systemFont(ofSize: 14)
        contactText.returnKeyType = UIReturnKeyType.done
        contactText.delegate = self
        contactText.attributedPlaceholder = NSAttributedString(string:NSLocalizedString("mine.contact.message", comment: ""),attributes:[NSForegroundColorAttributeName: TBIThemePlaceholderTextColor])

        
        feedbackText.backgroundColor = TBIThemeWhite
        contactText.backgroundColor = TBIThemeWhite
        submitButton.layer.cornerRadius = 5
        submitButton.clipsToBounds=true
        submitButton.setBackgroundImage(UIImage (named: "yellow_btn_gradient"), for: UIControlState.normal)
      
        feedbackTitle.snp.makeConstraints{ make in
            make.top.left.equalTo(15)
        }
        bgView.snp.makeConstraints{make in
            make.left.right.equalTo(0)
            make.top.equalTo(feedbackTitle.snp.bottom).offset(20)
            make.height.equalTo(200)
        }
        feedbackText.snp.makeConstraints{ make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(185)
            make.top.equalTo(10)
        }
        feedbackPlaceholder.snp.makeConstraints{ make in
            make.left.equalTo(20)
            make.right.equalTo(-15)
            make.height.equalTo(50)
            make.top.equalTo(10)
        }
        contactTitle.snp.makeConstraints{ make in
            make.left.equalTo(15)
            make.top.equalTo(feedbackText.snp.bottom).offset(15)
        }
        contactText.snp.makeConstraints{ make in
            make.left.right.equalTo(0)
            make.top.equalTo(contactTitle.snp.bottom).offset(10)
            make.height.equalTo(44)
        }
        
        submitButton.snp.makeConstraints{ make  in
            make.top.equalTo(contactText.snp.bottom).offset(30)
            make.height.equalTo(47)
            make.left.equalTo(15)
            make.right.equalTo(-15)
        }
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            return false
        }
        return true
    }

}
