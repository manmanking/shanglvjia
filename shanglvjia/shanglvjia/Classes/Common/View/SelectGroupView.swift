//
//  SelectGroupView.swift
//  shop
//
//  Created by akrio on 2017/6/4.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit
import SnapKit

class SelectGroupView: UIView {

    @IBAction func click(_ sender: UITapGestureRecognizer) {
        self.removeFromSuperview()
    }
    @IBAction func cancelClick(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var spiltLineView: UIView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var scrollerView: UIScrollView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    var bottomHeight:Float {
        return Float(cancelButton.frame.height + spiltLineView.frame.height)
    }
}
