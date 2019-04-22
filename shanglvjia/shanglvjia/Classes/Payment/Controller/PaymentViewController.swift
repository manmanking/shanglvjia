//
//  PaymentViewController.swift
//  shop
//
//  Created by manman on 2017/7/10.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import RxSwift

enum PaymentType:String  {
    case AliPay = "支付宝支付"
    case Wechat = "微信支付"
    case OtherPay = "otherPay"
    case Unknow = "Unknow"
    
}


//产品类型 支付
enum ProductTypePayment {
    case Travel
    case Flight
    case Hotel
    case Special
    case Default
}





class PaymentViewController: CompanyBaseViewController,UITableViewDelegate,UITableViewDataSource,PayManagerStateProtocol{

    //订单类型 1机票 3旅游特价
    public var orderType:Int = 0
    
    
    public var productTypePayment:ProductTypePayment = ProductTypePayment.Default
    //订单号
    public var orderNum:String = ""
    private var tableView:UITableView = UITableView()
    private let paymentViewCellIdentify = "PaymentViewCellIdentify"
    private let paymentViewOrderCellIdentify = "PaymentViewOrderCellIdentify"
    
    
    private var dataSource:[(title:String,titleContent:String)] = Array()
    private let bag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = TBIThemeMinorColor
        setNavigation(title: "")
        setTitle(titleStr: "在线支付")
        print("订单编号:",orderNum)
        dataSource = [("",""),("微信支付","ic_weixin"),("支付宝支付","ic_zhifubao")]
        setUIViewAutolayout()
        // Do any additional setup after loading the view.
        PayManager.sharedInstance.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(goBackgroundAction), name: NSNotification.Name.init(rawValue: GoBackground), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(goForegroundAction), name: NSNotification.Name.init(rawValue: GoForeground), object: nil)
        
    }
    
    func setUIViewAutolayout() {
        tableView.backgroundColor = TBIThemeMinorColor
        tableView.delegate = self
        tableView.dataSource = self
        
        let headerView = TBIPaymentHeaderView()
        headerView.productTypePayment = productTypePayment
        headerView.frame = CGRect.init(x: 0, y: 0, width: ScreenWindowWidth, height: 250)
        weak var weakSelf = self
        headerView.paymentHeaderViewRemainEndBlcok = {
            weakSelf?.backButtonAction(sender: UIButton())
            
        }
        tableView.tableHeaderView = headerView
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.register(PaymentViewCell.classForCoder(), forCellReuseIdentifier:paymentViewCellIdentify)
        tableView.register(PaymentViewOrderCell.classForCoder(), forCellReuseIdentifier: paymentViewOrderCellIdentify)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.bottom.right.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getOrderInfo(orderNum: orderNum)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell:PaymentViewOrderCell = tableView.dequeueReusableCell(withIdentifier: paymentViewOrderCellIdentify) as! PaymentViewOrderCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            cell.fillDataSource(orderNum: dataSource[indexPath.row].title, orderPrice: dataSource[indexPath.row].titleContent)
            weak var weakSelf = self
            cell.paymentViewOrderBlock = { (order) in
                weakSelf?.backButtonAction(sender:UIButton())
                
            }
            return cell
            
            
        }
        
        
        
        
        
        let cell:PaymentViewCell = tableView.dequeueReusableCell(withIdentifier: paymentViewCellIdentify) as! PaymentViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        var showLine:Bool = true
        if indexPath.row == 2 {
            showLine = false
        }
        cell.fillDataSource(title: dataSource[indexPath.row].title, imageName:dataSource[indexPath.row].titleContent, showLine: showLine)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        choicePaymentType(type:PaymentType.init(rawValue: dataSource[indexPath.row].title) ?? PaymentType.Unknow)
    }
    
    
    
    func choicePaymentType(type:PaymentType) {
        switch type {
        case PaymentType.AliPay:
            alipayOrderInfo(type: type)
            break
        case PaymentType.Wechat:
            wechatOrderInfo(type: type)
            break
        case PaymentType.Unknow:
            break
        default: break
            
        }
        
        
        
    }
    
    func getOrderInfo(orderNum:String) {
        weak var weakSelf = self
        PaymentService.sharedInstance
            .orderInfo(order: orderNum)
            .subscribe { (event) in
                weakSelf?.hideLoadingView()
                if case .next(let result) = event {
                    print(result)
                    weakSelf?.dataSource[0].title = result.orderNo!
                    weakSelf?.dataSource[0].titleContent = result.orderTotalAmount.description
                    
                    var timeRemaining:Int = 0
                    
                    switch weakSelf!.productTypePayment
                    {
                        case ProductTypePayment.Flight:
                        
                            timeRemaining = result.timeRemaining
                        
                            
                        case ProductTypePayment.Travel,ProductTypePayment.Special:
                            timeRemaining = Int(ceil(Double(result.timeRemaining / 60)))
                        default:
                            break
                    }
                    
                    
                    (weakSelf?.tableView.tableHeaderView as! TBIPaymentHeaderView).fillDataSource(remainTime:timeRemaining)
                    weakSelf?.tableView.reloadData()
                }
                
                if case .error(let result) = event {
                    try? weakSelf?.validateHttp(result)
                    //weakSelf?.showSystemAlertView(titleStr: "提示", message: String(describing: result))
                }
                
                
            }.disposed(by: bag)
        
        
        
        
    }
    
    
    
    func alipayOrderInfo(type:PaymentType)  {
        
        weak var weakSelf = self
        PaymentService.sharedInstance
            .alipayOrderInfo(order: orderNum)
            .subscribe { (event) in
                weakSelf?.hideLoadingView()
                if case .next(let result) = event {
                    print(result)
                    PayManager.sharedInstance.aliPayRequest(order:result )
                }
                if case .error(let result) = event {
                    try? weakSelf?.validateHttp(result)
                    //weakSelf?.showSystemAlertView(titleStr: "提示", message: String(describing: result))
                }
                
                
            }.disposed(by: bag)
        
        
    }
    
    func wechatOrderInfo(type:PaymentType)  {
        
        weak var weakSelf = self
        PaymentService.sharedInstance
            .wechatOrderInfo(order:orderNum)
            .subscribe { (event) in
                weakSelf?.hideLoadingView()
                if case .next(let result) = event {
                    print(result)
                    PayManager.sharedInstance.wxPayRequst(order:result)
                }
                if case .error(let result) = event {
                  try? weakSelf?.validateHttp(result)
                    // weakSelf?.showSystemAlertView(titleStr: "提示", message: String(describing: result))
                }
                
                
            }.disposed(by: bag)
        
        
    }
    
    func paymentView(paymentState:PaymentState) {
        
        weak var weakSelf = self
        let successView = TBIPaymentView.init(frame: (KeyWindow?.frame)!)
        successView.paymentState = paymentState
        successView.paymentViewBlock = {(title) in
            
            if title == "order" {
                //
                
               weakSelf?.backButtonAction(sender: UIButton())

                
            }else
            {
                weakSelf?.navigationController?.popToRootViewController(animated: true)
            }
        }
        KeyWindow?.addSubview(successView)
    }
    
    override func backButtonAction(sender: UIButton) {
        nextView()
        //self.navigationController?.popViewController(animated: true)
    }
    
    func nextView() {
        let needCustomPop = self.navigationController?.viewControllers.contains{ $0.isKind(of:SpecialOrderViewController.self ) || $0.isKind(of:TravelOrderViewController.self ) } ?? true
        guard needCustomPop else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        let tabBarController:BaseTabBarController = UIApplication.shared.keyWindow?.rootViewController as! BaseTabBarController
        
        
        tabBarController.selectedIndex = 2
        switch productTypePayment {
        case .Flight:
            let flightView = PFlightOrderDetailsController()
            flightView.flightOrderNO = orderNum   //机票订单号
            //改变当前controller栈
            (tabBarController.childViewControllers[2] as! BaseNavigationController).pushViewController(flightView, animated: false)
            self.navigationController?.popToRootViewController(animated: false)
            break
        case .Travel,.Special:
            //*****个人版“旅游”订单
            let travel = PTravelOrderDetailsController()
            travel.mTravelOrderNo = orderNum   //旅游订单号
            (tabBarController.childViewControllers[2] as! BaseNavigationController).pushViewController(travel, animated: false)
            self.navigationController?.popToRootViewController(animated: false)
            break
        case .Default:
            self.navigationController?.popViewController(animated: true)
            break
        default:
            self.navigationController?.popViewController(animated: true)
            break
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:------count Down
    func goBackgroundAction() {
        goBackgroundDate = Date()
        (self.tableView.tableHeaderView as! TBIPaymentHeaderView).shutDownTime.invalidate()
        
    }
    
    
    func goForegroundAction() {
        goForegroundDate = Date()
        timeInterval =  goForegroundDate.timeIntervalSince(goBackgroundDate)
        (self.tableView.tableHeaderView as! TBIPaymentHeaderView).fillDataSource(remainTime:NSInteger(timeInterval))
        
    }
    
    
    
    
    
    //MARK:------PayManagerDelegate
    func payManagerDidRecvFailureInfo(parameters: Dictionary<String, Any>?) {
        paymentView(paymentState: PaymentState.Failure)
    }
    func payManagerDidRecvSuccessInfo(parameters: Dictionary<String, Any>?) {
        paymentView(paymentState: PaymentState.Success)
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


class PaymentViewCell: UITableViewCell {
    
    private var baseBackgroundView:UIView = UIView()
    private var flagImageView:UIImageView = UIImageView()
    private var titleLabel:UILabel = UILabel()
    private var intoFlagImageView:UIImageView = UIImageView()
    private var bottomLine:UILabel = UILabel()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(baseBackgroundView)
        baseBackgroundView.backgroundColor = UIColor.white
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        setUIAutolayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setUIAutolayout() {
        flagImageView.image = UIImage.init(named: "")
        baseBackgroundView.addSubview(flagImageView)
        flagImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        titleLabel.textColor = TBIThemePrimaryTextColor
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        baseBackgroundView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(flagImageView.snp.right).offset(8)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(50)
            make.height.equalTo(30)
        }
        intoFlagImageView.image = UIImage.init(named: "ic_right_gray")
        intoFlagImageView.frame = CGRect(x:0,y:0,width:48,height:48)
        baseBackgroundView.addSubview(intoFlagImageView)
        intoFlagImageView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
            make.width.equalTo(8)
            make.height.equalTo(14)
        }
        bottomLine.backgroundColor = TBIThemeGrayLineColor
        baseBackgroundView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(0.5)
            make.height.equalTo(0.5)
        }
    }
    
    
    func fillDataSource(title:String,imageName:String,showLine:Bool) {
        flagImageView.image = UIImage.init(named: imageName)
        titleLabel.text = title
        bottomLine.isHidden = !showLine
    }
}

