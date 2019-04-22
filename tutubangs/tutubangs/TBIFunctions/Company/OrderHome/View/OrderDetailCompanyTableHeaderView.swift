//
//  OrderDetailCompanyTableHeaderView.swift
//  shop
//
//  Created by manman on 2017/9/8.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class OrderDetailCompanyTableHeaderView: UIView ,UITableViewDelegate,UITableViewDataSource{

    
    private let OrderDetailCompanyTableHeaderViewCellIdentify:String = "OrderDetailCompanyTableHeaderViewCell"
    
    private let baseBackgroundView:UIView = UIView()
    
    
    private let subBaseOrderStateBackgroundView:UIView = UIView()
    
    
    private let subBaseOrderInfoBackgroundView:UIView = UIView()

    public var  orderInfoArr:[(title:String ,content:String)] = Array()
    
    private let tableView:UITableView = UITableView()
    
    
    
    
    
    // 订单状态的 变量  照搬过来  后面在做处理
    
    var commonTopStatusContainerView = UIView()
    
    var circleViewArray:[UIImageView] = []
    var lineViewArray:[UIView] = []
    var statusTextViewArray:[UILabel] = []
    
    //状态对应的的文字
    var statusTextArray:[String] = []
    var statusNum:Int = 0
    
    

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(baseBackgroundView)
        baseBackgroundView.backgroundColor = TBIThemeBaseColor
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        baseBackgroundView.addSubview(subBaseOrderStateBackgroundView)
        subBaseOrderStateBackgroundView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(100)
        }
        
        subBaseOrderInfoBackgroundView.backgroundColor = UIColor.white
        baseBackgroundView.addSubview(subBaseOrderInfoBackgroundView)
        subBaseOrderInfoBackgroundView.snp.makeConstraints { (make) in
            make.top.equalTo(subBaseOrderStateBackgroundView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
        }
        setUIViewAutolayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUIViewAutolayout()
    {
        subBaseOrderStateBackgroundView.backgroundColor = TBIThemeBlueColor
        subBaseOrderStateBackgroundView.addSubview(commonTopStatusContainerView)
        commonTopStatusContainerView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(100)
        }
        
        
        
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.register(OrderDetailCompanyTableHeaderViewCell.classForCoder(), forCellReuseIdentifier:OrderDetailCompanyTableHeaderViewCellIdentify)
        subBaseOrderInfoBackgroundView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(15)
            make.left.right.equalToSuperview()
        }
    }
    
    
    func fillDataSources() {
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return orderInfoArr.count
        return 4
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:OrderDetailCompanyTableHeaderViewCell = tableView.dequeueReusableCell(withIdentifier:OrderDetailCompanyTableHeaderViewCellIdentify) as! OrderDetailCompanyTableHeaderViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
         (cell as! OrderDetailCompanyTableHeaderViewCell).fillDataSources(showInfo: true, title: orderInfoArr[indexPath.row].title, content: orderInfoArr[indexPath.row].content, contentEnable: false, atIndex: indexPath, showLine: false)
    }
    
    
    
    
    //对TableTopView进行布局
    func layoutTableTopView() -> Void
    {
        //隐藏子视图
        for subView in commonTopStatusContainerView.subviews
        {
            subView.isHidden = true
        }
        
        circleViewArray = []
        lineViewArray = []
        statusTextViewArray = []
        
        
        statusNum = statusTextArray.count
        
        //var i:Int = 0
        
        let lineNum = statusNum-1
        let circleStatusViewRadious = 8
        
        var marginEdge = 21
        if statusTextArray[0].characters.count >= 3
        {
            marginEdge = 27
        }
        
        let lineDistanceX:Int = (Int(ScreenWindowWidth)-(marginEdge*2)-(circleStatusViewRadious*2))/lineNum
        //设置中间线条的line
        for i in 0..<lineNum
        {
            let lineView = UIView();
            commonTopStatusContainerView.addSubview(lineView)
            //将线添加进数组
            lineViewArray.append(lineView)
            
            
            
            lineView.tag = i
            //lineView.backgroundColor = UIColor.white
            
            if i==0 {
                lineView.snp.makeConstraints{ (make) ->Void in
                    make.height.equalTo(4)
                    make.width.equalTo(lineDistanceX-13)
                    make.top.equalTo(38-2)
                    
                    make.centerX.equalTo(marginEdge-3+circleStatusViewRadious+lineDistanceX/2+3)
                    //make.left.equalTo(marginEdge+circleStatusViewRadious)
                }
            }
            else
            {
                //lineView.backgroundColor = UIColor.init(r: 154, g: 198, b: 250)
                
                lineView.snp.makeConstraints{ (make) ->Void in
                    make.height.equalTo(4)
                    make.width.equalTo(lineDistanceX-13)
                    make.top.equalTo(38-2)
                    
                    make.centerX.equalTo(marginEdge-3+circleStatusViewRadious+lineDistanceX*i+lineDistanceX/2+3)
                    //make.left.equalTo(marginEdge+circleStatusViewRadious+lineDistanceX*i)
                }
            }
            
            
        }
        
        //设置订单状态的Image
        for i in 0..<statusNum
        {
            let orderStatusImage = UIImageView()
            orderStatusImage.backgroundColor = UIColor.clear
            //orderStatusImage.image = UIImage(named: "ic_c_complete")
            orderStatusImage.tag=i
            commonTopStatusContainerView.addSubview(orderStatusImage)
            //将圆形状态添加进数组
            circleViewArray.append(orderStatusImage)
            
            if i==0
            {
                orderStatusImage.snp.makeConstraints { (make) -> Void in
                    make.width.height.equalTo(16)
                    make.left.equalTo(marginEdge)
                    make.top.equalTo(30)
                }
            }
            else
            {
                //orderStatusImage.image = UIImage(named: "ic_c_current")
                
                orderStatusImage.snp.makeConstraints { (make) -> Void in
                    make.width.height.equalTo(16)
                    make.top.equalTo(30)
                    make.left.equalTo(marginEdge+lineDistanceX*i)
                }
            }
            
        }
        
        
        
        for i in 0..<statusNum
        {
            let statusLabel = UILabel(text: statusTextArray[i], color: UIColor.white, size: 13)
            statusLabel.backgroundColor = UIColor.clear
            commonTopStatusContainerView.addSubview(statusLabel)
            statusTextViewArray.append(statusLabel)
            
            
            statusLabel.snp.makeConstraints { (make) -> Void in
                make.height.equalTo(13)
                make.top.equalTo(56)
                make.centerX.equalTo(circleViewArray[i].snp.centerX)
            }
        }
        
    }
    
    //TODO: 设置当前整体的订单状态的视图
    func setCurrentTotalOrderStatus(currentStatusNo:Int) -> Void
    {
        for i in 0..<statusNum
        {
            if i < currentStatusNo
            {
                //TODO:需要设置图片
                circleViewArray[i].image = UIImage(named: "ic_c_complete")
            }
            else if i == currentStatusNo
            {
                //circleViewArray[i].image = UIImage(named: "ic_c_current")
                circleViewArray[i].image = UIImage(named: "ic_c_complete")
            }
            else if i > currentStatusNo
            {
                //TODO:需要设置图片
                //circleViewArray[i].image = UIImage(named: "ic_c_complete")
                circleViewArray[i].layer.cornerRadius = 16.0/2
                circleViewArray[i].backgroundColor = UIColor.init(r: 154, g: 198, b: 250)
                
                statusTextViewArray[i].textColor = UIColor.init(r: 154, g: 198, b: 250)
            }
            
            
            
            if i != statusNum-1
            {
                if i < currentStatusNo
                {
                    lineViewArray[i].backgroundColor = UIColor.white
                }
                else
                {
                    lineViewArray[i].backgroundColor = UIColor.init(r: 154, g: 198, b: 250)
                }
            }
        }
        
    }
  
}









