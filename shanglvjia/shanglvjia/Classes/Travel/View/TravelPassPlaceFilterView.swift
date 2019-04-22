//
//  TravelPassPlaceFilterView.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/7/12.
//  Copyright © 2017年 TBI. All rights reserved.
//

//途经地筛选 控件

import UIKit

class TravelPassPlaceFilterView: UIView
{
    typealias DelegateMethodType = (_ clickAction:TravelPassPlaceFilterView.ClickActionEnum,_ leftIndex:Int,_ rightIndex:Int)->Void
    
    fileprivate static var instance:TravelPassPlaceFilterView! = nil
    fileprivate static weak var lastRootViewController:UIViewController! = nil
    fileprivate static weak var currentRootViewController:UIViewController! = nil
    {
        willSet
        {
            lastRootViewController = currentRootViewController
        }
    }
    
    
    let  leftTableViewCellIdentify = "AirInfoViewLeftTableViewCellIdentify"
    let  rightTableViewCellIdentify = "AirInfoViewRightTableViewCellIdentify"
    
    
    var delegateMethod:DelegateMethodType! = nil
    
    var leftTableViewDataSources:[String] = []
    var rightTableViewDataSources:[[String]] = []
    
    
    let myContentView = UIView()
    private var titleBackgroundView:UIView = UIView()
    
    private var cancelButton:UIButton = UIButton()
    private var clearButton:UIButton = UIButton()
    private var okayButton:UIButton = UIButton()
    
    var leftTableView = UITableView()
    var leftSelectedIndex:NSInteger = 0
    
    var rightTableView = UITableView()
    var rightSelectedIndexTuple:(left:NSInteger,right:NSInteger) = (0,0)
    
    var dataSourceArray:[(title:String,contentArray:[String])] = []
    {
        didSet
        {
            leftTableViewDataSources = []
            rightTableViewDataSources = []
            for item in dataSourceArray
            {
                leftTableViewDataSources.append(item.title)
                rightTableViewDataSources.append(item.contentArray)
            }
            
            let isEqualCount = isEqualDastaSourceCount(dataSource1: oldValue, dataSource2: dataSourceArray)
            if !isEqualCount
            {
                leftSelectedIndex = 0
                rightSelectedIndexTuple = (0,0)
            }
            
            self.reloadDataSources()
        }
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() -> Void
    {
        myContentView.backgroundColor = .white
        self.addSubview(myContentView)
        myContentView.snp.makeConstraints{(make)->Void in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(315)
        }
        
        setUIViewAutolayout()
    }
    
    func setUIViewAutolayout()
    {
        
        titleBackgroundView.backgroundColor = TBIThemeLinkColor
        myContentView.addSubview(titleBackgroundView)
        titleBackgroundView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        cancelButton.setTitle("取消", for: UIControlState.normal)
        cancelButton.titleLabel?.font = UIFont.systemFont( ofSize: 16)
        cancelButton.addTarget(self, action: #selector(cancelButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        titleBackgroundView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(15)
            make.height.equalTo(16)
            make.width.equalTo(50)
        }
        
        //上方的执行取消动作的按钮🔘
        let cancelBgView = UIView()
        self.addSubview(cancelBgView)
        cancelBgView.snp.makeConstraints{(make)->Void in
            make.left.right.equalToSuperview()
            make.top.equalTo(-100)
            make.bottom.equalTo(myContentView.snp.top)
        }
        //点击空白处相当于点击 取消 按钮🔘
        cancelBgView.addOnClickListener(target: self, action: #selector(cancelButtonAction))
        
        clearButton.setTitle("清空已选", for: UIControlState.normal)
        clearButton.titleLabel?.font = UIFont.systemFont( ofSize: 14)
        clearButton.addTarget(self, action: #selector(clearButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        titleBackgroundView.addSubview(clearButton)
        clearButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(16)
            make.width.equalTo(100)
        }
        
        okayButton.setTitle("确定", for: UIControlState.normal)
        okayButton.titleLabel?.font = UIFont.systemFont( ofSize: 16)
        okayButton.addTarget(self, action: #selector(okayButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        titleBackgroundView.addSubview(okayButton)
        okayButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(15)
            make.height.equalTo(16)
            make.width.equalTo(50)
        }
        
        leftTableView.delegate = self
        leftTableView.dataSource = self
        leftTableView.showsVerticalScrollIndicator = false
        leftTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        leftTableView.backgroundColor = TBIThemeBaseColor
        leftTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: leftTableViewCellIdentify)
        myContentView.addSubview(leftTableView)
        leftTableView.snp.makeConstraints { (make) in
            make.top.equalTo(titleBackgroundView.snp.bottom)
            make.left.bottom.equalToSuperview()
            make.width.equalTo(125)
        }
        
        
        rightTableView.delegate = self
        rightTableView.dataSource = self
        rightTableView.showsVerticalScrollIndicator = false
        rightTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        rightTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: rightTableViewCellIdentify)
        myContentView.addSubview(rightTableView)
        rightTableView.snp.makeConstraints { (make) in
            make.top.equalTo(titleBackgroundView.snp.bottom)
            make.right.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(125 + 15)
        }
        
    }
    
}

