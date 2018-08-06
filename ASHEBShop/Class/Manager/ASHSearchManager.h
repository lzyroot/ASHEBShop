//
//  ASHSearchManager.h
//  ASHEBShop
//
//  Created by xmfish on 2018/8/6.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHShareInstace.h"
#import "ASHSearchModel.h"
@interface ASHSearchManager : ASHShareInstace
+ (instancetype)shareInstance;

@property(nonatomic, readonly,strong)ASHSearchModel* model;
@property(nonatomic, readonly,strong)NSArray* historyTags;

- (void)searchWithKey:(NSString*)key;
- (void)clearHistory;
@end
