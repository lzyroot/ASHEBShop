//
//  ASHCouponViewController.m
//  ASHEBShop
//
//  Created by xmfish on 2018/9/6.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHCouponViewController.h"
#import "ShopItemCell.h"
#import <AlipaySDK/AlipaySDK.h>
#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import <AlibabaAuthSDK/ALBBSDK.h>

@interface ASHCouponViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView* tableView;
@end

@implementation ASHCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"优惠券";
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lineColor];
    [self initTableView];
    [self.tableView reloadData];
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
    
    [_tableView registerNib:[UINib nibWithNibName:@"ShopItemCell" bundle:nil] forCellReuseIdentifier:@"ShopItemCell"];
    
}
#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ASHCouponManager shareInstance].couponArr.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopItemCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ShopItemCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ShopItemCell" owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if ([ASHCouponManager shareInstance].couponArr.count > indexPath.row) {
        ASHCartDetailModel* model = [ASHCouponManager shareInstance].couponArr[indexPath.row][@"model"];
        [cell setDetailModel:model];


    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ASHCartDetailModel* model = [ASHCouponManager shareInstance].couponArr[indexPath.row][@"model"];
    AlibcTradeShowParams* showParam = [[AlibcTradeShowParams alloc] init];
    showParam.openType = AlibcOpenTypeNative;
    AlibcTradeTaokeParams *taoKeParams = [[AlibcTradeTaokeParams alloc] init];
    taoKeParams.pid = kASH_TAOBAO_PID;
    

    NSDictionary *dict = @{@"index" : @(model.num_iid)};
    [MobClick event:@"shopclick" attributes:dict];
    id<AlibcTradePage> page = [AlibcTradePageFactory page: model.coupon_click_url];
    [[AlibcTradeSDK sharedInstance].tradeService show: self page:page showParams:showParam taoKeParams:taoKeParams trackParam:nil tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
            
    } tradeProcessFailedCallback:^(NSError * _Nullable error) {
        NSLog(@"%@", [error description]);
    }];
    
}

@end
