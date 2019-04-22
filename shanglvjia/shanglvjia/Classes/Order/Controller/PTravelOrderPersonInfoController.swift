//
//  PTravelOrderPersonInfoController.swift
//  shop
//
//  Created by 孙祎鸿 on 2017/7/10.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class PTravelOrderPersonInfoController: CompanyBaseViewController
{
    var personInfo:PSpecialOrderDetails.OrderSpecialPersonInfo! = nil
    
    let contentYOffset:CGFloat = 20 + 44
    var myContentView:UIView! = nil
    
    let myTableView = UITableView()
    var dataSource:[(title:String,content:String)] = []
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        //设置头部的导航栏
        self.title = "出行人信息"  //"出行人信息"
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont.systemFont(ofSize: 16),NSForegroundColorAttributeName:UIColor.white]
        setNavigationBackButton(backImage: "back")
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIColor.creatImageWithColor(color: TBIThemeBlueColor), for: .any, barMetrics: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        setDataSource()
        initView()
    }
    
    //重写  头部左侧的🔙Btn
    override func backButtonAction(sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.navigationBar.shadowImage = UIImage.init(named: "border")
    }
    
    func setDataSource() -> Void
    {
        dataSource = []
        
        dataSource.append(("中文姓名",personInfo.personNameCn ?? ""))
        dataSource.append(("英文姓名",personInfo.personNameEn ?? ""))
        dataSource.append(("手机号码",personInfo.personPhone ?? ""))
        
        dataSource.append(("身份证号码",personInfo.personIdCard ?? ""))
        dataSource.append(("护照号码",personInfo.personPassport ?? ""))
        dataSource.append(("国籍",personInfo.personNationality ?? ""))
        
        var sexStr = ""
        if let personSex = personInfo.personSex
        {
            if personSex == "0"
            {
                sexStr = "男"
            }
            else if personSex == "1"
            {
                sexStr = "女"
            }
        }
        dataSource.append(("性别",sexStr))
        dataSource.append(("出生日期",personInfo.personBirthDay ?? ""))
        dataSource.append(("类型",personInfo.personTypeEnum.description))
    }
    
    func initView() -> Void
    {
        myContentView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWindowWidth, height: ScreentWindowHeight - contentYOffset))
        myContentView.backgroundColor = TBIThemeBaseColor
        self.view.addSubview(myContentView)
        
        myTableView.backgroundColor = TBIThemeBaseColor
        myContentView.addSubview(myTableView)
        myTableView.snp.makeConstraints{(make)->Void in
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(10)
        }
        
        myTableView.estimatedRowHeight = 30
        myTableView.rowHeight = UITableViewAutomaticDimension
        myTableView.separatorStyle = .none
        
        myTableView.dataSource = self
        myTableView.delegate = self
    }

}

extension PTravelOrderPersonInfoController:UITableViewDelegate,UITableViewDataSource
{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dataSource.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "")
        
        let i = indexPath.row
        
        let myCellContentView = UIView()
        myCellContentView.backgroundColor = .white
        cell.contentView.addSubview(myCellContentView)
        myCellContentView.snp.makeConstraints{(make)->Void in
            make.height.equalTo(44)
            make.width.equalTo(ScreenWindowWidth)
            
            make.left.top.right.bottom.equalTo(0)
        }
        
        let leftLabel = UILabel(text: dataSource[i].title, color: TBIThemePrimaryTextColor, size: 13)
        myCellContentView.addSubview(leftLabel)
        leftLabel.snp.makeConstraints{(make)->Void in
            make.left.equalTo(15)
            make.width.equalTo(80)
            make.centerY.equalToSuperview()
        }
        
        let rightLabel = UILabel(text: dataSource[i].content, color: TBIThemePrimaryTextColor, size: 13)
        myCellContentView.addSubview(rightLabel)
        rightLabel.snp.makeConstraints{(make)->Void in
            make.left.equalTo(100)
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
        }
        
        if i < (dataSource.count - 1)
        {
            //item底部的分割线
            let bottomSegLine = UIView()
            bottomSegLine.backgroundColor = TBIThemeGrayLineColor
            myCellContentView.addSubview(bottomSegLine)
            bottomSegLine.snp.makeConstraints{(make)->Void in
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.bottom.equalTo(0)
                
                make.height.equalTo(1)
            }
        }
        
        return cell
    }
}









