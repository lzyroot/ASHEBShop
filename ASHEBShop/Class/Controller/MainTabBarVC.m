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
#import "MainViewController.h"
@implementation MainTabBarVC
-(void)viewDidLoad
{
    [super viewDidLoad];
    UINavigationController* mainNav = [[UINavigationController alloc] initWithRootViewController:[MainViewController new]];
    UITabBarItem* mainItem = [[UITabBarItem alloc] initWithTitle:@"精选" image:[UIImage imageNamed:@"home_normal"] selectedImage:[[UIImage imageNamed:@"home_selected"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] ];
    [mainItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor mainColor],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    mainNav.tabBarItem = mainItem;
    
    UINavigationController* categoryNav = [[UINavigationController alloc] initWithRootViewController:[ASHCategoryVC new]];
    UITabBarItem* categoryItem = [[UITabBarItem alloc] initWithTitle:@"分类" image:[UIImage imageNamed:@"mall_normal"] selectedImage:[[UIImage imageNamed:@"mall_selected"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [categoryItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor mainColor],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    categoryNav.tabBarItem = categoryItem;
    
    [self setViewControllers:@[mainNav,categoryNav]];
    
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
