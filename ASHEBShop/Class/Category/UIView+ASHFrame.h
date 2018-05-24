//
//  UIView+ASHFrame.h
//  ASHEBShop
//
//  Created by xmfish on 2018/5/17.
//  Copyright © 2018年 ash. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ASHFrame)

@property (nonatomic) CGFloat ash_left;

@property (nonatomic) CGFloat ash_top;

@property (nonatomic) CGFloat ash_right;

@property (nonatomic) CGFloat ash_bottom;

@property (nonatomic) CGFloat ash_width;

@property (nonatomic) CGFloat ash_height;

@property (nonatomic) CGFloat ash_centerX;

@property (nonatomic) CGFloat ash_centerY;

@property (nonatomic) CGPoint ash_origin;

@property (nonatomic) CGSize ash_size;

@property (nonatomic, readonly) CGPoint ash_selfcenter;

@end
