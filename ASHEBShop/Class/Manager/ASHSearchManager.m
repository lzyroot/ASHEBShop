//
//  ASHSearchManager.m
//  ASHEBShop
//
//  Created by xmfish on 2018/8/6.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHSearchManager.h"
#import "ASHSearchViewModel.h"
@interface ASHSearchManager()
@property(nonatomic, strong)ASHSearchViewModel* viewModel;
@property(nonatomic,strong)ASHSearchModel* model;
@property(nonatomic, strong)NSMutableArray* historyTags;
@end
@implementation ASHSearchManager
+ (void)load
{
    [ASHSearchManager shareInstance];
}
+ (instancetype)shareInstance {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        _viewModel = [ASHSearchViewModel new];
        
        
        NSArray* history = [[NSUserDefaults standardUserDefaults] objectForKey:@"searchhistoryTag"];
        if (history) {
            _historyTags = [NSMutableArray arrayWithArray:history];
        }else{
            _historyTags = [NSMutableArray array];
        }
        
        @weakify(self);
        [_viewModel.requestFinishedSignal subscribeNext:^(id x) {
            @strongify(self);
            self.model = x;
        }];
        [_viewModel requestData];
    }
    return self;
}
- (NSArray*)historyTags
{
    return [_historyTags copy];
}
- (void)searchWithKey:(NSString *)key
{
    if (!_historyTags) {
        _historyTags = [NSMutableArray array];
    }
    if (_historyTags.count >= 10) {
        [_historyTags removeObjectAtIndex:0];
    }
    for (NSString* string in _historyTags) {
        if ([string isEqualToString:key]) {
            return;
        }
    }
    [_historyTags addObject:key];
    [[NSUserDefaults standardUserDefaults] setObject:_historyTags forKey:@"searchhistoryTag"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)clearHistory
{
    [_historyTags removeAllObjects];
    [[NSUserDefaults standardUserDefaults] setObject:_historyTags forKey:@"searchhistoryTag"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
