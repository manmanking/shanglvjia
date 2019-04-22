//
//  CoOrderTableViewCell.swift
//  shop
//
//  Created by akrio on 2017/6/8.
//  Copyright © 2017年 TBI. All rights reserved.
//

import UIKit

class CoOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var flightIconImage: UIImageView!
    @IBOutlet weak var hotelIconImage: UIImageView!
    @IBOutlet weak var orderNoLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var passengersLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bookUserLabel: UILabel!
    @IBOutlet weak var trainIconImage: UIImageView!
    @IBOutlet weak var carIconImage: UIImageView!
    
    var clickCallback:()->Void = { _ in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }
    //重写高亮
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            self.contentView.backgroundColor = UIColor(r: 0, g: 0, b: 0, alpha: 0.05)
//            self.headerView.backgroundColor = UIColor(r: 0, g: 0, b: 0, alpha: 0.2)
        }else {
            self.contentView.backgroundColor = .white
        }
    }
//    //重写选中
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        //        super.setSelected(selected, animated: animated)
//        if selected {
//            self.backgroundColor = UIColor(white: 0, alpha: 0.45)
//        }else {
//            self.backgroundColor = UIColor(white: 0, alpha: 0.25)
//        }
//    }
    
}
