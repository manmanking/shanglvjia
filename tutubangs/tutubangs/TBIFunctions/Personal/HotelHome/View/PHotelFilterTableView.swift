//
//  PHotelFilterTableView.swift
//  shanglvjia
//
//  Created by tbi on 2018/8/2.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PHotelFilterTableView: UIView,UITableViewDelegate,UITableViewDataSource{

    ///
    typealias PHotelFilterTableViewDismissBlock = ()->Void
    public var photelFilterTableViewDismissBlock:PHotelFilterTableViewDismissBlock!
    
    ///选择后
    typealias PHotelFilterTableViewSelectedBlock = (NSInteger) -> Void
    public var photelFilterTableViewSelectedBlock:PHotelFilterTableViewSelectedBlock!
    
    ///重置 确定
    typealias ResetOrSureButtonBlock = (String)->Void
    public var resetOrSureButtonBlock:ResetOrSureButtonBlock!
    
    private var baseBackgroundView:UIView = UIView()
    
    private var listTableView:UITableView = UITableView()
    private var dataArr:[(title:String,content:String)] = Array()
    private var selectRow:NSInteger = 0
    fileprivate let hotelFilterCellIdentify:String = "hotelFilterCellIdentify"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = TBIThemeBackgroundViewColor
        self.addSubview(baseBackgroundView)
        //baseBackgroundView.addOnClickListener(target: self, action: #selector(dismissSelfView))
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        setUIViewAutolayout()
    }
    
    private func setUIViewAutolayout() {
        
        listTableView.rowHeight = 44
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.bounces = false
        listTableView.separatorColor = UIColor.clear
        listTableView.backgroundColor = UIColor.red
        listTableView.register(PHotelFilterCell.self, forCellReuseIdentifier: hotelFilterCellIdentify)
        baseBackgroundView.addSubview(listTableView)
        listTableView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(100)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func fillDataSources(dataArray:[(title:String,content:String)],selectIndex:NSInteger)  {
        dataArr = dataArray
        selectRow = selectIndex
        listTableView.snp.remakeConstraints { (update) in
            update.left.top.right.equalToSuperview()
            update.height.equalTo(44*dataArray.count)
        }
        listTableView.reloadData()
    }
    
    
    //MARK:----------UITableViewDataSource-------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PHotelFilterCell = tableView.dequeueReusableCell(withIdentifier: hotelFilterCellIdentify) as! PHotelFilterCell
        cell.titleLabel.text = dataArr[indexPath.row].title
        if indexPath.row == selectRow{
            cell.titleLabel.textColor = PersonalThemeDarkColor
            cell.rightButton.isHidden = false
        }else{
            cell.titleLabel.textColor = PersonalThemeMinorTextColor
            cell.rightButton.isHidden = true
        }
        if dataArr.first?.title == "推荐排序"{
            if indexPath.row == 3{
                CommonTool.removeSubviews(onBgview: cell)
                for i in 0...1{
                    let button:UIButton = UIButton.init(title: i == 0 ? "重置" : "确定", titleColor: i == 0 ? PersonalThemeMajorTextColor : TBIThemeWhite, titleSize: 14)
                    button.frame = CGRect(x:CGFloat(i)*ScreenWindowWidth/2,y:0,width:ScreenWindowWidth/2,height:44)
                    if i == 1{
                        button.setBackgroundImage(UIImage(named:"yellow_btn_gradient"), for: .normal)
                    }
                    button.addTarget(self, action: #selector(resetOrSureClick(sender:)), for: .touchUpInside)
                    cell.addSubview(button)
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dataArr.first?.title != "推荐排序"{
            //self.isHidden = true
            if photelFilterTableViewSelectedBlock != nil{
                photelFilterTableViewSelectedBlock(indexPath.row)
            }
            dismissSelfView()
        }else{
            if photelFilterTableViewSelectedBlock != nil{
                photelFilterTableViewSelectedBlock(indexPath.row)
            }
        }
    }
    
    
    /// 清除 页面
    public func dismissSelfView() {
        self.isHidden = true
        if photelFilterTableViewDismissBlock != nil {
            photelFilterTableViewDismissBlock()
        }
    }
    
    func resetOrSureClick(sender:UIButton){
        if resetOrSureButtonBlock != nil{
            resetOrSureButtonBlock((sender.titleLabel?.text)!)
        }
        dismissSelfView()
    }
    
    
}
