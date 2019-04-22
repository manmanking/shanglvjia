//
//  TBIFinderView.swift
//  shop
//
//  Created by manman on 2017/5/25.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit


enum TBIFinderViewTextAlignment {
    case center
    case left
    case right
    case None
}
//底部弹出 选择框
class TBIFinderView: UIView ,UITableViewDelegate,UITableViewDataSource{
 
    typealias TBIFinderViewSelectedResultBlock = (NSInteger)->Void
    public  var finderViewSelectedResultBlock:TBIFinderViewSelectedResultBlock!
    public  var  textAlignment:TBIFinderViewTextAlignment = TBIFinderViewTextAlignment.center
    public var  rowHeight:NSInteger = 44 //默认高度
    public var  cancelHeight:NSInteger = 50 //默认高度
    //默认设置
    public var fontSize:UIFont = UIFont.systemFont(ofSize: 16)
    private let finderViewCellIdentify = "TBIFinderViewCellIdentify"
    private var baseBackgroundView:UIView = UIView()
    private var subBackgroundView:UIView = UIView()
    private var finderDataSources:[(title:String,flageImageName:String)] = Array()
    private var tableView = UITableView()
    private var cancelButton:UIButton = UIButton()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        baseBackgroundView.backgroundColor = UIColor.black
        baseBackgroundView.alpha = 0.2
        baseBackgroundView.addOnClickListener(target: self, action: #selector(cancelButtonAction))
        self.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        subBackgroundView.backgroundColor = TBIThemeBaseColor
        self.addSubview(subBackgroundView)
        subBackgroundView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().inset(rowHeight * (finderDataSources.count) + cancelHeight + 10)
            make.bottom.equalToSuperview()
        }
        setUIViewAutolayout()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   private func setUIViewAutolayout() {
    
        if  rowHeight < cancelHeight
        {
            rowHeight = cancelHeight
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = TBIThemeBaseColor
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.register(TBIFinderViewCell.classForCoder(), forCellReuseIdentifier:finderViewCellIdentify)
        subBackgroundView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(rowHeight)
        }
        
        cancelButton.setTitle("取消", for: UIControlState.normal)
        cancelButton.titleLabel?.font = UIFont.systemFont( ofSize: 16)
        cancelButton.addTarget(self, action: #selector(cancelButtonAction), for: UIControlEvents.touchUpInside)
        cancelButton.setTitleColor(TBIThemePrimaryTextColor, for: UIControlState.normal)
        cancelButton.backgroundColor = UIColor.white
        subBackgroundView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(cancelHeight)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return finderDataSources.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:TBIFinderViewCell = tableView.dequeueReusableCell(withIdentifier: finderViewCellIdentify) as! TBIFinderViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        if finderDataSources.count > indexPath.row {
            
            cell.fillDataSources(title: finderDataSources[indexPath.row].title, textAlignment:textAlignment, textEnable: false, bottomShow: true,flagImageName: finderDataSources[indexPath.row].flageImageName,fontSize:self.fontSize, rowHeight: rowHeight,index:indexPath.row)
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(rowHeight)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(indexPath.row)
        selectedRow(cellIndex: indexPath)
    }
    
    func selectedRow(cellIndex:IndexPath) {
        cancelButtonAction()
        finderViewSelectedResultBlock(cellIndex.row)
    }
    
    
    func reloadDataSources(titledataSources:[String],flageImage:[String]?) {
        for value in titledataSources {
            finderDataSources.append((title: value, flageImageName: ""))
        }
        if flageImage != nil && (flageImage?.count)! > 0 {
            for (index,value) in (flageImage?.enumerated())! {
                finderDataSources[index].flageImageName = value
            }
        }
       if  rowHeight < cancelHeight
        {
            rowHeight = cancelHeight
        }
       
        subBackgroundView.snp.remakeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(rowHeight * (finderDataSources.count ) + cancelHeight + 10)
        }
        tableView.reloadData()
    }
    
    @objc private  func cancelButtonAction() {
        self.removeFromSuperview()
    }

}

class TBIFinderViewCell: UITableViewCell {
    private var baseBackgroundView:UIView = UIView()
    private var contentTextField:UITextField = UITextField()
    private var bottomLine:UILabel = UILabel()
    private var flagImageView:UIImageView = UIImageView()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        baseBackgroundView.backgroundColor = UIColor.white
        self.contentView.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }

        contentTextField.textColor = TBIThemePrimaryTextColor
        contentTextField.font = UIFont.systemFont(ofSize: 16)
        //contentTextField.adjustsFontSizeToFitWidth = true
        baseBackgroundView.addSubview(contentTextField)
        contentTextField.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        flagImageView.image = UIImage.init(named: "")
        flagImageView.contentMode = UIViewContentMode.scaleToFill
        baseBackgroundView.addSubview(flagImageView)
        flagImageView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.right.equalTo(contentTextField.snp.left)
            make.height.width.equalTo(30)
            
        }
        bottomLine.backgroundColor = TBIThemeGrayLineColor
        baseBackgroundView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func fillDataSources(title:String,textAlignment:TBIFinderViewTextAlignment,textEnable:Bool,bottomShow:Bool,flagImageName:String,fontSize:UIFont,rowHeight:NSInteger,index:Int) {
        
        if contentTextField.textAlignment == NSTextAlignment.left {
            contentTextField.snp.removeConstraints()
            contentTextField.snp.makeConstraints({ (make) in
                make.left.right.equalToSuperview().inset(15)
                make.top.bottom.equalToSuperview()
            })
        }
        bottomLine.isHidden = index == 0
        
        
        var titleWidth:CGFloat = 10
        if  title.isEmpty == false {
            
           titleWidth = title.getTextWidth(font:fontSize, height:CGFloat(rowHeight))
            
        }
        if fontSize != nil {
            contentTextField.font = fontSize
        }
        
        
        
        if contentTextField.textAlignment == NSTextAlignment.center {
            contentTextField.snp.removeConstraints()
            contentTextField.snp.makeConstraints({ (make) in
                make.centerX.equalToSuperview()
                make.width.equalTo(titleWidth + 10)
                make.top.bottom.equalToSuperview()
            })
        }
        
        
        
        
        if !title.isEmpty
        {
            contentTextField.text = title
        }
        switch textAlignment {
        case .left:
            contentTextField.textAlignment = NSTextAlignment.left
        case .center:
            contentTextField.textAlignment = NSTextAlignment.center
        case .right:
            contentTextField.textAlignment = NSTextAlignment.right
        case .None:
            contentTextField.textAlignment = NSTextAlignment.natural
        }
        contentTextField.isEnabled = textEnable
        bottomLine.isHidden = !bottomShow
       
        //添加校验
        guard flagImageName.characters.count > 0 else {
            return
        }
        flagImageView.image = UIImage.init(named: flagImageName)
        flagImageView.snp.remakeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(contentTextField.snp.left)
            make.height.width.equalTo((flagImageView.image?.size.height)!)
        }
    }
}








