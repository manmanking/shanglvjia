//
//  CoOldOrderDetailsViewXib.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/5/23.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit


class CoOldOrderDetailsViewXib:UIView
{
    
    let screenWidth:Int = Int(UIScreen.main.bounds.size.width)
    let screenHeight:Int = Int(UIScreen.main.bounds.size.height)
    
    let tableViewCell_reuseIdentifier="CoOldOrderDetailsTableCellView"
    
    /// 表格
    lazy var myTableView: UITableView = UITableView(frame: self.frame, style: .plain)
    
    var tableHeadView:CoOldOrderDetailsTableHeadView? = nil

    var tableFooterView:CoOldOrderDetailsFooterView!
    
    
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initView() -> Void
    {
        self.addSubview(myTableView)
        
        tableFooterView=Bundle.main.loadNibNamed("CoOldOrderDetailsFooterView", owner: nil, options: nil)?.first as! CoOldOrderDetailsFooterView
        
        // 设置 tabelView 行高,自动计算行高
        myTableView.rowHeight = UITableViewAutomaticDimension;
        // 设置预估行高 --> 先让 tableView 能滚动，在滚动的时候再去计算显示的 cell 的真正的行高，并且调整 tabelView 的滚动范围
        myTableView.estimatedRowHeight = 2

        
        tableHeadView = CoOldOrderDetailsTableHeadView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 100))
        myTableView.tableHeaderView = tableHeadView
        myTableView.tableFooterView = tableFooterView
    }
    
}
