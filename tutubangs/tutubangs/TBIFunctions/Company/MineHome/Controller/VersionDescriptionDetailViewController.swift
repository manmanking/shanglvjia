//
//  VersionDescriptionDetailViewController.swift
//  shop
//
//  Created by manman on 2017/10/12.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit


let UILABEL_LINE_SPACE:CGFloat = 6

class VersionDescriptionDetailViewController: CompanyBaseViewController,UITableViewDelegate,UITableViewDataSource {

    private let tableViewCellIdentify:String = "tableViewCellIdentify"
    private let baseBackgroundView:UIView = UIView()
    private let tableView:UITableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
    private var dataSourcesArr:[(title:String,content:String)] = Array()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = TBIThemeBaseColor
        setBlackTitleAndNavigationColor(title: "版本详情")
        dataSourcesArr = [(title:"1.0.1版本更新说明",content:""),(title:"应用全新改版，体现在以下几个方面:",content:""),(title:"",content:"1.采用原生语言替代原有混合方式,全面提升用户体验和操作手感"),(title:"",content:"2.公务出行首页全新改版,页面更简洁,操作更简单"),(title:"6.2.2beta版本更新说明",content:"3.新增\"快速审批\"模块,用户可以在应用内审批员工的出差单"),(title:"",content:"4.新增\"行程\"和\"订单\",全面辅助您记录和查询自己的出行计划")]
        
        setUIViewAutolayout()
    }
    
    private func setUIViewAutolayout() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(VersionDescriptionDetailCell.classForCoder(), forCellReuseIdentifier:tableViewCellIdentify)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.left.bottom.right.equalToSuperview()
        }
        
        
        
        
        
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourcesArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0:
            return 60
        case 1:
            return 50
            
        default:
            return getTextHeigh(textStr: dataSourcesArr[indexPath.row].content, font: UIFont.systemFont(ofSize: 14), width: ScreenWindowWidth - 20) + 15
            //getSpaceLabelHeight(textStr: dataSourcesArr[indexPath.row].content, font: UIFont.systemFont(ofSize: 14), width: ScreenWindowWidth - 30)
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:VersionDescriptionDetailCell  = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentify) as! VersionDescriptionDetailCell
        cell.selectionStyle =  UITableViewCellSelectionStyle.none
        return cell
        
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        var content:String = ""
        var rank:TitleStyle = TitleStyle.Default
        switch indexPath.row {
        case 0:
            content = dataSourcesArr[indexPath.row].title
            rank = TitleStyle.FirstRank
        case 1:
            content = dataSourcesArr[indexPath.row].title
            rank = TitleStyle.SecondRank
        default:
            content = dataSourcesArr[indexPath.row].content
            rank = TitleStyle.Default
            
        }
        
        (cell as! VersionDescriptionDetailCell).fillData(content: content, rank: rank)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        
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
    
    //计算UILabel的高度(带有行间距的情况)
    func getSpaceLabelHeight(textStr:String?,font:UIFont,width:CGFloat) -> CGFloat {
        
        
        //获取tttLabel的高度
//        //先通过NSMutableAttributedString设置和上面tttLabel一样的属性,例如行间距,字体
//        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
//        //自定义str和TTTAttributedLabel一样的行间距
//        NSMutableParagraphStyle *paragrapStyle = [[NSMutableParagraphStyle alloc] init];
//        [paragrapStyle setLineSpacing:6];
//        //设置行间距
//        [attrString addAttribute:NSParagraphStyleAttributeName value:paragrapStyle range:NSMakeRange(0, str.length)];
//        //设置字体
//        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, str.length)];
//
//        //得到自定义行间距的UILabel的高度
//        CGFloat height = [TTTAttributedLabel sizeThatFitsAttributedString:attrString withConstraints:CGSizeMake(300, MAXFLOAT) limitedToNumberOfLines:0].height;
        

        let paraStyle:NSMutableParagraphStyle = NSMutableParagraphStyle.init()
        paraStyle.lineBreakMode = NSLineBreakMode.byCharWrapping
        paraStyle.alignment = NSTextAlignment.left
        paraStyle.lineSpacing = UILABEL_LINE_SPACE
        paraStyle.hyphenationFactor = 1.0
        paraStyle.firstLineHeadIndent = 0.0
        paraStyle.paragraphSpacingBefore = 0.0
        paraStyle.headIndent = 0
        paraStyle.tailIndent = 0
        let dic = NSDictionary(object: paraStyle, forKey: NSFontAttributeName as NSCopying)
        //let  dic = NSDictionary.init(objects: [font,paraStyle], forKeys: (NSFontAttributeName as NSCopying) as! [NSCopying])
        let normalText: NSString = textStr! as NSString
        let size = CGSize(width:width,height:1000)
        let stringSize = normalText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context:nil).size
        return stringSize.height
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func backButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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

enum TitleStyle:Int {
    case FirstRank = 1
    case SecondRank = 2
    case ThirdRank = 3
    case Default = 4
}




class VersionDescriptionDetailCell: UITableViewCell {
    
    
    private let baseBackgroundView:UIView = UIView()
    private let subBaseBackgroundView:UIView = UIView()
    private let title:UILabel = UILabel()
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(baseBackgroundView)
        baseBackgroundView.backgroundColor = UIColor.white
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        setUIViewAutolayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUIViewAutolayout() {
        
        baseBackgroundView.addSubview(title)
        title.numberOfLines = 0
        title.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(15)
        }
        
    }
    
    
    func fillData(content:String,rank:TitleStyle){
        
//        //通过富文本来设置行间距
//        let paraph = NSMutableParagraphStyle()
//        //将行间距设置为28
//        paraph.lineSpacing = 20
//        //样式属性集合
//        let attributes = [NSFontAttributeName:UIFont.systemFont(ofSize: 15),
//                          NSParagraphStyleAttributeName: paraph]
//        title.attributedText = NSAttributedString(string: content, attributes: attributes)
        switch rank {
        case .FirstRank:
            title.font = UIFont.systemFont(ofSize: 20)
            title.textColor = UIColor.init(hexString: "353535")
            title.textAlignment = NSTextAlignment.left
            title.text = content
            
        case .SecondRank:
            title.font = UIFont.systemFont(ofSize: 16)
            title.textColor = UIColor.init(hexString: "353535")
            title.textAlignment = NSTextAlignment.left
            title.text = content
        case .ThirdRank:
            break
            
        default:
            title.font = UIFont.systemFont(ofSize: 14)
            title.textColor = UIColor.init(hexString: "353535")
            title.textAlignment = NSTextAlignment.left
            title.text = content
        }
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
}











