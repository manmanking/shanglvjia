//
//  TravellerAddViewController.swift
//  shop
//
//  Created by TBI on 2017/7/5.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import SwiftDate
import RxCocoa
import RxSwift




//旅客类型
enum TravellerType:String {
    case FamilyMember = "FamilyMember"
    case FriendsMember = "FriendsMember"
    case Unknown = "Unknown"
}
enum FamilyMemberRelationship:Int,PickableEnum{
    case Father = 1
    case Mother = 2
    case MotherInLaw = 4 //"MotherInLaw"
    case FatherInLaw =  3//"FatherInLaw"
    case ChildrenFirst = 5//"EldestChildren"
    case ChildrenSecond = 6//"SecondChildren"
    case Unknow
}



class TravellerAddViewController: CompanyBaseViewController {
    
    enum ClickActionEnum
    {
        case update
        case delete
    }
    
    //选择人闭包回掉
    typealias  PersonSelectedResultBlock = (ClickActionEnum,TravellerListItem?)->Void
    
    public var personSelectedResultBlock:PersonSelectedResultBlock!
    

    
    public var whereFrom:TravellerType = TravellerType.Unknown
    public var travellerFamilyRelationship:FamilyMemberRelationship = FamilyMemberRelationship.Unknow
    
    fileprivate let disposeBag = DisposeBag()
    
    fileprivate let travellerPersonView:TravellerPersonView = TravellerPersonView()
    
    fileprivate let travellerFooterView:TravellerFooterView = TravellerFooterView()
    
    var item:TravellerListItem?
    
    var model:TravellerForm = TravellerForm()
    
    fileprivate let titleArr:[String] = ["男","女"]
    
