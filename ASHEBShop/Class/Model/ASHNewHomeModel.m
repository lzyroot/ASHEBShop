//
//  ASHNewHomeModel.m
//  ASHEBShop
//
//  Created by xmfish on 2018/5/8.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHNewHomeModel.h"
@implementation ASHNewHomeItemModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{@"itemId":@"id"};
}
@end
@implementation ASHNewHomeModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{@"dataArr":@"reommendJa"};
}
@end
