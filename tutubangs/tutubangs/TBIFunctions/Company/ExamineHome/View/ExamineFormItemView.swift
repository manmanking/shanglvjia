//
//  ExamineFormItemView.swift
//  shop
//
//  Created by akrio on 2017/6/1.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class ExamineFormItemView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        textField.borderStyle = .none
    }
}
