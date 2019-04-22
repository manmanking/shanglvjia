//
//  PriceInfoTableView.swift
//  shanglvjia
//
//  Created by tbi on 2018/5/18.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PriceInfoTableView: UIView{

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var arr = NSMutableArray()
    var orderModel = OrderDetailModel()
    var odType = String()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initViewWithArray(model:OrderDetailModel,orderType:String,dataArray:NSMutableArray)  {
        self.backgroundColor=TBIThemeWhite
        arr=dataArray
        orderModel=model
        odType=orderType
        print(arr.count,orderType)
        
        let tableView = UITableView()
        tableView.separatorStyle=UITableViewCellSeparatorStyle.none
        tableView.bounces=false
        tableView.dataSource=self
        tableView.delegate=self
        tableView.register(PriceInfoCell.self, forCellReuseIdentifier: "PriceInfoCell")
        self.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.height.equalTo(arr.count>10 ? 350:(35 * arr.count))
            make.bottom.equalTo(-6)
        }
    }
}
extension PriceInfoTableView:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PriceInfoCell = tableView.dequeueReusableCell(withIdentifier: "PriceInfoCell") as! PriceInfoCell
            let model = (arr[indexPath.row] as! OrderDetailModel)
            if(odType == "2")  {
                cell.nameLabel.text=CommonTool.stamp(to: model.date, withFormat: "MM-dd")  + "      " +  orderModel.meal
            }else{
                cell.nameLabel.text=model.date
            }
            cell.priceLabel.text="¥" + model.memberRate
            cell.personLabel.text = model.pnr
        return cell
    }
}

