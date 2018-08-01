//
//  ASHTabModel.m
//  ASHEBShop
//
//  Created by xmfish on 2018/8/1.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHTabModel.h"
@implementation ASHTabItemModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{@"tab_id":@"cate_collection_id"};
}
@end

@implementation ASHTabModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{@"tab_elementArr":@"data.tab_element"};
}
@end
