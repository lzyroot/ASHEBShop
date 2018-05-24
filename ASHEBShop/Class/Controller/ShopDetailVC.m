//
//  ShopDetailVC.m
//  ASHEBShop
//
//  Created by xmfish on 2018/5/17.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ShopDetailVC.h"
#import "ASHShopDetailViewModel.h"
#import "ShopDetailCell.h"
@interface ShopDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *headTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *headContentLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic, copy)ASHShopDetailViewModel* viewModel;

@end

@implementation ShopDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"攻略详情";
    
    
    [self setupTable];
    _viewModel = [ASHShopDetailViewModel new];
    _viewModel.itemId = self.detailId;
    [self.tableView.mj_header beginRefreshing];
    
    NSMutableDictionary* pariseDic =  [[NSUserDefaults standardUserDefaults] objectForKey:kASH_PRAISE_SAVE];
    if ([pariseDic objectForKey:[NSString stringWithNSInteger:self.detailId]]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"homelike"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBarBtnClick:)];
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"homenolike"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBarBtnClick:)];
    }
    
}

- (void)rightBarBtnClick:(id)sender
{
    [MobClick event:@"praise"];
    NSMutableDictionary* pariseDic =  [[NSUserDefaults standardUserDefaults] objectForKey:kASH_PRAISE_SAVE];
    if (![pariseDic objectForKey:@(self.detailId)]){
        [_viewModel requestParise];
        if (!pariseDic) {
            pariseDic = [NSMutableDictionary dictionary];
        }
        [pariseDic setObject:@"1" forKey:[NSString stringWithNSInteger:self.detailId]];
        [[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionaryWithDictionary:pariseDic] forKey:kASH_PRAISE_SAVE];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"homelike"];
    }else{
        [UIView showToast:@"已经收藏啦～"];
    }
    
}
- (void)requestData
{
    [self bindViewModel];
    [_viewModel requestData];
}
- (void)loadMore
{
    [self bindViewModel];
    [_viewModel requestData];
}
- (void)bindViewModel
{
    @weakify(self);
    [_viewModel.requestFinishedSignal subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        if(!self.viewModel.hasMore){
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            
            [self.tableView.mj_footer resetNoMoreData];
        }
        [self setupHeaderView];
        
        [self.tableView reloadData];
    } error:^(NSError *error) {
        @strongify(self);
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView.mj_footer removeFromSuperview];
        [self.tableView.mj_header endRefreshing];
        [UIView showToast:@"网络异常，请下拉刷新"];
    }];
}

- (void)setupTable{
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.rowHeight = 223.5;
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
- (void)setupHeaderView
{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.viewModel.model.imageUrl]];
    self.headTitleLabel.text = self.viewModel.model.title;
    self.headContentLabel.text = self.viewModel.model.desc;

    
    CGSize textSize = [self.headTitleLabel.text boundingRectWithSize:CGSizeMake(self.headTitleLabel.ash_size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.headTitleLabel.font} context:nil].size;
    
    CGSize contentSize = [self.headContentLabel.text boundingRectWithSize:CGSizeMake(self.headContentLabel.ash_size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.headContentLabel.font} context:nil].size;
    
    self.headerView.ash_height = textSize.height + contentSize.height + 270;
    self.tableView.tableHeaderView= self.headerView;
    
}
#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _viewModel.dataCount;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopDetailCell* cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return [cell cellHeight];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ShopDetailCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ShopDetailCell" owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    ASHShopDetailItemModel* model = [_viewModel modelIndex:indexPath.row];
    cell.model = model;
    
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
