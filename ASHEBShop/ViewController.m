//
//  ViewController.m
//  ASHEBShop
//
//  Created by xmfish on 17/3/15.
//  Copyright © 2017年 ash. All rights reserved.
//

#import "ViewController.h"
#import "UIColor+CustomColor.h"
#import "UIImage+ASHUtil.h"
#import "ShopItemCell.h"
#import "ASHHomeViewModel.h"
#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import <AlibabaAuthSDK/ALBBSDK.h>
#import <ReactiveCocoa.h>
#import "ASHHomeModel.h"
#import "ASHSettingVC.h"
#import <MJRefresh.h>
#import <UMMobClick/MobClick.h>

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView* tableView;
@property (nonatomic, strong)UIButton* setBtn;
@property (nonatomic, strong)UIButton* accoutBtn;
@property (nonatomic, strong)UIButton* topBtn;
@property (nonatomic, strong)ASHHomeViewModel* viewModel;
@end

@implementation ViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"shoppage"];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick endLogPageView:@"shoppage"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
//    UIImage* image = [UIImage imageNamed:@"backgroud13.jpg"];
    UIImage* image = [UIImage ash_imageFromColor:[UIColor whiteColor] andSize:CGSizeMake(1, 1) opaque:0.2];
//    image = [image imageByBlurRadius:10 tintColor:[UIColor colorWithWhite:0.6 alpha:0.3] tintMode:kCGBlendModeNormal saturation:1.0 maskImage:nil];;
    image = [image imageByBlurWithTint:[UIColor mainColor]];
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = image;
    [self.view addSubview:imageView];
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 456)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 5.0;
    
    view.center = self.view.center;
//    [self.view addSubview:view];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(4, 0, self.view.bounds.size.width - 8, self.view.bounds.size.height - 0) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 180;
    self.tableView.layer.masksToBounds = YES;
    self.tableView.layer.cornerRadius = 5.0;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 64)];
    headerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = headerView;
    
    @weakify(self);
    MJRefreshNormalHeader* refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self requestData];
    }];
    refreshHeader.stateLabel.textColor = [UIColor whiteColor];
    refreshHeader.lastUpdatedTimeLabel.textColor = [UIColor whiteColor];
    self.tableView.mj_header = refreshHeader;
    [self.view addSubview:self.tableView];
    
    MJRefreshAutoNormalFooter* refreshfooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self loadMore];
    }];
    refreshfooter.stateLabel.textColor = [UIColor whiteColor];
    self.tableView.mj_footer = refreshfooter;
    
    self.setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.setBtn.backgroundColor = [UIColor clearColor];
    [self.setBtn setBackgroundImage:[UIImage imageNamed:@"cart.png"] forState:UIControlStateNormal];
    self.setBtn.frame = CGRectMake(50, 25, 25, 25);
    
    
    
    [[self.setBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [MobClick event:@"shopcart"];
        id<AlibcTradePage> page = [AlibcTradePageFactory myCartsPage];
        AlibcTradeShowParams* showParam = [[AlibcTradeShowParams alloc] init];
        showParam.openType = AlibcOpenTypeAuto;
//        showParam.isNeedPush = YES;
        [[AlibcTradeSDK sharedInstance].tradeService show: self page:page showParams:showParam taoKeParams: nil trackParam: nil tradeProcessSuccessCallback:nil tradeProcessFailedCallback:nil];
    }];
    [self.view addSubview:self.setBtn];
    
    self.accoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.accoutBtn.backgroundColor = [UIColor clearColor];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([ALBBSession sharedInstance].isLogin) {
            [self.accoutBtn setBackgroundImage:[UIImage imageNamed:@"account-2.png"] forState:UIControlStateNormal];
        }else{
            [self.accoutBtn setBackgroundImage:[UIImage imageNamed:@"account-3.png"] forState:UIControlStateNormal];
        }

    });
    
    [[self.accoutBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if (![ALBBSession sharedInstance].isLogin) {
            [[ALBBSDK sharedInstance] auth:self successCallback:^(ALBBSession *session) {
                [self.accoutBtn setBackgroundImage:[UIImage imageNamed:@"account-2.png"] forState:UIControlStateNormal];
            } failureCallback:^(ALBBSession *session, NSError *error) {
                
            }];
        }else{
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"退出淘宝账号授权" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
            [[alert rac_buttonClickedSignal] subscribeNext:^(id x) {
                if ([x integerValue] == 1) {
                    [[ALBBSDK sharedInstance] logout];
                }
                
            }];
            [alert show];
        }
    }];
    self.accoutBtn.frame = CGRectMake(15, 25, 25, 25);
    [self.view addSubview:self.accoutBtn];
    
    
    self.topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.topBtn.backgroundColor = [UIColor colorWithHexString:@"#61BFA9" alpha:0.8];
    self.topBtn.layer.cornerRadius = 23;
    self.topBtn.layer.masksToBounds = YES;
    [self.topBtn setImage:[UIImage imageNamed:@"up.png"] forState:UIControlStateNormal];
    self.topBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    self.topBtn.frame = CGRectMake(self.view.bounds.size.width - 56, self.view.bounds.size.height - 56, 46, 46);
    self.topBtn.hidden = YES;
    [[self.topBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView setContentOffset:CGPointZero animated:YES];
    }];
    [self.view addSubview:self.topBtn];
    
    
    _viewModel = [ASHHomeViewModel new];
    
    [self.tableView.mj_header beginRefreshing];
    
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
        if(!self.viewModel.hasMore){
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_footer resetNoMoreData];
        }
        [self.tableView reloadData];
    } error:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
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
    }

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    

    
    AlibcTradeShowParams* showParam = [[AlibcTradeShowParams alloc] init];
    showParam.openType = AlibcOpenTypeAuto;
    
    if (_viewModel.model.goodsJa.count > indexPath.row) {
        ASHHomeItemModel* model = [_viewModel.model.goodsJa objectAtIndex:indexPath.row];
        NSDictionary *dict = @{@"index" : @(model.id)};
        [MobClick event:@"shopclick" attributes:dict];
        id<AlibcTradePage> page = [AlibcTradePageFactory page: model.goodsUrl];
        [[AlibcTradeSDK sharedInstance].tradeService show: self page:page showParams:showParam taoKeParams:nil trackParam:nil tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
            
        } tradeProcessFailedCallback:^(NSError * _Nullable error) {
            NSLog([error description]);
        }];
        
    }
}
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y > 0){
        self.setBtn.hidden = YES;
        self.accoutBtn.hidden = YES;
        self.topBtn.hidden = NO;
    }else{
        self.setBtn.hidden = NO;
        self.accoutBtn.hidden = NO;
        self.topBtn.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
