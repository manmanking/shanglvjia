//
//  ApprovalDetailChargeTableViewCell.swift
//  shanglvjia
//
//  Created by manman on 2018/5/21.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class ApprovalDetailChargeTableViewCell: UITableViewCell {

   
    private let baseBackgroundView:UIView = UIView()
    
    private let titleLabel:UILabel = UILabel()
    
    private let titleFlagLabel:UILabel = UILabel()
    
    private let firstLineLabel:UILabel = UILabel()
    
    private let titleContentLabel:UILabel = UILabel()
    
    private let subTitleLabel:UILabel = UILabel()
    
    private let subTitleContentLabel:UILabel = UILabel()
    
    private var baseInfoArr:[UIView] = Array()
    
    private var amountLabel:UILabel = UILabel()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = TBIThemeBaseColor
        baseBackgroundView.backgroundColor = TBIThemeWhite
        self.contentView.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(5)
        }
        setUIAutolayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUIAutolayout() {
        
        titleFlagLabel.backgroundColor = TBIThemeDarkBlueColor
        baseBackgroundView.addSubview(titleFlagLabel)
        titleFlagLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(5)
            make.left.equalToSuperview()
            make.width.equalTo(3)
            make.height.equalTo(33)
        }
        titleLabel.textColor = TBIThemePrimaryTextColor
        titleLabel.text = "费用明细"
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textAlignment = NSTextAlignment.left
        baseBackgroundView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleFlagLabel)
            make.height.equalTo(33)
            make.right.equalToSuperview()
            make.left.equalToSuperview().inset(15)
        }
        
        firstLineLabel.backgroundColor = TBIThemeGrayLineColor
        baseBackgroundView.addSubview(firstLineLabel)
        firstLineLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.height.equalTo(1)
        }
        
//        amountLabel.textColor = TBIThemePrimaryTextColor
//        amountLabel.font = UIFont.systemFont(ofSize: 15)
//        baseBackgroundView.addSubview(amountLabel)
//        amountLabel.snp.makeConstraints { (make) in
//            make.right.equalToSuperview().inset(15)
//            make.height.equalTo(44)
//        }
    }
    
    
    
    func fillDataSources(dataSources:[(title: String, content: String, right: String)]) {
        _ = baseInfoArr.map{$0.removeFromSuperview()}
        guard dataSources.count > 1 else {
            return
        }
        titleLabel.text = dataSources.first?.title
        let topMargin:NSInteger = 44
        var viewY:NSInteger = 0
        for index in  1...dataSources.count - 1 {
            let element = dataSources[index]
            viewY = index * topMargin
            let tmpCell:ApprovalRegularCell = ApprovalRegularCell()
            baseBackgroundView.addSubview(tmpCell)
            tmpCell.snp.makeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.top.equalToSuperview().inset(viewY)
                make.height.equalTo(44)
            }
            var isLast:Bool = false
            if index == dataSources.count - 1 {
                isLast = true
            }
            
            tmpCell.fillDataSources(title: element.title, content: element.content, right: element.right, isLast:isLast)
            baseInfoArr.append(tmpCell)
        }
//        amountLabel.text = dataSources.last?.right
//        amountLabel.snp.remakeConstraints { (make) in
//            make.left.right.equalToSuperview().inset(15)
//            make.height.equalTo(44)
//            make.top.equalToSuperview().inset(topMargin * dataSources.count)
//        }
//
        
    }
    
    
    

    
    class ApprovalRegularCell: UIView {
        private var baseBackgroundView:UIView = UIView()
        
        private let titleLabel:UILabel = UILabel()
//        private let minddleLabel:UILabel = UILabel()
        private let rightLabel:UILabel = UILabel()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.addSubview(baseBackgroundView)
            baseBackgroundView.backgroundColor = TBIThemeWhite
            baseBackgroundView.snp.makeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.left.right.equalToSuperview()
            }
            setUIViewAutolayout()
        }
        
        
        func setUIViewAutolayout() {
            
            titleLabel.textColor = TBIThemePrimaryTextColor
            titleLabel.font=UIFont.systemFont(ofSize: 15)
            baseBackgroundView.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.left.equalToSuperview().inset(15)
                make.width.equalTo(400)
            }
            
//            minddleLabel.textColor = TBIThemePrimaryTextColor
//            minddleLabel.textAlignment = NSTextAlignment.left
//            minddleLabel.font = UIFont.systemFont(ofSize: 13)
//            minddleLabel.numberOfLines = 0
//            baseBackgroundView.addSubview(minddleLabel)
//            minddleLabel.snp.makeConstraints { (make) in
//                make.top.bottom.equalToSuperview()
//                make.left.equalTo(titleLabel.snp.right).offset(5)
//                make.right.equalToSuperview()
//            }
            
            rightLabel.textColor = TBIThemeOrangeColor
            rightLabel.textAlignment = NSTextAlignment.right
            rightLabel.font = UIFont.systemFont(ofSize: 13)
            baseBackgroundView.addSubview(rightLabel)
            rightLabel.snp.makeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.right.equalToSuperview().inset(15)
                make.width.equalTo(100)
            }
            
            
        }
        
        
        
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        
        func fillDataSources(title:String,content:String,right:String,isLast:Bool) {
            titleLabel.text = title
//            minddleLabel.text = content
            rightLabel.text = right
            if content.isEmpty == true {
                titleLabel.snp.remakeConstraints { (update) in
                    update.top.bottom.equalToSuperview()
                    update.left.equalToSuperview().inset(15)
                    update.width.equalTo(400)
                }
            }else {
                titleLabel.snp.remakeConstraints { (make) in
                    make.top.bottom.equalToSuperview()
                    make.left.equalToSuperview().inset(15)
                    make.width.equalTo(400)
                }
            }
            if isLast == true {
                rightLabel.attributedText =  richText(text: right)
            }
            
            
        }
        
        
        func richText(text:String) ->NSMutableAttributedString {
            let attributedStrM : NSMutableAttributedString = NSMutableAttributedString()
            let preText:NSAttributedString = NSAttributedString(string: "总价   ", attributes: [NSForegroundColorAttributeName:TBIThemePrimaryTextColor, NSFontAttributeName:UIFont.boldSystemFont(ofSize: 16.0)])
            let priceText:NSAttributedString = NSAttributedString(string: text, attributes: [NSForegroundColorAttributeName : TBIThemeOrangeColor, NSFontAttributeName : UIFont.systemFont(ofSize: 18.0)])
            attributedStrM.append(preText)
            attributedStrM.append(priceText)
            return attributedStrM
        }
        
        
        
    }
    
    
    
}
