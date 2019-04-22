//
//  TravelNewDateViewController.swift
//  shop
//
//  Created by manman on 2017/7/6.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import RxSwift

class TravelNewDateViewController:CompanyBaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    public var travelListItem:TravelListItem = TravelListItem()
    private var tableView:UITableView = UITableView()
    private var tableViewRegularCellIdentify:String = "tableViewRegularCellIdentify"
    private var travelNewDateTableViewCellIdentify:String = "travelNewDateTableViewCellIdentify"
    private let leftMargin:NSInteger = 0
    private var dataSources:[(title:String,content:String)] = Array()
    private var tipDataSources:[(content:String,length:NSInteger)] = Array()
    private var  recordNumView:TBIStepper = TBIStepper()
    private let bag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle(titleStr: "发起新日期")
        setNavigationBackButton(backImage: "")
        self.view.backgroundColor = TBIThemeBaseColor
        // Do any additional setup after loading the view.
        
        setUIViewAutolayout()
        tipDataSources = [(content:"选择出发日期",length:15),(content:"选择出行人数",length:10),(content:"输入正确的名称",length:5),(content:"请输入正确手机号码",length:12),(content:"请输入您的邮箱",length:30)]
        dataSources = [(travelListItem.productName!,""),("出发日期",""),("出行人数(需大于5人)",""),("称呼",""),("手机号码",""),("邮箱",""),("您提交需求后，专属服务人员会与您联系，确认信息以及价格。","提交")]
        print(travelListItem)
        
    }
    
    
    func  setUIViewAutolayout() {
        tableView.backgroundColor = TBIThemeBaseColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: tableViewRegularCellIdentify)
        tableView.register(TravelNewDateTableViewCell.classForCoder(), forCellReuseIdentifier: travelNewDateTableViewCellIdentify)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.left.bottom.right.equalToSuperview()
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        switch indexPath.row {
        case 0:
            return configHeaderView()
        case 2:
            return configSecondLine()
        case 6:
            return configFooterView()
        default:
          return configCell(index: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return caculateRowHeight(index: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("selected",indexPath)
        if indexPath.row == 1 {
            // 发起日期
            //nextSpecailCalendarView(paramater: nil)
            nextViewTBICalendarView(paramater: nil)
        }
        
    }
    
    
    
        func nextSpecailCalendarView (paramater:Dictionary<String, Any>?) {
            let viewController = TBISpecailCalendarViewController()
            if paramater != nil {
                viewController.selectedDates = [paramater?[HotelSearchCheckinDate] as! String,paramater?[HotelSearchCheckoutDate] as! String]
            }
            viewController.isMultipleTap = false
            viewController.showDateTitle = ["入住","离店"]
            
            
            weak var weakSelf = self
            viewController.hotelSelectedDateAcomplishBlock = { (parameters) in
                print(parameters)
                
                let dateArr:[String] = parameters[0].components(separatedBy: " ")
                weakSelf?.dataSources[1].content = dateArr.first!
                weakSelf?.tableView.reloadData()
                
            }
            _ = self.navigationController?.pushViewController(viewController, animated: true)
        }
        func nextViewTBICalendarView(paramater:Dictionary<String, Any>?) {
            
            let viewController = TBICalendarViewController()
            if paramater != nil {
                viewController.selectedDates = [paramater?[HotelSearchCheckinDate] as! String,paramater?[HotelSearchCheckoutDate] as! String]
            }
            viewController.isMultipleTap = false
            viewController.showDateTitle = ["入住","离店"]
            
            
            weak var weakSelf = self
            viewController.hotelSelectedDateAcomplishBlock = { (parameters,action) in
                guard action == TBICalendarAction.Done else {
                    return
                }
                let dateArr:[String] = (parameters?[0].components(separatedBy: " "))!
                weakSelf?.dataSources[1].content = dateArr.first!
                weakSelf?.tableView.reloadData()
                
            }
            _ = self.navigationController?.pushViewController(viewController, animated: true)
            
            
        }
    
    
    
    
    
    func configHeaderView() ->UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:tableViewRegularCellIdentify)
        cell?.contentView.backgroundColor = TBIThemeBaseColor
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        let baseBackgroundView:UIView = UIView()
        baseBackgroundView.backgroundColor = UIColor.white
        cell?.contentView.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
        }
       
        let contentLabel = UILabel()
        //contentLabel.edgeInsets = UIEdgeInsetsMake(25, 0, 25, 0)
        contentLabel.text = dataSources.first?.title
        contentLabel.font = UIFont.systemFont(ofSize: 13)
        contentLabel.numberOfLines = 0
        baseBackgroundView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(3)
            make.left.equalToSuperview().inset(15 + 15 + 6)
            make.right.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(3)
            
        }
        
        let flageImageView = UIImageView()
        flageImageView.image = UIImage.init(named: "ic_travel")
        baseBackgroundView.addSubview(flageImageView)
        flageImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(10)
            make.width.height.equalTo(15)
        }
        
        return cell!
    }
    func configSecondLine() -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:tableViewRegularCellIdentify)
        cell?.contentView.backgroundColor = UIColor.white
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        let contentLabel = UILabel()
        contentLabel.text = dataSources[2].title
        contentLabel.font = UIFont.systemFont( ofSize: 13)
        cell?.contentView.addSubview(contentLabel)
        contentLabel.adjustsFontSizeToFitWidth = true
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(15)
            make.top.bottom.equalToSuperview()
        }
        
