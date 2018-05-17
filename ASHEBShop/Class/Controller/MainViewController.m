//
//  MainViewController.m
//  ASHEBShop
//
//  Created by xmfish on 2018/5/2.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "MainViewController.h"
#import "HomeCell.h"
#import "HomeCell2.h"
@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UITableView* tableView;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FBF5F5" alpha:1.0];
    self.title = @"推荐";
    [self initTableView];
    
}
- (void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 260;
    self.tableView.layer.masksToBounds = YES;
    self.tableView.layer.cornerRadius = 5.0;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    
    
}
#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCell2* cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell2"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"HomeCell2" owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.model = nil;
//    if (_viewModel.model.goodsJa.count > indexPath.row) {
//        ASHHomeItemModel* model = [_viewModel.model.goodsJa objectAtIndex:indexPath.row];
//        cell.model = model;
//        @weakify(self);
//        cell.couponAction = ^(ASHHomeItemModel* model){
//            @strongify(self);
//            if (![ALBBSession sharedInstance].isLogin) {
//                [self loginTB];
//            }else{
//                [self openCouponUrl:model.couponUrl];
//            }
//        };
//    }
    
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
