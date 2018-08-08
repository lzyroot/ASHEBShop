//
//  ASHSpecialViewModel.m
//  ASHEBShop
//
//  Created by xmfish on 2018/8/3.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHSpecialViewModel.h"
#import "ASHCouponModel.h"
@interface ASHSpecialViewModel()
@property (nonatomic, strong)ASHTopicModel* model;
@end
@implementation ASHSpecialViewModel

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
    NSString* baseUrl = [NSString stringWithFormat:@"http://m.sqkb.com/cate/categoryOperatorsData?cateCollectionId=%ld&sortType=%ld&page=%ld&pageSize=40",self.specialId,self.sortType,page];
    [self requestHomeDataWithUrl:baseUrl withpage:page];
}
- (void)requestTopic
{
    NSString* baseUrl = [NSString stringWithFormat:@"http://m.sqkb.com/topic/topicShowData?topic_id=%ld",self.specialId];
    [self requestHomeDataWithUrl:baseUrl withpage:0];
}
- (void)requestHomeDataWithUrl:(NSString*)baseUrl withpage:(NSInteger)page
{
    [requestDisposable dispose];
    ASHPropertyEntity* proEntity = [[ASHPropertyEntity alloc] init];
    proEntity.requireType = HTTPRequestTypeWithGET;
    proEntity.isCache = NO;
    proEntity.responesOBJ = [ASHTopicModel class];
    proEntity.baseUrl = baseUrl;
    
    
    @weakify(self);
    requestDisposable = [[ASHNetWork newRequestSignWithEneity:proEntity] subscribeNext:^(ASHTopicModel* model) {
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
        if (self.model.max_count > self.model.coupon_list.count) {
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