//        let recordNumView =  TBINumberRecordView()
//        recordNumView.minNum = 0
//        recordNumView.currentNum = 0
//        cell?.contentView.addSubview(recordNumView)
//        recordNumView.snp.makeConstraints { (make) in
//            make.right.equalToSuperview().inset(15)
//            make.centerY.equalToSuperview()
//            make.top.bottom.equalToSuperview().inset(10)
//            make.width.equalTo(73)
//        }

        
        recordNumView.minNum = 5
        recordNumView.currentValue = 5
        recordNumView.maxNum = 99
        cell?.contentView.addSubview(recordNumView)
        recordNumView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(10)
            make.width.equalTo(90)
        }
        
        
        let bottomLine = UILabel()
        bottomLine.backgroundColor = TBIThemePlaceholderTextColor
        
        bottomLine.backgroundColor = TBIThemeGrayLineColor
        cell?.contentView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            
            make.bottom.equalToSuperview().inset(1)
            make.height.equalTo(0.5)
            make.left.equalToSuperview().inset(leftMargin)
            make.right.equalToSuperview()
            
        }
        
        
//        weak var weakSelf = self
//        recordNumView.numberRecordViewResultBlock = { (result) in
//            print(result)
//            weakSelf?.dataSources[2].content = result.description
//            
//        }
        
        
       return cell!
    }
    
    func configFooterView() -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:tableViewRegularCellIdentify)
        cell?.contentView.backgroundColor = TBIThemeBaseColor
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        let baseBackgroundView:UIView = UIView()
        baseBackgroundView.backgroundColor = TBIThemeBaseColor
        cell?.contentView.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        let subBaseBackgroundView:UIView = UIView()
        
        subBaseBackgroundView.backgroundColor = UIColor.white
        baseBackgroundView.addSubview(subBaseBackgroundView)
        
        let size = getTextHeigh(textStr: dataSources.last?.title, font:UIFont.systemFont( ofSize: 11) , width: ScreenWindowWidth - 15 * 3 - 6)
        let contentLabel = UILabel()
        contentLabel.backgroundColor = UIColor.white
        contentLabel.text = dataSources.last?.title
        contentLabel.adjustsFontSizeToFitWidth = true
        contentLabel.textColor = TBIThemePlaceholderTextColor
        contentLabel.font = UIFont.systemFont( ofSize: 11)
        baseBackgroundView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(15)
            make.left.equalToSuperview().inset(15 + 15 + 6)
            make.right.equalToSuperview().inset(15)
            make.height.equalTo(size + 16)
            
        }
        let flageImageView = UIImageView()
        flageImageView.image = UIImage.init(named: "warningBlue")
        baseBackgroundView.addSubview(flageImageView)
        flageImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentLabel.snp.centerY)
            make.width.height.equalTo(15)
            make.right.equalTo(contentLabel.snp.left).offset(-5)
        }
        
        
        
        
        subBaseBackgroundView.snp.makeConstraints { (make) in
            make.top.equalTo(contentLabel.snp.top)
            make.bottom.equalTo(contentLabel.snp.bottom)
            make.left.right.equalToSuperview()
        }
        baseBackgroundView.insertSubview(contentLabel, aboveSubview: subBaseBackgroundView)
        
        let commitButton = UIButton()
        commitButton.setTitle(dataSources.last?.content, for: UIControlState.normal)
        commitButton.backgroundColor = TBIThemeOrangeColor
        commitButton.layer.cornerRadius = 4
        commitButton.addTarget(self, action: #selector(commitButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        baseBackgroundView.addSubview(commitButton)
        commitButton.snp.makeConstraints { (make) in
            make.top.equalTo(contentLabel.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(47)
        }
        return cell!
        
        
    }
    
    
    func configCell(index:IndexPath) -> TravelNewDateTableViewCell {
        let cell:TravelNewDateTableViewCell = tableView.dequeueReusableCell(withIdentifier:travelNewDateTableViewCellIdentify) as! TravelNewDateTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        var contentPlaceHolder = ""
        var content = ""
        var intoNextEnable:Bool = false
        var showLineEnable:Bool = true
        var contentEnable = true
        switch index.row {
        case 1:
            contentPlaceHolder = "选择您的出发日期"
            intoNextEnable = true
            contentEnable = false
        case 3:
            contentPlaceHolder = "输入您的名称"
        case 4:
            contentPlaceHolder = "收入您的手机号码"
        case 5:
            contentPlaceHolder = "输入您的邮箱"
            showLineEnable = false
        default:
            break
        }
        
        
        if dataSources[index.row].content.isEmpty == false {
            content = dataSources[index.row].content
        }
        cell.fillDataSource(title: dataSources[index.row].title, contentPlaceHolder: contentPlaceHolder, content: content, contentEnable: contentEnable, intoNextEnable: intoNextEnable, showLineEnable:showLineEnable , cellIndex: index)
        weak var weakSelf = self
        cell.reserveRoomTableViewContentResultBlock = { (content,index) in
            print("controller",content,index)
            weakSelf?.dataSources[index.row].content = content
        }
        
        return cell
        
        
    }
    
    
    func caculateRowHeight(index:IndexPath) -> CGFloat {
        
        switch index.row {
        case 0:
            let topMargin:CGFloat = 10
            return topMargin * 2 + 10 + getTextHeigh(textStr: dataSources[index.row].title, font: UIFont.systemFont( ofSize: 13), width: ScreenWindowWidth - 15 * 2 - 15 + 6 )
        case 6:
            return 100
        default:
            return 44
        }
        
        
    }
    
    
    
    func getTextHeigh(textStr:String?,font:UIFont,width:CGFloat) -> CGFloat {
        
        if textStr?.characters.count == 0 || textStr == nil {
            return 0.0
        }
        let normalText: NSString = textStr as! NSString
        let size = CGSize(width:width,height:1000)
        let dic = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
        let stringSize = normalText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context:nil).size
        return stringSize.height
    }
    
    
    
    
    func commitButtonAction(sender:UIButton) {
        
        dataSources[2].content = recordNumView.currentValue.description
        for (index,value) in dataSources.enumerated()
        {
            if index >= 1 && index <= 5 && (value.content.isEmpty == true || verifyTextValue(data: value.content, length:tipDataSources[index - 1].length ) == false){
                
                showSystemAlertView(titleStr: "提示", message:tipDataSources[index - 1].content)
                return
            }
            
        }
        
//        if dataSources[2].content == "0" {
//            showSystemAlertView(titleStr: "提示", message:"请选择同行人数")
//            return
//        }
        
        if !dataSources[4].content.validate(ValidateType.phone)
        {
            showSystemAlertView(titleStr: "提示", message:"请输入手机号码")
            return
        }
        
        if !dataSources[5].content.validate(ValidateType.email)
        {
            showSystemAlertView(titleStr: "提示", message:"请输入正确的邮箱")
            return
        }
        

        let travelOrderForm = TravelDIYIntentOrder(destination: travelListItem.arriveCity, togetherCount: NSInteger(recordNumView.currentValue), travelDate: dataSources[1].content, travelDays:5, departureCity: travelListItem.startCity, budget: "1000", specialNeeds: "无特殊需求", customerName: dataSources[3].content, phoneNum: dataSources[4].content, email: dataSources[5].content)
        showLoadingView()
        weak var weakSelf = self
        TravelService.sharedInstance
            .submitCustomTravelForm(travelOrderForm: travelOrderForm)
            .subscribe{ event in
                weakSelf?.hideLoadingView()
                    if case .next( _) = event {
                        let view:SuccessOrderView = SuccessOrderView(titleText:"您的需求已提交成功",messageText:"专属服务人员会尽快与您联系,请保持手机\(travelOrderForm.phoneNum.description)畅通,谢谢!")
                        view.returnHomeBlock = {
                            self.intoMainView(from:"")
                        }
                        KeyWindow?.addSubview(view)
                        
                        //print(e)
                        //weakSelf?.showSystemAlertView(titleStr: " 提示", message: "提交成功")
                        //weakSelf?.navigationController?.popToRootViewController(animated: true)
                        //weakSelf?.intoMainView(from: "发起新日期")
                    }
                    if case .error(let e) = event {
                        print("=====失败======")
                        print(e)
                        try? weakSelf?.validateHttp(e)
                        //weakSelf?.showSystemAlertView(titleStr: " 提示", message: String(describing: e))
                       
                    }
            }.disposed(by: bag)
    }
    
    override func backButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // true  符合要求  false 违背要求
    func verifyTextValue(data:String,length:NSInteger) -> Bool
    {
        if data.characters.count < length {
            return true
        }
        return false
        
    }
    
    
    
    

}








