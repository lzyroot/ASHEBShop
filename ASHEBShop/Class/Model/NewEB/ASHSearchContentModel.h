//
//  ASHSearchContentModel.h
//  ASHEBShop
//
//  Created by xmfish on 2018/8/7.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHBaseModel.h"
#import "ASHTopicModel.h"
@interface ASHSearchContentModel : ASHBaseModel
@property (nonatomic, strong)NSMutableArray<ASHCouponInfoModel >* coupon_list;
@end