    fileprivate let rightBtn:UIButton = UIButton(frame:CGRect(x:0,y:5,width:30,height:20))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation(title:"出行人信息")
        initView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initData()
        
        
    }
    
    /// 设置删除按钮
    func setRightBar() {
        rightBtn.setTitle("删除", for: UIControlState.normal)
        rightBtn.setTitleColor(TBIThemeWhite, for: UIControlState.normal)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        rightBtn.backgroundColor = TBIThemeBlueColor
        rightBtn.setEnlargeEdgeWithTop(20 ,left: 20, bottom: 20, right: 20)
        rightBtn.addOnClickListener(target: self, action: #selector(rightItemClick(sender:)))
        let itemBar = UIBarButtonItem.init(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = itemBar
    }
    
    /// 删除
    ///
    /// - Parameter sender: 、
    func rightItemClick(sender: UIBarButtonItem) {
        if item != nil {
            let alertController = UIAlertController(title: "提示", message: "是否删除该常用旅客信息?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel){ action in
                alertController.removeFromParentViewController()
                
            }
            let okAction = UIAlertAction(title: "确定", style: .default){ action in
                alertController.removeFromParentViewController()
                TravelService.sharedInstance.deleteTraveller(String(self.item?.guid ?? 0)).subscribe{ event in
                    self.hideLoadingView()
                    switch event{
                    case .next(_):
                        if self.personSelectedResultBlock != nil {
                            self.personSelectedResultBlock(.delete,self.item)
                        }
                        _ = self.navigationController?.popViewController(animated: true)
                    case .error(let e):
                        try? self.validateHttp(e)
                    case .completed:
                        break
                    }
                    }.addDisposableTo(self.disposeBag)
            }
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
            
            
            
        }
        
    }
    
    override func backButtonAction(sender:UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
  

}
extension TravellerAddViewController {

    func initData(){
        model.nameEng.value = item?.nameEng ?? ""
        model.guid = item?.guid
        model.userId = item?.userId
        model.nameChi.value = item?.nameChi ?? ""
        model.gender = item?.gender
        model.phone.value = item?.phone ?? ""
        model.birthday = item?.birthday ?? ""
        model.country.value = item?.country ?? ""
        model.travelType = item?.travelType ?? 1
        model.cityId = item?.cityId
        model.idCard.value = item?.idCard ?? ""
        model.passport.value = item?.passport ?? ""
        model.sort = item?.sort
        model.remarks = item?.remarks
        refreshData()
    }
    
    func updateModel() {
        item?.nameEng = model.nameEng.value
        item?.nameChi = model.nameChi.value
        item?.gender  =  model.gender ?? 0
        item?.phone   =  model.phone.value
        item?.birthday  =  model.birthday ?? ""
        item?.country  =  model.country.value
        item?.travelType  =  model.travelType ?? 1
        item?.idCard  =  model.idCard.value
        item?.passport  = model.passport.value
    }
    
    func refreshData(){
        travellerPersonView.fillCell(model: model)
    }
    
    func initView(){
        self.view.addSubview(travellerPersonView)
        travellerPersonView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(10)
            make.height.equalTo(396)
        }
        self.view.addSubview(travellerFooterView)
        travellerFooterView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(travellerPersonView.snp.bottom)
            make.height.equalTo(84)
        }
        //travellerPersonView.nameChi.textField.rx.text.orEmpty.bind(to: travellerPersonView.nameChi.titleLabel.rx.text).addDisposableTo(disposeBag)
        travellerPersonView.nameChi.textField.rx.text.orEmpty.bind(to: model.nameChi).addDisposableTo(disposeBag)
        travellerPersonView.nameEng.textField.rx.text.orEmpty.bind(to: model.nameEng).addDisposableTo(disposeBag)
        travellerPersonView.phone.textField.rx.text.orEmpty.bind(to: model.phone).addDisposableTo(disposeBag)
        travellerPersonView.idCard.textField.rx.text.orEmpty.bind(to: model.idCard).addDisposableTo(disposeBag)
        travellerPersonView.passport.textField.rx.text.orEmpty.bind(to: model.passport).addDisposableTo(disposeBag)
        travellerPersonView.country.textField.rx.text.orEmpty.bind(to: model.country).addDisposableTo(disposeBag)
        
        travellerPersonView.gender.addOnClickListener(target: self, action: #selector(sexClick))
        travellerPersonView.birthday.addOnClickListener(target: self, action: #selector(birthdayAction))
        travellerPersonView.travelType.oneButton.addTarget(self, action: #selector(oneClick(sender:)), for: .touchUpInside)
        travellerPersonView.travelType.twoButton.addTarget(self, action: #selector(twoClick(sender:)), for: .touchUpInside)
        
        travellerFooterView.okBtn.addTarget(self, action: #selector(submitButton(sender:)), for: .touchUpInside)
    }
    
    
    
    //提交出行人
    func submitButton(sender: UIButton){
       
        switch whereFrom {
        case TravellerType.FamilyMember:
            addFamilyMember()
            
        case TravellerType.FriendsMember:
            addFriendsMember()
        case TravellerType.Unknown:
                updateTraveller()
        default:
            break
        }
        
        
        
        
    }
    
    //添加旅客信息
    func updateTraveller() {
        print("添加旅客")
        showLoadingView()
        TravelService.sharedInstance.updateTraveller(model).subscribe{ event in
            self.hideLoadingView()
            switch event{
            case .next(let e):
                //if e {
                let alertController = UIAlertController(title: "成功", message: "提交成功", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "确定", style: .default){ action in
                    alertController.removeFromParentViewController()
                    self.updateModel()
                    if self.personSelectedResultBlock != nil {
                        self.personSelectedResultBlock(.update,self.item)
                    }
                    _ = self.navigationController?.popViewController(animated: true)
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true)
            //}
            case .error(let e):
                try? self.validateHttp(e)
            case .completed:
                break
            }
            }.addDisposableTo(self.disposeBag)
    }
    
    func addFamilyMember() {
        print("添加家庭成员")
        model.relation = "1"
        showLoadingView()
        TravelService.sharedInstance
            .addFamilyMember(familyTraveller: model)
            .subscribe{ result in
                        self.hideLoadingView()
                        print(result)
                
                }.addDisposableTo(self.disposeBag)
    }
    
    func addFriendsMember() {
        print("添加朋友")
    }
    
    
    
    
    //成人
    func oneClick(sender: UIButton){
        self.model.travelType = 1
        travellerPersonView.travelType.oneButton.isSelected = true
        travellerPersonView.travelType.twoButton.isSelected = false
    }
    //儿童
    func twoClick(sender: UIButton){
        self.model.travelType = 2
        travellerPersonView.travelType.oneButton.isSelected = false
        travellerPersonView.travelType.twoButton.isSelected = true
    }
    
    //sex
    func sexClick(){
        weak var weakSelf = self
        let roleView = TBIFinderView.init(frame: ScreenWindowFrame)
        roleView.finderViewSelectedResultBlock = { (cellIndex) in
            weakSelf?.model.gender = cellIndex
            weakSelf?.travellerPersonView.gender.textField.text = weakSelf?.titleArr[cellIndex]
        }
        KeyWindow?.addSubview(roleView)
        roleView.reloadDataSources(titledataSources:titleArr, flageImage: [""])
    }
    
    //生日
    func birthdayClick(sender: UIButton){
        weak var weakSelf = self
        let datePicker = TBIDatePickerView(frame: ScreenWindowFrame)
        datePicker.date = model.birthday ?? ""
        datePicker.datePickerResultBlock = { (date) in
            weakSelf?.model.birthday = date
            weakSelf?.travellerPersonView.birthday.textField.text = date
            
        }
        KeyWindow?.addSubview(datePicker)
        
    }
    func birthdayAction(sender:UIButton) {
        weak var weakSelf = self
        let birthdayView =  TBIBirthdayDateView.init(frame: ScreenWindowFrame)
        birthdayView.birthdayDateViewResult = { (result) in
            weakSelf?.model.birthday = result
            weakSelf?.travellerPersonView.birthday.textField.text = result
            
        }
        KeyWindow?.addSubview(birthdayView)
    }
}