extension TravelPassPlaceFilterView:UITableViewDelegate,UITableViewDataSource
{
    //MARK:-----UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if leftTableView == tableView
        {
            return leftTableViewDataSources.count
        }
        else
        {
            return rightTableViewDataSources[leftSelectedIndex].count
            
        }
        
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        
        if tableView == leftTableView
        {
            return  configLeftCell(tableView: tableView, indexPath: indexPath)
        }
        else
        {
            return configRightCell(tableView:tableView ,indexPath:indexPath)
        }
        
    }
    
    
    
    func configLeftCell(tableView:UITableView,indexPath:IndexPath) -> UITableViewCell
    {
        
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: leftTableViewCellIdentify)!
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        if indexPath.row < leftTableViewDataSources.count
        {
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell.textLabel?.text = leftTableViewDataSources[indexPath.row]
            cell.textLabel?.textAlignment = NSTextAlignment.center
            cell.textLabel?.textColor = TBIThemePrimaryTextColor
            cell.contentView.backgroundColor = TBIThemeBaseColor
        }
        if leftSelectedIndex == indexPath.row
        {
            cell.textLabel?.textColor = TBIThemeBlueColor
            cell.contentView.backgroundColor = UIColor.white
        }
        
        return cell
        
    }
    
    func configRightCell(tableView:UITableView,indexPath:IndexPath) -> UITableViewCell
    {
        //let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: rightTableViewCellIdentify)!
        let cell:UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: rightTableViewCellIdentify)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let cellContentView = UIView()
        cell.contentView.addSubview(cellContentView)
        cellContentView.snp.makeConstraints{(make)->Void in
            make.left.right.top.bottom.equalTo(0)
        }
        
        let leftContentLabel = UILabel(text: rightTableViewDataSources[leftSelectedIndex][indexPath.row], color: TBIThemePrimaryTextColor, size: 14)
        cellContentView.addSubview(leftContentLabel)
        leftContentLabel.snp.makeConstraints{(make)->Void in
            make.left.equalTo(0)
            make.centerY.equalToSuperview()
        }
        let rightArrowView = UIImageView(imageName: "ic_single_selection")
        cellContentView.addSubview(rightArrowView)
        rightArrowView.snp.makeConstraints{(make)->Void in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
        }
        let bottomSegLine = UIView()
        bottomSegLine.backgroundColor = TBIThemeGrayLineColor
        cellContentView.addSubview(bottomSegLine)
        bottomSegLine.snp.makeConstraints{(make)->Void in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        rightArrowView.isHidden = true
        
        if (rightSelectedIndexTuple.right == indexPath.row) && (rightSelectedIndexTuple.left == leftSelectedIndex)
        {
            rightArrowView.isHidden = false
        }
        
        return cell
    }
    
    
    
    //MARK:-----UITableViewDataDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 44
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        if leftTableView == tableView {
            leftSelectedIndex = indexPath.row
        }
        
        if rightTableView == tableView
        {
            rightSelectedIndexTuple = (leftSelectedIndex,indexPath.row)
        }
        
        
        self.reloadDataSources()
    }
    
    func reloadDataSources()
    {
        leftTableView.reloadData()
        rightTableView.reloadData()
        
    }
}


