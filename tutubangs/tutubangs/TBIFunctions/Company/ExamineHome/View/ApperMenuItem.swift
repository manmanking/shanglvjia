//
//  ApperMenuItem.swift
//  shop
//
//  Created by akrio on 2017/6/2.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class ApperMenuItem: UIView {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var selectImage: UIImageView!
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
}
