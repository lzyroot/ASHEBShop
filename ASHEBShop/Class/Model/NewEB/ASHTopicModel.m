//
//  ASHTopicModel.m
//  ASHEBShop
//
//  Created by xmfish on 2018/8/2.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHTopicModel.h"
@implementation ASHCouponInfoModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{@"mydescription":@"description"};
}

@end
//
@implementation ASHTopicItemModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{@"mydescription":@"description"};
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{ @"coupon_info" : [ASHCouponInfoModel class]};
}
- (void)setCoupon_info:(ASHCouponInfoModel *)coupon_info
{
    _coupon_info = coupon_info;
}
@end
@implementation ASHTopicModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{@"topic_list":@"data.topic_list",@"max_count":@"data.count"};
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"topic_list" : [ASHTopicItemModel class],};
}
@end
