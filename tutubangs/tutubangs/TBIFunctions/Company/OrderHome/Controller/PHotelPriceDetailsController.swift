//
//  PHotelPriceDetailsController.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/6/29.
//  Copyright © 2017年 TBI. All rights reserved.
//

//个人版酒店的价格明细页面


import UIKit

class PHotelPriceDetailsController: CompanyBaseViewController
{
    
    //价格明细
    var costList:[(String,Double)] = []
    // 早餐
    var productBreakfast:String = ""
    
    
    let contentYOffset:CGFloat = 20+44

    var myTableDataSource:[[(String,String,String,String)]] = []
    var myTableView:UITableView! = nil
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        //设置头部的导航栏
        self.title = "价格明细"  //"价格明细"
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont.systemFont(ofSize: 16),NSForegroundColorAttributeName:UIColor.white]
        setNavigationBackButton(backImage: "back")
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIColor.creatImageWithColor(color: TBIThemeBlueColor), for: .any, barMetrics: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        
        
        initView()
    }
    
    //重写  头部左侧的🔙Btn
    override func backButtonAction(sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.navigationBar.shadowImage = UIImage.init(named: "border")
    }
    
    
    
    func initView() -> Void
    {
        setDataSource()
        
        //myTableView = UITableView(frame: CGRect(x: 0, y: contentYOffset, width: ScreenWindowWidth, height: ScreentWindowHeight - contentYOffset), style: .grouped)
        myTableView = UITableView(frame: CGRect(x: 0, y: 0, width: ScreenWindowWidth, height: ScreentWindowHeight - contentYOffset))
        myTableView.backgroundColor = .white
        
        myTableView.rowHeight = UITableViewAutomaticDimension
        myTableView.estimatedRowHeight = 30
        
        myTableView.sectionHeaderHeight = UITableViewAutomaticDimension
        myTableView.estimatedSectionHeaderHeight = 5
        
        myTableView.separatorStyle = .none
        
        self.view.addSubview(myTableView)
        myTableView.dataSource = self
        myTableView.delegate = self
        
        
    }
    
    func setDataSource() -> Void
    {
        let groupItemCount = 2
        
        for i in 0..<groupItemCount    //group 组号
        {
            var tempArray:[(String,String,String,String)] = []
            
            if i == 0   //第一组   "房费"组
            {
                var totalPrice = 0.0
                for costItem in costList
                {
                    totalPrice += costItem.1
                }
                
                for j in 0..<costList.count    //row   组内的 行号
                {
                    //modify by manman   beacuse BUG 253
                    tempArray.append(("房费","¥\(Float(totalPrice).OneOfTheEffectiveFraction())",costList[j].0,"¥\(Float(costList[j].1).OneOfTheEffectiveFraction())"))
                    // end of line
                }
            }
            else if i == 1       //第二组 早餐组
            {
                for j in 0..<costList.count    //row   组内的 行号
                {
                    tempArray.append(("早餐","",costList[j].0,self.productBreakfast))
                }
            }
            
            myTableDataSource.append(tempArray)
        }
    }
    
    

}

extension PHotelPriceDetailsController:UITableViewDelegate,UITableViewDataSource
{
    public func numberOfSections(in tableView: UITableView) -> Int
    {
        return myTableDataSource.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return myTableDataSource[section].count
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        //let containerView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWindowWidth, height: 200))
        let containerView = UIView()
        containerView.backgroundColor = .white
        
        let leftTitleLabel = UILabel(text: myTableDataSource[section][0].0, color: TBIThemePrimaryTextColor, size: 16)
        containerView.addSubview(leftTitleLabel)
        leftTitleLabel.snp.makeConstraints{(make)->Void in
            make.left.equalTo(15)
            make.bottom.equalTo(-15)
            
            make.top.equalTo(15)
        }
        
        let rightPriceLabel = UILabel(text: myTableDataSource[section][0].1, color: TBIThemeOrangeColor, size: 16)
        containerView.addSubview(rightPriceLabel)
        rightPriceLabel.snp.makeConstraints{(make)->Void in
            make.top.equalTo(15)
            make.right.equalTo(-15)
        }
        
        //设置分割线
        let bottomSegLine = UIView()
        bottomSegLine.backgroundColor = TBIThemeGrayLineColor
        containerView.addSubview(bottomSegLine)
        bottomSegLine.snp.makeConstraints{(make)->Void in
            make.left.equalTo(15)
            make.right.equalTo(0)
            make.height.equalTo(1)
            
            make.bottom.equalToSuperview()
        }
        
        return containerView
    }
    
//    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat
//    {
//        return 50
//    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        let bgView = UIView()
        bgView.backgroundColor = .white
        
        return bgView
    }
    public func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat
    {
        var height:CGFloat = 35    //(100-30)/2
        
        if section ==  (myTableDataSource.count - 1)
        {
            height = 15
        }
        
        return height
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "aaa")
        
        let leftLabel = UILabel(text: myTableDataSource[indexPath.section][indexPath.row].2, color: TBIThemeTipTextColor, size: 13)
        cell.contentView.addSubview(leftLabel)
        leftLabel.snp.makeConstraints{(make)->Void in
            make.left.top.equalTo(15)
            make.bottom.equalTo(0)
        }
        
        let rightLabel = UILabel(text: myTableDataSource[indexPath.section][indexPath.row].3, color: TBIThemeTipTextColor, size: 13)
        cell.contentView.addSubview(rightLabel)
        rightLabel.snp.makeConstraints{(make)->Void in
            make.top.equalTo(15)
            make.right.equalTo(-15)
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
}
