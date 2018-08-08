//
//  ASHSearchContentVM.m
//  ASHEBShop
//
//  Created by xmfish on 2018/8/7.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHSearchContentVM.h"
#import "ASHSearchContentModel.h"
@interface ASHSearchContentVM()
@property (nonatomic, strong)ASHSearchContentModel* model;
@end
@implementation ASHSearchContentVM
- (void)requestData
{
    [self requestHomeDataWithPage:0];
}
- (void)loadMore
{
    [self requestHomeDataWithPage:self.page+1];
}

- (void)requestHomeDataWithPage:(NSInteger)page
{
    [requestDisposable dispose];
    ASHPropertyEntity* proEntity = [[ASHPropertyEntity alloc] init];
    proEntity.requireType = HTTPRequestTypeWithGET;
    proEntity.isCache = NO;
    proEntity.baseUrl = [NSString stringWithFormat:@"m.sqkb.com/search/searchResultData?sortType=%ld&word=%@&page=%ld&pageSize=40",self.sortType,[self.keyWord urlEncode],page];
    proEntity.responesOBJ = [ASHSearchContentModel class];
    @weakify(self);
    requestDisposable = [[ASHNetWork newRequestSignWithEneity:proEntity] subscribeNext:^(ASHSearchContentModel* model) {
        @strongify(self);
        self.page++;
        if (page == 0) {
            self.page = 1;
            self.model = model;
        }else if (model.coupon_list.count) {
            NSMutableArray<ASHTopicItemModel>* array = (NSMutableArray<ASHTopicItemModel>*)[NSMutableArray arrayWithArray:[(ASHTopicModel*)self.model coupon_list]];
            [array addObjectsFromArray:model.coupon_list];
            ((ASHTopicModel*)self.model).coupon_list = array;
        }
        if (model.coupon_list.count >= 20) {
            self.hasMore = YES;
        }else{
            self.hasMore = NO;
        }
        
        [self.ash_requestFinishedSubscriber sendNext:self.model];
        
    } error:^(NSError *error) {
        [self.ash_requestFinishedSubscriber sendError:error];
    }];
}

@end
