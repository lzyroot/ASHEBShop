//
//  ASHNewHomeViewModel.h
//  ASHEBShop
//
//  Created by xmfish on 2018/5/17.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHBaseViewModel.h"
#import "ASHNewHomeModel.h"

@interface ASHNewHomeViewModel : ASHBaseViewModel
@property (nonatomic, strong, readonly)ASHNewHomeModel* model;
@property (nonatomic, assign, readonly)NSInteger dataCount;

- (ASHNewHomeItemModel*)modelIndex:(NSInteger)index;
@end
