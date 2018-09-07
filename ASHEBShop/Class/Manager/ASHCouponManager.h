//
//  ASHCouponManager.h
//  ASHEBShop
//
//  Created by xmfish on 2018/9/6.
//  Copyright © 2018年 ash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASHCartInfoModel.h"
@interface ASHCouponManager : NSObject
@property(nonatomic, strong)NSMutableArray* couponArr;//
+ (instancetype)shareInstance;

- (BOOL)hasCacheCoupon:(NSInteger)num_iid;
- (void)saveCacheWithID:(NSInteger)num_iid withModel:(ASHCartDetailModel*)model;
- (void)addCouponWithID:(NSInteger)num_iid withModel:(ASHCartDetailModel*)model;

- (NSInteger)totalPrice;
@end
