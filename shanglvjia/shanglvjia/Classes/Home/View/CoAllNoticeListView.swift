//
//  CoAllNoticeListView.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/6/20.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class CoAllNoticeListView: UIView
{

    let myContentView = UIView()
    let myTableView = UITableView()
    
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
        self.addSubview(myContentView)
        myContentView.snp.makeConstraints{(make)->Void in
            make.left.right.bottom.top.equalTo(0)
        }
        
        myContentView.addSubview(myTableView)
        myTableView.snp.makeConstraints{(make)->Void in
            make.left.right.top.bottom.equalTo(0)
        }
        
        //去掉TableView的默认分割线
        myTableView.separatorStyle = .none
        // 设置 tabelView 行高,自动计算行高
        myTableView.rowHeight = UITableViewAutomaticDimension;
        // 设置预估行高 --> 先让 tableView 能滚动，在滚动的时候再去计算显示的 cell 的真正的行高，并且调整 tabelView 的滚动范围
        myTableView.estimatedRowHeight = 2
        
    }
    
    
}
