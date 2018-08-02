//
//  ASHCategoryListVC.m
//  ASHEBShop
//
//  Created by xmfish on 2018/5/24.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHCategoryListVC.h"
#import "UIColor+CustomColor.h"
#import "UIImage+ASHUtil.h"
#import "ShopItemCell.h"
#import "ASHHomeViewModel.h"
#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import <AlibabaAuthSDK/ALBBSDK.h>
#import <ReactiveCocoa.h>
#import "ASHHomeModel.h"
#import "ASHSettingVC.h"
#import "ASHBannerView.h"
#import <MJRefresh.h>
#import <UMMobClick/MobClick.h>
#import <MBProgressHUD.h>
#import "ASHCouponWebView.h"

@interface ASHCategoryListVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)ASHHomeViewModel* viewModel;
@property (nonatomic, strong)UITableView* tableView;
@end

@implementation ASHCategoryListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lineColor];
    
    [MobClick event:@"category" attributes:@{@"id":@(self.goodsTypeId)}];
    _viewModel = [ASHHomeViewModel new];
    _viewModel.goodsTypeId = self.goodsTypeId;
    [self initTableView];
    [self setupBanner];
}
- (void)setupBanner
{
    ASHBannerView *bannerView = [[ASHBannerView alloc] initWithFrame:CGRectMake(0, 0, ASHScreenWidth, 5 * ASHScreenWidth / 16)];
    bannerView.position = ASHBannerPageControlAtCenter;
    @weakify(self);
    NSArray *bannerImages = @[@"http://file.17gwx.com/sqkb/element/2018/08/01/717475b6111380d272.jpg",@"http://file.17gwx.com/sqkb/element/2018/07/31/204255b6035af59c81.jpg",@"http://file.17gwx.com/sqkb/element/2018/07/30/435975b5ef87fa5bc3.jpg",@"http://file.17gwx.com/sqkb/element/2018/07/30/893485b5ef83a73efd.jpg",@"http://file.17gwx.com/sqkb/element/2018/07/27/300975b5ae3eaa0ed8.jpg"];
    bannerView.images = bannerImages;
    bannerView.onDidClickEvent = ^(NSInteger index) {
        @strongify(self);
    };
    self.tableView.tableHeaderView = bannerView;
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
    return _viewModel.model.goodsJa.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopItemCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ShopItemCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ShopItemCell" owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (_viewModel.model.goodsJa.count > indexPath.row) {
        ASHHomeItemModel* model = [_viewModel.model.goodsJa objectAtIndex:indexPath.row];
        cell.model = model;
        @weakify(self);
        cell.couponAction = ^(ASHHomeItemModel* model){
            @strongify(self);
            [self openCouponUrl:model.couponUrl];
        };
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AlibcTradeShowParams* showParam = [[AlibcTradeShowParams alloc] init];
    showParam.openType = AlibcOpenTypeNative;
    
    if (_viewModel.model.goodsJa.count > indexPath.row) {
        ASHHomeItemModel* model = [_viewModel.model.goodsJa objectAtIndex:indexPath.row];
        NSDictionary *dict = @{@"index" : @(model.id)};
        [MobClick event:@"shopclick" attributes:dict];
        id<AlibcTradePage> page = [AlibcTradePageFactory page: model.goodsUrl];
        [[AlibcTradeSDK sharedInstance].tradeService show: self page:page showParams:showParam taoKeParams:nil trackParam:nil tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
            
        } tradeProcessFailedCallback:^(NSError * _Nullable error) {
            NSLog(@"%@", [error description]);
        }];
        
    }
}
- (void)openCouponUrl:(NSString*)url
{
    ASHCouponWebView* webview = [[ASHCouponWebView alloc] initWithUrl:url];
    webview.backgroundColor = [UIColor colorWithWhite:.6 alpha:0.5];
    [self.view addSubview:webview];
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
