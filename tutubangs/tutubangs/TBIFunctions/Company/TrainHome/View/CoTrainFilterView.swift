//
//  CoTrainFilterView.swift
//  shop
//
//  Created by TBI on 2018/1/3.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class CoTrainFilterView: UIView {
    
    /// 蒙层
    fileprivate let baseBackgroundView:UIView = UIView()
    /// 背景
    fileprivate let subBackgroundView:UIView = UIView()
    /// 过滤header
    fileprivate let titleBackgroundView:UIView = UIView()
    /// 过滤条件
    fileprivate var collectionView:UICollectionView?
    /// 取消
    fileprivate let cancelButton:UIButton = UIButton()
    /// 清空筛选
    fileprivate let clearButton:UIButton = UIButton()
    /// 确定
    fileprivate let okayButton:UIButton = UIButton()
    
    fileprivate let coTrainFilterColllectionReusableViewIdentify = "coTrainFilterColllectionReusableViewIdentify"
    
    fileprivate let coTrainFilterColllectionViewCellIdentify = "coTrainFilterColllectionViewCellIdentify"
    
    fileprivate var titleDataSources:[String] = ["车次类型","出发时间","出发/到达车站","是否始发"]
    
    var filterData:[[(index:Int,selected:Bool,value:String)]]?
    
    //选中回调
    typealias TrainSelectedResultBlock = ([[(index:Int,selected:Bool,value:String)]])->Void
    
    public var trainSelectedResultBlock:TrainSelectedResultBlock!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    func initView () {
        self.addSubview(baseBackgroundView)
        baseBackgroundView.backgroundColor = TBIThemeBackgroundViewColor
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        subBackgroundView.backgroundColor = UIColor.white
        self.addSubview(subBackgroundView)
        subBackgroundView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(448)
        }
        baseBackgroundView.addOnClickListener(target: self, action: #selector(cancelButtonAction))
        
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
        
        initCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
}
/// 筛选条件
extension CoTrainFilterView:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func initData () {
        collectionView?.reloadData()
    }
    
    func  initCollectionView(){
        
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        
        //设置cell的大小
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.indicatorStyle = .white
        collectionView?.backgroundColor = TBIThemeWhite
        collectionView?.register(CoTrainFilterColllectionViewCell.classForCoder(), forCellWithReuseIdentifier: coTrainFilterColllectionViewCellIdentify)
        collectionView?.register(CoTrainFilterColllectionReusableView.classForCoder(), forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: coTrainFilterColllectionReusableViewIdentify)
        self.subBackgroundView.addSubview(collectionView!)
        collectionView?.snp.makeConstraints { (make) in
           make.left.right.bottom.equalToSuperview()
           make.top.equalTo(titleBackgroundView.snp.bottom)
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return filterData?.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterData?[section].count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: coTrainFilterColllectionViewCellIdentify, for: indexPath) as! CoTrainFilterColllectionViewCell
        let data = filterData?[indexPath.section][indexPath.row]
        cell.fillCell(name: data?.value ?? "",selected: data?.selected ?? false)
        var i : Int = 0
        if data?.selected == true{
            i = i + 1
        }
        if i > 0{
           clearButton.setTitleColor(TBIThemeWhite, for: UIControlState.normal)
        }
        return cell

    }
    //返回HeadView
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: coTrainFilterColllectionReusableViewIdentify, for: indexPath) as! CoTrainFilterColllectionReusableView
        cell.fillCell(title: titleDataSources[indexPath.section])
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 3 {
            return UIEdgeInsets(top: 0, left: 30, bottom: 30, right: 30)
        }
        return UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
    }
    
    //minimumLineSpacing属性
    //设定全局的行间距，如果想要设定指定区内Cell的最小行距，可以使用下面方法：
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    //minimumInteritemSpacing属性
    //设定全局的Cell间距，如果想要设定指定区内Cell的最小间距，可以使用下面方法：
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ScreenWindowWidth - 130
        let cellSize = width/2
        return CGSize.init(width: cellSize, height: 30)
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        return CGSize.init(width: ScreenWindowWidth - 60, height: 45)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selected = filterData?[indexPath.section][indexPath.row].selected
        if selected ?? true{
            //如果选中变为未选中
            filterData?[indexPath.section][indexPath.row].selected = false
        }else {
            //改为选中
            filterData?[indexPath.section][indexPath.row].selected = true
        }
        self.collectionView?.reloadData()
    }
    
}

extension CoTrainFilterView {
    
    @objc fileprivate func cancelButtonAction() {
        // 取消回调
        self.removeFromSuperview()
    }
    
    /// 清除筛选条件
    @objc fileprivate func clearButtonAction(sender:UIButton) {
        if let data = filterData {
            for section in 0..<data.count{
                for row in 0..<data[section].count {
                    filterData?[section][row].selected  = false
                }
            }
            self.collectionView?.reloadData()
        }
        sender.setTitleColor(TBIThemePlaceholderColor, for: UIControlState.normal)
    }
    
    /// 确定
    @objc fileprivate func okayButtonAction(sender:UIButton) {
        self.removeFromSuperview()
        trainSelectedResultBlock(filterData!)
        
    }
}

class CoTrainFilterColllectionViewCell: UICollectionViewCell {
    
    let  titleLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 14)
    
    let  selectBtn = UIImageView(imageName:"unselectedSquare") //UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        selectBtn.setImage(UIImage.init(named: "unselectedSquare"), for: UIControlState.normal)
//        selectBtn.setImage(UIImage.init(named: "selectedSquare"), for: UIControlState.selected)
        self.addSubview(selectBtn)
        selectBtn.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview()
            make.height.width.equalTo(14)
        }
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(selectBtn.snp.right).offset(15)
            make.bottom.equalToSuperview()
        }
    }
    
    func fillCell(name:String,selected:Bool) {
        titleLabel.text = name
        if selected {
            selectBtn.image = UIImage.init(named: "squareSelected")
        }else {
            selectBtn.image = UIImage.init(named: "unselectedSquare")
        }
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class CoTrainFilterColllectionReusableView: UICollectionReusableView {
    
    
    fileprivate let leftLine = UILabel(color: TBIThemeGrayLineColor)
    
    fileprivate let rightLine = UILabel(color: TBIThemeGrayLineColor)
    
    fileprivate let titleLabel = UILabel(text: "", color: TBIThemeBlueColor, size: 14)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.centerX.equalToSuperview()
        }
        self.addSubview(leftLine)
        leftLine.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(30)
            make.right.equalTo(titleLabel.snp.left).offset(-20)
            make.height.equalTo(1)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
        self.addSubview(rightLine)
        rightLine.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(30)
            make.left.equalTo(titleLabel.snp.right).offset(20)
            make.height.equalTo(1)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
    }
    
    func fillCell(title:String){
        titleLabel.text = title
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
