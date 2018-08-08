//
//  ASHSearchContentModel.m
//  ASHEBShop
//
//  Created by xmfish on 2018/8/7.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHSearchContentModel.h"

@implementation ASHSearchContentModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{@"coupon_list":@"data.coupon_list"};
}
@end
