//
//  TBIPaymentHeaderView.swift
//  shop
//
//  Created by manman on 2017/9/20.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class TBIPaymentHeaderView: UITableViewHeaderFooterView {

    typealias TBIPaymentHeaderViewRemainEndBlcok = ()->Void
    public var paymentHeaderViewRemainEndBlcok:TBIPaymentHeaderViewRemainEndBlcok!
    public var productTypePayment:ProductTypePayment = ProductTypePayment.Default
    
    
    private var baseBackgroundView:UIView = UIView()
    private var subBaseBackgroundView:UIView = UIView()
    private var subTipInfoBackgroundView:UIView = UIView()
    private var tipTitleLabel:UILabel = UILabel()
    private var tipTitleContentLabel:UILabel = UILabel()
    public var shutDownTime:Timer!
    fileprivate var shutDownInt:Int = 0
    
    fileprivate var timeInterval:TimeInterval = 1.0 //默认设置 时间间隔 1.0 秒
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = TBIThemeBaseColor
        self.contentView.addSubview(baseBackgroundView)
        baseBackgroundView.backgroundColor = TBIThemeBlueColor
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
        }
        
        setUIViewAutolayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
   
    
    func setUIViewAutolayout()  {
        
        subBaseBackgroundView.backgroundColor = TBIThemeBlueColor
        baseBackgroundView.addSubview(subBaseBackgroundView)
        subBaseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        drawCircleView(radius: 75, borderColor:UIColor.white, borderWidth:3 , alpha: 0.3)
        drawCircleView(radius: 80, borderColor:UIColor.white, borderWidth: 1 , alpha: 1)
        
        
        tipTitleContentLabel.text = "00:00"
        tipTitleContentLabel.textColor = UIColor.white
        tipTitleContentLabel.textAlignment = NSTextAlignment.center
        tipTitleContentLabel.font = UIFont.systemFont(ofSize: 40)
        subBaseBackgroundView.addSubview(tipTitleContentLabel)
        tipTitleContentLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
            make.centerY.equalToSuperview().inset(-20)
        }
        
        
        tipTitleLabel.text = "支付剩余时间"
        tipTitleLabel.textAlignment = NSTextAlignment.center
        tipTitleLabel.textColor = UIColor.white
        subBaseBackgroundView.addSubview(tipTitleLabel)
        tipTitleLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(30)
        }
        
        
        
        
        
    }
    
    // 试试 可以写出几种 画圆的方式
    //第一种方式 用label 切圆角
    func drawCircleView(radius:CGFloat,borderColor:UIColor ,borderWidth:CGFloat,alpha:CGFloat) {
        let circleView:UIView = UIView()
        circleView.alpha = alpha
        circleView.layer.borderColor = UIColor.white.cgColor
        circleView.layer.cornerRadius = radius
        circleView.layer.borderWidth = borderWidth
        subBaseBackgroundView.addSubview(circleView)
        circleView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().inset(-20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(2 * radius)
        }
    }
    
    func fillDataSource(remainTime:NSInteger) {
        
       
        //tipTitleContentLabel.text = convertMinute(number: remainTime)
        switch productTypePayment {
        case ProductTypePayment.Flight:
            timeInterval = 1.0
        case ProductTypePayment.Travel,ProductTypePayment.Special:
            timeInterval = 60.0
        default:
            break
        }
        
        shutDownTime = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(shutDownStart(timer:)), userInfo: "", repeats: true)
        
        if shutDownInt == 0 {
            shutDownInt = remainTime
        }else
        {
            shutDownInt -= remainTime
        }
        
        
        print("remainTime",shutDownInt)
        shutDownRegular()
    }
    
    func convertTimeUnit(number:NSInteger) -> String {
        let minuter:NSInteger = number / 60
        let second:NSInteger = number % 60
        let result:String = minuter.description + ":" + second.description
        return result
    }
    
    func shutDownRegular() {
        
        
        shutDownTime.fire()
    }
    
    func shutDownStart(timer:Timer) {
        //printDebugLog(message: "second \(self.shutDownInt)")
        self.shutDownInt -= 1
        guard self.shutDownInt > 0 else {
        
            shutDownTime.invalidate()
            paymentHeaderViewRemainEndBlcok()
            return
        }
        tipTitleContentLabel.text = convertTimeUnit(number: shutDownInt)
    }

}
