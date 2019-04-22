//
//  TBICollectionViewCell.m
//  TBICalendar
//
//  Created by manman on 17/4/29.
//  Copyright © 2017年 Apress. All rights reserved.
//

#import "TBICollectionViewCell.h"
#import "Masonry.h"


#define CellDefaultAlpha = 1.0

@interface TBICollectionViewCell()


@property (strong, nonatomic) UIView  *backgroundView;

@property (strong, nonatomic) UIView  *subBackgroundView;





@end



@implementation TBICollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //默认设置为为选中状态
        self.isSelected = false;
        self.isToday = false;
        self.isActivity = true;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.backgroundView = [[UIView alloc]init];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.backgroundView];
        [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.left.bottom.right.equalTo(self.contentView);
            
        }];
        
        
        
        self.subBackgroundView = [[UIView alloc]init];
        self.subBackgroundView.backgroundColor = [UIColor whiteColor];
        [self.backgroundView addSubview:self.subBackgroundView];
        [self.subBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.left.bottom.right.equalTo(self.contentView);
            
        }];
        
        
        
        [self setUIViewAutolayout];
        
        
    }
    return self;
}


-(void)setUIViewAutolayout
{
    
    
    _imageView = [[UIImageView alloc]init];
    _imageView.image = [UIImage imageNamed:@"today"];
    //_imageView.backgroundColor = [UIColor whiteColor];
    //今天 图片的布局
    [self.backgroundView addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subBackgroundView.mas_top).with.offset(5);
        make.right.equalTo(self.subBackgroundView.mas_right).with.offset(-5);
        make.width.equalTo(@12);
        make.height.equalTo(@12);
        
        
        
    }];
    
    _titleLabel = [[UILabel alloc]init ];//WithFrame:CGRectMake(0, 0, 40, 40)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    _titleLabel.textColor = [UIColor whiteColor];
    [self.backgroundView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.top.left.right.equalTo(self.subBackgroundView);
        make.bottom.equalTo(self.subBackgroundView.mas_bottom).with.offset(-10);
    }];
    _subtitleLabel = [[UILabel alloc]init];
    _subtitleLabel.textAlignment = NSTextAlignmentCenter;
    _subtitleLabel.textColor = [UIColor whiteColor];
    [self.backgroundView addSubview:_subtitleLabel];
    [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.right.equalTo(self.subBackgroundView);
        make.bottom.equalTo(self.subBackgroundView.mas_bottom);
        
        
    }];
    
}



- (void)configAppearanceTitle:(NSString *)titleStr andSubtitleStr:(NSString *)subTitleStr andSubbackgroundAlpha:(CGFloat)alpha
{
    
    
    [self setCellStateAutolayout:self.isSelected];
    _titleLabel.text = titleStr;
    _subtitleLabel.text = subTitleStr;
    
    if (self.isToday) {
        self.imageView.hidden = !self.isToday;
        if (!self.isSelected) {
            self.subBackgroundView.backgroundColor = [UIColor whiteColor];    
        }
        
    }else
    {
        _imageView.hidden = !self.isToday;
        
    }
   
    if (alpha != 1.0) {
        self.subBackgroundView.alpha = alpha;
    }else
    {
        self.subBackgroundView.alpha = 1.0;
    }
    
    if (!self.isActivity) {
        _titleLabel.textColor = [UIColor grayColor];
    }else
    {
        _titleLabel.textColor = [UIColor blackColor];
    }
    
    
   
    
}

//空白样式
- (void)setCellTypeNone
{
    _subBackgroundView.backgroundColor = [UIColor whiteColor];
    _subBackgroundView.alpha = 1.0;
    _titleLabel.text = @"";
    _subtitleLabel.text = @"";
    _imageView.hidden = true;
}

- (void)setCellTypePlaceHolder:(NSString *) titleStr
{
    
    _subBackgroundView.backgroundColor = [UIColor whiteColor];
    _subBackgroundView.alpha = 1.0;
    _titleLabel.text = titleStr;
    _titleLabel.textColor = [UIColor grayColor];
    _subtitleLabel.text = @"";
    _imageView.hidden = true;
    
}



- (void)setCellStateAutolayout:(BOOL) selected
{
    if (selected) {
        self.subBackgroundView.backgroundColor = [UIColor colorWithRed:70/255.0 green:162/255.0 blue:255/255.0 alpha:1];
        self.subBackgroundView.alpha = 1;
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        self.subtitleLabel.hidden = !selected;
        self.subtitleLabel.textColor = [UIColor whiteColor];
        self.subtitleLabel.font = [UIFont systemFontOfSize:11];
        
    }else
    {
        self.subBackgroundView.backgroundColor = [UIColor whiteColor];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        self.subtitleLabel.hidden = !selected;
   
    }
  
    
}



@end
