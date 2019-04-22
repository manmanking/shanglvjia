//
//  ReserveRoomCustomRequireViewController.swift
//  shop
//
//  Created by manman on 2017/5/9.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit




class ReserveRoomCustomRequireViewController: CompanyBaseViewController{

    
    typealias ReserveRoomCustomRequireResultBlock = (String,String,[UIButton])->Void
    public var reserveRoomCustomRequireResultBlock:ReserveRoomCustomRequireResultBlock!
    public var selectedCustomRequire:[UIButton] = Array()
    
    private let reserveRoomCustomRequireTableViewCellIdentify = "ReserveRoomCustomRequireTableViewCellIdentify"
    private var baseBackgroundView = UIView()
    private var dataSources:[[(title:String,content:String)]] = Array()
    private var selectedBedStyleButton = UIButton()
    private var okayButton = UIButton()
    private var secondBedStyleButton = UIButton()
    private var firstBedStyleButton = UIButton()
    private var firstRequiredRoomStyleButton = UIButton()
    private var secondRequiredRoomStyleButton = UIButton()
    private var firstRequiredFloorStyleButton = UIButton()
    private var secondRequiredFloorStyleButton = UIButton()
    private var firstRequiredCharacteristicStyleButton = UIButton()
    private var secondRequiredCharacteristicStyleButton = UIButton()
    private var requiredButtonArr:[UIButton] = Array()
    private let buttonLocalHeight:NSInteger = 32
    private let buttonLocalWidth:Int = Int(ScreenWindowWidth * 0.416)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setBlackTitleAndNavigationColor(title: "特殊要求")
        let customRequire:[(title:String,content:String)] = [("特殊要求:您的需求会尽量转达给酒店。","")]
        let firstRowArr:[(title:String,content:String)] = [("床型(单选)",""),("大床","0"),("双床","0")]
        let secondRowArr:[(title:String,content:String)] = [("房间",""),("有窗","0"),("无烟","0")]
        let thirdRowArr:[(title:String,content:String)] = [("楼层",""),("同层","0"),("高层","0")]
        let forthRowArr:[(title:String,content:String)] = [("特点",""),("相邻",""),("安静房间","0")]
        let fifthRequire:[(title:String,content:String)] = [("确定","")]
        dataSources.append(customRequire)
        dataSources.append(firstRowArr)
        dataSources.append(secondRowArr)
        dataSources.append(thirdRowArr)
        dataSources.append(forthRowArr)
        dataSources.append(fifthRequire)
        
        requiredButtonArr = [firstRequiredRoomStyleButton,secondRequiredRoomStyleButton,firstRequiredFloorStyleButton,secondRequiredFloorStyleButton,firstRequiredCharacteristicStyleButton,secondRequiredCharacteristicStyleButton]
        
        baseBackgroundView.backgroundColor = UIColor.white
        self.view.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        
        customUIViewAutolayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
    
    
    
