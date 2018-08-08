//
//  ASHZheKou99ViewModel.m
//  ASHEBShop
//
//  Created by xmfish on 2018/8/8.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHZheKou99ViewModel.h"
@interface ASHZheKou99ViewModel()
@property (nonatomic, strong)ASHZheKou99Model* model;
@end
@implementation ASHZheKou99ViewModel
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
    proEntity.isCache = YES;
    NSString* baseUrl = @"http://m.sqkb.com/operateElement?moduleKey=zhekou_99_top,zhekou_99_shelf,zhekou_99_top_img&cateId=0";
    proEntity.baseUrl = baseUrl;
    proEntity.responesOBJ = [ASHZheKou99Model class];
    @weakify(self);
    requestDisposable = [[ASHNetWork newRequestSignWithEneity:proEntity] subscribeNext:^(ASHZheKou99Model* model) {
        @strongify(self);
        self.model = model;
        [self.ash_requestFinishedSubscriber sendNext:self.model];
        [self.ash_requestFinishedSubscriber sendCompleted];
        
    } error:^(NSError *error) {
        [self.ash_requestFinishedSubscriber sendError:error];
    }];
}
@end
