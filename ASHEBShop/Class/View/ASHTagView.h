//
//  ASHTagView.h
//  ASHEBShop
//
//  Created by xmfish on 2018/8/6.
//  Copyright © 2018年 ash. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASHTagView : UIView
@property(nonatomic,assign)CGFloat tagHeight;
- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray withTextColor:(UIColor*)textColor borderColor:(UIColor*)borderColor;

@property(copy,nonatomic)void(^tagIndexAction)(NSInteger index);
@end
