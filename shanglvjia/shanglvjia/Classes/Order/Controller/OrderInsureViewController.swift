//
//  OrderInsureViewController.swift
//  shanglvjia
//
//  Created by tbi on 2018/5/15.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class OrderInsureViewController: CompanyBaseViewController {
    
    //保险
    var suransModel : OrderDetailModel.passenger.surance?
    //基本信息
    var oneRow = [["title":"基本信息","content":"xxx"]]
    var detailTable = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=TBIThemeBaseColor
        
        oneRow.removeAll()
        oneRow.append( ["title":"产品名称","content":(suransModel?.suranceName)!])
        oneRow.append( ["title":"保险单号","content":(suransModel?.suranceNo)!])
        oneRow.append( ["title":"被保险人","content":(suransModel?.cusName)!])
        oneRow.append( ["title":"保险时效","content":(suransModel?.suranceStart)! + "至" + (suransModel?.suranceEnd)!])
        oneRow.append( ["title":"保险状态","content":(suransModel?.suranceStatusCH)!])
        oneRow.append( ["title":"保费","content":(suransModel?.price)! + "元"])
        
        initTableView()
        setNavigationImage()
        setTitleView()
        // Do any additional setup after loading the view.
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setNavigationImage() {
        self.navigationController?.navigationBar.isTranslucent = false

    }
    func setTitleView() {
        setBlackTitleAndNavigationColor(title:"保险方案")
        /// 新版订单更新
        setNavigationBackButton(backImage: "left")
    }
    override func backButtonAction(sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func initTableView() {
        detailTable.frame=CGRect(x:0,y:1,width:Int(ScreenWindowWidth),height:Int(ScreentWindowHeight)-kNavigationHeight)
        detailTable.separatorStyle=UITableViewCellSeparatorStyle.none
        detailTable.estimatedRowHeight=20
        detailTable.rowHeight=UITableViewAutomaticDimension
        detailTable.delegate=self
        detailTable.dataSource=self
        detailTable.backgroundColor=TBIThemeBaseColor
        detailTable.register(OrderInsureCell.self, forCellReuseIdentifier: "OrderInsureCell")
        self.view.addSubview(detailTable)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension OrderInsureViewController : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return oneRow.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:OrderInsureCell  = tableView.dequeueReusableCell(withIdentifier: "OrderInsureCell") as! OrderInsureCell
        cell.setCell(leftStr: oneRow[indexPath.row]["title"]!, rightStr: oneRow[indexPath.row]["content"]!)
        return cell
    }
}
