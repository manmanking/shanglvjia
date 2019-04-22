//
//  HotCityTableViewCell.swift
//  shop
//
//  Created by TBI on 2017/4/24.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

typealias HotCityBlock = (String) ->Void

class HotCityTableViewCell: UITableViewCell {

    var hotCityBlock:HotCityBlock?

    /// 懒加载 热门城市
    private var localHotCities: [Dictionary<String,String>] = {
        let path = Bundle.main.path(forResource: "hotCities.plist", ofType: nil)
        let array = NSArray(contentsOfFile: path ?? "") as? [Dictionary<String,String>]
        return array ?? []
    }()
    
     var trainHotCities:[Dictionary<String,String>] = []
    
    /// 使用tableView.dequeueReusableCell会自动调用这个方法
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.backgroundColor = TBIThemeMinorColor
        // 根据屏幕尺寸来计算
//        var buttonW:CGFloat = 75
        var buttonW:CGFloat = CGFloat((ScreenWindowWidth - 30 - 15 - 10*3) / 4)
        let n:Int = Int(ScreenWindowWidth/(75 + 10))
        if n == 3{
            buttonW = 80
        }
        if trainHotCities.count != 0 {
            // 动态创建城市btn
            for i in 0..<trainHotCities.count {
                // 列
                let column = i % n
                // 行
                let row = i / n
                
                let btn = UIButton(frame: CGRect(x: 15 + CGFloat(column) * (buttonW + 10), y: 10 + CGFloat(row) * (30 + 5), width: buttonW, height: 30))
                btn.setTitle(trainHotCities[i]["name"], for: .normal)
                btn.setTitleColor(TBIThemePrimaryTextColor, for: .normal)
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
                btn.backgroundColor = UIColor.white
//                btn.layer.borderWidth = 0.5
//                btn.layer.borderColor = TBIThemeGrayLineColor.cgColor
                btn .addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
                self.addSubview(btn)
            }
        }else {
            // 动态创建城市btn
            if localHotCities.isEmpty == true { return }
            for i in 0..<(localHotCities.count ?? 0) {
                // 列
                let column = i % n
                // 行
                let row = i / n
                
                let btn = UIButton(frame: CGRect(x: 15 + CGFloat(column) * (buttonW + 10), y: 10 + CGFloat(row) * (30 + 5), width: buttonW, height: 30))
                btn.setTitle(localHotCities[i]["name"], for: .normal)
                btn.setTitleColor(TBIThemePrimaryTextColor, for: .normal)
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
                btn.backgroundColor = UIColor.white
//                btn.layer.borderWidth = 0.5
//                btn.layer.borderColor = TBIThemeGrayLineColor.cgColor
                btn .addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
                self.addSubview(btn)
            }
        }
        
    }
    
    func setupUI(hotcitys:[Dictionary<String,String>]) {
        localHotCities = hotcitys
        self.backgroundColor = TBIThemeMinorColor
        // 根据屏幕尺寸来计算
        //        var buttonW:CGFloat = 75
        var buttonW:CGFloat = CGFloat((ScreenWindowWidth - 30 - 15 - 10*3) / 4)
        let n:Int = Int(ScreenWindowWidth/(75 + 10))
        if n == 3{
            buttonW = 80
        }
        if trainHotCities.count != 0 {
            // 动态创建城市btn
            for i in 0..<trainHotCities.count {
                // 列
                let column = i % n
                // 行
                let row = i / n
                
                let btn = UIButton(frame: CGRect(x: 15 + CGFloat(column) * (buttonW + 10), y: 10 + CGFloat(row) * (30 + 5), width: buttonW, height: 30))
                btn.setTitle(trainHotCities[i]["name"], for: .normal)
                btn.setTitleColor(TBIThemePrimaryTextColor, for: .normal)
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
                btn.backgroundColor = UIColor.white
                //                btn.layer.borderWidth = 0.5
                //                btn.layer.borderColor = TBIThemeGrayLineColor.cgColor
                btn .addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
                self.addSubview(btn)
            }
        }else {
            // 动态创建城市btn
            if localHotCities.isEmpty == true { return }
            for i in 0..<(localHotCities.count ?? 0) {
                // 列
                let column = i % n
                // 行
                let row = i / n
                
                let btn = UIButton(frame: CGRect(x: 15 + CGFloat(column) * (buttonW + 10), y: 10 + CGFloat(row) * (30 + 5), width: buttonW, height: 30))
                btn.setTitle(localHotCities[i]["name"], for: .normal)
                btn.setTitleColor(TBIThemePrimaryTextColor, for: .normal)
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
                btn.backgroundColor = UIColor.white
                //                btn.layer.borderWidth = 0.5
                //                btn.layer.borderColor = TBIThemeGrayLineColor.cgColor
                btn .addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
                self.addSubview(btn)
            }
        }
        
    }
    
    
    
    
    
    @objc private func btnClick(btn: UIButton) {
        hotCityBlock?((btn.titleLabel?.text!)!)
    }

}

class CityTableViewCell: UITableViewCell {
    
    var cityLable:UILabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 16)
    
    var line:UILabel = UILabel(color: TBIThemeGrayLineColor)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        addSubview(cityLable)
        cityLable.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(15)
        }
        addSubview(line)
        line.snp.makeConstraints { (make) in
            make.right.top.equalToSuperview()
            make.height.equalTo(0.5)
            make.left.equalTo(15)
        }
    }
    
    func fillCell(cityName:String,index:Int){
        cityLable.text = cityName
        line.isHidden = index == 0
    }
}
