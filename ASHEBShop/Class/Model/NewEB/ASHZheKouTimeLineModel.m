//
//  ASHZheKouTimeLineModel.m
//  ASHEBShop
//
//  Created by xmfish on 2018/8/8.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHZheKouTimeLineModel.h"
@implementation ASHZheKouTimeLineInfoModel

@end

@implementation ASHZheKouTimeLineModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{@"timeline_element":@"data.timeline_element"};
}
@end