class TravelNewDateTableViewCell: UITableViewCell ,UITextFieldDelegate{
    
    typealias ReserveRoomTableViewContentResultBlock = (String,IndexPath)->Void
    public var reserveRoomTableViewContentResultBlock:ReserveRoomTableViewContentResultBlock!
    private var baseBackgroundView = UIView()
    public var categoryTitleLabel = UILabel()
    private var contentTextField = UITextField()
    private var bottomLine = UILabel()
    private var index:IndexPath?
    private var intoDetailFlageImageView = UIImageView()
    
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
    
    func setUIViewAutolayout()
    {
        categoryTitleLabel.textAlignment = NSTextAlignment.left
        categoryTitleLabel.font = UIFont.systemFont(ofSize: 13)
        baseBackgroundView.addSubview(categoryTitleLabel)
        categoryTitleLabel.snp.makeConstraints { (make) in
            
            make.top.bottom.equalToSuperview().inset(5)
            make.left.equalToSuperview().inset(15)
            make.width.equalTo(100)
            
        }
        
        contentTextField.font = UIFont.systemFont( ofSize: 13)
        contentTextField.delegate = self
        contentTextField.returnKeyType = UIReturnKeyType.done
        baseBackgroundView.addSubview(contentTextField)
        contentTextField.snp.makeConstraints { (make) in
            
            make.top.bottom.equalToSuperview().inset(5)
            make.left.equalTo(categoryTitleLabel.snp.right).offset(5)
            make.right.equalToSuperview().inset(30)
            
        }
        
        intoDetailFlageImageView.image = UIImage.init(named: "Common_Forward_Arrow_Gray")
        baseBackgroundView.addSubview(intoDetailFlageImageView)
        intoDetailFlageImageView.snp.makeConstraints { (make) in
            
            make.right.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
            make.height.equalTo(13)
            make.width.equalTo(7)
            
        }
        
       
        bottomLine.backgroundColor = TBIThemeGrayLineColor
        baseBackgroundView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            
            make.bottom.equalToSuperview().inset(1)
            make.height.equalTo(0.5)
            make.left.equalToSuperview().inset(0)
            make.right.equalToSuperview()
            
        }
        
    }
    
    func fillDataSource(title:String,
                        contentPlaceHolder:String,
                        content:String,
                        contentEnable:Bool,
                        intoNextEnable:Bool,
                        showLineEnable:Bool,
                        cellIndex:IndexPath) {
    
        categoryTitleLabel.text = title
        if content.isEmpty {
            contentTextField.placeholder = contentPlaceHolder
        }else
        {
            contentTextField.text = content
        }
        index = cellIndex
        contentTextField.isEnabled = contentEnable
        bottomLine.isHidden = !showLineEnable
        intoDetailFlageImageView.isHidden = !intoNextEnable
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(textField.text)
        reserveRoomTableViewContentResultBlock(textField.text!,index!)
    }
    
}



