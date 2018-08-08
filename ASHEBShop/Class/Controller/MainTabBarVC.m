//
//  MainTabBarVC.m
//  ASHEBShop
//
//  Created by xmfish on 2018/5/2.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "MainTabBarVC.h"
#import "ViewController.h"
#import "ASHCategoryVC.h"
#import "ASHEBHomeViewController.h"
#import "MainViewController.h"
#import "ASHZheKou99ViewController.h"
#import "MainViewController.h"
@implementation MainTabBarVC
-(void)viewDidLoad
{
    [super viewDidLoad];
    UINavigationController* mainNav = [[UINavigationController alloc] initWithRootViewController:[ASHEBHomeViewController new]];
    UITabBarItem* mainItem = [[UITabBarItem alloc] initWithTitle:@"推荐" image:[UIImage imageNamed:@"home_normal"] selectedImage:[[UIImage imageNamed:@"home_selected"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] ];
    [mainItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor mainColor],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    mainNav.tabBarItem = mainItem;
    
    UINavigationController* categoryNav = [[UINavigationController alloc] initWithRootViewController:[ASHZheKou99ViewController new]];
    UITabBarItem* categoryItem = [[UITabBarItem alloc] initWithTitle:@"9块9" image:[UIImage imageNamed:@"tab_99_icon"] selectedImage:[[UIImage imageNamed:@"tab_99_icon_select"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [categoryItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor mainColor],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    categoryNav.tabBarItem = categoryItem;
    
    UINavigationController* thirdNav = [[UINavigationController alloc] initWithRootViewController:[MainViewController new]];
    UITabBarItem* thirdItem = [[UITabBarItem alloc] initWithTitle:@"精选" image:[UIImage imageNamed:@"mall_normal"] selectedImage:[[UIImage imageNamed:@"mall_selected"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [thirdItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor mainColor],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    thirdNav.tabBarItem = thirdItem;
    
    [self setViewControllers:@[mainNav,categoryNav,thirdNav]];

    self.selectedIndex = 0;
}
- (void)setSelectedViewController:(__kindof UIViewController *)selectedViewController
{
    [super setSelectedViewController:selectedViewController];
}
- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [super setSelectedIndex:selectedIndex];
}
@end
