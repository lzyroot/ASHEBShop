//
//  ASHTabManager.m
//  ASHEBShop
//
//  Created by xmfish on 2018/8/1.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHTabManager.h"
#import "ASHTabViewModel.h"
@interface ASHTabManager()
@property(nonatomic, strong)ASHTabViewModel* viewModel;
@property(nonatomic,strong)ASHTabModel* model;
@end
@implementation ASHTabManager
+ (void)load
{
    [ASHTabManager shareInstance];
}
- (instancetype)init{
    self = [super init];
    if (self) {
        _viewModel = [ASHTabViewModel new];
        @weakify(self);
        [_viewModel.requestFinishedSignal subscribeNext:^(id x) {
            @strongify(self);
            self.model = x;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kASH_Post_Tab" object:nil];
        }];
        [_viewModel requestData];
    }
    return self;
}
@end
