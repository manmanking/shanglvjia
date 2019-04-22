//
//  HotelSummaryViewController.swift
//  shop
//
//  Created by manman on 2017/5/10.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class HotelSummaryViewController: CompanyBaseViewController,UITableViewDelegate,UITableViewDataSource{

    //酒店周边
    public var hotelTraffic:String?
    private var hotelTrafficRowNum:NSInteger = 1
    //酒店介绍
    public var hotelDescription:String?
    private var hotelDescriptionRowNum:NSInteger = 1
    //酒店设施
    public var generalAmenities:String = ""
    private var generalAmenitiesRowNum:NSInteger = 1
    public var hotelName:String = String()
    
    
    private var rowNum:NSInteger = 3
    private var tableView:UITableView = UITableView()
    private var hotelSummaryViewCellIdentify = "HotelSummaryViewCellIdentify"
    private var hotelImageViewArr:[(imageView:String,title:String)] = [("HotelName","酒店设施"),("HotelAddress","酒店周边"),("HotelDetails","酒店介绍")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.alpha = 1
        self.automaticallyAdjustsScrollViewInsets = true
        setBlackTitleAndNavigationColor(title: hotelName)
        self.view.backgroundColor = TBIThemeWhite
        hotelImageViewArr.removeAll()
        if hotelDescription?.isEmpty == false && hotelDescription != nil{
            //hotelDescriptionRowNum -= 1
            hotelImageViewArr.append(("HotelDetails","酒店介绍"))
        }
        
        if generalAmenities.isEmpty == false && generalAmenities != nil{
            //generalAmenitiesRowNum -= 1
            hotelImageViewArr.append(("HotelName","酒店设施"))
        }
        if hotelTraffic?.isEmpty == false && hotelTraffic != nil{
            //hotelTrafficRowNum -= 1
            hotelImageViewArr.append(("HotelAddress","酒店周边"))
        }
       
        
        
        
        tableView.backgroundColor = TBIThemeBaseColor
        tableView.delegate = self
        tableView.dataSource  = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.register(HotelSummaryViewCell.classForCoder(), forCellReuseIdentifier:hotelSummaryViewCellIdentify)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(0)
        }
        

        
    }
    
    
    
    
    override func backButtonAction(sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hotelImageViewArr.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var  height:CGFloat  = 44 + 40
        height += caculateRowHeight(cellindex: indexPath)
        
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:HotelSummaryViewCell  = tableView.dequeueReusableCell(withIdentifier: hotelSummaryViewCellIdentify) as! HotelSummaryViewCell
        
        var content:String?
        
        if hotelImageViewArr[indexPath.row].title == "酒店设施" {
            content = generalAmenities
        }
        if hotelImageViewArr[indexPath.row].title == "酒店周边"  {
            content = hotelTraffic
        }
        if hotelImageViewArr[indexPath.row].title == "酒店介绍"  {
            content = hotelDescription
        }
        if  indexPath.row > hotelImageViewArr.count {
            return cell
        }
        
        cell.fillDataSources(titleImage:hotelImageViewArr[indexPath.row].imageView , title:hotelImageViewArr[indexPath.row].title , hotelDescription:content )
        return cell
        
        
    }
    
    func  caculateRowHeight(cellindex:IndexPath)-> CGFloat {
       
        var height:CGFloat = 0
        let font =  UIFont.systemFont( ofSize: 13)
        let width = ScreenWindowWidth - 30
        if hotelImageViewArr[cellindex.row].title == "酒店设施" && generalAmenities != nil && generalAmenities.isEmpty != true{
          height =  getTextHeigh(textStr:generalAmenities , font:font, width:width )
            
        }
        if hotelImageViewArr[cellindex.row].title == "酒店周边" && hotelTraffic != nil && hotelTraffic?.isEmpty != true {
            height = getTextHeigh(textStr:hotelTraffic , font:font, width:width)
        }
        
        if hotelImageViewArr[cellindex.row].title == "酒店介绍" && hotelDescription != nil && hotelDescription?.isEmpty != true {
            height = getTextHeigh(textStr:hotelDescription , font:font, width: width)
        }
        
        return height
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
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}



class HotelSummaryViewCell: UITableViewCell {
    
    private var baseBackgroundView:UIView = UIView()
    private var subBackgroundView:UIView = UIView()
    private var titleFlagImageView:UIImageView = UIImageView()
    private var titleContent:UILabel = UILabel()
    private var titleDescription:UILabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        baseBackgroundView.backgroundColor = TBIThemeBaseColor
        self.selectionStyle = .none
        self.contentView.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
         make.top.left.bottom.right.equalToSuperview()
        }
        
        subBackgroundView.backgroundColor = UIColor.white
        baseBackgroundView.addSubview(subBackgroundView)
        subBackgroundView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
        }
        setUIViewAutolayout()
        
        
    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    func setUIViewAutolayout() {
        
        subBackgroundView.addSubview(titleFlagImageView)
        titleFlagImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(12)
            make.left.equalToSuperview().inset(15)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        titleContent.font = UIFont.systemFont( ofSize: 16)
        titleContent.textColor = TBIThemePrimaryTextColor
        subBackgroundView.addSubview(titleContent)
        titleContent.snp.makeConstraints { (make) in
            make.left.equalTo(titleFlagImageView.snp.right).offset(10)
            make.top.equalTo(titleFlagImageView.snp.top)
            make.width.equalToSuperview().inset(15)
            make.height.equalTo(16)
        }
        
        let line = UILabel()
        line.backgroundColor = TBIThemeGrayLineColor
        subBackgroundView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.top.equalTo(titleContent.snp.bottom).offset(12)
            make.left.equalToSuperview().inset(15)
            make.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        titleDescription.textColor = TBIThemePrimaryTextColor
        titleDescription.font = UIFont.systemFont( ofSize: 13)
        titleDescription.numberOfLines = 0
        titleDescription.lineBreakMode = NSLineBreakMode.byWordWrapping
        subBackgroundView.addSubview(titleDescription)
        titleDescription.snp.makeConstraints { (make) in
            make.top.equalTo(line.snp.bottom).offset(15)
            make.left.bottom.right.equalToSuperview().inset(15)
            
        }
    }
    
    
    func fillDataSources(titleImage:String,title:String,hotelDescription:String?){
        
        titleFlagImageView.image = UIImage.init(named: titleImage)
        titleContent.text = title
        titleDescription.text = hotelDescription
    }
    
    
    
    
    
    
    
    
    
    
    
    
}




