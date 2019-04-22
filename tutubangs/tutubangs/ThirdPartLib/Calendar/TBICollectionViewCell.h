//
//  TBICollectionViewCell.h
//  TBICalendar
//
//  Created by manman on 17/4/29.
//  Copyright © 2017年 Apress. All rights reserved.
//




#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, SelectionType) {
    SelectionTypeNone,
    SelectionTypeSelected,
    SelectionTypeLeftBorder,
    SelectionTypeMiddle,
    SelectionTypeRightBorder
};


typedef NS_ENUM(NSUInteger, TBICalendarMonthPosition);


@interface TBICollectionViewCell : UICollectionViewCell


#pragma mark - Public properties



/**
 The day text label of the cell
 */
@property (strong, nonatomic) UILabel  *titleLabel;

// 是否被选中
@property (assign, nonatomic) BOOL      isSelected;

// 是否为今天
@property (assign, nonatomic) BOOL      isToday;

//是否可以响应事件
@property (assign, nonatomic) BOOL      isActivity;



/**
 The subtitle label of the cell
 */
@property (strong, nonatomic) UILabel  *subtitleLabel;

/**
 The bottom Line label of the cell
 */
@property (strong, nonatomic) UILabel  *bottomLineLabel;

/**
 The imageView below shape layer of the cell
 */
@property (strong, nonatomic) UIImageView *imageView;

@property (assign, nonatomic, getter=isPlaceholder) BOOL placeholder;


@property (assign, nonatomic) TBICalendarMonthPosition monthPosition;




//- (void)configAppearance:(UIColor) subBackgroundViewColor andTitle:()



//空白样式
- (void)setCellTypeNone;

- (void)configAppearanceTitle:(NSString *)titleStr andSubtitleStr:(NSString *)subTitleStr andSubbackgroundAlpha:(CGFloat) alpha;




@end
