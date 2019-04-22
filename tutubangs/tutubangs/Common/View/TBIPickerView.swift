//
//  TBIPickerView.swift
//  shop
//
//  Created by manman on 2017/5/9.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit



typealias PickerViewSelectedRow = (NSInteger,String)->Void

class TBIPickerView: UIView,UIPickerViewDelegate,UIPickerViewDataSource {

    private var baseBackgroundView:UIView = UIView()
    private var subBaseBackgroundView:UIView = UIView()
    private var titleBackgroundView:UIView = UIView()
    private let pickerView:UIPickerView = UIPickerView()
    private var cancelButton:UIButton =  UIButton(title: "取消", titleColor: .white, titleSize: 16)
    private var okayButton:UIButton =  UIButton(title: "确定", titleColor: .white, titleSize: 16)
    private var selectedIndex:NSInteger = 0
    
    private var pickerViewDatasources:[String] = Array()
    public  var pickerViewSelectedRow:PickerViewSelectedRow!
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //背景
        baseBackgroundView.backgroundColor = TBIThemeBackgroundViewColor
        baseBackgroundView.addOnClickListener(target: self, action: #selector(cancelButtonAction))
        self.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        //子背景
        subBaseBackgroundView.backgroundColor = TBIThemeBaseColor
        self.addSubview(subBaseBackgroundView)
        subBaseBackgroundView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(225)
        }
        
        
        setUIViewAutolayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUIViewAutolayout() {
        
        titleBackgroundView.backgroundColor = TBIThemeLinkColor
        subBaseBackgroundView.addSubview(titleBackgroundView)
        titleBackgroundView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(50)
            
        }
        
//        cancelButton.setTitle("取消", for: UIControlState.normal)
//        cancelButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        cancelButton.backgroundColor = TBIThemeLinkColor
        cancelButton.addTarget(self, action: #selector(cancelButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        titleBackgroundView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(15)
            make.height.equalTo(50)
            //make.width.equalTo(80)
        }
        cancelButton.setEnlargeEdgeWithTop(0 ,left: 40, bottom: 0, right: 40)
        
//        okayButton.setTitle("确定", for: UIControlState.normal)
//        okayButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        okayButton.backgroundColor = TBIThemeLinkColor
        okayButton.addTarget(self, action: #selector(okayButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        titleBackgroundView.addSubview(okayButton)
        okayButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(15)
            make.height.equalTo(50)
            //make.width.equalTo(80)
        }
        okayButton.setEnlargeEdgeWithTop(0 ,left: 40, bottom: 0, right: 40)
        
        pickerView.dataSource = self
        pickerView.delegate = self
        subBaseBackgroundView.addSubview(pickerView)
        pickerView.snp.makeConstraints { (make) in
            make.top.equalTo(titleBackgroundView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        pickerView.reloadAllComponents()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewDatasources.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return pickerViewDatasources[row]
    }
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat{
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        pickerView.subviews[1].backgroundColor = TBIThemeGrayLineColor
        pickerView.subviews[2].backgroundColor = TBIThemeGrayLineColor
        var contentLable:UILabel?
        
        if view == nil {
            
            contentLable = UILabel.init()
            //contentLable?.backgroundColor = UIColor.clear
            contentLable?.textAlignment = NSTextAlignment.center
            contentLable?.font = UIFont.systemFont(ofSize: 18)
            
            
        }else
        {
            contentLable = view as? UILabel
        }
        
        contentLable?.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        return contentLable!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedIndex = row
        print(row)
    }
    
    
    func fillDataSources(dataSourcesArr:Array<String>) {
        pickerViewDatasources = dataSourcesArr
        pickerView.reloadAllComponents()
    }
    
    func cancelButtonAction(sender:UIButton) {
        self.removeFromSuperview()
    }
    
    func okayButtonAction(sender:UIButton) {
        
        self.pickerViewSelectedRow(selectedIndex,pickerViewDatasources[selectedIndex])
        let tmpButton = UIButton()
        
        cancelButtonAction(sender: tmpButton)
        
    }
    
    
    
    
}
