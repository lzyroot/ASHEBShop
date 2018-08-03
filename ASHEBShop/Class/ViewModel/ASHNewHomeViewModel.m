//
//  ASHNewHomeViewModel.m
//  ASHEBShop
//
//  Created by xmfish on 2018/5/17.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHNewHomeViewModel.h"
#import "ASHNewHomeModel.h"
@interface ASHNewHomeViewModel()
@property (nonatomic, strong)ASHNewHomeModel* model;
@end

@implementation ASHNewHomeViewModel
- (void)requestData
{
    [self requestHomeDataWithPage:1];
}
- (void)loadMore
{
    [self requestHomeDataWithPage:self.page + 1];
}

- (void)requestHomeDataWithPage:(NSInteger)page
{
    [requestDisposable dispose];
    ASHPropertyEntity* proEntity = [[ASHPropertyEntity alloc] init];
    proEntity.requireType = HTTPRequestTypeWithPOST;
    proEntity.isCache = YES;
    proEntity.responesOBJ = [ASHNewHomeModel class];
    proEntity.command = 10002;
    proEntity.param = @{@"page":@(page), @"pageSize":@(kDefaultPageSize)};
    @weakify(self);
    requestDisposable = [[ASHNetWork requestSignWithEneity:proEntity] subscribeNext:^(ASHNewHomeModel* model) {
        @strongify(self);
        self.page++;
        if (model.dataArr.count < kDefaultPageSize) {
            self.hasMore = NO;
        }else{
            self.hasMore = YES;
        }
        if (page == 1) {
            self.page = 1;
            self.model = model;
        }else if(model.dataArr){
            NSMutableArray<ASHNewHomeItemModel>* array = (NSMutableArray<ASHNewHomeItemModel>*)[NSMutableArray arrayWithArray:[(ASHNewHomeModel*)self.model dataArr]];
            [array addObjectsFromArray:model.dataArr];
            ((ASHNewHomeModel*)self.model).dataArr = array;
        }
        [self.ash_requestFinishedSubscriber sendNext:self.model];
        [self.ash_requestFinishedSubscriber sendCompleted];
        
        
    } error:^(NSError *error) {
        [self.ash_requestFinishedSubscriber sendError:error];
    }];
}
- (NSInteger)dataCount
{
    return self.model.dataArr.count;
}
- (ASHNewHomeItemModel*)modelIndex:(NSInteger)index
{
    if (self.dataCount > index) {
        return self.model.dataArr[index];
    }
    return nil;
    
}
@end
