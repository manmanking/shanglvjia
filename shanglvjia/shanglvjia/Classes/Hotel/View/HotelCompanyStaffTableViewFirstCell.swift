//
//  HotelCompanyStaffTableViewFirstCell.swift
//  shop
//
//  Created by manman on 2017/5/10.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit


typealias HotelCompanyStaffUnfoldBlock = (Bool)->Void

typealias HotelCompanyStaffDeleteBlock = (NSInteger)->Void





class HotelCompanyStaffTableViewFirstCell: UITableViewCell {
    
    private let HotelCompanyStaffTableViewFirstCellButtonFoldTitle = "收起"
    private let HotelCompanyStaffTableViewFirstCellButtonUnfoldTitle = "全部"
    
    
    public  var hotelCompanyStaffUnfoldBlock:HotelCompanyStaffUnfoldBlock!
    public  var hotelCompanyStaffDeleteBlock:HotelCompanyStaffDeleteBlock!
    
    private var baseBackgroundView:UIView = UIView()
    private var staffNameLabel:UILabel = UILabel()
    //收起
    private var foldButton = UIButton()
    //删除
    private var deleteButton = UIButton()
    private var cellIndex:NSInteger!
    
    
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        baseBackgroundView.backgroundColor = UIColor.white
        self.contentView.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        setUIViewAutolayout()
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setUIViewAutolayout() {
      
        deleteButton.setImage(UIImage.init(named: "deleteRound"), for: UIControlState.normal)
        deleteButton.addTarget(self, action: #selector(deleteButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        baseBackgroundView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(40)
            make.width.height.equalTo(18)
        }
        
        staffNameLabel.text = "徐小明"
        staffNameLabel.font = UIFont.systemFont(ofSize: 16)
        staffNameLabel.textColor = TBIThemePrimaryTextColor
        baseBackgroundView.addSubview(staffNameLabel)
        staffNameLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(74)
            make.height.equalTo(16)
            make.right.equalToSuperview().inset(70)
        }
        
      
        foldButton.setTitle(HotelCompanyStaffTableViewFirstCellButtonFoldTitle, for: UIControlState.normal)
        foldButton.backgroundColor = UIColor.white
        foldButton.setTitleColor(TBIThemeBlueColor, for: UIControlState.normal)
        foldButton.addTarget(self, action: #selector(foldButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        foldButton.setEnlargeEdgeWithTop(0, left: 30, bottom: 0, right: 10)
        baseBackgroundView.addSubview(foldButton)
        foldButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(15)
            make.height.equalTo(18)
            make.width.equalTo(50)
        }
        

        let bottomLabel = UILabel()
        bottomLabel.backgroundColor = TBIThemePlaceholderTextColor
        baseBackgroundView.addSubview(bottomLabel)
        bottomLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(1)
            make.left.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        
        
        
        
    }
   
    
    func fillDataSources(traveller:Traveller,index:NSInteger,isShow:Bool)  {
        cellIndex = index
        staffNameLabel.text = traveller.name
        foldButton.isHidden = !isShow
    }
    
    func fillSVDataSource(passgenger:QueryPassagerResponse,index:NSInteger,isShow:Bool) {
        cellIndex = index
        staffNameLabel.text = passgenger.name
        foldButton.isHidden = !isShow
    }
    
    
    
    func deleteButtonAction(sender:UIButton) {
        
        
        self.hotelCompanyStaffDeleteBlock(cellIndex)
        
    }
    
    func foldButtonAction(sender:UIButton) {
        
        print(" 收起 ...")
        
        var  tmpFold:Bool = false
        
        //收起 是true
        if sender.currentTitle == HotelCompanyStaffTableViewFirstCellButtonFoldTitle {
            tmpFold = true
            sender.setTitle(HotelCompanyStaffTableViewFirstCellButtonUnfoldTitle, for: UIControlState.normal)
        }else
        {
            sender.setTitle(HotelCompanyStaffTableViewFirstCellButtonFoldTitle, for: UIControlState.normal)
        }
        
        self.hotelCompanyStaffUnfoldBlock(tmpFold)
        
    }
    

}
