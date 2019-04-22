//
//  HotelCustomScreenView.swift
//  shop
//
//  Created by manman on 2017/5/4.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit


enum HotelCustomScreenType{
    case Price //价格筛选
    case Region // 行政区域
    case Star // 星际筛选
}


let HotelCustomScreenDetermineConditionDetail = "HotelCustomScreenDetermineConditionDetail"
let HotelCustomScreenDetermineConditionDetailIndex = "HotelCustomScreenDetermineConditionDetailIndex"

class HotelCustomScreenView: UIView,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource{
    
    typealias HotelCustomScreenDetermineConditionBlock = (Dictionary<String,Any>)->Void
    private let hotelCustomScreenTableViewCellIdentify = "HotelCustomScreenTableViewCell"
    private let baseBackgroundView = UIView()
    private let subBackgroundView = UIView()
    private let subTitleBackgroundView = UIView()
    private let tableView = UITableView()
    private let lowPriceTextField = UITextField()
    private let upPriceTextField = UITextField()
    
    
    private let cancelButton = UIButton()
    private let okayButton = UIButton()
    private let clearsButton = UIButton()
    
    public  var datasource:[String] = Array()
    
    
    //选中 条件的 角标 集合
    public var selectedIndexArr:[NSInteger] = Array()
    
    public var lowPrice:NSInteger = Int.min
    public var upPrice:NSInteger = Int.min
    
