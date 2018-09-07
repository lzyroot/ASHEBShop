//
//  ASHCouponManager.m
//  ASHEBShop
//
//  Created by xmfish on 2018/9/6.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHCouponManager.h"
#import <YYCache.h>
@implementation ASHCouponManager

+ (instancetype)shareInstance {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        self.couponArr = [NSMutableArray array];
    }
    return self;
}
- (BOOL)hasCacheCoupon:(NSInteger)num_iid{
    YYCache* cache = [YYCache cacheWithName:kASH_CART_CACHE_PATH];
    NSString* stinrgKey = [NSString stringWithFormat:@"%ld",num_iid];
    ASHCartDetailModel* model = [cache objectForKey:stinrgKey];
    if (model) {
        [self addCouponWithID:num_iid withModel:model];
        return YES;
    }
    return NO;
}
- (void)saveCacheWithID:(NSInteger)num_iid withModel:(ASHCartDetailModel *)model{
    if (!model) {
        return;
    }
    YYCache* cache = [YYCache cacheWithName:kASH_CART_CACHE_PATH];
    NSString* stinrgKey = [NSString stringWithFormat:@"%ld",num_iid];
    [cache setObject:model forKey:stinrgKey];
    [self addCouponWithID:num_iid withModel:model];
}
- (void)addCouponWithID:(NSInteger)num_iid withModel:(ASHCartDetailModel *)model{
    if (!model) {
        return;
    }
    for (NSMutableDictionary* dic in self.couponArr) {
        NSInteger tnum_iid = [dic[@"num_iid"] integerValue];
        if (tnum_iid == num_iid) {
            return;
        }
    }
    NSMutableDictionary* dic = [NSMutableDictionary new];
    [dic setObject:@(num_iid) forKey:@"num_iid"];
    [dic setObject:model forKey:@"model"];
    [self.couponArr addObject:dic];
}
- (NSInteger)totalPrice{
    NSInteger sumPrice = 0;
    for (int i = 0; i < self.couponArr.count; i++) {
        NSDictionary* dic = self.couponArr[i];
        ASHCartDetailModel* model = dic[@"model"];
        NSInteger price = [model.price integerValue];
        NSInteger zkprice = [model.zk_final_price integerValue];
        if (price > zkprice) {
            sumPrice += (price - zkprice);
        }
        
    }
    return sumPrice;
}
@end
