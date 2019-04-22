//
//  SelectReasonItemView.swift
//  shop
//
//  Created by akrio on 2017/6/7.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class SelectReasonItemView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBAction func textClick(_ sender: UITextField) {
        textClickCallback(id,value)
    }

    @IBAction func itemClick(_ sender: UITapGestureRecognizer) {
        textClickCallback(id,value)
    }

    var id:String = ""
    var value:String = ""
    var textClickCallback:(String,String) -> Void = {_ in }
}