class PaymentViewOrderCell: UITableViewCell {
    
    typealias  PaymentViewOrderBlock = (String)->Void
    public var paymentViewOrderBlock:PaymentViewOrderBlock!
    private var baseBackgroundView:UIView = UIView()
    private var titleLabel:UILabel = UILabel()
    private var titleContentLabel:UILabel = UILabel()
    private var titleDetailButton:UILabel = UILabel()
    private var priceContentLabel:UILabel = UILabel()
    private var bottomLine:UILabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        setUIAutolayout()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUIAutolayout() {
        
        titleLabel.text = "订单号:"
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.adjustsFontSizeToFitWidth = true
        baseBackgroundView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
            
        }
        titleContentLabel.text = "123456789009876"
        titleContentLabel.font = UIFont.systemFont(ofSize: 13)
        titleContentLabel.adjustsFontSizeToFitWidth = true
        baseBackgroundView.addSubview(titleContentLabel)
        titleContentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
        }
        titleDetailButton.text = "详情"
        titleDetailButton.font = UIFont.systemFont(ofSize: 13)
        titleDetailButton.textColor = TBIThemeBlueColor
        titleDetailButton.addOnClickListener(target: self, action: #selector(titleDetailButtonAction(sender:)))
        
        baseBackgroundView.addSubview(titleDetailButton)
        titleDetailButton.snp.makeConstraints { (make) in
            make.left.equalTo(titleContentLabel.snp.right).offset(10)
            make.centerY.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(30)
        }
        priceContentLabel.text = "¥5500"
        priceContentLabel.font = UIFont.systemFont(ofSize: 13)
        priceContentLabel.textColor = TBIThemeOrangeColor
        priceContentLabel.textAlignment = NSTextAlignment.right
        priceContentLabel.adjustsFontSizeToFitWidth = true
        baseBackgroundView.addSubview(priceContentLabel)
        priceContentLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
        }
        
        bottomLine.backgroundColor = TBIThemeGrayLineColor
        baseBackgroundView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(0.5)
            make.height.equalTo(0.5)
        }
        
    }
    
    
    
    func titleDetailButtonAction(sender:UIButton) {
        
        print(#function,#line)
        paymentViewOrderBlock("")
        
        
    }
    func fillDataSource(orderNum:String,orderPrice:String) {
        titleContentLabel.text = orderNum
        priceContentLabel.text = "¥" + orderPrice
        
    }
    
    
    
    
    
    
}






