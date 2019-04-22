//
//  TBIAlertView.swift
//  shanglvjia
//
//  Created by tbi on 2018/5/16.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class NewAlertView: UIView {

    private var baseBackgroundView:UIView = UIView()
    var bgView = UIView()
    var titleLabel = UILabel(text:"提示标题",color:TBIThemePrimaryTextColor,size:16)
    var lineLabel = UILabel()
    
    var nullView = UIView()
    var nullImage = UIImageView()
    var nullLabel =  UILabel(text:"无",color:TBIThemePrimaryTextColor,size:15)
    var showView = UIView()
    
    var textView = UITextView()
    var okButton = UIButton()
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        baseBackgroundView.backgroundColor = TBIThemeBackgroundViewColor
        self.addSubview(baseBackgroundView)
        baseBackgroundView.addSubview(bgView)
        bgView.addSubview(showView)
        bgView.addSubview(nullView)
        showView.addSubview(titleLabel)
        showView.addSubview(lineLabel)
        showView.addSubview(textView)
        bgView.addSubview(okButton)
        nullView.addSubview(nullImage)
        nullView.addSubview(nullLabel)
        
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
        showView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        titleLabel.textAlignment=NSTextAlignment.center
        titleLabel.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(45)
            
        }
        lineLabel.backgroundColor=TBIThemeBaseColor
        lineLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        textView.font=UIFont.systemFont(ofSize: 14)
        textView.textColor=UIColor.gray
        textView.showsVerticalScrollIndicator=false
        //设置代理 不可编辑
        textView.delegate=self
        textView.bounces = false
        textView.snp.makeConstraints { (make) in
            make.top.equalTo(lineLabel.snp.bottom).offset(15)
            make.left.equalTo(25)
            make.right.equalTo(-25)
            make.height.equalTo(200)
        }
        okButton.setBackgroundImage(UIImage(named:"yellow_btn_gradient"), for: .normal)
        okButton.titleLabel?.font=UIFont.systemFont(ofSize: 15)
        okButton.layer.cornerRadius=4.0
        okButton.clipsToBounds=true
        okButton.addTarget(self, action: #selector(okButtonClick), for: UIControlEvents.touchUpInside)
        okButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(22)
            make.right.equalToSuperview().offset(-22)
            make.bottom.equalToSuperview().offset(-15)
            make.height.equalTo(40)
        }
        
        nullView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
        nullLabel.textAlignment=NSTextAlignment.center
        nullLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-100)
            make.height.equalTo(25)
        }
        nullImage.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(nullLabel.snp.top).offset(-55)
        }
    }
    required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
    }
    func okButtonClick()  {
        self.removeFromSuperview()
    }
    func setViewWithContent(content:String,titleStr:String,btnTitle:String,imageName:String,nullStr:String){
        if content.isEmpty
        {
            //隐藏提示信息view
            showView.alpha=0
            showView.isHidden=true
            nullImage.image=UIImage(named:imageName)
            nullLabel.text=nullStr
        }else{
            //隐藏nullview
            nullView.alpha=0
            nullView.isHidden=true
            textView.text=CommonTool.replace(content, withInstring: "<br/>", withOut: "\n")
            titleLabel.text=titleStr
            
            var textHeight:CGFloat = 0
            textHeight = getTextHeigh(textStr: CommonTool.replace(content, withInstring: "<br/>", withOut: "\n"), font: UIFont.systemFont( ofSize: 14), width: ScreenWindowWidth - 130 ) + 10
            textHeight = textHeight > 200 ? 200 : textHeight
            textView.snp.makeConstraints { (make) in
                make.top.equalTo(lineLabel.snp.bottom).offset(15)
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
            okButton.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(22)
                make.right.equalToSuperview().offset(-22)
                make.bottom.equalToSuperview().offset(-15)
                make.height.equalTo(40)
            }
        }
        okButton.setTitle(btnTitle, for: UIControlState.normal)
        
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

}
extension NewAlertView : UITextViewDelegate
{
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return false
    }
}
