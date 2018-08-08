//
//  ASHSearchContentVM.h
//  ASHEBShop
//
//  Created by xmfish on 2018/8/7.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHBaseViewModel.h"
@class ASHSearchContentModel;
@interface ASHSearchContentVM : ASHBaseViewModel
@property (nonatomic, strong,readonly)ASHSearchContentModel* model;
@property (nonatomic, assign)NSInteger sortType;
@property (nonatomic, strong)NSString* keyWord;
@end
