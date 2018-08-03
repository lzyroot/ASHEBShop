//
//  ASHCategoryModel.m
//  ASHEBShop
//
//  Created by xmfish on 2018/8/1.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHCategoryModel.h"
@implementation ASHCategoryItemModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{@"name":@"time"};
}
@end

@implementation ASHCategoryModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{@"zhekou_index_banner":@"data.zhekou_index_banner",@"zhekou_index_timeline":@"data.zhekou_index_timeline",@"zhekou_index_fixed_ad":@"data.zhekou_index_fixed_ad",@"zhekou_cate_banner":@"data.zhekou_cate_banner",@"zhekou_cate_timeline":@"data.zhekou_cate_timeline",@"zhekou_cate_minipic":@"data.zhekou_cate_minipic"};
}
@end
