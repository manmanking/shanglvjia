//
//  AddRemarkViewController.swift
//  shanglvjia
//
//  Created by tbi on 2018/6/14.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class AddDispolicyReasonViewController: CompanyBaseViewController {

    typealias AddDispolicyReasonViewResultBlock = (String)->Void
    public var addDispolicyReasonViewResultBlock:AddDispolicyReasonViewResultBlock!
    var myContentView:UIView!
    var myPlaceHolderLabel:UILabel!
    var myTopTextView:UITextView!
    var contentStr : String = ""
    typealias returnBlock = (String)->Void
    public var reBlock:returnBlock!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = TBIThemeBaseColor
        setBlackTitleAndNavigationColor(title: "添加违背原因")
        // Do any additional setup after loading the view.
        initView()
    }
    func initView() -> Void
    {
        myContentView = UIView()
        myContentView.backgroundColor = TBIThemeBaseColor
        myContentView.frame = CGRect(x: 0, y: 0, width: ScreenWindowWidth, height: ScreentWindowHeight-20-44)
        self.view.addSubview(myContentView)
        let topTextView = UITextView()
        self.myTopTextView = topTextView
        self.myTopTextView.delegate = self
        myTopTextView.layer.cornerRadius = 4
        self.myTopTextView.returnKeyType = UIReturnKeyType.done
        myContentView.addSubview(topTextView)
        topTextView.snp.makeConstraints{(make)->Void in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(10)
            make.height.equalTo(200)
        }
        topTextView.textColor = TBIThemePrimaryTextColor
        topTextView.font = UIFont.systemFont(ofSize: 16)
        topTextView.delegate = self
        topTextView.text = contentStr
        
        if contentStr.isEmpty{
            //设置UITextView的placeHolderText
            let placeHolderLabel = UILabel(text: "请您添加违背原因", color: TBIThemeTipTextColor, size: 16)
            self.myPlaceHolderLabel = placeHolderLabel
            myContentView.addSubview(placeHolderLabel)
            //placeHolderLabel.backgroundColor = UIColor.brown
            placeHolderLabel.snp.makeConstraints{(make)->Void in
                make.left.equalTo(18)
                make.top.equalTo(17)
            }
        }
        
        let submitBtn = UIButton(title: "确定", titleColor: UIColor.white, titleSize: 18)
        submitBtn.layer.cornerRadius = 3
        submitBtn.setBackgroundImage(UIImage (named: "yellow_btn_gradient"), for: UIControlState.normal)
        submitBtn.clipsToBounds=true
        myContentView.addSubview(submitBtn)
        submitBtn.snp.makeConstraints{(make)->Void in
            make.left.equalTo(15)
            make.top.equalTo(myTopTextView.snp.bottom).offset(30)
            make.right.equalTo(-15)
            make.height.equalTo(48)
        }
         submitBtn.addOnClickListener(target: self, action: #selector(commitCommentAction(sender:)))
    }
    //重写  头部左侧的🔙Btn
    override func backButtonAction(sender: UIButton) {
        
        if addDispolicyReasonViewResultBlock != nil {
            addDispolicyReasonViewResultBlock(contentStr)
        }
        
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.navigationBar.shadowImage = UIImage.init(named: "border")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension AddDispolicyReasonViewController : UITextViewDelegate
{
    public func textViewDidChange(_ textView: UITextView)
    {
//        print("textViewDidChange   \(textView.text)")
        
        //截取50个字
        let textContent = textView.text
        let textNum = textContent?.count
        if textNum! > 50 {
            let index = textContent?.index((textContent?.startIndex)!, offsetBy: 50)
            let str = textContent?.substring(to: index!)
            textView.text = str
        }
        
        if (myTopTextView.text == nil) || (myTopTextView.text == "")
        {
            myPlaceHolderLabel.text = "请您添加违背原因" //"请您添加订单备注"
        }
        else
        {
            if contentStr.isEmpty{
                myPlaceHolderLabel.text = ""
            }            
        }
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n"{
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
    func commitCommentAction(sender:UIButton){
        if reBlock != nil{
            reBlock(myTopTextView.text)
        }
        
        if addDispolicyReasonViewResultBlock != nil {
            addDispolicyReasonViewResultBlock(myTopTextView.text)
        }
        self.navigationController?.popViewController(animated: true)
    }
}
