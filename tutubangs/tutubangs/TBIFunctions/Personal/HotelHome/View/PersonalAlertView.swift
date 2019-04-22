//
//  PersonalAlertView.swift
//  shanglvjia
//
//  Created by tbi on 2018/8/1.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PersonalAlertView: UIView {

    private var baseBackgroundView:UIView = UIView()
    
    var bgView = UIView()
    var titleLabel = UILabel(text:"提示标题",color:TBIThemePrimaryTextColor,size:18)
    var textView = UITextView()
    var okButton = UIButton()
    var lineLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        baseBackgroundView.backgroundColor = TBIThemeBackgroundViewColor
        self.addSubview(baseBackgroundView)
        baseBackgroundView.addSubview(bgView)
        bgView.addSubview(titleLabel)
        bgView.addSubview(okButton)
        bgView.addSubview(textView)
        bgView.addSubview(lineLabel)
        
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        bgView.layer.cornerRadius=4.0
        bgView.clipsToBounds=true
        bgView.backgroundColor=TBIThemeWhite
        bgView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.equalTo(40)
            make.right.equalTo(-40)
            make.height.equalTo(345)
            
        }
        titleLabel.textAlignment=NSTextAlignment.center
        titleLabel.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(60)
            
        }
        
        textView.font=UIFont.systemFont(ofSize: 15)
        textView.textColor=UIColor.gray
        textView.showsVerticalScrollIndicator=false
        //设置代理 不可编辑
        textView.delegate=self
        textView.bounces = false
        textView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalTo(25)
            make.right.equalTo(-25)
            make.height.equalTo(200)
        }
        
    
        okButton.setTitleColor(PersonalThemeDarkColor, for: .normal)
        okButton.titleLabel?.font=UIFont.systemFont(ofSize: 18)
        okButton.addTarget(self, action: #selector(okButtonClick), for: UIControlEvents.touchUpInside)
        okButton.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(50)
        }
        
        lineLabel.backgroundColor=TBIThemeBaseColor
        lineLabel.snp.makeConstraints { (make) in
            make.top.equalTo(okButton)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
    }
    func okButtonClick()  {
        self.removeFromSuperview()
    }
    func setViewWithContent(content:String,titleStr:String,btnTitle:String){
        
        okButton.setTitle(btnTitle, for: UIControlState.normal)
        
        var textHeight:CGFloat = 0
        textHeight = getTextHeigh(textStr: CommonTool.replace(content, withInstring: "<br/>", withOut: "\n"), font: UIFont.systemFont( ofSize: 15), width: ScreenWindowWidth - 130 ) + 10 + 20
        
        textView.text=CommonTool.replace(content, withInstring: "<br/>", withOut: "\n")
        titleLabel.text=titleStr
        
        textHeight = textHeight > 200 ? 200 : textHeight
        textView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalTo(25)
            make.right.equalTo(-25)
            make.height.equalTo(textHeight)
        }
        bgView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.equalTo(40)
            make.right.equalTo(-40)
            make.height.equalTo(145 + textHeight)
            
        }
    }
    func getTextHeigh(textStr:String?,font:UIFont,width:CGFloat) -> CGFloat {
        
        if textStr?.characters.count == 0 || textStr == nil {
            return 0.0
        }
        let normalText: NSString = textStr as! NSString
        let size = CGSize(width:width,height:1000)
        let dic = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
        let stringSize = normalText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context:nil).size
        return stringSize.height
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension PersonalAlertView : UITextViewDelegate
{
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return false
    }
}
