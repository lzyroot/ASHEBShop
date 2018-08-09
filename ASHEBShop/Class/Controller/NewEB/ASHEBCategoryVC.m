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
#import "ASHTopicViewModel.h"
#import "ASHShopItem1Cell.h"
#import "ASHTopSessionView.h"
#import "ASHOneImageCell.h"
#import "ASHCouponWebVC.h"
#import "ASHTabCategoryView.h"
#import "ASHSpecialViewController.h"
#import "ASHZheKou99ViewController.h"
#import <AXWebViewController.h>
#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import <AlibabaAuthSDK/ALBBSDK.h>
@interface ASHEBCategoryVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)ASHCategoryViewModel* viewModel;
@property (nonatomic, strong)ASHTopicViewModel* topicViewModel;
@property (nonatomic, strong)UITableView* tableView;
@property (nonatomic, strong)ASHBannerView *bannerView;
@property (nonatomic, assign)BOOL hasTimeline;//是否有限时秒杀
@property (nonatomic, strong)ASHCategoryItemModel* timelineModel;//是否有限时秒杀
@property (nonatomic, strong)ASHTabCategoryView* categoryView;

@end

@implementation ASHEBCategoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lineColor];
    self.navigationItem.title = @"";
    self.hasTimeline = NO;
    [MobClick event:@"category" attributes:@{@"id":@(0)}];
    _viewModel = [ASHCategoryViewModel new];
    _topicViewModel = [ASHTopicViewModel new];
    _topicViewModel.sortType = 7;
    
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
    self.tableView.showsVerticalScrollIndicator = YES;
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
        ASHCategoryItemModel* model = self.viewModel.model.zhekou_index_banner[index];
        NSString* topicString = model.extend;
        topicString = [[topicString componentsSeparatedByString:@"?"] firstObject];
        
        NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:@"[a-zA-Z\u4e00-\u9fa5/:.]+" options:0 error:NULL];
        NSString* result = [regular stringByReplacingMatchesInString:topicString options:0 range:NSMakeRange(0, [topicString length]) withTemplate:@""];
        
        ASHSpecialViewController* vc = [ASHSpecialViewController new];
        vc.specialId = [result integerValue];
        vc.hidesBottomBarWhenPushed = YES;
        vc.title = model.title;
        vc.isTopic = YES;
        [self.navigationController pushViewController:vc animated:YES];
    };
    self.tableView.tableHeaderView = _bannerView;
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
        [self setupBanner];
        
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
        return 2;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    NSInteger count = self.topicViewModel.model.topic_list.count;
    if (self.hasTimeline) {
        count++;
    }
    return count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat height = 146.0;
    if (ASHScreenWidth <= 320) {
        height = 120;
    }
    if (self.hasTimeline && indexPath.row == 2) {
        height = (float)(self.timelineModel.pic_height * ASHScreenWidth) / (float)self.timelineModel.pic_width ;
    }
    if (indexPath.section == 0) {
        height = 100.0;
    }
    return height;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ASHCaetgoryTwoCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ASHCaetgoryTwoCell" owner:nil options:nil] firstObject];
        }
        [(ASHCaetgoryTwoCell*)cell setItemClickAction:^(NSInteger index) {
            if (index == 0) {
                ASHZheKou99ViewController* vc = [ASHZheKou99ViewController new];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                ASHCouponWebVC* webVC = [ASHCouponWebVC new];
                webVC.hidesBottomBarWhenPushed = YES;
                webVC.couponUrl = @"http://m.sqkb.com/coupon/newrank";
                [self.navigationController pushViewController:webVC animated:YES];
            }

        }];
    }else if (self.hasTimeline && indexPath.row == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ASHOneImageCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ASHOneImageCell" owner:nil options:nil] firstObject];
        }
        [(ASHOneImageCell*)cell setImageUrl:self.timelineModel.pic];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"ASHShopItem1Cell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ASHShopItem1Cell" owner:nil options:nil] firstObject];
        }
        
        NSInteger index = indexPath.row;
        
        if (self.hasTimeline && indexPath.row > 2) {
            index--;
        }
        [(ASHShopItem1Cell*)cell setModel:self.topicViewModel.model.topic_list[index]];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(self.hasTimeline && indexPath.row == 2){
        ASHCouponWebVC* webVC = [ASHCouponWebVC new];
        webVC.hidesBottomBarWhenPushed = YES;
        webVC.couponUrl = self.timelineModel.extend;
        [self.navigationController pushViewController:webVC animated:YES];
        return;
    }
    NSInteger index = indexPath.row;
    if (self.hasTimeline && indexPath.row > 2) {
        index--;
    }
    ASHTopicItemModel*model = self.topicViewModel.model.topic_list[index];
    ASHCouponWebVC* webVC = [ASHCouponWebVC new];
    webVC.hidesBottomBarWhenPushed = YES;
    webVC.couponUrl = model.coupon_info.detail_url;
    [self.navigationController pushViewController:webVC animated:YES];
    
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
        return 0;
    }
    return 45.0;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ASHTopSessionView* view = [[ASHTopSessionView alloc] initWithFrame:CGRectMake(0, 0, ASHScreenWidth, 45)];
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
