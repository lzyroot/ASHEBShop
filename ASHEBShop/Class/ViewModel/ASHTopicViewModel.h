//
//  ASHTopicViewModel.h
//  ASHEBShop
//
//  Created by xmfish on 2018/8/2.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHBaseViewModel.h"
#import "ASHTopicModel.h"
@interface ASHTopicViewModel : ASHBaseViewModel
@property (nonatomic, strong, readonly)ASHTopicModel* model;
@property (nonatomic, assign)NSInteger sortType;//默认7
@property(nonatomic, assign)NSInteger categoryId;
@end
