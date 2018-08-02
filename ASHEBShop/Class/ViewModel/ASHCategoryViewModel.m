//
//  ASHCategoryViewModel.m
//  ASHEBShop
//
//  Created by xmfish on 2018/8/1.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHCategoryViewModel.h"
@interface ASHCategoryViewModel()
@property (nonatomic, strong)ASHCategoryModel* model;
@end
@implementation ASHCategoryViewModel

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
    NSString* baseUrl = @"http://m.sqkb.com/operateElement?moduleKey=zhekou_index_banner,zhekou_index_timeline,zhekou_index_fixed_ad,zhekou_cate_banner,zhekou_cate_minipic,zhekou_cate_timeline&cateId=";
    proEntity.baseUrl = [NSString stringWithFormat:@"%@=%ld",baseUrl,self.categoryId];
    proEntity.responesOBJ = [ASHCategoryModel class];
    
    requestDisposable = [[ASHNetWork newRequestSignWithEneity:proEntity] subscribeNext:^(ASHCategoryModel* model) {
        self.model = model;
        [self.ash_requestFinishedSubscriber sendNext:self.model];
        //        [self.ash_requestFinishedSubscriber sendCompleted];
        
    } error:^(NSError *error) {
        [self.ash_requestFinishedSubscriber sendError:error];
    }];
}

@end
