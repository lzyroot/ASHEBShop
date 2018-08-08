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
#import "ASHSearchListViewController.h"
#import "ASHSearchBar.h"
#import "ASHSearchRecommondVM.h"
@interface ASHSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic, strong)UITableView* tableView;
@property (nonatomic, strong)ASHTagView* hotTagView;
@property (nonatomic, strong)ASHTagView* historyTagView;
@property (nonatomic, strong)UITableViewCell* historyCell;
@property (nonatomic, strong)UIButton* cancelButton;
@property (nonatomic, strong)ASHSearchRecommondVM* searchViewModel;
@property (nonatomic, assign)BOOL shouldShow;
@property (nonatomic, strong)ASHSearchBar *searchbar;

@end

@implementation ASHSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.shouldShow = NO;
    [self initData];
    [self initTableView];
    [self initSearchBar];
    [self bindViewModel];
}
- (void)bindViewModel
{
    _searchViewModel = [ASHSearchRecommondVM new];
    _searchViewModel.sortType = 7;
    
    @weakify(self);
    [_searchViewModel.requestFinishedSignal subscribeNext:^(id x) {
        @strongify(self);
        if (_searchViewModel.model.search_word_list.count > 0) {
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            self.shouldShow = YES;
        }else{
            self.shouldShow = NO;
        }
        [self.tableView reloadData];
    }];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.cancelButton.enabled = YES;
}
- (void)initSearchBar
{
    _searchbar = [[ASHSearchBar alloc] init];
    
    [self.view addSubview:_searchbar];
    
    _searchbar.frame = CGRectMake(10.0, 20.0, (CGRectGetWidth(self.view.bounds) - 10.0 * 2), 30);
    _searchbar.barStyle = UIBarStyleDefault;
    _searchbar.placeholder = @"输入商品名或粘贴淘宝标题";
    _searchbar.translucent = YES;
    _searchbar.tintColor = [UIColor blueColor];
    _searchbar.delegate = self;
    _searchbar.barTintColor = [UIColor whiteColor];
    _searchbar.backgroundColor = [UIColor whiteColor];
    
    _searchbar.showsCancelButton = YES;
    _searchbar.searchBarStyle = UISearchBarStyleMinimal;
    _searchbar.delegate = self;
    UITextField *searchField=[_searchbar valueForKey:@"searchField"];
    searchField.backgroundColor = [UIColor lineColor];
    [searchField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [searchField setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    [searchField becomeFirstResponder];
    
    for(UIView *view in  [[[_searchbar subviews] objectAtIndex:0] subviews]) {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            self.cancelButton = view;
        }
    }
    UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 55, ASHScreenWidth, 1)];
    lineView.backgroundColor = [UIColor lineColor];
    [self.view addSubview:lineView];
}
- (void)initHistoryView{
    if ([ASHSearchManager shareInstance].historyTags.count) {
        self.historyCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchcellhistory"];
        self.historyCell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.historyTagView = [[ASHTagView alloc] initWithFrame:self.view.bounds titleArray:[[[ASHSearchManager shareInstance].historyTags reverseObjectEnumerator] allObjects] withTextColor:[UIColor grayColor] borderColor:[UIColor lineColor]];
        self.historyTagView.ash_height = self.historyTagView.tagHeight;
        [self.historyCell addSubview:self.historyTagView];
        
        @weakify(self);
        [self.historyTagView setTagIndexAction:^(NSInteger index) {
            @strongify(self);
            ASHSearchListViewController* vc = [ASHSearchListViewController new];
            vc.searchKey = ([[[ASHSearchManager shareInstance].historyTags reverseObjectEnumerator] allObjects])[index];
            [self presentViewController:vc animated:NO completion:nil];
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
        ASHSearchListViewController* vc = [ASHSearchListViewController new];
        vc.searchKey = model.title;

        [self presentViewController:vc animated:NO completion:nil];
    }];
    

}
- (void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.ash_top = 60;
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
    if (self.shouldShow) {
        return 1;
    }
    if ([ASHSearchManager shareInstance].historyTags.count) {
        return 2;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.shouldShow) {
        return _searchViewModel.model.search_word_list.count;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.shouldShow) {
        return 40.0;
    }
    if (indexPath.section == 0 && [ASHSearchManager shareInstance].historyTags.count) {
        return self.historyTagView.tagHeight;
    }
    return self.hotTagView.tagHeight;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell;
    
    if (self.shouldShow) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"searchcellresult"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchcellresult"];
        }
        NSString* text = _searchViewModel.model.search_word_list[indexPath.row];
        cell.textLabel.text = text;
        return cell;
    }
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!self.shouldShow) {
        return;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (self.shouldShow) {
        return 0;
    }
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
#pragma mark UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length) {
        self.shouldShow = YES;
        [_searchViewModel requestSeachWord:searchText];
    }else{
        self.shouldShow = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView reloadData];
    }
}
@end
