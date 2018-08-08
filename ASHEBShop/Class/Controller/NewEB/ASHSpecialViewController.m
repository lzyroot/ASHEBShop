//
//  ASHSpecialViewController.m
//  ASHEBShop
//
//  Created by xmfish on 2018/8/3.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHSpecialViewController.h"
#import "ASHCategoryViewModel.h"
#import "ASHCaetgoryTwoCell.h"
#import "ASHTopicViewModel.h"
#import "ASHTopSessionView.h"
#import "ASHTabCategoryView.h"
#import "ASHShopItem2Cell.h"
#import "ASHTypeSessionView.h"
#import "ASHSpecialViewModel.h"
#import "ASHCouponWebVC.h"
@interface ASHSpecialViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)ASHSpecialViewModel* specialViewModel;
@property (nonatomic, strong)ASHCategoryViewModel* viewModel;
@property (nonatomic, strong)UITableView* tableView;
@property (nonatomic, strong)ASHTabCategoryView* categoryView;
@property (nonatomic, strong)ASHTypeSessionView* typeSelectView;
@property (nonatomic, assign)NSInteger typeIndex;//排序
@property (nonatomic, assign)BOOL shouldScrollTop;
@end

@implementation ASHSpecialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor lineColor];
    
    
    [MobClick event:@"special"];
    _viewModel = [ASHCategoryViewModel new];
    _viewModel.categoryId = self.specialId;
    _specialViewModel = [ASHSpecialViewModel new];
    _specialViewModel.sortType = 7;
    _specialViewModel.specialId = self.specialId;
    self.typeIndex = 0;
    self.shouldScrollTop = NO;
    [self bindViewModel];
    [self bindSpecialViewModel];
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
        self.specialViewModel.sortType = 7;
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
- (void)requestData
{
    [_viewModel requestData];
    [_specialViewModel requestData];
}
- (void)loadMore
{
    [_specialViewModel loadMore];
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

        ASHSpecialViewController* vc = [ASHSpecialViewController new];
        vc.specialId = [model.extend getInteger];
        vc.hidesBottomBarWhenPushed = YES;
        vc.title = model.title;
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    UIView* bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ASHScreenWidth, _categoryView.ash_height + 10)];
    bgView.backgroundColor = [UIColor lineColor];
    [bgView addSubview:_categoryView];
    self.tableView.tableHeaderView = bgView;
    
}

- (void)bindViewModel
{
    @weakify(self);
    [_viewModel.requestFinishedSignal subscribeNext:^(id x) {
        @strongify(self);
        [self setupCategoryTopView];
        [self.tableView reloadData];
    } error:^(NSError *error) {
        @strongify(self);
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView.mj_footer removeFromSuperview];
        [self.tableView.mj_header endRefreshing];
        [UIView showToast:kASH_NETWORK_Error];
    }];
}
- (void)bindSpecialViewModel
{
    @weakify(self);
    [_specialViewModel.requestFinishedSignal subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        [self setFooter];
        if(!self.specialViewModel.hasMore){
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
                self.specialViewModel.sortType = 7;
            }
            if (index == 1) {
                self.specialViewModel.sortType = 6;
            }
            if (index == 2) {
                self.specialViewModel.sortType = 1;
            }
            self.shouldScrollTop = YES;
            [self.specialViewModel requestData];
        }];
    }
    return _typeSelectView;
}
#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.specialViewModel.model.coupon_list.count) {
        return 1;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = self.specialViewModel.model.coupon_list.count;
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
    if (index >= self.specialViewModel.model.coupon_list.count) {
        return cell;
    }
    ASHCouponInfoModel* model1 = self.specialViewModel.model.coupon_list[index];
    ASHCouponInfoModel* model2;
    if (index + 1 < self.specialViewModel.model.coupon_list.count) {
        model2 = self.specialViewModel.model.coupon_list[ index + 1];
    }else{
        NSLog(@"%ld",index);
    }
    @weakify(self);
    [cell setItemClickAction:^(ASHCouponInfoModel *model) {
        @strongify(self);
        ASHCouponWebVC* webVC = [ASHCouponWebVC new];
        webVC.hidesBottomBarWhenPushed = YES;
        webVC.couponUrl = model.detail_url;
        [self.navigationController pushViewController:webVC animated:YES];
    }];
    
    [cell setModel:model1 secondModel:model2];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.specialViewModel.hasMore && (indexPath.item >= self.specialViewModel.model.coupon_list.count - 4) && (tableView.contentOffset.y > 0)) {
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