class OrderDetailCompanyTableHeaderViewCell: UITableViewCell,UITextFieldDelegate {
    
    
    private let leftMargin:Float = 15
    
    private let titleContentWidth:Float = 80
    
    
    private let baseBackgroundView:UIView = UIView()
    
    private let titleCatoryTextField:UITextField = UITextField()
    
    private let contentTextField:UITextField = UITextField()
    
    private var cellAtIndex:IndexPath?
    
    private let bottomLine:UILabel = UILabel()
    
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = UIColor.white
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
    
    
    
    private func setUIViewAutolayout()
    {
        titleCatoryTextField.textColor = TBIThemeTipTextColor
        titleCatoryTextField.font = UIFont.systemFont(ofSize: 15)
        titleCatoryTextField.textAlignment = NSTextAlignment.center
        titleCatoryTextField.delegate = self
        baseBackgroundView.addSubview(titleCatoryTextField)
        titleCatoryTextField.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(leftMargin)
            make.width.equalTo(titleContentWidth)
        }
        
        
        
        contentTextField.delegate = self
        contentTextField.font = UIFont.systemFont(ofSize: 15)
        contentTextField.textColor = TBIThemePrimaryTextColor
        contentTextField.textAlignment = NSTextAlignment.left
        baseBackgroundView.addSubview(contentTextField)
        contentTextField.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(titleCatoryTextField.snp.right).offset(20)
            make.right.equalToSuperview()
        }
        
        bottomLine.backgroundColor = TBIThemeGrayLineColor
        baseBackgroundView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(leftMargin)
            make.bottom.equalToSuperview().inset(1)
            make.height.equalTo(0.5)
            
        }
    }
    
    
    
    func fillDataSources(showInfo:Bool?, title:String? , content:String? ,contentEnable:Bool?,atIndex:IndexPath?, showLine:Bool?) {
        
        if !(showInfo ?? false) {
            baseBackgroundView.isHidden = !showInfo!
        }
        
        if title?.isEmpty == false {
            titleCatoryTextField.text = title
        }
        
        
         contentTextField.isEnabled = (contentEnable ?? false)
        if contentEnable ?? false
        {
           contentTextField.textColor = TBIThemeBlueColor
            
            
        }else
        {
            contentTextField.textColor = TBIThemePrimaryTextColor
            
        }
        
        if content?.isEmpty == false {
            contentTextField.text = content
        }
        
        if atIndex != nil {
            cellAtIndex = atIndex
        }
        bottomLine.isHidden = !(showLine ?? false)
        
    }
    
}















