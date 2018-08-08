//
//  ASHEBCategoryVC.m
//  ASHEBShop
//
//  Created by xmfish on 2018/8/1.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHEBCategory2VC.h"
#import "ASHCategoryViewModel.h"
#import "ASHBannerView.h"
#import "ASHCaetgoryTwoCell.h"
#import "ASHTopicViewModel.h"
#import "ASHShopItem1Cell.h"
#import "ASHTopSessionView.h"
#import "ASHOneImageCell.h"
#import "ASHTabCategoryView.h"
#import "ASHShopItem2Cell.h"
#import "ASHTypeSessionView.h"
#import "ASHCouponWebVC.h"
#import "ASHTabModel.h"
#import "ASHSpecialViewController.h"
@interface ASHEBCategory2VC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)ASHCategoryViewModel* viewModel;
@property (nonatomic, strong)ASHTopicViewModel* topicViewModel;
@property (nonatomic, strong)UITableView* tableView;
@property (nonatomic, strong)ASHBannerView *bannerView;
@property (nonatomic, assign)BOOL hasTimeline;//是否有限时秒杀
@property (nonatomic, strong)ASHCategoryItemModel* timelineModel;//是否有限时秒杀
@property (nonatomic, strong)ASHTabCategoryView* categoryView;
@property (nonatomic, strong)ASHTypeSessionView* typeSelectView;
@property (nonatomic, assign)NSInteger typeIndex;//排序
@property (nonatomic, assign)BOOL shouldScrollTop;
@end

@implementation ASHEBCategory2VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lineColor];
    
    self.hasTimeline = NO;
    [MobClick event:@"category" attributes:@{@"id":@(0)}];
    _viewModel = [ASHCategoryViewModel new];
    _viewModel.categoryId = self.categoryId;
    _topicViewModel = [ASHTopicViewModel new];
    _topicViewModel.sortType = 7;
    _topicViewModel.categoryId = self.categoryId;
    self.typeIndex = 0;
    self.shouldScrollTop = NO;
    [self bindViewModel];
    [self bindTopicVM];
    
    [self initTableView];
}