    func customUIViewAutolayout() {
        
        let requiredLabel = UILabel()
        requiredLabel.text = dataSources[0].first?.title
        requiredLabel.textColor = TBIThemeOrangeColor
        requiredLabel.font = UIFont.systemFont( ofSize: 12)
        baseBackgroundView.addSubview(requiredLabel)
        requiredLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()//.inset(20 + 44)
            make.left.equalToSuperview().inset(15)
            make.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        
        let firstLineLabel = UILabel()
        firstLineLabel.backgroundColor = TBIThemeGrayLineColor
        baseBackgroundView.addSubview(firstLineLabel)
        firstLineLabel.snp.makeConstraints { (make) in
            make.top.equalTo(requiredLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        
        //床型
        let requiredBedStyleLabel = UILabel()
        requiredBedStyleLabel.text = dataSources[1].first?.title
        requiredBedStyleLabel.textAlignment = NSTextAlignment.left
        requiredBedStyleLabel.textColor = TBIThemePrimaryTextColor
        requiredBedStyleLabel.font = UIFont.systemFont( ofSize: 12)
        baseBackgroundView.addSubview(requiredBedStyleLabel)
        requiredBedStyleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(requiredLabel.snp.bottom).offset(15)
            make.left.equalToSuperview().inset(15)
            make.right.equalToSuperview()
            make.height.equalTo(15)
        }
        
        
        firstBedStyleButton.layer.cornerRadius = 5
        firstBedStyleButton.layer.borderWidth = 1
        firstBedStyleButton.layer.borderColor = TBIThemeBlueColor.cgColor
        firstBedStyleButton.setTitle(dataSources[1][1].title, for: UIControlState.normal)
        firstBedStyleButton.setTitleColor(TBIThemeBlueColor, for: UIControlState.normal)
        firstBedStyleButton.setTitleColor(UIColor.white, for: UIControlState.selected)
        firstBedStyleButton.addTarget(self, action: #selector(firstBedStyleButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        firstBedStyleButton.backgroundColor = UIColor.white
        baseBackgroundView.addSubview(firstBedStyleButton)
        firstBedStyleButton.snp.makeConstraints { (make) in
            
            make.top.equalTo(requiredBedStyleLabel.snp.bottom).offset(15)
            make.left.equalToSuperview().inset(15)
            make.width.equalTo(buttonLocalWidth)
            make.height.equalTo(buttonLocalHeight)
            
        }
        
        
        secondBedStyleButton.layer.cornerRadius = 5
        secondBedStyleButton.layer.borderWidth = 1
        secondBedStyleButton.layer.borderColor = TBIThemeBlueColor.cgColor
        secondBedStyleButton.setTitle(dataSources[1][2].title, for: UIControlState.normal)
        secondBedStyleButton.setTitleColor(TBIThemeBlueColor, for: UIControlState.normal)
        secondBedStyleButton.setTitleColor(UIColor.white, for: UIControlState.selected)
        secondBedStyleButton.addTarget(self, action: #selector(secondBedStyleButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        secondBedStyleButton.backgroundColor = UIColor.white
        baseBackgroundView.addSubview(secondBedStyleButton)
        secondBedStyleButton.snp.makeConstraints { (make) in
            
            make.top.equalTo(requiredBedStyleLabel.snp.bottom).offset(15)
            make.right.equalToSuperview().inset(15)
            make.width.equalTo(buttonLocalWidth)
            make.height.equalTo(buttonLocalHeight)
            
        }
        
        // 房间
        let requiredRoomStyleLabel = UILabel()
        requiredRoomStyleLabel.text = dataSources[2].first?.title
        requiredRoomStyleLabel.textAlignment = NSTextAlignment.left
        requiredRoomStyleLabel.textColor = TBIThemePrimaryTextColor
        requiredRoomStyleLabel.font = UIFont.systemFont( ofSize: 12)
        baseBackgroundView.addSubview(requiredRoomStyleLabel)
        requiredRoomStyleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(firstBedStyleButton.snp.bottom).offset(15)
            make.left.equalToSuperview().inset(15)
            make.right.equalToSuperview()
            make.height.equalTo(15)
        }
        
        
        firstRequiredRoomStyleButton.layer.cornerRadius = 5
        firstRequiredRoomStyleButton.layer.borderWidth = 1
        firstRequiredRoomStyleButton.layer.borderColor = TBIThemeBlueColor.cgColor
        firstRequiredRoomStyleButton.setTitle(dataSources[2][1].title, for: UIControlState.normal)
        firstRequiredRoomStyleButton.setTitleColor(TBIThemeBlueColor, for: UIControlState.normal)
        firstRequiredRoomStyleButton.setTitleColor(UIColor.white, for: UIControlState.selected)
        firstRequiredRoomStyleButton.addTarget(self, action: #selector(requireButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        firstRequiredRoomStyleButton.backgroundColor = UIColor.white
        baseBackgroundView.addSubview(firstRequiredRoomStyleButton)
        firstRequiredRoomStyleButton.snp.makeConstraints { (make) in
            
            make.top.equalTo(requiredRoomStyleLabel.snp.bottom).offset(15)
            make.left.equalToSuperview().inset(15)
            make.width.equalTo(buttonLocalWidth)
            make.height.equalTo(buttonLocalHeight)
            
        }
        
        
        secondRequiredRoomStyleButton.layer.cornerRadius = 5
        secondRequiredRoomStyleButton.layer.borderWidth = 1
        secondRequiredRoomStyleButton.layer.borderColor = TBIThemeBlueColor.cgColor
        secondRequiredRoomStyleButton.setTitle(dataSources[2][2].title, for: UIControlState.normal)
        secondRequiredRoomStyleButton.setTitleColor(TBIThemeBlueColor, for: UIControlState.normal)
        secondRequiredRoomStyleButton.setTitleColor(UIColor.white, for: UIControlState.selected)
        secondRequiredRoomStyleButton.addTarget(self, action: #selector(requireButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        secondRequiredRoomStyleButton.backgroundColor = UIColor.white
        baseBackgroundView.addSubview(secondRequiredRoomStyleButton)
        secondRequiredRoomStyleButton.snp.makeConstraints { (make) in
            
            make.top.equalTo(requiredRoomStyleLabel.snp.bottom).offset(15)
            make.right.equalToSuperview().inset(15)
            make.width.equalTo(buttonLocalWidth)
            make.height.equalTo(buttonLocalHeight)
            
        }
        
        // 楼层
        let requiredFloorStyleLabel = UILabel()
        requiredFloorStyleLabel.text = dataSources[3].first?.title
        requiredFloorStyleLabel.textAlignment = NSTextAlignment.left
        requiredFloorStyleLabel.textColor = TBIThemePrimaryTextColor
        requiredFloorStyleLabel.font = UIFont.systemFont( ofSize: 12)
        baseBackgroundView.addSubview(requiredFloorStyleLabel)
        requiredFloorStyleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(firstRequiredRoomStyleButton.snp.bottom).offset(15)
            make.left.equalToSuperview().inset(15)
            make.right.equalToSuperview()
            make.height.equalTo(15)
        }
        
        
        firstRequiredFloorStyleButton.layer.cornerRadius = 5
        firstRequiredFloorStyleButton.layer.borderWidth = 1
        firstRequiredFloorStyleButton.layer.borderColor = TBIThemeBlueColor.cgColor
        firstRequiredFloorStyleButton.setTitle(dataSources[3][1].title, for: UIControlState.normal)
        firstRequiredFloorStyleButton.setTitleColor(TBIThemeBlueColor, for: UIControlState.normal)
        firstRequiredFloorStyleButton.setTitleColor(UIColor.white, for: UIControlState.selected)
        firstRequiredFloorStyleButton.addTarget(self, action: #selector(requireButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        firstRequiredFloorStyleButton.backgroundColor = UIColor.white
        baseBackgroundView.addSubview(firstRequiredFloorStyleButton)
        firstRequiredFloorStyleButton.snp.makeConstraints { (make) in
            
            make.top.equalTo(requiredFloorStyleLabel.snp.bottom).offset(15)
            make.left.equalToSuperview().inset(15)
            make.width.equalTo(buttonLocalWidth)
            make.height.equalTo(buttonLocalHeight)
            
        }
        
        
        secondRequiredFloorStyleButton.layer.cornerRadius = 5
        secondRequiredFloorStyleButton.layer.borderWidth = 1
        secondRequiredFloorStyleButton.layer.borderColor = TBIThemeBlueColor.cgColor
        secondRequiredFloorStyleButton.setTitle(dataSources[3][2].title, for: UIControlState.normal)
        secondRequiredFloorStyleButton.setTitleColor(TBIThemeBlueColor, for: UIControlState.normal)
        secondRequiredFloorStyleButton.setTitleColor(UIColor.white, for: UIControlState.selected)
        
        secondRequiredFloorStyleButton.addTarget(self, action: #selector(requireButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        secondRequiredFloorStyleButton.backgroundColor = UIColor.white
        baseBackgroundView.addSubview(secondRequiredFloorStyleButton)
        secondRequiredFloorStyleButton.snp.makeConstraints { (make) in
            
            make.top.equalTo(requiredFloorStyleLabel.snp.bottom).offset(15)
            make.right.equalToSuperview().inset(15)
            make.width.equalTo(buttonLocalWidth)
            make.height.equalTo(buttonLocalHeight)
            
        }
        
        // 特点
        let requiredCharacteristicStyleLabel = UILabel()
        requiredCharacteristicStyleLabel.text = dataSources[4].first?.title
        requiredCharacteristicStyleLabel.textAlignment = NSTextAlignment.left
        requiredCharacteristicStyleLabel.textColor = TBIThemePrimaryTextColor
        requiredCharacteristicStyleLabel.font = UIFont.systemFont( ofSize: 12)
        baseBackgroundView.addSubview(requiredCharacteristicStyleLabel)
        requiredCharacteristicStyleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(firstRequiredFloorStyleButton.snp.bottom).offset(15)
            make.left.equalToSuperview().inset(15)
            make.right.equalToSuperview()
            make.height.equalTo(15)
        }
        
        
        firstRequiredCharacteristicStyleButton.layer.cornerRadius = 5
        firstRequiredCharacteristicStyleButton.layer.borderWidth = 1
        firstRequiredCharacteristicStyleButton.layer.borderColor = TBIThemeBlueColor.cgColor
        firstRequiredCharacteristicStyleButton.setTitle(dataSources[4][1].title, for: UIControlState.normal)
        firstRequiredCharacteristicStyleButton.setTitleColor(TBIThemeBlueColor, for: UIControlState.normal)
        firstRequiredCharacteristicStyleButton.setTitleColor(UIColor.white, for: UIControlState.selected)
        firstRequiredCharacteristicStyleButton.addTarget(self, action: #selector(requireButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        firstRequiredCharacteristicStyleButton.backgroundColor = UIColor.white
        baseBackgroundView.addSubview(firstRequiredCharacteristicStyleButton)
        firstRequiredCharacteristicStyleButton.snp.makeConstraints { (make) in
            
            make.top.equalTo(requiredCharacteristicStyleLabel.snp.bottom).offset(15)
            make.left.equalToSuperview().inset(15)
            make.width.equalTo(buttonLocalWidth)
            make.height.equalTo(buttonLocalHeight)
            
        }
        
        
        secondRequiredCharacteristicStyleButton.layer.cornerRadius = 5
        secondRequiredCharacteristicStyleButton.layer.borderWidth = 1
        secondRequiredCharacteristicStyleButton.layer.borderColor = TBIThemeBlueColor.cgColor
        secondRequiredCharacteristicStyleButton.setTitle(dataSources[4][2].title, for: UIControlState.normal)
        secondRequiredCharacteristicStyleButton.setTitleColor(TBIThemeBlueColor, for: UIControlState.normal)
        secondRequiredCharacteristicStyleButton.setTitleColor(UIColor.white, for: UIControlState.selected)
        secondRequiredCharacteristicStyleButton.backgroundColor = UIColor.white
        secondRequiredCharacteristicStyleButton.addTarget(self, action: #selector(requireButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        baseBackgroundView.addSubview(secondRequiredCharacteristicStyleButton)
        secondRequiredCharacteristicStyleButton.snp.makeConstraints { (make) in
            
            make.top.equalTo(requiredCharacteristicStyleLabel.snp.bottom).offset(15)
            make.right.equalToSuperview().inset(15)
            make.width.equalTo(buttonLocalWidth)
            make.height.equalTo(buttonLocalHeight)
            
        }

        
        //确定
        okayButton.layer.cornerRadius = 5
        okayButton.setTitle(dataSources[5].first?.title, for: UIControlState.normal)
        okayButton.titleLabel?.font = UIFont.systemFont( ofSize: 18)
        okayButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        okayButton.backgroundColor = TBIThemeDarkBlueColor
        okayButton.addTarget(self, action: #selector(okayButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        baseBackgroundView.addSubview(okayButton)
        okayButton.snp.makeConstraints { (make) in
            
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(47)
            make.top.equalTo(secondRequiredCharacteristicStyleButton.snp.bottom).offset(50)
            
        }
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
       
        verifySeletedRequire()
        
        
        
    }
    
    func verifySeletedRequire() {
        for element in requiredButtonArr
        {
            let result = selectedCustomRequire.contains(where: { (selectedElement) -> Bool in
                selectedElement.currentTitle == element.currentTitle
            })
            if result
            {
                element.isSelected = true
                element.backgroundColor = TBIThemeBlueColor
            }
            
            
        }
        
        
        let resultFirst = selectedCustomRequire.contains(where: { (selectedElement) -> Bool in
            selectedElement.currentTitle == firstBedStyleButton.currentTitle
        })
        if resultFirst
        {
            
            selectedBedStyleButton = firstBedStyleButton
            selectedBedStyleButton.isSelected = true
            selectedBedStyleButton.backgroundColor = TBIThemeBlueColor
        }
        
        let resultSecond = selectedCustomRequire.contains(where: { (selectedElement) -> Bool in
            selectedElement.currentTitle == secondBedStyleButton.currentTitle
        })
        if resultSecond
        {
            
            selectedBedStyleButton = secondBedStyleButton
            selectedBedStyleButton.isSelected = true
            selectedBedStyleButton.backgroundColor = TBIThemeBlueColor
        }
        
        
    }
    
    
    
    
    override func backButtonAction(sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    //MARK:--- Action
    
    func firstBedStyleButtonAction(sender:UIButton) {
        setBedStyleButtonState(sender: sender)
        
        
    }
    
    func secondBedStyleButtonAction(sender:UIButton) {
        setBedStyleButtonState(sender: sender)
    }
    func okayButtonAction(sender:UIButton) {
        
        selectedCustomRequire.removeAll()
        
        var bedType:String  = ""
        if selectedBedStyleButton.currentTitle != nil {
            bedType = selectedBedStyleButton.currentTitle!
            selectedCustomRequire.append(selectedBedStyleButton)
        }
        
        var requireStr:String = ""
        
        
        for element in requiredButtonArr
        {
            if element.isSelected == true {
               requireStr =  requireStr + element.currentTitle! + ","
                selectedCustomRequire.append(element)
            }
        }
        
        if requireStr.characters.count > 1
        {
            requireStr.remove(at: requireStr.index(before: requireStr.endIndex))
        }
        
        
        reserveRoomCustomRequireResultBlock(bedType,requireStr,selectedCustomRequire)
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    func requireButtonAction(sender:UIButton) {
        
        if sender.isSelected {
            sender.isSelected = false
            sender.backgroundColor = UIColor.white
        }
        else
        {
            sender.isSelected = true
            sender.backgroundColor = TBIThemeBlueColor
        }
        
    }
    
    
    func setBedStyleButtonState(sender:UIButton) {
        selectedBedStyleButton.isSelected = false
        selectedBedStyleButton.backgroundColor = UIColor.white
        selectedBedStyleButton = sender
        selectedBedStyleButton.isSelected = true
        selectedBedStyleButton.backgroundColor = TBIThemeBlueColor
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
