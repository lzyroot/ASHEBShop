//
//  ASHEBCategoryVC.m
//  ASHEBShop
//
//  Created by xmfish on 2018/8/1.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHEBCategoryVC.h"
#import "ASHCategoryViewModel.h"
#import "ASHBannerView.h"
#import "ASHCaetgoryTwoCell.h"

@interface ASHEBCategoryVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)ASHCategoryViewModel* viewModel;
@property (nonatomic, strong)UITableView* tableView;
@property (nonatomic, strong)ASHBannerView *bannerView;
@end

@implementation ASHEBCategoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lineColor];
    
    [MobClick event:@"category" attributes:@{@"id":@(0)}];
    _viewModel = [ASHCategoryViewModel new];
    _viewModel.categoryId = 0;
    [self initTableView];
    [self setupBanner];
}

- (void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
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
- (void)setupBanner
{
    if (!self.viewModel.model.zhekou_index_banner.count) {
        return;
    }
    if (_bannerView) {
        [_bannerView removeFromSuperview];
        _bannerView = nil;
    }
    _bannerView = [[ASHBannerView alloc] initWithFrame:CGRectMake(0, 0, ASHScreenWidth, 5 * ASHScreenWidth / 16)];
    _bannerView.position = ASHBannerPageControlAtCenter;
    @weakify(self);
    NSMutableArray* bannerImages = [NSMutableArray array];
    
    [self.viewModel.model.zhekou_index_banner enumerateObjectsUsingBlock:^(ASHCategoryItemModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [bannerImages addObject:obj.pic];
    }];
    _bannerView.images = bannerImages;
    _bannerView.onDidClickEvent = ^(NSInteger index) {
        @strongify(self);
    };
    self.tableView.tableHeaderView = _bannerView;
}

- (void)requestData
{
    [self bindViewModel];
    [_viewModel requestData];
}
- (void)loadMore
{
    [self bindViewModel];
    [_viewModel loadMore];
}
- (void)bindViewModel
{
    @weakify(self);
    [_viewModel.requestFinishedSignal subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        [self setFooter];
        if(!self.viewModel.hasMore){
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            
            [self.tableView.mj_footer resetNoMoreData];
        }
        [self setupBanner];
        [self.tableView reloadData];
    } error:^(NSError *error) {
        @strongify(self);
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView.mj_footer removeFromSuperview];
        [self.tableView.mj_header endRefreshing];
        MBProgressHUD* progressHUD = [[MBProgressHUD alloc] initWithFrame:self.view.bounds];
        progressHUD.mode = MBProgressHUDModeText;
        progressHUD.removeFromSuperViewOnHide = YES;
        progressHUD.center = self.view.center;
        progressHUD.label.text = @"网络异常,请下拉刷新重试";
        [self.view addSubview:progressHUD];
        [progressHUD showAnimated:NO];
        [progressHUD hideAnimated:YES afterDelay:2.0];
    }];
}
#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ASHCaetgoryTwoCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ASHCaetgoryTwoCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ASHCaetgoryTwoCell" owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
