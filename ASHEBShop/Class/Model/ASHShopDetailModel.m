//
//  ASHShopDetailModel.m
//  ASHEBShop
//
//  Created by xmfish on 2018/5/21.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHShopDetailModel.h"
@implementation ASHShopDetailItemModel
@end
@implementation ASHShopDetailModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{@"contentArr":@"reommend.content",@"title":@"reommend.title",@"desc":@"reommend.desc",@"imageUrl":@"reommend.imageUrl"};
}
@end
