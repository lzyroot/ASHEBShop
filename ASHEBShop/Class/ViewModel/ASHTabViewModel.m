//
//  ASHTabViewModel.m
//  ASHEBShop
//
//  Created by xmfish on 2018/8/1.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHTabViewModel.h"
@interface ASHTabViewModel()
@property (nonatomic, strong)ASHTabModel* model;
@end
@implementation ASHTabViewModel

- (void)requestData
{
    [self requestHomeDataWithPage:1];
}
- (void)loadMore
{
    [self requestHomeDataWithPage:1];
}

- (void)requestHomeDataWithPage:(NSInteger)page
{
    [requestDisposable dispose];
    ASHPropertyEntity* proEntity = [[ASHPropertyEntity alloc] init];
    proEntity.requireType = HTTPRequestTypeWithGET;
    proEntity.isCache = YES;
    proEntity.baseUrl = @"http://m.sqkb.com/tab";
    proEntity.responesOBJ = [ASHTabModel class];
    requestDisposable = [[ASHNetWork newRequestSignWithEneity:proEntity] subscribeNext:^(ASHTabModel* model) {
        self.model = model;
        [self.ash_requestFinishedSubscriber sendNext:self.model];
//        [self.ash_requestFinishedSubscriber sendCompleted];
        
    } error:^(NSError *error) {
        [self.ash_requestFinishedSubscriber sendError:error];
    }];
}
- (NSInteger)dataCount
{
    return self.model.tab_elementArr.count;
}
- (ASHTabItemModel*)modelIndex:(NSInteger)index
{
    if (self.dataCount > index) {
        return self.model.tab_elementArr[index];
    }
    return nil;
    
}

@end
