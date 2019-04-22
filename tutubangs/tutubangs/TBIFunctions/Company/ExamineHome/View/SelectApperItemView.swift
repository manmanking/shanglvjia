//
//  SelectApperItemView.swift
//  shop
//
//  Created by akrio on 2017/6/1.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SelectApperItemView: UIView {
    let bag = DisposeBag()
    /// 审批级别文字
    @IBOutlet weak var levelLabel: UILabel!
    /// 审批人姓名文字
    @IBOutlet weak var nameLabel: UILabel!
    /// 审批人邮箱文字
    @IBOutlet weak var mailLabel: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBAction func itemClick(_ sender: UITapGestureRecognizer) {
        clickCallback(id)
    }
    var clickCallback:(_ id:String)->Void = {_ in }
    /// 唯一标示
    var id:String = ""
    func bind(item:ApperItem) {
        item.name.asObservable().bind(to: levelLabel.rx.text).addDisposableTo(bag)
        item.mail.asObservable().bind(to: mailLabel.rx.text).addDisposableTo(bag)
        item.level.asObservable().map{
            /// 审批级别描述
                var levelMap:[Int:String] = [1:"一"]
                levelMap[2] = "二"
                levelMap[3] = "三"
                levelMap[4] = "四"
                levelMap[5] = "五"
                levelMap[6] = "六"
                levelMap[7] = "七"
                levelMap[8] = "八"
                levelMap[9] = "九"
                return "\(levelMap[$0] ?? "")级审批人"
            
        }.bind(to: levelLabel.rx.text).addDisposableTo(bag)
    }
    var level:Int = 0
    func setTitle(_ level:Int) {
        var levelMap:[Int:String] = [1:"一"]
        levelMap[2] = "二"
        levelMap[3] = "三"
        levelMap[4] = "四"
        levelMap[5] = "五"
        levelMap[6] = "六"
        levelMap[7] = "七"
        levelMap[8] = "八"
        levelMap[9] = "九"
        let levelStr =  "\(levelMap[level] ?? "")级审批人"
        self.level = level
        levelLabel.text = levelStr
    }
    
    /// 单条审批人实体
    struct ApperItem {
        /// 审批级别
        let level = Variable(0)
        /// 审批人姓名
        let name  = Variable("")
        /// 审批人邮箱
        let mail = Variable("")
        init(level:Int,name:String,mail:String) {
            self.level.value = level
            self.name.value = name
            self.mail.value = mail
        }
    }
}
