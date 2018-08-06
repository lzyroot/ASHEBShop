//
//  ASHSearchRecommondVM.m
//  ASHEBShop
//
//  Created by xmfish on 2018/8/6.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHSearchRecommondVM.h"
#import "ASHSearchRecommondModel.h"
@interface ASHSearchRecommondVM()
@property (nonatomic, strong)ASHSearchRecommondModel* model;
@end
@implementation ASHSearchRecommondVM

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
    proEntity.baseUrl = [NSString stringWithFormat:@"http://m.sqkb.com/search/searchRecommondByWordData?sortType=%ld&word=%@",self.sortType,self.keyWord];
    proEntity.responesOBJ = [ASHSearchRecommondModel class];
    @weakify(self);
    requestDisposable = [[ASHNetWork newRequestSignWithEneity:proEntity] subscribeNext:^(ASHSearchRecommondModel* model) {
        @strongify(self);
        self.model = model;
        [self.ash_requestFinishedSubscriber sendNext:self.model];
        [self.ash_requestFinishedSubscriber sendCompleted];
        
    } error:^(NSError *error) {
        [self.ash_requestFinishedSubscriber sendError:error];
    }];
}
@end