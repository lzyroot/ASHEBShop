//
//  ASHTabCategoryView.h
//  ASHEBShop
//
//  Created by xmfish on 2018/8/1.
//  Copyright © 2018年 ash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASHCategoryModel.h"
@interface ASHTabCategoryView : UIView
@property(copy,nonatomic)void(^categoryIndexAction)(NSInteger index);
@property(copy,nonatomic)void(^closeAction)(void);
+ (ASHTabCategoryView*)show;

- (instancetype)initWithCategoryArr:(NSArray<ASHCategoryItemModel>*)categoryArr;
@end
