//
//  ASHShopDetailViewModel.m
//  ASHEBShop
//
//  Created by xmfish on 2018/5/21.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHShopDetailViewModel.h"
@interface ASHShopDetailViewModel()
@property (nonatomic, strong)ASHShopDetailModel* model;
@end
@implementation ASHShopDetailViewModel
- (void)loadMore
{
//    [self requestHomeDataWithPage:self.page + 1];
}
- (void)requestData{
    [requestDisposable dispose];
    ASHPropertyEntity* proEntity = [[ASHPropertyEntity alloc] init];
    proEntity.requireType = HTTPRequestTypeWithPOST;
    proEntity.isCache = YES;
    proEntity.responesOBJ = [ASHShopDetailModel class];
    proEntity.command = 10003 ;
    proEntity.param = @{@"id":@(self.itemId)};
    @weakify(self);
    requestDisposable = [[ASHNetWork requestSignWithEneity:proEntity] subscribeNext:^(ASHShopDetailModel* model) {
        @strongify(self);
        self.hasMore = NO;
        self.page = 1;
        self.model = model;

        [self.ash_requestFinishedSubscriber sendNext:self.model];
        [self.ash_requestFinishedSubscriber sendCompleted];
        
        
    } error:^(NSError *error) {
        [self.ash_requestFinishedSubscriber sendError:error];
    }];
}
- (void)requestParise
{
    ASHPropertyEntity* proEntity = [[ASHPropertyEntity alloc] init];
    proEntity.requireType = HTTPRequestTypeWithPOST;
    proEntity.isCache = YES;
    proEntity.responesOBJ = [ASHShopDetailModel class];
    proEntity.command = 10004 ;
    proEntity.param = @{@"id":@(self.itemId)};
    [[ASHNetWork requestSignWithEneity:proEntity] subscribeNext:^(ASHShopDetailModel* model) {
        [self.ash_requestFinishedSubscriber sendNext:self.model];
        [self.ash_requestFinishedSubscriber sendCompleted];
        
    } error:^(NSError *error) {
        [self.ash_requestFinishedSubscriber sendError:error];
    }];
}
- (NSInteger)dataCount
{
    return self.model.contentArr.count;
}
- (ASHShopDetailItemModel*)modelIndex:(NSInteger)index
{
    if (self.dataCount > index) {
        return self.model.contentArr[index];
    }
    return nil;
    
}
@end
