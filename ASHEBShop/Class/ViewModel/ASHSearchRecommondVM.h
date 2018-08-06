//
//  ASHSearchRecommondVM.h
//  ASHEBShop
//
//  Created by xmfish on 2018/8/6.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHBaseViewModel.h"
#import "ASHSearchRecommondModel.h"
@interface ASHSearchRecommondVM : ASHBaseViewModel
@property (nonatomic, strong,readonly)ASHSearchRecommondModel* model;
@property (nonatomic, assign)NSInteger sortType;
@property (nonatomic, strong)NSString* keyWord;
@end
