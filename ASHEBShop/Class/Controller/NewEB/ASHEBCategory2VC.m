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
@interface ASHEBCategory2VC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)ASHCategoryViewModel* viewModel;
@property (nonatomic, strong)ASHTopicViewModel* topicViewModel;
@property (nonatomic, strong)UITableView* tableView;
@property (nonatomic, strong)ASHBannerView *bannerView;
@property (nonatomic, assign)BOOL hasTimeline;//是否有限时秒杀
@property (nonatomic, strong)ASHCategoryItemModel* timelineModel;//是否有限时秒杀
@property (nonatomic, strong)ASHTabCategoryView* categoryView;
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
    
    [self bindViewModel];
    [self bindTopicVM];
    
    [self initTableView];
}

- (void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 140.0;
    self.tableView.layer.masksToBounds = YES;
    self.tableView.layer.cornerRadius = 5.0;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    
    
    @weakify(self);
    MJRefreshNormalHeader* refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self requestData];
    }];
    refreshHeader.stateLabel.textColor = [UIColor grayColor];
    refreshHeader.lastUpdatedTimeLabel.textColor = [UIColor grayColor];
    self.tableView.mj_header = refreshHeader;
    [self.tableView.mj_header beginRefreshing];
    
    [_tableView registerNib:[UINib nibWithNibName:@"ASHCaetgoryTwoCell" bundle:nil] forCellReuseIdentifier:@"ASHCaetgoryTwoCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"ASHOneImageCell" bundle:nil] forCellReuseIdentifier:@"ASHOneImageCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"ASHShopItem1Cell" bundle:nil] forCellReuseIdentifier:@"ASHShopItem1Cell"];
    
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
    self.tableView.tableHeaderView = _categoryView;
    
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
    } error:^(NSError *error) {
        @strongify(self);
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView.mj_footer removeFromSuperview];
        [self.tableView.mj_header endRefreshing];
        [UIView showToast:kASH_NETWORK_Error];
    }];
}
#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.topicViewModel.model.topic_list.count) {
        return 1;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = self.topicViewModel.model.topic_list.count;
    return count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat height = 146.0;
    if (ASHScreenWidth <= 320) {
        height = 120;
    }
    return height;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ASHShopItem1Cell* cell;

    cell = [tableView dequeueReusableCellWithIdentifier:@"ASHShopItem1Cell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ASHShopItem1Cell" owner:nil options:nil] firstObject];
    }
        
    NSInteger index = indexPath.row;
    if (self.hasTimeline && indexPath.row > 2) {
        index--;
    }
    [(ASHShopItem1Cell*)cell setModel:self.topicViewModel.model.topic_list[index]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.topicViewModel.hasMore && (indexPath.item >= self.topicViewModel.model.topic_list.count - 4) && (tableView.contentOffset.y > 0)) {
        [self.tableView.mj_footer beginRefreshing];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }
    return 45.0;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ASHScreenWidth, 10.0)];
    view.backgroundColor = [UIColor lineColor];
    return view;
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

