//
//  SelectItemView.swift
//  shop
//
//  Created by akrio on 2017/6/7.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class SelectItemView: UIView {

    @IBAction func itemClick(_ sender: UITapGestureRecognizer) {
        clickCallback(id)
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var selectImage: UIImageView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var clickCallback:(_ id:String)->Void = {_ in }
    /// 唯一标示
    var id:String = ""
}