    //样式类型
    public  var hotelCustomScreenType:HotelCustomScreenType = HotelCustomScreenType.Price
    public  var hotelCustomScreenDetermineConditionBlock:HotelCustomScreenDetermineConditionBlock!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        baseBackgroundView.backgroundColor = UIColor.black
        baseBackgroundView.alpha = 0.2
        baseBackgroundView.addOnClickListener(target:self , action: #selector(cancelButtonAction))
        self.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        //注册键盘消失的通知
 
        setUIViewAutolayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setUIViewAutolayout() {
        
        subBackgroundView.backgroundColor = UIColor.white
        self.addSubview(subBackgroundView)
        subBackgroundView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(6 * 45 + 50 )
        }
        subTitleBackgroundView.backgroundColor = TBIThemeLinkColor
        subBackgroundView.addSubview(subTitleBackgroundView)
        subTitleBackgroundView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(50)
        }
        setSubTitleViewAutolayout()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.register(HotelCustomScreenTableViewCell.classForCoder(), forCellReuseIdentifier:hotelCustomScreenTableViewCellIdentify)
        subBackgroundView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(subTitleBackgroundView.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }
    }
    
    func setSubTitleViewAutolayout() {
        cancelButton.setTitle("取消", for: UIControlState.normal)
        cancelButton.titleLabel?.adjustsFontSizeToFitWidth = true
        cancelButton.setEnlargeEdgeWithTop(0, left: 10, bottom: 0, right:50)
        cancelButton.titleLabel?.font = UIFont.systemFont( ofSize: 16)
        cancelButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonAction), for: UIControlEvents.touchUpInside)
        subTitleBackgroundView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(15)
            make.height.equalTo(15)
            make.centerY.equalToSuperview()
        }
        
        clearsButton.setTitle("清空筛选", for: UIControlState.normal)
        clearsButton.titleLabel?.font = UIFont.systemFont( ofSize: 16)
        clearsButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        clearsButton.titleLabel?.adjustsFontSizeToFitWidth = true
        clearsButton.addTarget(self, action: #selector(clearsButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        subTitleBackgroundView.addSubview(clearsButton)
        clearsButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(15)
            
        }
        
        okayButton.setTitle("确定", for: UIControlState.normal)
        okayButton.titleLabel?.adjustsFontSizeToFitWidth = true
        okayButton.titleLabel?.font = UIFont.systemFont( ofSize: 16)
        okayButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        okayButton.addTarget(self, action: #selector(okayButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        subTitleBackgroundView.addSubview(okayButton)
        okayButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(15)
            make.height.equalTo(30)
        }
    }
    
    //MARK:-- UITableViewDataSource start of line
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch hotelCustomScreenType {
        case .Price,.Region:
            print("price ...")
            return datasource.count
        case .Star:
            print("star ...")
            return 6
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell:HotelCustomScreenTableViewCell = tableView.dequeueReusableCell(withIdentifier: hotelCustomScreenTableViewCellIdentify) as! HotelCustomScreenTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.customScreenType = TBICustomScreenType.Hotel
        if selectedIndexArr.contains(indexPath.row) {
            cell.cellConfig(title:datasource[indexPath.row], selected: true ,index:indexPath.row, selectedImage: nil)
        }else
        {
            cell.cellConfig(title:datasource[indexPath.row], selected: false,index:indexPath.row, selectedImage: nil)
        }
        weak var weakSelf = self
        cell.hotelCustomScreenSelectedConditionBlock = { (selectedCell) in
            weakSelf?.selectedCondition(selectedIndex: selectedCell)
        }
        
        if hotelCustomScreenType == HotelCustomScreenType.Price {
            if indexPath.section == 0 && indexPath.row == 5 {
                
                if lowPrice != Int.min
                {
                    lowPriceTextField.text = String(lowPrice)
                }else
                {
                    lowPriceTextField.text = ""
                }
                if upPrice != Int.min
                {
                    
                    upPriceTextField.text = String(upPrice)
                }
                else
                {
                    upPriceTextField.text = ""
                }
                lowPriceTextField.layer.borderWidth = 0.5
                lowPriceTextField.delegate = self
                lowPriceTextField.textAlignment = NSTextAlignment.center
                lowPriceTextField.keyboardType = UIKeyboardType.numberPad
                lowPriceTextField.returnKeyType = UIReturnKeyType.done
                lowPriceTextField.layer.backgroundColor = TBIThemePrimaryTextColor.cgColor
                lowPriceTextField.backgroundColor = UIColor.white
                cell.contentView.addSubview(lowPriceTextField)
                lowPriceTextField.snp.makeConstraints({ (make) in
                    make.left.equalToSuperview().inset(15)
                    make.centerY.equalToSuperview()
                    make.width.equalTo(80)
                    make.height.equalTo(30)
                })
                
                let midLine = UILabel()
                midLine.backgroundColor = UIColor.black
                cell.contentView.addSubview(midLine)
                midLine.snp.makeConstraints({ (make) in
                    make.left.equalTo(lowPriceTextField.snp.right).offset(5)
                    make.centerY.equalToSuperview()
                    make.width.equalTo(5)
                    make.height.equalTo(0.5)
                })
                
                upPriceTextField.layer.borderColor = TBIThemePrimaryTextColor.cgColor
                upPriceTextField.layer.borderWidth = 0.5
                upPriceTextField.textAlignment = NSTextAlignment.center
                upPriceTextField.delegate = self
                upPriceTextField.keyboardType = UIKeyboardType.numberPad
                upPriceTextField.returnKeyType = UIReturnKeyType.done
                upPriceTextField.backgroundColor = UIColor.white
                cell.contentView.addSubview(upPriceTextField)
                upPriceTextField.snp.makeConstraints({ (make) in
                    make.left.equalTo(midLine.snp.right).offset(5)
                    make.centerY.equalToSuperview()
                    make.height.equalTo(30)
                    make.width.equalTo(80)
                })
            }
        }
        return cell
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        printDebugLog(message:"touchesBegan")
        
        
        keyboardWillHide()

        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if  hotelCustomScreenType == HotelCustomScreenType.Price {
            selectedCondition(selectedIndex:5)
        }
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        printDebugLog(message:"textFieldDidBeginEditing")
       
        
        let frame = textField.frame;
        
        let heights:CGFloat = self.subBackgroundView.frame.size.height;
        
        // 当前点击textfield的坐标的Y值 + 当前点击textFiled的高度 - （屏幕高度- 键盘高度 - 键盘上tabbar高度）
        
        // 在这一部 就是了一个 当前textfile的的最大Y值 和 键盘的最全高度的差值，用来计算整个view的偏移量
        // - 35.0
        let offset:CGFloat = heights - 216.0  + 35.0 * 2 //键盘高度216
        let animationDuration:TimeInterval = 0.30
        UIView.beginAnimations("ResizeForKeyBoard", context: nil)
        UIView.setAnimationDelay(animationDuration)
        
        let width:CGFloat = self.subBackgroundView.frame.size.width
        let height:CGFloat = self.subBackgroundView.frame.size.height
        
        if(offset > 0)
        {
            
            let rect:CGRect = CGRect(x:0.0, y:offset ,width:self.frame.size.width, height:5 * 45 + 50);
            self.subBackgroundView.frame = rect;
            
        }
        
        UIView.commitAnimations()

    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
   
        printDebugLog(message:"touchesBegan")
        
        keyboardWillHide()
    }
    
    
    func keyboardWillHide() {
        self.endEditing(true)
        
        
        let animationDuration:TimeInterval = 0.30
        
        UIView.beginAnimations("ResizeForKeyboard", context: nil)
        UIView.setAnimationDelay(animationDuration)
        let rect:CGRect = CGRect(x:0.0, y:ScreentWindowHeight - (6 * 45 + 50)  ,width:self.frame.size.width, height:6 * 45 + 50);
        
        self.subBackgroundView.frame = rect;
        UIView.commitAnimations()
        
    }
    
   
   
    
    
    
    
    
    //MARK:-- UITableViewDelegate start of line
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedCondition(selectedIndex: indexPath.row)
    }
    
    //MARK:-----Action
    @objc private func cancelButtonAction() {
        
        self.removeFromSuperview()
        
        
    }
    func clearsButtonAction(sender:UIButton) {
        self.selectedIndexArr.removeAll()
        self.selectedIndexArr.append(0)
        lowPrice = Int.min
        upPrice = Int.min
        tableView.reloadData()
    }
    func okayButtonAction(sender:UIButton) {
        print("确定 条件")
       
        if selectedIndexArr.count == 0 || (selectedIndexArr.contains(5) && (upPriceTextField.text?.characters.count == 0 || lowPriceTextField.text?.characters.count == 0 ) && hotelCustomScreenType == HotelCustomScreenType.Price ) {
            showSystemAlertView(titleStr: "提示", message: "请选择筛选条件")
            return
        }
        
        var forthCondition = ""
        
        var selectedConditionArr:[String] = Array()
        
        
        for index in 0..<selectedIndexArr.count
        {
            if datasource[selectedIndexArr[index]].isEmpty  == false {
                selectedConditionArr.append(datasource[selectedIndexArr[index]])
            }
        }
        
        if hotelCustomScreenType == HotelCustomScreenType.Price
        {
            if selectedIndexArr.contains(5)
            {
                if lowPriceTextField.text?.compare(upPriceTextField.text!) == ComparisonResult.orderedDescending
                {
                    showSystemAlertView(titleStr: "提示", message: "筛选价格区间错误")
                    return
                }
                
                
                
                
                
                forthCondition = (lowPriceTextField.text?.description)! + "-" + (upPriceTextField.text?.description)!
                selectedConditionArr.append(forthCondition)
            }
            if selectedIndexArr.contains(4) {
                //丰田
                if Toyota == UserService.sharedInstance.userDetail()?.companyUser?.companyCode  {
                    selectedConditionArr[0] = ("650-99999")// 650 以上
                }else
                {
                    selectedConditionArr[0] = ("800-99999")// 800 以上
                }
                
            }
        }
        let tmpDic:Dictionary<String,Any> = [HotelCustomScreenDetermineConditionDetail:selectedConditionArr,HotelCustomScreenDetermineConditionDetailIndex:selectedIndexArr]
        
       
        self.hotelCustomScreenDetermineConditionBlock(tmpDic)
        cancelButtonAction()
        
    }
    
    
    func selectedCondition(selectedIndex:NSInteger) {
        
        if hotelCustomScreenType == HotelCustomScreenType.Price || hotelCustomScreenType ==  HotelCustomScreenType.Region
        {
            if selectedIndexArr.count == 1 {
                selectedIndexArr[0] = selectedIndex
                if hotelCustomScreenType == HotelCustomScreenType.Price && selectedIndex == 5 {
                    if lowPriceTextField.text?.isEmpty == false {
                        lowPrice =  NSInteger(lowPriceTextField.text!)!
                    }
                    
                    if upPriceTextField.text?.isEmpty == false {
                        upPrice =  NSInteger(upPriceTextField.text!)!
                    }
                    
                }
            }else
            {
                selectedIndexArr.append(selectedIndex)
            }
            
        }
        else
        {
            if selectedIndex == 0
            {
                if !selectedIndexArr.contains(0) {
                    selectedIndexArr.removeAll()
                    selectedIndexArr.append(0)
                }else
                {
                    selectedIndexArr.removeAll()
                }
                
                tableView.reloadData()
                return
  
            }
            //是否保存 选中 条件
            if self.selectedIndexArr.contains(selectedIndex)
            {
                //取消选中
                for index in 0..<selectedIndexArr.count {
                    if selectedIndexArr[index] == selectedIndex {
                        selectedIndexArr.remove(at: index)
                        if selectedIndexArr.count == 0
                        {
                            selectedIndexArr.append(0)
                        }
                        
                        break
                    }
                }
            }else
            {
                if selectedIndexArr.contains(0)
                {
                    selectedIndexArr.removeAll()
                    
                }
                selectedIndexArr.append(selectedIndex)
                
            }
            
        }
       
        
        tableView.reloadData()
        
    }
    
    /// 显示系统提示信息样式
    ///
    /// - Parameters:
    ///   - titleStr:
    ///   - message:
    func showSystemAlertView(titleStr:String,message:String) {
        let alertView = UIAlertView.init(title: titleStr, message: message, delegate: self, cancelButtonTitle: "确定")
        alertView.show()
        
    }
    
    

}
