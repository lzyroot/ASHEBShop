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
@property (nonatomic, strong)ASHTabModel* zhekouModel;
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
    @weakify(self);
    requestDisposable = [[ASHNetWork newRequestSignWithEneity:proEntity] subscribeNext:^(ASHTabModel* model) {
        @strongify(self);
        ASHTabItemModel* itemModel = [ASHTabItemModel new];
        itemModel.name = @"今日精选";
        itemModel.tab_id = 0;
        itemModel.pic = @"http://ms1.sqkb.com/dist/image/before/today-best-choose-icon-e566c712cb.png";
        [model.tab_elementArr insertObject:itemModel atIndex:0];
        self.model = model;
        [self requestZhekou99];
        [self.ash_requestFinishedSubscriber sendNext:self];
        
    } error:^(NSError *error) {
        [self.ash_requestFinishedSubscriber sendError:error];
    }];
}
- (void)requestZhekou99{
    [requestDisposable dispose];
    ASHPropertyEntity* proEntity = [[ASHPropertyEntity alloc] init];
    proEntity.requireType = HTTPRequestTypeWithGET;
    proEntity.isCache = YES;
    proEntity.baseUrl = @"http://m.sqkb.com/coupon/k9/cateTab";
    proEntity.responesOBJ = [ASHTabModel class];
    @weakify(self);
    requestDisposable = [[ASHNetWork newRequestSignWithEneity:proEntity] subscribeNext:^(ASHTabModel* model) {
        @strongify(self);
        ASHTabItemModel* itemModel = [ASHTabItemModel new];
        itemModel.name = @"精选";
        itemModel.tab_id = 0;
        [model.tab_elementArr insertObject:itemModel atIndex:0];
        self.zhekouModel = model;
        [self.ash_requestFinishedSubscriber sendNext:self];
        
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