extension TravelPassPlaceFilterView
{
    //MARK:------Action
    @objc fileprivate func cancelButtonAction(sender:UIButton)
    {
        //printDebugLog(message: "cancelButtonAction ...")
        self.removeFromSuperview()
        
        if delegateMethod != nil
        {
            self.delegateMethod(.cancel,-1,-1)
        }
    }
    
    
    
    @objc fileprivate func clearButtonAction(sender:UIButton)
    {
        
        //printDebugLog(message: "clearButtonAction ...")
        leftSelectedIndex = 0
        rightSelectedIndexTuple = (0,0)
        self.reloadDataSources()
        
        // 让UITableView自动滑动（定位）到某一行cell
        leftTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .middle, animated: true)
        rightTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .middle, animated: true)
    }
    
    
    @objc fileprivate func okayButtonAction(sender:UIButton) {
        //printDebugLog(message: "okayButtonAction ...")
        self.removeFromSuperview()
        if delegateMethod != nil
        {
            self.delegateMethod(.ok,leftSelectedIndex,rightSelectedIndexTuple.right)
        }
    }
    
    enum ClickActionEnum
    {
        case ok
        case cancel
    }
    
    //UIVIew平移的动画
    func viewTranslateAnimation(view:UIView,fromYPosition:CGFloat,toYPosition:CGFloat,duration:Double = 0.5) -> Void
    {
        view.transform = CGAffineTransform(translationX: 0, y: fromYPosition)
        self.backgroundColor = UIColor(r:0,g:0,b:0,alpha:0)
        
        UIView.animate(withDuration: duration, animations: {_ in
            view.transform = CGAffineTransform(translationX: 0, y: toYPosition)
            self.backgroundColor = UIColor(r:0,g:0,b:0,alpha:0.6)
        }, completion: nil)
        
    }
}

extension TravelPassPlaceFilterView
{
    //新创建实例
    public static func getNewInstance(dataSourceArray:[(title:String,contentArray:[String])],resultBlock:DelegateMethodType?)->TravelPassPlaceFilterView
    {
        instance = TravelPassPlaceFilterView(frame: ScreenWindowFrame)
        instance.delegateMethod = resultBlock
        instance.dataSourceArray = dataSourceArray
        
        instance.viewTranslateAnimation(view: instance.myContentView, fromYPosition: 315, toYPosition: 0)
        
        return instance
    }
    
    //单实例
    static func getInstance(viewController:UIViewController,dataSourceArray:[(title:String,contentArray:[String])],resultBlock:DelegateMethodType?)->TravelPassPlaceFilterView
    {
        
        TravelPassPlaceFilterView.currentRootViewController = viewController
        if (instance == nil) || (TravelPassPlaceFilterView.lastRootViewController == nil) || (TravelPassPlaceFilterView.lastRootViewController != TravelPassPlaceFilterView.currentRootViewController)
        {
            instance = TravelPassPlaceFilterView(frame: ScreenWindowFrame)
        }
        instance.delegateMethod = resultBlock
        instance.dataSourceArray = dataSourceArray
        
        instance.viewTranslateAnimation(view: instance.myContentView, fromYPosition: 226, toYPosition: 0)
        
        //instance.leftSelectedIndex = 0
        //instance.reloadDataSources()
        
        return instance
    }
}

extension TravelPassPlaceFilterView
{
    func isEqualDastaSourceCount(dataSource1:[(String,[String])],dataSource2:[(String,[String])]) -> Bool
    {
        if dataSource1.count != dataSource2.count
        {
            return false
        }
        
        for i in 0..<dataSource1.count
        {
            let item1 = dataSource1[i]
            let item2 = dataSource2[i]
            
            if item1.1.count != item2.1.count
            {
                return false
            }
        }
        
        return true
    }
    
    
}





