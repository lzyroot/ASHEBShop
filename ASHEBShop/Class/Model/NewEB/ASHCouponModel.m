//
//  ASHCouponModel.m
//  ASHEBShop
//
//  Created by xmfish on 2018/8/3.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHCouponModel.h"

@implementation ASHCouponModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{@"coupon_list":@"data.coupon_list",@"max_count":@"data.count"};
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"coupon_list" : [ASHCouponInfoModel class],};
}
@end
