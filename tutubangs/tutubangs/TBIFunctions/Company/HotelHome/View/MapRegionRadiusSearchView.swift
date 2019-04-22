//
//  MapRegionRadiusSearchView.swift
//  shanglvjia
//
//  Created by manman on 2018/4/27.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class MapRegionRadiusSearchView: UIView,UITableViewDelegate,UITableViewDataSource {

    typealias MapRegionRadiusSearchSelectedBlock = (String,String)->Void
    public var mapRegionRadiusSearchSelectedBlock:MapRegionRadiusSearchSelectedBlock!
    
    private let tableViewCellIdentify:String = "tableViewCellIdentify"
    private let tableView:UITableView = UITableView()
    private var tableViewDataSources:[(title:String,content:String)] = Array()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let baseBackgroundImageView:UIImageView = UIImageView.init(imageName: "img_hotel_bg")
//        baseBackgroundImageView.frame = CGRect.init(x: 0, y: 0, width: 95, height: 5 * 44)
        self.addSubview(baseBackgroundImageView)
        baseBackgroundImageView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        setUIViewAutolayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   private func setUIViewAutolayout() {
    
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.black
        tableView.backgroundView?.alpha = 0.6
        tableView.bounces = false
        tableView.layer.cornerRadius = 4.0
        tableView.clipsToBounds = true
        tableView.separatorColor = UIColor.white
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: tableViewCellIdentify)
        self.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.left.right.bottom.equalToSuperview()
        }
        
    }
    
   public func fillDataSources(dataSources:[(String,String)]) {
        tableViewDataSources = dataSources
        tableView.reloadData()
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewDataSources.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentify)!
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.contentView.backgroundColor = UIColor.black
        cell.contentView.alpha = 0.6
        cell.textLabel?.text = tableViewDataSources[indexPath.row].title
        cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
        cell.textLabel?.textColor = TBIThemeWhite
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if mapRegionRadiusSearchSelectedBlock != nil {
            let selectedContent:String = tableViewDataSources[indexPath.row].content
            let selectedTitle:String = tableViewDataSources[indexPath.row].title
            mapRegionRadiusSearchSelectedBlock(selectedTitle,selectedContent)
        }
        self.removeFromSuperview()
    }
    
    
    
}
