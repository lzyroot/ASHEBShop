//
//  ASHShopDetailViewModel.h
//  ASHEBShop
//
//  Created by xmfish on 2018/5/21.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHBaseViewModel.h"
#import "ASHShopDetailModel.h"
@interface ASHShopDetailViewModel : ASHBaseViewModel

@property (nonatomic, assign)NSInteger itemId;
@property (nonatomic, strong, readonly)ASHShopDetailModel* model;
@property (nonatomic, assign, readonly)NSInteger dataCount;

- (ASHShopDetailItemModel*)modelIndex:(NSInteger)index;

- (void)requestData;

- (void)requestParise;
@end
