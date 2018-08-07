//
//  ASHSearchListViewController.m
//  ASHEBShop
//
//  Created by xmfish on 2018/8/7.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHSearchListViewController.h"
#import "ASHSearchBar.h"
@interface ASHSearchListViewController ()<UISearchBarDelegate>
@property (nonatomic, strong)ASHSearchBar *searchbar;
@end

@implementation ASHSearchListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initSearchBar];
}
- (void)initSearchBar
{
    _searchbar = [[ASHSearchBar alloc] init];
    
    [self.view addSubview:_searchbar];
    
    _searchbar.frame = CGRectMake(44.0, 20.0, (CGRectGetWidth(self.view.bounds) - 54), 30);
    _searchbar.barStyle = UIBarStyleDefault;
    _searchbar.placeholder = @"输入商品名或粘贴淘宝标题";
    _searchbar.translucent = YES;
    _searchbar.tintColor = [UIColor blueColor];
    
    _searchbar.barTintColor = [UIColor whiteColor];
    _searchbar.backgroundColor = [UIColor whiteColor];
    
    _searchbar.showsCancelButton = NO;
    _searchbar.searchBarStyle = UISearchBarStyleMinimal;
    _searchbar.delegate = self;
    UITextField *searchField=[_searchbar valueForKey:@"searchField"];
    searchField.backgroundColor = [UIColor lineColor];
    [searchField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [searchField setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    [searchField becomeFirstResponder];
    
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 15, 44, 44);
    [backButton setImage:[UIImage imageNamed:@"nav_back_arrow_icon"] forState:UIControlStateNormal];
    @weakify(self);
    [[[backButton rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self);
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
    [self.view addSubview:backButton];
    
    UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 55, ASHScreenWidth, 1)];
    lineView.backgroundColor = [UIColor lineColor];
    [self.view addSubview:lineView];
    
    _searchbar.text = self.searchKey;
}
@end
