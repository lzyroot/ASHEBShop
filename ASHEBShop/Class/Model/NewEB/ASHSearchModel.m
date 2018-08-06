//
//  ASHSearchModel.m
//  ASHEBShop
//
//  Created by xmfish on 2018/8/6.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHSearchModel.h"
@implementation ASHSearchInfoModel
@end
@implementation ASHSearchModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{@"search_hot_word":@"data.search_hot_word"};
}

@end
