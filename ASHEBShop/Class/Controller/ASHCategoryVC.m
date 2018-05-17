//
//  ASHCategoryVC.m
//  ASHEBShop
//
//  Created by xmfish on 2018/5/2.
//  Copyright © 2018年 ash. All rights reserved.
//

#import "ASHCategoryVC.h"
#import "ASHPageViewController.h"
#import "ViewController.h"
#import "IMYNewsSegmentedView.h"
#import <Masonry.h>
@interface ASHCategoryVC ()<ASHPageViewControllerDelegate,ASHPageViewControllerDataSource,UIScrollViewDelegate,IMYNewsSegmentedViewDataSource,IMYNewsSegmentedViewDelegate>
@property(nonatomic, strong)ASHPageViewController* pageViewController;
@property (nonatomic, strong) IMYNewsSegmentedView *segmentView;
@property(nonatomic, copy)NSMutableArray* vcArr;
@end

@implementation ASHCategoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"分类";
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    _vcArr = [[NSMutableArray alloc] init];
    
    [_vcArr addObject:[ViewController new]];
    [_vcArr addObject:[ViewController new]];
    [_vcArr addObject:[ViewController new]];
    
}
- (IMYNewsSegmentedView *)segmentView {
    if (_segmentView == nil) {
        _segmentView = [[IMYNewsSegmentedView alloc] init];
        _segmentView.dataSource = self;
        _segmentView.delegate = self;
        _segmentView.titleFont = [UIFont systemFontOfSize:17];
        _segmentView.titleSelectFont = [UIFont systemFontOfSize:17];
        UIView *lineView = [[UIView alloc] init];
        [lineView setBackgroundColor:[UIColor lightGrayColor]];
        [_segmentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(_segmentView);
            make.height.mas_equalTo(0.7);
        }];
    }
    return _segmentView;
}
- (ASHPageViewController *)pageViewController {
    if (_pageViewController == nil) {
        _pageViewController = [[ASHPageViewController alloc] init];
        [_pageViewController.view setBackgroundColor:[UIColor whiteColor]];
        _pageViewController.dataSource = self;
        _pageViewController.delegate = self;
        _pageViewController.scrollViewForwardDelegate = self;
    }
    return _pageViewController;
}
#pragma mark ASHPageViewControllerDataSource
- (NSUInteger)numberOfControllersInPageViewController:(ASHPageViewController *)pageViewController{
    return _vcArr.count;
}
- (UIViewController* )pageViewController:(ASHPageViewController *)pageViewController controllerAtIndex:(NSUInteger)index{
    return _vcArr[index];
}
#pragma mark ASHPageViewControllerDelegate
- (void)pageViewController:(ASHPageViewController *)pageViewController didTransitionFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    
}
- (void)pageViewController:(ASHPageViewController *)pageViewController willTransitionFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    
}
#pragma mark IMYNewsSegmentedViewDataSource
- (NSUInteger)numberOfSegmentedViews:(id)sender{
    return _vcArr.count;
}
- (NSString*)titleForSegmentedView:(id)sender index:(NSUInteger)index{
    return @"精选";
}
- (CGFloat)segmentedViewWidth:(id)sender index:(NSUInteger)index
{
    return 62.0;
}
#pragma mark IMYNewsSegmentedViewDelegate
- (void)IMYNewsSegmentedViewDidSelect:(id)sender index:(NSUInteger)index
{
    [self.pageViewController setViewControllerAtIndex:index animated:YES];
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
