//
//  HistoryCityTableViewCell.swift
//  shanglvjia
//
//  Created by manman on 2018/6/26.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class HistoryCityTableViewCell: UITableViewCell {

    typealias HistoryCityTableViewCellSelectedHistoryCityBlock = (HotelCityModel)->Void
    
    public var historyCityTableViewCellSelectedHistoryCityBlock:HistoryCityTableViewCellSelectedHistoryCityBlock!
    
    private var localHistoryCityButtonArr:[UIButton] = Array()
    
    private var localHistoryCity:[HotelCityModel] = Array()
    
    
    private var baseBackgroundView:UIView = UIView()
    
    

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = TBIThemeBaseColor
        self.contentView.addSubview(baseBackgroundView)
        self.selectionStyle = UITableViewCellSelectionStyle.none
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        baseBackgroundView.backgroundColor = TBIThemeBaseColor
        
        
        setUIViewAutolayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUIViewAutolayout() {
        
    }
    
    
    
    
    func fillDataSources(historyCityArr:[HotelCityModel]) {
        
        guard historyCityArr.count > 0 else {
            return
        }
        for element in localHistoryCityButtonArr {
            element.removeTarget(nil, action:nil , for: UIControlEvents.touchUpInside)
        }
        localHistoryCityButtonArr.removeAll()
        localHistoryCity.removeAll()
        for element in baseBackgroundView.subviews {
            element.removeFromSuperview()
        }
        localHistoryCity = historyCityArr
        let buttonWidth:Float = Float((ScreenWindowWidth - 30 - 15 - 10*3) / 4)
        for (index,element) in localHistoryCity.enumerated() {
            
            let tmpButton:UIButton = UIButton()
            tmpButton.setTitle(element.cnName , for: UIControlState.normal)
            tmpButton.setTitleColor(TBIThemePrimaryTextColor, for: UIControlState.normal)
            tmpButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            //tmpButton.titleLabel?.textColor =
            tmpButton.backgroundColor = TBIThemeWhite
            //button.layer.cornerRadius = 2
            tmpButton.addTarget(self, action: #selector(historyCityAction(sender:)), for: UIControlEvents.touchUpInside)
            //            createButtonLayout(button: tmpButton)
            baseBackgroundView.addSubview(tmpButton)
            tmpButton.snp.makeConstraints { (make) in
                make.left.equalToSuperview().inset( 15 + Float(index) * buttonWidth + 10*Float(index))
                make.width.equalTo(buttonWidth)
                make.height.equalTo(30)
                make.centerY.equalToSuperview()
            }
            localHistoryCityButtonArr.append(tmpButton)
        }
        
        
        
    }
    
    
    
    func createButtonLayout(button:UIButton) {
        
      
        
        
    }
    
    func historyCityAction(sender:UIButton) {
        var selectedHistoryCity:HotelCityModel = HotelCityModel()
        for element in localHistoryCity {
            if element.cnName ==  sender.titleLabel?.text {
                selectedHistoryCity = element
            }
        }
        if historyCityTableViewCellSelectedHistoryCityBlock != nil {
            historyCityTableViewCellSelectedHistoryCityBlock(selectedHistoryCity)
        }
        
        
        
    }
    
    
    
    
    

}
