//
//  UIButton+EnlargeTouchArea.h
//  shop
//
//  Created by manman on 2017/6/1.
//  Copyright © 2017年 zhangwangwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (EnlargeTouchArea)


- (void) setEnlargeEdgeWithTop:(CGFloat) top left:(CGFloat) left bottom:(CGFloat) bottom right:(CGFloat) right;

- (void)setEnlargeEdge:(CGFloat) size;

@end
