//
//  ASHZhekouTimelineVM.m
//  ASHEBShop
//
//  Created by xmfish on 2018/8/8.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHZhekouTimelineVM.h"
@interface ASHZhekouTimelineVM()
@property(nonatomic, strong)ASHZheKouTimeLineModel* model;
@end
@implementation ASHZhekouTimelineVM
- (instancetype)init{
    self = [super init];
    if (self) {
    }
    return self;
}
- (void)requestData
{
    [self requestHomeDataWithPage:0];
}
- (void)loadMore
{
    [self requestHomeDataWithPage:0];
}

- (void)requestHomeDataWithPage:(NSInteger)page
{
    [requestDisposable dispose];
    ASHPropertyEntity* proEntity = [[ASHPropertyEntity alloc] init];
    proEntity.requireType = HTTPRequestTypeWithGET;
    proEntity.isCache = NO;
    NSString* baseUrl = [NSString stringWithFormat:@"http://m.sqkb.com/coupon/k9/element?cate_collection_id=%ld",self.categoryId];
    proEntity.baseUrl = baseUrl;
    proEntity.responesOBJ = [ASHZheKouTimeLineModel class];
    @weakify(self);
    requestDisposable = [[ASHNetWork newRequestSignWithEneity:proEntity] subscribeNext:^(ASHZheKouTimeLineModel* model) {
        @strongify(self);
        self.model = model;
        [self.ash_requestFinishedSubscriber sendNext:self.model];
//        [self.ash_requestFinishedSubscriber sendCompleted];
        
    } error:^(NSError *error) {
        [self.ash_requestFinishedSubscriber sendError:error];
    }];
}
@end
