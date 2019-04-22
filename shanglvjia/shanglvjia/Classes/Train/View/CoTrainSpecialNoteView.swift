//
//  CoTrainSpecialNoteView.swift
//  shop
//
//  Created by TBI on 2018/1/8.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class CoTrainSpecialNoteView: UIView {
    
    fileprivate let oneCell:CoTrainSpecialNoteCellView = CoTrainSpecialNoteCellView()
    
    fileprivate let twoCell:CoTrainSpecialNoteCellView = CoTrainSpecialNoteCellView()
    
    fileprivate let threeCell:CoTrainSpecialNoteCellView = CoTrainSpecialNoteCellView()
    
    fileprivate let fourCell:CoTrainSpecialNoteCellView = CoTrainSpecialNoteCellView()
    
    fileprivate let fiveCell:CoTrainSpecialNoteCellView = CoTrainSpecialNoteCellView()
    
    fileprivate let sixCell:CoTrainSpecialNoteCellView = CoTrainSpecialNoteCellView()
    
    fileprivate let sevenCell:CoTrainSpecialNoteCellView = CoTrainSpecialNoteCellView()
    
    fileprivate let eightCell:CoTrainSpecialNoteCellView = CoTrainSpecialNoteCellView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    func initView () {
        oneCell.initView(text: "因火车票实名制购买规定，我司只为真实的消费者代购火车票，我方有权在核实购票人身份时，要求客户提供身份证复印件核实购票人的身份，购票人身份核实通过后，才能完成购票，退票及退款，否则我司不提供售后服务。票源紧张，严禁利用本网站进行囤票、占票、倒票。若您的行为违反铁路机关相关规定的，我司将主动配合公安机关进行查处。")
        addSubview(oneCell)
        oneCell.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.left.right.equalToSuperview()
        }
        twoCell.initView(text: "为方便报销，建议您凭预订时使用的有效身份证件换取纸质车票后乘车。")
        addSubview(twoCell)
        twoCell.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(oneCell.snp.bottom).offset(15)
        }
        threeCell.initView(text: "退票：自取票，若未取票且离发车时间大于35分钟可以在线申请退票；若已取票或离发车时间小于35分钟需您自行携带购票时的有效证件在发车前至火车站退票窗口办理退票。我们的在线退票申请服务时间是8:30-17:30，其余时间需您在发车前自行去火车站退票窗口办理退票。送票上门的车票则需您自行前往火车站进行退票。")
        addSubview(threeCell)
        threeCell.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(twoCell.snp.bottom).offset(15)
        }
        fourCell.initView(text: "改签：暂不提供改签，您可前往火车站办理。")
        addSubview(fourCell)
        fourCell.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(threeCell.snp.bottom).offset(15)
        }
        fiveCell.initView(text: "我司无法提供退票手续费发票，需凭有效乘车人证件原件在办理退票日起10天内自行到火车站售票窗口索取。")
        addSubview(fiveCell)
        fiveCell.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(fourCell.snp.bottom).offset(15)
        }
        sixCell.initView(text: "成功出票后您会收到我司发送的的通知短信，但因运营商网关延迟可能导致您无法及时接收短信，请到“我的订单”中跟踪出票情况。")
        addSubview(sixCell)
        sixCell.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(fiveCell.snp.bottom).offset(15)
        }
        sevenCell.initView(text: "预订完成后我们不能保证100%有票，如不能出票，我们客服会立即联系您，请您保持手机畅通，以免耽误您的出行。")
        addSubview(sevenCell)
        sevenCell.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(sixCell.snp.bottom).offset(15)
        }
        
        eightCell.initView(text: "如遇列车停运，请最晚在发车前35分钟申请退票，如果已经取出车票或者列车已过发车时间，请您务必在5日内（含出发日）前往车站退票，全款将按支付渠道退回。")
        addSubview(eightCell)
        eightCell.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(sevenCell.snp.bottom).offset(15)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CoTrainSpecialNoteCellView: UIView {
    
    fileprivate  let imgLabel = UILabel()
    
    fileprivate  let textLabel = UILabel(text: "", color: TBIThemePrimaryTextColor, size: 14)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func initView (text:String) {
        imgLabel.layer.masksToBounds = true
        imgLabel.layer.cornerRadius = 2.5
        imgLabel.backgroundColor = TBIThemeBlueColor
        textLabel.text = text
        textLabel.numberOfLines = 0
        addSubview(imgLabel)
        imgLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(8)
            make.width.height.equalTo(5)
        }
        addSubview(textLabel)
        textLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.right.equalTo(-15)
            make.left.equalTo(imgLabel.snp.right).offset(13)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CoNoTrainsView: UIView {
    
    private var baseBackgroundView:UIView = UIView()
    
    fileprivate  let textLabel = UILabel(text: "该日期次车不运行", color: TBIThemeWhite, size: 14)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        textLabel.layer.cornerRadius = 5
        textLabel.clipsToBounds = true
        textLabel.textAlignment = .center
        textLabel.backgroundColor = TBIThemeBackgroundViewColor
        baseBackgroundView.addSubview(textLabel)
        textLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(213)
        }
        baseBackgroundView.addOnClickListener(target: self, action:  #selector(click(tap:)))
    }
    
    func click(tap:UITapGestureRecognizer){
        self.removeFromSuperview()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

