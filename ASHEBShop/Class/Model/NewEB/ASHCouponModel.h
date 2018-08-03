//
//  ASHCouponModel.h
//  ASHEBShop
//
//  Created by xmfish on 2018/8/3.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHBaseModel.h"
#import "ASHTopicModel.h"
@interface ASHCouponModel : ASHBaseModel
@property (nonatomic, strong)NSMutableArray<ASHCouponInfoModel >* coupon_list;
@property (nonatomic, assign)NSInteger max_count;
@end
