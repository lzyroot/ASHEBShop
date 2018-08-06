//
//  ASHSearchRecommondModel.m
//  ASHEBShop
//
//  Created by xmfish on 2018/8/6.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHSearchRecommondModel.h"

@implementation ASHSearchRecommondModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{@"rec_word_list":@"data.rec_word_list"};
}
@end
