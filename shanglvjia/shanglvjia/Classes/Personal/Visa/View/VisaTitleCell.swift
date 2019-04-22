//
//  VisaTitleCell.swift
//  shanglvjia
//
//  Created by tbi on 2018/7/18.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class VisaTitleCell: UITableViewCell {

    var titleLabel = UILabel.init(text: "", color: PersonalThemeMajorTextColor, size: 16)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = TBIThemeWhite
        self.selectionStyle = UITableViewCellSelectionStyle.none
        creatCellUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func creatCellUI() {
        self.addSubview(titleLabel)
        titleLabel.numberOfLines = 0
        titleLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(13)
            make.left.right.equalToSuperview().inset(15)
        }
    }
    
    func fillDataSources(visaName:String) {
       
        do{
            let attrStr = try NSAttributedString(data:visaName.data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
            
             titleLabel.attributedText = attrStr
        }catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    
}
