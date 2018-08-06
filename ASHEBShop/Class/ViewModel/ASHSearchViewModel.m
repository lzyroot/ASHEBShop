//
//  ASHSearchViewModel.m
//  ASHEBShop
//
//  Created by xmfish on 2018/8/6.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHSearchViewModel.h"
#import "ASHSearchModel.h"
@interface ASHSearchViewModel()
@property (nonatomic, strong)ASHSearchModel* model;
@end
@implementation ASHSearchViewModel
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
    proEntity.isCache = YES;
    proEntity.baseUrl = @"http://m.sqkb.com/search/operateElement?moduleKey=search_hot_word&page=0&pageSize=50";
    proEntity.responesOBJ = [ASHSearchModel class];
    @weakify(self);
    requestDisposable = [[ASHNetWork newRequestSignWithEneity:proEntity] subscribeNext:^(ASHSearchModel* model) {
        @strongify(self);
        [model.search_hot_word removeObjectAtIndex:0];
        self.model = model;
        [self.ash_requestFinishedSubscriber sendNext:self.model];
        //        [self.ash_requestFinishedSubscriber sendCompleted];
        
    } error:^(NSError *error) {
        [self.ash_requestFinishedSubscriber sendError:error];
    }];
}

@end
