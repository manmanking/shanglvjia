//
//  AirInfoView.swift
//  shop
//
//  Created by manman on 2017/5/17.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class AirInfoView: UIView,UITableViewDelegate,UITableViewDataSource {
    
    typealias AirInfoViewCancelBlock  = (String)->Void
    
    typealias AirInfoSelectedResultBlock = ([[(index:NSInteger,content:String)]])->Void
    
    public var airInfoSelectedResultBlock:AirInfoSelectedResultBlock!
    public var airInfoViewCancelBlock:AirInfoViewCancelBlock!
    
    public var  rightSelectedDataSources:[[(index:NSInteger,content:String)]] = Array()
    public var leftTableViewDataSources:[String] = Array()
    {
        didSet{
            for _ in 0..<leftTableViewDataSources.count {
                rightSelectedDataSources.append([(0,"")])
            }
            
        }
    }
    public var rightTableViewDataSources:[[String]] = Array()
    
    
    private let  leftTableViewCellIdentify = "AirInfoViewLeftTableViewCellIdentify"
    private let  rightTableViewCellIdentify = "AirInfoViewRightTableViewCellIdentify"
    
    private var baseBackgroundView:UIView = UIView()
    private var subBackgroundView:UIView = UIView()
    private var titleBackgroundView:UIView = UIView()
    
    private var cancelButton:UIButton = UIButton()
    private var clearButton:UIButton = UIButton()
    private var okayButton:UIButton = UIButton()
    
    private var leftTableView = UITableView()
    private var leftSelectedIndex:NSInteger = 0
    
    private var rightTableView = UITableView()
    private var rightSelectedIndex:NSInteger = 0
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(baseBackgroundView)
        baseBackgroundView.backgroundColor = TBIThemeBackgroundViewColor
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        subBackgroundView.backgroundColor = UIColor.white
        self.addSubview(subBackgroundView)
        subBackgroundView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(226)
        }
        baseBackgroundView.addOnClickListener(target: self, action: #selector(cancelButtonAction))
        setUIViewAutolayout()
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
        
    }
    
    func setUIViewAutolayout() {
        
        titleBackgroundView.backgroundColor = TBIThemeLinkColor
        subBackgroundView.addSubview(titleBackgroundView)
        titleBackgroundView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        cancelButton.setTitle("取消", for: UIControlState.normal)
        cancelButton.titleLabel?.font = UIFont.systemFont( ofSize: 16)
        cancelButton.addTarget(self, action: #selector(cancelButtonAction), for: UIControlEvents.touchUpInside)
        titleBackgroundView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(15)
            make.height.equalTo(16)
            make.width.equalTo(50)
        }
        
        clearButton.setTitle("清空已选", for: UIControlState.normal)
        clearButton.titleLabel?.font = UIFont.systemFont( ofSize: 14)
        clearButton.setTitleColor(TBIThemePlaceholderColor, for: UIControlState.normal)
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
        leftTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: leftTableViewCellIdentify)
        subBackgroundView.addSubview(leftTableView)
        leftTableView.snp.makeConstraints { (make) in
            make.top.equalTo(titleBackgroundView.snp.bottom)
            make.left.bottom.equalToSuperview()
            make.width.equalTo(125)
        }
        
        
        rightTableView.delegate = self
        rightTableView.dataSource = self
        rightTableView.showsVerticalScrollIndicator = false
        rightTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        rightTableView.register(HotelCustomScreenTableViewCell.classForCoder(), forCellReuseIdentifier: rightTableViewCellIdentify)
        subBackgroundView.addSubview(rightTableView)
        rightTableView.snp.makeConstraints { (make) in
            make.top.equalTo(titleBackgroundView.snp.bottom)
            make.right.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(125 + 15)
        }
        
    }
    
    
    //MARK:-----UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if leftTableView == tableView {
            return leftTableViewDataSources.count
        }else
        {
            return rightTableViewDataSources[leftSelectedIndex].count
            
        }
        
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if tableView == leftTableView {
            return  configLeftCell(tableView: tableView, indexPath: indexPath)
        }
        else
        {
            return configRightCell(tableView:tableView ,indexPath:indexPath)
        }
        
    }
    
    
    
    func configLeftCell(tableView:UITableView,indexPath:IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: leftTableViewCellIdentify)!
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        if leftTableViewDataSources.count > indexPath.row {
            cell.textLabel?.text = leftTableViewDataSources[indexPath.row]
            cell.textLabel?.font = UIFont.systemFont( ofSize: 14)
            cell.textLabel?.textAlignment = NSTextAlignment.center
            cell.textLabel?.textColor = TBIThemePrimaryTextColor
            cell.contentView.backgroundColor = TBIThemeBaseColor
        }
        if leftSelectedIndex == indexPath.row
        {
            cell.textLabel?.textColor = TBIThemeBlueColor
            cell.contentView.backgroundColor = UIColor.white
        }
        if rightSelectedDataSources.count != 0{
            clearButtonColor()
        }
        return cell
        
    }
    
    func configRightCell(tableView:UITableView,indexPath:IndexPath) -> UITableViewCell {
        let cell:HotelCustomScreenTableViewCell = tableView.dequeueReusableCell(withIdentifier: rightTableViewCellIdentify) as! HotelCustomScreenTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.customScreenType = TBICustomScreenType.Flight
        if rightTableViewDataSources[leftSelectedIndex].count > indexPath.row {
            
            var selectedBool:Bool = false
            
            var selectedFlag:String = ""
            
//            if leftSelectedIndex == 0 {
//                selectedFlag = ""
//            }
            switch leftSelectedIndex {
            case 0:
                selectedFlag = "emptyPlaceHolder" //是否直达 未选中 图标显示
                
                break
            case 1:
                selectedFlag = "emptyPlaceHolder" //起飞时间 未选中 图标显示
                break
            case 2:
                selectedFlag = "emptyPlaceHolder" //仓位 未选中 图标显示
                break
            case 3:
                selectedFlag = "emptyPlaceHolder" //航空公司 未选中 图标显示
                break
                
            default:
                break
            }
            
            
            var showArr:[(index:NSInteger,content:String)] = self.rightSelectedDataSources[leftSelectedIndex]
            
            let isContain =  showArr.contains(where: { (element) -> Bool in
                element.index == indexPath.row
            })
            
            if isContain {
                selectedBool = true
            }
            
            //是否直达
            if isContain == true && (leftSelectedIndex == 0 || leftSelectedIndex == 2 ){
                selectedFlag = "ic_single_selection"
            }
            
            //起飞时间
            if isContain == true && (leftSelectedIndex == 1 || leftSelectedIndex == 3 ) && indexPath.row == 0 {
                selectedFlag = "ic_single_selection"
            }else if isContain == false && (leftSelectedIndex == 1 || leftSelectedIndex == 3 ) && indexPath.row != 0
            {
                selectedFlag = "squareUnselected"
            }else if isContain == true && (leftSelectedIndex == 1 || leftSelectedIndex == 3 ) && indexPath.row != 0
            {
                selectedFlag = "squareSelected"
            }
            
            print("leftSelectedIndex",leftSelectedIndex)
            cell.cellConfig(title: rightTableViewDataSources[leftSelectedIndex][indexPath.row], selected: selectedBool, index: indexPath.row, selectedImage:selectedFlag)
            weak var weakSelf = self
            cell.hotelCustomScreenSelectedConditionBlock = { (selectedIndex) in
                
                weakSelf?.selectedCell(selectedIndex: selectedIndex)
                
            }
            
            
        }
        
        return cell
    }
    
    
    
    //MARK:-----UITableViewDataDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if leftTableView == tableView {
            leftSelectedIndex = indexPath.row
        }
        
        if rightTableView == tableView {
            selectedCell(selectedIndex: indexPath.row)
        }
        self.reloadDataSources()
    }
    
    func reloadDataSources() {
        leftTableView.reloadData()
        rightTableView.reloadData()
        
    }
    
    
    private func selectedCell(selectedIndex:NSInteger)
    {
        weak var weakSelf = self
        
        var tmpArr:[(index:NSInteger,content:String)] = (weakSelf?.rightSelectedDataSources[(weakSelf?.leftSelectedIndex)!])!
        weakSelf?.rightSelectedDataSources.remove(at: (weakSelf?.leftSelectedIndex)!)
        //单选
        if weakSelf?.leftSelectedIndex == 0  || weakSelf?.leftSelectedIndex == 2 {
            
            tmpArr.removeAll()
            //tmpArr.append((selectedIndex,""))
            tmpArr.append((weakSelf?.fillDataSources(rowIndex: selectedIndex, categoryIndex: (weakSelf?.leftSelectedIndex)!))!)
            
            //print(tmpArr)
            weakSelf?.rightSelectedDataSources.insert(tmpArr, at: ((weakSelf?.leftSelectedIndex)!))
        }
        else // 复选  复选可以取消选项 单选 不可以
        {
            
            let isContain = tmpArr.contains(where: { (element) -> Bool in
                element.index == 0
            })
            
            
            if selectedIndex == 0 || isContain == true {
                tmpArr.removeAll()
                //tmpArr.append((selectedIndex,""))
                tmpArr.append((weakSelf?.fillDataSources(rowIndex: selectedIndex, categoryIndex: (weakSelf?.leftSelectedIndex)!))!)
                //print(tmpArr)
                weakSelf?.rightSelectedDataSources.insert(tmpArr, at: (weakSelf?.leftSelectedIndex)!)
            }else
            {
                
                let isContain = tmpArr.contains(where: { (element) -> Bool in
                    element.index == selectedIndex
                })
                
                if !isContain {
                    //tmpArr.append((selectedIndex,""))
                    tmpArr.append((weakSelf?.fillDataSources(rowIndex: selectedIndex, categoryIndex: (weakSelf?.leftSelectedIndex)!))!)
                    //print(tmpArr)
                    weakSelf?.rightSelectedDataSources.insert(tmpArr, at: ((weakSelf?.leftSelectedIndex)!))
                }else
                {
                    for index in 0..<tmpArr.count
                    {
                        if tmpArr.count > index {
                            if tmpArr[index].index == selectedIndex {
                                tmpArr.remove(at: index)
                            }
                        }
                    }
                    
                    if tmpArr.count == 0 {
                        tmpArr.append((0,"不限"))
                    }
                    //print(tmpArr)
                    weakSelf?.rightSelectedDataSources.insert(tmpArr, at: ((weakSelf?.leftSelectedIndex)!))
                }
            }
            
        }
        weakSelf?.reloadDataSources()
        
        var noNum : Int = 0
        for i in 0...rightSelectedDataSources.count-1{
            if rightSelectedDataSources[i][0].index == 0{
                noNum = noNum + 1
            }
        }
        if noNum == rightSelectedDataSources.count{
            clearButton.setTitleColor(TBIThemePlaceholderColor, for: UIControlState.normal)
        }else{
            clearButton.setTitleColor(TBIThemeWhite, for: UIControlState.normal)
        }
        clearButtonColor()
    }
    ///清空已选的按钮颜色
    func clearButtonColor() {
        var noNum : Int = 0
        for i in 0...rightSelectedDataSources.count-1{
            if rightSelectedDataSources[i][0].index == 0{
                noNum = noNum + 1
            }
        }
        if noNum == rightSelectedDataSources.count{
            clearButton.setTitleColor(TBIThemePlaceholderColor, for: UIControlState.normal)
        }else{
            clearButton.setTitleColor(TBIThemeWhite, for: UIControlState.normal)
        }
    }
    
    
    func fillDataSources(rowIndex:NSInteger,categoryIndex:NSInteger)->(index:NSInteger,content:String){
        
        let content = rightTableViewDataSources[categoryIndex][rowIndex]
        let element:(index:NSInteger,content:String) = (index:rowIndex,content:content)
        return element
        
    }
    
    
    
    
    
    
    //MARK:------Action
    @objc fileprivate func cancelButtonAction() {
        printDebugLog(message: "cancelButtonAction ...")
        if airInfoViewCancelBlock != nil
        {
            airInfoViewCancelBlock("")
        }
        self.removeFromSuperview()
    }
    
    
    
    @objc private func clearButtonAction(sender:UIButton) {
        
        printDebugLog(message: "clearButtonAction ...")
        if rightSelectedDataSources.count > 0 {
            rightSelectedDataSources.removeAll()
        }
        
        for _ in leftTableViewDataSources {
            rightSelectedDataSources.append([(0,"")])
        }
        reloadDataSources()
        sender.setTitleColor(TBIThemePlaceholderColor, for: UIControlState.normal)
    }
    
    
    @objc private func okayButtonAction(sender:UIButton) {
        printDebugLog(message: "okayButtonAction ...")
        
        
        //print(rightSelectedDataSources)
        self.airInfoSelectedResultBlock(rightSelectedDataSources)
         self.removeFromSuperview()
         //cancelButtonAction(sender: UIButton())
        
    }
    
    
}
