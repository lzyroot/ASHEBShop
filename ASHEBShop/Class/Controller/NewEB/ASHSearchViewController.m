//
//  ASHSearchViewController.m
//  ASHEBShop
//
//  Created by xmfish on 2018/8/6.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHSearchViewController.h"
#import "ASHTagView.h"
#import "ASHSearchManager.h"
@interface ASHSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic, strong)UITableView* tableView;
@property (nonatomic, strong)ASHTagView* hotTagView;
@property (nonatomic, strong)ASHTagView* historyTagView;
@property (nonatomic, strong)UITableViewCell* historyCell;
@property (nonatomic, strong)UIButton* cancelButton;
@end

@implementation ASHSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self initData];
    [self initTableView];
    [self initSearchBar];
}
- (void)initSearchBar
{
    UISearchBar *searchbar = [[UISearchBar alloc] init];
    // 添加到父视图
    [self.view addSubview:searchbar];
    // 设置原点坐标与大小
    searchbar.frame = CGRectMake(10.0, 20.0, (CGRectGetWidth(self.view.bounds) - 10.0 * 2), 44.0);
    searchbar.barStyle = UIBarStyleDefault;
    searchbar.placeholder = @"输入商品名或粘贴淘宝标题";
    searchbar.translucent = YES;
    searchbar.tintColor = [UIColor blueColor];
    // 输入框边框颜色
    searchbar.barTintColor = [UIColor whiteColor];
    searchbar.backgroundColor = [UIColor lineColor];
    // 输入框类型
    searchbar.showsCancelButton = YES;
    searchbar.searchBarStyle = UISearchBarStyleProminent;
    searchbar.delegate = self;
    UITextField *searchField=[searchbar valueForKey:@"searchField"];
    searchField.backgroundColor = [UIColor lineColor];
    searchField.layer.cornerRadius = 1.0;
    [searchField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [searchField setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    [searchField becomeFirstResponder];
    
    for(UIView *view in  [[[searchbar subviews] objectAtIndex:0] subviews]) {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            self.cancelButton = view;
        }
    }
}
- (void)initHistoryView{
    if ([ASHSearchManager shareInstance].historyTags.count) {
        self.historyCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchcellhistory"];
        self.historyCell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.historyTagView = [[ASHTagView alloc] initWithFrame:self.view.bounds titleArray:[[[ASHSearchManager shareInstance].historyTags reverseObjectEnumerator] allObjects] withTextColor:[UIColor grayColor] borderColor:[UIColor lineColor]];
        self.historyTagView.ash_height = self.historyTagView.tagHeight;
        [self.historyCell addSubview:self.historyTagView];
        
        [self.historyTagView setTagIndexAction:^(NSInteger index) {
            
        }];
        
    }else{
        self.historyCell = nil;
    }
}
- (void)initData{
    NSMutableArray* titleArr = [NSMutableArray array];
    for (ASHSearchInfoModel* model in [ASHSearchManager shareInstance].model.search_hot_word) {
        [titleArr addObject:model.title];
    }
    self.hotTagView = [[ASHTagView alloc] initWithFrame:self.view.bounds titleArray:titleArr withTextColor:[UIColor blackColor] borderColor:[UIColor blackColor]];
    self.hotTagView.ash_height = self.hotTagView.tagHeight;
    
    [self initHistoryView];
    
    @weakify(self);
    [self.hotTagView setTagIndexAction:^(NSInteger index) {
        @strongify(self);
        ASHSearchInfoModel* model = [ASHSearchManager shareInstance].model.search_hot_word[index];
        [[ASHSearchManager shareInstance] searchWithKey:model.title];
        [self initHistoryView];
        [self.tableView reloadData];
    }];
    

}
- (void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.ash_top = 68;
    self.tableView.layer.masksToBounds = YES;
    self.tableView.layer.cornerRadius = 5.0;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundView.backgroundColor = [UIColor lineColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    
    

//    [_tableView registerNib:[UINib nibWithNibName:@"ASHShopItem2Cell" bundle:nil] forCellReuseIdentifier:@"ASHShopItem2Cell"];
    
}
#pragma UISearchBarDelegate
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
}
#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([ASHSearchManager shareInstance].historyTags.count) {
        return 2;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0 && [ASHSearchManager shareInstance].historyTags.count) {
        return self.historyTagView.tagHeight;
    }
    return self.hotTagView.tagHeight;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell;
    
    if ([ASHSearchManager shareInstance].historyTags.count && indexPath.section == 0) {
        return self.historyCell;
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"searchcellhot"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchcellhot"];
        [cell addSubview:self.hotTagView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 40.0;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ASHScreenWidth, 30)];
    UILabel* label = [[UILabel alloc] initWithFrame:view.bounds];
    label.text = @"大家都在搜";
    label.ash_left = 20.0;
    label.ash_top = 10.0;
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:12.0];
    if (section == 0 && [ASHSearchManager shareInstance].historyTags.count) {
        label.text = @"历史搜索";
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 11, 13);
        button.ash_right = ASHScreenWidth- 15;
        button.ash_top = 18;
        [button setImage:[UIImage imageNamed:@"btn_search_history_clear"] forState:UIControlStateNormal];
        @weakify(self);
        [[[button rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread] subscribeNext:^(id x) {
            @strongify(self);
            [[ASHSearchManager shareInstance] clearHistory];
            [self initHistoryView];
            [self.tableView reloadData];
        }];
        [view addSubview:button];
    }
    [view addSubview:label];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0 && [ASHSearchManager shareInstance].historyTags.count) {
        return 3;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ASHScreenWidth, 3)];
    view.backgroundColor = [UIColor lineColor];
    return view;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    self.cancelButton.enabled = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
