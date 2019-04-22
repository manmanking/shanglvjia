//
//  ApprovalDetalBaseInfoTableViewCell.swift
//  shanglvjia
//
//  Created by manman on 2018/5/18.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit

class ApprovalDetalBaseInfoTableViewCell: UITableViewCell {
    
    
    private let baseBackgroundView:UIView = UIView()
    
    private let titleLabel:UILabel = UILabel()
    
    private let titleFlagLabel:UILabel = UILabel()
    
    private let firstLineLabel:UILabel = UILabel()
    
    private let subTitleLabel:UILabel = UILabel()
    
    private let subTitleContentLabel:UILabel = UILabel()
    
    private var baseInfoArr:[UIView] = Array()
    
    
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
    }
    
    func fillDataSources(dataSources:[(title:String,content:String,right:String)]) {
        guard dataSources.count > 0 else {
            return
        }
         _ = baseInfoArr.map{$0.removeFromSuperview()}
        
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
            tmpCell.fillDataSources(title: element.title, content: element.content, right: element.right)
            baseInfoArr.append(tmpCell)
        }
    }
    
    

    
    class ApprovalRegularCell: UIView {
        private var baseBackgroundView:UIView = UIView()
        
        private let titleLabel:UILabel = UILabel()
        private let minddleLabel:UILabel = UILabel()
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
            
            titleLabel.textColor = UIColor.gray
            titleLabel.font=UIFont.systemFont(ofSize: 15)
            baseBackgroundView.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.left.equalToSuperview().inset(15)
                make.width.equalTo(90)
            }
            
            minddleLabel.textColor = TBIThemePrimaryTextColor
            minddleLabel.textAlignment = NSTextAlignment.left
            minddleLabel.font = UIFont.systemFont(ofSize: 15)
            minddleLabel.numberOfLines = 0
            baseBackgroundView.addSubview(minddleLabel)
            minddleLabel.snp.makeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.left.equalTo(titleLabel.snp.right).offset(5)
                make.right.equalToSuperview()
            }
            
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
        
        
        func fillDataSources(title:String,content:String,right:String) {
            titleLabel.text = title
            minddleLabel.text = content
            rightLabel.text = right
            
            if title.count > 4
            {
                titleLabel.snp.updateConstraints({ (make) in
                    make.width.equalTo(140)
                })
            }
            
        }
        
        
        
    }
    
    
    
    
}