- (void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 140.0;
    self.tableView.layer.masksToBounds = YES;
    self.tableView.layer.cornerRadius = 5.0;
    self.tableView.backgroundColor = [UIColor lineColor];
    self.tableView.backgroundView.backgroundColor = [UIColor lineColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:self.tableView];
    
    
    @weakify(self);
    MJRefreshNormalHeader* refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.topicViewModel.sortType = 7;
        self.typeIndex = 0;
        [self.typeSelectView setIndex:0];
        [self requestData];
    }];
    refreshHeader.backgroundColor = [UIColor lineColor];
    refreshHeader.stateLabel.textColor = [UIColor grayColor];
    refreshHeader.lastUpdatedTimeLabel.textColor = [UIColor grayColor];
    self.tableView.mj_header = refreshHeader;
    [self.tableView.mj_header beginRefreshing];
    
    [_tableView registerNib:[UINib nibWithNibName:@"ASHShopItem2Cell" bundle:nil] forCellReuseIdentifier:@"ASHShopItem2Cell"];
    
}
- (void)setFooter
{
    if (self.tableView.mj_footer) {
        return;
    }
    @weakify(self);
    MJRefreshAutoNormalFooter* refreshfooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self loadMore];
    }];
    refreshfooter.stateLabel.textColor = [UIColor whiteColor];
    self.tableView.mj_footer = refreshfooter;
    
    
}
- (void)setupCategoryTopView
{
    if (!self.viewModel.model.zhekou_cate_minipic.count) {
        return;
    }
    if (_categoryView) {
        [_categoryView removeFromSuperview];
        _categoryView = nil;
    }
    _categoryView = [[ASHTabCategoryView alloc] initWithCategoryArr:self.viewModel.model.zhekou_cate_minipic];
    @weakify(self);
    [_categoryView setCategoryIndexAction:^(NSInteger index) {
        @strongify(self);
        ASHCategoryItemModel* model = self.viewModel.model.zhekou_cate_minipic[index];
        NSString *string = model.extend;
        NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:@"[a-zA-Z\u4e00-\u9fa5/:.]+" options:0 error:NULL];
        NSString* result = [regular stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@""];
        ASHSpecialViewController* vc = [ASHSpecialViewController new];
        vc.specialId = [result integerValue];
        vc.hidesBottomBarWhenPushed = YES;
        vc.title = model.title;
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    UIView* bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ASHScreenWidth, _categoryView.ash_height + 10)];
    bgView.backgroundColor = [UIColor lineColor];
    [bgView addSubview:_categoryView];
    self.tableView.tableHeaderView = bgView;
    
}
- (void)requestData
{
    [_viewModel requestData];
    [_topicViewModel requestData];
}
- (void)loadMore
{
    [_topicViewModel loadMore];
}
- (void)bindViewModel
{
    @weakify(self);
    [_viewModel.requestFinishedSignal subscribeNext:^(id x) {
        @strongify(self);
        [self setupCategoryTopView];
        
        if (self.viewModel.model.zhekou_index_timeline.count) {
            ASHCategoryItemModel* model = [self.viewModel.model.zhekou_index_timeline firstObject];
            if ([model.element_type isEqualToString:@"webview"]) {
                self.hasTimeline = YES;
                _timelineModel = model;
            }
        }
        [self.tableView reloadData];
    } error:^(NSError *error) {
        @strongify(self);
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView.mj_footer removeFromSuperview];
        [self.tableView.mj_header endRefreshing];
        [UIView showToast:kASH_NETWORK_Error];
    }];
}
- (void)bindTopicVM
{
    @weakify(self);
    [_topicViewModel.requestFinishedSignal subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        [self setFooter];
        if(!self.topicViewModel.hasMore){
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            
            [self.tableView.mj_footer resetNoMoreData];
        }
        
        [self.tableView reloadData];
        if (self.shouldScrollTop) {
            self.shouldScrollTop = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            });
            
        }
        
    } error:^(NSError *error) {
        @strongify(self);
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView.mj_footer removeFromSuperview];
        [self.tableView.mj_header endRefreshing];
        [UIView showToast:kASH_NETWORK_Error];
    }];
}
#pragma mark View
- (ASHTypeSessionView*)typeSelectView
{
    if (!_typeSelectView) {
        _typeSelectView = [[ASHTypeSessionView alloc] initWithFrame:CGRectMake(0, 10, ASHScreenWidth, 40.0)];
        [_typeSelectView addBottomLine:1.0];
        
        @weakify(self);
        [_typeSelectView setTypeSelectAction:^(NSInteger index) {
            @strongify(self);
            
            if (index == 0) {
                self.topicViewModel.sortType = 7;
            }
            if (index == 1) {
                self.topicViewModel.sortType = 6;
            }
            if (index == 2) {
                self.topicViewModel.sortType = 1;
            }
            self.shouldScrollTop = YES;
            [self.topicViewModel requestData];
        }];
    }
    return _typeSelectView;
}
#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.topicViewModel.model.coupon_list.count) {
        return 1;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = self.topicViewModel.model.coupon_list.count;
    count = count / 2 + count % 2;
    return count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat height = ASHScreenWidth / 2 * 1.58;
    
    return height;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ASHShopItem2Cell* cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"ASHShopItem2Cell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ASHShopItem2Cell" owner:nil options:nil] firstObject];
    }
    NSInteger index = indexPath.row*2;
    if (index >= self.topicViewModel.model.coupon_list.count) {
        return cell;
    }
    ASHCouponInfoModel* model1 = self.topicViewModel.model.coupon_list[index];
    ASHCouponInfoModel* model2;
    if (index + 1 < self.topicViewModel.model.coupon_list.count) {
        model2 = self.topicViewModel.model.coupon_list[ index + 1];
    }else{
        NSLog(@"%ld",index);
    }
    [cell setModel:model1 secondModel:model2];
    @weakify(self);
    [cell setItemClickAction:^(ASHCouponInfoModel *model) {
        @strongify(self);
        ASHCouponWebVC* webVC = [ASHCouponWebVC new];
        webVC.hidesBottomBarWhenPushed = YES;
        webVC.couponUrl = model.detail_url;
        [self.navigationController pushViewController:webVC animated:YES];
    }];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.topicViewModel.hasMore && (indexPath.item >= self.topicViewModel.model.coupon_list.count - 4) && (tableView.contentOffset.y > 0)) {
        [self.tableView.mj_footer beginRefreshing];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 40.0;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _typeSelectView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

