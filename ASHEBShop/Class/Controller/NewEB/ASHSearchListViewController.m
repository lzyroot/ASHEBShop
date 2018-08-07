//
//  ASHSearchListViewController.m
//  ASHEBShop
//
//  Created by xmfish on 2018/8/7.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHSearchListViewController.h"

@interface ASHSearchListViewController ()

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
    UISearchBar *searchbar = [[UISearchBar alloc] init];
    
    [self.view addSubview:searchbar];
    
    searchbar.frame = CGRectMake(44.0, 20.0, (CGRectGetWidth(self.view.bounds) - 54), 44.0);
    searchbar.barStyle = UIBarStyleDefault;
    searchbar.placeholder = @"输入商品名或粘贴淘宝标题";
    searchbar.translucent = YES;
    searchbar.tintColor = [UIColor blueColor];
    
    searchbar.barTintColor = [UIColor whiteColor];
    searchbar.backgroundColor = [UIColor lineColor];
    
    searchbar.showsCancelButton = NO;
    searchbar.searchBarStyle = UISearchBarStyleProminent;
    searchbar.delegate = self;
    UITextField *searchField=[searchbar valueForKey:@"searchField"];
    searchField.backgroundColor = [UIColor lineColor];
    searchField.layer.cornerRadius = 1.0;
    [searchField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [searchField setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    [searchField becomeFirstResponder];
    
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 20, 44, 44);
    [backButton setImage:[UIImage imageNamed:@"nav_back_arrow_icon"] forState:UIControlStateNormal];
    @weakify(self);
    [[[backButton rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self);
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
    [self.view addSubview:backButton];
}
@end
