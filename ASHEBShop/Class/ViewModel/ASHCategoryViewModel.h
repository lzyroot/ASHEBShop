//
//  ASHCategoryViewModel.h
//  ASHEBShop
//
//  Created by xmfish on 2018/8/1.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHBaseViewModel.h"
#import "ASHCategoryModel.h"
@interface ASHCategoryViewModel : ASHBaseViewModel
@property (nonatomic, strong, readonly)ASHCategoryModel* model;
@property (nonatomic, assign)NSInteger categoryId;
@end
