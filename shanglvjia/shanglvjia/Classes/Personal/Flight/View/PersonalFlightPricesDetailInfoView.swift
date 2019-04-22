//
//  PersonalFlightPricesDetailInfoView.swift
//  shanglvjia
//
//  Created by manman on 2018/8/8.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class PersonalFlightPricesDetailInfoView: UIView,UITableViewDelegate,UITableViewDataSource {

    let totalPriceLabel = UILabel(text: "", color: TBIThemePrimaryWarningColor, size: 20)
    
    let priceButton = UIButton()
    
    let backBlackView = UIView()
    let priceTitleLabel = UILabel(text: "费用明细", color: TBIThemePrimaryTextColor, size: 16)
    let priceLine = UILabel(color: TBIThemeGrayLineColor)
    let whiteView:UIView = UIView()
    let submitButton:UIButton = UIButton(title: "下一步",titleColor: TBIThemeWhite,titleSize: 20)
    
    lazy var leftView:UIView = {
        let vi = UIView()
        vi.backgroundColor = TBIThemeWhite
        let line = UILabel(color: TBIThemeGrayLineColor)
        let titleLabel = UILabel(text: "总价", color: TBIThemePrimaryTextColor, size: 13)
        let yLabel = UILabel(text: "¥", color: TBIThemePrimaryWarningColor, size: 13)
        vi.addSubview(line)
        vi.addSubview(titleLabel)
        vi.addSubview(self.totalPriceLabel)
        vi.addSubview(yLabel)
        line.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalTo(0)
            make.height.equalTo(0.5)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
        self.totalPriceLabel.text = "0"
        self.totalPriceLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-44)
            make.centerY.equalToSuperview()
        }
        yLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.totalPriceLabel.snp.bottom).offset(-3)
            make.right.equalTo(self.totalPriceLabel.snp.left)
        }
        return vi
    }()
    var arr:[(priceTitle:String,price:String)] = Array()
    let tableView = UITableView()


    override init(frame: CGRect) {
        super.init(frame: frame)
       initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView(){
        
        backBlackView.backgroundColor = TBIThemeBackgroundViewColor
        backBlackView.isHidden = true
        addSubview(backBlackView)
//        totalPriceLabel.font = UIFont.boldSystemFont(ofSize: 20)
//        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
//        addSubview(leftView)
//        addSubview(submitButton)
//        addSubview(priceButton)
//        priceButton.setImage(UIImage(named: "ic_up_gray"), for: UIControlState.normal)
//        priceButton.setImage(UIImage(named: "ic_down_gray"), for: UIControlState.selected)
//        submitButton.setBackgroundImage(UIImage (named: "yellow_btn_gradient"), for: UIControlState.normal)
//
//        priceButton.setEnlargeEdgeWithTop(20 ,left: 400, bottom: 20, right: 0)
//        leftView.snp.makeConstraints { (make) in
//            make.left.equalToSuperview()
//            make.height.equalToSuperview()
//            make.bottom.equalToSuperview()
//            make.width.equalToSuperview().dividedBy(2)
//        }
//        submitButton.snp.makeConstraints { (make) in
//            make.right.equalToSuperview()
//            make.height.equalToSuperview()
//            make.bottom.equalToSuperview()
//            make.width.equalToSuperview().dividedBy(2)
//        }
//        priceButton.snp.makeConstraints { (make) in
//            make.right.equalTo(submitButton.snp.left).offset(-15)
//            make.centerY.equalToSuperview()
//        }
        
        ///明细
        backBlackView.addSubview(whiteView)
        whiteView.addSubview(priceTitleLabel)
        whiteView.addSubview(priceLine)
        
        priceTitleLabel.layer.cornerRadius = 15
        priceTitleLabel.clipsToBounds = true
        priceTitleLabel.textAlignment = .center
        priceTitleLabel.backgroundColor = TBIThemeWhite
        
        priceLine.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(0.5)
            make.top.equalTo(priceTitleLabel.snp.bottom)
        }
        whiteView.backgroundColor = TBIThemeWhite
        
        
        tableView.separatorStyle=UITableViewCellSeparatorStyle.none
        tableView.bounces=false
        tableView.dataSource=self
        tableView.delegate=self
        tableView.register(PriceInfoCell.self, forCellReuseIdentifier: "PriceInfoCell")
        backBlackView.addSubview(tableView)
        
    }
    
    
    
//    func fillDataSources(pricesDetail:[(title:String,content:String)]) {
//        pricesDetailLocal = pricesDetail
//        pricesDetailBaseBackgroundView.snp.remakeConstraints { (make) in
//            make.left.right.equalToSuperview()
//            make.bottom.equalToSuperview()
//            make.height.equalTo((pricesDetailLocal.count + 1) * 44)
//        }
//        priceDetailTableView.reloadData()
//    }
    func fillDataSources(pricesDetail:[(priceTitle:String,price:String)]) {
        arr = pricesDetail
        tableView.reloadData()
        let height =  Int((arr.count>10 ? 250:(25 * arr.count))+34)
        whiteView.frame = CGRect(x:0,y:(Int(ScreentWindowHeight) - height - 54),width:Int(ScreenWindowWidth),height:height)
        priceTitleLabel.frame = CGRect(x:0,y:-22,width:Int(ScreenWindowWidth),height:44)
        tableView.frame = CGRect(x:0,y:Int(whiteView.frame.origin.y) + 28,width:Int(ScreenWindowWidth),height:Int(arr.count>10 ? 250:(25 * arr.count)))
    }
   
    
    
    //MARK:------UITableViewDataSources-----
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:PriceInfoCell = tableView.dequeueReusableCell(withIdentifier: "PriceInfoCell") as! PriceInfoCell
        cell.priceLabel.text =  arr[indexPath.row].priceTitle
        cell.nameLabel.text = arr[indexPath.row].price
        return cell
    }
   
    
    
    
    
    
    
    
    
}
