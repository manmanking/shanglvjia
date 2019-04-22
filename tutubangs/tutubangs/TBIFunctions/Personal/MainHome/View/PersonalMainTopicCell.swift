//
//  PersonalMainTopicCell.swift
//  tutubangs
//
//  Created by tbi on 2018/10/22.
//  Copyright © 2018 manman. All rights reserved.
//

import UIKit

class PersonalMainTopicCell: UITableViewCell {

    typealias SelectRowIndexClickBlock = (Int,String) ->Void
    var selectRowIndexClickBlock:SelectRowIndexClickBlock!
    
    private let bgView:UIView = UIView()
    private let allViewButton = UIButton.init()
    private let titleLabel = UILabel.init(text: "", color: PersonalThemeMajorTextColor, size: 15)
    private let desLabel = UILabel.init(text: "", color: PersonalThemeMinorTextColor, size: 13)
    private let allviewLabel = UILabel.init(text: "全景介绍", color: PersonalThemeMajorTextColor, size: 13)
    private let allImageView = UIImageView.init(imageName: "button_panoramic_introduction")
    private let traingleImageView = UIImageView.init(imageName: "up_traingle")
    
    private let productButton = UIButton.init()
    private let productImage = UIImageView.init()
    private let productTitleLabel = UILabel.init(text: "", color: PersonalThemeMajorTextColor, size: 15)
    private let productSubTitleLabel = UILabel.init(text: "", color: PersonalThemeMinorTextColor, size: 13)
    private let productMoneyTitleLabel = UILabel.init(text: "", color: PersonalThemeRedColor, size: 20)
    
    private let moreButton = UIButton.init(title: "  查看更多  ", titleColor: PersonalThemeMinorTextColor, titleSize: 15)
    fileprivate var rowIndexPath = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.backgroundColor = TBIThemeBaseColor
        self.selectionStyle = .none
        initView()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initView(){
        bgView.backgroundColor = TBIThemeWhite
        self.addSubview(bgView)
        
        bgView.addSubview(allViewButton)
        bgView.addSubview(productButton)
        bgView.addSubview(moreButton)
        
        bgView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        allViewButton.adjustsImageWhenHighlighted = false
        allViewButton.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(130)
        }
        allViewButton.addSubview(titleLabel)
        allViewButton.addSubview(desLabel)
        allViewButton.addSubview(allviewLabel)
        allViewButton.addSubview(allImageView)
        allViewButton.addSubview(traingleImageView)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(30)
            make.height.equalTo(25)
        }
        desLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom)
            make.height.equalTo(17)
        }
        allImageView.snp.makeConstraints { (make) in
            make.width.equalTo(80)
            make.left.equalTo(titleLabel)
            make.height.equalTo(25)
            make.top.equalTo(desLabel.snp.bottom).offset(8)
        }
        allviewLabel.textAlignment = .center
        allviewLabel.snp.makeConstraints { (make) in
            make.width.equalTo(80)
            make.left.equalTo(titleLabel)
            make.height.equalTo(25)
            make.top.equalTo(desLabel.snp.bottom).offset(8)
        }
        traingleImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(20)
            make.height.equalTo(10)
        }
        
        productButton.snp.makeConstraints { (make) in
            make.top.equalTo(allViewButton.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(100)
        }
        productButton.addSubview(productImage)
        productButton.addSubview(productTitleLabel)
        productButton.addSubview(productSubTitleLabel)
        productButton.addSubview(productMoneyTitleLabel)
        
        productImage.layer.cornerRadius = 2.0
        productImage.clipsToBounds = true
        productImage.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(30)
            make.top.equalToSuperview().inset(15)
            make.width.equalTo(150)
            make.height.equalTo(88)
        }
        productTitleLabel.numberOfLines = 1
        productTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(productImage.snp.right).offset(15)
            make.right.equalToSuperview().inset(15)
            make.top.equalTo(productImage).offset(8)
        }
        productSubTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(productImage.snp.right).offset(15)
            make.right.equalToSuperview().inset(15)
            make.top.equalTo(productTitleLabel.snp.bottom).offset(8)
        }
        productMoneyTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(productSubTitleLabel)
            make.right.equalToSuperview().inset(15)
            make.bottom.equalTo(productImage.snp.bottom).inset(5)
        }
        
        moreButton.layer.cornerRadius = 2.0
        moreButton.layer.borderWidth = 0.5
        moreButton.layer.borderColor = PersonalThemeMajorTextColor.cgColor
        moreButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(productButton.snp.bottom).offset(20)
            make.height.equalTo(30)
            make.bottom.equalToSuperview().inset(22)
        }
        allViewButton.addTarget(self, action: #selector(allViewButtonClick), for: UIControlEvents.touchUpInside)
        productButton.addTarget(self, action: #selector(productButtonClick), for: UIControlEvents.touchUpInside)
        moreButton.addTarget(self, action: #selector(moreButtonClick), for: UIControlEvents.touchUpInside)
        
    }
    func fillData(rowIndex:NSInteger,model:PersonalTopicModel){
        rowIndexPath = rowIndex
        
        if rowIndexPath == 2{
            allViewButton.setBackgroundImage(UIImage(named:"singapore_panoramic_introduction"), for: .normal)
            titleLabel.text = "丰田员工心想狮城之旅"
            desLabel.text = "来自新加坡旅游局的热忱推荐"
        }else{
            allViewButton.setBackgroundImage(UIImage(named:"japan_panoramic_introduction"), for: .normal)
            titleLabel.text = "丰田员工日本完美假期"
            desLabel.text = "来自日本旅游局的独家推荐"
        }
        let encodedStr = model.image.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        let url = URL.init(string: encodedStr!)
        
        productImage.sd_setImage(with: url, placeholderImage: UIImage(named:"bg_default_travel"))
        productTitleLabel.text = model.contentName
        productSubTitleLabel.text = model.sideName
        productMoneyTitleLabel.text = "¥" + model.price
    }
    func allViewButtonClick(){
        if selectRowIndexClickBlock != nil{
            selectRowIndexClickBlock(rowIndexPath,"allView")
        }
    }
    func productButtonClick(){
        if selectRowIndexClickBlock != nil{
            selectRowIndexClickBlock(rowIndexPath,"product")
        }
    }
    func moreButtonClick(){
        if selectRowIndexClickBlock != nil{
            selectRowIndexClickBlock(rowIndexPath,"more")
        }
    }
}
