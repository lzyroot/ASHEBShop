//
//  ASHCartViewModel.m
//  ASHEBShop
//
//  Created by xmfish on 2018/9/4.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHCartViewModel.h"
#import "ASHCartInfoModel.h"

#import <YYCache.h>
@interface ASHCartViewModel()
@property(nonatomic, strong)ASHCartInfoModel* model;
@end
@implementation ASHCartViewModel

- (void)requestHomeDataWithNumId:(NSInteger)num_iid title:(NSString*)title price:(NSString *)price
{
    if ([[ASHCouponManager shareInstance] hasCacheCoupon:num_iid]) {
        [self.ash_requestFinishedSubscriber sendNext:nil];
        [self.ash_requestFinishedSubscriber sendCompleted];
        return;
    }
    [requestDisposable dispose];
    ASHPropertyEntity* proEntity = [[ASHPropertyEntity alloc] init];
    proEntity.requireType = HTTPRequestTypeWithPOST;
    proEntity.isCache = YES;
    proEntity.responesOBJ = [ASHCartInfoModel class];
    proEntity.command = 10005;
    proEntity.param = @{@"num_iid":@(num_iid), @"title":title};

    @weakify(self);
    requestDisposable = [[ASHNetWork requestSignWithEneity:proEntity] subscribeNext:^(ASHCartInfoModel* model) {
        @strongify(self);
        ASHCartDetailModel* detailModel = model.match_coupon;
        detailModel.isLike = NO;
        if (!detailModel) {
            detailModel = model.like_coupon;
            detailModel.isLike = YES;
        }
        if (detailModel) {
            detailModel.price = price;
            [[ASHCouponManager shareInstance] saveCacheWithID:num_iid withModel:detailModel];
        }else{
            
        }
        
        self.model = model;
        
        [self.ash_requestFinishedSubscriber sendNext:self.model];
        [self.ash_requestFinishedSubscriber sendCompleted];
        
        
    } error:^(NSError *error) {
        [self.ash_requestFinishedSubscriber sendError:error];
    }];
}
@end
