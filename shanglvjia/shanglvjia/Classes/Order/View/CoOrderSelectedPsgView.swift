//
//  CoOrderSelectedPsgView.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/6/14.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

protocol SelectOrderPsgListener
{
    func selectedPsgClk(clkView:UIView,indexArray:[Int]) -> Void
    
}

class CoOrderSelectedPsgView: UIView
{
    // 添加类型
    static var addType:AddTypeEnum = .none
    
    static var isAddFlight = false
    
    var selectOrderPsgListener:SelectOrderPsgListener!
    
    var cellsIsCheckedArray:[Bool] = []
    var psgNameArray:[(name:String,email:String)] = []   //姓名，邮箱📮
    
    var bgView:UIView!
    
    var myContentView:UIView!
    var myTableView:UITableView! = nil
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        //initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() -> Void
    {
        //测试时使用
        //psgNameArray = ["aaa","bbb","ccc","ddd","eee"]
        
        cellsIsCheckedArray = []
        for _ in psgNameArray
        {
            cellsIsCheckedArray.append(false)
        }
        
        bgView = UIView()
        bgView.backgroundColor = TBIThemeBackgroundViewColor
        bgView.addOnClickListener(target: self, action: #selector(cancelButtonAction))
        self.addSubview(bgView)
        bgView.snp.makeConstraints{(make)->Void in
            make.left.right.top.bottom.equalTo(0)
        }
        
        myContentView = UIView()
        self.addSubview(myContentView)
        myContentView.layer.cornerRadius = 6
        myContentView.layer.masksToBounds = true
        myContentView.snp.makeConstraints{(make)->Void in
            make.left.equalTo(14)
            make.right.equalTo(-14)
            make.center.equalToSuperview()
            make.height.equalTo(274)
        }
        
        myTableView = UITableView()
        myTableView.dataSource = self
        myTableView.delegate = self
        //去掉TableView的默认分割线
        myTableView.separatorStyle = .none
        // 设置 tabelView 行高,自动计算行高
        myTableView.rowHeight = UITableViewAutomaticDimension;
        myTableView.estimatedRowHeight = 50
        //myTableView.rowHeight = 130
        
        myTableView.backgroundColor = .white
        myContentView.addSubview(myTableView)
        myTableView.snp.makeConstraints{(make)->Void in
            make.left.right.top.equalTo(0)
            make.height.equalTo(214)
        }
        
        let myBottomButton = UIButton(title: "下一步", titleColor: .white, titleSize: 18)
        myBottomButton.backgroundColor = TBIThemeBlueColor
        myContentView.addSubview(myBottomButton)
        myBottomButton.snp.makeConstraints{(make)->Void in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(60)
        }
        
        myBottomButton.addOnClickListener(target: self, action: #selector(nextStepClk(clkView:)))
        
    }
    
    func nextStepClk(clkView:UIView) -> Void
    {
        cancelButtonAction()
        
        var indexArray:[Int] = []
        for i in 0..<cellsIsCheckedArray.count
        {
            let flag = cellsIsCheckedArray[i]
            if flag == true
            {
                indexArray.append(i)
            }
        }
        
        if selectOrderPsgListener != nil
        {
            selectOrderPsgListener.selectedPsgClk(clkView: clkView, indexArray: indexArray)
        }
        
        print("\(indexArray)")
    }
    
    
    func cancelButtonAction() {
        self.removeFromSuperview()
    }
    
}

extension CoOrderSelectedPsgView:UITableViewDataSource,UITableViewDelegate
{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return self.psgNameArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let myCell = CoOrderSelectedPsgCell(style: .default, reuseIdentifier: "")
        
        myCell.topTitleLabel.text = self.psgNameArray[indexPath.row].name
        myCell.subTitleLabel.text = self.psgNameArray[indexPath.row].email
        if cellsIsCheckedArray[indexPath.row] == true     //勾选上了
        {
            //myCell.rightCheckImgView.backgroundColor = .green
            myCell.rightCheckImgView.image = UIImage(named: "ic_select")
        }
        else      //未勾选上
        {
            //myCell.rightCheckImgView.backgroundColor = .red
            myCell.rightCheckImgView.image = UIImage(named: "ic_no_select")
        }
        
        
        return myCell
    }
    
    //选中
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.myTableView.deselectRow(at: indexPath, animated: true)
        
        cellsIsCheckedArray[indexPath.row] = (!cellsIsCheckedArray[indexPath.row])
        self.myTableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    
}

/// 订单详情添加类型
///
/// - flight: 机票
/// - hotel: 酒店
/// - train: 火车
/// - car: 专车
enum AddTypeEnum:Int {
    case flight = 1
    case hotel = 2
    case train  = 3
    case car = 4
    case none = 0
}



