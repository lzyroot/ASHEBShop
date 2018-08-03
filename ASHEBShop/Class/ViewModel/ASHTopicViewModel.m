//
//  ASHTopicViewModel.m
//  ASHEBShop
//
//  Created by xmfish on 2018/8/2.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHTopicViewModel.h"
@interface ASHTopicViewModel()
@property (nonatomic, strong)ASHTopicModel* model;
@end
@implementation ASHTopicViewModel

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
    proEntity.baseUrl = [NSString stringWithFormat:@"http://m.sqkb.com/topic?sortType=%ld&page=%ld&pageSize=40",self.sortType,page];
    proEntity.responesOBJ = [ASHTopicModel class];
    @weakify(self);
    requestDisposable = [[ASHNetWork newRequestSignWithEneity:proEntity] subscribeNext:^(ASHTopicModel* model) {
        @strongify(self);
        self.page++;
        if (page == 0) {
            self.page = 1;
            self.model = model;
        }else if(model.topic_list){
            NSMutableArray<ASHTopicItemModel>* array = (NSMutableArray<ASHTopicItemModel>*)[NSMutableArray arrayWithArray:[(ASHTopicModel*)self.model topic_list]];
            [array addObjectsFromArray:model.topic_list];
            ((ASHTopicModel*)self.model).topic_list = array;
        }
        if (self.model.max_count > self.model.topic_list.count) {
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
